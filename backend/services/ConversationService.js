const crypto = require('crypto');
const ChatHistory = require('../models/ChatHistory');

class ConversationService {
  async getOrCreate(userId, conversationId, language) {
    const id = conversationId || crypto.randomUUID();
    let conversation = await ChatHistory.findOne({ userId, conversationId: id });
    if (!conversation) conversation = await ChatHistory.create({ userId, conversationId: id, languageUsed: language || 'en' });
    return conversation;
  }
  async append(conversation, message) { conversation.messages.push(message); conversation.lastMessageAt = new Date(); if (conversation.messages.length === 1 && message.role === 'user') conversation.title = message.content.slice(0, 80); await conversation.save(); return conversation; }
  history(conversation) { return conversation.messages.slice(-8).map((message) => ({ role: message.role, content: message.content })); }
}
module.exports = new ConversationService();
