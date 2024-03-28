import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppColors {
  static const mainColor = Color(0xFF263238);
  static const secondaryColor = Color(0xFFE5F6FF);
  static const accent = Color(0xFF111118);
  static const textDark = Color(0xFF53585A);
  static const textLight = accent;
  static const textHighLight = Colors.blue;
  static const iconLight = accent;
  static const iconDark = Color(0xFFB1B3C1);
  static const cardLight = mainColor;
  static const cardLightText = secondaryColor;
  static const cardDark = Color.fromARGB(255, 46, 46, 46);
}

abstract class _LightColors {
  static const background = AppColors.secondaryColor;
  static const card = AppColors.cardLight;
}

abstract class _DarkColors {
  static const background = Color.fromARGB(255, 18, 18, 18);
  static const card = AppColors.cardDark;
}

class AppTheme {
  static const accentColor = AppColors.accent;
  static final visualDensity = VisualDensity.adaptivePlatformDensity;

  final darkBase = ThemeData.dark();
  final lightBase = ThemeData.light();

  ThemeData get light => ThemeData(
        brightness: Brightness.light,
        visualDensity: visualDensity,
        textTheme: GoogleFonts.mulishTextTheme().apply(
          bodyColor: AppColors.textDark
        ),
        appBarTheme: lightBase.appBarTheme.copyWith(
          iconTheme: lightBase.iconTheme,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColors.textDark,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        scaffoldBackgroundColor: _LightColors.background,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: AppColors.accent,
              textStyle: const TextStyle(fontSize: 18, color: AppColors.cardLightText)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: AppColors.textLight),
          floatingLabelStyle: const TextStyle(color: AppColors.textLight),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.accent),
            borderRadius: BorderRadius.circular(10.0),
          )
        ),
        cardColor: _LightColors.card,
        primaryTextTheme: const TextTheme(
          titleLarge: TextStyle(color: AppColors.textDark),
        ),
        iconTheme: const IconThemeData(color: AppColors.iconDark),
        colorScheme: lightBase.colorScheme
            .copyWith(secondary: accentColor)
            .copyWith(background: _LightColors.background),
      );

  ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        visualDensity: visualDensity,
        textTheme:
            GoogleFonts.interTextTheme().apply(bodyColor: AppColors.textLight),
        appBarTheme: darkBase.appBarTheme.copyWith(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        scaffoldBackgroundColor: _DarkColors.background,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondaryColor,
            padding: const EdgeInsets.symmetric(vertical: 14),
            textStyle: const TextStyle(fontSize: 18, color: AppColors.textLight),
          ),
        ),
        cardColor: _DarkColors.card,
        primaryTextTheme: const TextTheme(
          titleLarge: TextStyle(color: AppColors.textLight),
        ),
        iconTheme: const IconThemeData(color: AppColors.iconLight),
        colorScheme: darkBase.colorScheme
            .copyWith(secondary: accentColor)
            .copyWith(background: _DarkColors.background),
      );
}
