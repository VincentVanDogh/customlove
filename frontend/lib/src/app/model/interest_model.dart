class Interest {
  int id;
  String name;

  Interest(this.id, this.name);

  factory Interest.fromJson(dynamic json) {
    return Interest(json['id'] as int, json['name'] as String);
  }

  @override
  String toString() {
    return '{ $id, $name }';
  }

  @override
  bool operator ==(other) => other is Interest && id == other.id && name == other.name;

  @override
  int get hashCode => Object.hash(id, name);
}
