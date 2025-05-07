part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Represents a peer in the Beacon network.
///
/// A peer can be a dApp or a wallet that participates in the Beacon protocol.
class Peer {
  /// The unique identifier of this peer.
  final String id;

  /// The name of this peer.
  final String name;

  /// The public key of this peer used for secure communication.
  final String publicKey;

  /// The protocol version used by this peer.
  final String version;

  /// Optional app URL for this peer.
  final String? appUrl;

  /// Optional icon URL for this peer.
  final String? icon;

  /// Creates a new [Peer] instance.
  const Peer({
    required this.id,
    required this.name,
    required this.publicKey,
    required this.version,
    this.appUrl,
    this.icon,
  });

  /// Creates a new Peer instance from a JSON map.
  factory Peer.fromJson(Map<String, dynamic> json) {
    return Peer(
      id: json['id'] as String,
      name: json['name'] as String,
      publicKey: json['publicKey'] as String,
      version: json['version'] as String,
      appUrl: json['appUrl'] as String?,
      icon: json['icon'] as String?,
    );
  }

  /// Converts this Peer to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'publicKey': publicKey,
      'version': version,
      if (appUrl != null) 'appUrl': appUrl,
      if (icon != null) 'icon': icon,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Peer &&
        other.id == id &&
        other.name == name &&
        other.publicKey == publicKey &&
        other.version == version &&
        other.appUrl == appUrl &&
        other.icon == icon;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        publicKey.hashCode ^
        version.hashCode ^
        (appUrl?.hashCode ?? 0) ^
        (icon?.hashCode ?? 0);
  }
}
