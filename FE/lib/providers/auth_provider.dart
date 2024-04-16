import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool? isLogin;

  AuthProvider() {
    SharedPreferences.getInstance().then((val) {
      isLogin = val.getBool("isLogin");
    });
  }

  void signIn () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin = true;
    prefs.setBool('isLogin', true);
    notifyListeners();
  }

  void logOut () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin = false;
    prefs.setBool('isLogin', false);
    notifyListeners();
  }
}