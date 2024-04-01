import 'package:shared_preferences/shared_preferences.dart';

void setLogin(bool status) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isLogin', status);
}

Future<bool> isLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLogin') ?? false;
}