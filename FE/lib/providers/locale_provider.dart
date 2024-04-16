import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordwizzard/localization/language_constant.dart';

class LocaleProvider with ChangeNotifier {
  Locale? localeVal;

  LocaleProvider() {
    SharedPreferences.getInstance().then((val) {
      localeVal = val.getString("locale") == "vi" ? locale(vietnamese) : locale(english);
    });
  }

  void changeLocale(Locale newLocale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    localeVal = newLocale;
    if (newLocale == locale(vietnamese)) {
      prefs.setString('locale', 'en');
    } else {
      prefs.setString('locale', 'vi');
    }
    notifyListeners();
  }
}
