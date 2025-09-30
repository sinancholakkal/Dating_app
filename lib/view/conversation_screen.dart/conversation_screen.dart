import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/models/chat_user_model.dart';
import 'package:dating_app/services/auth_services.dart';
import 'package:dating_app/services/chat_service.dart';
import 'package:dating_app/state/conversation_bloc/conversation_bloc.dart';
import 'package:dating_app/state/conversation_bloc/conversation_event.dart';
import 'package:dating_app/state/conversation_bloc/conversation_state.dart';
import 'package:dating_app/state/user_bloc_and_report_bloc/user_bloc_and_report_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/conversation_screen.dart/widget/drop_down_widget.dart';
import 'package:dating_app/view/conversation_screen.dart/widget/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final ChatUserModel otherUser;

  const ConversationScreen({
    super.key,
    required this.chatRoomId,
    required this.otherUser,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  late final TextEditingController _messageController;
  Timer? _typingTimer;
  final _chatService = ChatService();
  void _onTextChanged({required String value, required String currentUserId}) {
    if (_typingTimer?.isActive ?? false) _typingTimer?.cancel();

    _chatService.updateUserTypingStatus(
      chatRoomId: widget.chatRoomId,
      userId: currentUserId,
      isTyping: true,
    );

    _typingTimer = Timer(const Duration(seconds: 2), () {
      _chatService.updateUserTypingStatus(
        chatRoomId: widget.chatRoomId,
        userId: currentUserId,
        isTyping: false,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _chatService.markChatAsRead(
      chatRoomId: widget.chatRoomId,
      currentUserId: AuthService().getCurrentUser()!.uid,
    );
    context.read<ConversationBloc>().add(
      LoadMessagesEvent(chatRoomId: widget.chatRoomId),
    );
  }

  @override
  void dispose() {
    _chatService.markChatAsRead(
      chatRoomId: widget.chatRoomId,
      currentUserId: AuthService().getCurrentUser()!.uid,
    );
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      context.read<ConversationBloc>().add(
        SendMessageEvent(
          recipientId: widget.otherUser.otherUserId,
          chatRoomId: widget.chatRoomId,
          messageText: _messageController.text.trim(),
          senderId: FirebaseAuth.instance.currentUser!.uid,
        ),
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return BlocListener<UserBlocAndReportBloc, UserBlocAndReportState>(
      listener: (context, state) {
       if(state is UserBlocSuccess){
        log("Success fully blocked and navigated to chatlist Screen");
        Navigator.pop(context);
       }
      },
      child: Container(
        decoration: const BoxDecoration(gradient: appGradient),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: kWhite),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.otherUser.name,
                  style: GoogleFonts.poppins(
                    color: kWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .doc(widget.chatRoomId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      final typingUsers = List<String>.from(
                        data['typingUsers'] ?? [],
                      );
                      if (typingUsers.contains(widget.otherUser.otherUserId)) {
                        return Text(
                          'is typing...',
                          style: TextStyle(color: kWhite70, fontSize: 17),
                        );
                      }
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
            //DropDown Action-------
            actions: [DropDownWidget(chatUserModel: widget.otherUser)],
          ),
          body: Column(
            children: [
              Expanded(
                child: BlocBuilder<ConversationBloc, ConversationState>(
                  builder: (context, state) {
                    if (state is ConversationLoading) {
                      return Center(
                        child: CircularProgressIndicator(color: kWhite),
                      );
                    }
                    if (state is ConversationLoaded) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        reverse: true,
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final messageDoc = state.messages[index];
                          final messageData =
                              messageDoc.data() as Map<String, dynamic>;
                          final bool isMe =
                              messageData['senderId'] == currentUserId;
                          return MessageBubble(
                            isMe: isMe,
                            text: messageData['text'],
                          );
                        },
                      );
                    }
                    return Center(
                      child: Text(
                        "No messages yet.",
                        style: TextStyle(color: kWhite),
                      ),
                    );
                  },
                ),
              ),
              _buildMessageInputField(
                (value) =>
                    _onTextChanged(value: value, currentUserId: currentUserId),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInputField(ValueChanged<String> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(color: bgcard.withOpacity(0.5)),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: onChanged,
                controller: _messageController,
                style: GoogleFonts.poppins(color: kWhite),
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: GoogleFonts.poppins(color: kWhite70),
                  filled: true,
                  fillColor: kWhite.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: Icon(Icons.send, color: kWhite),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
