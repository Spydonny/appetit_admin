import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final Map<String, String>? nameTranslations;
  final int sort;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Category({
    required this.id,
    required this.name,
    this.nameTranslations,
    required this.sort,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      nameTranslations: (json['name_translations'] as Map?)?.cast<String, String>(),
      sort: json['sort'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "name_translations": nameTranslations,
      "sort": sort,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, name, nameTranslations, sort, createdAt, updatedAt];
}
