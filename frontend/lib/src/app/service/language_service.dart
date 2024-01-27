import 'dart:convert';

import 'package:frontend/src/app/model/language_model.dart';
import 'package:http/http.dart' as http;
import '../../config/api_config.dart';
import 'package:logger/logger.dart';

import '../../config/exceptions.dart';

class LanguageService {
  final Logger logger = Logger();

  Future<List<Language>> getLanguages() async {
    String url = "${ApiConfig.baseUrl}/languages/";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var languageJson = jsonDecode(response.body)['items'] as List;
        List<Language> languageObjs = languageJson.map((tagJson) => Language.fromJson(tagJson)).toList();
        return languageObjs;
      }
    } catch (error) {
      logger.e('Error: $error');
      if (error is http.ClientException) {
        throw ServerNotRunningException();
      }
    }
    return List<Language>.empty();
  }
}
