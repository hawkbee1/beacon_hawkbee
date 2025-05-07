part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// A message to disconnect from a peer.
class DisconnectMessage extends BeaconMessage {
  /// Creates a new [DisconnectMessage] instance.
  const DisconnectMessage({
    required super.id,
    required super.senderId,
    required super.version,
    required super.origin,
    required super.destination,
  }) : super(type: BeaconMessageType.disconnect);

  /// Creates a new DisconnectMessage instance from a JSON map.
  factory DisconnectMessage.fromJson(Map<String, dynamic> json) {
    return DisconnectMessage(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      version: json['version'] as String,
      origin: Connection.fromJson(json['origin'] as Map<String, dynamic>),
      destination: Connection.fromJson(
        json['destination'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }
}
