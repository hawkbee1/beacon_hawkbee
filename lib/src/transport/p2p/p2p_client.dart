part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Interface for P2P client implementations.
///
/// This interface provides methods for connecting to and communicating with other
/// peers over a peer-to-peer network.
abstract class P2PClient {
  /// Whether the client is connected to the P2P network.
  bool get isConnected;

  /// Stream of incoming messages.
  Stream<ConnectionMessage> get messageStream;

  /// Initializes the P2P client.
  ///
  /// This method should set up the client's initial state, such as loading
  /// stored credentials or creating new ones.
  Future<void> init();

  /// Connects to the P2P network.
  Future<void> connect();

  /// Disconnects from the P2P network.
  Future<void> disconnect();

  /// Sends a message to another peer.
  Future<void> sendMessage(ConnectionMessage message);
}
