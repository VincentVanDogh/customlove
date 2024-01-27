import 'dart:collection';

import 'package:frontend/src/app/model/factories/interfaces/model_factory.dart';

import '../user_model.dart';

class UserFactory implements ModelFactory<User> {
  @override
  Map<int, User> parseModels(List<dynamic> items) {
    LinkedHashMap<int, User> users = LinkedHashMap<int, User>();

    for (dynamic element in items) {
      users.putIfAbsent(element['id'], () => User.fromJson(element));
    }

    return users;
  }
}