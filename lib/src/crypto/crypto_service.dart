part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Service for handling cryptographic operations in the Beacon SDK.
///
/// This includes key generation, encryption, decryption, and hashing.
abstract class CryptoService {
  /// Generates a new cryptographic key pair.
  Future<KeyPair> generateKeyPair();

  /// Encrypts a message using the recipient's public key.
  Future<Uint8List> encrypt(Uint8List message, Uint8List publicKey);

  /// Decrypts a message using the recipient's private key.
  Future<Uint8List> decrypt(Uint8List encryptedMessage, Uint8List privateKey);

  /// Signs a message using the private key.
  Future<Uint8List> sign(Uint8List message, Uint8List privateKey);

  /// Verifies a signature using the public key.
  Future<bool> verify(
      Uint8List message, Uint8List signature, Uint8List publicKey);

  /// Generates a hash of the message.
  Future<Uint8List> hash(Uint8List message);

  /// Generates a unique identifier based on the input.
  Future<String> guid();

  /// Loads a key pair from secure storage or generates a new one if not found.
  Future<KeyPair> loadOrGenerateKeyPair(SecureStorage secureStorage);
}
