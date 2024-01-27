import 'package:frontend/src/app/model/interest_model.dart';
import 'package:frontend/src/app/model/language_model.dart';

import 'gender_model.dart';

class UserDetailed {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String bio;
  final String dateOfBirth;
  final String job;
  final int searchRadius;
  final Gender genderIdentity;
  final List<Gender> genderPreferences;
  final int swipesLeft;
  final String swipeLimitResetDate;
  final double latitude;
  final double longitude;
  final List<Interest> interests;
  final List<Language> languages;
  final int matchingAlgorithm;
  final int profilePictureId;

  UserDetailed({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.bio,
    required this.dateOfBirth,
    required this.job,
    required this.searchRadius,
    required this.genderIdentity,
    required this.genderPreferences,
    required this.swipesLeft,
    required this.swipeLimitResetDate,
    required this.latitude,
    required this.longitude,
    required this.interests,
    required this.languages,
    required this.matchingAlgorithm,
    required this.profilePictureId,
  });

  factory UserDetailed.fromJson(Map<String, dynamic> json) {
    List<dynamic> genderJsonList = json['gender_preferences'];
    List<dynamic> interestJsonList = json['interests'];
    List<dynamic> languageJsonList = json['languages'];
    List<Gender> genders = [];
    List<Interest> interests = [];
    List<Language> languages = [];
    for (var gender in genderJsonList) {
      genders.add(Gender(gender['id'] as int, gender['name'] as String));
    }
    for (var interest in interestJsonList) {
      interests.add(Interest(interest['id'] as int, interest['name'] as String));
    }
    for (var language in languageJsonList) {
      languages.add(Language(language['id'] as int, language['name'] as String));
    }

    return UserDetailed(
        id: json['id'] as int,
        firstName: json['first_name'] as String,
        lastName: json['last_name'] as String,
        email: json['email'] as String,
        password: json['password'] as String,
        bio: json['bio'] as String,
        dateOfBirth: json['date_of_birth'] as String,
        job: json['job'] as String,
        searchRadius: json['search_radius'] as int,
        genderIdentity: Gender.fromJson(json['gender_identity']),
        genderPreferences: genders,
        swipesLeft: json['swipes_left'] as int,
        swipeLimitResetDate: json['swipe_limit_reset_date'] as String,
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double,
        interests: interests,
        languages: languages,
        matchingAlgorithm: json['matching_algorithm'] as int,
        profilePictureId: json['profile_picture_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'bio': bio,
      'date_of_birth': dateOfBirth,
      'job': job,
      'search_radius': searchRadius,
      'gender_identity': genderIdentity,
      'gender_preferences': genderPreferences,
      'swipes_left': swipesLeft,
      'swipe_limit_reset_date': swipeLimitResetDate,
      'latitude': latitude,
      'longitude': longitude,
      'interests': interests,
      'languages': languages,
      'matching_algorithm': matchingAlgorithm,
      'profile_picture_id': profilePictureId,
    };
  }
}
