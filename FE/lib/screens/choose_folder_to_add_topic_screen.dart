import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/providers/auth_provider.dart';
import 'package:wordwizzard/providers/id_container_provider.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/services/topic.dart';
import 'package:wordwizzard/widgets/custom_toast.dart';
import 'package:wordwizzard/widgets/simple_folder_item.dart';

class ChooseFolderToAddTopicScreen extends StatefulWidget {
  final String id;
  const ChooseFolderToAddTopicScreen({super.key, required this.id});

  @override
  ChooseFolderToAddTopicScreenState createState() =>
      ChooseFolderToAddTopicScreenState();
}

class ChooseFolderToAddTopicScreenState
    extends State<ChooseFolderToAddTopicScreen> {
  late FToast toast;

  @override
  void initState(){
    super.initState();
    toast = FToast();
    toast.init(context);
  }

  void handleBack() {
    if(Navigator.of(context).canPop()){
      context.read<IdContainerProvider>().resetList();
      Navigator.of(context).pop();
    }
  }

  void handleDone() {
    List<String> list = context.read<IdContainerProvider>().idList;
    handleAddTopicsToFolder(widget.id, list).then((res) {
      if(res["code"] == 0){
        toast.showToast(
          child: const CustomToast(text: "edit_folder_success"),
          gravity: ToastGravity.BOTTOM
        );
        handleBack();
      }else{
        context.read<IdContainerProvider>().resetList();
        debugPrint("Error with code ${res["code"]}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, "add_to_folder"),
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
          centerTitle: true,
          leading: IconButton(onPressed: handleBack, icon: const FaIcon(FontAwesomeIcons.chevronLeft)),
          actions: [
            TextButton(
                onPressed: handleDone,
                child: Text(getTranslated(context, "done")))
          ],
        ),
        body: FutureBuilder(
          future: handleGetFolderToAdd(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data["code"] == 0) {
              List<dynamic> data = snapshot.data["data"];
              return SingleChildScrollView(
                child: ListView.builder(
                    padding: const EdgeInsets.all(18),
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return SimpleFolderItem(
                          id: data[index]["_id"],
                          title: data[index]["name"],
                          initState: data[index]["isChosen"]);
                    }),
              );
            } else if (snapshot.hasData && snapshot.data["code"] == -1) {
              context.read<AuthProvider>().logOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(signInRoute, (route) => false);
            }
            return Center(
              child: Lottie.asset('assets/animation/loading.json', height: 80),
            );
          },
        ));
  }
}
