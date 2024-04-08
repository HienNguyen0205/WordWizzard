import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tab_container/tab_container.dart';
import 'package:wordwizzard/auth/auth.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/stream/topics_folders_stream.dart';
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

  TopicsFoldersStream stream = TopicsFoldersStream();

  @override
  void initState() {
    super.initState();
    stream.updateTopicsFoldersData();
  }

  void handleShowAllTopics() {}

  void handleSearchBtn() {
    Navigator.of(context).pushNamed(searchRoute);
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
        stream: stream.topicsFoldersStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data["code"] == 0) {
            final topics = snapshot.data?["topics"];
            final folders = snapshot.data?["folders"];
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
                  isStringTabs: false,
                  tabs: [
                    Text(getTranslated(context, "topic"),
                        style: TextStyle(
                            color: index == 0 ? Colors.black : Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                    Text(getTranslated(context, 'popular'),
                        style: TextStyle(
                            color: index == 1 ? Colors.black : Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500))
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
                                        publicId:
                                            "ivdnlro588kyrxzhcv5z",
                                        author: {
                                          "avatar": topics[index]["createdBy"]
                                              ["image"],
                                          "name": topics[index]["createdBy"]["username"]
                                        },
                                        handleTap: () {},
                                      ));
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated(context, "my_folder"),
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
                              height: 100.0,
                              child: PageView.builder(
                                controller:
                                    PageController(viewportFraction: 0.675),
                                itemCount: folders.length,
                                onPageChanged: (int page) {
                                  setState(() {
                                    folderIndex = page;
                                  });
                                },
                                itemBuilder: (BuildContext context, int index) {
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
                                        topicQuantity: folders[index]["listTopics"],
                                        author: {
                                          "avatar": null,
                                          "name": folders[index]["createdBy"]["username"]
                                        },
                                        handleTap: () {},
                                      ));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container()
                  ],
                  onEnd: () {
                    setState(() {
                      topicIndex = 0;
                      folderIndex = 0;
                      if (index == 0) {
                        index = 1;
                      } else {
                        index = 0;
                      }
                    });
                  },
                ),
              ),
            ]);
          } else if (snapshot.hasData && snapshot.data["code"] != 0) {
            setLogin(false);
            Navigator.of(context).pushNamedAndRemoveUntil(signInRoute, (route) => false);
          }
          return Center(
            child: Lottie.asset('assets/loading/loading.json', height: 80),
          );
        },
      ),
    );
  }
}

// void changeLanguage() async {
//   Locale currentLocale = await getLocale();
//   Locale locale;
//   if(currentLocale.languageCode == 'vi'){
//     locale = await setLocale('en');
//   }else{
//     locale = await setLocale('vi');
//   }
//   MyApp.setLocale(context, locale);
// }