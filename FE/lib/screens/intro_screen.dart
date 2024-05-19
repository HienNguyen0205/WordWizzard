import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wordwizzard/constants/constants.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  void handleDoneBtn(BuildContext context) {
    setFirstLaunchFlag();
    Navigator.of(context).pushReplacementNamed(signInRoute);
  }

  Future<void> setFirstLaunchFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IntroductionScreen(
            showNextButton: true,
            showSkipButton: true,
            showDoneButton: true,
            skip: Text(
              getTranslated(context, "skip"),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            next: Text(
              getTranslated(context, "next"),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            done: Text(
              getTranslated(context, "done"),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            onDone: () {
              handleDoneBtn(context);
            },
            dotsDecorator: DotsDecorator(
              size: const Size.square(10.0),
              activeSize: const Size(20.0, 10.0),
              activeColor: Theme.of(context).colorScheme.secondary,
              color: Colors.black26,
              spacing: const EdgeInsets.symmetric(horizontal: 3.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
            ),
            pages: introData
                .map((item) => PageViewModel(
                    title: getTranslated(context, item.title),
                    body: getTranslated(context, item.body),
                    image: SvgPicture.asset(item.imageUrl),
                    decoration: const PageDecoration(
                        pageMargin: EdgeInsets.symmetric(vertical: 60))))
                .toList()));
  }
}
