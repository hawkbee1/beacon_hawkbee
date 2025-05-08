part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Defines constants for message types.
class BeaconMessageType {
  /// Request for permissions.
  static const String permissionRequest = 'permission_request';

  /// Response to a permission request.
  static const String permissionResponse = 'permission_response';

  /// Operation request (e.g., transaction).
  static const String operationRequest = 'operation_request';

  /// Response to an operation request.
  static const String operationResponse = 'operation_response';

  /// Sign payload request.
  static const String signPayloadRequest = 'sign_payload_request';

  /// Response to a sign payload request.
  static const String signPayloadResponse = 'sign_payload_response';

  /// Disconnect message.
  static const String disconnect = 'disconnect';
}

/// Represents a peer in the Beacon protocol.
class BeaconPeer {
  /// The peer's unique identifier.
  final String id;

  /// The peer's name.
  final String name;

  /// The peer's public key.
  final String publicKey;

  /// The peer's relay server.
  final String relayServer;

  /// The peer's version.
  final String version;

  /// Creates a new [BeaconPeer] instance.
  BeaconPeer({
    required this.id,
    required this.name,
    required this.publicKey,
    required this.relayServer,
    required this.version,
  });

  /// Creates a [BeaconPeer] instance from a JSON map.
  factory BeaconPeer.fromJson(Map<String, dynamic> json) {
    return BeaconPeer(
      id: json['id'] as String,
      name: json['name'] as String,
      publicKey: json['publicKey'] as String,
      relayServer: json['relayServer'] as String,
      version: json['version'] as String,
    );
  }

  /// Converts this peer to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'publicKey': publicKey,
      'relayServer': relayServer,
      'version': version,
    };
  }
}

/// Base class for all Beacon messages.
abstract class BeaconMessage {
  /// The unique identifier of this message.
  final String id;

  /// The type of message.
  final String type;

  /// The version of the Beacon protocol.
  final String version;

  /// The sender of this message.
  final BeaconPeer sender;

  /// The destination of this message.
  final BeaconPeer destination;

  /// Creates a new [BeaconMessage] instance.
  BeaconMessage({
    required this.id,
    required this.type,
    required this.version,
    required this.sender,
    required this.destination,
  });

  /// Creates a [BeaconMessage] instance from a JSON map.
  factory BeaconMessage.fromJson(Map<String, dynamic> json) {
    final String type = json['type'] as String;

    switch (type) {
      case BeaconMessageType.permissionRequest:
        return PermissionRequestMessage.fromJson(json);
      case BeaconMessageType.permissionResponse:
        return PermissionResponseMessage.fromJson(json);
      case BeaconMessageType.disconnect:
        return DisconnectMessage.fromJson(json);
      // TODO: Add other message types
      default:
        throw FormatException('Unknown message type: $type');
    }
  }

  /// Converts this message to a JSON map.
  Map<String, dynamic> toJson();
}
