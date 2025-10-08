import 'dart:developer';
import 'package:dating_app/models/user_profile_model.dart';
import 'package:dating_app/state/home_user_bloc/home_user_bloc.dart';
import 'package:dating_app/state/user_actions_bloc/user_actions_bloc.dart';
import 'package:dating_app/state/user_bloc/user_bloc.dart';
import 'package:dating_app/utils/app_color.dart' as AppColors;
import 'package:dating_app/view/home_screen/widget/other_profile_details_screen.dart';
import 'package:dating_app/view/home_screen/widget/upgrade_widget.dart';
import 'package:flutter/cupertino.dart';
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
  late UserProfile accUserProfile;
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
                        'Finding amazing people...',
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

              if (state is FetchAllUsersLoadedState) {
                final List<SwipeItem> swipeItems = state.userProfiles.map((
                  profile,
                ) {
                  return SwipeItem(
                    content: profile,
                    likeAction: () {
                      log("Liked //${profile.name}");
                      log(accUserProfile.name);
                      log(accUserProfile.id);
                      context.read<UserActionsBloc>().add(
                        UserLikeActionEvent(
                          likeUserId: profile.id,
                          likeUserName: profile.name,
                          currentUserId: accUserProfile.id,
                          currentUserName: accUserProfile.name,
                          image: accUserProfile.getImages![0],
                        ),
                      );
                    },
                    nopeAction: () {
                      log("Noped ${profile.name}");
                      context.read<UserActionsBloc>().add(
                        UserDislikeActionEvent(dislikeUserId: profile.id),
                      );
                    },
                    superlikeAction: () {
                      log("Superliked ${profile.name}");
                      context.read<UserActionsBloc>().add(
                        SuperLikeEvent(
                          likeUserId: profile.id,
                          likeUserName: profile.name,
                          currentUserId: accUserProfile.id,
                          currentUserName: accUserProfile.name,
                          image: accUserProfile.getImages![0],
                        ),
                      );
                    },
                  );
                }).toList();

                if (swipeItems.isEmpty) {
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
                              Icons.favorite_border,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'No more profiles!',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Check back later for new people\nor expand your search radius',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              context.read<HomeUserBloc>().add(
                                FetchHomeAllUsers(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.2),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Text(
                              'Refresh',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
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
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Container(
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
                            onTap: () {
                              log(
                                "Noped ${matchEngine.currentItem!.content.name}",
                              );
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
                            onTap: () {
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
                            onTap: () {
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

  Widget _buildActionButton({
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

class ProfileCard extends StatefulWidget {
  final UserProfile profile;
  final VoidCallback onInfoTap;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.onInfoTap,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  int _currentPhoto = 0;

  @override
  Widget build(BuildContext context) {
    final int numberPhotos = widget.profile.getImages!.length;
    final bool hasImages = numberPhotos > 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      child: Hero(
        tag: "profile_hero_${widget.profile.id}",
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Image Container
                Container(
                  color: Colors.grey.shade800,
                  child: hasImages
                      ? Image.network(
                          widget.profile.getImages![_currentPhoto],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.grey.shade700,
                                      Colors.grey.shade800,
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.white54,
                                    size: 64,
                                  ),
                                ),
                              ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.grey.shade700,
                                Colors.grey.shade800,
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 80,
                            ),
                          ),
                        ),
                ),
                // Enhanced Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color(0xE6000000),
                        Color(0x80000000),
                        Color(0x40000000),
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.3, 0.6, 1.0],
                    ),
                  ),
                ),
                // Photo Navigation Taps
                if (hasImages && numberPhotos > 1)
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (_currentPhoto > 0) {
                              setState(() => _currentPhoto--);
                            }
                          },
                          child: Container(color: Colors.transparent),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (_currentPhoto < (numberPhotos - 1)) {
                              setState(() => _currentPhoto++);
                            }
                          },
                          child: Container(color: Colors.transparent),
                        ),
                      ),
                    ],
                  ),
                // Enhanced Photo Indicators
                if (hasImages && numberPhotos > 1)
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: List.generate(numberPhotos, (index) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 3.0,
                              ),
                              child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: _currentPhoto == index
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.4),
                                  boxShadow: _currentPhoto == index
                                      ? [
                                          BoxShadow(
                                            color: Colors.white.withOpacity(
                                              0.5,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                // Enhanced User Info
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    widget.profile.name,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.3,
                                      fontSize: 28,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.5),
                                          offset: const Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      widget.profile.age.toString(),
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (widget.profile.bio.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  widget.profile.bio,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: widget.onInfoTap,
                            icon: const Icon(
                              CupertinoIcons.info_circle_fill,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
