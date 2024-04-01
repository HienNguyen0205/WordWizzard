import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/localization/localization.dart';
import 'package:wordwizzard/routes/custom_route.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
  bool isLogin = prefs.getBool('isLogin') ?? false;
  String initialRoute;
  if(isFirstLaunch){
    initialRoute = introRoute;
  }else{
    if(isLogin){
      initialRoute = bottomNavBarRoute;
    }else{
      initialRoute = signInRoute;
    }
  }
  runApp(MyApp(route: initialRoute),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.route});

  final String route;

  static void setLocale(BuildContext context, Locale newLocale) {
    MyAppState? state = context.findAncestorStateOfType<MyAppState>();
    state?.setLocale(newLocale);
  }

  static void setTheme(BuildContext context) {
    MyAppState? state = context.findAncestorStateOfType<MyAppState>();
    state?.handleChangeTheme();
  }

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode mode = ThemeMode.light;
  Locale _locale = locale(vietnamese);

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WordWiizzard',
      theme: FlexThemeData.light(
        scheme: FlexScheme.cyanM3,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 7,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
          navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
          navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
          navigationBarMutedUnselectedLabel: false,
          navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
          navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
          navigationBarMutedUnselectedIcon: false,
          navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
          navigationBarIndicatorOpacity: 1.00,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.cyanM3,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 13,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
          navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
          navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
          navigationBarMutedUnselectedLabel: false,
          navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
          navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
          navigationBarMutedUnselectedIcon: false,
          navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
          navigationBarIndicatorOpacity: 1.00,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
      ),
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
      initialRoute: widget.route,
    );
  }
}
