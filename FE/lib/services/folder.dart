import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:wordwizzard/constants/constants.dart';

Future<dynamic> handleGetAllFolders(
    int? page, String? search, int? limit) async {
  final url = Uri.parse(
      'http://$ipv4:5001/api/folder/all?search=$search&page=$page&limit=$limit');
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
      return {"errorCode": resData["errorCode"]};
    }
  } catch (error) {
    debugPrint(error.toString());
    return {"code": -1};
  }
}

Future<dynamic> handleAddFolder(String name, String description) async {
  final url = Uri.parse('http://$ipv4:5001/api/folder/add');
  const storage = FlutterSecureStorage();

  try {
    String? token = await storage.read(key: "token");
    final res = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
      body: {
        'name': name,
        'description': description,
      },
    );
    final resData = jsonDecode(res.body);
    if (res.statusCode == 201) {
      return {"code": 0, "data": resData["data"]};
    } else {
      return {"errorCode": resData["errorCode"]};
    }
  } catch (error) {
    debugPrint(error.toString());
    return {"code": -1};
  }
}

Future<dynamic> handleGetFolderDetails(String folderId) async {
  final url = Uri.parse('http://$ipv4:5001/api/folder/detail/$folderId');
  const storage = FlutterSecureStorage();

  try {
    String? token = await storage.read(key: "token");
    final res = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    final resData = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return {"code": 0, "data": resData["data"]};
    } else {
      return {"errorCode": resData["errorCode"]};
    }
  } catch (error) {
    debugPrint(error.toString());
    return {"code": -1};
  }
}

Future<dynamic> handleGetTopicsAddToFolder(String folderId) async {
  final url = Uri.parse('http://$ipv4:5001/api/folder/get-topics/$folderId');
  const storage = FlutterSecureStorage();

  try {
    String? token = await storage.read(key: "token");
    final res = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    final resData = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return {"code": 0, "data": resData["data"]};
    } else {
      return {"errorCode": resData["errorCode"]};
    }
  } catch (error) {
    debugPrint(error.toString());
    return {"code": -1};
  }
}

Future<int> handleAddTopicsToFolder(String folderId, List<String> idList) async {
  final url = Uri.parse('http://$ipv4:5001/api/folder/update-topics/$folderId');
  const storage = FlutterSecureStorage();
  debugPrint(idList.toString());

  try {
    String? token = await storage.read(key: "token");
    debugPrint(jsonEncode(idList));
    final res = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
      body: {
        'topicIds': jsonEncode(idList),
      },
    );
    final resData = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return 0;
    } else {
      return resData["errorCode"];
    }
  } catch (error) {
    debugPrint(error.toString());
    return -1;
  }
}
