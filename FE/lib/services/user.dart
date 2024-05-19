import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wordwizzard/constants/constants.dart';


Future<dynamic> handleGetUserInfo() async {
  final url = Uri.parse('http://$ipv4:5001/api/user/me');
  const storage = FlutterSecureStorage();

  try {
    String? token = await storage.read(key: "token");
    final res = await http.get(url, headers: {
      "Authorization": "Bearer $token",
    });

    final resData = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return {"code": 0, "data": resData};
    } else {
      return {"errrorCode": resData["errrorCode"]};
    }
  } catch (error) {
    debugPrint(error.toString());
    return {'code': -1};
  }
}

Future<dynamic> handleUpdateUserInfo(String fullname, String phone) async {
  final url = Uri.parse('http://$ipv4:5001/api/user/update-profile');
  const storage = FlutterSecureStorage();

  try {
    String? token = await storage.read(key: "token");
    final res = await http.post(url, headers: {
      "Authorization": "Bearer $token",
    }, body: {
      "fullname": fullname,
      "phone": phone
    });

    final resData = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return {"code": 0, "data": resData};
    } else {
      return {"errrorCode": resData["errrorCode"]};
    }
  } catch (error) {
    debugPrint(error.toString());
    return {'code': -1};
  }
}

Future<dynamic> handleChangePw(String currentPassword, String newPassword) async {
  final url = Uri.parse('http://$ipv4:5001/api/user/change-password');
  const storage = FlutterSecureStorage();

  try {
    String? token = await storage.read(key: "token");
    final res = await http.post(url, headers: {
      "Authorization": "Bearer $token",
    }, body: {
      "currentPassword": currentPassword,
      "newPassword": newPassword
    });

    final resData = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return {"code": 0, "data": resData};
    } else {
      return {"errrorCode": resData["errrorCode"]};
    }
  } catch (error) {
    debugPrint(error.toString());
    return {'code': -1};
  }
}

Future<dynamic> handleResetPass(String pass, String userId) async {
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
    } else {
      return {'code': int.parse(resData['errorCode'])};
    }
  } catch (error) {
    debugPrint('Failed to send data: $error');
    return {'code': -1};
  }
}

Future<dynamic> handleUpdateAvatar(XFile image) async {
  final url = Uri.parse('http://$ipv4:5001/api/user/upload-image');
  const storage = FlutterSecureStorage();

  debugPrint(image.name);
  debugPrint(image.path);
  debugPrint(File(image.path).existsSync().toString());

  try {
    String? token = await storage.read(key: "token");
    final req = http.MultipartRequest("POST", url)
    ..files.add(await http.MultipartFile.fromPath("image", image.path));

    req.headers.addAll({
      "Authorization": "Bearer $token",
      "contentType": 'multipart/form-data'
    });

    final res = await req.send();
    String resBody = await res.stream.bytesToString();
    return jsonDecode(resBody);
  } catch (error) {
    debugPrint(error.toString());
    return {'code': -1};
  }
}
