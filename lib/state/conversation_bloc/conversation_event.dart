import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ConversationEvent {}

/// Tells the BLoC to start listening for messages in a specific chat room.
class LoadMessagesEvent extends ConversationEvent {
  final String chatRoomId;
  LoadMessagesEvent({required this.chatRoomId});
}

/// Tells the BLoC to send a new message.
class SendMessageEvent extends ConversationEvent {
  final String chatRoomId;
  final String messageText;
  final String senderId;

  SendMessageEvent({
    required this.chatRoomId,
    required this.messageText,
    required this.senderId,
  });
}

/// A private event the BLoC uses to update its state with new messages from the stream.
class MessagesUpdatedEvent extends ConversationEvent {
  final List<QueryDocumentSnapshot> messages;
  MessagesUpdatedEvent(this.messages);
}