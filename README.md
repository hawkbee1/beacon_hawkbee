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

A Dart implementation of the Beacon protocol for connecting blockchain dApps with wallets. This library enables communication between decentralized applications and blockchain wallets, focusing initially on Tezos blockchain integration.

## Features

- Core Beacon SDK functionality translated from the [Kotlin Beacon Android SDK](https://github.com/airgap-it/beacon-android-sdk)
- Type-safe data models for Beacon protocol messages
- Support for permission requests and responses
- Peer-to-peer connection management
- Blockchain-agnostic architecture with initial focus on Tezos

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  beacon_hawkbee: ^0.1.0
```

Then run:

```
flutter pub get
```

## Usage

```dart
import 'package:beacon_hawkbee/beacon_hawkbee.dart';

// Initialize the Beacon SDK
final beacon = await Beacon.init(
  appMetadata: AppMetadata(
    blockchainIdentifier: 'tezos',
    senderId: 'my-dapp-sender-id',
    name: 'My Awesome dApp',
    icon: 'https://myapp.com/icon.png',
  ),
);

// Request permissions from a wallet
// Implementation details depend on your specific use case
```

See the `example` directory for a complete sample application.

## Architecture

The SDK is designed with the following core components:

- **BeaconClient**: Base class for all client types
- **BeaconConsumer**: Interface for dApps that receive responses from wallets
- **BeaconProducer**: Interface for wallets that respond to dApp requests
- **Data Models**: Type-safe representations of protocol data (Account, Peer, Network, etc.)
- **Message Types**: Various message formats for communication (PermissionRequest, etc.)
- **Blockchain**: Abstraction layer for various blockchain implementations

## Roadmap

- [x] Core data models and interfaces
- [x] Message serialization/deserialization
- [ ] P2P matrix transport implementation
- [ ] Deep linking support for mobile apps
- [ ] Tezos blockchain implementation
- [ ] Substrate blockchain implementation

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
