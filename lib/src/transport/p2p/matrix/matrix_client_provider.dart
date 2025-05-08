import 'package:beacon_hawkbee/beacon_hawkbee.dart';

/// Provider class for creating Matrix P2P clients.
class MatrixClientProvider {
  /// The Matrix homeserver URL.
  final String matrixNode;

  /// Creates a new [MatrixClientProvider] instance.
  MatrixClientProvider({
    this.matrixNode = MatrixP2PClient.defaultMatrixServer,
  });

  /// Creates a Matrix P2P client for the given app metadata and storage.
  P2PClient createClient({
    required AppMetadata appMetadata,
    required StorageManager storageManager,
  }) {
    return MatrixP2PClient(
      appMetadata: appMetadata,
      storageManager: storageManager,
      homeserver: matrixNode,
    );
  }
}
