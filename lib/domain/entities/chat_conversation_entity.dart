import 'package:equatable/equatable.dart';

class ChatConversationEntity extends Equatable {
  final String id;
  final String title;
  final String lastMessage;
  final DateTime updatedAt;
  final bool isPinned;

  const ChatConversationEntity({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.updatedAt,
    this.isPinned = false,
  });

  ChatConversationEntity copyWith({
    String? id,
    String? title,
    String? lastMessage,
    DateTime? updatedAt,
    bool? isPinned,
  }) {
    return ChatConversationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      lastMessage: lastMessage ?? this.lastMessage,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  @override
  List<Object?> get props => [id, title, lastMessage, updatedAt, isPinned];
}
