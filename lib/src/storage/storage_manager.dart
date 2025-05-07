part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Interface defining the storage operations for the Beacon SDK.
///
/// This handles persisting peers, permissions and other data.
abstract class StorageManager {
  /// Adds a list of peers to storage.
  Future<void> addPeers(List<Peer> peers);

  /// Gets all stored peers.
  Future<List<Peer>> getPeers();

  /// Removes the specified peers from storage.
  Future<void> removePeers(List<Peer> peers);

  /// Removes all peers matching the provided predicate.
  Future<void> removePeersWhere(bool Function(Peer) predicate);

  /// Removes all stored peers.
  Future<void> removeAllPeers();

  /// Adds a list of permissions to storage.
  Future<void> addPermissions(List<Permission> permissions);

  /// Gets all stored permissions.
  Future<List<Permission>> getPermissions();

  /// Finds a permission matching the provided predicate.
  Future<Permission?> findPermission(bool Function(Permission) predicate);

  /// Removes the specified permissions from storage.
  Future<void> removePermissions(List<Permission> permissions);

  /// Removes all permissions matching the provided predicate.
  Future<void> removePermissionsWhere(bool Function(Permission) predicate);

  /// Removes all stored permissions.
  Future<void> removeAllPermissions();

  /// Saves a value with the specified key.
  Future<void> setValue(String key, String value);

  /// Gets a value for the specified key.
  Future<String?> getValue(String key);

  /// Removes a value for the specified key.
  Future<void> removeValue(String key);
}
