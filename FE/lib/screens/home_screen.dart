import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tab_container/tab_container.dart';
import 'package:wordwizzard/localization/language_constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text("WordWizzard",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
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
            child: Image.asset(
              "assets/images/banner/banner.png",
              fit: BoxFit.fitWidth,
            )),
        Positioned(
          top: 180,
          left: 0,
          right: 0,
          bottom: 0,
          child: TabContainer(
            tabEdge: TabEdge.top,
            color: Colors.white,
            isStringTabs: false,
            tabs: [
              Text(getTranslated(context, "topic"),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,)),
                      // color: currentThemeMode == Brightness.light
                      //     ? Colors.black
                      //     : Colors.white)),
              Text(getTranslated(context, 'popular'),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,))
                      // color: currentThemeMode == Brightness.light
                      //     ? Colors.black
                      //     : Colors.white)),
            ],
            selectedTextStyle:
                textTheme.bodyMedium,
            unselectedTextStyle:
                textTheme.bodyMedium?.copyWith(color: Colors.white),
            children: [
              Container(
                child: Text('Child 1'),
              ),
              Container(
                child: Text('Child 2'),
              ),
            ],
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
