import 'package:agrisathi_ai/data/models/chat_message_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatMessageModel Tests', () {
    test('ChatMessageModel correctly serializes JSON and handles scheme badges', () {
      final now = DateTime.now();
      final model = ChatMessageModel(
        id: 'msg_99',
        conversationId: 'conv_1',
        text: 'PM-KISAN provides ₹6,000 yearly',
        isUser: false,
        timestamp: now,
        referencedSchemeNames: const ['PM-KISAN'],
        officialLinks: const ['https://pmkisan.gov.in'],
        languageCode: 'en',
      );

      final json = model.toJson();
      expect(json['id'], equals('msg_99'));
      expect(json['isUser'], isFalse);

      final fromJson = ChatMessageModel.fromJson(json);
      expect(fromJson.id, equals(model.id));
      expect(fromJson.referencedSchemeNames.length, equals(1));
    });
  });
}
