import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void logIn() {
    _isLoggedIn = true;
    notifyListeners();
  }
  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}