import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wordwizzard/constants/constants.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/services/topic.dart';
import 'package:wordwizzard/stream/topics_stream.dart';
import 'package:wordwizzard/widgets/add_topic_secttion.dart';
import 'package:wordwizzard/widgets/select_item.dart';

class AddTopicScreen extends StatefulWidget {
  const AddTopicScreen({super.key});

  @override
  AddTopicScreenState createState() => AddTopicScreenState();
}

class AddTopicScreenState extends State<AddTopicScreen> {
  String topic = '';
  String description = '';
  int tagIndex = 0;
  String accessScope = 'PRIVATE';
  late List<dynamic> topicInputs;

  @override
  void initState() {
    super.initState();
    topicInputs = [
      {"term": "", "definition": ""},
      {"term": "", "definition": ""},
    ];
  }

  void setAccessScope(String scope) {
    accessScope = scope;
  }

  void handlleSetting() {
    Navigator.of(context).pushNamed(settingAddTopicRoute, arguments: {
      "accessScope": accessScope,
      "setAccessScope": setAccessScope
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
    for (var ele in topicInputs) {
      if (ele["term"] == '' || ele["definition"] == '') {
        flag = false;
        break;
      }
    }
    if (topic.isNotEmpty && topicInputs.length >= 2 && flag) {
      handleAddTopic(topic, description, accessScope,
              topicTagItems[tagIndex].tag, topicInputs)
          .then((val) {
        if (val["code"] == 0) {
          if(accessScope == "PUBLIC"){
            TopicStream().getAllTopicData();
          }
          TopicStream().getMyTopicsData();
        }
      });
    } else if (topic.isNotEmpty || flag) {
      showAdaptiveDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(getTranslated(context, "title_not_done_topic")),
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
                      handleAddTopic(topic, description, "DRAFT", topicTagItems[tagIndex].tag, topicInputs).then((val) {
                        debugPrint(val["code"].toString());
                        if (val["code"] == 0) {
                          
                        }
                      });
                    },
                    child: Text(getTranslated(context, "save"))),
              ],
            );
          });
    }else{
      Navigator.of(context).pop();
    }
  }

  void handleUploadTopic() {}

  void handleShowTagSelection() {
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
                            selected: index == tagIndex,
                          );
                        }),
                    controller:
                        FixedExtentScrollController(initialItem: tagIndex),
                    onSelectedItemChanged: (val) {
                      setSheetState(() {
                        tagIndex = val;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.gear),
          onPressed: handlleSetting,
        ),
        title: Text(getTranslated(context, "create_topic")),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: handleDone,
              child: Text(
                getTranslated(context, "done"),
              ))
        ],
      ),
      bottomNavigationBar: ConvexButton.fab(
        icon: Icons.add,
        onTap: addTopicInput,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                labelText: getTranslated(context, "topic"),
                border: const UnderlineInputBorder(),
                enabledBorder: const UnderlineInputBorder(),
                focusedBorder:
                    const UnderlineInputBorder(), // Customize the color as needed
              ),
              onChanged: (value) {
                if(value.length <= 30){
                  topic = value;
                }
              },
            ),
            TextField(
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                labelText: getTranslated(context, "description"),
                border: const UnderlineInputBorder(),
                enabledBorder: const UnderlineInputBorder(),
                focusedBorder:
                    const UnderlineInputBorder(), // Customize the color as needed
              ),
              onChanged: (value) {
                description = value;
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
                            termVal: topicInputs[index],
                            handleChange: updateTopic),
                      )),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
