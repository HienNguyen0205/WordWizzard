import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/utils/shake_widget_state.dart';
import 'package:wordwizzard/widgets/shake_widget.dart';
import 'package:wordwizzard/widgets/test_result_item.dart';

class WordFillingTestScreen extends StatefulWidget {
  final List<dynamic> listWord;
  final int questionQuantity;
  final bool isInstantShowAnswer;
  final bool isAnswerWithTerm;
  final bool isAnswerWithDef;
  const WordFillingTestScreen(
      {super.key,
      required this.listWord,
      required this.questionQuantity,
      required this.isInstantShowAnswer,
      required this.isAnswerWithTerm,
      required this.isAnswerWithDef});

  @override
  WordFillingTestScreenState createState() => WordFillingTestScreenState();
}

class WordFillingTestScreenState extends State<WordFillingTestScreen> {
  late int questionQuantity;
  late List<dynamic> listWord;
  int currStep = 0;
  late String titleProgress;
  double linearProgressValue = 0.0;
  late bool isAnswerWithTerm;
  late bool isAnswerWithDef;
  String question = "";
  String answer = "";
  String userAnswer = "";
  int touchedIndex = -1;
  int rightAns = 0;
  int wrongAns = 0;
  List<dynamic> testHistory = [];
  TextEditingController controller = TextEditingController();
  final shakeKey = GlobalKey<ShakeWidgetState>();
  Color? questionColor;

  @override
  void initState() {
    super.initState();
    listWord = widget.listWord;
    listWord.shuffle();
    questionQuantity = widget.questionQuantity;
    titleProgress = "$currStep/$questionQuantity";
    isAnswerWithTerm = widget.isAnswerWithTerm;
    isAnswerWithDef = widget.isAnswerWithDef;
    pickQuestion();
  }

  void pickQuestion() {
    String type = "";
    if (isAnswerWithTerm && !isAnswerWithDef) {
      type = "general";
    } else if (!isAnswerWithTerm && isAnswerWithDef) {
      type = "meaning";
    } else {
      int rand = Random().nextInt(2);
      type = rand == 0 ? "general" : "meaning";
    }
    setState(() {
      updateProgress();
      if(currStep < questionQuantity){
        question = listWord[currStep][type == "general" ? "meaning" : "general"];
        answer = listWord[currStep][type];
      }
    });
  }

  void updateProgress() {
    setState(() {
      if (currStep < questionQuantity) {
        titleProgress = "${currStep + 1}/$questionQuantity";
      }
      linearProgressValue = (1 / questionQuantity.toDouble()) * currStep;
    });
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (index) {
      bool isTouched = index == touchedIndex;
      double radius = isTouched ? 18 : 14;
      double rightVal = (rightAns / questionQuantity.toDouble()) * 360;
      double wrongVal = (wrongAns / questionQuantity.toDouble()) * 360;
      switch (index) {
        case 0:
          return PieChartSectionData(
            showTitle: false,
            color: Colors.greenAccent,
            value: rightVal,
            radius: radius,
          );
        case 1:
          return PieChartSectionData(
            showTitle: false,
            color: Colors.orangeAccent,
            value: wrongVal,
            radius: radius,
          );
        default:
          throw Error();
      }
    });
  }

  void updateNewQuestion() {
    currStep++;
    pickQuestion();
  }

  void resetQuestionColor() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        questionColor = null;
      });
      updateNewQuestion();
      controller.clear();
    });
  }

  void handleTestHis(bool isRight, String? ans){
    if(isRight){
      testHistory.add({
        "isRight": true,
        "question": question,
        "answer": {"ans": answer, "choose": null}
      });
    }else{
      testHistory.add({
        "isRight": false,
        "question": question,
        "answer": {"ans": answer, "choose": ans}
      });
    }
  }

  void handleAnswer() {
    String trimAns = userAnswer.trim();
    if (trimAns == "") {
      handleTestHis(false, trimAns);
      updateNewQuestion();
      wrongAns++;
    } else if (trimAns == answer.trim().toLowerCase()) {
      handleTestHis(true, null);
      if (widget.isInstantShowAnswer) {
        setState(() {
          questionColor = Colors.green;
        });
        resetQuestionColor();
      } else {
        updateNewQuestion();
      }
      rightAns++;
    } else {
      handleTestHis(false, trimAns);
      if (widget.isInstantShowAnswer) {
        setState(() {
          questionColor = Colors.red;
        });
        resetQuestionColor();
        shakeKey.currentState?.shake();
      } else {
        updateNewQuestion();
      }
      wrongAns++;
    }
  }

  void handleClose() {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleProgress,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        centerTitle: true,
        leading: IconButton(
          onPressed: handleClose,
          icon: const FaIcon(FontAwesomeIcons.xmark),
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(6),
            child: TweenAnimationBuilder(
              duration: const Duration(seconds: 1),
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
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: currStep < questionQuantity
            ? Column(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: ShakeWidget(
                        key: shakeKey,
                        shakeCount: 3,
                        shakeOffset: 10,
                        shakeDuration: const Duration(milliseconds: 500),
                        child: Text(question,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: questionColor)),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          autofocus: true,
                          controller: controller,
                          decoration: const InputDecoration(
                            fillColor: Colors.transparent,
                          ),
                          onChanged: (val) {
                            setState(() {
                              userAnswer = val.toLowerCase();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        alignment: Alignment.center,
                        child: IconButton(
                          onPressed: handleAnswer,
                          icon: FaIcon(
                              userAnswer == ""
                                  ? FontAwesomeIcons.circleXmark
                                  : FontAwesomeIcons.circleUp,
                              color:
                                  userAnswer == "" ? Colors.red : Colors.blue,
                              size: 32),
                        ),
                      )
                    ],
                  )
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Lottie.asset('assets/animation/tick_ani.json',
                            width: 180, height: 180),
                        Text(getTranslated(context, "congra_to_test"),
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
                                      startDegreeOffset: -90,
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
                                        "${(rightAns / questionQuantity.toDouble() * 100).round()}%",
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
                                    Text(getTranslated(context, "right_answer"),
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
                                        rightAns.toString(),
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
                                    Text(getTranslated(context, "wrong_answer"),
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
                                        wrongAns.toString(),
                                        style: const TextStyle(
                                            color: Colors.orange),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: handleClose,
                        child: Text(getTranslated(context, "exit"),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Text(getTranslated(context, "your_answer"),
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500)),
                    ),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: questionQuantity,
                        itemBuilder: (context, index) => TestResultItem(
                            isRight: testHistory[index]["isRight"],
                            question: testHistory[index]["question"],
                            answer: testHistory[index]["answer"]))
                  ],
                ),
              ),
      ),
    );
  }
}
