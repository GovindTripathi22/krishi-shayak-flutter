import '../../domain/entities/chat_conversation_entity.dart';

class ChatConversationModel extends ChatConversationEntity {
  const ChatConversationModel({
    required super.id,
    required super.title,
    required super.lastMessage,
    required super.updatedAt,
    super.isPinned,
  });

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) {
    return ChatConversationModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Agricultural Advisory',
      lastMessage: json['lastMessage'] as String? ?? '',
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      isPinned: json['isPinned'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lastMessage': lastMessage,
      'updatedAt': updatedAt.toIso8601String(),
      'isPinned': isPinned,
    };
  }
}
