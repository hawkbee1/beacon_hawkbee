part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Interface for secure storage operations in the Beacon SDK.
abstract class SecureStorage {
  /// Stores a value securely.
  Future<void> saveSecure(String key, String value);

  /// Retrieves a securely stored value.
  Future<String?> getSecure(String key);

  /// Removes a securely stored value.
  Future<void> removeSecure(String key);
}
