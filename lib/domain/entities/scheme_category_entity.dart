import 'package:equatable/equatable.dart';

class SchemeCategoryEntity extends Equatable {
  final String id;
  final String title;
  final String iconName;
  final int count;

  const SchemeCategoryEntity({
    required this.id,
    required this.title,
    required this.iconName,
    required this.count,
  });

  factory SchemeCategoryEntity.fromJson(Map<String, dynamic> json) {
    return SchemeCategoryEntity(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      iconName: json['iconName'] as String? ?? 'eco',
      count: json['count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'iconName': iconName,
      'count': count,
    };
  }

  @override
  List<Object?> get props => [id, title, iconName, count];
}
