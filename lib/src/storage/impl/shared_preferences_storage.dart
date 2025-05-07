import 'dart:convert';

import 'package:beacon_hawkbee/beacon_hawkbee.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of [StorageManager] using SharedPreferences for persistence.
class SharedPreferencesStorage implements StorageManager {
  static const String _peersKey = 'beacon_peers';
  static const String _permissionsKey = 'beacon_permissions';
  static const String _valuesPrefix = 'beacon_value_';

  final SharedPreferences _prefs;

  /// Creates a new [SharedPreferencesStorage] instance with the provided
  /// [SharedPreferences] instance.
  SharedPreferencesStorage(this._prefs);

  /// Creates and initializes a new [SharedPreferencesStorage] instance.
  static Future<SharedPreferencesStorage> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPreferencesStorage(prefs);
  }

  @override
  Future<void> addPeers(List<Peer> peers) async {
    final existing = await getPeers();
    final newPeers = [...existing];

    // Add only peers that don't exist yet (by id)
    for (final peer in peers) {
      final index = newPeers.indexWhere((p) => p.id == peer.id);
      if (index >= 0) {
        newPeers[index] = peer; // Replace existing peer
      } else {
        newPeers.add(peer); // Add new peer
      }
    }

    await _savePeers(newPeers);
  }

  @override
  Future<List<Peer>> getPeers() async {
    final peersJson = _prefs.getString(_peersKey);
    if (peersJson == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(peersJson);
      return decoded
          .map((peerJson) => Peer.fromJson(peerJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // If there's an error parsing, return empty list
      return [];
    }
  }

  @override
  Future<void> removePeers(List<Peer> peersToRemove) async {
    final peers = await getPeers();
    final remaining = peers
        .where((peer) => !peersToRemove.any((p) => p.id == peer.id))
        .toList();
    await _savePeers(remaining);
  }

  @override
  Future<void> removePeersWhere(bool Function(Peer) predicate) async {
    final peers = await getPeers();
    final remaining = peers.where((peer) => !predicate(peer)).toList();
    await _savePeers(remaining);
  }

  @override
  Future<void> removeAllPeers() async {
    await _prefs.remove(_peersKey);
  }

  @override
  Future<void> addPermissions(List<Permission> permissions) async {
    final existing = await getPermissions();
    final newPermissions = [...existing];

    // Add only permissions that don't exist yet (by accountId and senderId)
    for (final permission in permissions) {
      final index = newPermissions.indexWhere(
        (p) =>
            p.accountId == permission.accountId &&
            p.senderId == permission.senderId,
      );
      if (index >= 0) {
        newPermissions[index] = permission; // Replace existing permission
      } else {
        newPermissions.add(permission); // Add new permission
      }
    }

    await _savePermissions(newPermissions);
  }

  @override
  Future<List<Permission>> getPermissions() async {
    final permissionsJson = _prefs.getString(_permissionsKey);
    if (permissionsJson == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(permissionsJson);
      return decoded
          .map((json) => Permission.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // If there's an error parsing, return empty list
      return [];
    }
  }

  @override
  Future<Permission?> findPermission(
      bool Function(Permission) predicate) async {
    final permissions = await getPermissions();
    return permissions.firstWhere(predicate, orElse: () => null as Permission);
  }

  @override
  Future<void> removePermissions(List<Permission> permissionsToRemove) async {
    final permissions = await getPermissions();
    final remaining = permissions
        .where((permission) => !permissionsToRemove.any(
              (p) =>
                  p.accountId == permission.accountId &&
                  p.senderId == permission.senderId,
            ))
        .toList();
    await _savePermissions(remaining);
  }

  @override
  Future<void> removePermissionsWhere(
      bool Function(Permission) predicate) async {
    final permissions = await getPermissions();
    final remaining =
        permissions.where((permission) => !predicate(permission)).toList();
    await _savePermissions(remaining);
  }

  @override
  Future<void> removeAllPermissions() async {
    await _prefs.remove(_permissionsKey);
  }

  @override
  Future<void> setValue(String key, String value) async {
    await _prefs.setString(_getStorageKey(key), value);
  }

  @override
  Future<String?> getValue(String key) async {
    return _prefs.getString(_getStorageKey(key));
  }

  @override
  Future<void> removeValue(String key) async {
    await _prefs.remove(_getStorageKey(key));
  }

  // Helper methods

  Future<void> _savePeers(List<Peer> peers) async {
    final peersJson = jsonEncode(peers.map((p) => p.toJson()).toList());
    await _prefs.setString(_peersKey, peersJson);
  }

  Future<void> _savePermissions(List<Permission> permissions) async {
    final permissionsJson =
        jsonEncode(permissions.map((p) => p.toJson()).toList());
    await _prefs.setString(_permissionsKey, permissionsJson);
  }

  String _getStorageKey(String key) => '$_valuesPrefix$key';
}
