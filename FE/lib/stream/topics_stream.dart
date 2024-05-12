import 'dart:async';
import 'package:wordwizzard/services/topic.dart';

class TopicStream {
  dynamic myTopicData;
  dynamic allTopicData;
  static final TopicStream _instance = TopicStream._internal();
  factory TopicStream() => _instance;

  TopicStream._internal() {
    myTopicController = StreamController<dynamic>.broadcast(sync: true);
    allTopicController = StreamController<dynamic>.broadcast(sync: true);
  }

  late StreamController<dynamic> myTopicController;
  Stream get myTopicStream => myTopicController.stream;
  late StreamController<dynamic> allTopicController;
  Stream get allTopicStream => allTopicController.stream;

  void getAllTopicData() {
    handleGetAllTopics(1, "", 10).then((val) {
      if (val["code"] == 0) {
        allTopicData = val["data"];
        allTopicController.sink.add(allTopicData);
      } else if(val["code"] == -1) {
        allTopicController.sink.addError(val["code"]);
      }
    });
  }

  void getMyTopicsData() {
    handleGetAllMyTopics(1, "", 10).then((val) {
      if (val["code"] == 0) {
        myTopicData = val["data"];
        myTopicController.sink.add(myTopicData);
      } else if (val["code"] == -1) {
        myTopicController.sink.addError(val["code"]);
      }
    });
  }

  void dispose() {
    myTopicController.close();
    allTopicController.close();
  }
}