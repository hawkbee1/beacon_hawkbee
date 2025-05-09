import 'dart:typed_data';

import 'package:beacon_hawkbee/beacon_hawkbee.dart';

/// Implementation of the [Blockchain] interface for Tezos.
class TezosBlockchain implements Blockchain {
  /// The unique identifier for Tezos blockchain.
  static const String blockchainIdentifier = 'tezos';

  @override
  String get identifier => blockchainIdentifier;

  /// Creates a new [TezosBlockchain] instance.
  const TezosBlockchain();

  @override
  Map<String, dynamic> serializeData(dynamic data) {
    if (data is TezosAccount) {
      return data.toJson();
    } else if (data is TezosNetwork) {
      return data.toJson();
    } else if (data is TezosPermission) {
      return data.toJson();
    } else {
      throw ArgumentError('Unsupported data type: ${data.runtimeType}');
    }
  }

  @override
  T deserializeData<T>(Map<String, dynamic> json) {
    if (T == TezosAccount) {
      return TezosAccount.fromJson(json) as T;
    } else if (T == TezosNetwork) {
      return TezosNetwork.fromJson(json) as T;
    } else if (T == TezosPermission) {
      return TezosPermission.fromJson(json) as T;
    } else {
      throw ArgumentError('Unsupported type: $T');
    }
  }
}

/// Represents a Tezos account.
class TezosAccount extends Account {
  /// Creates a new [TezosAccount] instance.
  TezosAccount({
    required super.publicKey,
    required super.address,
    required TezosNetwork network,
  }) : super(
          blockchainIdentifier: TezosBlockchain.blockchainIdentifier,
          network: network,
        );

  /// Creates a new TezosAccount instance from a JSON map.
  factory TezosAccount.fromJson(Map<String, dynamic> json) {
    return TezosAccount(
      publicKey: json['publicKey'] as String,
      address: json['address'] as String,
      network: TezosNetwork.fromJson(json['network'] as Map<String, dynamic>),
    );
  }
}

/// Represents a Tezos network.
class TezosNetwork extends Network {
  /// The RPC URL for the network.
  final String? rpcUrl;

  /// Creates a new [TezosNetwork] instance.
  const TezosNetwork({
    required super.type,
    required super.name,
    this.rpcUrl,
  }) : super(rpcUrl: rpcUrl);

  /// Creates a new TezosNetwork instance from a JSON map.
  factory TezosNetwork.fromJson(Map<String, dynamic> json) {
    return TezosNetwork(
      type: json['type'] as String,
      name: json['name'] as String,
      rpcUrl: json['rpcUrl'] as String?,
    );
  }

  /// Predefined Tezos mainnet.
  static const TezosNetwork mainnet = TezosNetwork(
    type: 'mainnet',
    name: 'Mainnet',
    rpcUrl: 'https://mainnet.api.tez.ie',
  );

  /// Predefined Tezos ghostnet testnet.
  static const TezosNetwork ghostnet = TezosNetwork(
    type: 'ghostnet',
    name: 'Ghostnet',
    rpcUrl: 'https://ghostnet.ecadinfra.com',
  );
}

/// Represents a Tezos permission.
class TezosPermission extends Permission {
  /// The allowed operation types.
  final List<String> scopes;

  /// Creates a new [TezosPermission] instance.
  const TezosPermission({
    required super.accountId,
    required super.senderId,
    required super.connectedAt,
    required this.scopes,
  }) : super(
          blockchainIdentifier: TezosBlockchain.blockchainIdentifier,
        );

  /// Creates a new TezosPermission instance from a JSON map.
  factory TezosPermission.fromJson(Map<String, dynamic> json) {
    return TezosPermission(
      accountId: json['accountId'] as String,
      senderId: json['senderId'] as String,
      connectedAt: json['connectedAt'] as int,
      scopes: (json['scopes'] as List<dynamic>).cast<String>(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['scopes'] = scopes;
    return json;
  }
}
