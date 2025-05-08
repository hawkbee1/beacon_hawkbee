part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Standard permission scopes available in Beacon.
class BeaconScope {
  /// Permission to request signature.
  static const String sign = 'sign';
  
  /// Permission to request operations.
  static const String operation = 'operation';
  
  /// Permission to request contract calls.
  static const String contractCall = 'contract_call';
  
  /// Permission to interact with threshold accounts.
  static const String threshold = 'threshold';
}

/// Represents permission for a specific blockchain account.
class Permission {
  /// The account for which permission is granted.
  final Account account;
  
  /// The application metadata for which permission is granted.
  final AppMetadata appMetadata;
  
  /// The list of scopes/permissions granted.
  final List<String> scopes;
  
  /// The date when this permission was created.
  final DateTime createdAt;
  
  /// The account identifier (for permission lookup)
  String get accountId => account.accountId;
  
  /// The sender identifier (for permission lookup)
  String get senderId => appMetadata.senderId;
  
  /// Creates a new [Permission] instance.
  Permission({
    required this.account,
    required this.appMetadata,
    required this.scopes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
  
  /// Creates a [Permission] instance from a JSON map.
  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      account: Account.fromJson(json['account'] as Map<String, dynamic>),
      appMetadata: AppMetadata.fromJson(json['appMetadata'] as Map<String, dynamic>),
      scopes: (json['scopes'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
  
  /// Converts this permission to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'account': account.toJson(),
      'appMetadata': appMetadata.toJson(),
      'scopes': scopes,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
