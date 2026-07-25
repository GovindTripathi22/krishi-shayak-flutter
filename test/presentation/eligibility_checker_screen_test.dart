import 'package:agrisathi_ai/core/localization/app_localizations_delegate.dart';
import 'package:agrisathi_ai/presentation/screens/eligibility_checker/eligibility_checker_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('EligibilityCheckerScreen renders auto-filled questionnaire and run button', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          home: EligibilityCheckerScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Auto-Filled From Your Profile'), findsOneWidget);
    expect(find.text('Run AI Eligibility Evaluation'), findsOneWidget);
  });
}
