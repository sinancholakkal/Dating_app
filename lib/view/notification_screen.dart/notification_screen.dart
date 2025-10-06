import 'dart:developer';
import 'package:dating_app/state/request_bloc/request_bloc.dart';
import 'package:dating_app/utils/app_color.dart'; // Your app's colors
import 'package:dating_app/view/notification_screen.dart/widget/request_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// --- Data Model (Stays the same) ---

// --- The Main Notification Screen Widget ---
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

  // --- Data Fetching Logic ---
  // Future<void> _fetchRequests() async {
  //   try {
  //     // Simulate a network call to get data
  //     await Future.delayed(const Duration(seconds: 1));
  //     final List<RequestModel> dummyRequests = [
  //       RequestModel(senderId: '1', senderName: 'Jessica', senderImageUrl: 'https://images.unsplash.com/photo-1520466809213-7b9a56adcd45?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1287&q=80', timestamp: DateTime.now().subtract(const Duration(minutes: 5))),
  //       RequestModel(senderId: '2', senderName: 'David', senderImageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1287&q=80', timestamp: DateTime.now().subtract(const Duration(hours: 2))),
  //     ];

  //     // Update the state with the fetched data
  //     setState(() {
  //       _requests = dummyRequests;
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     // Update the state with an error message
  //     setState(() {
  //       _error = "Failed to load requests.";
  //       _isLoading = false;
  //     });
  //   }
  // }

  // // --- Action Handlers ---
  // void _acceptRequest(String senderId) {
  //   log("Accepted request from $senderId");
  //   // In a real app, you would call your service here.
  //   // Then, remove the request from the list and update the UI.
  //   setState(() {
  //     _requests.removeWhere((req) => req.senderId == senderId);
  //   });
  // }

  // void _declineRequest(String senderId) {
  //   log("Declined request from $senderId");
  //   setState(() {
  //     _requests.removeWhere((req) => req.senderId == senderId);
  //   });
  // }

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

  //   Widget _buildBody() {
  //     if (_isLoading) {
  //       return  Center(child: CircularProgressIndicator(color: kWhite));
  //     }

  //     if (_error != null) {
  //       return Center(
  //         child: Text(
  //           _error!,
  //           style: const TextStyle(color: Colors.redAccent, fontSize: 16),
  //         ),
  //       );
  //     }

  //     if (_requests.isEmpty) {
  //       return  Center(
  //         child: Text(
  //           'No new requests yet.',
  //           style: TextStyle(color: kWhite70, fontSize: 16),
  //         ),
  //       );
  //     }

  //     return ListView.builder(
  //       itemCount: _requests.length,
  //       itemBuilder: (context, index) {
  //         final request = _requests[index];
  //         return RequestCard(
  //           request: request,
  //           onAccept: () => _acceptRequest(request.senderId),
  //           onDecline: () => _declineRequest(request.senderId),
  //         );
  //       },
  //     );
  //   }
  // }
}
