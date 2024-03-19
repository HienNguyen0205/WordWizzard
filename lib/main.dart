// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:wordwizzard/screens/splash.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordwizzard/theme.dart';

void main () async {
  // WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs.clear();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {

  ThemeMode mode = ThemeMode.light;

  void handleChangeTheme () {
    setState(() {
      mode = mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  final AppTheme appTheme = AppTheme();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'WordWiizzard',
        theme: appTheme.light,
        darkTheme: appTheme.dark,
        themeMode: mode,
        home: const Splash(),
    );
  }
}
