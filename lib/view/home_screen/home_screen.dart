import 'dart:developer';
import 'package:dating_app/models/user_profile_model.dart';
import 'package:dating_app/state/home_user_bloc/home_user_bloc.dart';
import 'package:dating_app/state/user_actions_bloc/user_actions_bloc.dart';
import 'package:dating_app/state/user_bloc/user_bloc.dart' hide ErrorState;
import 'package:dating_app/utils/app_color.dart' as AppColors;
import 'package:dating_app/view/home_screen/widget/empty_profiles_widget.dart';
import 'package:dating_app/view/home_screen/widget/loading_widget.dart';
import 'package:dating_app/view/home_screen/widget/nomore_profile_widget.dart';
import 'package:dating_app/view/home_screen/widget/other_profile_details_screen.dart';
import 'package:dating_app/view/home_screen/widget/profile_card.dart';
import 'package:dating_app/view/home_screen/widget/refresh_button_widget.dart';
import 'package:dating_app/view/home_screen/widget/swipe_action_buttons.dart';
import 'package:dating_app/view/home_screen/widget/upgrade_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:swipe_cards/swipe_cards.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserProfile? accUserProfile;

  @override
  void initState() {
    super.initState();
    // Fetch users when the screen is first initialized.
    context.read<HomeUserBloc>().add(FetchHomeAllUsers());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is GetSuccessState) {
              log("User profile executed----------");

              accUserProfile = state.userProfile;
              log("looking for:::::::: ${accUserProfile!.lookingFor}");
              log("looking for============================================================================================================================");
              log(accUserProfile!.name);
            }
          },
        ),
        BlocListener<UserActionsBloc, UserActionsState>(
          listener: (context, state) async {
            if (state is SwipeLimitReachedState) {
              log('SUCCESS: SwipeLimitReachedState was detected!');
              await showUpgradeSheet(context);
              context.read<UserActionsBloc>().add(
                SwipeLimitWarningShownEvent(),
              );
              context.read<UserActionsBloc>().add(
                SwipeLimitWarningAcknowledgedEvent(),
              );
              log('Reset event dispatched.');
            }
          },
        ),
      ],
      child: Container(
        decoration: const BoxDecoration(gradient: AppColors.appGradient),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Image.asset("asset/app_icon.png", scale: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'PairUp Meet',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    fontSize: 24,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: BlocBuilder<HomeUserBloc, HomeUserState>(
            builder: (context, state) {
              if (state is FetchAllUsersLoadingState) {
                return const LoadingWidget();
              }
              if(state is ErrorState){
                //Refresh button widget-----------------------
                return RefreshButtonWidget(msg: state.msg,);
              }
              if (state is FetchAllUsersLoadedState) {
                // If user profile is not loaded yet, show loading
                if (accUserProfile == null) {
                  return const LoadingWidget();
                }

                final List<SwipeItem> swipeItems = state.userProfiles.map((
                  profile,
                ) {
                  return SwipeItem(
                    
                    content: profile,
                    likeAction: () {
                      if (accUserProfile == null) return;
                      log("Liked //${profile.name}");
                      log(accUserProfile!.name);
                      log(accUserProfile!.id);
                      // context.read<UserActionsBloc>().add(
                      //   UserLikeActionEvent(
                      //     likeUserId: profile.id,
                      //     likeUserName: profile.name,
                      //     currentUserId: accUserProfile!.id,
                      //     currentUserName: accUserProfile!.name,
                      //     image: accUserProfile!.getImages![0],
                      //   ),
                      // );
                    },
                    nopeAction: () {
                      log("Noped ${profile.name}");
                      // context.read<UserActionsBloc>().add(
                      //   UserDislikeActionEvent(dislikeUserId: profile.id),
                      // );
                    },
                    superlikeAction: () {
                      if (accUserProfile == null) return;
                      log("Superliked ${profile.name}");
                      // context.read<UserActionsBloc>().add(
                      //   SuperLikeEvent(
                      //     likeUserId: profile.id,
                      //     likeUserName: profile.name,
                      //     currentUserId: accUserProfile!.id,
                      //     currentUserName: accUserProfile!.name,
                      //     image: accUserProfile!.getImages![0],
                      //   ),
                      // );
                    },
                  );
                }).toList();

                if (swipeItems.isEmpty) {
                  return const EmptyProfilesWidget();
                }

                final MatchEngine matchEngine = MatchEngine(
                  swipeItems: swipeItems,
                );

                return Column(
                  children: [
                    Expanded(
                      child: SwipeCards(
                        matchEngine: matchEngine,
                        upSwipeAllowed: true,
                        onStackFinished: () {
                          log("Stack Finished");
                        },
                        itemBuilder: (context, i) {
                          final profile = swipeItems[i].content as UserProfile;
                          if(i==swipeItems.length-1){
                            return NomoreProfileWidget();
                          }
                          return ProfileCard(
                            profile: profile,
                            onInfoTap: () {
                              pushNewScreen(
                                context,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.slideUp,
                                withNavBar: false,
                                screen: OtherProfileDetailsScreen(
                                  index: i,
                                  userProfile: profile,
                                  matchEngine: matchEngine,
                                  accUserProfile: accUserProfile!,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    SwipeActionButtons(
                      matchEngine: matchEngine,
                      accUserProfile: accUserProfile!,
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  

}

