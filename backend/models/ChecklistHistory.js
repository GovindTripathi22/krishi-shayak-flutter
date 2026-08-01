const mongoose = require('mongoose');

const ChecklistHistorySchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    schemeId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'GovernmentScheme',
      required: true,
      index: true,
    },
    completedItemIds: [
      {
        type: String,
      },
    ],
    progressPercentage: {
      type: Number,
      default: 0,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model('ChecklistHistory', ChecklistHistorySchema);
