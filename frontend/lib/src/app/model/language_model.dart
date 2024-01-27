class Language {
  int id;
  String name;

  Language(this.id, this.name);

  factory Language.fromJson(dynamic json) {
    return Language(json['id'] as int, json['name'] as String);
  }

  @override
  String toString() {
    return '{ $id, $name }';
  }

  @override
  bool operator ==(other) => other is Language && id == other.id && name == other.name;

  @override
  int get hashCode => Object.hash(id, name);
}
