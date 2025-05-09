part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Represents an error response message in the Beacon protocol.
class BeaconErrorResponseMessage extends BeaconMessage {
  /// The ID of the request being responded to.
  final String requestId;

  /// The error type code.
  final int errorType;

  /// The human-readable error message.
  final String errorMessage;

  /// Creates a new [BeaconErrorResponseMessage] instance.
  BeaconErrorResponseMessage({
    required String id,
    required String senderId,
    required String version,
    required Connection origin,
    required Connection destination,
    required this.requestId,
    required this.errorType,
    required this.errorMessage,
  }) : super(
          id: id,
          type: BeaconMessageType.error,
          version: version,
          senderId: senderId,
          origin: origin,
          destination: destination,
        );

  /// Creates a [BeaconErrorResponseMessage] instance from a JSON map.
  factory BeaconErrorResponseMessage.fromJson(Map<String, dynamic> json) {
    return BeaconErrorResponseMessage(
      id: json['id'] as String,
      version: json['version'] as String,
      senderId: json['senderId'] as String,
      origin: Connection.fromJson(json['origin'] as Map<String, dynamic>),
      destination:
          Connection.fromJson(json['destination'] as Map<String, dynamic>),
      requestId: json['requestId'] as String,
      errorType: json['errorType'] as int,
      errorMessage: json['errorMessage'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.value,
      'version': version,
      'senderId': senderId,
      'origin': origin.toJson(),
      'destination': destination.toJson(),
      'requestId': requestId,
      'errorType': errorType,
      'errorMessage': errorMessage,
    };
  }
}
