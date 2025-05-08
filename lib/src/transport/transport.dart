part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Defines constants for transport types.
class TransportType {
  /// Peer-to-peer transport type.
  static const String p2p = 'p2p';

  /// PostMessage transport type (for web).
  static const String postMessage = 'post-message';

  /// Deep link transport type (for mobile).
  static const String deepLink = 'deep-link';
}

/// Interface for transport implementations.
///
/// A transport is responsible for sending and receiving messages between peers.
abstract class Transport {
  /// The type of transport (p2p, post-message, etc.).
  String get type;

  /// Whether the transport is currently connected.
  bool get isConnected;

  /// Stream of incoming messages.
  Stream<BeaconMessage> get messageStream;

  /// Connects to the transport network.
  Future<void> connect();

  /// Disconnects from the transport network.
  Future<void> disconnect();

  /// Sends a message to a peer.
  Future<void> sendMessage(BeaconMessage message);
}

/// Error thrown when transport operations fail.
class TransportError implements Exception {
  /// The error message.
  final String message;

  /// Creates a new [TransportError] instance.
  TransportError(this.message);

  @override
  String toString() => 'TransportError: $message';
}
