import 'package:flutter/material.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/screens/bottom_nav.dart';
import 'package:wordwizzard/screens/change_pass_screen.dart';
import 'package:wordwizzard/screens/forget_pass_screen.dart';
import 'package:wordwizzard/screens/home_screen.dart';
import 'package:wordwizzard/screens/intro_screen.dart';
import 'package:wordwizzard/screens/not_found_screen.dart';
import 'package:wordwizzard/screens/otp_verify_screen.dart';
import 'package:wordwizzard/screens/sign_in_screen.dart';
import 'package:wordwizzard/screens/sign_up_screen.dart';

class CustomRouter {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    final Map<String, dynamic>? args =
        settings.arguments as Map<String, dynamic>?;
    switch (settings.name) {
      case introRoute:
        return MaterialPageRoute(builder: (_) => const IntroScreen());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case signInRoute:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case signUpRoute:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => const SignUpScreen(),
            transitionDuration: const Duration(milliseconds: 500),
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
              transitionDuration: const Duration(milliseconds: 500),
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
            transitionDuration: const Duration(milliseconds: 500),
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
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
      case bottomNavBarRoute:
        return MaterialPageRoute(builder: (_) => const BottomNav());
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundScreen());
    }
  }
}
