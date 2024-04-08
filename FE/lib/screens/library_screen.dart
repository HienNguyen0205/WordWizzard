import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:wordwizzard/auth/auth.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/stream/topics_folders_stream.dart';
import 'package:wordwizzard/widgets/folder_item.dart';
import 'package:wordwizzard/widgets/simple_topic_item.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  LibraryScreenState createState() => LibraryScreenState();
}

class LibraryScreenState extends State<LibraryScreen> {
  List<String> list = <String>['all', 'created', 'learnt'];
  String sortType = 'all';
  TopicsFoldersStream stream = TopicsFoldersStream();

  @override
  void initState() {
    super.initState();
    stream.updateTopicsFoldersData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, "library")),
          actions: [
            IconButton(
                onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.plus))
          ],
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(getTranslated(context, "topic"),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
              ),
              Tab(
                child: Text(getTranslated(context, "folder"),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
        body: StreamBuilder(
            stream: stream.topicsFoldersStream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data["code"] == 0) {
                final topics = snapshot.data?["topics"];
                final folders = snapshot.data?["folders"];
                return TabBarView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: getTranslated(context, "search"),
                                  ),
                                ),
                              ),
                              PopupMenuButton(
                                position: PopupMenuPosition.under,
                                offset: const Offset(0, 16),
                                icon: const FaIcon(FontAwesomeIcons.filter),
                                itemBuilder: (context) => list.map((item) {
                                  return PopupMenuItem(
                                    value: item,
                                    child: Text(getTranslated(context, item)),
                                  );
                                }).toList(),
                                onSelected: (val) {
                                  setState(() {
                                    sortType = val;
                                  });
                                },
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: topics.length,
                                itemBuilder: (context, index) =>
                                    SimpleTopicItem(
                                        title: topics[index]["name"],
                                        term: topics[index]["words"],
                                        author: {
                                          "avatar": topics[index]["createdBy"]
                                              ["image"],
                                          "name": topics[index]["createdBy"]
                                              ["username"]
                                        },
                                        isDraft: topics[index]
                                                ["sercurityView"] ==
                                            'DRAFT',
                                        handleTap: () {})),
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(18),
                        child: ListView.builder(
                            itemCount: folders.length,
                            itemBuilder: (context, index) => FolderItem(
                                title: topics[index]["name"],
                                topicQuantity: folders[index]["listTopics"],
                                author: {
                                  "avatar": topics[index]["createdBy"]["image"],
                                  "name": topics[index]["createdBy"]["username"]
                                },
                                handleTap: () {}))),
                  ],
                );
              } else if (snapshot.hasData && snapshot.data["code"] != 0) {
                setLogin(false);
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(signInRoute, (route) => false);
              }
              return Center(
                child: Lottie.asset('assets/loading/loading.json', height: 80),
              );
            }),
      ),
    );
  }
}
