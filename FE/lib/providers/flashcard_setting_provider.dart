import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlashcardSettingProvider with ChangeNotifier {
  bool suffleCard = false;
  bool autoPronun = false;
  String frontContent = "term";
  String learnContent = "learn_all";
  
  FlashcardSettingProvider() {
    SharedPreferences.getInstance().then((val) {
      suffleCard = val.getBool("suffleCard") ?? false;
      autoPronun = val.getBool("autoPronun") ?? false;
      frontContent = val.getString("frontContent") ?? "term";
      learnContent = "learn_all";
      notifyListeners();
    });
  }

  void changeSuffleCardSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    suffleCard = !suffleCard;
    prefs.setBool('suffleCard', suffleCard);
    notifyListeners();
  }

  void changeAutoPronunSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    autoPronun = !autoPronun;
    prefs.setBool('autoPronun', autoPronun);
    notifyListeners();
  }

  void changeFrontContentSetting(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    frontContent = value;
    prefs.setString('frontContent', value);
    notifyListeners();
  }

  void changeLearnContentSetting(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    learnContent = value;
    prefs.setString('learnContent', value);
    notifyListeners();
  }
}