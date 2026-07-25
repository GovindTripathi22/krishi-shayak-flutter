import 'package:agrisathi_ai/presentation/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SplashScreen displays logo and app title correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SplashScreen(),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byIcon(Icons.eco_rounded), findsOneWidget);
    expect(find.text('AgriSathi AI'), findsOneWidget);
  });
}
