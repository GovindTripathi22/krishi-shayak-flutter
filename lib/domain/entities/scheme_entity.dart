import 'package:equatable/equatable.dart';

class SchemeEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category;
  final String subsidyPercentage;
  final String officialUrl;
  final bool isBookmarked;

  const SchemeEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.subsidyPercentage,
    required this.officialUrl,
    this.isBookmarked = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        subsidyPercentage,
        officialUrl,
        isBookmarked,
      ];
}
