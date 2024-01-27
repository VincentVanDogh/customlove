import 'dart:async';

class SwipeableEvent {
  final StreamController<bool> _controller = StreamController<bool>.broadcast();
  bool _currentSwipeable = false;

  Stream<bool> get swipeableChanged => _controller.stream;

  void changeSwipeable(bool swipeable) {
    _currentSwipeable = swipeable;
    _controller.add(swipeable);
  }

  bool getSwipeable() {
    return _currentSwipeable;
  }

  Future<bool> getFutureSwipeable() async {
    return _currentSwipeable;
  }

  void dispose() {
    _controller.close();
  }
}
