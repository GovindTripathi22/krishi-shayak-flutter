import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection_container.dart';
import '../../domain/entities/chat_conversation_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chat_repository.dart';

final activeConversationIdProvider = StateProvider<String>((ref) => 'new_session');
final chatSuggestionsProvider = FutureProvider<List<String>>((ref) => sl<ChatRepository>().getSuggestions());

final chatConversationsProvider = StateNotifierProvider<ChatConversationsNotifier, List<ChatConversationEntity>>((ref) => ChatConversationsNotifier(repository: sl<ChatRepository>()));
class ChatConversationsNotifier extends StateNotifier<List<ChatConversationEntity>> {
  final ChatRepository repository;
  ChatConversationsNotifier({required this.repository}) : super([]) { loadConversations(); }
  Future<void> loadConversations() async { state = await repository.getConversations(); }
  Future<ChatConversationEntity> createNewSession(String title) async { final conversation = await repository.createConversation(title); state = [conversation, ...state]; return conversation; }
  Future<void> deleteSession(String id) async { await repository.deleteConversation(id); await loadConversations(); }
}

class ChatState {
  final List<ChatMessageEntity> messages; final bool isStreaming; final String? errorMessage;
  const ChatState({this.messages = const [], this.isStreaming = false, this.errorMessage});
  ChatState copyWith({List<ChatMessageEntity>? messages, bool? isStreaming, String? errorMessage}) => ChatState(messages: messages ?? this.messages, isStreaming: isStreaming ?? this.isStreaming, errorMessage: errorMessage);
}
final chatMessagesNotifierProvider = StateNotifierProvider<ChatMessagesNotifier, ChatState>((ref) => ChatMessagesNotifier(repository: sl<ChatRepository>(), conversationId: ref.watch(activeConversationIdProvider)));
class ChatMessagesNotifier extends StateNotifier<ChatState> {
  final ChatRepository repository; String conversationId;
  ChatMessagesNotifier({required this.repository, required this.conversationId}) : super(const ChatState()) { loadMessages(); }
  Future<void> loadMessages() async { try { state = ChatState(messages: await repository.getMessages(conversationId)); } catch (_) { state = state.copyWith(errorMessage: 'Unable to load this conversation.'); } }
  Future<void> sendMessage(String text, {String? schemeId}) async {
    if (text.trim().isEmpty || state.isStreaming) return;
    final userMessage = ChatMessageEntity(id: 'pending_${DateTime.now().microsecondsSinceEpoch}', conversationId: conversationId, text: text.trim(), isUser: true, timestamp: DateTime.now());
    state = ChatState(messages: [...state.messages, userMessage], isStreaming: true);
    try {
      final reply = await repository.sendMessage(conversationId, text, schemeId: schemeId);
      conversationId = reply.conversationId;
      state = ChatState(messages: [...state.messages, reply], isStreaming: false);
    } catch (_) { state = state.copyWith(isStreaming: false, errorMessage: 'Unable to reach the verified scheme assistant. Please try again.'); }
  }
  Future<void> clearHistory() async { if (!conversationId.startsWith('new_')) await repository.deleteConversation(conversationId); state = const ChatState(); }
}
