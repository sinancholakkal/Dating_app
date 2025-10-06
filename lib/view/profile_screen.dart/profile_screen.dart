import 'dart:developer';
import 'dart:io';
import 'package:dating_app/models/user_current_model.dart';
import 'package:dating_app/state/auth_bloc/auth_bloc.dart';
import 'package:dating_app/state/profile_setup_bloc/profile_setup_bloc.dart';
import 'package:dating_app/state/user_bloc/user_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/utils/app_sizedbox.dart';
import 'package:dating_app/utils/app_string.dart';
import 'package:dating_app/view/profile_screen.dart/widget/privacy_button.dart';
import 'package:dating_app/view/profile_screen.dart/widget/wallet_card_pro.dart';
import 'package:dating_app/view/widgets/show_diolog.dart';
import 'package:dating_app/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

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

  @override
  void initState() {
    super.initState();

    context.read<UserBloc>().add(GetUserProfileEvent());
    _bioController = TextEditingController(
      text:
          "Lover of sunsets, travel, and finding the best coffee shops. Looking for someone to share new adventures with!",
    );
  }

  bool isLoading = false;

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
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
            if (state is GetSuccessState) {}
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
              decoration: BoxDecoration(gradient: appGradient),
              child: Center(child: CircularProgressIndicator()),
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
                        WalletCardPro(
                          coins: 0,
                          onWatchAd: () {
                            // TODO: trigger rewarded ad flow, then +5 coins
                          },
                          onManage: null,
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
                        _buildBioEditor(),
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
                                child: Icon(
                                  Icons.add,
                                  color: kWhite,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add Photo',
                                style: GoogleFonts.poppins(
                                  color: kWhite,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
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
                              errorBuilder: (context, error, stackTrace) => Center(
                                child: Icon(Icons.broken_image, color: kWhite54, size: 32),
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

  Widget _buildBioEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _bioController,
          maxLines: 4,
          maxLength: 200,
          onChanged: (_) => setState(() {}),
          style: GoogleFonts.poppins(color: kWhite, height: 1.5),
          decoration: InputDecoration(
            hintText: "Write something fun...",
            hintStyle: GoogleFonts.poppins(color: kWhite54),
            filled: true,
            fillColor: kWhite.withOpacity(0.06),
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: kWhite.withOpacity(0.12)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: kWhite.withOpacity(0.12)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: primary, width: 1.2),
            ),
            counterText: "",
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Share hobbies, vibes, and what you're into",
              style: GoogleFonts.poppins(color: kWhite54, fontSize: 12),
            ),
            Text(
              "${_bioController.text.length}/200",
              style: GoogleFonts.poppins(color: kWhite70, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

}

class InterestSelectionWrap extends StatelessWidget {
  final Set<String> selectedInterests;
  final ValueChanged<String>
  onInterestSelected; // Callback for when an interest is toggled
  final List<String>
  allInterests; // Pass all interests, or rely on AppStrings.allInterests

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
          backgroundColor: isSelected ? primary.withOpacity(0.9) : const Color(0xFF23262B),
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

// Thin divider used below section headers for a professional look
Widget _buildSectionDivider() {
  return Container(
    margin: const EdgeInsets.only(top: 8),
    height: 1,
    width: double.infinity,
    color: kWhite.withOpacity(0.08),
  );
}
