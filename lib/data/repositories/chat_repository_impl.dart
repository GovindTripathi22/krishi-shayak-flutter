import 'dart:convert';

import '../../core/logger/app_logger.dart';
import '../../core/services/storage/preferences_service.dart';
import '../../domain/entities/chat_conversation_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/chat_conversation_model.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  static const String _keyConversations = 'pref_chat_conversations_v1';
  static const String _keyMessagesPrefix = 'pref_chat_messages_';

  @override
  Future<List<ChatConversationEntity>> getConversations() async {
    try {
      final rawStr = PreferencesService.getString(_keyConversations);
      if (rawStr != null && rawStr.isNotEmpty) {
        final List<dynamic> list = jsonDecode(rawStr);
        return list.map((j) => ChatConversationModel.fromJson(j as Map<String, dynamic>)).toList();
      }
    } catch (e, stack) {
      AppLogger.error('ChatRepositoryImpl: Error reading conversations', e, stack);
    }

    // Default Initial Conversation
    final defaultConv = ChatConversationModel(
      id: 'conv_default',
      title: 'Agricultural Advisory Chat',
      lastMessage: 'Namaste! How can I assist your farm today?',
      updatedAt: DateTime.now(),
    );
    await _saveConversations([defaultConv]);
    return [defaultConv];
  }

  @override
  Future<ChatConversationEntity> createConversation(String initialTitle) async {
    final convs = await getConversations();
    final newConv = ChatConversationModel(
      id: 'conv_${DateTime.now().millisecondsSinceEpoch}',
      title: initialTitle,
      lastMessage: '',
      updatedAt: DateTime.now(),
    );

    final updatedList = [newConv, ...convs];
    await _saveConversations(updatedList.cast<ChatConversationModel>());
    return newConv;
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    final convs = await getConversations();
    final updatedList = convs.where((c) => c.id != conversationId).toList();
    await _saveConversations(updatedList.map((e) => ChatConversationModel(
      id: e.id,
      title: e.title,
      lastMessage: e.lastMessage,
      updatedAt: e.updatedAt,
      isPinned: e.isPinned,
    )).toList());
    await PreferencesService.remove('$_keyMessagesPrefix$conversationId');
  }

  @override
  Future<void> renameConversation(String conversationId, String newTitle) async {
    final convs = await getConversations();
    final updatedList = convs.map((c) {
      if (c.id == conversationId) {
        return c.copyWith(title: newTitle);
      }
      return c;
    }).toList();
    await _saveConversations(updatedList.map((e) => ChatConversationModel(
      id: e.id,
      title: e.title,
      lastMessage: e.lastMessage,
      updatedAt: e.updatedAt,
      isPinned: e.isPinned,
    )).toList());
  }

  @override
  Future<List<ChatMessageEntity>> getMessages(String conversationId) async {
    try {
      final rawStr = PreferencesService.getString('$_keyMessagesPrefix$conversationId');
      if (rawStr != null && rawStr.isNotEmpty) {
        final List<dynamic> list = jsonDecode(rawStr);
        return list.map((j) => ChatMessageModel.fromJson(j as Map<String, dynamic>)).toList();
      }
    } catch (e, stack) {
      AppLogger.error('ChatRepositoryImpl: Error reading messages', e, stack);
    }
    return [];
  }

  @override
  Future<void> saveMessage(ChatMessageEntity message) async {
    final messages = await getMessages(message.conversationId);
    final updatedList = [...messages, message];

    final jsonStr = jsonEncode(updatedList.map((m) => ChatMessageModel(
      id: m.id,
      conversationId: m.conversationId,
      text: m.text,
      isUser: m.isUser,
      timestamp: m.timestamp,
      referencedSchemeNames: m.referencedSchemeNames,
      officialLinks: m.officialLinks,
      languageCode: m.languageCode,
      isStreaming: m.isStreaming,
    ).toJson()).toList());

    await PreferencesService.setString('$_keyMessagesPrefix${message.conversationId}', jsonStr);
  }

  Future<void> _saveConversations(List<ChatConversationModel> list) async {
    final jsonStr = jsonEncode(list.map((c) => c.toJson()).toList());
    await PreferencesService.setString(_keyConversations, jsonStr);
  }
}
