import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _name = 'user has not been registered';

  String get name => _name;
  set name(String newName) {
    _name = newName;
    notifyListeners();
  }
}
