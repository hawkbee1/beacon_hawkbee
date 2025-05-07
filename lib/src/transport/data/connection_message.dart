part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// A message that is sent over a connection between peers.
class ConnectionMessage {
  /// The id of the peer that sent the message.
  final String senderId;

  /// The id of the peer that should receive the message.
  final String recipientId;

  /// The content of the message.
  final String content;

  /// The version of the message format.
  final String version;

  /// Creates a new [ConnectionMessage] instance.
  const ConnectionMessage({
    required this.senderId,
    required this.recipientId,
    required this.content,
    required this.version,
  });

  /// Creates a new ConnectionMessage instance from a JSON map.
  factory ConnectionMessage.fromJson(Map<String, dynamic> json) {
    return ConnectionMessage(
      senderId: json['senderId'] as String,
      recipientId: json['recipientId'] as String,
      content: json['content'] as String,
      version: json['version'] as String,
    );
  }

  /// Converts this ConnectionMessage to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'recipientId': recipientId,
      'content': content,
      'version': version,
    };
  }
}
