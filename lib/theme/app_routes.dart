// app_routes.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/pages/auth/error_face_screen.dart';
import 'package:linkingpal/pages/auth/faceid_req_screen.dart';
import 'package:linkingpal/pages/auth/forgot_password_screen.dart';
import 'package:linkingpal/pages/auth/interest_screen.dart';
import 'package:linkingpal/pages/auth/introduction_video_screen.dart';
import 'package:linkingpal/pages/auth/location_access_screen.dart';
import 'package:linkingpal/pages/auth/sign_in_screen.dart';
import 'package:linkingpal/pages/auth/sign_up_screen.dart';
import 'package:linkingpal/pages/auth/success_face_screen.dart';
import 'package:linkingpal/pages/auth/upload_profile_picture.dart';
import 'package:linkingpal/pages/auth/verification_screen.dart';
import 'package:linkingpal/pages/create_post/create_post_screen.dart';
import 'package:linkingpal/pages/dashboard_screen.dart';
import 'package:linkingpal/pages/home/home_screen.dart';
import 'package:linkingpal/pages/home/notification.dart';
import 'package:linkingpal/pages/message/chat_screen.dart';
import 'package:linkingpal/pages/message/message_screen.dart';
import 'package:linkingpal/pages/onboarding/onboarding_screen.dart';
import 'package:linkingpal/pages/profile/all_post_screen.dart';
import 'package:linkingpal/pages/profile/edit_profile.dart';
import 'package:linkingpal/pages/profile/profile_screen.dart';
import 'package:linkingpal/pages/setting/blocked_user_screen.dart';
import 'package:linkingpal/pages/setting/change_password_screen.dart';
import 'package:linkingpal/pages/setting/matches_screen.dart';
import 'package:linkingpal/pages/setting/privacy_policy_screen.dart';
import 'package:linkingpal/pages/setting/setting_screen.dart';
import 'package:linkingpal/pages/setting/subcription_screen.dart';
import 'package:linkingpal/pages/setting/terms_screen.dart';
import 'package:linkingpal/pages/splash/splash_screen.dart';
import 'package:linkingpal/pages/swipe/swipe_screen.dart';
import 'package:linkingpal/pages/swipe/users_profile_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String walkthrough = '/walkthrough';
  static const String introductionVideo = '/introductionVideo';
  static const String homescreen = '/homescreen';
  static const String dashboard = '/dashboard';
  static const String verification = '/Verification';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgotPassword';
  static const String interest = '/interest';
  static const String uploadPicture = '/uploadPicture';
  static const String locationAccess = '/locationAccess';
  static const String errorFace = '/errorFace';
  static const String faceIdReq = '/faceIdReq';
  static const String successFace = '/successFace';
  static const String createPost = '/createPost';
  static const String notification = '/notification';
  static const String chat = '/chat';
  static const String message = '/message';
  static const String allpost = '/allpost';
  static const String editProfile = '/editProfile';
  static const String profile = '/profile';
  static const String blockedUser = '/blockedUser';
  static const String changePassword = '/changePassword';
  static const String matches = '/matches';
  static const String privacyPolicy = '/privacyPolicy';
  static const String settings = '/settings';
  static const String subscription = '/subscription';
  static const String terms = '/terms';
  static const String swipe = '/swipe';
  static const String swipedCardProfile = '/swipedCardProfile';
}

class RouteHandler {
  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.createPost,
      page: () => const CreatePostScreen(),
    ),
    GetPage(
      name: AppRoutes.swipe,
      page: () => const SwipeScreen(),
    ),
    GetPage(
      name: AppRoutes.swipedCardProfile,
      page: () => const UsersProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.terms,
      page: () => const TermsAndConditionsScreen(),
    ),
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingScreen(),
    ),
    GetPage(
      name: AppRoutes.subscription,
      page: () => const SubscriptionScreen(),
    ),
    GetPage(
      name: AppRoutes.matches,
      page: () => const MatchesScreen(),
    ),
    GetPage(
      name: AppRoutes.blockedUser,
      page: () => const BlockedUserScreen(),
    ),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => ChangePasswordScreen(),
    ),
    GetPage(
      name: AppRoutes.allpost,
      page: () => const AllPostScreen(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => EditProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatScreen(),
    ),
    GetPage(
      name: AppRoutes.message,
      page: () => const MessageScreen(),
    ),
    GetPage(
      name: AppRoutes.homescreen,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.notification,
      page: () => const NotificationScreen(),
    ),
    GetPage(
      name: AppRoutes.initial,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.walkthrough,
      page: () => const WalkThrough(),
    ),
    GetPage(
      name: AppRoutes.introductionVideo,
      page: () => IntroductionVideoScreen(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashBoardScreen(),
    ),
    GetPage(
      name: AppRoutes.verification,
      page: () {
        final VoidCallback action = Get.arguments["action"];
        final String tempToken = Get.arguments["token"];
        return VerificationScreen(
          onClickButtonNext: action,
          token: tempToken,
        );
      },
    ),
    GetPage(
      name: AppRoutes.signin,
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
      page: () => LocationAccessScreen(),
    ),
    GetPage(
      name: AppRoutes.errorFace,
      page: () => const ErrorFaceScreen(),
    ),
    GetPage(
      name: AppRoutes.faceIdReq,
      page: () => const FaceReqIdScreen(),
    ),
    GetPage(
      name: AppRoutes.successFace,
      page: () => const SuccessFaceScreen(),
    ),
  ];
}
