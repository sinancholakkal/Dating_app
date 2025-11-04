import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/di/di.dart';
import 'package:dating_app/models/chat_user_model.dart';
import 'package:dating_app/services/auth_services.dart';
import 'package:dating_app/services/chat_service.dart';
import 'package:dating_app/services/moderation_services.dart';
import 'package:dating_app/state/conversation_bloc/conversation_bloc.dart';
import 'package:dating_app/state/conversation_bloc/conversation_event.dart';
import 'package:dating_app/state/conversation_bloc/conversation_state.dart';
import 'package:dating_app/state/profile_setup_bloc/profile_setup_bloc.dart';
import 'package:dating_app/state/user_bloc_and_report_bloc/user_bloc_and_report_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/conversation_screen.dart/widget/conversation_app_bar.dart';
import 'package:dating_app/view/conversation_screen.dart/widget/conversation_empty_widget.dart';
import 'package:dating_app/view/conversation_screen.dart/widget/conversation_loading_widget.dart';
import 'package:dating_app/view/conversation_screen.dart/widget/message_bubble.dart';
import 'package:dating_app/view/conversation_screen.dart/widget/message_input_field.dart';
import 'package:dating_app/view/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

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
  String lastMessageId = '';
  final chatService = di.get<ChatServices>();
    final authService = di.get<AuthServices>();
  void _onTextChanged({required String value, required String currentUserId}) {
    if (_typingTimer?.isActive ?? false) _typingTimer?.cancel();

    chatService.updateUserTypingStatus(
      chatRoomId: widget.chatRoomId,
      userId: currentUserId,
      isTyping: true,
    );

    _typingTimer = Timer(const Duration(seconds: 2), () {
      chatService.updateUserTypingStatus(
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
    chatService.markChatAsRead(
      chatRoomId: widget.chatRoomId,
      currentUserId: authService.getCurrentUser()!.uid,
    );
    context.read<ConversationBloc>().add(
      LoadMessagesEvent(chatRoomId: widget.chatRoomId),
    );
  }

  @override
  void dispose() {
    chatService.markChatAsRead(
      chatRoomId: widget.chatRoomId,
      currentUserId: authService.getCurrentUser()!.uid,
    );
    _messageController.dispose();
    super.dispose();
  }

  Future<void> deleteMessage({required String chatRoomId}) async {
    if (await ModerationServices().checkContentModeration(
          text: _messageController.text.trim(),
        ) ==
        "YES") {
          flutterToast(msg: "Message is moderated");
      chatService.deleteMessageById(
        chatRoomId: chatRoomId,
        messageId: lastMessageId,
      );
    }
  }



  void sendMessage({required XFile? xfile}) async {
    log("sendMessage onTap called");
    deleteMessage(chatRoomId: widget.chatRoomId);
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
    } else if (xfile != null) {
      log("Image upload bloc called");
      context.read<ProfileSetupBloc>().add(ClearImageEvent());
      context.read<ConversationBloc>().add(
        SendImageEvent(
          chatRoomId: widget.chatRoomId,
          image: xfile,
          senderId: FirebaseAuth.instance.currentUser!.uid,
          recipientId: widget.otherUser.otherUserId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return BlocListener<UserBlocAndReportBloc, UserBlocAndReportState>(
      listener: (context, state) {
        if (state is UserBlockSuccess) {
          log("Success fully blocked and navigated to chatlist Screen");
          Navigator.pop(context);
        }
      },
      child: Container(
        decoration: const BoxDecoration(gradient: appGradient),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: ConversationAppBar(
            otherUser: widget.otherUser,
            chatRoomId: widget.chatRoomId,
          ),
          body: Column(
            children: [
              Expanded(
                child: BlocBuilder<ConversationBloc, ConversationState>(
                  builder: (context, state) {
                    if (state is ConversationLoading) {
                      return const ConversationLoadingWidget();
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
                          final Timestamp? ts = messageData['timestamp'];
                          final DateTime? messageTime = ts?.toDate();

                          // Show a day divider when day changes (accounting for reverse list)
                          Widget? divider;
                          if (messageTime != null) {
                            final DateTime now = DateTime.now();
                            final int difference = now
                                .difference(messageTime)
                                .inMilliseconds;
                            if (difference.abs() <= 1500) {
                              log(
                                "Message is very recent (within 1.5 seconds)",
                              );
                              lastMessageId = messageDoc.id;
                              log(lastMessageId);
                            }
                            final prevIndex = index + 1;
                            final bool showDivider;
                            if (prevIndex >= state.messages.length) {
                              showDivider = true; // top-most (latest) message
                            } else {
                              final prevData =
                                  state.messages[prevIndex].data()
                                      as Map<String, dynamic>;
                              final Timestamp? prevTs = prevData['timestamp'];
                              final DateTime? prevTime = prevTs?.toDate();
                              showDivider = prevTime == null
                                  ? false
                                  : !_isSameDay(messageTime, prevTime);
                            }
                            if (showDivider) {
                              divider = _DayDivider(
                                label: _formatDayLabel(messageTime),
                              );
                            }
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (divider != null) ...[
                                divider,
                                const SizedBox(height: 8),
                              ],
                              MessageBubble(
                                messageId: messageDoc.id,
                                senderId: messageData['senderId'],
                                isMe: isMe,
                                text: messageData['text'],
                                reactions: messageData['reactions'] ?? {},
                                currentUserId: currentUserId,
                                chatRoomId: widget.chatRoomId,
                                chatService: chatService,
                              ),
                            ],
                          );
                        },
                      );
                    }
                    return ConversationEmptyWidget(
                      otherUserName: widget.otherUser.name,
                    );
                  },
                ),
              ),
              MessageInputField(
                messageController: _messageController,
                onChanged: (value) =>
                    _onTextChanged(value: value, currentUserId: currentUserId),
                onSendMessage: (xFile) => sendMessage(xfile: xFile),
              ),
            ],
          ),
        ),
      ),
    );
  }


  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatDayLabel(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateOnly = DateTime(time.year, time.month, time.day);
    if (dateOnly == today) return "Today";
    if (dateOnly == yesterday) return "Yesterday";
    return "${dateOnly.day.toString().padLeft(2, '0')}/${dateOnly.month.toString().padLeft(2, '0')}/${dateOnly.year.toString().substring(2)}";
  }
}

class _DayDivider extends StatelessWidget {
  final String label;
  const _DayDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.white.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.white.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
