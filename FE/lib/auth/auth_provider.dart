import 'package:flutter/material.dart';
import 'package:wordwizzard/services/auth.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<bool> logIn(String email, String password) async {
    bool res = await handleLogin(email, password);
    if(res){
      _isLoggedIn = true;
    }
    notifyListeners();
    return res;
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}