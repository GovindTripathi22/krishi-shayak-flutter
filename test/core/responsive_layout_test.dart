import 'package:krishisahayak/core/utils/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ResponsiveLayout renders mobileBody on standard mobile dimensions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ResponsiveLayout(
            mobileBody: Text('Mobile View'),
            tabletBody: Text('Tablet View'),
          ),
        ),
      ),
    );

    expect(find.text('Mobile View'), findsOneWidget);
    expect(find.text('Tablet View'), findsNothing);

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('ResponsiveLayout renders tabletBody on tablet dimensions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ResponsiveLayout(
            mobileBody: Text('Mobile View'),
            tabletBody: Text('Tablet View'),
          ),
        ),
      ),
    );

    expect(find.text('Tablet View'), findsOneWidget);
    expect(find.text('Mobile View'), findsNothing);

    addTearDown(tester.view.resetPhysicalSize);
  });
}
