part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Represents a request for permissions from a dApp to a wallet.
class PermissionRequestMessage extends BeaconMessage {
  /// The application metadata.
  final AppMetadata appMetadata;

  /// The network to request permissions for.
  final Network network;

  /// The desired scopes/permissions.
  final List<String> scopes;

  /// Creates a new [PermissionRequestMessage] instance.
  PermissionRequestMessage({
    required String id,
    required String version,
    required BeaconPeer sender,
    required BeaconPeer destination,
    required this.appMetadata,
    required this.network,
    required this.scopes,
  }) : super(
          id: id,
          type: BeaconMessageType.permissionRequest,
          version: version,
          sender: sender,
          destination: destination,
        );

  /// Creates a [PermissionRequestMessage] instance from a JSON map.
  factory PermissionRequestMessage.fromJson(Map<String, dynamic> json) {
    return PermissionRequestMessage(
      id: json['id'] as String,
      version: json['version'] as String,
      sender: BeaconPeer.fromJson(json['sender'] as Map<String, dynamic>),
      destination:
          BeaconPeer.fromJson(json['destination'] as Map<String, dynamic>),
      appMetadata:
          AppMetadata.fromJson(json['appMetadata'] as Map<String, dynamic>),
      network: Network.fromJson(json['network'] as Map<String, dynamic>),
      scopes:
          (json['scopes'] as List<dynamic>).map((e) => e as String).toList(),
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
      'appMetadata': appMetadata.toJson(),
      'network': network.toJson(),
      'scopes': scopes,
    };
  }
}
