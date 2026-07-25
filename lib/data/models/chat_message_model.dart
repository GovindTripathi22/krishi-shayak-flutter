import '../../domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.id,
    required super.conversationId,
    required super.text,
    required super.isUser,
    required super.timestamp,
    super.referencedSchemeNames,
    super.officialLinks,
    super.languageCode,
    super.isStreaming,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String? ?? '',
      conversationId: json['conversationId'] as String? ?? '',
      text: json['text'] as String? ?? '',
      isUser: json['isUser'] as bool? ?? false,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      referencedSchemeNames: (json['referencedSchemeNames'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      officialLinks: (json['officialLinks'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      languageCode: json['languageCode'] as String? ?? 'en',
      isStreaming: json['isStreaming'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'referencedSchemeNames': referencedSchemeNames,
      'officialLinks': officialLinks,
      'languageCode': languageCode,
      'isStreaming': isStreaming,
    };
  }
}
