import 'dart:convert';

import 'package:beacon_hawkbee/beacon_hawkbee.dart';
import 'package:beacon_hawkbee/src/client/impl/dapp_client.dart';
import 'package:beacon_hawkbee/src/client/impl/wallet_client.dart';
import 'package:beacon_hawkbee/src/crypto/impl/sodium_crypto_service.dart';
import 'package:beacon_hawkbee/src/storage/impl/flutter_secure_storage_impl.dart';
import 'package:beacon_hawkbee/src/storage/impl/shared_preferences_storage.dart';
import 'package:beacon_hawkbee/src/transport/p2p/matrix/matrix_client_provider.dart';
import 'package:beacon_hawkbee/src/transport/p2p/matrix/matrix_p2p_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sodium/sodium.dart';
import 'package:uuid/uuid.dart';

/// Factory for creating Beacon clients with appropriate dependencies.
class ClientFactory {
  /// Creates a dApp client with default implementations.
  static Future<DAppClient> createDAppClient({
    required AppMetadata appMetadata,
    String? beaconId,
    String? matrixNode,
    SharedPreferences? preferences,
    Sodium? sodium,
  }) async {
    final prefs = preferences ?? await SharedPreferences.getInstance();
    final storage = SharedPreferencesStorage(prefs);
    final secureStorage = FlutterSecureStorageImpl();

    // Initialize sodium
    final sodiumInstance = sodium ?? await SodiumInit.init();
    final cryptoService = SodiumCryptoService(sodiumInstance);

    // Generate or load beacon ID
    final clientId =
        beaconId ?? await _getOrCreateBeaconId(storage, secureStorage);

    // Create P2P client
    final p2pClient = MatrixP2PClient(
      appMetadata: appMetadata,
      storageManager: storage,
      homeserver: matrixNode ?? MatrixP2PClient.defaultMatrixServer,
    );

    try {
      // Initialize the P2P client using a dynamic approach to avoid type mismatches
      (p2pClient as dynamic).init();
    } catch (e) {
      throw Exception('Failed to initialize P2P client: $e');
    }

    return DAppClient(
      appMetadata: appMetadata,
      storageManager: storage,
      cryptoService: cryptoService,
      p2pClient: p2pClient,
      clientId: clientId,
    );
  }

  static Future<String> _getOrCreateBeaconId(
    SharedPreferencesStorage storage,
    FlutterSecureStorageImpl secureStorage,
  ) async {
    var beaconId = await secureStorage.read(key: 'beaconId');
    if (beaconId == null) {
      beaconId = Uuid().v4();
      await secureStorage.write(key: 'beaconId', value: beaconId);
    }
    return beaconId;
  }
}
