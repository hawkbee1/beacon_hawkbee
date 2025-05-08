part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Represents a cryptographic key pair with public and private keys.
class KeyPair {
  /// The public key.
  final Uint8List publicKey;

  /// The private key.
  final Uint8List privateKey;

  /// Creates a new [KeyPair] instance.
  const KeyPair({
    required this.publicKey,
    required this.privateKey,
  });
}
