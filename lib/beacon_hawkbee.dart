/// Beacon SDK for Dart - enabling communication between dApps and wallets
///
/// This library provides a Dart implementation of the Beacon protocol,
/// allowing dApps to connect with wallets for blockchain operations.
library beacon_hawkbee;

export 'src/beacon_hawkbee_base.dart';

// Core data models
export 'src/data/account.dart';
export 'src/data/app_metadata.dart';
export 'src/data/beacon_error.dart';
export 'src/data/connection.dart';
export 'src/data/network.dart';
export 'src/data/peer.dart';
export 'src/data/permission.dart';
export 'src/data/signing_type.dart';

// Client interfaces
export 'src/client/beacon_client.dart';
export 'src/client/beacon_consumer.dart';
export 'src/client/beacon_producer.dart';

// Configuration
export 'src/configuration/log_level.dart';

// Message types
export 'src/message/beacon_message.dart';
export 'src/message/disconnect_message.dart';
export 'src/message/permission_request_message.dart';
export 'src/message/permission_response_message.dart';

// Blockchain abstractions
export 'src/blockchain/blockchain.dart';
