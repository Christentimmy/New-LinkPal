// app_routes.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/models/post_model.dart';
import 'package:linkingpal/pages/auth/error_face_screen.dart';
import 'package:linkingpal/pages/auth/faceid_req_screen.dart';
import 'package:linkingpal/pages/auth/forgot_password_screen.dart';
import 'package:linkingpal/pages/auth/interest_screen.dart';
import 'package:linkingpal/pages/auth/introduction_video_screen.dart';
import 'package:linkingpal/pages/auth/personal_data_from_user.dart';
import 'package:linkingpal/pages/auth/select_gender_screen.dart';
import 'package:linkingpal/pages/auth/sign_in_screen.dart';
import 'package:linkingpal/pages/auth/sign_up_screen.dart';
import 'package:linkingpal/pages/auth/success_face_screen.dart';
import 'package:linkingpal/pages/auth/update_profile_picture.dart';
import 'package:linkingpal/pages/auth/upload_profile_picture.dart';
import 'package:linkingpal/pages/auth/verification_checker_screen.dart';
import 'package:linkingpal/pages/auth/verification_screen_for_email.dart';
import 'package:linkingpal/pages/auth/verification_screen_for_phone.dart';
import 'package:linkingpal/pages/create_post/create_post_screen.dart';
import 'package:linkingpal/pages/create_post/edit_post_screen.dart';
import 'package:linkingpal/pages/dashboard_screen.dart';
import 'package:linkingpal/pages/home/home_screen.dart';
import 'package:linkingpal/pages/home/notification.dart';
import 'package:linkingpal/pages/message/chat_screen.dart';
import 'package:linkingpal/pages/message/message_screen.dart';
import 'package:linkingpal/pages/onboarding/onboarding_screen.dart';
import 'package:linkingpal/pages/profile/all_post_screen.dart';
import 'package:linkingpal/pages/profile/edit_profile.dart';
import 'package:linkingpal/pages/profile/match_profile_screen.dart';
import 'package:linkingpal/pages/profile/other_users_profile.dart';
import 'package:linkingpal/pages/profile/profile_screen.dart';
import 'package:linkingpal/pages/profile/update_interest.dart';
import 'package:linkingpal/pages/profile/update_video.dart';
import 'package:linkingpal/pages/setting/blocked_user_screen.dart';
import 'package:linkingpal/pages/setting/change_password_screen.dart';
import 'package:linkingpal/pages/setting/matches_request.dart';
import 'package:linkingpal/pages/setting/matches_screen.dart';
import 'package:linkingpal/pages/setting/premium_screen.dart';
import 'package:linkingpal/pages/setting/privacy_policy_screen.dart';
import 'package:linkingpal/pages/setting/setting_screen.dart';
import 'package:linkingpal/pages/setting/subcription_screen.dart';
import 'package:linkingpal/pages/setting/terms_screen.dart';
import 'package:linkingpal/pages/splash/splash_screen.dart';
import 'package:linkingpal/pages/swipe/swipe_screen.dart';
import 'package:linkingpal/pages/swipe/swipe_users_profile_screen.dart';
import 'package:linkingpal/pages/swipe/view_posted_pics.dart';

class AppRoutes {
  static const String initial = '/';
  static const String walkthrough = '/walkthrough';
  static const String matchesProfileScreen = '/matchesProfileScreen';
  static const String viewAllPostedPics = '/viewAllPostedPics';
  static const String introductionVideo = '/introductionVideo';
  static const String updateVideo = '/updateVideo';
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
  static const String swipedUserCardProfile = '/swipedCardProfile';
  static const String verificationChecker = '/verificationChecker';
  static const String premium = '/premium';
  static const String personalDataFromUser = '/personalDataFromUser';
  static const String editPost = '/editPost';
  static const String viewVideoPosted = '/viewVideoPosted';
  static const String selectGender = '/selectGender';
  static const String verificationScreenEMail = '/verificationScreenEMail';
  static const String verificationScreenPhone = '/verificationScreenPhone';
  static const String updateInterest = '/updateInterest';
  static const String userProfileScreen = '/userProfileScreen';
  static const String matchesRequest = '/matchesRequest';
  static const String updateProfilePicture = '/updateProfilePicture';
}

class RouteHandler {
  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.createPost,
      page: () => const CreatePostScreen(),
    ),
    GetPage(
      name: AppRoutes.updateProfilePicture,
      page: () => UpdateProfilePicture(),
    ),
    GetPage(
      name: AppRoutes.matchesProfileScreen,
      page: () {
        final userId = Get.arguments["userId"];
        return MatchesProfileScreen(userId: userId);
      },
    ),
    GetPage(
      name: AppRoutes.updateInterest,
      page: () => UpdateInterestScreen(),
    ),
    GetPage(
      name: AppRoutes.verificationScreenPhone,
      page: () => const VerificationScreenPhone(),
    ),
    GetPage(
      name: AppRoutes.verificationScreenEMail,
      page: () => const VerificationScreenEmail(),
    ),
    GetPage(
      name: AppRoutes.selectGender,
      page: () => SelectGenderScreen(),
    ),
    GetPage(
      name: AppRoutes.updateVideo,
      page: () => UpdateVideoScreen(),
    ),
    GetPage(
      name: AppRoutes.viewAllPostedPics,
      page: () {
        final RxList<String> allPostedPics = Get.arguments["list"];
        return VieAllPostedPics(
          allPostedPics: allPostedPics,
        );
      },
    ),
    GetPage(
      name: AppRoutes.viewVideoPosted,
      page: () => const CreatePostScreen(),
    ),
    GetPage(
      name: AppRoutes.editPost,
      page: () {
        final PostModel model = Get.arguments["model"];
        return EditPostScreen(postModel: model);
      },
    ),
    GetPage(
      name: AppRoutes.personalDataFromUser,
      page: () => PersonalDataFromUser(),
    ),
    GetPage(
      name: AppRoutes.premium,
      page: () => const PremiumScreen(),
    ),
    GetPage(
      name: AppRoutes.swipe,
      page: () => const SwipeScreen(),
    ),
    GetPage(
      name: AppRoutes.swipedUserCardProfile,
      page: () {
        final String userId = Get.arguments["userId"];

        return SwipeUsersProfileScreen(
          userId: userId,
        );
      },
    ),
    GetPage(
      name: AppRoutes.userProfileScreen,
      page: () {
        final String userId = Get.arguments["userId"];
        return UsersProfileScreen(
          userId: userId,
        );
      },
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
      name: AppRoutes.matchesRequest,
      page: () => const MatchesRequestScreen(),
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
      page: () => AllPostScreen(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () {
        final userId = Get.arguments["userId"];
        final channedlId = Get.arguments["channedlId"];
        final name = Get.arguments["name"];
        return ChatScreen(
          userId: userId,
          channedlId: channedlId,
          name: name,
        );
      },
    ),
    GetPage(
      name: AppRoutes.message,
      page: () => const MessageScreen(),
    ),
    GetPage(
      name: AppRoutes.homescreen,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.notification,
      page: () => NotificationScreen(),
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
      page: () {
        final int? startScreen = Get.arguments?["startScreen"];
        return DashBoardScreen(startscreen: startScreen ?? 0);
      },
    ),
    GetPage(
      name: AppRoutes.signin,
      page: () => const SignIn(),
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
    // GetPage(
    //   name: AppRoutes.locationAccess,
    //   page: () => LocationAccessScreen(),
    // ),
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
    GetPage(
      name: AppRoutes.verificationChecker,
      page: () {
        final VoidCallback onClickedToProceed =
            Get.arguments["onClickToProceed"];
        return VerificationCheckerScreen(
          onClickedToProceed: onClickedToProceed,
        );
      },
    ),
  ];
}
