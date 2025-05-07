import 'package:beacon_hawkbee/beacon_hawkbee.dart';

void main() async {
  // Initialize the Beacon SDK with app metadata
  final beacon = await Beacon.init(
    appMetadata: AppMetadata(
      blockchainIdentifier: 'tezos',
      senderId: 'my-dapp-sender-id',
      name: 'My Awesome dApp',
      icon: 'https://myapp.com/icon.png',
    ),
    logLevel: LogLevel.debug,
  );

  print('Beacon SDK initialized for ${beacon.appMetadata.name}');

  // Example of creating a peer manually
  final peer = Peer(
    id: 'wallet-peer-id',
    name: 'Example Wallet',
    publicKey: 'abc123def456', // In production, this would be a real public key
    version: '3',
    appUrl: 'https://examplewallet.com',
  );

  // Example of network definition
  final mainnet = Network(
    type: 'mainnet',
    name: 'Tezos Mainnet',
  );

  // Example of creating a permission request message
  final requestMessage = PermissionRequestMessage(
    id: 'req-1',
    senderId: 'my-dapp-sender-id',
    version: '3',
    origin: Connection(type: ConnectionType.p2p, id: 'dapp-connection'),
    destination: Connection(type: ConnectionType.p2p, id: peer.publicKey),
    appMetadata: beacon.appMetadata,
    network: mainnet,
    scopes: ['operation_request', 'sign'],
  );

  // In a real implementation, you would send this message to a wallet
  print('Created permission request: ${requestMessage.toJson()}');

  // Example of creating a permission response
  final responseMessage = PermissionResponseMessage(
    id: 'resp-1',
    requestId: requestMessage.id,
    senderId: peer.id,
    version: '3',
    origin: Connection(type: ConnectionType.p2p, id: peer.publicKey),
    destination: Connection(type: ConnectionType.p2p, id: 'dapp-connection'),
    publicKey: 'wallet-public-key',
    network: mainnet,
    address: 'tz1123456789abcdef',
    scopes: ['operation_request', 'sign'],
    appMetadata: AppMetadata(
      blockchainIdentifier: 'tezos',
      senderId: peer.id,
      name: 'Example Wallet',
      icon: 'https://examplewallet.com/icon.png',
    ),
  );

  // In a real implementation, this would be received from a wallet
  print('Simulated permission response: ${responseMessage.toJson()}');
}
