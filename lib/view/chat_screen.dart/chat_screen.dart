import 'package:dating_app/models/chat_user_model.dart';
import 'package:dating_app/services/chat_service.dart';
import 'package:dating_app/state/user_bloc_and_report_bloc/user_bloc_and_report_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/chat_screen.dart/widget/chat_empty_widget.dart';
import 'package:dating_app/view/chat_screen.dart/widget/chat_error_widget.dart';
import 'package:dating_app/view/chat_screen.dart/widget/chat_list_item.dart';
import 'package:dating_app/view/chat_screen.dart/widget/chat_loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
            // Handle state changes if needed
          },
          child: StreamBuilder<List<ChatUserModel>>(
            stream: chatService.getChatsStream(currentUserId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ChatLoadingWidget();
              }

              if (snapshot.hasError) {
                return const ChatErrorWidget();
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const ChatEmptyWidget();
              }

              final chatList = snapshot.data!;

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  return ChatListItem(
                    chat: chatList[index],
                    currentUserId: currentUserId,
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 12),
              );
            },
          ),
        ),
      ),
    );
  }
}
