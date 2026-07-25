import 'package:agrisathi_ai/core/localization/app_localizations_delegate.dart';
import 'package:agrisathi_ai/presentation/screens/schemes/scheme_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SchemeDetailsScreen displays scheme title and apply buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          home: SchemeDetailsScreen(schemeId: 'gov_sch_101'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Scheme Details'), findsOneWidget);
    expect(find.text('Apply on Official Government Portal'), findsOneWidget);
  });
}
