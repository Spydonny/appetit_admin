import 'package:equatable/equatable.dart';

class MenuItem extends Equatable {
  final int id;
  final int? categoryId;
  final String name;
  final Map<String, String>? nameTranslations;
  final String? description;
  final Map<String, String>? descriptionTranslations;
  final double price;
  final String? imageUrl;
  final bool isActive;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MenuItem({
    required this.id,
    this.categoryId,
    required this.name,
    this.nameTranslations,
    this.description,
    this.descriptionTranslations,
    required this.price,
    this.imageUrl,
    required this.isActive,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as int,
      categoryId: json['category_id'] as int?,
      name: json['name'] as String,
      nameTranslations: (json['name_translations'] as Map?)?.cast<String, String>(),
      description: json['description'] as String?,
      descriptionTranslations: (json['description_translations'] as Map?)?.cast<String, String>(),
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] as String?,
      isActive: json['is_active'] as bool,
      isAvailable: json['is_available'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "category_id": categoryId,
      "name": name,
      "name_translations": nameTranslations,
      "description": description,
      "description_translations": descriptionTranslations,
      "price": price,
      "image_url": imageUrl,
      "is_active": isActive,
      "is_available": isAvailable,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    categoryId,
    name,
    nameTranslations,
    description,
    descriptionTranslations,
    price,
    imageUrl,
    isActive,
    isAvailable,
    createdAt,
    updatedAt
  ];
}
