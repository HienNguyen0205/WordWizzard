import 'package:flutter/material.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/services/folder.dart';
import 'package:wordwizzard/stream/folders_stream.dart';

class AddFolderScreen extends StatefulWidget {
  const AddFolderScreen({super.key});

  @override
  AddFolderScreenState createState() => AddFolderScreenState();
}

class AddFolderScreenState extends State<AddFolderScreen> {
  bool canCreate = false;
  String name = "";
  String description = "";

  void handleCancel() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void handleSave() {
    if (name.isNotEmpty) {
      handleAddFolder(name, description).then((val) {
        if (val['code'] == 0) {
          FoldersStream().getFoldersData();
          Navigator.of(context).pushReplacementNamed(folderDetailRoute, arguments: {"folderId": val['data']['_id']});
        } else if (val['code'] == -1) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              signInRoute, (Route<dynamic> route) => false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(getTranslated(context, "new_folder"), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),),
        leading: TextButton(
            onPressed: handleCancel,
            child: Text(getTranslated(context, "cancel"))),
        leadingWidth: 64,
        actions: [
          canCreate
              ? TextButton(
                  onPressed: handleSave,
                  child: Text(getTranslated(context, "save")))
              : const SizedBox.shrink()
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                labelText: getTranslated(context, "folder_title"),
                border: const UnderlineInputBorder(),
                enabledBorder: const UnderlineInputBorder(),
                focusedBorder:
                    const UnderlineInputBorder(), // Customize the color as needed
              ),
              onChanged: (value) {
                name = value;
                setState(() {
                  if (name.isNotEmpty) {
                    canCreate = true;
                  } else {
                    canCreate = false;
                  }
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                labelText:
                    "${getTranslated(context, 'description')}(${getTranslated(context, 'optional')})",
                border: const UnderlineInputBorder(),
                enabledBorder: const UnderlineInputBorder(),
                focusedBorder:
                    const UnderlineInputBorder(), // Customize the color as needed
              ),
              onChanged: (value) {
                description = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}
