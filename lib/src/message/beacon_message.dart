part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Message types supported by Beacon protocol.
enum BeaconMessageType {
  /// Permission request for access to account
  permissionRequest,
  
  /// Response to permission request
  permissionResponse,
  
  /// Request to sign message/operation
  signRequest,
  
  /// Response to sign request
  signResponse,
  
  /// Request to broadcast operation
  broadcastRequest,
  
  /// Response to broadcast request
  broadcastResponse,
  
  /// Request for operation
  operationRequest,
  
  /// Response to operation request
  operationResponse,
  
  /// Disconnect message
  disconnect,
  
  /// Error message
  error,
}

/// Extension to convert BeaconMessageType to/from string
extension BeaconMessageTypeExtension on BeaconMessageType {
  /// Get string value of message type
  String get value {
    switch (this) {
      case BeaconMessageType.permissionRequest:
        return 'permission_request';
      case BeaconMessageType.permissionResponse:
        return 'permission_response';
      case BeaconMessageType.signRequest:
        return 'sign_request';
      case BeaconMessageType.signResponse:
        return 'sign_response';
      case BeaconMessageType.broadcastRequest:
        return 'broadcast_request';
      case BeaconMessageType.broadcastResponse:
        return 'broadcast_response';
      case BeaconMessageType.operationRequest:
        return 'operation_request';
      case BeaconMessageType.operationResponse:
        return 'operation_response';
      case BeaconMessageType.disconnect:
        return 'disconnect';
      case BeaconMessageType.error:
        return 'error';
    }
  }
  
  /// Create BeaconMessageType from string
  static BeaconMessageType fromString(String value) {
    switch (value) {
      case 'permission_request':
        return BeaconMessageType.permissionRequest;
      case 'permission_response':
        return BeaconMessageType.permissionResponse;
      case 'sign_request':
        return BeaconMessageType.signRequest;
      case 'sign_response':
        return BeaconMessageType.signResponse;
      case 'broadcast_request':
        return BeaconMessageType.broadcastRequest;
      case 'broadcast_response':
        return BeaconMessageType.broadcastResponse;
      case 'operation_request':
        return BeaconMessageType.operationRequest;
      case 'operation_response':
        return BeaconMessageType.operationResponse;
      case 'disconnect':
        return BeaconMessageType.disconnect;
      case 'error':
        return BeaconMessageType.error;
      default:
        throw ArgumentError('Unknown message type: $value');
    }
  }
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
  /// The unique ID of the message.
  final String id;
  
  /// The type of the message.
  final BeaconMessageType type;
  
  /// The version of the protocol.
  final String version;
  
  /// The sender identifier.
  final String senderId;
  
  /// Creates a new [BeaconMessage] instance.
  BeaconMessage({
    required this.id,
    required this.type,
    required this.version,
    required this.senderId,
  });
  
  /// Factory constructor to create a message from JSON.
  factory BeaconMessage.fromJson(Map<String, dynamic> json) {
    final type = BeaconMessageTypeExtension.fromString(json['type'] as String);
    
    switch (type) {
      case BeaconMessageType.permissionRequest:
        return PermissionRequestMessage.fromJson(json);
      case BeaconMessageType.permissionResponse:
        return PermissionResponseMessage.fromJson(json);
      case BeaconMessageType.disconnect:
        return DisconnectMessage.fromJson(json);
      // TODO: Implement other message types
      default:
        throw UnimplementedError('Message type ${type.value} is not implemented yet');
    }
  }
  
  /// Convert the message to a JSON map.
  Map<String, dynamic> toJson();
}
