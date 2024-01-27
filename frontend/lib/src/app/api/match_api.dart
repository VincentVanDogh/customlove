import "package:frontend/src/app/model/factories/MatchFactory.dart";
import "package:http/http.dart" as http;

import "../model/match_model.dart";
import "interfaces/paginated_api.dart";

class MatchApi extends PaginatedApi<Match> {
  MatchApi(http.Client client)
      : super(client, "swipe_statuses/matches/", MatchFactory());
  MatchApi.url(http.Client client, String urlParams)
      : super(client, "swipe_statuses/matches/$urlParams", MatchFactory());

  @override
  MatchApi copyWith(String urlParams) => MatchApi.url(client, urlParams);
}
