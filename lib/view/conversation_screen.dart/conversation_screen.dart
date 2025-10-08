import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:dating_app/view/conversation_screen.dart/widget/drop_down_widget.dart';
import 'package:dating_app/view/conversation_screen.dart/widget/message_bubble.dart';
import 'package:dating_app/view/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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

  Future<void> deleteMessage({required String chatRoomId}) async {
    if (await ModerationServices().checkContentModeration(
          text: _messageController.text.trim(),
        ) ==
        "YES") {
          flutterToast(msg: "Message is moderated");
      ChatService().deleteMessageById(
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: widget.otherUser.imageUrl.isNotEmpty
                        ? Image.network(
                            widget.otherUser.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: Colors.grey.shade700,
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                          )
                        : Container(
                            color: Colors.grey.shade700,
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.otherUser.name,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                          fontSize: 18,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
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
                            if (typingUsers.contains(
                              widget.otherUser.otherUserId,
                            )) {
                              return Row(
                                children: [
                                  SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'typing...',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              );
                            }
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: DropDownWidget(chatUserModel: widget.otherUser),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: BlocBuilder<ConversationBloc, ConversationState>(
                  builder: (context, state) {
                    if (state is ConversationLoading) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeWidth: 3,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Loading messages...',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
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
                                chatService: _chatService,
                              ),
                            ],
                          );
                        },
                      );
                    }
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.all(32),
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.chat_bubble_outline,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Start the conversation!',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Send a message to ${widget.otherUser.name}\nto begin your chat',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.white.withOpacity(0.7),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Type below to get started',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
    XFile? xFile;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.15), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
        builder: (context, state) {
          if (state is ChatImageUploadState) {
            xFile = state.pickedFile;
          } else if (state is ClearedImageState) {
            xFile = null;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Image preview
              if (xFile != null)
                _buildImagePreview(
                  xFile: xFile!,
                  cancelOnTap: () {
                    log("canceled image");
                    context.read<ProfileSetupBloc>().add(ClearImageEvent());
                  },
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8.0,
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 22,
                          ),
                          onPressed: () => showImageSourceActionSheet(
                            context,
                            bloc: context.read<ProfileSetupBloc>(),
                          ),
                        ),
                      ),
                      if (xFile != null) Spacer(),
                      if (xFile == null)
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: TextField(
                              onChanged: onChanged,
                              controller: _messageController,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: "Type a message...",
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 16,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide(
                                    color: primary,
                                    width: 2,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [primary, primary.withOpacity(0.8)],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primary.withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () => sendMessage(xfile: xFile),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
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

//Image preview widget----------
Widget _buildImagePreview({
  required XFile xFile,
  required void Function()? cancelOnTap,
}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
    child: Stack(
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(File(xFile.path), fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: cancelOnTap,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

void showImageSourceActionSheet(
  BuildContext context, {
  required ProfileSetupBloc bloc,
}) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            bloc.add(ImagePickEvent(source: ImageSource.camera));
          },
          child: const Text('Camera'),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            bloc.add(ImagePickEvent(source: ImageSource.gallery));
          },
          child: const Text('Photo Gallery'),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: true,
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
    ),
  );
}
