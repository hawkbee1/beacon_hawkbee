part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Abstract interface representing a blockchain in the Beacon protocol.
///
/// This class serves as a base for all blockchain-specific implementations
/// like Tezos, Substrate, etc.
abstract class Blockchain {
  /// The unique identifier of the blockchain.
  String get identifier;

  /// Creates an instance of a blockchain from its identifier.
  ///
  /// Throws an [ArgumentError] if no blockchain is registered for the given identifier.
  static Blockchain fromIdentifier(String identifier) {
    // This will be implemented when we add specific blockchain implementations
    throw UnimplementedError(
      'No blockchain implementation found for identifier: $identifier',
    );
  }

  /// Creates a serializer for blockchain-specific data.
  ///
  /// This method will be implemented by specific blockchain implementations.
  Map<String, dynamic> serializeData(dynamic data);

  /// Deserializes blockchain-specific data.
  ///
  /// This method will be implemented by specific blockchain implementations.
  T deserializeData<T>(Map<String, dynamic> json);
}
