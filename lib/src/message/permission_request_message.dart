part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Represents a request for permissions from a dApp to a wallet.
class PermissionRequestMessage extends BeaconMessage {
  /// The application metadata.
  final AppMetadata appMetadata;

  /// The network to request permissions for.
  final Network network;

  /// The desired scopes/permissions.
  final List<String>? scopes;

  /// Creates a new [PermissionRequestMessage] instance.
  PermissionRequestMessage({
    required String id,
    required String senderId,
    required String version,
    required Connection origin,
    required Connection destination,
    required this.appMetadata,
    required this.network,
    this.scopes,
  }) : super(
          id: id,
          type: BeaconMessageType.permissionRequest,
          version: version,
          senderId: senderId,
          origin: origin,
          destination: destination,
        );

  /// Creates a [PermissionRequestMessage] instance from a JSON map.
  factory PermissionRequestMessage.fromJson(Map<String, dynamic> json) {
    return PermissionRequestMessage(
      id: json['id'] as String,
      version: json['version'] as String,
      senderId: json['senderId'] as String,
      origin: Connection.fromJson(json['origin'] as Map<String, dynamic>),
      destination:
          Connection.fromJson(json['destination'] as Map<String, dynamic>),
      appMetadata:
          AppMetadata.fromJson(json['appMetadata'] as Map<String, dynamic>),
      network: Network.fromJson(json['network'] as Map<String, dynamic>),
      scopes: json['scopes'] != null
          ? (json['scopes'] as List<dynamic>).map((e) => e as String).toList()
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'id': id,
      'type': type.value,
      'version': version,
      'senderId': senderId,
      'origin': origin.toJson(),
      'destination': destination.toJson(),
      'appMetadata': appMetadata.toJson(),
      'network': network.toJson(),
    };

    if (scopes != null) {
      json['scopes'] = scopes;
    }

    return json;
  }
}
