import 'package:flutter/material.dart';
import 'package:wordwizzard/localization/localization.dart';

const String languageKey = 'languageCode';

const String english = 'en';
const String vietnamese = 'vi';

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