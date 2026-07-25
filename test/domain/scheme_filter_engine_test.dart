import 'package:krishisahayak/domain/entities/scheme_filter_params.dart';
import 'package:krishisahayak/domain/entities/scheme_sort_option.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Scheme Filter & Sort Engine Tests', () {
    test('SchemeFilterParams correctly detects active filters', () {
      const emptyFilter = SchemeFilterParams();
      expect(emptyFilter.hasActiveFilters, isFalse);

      const activeFilter = SchemeFilterParams(
        category: 'Crop Insurance',
        state: 'Maharashtra',
      );
      expect(activeFilter.hasActiveFilters, isTrue);
    });

    test('SchemeSortOption provides correct human readable labels', () {
      expect(SchemeSortOption.newest.label, equals('Newest First'));
      expect(SchemeSortOption.popular.label, equals('Most Popular'));
      expect(SchemeSortOption.deadlineSoon.label, equals('Ending Soon'));
    });
  });
}
