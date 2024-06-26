import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:wordwizzard/constants/constants.dart';

Future<dynamic> handleGetRanking(int limit, int page) async {
  final url = Uri.parse('http://$ipv4:5001/api/user/leaderboard?search=&limit=$limit&page=$page');
  const storage = FlutterSecureStorage();

  try {
    String? token = await storage.read(key: "token");
    final res = await http.get(url, headers: {
      "Authorization": "Bearer $token",
    });
    final resData = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return {"code": 0, "data": resData["data"]};
    } else {
      return {"errrorCode": resData["errrorCode"]};
    }
  } catch (error) {
    debugPrint(error.toString());
    return {"code": -1};
  }
}
