class Thing {
  Thing({ required this.id,
          required this.name, });

  int id;
  String name;

  // representations
  @override
  String toString() {
    return 'Thing{id: $id, name: $name}';
  }

  factory Thing.fromJson(Map<String, dynamic> json) => Thing(
    id: json['id'],
    name: json['name'],
  );
}