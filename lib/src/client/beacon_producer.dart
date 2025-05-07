part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Interface for clients that can produce message responses on the Beacon network.
///
/// This interface is typically implemented by wallet clients that need to
/// respond to requests from dApps.
abstract class BeaconProducer extends BeaconClient {
  BeaconProducer({
    required super.appMetadata,
    required super.beaconId,
  });

  /// Responds to a permission request with an approval.
  ///
  /// This method is called when a user approves a permission request from a dApp.
  Future<void> respondToPermissionRequest({
    required String requestId,
    required String publicKey,
    required String address,
    required String network,
    List<String> scopes = const [],
  });

  /// Responds to a permission request with a rejection.
  ///
  /// This method is called when a user rejects a permission request from a dApp.
  Future<void> rejectPermissionRequest({
    required String requestId,
    String? errorMessage,
  });
}