import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/providers/access_scope_provider.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/widgets/setting_section.dart';

class SettingAddTopicScreen extends StatefulWidget {
  const SettingAddTopicScreen(
      {super.key});

  @override
  SettingAddTopicScreenState createState() => SettingAddTopicScreenState();
}

class SettingAddTopicScreenState extends State<SettingAddTopicScreen> {

  void handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    String accessScope = context.watch<AccessScopeProvider>().accessScope;
    return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, "setting"), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),),
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
                        Navigator.of(context).pushNamed(settingAccessScopeRoute);
                      },
                    ),
                  ])
            ],
          ),
        ));
  }
}
