import 'package:flutter/material.dart';

class SettingSection extends StatefulWidget {
  final String title;
  final List<Widget> settingsOptions;
  const SettingSection({ super.key, required this.title, required this.settingsOptions });

  @override
  SettingSectionState createState() => SettingSectionState();
}

class SettingSectionState extends State<SettingSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: widget.settingsOptions.map((setting) => setting).toList(),
          ),
        ),
      ],
    );
  }
}