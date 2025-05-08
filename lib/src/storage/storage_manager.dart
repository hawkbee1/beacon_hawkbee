part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Interface for managing persistent storage operations in the Beacon SDK.
abstract class StorageManager {
  /// Retrieves a value from storage by key.
  Future<String?> getValue(String key);

  /// Stores a value with the given key.
  Future<void> setValue(String key, String value);

  /// Removes a value by key.
  Future<void> removeValue(String key);

  /// Retrieves all stored peers.
  Future<List<Peer>> getPeers();

  /// Adds peers to storage.
  Future<void> addPeers(List<Peer> peers);

  /// Removes specific peers from storage.
  Future<void> removePeers(List<Peer> peers);

  /// Removes all peers from storage.
  Future<void> removeAllPeers();

  /// Finds a peer matching the given predicate.
  Future<Peer?> findPeer(bool Function(Peer) predicate);

  /// Retrieves all stored permissions.
  Future<List<Permission>> getPermissions();

  /// Adds permissions to storage.
  Future<void> addPermissions(List<Permission> permissions);

  /// Removes specific permissions from storage.
  Future<void> removePermissions(List<Permission> permissions);

  /// Removes all permissions from storage.
  Future<void> removeAllPermissions();

  /// Removes permissions that match the given predicate.
  Future<void> removePermissionsWhere(bool Function(Permission) predicate);

  /// Finds a permission matching the given predicate.
  Future<Permission?> findPermission(bool Function(Permission) predicate);
}
