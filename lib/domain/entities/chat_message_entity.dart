import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final String id;
  final String conversationId;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<String> referencedSchemeNames;
  final List<String> officialLinks;
  final String languageCode;
  final bool isStreaming;

  const ChatMessageEntity({
    required this.id,
    required this.conversationId,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.referencedSchemeNames = const [],
    this.officialLinks = const [],
    this.languageCode = 'en',
    this.isStreaming = false,
  });

  ChatMessageEntity copyWith({
    String? id,
    String? conversationId,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    List<String>? referencedSchemeNames,
    List<String>? officialLinks,
    String? languageCode,
    bool? isStreaming,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      referencedSchemeNames: referencedSchemeNames ?? this.referencedSchemeNames,
      officialLinks: officialLinks ?? this.officialLinks,
      languageCode: languageCode ?? this.languageCode,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }

  @override
  List<Object?> get props => [
        id,
        conversationId,
        text,
        isUser,
        timestamp,
        referencedSchemeNames,
        officialLinks,
        languageCode,
        isStreaming,
      ];
}
