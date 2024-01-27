import '../../api/interfaces/paginated_api.dart';

abstract class PaginatedService<T, U extends PaginatedApi<T>> {
  U _api;
  U get api => _api;

  PaginatedService(this._api);

  Future<Map<int, T>> getAll() async {
    return await _api.getAll();
  }

  Future<Map<int, T>> getFirst() async {
    return await _api.getFirst();
  }

  Future<Map<int, T>> getNextPage(int currentPage, int size) async {
    return _api.getNextPage(currentPage, size);
  }

  Future<int> getMaxPage(int currentPage, int size) async {
    return _api.getMaxPage(currentPage, size);
  }

  Future<bool> hasNext(int currentPage, int size) async {
    return _api.hasNext(currentPage, size);
  }

  PaginatedService<T, U> copyWith(String urlParams);
}