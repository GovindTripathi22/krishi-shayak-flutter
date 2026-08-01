const mongoose = require('mongoose');

const messageSchema = new mongoose.Schema({
  role: { type: String, enum: ['user', 'assistant'], required: true },
  content: { type: String, required: true, maxlength: 6000 },
  referencedSchemeIds: [{ type: mongoose.Schema.Types.ObjectId, ref: 'GovernmentScheme' }],
  officialLinks: [{ type: String }],
  createdAt: { type: Date, default: Date.now },
}, { _id: true });

const ChatHistorySchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, index: true },
  conversationId: { type: String, required: true, trim: true, maxlength: 80 },
  title: { type: String, default: 'Scheme assistance', maxlength: 120 },
  languageUsed: { type: String, default: 'en', maxlength: 12 },
  messages: { type: [messageSchema], default: [] },
  lastMessageAt: { type: Date, default: Date.now, index: true },
}, { timestamps: true, collection: 'chat_histories' });

ChatHistorySchema.index({ userId: 1, conversationId: 1 }, { unique: true });
ChatHistorySchema.index({ userId: 1, lastMessageAt: -1 });
module.exports = mongoose.model('ChatHistory', ChatHistorySchema);
