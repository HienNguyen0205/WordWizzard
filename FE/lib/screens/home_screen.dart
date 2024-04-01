import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tab_container/tab_container.dart';
import 'package:wordwizzard/localization/language_constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int index = 0;
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
              Container(
                child: Text('Child 1'),
              ),
              Container(
                child: Text('Child 2'),
              ),
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
