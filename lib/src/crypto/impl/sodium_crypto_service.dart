import 'dart:convert';
import 'dart:typed_data';

import 'package:beacon_hawkbee/beacon_hawkbee.dart';
import 'package:sodium/sodium.dart';
import 'package:uuid/uuid.dart';

/// Implementation of [CryptoService] using libsodium.
class SodiumCryptoService implements CryptoService {
  static const String _keyPairPublicKey = 'beacon_keypair_pk';
  static const String _keyPairSecretKey = 'beacon_keypair_sk';

  final Sodium _sodium;
  final Uuid _uuid;

  /// Creates a new [SodiumCryptoService] instance.
  SodiumCryptoService(this._sodium, {Uuid? uuid})
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
    final nonce = _sodium.randombytes.buf(_sodium.crypto.box.nonceBytes);
    final keyPair = await generateKeyPair();

    final encrypted = _sodium.crypto.box.easy(
      message: message,
      nonce: nonce,
      publicKey: publicKey,
      secretKey: keyPair.privateKey,
    );

    // Format: [sender's public key (32 bytes)][nonce (24 bytes)][encrypted message]
    final result =
        Uint8List(keyPair.publicKey.length + nonce.length + encrypted.length);
    result.setAll(0, keyPair.publicKey);
    result.setAll(keyPair.publicKey.length, nonce);
    result.setAll(keyPair.publicKey.length + nonce.length, encrypted);

    return result;
  }

  @override
  Future<Uint8List> decrypt(
      Uint8List encryptedMessage, Uint8List privateKey) async {
    // Extract sender's public key, nonce, and cipher text
    final senderPkLength = _sodium.crypto.box.publicKeyBytes;
    final nonceLength = _sodium.crypto.box.nonceBytes;

    if (encryptedMessage.length <= senderPkLength + nonceLength) {
      throw ArgumentError('Invalid encrypted message format');
    }

    final senderPk = encryptedMessage.sublist(0, senderPkLength);
    final nonce =
        encryptedMessage.sublist(senderPkLength, senderPkLength + nonceLength);
    final cipherText = encryptedMessage.sublist(senderPkLength + nonceLength);

    return _sodium.crypto.box.openEasy(
      cipherText: cipherText,
      nonce: nonce,
      publicKey: senderPk,
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
      return _sodium.crypto.sign.verifyDetached(
        signature: signature,
        message: message,
        publicKey: publicKey,
      );
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Uint8List> hash(Uint8List message) async {
    return _sodium.crypto.genericHash.hash(message);
  }

  @override
  Future<String> guid() async {
    return _uuid.v4();
  }

  @override
  Future<KeyPair> loadOrGenerateKeyPair(SecureStorage secureStorage) async {
    final publicKeyHex = await secureStorage.getSecure(_keyPairPublicKey);
    final privateKeyHex = await secureStorage.getSecure(_keyPairSecretKey);

    if (publicKeyHex != null && privateKeyHex != null) {
      return KeyPair.fromHex(
        publicKeyHex: publicKeyHex,
        privateKeyHex: privateKeyHex,
      );
    } else {
      // Generate new key pair
      final keyPair = await generateKeyPair();

      // Store in secure storage
      await secureStorage.saveSecure(_keyPairPublicKey, keyPair.publicKeyHex);
      await secureStorage.saveSecure(_keyPairSecretKey, keyPair.privateKeyHex);

      return keyPair;
    }
  }
}
