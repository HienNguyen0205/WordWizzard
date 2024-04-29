import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool? isLogin;
  String? userId;

  AuthProvider() {
    SharedPreferences.getInstance().then((val) {
      isLogin = val.getBool("isLogin");
      userId = val.getString("userId");
      notifyListeners();
    });
  }

  void signIn () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin = true;
    prefs.setBool('isLogin', true);
    notifyListeners();
  }

  Future<String> getUserId() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token as String);
    return decodedToken["_id"];
  }

  void logOut () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin = false;
    prefs.setBool('isLogin', false);
    notifyListeners();
  }
}