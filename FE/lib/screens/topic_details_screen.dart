import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/providers/auth_provider.dart';
import 'package:wordwizzard/providers/flashcard_setting_provider.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/services/topic.dart';
import 'package:wordwizzard/stream/folders_stream.dart';
import 'package:wordwizzard/stream/topics_stream.dart';
import 'package:wordwizzard/utils/tts_controller.dart';
import 'package:wordwizzard/widgets/avatar.dart';
import 'package:wordwizzard/widgets/custom_toast.dart';
import 'package:wordwizzard/widgets/flashcard.dart';

class TopicDetailsScreen extends StatefulWidget {
  final String topicId;
  const TopicDetailsScreen({super.key, required this.topicId});

  @override
  TopicDetailsScreenState createState() => TopicDetailsScreenState();
}

class TopicDetailsScreenState extends State<TopicDetailsScreen> {
  int sliderIndex = 0;
  List<dynamic> words = [];
  TtsController ttsController = TtsController();
  String userId = "";
  Map<String,dynamic> data = {};
  late FToast toast;

  @override
  void initState() {
    super.initState();
    toast = FToast();
    toast.init(context);
  }

  void handleBack() {
    if (Navigator.canPop(context)) {
      List<String> markList =
          getMarkWords().map((item) => item["_id"] as String).toList();
      handleSaveTopic(widget.topicId, markList);
      Navigator.pop(context);
    }
  }

  Widget _buildActionButton(IconData icon, String text, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          child: Row(
            children: [
              Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  child: FaIcon(icon)),
              const SizedBox(width: 16),
              Text(
                getTranslated(context, text),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleLearnFlashcard(List<dynamic> list) {
    Navigator.of(context)
        .pushNamed(flashcardRoute, arguments: {"listWords": list});
  }

  Widget _buildFlashCard(int index) {
    if (context.watch<FlashcardSettingProvider>().learnContent ==
            "learn_star" && !words[index]["is_mark"]) {
      return const SizedBox.shrink();
    }
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(words[index]["general"],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500)),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          ttsController.speak(words[index]["general"]);
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.volumeHigh,
                          size: 18,
                        )),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            words[index]["is_mark"] = !words[index]["is_mark"];
                          });
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.solidStar,
                          size: 18,
                          color: words[index]["is_mark"] ? Colors.yellow : null,
                        )),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(words[index]["meaning"],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  void handleAddToFolder() {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(chooseFolderToAddTopicRoute,
        arguments: {"id": widget.topicId});
  }

  void handleDeleteTopicBtn() {
    handleDeleteTopic(widget.topicId).then((val) {
      if(val["code"] == 0){
        Future<void> refreshTopic() async {
          TopicStream().getAllTopicData();
          TopicStream().getMyTopicsData();
          FoldersStream().getFoldersData();
        }
        refreshTopic().then((_) {
          toast.showToast(
              child: const CustomToast(text: "delete_success"),
              gravity: ToastGravity.BOTTOM);
          Navigator.popUntil(context, (route) => route.isFirst);
        });
      }
    });
  }

  void handleShowSetting() {
    context.read<AuthProvider>().getUserId().then((id) {
      List<Widget?> topicOpts = [
        id == userId
            ? ListTile(
                title: Text(getTranslated(context, "edit")),
                leading: const FaIcon(FontAwesomeIcons.pencil),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed(addTopicRoute,
                      arguments: {"topicDetails": data});
                },
              )
            : null,
        ListTile(
          title: Text(getTranslated(context, "add_to_folder")),
          leading: const FaIcon(FontAwesomeIcons.folder),
          onTap: handleAddToFolder,
        ),
        id != userId
            ? ListTile(
                title: Text(getTranslated(context, "save_and_edit")),
                leading: const FaIcon(FontAwesomeIcons.floppyDisk),
                onTap: () {},
              )
            : null,
        id == userId
            ? ListTile(
                title: Text(getTranslated(context, "delete_topic")),
                leading: const FaIcon(FontAwesomeIcons.trashCan),
                onTap: handleDeleteTopicBtn,
              )
            : null,
      ];
      showCupertinoModalBottomSheet(
          context: context,
          expand: false,
          builder: (context) {
            return Material(
              child: SafeArea(
                top: false,
                child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return topicOpts[index] ?? const SizedBox.shrink();
                    },
                    separatorBuilder: (context, index) {
                      if (topicOpts[index] != null) {
                        return const Divider();
                      }
                      return const SizedBox.shrink();
                    },
                    itemCount: topicOpts.length),
              ),
            );
          });
    });
  }

  void handleLearnQuiz(List<dynamic> listWord) {
    Navigator.of(context).pushNamed(testingSettingRoute,
        arguments: {"listWord": listWord, "testType": "multipleChoice"});
  }

  void handleLearnFilling(List<dynamic> listWord) {
    Navigator.of(context).pushNamed(testingSettingRoute,
        arguments: {"listWord": listWord, "testType": "filling"});
  }

  List<dynamic> getMarkWords() {
    return words.where((item) => item["is_mark"]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: handleBack,
              icon: const FaIcon(FontAwesomeIcons.arrowLeft)),
          actions: [
            IconButton(
              onPressed: handleShowSetting,
              icon: const FaIcon(FontAwesomeIcons.ellipsis),
            ),
          ],
        ),
        body: FutureBuilder(
          future: handleJoinTopicDetails(widget.topicId),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data?["code"] == 0) {
              data = snapshot.data?["data"];
              userId = data["createdBy"]["_id"];
              if (words.isEmpty) {
                words = data["listWords"];
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        height: 280.0,
                        child: PageView.builder(
                          controller: PageController(viewportFraction: 0.84),
                          itemCount: data["listWords"].length,
                          onPageChanged: (int page) {
                            setState(() {
                              sliderIndex = page;
                            });
                          },
                          itemBuilder: (BuildContext context, int index) {
                            double scaleFactor = 1.0;
                            if (index == sliderIndex) {
                              scaleFactor = 1.0;
                            } else {
                              scaleFactor = 0.92;
                            }
                            return AnimatedContainer(
                                transformAlignment: Alignment.center,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                transform: Matrix4.diagonal3Values(
                                    scaleFactor, scaleFactor, 1.0),
                                child: Flashcard(
                                    term: words[index]["general"],
                                    definition: words[index]["meaning"],
                                    direction: "vertical"));
                          },
                        ),
                      ),
                      Text(
                        data["name"],
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: IntrinsicHeight(
                            child: Row(children: [
                              Avatar(
                                  publicId: data["createdBy"]["image"],
                                  radius: 14),
                              const SizedBox(width: 12),
                              Text(
                                data["createdBy"]["username"],
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              const VerticalDivider(),
                              Text(
                                "${words.length} ${getTranslated(context, "term")}",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              )
                            ]),
                          )),
                      _buildActionButton(
                          FontAwesomeIcons.noteSticky, "flashcard", () {
                        handleLearnFlashcard(words);
                      }),
                      _buildActionButton(FontAwesomeIcons.listCheck, "quiz",
                          () {
                        handleLearnQuiz(words);
                      }),
                      _buildActionButton(
                          FontAwesomeIcons.penToSquare, "typing_practice", () {
                        handleLearnFilling(words);
                      }),
                      words.any((item) => item["is_mark"])
                          ? LayoutBuilder(
                              builder: (context, constraints) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: ToggleSwitch(
                                    minWidth: constraints.maxWidth / 2,
                                    initialLabelIndex: context
                                                .watch<
                                                    FlashcardSettingProvider>()
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
                                      String type;
                                      if (index == 0) {
                                        type = "learn_all";
                                      } else {
                                        type = "learn_star";
                                      }
                                      context
                                          .read<FlashcardSettingProvider>()
                                          .changeLearnContentSetting(type);
                                    },
                                  ),
                                );
                              },
                            )
                          : const SizedBox.shrink(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          getTranslated(context, "term"),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: words.length,
                          itemBuilder: (context, index) =>
                              _buildFlashCard(index)),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasData && snapshot.data?["code"] == -1) {
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
