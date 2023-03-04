import 'package:flutter/material.dart';

class CatProvider extends ChangeNotifier {
  String _name = 'Meme';
  int _age = 6;

  String get name => _name;
  int get age => _age;

  set name(String newName) {
    _name = newName;
    notifyListeners();
  }

  set age(int newAge) {
    _age = newAge;
    notifyListeners();
  }

  void methodA() {
    _name = "Gege";
    notifyListeners();
  }

  Widget? build() {
    return Container();
  }
}
