import 'dart:async';
import 'package:wordwizzard/services/folder.dart';
import 'package:wordwizzard/services/topic.dart';

class TopicsFoldersStream {
  dynamic topicsFoldersData;
  StreamController topicsFoldersController = StreamController<dynamic>.broadcast();
  Stream get topicsFoldersStream => topicsFoldersController.stream;

  Future<List> getData() async {
    List<Future<dynamic>> future = [
      handleGetAllTopics(1, "", 10),
      handleGetAllFolders(1, "", 10),
    ];
    List<dynamic> res = await Future.wait(future);
    return res;
  }

  void updateTopicsFoldersData() {
    getData().then((val) {
      int statusCode = val[0]["code"] == 0 && val[1]["code"] == 0 ? 0 : 1;
      if(statusCode == 0) {
        topicsFoldersData = {"code": statusCode, "topics": val[0]["data"], "folders": val[1]["data"]};
      }else{
        topicsFoldersData = {"code": statusCode};
      }
      topicsFoldersController.sink.add(topicsFoldersData);
    });
  }

  void dispose() {
    topicsFoldersController.close();
  }
}