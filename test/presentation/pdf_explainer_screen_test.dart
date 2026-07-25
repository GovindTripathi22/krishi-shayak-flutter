import 'package:agrisathi_ai/core/localization/app_localizations_delegate.dart';
import 'package:agrisathi_ai/presentation/screens/pdf_explainer/pdf_explainer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PdfExplainerScreen renders document upload options and search bar', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          home: PdfExplainerScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Upload Government Circular or Scheme PDF'), findsOneWidget);
    expect(find.text('Upload PDF'), findsOneWidget);
    expect(find.text('Scan Image'), findsOneWidget);
  });
}
