


import 'package:dating_app/view/home_screen/persistent_nav.dart';
import 'package:dating_app/view/auth_landing_screen/auth_landing_screen.dart';
import 'package:dating_app/view/email_auth_screen/email_auth_screen.dart';
import 'package:dating_app/view/home_screen/home_screen.dart';
import 'package:dating_app/view/lookingfor_exist_screen/lookingfor_exist_screen.dart';
import 'package:dating_app/view/phone_otp_screen/phone_otp_screen.dart';
import 'package:dating_app/view/profile_setup_screen/profile_setup_screen.dart';
import 'package:dating_app/view/screen_onboarding/screen_onboarding.dart';
import 'package:dating_app/view/screen_spash.dart';
import 'package:dating_app/view/sensitive_togle_screen/sensitive_togle_screen.dart';
import 'package:dating_app/view/settings_screen/settings_screen.dart';
import 'package:dating_app/view/test_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  
  routes: [
    GoRoute(path: '/onboarding', builder: (context, state) =>  ScreenOnboarding()),
    GoRoute(path: '/authlanding', builder: (context, state) =>  AuthLandingScreen()),
    GoRoute(path: '/phoneotp', builder: (context, state) =>  PhoneOtpScreen()),
    GoRoute(path: '/emailauth', builder: (context, state) =>  EmailAuthScreen()),
    GoRoute(path: '/profilesetup', builder: (context, state) =>  ProfileSetupScreen()),
    GoRoute(path: '/home', builder: (context, state) =>  HomeScreen()),
    GoRoute(path: '/easytab', builder: (context, state) =>  EasyTabbar()),
    GoRoute(path: '/splash', builder: (context, state) =>  ScreenSplash()),
    GoRoute(path: '/MyHomePage', builder: (context, state) =>  MyHomePage()),
    GoRoute(path: '/settings', builder: (context, state) =>  SettingsScreen()),
    GoRoute(path: '/sensitive', builder: (context, state) =>  SensitiveTogleScreen()),
    GoRoute(path: '/lookingforexist', builder: (context, state) =>  ExistLookingforScreen()),

    // GoRoute(
    //   path: '/profile/:userId', // The ':userId' is the parameter
    //   builder: (context, state) {
    //     // Extract the userId from the route's state
    //     final index = state.pathParameters['userId']!;
    //     return OtherProfileDetailsScreen(index: int.parse(index));
    //   },
    // ),
    // GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    // GoRoute(
    //   path: '/register',
    //   builder: (context, state) => const RegisterScreen(),
    // ),
    // GoRoute(path: "/home", builder: (context, state) =>  HomeScreen()),
    //  GoRoute(path: "/splash", builder: (context, state) =>  ScreenSplash()),
    //  GoRoute(path: '/viewItem', builder: (context, state) {
    //   final passWordModel = state.extra as PasswordModel;
    //   return ViewScreen(passwordModel: passWordModel,);
    //  }),
    //  GoRoute(path: '/addedit', builder: (context, state) {
    //   final Map<String,dynamic> params = state.extra as Map<String,dynamic>;

    //   return AddEditItemScreen(type: params['type'],passwordModel: params['model'],);
    //  }),
    //  GoRoute(path: '/forgot', builder: (context, state) => const ForgotScreen()),
    //  GoRoute(path: '/search', builder: (context, state) {
    //   final params = state.extra as List<PasswordModel>;

    //   return SearchScreen(models: params,);
    //  }),

  ],
);
