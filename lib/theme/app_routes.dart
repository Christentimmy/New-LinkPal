// app_routes.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/pages/auth/forgot_password_screen.dart';
import 'package:linkingpal/pages/auth/interest_screen.dart';
import 'package:linkingpal/pages/auth/introduction_video_screen.dart';
import 'package:linkingpal/pages/auth/location_access_screen.dart';
import 'package:linkingpal/pages/auth/sign_in_screen.dart';
import 'package:linkingpal/pages/auth/sign_up_screen.dart';
import 'package:linkingpal/pages/auth/upload_profile_picture.dart';
import 'package:linkingpal/pages/auth/verification_screen.dart';
import 'package:linkingpal/pages/dashboard_screen.dart';
import 'package:linkingpal/pages/home/home_screen.dart';
import 'package:linkingpal/pages/onboarding/onboarding_screen.dart';
import 'package:linkingpal/pages/splash/splash_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String walkthrough = '/walkthrough';
  static const String introduction = '/introduction';
  static const String homesceen = '/homescreen';
  static const String dashboard = '/dashboard';
  static const String verification = '/Verification';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgotPassword';
  static const String interest = '/forgotPassword';
  static const String uploadPicture = '/uploadPicture';
  static const String locationAccess = '/locationAccess';
}

class RouteHandler {
  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.initial,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.walkthrough,
      page: () => const WalkThrough(),
    ),
    GetPage(
      name: AppRoutes.introduction,
      page: () => IntroductionVideoScreen(),
    ),
    GetPage(
      name: AppRoutes.homesceen,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashBoardScreen(),
    ),
    GetPage(
      name: AppRoutes.verification,
      page: () {
        final VoidCallback? action = Get.arguments?["action"];
        return VerificationScreen(
          onClickButtonNext: action ?? () {},
        );
      },
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => SignIn(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => SignUp(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => ForgotPasswordScreen(),
    ),
    GetPage(
      name: AppRoutes.interest,
      page: () => InterestScreen(),
    ),
    GetPage(
      name: AppRoutes.uploadPicture,
      page: () => UploadProfilePicture(),
    ),
    GetPage(
      name: AppRoutes.locationAccess,
      page: () =>  LocationAccessScreen(),
    ),
  ];
}
