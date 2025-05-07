part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Represents a connection type in the Beacon network.
///
/// Connections define how peers communicate with each other.
class Connection {
  /// The type of connection.
  final ConnectionType type;

  /// The unique identifier for this connection.
  final String id;

  /// Creates a new [Connection] instance.
  const Connection({required this.type, required this.id});

  /// Creates a connection ID specific to a peer.
  static Connection forPeer(Peer peer) {
    return Connection(type: ConnectionType.p2p, id: peer.publicKey);
  }

  /// Creates a new Connection instance from a JSON map.
  factory Connection.fromJson(Map<String, dynamic> json) {
    return Connection(
      type: ConnectionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ConnectionType.p2p,
      ),
      id: json['id'] as String,
    );
  }

  /// Converts this Connection to a JSON map.
  Map<String, dynamic> toJson() {
    return {'type': type.name, 'id': id};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Connection && other.type == type && other.id == id;
  }

  @override
  int get hashCode => type.hashCode ^ id.hashCode;
}

/// The type of connection between peers.
enum ConnectionType {
  /// Peer-to-peer connection.
  p2p,
}
