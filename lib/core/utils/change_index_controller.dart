import 'package:flutter/material.dart';

class ChangeIndexController with ChangeNotifier {
  int index = 0;
  int indexOnBoarding = 0;
  bool isMain = false;
 
  void changeIndexFunctionOnBoarding(int index) {
    indexOnBoarding = index;
    changeIndexPageControllerOnBoarding;
    notifyListeners();
  }

  PageController get changeIndexPageControllerOnBoarding =>
      PageController(initialPage: indexOnBoarding);

  void changeIndexFunction(int index) {
    this.index = index;
    notifyListeners();
  }
}
