import 'package:krishisahayak/core/localization/app_localizations_delegate.dart';
import 'package:krishisahayak/presentation/screens/registration/registration_wizard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('RegistrationWizardScreen displays Step 1 Personal Details', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          home: RegistrationWizardScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Step 1: Personal Details'), findsOneWidget);
    expect(find.text('Next Step'), findsOneWidget);
  });
}
