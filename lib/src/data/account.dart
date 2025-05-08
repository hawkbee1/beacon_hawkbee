part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Represents a blockchain account.
class Account {
  /// The account's address.
  final String address;

  /// The network this account belongs to.
  final Network network;

  /// The public key of this account.
  final String? publicKey;

  /// The account's threshold for multi-signature operations.
  final int? threshold;

  /// The unique identifier for this account (combination of address and network)
  String get accountId => '${network.type}:${network.name}:$address';

  /// Creates a new [Account] instance.
  Account({
    required this.address,
    required this.network,
    this.publicKey,
    this.threshold,
  });

  /// Creates an [Account] instance from a JSON map.
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      address: json['address'] as String,
      network: Network.fromJson(json['network'] as Map<String, dynamic>),
      publicKey: json['publicKey'] as String?,
      threshold: json['threshold'] as int?,
    );
  }

  /// Converts this account to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'network': network.toJson(),
      if (publicKey != null) 'publicKey': publicKey,
      if (threshold != null) 'threshold': threshold,
    };
  }
}
