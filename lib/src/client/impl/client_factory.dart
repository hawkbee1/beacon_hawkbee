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

    // Create P2P client and transport
    final p2pClient = MatrixP2PClient(
      appMetadata: appMetadata,
      storageManager: storage,
      homeserver: matrixNode ?? MatrixP2PClient.defaultMatrixServer,
    );
    await p2pClient.init();
    final transport = P2PTransport(
      p2pClient: p2pClient,
      cryptoService: cryptoService,
      storageManager: storage,
      senderId: clientId,
    );

    return DAppClient(
      appMetadata: appMetadata,
      beaconId: clientId,
      cryptoService: cryptoService,
      storageManager: storage,
      transport: transport,
    );
  }

  /// Creates a wallet client with default implementations.
  static Future<WalletClient> createWalletClient({
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

    // Create P2P client and transport
    final p2pClient = MatrixP2PClient(
      appMetadata: appMetadata,
      storageManager: storage,
      homeserver: matrixNode ?? MatrixP2PClient.defaultMatrixServer,
    );
    await p2pClient.init();
    final transport = P2PTransport(
      p2pClient: p2pClient,
      cryptoService: cryptoService,
      storageManager: storage,
      senderId: clientId,
    );

    return WalletClient(
      appMetadata: appMetadata,
      beaconId: clientId,
      cryptoService: cryptoService,
      storageManager: storage,
      transport: transport,
    );
  }

  /// Gets or creates a beacon ID for the client.
  static Future<String> _getOrCreateBeaconId(
    StorageManager storage,
    SecureStorage secureStorage,
  ) async {
    final storedId = await storage.getValue('beacon_client_id');
    if (storedId != null) {
      return storedId;
    }

    // Generate a new beacon ID (based on UUID)
    final newId = const Uuid().v4();
    await storage.setValue('beacon_client_id', newId);

    return newId;
  }
}
