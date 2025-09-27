import 'package:dating_app/services/auth_services.dart';
import 'package:dating_app/state/auth_bloc/auth_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    context.read<AuthBloc>().add(CheckLoginStatusEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: appGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccessNavigateToHome) {
            context.go("/easytab");
          } else if (state is AuthNoFountState) {
            context.go("/onboarding");
          }else if(state is AuthSuccessNavigateToProfileSetup){
            context.go("/profilesetup");
          }
        },
          
          child: Center(
            child: Text("Loading"),
          ),
        ),
      ),
    );
  }
}
