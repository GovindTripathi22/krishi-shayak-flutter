import '../../core/services/backend/api_client.dart';
import '../../domain/entities/chat_conversation_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/chat_conversation_model.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ApiClient _apiClient;
  ChatRepositoryImpl({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();
  @override
  Future<List<ChatConversationEntity>> getConversations() async {
    final response = await _apiClient.get('/chat/history') as Map<String, dynamic>;
    return (response['data'] as List<dynamic>? ?? []).map((item) { final data = Map<String, dynamic>.from(item as Map); return ChatConversationModel(id: data['conversationId'].toString(), title: data['title']?.toString() ?? 'Scheme assistance', lastMessage: data['lastMessage']?.toString() ?? '', updatedAt: DateTime.parse(data['updatedAt'].toString())); }).toList();
  }
  @override
  Future<ChatConversationEntity> createConversation(String initialTitle) async => ChatConversationModel(id: 'new_${DateTime.now().microsecondsSinceEpoch}', title: initialTitle, lastMessage: '', updatedAt: DateTime.now());
  @override
  Future<void> deleteConversation(String conversationId) async { await _apiClient.delete('/chat/history?conversationId=$conversationId'); }
  @override
  Future<void> renameConversation(String conversationId, String newTitle) async {}
  @override
  Future<List<ChatMessageEntity>> getMessages(String conversationId) async {
    final response = await _apiClient.post('/chat/history', body: {'conversationId': conversationId}) as Map<String, dynamic>;
    final conversation = response['data']; if (conversation == null) return [];
    return (conversation['messages'] as List<dynamic>? ?? []).map((item) { final data = Map<String, dynamic>.from(item as Map); return ChatMessageModel(id: data['id'].toString(), conversationId: conversationId, text: data['content'].toString(), isUser: data['role'] == 'user', timestamp: DateTime.parse(data['createdAt'].toString()), officialLinks: (data['officialLinks'] as List<dynamic>? ?? []).map((link) => link.toString()).toList()); }).toList();
  }
  @override
  Future<ChatMessageEntity> sendMessage(String conversationId, String text, {String languageCode = 'en', String? schemeId, String? screenContext}) async {
    final response = await _apiClient.post('/chat', body: {'message': text, 'conversationId': conversationId.startsWith('new_') ? null : conversationId, 'language': languageCode, if (schemeId != null) 'schemeId': schemeId, if (screenContext != null) 'screenContext': screenContext}) as Map<String, dynamic>;
    final data = Map<String, dynamic>.from(response['data'] as Map);
    return ChatMessageModel(id: data['messageId'].toString(), conversationId: data['conversationId'].toString(), text: data['answer'].toString(), isUser: false, timestamp: DateTime.now(), referencedSchemeNames: (data['referencedSchemes'] as List<dynamic>? ?? []).map((scheme) => (scheme as Map)['name'].toString()).toList(), officialLinks: (data['officialLinks'] as List<dynamic>? ?? []).map((link) => link.toString()).toList(), languageCode: languageCode);
  }
  @override
  Future<List<String>> getSuggestions({String? schemeId, String? screenContext}) async { final response = await _apiClient.get('/chat/suggestions') as Map<String, dynamic>; return (response['data'] as List<dynamic>? ?? []).map((item) => item.toString()).toList(); }
  @override
  Future<void> saveMessage(ChatMessageEntity message) async {}
}
