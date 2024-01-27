import 'dart:convert';

import 'package:frontend/src/app/api/helpers/jwt_api.dart';
import 'package:http/http.dart' as http;

class PaginationApi {
  int _maxPage;
  int? _total;

  int _currentPage;
  int _size;
  String _url;

  // getters
  int? get maxPage => _maxPage;
  int? get total => _total;
  int get currentPage => _currentPage;
  int get size => _size;

  // the default constructor (same as in backend, the default size is 50)
  PaginationApi(url): this.custom(0, 50, url, -1);

  // a custom constructor to set a different page size
  PaginationApi.custom(this._currentPage, this._size, this._url, this._maxPage);

  Future<Map<String, dynamic>> _getRequest(http.Client client) async {
    JWTApi jwtApi = JWTApi();
    int page = _currentPage == 0 ? 1 : _currentPage;
    http.Response response = await jwtApi.get(client, "$_url?size=$_size&page=$page");

    if (response.statusCode != 200) {
      throw Exception("The request: GET $_url, returned ${response.statusCode}");
    }

    Map<String, dynamic> data = json.decode(response.body);
    _maxPage = data['pages'];
    // _total = data['total']; - this approach fails for get users
    _total = data['items'].length;
    return data;
  }

  // return the next page
  // if there are no more pages, return the last page
  Future<List<dynamic>> getNextPage(http.Client client) async {
    _currentPage++;

    // if there is no next page, return an empty list
    if (_maxPage != -1 && _currentPage > _maxPage) {
      return List<dynamic>.empty();
    }

    Map<String, dynamic> paginationObject = await _getRequest(client);
    List<dynamic> ret = List<dynamic>.empty(growable: true);
    int itemCount = (_total! - (_currentPage * _size) < _size) ? _total! : _size;

    for (int i = 0; i < itemCount; i++) {
      ret.add(paginationObject['items'][i]);
    }

    return ret;
  }

  Future<bool> hasNext(http.Client client) async {
    // before the first call
    if (_maxPage == -1) {
      await _getRequest(client);
    }

    // check if the currentPage is greater than the max amount of pages
    return !(_currentPage > _maxPage);
  }

  Future<int> getMaxPage(http.Client client) async {
    await _getRequest(client);

    return _maxPage;
  }
}