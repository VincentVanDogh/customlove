import 'dart:convert';
import 'package:frontend/src/config/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/src/config/api_config.dart';

class LoginApi {
  final http.Client httpClient;

  LoginApi({required this.httpClient});

  Future<Map<String, dynamic>> loginUser(
      String username, String password) async {
    final Map<String, String> body = {
      'grant_type': '',
      'username': username,
      'password': password,
      'scope': '',
      'client_id': '',
      'client_secret': '',
    };

    final response =
        await httpClient.post(Uri.parse('${ApiConfig.baseUrl}/users/login'),
            headers: {
              'accept': 'application/json',
              'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: body);

    if (response.statusCode == 200) {
      // Successful login, return the response body as a map
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      // Unauthorized (wrong credentials), throw a custom exception
      throw WrongPasswordException();
    } else if (response.statusCode == 404) {
      // Unauthorized (wrong credentials), throw a custom exception
      throw WrongEmailException();
    } else {
      throw Exception('Error during Authentication');
    }
  }
}
