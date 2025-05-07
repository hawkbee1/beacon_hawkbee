part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Interface for secure storage operations in the Beacon SDK.
///
/// This provides methods to securely store sensitive data like keys.
abstract class SecureStorage {
  /// Saves a value securely with the specified key.
  Future<void> saveSecure(String key, String value);

  /// Gets a securely stored value for the specified key.
  Future<String?> getSecure(String key);

  /// Removes a securely stored value for the specified key.
  Future<void> deleteSecure(String key);

  /// Checks if a securely stored value exists for the specified key.
  Future<bool> hasSecure(String key);
}
