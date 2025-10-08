import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:dating_app/models/user_current_model.dart';
import 'package:dating_app/services/auth_services.dart';
import 'package:dating_app/state/auth_bloc/auth_bloc.dart';
import 'package:dating_app/state/coins_bloc/coins_bloc.dart';
import 'package:dating_app/state/profile_setup_bloc/profile_setup_bloc.dart';
import 'package:dating_app/state/user_bloc/user_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/utils/app_sizedbox.dart';
import 'package:dating_app/utils/app_string.dart';
import 'package:dating_app/view/profile_screen.dart/widget/bio_editor_widget.dart';
import 'package:dating_app/view/profile_screen.dart/widget/privacy_button.dart';
import 'package:dating_app/view/profile_screen.dart/widget/wallet_card_pro.dart';
import 'package:dating_app/view/widgets/show_diolog.dart';
import 'package:dating_app/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Set<String> updatedSet = {};

  // Ad watching variables
  InterstitialAd? _interstitialAd;
  Timer? _timer;
  late ValueNotifier<int> _timeLeft;
  late ValueNotifier<int> _walletCoins;
  static const int _walletAdType = 4;

  @override
  void initState() {
    super.initState();

    context.read<UserBloc>().add(GetUserProfileEvent());
    _bioController = TextEditingController(
      text:
          "Lover of sunsets, travel, and finding the best coffee shops. Looking for someone to share new adventures with!",
    );
    
    // Initialize ValueNotifiers
    _timeLeft = ValueNotifier<int>(0);
    _walletCoins = ValueNotifier<int>(0);
    
    _initAdTimer();
    _loadInterstitialAd();
    
    // Load user's coins from Firestore
    context.read<CoinsBloc>().add( GetCurrentUserCoinsEvent());
  }

  bool isLoading = false;

  @override
  void dispose() {
    _bioController.dispose();
    _interstitialAd?.dispose();
    _timer?.cancel();
    _timeLeft.dispose();
    _walletCoins.dispose();
    super.dispose();
  }

  // Ad watching methods
  Future<void> _initAdTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    const int cooldownDuration = 60; // 60 seconds cooldown

    int? timestamp = prefs.getInt('wallet_timestamp$_walletAdType');
    if (timestamp != null) {
      int elapsedSeconds = (currentTime - timestamp) ~/ 1000;
      if (elapsedSeconds < cooldownDuration) {
        _timeLeft.value = cooldownDuration - elapsedSeconds;
        _startAdTimer(timestamp);
      } else {
        await prefs.remove('wallet_timestamp$_walletAdType');
      }
    }
  }

  void _startAdTimer(int startTime) {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? storedTimestamp = prefs.getInt('wallet_timestamp$_walletAdType');
      const int cooldownDuration = 60;

      if (storedTimestamp == null || storedTimestamp != startTime) {
        timer.cancel();
        _timeLeft.value = 0;
        return;
      }

      int currentTime = DateTime.now().millisecondsSinceEpoch;
      int elapsedSeconds = (currentTime - storedTimestamp) ~/ 1000;
      int remainingTime = cooldownDuration - elapsedSeconds;

      if (remainingTime <= 0) {
        timer.cancel();
        await prefs.remove('wallet_timestamp$_walletAdType');
        _timeLeft.value = 0;
        _loadInterstitialAd();
      } else {
        _timeLeft.value = remainingTime;
      }
    });
  }

  void _loadInterstitialAd() {
    String adUnitId = 'ca-app-pub-6236667985806581/7882906249'; // Your wallet ad unit ID

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          log('Wallet InterstitialAd loaded for adType $_walletAdType.');
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          log('Wallet InterstitialAd failed to load: $error');
          _interstitialAd?.dispose();
          _interstitialAd = null;
        },
      ),
    );
  }

  Future<void> _onWatchAdButtonClicked() async {
    if (_timeLeft.value > 0) {
      flutterToast(msg: "Ad is on cooldown. Please wait ${_timeLeft.value} seconds.");
      return;
    }

    if (_interstitialAd == null) {
      log('Wallet InterstitialAd not loaded. Attempting to load...');
      _loadInterstitialAd();
      flutterToast(msg: "Ad not ready yet. Please try again in a moment.");
      return;
    }

    // Show the ad
    _interstitialAd?.show();
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) async {
        log('Wallet Ad dismissed for adType $_walletAdType.');
        ad.dispose();
        
        // Start cooldown timer
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int currentTime = DateTime.now().millisecondsSinceEpoch;
        await prefs.setInt('wallet_timestamp$_walletAdType', currentTime);
        
        _timeLeft.value = 60;
        
        _startAdTimer(currentTime);
        
        // Add coins using the coins service
        context.read<CoinsBloc>().add( AddCoinsEvent(coins: 5,userId: AuthService().getCurrentUser()!.uid));
        
        // Show success message
        flutterToast(msg: "You earned 5 coins! 🎉");
        
        _interstitialAd = null;
        _loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        log('Wallet Ad failed to show: $error');
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitialAd();
        
        flutterToast(msg: "Failed to show ad. Please try again.");
      },
      onAdImpression: (ad) => log('Wallet Ad impression recorded.'),
      onAdShowedFullScreenContent: (ad) => log('Wallet Ad showed full screen content.'),
      onAdWillDismissFullScreenContent: (ad) => log('Wallet Ad will dismiss full screen content.'),
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
              flutterToast(msg: "Coins added successfully! 🎉");
            } else if (state is AddCoinsErrorState) {
              flutterToast(msg: "Failed to add coins: ${state.message}");
            } else if (state is GetCurrentUserCoinsSuccessState) {
              // Update wallet coins when successfully loaded
              _walletCoins.value = state.coins;
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
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(gradient: appGradient),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 3,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            state is GetProfileLoadingState 
                                ? 'Loading your profile...' 
                                : 'Updating profile...',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state is GetProfileLoadingState 
                                ? 'Getting your information ready' 
                                : 'Saving your changes',
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Please wait...',
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is GetSuccessState) {
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
                    IconButton(
                      icon: Icon(Icons.logout, color: kWhite),
                      onPressed: () {
                        showDiolog(
                          context: context,
                          title: AppStrings.logout,
                          content: AppStrings.logoutContent,
                          cancelTap: () => context.pop(),
                          confirmTap: () {
                            context.pop();
                            context.read<AuthBloc>().add(SignOutEvent());
                          },
                        );
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
                            return ValueListenableBuilder<int>(
                              valueListenable: _walletCoins,
                              builder: (context, coins, child) {
                                return WalletCardPro(
                                  coins: coins,
                                  onWatchAd: _onWatchAdButtonClicked,
                                  onManage: null,
                                  isLoading: coinsState is AddCoinsLoadingState || 
                                           coinsState is GetCurrentUserCoinsLoadingState,
                                  isAdLoading: coinsState is AddCoinsLoadingState,
                                );
                              },
                            );
                          },
                        ),
                        AppSizedBox.h30,
                        _buildSectionHeader("My Photos"),
                        _buildSectionDivider(),
                        AppSizedBox.h16,
                        _buildPhotoGrid(),
                        AppSizedBox.h30,
                        _buildSectionHeader("About Me"),
                        _buildSectionDivider(),
                        AppSizedBox.h16,
                        BioEditorWidget(
                          bioController: _bioController,
                          onChanged: (value) {},
                        ),
                        AppSizedBox.h30,
                        _buildSectionHeader("My Interests"),
                        _buildSectionDivider(),
                        AppSizedBox.h16,

                        ValueListenableBuilder<Set<String>>(
                          valueListenable: userInterests,
                          builder: (context, currentSelectedInterests, child) {
                            return InterestSelectionWrap(
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
                        AppSizedBox.h70, // Space for the FAB
                        buildPrivacyPolicyLink(context),
                        AppSizedBox.h70,
                      ],
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
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
                    if (getUserModel == newModel) {
                      flutterToast(msg: "No updates");
                    } else if (getImages.length < 2) {
                      flutterToast(msg: "Please select minimum two images");
                    } else if (userInterests.value.length < 2) {
                      flutterToast(
                        msg: "Please select minimum two your interest",
                      );
                    }else if(_bioController.text.trim().isEmpty){
                      flutterToast(msg: "Please fill the bio");

                    } else {
                      //Call update event
                      context.read<UserBloc>().add(
                        UpdateUserPrfileEvent(
                          userCurrentModel: newModel,
                          deleteImages: deleteImage,
                        ),
                      );
                    }
                  },
                  backgroundColor: primary, // Use your theme color
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

  // --- WIDGET BUILDER METHODS ---

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        color: kWhite,
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return BlocConsumer<ProfileSetupBloc, ProfileSetupState>(
      listener: (context, state) {
        if (state is ImageUploadedState) {
          getImages.add(state.pickedFile);
        } else if (state is ImageRemovedState) {
          //getImages = state.images;
          if (getImages[state.index] is String) {
            deleteImage.add(getImages[state.index]);
          }
          getImages.removeAt(state.index);
        }
      },
      builder: (context, state) {
        // Removed noisy log
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: getImages.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            if (index == getImages.length) {
              return GestureDetector(
                onTap: () {
                  context.read<ProfileSetupBloc>().add(
                    SelfieImageUploadEvent(source: ImageSource.gallery),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: kWhite.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kWhite.withOpacity(0.12)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.04),
                                Colors.white.withOpacity(0.02),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.add, color: kWhite, size: 22),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add Photo',
                                style: GoogleFonts.poppins(
                                  color: kWhite,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return GestureDetector(
              onLongPress: () {
                showDiolog(
                  context: context,
                  title: "Remove",
                  content: "Are you sure want to remove?",
                  cancelTap: () => context.pop(),
                  confirmTap: () {
                    context.pop();
                    context.read<ProfileSetupBloc>().add(
                      ImageRemoveEvent(index: index),
                    );
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: kWhite.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kWhite.withOpacity(0.12)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      (getImages[index] is String)
                          ? Image.network(
                              getImages[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: kWhite54,
                                      size: 32,
                                    ),
                                  ),
                            )
                          : Image.file(
                              File(getImages[index].path),
                              fit: BoxFit.cover,
                            ),
                      // Bottom gradient overlay
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 36,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Color(0x99000000), Color(0x00000000)],
                            ),
                          ),
                        ),
                      ),
                      // Subtle camera icon
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.photo,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class InterestSelectionWrap extends StatelessWidget {
  final Set<String> selectedInterests;
  final ValueChanged<String>
  onInterestSelected; 
  final List<String>
  allInterests; 

  const InterestSelectionWrap({
    super.key,
    required this.selectedInterests,
    required this.onInterestSelected,
    required this.allInterests,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: allInterests.map((interest) {
        final bool isSelected = selectedInterests.contains(interest);
        return ChoiceChip(
          label: Text(
            interest,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
          selected: isSelected,
          onSelected: (_) => onInterestSelected(interest),
          backgroundColor: isSelected
              ? primary.withOpacity(0.9)
              : const Color(0xFF23262B),
          selectedColor: primary.withOpacity(0.9),
          pressElevation: 0,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isSelected ? Colors.transparent : kWhite.withOpacity(0.30),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
        );
      }).toList(),
    );
  }
}

Widget _buildSectionDivider() {
  return Container(
    margin: const EdgeInsets.only(top: 8),
    height: 1,
    width: double.infinity,
    color: kWhite.withOpacity(0.08),
  );
}
