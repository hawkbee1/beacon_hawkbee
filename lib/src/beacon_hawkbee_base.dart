/// Beacon is a protocol that enables communication between dApps and wallets.
/// This library is a Dart implementation of the Beacon SDK.
library beacon_hawkbee;

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

part 'blockchain/blockchain.dart';
part 'data/account.dart';
part 'data/app_metadata.dart';
part 'data/beacon_error.dart';
part 'data/connection.dart';
part 'data/network.dart';
part 'data/peer.dart';
part 'data/permission.dart';
part 'data/signing_type.dart';
part 'client/beacon_client.dart';
part 'client/beacon_consumer.dart';
part 'client/beacon_producer.dart';
part 'configuration/log_level.dart';
part 'message/beacon_message.dart';
part 'message/permission_request_message.dart';
part 'message/permission_response_message.dart';
part 'message/disconnect_message.dart';
part 'storage/storage_manager.dart';
part 'storage/secure_storage.dart';
part 'crypto/crypto_service.dart';
part 'crypto/key_pair.dart';
part 'transport/transport.dart';
part 'transport/data/pairing_message.dart';
part 'transport/data/connection_message.dart';
part 'transport/p2p/p2p_transport.dart';
part 'transport/p2p/p2p_client.dart';

/// Core Beacon class that serves as the main entry point for the SDK.
class Beacon {
  /// The singleton instance of the Beacon SDK.
  static Beacon? _instance;

  /// Gets the singleton instance of the Beacon SDK.
  static Beacon get instance {
    if (_instance == null) {
      throw StateError('Beacon SDK not initialized. Call Beacon.init() first.');
    }
    return _instance!;
  }

  /// Initializes the Beacon SDK.
  static Future<Beacon> init({
    required AppMetadata appMetadata,
    LogLevel logLevel = LogLevel.none,
  }) async {
    if (_instance != null) {
      return _instance!;
    }

    _instance = Beacon._internal(appMetadata: appMetadata, logLevel: logLevel);

    await _instance!._initialize();

    return _instance!;
  }

  /// The application metadata.
  final AppMetadata appMetadata;

  /// The current log level.
  final LogLevel logLevel;

  Beacon._internal({required this.appMetadata, required this.logLevel});

  Future<void> _initialize() async {
    // Initialize core components
    // This will be implemented later
  }
}
