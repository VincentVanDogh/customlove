import 'dart:convert';

import 'package:frontend/src/app/api/interfaces/paginated_api.dart';
import 'package:frontend/src/app/model/factories/conversation_factory.dart';
import 'package:http/http.dart' as http;

import '../model/conversation_model.dart';
import 'helpers/jwt_api.dart';

class ConversationApi extends PaginatedApi<Conversation> {
  ConversationApi(http.Client client)
      : super(client, "conversations/", ConversationFactory());
  ConversationApi.url(http.Client client, String urlParams)
      : super(client, "conversations/$urlParams", ConversationFactory());

  @override
  ConversationApi copyWith(String urlParams) =>
      ConversationApi.url(client, urlParams);

  Future<Map<String, dynamic>> addConversation(int userId) async {
    JWTApi jwtApi = JWTApi();
    http.Response response = await jwtApi.post(client, "${super.url}$userId");

    if (response.statusCode != 200) {
      throw Exception("The request: POST ${super.url}$userId, returned ${response.statusCode}");
    }

    Map<String, dynamic> data = json.decode(response.body);
    return data;
  }
}
