import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tab_container/tab_container.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/services/folder.dart';
import 'package:wordwizzard/services/topic.dart';
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
  List topics = [];
  List folders = [];

  Future<List> getData() async {
    List<Future<dynamic>> future = [
      handleGetAllTopics(1, "", 10),
      handleGetAllFolders(1, "", 10),
    ];
    List<dynamic> res = await Future.wait(future);
    return res;
  }

  @override
  void initState() {
    super.initState();
    getData().then((value) {
      setState(() {
        topics = [1, 1, 1];
        folders = [1,1,1];
      });
    });
  }

  void handleShowAllTopics() {}

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
            onPressed: () {},
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.bell, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: Stack(fit: StackFit.expand, children: [
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
                  padding: const EdgeInsets.only(top: 12, left: 12, bottom: 40, right: 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(getTranslated(context, "topics"),
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w500)),
                          TextButton(
                              onPressed: handleShowAllTopics,
                              child: Text(getTranslated(context, "see_more")))
                        ],
                      ),
                      SizedBox(
                        height: 300.0,
                        child: PageView.builder(
                          controller: PageController(viewportFraction: 0.675),
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
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                transform: Matrix4.diagonal3Values(
                                    scaleFactor, scaleFactor, 1.0),
                                child: TopicItem(
                                  title: "lol",
                                  termQuantity: 12,
                                  imgSrc:
                                      "https://res.cloudinary.com/dtrtjisrv/image/upload/f_auto,q_auto/ivdnlro588kyrxzhcv5z",
                                  author: const {"avatar": null, "name": "Chó Mai duy"},
                                  handleTap: () {
                                    
                                  },
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
                                  fontSize: 22, fontWeight: FontWeight.w500)),
                          TextButton(
                              onPressed: handleShowAllTopics,
                              child: Text(getTranslated(context, "see_more")))
                        ],
                      ),
                      SizedBox(
                        height: 100.0,
                        child: PageView.builder(
                          controller: PageController(viewportFraction: 0.675),
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
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                transform: Matrix4.diagonal3Values(
                                    scaleFactor, scaleFactor, 1.0),
                                child: FolderItem(
                                  title: "lol",
                                  topicQuantity: 12,
                                  author: const {
                                    "avatar": null,
                                    "name": "Chó Mai duy"
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
                if (index == 0) {
                  index = 1;
                } else {
                  index = 0;
                }
              });
            },
          ),
        ),
      ]),
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