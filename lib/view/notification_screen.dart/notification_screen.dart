import 'dart:developer';
import 'package:dating_app/state/request_bloc/request_bloc.dart';
import 'package:dating_app/utils/app_color.dart'; // Your app's colors
import 'package:dating_app/view/notification_screen.dart/widget/request_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: appGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Requests',
            style: GoogleFonts.poppins(
              color: kWhite, 
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              fontSize: 20,
            ),
          ),
        ),
        body: BlocBuilder<RequestBloc, RequestState>(
          builder: (context, state) {
            if (state is FetchLoadingState) {
              return Center(
                child: CircularProgressIndicator(
                  color: kWhite,
                  strokeWidth: 3,
                ),
              );
            } else if (state is EmptyRequestState) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Icon(
                        Icons.notifications_none,
                        color: Colors.white.withOpacity(0.6),
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "No requests yet",
                      style: GoogleFonts.poppins(
                        color: kWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "When someone wants to connect with you, you'll see it here",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: kWhite70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is FetchLoadedState) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: state.requests.length,
                itemBuilder: (context, index) {
                  final request = state.requests[index];
                  return RequestCard(
                    request: request,
                    onAccept: () {
                      context.read<RequestBloc>().add(AcceptRequestEvent(request: request));
                    },
                    onDecline: () {
                      log("Decline event called");
                      context.read<RequestBloc>().add(DeclineRequestEvent(request: request));
                    },
                  );
                },
              );
            }
            return Center(
              child: Text(
                "Please try again later!",
                style: GoogleFonts.poppins(
                  color: kWhite70,
                  fontSize: 16,
                ),
              ),
            );
            
          },
        ),
      ),
    );
  }


}
