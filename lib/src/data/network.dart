part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Represents a blockchain network.
class Network {
  /// The type of blockchain (e.g., "tezos").
  final String type;

  /// The network's name (e.g., "mainnet", "ghostnet").
  final String name;

  /// The RPC URL for this network.
  final String rpcUrl;

  /// Creates a new [Network] instance.
  Network({
    required this.type,
    required this.name,
    required this.rpcUrl,
  });

  /// Creates a [Network] instance from a JSON map.
  factory Network.fromJson(Map<String, dynamic> json) {
    return Network(
      type: json['type'] as String,
      name: json['name'] as String,
      rpcUrl: json['rpcUrl'] as String,
    );
  }

  /// Converts this network to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': name,
      'rpcUrl': rpcUrl,
    };
  }

  /// Returns a predefined mainnet network for Tezos.
  static Network tezosMainnet() {
    return Network(
      type: 'tezos',
      name: 'mainnet',
      rpcUrl: 'https://mainnet.api.tez.ie',
    );
  }

  /// Returns a predefined testnet network for Tezos (Ghostnet).
  static Network tezosGhostnet() {
    return Network(
      type: 'tezos',
      name: 'ghostnet',
      rpcUrl: 'https://ghostnet.smartpy.io',
    );
  }
}
