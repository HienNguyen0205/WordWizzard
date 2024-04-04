import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:wordwizzard/constants/constants.dart';

Future<dynamic> handleGetAllTopics(int page, String search, int limit) async {
  final url = Uri.parse('http://$ipv4:5001/api/topic/all?search=$search&page=$page&limit=10');
  const storage = FlutterSecureStorage();

  try {
    String? token = await storage.read(key: "token");
    final res = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      }
    );
    final resData = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return {"code": 0, "data": resData["data"]};
    }
  } catch (error) {
    return {"code": 1};
  }
}

Future<int> handleAddTopic(String name, String description, String securityView, List listWords) async {
  final url = Uri.parse('http://$ipv4:5001/api/topic/add');

  try {
    final res = await http.post(
      url,
      body: {
        'name': name,
        'description': description,
        'securityView': securityView,
        'listWords': listWords
      },
    );
    final resData = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return 0;
    } else {
      return int.parse(resData['errorCode']);
    }
  } catch (error) {
    return -1;
  }
}
