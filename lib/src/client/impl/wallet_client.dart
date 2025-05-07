import 'dart:async';
import 'dart:convert';

import 'package:beacon_hawkbee/beacon_hawkbee.dart';
import 'package:uuid/uuid.dart';

/// Implementation of a Beacon client for wallets.
///
/// This client enables wallets to listen for requests from dApps
/// and respond to them.
class WalletClient extends BeaconProducer {
  /// The Crypto service.
  final CryptoService _cryptoService;

  /// The storage manager.
  final StorageManager _storageManager;

  /// The transport layer.
  final Transport _transport;

  /// Message stream subscription.
  StreamSubscription<ConnectionMessage>? _messageSubscription;

  /// Stream controller for beacon messages.
  final StreamController<BeaconMessage> _messageController =
      StreamController<BeaconMessage>.broadcast();

  /// Creates a new [WalletClient] instance.
  WalletClient({
    required AppMetadata appMetadata,
    required String beaconId,
    required CryptoService cryptoService,
    required StorageManager storageManager,
    required Transport transport,
  })  : _cryptoService = cryptoService,
        _storageManager = storageManager,
        _transport = transport,
        super(appMetadata: appMetadata, beaconId: beaconId);

  @override
  Stream<BeaconMessage> connect() {
    _messageSubscription = _transport.start().listen((message) {
      _handleMessage(message).then((beaconMessage) {
        if (beaconMessage != null) {
          _messageController.add(beaconMessage);
        }
      });
    });

    return _messageController.stream;
  }

  @override
  Future<void> addPeers(List<Peer> peers) async {
    await _storageManager.addPeers(peers);
  }

  @override
  Future<List<Peer>> getPeers() async {
    return await _storageManager.getPeers();
  }

  @override
  Future<void> removePeers(List<Peer> peers) async {
    await _storageManager.removePeers(peers);
  }

  @override
  Future<void> removeAllPeers() async {
    await _storageManager.removeAllPeers();
  }

  @override
  Future<List<Permission>> getPermissions() async {
    return await _storageManager.getPermissions();
  }

  @override
  Future<Permission?> getPermissionsFor(String accountIdentifier) async {
    return await _storageManager
        .findPermission((p) => p.accountId == accountIdentifier);
  }

  @override
  Future<void> removePermissionsFor(List<String> accountIdentifiers) async {
    await _storageManager.removePermissionsWhere(
      (permission) => accountIdentifiers.contains(permission.accountId),
    );
  }

  @override
  Future<void> removePermissions(List<Permission> permissions) async {
    await _storageManager.removePermissions(permissions);
  }

  @override
  Future<void> removeAllPermissions() async {
    await _storageManager.removeAllPermissions();
  }

  @override
  String serializePairingData(dynamic pairingMessage) {
    if (pairingMessage is PairingMessage) {
      return jsonEncode(pairingMessage.toJson());
    }
    throw ArgumentError(
        'Invalid pairing message type: ${pairingMessage.runtimeType}');
  }

  @override
  T deserializePairingData<T>(String serialized) {
    if (T == PairingMessage) {
      final map = jsonDecode(serialized) as Map<String, dynamic>;
      return PairingMessage.fromJson(map) as T;
    }
    throw ArgumentError('Unsupported type: $T');
  }

  @override
  Future<void> send(BeaconMessage message, {bool isTerminal = false}) async {
    // Convert BeaconMessage to ConnectionMessage
    final connectionMessage = ConnectionMessage(
      senderId: senderId,
      recipientId: message.destination.id,
      content: jsonEncode(message.toJson()),
      version: message.version,
    );

    await _transport.send(connectionMessage);
  }

  @override
  Future<void> respondToPermissionRequest({
    required String requestId,
    required String publicKey,
    required String address,
    required String network,
    List<String> scopes = const [],
  }) async {
    // Find the original request
    final request = await _findStoredRequest(requestId);
    if (request == null) {
      throw BeaconError(
        code: BeaconError.unknownError,
        description: 'Original request $requestId not found',
      );
    }

    // Create response message
    final id = await _cryptoService.guid();
    final responseMessage = PermissionResponseMessage(
      id: id,
      senderId: senderId,
      version: request.version,
      origin: Connection(type: ConnectionType.p2p, id: senderId),
      destination: request.origin,
      requestId: requestId,
      publicKey: publicKey,
      network: Network(type: network, name: network),
      address: address,
      scopes: scopes,
      appMetadata: appMetadata,
    );

    // Store permission
    final permission = Permission(
      blockchainIdentifier: network,
      accountId: address,
      senderId: request.senderId,
      connectedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _storageManager.addPermissions([permission]);

    // Send response
    await send(responseMessage);
  }

  @override
  Future<void> rejectPermissionRequest({
    required String requestId,
    String? errorMessage,
  }) async {
    // Find the original request
    final request = await _findStoredRequest(requestId);
    if (request == null) {
      throw BeaconError(
        code: BeaconError.unknownError,
        description: 'Original request $requestId not found',
      );
    }

    // Create error response
    final error = BeaconError(
      code: BeaconError.notGrantedError,
      description: errorMessage ?? 'Permission denied by user',
    );

    // TODO: Implement error response message
    // This requires adding an error response message type to the protocol
  }

  /// Handles a received message from the transport layer.
  Future<BeaconMessage?> _handleMessage(ConnectionMessage message) async {
    try {
      final data = jsonDecode(message.content) as Map<String, dynamic>;
      final beaconMessage = BeaconMessage.fromJson(data);

      // Store the request for later reference
      if (beaconMessage is PermissionRequestMessage) {
        await _storeRequest(beaconMessage);
      }

      return beaconMessage;
    } catch (e) {
      return null;
    }
  }

  /// Stores a request message for later reference.
  Future<void> _storeRequest(BeaconMessage request) async {
    await _storageManager.setValue(
        'beacon_request_${request.id}', jsonEncode(request.toJson()));
  }

  /// Finds a stored request message by ID.
  Future<BeaconMessage?> _findStoredRequest(String requestId) async {
    final requestJson =
        await _storageManager.getValue('beacon_request_$requestId');
    if (requestJson == null) return null;

    try {
      final map = jsonDecode(requestJson) as Map<String, dynamic>;
      return BeaconMessage.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  /// Handles a pairing request from a dApp.
  Future<void> handlePairingRequest(String pairingRequestData) async {
    try {
      // Parse the pairing request
      final data = jsonDecode(pairingRequestData) as Map<String, dynamic>;
      final request = PairingMessage.fromJson(data);

      if (request.type == PairingMessageType.pairingRequest) {
        // Create a peer from the request
        final peer = request.toPeer();

        // Add the peer to storage
        await _storageManager.addPeers([peer]);

        // Create a pairing response
        final response = PairingMessage(
          id: const Uuid().v4(),
          type: PairingMessageType.pairingResponse,
          name: appMetadata.name,
          version: '3',
          publicKey: senderId,
          icon: appMetadata.icon,
        );

        // The response would typically be displayed as a QR code or deep link
        // for the dApp to scan/process
        return;
      }
    } catch (e) {
      throw BeaconError(
        code: BeaconError.pairingError,
        description: 'Failed to handle pairing request: $e',
      );
    }
  }
}
