part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Represents a message sent between peers over a P2P connection.
class ConnectionMessage {
  /// Unique identifier for this message.
  final String id;

  /// The sender's public key or identifier.
  final String senderId;

  /// The recipient's public key or identifier.
  final String recipientId;

  /// The message content (typically encrypted).
  final String content;

  /// The protocol version used.
  final String version;

  /// Creates a new [ConnectionMessage] instance.
  ConnectionMessage({
    required this.id,
    required this.senderId,
    required this.recipientId,
    required this.content,
    required this.version,
  });

  /// Creates a [ConnectionMessage] instance from a JSON map.
  factory ConnectionMessage.fromJson(Map<String, dynamic> json) {
    return ConnectionMessage(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      recipientId: json['recipientId'] as String,
      content: json['content'] as String,
      version: json['version'] as String,
    );
  }

  /// Converts this message to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'recipientId': recipientId,
      'content': content,
      'version': version,
    };
  }
}
