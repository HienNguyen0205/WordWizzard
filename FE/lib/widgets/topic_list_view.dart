import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wordwizzard/auth/auth.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/services/topic.dart';
import 'package:wordwizzard/widgets/simple_topic_item.dart';

class TopicListView extends StatefulWidget {
  final List<dynamic> topicList;
  const TopicListView({super.key, required this.topicList});

  @override
  TopicListViewState createState() => TopicListViewState();
}

class TopicListViewState extends State<TopicListView> {
  late ScrollController _scrollTopicController;
  int currentTopicPage = 1;
  late List<dynamic> topicList;
  bool canLoadTopic = false;

  @override
  void initState() {
    super.initState();
    topicList = widget.topicList;
    _scrollTopicController = ScrollController();
    _scrollTopicController.addListener(handleLoadTopic);
  }

  @override
  void dispose() {
    _scrollTopicController.dispose();
    super.dispose();
  }

  void handleLoadTopic() async {
    if (_scrollTopicController.position.pixels ==
        _scrollTopicController.position.maxScrollExtent) {
      handleGetAllMyTopics(currentTopicPage + 1, "", 10).then((val) {
        if (val["code"] == 0) {
          if (val["data"] != []) {
            currentTopicPage += 1;
            setState(() {
              canLoadTopic = true;
              topicList.addAll(val["data"]);
            });
          }
        } else if (val["code"] == -1) {
          setLogin(false);
          Navigator.of(context)
              .pushNamedAndRemoveUntil(signInRoute, (route) => false);
        } else {
          debugPrint(val["errorCode"].toString());
        }
        setState(() {
          canLoadTopic = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: ListView.builder(
          controller: _scrollTopicController,
          itemCount: topicList.length + (canLoadTopic ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == topicList.length && canLoadTopic) {
              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child:
                      Lottie.asset('assets/animation/loading.json', height: 80));
            } else {
              return SimpleTopicItem(
                  title: topicList[index]["name"],
                  term: topicList[index]["words"],
                  author: {
                    "avatar": topicList[index]["createdBy"]["image"],
                    "name": topicList[index]["createdBy"]["username"]
                  },
                  isDraft: topicList[index]["sercurityView"] == 'DRAFT',
                  handleTap: () {});
            }
          }),
    ));
  }
}
