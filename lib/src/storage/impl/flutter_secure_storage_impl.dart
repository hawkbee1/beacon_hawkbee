import 'package:beacon_hawkbee/beacon_hawkbee.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Implementation of [SecureStorage] using flutter_secure_storage.
class FlutterSecureStorageImpl implements SecureStorage {
  static const String _keyPrefix = 'beacon_secure_';

  final FlutterSecureStorage _storage;

  /// Creates a new [FlutterSecureStorageImpl] instance.
  FlutterSecureStorageImpl([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<void> saveSecure(String key, String value) async {
    await _storage.write(key: _getPrefixedKey(key), value: value);
  }

  @override
  Future<String?> getSecure(String key) async {
    return await _storage.read(key: _getPrefixedKey(key));
  }

  @override
  Future<void> deleteSecure(String key) async {
    await _storage.delete(key: _getPrefixedKey(key));
  }

  @override
  Future<bool> hasSecure(String key) async {
    return (await _storage.containsKey(key: _getPrefixedKey(key)));
  }

  /// Adds a prefix to the key to avoid collisions with other apps.
  String _getPrefixedKey(String key) => '$_keyPrefix$key';
}
