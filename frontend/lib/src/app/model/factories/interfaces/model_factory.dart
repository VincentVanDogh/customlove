abstract interface class ModelFactory<T> {
  Map<int, T> parseModels(List<dynamic> items);
}