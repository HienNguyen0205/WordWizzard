import 'dart:async';

import 'package:wordwizzard/services/user.dart';

class UserStream {
  dynamic userData;
  static final UserStream _instance = UserStream._internal();
  factory UserStream() => _instance;

  UserStream._internal() {
    userController = StreamController<dynamic>.broadcast(sync: true);
  }

  late StreamController<dynamic> userController;
  Stream get userStream => userController.stream;

  void getUserData() {
    handleGetUserInfo().then((val) {
      if(val["code"] == 0){
        userData = val["data"];
        userController.sink.add(userData);
      }else if(val["code"] == -1){
        userController.sink.addError(val["code"]);
      }
    });
  }

  void dispose() {
    userController.close();
  }
}
