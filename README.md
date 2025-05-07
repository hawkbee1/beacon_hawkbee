<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages). 
-->

# Beacon Hawkbee

Beacon Hawkbee is a Dart implementation of the [Beacon SDK](https://github.com/airgap-it/beacon-sdk), enabling communication between decentralized applications (dApps) and wallets in the Tezos ecosystem.

## Features

- **Cross-Platform**: Works on iOS, Android, and web platforms
- **Type-Safe**: Built with Dart's strong type system
- **Protocol v3**: Implements version 3 of the Beacon protocol
- **Matrix Support**: Communicates via Matrix for decentralized, secure connections
- **Tezos Support**: Designed specifically for the Tezos blockchain

## Installation

```yaml
dependencies:
  beacon_hawkbee: ^0.1.0
```

## Basic Usage

### For dApps

```dart
import 'package:beacon_hawkbee/beacon_hawkbee.dart';

Future<void> main() async {
  // Initialize dApp client
  final dAppClient = await ClientFactory.createDAppClient(
    appMetadata: AppMetadata(
      blockchainIdentifier: 'tezos',
      senderId: 'my-dapp-id',
      name: 'My Tezos dApp',
      icon: 'https://myapp.com/icon.png',
    ),
  );

  // Connect to Beacon network
  final messageStream = dAppClient.connect();
  messageStream.listen((message) {
    print('Received message: ${message.type}');
  });

  // Create pairing request (returns a string that can be converted to QR code)
  final pairingData = await dAppClient.createPairingRequest();
  
  // Display QR code to user for scanning with a wallet
  // ...

  // Request permissions once paired with a wallet
  try {
    final permission = await dAppClient.requestPermissions(
      network: 'mainnet',
      scopes: ['operation_request', 'sign'],
    );
    print('Permission granted for account: ${permission.accountId}');
  } catch (e) {
    print('Permission request failed: $e');
  }

  // Request operation signing (example for Tezos)
  // ...
}
```

### For Wallets

```dart
import 'package:beacon_hawkbee/beacon_hawkbee.dart';

Future<void> main() async {
  // Initialize wallet client
  final walletClient = await ClientFactory.createWalletClient(
    appMetadata: AppMetadata(
      blockchainIdentifier: 'tezos',
      senderId: 'my-wallet-id',
      name: 'My Tezos Wallet',
      icon: 'https://mywallet.com/icon.png',
    ),
  );

  // Connect to Beacon network
  final messageStream = walletClient.connect();
  messageStream.listen((message) async {
    if (message is PermissionRequestMessage) {
      // Show permission request to user
      // ...
      
      // Respond with approval (after user confirms)
      await walletClient.respondToPermissionRequest(
        requestId: message.id,
        publicKey: 'user-public-key',
        address: 'tz1userAddress',
        network: message.network.type,
        scopes: message.scopes ?? [],
      );
    } 
    else if (message is TezosOperationSignRequest) {
      // Handle operation signing request
      // ...
    }
  });

  // Handle incoming pairing requests (from QR code scans or deep links)
  Future<void> handlePairingData(String data) async {
    await walletClient.handlePairingRequest(data);
  }
}
```

## Architecture

Beacon Hawkbee follows a modular architecture:

1. **Core SDK** - Base interfaces and data models
2. **Transport Layer** - Handles peer-to-peer communication (Matrix)
3. **Cryptography** - Secure messaging with libsodium
4. **Storage** - Persistent storage of peers and permissions
5. **Blockchain-specific** - Implementations for Tezos

## Advanced Usage

### Custom Configuration

You can customize various components of the SDK:

```dart
// Custom Matrix node
final dAppClient = await ClientFactory.createDAppClient(
  appMetadata: myAppMetadata,
  matrixNode: 'https://matrix.example.com',
);

// Custom storage
final prefs = await SharedPreferences.getInstance();
final customStorage = SharedPreferencesStorage(prefs);

// ... other customizations
```

### Error Handling

The SDK uses `BeaconError` for error conditions:

```dart
try {
  await dAppClient.requestPermissions();
} catch (e) {
  if (e is BeaconError) {
    if (e.code == BeaconError.notGrantedError) {
      // Permission was denied
    } else if (e.code == BeaconError.pairingError) {
      // Pairing failed
    }
  }
}
```

## Tezos-specific Features

Beacon Hawkbee includes Tezos-specific components for:

- Account management
- Network configuration (mainnet, testnets)
- Operation signing
- Permission scopes

## Compatibility

This library implements version 3 of the Beacon protocol, making it compatible with:

- Beacon Kotlin/Swift SDK
- AirGap Wallet
- Temple Wallet
- Other Beacon-compatible wallets

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This package is open source and available under the MIT license.
