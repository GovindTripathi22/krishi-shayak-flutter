const mongoose = require('mongoose');
const RecommendationPolicySchema = new mongoose.Schema({
  key: { type: String, required: true, unique: true, default: 'default' },
  weights: { type: Map, of: Number, required: true },
  version: { type: Number, default: 1 },
  active: { type: Boolean, default: true, index: true },
}, { timestamps: true, collection: 'recommendation_policies' });
module.exports = mongoose.model('RecommendationPolicy', RecommendationPolicySchema);
