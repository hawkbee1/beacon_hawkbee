part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Represents a blockchain account.
///
/// Accounts are identified by their public key and address.
class Account {
  /// The blockchain identifier for this account.
  final String blockchainIdentifier;

  /// The account's public key.
  final String publicKey;

  /// The account's address.
  final String address;

  /// The network on which this account exists.
  final Network network;

  /// Creates a new [Account] instance.
  const Account({
    required this.blockchainIdentifier,
    required this.publicKey,
    required this.address,
    required this.network,
  });

  /// Creates a new Account instance from a JSON map.
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      blockchainIdentifier: json['blockchainIdentifier'] as String,
      publicKey: json['publicKey'] as String,
      address: json['address'] as String,
      network: Network.fromJson(json['network'] as Map<String, dynamic>),
    );
  }

  /// Converts this Account to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'blockchainIdentifier': blockchainIdentifier,
      'publicKey': publicKey,
      'address': address,
      'network': network.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Account &&
        other.blockchainIdentifier == blockchainIdentifier &&
        other.publicKey == publicKey &&
        other.address == address &&
        other.network == network;
  }

  @override
  int get hashCode {
    return blockchainIdentifier.hashCode ^
        publicKey.hashCode ^
        address.hashCode ^
        network.hashCode;
  }
}
