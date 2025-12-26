class PartCategory {
  final String id;
  final String name;

  PartCategory({required this.id, required this.name});

  factory PartCategory.fromJson(Map<String, dynamic> json) {
    return PartCategory(
      id: json['id'],
      name: json['name'],
    );
  }
}
