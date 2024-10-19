import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/services/folder.dart';
import 'package:wordwizzard/stream/folders_stream.dart';
import 'package:wordwizzard/widgets/custom_toast.dart';

class AddFolderScreen extends StatefulWidget {
  final String? folderId;
  final String? name;
  final String? description;
  const AddFolderScreen({super.key, this.folderId, this.name, this.description});

  @override
  AddFolderScreenState createState() => AddFolderScreenState();
}

class AddFolderScreenState extends State<AddFolderScreen> {
  late bool canCreate;
  late String name;
  late String description;
  late FToast toast;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    name = widget.name ?? "";
    description = widget.description ?? "";
    _nameController = TextEditingController(text: name);
    _descriptionController = TextEditingController(text: description);
    canCreate = name != "";
    toast = FToast();
    toast.init(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void handleCancel() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void handleSave() {
    if (name.isNotEmpty) {
      if(widget.name == null){
        handleAddFolder(name, description).then((val) {
          if (val['code'] == 0) {
            FoldersStream().getFoldersData();
            toast.showToast(
                child: const CustomToast(text: "add_success"),
                gravity: ToastGravity.BOTTOM);
            Navigator.of(context).pushReplacementNamed(folderDetailRoute,
                arguments: {"folderId": val['data']['_id']});
          } else if (val['code'] == -1) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                signInRoute, (Route<dynamic> route) => false);
          }
        });
      }else{
        handleEditFolder(widget.folderId as String, name, description).then((val) {
          int count = 0;
          if (val['code'] == 0) {
            FoldersStream().getFolderDetailsData(widget.folderId as String);
            toast.showToast(
                child: const CustomToast(text: "edit_success"),
                gravity: ToastGravity.BOTTOM);
            Navigator.of(context).popUntil((route) {
              return count++ == 2;
            });
          } else if (val['code'] == -1) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                signInRoute, (Route<dynamic> route) => false);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          getTranslated(context, widget.folderId == null ? "new_folder" : "edit_folder"),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
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
              controller: _nameController,
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
              controller: _descriptionController,
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
