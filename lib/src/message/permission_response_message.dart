part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// A message responding to a permission request from a dApp.
class PermissionResponseMessage extends BeaconMessage {
  /// ID of the request message this is responding to.
  final String requestId;

  /// The public key of the account granting permissions.
  final String publicKey;

  /// The network on which permissions are being granted.
  final Network network;

  /// The blockchain account address.
  final String address;

  /// Scopes of permissions being granted.
  final List<String> scopes;

  /// Application metadata of the wallet granting permissions.
  final AppMetadata appMetadata;

  /// Creates a new [PermissionResponseMessage] instance.
  const PermissionResponseMessage({
    required super.id,
    required super.senderId,
    required super.version,
    required super.origin,
    required super.destination,
    required this.requestId,
    required this.publicKey,
    required this.network,
    required this.address,
    required this.scopes,
    required this.appMetadata,
  }) : super(type: BeaconMessageType.permissionResponse);

  /// Creates a new PermissionResponseMessage instance from a JSON map.
  factory PermissionResponseMessage.fromJson(Map<String, dynamic> json) {
    return PermissionResponseMessage(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      version: json['version'] as String,
      origin: Connection.fromJson(json['origin'] as Map<String, dynamic>),
      destination: Connection.fromJson(
        json['destination'] as Map<String, dynamic>,
      ),
      requestId: json['requestId'] as String,
      publicKey: json['publicKey'] as String,
      network: Network.fromJson(json['network'] as Map<String, dynamic>),
      address: json['address'] as String,
      scopes: (json['scopes'] as List<dynamic>).cast<String>(),
      appMetadata: AppMetadata.fromJson(
        json['appMetadata'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'requestId': requestId,
      'publicKey': publicKey,
      'network': network.toJson(),
      'address': address,
      'scopes': scopes,
      'appMetadata': appMetadata.toJson(),
    };
  }
}
