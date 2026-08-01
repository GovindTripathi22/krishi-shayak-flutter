const mongoose = require('mongoose');

const DocumentSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    fileName: {
      type: String,
      required: true,
    },
    fileType: {
      type: String,
      enum: ['pdf', 'jpg', 'jpeg', 'png'],
      required: true,
    },
    fileUrl: {
      type: String,
      required: true,
    },
    fileSizeBytes: {
      type: Number,
    },
    mimeType: {
      type: String,
    },
    storagePath: { type: String, required: true, select: false },
    contentHash: { type: String, required: true, index: true },
    processingStatus: { type: String, enum: ['uploaded', 'processing', 'completed', 'failed'], default: 'uploaded', index: true },
    language: { type: String, default: 'en' },
    extractedTextPreview: { type: String, default: '' },
  },
  {
    timestamps: true,
  }
);

DocumentSchema.index({ userId: 1, contentHash: 1 });
DocumentSchema.index({ userId: 1, fileName: 'text', extractedTextPreview: 'text', createdAt: -1 });

module.exports = mongoose.model('Document', DocumentSchema);
