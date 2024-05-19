import 'package:flutter/material.dart';

class AccessScopeProvider with ChangeNotifier {
  String accessScope = 'PRIVATE';

  void setAccessScope(String scope) {
    accessScope = scope;
    notifyListeners();
  }
}