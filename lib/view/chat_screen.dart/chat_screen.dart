// To represent a single message
import 'package:dating_app/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatMessage {
  final String text;
  final bool isSentByMe;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isSentByMe,
    required this.timestamp,
  });
}

// To represent a contact in the chat list
class ChatContact {
  final String name;
  final String lastMessage;
  final String timestamp;
  final String imageUrl; // URL for the profile picture

  ChatContact({
    required this.name,
    required this.lastMessage,
    required this.timestamp,
    required this.imageUrl,
  });
}



class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  // --- MOCK DATA ---
  final List<ChatContact> _chatContacts = [
    ChatContact(name: "Priya", lastMessage: "See you then! 😊", timestamp: "10:42 PM", imageUrl: "https://example.com/priya.jpg"),
    ChatContact(name: "Rohan", lastMessage: "Haha, that's hilarious.", timestamp: "8:15 PM", imageUrl: "https://example.com/rohan.jpg"),
    ChatContact(name: "Aisha", lastMessage: "I'll check it out, thanks!", timestamp: "Yesterday", imageUrl: "https://example.com/aisha.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: appGradient
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Use your dark theme background
        appBar: AppBar(
          title: Text('Chats', style: GoogleFonts.poppins(color: kWhite, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView.separated(
          itemCount: _chatContacts.length,
          itemBuilder: (context, index) {
            final contact = _chatContacts[index];
            return ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: primary.withOpacity(0.5),
              backgroundImage: AssetImage("asset/girl_image.webp"),
                // backgroundImage: NetworkImage(contact.imageUrl),
              ),
              title: Text(contact.name, style: GoogleFonts.poppins(color: kWhite, fontWeight: FontWeight.bold)),
              subtitle: Text(contact.lastMessage, style: GoogleFonts.poppins(color: kWhite70)),
              trailing: Text(contact.timestamp, style: GoogleFonts.poppins(color: kWhite54, fontSize: 12)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConversationScreen(contact: contact),
                  ),
                );
              },
            );
          },
          separatorBuilder: (context, index) => Divider(color: kWhite.withOpacity(0.1), indent: 80),
        ),
      ),
    );
  }
}



class ConversationScreen extends StatefulWidget {
  final ChatContact contact;
  const ConversationScreen({super.key, required this.contact});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  late final TextEditingController _messageController;
  // --- MOCK DATA ---
  final List<ChatMessage> _messages = [
    ChatMessage(text: "Hey, how's it going?", isSentByMe: false, timestamp: DateTime.now().subtract(const Duration(minutes: 5))),
    ChatMessage(text: "Pretty good! Just finished a workout. You?", isSentByMe: true, timestamp: DateTime.now().subtract(const Duration(minutes: 4))),
    ChatMessage(text: "Nice! I'm just relaxing. So, I was thinking about that new cafe we talked about.", isSentByMe: false, timestamp: DateTime.now().subtract(const Duration(minutes: 3))),
    ChatMessage(text: "Oh yeah! We should definitely go this weekend.", isSentByMe: true, timestamp: DateTime.now()),
  ];
  
  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: appGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
               CircleAvatar(backgroundColor: kWhite, radius: 20),
              const SizedBox(width: 12),
              Text(widget.contact.name, style: GoogleFonts.poppins(color: kWhite, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                reverse: true, // Shows latest messages at the bottom
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages.reversed.toList()[index];
                  return _MessageBubble(message: message);
                },
              ),
            ),
            _buildMessageInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(color: bgcard.withOpacity(0.5)),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                style: GoogleFonts.poppins(color: kWhite),
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: GoogleFonts.poppins(color: kWhite70),
                  filled: true,
                  fillColor: kWhite.withOpacity(0.1),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon:  Icon(Icons.send, color: kWhite),
              onPressed: () { /* Send message logic */ },
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isSentByMe;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isMe ? primary : kWhite.withOpacity(0.2),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isMe ? const Radius.circular(20) : const Radius.circular(4),
            bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(20),
          ),
        ),
        child: Text(message.text, style: GoogleFonts.poppins(color: kWhite)),
      ),
    );
  }
}