import 'dart:collection';

import 'package:frontend/src/app/model/factories/interfaces/model_factory.dart';

import '../message_model.dart';

class MessageFactory implements ModelFactory<Message> {
  @override
  Map<int, Message> parseModels(List<dynamic> items) {
    LinkedHashMap<int, Message> messages = LinkedHashMap<int, Message>();

    for (dynamic element in items) {
      messages.putIfAbsent(element['id'], () => Message.fromJson(element));
    }

    return messages;
  }
}