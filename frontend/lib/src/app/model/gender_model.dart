class Gender {
  int id;
  String name;

  Gender(this.id, this.name);

  factory Gender.fromJson(dynamic json) {
    return Gender(json['id'] as int, json['name'] as String);
  }

  @override
  String toString() {
    return '{ $id, $name }';
  }

  @override
  bool operator ==(other) => other is Gender && id == other.id && name == other.name;

  @override
  int get hashCode => Object.hash(id, name);
}
