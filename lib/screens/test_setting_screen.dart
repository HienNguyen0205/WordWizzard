import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/widgets/select_item.dart';

class TestSetting extends StatefulWidget {
  final String id;
  final List<dynamic> listWord;
  final String testType;
  const TestSetting({super.key, required this.id, required this.listWord, required this.testType});

  @override
  TestSettingState createState() => TestSettingState();
}

class TestSettingState extends State<TestSetting> {
  late List<dynamic> listWord;
  List<int> quantityList = [];
  int questionQuantity = 2;
  bool isShowAnswerInstantly = false;
  bool isAnswerWithTerm = false;
  bool isAnswerWithDef = true;

  @override
  void initState() {
    listWord = widget.listWord;
    for (int i = 2; i <= listWord.length; i++) {
      quantityList.add(i);
    }
    super.initState();
  }

  void handleBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void handleShowQuantitySelection() {
    showMaterialModalBottomSheet(
        expand: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setSheetState) {
            return Padding(
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
                        childCount: quantityList.length,
                        builder: (context, index) {
                          return SelectItem(
                            title: quantityList[index].toString(),
                            useLocale: false,
                            selected: quantityList[index] == questionQuantity,
                          );
                        }),
                    onSelectedItemChanged: (index) {
                      setSheetState(() {
                        setState(() {
                          questionQuantity = quantityList[index];
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

  void handleShowAnswerSelection() {
    showMaterialModalBottomSheet(
        expand: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setSheetState) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(getTranslated(context, "term")),
                      trailing: Switch(
                        value: isAnswerWithTerm,
                        onChanged: (value) {
                          if (!(isAnswerWithDef == false && value == false)) {
                            setSheetState(() {
                              setState(() {
                                isAnswerWithTerm = value;
                              });
                            });
                          }
                        },
                      ),
                    ),
                    ListTile(
                        title: Text(getTranslated(context, "definition")),
                        trailing: Switch(
                            value: isAnswerWithDef,
                            onChanged: (value) {
                              if (!(isAnswerWithTerm == false &&
                                  value == false)) {
                                setSheetState(() {
                                  setState(() {
                                    isAnswerWithDef = value;
                                  });
                                });
                              }
                            }))
                  ],
                ),
              );
            },
          );
        });
  }

  void handleTakeATest() {
    if(widget.testType == "multipleChoice"){
      Navigator.of(context).pushReplacementNamed(multipleChoiceTestRoute, arguments: {
        "id": widget.id,
        "listWord": listWord,
        "questionQuantity": questionQuantity,
        "isInstantShowAnswer": isShowAnswerInstantly,
        "isAnswerWithTerm": isAnswerWithTerm,
        "isAnswerWithDef": isAnswerWithDef,
      });
    }else{
      Navigator.of(context).pushReplacementNamed(wordFillingTestRoute, arguments: {
        "id": widget.id,
        "listWord": listWord,
        "questionQuantity": questionQuantity,
        "isInstantShowAnswer": isShowAnswerInstantly,
        "isAnswerWithTerm": isAnswerWithTerm,
        "isAnswerWithDef": isAnswerWithDef,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: handleBack,
          icon: const FaIcon(FontAwesomeIcons.xmark),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(getTranslated(context, "multiple_choice_setting"),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w500)),
            ),
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      getTranslated(context, "question_quantity"),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(questionQuantity.toString()),
                    trailing: const FaIcon(FontAwesomeIcons.caretDown),
                    onTap: handleShowQuantitySelection,
                  ),
                  ListTile(
                    title: Text(getTranslated(context, "instant_show_answer"),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    trailing: Switch(
                      value: isShowAnswerInstantly,
                      onChanged: (value) {
                        setState(() {
                          isShowAnswerInstantly = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(getTranslated(context, "answer_with"),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    subtitle: Text(
                        "${isAnswerWithTerm ? getTranslated(context, "term") : ""}${isAnswerWithDef && isAnswerWithTerm ? "," : ""} ${isAnswerWithDef ? getTranslated(context, "definition") : ""}"),
                    trailing: const FaIcon(FontAwesomeIcons.caretDown),
                    onTap: handleShowAnswerSelection,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              width: double.infinity,
              height: 80,
              child: FilledButton(
                onPressed: handleTakeATest,
                child: Text(getTranslated(context, "take_a_test"), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500))
              ),
            )
          ],
        ),
      ),
    );
  }
}
