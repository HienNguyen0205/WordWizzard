import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode? mode;

  ThemeProvider() {
    SharedPreferences.getInstance().then((prefs) {
      mode = (prefs.getString("themeMode") ?? "light") == "dark" ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void changeThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String res = prefs.getString("themeMode") ?? "light";
    if(res == "dark"){
      prefs.setString('themeMode', 'light'); 
      mode = ThemeMode.light;
    }else{
      prefs.setString('themeMode', 'dark');
      mode = ThemeMode.dark;
    }
    notifyListeners();
  }
}