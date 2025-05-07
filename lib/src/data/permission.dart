part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Base class for granted permission data.
///
/// Permissions represent access rights granted by a wallet to a dApp.
class Permission {
  /// The unique name of the blockchain on which the permission is valid.
  final String blockchainIdentifier;

  /// The value that identifies the account which granted the permissions.
  final String accountId;

  /// The value that identifies the sender to whom the permissions were granted.
  final String senderId;

  /// The timestamp at which the permissions were granted.
  final int connectedAt;

  /// Creates a new [Permission] instance.
  const Permission({
    required this.blockchainIdentifier,
    required this.accountId,
    required this.senderId,
    required this.connectedAt,
  });

  /// Creates a new Permission instance from a JSON map.
  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      blockchainIdentifier: json['blockchainIdentifier'] as String,
      accountId: json['accountId'] as String,
      senderId: json['senderId'] as String,
      connectedAt: json['connectedAt'] as int,
    );
  }

  /// Converts this Permission to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'blockchainIdentifier': blockchainIdentifier,
      'accountId': accountId,
      'senderId': senderId,
      'connectedAt': connectedAt,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Permission &&
        other.blockchainIdentifier == blockchainIdentifier &&
        other.accountId == accountId &&
        other.senderId == senderId &&
        other.connectedAt == connectedAt;
  }

  @override
  int get hashCode {
    return blockchainIdentifier.hashCode ^
        accountId.hashCode ^
        senderId.hashCode ^
        connectedAt.hashCode;
  }
}
