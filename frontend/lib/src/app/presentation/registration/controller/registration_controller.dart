import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/src/app/model/gender_model.dart';
import 'package:frontend/src/app/model/interest_model.dart';
import 'package:frontend/src/app/presentation/utils/secure_storage_service.dart';
import 'package:frontend/src/app/service/registration_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../../config/app_state.dart';
import '../../../model/language_model.dart';
import '../../../model/user_model.dart';
import '../../../service/user_service.dart';
import '../../onboarding/pages/onboarding.dart';
import '../../swipe/util/content.dart';

class RegistrationController {
  var logger = Logger();

  final SecureStorageService _secureStorageService = SecureStorageService();



  Future<bool> emailExists(BuildContext context, String email) async {
    RegistrationService registrationService = context.read<RegistrationService>();

    try {
      await registrationService.getUserByEmail(email);
      // Retrieving the user based on his/her email did not throw an exception,
      // meaning a user with a corresponding email exists in the database
      return true;
    } catch (e) {
      // User was not found, therefore there is no user with entered email in
      // the database
      return false;
    }
  }

  Future<void> handleRegistration(
      BuildContext context,
      final String? firstName,
      final String? lastName,
      final String? email,
      final String? password,
      final String? bio,
      final String? birthdate,
      final String? job,
      final Position? location,
      final double? searchRadius,
      final Gender? gender,
      final List<Gender> genderPreferences,
      final XFile? profilePicture,
      final List<Interest> userInterestIdList,
      final List<Language> languages
    ) async {

    RegistrationService registrationService = context.read<RegistrationService>();
    UserService userService = context.read<UserService>();

    try {
      // Wait for the completion of the registration service
      Map<String, dynamic> registrationResult =
      await registrationService.registerTo(
          firstName!,
          lastName!,
          email!,
          password!,
          bio ?? "",
          convertDateToJsonDate(birthdate!),
          job ?? "",
          location!,
          searchRadius!.toInt(),
          gender!.id,
          convertGenderListToGenderIdList(genderPreferences),
          profilePicture,
          convertInterestListToInterestIdList(userInterestIdList),
          convertLanguageListToLanguageIdList(languages)
      );

      var accessToken = registrationResult["access_token"];
      await _secureStorageService.storeAccessToken(accessToken);

      var userId = registrationResult["user"]["id"];
      await _secureStorageService.storeUserId(userId.toString());

      List<List<dynamic>> usersLists = List.generate(genderPreferences.length, (index) => []);

      for (int i = 0; i < genderPreferences.length; i++) {
        String genderPreferenceString = genderPreferences[i].name.toLowerCase();
        String jsonString = await rootBundle.loadString("assets/exsys_trainings_users_$genderPreferenceString.json");
        final userData = await json.decode(jsonString);
        usersLists[i] = userData["exsys_trainings_users_$genderPreferenceString"];
      }

      List<dynamic> users = [];
      if (genderPreferences.length == 1) {
        users = usersLists[0];
      } else if (genderPreferences.length == 2) {
        users = [...usersLists[0].take(7), ...usersLists[1].getRange(usersLists[1].length - 7, usersLists[1].length)];
      } else {
        users = [...usersLists[0].take(5), ...usersLists[1].getRange(usersLists[1].length - 9, usersLists[1].length - 4), ...usersLists[2].getRange(usersLists[2].length - 4, usersLists[2].length)];
      }

      List<Content> usersContent = users.map((item) {
        return Content(
            name: item["name"],
            gender: item["gender"],
            age: item["age"],
            bio: item["bio"],
            interests: List<String>.from(item["interests"]));
      }).toList();

      // If registration is successful, navigate to '/home/swipe'
      if (context.mounted) {
        userService.updateCurrentUserLocation(location, accessToken);

        // load users, conversations, matches and first messages
        unawaited(Provider.of<StateManager>(context, listen: false).initialize(context));

        // save the user object and connect to a websocket
        Provider.of<StateManager>(context, listen: false).registerUser(User.fromJson(registrationResult['user']), context);

        Navigator.of(context).popUntil((route) => route.isFirst);
        //Navigator.of(context).pushReplacementNamed('/home/swipe');
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => OnboardingPage(userService: context.read<UserService>(), usersContent: usersContent)),
        );
      }
    } catch (e) {
      logger.e('Entered exception: $e');
      // TODO: Handle different exceptions
    }

  }

  String convertDateToJsonDate(String date) {
    return "${date}T00:00:00.0";
  }

  List<int> convertInterestListToInterestIdList(List<Interest> interests) {
    List<int> interestIds = [];
    for (Interest interest in interests) {
      interestIds.add(interest.id);
    }
    return interestIds;
  }

  List<int> convertGenderListToGenderIdList(List<Gender> genders) {
    List<int> genderIds = [];
    for (Gender gender in genders) {
      genderIds.add(gender.id);
    }
    return genderIds;
  }

  List<int> convertLanguageListToLanguageIdList(List<Language> languages) {
    List<int> languageIds = [];
    for (Language language in languages) {
      languageIds.add(language.id);
    }
    return languageIds;
  }

  String genderListToString(List<Gender> genders) {
    if (genders.isEmpty) {
      return "";
    }
    String genderStr = "";
    for (Gender gender in genders) {
      genderStr +=  "${gender.name}, ";
    }
    return genderStr.substring(0, genderStr.length - 2);
  }

  String interestsListToString(List<Interest> interests) {
    if (interests.isEmpty) {
      return "";
    }
    String interestStr = "";
    for (Interest interest in interests) {
      interestStr +=  "${interest.name}, ";
    }
    return interestStr.substring(0, interestStr.length - 2);
  }

  String languageListToString(List<Language> languages) {
    if (languages.isEmpty) {
      return "";
    }
    String languageStr = "";
    for (Language language in languages) {
      languageStr +=  "${language.name}, ";
    }
    return languageStr.substring(0, languageStr.length - 2);
  }

}
