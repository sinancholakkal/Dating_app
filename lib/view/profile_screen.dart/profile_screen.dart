import 'dart:developer';
import 'dart:io';
import 'package:dating_app/models/user_current_model.dart';
import 'package:dating_app/models/user_profile_model.dart';
import 'package:dating_app/state/auth_bloc/auth_bloc.dart';
import 'package:dating_app/state/profile_setup_bloc/profile_setup_bloc.dart';
import 'package:dating_app/state/user_bloc/user_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/utils/app_sizedbox.dart';
import 'package:dating_app/utils/app_string.dart';
import 'package:dating_app/view/profile_setup_screen/widget/interested_setup.dart';
import 'package:dating_app/view/widgets/loading.dart';
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
  final Set<String> _userInterests = {
    'Travel',
    'Photography',
    'Music',
    'Fitness',
  };
  List<dynamic> getImages = [];
  List<String> deleteImage = [];

   
  late final TextEditingController _bioController;

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
            if(state is GetSuccessState){
              
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
              decoration: BoxDecoration(gradient: appGradient),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (state is GetSuccessState) {
            UserCurrentModel getUserModel =UserCurrentModel(bio: _bioController.text, images: state.userProfile.getImages!,userId: state.userProfile.id);
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
                      fontWeight: FontWeight.bold,
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
                        // _buildProfileHeader(
                        //   profileUrl: state.userProfile.getSelfie!,
                        //   name: state.userProfile.name
                        // ),
                        AppSizedBox.h30,
                        _buildSectionHeader("My Photos"),
                        AppSizedBox.h16,
                        _buildPhotoGrid(),
                        AppSizedBox.h30,
                        _buildSectionHeader("About Me"),
                        AppSizedBox.h16,
                        _buildBioEditor(),
                        AppSizedBox.h30,
                        // _buildSectionHeader("My Interests"),
                        // AppSizedBox.h16,
                        // _buildInterestsWrap(),
                        // AppSizedBox.h70, // Space for the FAB
                      ],
                    ),
                  ),
                ),
                floatingActionButton: ProfileUpdateButton(
                  bioController: _bioController,
                  getImages: getImages,
                  getUserModel: getUserModel,
                  deleteImages: deleteImage,
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

  Widget _buildProfileHeader({String? profileUrl, required String name}) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: kWhite.withOpacity(0.2),
            backgroundImage: profileUrl != null
                ? NetworkImage(profileUrl)
                : null,
            // backgroundImage: _userPhotos.isNotEmpty ? FileImage(_userPhotos.first) : null,
            child: profileUrl == null
                ? Icon(Icons.person, size: 60, color: kWhite)
                : null,
          ),
          AppSizedBox.h16,
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: kWhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
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
            log("This image for delete from firebase");
          }
          getImages.removeAt(state.index);
        }
      },
      builder: (context, state) {
        log(getImages.length.toString());
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
                onLongPress: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: kWhite.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),

                    border: Border.all(color: kWhite.withOpacity(0.3)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Icon(Icons.add),
                  ),
                ),
              );
            }
            return GestureDetector(
              onLongPress: () {
                log("Long press taped : Index $index");
                log(getImages.length.toString());
                showDiolog(
                  context: context,
                  title: "Remove",
                  content: "Are you sure want to remove?",
                  cancelTap: () => context.pop(),
                  confirmTap: () {
                    context.pop();
                    // setState(() {});
                    context.read<ProfileSetupBloc>().add(
                      ImageRemoveEvent(index: index),
                    );
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: kWhite.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),

                  border: Border.all(color: kWhite.withOpacity(0.3)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: (getImages[index] is String)
                      ? Image.network(getImages[index], fit: BoxFit.cover)
                      : Image.file(
                          File(getImages[index].path),
                          fit: BoxFit.cover,
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
    return TextField(
      controller: _bioController,
      maxLines: 4,
      style: GoogleFonts.poppins(color: kWhite),
      decoration: InputDecoration(
        hintText: "Write something fun...",
        hintStyle: GoogleFonts.poppins(color: kWhite54),
        filled: true,
        fillColor: kWhite.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: kWhite.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: kWhite.withOpacity(0.3)),
        ),
      ),
    );
  }

  // Widget _buildInterestsWrap() {
  //   return Wrap(
  //     spacing: 12.0,
  //     runSpacing: 12.0,
  //     children: _userInterests.map((interest) {
  //       return InterestChip(
  //         label: interest,
  //         isSelected: true,
  //         onSelected: (selected) {},
  //       );
  //     }).toList(),
  //   );
  // }
}

class ProfileUpdateButton extends StatelessWidget {
  const ProfileUpdateButton({
    super.key,
    required TextEditingController bioController,
    required this.getImages,
    required this.getUserModel,
    required this.deleteImages,
  }) : _bioController = bioController;

  final TextEditingController _bioController;
  final List getImages;
  final UserCurrentModel getUserModel;
  final List<String> deleteImages;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final newModel = UserCurrentModel(
          bio: _bioController.text.trim(),
          images: getImages,
          userId: getUserModel.userId,
        );

        log(getUserModel.images.length.toString());
        log(newModel.images.length.toString());
        log("${getUserModel == newModel}");
        if (getUserModel == newModel) {
          flutterToast(msg: "No updates");
        } else {
          //Call update event
          context.read<UserBloc>().add(
            UpdateUserPrfileEvent(
              userCurrentModel: newModel,
              deleteImages: deleteImages,
            ),
          );
        }
      },
      backgroundColor: primary, // Use your theme color
      child: Icon(Icons.check, color: kWhite),
    );
  }
}
