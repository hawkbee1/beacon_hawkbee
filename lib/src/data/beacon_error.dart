part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Represents errors that can occur in the Beacon protocol.
class BeaconError implements Exception {
  /// The error code.
  final int code;

  /// The error description.
  final String description;

  /// Optional additional error details.
  final Map<String, dynamic>? data;

  /// Creates a new [BeaconError] instance.
  const BeaconError({required this.code, required this.description, this.data});

  /// Common error codes in the Beacon protocol
  static const int unknownError = 0;
  static const int abortedError = 1;
  static const int networkNotSupportedError = 2;
  static const int notGrantedError = 3;
  static const int transactionInvalidError = 4;
  static const int tooManyOperationsError = 5;
  static const int broadcastError = 6;
  static const int messageNotSupportedError = 7;
  static const int pairingError = 8;

  /// Create an unknown error
  factory BeaconError.unknown([String message = 'An unknown error occurred']) {
    return BeaconError(code: unknownError, description: message);
  }

  /// Create an aborted error
  factory BeaconError.aborted([String message = 'Operation aborted']) {
    return BeaconError(code: abortedError, description: message);
  }

  /// Create a network not supported error
  factory BeaconError.networkNotSupported([
    String message = 'Network not supported',
  ]) {
    return BeaconError(code: networkNotSupportedError, description: message);
  }

  /// Creates a new BeaconError instance from a JSON map.
  factory BeaconError.fromJson(Map<String, dynamic> json) {
    return BeaconError(
      code: json['code'] as int,
      description: json['description'] as String,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  /// Converts this BeaconError to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'description': description,
      if (data != null) 'data': data,
    };
  }

  @override
  String toString() {
    return 'BeaconError: [$code] $description';
  }
}
