import '../../../model/user_model.dart';
import '../../../service/user_service.dart';

class SwipesLeft {
  static Future<int> updateSwipeLeft(String accessToken, UserService userService) async {
    int tmpSwipesLeft = 0;
    await userService.updateCurrentUserSwipesLeft(accessToken).then((User? user) {
      tmpSwipesLeft = user!.swipes_left;
      if(tmpSwipesLeft == 0) {
        print("swipe limit reached");
      }
    });
    return tmpSwipesLeft;
  }

  static Future<int> getCurrentSwipesLeft(String accessToken, int userId, UserService userService) async {
    int tmpSwipesLeft = 0;
    await userService.getUser(accessToken, userId).then((User? user) {
      tmpSwipesLeft = user!.swipes_left;
    });
    return tmpSwipesLeft;
  }

}