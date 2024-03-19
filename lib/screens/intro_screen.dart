import 'package:flutter/material.dart';
import 'package:wordwizzard/constants/constants.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:wordwizzard/screens/sign_in_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  void handleDoneBtn (BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignInScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IntroductionScreen(
            showNextButton: true,
            showSkipButton: true,
            showDoneButton: true,
            skip: const Text(
              "Bỏ qua",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            next: const Text(
              "Tiếp",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            done: const Text(
              "Hoàn thành",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                    title: item.title,
                    body: item.body,
                    image: Image.asset(item.imageUrl),
                    decoration: const PageDecoration(
                        pageMargin: EdgeInsets.symmetric(vertical: 60))))
                .toList()));
  }
}
