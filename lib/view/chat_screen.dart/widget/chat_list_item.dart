import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/models/chat_user_model.dart';
import 'package:dating_app/services/chat_service.dart';
import 'package:dating_app/state/conversation_bloc/conversation_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/chat_screen.dart/widget/bottom_sheet.dart';
import 'package:dating_app/view/conversation_screen.dart/conversation_screen.dart';
import 'package:dating_app/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatListItem extends StatelessWidget {
  final ChatUserModel chat;
  final String currentUserId;

  const ChatListItem({
    super.key,
    required this.chat,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: chat.blockedBy != currentUserId && chat.blockedBy.isNotEmpty
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              backgroundImage: CachedNetworkImageProvider(chat.imageUrl,),
              onBackgroundImageError: (_, __) {},
              child: chat.imageUrl.isEmpty
                  ? Icon(Icons.person, color: kWhite)
                  : null,
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
            child: chat.lastMessage
                    .startsWith("https://firebasestorage.googleapis.com")
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
              if (chat.blockedBy == currentUserId && chat.blockedBy.isNotEmpty)
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              showActionSheetUnblock(context, chat: chat);
            } else if (chat.blockedBy != currentUserId &&
                chat.blockedBy.isNotEmpty) {
              log("User has blocked you");
              flutterToast(msg: "${chat.name} has blocked you");
            }
          },
        ),
      ),
    );
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

