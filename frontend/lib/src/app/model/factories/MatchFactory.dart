import 'dart:collection';

import 'package:frontend/src/app/model/factories/interfaces/model_factory.dart';

import '../match_model.dart';

class MatchFactory implements ModelFactory<Match> {
  @override
  Map<int, Match> parseModels(List<dynamic> items) {
    LinkedHashMap<int, Match> matches = LinkedHashMap<int, Match>();

    for (dynamic element in items) {
      matches.putIfAbsent(element['id'], () => Match.fromJson(element));
    }

    return matches;
  }
}