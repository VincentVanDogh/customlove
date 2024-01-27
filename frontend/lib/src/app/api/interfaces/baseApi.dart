import 'package:http/http.dart' as http;

abstract class BaseApi {
  final http.Client client;

  BaseApi(this.client);
}