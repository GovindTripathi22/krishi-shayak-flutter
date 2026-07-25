import 'package:equatable/equatable.dart';

class SchemeFilterParams extends Equatable {
  final String? state;
  final String? district;
  final String? crop;
  final String? category;
  final bool? isCentralScheme;
  final String? farmerType;
  final String? languageCode;

  const SchemeFilterParams({
    this.state,
    this.district,
    this.crop,
    this.category,
    this.isCentralScheme,
    this.farmerType,
    this.languageCode,
  });

  bool get hasActiveFilters =>
      (state != null && state!.isNotEmpty) ||
      (district != null && district!.isNotEmpty) ||
      (crop != null && crop!.isNotEmpty) ||
      (category != null && category!.isNotEmpty && category != 'All') ||
      isCentralScheme != null ||
      (farmerType != null && farmerType!.isNotEmpty) ||
      (languageCode != null && languageCode!.isNotEmpty);

  SchemeFilterParams copyWith({
    String? state,
    String? district,
    String? crop,
    String? category,
    bool? isCentralScheme,
    String? farmerType,
    String? languageCode,
  }) {
    return SchemeFilterParams(
      state: state ?? this.state,
      district: district ?? this.district,
      crop: crop ?? this.crop,
      category: category ?? this.category,
      isCentralScheme: isCentralScheme ?? this.isCentralScheme,
      farmerType: farmerType ?? this.farmerType,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object?> get props => [
        state,
        district,
        crop,
        category,
        isCentralScheme,
        farmerType,
        languageCode,
      ];
}
