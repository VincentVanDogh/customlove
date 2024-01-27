import 'package:flutter/cupertino.dart';
import 'package:frontend/src/app/presentation/swipe/util/swipe_state.dart';

class SwipeStateNotifier extends ChangeNotifier {
  SwipeState _swipeState = SwipeState.OKAY;

  SwipeState get swipeState => _swipeState;

  void setSwipeState(SwipeState swipeState) {
    _swipeState = swipeState;
    notifyListeners();
  }
}