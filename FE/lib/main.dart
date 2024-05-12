import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordwizzard/localization/localization.dart';
import 'package:wordwizzard/providers/access_scope_provider.dart';
import 'package:wordwizzard/providers/auth_provider.dart';
import 'package:wordwizzard/providers/flashcard_setting_provider.dart';
import 'package:wordwizzard/providers/id_container_provider.dart';
import 'package:wordwizzard/providers/locale_provider.dart';
import 'package:wordwizzard/providers/theme_provider.dart';
import 'package:wordwizzard/routes/custom_route.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String initialRoute;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
  bool isLogin = prefs.getBool('isLogin') ?? false;
  if (isFirstLaunch) {
    initialRoute = introRoute;
  } else {
    if (isLogin) {
      initialRoute = bottomNavRoute;
    } else {
      initialRoute = signInRoute;
    }
  }
  // ignore: deprecated_member_use
  CloudinaryContext.cloudinary =
      Cloudinary.fromCloudName(cloudName: "dtrtjisrv");
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => LocaleProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => AccessScopeProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => FlashcardSettingProvider(),
      ),
      Provider(create: (_) => IdContainerProvider()),
    ], child: MyApp(initRoute: initialRoute)),
  );
}

class MyApp extends StatefulWidget {
  final String initRoute;
  const MyApp({super.key, required this.initRoute});

  @override
  MyAppState createState() => MyAppState();
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
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
            bottomSheetElevation: 20,
            navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
            navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
            navigationBarMutedUnselectedLabel: false,
            navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
            navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
            navigationBarMutedUnselectedIcon: false,
            navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
            navigationBarIndicatorOpacity: 1.00,
            textButtonTextStyle: MaterialStatePropertyAll(
                TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            cardElevation: 4,
            bottomNavigationBarElevation: 12,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          swapLegacyOnMaterial3: true,
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily),
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
            bottomSheetElevation: 20,
            navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
            navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
            navigationBarMutedUnselectedLabel: false,
            navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
            navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
            navigationBarMutedUnselectedIcon: false,
            navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
            navigationBarIndicatorOpacity: 1.00,
            textButtonTextStyle: MaterialStatePropertyAll(
                TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            cardElevation: 4,
            bottomNavigationBarElevation: 12,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          swapLegacyOnMaterial3: true,
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily),
      themeMode: context.watch<ThemeProvider>().mode,
      locale: context.watch<LocaleProvider>().localeVal,
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
      initialRoute: widget.initRoute,
      builder: FToastBuilder(),
    );
  }
}
