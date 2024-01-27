import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../config/api_config.dart';

class JWTApi {
  static Future<String?> retrieveAccessToken() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    String? token = await storage.read(key: "access_token");

    if (token == null) {
      throw Exception("Token not registered!");
    }

    return token;
  }

  Future<http.Response> get(http.Client client, String url) async {
    String? token = await JWTApi.retrieveAccessToken();
    if (token == null) {
      throw Exception('Not logged in');
    }

    http.Response response =
        await client.get(Uri.parse('${ApiConfig.baseUrl}/$url'), headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 422) {
      // TODO: handle token refresh
      throw Exception('JWT is corrupt');
    }

    return response;
  }

  Future<http.Response> post(http.Client client, String url) async {
    String? token = await JWTApi.retrieveAccessToken();
    if (token == null) {
      throw Exception('Not logged in');
    }

    http.Response response =
    await client.post(Uri.parse('${ApiConfig.baseUrl}/$url'), headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 422) {
      // TODO: handle token refresh
      throw Exception('JWT is corrupt');
    }

    return response;
  }

  Future<http.StreamedResponse> handleRequest(http.Client client, http.BaseRequest req) async {
    String? token = await JWTApi.retrieveAccessToken();
    if (token == null) {
      throw Exception('Not logged in');
    }

    req.headers.addAll({
      'Content-Type': 'application/json',
      'accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    http.StreamedResponse response = await client.send(req);

    if (response.statusCode == 422) {
      // TODO: handle token refresh
      throw Exception('JWT is corrupt');
    }

    return response;
  }
}