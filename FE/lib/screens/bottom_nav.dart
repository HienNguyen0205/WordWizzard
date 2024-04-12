import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/screens/home_screen.dart';
import 'package:wordwizzard/screens/library_screen.dart';
import 'package:wordwizzard/screens/setting_screen.dart';
import 'package:wordwizzard/screens/ranking_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  static void changeScreen(BuildContext context, int index){
    BottomNavState? state = context.findAncestorStateOfType<BottomNavState>();
    state?.handleSetSelectedIndex(index);
  }

  @override
  BottomNavState createState() => BottomNavState();
}

class BottomNavState extends State<BottomNav> with TickerProviderStateMixin{
  int selectedIndex = 0;
  late TabController tabController;
  late List<Widget> screens;

  @override
  void initState(){
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    screens = [
      const HomeScreen(),
      const RankingScreen(),
      const LibraryScreen(libraryTab: 0),
      const SettingScreen(),
    ];
  }

  void handleSetSelectedIndex(int index) {
    tabController.index = index > 1 ? index + 1 : index;
    if(index == 2){
      setState(() {
        screens[2] = const LibraryScreen(libraryTab: 1);
      });
    }
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).bottomNavigationBarTheme;

    void handleAddTopicBtn() {
      Navigator.pop(context);
      Navigator.of(context).pushNamed(addTopicRoute);
    }

    void handleAddFolderBtn() {
      Navigator.pop(context);
      Navigator.of(context).pushNamed(addFolderRoute);
    }

    void handleShowBottomSheet() {
      showMaterialModalBottomSheet(
        expand: false,
        context: context,
        builder: (context) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                clipBehavior: Clip.hardEdge,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: handleAddTopicBtn,
                  child: Container(
                    padding: const EdgeInsets.only(left: 18),
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    height: 64,
                    child: Row(children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 18),
                        child: FaIcon(FontAwesomeIcons.clone),
                      ),
                      Text(getTranslated(context, "topic"),
                          style: const TextStyle(fontSize: 18)),
                    ]),
                  ),
                ),
              ),
              Card(
                clipBehavior: Clip.hardEdge,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: handleAddFolderBtn,
                  child: Container(
                    padding: const EdgeInsets.only(left: 18),
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    height: 64,
                    child: Row(children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 18),
                        child: FaIcon(FontAwesomeIcons.folder),
                      ),
                      Text(getTranslated(context, "folder"),
                          style: const TextStyle(fontSize: 18)),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
        body: screens[selectedIndex],
        bottomNavigationBar: ConvexAppBar(
          controller: tabController,
          backgroundColor: theme.backgroundColor,
          color: theme.unselectedItemColor,
          activeColor: theme.selectedItemColor,
          height: 64,
          style: TabStyle.fixedCircle,
          items: [
            TabItem(
                icon: FaIcon(FontAwesomeIcons.house,
                    color: theme.unselectedItemColor),
                activeIcon: FaIcon(FontAwesomeIcons.house,
                    color: theme.selectedItemColor),
                title: getTranslated(context, "home")),
            TabItem(
                icon: FaIcon(FontAwesomeIcons.rankingStar,
                    color: theme.unselectedItemColor),
                activeIcon: FaIcon(FontAwesomeIcons.rankingStar,
                    color: theme.selectedItemColor),
                title: getTranslated(context, "ranking")),
            const TabItem(
              icon: Center(
                child: FaIcon(FontAwesomeIcons.plus, color: Colors.white,),
              ),
            ),
            TabItem(
                icon: FaIcon(FontAwesomeIcons.folderOpen,
                    color: theme.unselectedItemColor),
                activeIcon: FaIcon(FontAwesomeIcons.folderOpen,
                    color: theme.selectedItemColor),
                title: getTranslated(context, "library")),
            TabItem(
                icon: FaIcon(FontAwesomeIcons.gear,
                    color: theme.unselectedItemColor),
                activeIcon:
                    FaIcon(FontAwesomeIcons.gear, color: theme.selectedItemColor),
                title: getTranslated(context, "setting")),
          ],
          onTap: (index) {
            if (index != 2) {
              setState(() {
                selectedIndex = index > 2 ? index - 1 : index;
              });
            } else {
              handleShowBottomSheet();
            }
          },
        ),
      );
  }
}
