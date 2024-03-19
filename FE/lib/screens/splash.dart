import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordwizzard/screens/home_screen.dart';
import 'package:wordwizzard/screens/intro_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  String getCurrentRouteName(BuildContext context) {
    ModalRoute<dynamic>? route = ModalRoute.of(context);
    if (route != null) {
      return route.settings.name ?? '';
    }
    return '';
  }

  Future checkFirstLauch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLauch = (prefs.getBool('isFistLauch') ?? false);

    if (isFirstLauch) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      await prefs.setBool('isFistLauch', true);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const IntroScreen()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstLauch();

  @override
  Widget build(BuildContext context) {
    String route = getCurrentRouteName(context);
    debugPrint('route $route');
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SpinKitPouringHourGlass(color: Colors.black),
      ),
    );
  }
}
