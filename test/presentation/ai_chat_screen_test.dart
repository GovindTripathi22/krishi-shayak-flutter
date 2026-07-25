import 'package:krishisahayak/core/localization/app_localizations_delegate.dart';
import 'package:krishisahayak/presentation/screens/ai_chat/ai_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AiChatScreen renders initial AI message and suggested prompt chips', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          home: AiChatScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('KrishiSahayak Advisor'), findsOneWidget);
    expect(find.text('Which schemes are available for cotton farmers?'), findsOneWidget);
  });
}
