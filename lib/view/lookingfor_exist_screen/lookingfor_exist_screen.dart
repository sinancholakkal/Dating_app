import 'dart:developer';

import 'package:dating_app/state/lookingfor_bloc/lookingfor_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/profile_setup_screen/widget/looking_for.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ExistLookingforScreen extends StatefulWidget {
  const ExistLookingforScreen({super.key});

  @override
  State<ExistLookingforScreen> createState() => _ExistLookingforScreenState();
}

class _ExistLookingforScreenState extends State<ExistLookingforScreen> {
  @override
  void initState() {
    context.read<LookingforBloc>().add(LookingforFetchDefaultEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<LookingforBloc, LookingforState>(
      listener: (context, state) {
        if(state is LookingforAddedState){
          context.go("/easytab");
        }
      },
      child: Container(
      decoration: BoxDecoration(gradient: appGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: LookingForStep(onContinue: (lookingFor) {
            context.read<LookingforBloc>().add(LookingforAddEvent(lookingFor: lookingFor));
          },),
        ),
      ),
    ));
  }
}