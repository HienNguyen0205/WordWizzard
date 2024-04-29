import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/providers/flashcard_setting_provider.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/utils/tts_controller.dart';
import 'package:wordwizzard/widgets/flashcard.dart';

class FlashcardLearningScreen extends StatefulWidget {
  final List<dynamic> listWords;
  final int? currIndex;
  const FlashcardLearningScreen(
      {super.key, required this.listWords, this.currIndex});

  @override
  FlashcardLearningScreenState createState() => FlashcardLearningScreenState();
}

class FlashcardLearningScreenState extends State<FlashcardLearningScreen> {
  String progressTitle = '';
  int wordQuantity = 0;
  late List<dynamic> listWords;
  late List<dynamic> markWords;
  List<dynamic> displayList = [];
  List<dynamic> learningList = [];
  List<dynamic> memorizedList = [];
  Offset centerOffset = Offset.zero;
  Offset cardOffset = Offset.zero;
  ValueNotifier<int> dragStatusNotifier = ValueNotifier<int>(0);
  ValueNotifier<double> rotateNotifier = ValueNotifier<double>(0.0);
  late int currIndex;
  List<int> undoHistory = [];
  double linearProgressValue = 0;
  bool isPlaying = false;
  FlipCardController controller = FlipCardController();
  int touchedIndex = -1;
  StreamSubscription? autoPlaySubscription;
  TtsController ttsController = TtsController();
  bool isFirstLaunch = true;

  @override
  void initState() {
    super.initState();
    listWords = widget.listWords;
    markWords = listWords.where((item) => item["isMark"] == true).toList();
    currIndex = widget.currIndex ?? 0;
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    String learnContent =
        context.watch<FlashcardSettingProvider>().learnContent;
    bool isSuffle = context.watch<FlashcardSettingProvider>().suffleCard;
    setState(() {
      displayList.clear();
      displayList.addAll(learnContent == "learn_all" ? listWords : markWords);
      wordQuantity = displayList.length;
      updateProgress(currIndex);
      if (isSuffle) {
        displayList.shuffle();
      }
    });
  }

  void handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void updateProgress(int val) {
    setState(() {
      if (currIndex < displayList.length) {
        progressTitle = "${val + 1} / $wordQuantity";
      }
      linearProgressValue = (1 / wordQuantity.toDouble()) * val;
    });
  }

  void handleUndo() {
    if (currIndex > 0) {
      setState(() {
        currIndex--;
        progressTitle = "${currIndex + 1} / $wordQuantity";
        linearProgressValue = (1 / wordQuantity.toDouble()) * currIndex;
        if (undoHistory.last == 0) {
          learningList.removeLast();
        } else {
          memorizedList.removeLast();
        }
      });
      undoHistory.removeLast();
    }
  }

  void handleAutoPlay() async {
    ttsController.speak(displayList[currIndex]["general"]);
    await Future.delayed(const Duration(seconds: 2));
    controller.toggleCard();
    await Future.delayed(const Duration(seconds: 2));
    learningList.add(displayList[currIndex]);
    undoHistory.add(0);
    controller.toggleCard();
    setState(() {
      if (currIndex < displayList.length) {
        currIndex++;
        updateProgress(currIndex);
      }
    });
  }

  void handlePlay() {
    if (currIndex < displayList.length) {
      setState(() {
        isPlaying = !isPlaying;
      });
      handleAutoPlay();
      autoPlaySubscription =
          Stream.periodic(const Duration(seconds: 5), (count) => count)
              .takeWhile((count) => currIndex < displayList.length)
              .listen((count) {
        handleAutoPlay();
      });
    }
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (index) {
      bool isTouched = index == touchedIndex;
      double radius = isTouched ? 18 : 14;
      double memorizedVal =
          (memorizedList.length / displayList.length.toDouble()) * 360;
      double learningVal =
          (learningList.length / displayList.length.toDouble()) * 360;
      switch (index) {
        case 0:
          return PieChartSectionData(
            showTitle: false,
            color: Colors.greenAccent,
            value: memorizedVal,
            radius: radius,
          );
        case 1:
          return PieChartSectionData(
            showTitle: false,
            color: Colors.orangeAccent,
            value: learningVal,
            radius: radius,
          );
        default:
          throw Error();
      }
    });
  }

  void handleContinueLearn() {
    if (learningList.isNotEmpty) {
      Navigator.of(context).pushReplacementNamed(flashcardRoute,
          arguments: {"listWords": learningList});
    } else {
      Navigator.of(context).pop();
    }
  }

  void showBottonSheetSettings() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return Material(
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.all(12),
                child: Text(getTranslated(context, "setting"),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 24, fontWeight: FontWeight.w500))),
            const Divider(),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: ListTile(
                        title: Text(getTranslated(context, "shuffle_cards")),
                        leading: const FaIcon(FontAwesomeIcons.shuffle),
                        trailing: Switch(
                          value: context
                              .watch<FlashcardSettingProvider>()
                              .suffleCard,
                          onChanged: (value) {
                            context
                                .read<FlashcardSettingProvider>()
                                .changeSuffleCardSetting();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Card(
                      child: ListTile(
                        title: Text(
                            getTranslated(context, "automatic_pronunciation")),
                        leading: const FaIcon(FontAwesomeIcons.volumeHigh),
                        trailing: Switch(
                          value: context
                              .watch<FlashcardSettingProvider>()
                              .autoPronun,
                          onChanged: (value) {
                            context
                                .read<FlashcardSettingProvider>()
                                .changeAutoPronunSetting();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          getTranslated(context, "flashcard_front_content"),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                        )),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return ToggleSwitch(
                          minWidth: constraints.maxWidth / 2,
                          initialLabelIndex: context
                                      .watch<FlashcardSettingProvider>()
                                      .frontContent ==
                                  "term"
                              ? 0
                              : 1,
                          totalSwitches: 2,
                          labels: [
                            getTranslated(context, "term"),
                            getTranslated(context, "definition")
                          ],
                          onToggle: (index) {
                            if (index == 0) {
                              context
                                  .read<FlashcardSettingProvider>()
                                  .changeFrontContentSetting("term");
                            } else {
                              context
                                  .read<FlashcardSettingProvider>()
                                  .changeFrontContentSetting("definition");
                            }
                          },
                        );
                      },
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          getTranslated(context, "learning_content"),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                        )),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return ToggleSwitch(
                          minWidth: constraints.maxWidth / 2,
                          initialLabelIndex: context
                                      .watch<FlashcardSettingProvider>()
                                      .learnContent ==
                                  "learn_all"
                              ? 0
                              : 1,
                          totalSwitches: 2,
                          labels: [
                            getTranslated(context, "learn_all"),
                            getTranslated(context, "learn_star")
                          ],
                          onToggle: (index) {
                            if (index == 0) {
                              context
                                  .read<FlashcardSettingProvider>()
                                  .changeLearnContentSetting("learn_all");
                            } else {
                              context
                                  .read<FlashcardSettingProvider>()
                                  .changeLearnContentSetting("learn_star");
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isAutoPronun = context.watch<FlashcardSettingProvider>().autoPronun;
    String frontContentType = context.watch<FlashcardSettingProvider>().frontContent;
    String frontContent = frontContentType == "term" ? "general" : "meaning";
    String backContent = frontContentType == "term" ? "meaning" : "general";
    if (isFirstLaunch && isAutoPronun) {
      ttsController.speak(displayList[currIndex]["general"]);
      isFirstLaunch = false;
    }
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: handleBack,
              icon: const FaIcon(FontAwesomeIcons.xmark)),
          title: Text(progressTitle,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
          centerTitle: true,
          actions: currIndex < displayList.length
              ? [
                  IconButton(
                      onPressed: showBottonSheetSettings,
                      icon: const FaIcon(FontAwesomeIcons.gear))
                ]
              : null,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(6),
              child: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                tween: Tween<double>(
                  begin: 0,
                  end: linearProgressValue,
                ),
                builder: (context, value, child) => LinearProgressIndicator(
                  value: value,
                ),
              )),
        ),
        body: currIndex < displayList.length
            ? Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 54,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(24)),
                          border: Border(
                              top: BorderSide(color: Colors.redAccent),
                              right: BorderSide(color: Colors.redAccent),
                              bottom: BorderSide(color: Colors.redAccent)),
                        ),
                        child: Text(learningList.length.toString(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500)),
                      ),
                      Container(
                        width: 54,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(24)),
                          border: Border(
                              top: BorderSide(color: Colors.greenAccent),
                              left: BorderSide(color: Colors.greenAccent),
                              bottom: BorderSide(color: Colors.greenAccent)),
                        ),
                        child: Text(memorizedList.length.toString(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500)),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        centerOffset = Offset(constraints.maxWidth / 2,
                            constraints.maxHeight / 2);
                        return Draggable(
                          feedback: AnimatedBuilder(
                            animation: Listenable.merge(
                                [dragStatusNotifier, rotateNotifier]),
                            builder: (context, child) {
                              Color color = dragStatusNotifier.value == 0
                                  ? Colors.redAccent
                                  : Colors.greenAccent;
                              String text = dragStatusNotifier.value == 0
                                  ? "learning"
                                  : "memorized";
                              return Transform.rotate(
                                angle: rotateNotifier.value,
                                child: SizedBox(
                                  width: constraints.maxWidth,
                                  height: constraints.maxHeight,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        side:
                                            BorderSide(color: color, width: 2),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(18))),
                                    child: Center(
                                      child: Text(
                                        getTranslated(context, text),
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          childWhenDragging: Flashcard(
                            term: currIndex + 1 < displayList.length
                                ? displayList[currIndex + 1][frontContent]
                                : "",
                            definition: currIndex + 1 < displayList.length
                                ? displayList[currIndex + 1][backContent]
                                : "",
                            direction: "horizontal",
                          ),
                          onDragStarted: () {
                            cardOffset = centerOffset;
                          },
                          onDragUpdate: (details) {
                            cardOffset += details.delta;
                            if (cardOffset.dx < centerOffset.dx &&
                                dragStatusNotifier.value == 1) {
                              dragStatusNotifier.value = 0;
                            } else if (cardOffset.dx > centerOffset.dx &&
                                dragStatusNotifier.value == 0) {
                              dragStatusNotifier.value = 1;
                            }
                            rotateNotifier.value =
                                (cardOffset.dx - centerOffset.dx) * 0.0025;
                          },
                          onDragEnd: (details) {
                            double distance = (cardOffset.dx - centerOffset.dx);
                            if (distance.abs() > 120) {
                              if (distance > 0) {
                                setState(() {
                                  memorizedList.add(displayList[currIndex]);
                                  if (currIndex < displayList.length) {
                                    currIndex++;
                                  }
                                });
                                undoHistory.add(1);
                                updateProgress(currIndex);
                              } else {
                                setState(() {
                                  learningList.add(displayList[currIndex]);
                                  if (currIndex < displayList.length) {
                                    currIndex++;
                                  }
                                });
                                undoHistory.add(0);
                                updateProgress(currIndex);
                              }
                              if(isAutoPronun){
                                ttsController.speak(displayList[currIndex]["general"]);
                              }
                            }
                          },
                          child: Flashcard(
                            term: displayList[currIndex][frontContent],
                            definition: displayList[currIndex][backContent],
                            direction: "horizontal",
                            controller: controller,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Opacity(
                          opacity: undoHistory.isNotEmpty ? 1 : 0.5,
                          child: IconButton(
                              onPressed:
                                  undoHistory.isNotEmpty ? handleUndo : null,
                              icon: const FaIcon(FontAwesomeIcons.rotateLeft)),
                        ),
                        IconButton(
                            onPressed: () {
                              ttsController.speak(displayList[currIndex]["general"]);
                            },
                            icon: const FaIcon(FontAwesomeIcons.volumeHigh)),
                        IconButton(
                            onPressed: handlePlay,
                            icon: isPlaying
                                ? const FaIcon(FontAwesomeIcons.pause)
                                : const FaIcon(FontAwesomeIcons.play))
                      ]),
                )
              ])
            : Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        Lottie.asset('assets/animation/tick_ani.json',
                            width: 180, height: 180),
                        Text(getTranslated(context, "congra_to_review"),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500))
                      ],
                    ),
                    SizedBox(
                      height: 200,
                      child: Row(
                        children: [
                          Expanded(
                            child: Stack(
                                alignment: Alignment.center,
                                fit: StackFit.expand,
                                children: [
                                  PieChart(
                                    PieChartData(
                                      pieTouchData: PieTouchData(
                                        touchCallback: (FlTouchEvent event,
                                            pieTouchResponse) {
                                          setState(() {
                                            if (!event
                                                    .isInterestedForInteractions ||
                                                pieTouchResponse == null ||
                                                pieTouchResponse
                                                        .touchedSection ==
                                                    null) {
                                              touchedIndex = -1;
                                              return;
                                            }
                                            touchedIndex = pieTouchResponse
                                                .touchedSection!
                                                .touchedSectionIndex;
                                          });
                                        },
                                      ),
                                      borderData: FlBorderData(
                                        show: false,
                                      ),
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 54,
                                      startDegreeOffset: 90,
                                      sections: showingSections(),
                                    ),
                                    swapAnimationDuration:
                                        const Duration(milliseconds: 300),
                                    swapAnimationCurve: Curves.easeInOut,
                                  ),
                                  Container(
                                      width: 32,
                                      height: 24,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "${(memorizedList.length / displayList.length * 100).round()}%",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      )),
                                ]),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(getTranslated(context, "memorized"),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.greenAccent)),
                                    Container(
                                      width: 40,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.green),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        memorizedList.length.toString(),
                                        style: const TextStyle(
                                            color: Colors.green),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(getTranslated(context, "learning"),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.orangeAccent)),
                                    Container(
                                      width: 40,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.orange),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        learningList.length.toString(),
                                        style: const TextStyle(
                                            color: Colors.orange),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(getTranslated(context, "not_learned"),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500)),
                                    Container(
                                      width: 40,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Theme.of(context).textTheme.titleLarge!.color ?? Colors.black),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text('0'),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                          onPressed: handleContinueLearn,
                          child: Text(
                            getTranslated(
                                context,
                                learningList.isNotEmpty
                                    ? "continue_learn"
                                    : "finish"),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          )),
                    )
                  ],
                ),
              ));
  }
}
