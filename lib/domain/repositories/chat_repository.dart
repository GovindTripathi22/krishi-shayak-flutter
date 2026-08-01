import '../entities/chat_conversation_entity.dart';
import '../entities/chat_message_entity.dart';

abstract class ChatRepository {
  Future<List<ChatConversationEntity>> getConversations();
  Future<ChatConversationEntity> createConversation(String initialTitle);
  Future<void> deleteConversation(String conversationId);
  Future<void> renameConversation(String conversationId, String newTitle);
  Future<List<ChatMessageEntity>> getMessages(String conversationId);
  Future<ChatMessageEntity> sendMessage(String conversationId, String text, {String languageCode, String? schemeId, String? screenContext});
  Future<List<String>> getSuggestions({String? schemeId, String? screenContext});
  Future<void> saveMessage(ChatMessageEntity message);
}
