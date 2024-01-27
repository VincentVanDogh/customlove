import 'dart:convert';
import 'dart:math';

import 'package:frontend/src/app/exceptions/bad_request_exception.dart';
import 'package:frontend/src/app/exceptions/not_found_exception.dart';
import 'package:frontend/src/app/model/factories/user_factory.dart';
import 'package:frontend/src/app/model/user_model.dart';
import 'package:frontend/src/config/api_config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../model/gender_model.dart';
import '../model/interest_model.dart';
import '../model/language_model.dart';
import '../model/user_detailed.dart';
import 'interfaces/paginated_api.dart';

class UserApi extends PaginatedApi<User> {
  final logger = Logger();
  Random random = Random();

  UserApi(http.Client client) : super(client, "users", UserFactory());
  UserApi.url(http.Client client, String urlParams)
      : super(client, "users/$urlParams", UserFactory());

  @override
  UserApi copyWith(String urlParams) => UserApi.url(client, urlParams);

  Future<User> getUser(var accessToken, var id) async {
    final response =
        await super.client.get(Uri.parse('${ApiConfig.baseUrl}/users/$id'),
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        );

    if (response.statusCode == 200) {
      var tmp = json.decode(response.body);
      final User user = User.fromJson(tmp);
      return user;
    } else if (response.statusCode == 404) {
      throw NotFoundException("User not found");
    } else if (response.statusCode == 400) {
      throw BadRequestException("Bad request");
    } else {
      throw Exception("Failed to load user");
    }
  }

    Future<Map<String, dynamic>> getUserProfile(String accessToken, int id) async {
    final response =
    await super.client.get(Uri.parse('${ApiConfig.baseUrl}/users/profile/$id'),
      headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      var body = json.decode(response.body);

      // Genders
      var genderJson = jsonDecode(response.body)['genders'] as List;
      List<Gender> genderObjs = genderJson.map((tagJson) => Gender.fromJson(tagJson)).toList();

      // Languages
      var languageJson = jsonDecode(response.body)['languages'] as List;
      List<Language> languageObjs = languageJson.map((tagJson) => Language.fromJson(tagJson)).toList();

      // Interests
      var interestJson = jsonDecode(response.body)['interests'] as List;
      List<Interest> interestObjs = interestJson.map((tagJson) => Interest.fromJson(tagJson)).toList();

      return {
        "user": UserDetailed.fromJson(body['user']),
        "genders": genderObjs,
        "interests": interestObjs,
        "languages": languageObjs,
      };
    } else if (response.statusCode == 404) {
      throw NotFoundException("User not found");
    } else if (response.statusCode == 400) {
      throw BadRequestException("Bad request");
    } else {
      throw Exception("Failed to load user");
    }
  }

  Future<UserDetailed> updateUserProfile(
      String? accessToken,
      String bio,
      String job,
      List<int> genderPreferences,
      List<int> interests,
      List<int> languages,
      int searchRadius
      ) async {

    if (accessToken == null) {
      throw Exception("Token not registered!");
    }

    final Map<String, dynamic> body = {
      "bio": bio,
      "job": job,
      "gender_preference_ids": genderPreferences,
      "interest_ids": interests,
      "language_ids": languages,
      "search_radius": searchRadius
    };
    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/users/profile'),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      var body = json.decode(response.body);

      return UserDetailed.fromJson(body);
    } else if (response.statusCode == 404) {
      throw NotFoundException("User not found");
    } else if (response.statusCode == 400) {
      throw BadRequestException("Bad request");
    } else {
      throw Exception("Failed to load user");
    }
  }

  Future<User> updateUserLocation(
      Position userPosition, var accessToken) async {
    final Map<String, dynamic> body = {
      "latitude": userPosition.latitude,
      "longitude": userPosition.longitude,
    };

    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/users'),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final dynamic jsonItem = json.decode(response.body);
      final User user = User.fromJson(jsonItem);
      return user;
    } else if (response.statusCode == 404) {
      throw NotFoundException("User not found");
    } else if (response.statusCode == 422) {
      throw BadRequestException("Unprocessable entity");
    } else {
      throw Exception("Failed to load user");
    }
  }

  Future<User> updateUserSwipesLeft(var accessToken) async {
    final Map<String, dynamic> body = {
      "swiped": true,
    };

    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/users'),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final dynamic jsonItem = json.decode(response.body);
      final User user = User.fromJson(jsonItem);
      return user;
    } else if (response.statusCode == 404) {
      throw NotFoundException("User not found");
    } else if (response.statusCode == 422) {
      throw BadRequestException("Unprocessable entity");
    } else {
      throw Exception("Failed to load user");
    }
  }

  Future<User> updateCurrentUserMatchingAlgorithm(
      var accessToken, int algoId) async {
    final Map<String, dynamic> body = {
      "algo_id": algoId,
    };

    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/users'),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final dynamic jsonItem = json.decode(response.body);
      final User user = User.fromJson(jsonItem);
      return user;
    } else if (response.statusCode == 404) {
      throw NotFoundException("User not found");
    } else if (response.statusCode == 422) {
      throw BadRequestException("Unprocessable entity");
    } else {
      throw Exception("Failed to load user");
    }
  }

  Future<User?> getAlgoUser(var accessToken, int algoId) async {
    final response = await http.get(
      Uri.parse(
          '${ApiConfig.baseUrl}/users/algo/{algoId}?algoId=$algoId&page=1&size=50'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final dynamic jsonItem = json.decode(response.body);
      if (jsonItem == null) return null;
      final User user = User.fromJson(jsonItem);
      return user;
    } else if (response.statusCode == 404) {
      throw NotFoundException("User not found");
    } else if (response.statusCode == 400) {
      throw BadRequestException("Bad request");
    } else {
      throw Exception("Failed to load user");
    }
  }
}
