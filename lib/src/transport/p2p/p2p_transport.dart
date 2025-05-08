part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Implementation of [Transport] using P2P communication.
class P2PTransport implements Transport {
  /// The P2P client used for communication.
  final P2PClient _p2pClient;

  /// The crypto service used for encryption/decryption.
  final CryptoService _cryptoService;

  /// The storage manager.
  final StorageManager _storageManager;

  /// The sender ID.
  final String _senderId;

  /// Stream controller for BeaconMessage.
  final StreamController<BeaconMessage> _beaconMessageController =
      StreamController<BeaconMessage>.broadcast();

  /// Flag indicating if transport is connected.
  bool _isConnected = false;

  /// Key pair used for encryption/decryption.
  late KeyPair _keyPair;

  /// Subscription to the P2P client's message stream.
  StreamSubscription<ConnectionMessage>? _subscription;

  /// Creates a new [P2PTransport] instance.
  P2PTransport({
    required P2PClient p2pClient,
    required CryptoService cryptoService,
    required StorageManager storageManager,
    required String senderId,
  })  : _p2pClient = p2pClient,
        _cryptoService = cryptoService,
        _storageManager = storageManager,
        _senderId = senderId;

  @override
  bool get isConnected => _isConnected;

  @override
  String get type => TransportType.p2p;

  @override
  Stream<BeaconMessage> get messageStream => _beaconMessageController.stream;

  @override
  Future<void> connect() async {
    if (_isConnected) return;

    try {
      // Initialize the P2P client
      await _p2pClient.init();

      // Load or generate our key pair
      _keyPair = await _cryptoService.loadOrGenerateKeyPair(
        // TODO: Replace with proper secure storage
        DummySecureStorage(),
      );

      // Connect to the P2P network
      await _p2pClient.connect();

      // Listen for incoming messages
      _subscription = _p2pClient.messageStream.listen(_handleIncomingMessage);

      _isConnected = true;
    } catch (e) {
      throw TransportError('Failed to connect: $e');
    }
  }

  @override
  Future<void> disconnect() async {
    if (!_isConnected) return;

    try {
      // Unsubscribe from the message stream
      await _subscription?.cancel();
      _subscription = null;

      // Disconnect from the P2P network
      await _p2pClient.disconnect();

      _isConnected = false;
    } catch (e) {
      throw TransportError('Failed to disconnect: $e');
    }
  }

  @override
  Future<void> sendMessage(BeaconMessage message) async {
    if (!_isConnected) {
      throw TransportError('Cannot send message: not connected');
    }

    try {
      // Find the peer by ID
      final peerPublicKey = message.destination.id;
      final peer =
          await _storageManager.findPeer((p) => p.publicKey == peerPublicKey);

      if (peer == null) {
        throw TransportError('Cannot send message: peer not found');
      }

      // Convert the message to JSON
      final messageJson = jsonEncode(message.toJson());

      // Convert the JSON to bytes
      final messageBytes = Uint8List.fromList(utf8.encode(messageJson));

      // Get the peer's public key
      final publicKeyBytes = _hexToBytes(peer.publicKey);

      // Encrypt the message
      final encryptedBytes =
          await _cryptoService.encrypt(messageBytes, publicKeyBytes);

      // Convert the encrypted bytes to a Base64 string
      final encryptedString = base64Encode(encryptedBytes);

      // Create a connection message
      final connectionMessage = ConnectionMessage(
        id: message.id,
        senderId: _senderId,
        recipientId: peer.publicKey,
        content: encryptedString,
        version: '3',
      );

      // Send the connection message
      await _p2pClient.sendMessage(connectionMessage);
    } catch (e) {
      throw TransportError('Failed to send message: $e');
    }
  }

  @override
  Future<void> send(ConnectionMessage message) async {
    if (!_isConnected) {
      throw TransportError('Cannot send message: not connected');
    }

    await _p2pClient.sendMessage(message);
  }

  /// Handles an incoming message from the P2P client.
  Future<void> _handleIncomingMessage(ConnectionMessage message) async {
    try {
      // Find the sender peer
      final sender = await _storageManager
          .findPeer((p) => p.publicKey == message.senderId);

      if (sender == null) {
        // Unknown sender, ignore message
        return;
      }

      // Decode the Base64 string to bytes
      final encryptedBytes = base64Decode(message.content);

      // Decrypt the message
      final decryptedBytes = await _cryptoService.decrypt(
        encryptedBytes,
        _keyPair.privateKey,
      );

      // Convert the bytes to a JSON string
      final jsonString = utf8.decode(decryptedBytes);

      // Parse the JSON into a map
      final Map<String, dynamic> messageJson = jsonDecode(jsonString);

      // Create a BeaconMessage from the JSON
      final beaconMessage = BeaconMessage.fromJson(messageJson);

      // Add the message to the stream
      _beaconMessageController.add(beaconMessage);
    } catch (e) {
      // Ignore invalid messages
    }
  }

  /// Converts a hex string to bytes.
  Uint8List _hexToBytes(String hex) {
    String normalizedHex = hex.startsWith('0x') ? hex.substring(2) : hex;
    if (normalizedHex.length % 2 != 0) {
      normalizedHex = '0' + normalizedHex;
    }

    final result = Uint8List(normalizedHex.length ~/ 2);
    for (var i = 0; i < result.length; i++) {
      final hexByte = normalizedHex.substring(i * 2, i * 2 + 2);
      result[i] = int.parse(hexByte, radix: 16);
    }
    return result;
  }

  /// Creates a QR code pairing request that can be scanned by a wallet.
  Future<String> createPairingRequest() async {
    // Generate QR code content for pairing
    final pairingRequest = PairingMessage(
      id: await _cryptoService.guid(),
      type: PairingMessageType.pairingRequest,
      name: 'Beacon SDK',
      version: '3',
      publicKey: _senderId,
      relayServer: 'matrix',
    );

    return jsonEncode(pairingRequest.toJson());
  }
}

/// Temporary dummy secure storage for testing.
class DummySecureStorage implements SecureStorage {
  final Map<String, String> _storage = {};

  @override
  Future<String?> getSecure(String key) async => _storage[key];

  @override
  Future<void> saveSecure(String key, String value) async =>
      _storage[key] = value;

  @override
  Future<void> removeSecure(String key) async => _storage.remove(key);
}
