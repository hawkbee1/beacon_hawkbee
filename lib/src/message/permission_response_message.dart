part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Represents a response to a permission request from a wallet to a dApp.
class PermissionResponseMessage extends BeaconMessage {
  /// The ID of the request being responded to.
  final String requestId;

  /// The public key of the wallet.
  final String publicKey;

  /// The network that permissions were granted for.
  final Network network;

  /// The wallet address.
  final String address;

  /// The application metadata.
  final AppMetadata appMetadata;

  /// The granted scopes/permissions.
  final List<String> scopes;

  /// Creates a new [PermissionResponseMessage] instance.
  PermissionResponseMessage({
    required String id,
    required String senderId,
    required String version,
    required Connection origin,
    required Connection destination,
    required this.requestId,
    required this.publicKey,
    required this.network,
    required this.address,
    required this.appMetadata,
    this.scopes = const [],
  }) : super(
          id: id,
          type: BeaconMessageType.permissionResponse,
          version: version,
          senderId: senderId,
          origin: origin,
          destination: destination,
        );

  /// Creates a [PermissionResponseMessage] instance from a JSON map.
  factory PermissionResponseMessage.fromJson(Map<String, dynamic> json) {
    return PermissionResponseMessage(
      id: json['id'] as String,
      version: json['version'] as String,
      senderId: json['senderId'] as String,
      origin: Connection.fromJson(json['origin'] as Map<String, dynamic>),
      destination:
          Connection.fromJson(json['destination'] as Map<String, dynamic>),
      requestId: json['requestId'] as String,
      publicKey: json['publicKey'] as String,
      network: Network.fromJson(json['network'] as Map<String, dynamic>),
      address: json['address'] as String,
      appMetadata:
          AppMetadata.fromJson(json['appMetadata'] as Map<String, dynamic>),
      scopes: json['scopes'] != null
          ? (json['scopes'] as List<dynamic>).map((e) => e as String).toList()
          : const [],
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
      'requestId': requestId,
      'publicKey': publicKey,
      'network': network.toJson(),
      'address': address,
      'appMetadata': appMetadata.toJson(),
      'scopes': scopes,
    };
  }
}
