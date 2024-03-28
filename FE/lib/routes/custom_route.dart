import 'package:flutter/material.dart';
import 'package:wordwizzard/routes/route_contants.dart';
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
    switch (settings.name) {
      case introRoute:
        return MaterialPageRoute(builder: (_) => const IntroScreen());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case signInRoute:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case signUpRoute:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case otpVerifyRoute:
        return MaterialPageRoute(builder: (_) => const OtpVerifyScreen(email: '', userId: '', action: '',));
      case forgetPassRoute:
        return MaterialPageRoute(builder: (_) => const ForgetPassScreen());
      case changePassRoute:
        return MaterialPageRoute(builder: (_) => const ChangePassScreen(userId: '',));
      // case settingsRoute:
      //   return MaterialPageRoute(builder: (_) => SettingsPage());
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundScreen());
    }
  }
}