import 'package:frontend/src/app/api/interfaces/paginated_api.dart';
import 'package:frontend/src/app/service/interfaces/paginated_service.dart';

import '../api/match_api.dart';
import '../model/match_model.dart';

class MatchService extends PaginatedService<Match, MatchApi> {
  MatchService(super._api);

  @override
  PaginatedService<Match, MatchApi> copyWith(String urlParams)
  => MatchService(super.api.copyWith(urlParams));
}