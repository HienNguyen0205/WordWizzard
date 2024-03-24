import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<int> handleLogin(String email, String password) async {
  final url = Uri.parse('http://192.168.1.104:5001/api/user/login');

  try {
    final res = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
      },
    );
    final resData = jsonDecode(res.body);
    if (res.statusCode == 200) {
      const storage = FlutterSecureStorage();
      storage.write(key: 'token', value: resData['token']);
      return 0;
    }else{
      return resData['code'];
    }
  } catch (error) {
    debugPrint('Failed to send data: $error');
    return -1;
  }
}

Future<int> handleRegister(String name, String email, String password) async {
  final url = Uri.parse('http://192.168.1.104:5001/api/user/register');

  try {
    final res = await http.post(
      url,
      body: {
        'username': name,
        'email': email,
        'password': password,
      },
    );

    if (res.statusCode == 200) {
      return 0;
    }else{
      final resData = jsonDecode(res.body);
      return resData['code'];
    }
  } catch (error) {
    debugPrint('Failed to send data: $error');
    return -1;
  }
}