part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Metadata describing an application.
///
/// This class contains essential information about a dApp or wallet
/// that's used for identification and display purposes.
class AppMetadata {
  /// The unique identifier of the blockchain on which the app operates.
  final String blockchainIdentifier;

  /// The unique identifier of the sender (app).
  final String senderId;

  /// The name of the application.
  final String name;

  /// An optional URL for the application icon.
  final String? icon;

  /// Creates a new instance of AppMetadata.
  const AppMetadata({
    required this.blockchainIdentifier,
    required this.senderId,
    required this.name,
    this.icon,
  });

  /// Creates a new AppMetadata instance from a JSON map.
  factory AppMetadata.fromJson(Map<String, dynamic> json) {
    return AppMetadata(
      blockchainIdentifier: json['blockchainIdentifier'] as String,
      senderId: json['senderId'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
    );
  }

  /// Converts this AppMetadata to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'blockchainIdentifier': blockchainIdentifier,
      'senderId': senderId,
      'name': name,
      if (icon != null) 'icon': icon,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppMetadata &&
        other.blockchainIdentifier == blockchainIdentifier &&
        other.senderId == senderId &&
        other.name == name &&
        other.icon == icon;
  }

  @override
  int get hashCode {
    return blockchainIdentifier.hashCode ^
        senderId.hashCode ^
        name.hashCode ^
        (icon?.hashCode ?? 0);
  }

  @override
  String toString() {
    return 'AppMetadata(blockchainIdentifier: $blockchainIdentifier, senderId: $senderId, name: $name, icon: $icon)';
  }
}
