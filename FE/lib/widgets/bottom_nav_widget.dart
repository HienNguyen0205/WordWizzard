import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/routes/route_contants.dart';

class BottomNavWidget extends StatefulWidget {
  const BottomNavWidget({super.key});

  @override
  BottomNavWidgetState createState() => BottomNavWidgetState();
}

class BottomNavWidgetState extends State<BottomNavWidget>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
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

    return ConvexAppBar(
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
            activeIcon:
                FaIcon(FontAwesomeIcons.house, color: theme.selectedItemColor),
            title: getTranslated(context, "home")),
        TabItem(
            icon: FaIcon(FontAwesomeIcons.rankingStar,
                color: theme.unselectedItemColor),
            activeIcon: FaIcon(FontAwesomeIcons.rankingStar,
                color: theme.selectedItemColor),
            title: getTranslated(context, "ranking")),
        const TabItem(
          icon: Center(
            child: FaIcon(FontAwesomeIcons.plus),
          ),
        ),
        TabItem(
            icon: FaIcon(FontAwesomeIcons.folderOpen,
                color: theme.unselectedItemColor),
            activeIcon: FaIcon(FontAwesomeIcons.folderOpen,
                color: theme.selectedItemColor),
            title: getTranslated(context, "library")),
        TabItem(
            icon: FaIcon(FontAwesomeIcons.solidAddressBook,
                color: theme.unselectedItemColor),
            activeIcon: FaIcon(FontAwesomeIcons.solidAddressBook,
                color: theme.selectedItemColor),
            title: getTranslated(context, "profile")),
      ],
      onTap: (index) {
        if (index == 2) {
          setState(() {
            handleShowBottomSheet();
          });
        }else{
          switch(index){
            case 0:
              
          }
        }
      },
    );
  }
}
