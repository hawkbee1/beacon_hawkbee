import 'dart:typed_data';
import 'dart:convert';

import 'package:beacon_hawkbee/beacon_hawkbee.dart';
import 'package:sodium/sodium.dart';
import 'package:uuid/uuid.dart';

/// Implementation of [CryptoService] using libsodium.
class SodiumCryptoService implements CryptoService {
  /// The sodium instance.
  final Sodium _sodium;

  /// UUID generator.
  final Uuid _uuid;

  /// Storage keys for cryptographic material.
  static const String _publicKeyStorageKey = 'beacon_sodium_public_key';
  static const String _privateKeyStorageKey = 'beacon_sodium_private_key';

  /// Creates a new [SodiumCryptoService] instance.
  SodiumCryptoService(this._sodium, [Uuid? uuid])
      : _uuid = uuid ?? const Uuid();

  @override
  Future<KeyPair> generateKeyPair() async {
    final keyPair = _sodium.crypto.box.keyPair();

    return KeyPair(
      publicKey: keyPair.publicKey,
      privateKey: keyPair.secretKey,
    );
  }

  @override
  Future<Uint8List> encrypt(Uint8List message, Uint8List publicKey) async {
    final nonce = _generateNonce();
    final keyPair = await generateKeyPair();

    final encryptedMessage = _sodium.crypto.box.easy(
      message: message,
      nonce: nonce,
      publicKey: publicKey,
      secretKey: keyPair.privateKey,
    );

    // Combine nonce and encrypted message (first 24 bytes are the nonce)
    final result = Uint8List(nonce.length + encryptedMessage.length);
    result.setAll(0, nonce);
    result.setAll(nonce.length, encryptedMessage);

    return result;
  }

  @override
  Future<Uint8List> decrypt(
      Uint8List encryptedMessage, Uint8List privateKey) async {
    // Extract nonce (first 24 bytes)
    final nonce = encryptedMessage.sublist(0, _sodium.crypto.box.nonceBytes);
    final ciphertext = encryptedMessage.sublist(_sodium.crypto.box.nonceBytes);

    final publicKey = _sodium.crypto.box.extractPublicKey(privateKey);

    return _sodium.crypto.box.openEasy(
      cipherText: ciphertext,
      nonce: nonce,
      publicKey: publicKey,
      secretKey: privateKey,
    );
  }

  @override
  Future<Uint8List> sign(Uint8List message, Uint8List privateKey) async {
    return _sodium.crypto.sign
        .detached(message: message, secretKey: privateKey);
  }

  @override
  Future<bool> verify(
      Uint8List message, Uint8List signature, Uint8List publicKey) async {
    try {
      _sodium.crypto.sign.verifyDetached(
        signature: signature,
        message: message,
        publicKey: publicKey,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Uint8List> hash(Uint8List message) async {
    return _sodium.crypto.genericHash.hash(
      message: message,
      outLen: 32, // 32 bytes (256 bits) hash
    );
  }

  @override
  Future<String> guid() async {
    return _uuid.v4();
  }

  @override
  Future<KeyPair> loadOrGenerateKeyPair(SecureStorage secureStorage) async {
    final storedPublicKey = await secureStorage.getSecure(_publicKeyStorageKey);
    final storedPrivateKey =
        await secureStorage.getSecure(_privateKeyStorageKey);

    if (storedPublicKey != null && storedPrivateKey != null) {
      // Convert stored hex strings to bytes
      final publicKey = _hexToBytes(storedPublicKey);
      final privateKey = _hexToBytes(storedPrivateKey);

      return KeyPair(publicKey: publicKey, privateKey: privateKey);
    }

    // Generate a new key pair if none exists
    final newKeyPair = await generateKeyPair();

    // Store the new key pair
    await secureStorage.saveSecure(
        _publicKeyStorageKey, _bytesToHex(newKeyPair.publicKey));
    await secureStorage.saveSecure(
        _privateKeyStorageKey, _bytesToHex(newKeyPair.privateKey));

    return newKeyPair;
  }

  // Helper methods

  Uint8List _generateNonce() {
    return _sodium.randombytes.buf(_sodium.crypto.box.nonceBytes);
  }

  String _bytesToHex(Uint8List bytes) {
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
  }

  Uint8List _hexToBytes(String hex) {
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
