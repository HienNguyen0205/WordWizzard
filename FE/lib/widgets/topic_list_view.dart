import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wordwizzard/providers/auth_provider.dart';
import 'package:wordwizzard/providers/id_container_provider.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/services/topic.dart';
import 'package:wordwizzard/widgets/simple_topic_item.dart';

class TopicListView extends StatefulWidget {
  final List<dynamic> topicList;
  final bool classifyByWeek;
  final bool canSelected;
  const TopicListView(
      {super.key,
      required this.topicList,
      required this.classifyByWeek,
      required this.canSelected});

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

  dynamic handleFormatDate(String? date) {
    if (date != null) {
      return DateFormat('yM').format(DateTime.parse(date));
    }
    return false;
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
          context.read<AuthProvider>().logOut();
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

  void handleChooseTopic(int index) {
    String id = topicList[index]["_id"];
    if (context.read<IdContainerProvider>().containId(id)) {
      context.read<IdContainerProvider>().removeId(id);
    } else {
      context.read<IdContainerProvider>().addId(id);
    }
  }

  void handleTopicDetail(int index) {
    Navigator.of(context).pushNamed(topicDetailRoute, arguments: {"topicId": topicList[index]["_id"]});
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
            if (widget.canSelected && (topicList[index]["isChosen"] ?? false)) {
              context
                  .read<IdContainerProvider>()
                  .addId(topicList[index]["_id"]);
            }
            if ((index == 0 ||
                    handleFormatDate(topicList[index]["createdAt"]) !=
                        handleFormatDate(topicList[index - 1]?["createdAt"])) &&
                widget.classifyByWeek) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                          handleFormatDate(topicList[index]["createdAt"]),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600))),
                  SimpleTopicItem(
                      title: topicList[index]["name"],
                      term: topicList[index]["words"],
                      author: {
                        "avatar": topicList[index]["createdBy"]["image"],
                        "name": topicList[index]["createdBy"]["username"]
                      },
                      isDraft: topicList[index]?["sercurityView"] == 'DRAFT',
                      isSelected: topicList[index]["isChosen"] ?? false,
                      canSelected: widget.canSelected,
                      handleTap: () {
                        if (widget.canSelected) {
                          handleChooseTopic(index);
                        } else {
                          handleTopicDetail(index);
                        }
                      })
                ],
              );
            }
            return SimpleTopicItem(
                title: topicList[index]["name"],
                term: topicList[index]["words"],
                author: {
                  "avatar": topicList[index]["createdBy"]["image"],
                  "name": topicList[index]["createdBy"]["username"]
                },
                isDraft: topicList[index]?["sercurityView"] == 'DRAFT',
                isSelected: topicList[index]["isChosen"] ?? false,
                canSelected: widget.canSelected,
                handleTap: () {
                  if(widget.canSelected){
                    handleChooseTopic(index);
                  }else{
                    handleTopicDetail(index);
                  }
                });
          }
        },
      ),
    ));
  }
}
