import 'package:dating_app/state/profile_setup_bloc/profile_setup_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/utils/app_color.dart' as AppColors;
import 'package:dating_app/view/profile_setup_screen/widget/details_setup.dart';
import 'package:dating_app/view/profile_setup_screen/widget/photos_setp.dart';
import 'package:dating_app/view/widgets/app_genderchip.dart';
import 'package:dating_app/view/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  late final PageController _pageController;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  //Gender _selectedGender = Gender.none;
  ValueNotifier<Gender> selectedGender = ValueNotifier(Gender.none);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: appGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: kWhite),

          title: BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
            builder: (context, state) {
              if (state is ProfileSetUpNextPage) {
                _currentPage = state.currentPage;
              }
              return LinearProgressIndicator(
                value: (_currentPage + 1) / 2,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              );
            },
          ),
        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ValueListenableBuilder(
              valueListenable: selectedGender,
              builder: (context, genderNoti, child) {
                //Detailse setup widget session----
                return DetailsStep(
                  onContinue: () => context.read<ProfileSetupBloc>().add(
                    ContinueTappedEvent(
                      pageController: _pageController,
                      currentPage: _currentPage++,
                    ),
                  ),
                  nameController: _nameController,
                  ageController: _ageController,
                  selectedGender: genderNoti,
                  onGenderSelected: (gender) {
                    selectedGender.value = gender;
                  },
                );
              },
            ),

            PhotosStep(
              onContinue: () => context.read<ProfileSetupBloc>().add(
                ContinueTappedEvent(
                  pageController: _pageController,
                  currentPage: _currentPage,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



enum Gender { none, woman, man }
