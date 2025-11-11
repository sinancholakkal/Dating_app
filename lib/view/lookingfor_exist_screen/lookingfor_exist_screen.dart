import 'dart:developer';

import 'package:dating_app/models/lookingfor_model.dart';
import 'package:dating_app/state/lookingfor_bloc/lookingfor_bloc.dart';
import 'package:dating_app/state/turn_ons_bloc/turn_ons_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/profile_setup_screen/widget/looking_for.dart';
import 'package:dating_app/view/widgets/toast.dart';
import 'package:dating_app/view/widgets/tunt_ons_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ExistLookingforScreen extends StatefulWidget {
  const ExistLookingforScreen({super.key});

  @override
  State<ExistLookingforScreen> createState() => _ExistLookingforScreenState();
}

class _ExistLookingforScreenState extends State<ExistLookingforScreen> {
  late final PageController _pageController;
  List<LookingForModel> lookingFor = [];
  List<LookingForModel> turnOns = [];
  int _currentPage = 0;

  @override
  void initState() {
    _pageController = PageController();
    context.read<LookingforBloc>().add(LookingforFetchDefaultEvent());
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  
  void _goToPage(int index) {
    setState(() => _currentPage = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LookingforBloc, LookingforState>(
      listener: (context, state) {
        if (state is LookingforAddedState) {
          context.go("/easytab");
        }
      },
      child: Container(
        decoration: BoxDecoration(gradient: appGradient),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: PageView(
              controller: _pageController,
              onPageChanged: (value) {
                // setState(() {
                //   _currentPage = value;
                // });
              },
              children: [
                LookingForStep(
                  onContinue: (lookingFor) {
                    final isTrue = lookingFor.any(
                      (element) => element.isSelected == true,
                    );
                    if (isTrue) {
                      // context.read<LookingforBloc>().add(
                      //   LookingforAddEvent(lookingFor: lookingFor),
                      // );
                      this.lookingFor = lookingFor;
                      _goToPage(1);
                    } else {
                      flutterToast(
                        msg: "Please select at least one looking for",
                      );
                    }
                  },
                ),

                TuntOnsWidget(
                  onContinue: (turnOns) {
                    this.turnOns = turnOns;
                    final isTrue = turnOns.any(
                      (element) => element.isSelected == true,
                    );
                    if (isTrue) {
                      context.read<TurnOnsBloc>().add(TurnOnsAddEvent(turnOns: turnOns));
                      context.read<LookingforBloc>().add(LookingforAddEvent(lookingFor: lookingFor));
                    } else {
                      flutterToast(
                        msg: "Please select at least one turn on",
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
