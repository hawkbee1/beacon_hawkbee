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
export 'src/client/impl/client_factory.dart';
export 'src/client/impl/dapp_client.dart';
export 'src/client/impl/wallet_client.dart';

// Configuration
export 'src/configuration/log_level.dart';

// Message types
export 'src/message/beacon_message.dart';
export 'src/message/disconnect_message.dart';
export 'src/message/permission_request_message.dart';
export 'src/message/permission_response_message.dart';

// Blockchain abstractions
export 'src/blockchain/blockchain.dart';
export 'src/blockchain/tezos/tezos_blockchain.dart';
export 'src/blockchain/tezos/message/tezos_operation_request.dart';

// Storage
export 'src/storage/storage_manager.dart';
export 'src/storage/secure_storage.dart';
export 'src/storage/impl/shared_preferences_storage.dart';
export 'src/storage/impl/flutter_secure_storage_impl.dart';

// Transport layer
export 'src/transport/transport.dart';
export 'src/transport/data/connection_message.dart';
export 'src/transport/data/pairing_message.dart';
export 'src/transport/p2p/p2p_client.dart';
export 'src/transport/p2p/p2p_transport.dart';
export 'src/transport/p2p/matrix/matrix_client_provider.dart';

// Cryptography
export 'src/crypto/crypto_service.dart';
export 'src/crypto/key_pair.dart';
export 'src/crypto/impl/sodium_crypto_service.dart';
