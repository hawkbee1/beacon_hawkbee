import 'dart:async';
import 'dart:convert';

import 'package:beacon_hawkbee/beacon_hawkbee.dart';
import 'package:uuid/uuid.dart';

/// Implementation of a Beacon client for dApps.
///
/// This client enables dApps to connect to wallets and request operations.
class DAppClient extends BeaconConsumer {
  /// The Crypto service.
  final CryptoService _cryptoService;

  /// The storage manager.
  final StorageManager _storageManager;

  /// The transport layer.
  final Transport _transport;

  /// Completer for handling responses from wallets.
  final Map<String, Completer<BeaconMessage>> _responseCompleters = {};

  /// Message stream subscription.
  StreamSubscription<BeaconMessage>? _messageSubscription;

  /// Connection state flag
  bool _isConnected = false;

  /// Creates a new [DAppClient] instance.
  DAppClient({
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
    final controller = StreamController<BeaconMessage>.broadcast();

    try {
      // Connect to transport
      _transport.connect().then((_) {
        _isConnected = true;

        // Subscribe to messages - they are already BeaconMessage objects
        _transport.messageStream.listen((beaconMessage) {
          // Check if there's a completer waiting for this response
          final completer = _responseCompleters[beaconMessage.id];
          if (completer != null && !completer.isCompleted) {
            completer.complete(beaconMessage);
            _responseCompleters.remove(beaconMessage.id);
          } else {
            // Forward the message to the stream
            controller.add(beaconMessage);
          }
        });
      }).catchError((e) {
        controller.addError(BeaconError(
          code: BeaconError.unknownError,
          description: 'Failed to connect: $e',
        ));
      });
    } catch (e) {
      controller.addError(BeaconError(
        code: BeaconError.unknownError,
        description: 'Failed to connect: $e',
      ));
    }

    return controller.stream;
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
    // Send the BeaconMessage directly
    await _transport.sendMessage(message);
  }

  @override
  Future<Permission> requestPermissions({
    String? selectedAccount,
    String? network,
    List<String>? scopes,
  }) async {
    // Get the first peer or throw if none available
    final peers = await getPeers();
    if (peers.isEmpty) {
      throw BeaconError(
        code: BeaconError.pairingError,
        description: 'No peer available. Pair with a wallet first.',
      );
    }

    // Use the first peer
    final peer = peers.first;

    // Create request message
    final id = await _cryptoService.guid();
    final requestMessage = PermissionRequestMessage(
      id: id,
      senderId: senderId,
      version: '3', // Using beacon protocol version 3
      origin: Connection(type: ConnectionType.p2p, id: senderId),
      destination: Connection(type: ConnectionType.p2p, id: peer.publicKey),
      appMetadata: appMetadata,
      network: Network(
        type: network ?? 'mainnet',
        name: network ?? 'Mainnet',
        rpcUrl: network == 'ghostnet'
            ? 'https://ghostnet.ecadinfra.com'
            : 'https://mainnet.api.tez.ie',
      ),
      scopes: scopes,
    );

    // Set up completer to await response
    final completer = Completer<BeaconMessage>();
    _responseCompleters[id] = completer;

    // Send request
    await send(requestMessage);

    // Wait for response
    final response = await completer.future;

    if (response is PermissionResponseMessage) {
      // Create account from response
      final account = Account(
        address: response.address,
        network: response.network,
        publicKey: response.publicKey,
      );

      // Create and store permission with required parameters
      final permission = Permission(
        account: account,
        appMetadata: appMetadata,
        scopes: response.scopes ?? [],
      );

      await _storageManager.addPermissions([permission]);

      return permission;
    } else {
      throw BeaconError(
        code: BeaconError.notGrantedError,
        description: 'Permission request was not granted',
      );
    }
  }

  /// Handles a received message from the transport layer.
  Future<BeaconMessage?> _handleConnectionMessage(
      ConnectionMessage message) async {
    try {
      final data = jsonDecode(message.content) as Map<String, dynamic>;
      return BeaconMessage.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  /// Creates a QR code pairing request that can be scanned by a wallet.
  Future<String> createPairingRequest() async {
    if (_transport is P2PTransport) {
      final p2pTransport = _transport as P2PTransport;
      return await p2pTransport.createPairingRequest();
    } else {
      throw UnsupportedError(
          'The current transport does not support pairing requests');
    }
  }
}
