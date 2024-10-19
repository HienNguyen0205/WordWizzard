import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wordwizzard/localization/language_constant.dart';

class SelectItem extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool? useLocale;
  final bool selected;

  const SelectItem(
      {super.key, required this.title, this.icon, this.useLocale, required this.selected});

  @override
  Widget build(BuildContext context) {
    CardTheme theme = Theme.of(context).cardTheme;

    return Card(
      color: selected ? Colors.blueAccent : theme.color,
      child: Row(
        mainAxisAlignment: icon != null ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          icon != null
              ? Container(
                  width: 120,
                  alignment: Alignment.center,
                  child: FaIcon(icon,
                      color: selected ? Colors.white : Colors.black))
              : const SizedBox.shrink(),
          Text(useLocale != null && useLocale == true ? getTranslated(context, title) : title,
              style: TextStyle(color: selected ? Colors.white : Colors.black, fontSize: 18)),
        ],
      ),
    );
  }
}
