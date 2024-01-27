import 'package:frontend/src/app/api/login_api.dart';

class LoginService {
  final LoginApi _loginApi;

  LoginService(this._loginApi);

  Future<Map<String, dynamic>> loginTo(email, password) async {
    try {
      final body = _loginApi.loginUser(email, password);
      return body;
    } catch (e) {
      rethrow;
    }
  }
}
