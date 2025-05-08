part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Represents a disconnect message sent between peers.
class DisconnectMessage extends BeaconMessage {
  /// Creates a new [DisconnectMessage] instance.
  DisconnectMessage({
    required String id,
    required String version,
    required BeaconPeer sender,
    required BeaconPeer destination,
  }) : super(
          id: id,
          type: BeaconMessageType.disconnect,
          version: version,
          sender: sender,
          destination: destination,
        );

  /// Creates a [DisconnectMessage] instance from a JSON map.
  factory DisconnectMessage.fromJson(Map<String, dynamic> json) {
    return DisconnectMessage(
      id: json['id'] as String,
      version: json['version'] as String,
      sender: BeaconPeer.fromJson(json['sender'] as Map<String, dynamic>),
      destination:
          BeaconPeer.fromJson(json['destination'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'version': version,
      'sender': sender.toJson(),
      'destination': destination.toJson(),
    };
  }
}
