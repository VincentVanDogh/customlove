import 'package:flutter/material.dart';
import 'package:frontend/src/app/model/user_detailed.dart';
import 'package:frontend/src/app/service/user_service.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../utils/secure_storage_service.dart';

class ProfileController {
  var logger = Logger();

  final SecureStorageService storage = SecureStorageService();

  Future<UserDetailed?> updateUser(
      BuildContext context,
      String job,
      String bio,
      List<int> genderPreferences,
      List<int> interests,
      List<int> languages,
      int searchRadius
      ) async {
      UserService userService = context.read<UserService>();
    try {
      String? token = await storage.retrieveAccessToken();

      return await userService.updateUserProfile(
          token!,
          bio,
          job,
          genderPreferences,
          interests,
          languages,
          searchRadius
      );

    } catch (e) {
      logger.e("Error getting updated user: $e");
      return null;
    }
  }
}
