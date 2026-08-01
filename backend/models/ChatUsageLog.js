const mongoose = require('mongoose');
const ChatUsageLogSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, index: true },
  conversationId: { type: String, required: true, index: true },
  model: { type: String, required: true },
  promptTokenCount: { type: Number, default: 0 },
  responseTokenCount: { type: Number, default: 0 },
  totalTokenCount: { type: Number, default: 0 },
  latencyMs: { type: Number, required: true },
}, { timestamps: true, collection: 'chat_usage_logs' });
ChatUsageLogSchema.index({ userId: 1, createdAt: -1 });
module.exports = mongoose.model('ChatUsageLog', ChatUsageLogSchema);
