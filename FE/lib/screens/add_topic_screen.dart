// ignore_for_file: dead_code
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wordwizzard/constants/constants.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/widgets/add_topic_secttion.dart';
import 'package:wordwizzard/widgets/select_item.dart';

class TermDef {
  String term;
  String definition;
  TermDef({required this.definition, required this.term});
}

class AddTopicScreen extends StatefulWidget {
  const AddTopicScreen({super.key});

  @override
  AddTopicScreenState createState() => AddTopicScreenState();
}

class AddTopicScreenState extends State<AddTopicScreen> {
  String topic = '';
  int tagIndex = 0;
  List<TermDef> topicInputs = [
    TermDef(term: '', definition: ''),
    TermDef(term: '', definition: ''),
  ];

  void handlleSetting() {
    Navigator.of(context).pushNamed(settingAddTopicRoute);
  }

  void handleAddTopic() {}

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
      topicInputs.add(TermDef(definition: '', term: ''));
    });
  }

  void removeTopicInput(int index) {
    setState(() {
      topicInputs.removeAt(index);
    });
  }

  void updateTopic(int index, String? term, String? definition) {
    if (term != null) {
      topicInputs[index].term = term;
    }
    if (definition != null) {
      topicInputs[index].definition = definition;
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
              onPressed: handleAddTopic,
              child: Text(
                getTranslated(context, "done"),
                style: const TextStyle(fontSize: 18),
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
                topic = value;
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
                        decoration: const BoxDecoration(color: Colors.red , borderRadius: BorderRadius.all(Radius.circular(8))),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: const FaIcon(FontAwesomeIcons.trashCan, size: 32, color: Colors.white),
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        transform: Matrix4.translationValues(
                          isSwiped ? -40.0 : 0.0,
                          0.0,
                          0.0,
                        ),
                        child: AddTopicSecttion(
                            index: index, handleChange: updateTopic),
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
