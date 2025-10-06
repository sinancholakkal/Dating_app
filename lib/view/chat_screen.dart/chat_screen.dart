// To represent a single message
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/models/chat_user_model.dart';
import 'package:dating_app/services/chat_service.dart';
import 'package:dating_app/state/conversation_bloc/conversation_bloc.dart';
import 'package:dating_app/state/user_bloc_and_report_bloc/user_bloc_and_report_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/chat_screen.dart/widget/bottom_sheet.dart';
import 'package:dating_app/view/conversation_screen.dart/conversation_screen.dart';
import 'package:dating_app/view/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatMessage {final String id;
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

class ChatContact {
  final String name;
  final String lastMessage;
  final String timestamp;
  final String imageUrl;

  ChatContact({
    required this.name,
    required this.lastMessage,
    required this.timestamp,
    required this.imageUrl,
  });
}

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatService = ChatService();
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      return const Scaffold(body: Center(child: Text("Please log in.")));
    }

    return Container(
      decoration: const BoxDecoration(gradient: appGradient),
      child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'Messages',
          style: GoogleFonts.poppins(
            color: kWhite,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocListener<UserBlocAndReportBloc, UserBlocAndReportState>(
        listener: (context, state) {
          // if(state is UserUnblockSuccess){
          //   log("UserUnblock success state");
          //   Navigator.pop(context);
          // }
        },
        child: StreamBuilder<List<ChatUserModel>>(
          stream: chatService.getChatsStream(currentUserId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: kWhite));
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Something went wrong.",
                  style: GoogleFonts.poppins(color: kWhite70),
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No conversations yet.",
                  style: GoogleFonts.poppins(color: kWhite70),
                ),
              );
            }

            final chatList = snapshot.data!;

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                final chat = chatList[index];
                return Opacity(
                  opacity:
                      chat.blockedBy != currentUserId &&
                          chat.blockedBy.isNotEmpty
                      ? 0.5
                      : 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      leading: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: primary.withOpacity(0.15),
                          backgroundImage: NetworkImage(chat.imageUrl),
                          onBackgroundImageError: (_, __) {},
                          child: chat.imageUrl.isEmpty ? Icon(Icons.person, color: kWhite) : null,
                        ),
                      ),
                      title: Text(
                        chat.name,
                        style: GoogleFonts.poppins(
                          color: kWhite,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: chat.lastMessage.startsWith("https://firebasestorage.googleapis.com")
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.photo_camera,
                                    color: kWhite.withOpacity(0.6),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Photo",
                                    style: GoogleFonts.poppins(
                                      color: kWhite.withOpacity(0.6),
                                      fontSize: 13,
                                    ),
                                  )
                                ],
                              )
                            : Text(
                                chat.lastMessage,
                                style: GoogleFonts.poppins(
                                  color: kWhite70,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _formatTimestamp(chat.lastMessageTimestamp),
                            style: GoogleFonts.poppins(
                              color: kWhite54,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (chat.blockedBy == currentUserId &&
                              chat.blockedBy.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                "You blocked",
                                style: GoogleFonts.poppins(
                                  color: Kred,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          if (chat.unreadCount > 0) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: primary,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: primary.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                chat.unreadCount.toString(),
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      onTap: () {
                        if (chat.blockedBy.isEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (context) =>
                                    ConversationBloc(context.read<ChatService>()),

                                child: ConversationScreen(
                                  chatRoomId: chat.chatRoomId,
                                  otherUser: chat,
                                ),
                              ),
                            ),
                          );
                        } else if (chat.blockedBy == currentUserId &&
                            chat.blockedBy.isNotEmpty) {
                          showActionSheetUnblock(
                            context,
                            chat: chat
                          );
                        } else if (chat.blockedBy != currentUserId &&
                            chat.blockedBy.isNotEmpty) {
                          log("hahhahadd");
                          flutterToast(msg: "${chat.name} has blocked you");
                        }
                      },
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            );
          },
        ),
      ),
    ));
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateToCheck = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );

    if (dateToCheck == today) {
      return DateFormat.jm().format(timestamp);
    } else if (dateToCheck == yesterday) {
      return "Yesterday";
    } else {
      return DateFormat('dd/MM/yy').format(timestamp);
    }
  }
}
