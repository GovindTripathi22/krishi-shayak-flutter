import '../../domain/entities/scheme_entity.dart';

class SchemeModel extends SchemeEntity {
  const SchemeModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.subsidyPercentage,
    required super.officialUrl,
    super.isBookmarked,
  });

  factory SchemeModel.fromJson(Map<String, dynamic> json) {
    return SchemeModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      subsidyPercentage: json['subsidyPercentage'] as String? ?? '',
      officialUrl: json['officialUrl'] as String? ?? '',
      isBookmarked: json['isBookmarked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'subsidyPercentage': subsidyPercentage,
      'officialUrl': officialUrl,
      'isBookmarked': isBookmarked,
    };
  }
}
