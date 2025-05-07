part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Interface for clients that can consume messages from the Beacon network.
///
/// This interface is typically implemented by dApp clients that need to
/// receive responses from wallets.
abstract class BeaconConsumer extends BeaconClient {
  BeaconConsumer({required super.appMetadata, required super.beaconId});

  /// Requests permissions from a wallet.
  ///
  /// Returns a [Future] that completes with the granted permission
  /// or fails with an error if the request is rejected.
  Future<Permission> requestPermissions({
    String? selectedAccount,
    String? network,
    List<String>? scopes,
  });
}
