import 'package:frontend/src/app/api/message_api.dart';
import 'package:frontend/src/app/model/message_model.dart';
import 'package:frontend/src/app/service/interfaces/paginated_service.dart';

class MessageService extends PaginatedService<Message, MessageApi> {
  MessageService(super._api);

  @override
  PaginatedService<Message, MessageApi> copyWith(String urlParams) =>
      MessageService(super.api.copyWith(urlParams));
}
