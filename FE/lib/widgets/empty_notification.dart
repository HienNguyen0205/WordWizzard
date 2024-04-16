import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wordwizzard/localization/language_constant.dart';

class EmptyNotification extends StatelessWidget {
  final String message;
  const EmptyNotification({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Lottie.asset("assets/animation/empty_ani.json", width: 180, height: 180),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(getTranslated(context, message),
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)))
    ]));
  }
}