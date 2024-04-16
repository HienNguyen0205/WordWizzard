import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wordwizzard/localization/language_constant.dart';

class SelectItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;

  const SelectItem({super.key, required this.title, required this.icon, required this.selected});

  @override
  Widget build(BuildContext context) {
    CardTheme theme = Theme.of(context).cardTheme;

    return Card(
      color: selected ? Colors.blueAccent : theme.color,
      child: Row(
        children: [
          Container(
              width: 120, alignment: Alignment.center, child: FaIcon(icon, color: selected ? Colors.white : Colors.black)),
          Text(getTranslated(context, title), style: TextStyle(color: selected ? Colors.white : Colors.black)),
        ],
      ),
    );
  }
}
