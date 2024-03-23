import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<bool> handleLogin(String email, String password) async {
  final url = Uri.parse('http://localhost:5001/api/user/login');

  try {
    final res = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
      },
    );

    if (res.statusCode == 200) {
      return true;
    }
    return false;
  } catch (error) {
    debugPrint('Failed to send data: $error');
    return false;
  }
}
