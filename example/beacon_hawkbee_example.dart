import 'dart:async';
import 'dart:convert';

import 'package:beacon_hawkbee/beacon_hawkbee.dart';
import 'package:beacon_hawkbee/src/blockchain/tezos/message/tezos_operation_request.dart';

/// Example showing the use of the Beacon SDK for both dApp and wallet applications.
Future<void> main() async {
  print('Beacon Hawkbee SDK Example');
  print('========================\n');

  // This example demonstrates both dApp and wallet functionality in a single application
  // In a real scenario, these would be separate applications

  await dAppExample();
  // Uncomment to run the wallet example instead
  // await walletExample();
}

/// Example of using the Beacon SDK in a dApp.
Future<void> dAppExample() async {
  print('Running dApp example...\n');

  // Initialize a dApp client
  final dAppClient = await ClientFactory.createDAppClient(
    appMetadata: AppMetadata(
      blockchainIdentifier: 'tezos',
      senderId: 'example-dapp',
      name: 'Example Tezos dApp',
      icon: 'https://tezos.com/favicon.ico',
    ),
  );

  print('dApp client initialized with ID: ${dAppClient.senderId}');

  // Connect to the Beacon network
  final messageStream = dAppClient.connect();
  final subscription = messageStream.listen((message) {
    print('Received message: ${message.type}');
  });

  // Generate a pairing QR code/deep link
  try {
    final pairingData = await dAppClient.createPairingRequest();
    print('\nScan this QR code with a Beacon-compatible wallet:');
    print('----------------------------------------------');
    print('Pairing data: $pairingData');
    print('----------------------------------------------\n');

    // In a real application, you would convert this to a QR code
    // or generate a deep link for mobile apps
  } catch (e) {
    print('Failed to create pairing request: $e');
  }

  // Wait for a connection
  print('Waiting for wallet to connect...');
  print('(In a real app, this would happen when a user scans the QR code)');

  // For demo purposes, simulate a wallet connecting after a delay
  await Future.delayed(Duration(seconds: 2));

  // For the example, we'll create a simulated peer that represents a connected wallet
  final simulatedPeer = Peer(
    id: 'simulated-wallet-id',
    name: 'Simulated Wallet',
    publicKey: 'sim-public-key-xyz',
    version: '3',
    appUrl: 'https://example.com/wallet',
    icon: 'https://example.com/wallet/icon.png',
  );

  await dAppClient.addPeers([simulatedPeer]);
  print('\nWallet connected! Peer added with ID: ${simulatedPeer.id}');

  // Request permissions from the wallet
  try {
    print('\nRequesting permissions from wallet...');

    // In a real app, this would send a message to the wallet
    // and the wallet would display a permission request to the user
    // For this example, we'll just print what would happen

    print('Permission request would include:');
    print('- Network: mainnet');
    print('- Scopes: [operation_request, sign]');

    // In a real application with a real connected wallet, you would do:
    /*
    final permission = await dAppClient.requestPermissions(
      network: 'mainnet',
      scopes: ['operation_request', 'sign'],
    );
    print('Permission granted for account: ${permission.accountId}');
    */
  } catch (e) {
    print('Permission request failed: $e');
  }

  // Show how to request a transaction signature
  print('\nExample of requesting a transaction signature:');

  // Create a sample Tezos operation
  final operationRequest = TezosOperationSignRequest(
    id: 'op-request-123',
    senderId: dAppClient.senderId,
    version: '3',
    origin: Connection(type: ConnectionType.p2p, id: dAppClient.senderId),
    destination:
        Connection(type: ConnectionType.p2p, id: simulatedPeer.publicKey),
    sourceAddress: 'tz1exampleAddress123456789',
    network: TezosNetwork.mainnet,
    operationDetails:
        '0x01234567890abcdef', // Hex representation of the operation
  );

  print('Operation request:');
  print('- From address: ${operationRequest.sourceAddress}');
  print('- Network: ${operationRequest.network.name}');
  print('- Operation bytes: ${operationRequest.operationDetails}');

  // In a real app with a connected wallet, you would send this request
  // and wait for a response with the signed transaction

  // Cleanup
  await subscription.cancel();
  print('\ndApp example completed.');
}

/// Example of using the Beacon SDK in a wallet.
Future<void> walletExample() async {
  print('Running wallet example...\n');

  // Initialize a wallet client
  final walletClient = await ClientFactory.createWalletClient(
    appMetadata: AppMetadata(
      blockchainIdentifier: 'tezos',
      senderId: 'example-wallet',
      name: 'Example Tezos Wallet',
      icon: 'https://tezos.com/wallet-icon.png',
    ),
  );

  print('Wallet client initialized with ID: ${walletClient.senderId}');

  // Connect to the Beacon network to listen for requests
  final messageStream = walletClient.connect();
  final subscription = messageStream.listen((message) async {
    print('\nReceived message from dApp: ${message.type}');

    if (message is PermissionRequestMessage) {
      print('Permission request from: ${message.appMetadata.name}');
      print('- Network: ${message.network.name}');
      print('- Scopes: ${message.scopes}');

      // In a real wallet, you would show a UI to the user to approve/reject
      print('\nSimulating user approval...');

      // Respond with approval
      try {
        await walletClient.respondToPermissionRequest(
          requestId: message.id,
          publicKey: 'wallet-public-key-xyz',
          address: 'tz1walletAddress123456789',
          network: message.network.type,
          scopes: message.scopes ?? [],
        );
        print('Permission granted and response sent!');
      } catch (e) {
        print('Failed to respond to permission request: $e');
      }
    } else if (message is TezosOperationSignRequest) {
      print('Operation signing request:');
      print('- From address: ${message.sourceAddress}');
      print('- Network: ${message.network.name}');
      print('- Operation bytes: ${message.operationDetails}');

      // In a real wallet, you would show transaction details to the user
      // and ask for confirmation
      print('\nSimulating user confirming transaction...');

      // For this example, we'll just print what would happen
      print('In a real wallet:');
      print('1. Decode and display operation details');
      print('2. Ask user for confirmation');
      print('3. Sign with private key if confirmed');
      print('4. Send response with signature');
    }
  });

  // Handle incoming pairing requests
  print('\nWallet is ready to pair with dApps');
  print('In a real wallet, you would scan a QR code or open a deep link');

  // For demo purposes, simulate receiving a pairing request after a delay
  await Future.delayed(Duration(seconds: 2));

  final simulatedPairingRequest = PairingMessage(
    id: 'pairing-req-123',
    type: PairingMessageType.pairingRequest,
    name: 'Example dApp',
    version: '3',
    publicKey: 'dapp-public-key-xyz',
    appUrl: 'https://example.com/dapp',
    icon: 'https://example.com/dapp/icon.png',
  );

  print('\nSimulating scanning a QR code from a dApp...');

  // Process the pairing request
  try {
    await walletClient
        .handlePairingRequest(jsonEncode(simulatedPairingRequest.toJson()));
    print('Paired with dApp: ${simulatedPairingRequest.name}');

    // In a real wallet, you would display the dApp info to the user
    // and ask for confirmation before pairing
  } catch (e) {
    print('Failed to pair with dApp: $e');
  }

  // Keep listening for a while in this example
  await Future.delayed(Duration(seconds: 5));

  // Cleanup
  await subscription.cancel();
  print('\nWallet example completed.');
}
