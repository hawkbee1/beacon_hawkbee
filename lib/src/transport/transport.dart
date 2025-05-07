part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Abstract interface for all transport implementations.
///
/// The transport layer is responsible for sending and receiving messages
/// between peers in the Beacon network.
abstract class Transport {
  /// The type of this transport.
  TransportType get type;

  /// Starts the transport and returns a stream of incoming messages.
  Stream<ConnectionMessage> start();

  /// Sends a message to a peer.
  ///
  /// Returns a [Future] that completes when the message is sent.
  Future<void> send(ConnectionMessage message);

  /// Stops the transport.
  Future<void> stop();

  /// Returns true if the transport supports the given [peer].
  bool canConnect(Peer peer);
}

/// The type of transport.
enum TransportType {
  /// Peer-to-peer transport.
  p2p,

  /// Deep link transport (used for mobile apps).
  deeplink,
}
