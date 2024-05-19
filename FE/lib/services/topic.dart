import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:wordwizzard/constants/constants.dart';

Future<dynamic> handleTopicDetails(String topicId) async {
  final url = Uri.parse(
      'http://$ipv4:5001/api/topic/detail/$topicId');
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

Future<dynamic> handleJoinTopicDetails(String topicId) async {
  final url = Uri.parse('http://$ipv4:5001/api/userTopic/join/$topicId');
  const storage = FlutterSecureStorage();

  try {
    String? token = await storage.read(key: "token");
    final res = await http.post(url, headers: {
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

Future<dynamic> handleGetAllMyTopics(int? page, String? search, int? limit) async {
  final url = Uri.parse('http://$ipv4:5001/api/topic/all?search=$search&page=$page&limit=$limit');
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
    }else {
      return {"errrorCode": resData["errrorCode"]};
    }
  } catch (error) {
    debugPrint(error.toString());
    return {"code": -1};
  }
}

Future<dynamic> handleGetAllTopics(
    int? page, String? search, int? limit) async {
  final url = Uri.parse(
      'http://$ipv4:5001/api/topic/all-client?search=$search&page=$page&limit=$limit');
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

Future<dynamic> handleAddTopic(String name, String description, String securityView, String tag, List<dynamic> listWords) async {
  final url = Uri.parse('http://$ipv4:5001/api/topic/add');
  const storage = FlutterSecureStorage();
  List words = listWords.map((val) {
    return {"general": val["term"], "meaning": val["definition"]};
  }).toList();

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
        'securityView': securityView,
        'tag': tag,
        'listWords': jsonEncode(words)
      },
    );
    final resData = jsonDecode(res.body);
    if (res.statusCode == 201) {
      return {"code": 0, "data": resData["data"]};
    } else {
      return {"errrorCode": resData["errrorCode"]};
    }
  } catch (error) {
    debugPrint(error.toString());
    return {"code": -1};
  }
}

Future<dynamic> handleGetFolderToAdd(String id) async {
  final url = Uri.parse('http://$ipv4:5001/api/topic/get-folders/$id');
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
      return {"errrorCode": resData["errrorCode"]};
    }
  } catch (error) {
    debugPrint(error.toString());
    return {"code": -1};
  }
}

Future<dynamic> handleAddTopicsToFolder(String id, List<String> folderList) async {
  final url = Uri.parse('http://$ipv4:5001/api/topic/choose-folders/$id');
  const storage = FlutterSecureStorage();

  try {
    String? token = await storage.read(key: "token");
    final res = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
      body: {
        'folderIds': jsonEncode(folderList)
      }
    );
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

Future<dynamic> handleSaveTopic(String id, List<String> idList) async {
  final url = Uri.parse('http://$ipv4:5001/api/userTopic/save/$id');
  const storage = FlutterSecureStorage();

  try {
    String? token = await storage.read(key: "token");
    final res = await http.post(url, headers: {
      "Authorization": "Bearer $token",
    }, body: {
      'words_mark': jsonEncode(idList),
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

Future<dynamic> handleUpdateTopic(String id, String name, String description, String sercurityView, String tag, List<dynamic> listWords) async {
  final url = Uri.parse('http://$ipv4:5001/api/topic/update/$id');
  const storage = FlutterSecureStorage();

  List words = listWords.map((val) {
    return {"general": val["term"], "meaning": val["definition"]};
  }).toList();

  debugPrint("🚀 ${listWords.toString()}");

  try {
    String? token = await storage.read(key: "token");
    final res = await http.patch(url, headers: {
      "Authorization": "Bearer $token",
    }, body: {
      'name': name,
      'description': description,
      'securityView': sercurityView,
      'tag': tag,
      'listWords': jsonEncode(words)
    });
    final resData = jsonDecode(res.body);
    debugPrint("🚀 ${resData.toString()}");
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

Future<dynamic> handleDeleteTopic(String id) async {
  final url = Uri.parse('http://$ipv4:5001/api/topic/delete/$id');
  const storage = FlutterSecureStorage();

  try {
    String? token = await storage.read(key: "token");
    final res = await http.delete(url, headers: {
      "Authorization": "Bearer $token",
    });
    final resData = jsonDecode(res.body);
    debugPrint(resData.toString());
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
