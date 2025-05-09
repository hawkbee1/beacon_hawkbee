import 'package:beacon_hawkbee/beacon_hawkbee.dart';
import 'package:beacon_hawkbee/src/blockchain/tezos/tezos_blockchain.dart';

/// Message type for Tezos operations.
enum TezosOperationType {
  /// Request for permissions to connect
  permission,

  /// Request to sign a transaction
  operation,

  /// Request to sign arbitrary data
  signPayload,

  /// Response to a request
  response,
}

/// Base class for all Tezos operation requests.
abstract class TezosOperationRequest extends BeaconMessage {
  /// Creates a new [TezosOperationRequest] instance.
  TezosOperationRequest({
    required super.id,
    required super.senderId,
    required super.version,
    required super.origin,
    required super.destination,
    required super.type,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.value,
      'version': version,
      'senderId': senderId,
      'origin': origin.toJson(),
      'destination': destination.toJson(),
    };
  }
}

/// Request to sign a Tezos operation.
class TezosOperationSignRequest extends TezosOperationRequest {
  /// The source account address.
  final String sourceAddress;

  /// The network on which to perform the operation.
  final TezosNetwork network;

  /// The operation to sign in hex format.
  final String operationDetails;

  /// Creates a new [TezosOperationSignRequest] instance.
  TezosOperationSignRequest({
    required super.id,
    required super.senderId,
    required super.version,
    required super.origin,
    required super.destination,
    required this.sourceAddress,
    required this.network,
    required this.operationDetails,
  }) : super(type: BeaconMessageType.operationRequest);

  /// Creates a new TezosOperationSignRequest instance from a JSON map.
  factory TezosOperationSignRequest.fromJson(Map<String, dynamic> json) {
    return TezosOperationSignRequest(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      version: json['version'] as String,
      origin: Connection.fromJson(json['origin'] as Map<String, dynamic>),
      destination:
          Connection.fromJson(json['destination'] as Map<String, dynamic>),
      sourceAddress: json['sourceAddress'] as String,
      network: TezosNetwork.fromJson(json['network'] as Map<String, dynamic>),
      operationDetails: json['operationDetails'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'sourceAddress': sourceAddress,
      'network': network.toJson(),
      'operationDetails': operationDetails,
    });
    return json;
  }
}

/// Request to sign arbitrary payload in Tezos.
class TezosSignPayloadRequest extends TezosOperationRequest {
  /// The source account address.
  final String sourceAddress;

  /// The payload to sign.
  final String payload;

  /// The signing type.
  final SigningType signingType;

  /// Creates a new [TezosSignPayloadRequest] instance.
  TezosSignPayloadRequest({
    required super.id,
    required super.senderId,
    required super.version,
    required super.origin,
    required super.destination,
    required this.sourceAddress,
    required this.payload,
    required this.signingType,
  }) : super(type: BeaconMessageType.signRequest);

  /// Creates a new TezosSignPayloadRequest instance from a JSON map.
  factory TezosSignPayloadRequest.fromJson(Map<String, dynamic> json) {
    return TezosSignPayloadRequest(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      version: json['version'] as String,
      origin: Connection.fromJson(json['origin'] as Map<String, dynamic>),
      destination:
          Connection.fromJson(json['destination'] as Map<String, dynamic>),
      sourceAddress: json['sourceAddress'] as String,
      payload: json['payload'] as String,
      signingType:
          SigningTypeExtension.fromString(json['signingType'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'sourceAddress': sourceAddress,
      'payload': payload,
      'signingType': signingType.value,
    });
    return json;
  }
}

/// Response for a Tezos operation sign request.
class TezosOperationResponse extends BeaconMessage {
  /// ID of the request this is responding to.
  final String requestId;

  /// The signed transaction hash.
  final String transactionHash;

  /// Creates a new [TezosOperationResponse] instance.
  TezosOperationResponse({
    required super.id,
    required super.senderId,
    required super.version,
    required super.origin,
    required super.destination,
    required this.requestId,
    required this.transactionHash,
  }) : super(type: BeaconMessageType.operationResponse);

  /// Creates a new TezosOperationResponse instance from a JSON map.
  factory TezosOperationResponse.fromJson(Map<String, dynamic> json) {
    return TezosOperationResponse(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      version: json['version'] as String,
      origin: Connection.fromJson(json['origin'] as Map<String, dynamic>),
      destination:
          Connection.fromJson(json['destination'] as Map<String, dynamic>),
      requestId: json['requestId'] as String,
      transactionHash: json['transactionHash'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'requestId': requestId,
      'transactionHash': transactionHash,
    });
    return json;
  }
}
