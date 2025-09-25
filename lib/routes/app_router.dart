


import 'package:dating_app/view/auth_landing_screen/auth_landing_screen.dart';
import 'package:dating_app/view/screen_onboarding/screen_onboarding.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(path: '/onboarding', builder: (context, state) =>  ScreenOnboarding()),
    GoRoute(path: '/authlanding', builder: (context, state) =>  AuthLandingScreen()),
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
