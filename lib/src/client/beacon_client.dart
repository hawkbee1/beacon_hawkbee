part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Abstract base class for different Beacon client types.
///
/// This class provides common functionality for dApp clients and wallet clients.
abstract class BeaconClient {
  /// The application metadata.
  final AppMetadata appMetadata;

  /// The unique identifier of this client instance.
  final String beaconId;

  /// The sender ID derived from the client's public key.
  late final String senderId;

  /// Creates a new [BeaconClient] instance.
  BeaconClient({required this.appMetadata, required this.beaconId});

  /// Connects with known peers and subscribes to incoming messages.
  ///
  /// Returns a stream of received messages or errors.
  Stream<BeaconMessage> connect();

  /// Adds new peers.
  ///
  /// The new peers will be persisted and subscribed to.
  Future<void> addPeers(List<Peer> peers);

  /// Returns a list of known peers.
  Future<List<Peer>> getPeers();

  /// Removes the specified peers.
  ///
  /// The removed peers will be unsubscribed.
  Future<void> removePeers(List<Peer> peers);

  /// Removes all known peers.
  Future<void> removeAllPeers();

  /// Returns a list of granted permissions.
  Future<List<Permission>> getPermissions();

  /// Returns the permission granted for the specified account identifier.
  Future<Permission?> getPermissionsFor(String accountIdentifier);

  /// Removes permissions granted for the specified account identifiers.
  Future<void> removePermissionsFor(List<String> accountIdentifiers);

  /// Removes the specified permissions.
  Future<void> removePermissions(List<Permission> permissions);

  /// Removes all granted permissions.
  Future<void> removeAllPermissions();

  /// Serializes the pairing message to a String.
  String serializePairingData(dynamic pairingMessage);

  /// Deserializes the serialized payload to a specific pairing message.
  T deserializePairingData<T>(String serialized);

  /// Sends a message to a peer.
  ///
  /// If [isTerminal] is true, the connection will be closed after sending.
  Future<void> send(BeaconMessage message, {bool isTerminal = false});
}
