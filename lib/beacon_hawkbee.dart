/// Beacon SDK for Dart - enabling communication between dApps and wallets
///
/// This library provides a Dart implementation of the Beacon protocol,
/// allowing dApps to connect with wallets for blockchain operations.
library beacon_hawkbee;

// Export the base library that contains all the part files
export 'src/beacon_hawkbee_base.dart';

// Client implementation files that are not parts
export 'src/client/impl/client_factory.dart';
export 'src/client/impl/dapp_client.dart';
export 'src/client/impl/wallet_client.dart';

// Blockchain implementations that are not parts
export 'src/blockchain/tezos/tezos_blockchain.dart';
export 'src/blockchain/tezos/message/tezos_operation_request.dart';

// Storage implementations that are not parts
export 'src/storage/impl/shared_preferences_storage.dart';
export 'src/storage/impl/flutter_secure_storage_impl.dart';

// Matrix implementation that is not a part
export 'src/transport/p2p/matrix/matrix_client_provider.dart';
export 'src/transport/p2p/matrix/matrix_p2p_client.dart';

// Crypto implementation that is not a part
export 'src/crypto/impl/sodium_crypto_service.dart';
