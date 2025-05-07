import 'package:beacon_hawkbee/beacon_hawkbee.dart';
import 'package:beacon_hawkbee/src/transport/p2p/matrix/matrix_p2p_client.dart';

/// Provider for Matrix P2P clients.
class MatrixClientProvider {
  /// The homeserver URL.
  final String homeserver;

  /// Creates a new [MatrixClientProvider] instance.
  const MatrixClientProvider({
    this.homeserver = MatrixP2PClient.defaultMatrixServer,
  });

  /// Creates a new [P2PClient] instance using Matrix.
  P2PClient createClient({
    required AppMetadata appMetadata,
    required StorageManager storageManager,
  }) {
    return MatrixP2PClient(
      appMetadata: appMetadata,
      storageManager: storageManager,
      homeserver: homeserver,
    );
  }
}
