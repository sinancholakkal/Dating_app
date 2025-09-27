import 'dart:io';
import 'package:dating_app/state/auth_bloc/auth_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/utils/app_sizedbox.dart';
import 'package:dating_app/utils/app_string.dart';
import 'package:dating_app/view/profile_setup_screen/widget/interested_setup.dart';
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
  // --- MOCK DATA ---
  // In a real app, this data would come from your User model via a BLoC state
  final String _userName = "Jessica, 24";
  final List<File> _userPhotos = [];
  final Set<String> _userInterests = {
    'Travel',
    'Photography',
    'Music',
    'Fitness',
  };
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(
      text:
          "Lover of sunsets, travel, and finding the best coffee shops. Looking for someone to share new adventures with!",
    );
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
       if(state is LogoutSuccessState){
              flutterToast(msg: AppStrings.logoutS);
              context.go("/onboarding");
            }
      },
      child: Container(
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
                  _buildProfileHeader(),
                  AppSizedBox.h30,
                  _buildSectionHeader("My Photos"),
                  AppSizedBox.h16,
                  _buildPhotoGrid(),
                  AppSizedBox.h30,
                  _buildSectionHeader("About Me"),
                  AppSizedBox.h16,
                  _buildBioEditor(),
                  AppSizedBox.h30,
                  _buildSectionHeader("My Interests"),
                  AppSizedBox.h16,
                  _buildInterestsWrap(),
                  AppSizedBox.h70, // Space for the FAB
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              /* Save profile changes */
            },
            backgroundColor: primary, // Use your theme color
            child: Icon(Icons.check, color: kWhite),
          ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDER METHODS ---

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: kWhite.withOpacity(0.2),
            // backgroundImage: _userPhotos.isNotEmpty ? FileImage(_userPhotos.first) : null,
            child: Icon(Icons.person, size: 60, color: kWhite),
          ),
          AppSizedBox.h16,
          Text(
            _userName,
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: kWhite.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kWhite.withOpacity(0.3)),
          ),
          child: Icon(Icons.add, color: kWhite54, size: 40),
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

  Widget _buildInterestsWrap() {
    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: _userInterests.map((interest) {
        return InterestChip(
          label: interest,
          isSelected: true, // Display only, not selectable on this screen
          onSelected: (selected) {},
        );
      }).toList(),
    );
  }
}
