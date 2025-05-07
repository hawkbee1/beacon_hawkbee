part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Represents a blockchain network.
///
/// Networks define the specific blockchain environment (mainnet, testnet, etc.)
class Network {
  /// The type of network (e.g., mainnet, testnet).
  final String type;

  /// The name of the network.
  final String name;

  /// The RPC URL for the network.
  final String? rpcUrl;

  /// Creates a new [Network] instance.
  const Network({required this.type, required this.name, this.rpcUrl});

  /// Creates a new Network instance from a JSON map.
  factory Network.fromJson(Map<String, dynamic> json) {
    return Network(
      type: json['type'] as String,
      name: json['name'] as String,
      rpcUrl: json['rpcUrl'] as String?,
    );
  }

  /// Converts this Network to a JSON map.
  Map<String, dynamic> toJson() {
    return {'type': type, 'name': name, if (rpcUrl != null) 'rpcUrl': rpcUrl};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Network &&
        other.type == type &&
        other.name == name &&
        other.rpcUrl == rpcUrl;
  }

  @override
  int get hashCode => type.hashCode ^ name.hashCode ^ (rpcUrl?.hashCode ?? 0);
}
