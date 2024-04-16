import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tab_container/tab_container.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/providers/auth_provider.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/screens/bottom_nav.dart';
import 'package:wordwizzard/stream/folders_stream.dart';
import 'package:wordwizzard/stream/topics_stream.dart';
import 'package:wordwizzard/widgets/folder_item.dart';
import 'package:wordwizzard/widgets/topic_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int index = 0;
  int topicIndex = 0;
  int folderIndex = 0;

  @override
  void initState() {
    super.initState();
    TopicStream().getAllTopicData();
    FoldersStream().getFoldersData();
  }

  

  void handleShowAllTopics() {}

  void handleShowAllFolders() {
    BottomNav.changeScreen(context, 2);
  }

  void handleSearchBtn() {
    Navigator.of(context).pushNamed(searchRoute);
  }

  void redirectToSignInRoute() {
    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(signInRoute, (route) => false);
    });
  }

  void handleShowNotifications() {
    showMaterialModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18)),
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Text(getTranslated(context, "notifications"),
                            style: Theme.of(context).textTheme.titleLarge),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                      ),
                    ),
                  ],
                ),
                // SingleChildScrollView(
                //   child: ,
                // )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.magnifyingGlass,
                color: Colors.white),
            onPressed: handleSearchBtn,
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.bell, color: Colors.white),
            onPressed: handleShowNotifications,
          )
        ],
      ),
      body: StreamBuilder(
        stream: Rx.combineLatest2(TopicStream().allTopicStream,
            FoldersStream().foldersStream, (a, b) => [a, b]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> topics = snapshot.data?[0];
            List<dynamic> folders = snapshot.data?[1];
            return Stack(fit: StackFit.expand, children: [
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.srcOver),
                    child: Image.asset(
                      "assets/images/banner/banner.png",
                      fit: BoxFit.fitWidth,
                    ),
                  )),
              Positioned(
                top: 180,
                left: 0,
                right: 0,
                bottom: 0,
                child: TabContainer(
                  tabEdge: TabEdge.top,
                  color: Theme.of(context).colorScheme.background,
                  selectedTextStyle: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
                  unselectedTextStyle: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white, fontSize: 18,
                          fontWeight: FontWeight.w500),
                  tabs: [
                    Text(getTranslated(context, "topic")),
                    Text(getTranslated(context, 'popular'))
                  ],
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 24, left: 12, bottom: 60, right: 12),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated(context, "topics"),
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500)),
                                TextButton(
                                    onPressed: handleShowAllTopics,
                                    child: Text(
                                        getTranslated(context, "see_more")))
                              ],
                            ),
                            SizedBox(
                              height: 260.0,
                              child: PageView.builder(
                                controller:
                                    PageController(viewportFraction: 0.675),
                                itemCount: topics.length,
                                onPageChanged: (int page) {
                                  setState(() {
                                    topicIndex = page;
                                  });
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  double scaleFactor = 1.0;
                                  if (index == topicIndex) {
                                    scaleFactor = 1.0;
                                  } else {
                                    scaleFactor = 0.7;
                                  }
                                  return AnimatedContainer(
                                      transformAlignment: Alignment.center,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      transform: Matrix4.diagonal3Values(
                                          scaleFactor, scaleFactor, 1.0),
                                      child: TopicItem(
                                        title: topics[index]["name"],
                                        termQuantity: topics[index]["words"],
                                        publicId: topics[index]["tag"]["image"],
                                        author: {
                                          "avatar": topics[index]["createdBy"]
                                              ["image"],
                                          "name": topics[index]["createdBy"]
                                              ["username"]
                                        },
                                        handleTap: () {},
                                      ));
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                            folders.isNotEmpty ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(getTranslated(context, "my_folder"),
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500)),
                                    TextButton(
                                        onPressed: handleShowAllFolders,
                                        child: Text(
                                            getTranslated(context, "see_more")))
                                  ],
                                ),
                                SizedBox(
                                  height: 104.0,
                                  child: PageView.builder(
                                    controller:
                                        PageController(viewportFraction: 0.675),
                                    itemCount: folders.length,
                                    onPageChanged: (int page) {
                                      setState(() {
                                        folderIndex = page;
                                      });
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      double scaleFactor = 1.0;
                                      if (index == folderIndex) {
                                        scaleFactor = 1.0;
                                      } else {
                                        scaleFactor = 0.7;
                                      }
                                      return AnimatedContainer(
                                          transformAlignment: Alignment.center,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                          transform: Matrix4.diagonal3Values(
                                              scaleFactor, scaleFactor, 1.0),
                                          child: FolderItem(
                                            title: folders[index]["name"],
                                            topicQuantity: folders[index]
                                                ["listTopics"],
                                            author: {
                                              "avatar": null,
                                              "name": folders[index]
                                                  ["createdBy"]["username"]
                                            },
                                            handleTap: () {},
                                          ));
                                    },
                                  ),
                                ),
                              ],
                            ) : const SizedBox.shrink()
                          ],
                        ),
                      ),
                    ),
                    Container()
                  ],
                ),
              ),
            ]);
          } else if (snapshot.hasError) {
            context.read<AuthProvider>().logOut();
            redirectToSignInRoute();
          }
          return Center(
            child: Lottie.asset('assets/animation/loading.json', height: 80),
          );
        },
      ),
    );
  }
}