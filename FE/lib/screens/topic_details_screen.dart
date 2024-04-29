import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/providers/auth_provider.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/services/topic.dart';
import 'package:wordwizzard/utils/tts_controller.dart';
import 'package:wordwizzard/widgets/avatar.dart';
import 'package:wordwizzard/widgets/flashcard.dart';

class TopicDetailsScreen extends StatefulWidget {
  final String topicId;
  const TopicDetailsScreen({super.key, required this.topicId});

  @override
  TopicDetailsScreenState createState() => TopicDetailsScreenState();
}

class TopicDetailsScreenState extends State<TopicDetailsScreen> {
  int sliderIndex = 0;
  int wordDisplayType = 0;
  List<dynamic> markWords = [];
  TtsController ttsController = TtsController();
  String userId = "";

  void handleBack() {
    if (Navigator.canPop(context)) {
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

  void handleLearnFlashcard(List<dynamic> list, int? index) {
    Navigator.of(context)
        .pushNamed(flashcardRoute, arguments: {"listWords": list});
  }

  Widget _buildFlashCard(dynamic word) {
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
                Text(word["general"],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500)),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          ttsController.speak(word["general"]);
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.volumeHigh,
                          size: 18,
                        )),
                    IconButton(
                        onPressed: () {
                          word["isMark"] = !word["isMark"];
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.solidStar,
                          size: 18,
                          color: word["isMark"] == true ? Colors.yellow : null,
                        )),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(word["meaning"],
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

  void handleShowSetting() {
    context.read<AuthProvider>().getUserId().then((id) {
      List<Widget?> topicOpts = [
        id == userId
            ? ListTile(
                title: Text(getTranslated(context, "edit")),
                leading: const FaIcon(FontAwesomeIcons.pencil),
                onTap: () {},
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
                onTap: () {},
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
    Navigator.of(context).pushNamed(multipleChoiceSettingRoute, arguments: {"listWord": listWord});
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
          future: handleTopicDetails(widget.topicId),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data?["code"] == 0) {
              dynamic data = snapshot.data["data"];
              userId = data["createdBy"]["_id"];
              List<dynamic> words = snapshot.data["data"]["listWords"];
              markWords =
                  words.where((word) => word['isMark'] == true).toList();
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
                        handleLearnFlashcard(words, 0);
                      }),
                      _buildActionButton(
                          FontAwesomeIcons.listCheck, "quiz", () {
                            handleLearnQuiz(words);
                          }),
                      _buildActionButton(FontAwesomeIcons.penToSquare,
                          "typing_practice", () {}),
                      markWords.isNotEmpty
                          ? LayoutBuilder(
                              builder: (context, constraints) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: ToggleSwitch(
                                    minWidth: constraints.maxWidth / 2,
                                    initialLabelIndex: wordDisplayType,
                                    totalSwitches: 2,
                                    labels: [
                                      getTranslated(context, "learn_all"),
                                      getTranslated(context, "learn_star")
                                    ],
                                    onToggle: (index) {
                                      wordDisplayType = index!;
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
                          itemCount: wordDisplayType == 0
                              ? words.length
                              : markWords.length,
                          itemBuilder: (context, index) {
                            if (wordDisplayType == 0) {
                              return _buildFlashCard(words[index]);
                            } else {
                              return _buildFlashCard(markWords[index]);
                            }
                          }),
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
