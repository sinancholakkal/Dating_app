import 'dart:developer';
import 'package:dating_app/models/user_profile_model.dart';
import 'package:dating_app/state/home_user_bloc/home_user_bloc.dart';
import 'package:dating_app/state/user_actions_bloc/user_actions_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipe_cards/swipe_cards.dart';

class SwipeActionButtons extends StatelessWidget {
  final MatchEngine matchEngine;
  final UserProfile accUserProfile;

  const SwipeActionButtons({
    super.key,
    required this.matchEngine,
    required this.accUserProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            context: context,
            onTap: () {
              context.read<HomeUserBloc>().add(
                FetchHomeAllUsers(),
              );
            },
            asset: 'assets/icons/back.png',
            color: const Color(0xFFFFA726),
            label: 'Refresh',
          ),
          _buildActionButton(
            context: context,
            onTap: () {
              if (matchEngine.currentItem == null) return;
              log(
                "Noped ${matchEngine.currentItem!.content.name}",
              );
              matchEngine.currentItem?.nope();
              context.read<UserActionsBloc>().add(
                UserDislikeActionEvent(
                  dislikeUserId:
                      matchEngine.currentItem!.content.id,
                ),
              );
            },
            asset: 'assets/icons/clear.png',
            color: const Color(0xFFEF5350),
            isLarge: true,
            label: 'Pass',
          ),
          _buildActionButton(
            context: context,
            onTap: () {
              if (matchEngine.currentItem == null) return;
              matchEngine.currentItem?.superLike();
              context.read<UserActionsBloc>().add(
                SuperLikeEvent(
                  likeUserId:
                      matchEngine.currentItem!.content.id,
                  likeUserName:
                      matchEngine.currentItem!.content.name,
                  currentUserId: accUserProfile.id,
                  currentUserName: accUserProfile.name,
                  image: accUserProfile.getImages![0],
                ),
              );
            },
            asset: 'assets/icons/star.png',
            color: const Color(0xFF42A5F5),
            label: 'Super',
          ),
          _buildActionButton(
            context: context,
            onTap: () {
              if (matchEngine.currentItem == null) return;
              matchEngine.currentItem?.like();
              context.read<UserActionsBloc>().add(
                UserLikeActionEvent(
                  likeUserId:
                      matchEngine.currentItem!.content.id,
                  likeUserName:
                      matchEngine.currentItem!.content.name,
                  currentUserId: accUserProfile.id,
                  currentUserName: accUserProfile.name,
                  image: accUserProfile.getImages![0],
                ),
              );
            },
            asset: 'assets/icons/heart.png',
            color: const Color(0xFF66BB6A),
            isLarge: true,
            label: 'Like',
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required VoidCallback onTap,
    required String asset,
    required Color color,
    bool isLarge = false,
    String? label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(100),
            onTap: onTap,
            child: Container(
              height: isLarge ? 56 : 48,
              width: isLarge ? 56 : 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
                ),
                border: Border.all(color: color.withOpacity(0.4), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(isLarge ? 14.0 : 10.0),
                  child: Image.asset(asset, color: color, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

