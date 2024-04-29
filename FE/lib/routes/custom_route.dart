import 'package:flutter/material.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/screens/add_folder_screen.dart';
import 'package:wordwizzard/screens/add_topic_screen.dart';
import 'package:wordwizzard/screens/add_topic_to_folder_screen.dart';
import 'package:wordwizzard/screens/bottom_nav.dart';
import 'package:wordwizzard/screens/change_language_screen.dart';
import 'package:wordwizzard/screens/change_pass_screen.dart';
import 'package:wordwizzard/screens/choose_folder_to_add_topic_screen.dart';
import 'package:wordwizzard/screens/flashcard_learning_screen.dart';
import 'package:wordwizzard/screens/folder_detail_screen.dart';
import 'package:wordwizzard/screens/forget_pass_screen.dart';
import 'package:wordwizzard/screens/intro_screen.dart';
import 'package:wordwizzard/screens/multiple_choice_setting.dart';
import 'package:wordwizzard/screens/multiple_choice_test_screen.dart';
import 'package:wordwizzard/screens/not_found_screen.dart';
import 'package:wordwizzard/screens/otp_verify_screen.dart';
import 'package:wordwizzard/screens/search_screen.dart';
import 'package:wordwizzard/screens/setting_access_scope_screen.dart';
import 'package:wordwizzard/screens/setting_add_topic_screen.dart';
import 'package:wordwizzard/screens/sign_in_screen.dart';
import 'package:wordwizzard/screens/sign_up_screen.dart';
import 'package:wordwizzard/screens/topic_details_screen.dart';

class CustomRouter {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    final Map<String, dynamic>? args =
        settings.arguments as Map<String, dynamic>?;
    switch (settings.name) {
      case introRoute:
        return MaterialPageRoute(builder: (_) => const IntroScreen());
      case signInRoute:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case signUpRoute:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => const SignUpScreen(),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
      case otpVerifyRoute:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => OtpVerifyScreen(
                email: args?["email"],
                userId: args?["userId"],
                action: args?["action"]),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
      case forgetPassRoute:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => const ForgetPassScreen(),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
      case changePassRoute:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                ChangePassScreen(userId: args?["userId"]),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
      case addTopicRoute:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => const AddTopicScreen(),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
      case settingAddTopicRoute:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => const SettingAddTopicScreen(),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
      case settingAccessScopeRoute:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => const SettingAccessScope(),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
      case addFolderRoute:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => const AddFolderScreen(),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
      case searchRoute:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => const SearchScreen(),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
      case folderDetailRoute:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                FolderDetailScreen(folderId: args?["folderId"]),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
      case bottomNavRoute:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => const BottomNav(),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (_, animation, __, child) {
              var begin = 0.7;
              var end = 1.0;
              var curve = Curves.ease;

              var tween = Tween(begin: begin, end: end).chain(
                CurveTween(curve: curve),
              );

              var scaleAnimation = animation.drive(tween);

              return ScaleTransition(
                scale: scaleAnimation,
                child: child,
              );
            });
      case addTopicToFolderRoute:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                AddTopicToFolderScreen(folderId: args?["folderId"]),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
      case changeLanguageRoute:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => const ChangeLanguageScreen(),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
      case topicDetailRoute:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => TopicDetailsScreen(
                  topicId: args?["topicId"],
                ),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
      case flashcardRoute:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => FlashcardLearningScreen(
                listWords: args?["listWords"], currIndex: args?["currIndex"]),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
      case chooseFolderToAddTopicRoute:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => ChooseFolderToAddTopicScreen(
                  id: args?["id"],
                ),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
      case multipleChoiceSettingRoute:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => MultipleChoiceSetting(
                  listWord: args?["listWord"],
                ),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
      case multipleChoiceTestRoute:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => MultipleChoiceTestScreen(
                  listWord: args?["listWord"],
                  questionQuantity: args?["questionQuantity"],
                  isInstantShowAnswer: args?["isInstantShowAnswer"],
                  isAnswerWithTerm: args?["isAnswerWithTerm"],
                  isAnswerWithDef: args?["isAnswerWithDef"],
                ),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundScreen());
    }
  }
}
