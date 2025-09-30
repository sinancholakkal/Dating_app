class ChatUserModel {
  final String chatRoomId;
  final String otherUserId;
  final String name;
  final String imageUrl;
  final String lastMessage;
  final DateTime lastMessageTimestamp;

  ChatUserModel({
    required this.chatRoomId,
    required this.otherUserId,
    required this.name,
    required this.imageUrl,
    required this.lastMessage,
    required this.lastMessageTimestamp,
  });
}