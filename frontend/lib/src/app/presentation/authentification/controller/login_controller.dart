import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/src/app/service/login_service.dart';
import 'package:frontend/src/app/service/user_service.dart';
import 'package:frontend/src/config/app_state.dart';
import 'package:frontend/src/config/exceptions.dart';
import 'package:frontend/src/config/theme.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../model/user_model.dart';
import '../../swipe/util/algo_id_notifier.dart';
import '../../utils/secure_storage_service.dart';

class LoginController {
  var logger = Logger();
  Position? userLocation;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final SecureStorageService _secureStorageService = SecureStorageService();

  Future<void> handleLogout(BuildContext context) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    storage.delete(key: 'access_token');
    Navigator.pushNamed(context, '/');
  }

  Future<void> handleLogin(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;
    LoginService loginService = context.read<LoginService>();
    UserService userService = context.read<UserService>();
    AlgoIdNotifier algoIdNotifier = context.read<AlgoIdNotifier>();

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        // Wait for the completion of the login service
        Map<String, dynamic> loginResult =
            await loginService.loginTo(email, password);

        var accessToken = loginResult["access_token"];

        await _secureStorageService.storeAccessToken(accessToken);

        var userId = loginResult["user"]["id"];

        await _secureStorageService.storeUserId(userId.toString());

        var userMatchingAlgorithm = loginResult["user"]["matching_algorithm"];
        if(userMatchingAlgorithm != null || userMatchingAlgorithm != 0) {
          algoIdNotifier.setAlgoId(userMatchingAlgorithm);
        }

        // If login is successful, navigate to '/home'
        if (context.mounted) {
          userService.updateCurrentUserLocation(userLocation!, accessToken);

          // load users, conversations, matches and first messages
          unawaited(Provider.of<StateManager>(context, listen: false)
              .initialize(context, force: true));

          // save the user object and connect to a websocket
          Provider.of<StateManager>(context, listen: false)
              .registerUser(User.fromJson(loginResult['user']), context);

          Navigator.pushNamed(context, '/home/swipe');
        }
      } catch (e) {
        // Handle different exceptions
        if (e is WrongEmailException) {
          if (context.mounted) {
            errorMessage(context, e.message);
          }
        } else if (e is WrongPasswordException) {
          if (context.mounted) {
            errorMessage(context, e.message);
          }
        } else {
          if (context.mounted) {
            errorMessage(context, "Error during Authentication");
          }
        }
      }
    }
  }

  // error during login message popup
  void errorMessage(context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _customLoveTheme.primaryColor,
          title: Center(
            child: Text(
              message,
              style: TextStyle(color: _customLoveTheme.neutralColor),
            ),
          ),
        );
      },
    );
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
