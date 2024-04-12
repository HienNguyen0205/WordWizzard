import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:wordwizzard/auth/auth.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/services/folder.dart';
import 'package:wordwizzard/widgets/avatar.dart';
import 'package:wordwizzard/widgets/topic_list_view.dart';

class FolderDetailScreen extends StatefulWidget {
  final String folderId;
  const FolderDetailScreen({super.key, required this.folderId});

  @override
  FolderDetailScreenState createState() => FolderDetailScreenState();
}

class FolderDetailScreenState extends State<FolderDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  void handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void handleAddTopicToFolder() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: handleBack,
            icon: const FaIcon(FontAwesomeIcons.arrowLeft)),
        actions: [
          IconButton(
            onPressed: handleAddTopicToFolder,
            icon: const FaIcon(FontAwesomeIcons.plus),
          ),
          IconButton(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.ellipsis),
          ),
        ],
      ),
      body: FutureBuilder(
        future: handleGetFolderDetails(widget.folderId),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data["code"] == 0) {
            dynamic data = snapshot.data;
            return Container(
              margin: const EdgeInsets.only(
                  top: 18, right: 18, bottom: 24, left: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data["name"],
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w600)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "${data["listTopics"].length} ${getTranslated(context, "topic")}"),
                      Row(
                        children: [
                          Avatar(publicId: data[""], radius: 14),
                          const SizedBox(width: 8),
                          Text(data["createdBy"]["username"])
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 32),
                  data["listTopics"].length != 0 ? TopicListView(topicList: data["listTopics"])
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/animation/empty_ani.json"),
                      const SizedBox(height: 18),
                      Text(getTranslated(context, "empty_folder"), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                    ],
                  )
                ],
              ),
            );
          } else if (snapshot.hasData && snapshot.data["code"] == -1) {
            setLogin(false);
            Navigator.of(context)
                .pushNamedAndRemoveUntil(signInRoute, (route) => false);
          }
          return Center(
            child: Lottie.asset('assets/animation/loading.json', height: 80),
          );
        },
      ),
    );
  }
}
