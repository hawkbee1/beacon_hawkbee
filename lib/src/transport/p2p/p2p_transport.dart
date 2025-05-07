part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Implementation of the [Transport] interface using P2P communication.
class P2PTransport implements Transport {
  final P2PClient _client;

  /// Creates a new [P2PTransport] instance.
  P2PTransport(this._client);

  @override
  TransportType get type => TransportType.p2p;

  @override
  Stream<ConnectionMessage> start() {
    _client.start();
    return _client.messages();
  }

  @override
  Future<void> send(ConnectionMessage message) async {
    await _client.sendMessage(message);
  }

  @override
  Future<void> stop() async {
    await _client.stop();
  }

  @override
  bool canConnect(Peer peer) {
    // Can connect if peer has a public key
    return peer.publicKey.isNotEmpty;
  }

  /// Creates a pairing request to share with another peer.
  Future<String> createPairingRequest() async {
    return await _client.createPairingRequest();
  }

  /// Gets the public key of this transport.
  String get publicKey => _client.publicKey;
}
