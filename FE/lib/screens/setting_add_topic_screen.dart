import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wordwizzard/localization/language_constant.dart';

class SettingAddTopicScreen extends StatefulWidget {
  const SettingAddTopicScreen({ super.key });

  @override
  SettingAddTopicScreenState createState() => SettingAddTopicScreenState();
}

class SettingAddTopicScreenState extends State<SettingAddTopicScreen> {

  void handleBack () {
    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "setting")),
        centerTitle: true,
        leading: IconButton(onPressed: handleBack, icon: const FaIcon(FontAwesomeIcons.arrowLeft)),
      ),
      body: ListView(
          
      )
    );
  }
}