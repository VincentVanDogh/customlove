import 'package:frontend/src/app/api/interfaces/paginated_api.dart';
import 'package:frontend/src/app/model/factories/MessageFactory.dart';
import 'package:http/http.dart' as http;

import '../model/message_model.dart';

class MessageApi extends PaginatedApi<Message> {
  MessageApi(http.Client client): super(client, "swipe_statuses/", MessageFactory());
  MessageApi.url(http.Client client, String urlParams): super(client, "messages/$urlParams", MessageFactory());

  @override
  MessageApi copyWith(String urlParams) => MessageApi.url(client, urlParams);
}