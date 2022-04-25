class Thing {
  final int id;
  final String name;

  const Thing({
    required this.id,
    required this.name,
  });

  @override
  String toString() {
    return 'Thing{id: $id, name: $name}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  Thing copyWith({int? id, String? name}) {
    return Thing(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}