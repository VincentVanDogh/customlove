import 'package:frontend/src/app/presentation/swipe/util/swipeable_event.dart';

class SharedSwipeableEvent {
  static SwipeableEvent swipeable = SwipeableEvent();

  void dispose() {
    swipeable.dispose();
  }
}