import 'package:flutter/cupertino.dart';

class AlgoIdNotifier extends ChangeNotifier {
  int _algoId = 0;

  int get algoId => _algoId;

  void setAlgoId(int value) {
    _algoId = value;
    notifyListeners();
  }
}