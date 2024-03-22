import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordwizzard/localization/localization.dart';

const String languageKey = 'languageCode';

const String english = 'en';
const String vietnamese = 'vi';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(languageKey, languageCode);
  return locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String languageCode = prefs.getString(languageKey) ?? "vi";
  return locale(languageCode);
}

Locale locale(String languageCode) {
  switch (languageCode) {
    case english:
      return const Locale(english);
    case vietnamese:
      return const Locale(vietnamese);
    default:
      return const Locale(vietnamese);
  }
}

String getTranslated(BuildContext context, String key) {
  return Localization.of(context)?.translate(key) ?? '';
}