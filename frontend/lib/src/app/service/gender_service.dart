import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../config/api_config.dart';
import 'package:logger/logger.dart';

import '../../config/exceptions.dart';
import '../model/gender_model.dart';

class GenderService {
  final Logger logger = Logger();

  Future<List<Gender>> getGenders() async {
    String url = "${ApiConfig.baseUrl}/gender-identities/";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var genderJson = jsonDecode(response.body)['items'] as List;
        List<Gender> genderObjs = genderJson.map((tagJson) => Gender.fromJson(tagJson)).toList();
        return genderObjs;
      }
    } catch (error) {
      logger.e('Error: $error');
      if (error is http.ClientException) {
        throw ServerNotRunningException();
      }
    }
    return List<Gender>.empty();
  }
}
