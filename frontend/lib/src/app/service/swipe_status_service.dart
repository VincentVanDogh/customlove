import 'package:frontend/src/app/api/swipe_status_api.dart';

class SwipeStatusService {
  final SwipeStatusApi _swipeStatusApi;

  SwipeStatusService(this._swipeStatusApi);

  Future<String> postView(String token, int userId) async {
    try {
      final result = await _swipeStatusApi.postView(token, userId);
      return result;
    } catch (error) {
      rethrow;
    }
  }

  Future<String> postLike(String token, int userId) async {
    try {
      final result = await _swipeStatusApi.postLike(token, userId);
      return result;
    } catch (error) {
      rethrow;
    }
  }
}
