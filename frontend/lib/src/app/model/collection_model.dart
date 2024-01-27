import 'dart:collection';

import 'package:frontend/src/app/api/interfaces/paginated_api.dart';
import 'package:frontend/src/app/service/interfaces/paginated_service.dart';

class Collection<T> {
  int _currentPage;
  int _size;

  int get currentPage => _currentPage;
  int get size => _size;

  SplayTreeMap<int, T> items = SplayTreeMap((a, b) => a.compareTo(b));

  Collection(): this.custom(0, 50);
  Collection.custom(this._currentPage, this._size);

  Future<void> getAll(PaginatedService<T, PaginatedApi<T>> service) async {
    items.addAll(await service.getAll());
  }

  Future<void> getFirst(PaginatedService<T, PaginatedApi<T>> service) async {
    // the first element is already there
    if (items.isNotEmpty) {
      return;
    }

    items.addAll(await service.getFirst());
  }

  Future<void> getNextPage(PaginatedService<T, PaginatedApi<T>> service) async {
    items.addAll(await service.getNextPage(_currentPage, _size));
    _currentPage++;
  }

  Future<bool> hasNext(PaginatedService<T, PaginatedApi<T>> service) async {
    return await service.hasNext(_currentPage, _size);
  }

  Future<int> getMaxPage(PaginatedService<T, PaginatedApi<T>> service) async {
    return await service.getMaxPage(_currentPage, _size);
  }

  T? getElementAtIndex(int idx) {
    if (items.values.isEmpty) {
      return null;
    }

    return items.values.elementAtOrNull(idx);
  }
}
