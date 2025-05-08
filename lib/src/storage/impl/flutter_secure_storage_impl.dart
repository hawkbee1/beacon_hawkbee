import 'package:beacon_hawkbee/beacon_hawkbee.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Implementation of [SecureStorage] using flutter_secure_storage.
class FlutterSecureStorageImpl implements SecureStorage {
  /// The flutter_secure_storage instance.
  final FlutterSecureStorage _secureStorage;

  /// Creates a new [FlutterSecureStorageImpl] instance.
  FlutterSecureStorageImpl([FlutterSecureStorage? secureStorage])
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  @override
  Future<String?> getSecure(String key) async {
    return await _secureStorage.read(key: key);
  }

  @override
  Future<void> saveSecure(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  @override
  Future<void> removeSecure(String key) async {
    await _secureStorage.delete(key: key);
  }
}
