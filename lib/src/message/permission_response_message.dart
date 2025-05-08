part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Represents a response to a permission request from a wallet to a dApp.
class PermissionResponseMessage extends BeaconMessage {
  /// The account that was granted permissions.
  final Account account;

  /// The granted scopes/permissions.
  final List<String> scopes;

  /// Creates a new [PermissionResponseMessage] instance.
  PermissionResponseMessage({
    required String id,
    required String version,
    required BeaconPeer sender,
    required BeaconPeer destination,
    required this.account,
    required this.scopes,
  }) : super(
          id: id,
          type: BeaconMessageType.permissionResponse,
          version: version,
          sender: sender,
          destination: destination,
        );

  /// Creates a [PermissionResponseMessage] instance from a JSON map.
  factory PermissionResponseMessage.fromJson(Map<String, dynamic> json) {
    return PermissionResponseMessage(
      id: json['id'] as String,
      version: json['version'] as String,
      sender: BeaconPeer.fromJson(json['sender'] as Map<String, dynamic>),
      destination:
          BeaconPeer.fromJson(json['destination'] as Map<String, dynamic>),
      account: Account.fromJson(json['account'] as Map<String, dynamic>),
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
      'account': account.toJson(),
      'scopes': scopes,
    };
  }
}
