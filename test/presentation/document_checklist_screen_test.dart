import 'package:agrisathi_ai/core/localization/app_localizations_delegate.dart';
import 'package:agrisathi_ai/presentation/screens/checklist/document_checklist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DocumentChecklistScreen renders scheme title and document preparedness bar', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          home: DocumentChecklistScreen(schemeId: 'gov_sch_101'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Required Document Checklist'), findsOneWidget);
    expect(find.text('Document Preparedness'), findsOneWidget);
  });
}
