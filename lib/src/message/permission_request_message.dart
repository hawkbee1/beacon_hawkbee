part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// A message requesting permission from a wallet.
class PermissionRequestMessage extends BeaconMessage {
  /// Application metadata of the dApp requesting permissions.
  final AppMetadata appMetadata;

  /// The requested network to connect to.
  final Network network;

  /// Optional scopes of permissions being requested.
  final List<String>? scopes;

  /// Creates a new [PermissionRequestMessage] instance.
  const PermissionRequestMessage({
    required super.id,
    required super.senderId,
    required super.version,
    required super.origin,
    required super.destination,
    required this.appMetadata,
    required this.network,
    this.scopes,
  }) : super(type: BeaconMessageType.permissionRequest);

  /// Creates a new PermissionRequestMessage instance from a JSON map.
  factory PermissionRequestMessage.fromJson(Map<String, dynamic> json) {
    return PermissionRequestMessage(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      version: json['version'] as String,
      origin: Connection.fromJson(json['origin'] as Map<String, dynamic>),
      destination: Connection.fromJson(
        json['destination'] as Map<String, dynamic>,
      ),
      appMetadata: AppMetadata.fromJson(
        json['appMetadata'] as Map<String, dynamic>,
      ),
      network: Network.fromJson(json['network'] as Map<String, dynamic>),
      scopes: (json['scopes'] as List<dynamic>?)?.cast<String>(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'appMetadata': appMetadata.toJson(),
      'network': network.toJson(),
      if (scopes != null) 'scopes': scopes,
    };
  }
}
