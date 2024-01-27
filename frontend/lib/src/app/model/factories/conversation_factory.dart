import 'dart:collection';

import 'package:frontend/src/app/model/conversation_model.dart';
import 'package:frontend/src/app/model/factories/interfaces/model_factory.dart';

class ConversationFactory implements ModelFactory<Conversation> {
  @override
  Map<int, Conversation> parseModels(List<dynamic> items) {
    LinkedHashMap<int, Conversation> conversations = LinkedHashMap<int, Conversation>();

    for (dynamic element in items) {
      conversations.putIfAbsent(element['id'], () => Conversation.fromJson(element));
    }

    return conversations;
  }
}