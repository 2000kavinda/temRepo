import 'package:flutter/material.dart';

import 'package:codesafari/src/utils/appColors.dart';

class MyModel extends ChangeNotifier {
  String level = "00";
  String title = "00";
  String currentLevel = "Easy";
  double kLevel = 0.0;
  List<Map<String, dynamic>> questions = [];
  String levelText = "Ooops";
  String levelPara = "Something went wrong...";
  String levelImg = "assets/oops.png";
  Color textCol = AppColors.black1;

  void updateTextCol(Color newValue) {
    textCol = newValue;
    notifyListeners();
  }

  void updateLevel(String newValue) {
    level = newValue;
    notifyListeners();
  }

  void updateTitle(String newValue) {
    title = newValue;
    notifyListeners();
  }

  void updateCurrentLevel(String newValue) {
    currentLevel = newValue;
    notifyListeners();
  }

  void updateKLevel(double newValue) {
    kLevel = newValue;
    notifyListeners();
  }

  void updateQs(var newValue) {
    questions = newValue;
    notifyListeners();
  }

  void updateLevelText(String newValue) {
    levelText = newValue;
    notifyListeners();
  }

  void updateLevelPara(String newValue) {
    levelPara = newValue;
    notifyListeners();
  }

  void updateLevelImg(String newValue) {
    levelImg = newValue;
    notifyListeners();
  }
}
