import 'dart:async';
import 'dart:convert';

import 'package:beacon_hawkbee/beacon_hawkbee.dart';
import 'package:matrix/matrix.dart';
import 'package:uuid/uuid.dart';

/// Implementation of [P2PClient] using Matrix protocol for peer-to-peer communication.
class MatrixP2PClient implements P2PClient {
  /// Default Matrix server used for communication.
  static const String defaultMatrixServer = 'matrix.org';

  /// The Matrix client instance.
  final Client _client;

  /// Controller for the message stream.
  final StreamController<ConnectionMessage> _messageController =
      StreamController.broadcast();

  /// The app metadata for this client.
  final AppMetadata _appMetadata;

  /// UUID generator.
  final Uuid _uuid;

  /// The storage for peer relationships.
  final StorageManager _storageManager;

  /// The user ID on Matrix.
  String? _userId;

  /// The room ID for peer-to-peer communication.
  final Map<String, String> _peerRooms = {};

  /// Whether the client has been started.
  bool _isStarted = false;

  /// The public key of this client.
  @override
  String get publicKey => _appMetadata.senderId;

  /// Creates a new [MatrixP2PClient] instance.
  MatrixP2PClient({
    required AppMetadata appMetadata,
    required StorageManager storageManager,
    Client? client,
    Uuid? uuid,
    String? homeserver,
  })  : _appMetadata = appMetadata,
        _storageManager = storageManager,
        _client = client ??
            Client(
              '$homeserver',
              databaseBuilder: (_) async => null,
            ),
        _uuid = uuid ?? Uuid();

  @override
  Stream<ConnectionMessage> messages() {
    return _messageController.stream;
  }

  @override
  Future<void> start() async {
    if (_isStarted) return;

    await _initializeMatrixClient();
    await _syncPeers();

    _client.onRoomEvent.listen(_handleRoomEvent);
    _isStarted = true;
  }

  @override
  Future<void> stop() async {
    await _client.dispose();
    _isStarted = false;
  }

  @override
  Future<void> sendMessage(ConnectionMessage message) async {
    final roomId = await _getRoomForPeer(message.recipientId);
    if (roomId == null) {
      throw Exception('No room found for peer ${message.recipientId}');
    }

    await _client.getRoomById(roomId)?.sendTextEvent(
          jsonEncode(message.toJson()),
          msgtype: MessageTypes.Text,
        );
  }

  @override
  Future<String> createPairingRequest() async {
    final pairingId = _uuid.v4();

    final pairingMessage = PairingMessage(
      id: pairingId,
      type: PairingMessageType.pairingRequest,
      name: _appMetadata.name,
      version: '3', // We're implementing protocol version 3
      publicKey: publicKey,
      appUrl: null,
      icon: _appMetadata.icon,
    );

    return jsonEncode(pairingMessage.toJson());
  }

  /// Handles a pairing response from another peer.
  Future<void> handlePairingResponse(String pairingResponse) async {
    try {
      final data = jsonDecode(pairingResponse) as Map<String, dynamic>;
      final pairingMessage = PairingMessage.fromJson(data);

      if (pairingMessage.type == PairingMessageType.pairingResponse) {
        // Create a peer from the pairing message
        final peer = pairingMessage.toPeer();

        // Add peer to storage
        await _storageManager.addPeers([peer]);

        // Create a room with the peer
        await _createRoomWithPeer(peer);
      }
    } catch (e) {
      throw Exception('Failed to handle pairing response: $e');
    }
  }

  // Private helper methods

  Future<void> _initializeMatrixClient() async {
    try {
      // Check if we already have login credentials
      final accessToken = await _storageManager.getValue('beacon_matrix_token');
      final userId = await _storageManager.getValue('beacon_matrix_user_id');

      if (accessToken != null && userId != null) {
        // Use saved credentials
        await _client.loginWithToken(accessToken);
        _userId = userId;
      } else {
        // Generate a random username and password
        final username =
            'beacon_${_uuid.v4().replaceAll('-', '').substring(0, 8)}';
        final password = _uuid.v4();

        // Create a new account
        await _client.register(username: username, password: password);
        _userId = _client.userID;

        // Store credentials
        await _storageManager.setValue(
            'beacon_matrix_token', _client.accessToken!);
        await _storageManager.setValue('beacon_matrix_user_id', _userId!);
      }

      // Start syncing
      await _client.startSync();
    } catch (e) {
      throw Exception('Failed to initialize Matrix client: $e');
    }
  }

  Future<void> _syncPeers() async {
    final peers = await _storageManager.getPeers();
    for (final peer in peers) {
      await _createRoomWithPeer(peer);
    }
  }

  Future<void> _createRoomWithPeer(Peer peer) async {
    try {
      final existingRoomId = await _getRoomForPeer(peer.publicKey);
      if (existingRoomId != null) {
        return; // Room already exists
      }

      // Create a direct message room with the peer
      final roomId = await _client.createRoom(
        isDirect: true,
        preset: CreateRoomPreset.trustedPrivateChat,
        name: 'Beacon: ${peer.name}',
      );

      // Store the room ID for this peer
      _peerRooms[peer.publicKey] = roomId.roomId;
      await _storageManager.setValue(
          'beacon_room_${peer.publicKey}', roomId.roomId);
    } catch (e) {
      throw Exception('Failed to create room with peer: $e');
    }
  }

  Future<String?> _getRoomForPeer(String peerPublicKey) async {
    // Try to get from memory cache first
    if (_peerRooms.containsKey(peerPublicKey)) {
      return _peerRooms[peerPublicKey];
    }

    // Try to get from storage
    final roomId = await _storageManager.getValue('beacon_room_$peerPublicKey');
    if (roomId != null) {
      _peerRooms[peerPublicKey] = roomId;
    }

    return roomId;
  }

  void _handleRoomEvent(Event event) {
    if (event.type == EventTypes.Message &&
        event.messageType == MessageTypes.Text) {
      try {
        final data = jsonDecode(event.text ?? '{}') as Map<String, dynamic>;
        final message = ConnectionMessage.fromJson(data);
        _messageController.add(message);
      } catch (e) {
        // Ignore messages that aren't valid Beacon messages
      }
    }
  }
}
