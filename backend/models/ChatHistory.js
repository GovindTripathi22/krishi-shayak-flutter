const mongoose = require('mongoose');

const ChatHistorySchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    prompt: {
      type: String,
      required: true,
    },
    aiResponse: {
      type: String,
      required: true,
    },
    referencedSchemes: [
      {
        type: String,
      },
    ],
    languageUsed: {
      type: String,
      default: 'en',
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model('ChatHistory', ChatHistorySchema);
