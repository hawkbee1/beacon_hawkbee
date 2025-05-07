part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Defines different methods of signing blockchain operations.
enum SigningType {
  /// Operation signing - for standard blockchain operations
  operation,

  /// Micheline signing - specific to Tezos michelson expressions
  micheline,

  /// Raw signing - for raw byte data
  raw,

  /// Message signing - for plain text messages
  message;

  /// Get the string representation of this signing type.
  String get stringValue {
    switch (this) {
      case SigningType.operation:
        return 'operation';
      case SigningType.micheline:
        return 'micheline';
      case SigningType.raw:
        return 'raw';
      case SigningType.message:
        return 'message';
    }
  }

  /// Create a SigningType from its string representation.
  static SigningType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'operation':
        return SigningType.operation;
      case 'micheline':
        return SigningType.micheline;
      case 'raw':
        return SigningType.raw;
      case 'message':
        return SigningType.message;
      default:
        throw ArgumentError('Unknown signing type: $value');
    }
  }
}
