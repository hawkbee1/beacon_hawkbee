part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Represents the different types of signing operations.
enum SigningType {
  /// Sign raw bytes.
  raw,
  
  /// Sign a transaction operation.
  operation,
  
  /// Sign a Micheline expression.
  micheline,
  
  /// Sign data based on a specific schema.
  dataSchema,
}

/// Extension on SigningType to convert to/from strings
extension SigningTypeExtension on SigningType {
  /// Converts SigningType to a string
  String get value {
    switch (this) {
      case SigningType.raw:
        return 'raw';
      case SigningType.operation:
        return 'operation';
      case SigningType.micheline:
        return 'micheline';
      case SigningType.dataSchema:
        return 'data_schema';
    }
  }
  
  /// Creates a SigningType from a string
  static SigningType fromString(String value) {
    switch (value) {
      case 'raw':
        return SigningType.raw;
      case 'operation':
        return SigningType.operation;
      case 'micheline':
        return SigningType.micheline;
      case 'data_schema':
        return SigningType.dataSchema;
      default:
        throw ArgumentError('Unknown signing type: $value');
    }
  }
}
