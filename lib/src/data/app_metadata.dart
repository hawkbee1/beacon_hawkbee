part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Represents metadata about an application.
class AppMetadata {
  /// The name of the application.
  final String name;

  /// The URL of the application's website.
  final String url;

  /// The URL of the application's icon.
  final String? iconUrl;

  /// The application's identifier.
  final String? appId;

  /// The sender identifier used for permissions
  String get senderId => appId ?? name;

  /// Creates a new [AppMetadata] instance.
  AppMetadata({
    required this.name,
    required this.url,
    this.iconUrl,
    this.appId,
  });

  /// Creates an [AppMetadata] instance from a JSON map.
  factory AppMetadata.fromJson(Map<String, dynamic> json) {
    return AppMetadata(
      name: json['name'] as String,
      url: json['url'] as String,
      iconUrl: json['iconUrl'] as String?,
      appId: json['appId'] as String?,
    );
  }

  /// Converts this app metadata to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      if (iconUrl != null) 'iconUrl': iconUrl,
      if (appId != null) 'appId': appId,
    };
  }
}
