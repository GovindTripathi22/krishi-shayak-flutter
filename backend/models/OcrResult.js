const mongoose = require('mongoose');

const OcrResultSchema = new mongoose.Schema(
  {
    documentId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Document',
      required: true,
      index: true,
    },
    extractedText: {
      type: String,
      required: true,
    },
    pageCount: {
      type: Number,
      default: 1,
    },
    confidenceScore: {
      type: Number,
      default: 1.0,
    },
    summaryText: {
      type: String,
    },
    engine: { type: String, required: true },
    status: { type: String, enum: ['completed', 'failed'], default: 'completed' },
  },
  {
    timestamps: true,
  }
);

OcrResultSchema.index({ documentId: 1 }, { unique: true });

module.exports = mongoose.model('OcrResult', OcrResultSchema);
