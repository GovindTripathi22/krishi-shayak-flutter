import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/injection_container.dart';
import '../../core/services/ai/gemini_ai_service.dart';
import '../../core/services/ai/rag_search_engine.dart';
import '../../domain/entities/chat_conversation_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import 'auth_controller_provider.dart';

final activeConversationIdProvider = StateProvider<String>((ref) => 'conv_default');

// Conversations List Notifier
final chatConversationsProvider =
    StateNotifierProvider<ChatConversationsNotifier, List<ChatConversationEntity>>((ref) {
  return ChatConversationsNotifier(repository: sl<ChatRepository>());
});

class ChatConversationsNotifier extends StateNotifier<List<ChatConversationEntity>> {
  final ChatRepository repository;

  ChatConversationsNotifier({required this.repository}) : super([]) {
    loadConversations();
  }

  Future<void> loadConversations() async {
    state = await repository.getConversations();
  }

  Future<ChatConversationEntity> createNewSession(String title) async {
    final conv = await repository.createConversation(title);
    await loadConversations();
    return conv;
  }

  Future<void> deleteSession(String id) async {
    await repository.deleteConversation(id);
    await loadConversations();
  }
}

// Chat Messages Notifier
class ChatState {
  final List<ChatMessageEntity> messages;
  final bool isStreaming;
  final String? errorMessage;

  const ChatState({
    this.messages = const [],
    this.isStreaming = false,
    this.errorMessage,
  });

  ChatState copyWith({
    List<ChatMessageEntity>? messages,
    bool? isStreaming,
    String? errorMessage,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isStreaming: isStreaming ?? this.isStreaming,
      errorMessage: errorMessage,
    );
  }
}

final chatMessagesNotifierProvider =
    StateNotifierProvider<ChatMessagesNotifier, ChatState>((ref) {
  final convId = ref.watch(activeConversationIdProvider);
  final profile = ref.watch(authControllerProvider).farmerProfile;

  return ChatMessagesNotifier(
    chatRepository: sl<ChatRepository>(),
    ragEngine: sl<RagSearchEngine>(),
    geminiService: sl<GeminiAiService>(),
    conversationId: convId,
    farmerProfile: profile,
  );
});

class ChatMessagesNotifier extends StateNotifier<ChatState> {
  final ChatRepository chatRepository;
  final RagSearchEngine ragEngine;
  final GeminiAiService geminiService;
  final String conversationId;
  final dynamic farmerProfile;

  ChatMessagesNotifier({
    required this.chatRepository,
    required this.ragEngine,
    required this.geminiService,
    required this.conversationId,
    this.farmerProfile,
  }) : super(const ChatState()) {
    loadMessages();
  }

  Future<void> loadMessages() async {
    final history = await chatRepository.getMessages(conversationId);
    if (history.isEmpty) {
      final initialMsg = ChatMessageEntity(
        id: 'msg_init',
        conversationId: conversationId,
        text: 'Namaste! I am your AgriSathi AI Agricultural Advisor. Ask me anything about government schemes, subsidies, crop insurance, or farming advice in your language.',
        isUser: false,
        timestamp: DateTime.now(),
      );
      await chatRepository.saveMessage(initialMsg);
      state = ChatState(messages: [initialMsg]);
    } else {
      state = ChatState(messages: history);
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || state.isStreaming) return;

    final userMsg = ChatMessageEntity(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    await chatRepository.saveMessage(userMsg);
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isStreaming: true,
      errorMessage: null,
    );

    try {
      // 1. Run Vector RAG Context Retrieval
      final ragResult = await ragEngine.retrieveContext(
        userQuery: text,
        farmerProfile: farmerProfile,
      );

      // 2. Prepare AI Response Entity
      final String aiMsgId = 'msg_ai_${DateTime.now().millisecondsSinceEpoch}';
      ChatMessageEntity aiMsg = ChatMessageEntity(
        id: aiMsgId,
        conversationId: conversationId,
        text: '',
        isUser: false,
        timestamp: DateTime.now(),
        referencedSchemeNames: ragResult.relevantSchemes.map((s) => s.name).toList(),
        officialLinks: ragResult.relevantSchemes.map((s) => s.officialApplicationLink).toList(),
        isStreaming: true,
      );

      state = state.copyWith(messages: [...state.messages, aiMsg]);

      // 3. Stream Response Chunks
      final stream = geminiService.generateStreamingResponse(
        prompt: text,
        ragContext: ragResult.formattedContext,
      );

      String accumulatedText = '';
      await for (final chunk in stream) {
        accumulatedText += chunk;
        aiMsg = aiMsg.copyWith(text: accumulatedText);

        state = state.copyWith(
          messages: state.messages.map((m) => m.id == aiMsgId ? aiMsg : m).toList(),
        );
      }

      final finalAiMsg = aiMsg.copyWith(isStreaming: false);
      await chatRepository.saveMessage(finalAiMsg);

      state = state.copyWith(
        messages: state.messages.map((m) => m.id == aiMsgId ? finalAiMsg : m).toList(),
        isStreaming: false,
      );
    } catch (e) {
      state = state.copyWith(
        isStreaming: false,
        errorMessage: 'Connection interrupted. Tap retry to resend query.',
      );
    }
  }
}
