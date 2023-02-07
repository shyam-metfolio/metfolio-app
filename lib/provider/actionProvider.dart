import 'package:flutter/cupertino.dart';

// var initialIndex = 0;

class ActionProvider with ChangeNotifier {
  String _navGoldType = '1';
  int _initialIndex = 0;
  int _phyGoldDispalyType = 0;
  int _goalDispalyType = 0;
  int get initialIndex => _initialIndex;
  int get phyGoldDispalyType => _phyGoldDispalyType;
  int get goalDispalyType => _goalDispalyType;
  String get navGoldType => _navGoldType;
  changeActionIndex(index) {
    _initialIndex = index;
    print('_data.initialIndex');
    print(initialIndex);
    notifyListeners();
  }

  phyGoldAction(value) {
    _phyGoldDispalyType = value;
    notifyListeners();
  }

  goalGoldAction(value) {
    _goalDispalyType = value;
    notifyListeners();
  }

  navGoldTypeaction(value) {
    _navGoldType = value;
    notifyListeners();
  }
}
