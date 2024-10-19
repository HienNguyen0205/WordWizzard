import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wordwizzard/localization/language_constant.dart';

class CustomToast extends StatelessWidget {
  final Color? color;
  final IconData? iconData;
  final String text;
  const CustomToast({super.key, this.color, this.iconData, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        color: color ?? Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(iconData ?? FontAwesomeIcons.check),
          const SizedBox(
            width: 12.0,
          ),
          Text(getTranslated(context, text)),
        ],
      ),
    );
  }
}
