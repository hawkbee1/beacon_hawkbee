import 'dart:convert';

import 'package:beacon_hawkbee/beacon_hawkbee.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of [StorageManager] using SharedPreferences.
class SharedPreferencesStorage implements StorageManager {
  /// SharedPreferences instance used for storage.
  final SharedPreferences _preferences;

  /// Keys for stored data.
  static const String _peersKey = 'beacon_peers';
  static const String _permissionsKey = 'beacon_permissions';

  /// Creates a new [SharedPreferencesStorage] instance.
  SharedPreferencesStorage(this._preferences);

  @override
  Future<String?> getValue(String key) async {
    return _preferences.getString(key);
  }

  @override
  Future<void> setValue(String key, String value) async {
    await _preferences.setString(key, value);
  }

  @override
  Future<void> removeValue(String key) async {
    await _preferences.remove(key);
  }

  @override
  Future<List<Peer>> getPeers() async {
    final peersJson = _preferences.getString(_peersKey);
    if (peersJson == null) {
      return [];
    }

    try {
      final List<dynamic> peersList = json.decode(peersJson);
      return peersList
          .map((peerMap) => Peer.fromJson(peerMap as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> addPeers(List<Peer> peers) async {
    final currentPeers = await getPeers();

    // Filter out duplicates
    final newPeers = peers
        .where((newPeer) =>
            !currentPeers.any((peer) => peer.publicKey == newPeer.publicKey))
        .toList();

    final allPeers = [...currentPeers, ...newPeers];
    final peersJson = json.encode(allPeers.map((p) => p.toJson()).toList());

    await _preferences.setString(_peersKey, peersJson);
  }

  @override
  Future<void> removePeers(List<Peer> peers) async {
    final currentPeers = await getPeers();

    final updatedPeers = currentPeers
        .where((peer) =>
            !peers.any((toRemove) => toRemove.publicKey == peer.publicKey))
        .toList();

    final peersJson = json.encode(updatedPeers.map((p) => p.toJson()).toList());
    await _preferences.setString(_peersKey, peersJson);
  }

  @override
  Future<void> removeAllPeers() async {
    await _preferences.remove(_peersKey);
  }

  @override
  Future<Peer?> findPeer(bool Function(Peer) predicate) async {
    final peers = await getPeers();
    try {
      return peers.firstWhere(predicate);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Permission>> getPermissions() async {
    final permissionsJson = _preferences.getString(_permissionsKey);
    if (permissionsJson == null) {
      return [];
    }

    try {
      final List<dynamic> permissionsList = json.decode(permissionsJson);
      return permissionsList
          .map((permissionMap) =>
              Permission.fromJson(permissionMap as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> addPermissions(List<Permission> permissions) async {
    final currentPermissions = await getPermissions();

    // Filter out duplicates
    final newPermissions = permissions
        .where((newPermission) => !currentPermissions.any((permission) =>
            permission.accountId == newPermission.accountId &&
            permission.senderId == newPermission.senderId))
        .toList();

    final allPermissions = [...currentPermissions, ...newPermissions];
    final permissionsJson =
        json.encode(allPermissions.map((p) => p.toJson()).toList());

    await _preferences.setString(_permissionsKey, permissionsJson);
  }

  @override
  Future<void> removePermissions(List<Permission> permissions) async {
    final currentPermissions = await getPermissions();

    final updatedPermissions = currentPermissions
        .where((permission) => !permissions.any((toRemove) =>
            toRemove.accountId == permission.accountId &&
            toRemove.senderId == permission.senderId))
        .toList();

    final permissionsJson =
        json.encode(updatedPermissions.map((p) => p.toJson()).toList());
    await _preferences.setString(_permissionsKey, permissionsJson);
  }

  @override
  Future<void> removeAllPermissions() async {
    await _preferences.remove(_permissionsKey);
  }

  @override
  Future<void> removePermissionsWhere(
      bool Function(Permission) predicate) async {
    final currentPermissions = await getPermissions();

    final updatedPermissions = currentPermissions
        .where((permission) => !predicate(permission))
        .toList();

    final permissionsJson =
        json.encode(updatedPermissions.map((p) => p.toJson()).toList());
    await _preferences.setString(_permissionsKey, permissionsJson);
  }

  @override
  Future<Permission?> findPermission(
      bool Function(Permission) predicate) async {
    final permissions = await getPermissions();
    try {
      return permissions.firstWhere(predicate);
    } catch (e) {
      return null;
    }
  }
}
