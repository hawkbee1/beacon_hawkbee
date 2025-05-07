part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Type of pairing message.
enum PairingMessageType {
  /// Request to pair with another peer.
  pairingRequest,

  /// Response to a pairing request.
  pairingResponse,
}

/// A message used during the initial pairing process between peers.
class PairingMessage {
  /// The unique identifier for this pairing.
  final String id;

  /// The type of pairing message.
  final PairingMessageType type;

  /// The name of the sender.
  final String name;

  /// The version of the protocol being used.
  final String version;

  /// The public key of the sender.
  final String publicKey;

  /// Optional URL to the sender's app.
  final String? appUrl;

  /// Optional URL to the sender's icon.
  final String? icon;

  /// Creates a new [PairingMessage] instance.
  const PairingMessage({
    required this.id,
    required this.type,
    required this.name,
    required this.version,
    required this.publicKey,
    this.appUrl,
    this.icon,
  });

  /// Creates a new PairingMessage instance from a JSON map.
  factory PairingMessage.fromJson(Map<String, dynamic> json) {
    return PairingMessage(
      id: json['id'] as String,
      type: PairingMessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PairingMessageType.pairingRequest,
      ),
      name: json['name'] as String,
      version: json['version'] as String,
      publicKey: json['publicKey'] as String,
      appUrl: json['appUrl'] as String?,
      icon: json['icon'] as String?,
    );
  }

  /// Converts this PairingMessage to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'name': name,
      'version': version,
      'publicKey': publicKey,
      if (appUrl != null) 'appUrl': appUrl,
      if (icon != null) 'icon': icon,
    };
  }

  /// Creates a peer from this pairing message.
  Peer toPeer() {
    return Peer(
      id: id,
      name: name,
      publicKey: publicKey,
      version: version,
      appUrl: appUrl,
      icon: icon,
    );
  }
}
