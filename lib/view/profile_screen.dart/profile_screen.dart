import 'dart:developer';
import 'package:dating_app/di/di.dart';
import 'package:dating_app/models/user_current_model.dart';
import 'package:dating_app/services/auth_services.dart';
import 'package:dating_app/state/auth_bloc/auth_bloc.dart';
import 'package:dating_app/state/coins_bloc/coins_bloc.dart';
import 'package:dating_app/state/lookingfor_bloc/lookingfor_bloc.dart';
import 'package:dating_app/state/user_bloc/user_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/utils/app_sizedbox.dart';
import 'package:dating_app/utils/app_string.dart';
import 'package:dating_app/view/profile_screen.dart/managers/profile_ad_manager.dart';
import 'package:dating_app/view/profile_screen.dart/widget/bio_editor_widget.dart';
import 'package:dating_app/view/profile_screen.dart/widget/interests_section.dart';
import 'package:dating_app/view/profile_screen.dart/widget/lookingfor_session.dart';
import 'package:dating_app/view/profile_screen.dart/widget/profile_loading_widget.dart';
import 'package:dating_app/view/profile_screen.dart/widget/profile_photo_grid.dart';
import 'package:dating_app/view/profile_screen.dart/widget/section_header.dart';
import 'package:dating_app/view/profile_screen.dart/widget/wallet_card_pro.dart';
import 'package:dating_app/view/widgets/lookingFor_card.dart';
import 'package:dating_app/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<dynamic> getImages = [];
  List<String> deleteImage = [];

  late final TextEditingController _bioController;
  late ValueNotifier<Set<String>> userInterests;
  late ProfileAdManager _adManager;
  final authService = di.get<AuthServices>();
  @override
  void initState() {
    super.initState();
    context.read<LookingforBloc>().add(LookingforFetchEvent());
    context.read<UserBloc>().add(GetUserProfileEvent());
    _bioController = TextEditingController(
      text:
          "Lover of sunsets, travel, and finding the best coffee shops. Looking for someone to share new adventures with!",
    );

    // Initialize ad manager
    _adManager = ProfileAdManager(
      onAdRewardGranted: _onAdRewardGranted,
      onError: (message) => flutterToast(msg: message),
    );
    _adManager.initialize();

    // Load user's coins from Firestore
    context.read<CoinsBloc>().add(GetCurrentUserCoinsEvent());
    context.read<LookingforBloc>().add(LookingforFetchDefaultEvent());
  }

  @override
  void dispose() {
    _bioController.dispose();
    _adManager.dispose();
    super.dispose();
  }

  // Callback when ad reward is granted
  void _onAdRewardGranted() {
    // Add coins using the coins service
    context.read<CoinsBloc>().add(
      AddCoinsEvent(
        coins: _adManager.coinsReward,
        userId: authService.getCurrentUser()!.uid,
      ),
    );
    // Show success message
    flutterToast(msg: "You earned ${_adManager.coinsReward} coins! 🎉");
  }

  // Handle profile save with validation
  void _handleSaveProfile(UserCurrentModel getUserModel) {
    log(_bioController.text.trim());
    log("==========");
    log(getUserModel.bio);

    final newModel = UserCurrentModel(
      bio: _bioController.text.trim(),
      images: getImages,
      userId: getUserModel.userId,
      interests: userInterests.value,
    );

    log(getUserModel.interests.toString());
    log(newModel.interests.toString());
    log("${getUserModel == newModel}");

    // Validation checks
    if (getUserModel == newModel) {
      flutterToast(msg: "No updates");
      return;
    }

    if (getImages.length < 2) {
      flutterToast(msg: "Please select minimum two images");
      return;
    }

    if (userInterests.value.length < 2) {
      flutterToast(msg: "Please select minimum two your interest");
      return;
    }

    if (_bioController.text.trim().isEmpty) {
      flutterToast(msg: "Please fill the bio");
      return;
    }

    // Call update event
    context.read<UserBloc>().add(
      UpdateUserPrfileEvent(
        userCurrentModel: newModel,
        deleteImages: deleteImage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LogoutSuccessState) {
              flutterToast(msg: AppStrings.logoutS);
              context.go("/onboarding");
            }
          },
        ),
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is FoundInappropriateState) {
              flutterToast(msg: state.msg);
            }
          },
        ),
        BlocListener<CoinsBloc, CoinsState>(
          listener: (context, state) {
            if (state is AddCoinsSuccessState) {
              // Refresh coins after successful addition
              context.read<CoinsBloc>().add(GetCurrentUserCoinsEvent());
            } else if (state is AddCoinsErrorState) {
              flutterToast(msg: "Failed to add coins: ${state.message}");
            } else if (state is GetCurrentUserCoinsErrorState) {
              flutterToast(msg: "Failed to load coins: ${state.message}");
            }
          },
        ),
      ],
      child: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is GetSuccessState) {
            getImages.clear();
            getImages.addAll(state.userProfile.getImages!);
            _bioController.text = state.userProfile.bio;
          } else if (state is UpdatedProfileState) {
            context.read<UserBloc>().add(GetUserProfileEvent());
          }
        },
        builder: (context, state) {
          if (state is GetProfileLoadingState ||
              state is UpdateProfileLoadingState) {
            return ProfileLoadingWidget(state: state);
          } else if (state is GetSuccessState) {
            //It is a current user model of diplaying in the profile screen
            UserCurrentModel getUserModel = UserCurrentModel(
              bio: _bioController.text,
              images: state.userProfile.getImages!,
              userId: state.userProfile.id,
              interests: state.userProfile.interests,
            );
            userInterests = ValueNotifier(state.userProfile.interests);
            log("rebuilding");
            return Container(
              decoration: const BoxDecoration(gradient: appGradient),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: Text(
                    'Your Profile',
                    style: GoogleFonts.poppins(
                      color: kWhite,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                      fontSize: 20,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    // IconButton(
                    //   icon: Icon(Icons.logout, color: kWhite),
                    //   onPressed: () {
                    //     showDiolog(
                    //       context: context,
                    //       title: AppStrings.logout,
                    //       content: AppStrings.logoutContent,
                    //       cancelTap: () => context.pop(),
                    //       confirmTap: () {
                    //         context.pop();
                    //         context.read<AuthBloc>().add(SignOutEvent());
                    //       },
                    //     );
                    //   },
                    // ),
                    IconButton(
                      icon: Icon(Icons.settings, color: kWhite),
                      onPressed: () {
                        context.push("/settings");
                      },
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSizedBox.h20,
                        BlocBuilder<CoinsBloc, CoinsState>(
                          builder: (context, coinsState) {
                            return WalletCardPro(
                              coins:
                                  0, // Will be updated by BlocBuilder inside WalletCardPro
                              onWatchAd: _adManager.onWatchAdButtonClicked,
                              onManage: null,
                              isLoading:
                                  coinsState is AddCoinsLoadingState ||
                                  coinsState is GetCurrentUserCoinsLoadingState,
                              isAdLoading: coinsState is AddCoinsLoadingState,
                            );
                          },
                        ),
                        AppSizedBox.h30,
                        const SectionHeader(title: "My Photos"),
                        AppSizedBox.h16,
                        ProfilePhotoGrid(
                          images: getImages,
                          onImageAdded: (image) {
                            setState(() {
                              getImages.add(image);
                            });
                          },
                          onImageRemoved: (index) {
                            setState(() {
                              if (getImages[index] is String) {
                                deleteImage.add(getImages[index]);
                              }
                              getImages.removeAt(index);
                            });
                          },
                        ),
                        AppSizedBox.h30,
                        const SectionHeader(title: "About Me"),
                        AppSizedBox.h16,
                        BioEditorWidget(
                          bioController: _bioController,
                          onChanged: (value) {},
                        ),
                        AppSizedBox.h30,
                        const SectionHeader(title: "My Interests"),
                        AppSizedBox.h16,
                        ValueListenableBuilder<Set<String>>(
                          valueListenable: userInterests,
                          builder: (context, currentSelectedInterests, child) {
                            return InterestsSection(
                              selectedInterests: currentSelectedInterests,
                              onInterestSelected: (toggledInterest) {
                                final updatedSet = Set<String>.from(
                                  currentSelectedInterests,
                                );

                                if (updatedSet.contains(toggledInterest)) {
                                  updatedSet.remove(toggledInterest);
                                } else {
                                  updatedSet.add(toggledInterest);
                                }

                                userInterests.value = updatedSet;
                                log(userInterests.value.toString());
                              },
                              allInterests: AppStrings.allInterests,
                            );
                          },
                        ),
                        AppSizedBox.h30,
                        const SectionHeader(title: "Looking For"),
                         LookingForSession(),
                       
                        AppSizedBox.h70,

                      ],
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => _handleSaveProfile(getUserModel),
                  backgroundColor: primary,
                  child: Icon(Icons.check, color: kWhite),
                ),
              ),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
    
  }
}
