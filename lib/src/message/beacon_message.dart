part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// The type of Beacon message.
enum BeaconMessageType {
  /// Request for permissions
  permissionRequest,

  /// Response to a permission request
  permissionResponse,

  /// Message to disconnect peers
  disconnect,
}

/// Base class for all Beacon protocol messages.
abstract class BeaconMessage {
  /// The unique identifier of the message.
  final String id;

  /// The sender identifier.
  final String senderId;

  /// The protocol version.
  final String version;

  /// The origin connection of this message.
  final Connection origin;

  /// The destination connection for this message.
  final Connection destination;

  /// The type of message.
  final BeaconMessageType type;

  /// Creates a new [BeaconMessage] instance.
  const BeaconMessage({
    required this.id,
    required this.senderId,
    required this.version,
    required this.origin,
    required this.destination,
    required this.type,
  });

  /// Converts this message to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'version': version,
      'origin': origin.toJson(),
      'destination': destination.toJson(),
      'type': type.name,
    };
  }

  /// Factory to create the appropriate message subtype from JSON
  static BeaconMessage fromJson(Map<String, dynamic> json) {
    final type = BeaconMessageType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () =>
          throw ArgumentError('Unknown message type: ${json['type']}'),
    );

    switch (type) {
      case BeaconMessageType.permissionRequest:
        return PermissionRequestMessage.fromJson(json);
      case BeaconMessageType.permissionResponse:
        return PermissionResponseMessage.fromJson(json);
      case BeaconMessageType.disconnect:
        return DisconnectMessage.fromJson(json);
    }
  }
}
