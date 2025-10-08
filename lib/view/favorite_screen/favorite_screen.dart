import 'dart:developer';

import 'package:dating_app/services/user_actions_services.dart';
import 'package:dating_app/state/favorite_bloc/favorite_bloc.dart';
import 'package:dating_app/state/user_actions_bloc/user_actions_bloc.dart';
import 'package:dating_app/state/user_bloc/user_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/favorite_screen/widgets/favorite_card.dart';
import 'package:dating_app/view/home_screen/widget/upgrade_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:dating_app/models/user_profile_model.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late UserProfile accUserProfile;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is GetSuccessState) {
              log("User profile executed----------");

              accUserProfile = state.userProfile;

              log(accUserProfile.name);
            }
          },
        ),
        BlocListener<UserActionsBloc, UserActionsState>(
          listener: (context, state) async {
            if (state is SwipeLimitReachedState) {
              log('SUCCESS: SwipeLimitReachedState was detected!');
              await showUpgradeSheet(context);

              context.read<UserActionsBloc>().add(
                SwipeLimitWarningAcknowledgedEvent(),
              );
              context.read<FavoriteBloc>().add(FetchAllFavoritesEvent());
              log('Reset event dispatched.');
            }
          },
        ),
      ],
      child: Container(
        decoration: BoxDecoration(gradient: appGradient),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              "Favorites",
              style: GoogleFonts.poppins(
                color: kWhite,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: BlocConsumer<FavoriteBloc, FavoriteState>(
            listener: (context, state) {
              if (state is LocalRemoveSucessState) {
                // favoritesList.clear();
                // favoritesList = state.userProfiles;
              } else if (state is FavoriteLoadedState) {}
            },
            builder: (context, state) {
              if (state is FavoriteLoadingState) {
                return Center(child: CircularProgressIndicator(color: kWhite));
              }
              if (state is FavoriteLoadedState) {
                log("favorite loaded state emited");
                List<UserProfile> favoritesList = state.favorites;
                if (favoritesList.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.1)),
                            ),
                            child: const Icon(Icons.favorite_border, color: Colors.white, size: 36),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No favorites yet",
                            style: GoogleFonts.poppins(
                              color: kWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Tap the heart on profiles to save them here",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(color: kWhite70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                log(favoritesList.toString());
                return GridView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: favoritesList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final user = favoritesList[index];

                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          context.read<FavoriteBloc>().add(
                            FavoriteActionEvent(user: user),
                          );
                        });
                        if (direction == DismissDirection.startToEnd) {
                          // Right swipe
                          context.read<UserActionsBloc>().add(
                            UserLikeActionEvent(
                              likeUserId: user.id,
                              likeUserName: user.name,
                              currentUserId: accUserProfile.id,
                              currentUserName: accUserProfile.name,
                              image: accUserProfile.getImages![0],
                            ),
                          );
                        } else {
                          //Left swip
                          context.read<UserActionsBloc>().add(
                            UserDislikeActionEvent(dislikeUserId: user.id),
                          );
                        }
                        UserActionsServices().removeFromFavorites(favoriteUserId: user.id);
                      },

                      background: Container(
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        child: Icon(Icons.favorite, color: kWhite, size: 40),
                      ),
                      // 4. This is the background for a LEFT swipe (Dislike)
                      secondaryBackground: Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(Icons.close, color: kWhite, size: 40),
                      ),
                      child: FavoriteCard(user: user),
                    );
                  },
                );
              }
              return SizedBox();
            },
          ),
        ),
      ),
    );
  }
}

