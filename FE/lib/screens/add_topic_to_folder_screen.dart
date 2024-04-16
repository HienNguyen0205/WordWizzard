import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/providers/auth_provider.dart';
import 'package:wordwizzard/providers/id_container_provider.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/services/folder.dart';
import 'package:wordwizzard/stream/folders_stream.dart';
import 'package:wordwizzard/widgets/topic_list_view.dart';

class AddTopicToFolderScreen extends StatefulWidget {
  final String folderId;
  const AddTopicToFolderScreen({super.key, required this.folderId});

  @override
  AddTopicToFolderScreenState createState() => AddTopicToFolderScreenState();
}

class AddTopicToFolderScreenState extends State<AddTopicToFolderScreen> {

  void handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void handleDone() {
    List<String> idList = context.read<IdContainerProvider>().idList;
    handleAddTopicsToFolder(widget.folderId, idList).then((val) {
      if(val == 0){
        context.read<IdContainerProvider>().resetList();
        FoldersStream().getFolderDetailsData(widget.folderId);
        Fluttertoast.showToast(msg: "test");
        handleBack();
      }else{
        debugPrint("Error with code $val");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "add_topic"),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        centerTitle: true,
        leading: IconButton(
            onPressed: handleBack,
            icon: const FaIcon(FontAwesomeIcons.arrowLeft)),
        actions: [
          TextButton(
              onPressed: handleDone,
              child: Text(getTranslated(context, "done")))
        ],
      ),
      body: FutureBuilder(
        future: handleGetTopicsAddToFolder(widget.folderId),
        builder: (builder, snapshot) {
          if (snapshot.hasData && snapshot.data?["code"] == 0) {
            List<dynamic> topicList = snapshot.data["data"];
            return Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [TopicListView(
                      topicList: topicList,
                      classifyByWeek: false,
                      canSelected: true),]
                ));
          } else if (snapshot.hasData && snapshot.data?["code"] == -1) {
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
