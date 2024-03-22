import 'package:flutter/material.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/screens/home_screen.dart';
import 'package:wordwizzard/screens/intro_screen.dart';
import 'package:wordwizzard/screens/not_found_screen.dart';

class CustomRouter {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case introRoute:
        return MaterialPageRoute(builder: (_) => const IntroScreen());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      // case aboutRoute:
      //   return MaterialPageRoute(builder: (_) => AboutPage());
      // case settingsRoute:
      //   return MaterialPageRoute(builder: (_) => SettingsPage());
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundScreen());
    }
  }
}