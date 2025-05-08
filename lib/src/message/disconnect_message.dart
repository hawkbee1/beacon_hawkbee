part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Represents a disconnect message.
class DisconnectMessage extends BeaconMessage {
  /// Creates a new [DisconnectMessage] instance.
  DisconnectMessage({
    required String id,
    required String senderId,
    required String version,
    required Connection origin,
    required Connection destination,
  }) : super(
          id: id,
          type: BeaconMessageType.disconnect,
          version: version,
          senderId: senderId,
          origin: origin,
          destination: destination,
        );

  /// Creates a [DisconnectMessage] instance from a JSON map.
  factory DisconnectMessage.fromJson(Map<String, dynamic> json) {
    return DisconnectMessage(
      id: json['id'] as String,
      version: json['version'] as String,
      senderId: json['senderId'] as String,
      origin: Connection.fromJson(json['origin'] as Map<String, dynamic>),
      destination:
          Connection.fromJson(json['destination'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.value,
      'version': version,
      'senderId': senderId,
      'origin': origin.toJson(),
      'destination': destination.toJson(),
    };
  }
}
