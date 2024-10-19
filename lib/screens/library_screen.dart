import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/providers/auth_provider.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/services/folder.dart';
import 'package:wordwizzard/stream/folders_stream.dart';
import 'package:wordwizzard/stream/topics_stream.dart';
import 'package:wordwizzard/widgets/empty_notification.dart';
import 'package:wordwizzard/widgets/folder_item.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wordwizzard/widgets/topic_list_view.dart';

class LibraryScreen extends StatefulWidget {
  final int libraryTab;
  const LibraryScreen({super.key, required this.libraryTab});

  @override
  LibraryScreenState createState() => LibraryScreenState();
}

class LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollFolderController;
  int currentFolderPage = 1;
  List<dynamic> topicList = [];
  List<dynamic> folderList = [];
  bool canLoadFolder = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = widget.libraryTab;
    _scrollFolderController = ScrollController();
    _scrollFolderController.addListener(handleLoadFolder);
    TopicStream().getMyTopicsData();
    FoldersStream().getFoldersData();
  }

  @override
  void dispose() {
    _scrollFolderController.dispose();
    super.dispose();
  }

  void handleLoadFolder() {
    if (_scrollFolderController.position.pixels ==
        _scrollFolderController.position.maxScrollExtent) {
      handleGetAllFolders(currentFolderPage, "", 10).then((val) {
        if (val["code"] == 0) {
          if (val["data"] != []) {
            currentFolderPage += 1;
            setState(() {
              canLoadFolder = true;
              folderList.addAll(val["data"]);
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
          canLoadFolder = false;
        });
      });
    }
  }

  void handleAddBtn() {
    if (_tabController.index == 0) {
      Navigator.of(context).pushNamed(addTopicRoute);
    } else if (_tabController.index == 1) {
      Navigator.of(context).pushNamed(addFolderRoute);
    }
  }

  void handleShowFolderDetails(String id) {
    Navigator.of(context)
        .pushNamed(folderDetailRoute, arguments: {"folderId": id});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: _tabController.index,
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text(getTranslated(context, "library"),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
            actions: [
              IconButton(
                  onPressed: handleAddBtn,
                  icon: const FaIcon(FontAwesomeIcons.plus)),
            ],
            centerTitle: true,
            bottom: TabBar(
              controller: _tabController,
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
            stream: Rx.combineLatest2(TopicStream().myTopicStream,
                FoldersStream().foldersStream, (a, b) => [a, b]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                topicList = snapshot.data?[0];
                folderList = snapshot.data?[1];
                return TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                            top: 18, left: 18, right: 18, bottom: 24),
                      child: snapshot.data?[0].isNotEmpty
                          ? Column(
                            children: [
                              TopicListView(
                                    topicList: topicList,
                                    classifyByWeek: true,
                                    canSelected: false),
                            ],
                          )
                          : const EmptyNotification(message: "not_any_topic")
                    ),
                    Container(
                        margin: const EdgeInsets.only(
                            top: 18, left: 18, right: 18, bottom: 24),
                        child: folderList.isNotEmpty ? ListView.builder(
                            controller: _scrollFolderController,
                            itemCount:
                                folderList.length + (canLoadFolder ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == folderList.length && canLoadFolder) {
                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: Lottie.asset(
                                        'assets/animation/loading.json',
                                        height: 80));
                              } else {
                                dynamic folder = folderList[index];
                                return FolderItem(
                                    title: folder["name"],
                                    topicQuantity: folder["listTopics"],
                                    author: {
                                      "avatar": folder["createdBy"]["image"],
                                      "name": folder["createdBy"]["username"]
                                    },
                                    handleTap: () {
                                      handleShowFolderDetails(folder["_id"]);
                                    });
                              }
                            }) : const EmptyNotification(message: "not_any_folder")
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                context.read<AuthProvider>().logOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(signInRoute, (route) => false);
              }
              return Center(
                child:
                    Lottie.asset('assets/animation/loading.json', height: 80),
              );
            },
          )),
    );
  }
}
