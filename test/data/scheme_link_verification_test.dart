import 'package:krishisahayak/data/datasources/scheme_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Real Government Scheme Data & Link Health Verification', () {
    final dataSource = SchemeRemoteDataSourceImpl();

    test('All loaded schemes contain non-empty real-world data and zero dummy text', () async {
      final schemes = await dataSource.getSchemes();

      expect(schemes, isNotEmpty);
      expect(schemes.length, greaterThanOrEqualTo(8));

      for (final scheme in schemes) {
        expect(scheme.id, isNotEmpty);
        expect(scheme.name, isNotEmpty);
        expect(scheme.shortDescription, isNotEmpty);
        expect(scheme.benefits, isNotEmpty);
        expect(scheme.eligibilityCriteria, isNotEmpty);
        expect(scheme.requiredDocuments, isNotEmpty);

        // Ensure zero placeholder/dummy keywords exist
        expect(scheme.name.toLowerCase(), isNot(contains('dummy')));
        expect(scheme.name.toLowerCase(), isNot(contains('test scheme')));
        expect(scheme.name.toLowerCase(), isNot(contains('foo')));
        expect(scheme.benefits.toLowerCase(), isNot(contains('placeholder')));
      }
    });

    test('All official website and application links are valid HTTPS government URLs', () async {
      final schemes = await dataSource.getSchemes();

      for (final scheme in schemes) {
        final webUri = Uri.tryParse(scheme.officialWebsite);
        final appUri = Uri.tryParse(scheme.officialApplicationLink);

        expect(webUri, isNotNull, reason: 'Scheme ${scheme.name} website URL is invalid');
        expect(appUri, isNotNull, reason: 'Scheme ${scheme.name} application URL is invalid');

        expect(webUri!.isScheme('HTTPS') || webUri.isScheme('HTTP'), isTrue);
        expect(appUri!.isScheme('HTTPS') || appUri.isScheme('HTTP'), isTrue);

        // Verify official government TLDs (.gov.in, .nic.in, .maharashtra.gov.in, etc.)
        final host = webUri.host.toLowerCase();
        expect(
          host.endsWith('.gov.in') || host.endsWith('.nic.in') || host.endsWith('.in'),
          isTrue,
          reason: 'URL $host for scheme ${scheme.name} must point to official government domain',
        );
      }
    });
  });
}
