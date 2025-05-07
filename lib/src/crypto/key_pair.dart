part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Represents a cryptographic key pair (public and private keys).
///
/// This class is used for secure communication and message signing.
class KeyPair {
  /// The public key as bytes.
  final Uint8List publicKey;

  /// The private key as bytes.
  final Uint8List privateKey;

  /// Creates a new KeyPair with the given public and private keys.
  const KeyPair({
    required this.publicKey,
    required this.privateKey,
  });

  /// Returns the public key as a hexadecimal string.
  String get publicKeyHex => _bytesToHex(publicKey);

  /// Returns the private key as a hexadecimal string.
  String get privateKeyHex => _bytesToHex(privateKey);

  /// Helper method to convert bytes to a hexadecimal string.
  static String _bytesToHex(Uint8List bytes) {
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
  }

  /// Creates a KeyPair from hexadecimal string representations of the keys.
  factory KeyPair.fromHex({
    required String publicKeyHex,
    required String privateKeyHex,
  }) {
    return KeyPair(
      publicKey: _hexToBytes(publicKeyHex),
      privateKey: _hexToBytes(privateKeyHex),
    );
  }

  /// Helper method to convert a hexadecimal string to bytes.
  static Uint8List _hexToBytes(String hex) {
    String normalizedHex = hex.startsWith('0x') ? hex.substring(2) : hex;
    if (normalizedHex.length % 2 != 0) {
      normalizedHex = '0' + normalizedHex;
    }

    final result = Uint8List(normalizedHex.length ~/ 2);
    for (var i = 0; i < result.length; i++) {
      final hexByte = normalizedHex.substring(i * 2, i * 2 + 2);
      result[i] = int.parse(hexByte, radix: 16);
    }
    return result;
  }
}
