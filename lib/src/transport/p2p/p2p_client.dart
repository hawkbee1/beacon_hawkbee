part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Interface for P2P client implementations.
///
/// This interface provides methods for connecting to and communicating with other
/// peers over a peer-to-peer network.
abstract class P2PClient {
  /// Returns a stream of messages from the P2P network.
  Stream<ConnectionMessage> messages();

  /// Starts the P2P client.
  Future<void> start();

  /// Stops the P2P client.
  Future<void> stop();

  /// Sends a message to a specific recipient.
  Future<void> sendMessage(ConnectionMessage message);

  /// Pairs with another peer on the network.
  Future<String> createPairingRequest();

  /// Gets the public key of this client.
  String get publicKey;
}
