import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:wordwizzard/constants/constants.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/providers/access_scope_provider.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/services/topic.dart';
import 'package:wordwizzard/stream/topics_stream.dart';
import 'package:wordwizzard/widgets/add_topic_secttion.dart';
import 'package:wordwizzard/widgets/custom_toast.dart';
import 'package:wordwizzard/widgets/select_item.dart';

class AddTopicScreen extends StatefulWidget {
  final Map<String,dynamic>? topicDetails;
  const AddTopicScreen({super.key, this.topicDetails});

  @override
  AddTopicScreenState createState() => AddTopicScreenState();
}

class AddTopicScreenState extends State<AddTopicScreen> {
  late int tagIndex;
  FocusNode desFocusNode = FocusNode();
  int focusIndex = 0;
  late TextEditingController titleController;
  late TextEditingController desController;
  late List<dynamic> topicInputs;
  late FToast toast;
  late Map<String,dynamic>? topicDetails;

  @override
  void initState() {
    super.initState();
    topicDetails = widget.topicDetails;
    List<dynamic>? newList;
    if(topicDetails != null){
      newList = topicDetails?["listWords"].map((item) {
        return {"_id": item["_id"], "term": item["general"], "definition": item["meaning"]};
      }).toList();
    }
    topicInputs = newList ?? [
      {"term": "", "definition": ""},
      {"term": "", "definition": ""},
    ];
    tagIndex = topicDetails == null ? 0 : topicTagItems.indexWhere((item) => item.tag == topicDetails?['tag']['value']);
    titleController = TextEditingController(text: topicDetails?["name"] ?? "");
    desController = TextEditingController(text: topicDetails?["description"] ?? "");
    toast = FToast();
    toast.init(context);
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    if (topicDetails != null) {
      Future.delayed(Duration.zero, () {
        context
            .read<AccessScopeProvider>()
            .setAccessScope(topicDetails?["securityView"]);
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    desController.dispose();
    desFocusNode.dispose();
    super.dispose();
  }

  void setFocusIndex(int index) {
    setState(() {
      focusIndex = index;
    });
  }

  Widget adaptiveAction(
      {required BuildContext context,
      required VoidCallback onPressed,
      required Widget child}) {
    final ThemeData theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return TextButton(onPressed: onPressed, child: child);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoDialogAction(onPressed: onPressed, child: child);
    }
  }

  void handleDone() {
    bool flag = true;
    String title = titleController.text;
    String des = desController.text;
    for (var ele in topicInputs) {
      if (ele["term"] == '' || ele["definition"] == '' || ele["term"] == null || ele["definition"] == null) {
        flag = false;
        break;
      }
    }
    if (title.isNotEmpty && topicInputs.length >= 2 && flag) {
      String accessScope = context.read<AccessScopeProvider>().accessScope;
      if(topicDetails == null){
        handleAddTopic(title, des, accessScope,
                topicTagItems[tagIndex].tag, topicInputs)
            .then((val) {
          if (val["code"] == 0) {
            if (accessScope == "PUBLIC") {
              TopicStream().getAllTopicData();
            }
            TopicStream().getMyTopicsData();
            toast.showToast(
                child: const CustomToast(text: "add_success"),
                gravity: ToastGravity.BOTTOM);
            context.read<AccessScopeProvider>().setAccessScope("PRIVATE");
            Navigator.of(context).pushReplacementNamed(topicDetailRoute,
                arguments: {"topicId": val["data"]["_id"]});
          }
        });
      }else{
        handleUpdateTopic(topicDetails?["_id"], title, des, accessScope, topicTagItems[tagIndex].tag, topicInputs).then((val) {
          if (val["code"] == 0) {
            if (accessScope == "PUBLIC") {
              TopicStream().getAllTopicData();
            }
            TopicStream().getMyTopicsData();
            toast.showToast(
                child: const CustomToast(text: "edit_success"),
                gravity: ToastGravity.BOTTOM);
            context.read<AccessScopeProvider>().setAccessScope("PRIVATE");
            Navigator.of(context).pushReplacementNamed(topicDetailRoute,
                arguments: {"topicId": val["data"]["_id"]});
          }
        });
      }
    } else if (title.isNotEmpty || flag) {
      showAdaptiveDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                getTranslated(context, "title_not_done_topic"),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              content: Text(getTranslated(context, "content_not_done_topic")),
              actions: [
                adaptiveAction(
                    context: context,
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Text(getTranslated(context, "delete"))),
                adaptiveAction(
                    context: context,
                    onPressed: () {
                      handleAddTopic(title, des, "DRAFT",
                              topicTagItems[tagIndex].tag, topicInputs)
                          .then((val) {
                        if (val["code"] == 0) {
                          Navigator.of(context).pop();
                        }
                      });
                    },
                    child: Text(getTranslated(context, "save"))),
              ],
            );
          });
    } else {
      Navigator.of(context).pop();
    }
  }

  void handleUploadTopic() {}

  void handleShowTagSelection() {
    handleHideKeyboard();
    showMaterialModalBottomSheet(
        expand: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setSheetState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(getTranslated(context, "select_topic"),
                    style: Theme.of(context).textTheme.titleLarge),
                SizedBox(
                  height: 5 * 48,
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 48,
                    perspective: 0.005,
                    diameterRatio: 1.2,
                    physics: const FixedExtentScrollPhysics(),
                    childDelegate: ListWheelChildBuilderDelegate(
                        childCount: topicTagItems.length,
                        builder: (context, index) {
                          return SelectItem(
                            title: topicTagItems[index].title,
                            icon: topicTagItems[index].icon,
                            useLocale: true,
                            selected: index == tagIndex,
                          );
                        }),
                    controller:
                        FixedExtentScrollController(initialItem: tagIndex),
                    onSelectedItemChanged: (val) {
                      setState(() {
                        setSheetState(() {
                          tagIndex = val;
                        });
                      });
                    },
                  ),
                ),
              ]),
            );
          });
        });
  }

  void addTopicInput() {
    setState(() {
      topicInputs.add({"term": "", "definition": ""});
      focusIndex = (topicInputs.length - 1) * 2;
    });
  }

  void removeTopicInput(int index) {
    setState(() {
      topicInputs.removeAt(index);
    });
  }

  void updateTopic(int index, String? term, String? definition) {
    if (term != null) {
      topicInputs[index]["term"] = term;
    }
    if (definition != null) {
      topicInputs[index]["definition"] = definition;
    }
  }

  void handlleSetting() {
    handleHideKeyboard();
    Navigator.of(context).pushNamed(settingAddTopicRoute);
  }

  void handleNextFocus() {
    setState(() {
      if (focusIndex < (topicInputs.length * 2) - 1) {
        focusIndex++;
      } else {
        addTopicInput();
      }
    });
  }

  void handleHideKeyboard() {
    setState(() {
      focusIndex = -1;
    });
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.gear),
          onPressed: handlleSetting,
        ),
        title: Text(getTranslated(context, topicDetails == null ? "create_topic" : "edit_topic")),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: handleDone,
              child: Text(
                getTranslated(context, "done"),
              ))
        ],
      ),
      bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
              height: 60,
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: const Border(top: BorderSide(color: Colors.grey))),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Positioned(
                          top: constraints.maxHeight / 2 - 20,
                          left: 18,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 40,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: handleNextFocus,
                                  icon: const FaIcon(
                                      FontAwesomeIcons.chevronDown),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                    "${(focusIndex / 2).floor() + 1}/${topicInputs.length}")
                              ],
                            ),
                          )),
                      Positioned(
                        top: constraints.maxHeight / 2 - 24,
                        left: constraints.maxWidth / 2 - 24,
                        child: Container(
                          height: 48,
                          width: 48,
                          alignment: Alignment.center,
                          child: IconButton(
                            onPressed: addTopicInput,
                            icon: const FaIcon(
                              FontAwesomeIcons.circlePlus,
                              size: 32,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              maxLength: 30,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                icon: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: FaIcon(topicTagItems[tagIndex].icon)),
                fillColor: Colors.transparent,
                labelText: getTranslated(context, "topic"),
                border: const UnderlineInputBorder(),
                enabledBorder: const UnderlineInputBorder(),
                focusedBorder:
                    const UnderlineInputBorder(), // Customize the color as needed
              ),
              onEditingComplete: () {
                desFocusNode.requestFocus();
              },
            ),
            TextField(
              controller: desController,
              focusNode: desFocusNode,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                icon: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: const FaIcon(FontAwesomeIcons.comment)),
                fillColor: Colors.transparent,
                labelText: getTranslated(context, "description"),
                border: const UnderlineInputBorder(),
                enabledBorder: const UnderlineInputBorder(),
                focusedBorder:
                    const UnderlineInputBorder(), // Customize the color as needed
              ),
              onEditingComplete: () {
                desFocusNode.unfocus();
                setFocusIndex(0);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  FilledButton.icon(
                      onPressed: handleUploadTopic,
                      icon: const FaIcon(
                        FontAwesomeIcons.arrowUpFromBracket,
                        size: 18,
                      ),
                      label: Text(getTranslated(context, "upload_topic"))),
                  const Spacer(),
                  FilledButton.icon(
                      onPressed: handleShowTagSelection,
                      icon: const FaIcon(FontAwesomeIcons.tags, size: 18),
                      label: Text(getTranslated(context, "add_tag")))
                ],
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: topicInputs.length,
              padding: const EdgeInsets.only(bottom: 40),
              itemBuilder: (context, index) {
                bool isSwiped = false;
                double dragStartX = 0.0;
                return GestureDetector(
                  onHorizontalDragStart: (details) {
                    dragStartX = details.globalPosition.dx;
                  },
                  onHorizontalDragUpdate: (details) {
                    final dx = details.globalPosition.dx;
                    final delta = dx - dragStartX;
                    if (delta < -32) {
                      setState(() {
                        isSwiped = true;
                      });
                    } else {
                      setState(() {
                        isSwiped = false;
                      });
                    }
                  },
                  onHorizontalDragEnd: (details) {
                    setState(() {
                      isSwiped = false;
                    });
                  },
                  child: Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        removeTopicInput(index);
                      },
                      background: Container(
                        decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: const FaIcon(FontAwesomeIcons.trashCan,
                            size: 32, color: Colors.white),
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        transform: Matrix4.translationValues(
                          // ignore: dead_code
                          isSwiped ? -40.0 : 0.0,
                          0.0,
                          0.0,
                        ),
                        child: AddTopicSecttion(
                            index: index,
                            focusIndex: focusIndex,
                            handleFocusChange: setFocusIndex,
                            termVal: topicInputs[index],
                            handleChange: updateTopic),
                      )),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
