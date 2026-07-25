import 'package:agrisathi_ai/core/localization/app_localizations_delegate.dart';
import 'package:agrisathi_ai/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomeScreen renders greeting, search bar, and Quick Actions section', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          home: HomeScreen(),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Quick Actions'), findsOneWidget);
    expect(find.text('AI Chat'), findsOneWidget);
    expect(find.text('Govt Schemes'), findsOneWidget);
  });
}
