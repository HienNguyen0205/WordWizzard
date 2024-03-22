// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/localization/localization.dart';
import 'package:wordwizzard/routes/custom_route.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  static void setTheme(BuildContext context){
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.handleChangeTheme();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode mode = ThemeMode.light;
  late Locale _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  void handleChangeTheme() {
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
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('vi'),
      ],
      localizationsDelegates: const [
        Localization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      onGenerateRoute: CustomRouter.generatedRoute,
      initialRoute: introRoute,
    );
  }
}
