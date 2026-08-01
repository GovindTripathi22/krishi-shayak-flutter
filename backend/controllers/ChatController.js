const mongoose = require('mongoose');
const ChatHistory = require('../models/ChatHistory');
const ChatUsageLog = require('../models/ChatUsageLog');
const ConversationService = require('../services/ConversationService');
const RAGService = require('../services/RAGService');
const PromptService = require('../services/PromptService');
const GeminiService = require('../services/GeminiService');
const TranslationService = require('../services/TranslationService');

const unavailable = "I couldn't find official information for that question.";
const validQuestion = (value) => typeof value === 'string' && value.trim().length > 0 && value.trim().length <= 1500;
const serialise = (conversation) => ({ conversationId: conversation.conversationId, title: conversation.title, language: conversation.languageUsed, messages: conversation.messages.map((message) => ({ id: message._id, role: message.role, content: message.content, referencedSchemeIds: message.referencedSchemeIds.map(String), officialLinks: message.officialLinks, createdAt: message.createdAt })), updatedAt: conversation.lastMessageAt });
const validateAnswer = (answer, retrieval) => {
  const allowedLinks = new Set(retrieval.schemes.flatMap((scheme) => [scheme.website, scheme.applicationLink]).filter(Boolean));
  const urls = answer.match(/https?:\/\/[^\s)]+/g) || [];
  const sources = answer.match(/sources:\s*(.+)/i)?.[1] || '';
  return urls.every((url) => allowedLinks.has(url)) && retrieval.schemes.some((scheme) => sources.includes(scheme.name));
};

class ChatController {
  static async sendMessage(req, res, next) {
    try {
      const { message, conversationId, language, schemeId, screenContext } = req.body;
      if (!validQuestion(message)) return res.status(400).json({ success: false, message: 'message must be between 1 and 1500 characters.' });
      if (conversationId && (typeof conversationId !== 'string' || conversationId.length > 80)) return res.status(400).json({ success: false, message: 'Invalid conversationId.' });
      if (schemeId && !mongoose.isValidObjectId(schemeId)) return res.status(400).json({ success: false, message: 'Invalid schemeId.' });
      const question = message.trim(); const responseLanguage = TranslationService.resolveLanguage(language); const conversation = await ConversationService.getOrCreate(req.user.id, conversationId, responseLanguage);
      await ConversationService.append(conversation, { role: 'user', content: question });
      const retrieval = await RAGService.retrieve({ userId: req.user.id, question, screenContext, schemeId });
      let answer = unavailable; let usage = {}; const startedAt = Date.now();
      if (retrieval.schemes.length) {
        const prompt = PromptService.build({ question, context: RAGService.format(retrieval), language: responseLanguage, history: ConversationService.history(conversation) });
        try {
          const generated = await GeminiService.generateResponse(prompt);
          if (validateAnswer(generated.text, retrieval)) { answer = generated.text; usage = generated.usage; }
        } catch (_) { answer = unavailable; }
      }
      const links = retrieval.schemes.flatMap((scheme) => [scheme.applicationLink, scheme.website]).filter(Boolean);
      const persisted = await ConversationService.append(conversation, { role: 'assistant', content: answer, referencedSchemeIds: retrieval.schemes.map((scheme) => scheme.id), officialLinks: links });
      if (Object.keys(usage).length) await ChatUsageLog.create({ userId: req.user.id, conversationId: conversation.conversationId, model: GeminiService.model, promptTokenCount: usage.promptTokenCount || 0, responseTokenCount: usage.candidatesTokenCount || 0, totalTokenCount: usage.totalTokenCount || 0, latencyMs: Date.now() - startedAt });
      res.json({ success: true, data: { conversationId: conversation.conversationId, messageId: persisted.messages.at(-1)._id, answer, referencedSchemes: retrieval.schemes.map((scheme) => ({ id: scheme.id, name: scheme.name, officialApplicationLink: scheme.applicationLink })), officialLinks: links, suggestions: ChatController.suggestions(retrieval), sourceVerified: answer !== unavailable } });
    } catch (error) { next(error); }
  }
  static suggestions(retrieval) { return retrieval.schemes.length ? ['Am I eligible?', 'Required documents', 'Last date', 'Benefits', 'How to apply?'] : ['Search schemes', 'How do I apply for a scheme?']; }
  static async history(req, res, next) {
    try {
      const conversationId = req.body.conversationId || req.query.conversationId;
      if (conversationId) { const conversation = await ChatHistory.findOne({ userId: req.user.id, conversationId }).lean(); return res.json({ success: true, data: conversation ? serialise(conversation) : null }); }
      const conversations = await ChatHistory.find({ userId: req.user.id }).sort({ lastMessageAt: -1 }).limit(50).lean();
      res.json({ success: true, data: conversations.map((conversation) => ({ conversationId: conversation.conversationId, title: conversation.title, updatedAt: conversation.lastMessageAt, lastMessage: conversation.messages.at(-1)?.content || '' })) });
    } catch (error) { next(error); }
  }
  static async deleteHistory(req, res, next) { try { const conversationId = req.body.conversationId || req.query.conversationId; const filter = { userId: req.user.id, ...(conversationId ? { conversationId } : {}) }; await ChatHistory.deleteMany(filter); res.status(204).send(); } catch (error) { next(error); } }
  static async getSuggestions(req, res, next) { try { const retrieval = await RAGService.retrieve({ userId: req.user.id, question: req.query.q || '', schemeId: req.query.schemeId, screenContext: req.query.screenContext }); res.json({ success: true, data: ChatController.suggestions(retrieval) }); } catch (error) { next(error); } }
}
module.exports = ChatController;
