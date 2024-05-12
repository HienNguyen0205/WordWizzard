import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wordwizzard/constants/constants.dart';

Future<dynamic> handleLogin(String email, String password) async {
  final url = Uri.parse('http://$ipv4:5001/api/user/login');

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
      return int.parse(resData['errorCode']);
    }
  } catch (error) {
    debugPrint(error.toString());
    return -1;
  }
}

Future<dynamic> handleRegister(String name, String email, String password) async {
    final registerUrl = Uri.parse('http://$ipv4:5001/api/user/register');

  try {
    final res = await http.post(
      registerUrl,
      body: {
        'username': name,
        'email': email,
        'password': password,
      },
    );
    final resData = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return {'code': 0, 'userId': resData['user_id']};
    }else{
      return {'code': int.parse(resData['errorCode'])};
    }
  } catch (error) {
    debugPrint(error.toString());
    return {'code': -1};
  }
}

Future<int> handleRegisterOTP(String otp, String userId) async {
  final url = Uri.parse('http://$ipv4:5001/api/user/login-otp/$userId');

  try {
    final res = await http.post(
      url,
      body: {
        'otp': otp
      },
    );

    final resData = jsonDecode(res.body);
    if (res.statusCode == 200) {
      const storage = FlutterSecureStorage();
      storage.write(key: 'token', value: resData['token']);
      return 0;
    }else{
      return int.parse(resData['errorCode']);
    }
  } catch (error) {
    debugPrint(error.toString());
    return -1;
  }
}

Future<int> handleResendOTP(String email) async {
  final url = Uri.parse('http://$ipv4:5001/api/user/renew-otp');

  try {
    final res = await http.post(
      url,
      body: {
        'email': email
      },
    );

    final resData = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return 0;
    }else{
      return int.parse(resData['errorCode']);
    }
  } catch (error) {
    debugPrint(error.toString());
    return -1;
  }
}

Future<dynamic> handleForgetPass(String email) async {
  final url = Uri.parse('http://$ipv4:5001/api/user/otp');

  try {
    final res = await http.post(
      url,
      body: {
        'email': email
      },
    );

    final resData = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return {'code': 0, 'userId': resData['user_id']};
    }else{
      return {'code': int.parse(resData['errorCode'])};
    }
  } catch (error) {
    debugPrint(error.toString());
    return {'code': -1 };
  }
}

Future<dynamic> handleResetPassOTP(String otp, String userId) async {
  final url = Uri.parse('http://$ipv4:5001/api/user/verify-otp/$userId');

  try {
    final res = await http.post(
      url,
      body: {
        'otp': otp,
      },
    );

    final resData = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return {'code': 0, 'userId': resData['user_id']};
    }else{
      return {'code': int.parse(resData['errorCode'])};
    }
  } catch (error) {
    debugPrint('Failed to send data: $error');
    return {'code': -1 };
  }
}

Future<dynamic> handleChangePass(String pass, String userId) async {
  final url = Uri.parse('http://$ipv4:5001/api/user/reset-password/$userId');

  try {
    final res = await http.post(
      url,
      body: {
        'password': pass,
      },
    );

    final resData = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return {'code': 0, 'userId': resData['user_id']};
    }else{
      return {'code': int.parse(resData['errorCode'])};
    }
  } catch (error) {
    debugPrint('Failed to send data: $error');
    return {'code': -1 };
  }
}