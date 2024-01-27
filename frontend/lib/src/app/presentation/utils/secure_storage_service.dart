import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> storeAccessToken(String accessToken) async {
    await _storage.write(key: "access_token", value: accessToken);
  }

  Future<String?> retrieveAccessToken() async {
    return await _storage.read(key: "access_token");
  }

  Future<void> storeUserId(String id) async {
    await _storage.write(key: "user_id", value: id);
  }

  Future<String?> retrieveUserId() async {
    return await _storage.read(key: "user_id");
  }
}