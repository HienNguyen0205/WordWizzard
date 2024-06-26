import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/providers/auth_provider.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/services/folder.dart';
import 'package:wordwizzard/stream/folders_stream.dart';
import 'package:wordwizzard/widgets/avatar.dart';
import 'package:wordwizzard/widgets/custom_toast.dart';
import 'package:wordwizzard/widgets/topic_list_view.dart';

class FolderDetailScreen extends StatefulWidget {
  final String folderId;
  const FolderDetailScreen({super.key, required this.folderId});

  @override
  FolderDetailScreenState createState() => FolderDetailScreenState();
}

class FolderDetailScreenState extends State<FolderDetailScreen> {
  late FToast toast;
  String name = "";
  String description = "";

  @override
  void initState() {
    super.initState();
    FoldersStream().getFolderDetailsData(widget.folderId);
    toast = FToast();
    toast.init(context);
  }
  void handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
  void handleAddTopicToFolder() {
    Navigator.of(context).pushNamed(addTopicToFolderRoute, arguments: {"folderId": widget.folderId});
  }

  void handleDeleteFolderBtn() {
    handleDeleteFolder(widget.folderId).then((val) {
      if(val['code'] == 0){
        Future<void> refreshFolder() async {
          FoldersStream().getFoldersData();
        }
        refreshFolder().then((_) {
          toast.showToast(
              child: const CustomToast(text: "delete_success"),
              gravity: ToastGravity.BOTTOM);
          int count = 0;
          Navigator.popUntil(context, (route) {
            return count++ == 2 || route.isFirst;
          });
        });
      }
    });
  }

  handleEditFolderBtn() {
    Navigator.of(context).pushNamed(addFolderRoute, arguments: {"folderId": widget.folderId, "name": name, "description": description});
  }

  void handleShowSetting() {
    List<Widget> settingList = [
      ListTile(
        title: Text(getTranslated(context, "edit_folder")),
        leading: const FaIcon(FontAwesomeIcons.pencil),
        onTap: handleEditFolderBtn,
      ),
      ListTile(
        title: Text(getTranslated(context, "delete_folder")),
        leading: const FaIcon(FontAwesomeIcons.trashCan),
        onTap: handleDeleteFolderBtn,
      ),
    ];
    showCupertinoModalBottomSheet(
      context: context,
      builder:(context) {
        return Material(
          child: SafeArea(
            top: false,
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return settingList[index];
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: settingList.length),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: handleBack,
            icon: const FaIcon(FontAwesomeIcons.chevronLeft)),
        actions: [
          IconButton(
            onPressed: handleAddTopicToFolder,
            icon: const FaIcon(FontAwesomeIcons.plus),
          ),
          IconButton(
            onPressed: handleShowSetting,
            icon: const FaIcon(FontAwesomeIcons.ellipsis),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FoldersStream().folderDetailsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            dynamic data = snapshot.data;
            name = data["name"];
            description = data["description"];
            return Container(
              margin: const EdgeInsets.only(
                  top: 18, right: 18, bottom: 24, left: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data["name"],
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w500)),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            "${data["listTopics"].length} ${getTranslated(context, "topic")}"),
                        const VerticalDivider(),
                        Avatar(publicId: data["createdBy"]["image"], radius: 14),
                        const SizedBox(width: 8),
                        Text(data["createdBy"]["username"])
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  data["listTopics"].length != 0
                      ? TopicListView(topicList: data["listTopics"], classifyByWeek: false, canSelected: false)
                      : SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Lottie.asset("assets/animation/empty_ani.json",
                                  width: 180, height: 180),
                              Text(
                                getTranslated(context, "empty_folder"),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        )
                ],
              ),
            );
          } else if (snapshot.hasData) {
            context.read<AuthProvider>().logOut();
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
