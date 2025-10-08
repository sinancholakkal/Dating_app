import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isSentByMe;
  final Timestamp timestamp;
  final Map<String, dynamic> reactions;

  ChatMessage({
    required this.text,
    required this.isSentByMe,
    required this.timestamp,
    this.reactions = const {},
    required this.id,
  });
}

