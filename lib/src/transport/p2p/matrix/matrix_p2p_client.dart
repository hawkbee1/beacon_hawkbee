import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:beacon_hawkbee/beacon_hawkbee.dart';
import 'package:matrix/matrix.dart';

/// Implementation of [P2PClient] using the Matrix protocol.
class MatrixP2PClient implements P2PClient {
  /// Default Matrix server used for Beacon communication.
  static const String defaultMatrixServer = 'https://matrix.tez.ie';

  /// The app metadata.
  final AppMetadata appMetadata;

  /// The storage manager.
  final StorageManager storageManager;

  /// The Matrix homeserver URL.
  final String homeserver;

  /// The Matrix client instance.
  late Client _matrixClient;

  /// Stream controller for received messages.
  final StreamController<ConnectionMessage> _messageController =
      StreamController<ConnectionMessage>.broadcast();

  /// Whether the client is initialized.
  bool _isInitialized = false;

  /// Whether the client is connected.
  bool _isConnected = false;

  /// User ID in the Matrix server.
  String? _userId;

  /// Creates a new [MatrixP2PClient] instance.
  MatrixP2PClient({
    required this.appMetadata,
    required this.storageManager,
    required this.homeserver,
  }) {
    _matrixClient = Client(
      'BeaconSDK',
      databaseBuilder: (_) async =>
          Database.inMemoryDatabaseBuilder('BeaconSDK'),
    );
  }

  @override
  bool get isConnected => _isConnected;

  @override
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Try to load existing credentials
      final storedUserId = await storageManager.getValue('matrix_user_id');
      final storedAccessToken =
          await storageManager.getValue('matrix_access_token');
      final storedDeviceId = await storageManager.getValue('matrix_device_id');

      if (storedUserId != null &&
          storedAccessToken != null &&
          storedDeviceId != null) {
        // Use existing credentials
        await _matrixClient.init(
          newToken: storedAccessToken,
          newUserID: storedUserId,
          newHomeserver: Uri.parse(homeserver),
          newDeviceID: storedDeviceId,
        );
        _userId = storedUserId;
      } else {
        // Create new account
        final username = 'beacon_${_randomString(8)}';
        final password = _randomString(24);

        await _matrixClient.checkHomeserver(Uri.parse(homeserver));

        try {
          // Try to register a new user
          await _matrixClient.register(
            username: username,
            password: password,
            initialDeviceDisplayName: 'Beacon SDK',
          );
        } catch (e) {
          // If registration fails, try login
          await _matrixClient.login(
            LoginType.mLoginPassword,
            identifier: AuthenticationUserIdentifier(user: username),
            password: password,
            initialDeviceDisplayName: 'Beacon SDK',
          );
        }

        // Store credentials
        await storageManager.setValue('matrix_user_id', _matrixClient.userID!);
        await storageManager.setValue(
            'matrix_access_token', _matrixClient.accessToken!);
        await storageManager.setValue(
            'matrix_device_id', _matrixClient.deviceID!);

        _userId = _matrixClient.userID;
      }

      // Set up message handler
      _matrixClient.onEvent.stream.listen(_handleEvent);

      _isInitialized = true;
    } catch (e) {
      throw P2PClientError('Failed to initialize Matrix client: $e');
    }
  }

  @override
  Future<void> connect() async {
    if (_isConnected) return;

    if (!_isInitialized) {
      await init();
    }

    try {
      // Start syncing
      await _matrixClient.startSync();

      // Join rooms for all known peers
      final peers = await storageManager.getPeers();
      for (final peer in peers) {
        await _joinOrCreateRoomForPeer(peer.publicKey);
      }

      _isConnected = true;
    } catch (e) {
      throw P2PClientError('Failed to connect Matrix client: $e');
    }
  }

  @override
  Future<void> disconnect() async {
    if (!_isConnected) return;

    try {
      await _matrixClient.logout();
      _isConnected = false;
    } catch (e) {
      throw P2PClientError('Failed to disconnect Matrix client: $e');
    }
  }

  @override
  Future<void> sendMessage(ConnectionMessage message) async {
    if (!_isConnected) {
      throw P2PClientError('Cannot send message: client is not connected');
    }

    try {
      // Find or create room for the recipient
      final roomId = await _joinOrCreateRoomForPeer(message.recipientId);

      // Send the message
      await _matrixClient.sendTextEvent(
        roomId,
        message.content,
        txid: message.id,
      );
    } catch (e) {
      throw P2PClientError('Failed to send message: $e');
    }
  }

  @override
  Stream<ConnectionMessage> get messageStream => _messageController.stream;

  /// Returns a deterministic room ID for a peer.
  Future<String> _joinOrCreateRoomForPeer(String peerId) async {
    // Create deterministic room name
    final roomName = [_userId, peerId]..sort();
    final roomAlias = 'beacon_${roomName.join('_')}';

    try {
      // Try to find existing room
      final rooms = await _matrixClient.getPublicRooms();
      final existingRoom = rooms.chunk.firstWhere(
        (room) => room.name == roomAlias,
        orElse: () => PublicRoomsChunk(roomId: ''),
      );

      if (existingRoom.roomId.isNotEmpty) {
        // Join existing room
        final joinedRoom = await _matrixClient.joinRoom(existingRoom.roomId);
        return joinedRoom.id;
      }

      // Create new room
      final createdRoom = await _matrixClient.createRoom(
        name: roomAlias,
        preset: CreateRoomPreset.publicChat,
        visibility: Visibility.public,
        topic: 'Beacon SDK communication channel',
      );

      return createdRoom.id;
    } catch (e) {
      // Fallback to direct creation
      try {
        final createdRoom = await _matrixClient.createRoom(
          name: roomAlias,
          preset: CreateRoomPreset.publicChat,
          visibility: Visibility.public,
          topic: 'Beacon SDK communication channel',
        );

        return createdRoom.id;
      } catch (e) {
        throw P2PClientError('Failed to create or join room: $e');
      }
    }
  }

  /// Handles incoming Matrix events.
  void _handleEvent(EventUpdate event) {
    if (event.type == EventUpdateType.timeline &&
        event.content['type'] == 'm.room.message' &&
        event.content['content']['msgtype'] == 'm.text') {
      final senderId = event.content['sender'];
      final content = event.content['content']['body'];

      // Filter out own messages
      if (senderId != _userId) {
        try {
          // Parse the message content
          final message = ConnectionMessage(
            id: event.content['event_id'] ?? _randomString(10),
            senderId: senderId,
            recipientId: _userId ?? '',
            content: content,
            version: '3', // Default to protocol version 3
          );

          _messageController.add(message);
        } catch (e) {
          // Ignore invalid messages
        }
      }
    }
  }

  /// Generates a random string of the specified length.
  String _randomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return String.fromCharCodes(
      List.generate(
          length, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }
}

/// Error thrown when P2P client operations fail.
class P2PClientError implements Exception {
  /// The error message.
  final String message;

  /// Creates a new [P2PClientError] instance.
  P2PClientError(this.message);

  @override
  String toString() => 'P2PClientError: $message';
}
