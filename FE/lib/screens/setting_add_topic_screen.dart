import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/widgets/setting_section.dart';

class SettingAddTopicScreen extends StatefulWidget {
  const SettingAddTopicScreen(
      {super.key, required this.accessScope, required this.setAccessScope});
  final void Function(String scope) setAccessScope;
  final String accessScope;

  @override
  SettingAddTopicScreenState createState() => SettingAddTopicScreenState();
}

class SettingAddTopicScreenState extends State<SettingAddTopicScreen> {
  late String accessScope;

  @override
  void initState() {
    super.initState();
    accessScope = widget.accessScope;
  }

  void handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }

  void setAccessScope(String scope) {
    setState(() {
      accessScope = scope;
    });
    widget.setAccessScope(scope);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, "setting")),
          centerTitle: true,
          leading: IconButton(
              onPressed: handleBack,
              icon: const FaIcon(FontAwesomeIcons.arrowLeft)),
        ),
        body: Container(
          padding: const EdgeInsets.all(12),
          child: ListView(
            children: [
              SettingSection(
                  title: getTranslated(context, "private_policy"),
                  settingsOptions: [
                    ListTile(
                      title: Text(getTranslated(context, "who_can_see")),
                      subtitle: Text(getTranslated(context, accessScope == "PUBLIC" ? "everyone" : "only_me")),
                      leading: const FaIcon(FontAwesomeIcons.eye),
                      trailing: const FaIcon(FontAwesomeIcons.chevronRight),
                      onTap: () {
                        Navigator.of(context).pushNamed(settingAccessScopeRoute,
                            arguments: {
                              "accessScope": accessScope,
                              "setAccessScope": setAccessScope
                            });
                      },
                    ),
                  ])
            ],
          ),
        ));
  }
}
