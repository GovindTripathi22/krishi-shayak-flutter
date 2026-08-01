const mongoose = require('mongoose');

const faqSchema = new mongoose.Schema({
  question: { type: String, required: true, trim: true, maxlength: 500 },
  answer: { type: String, required: true, trim: true, maxlength: 3000 },
}, { _id: false });

const isOfficialUrl = (value) => {
  if (!value) return true;
  try {
    const url = new URL(value);
    return url.protocol === 'https:' && (url.hostname.endsWith('.gov.in') || url.hostname.endsWith('.nic.in'));
  } catch (_) {
    return false;
  }
};

const GovernmentSchemeSchema = new mongoose.Schema({
  schemeCode: { type: String, required: true, unique: true, trim: true, uppercase: true, maxlength: 80 },
  name: { type: String, required: true, trim: true, maxlength: 250 },
  shortDescription: { type: String, required: true, trim: true, maxlength: 600 },
  detailedDescription: { type: String, required: true, trim: true, maxlength: 10000 },
  benefits: { type: String, required: true, trim: true, maxlength: 4000 },
  financialAssistance: { type: String, default: '', trim: true, maxlength: 1000 },
  financialAssistanceAmount: { type: Number, default: 0, min: 0 },
  eligibilityCriteria: { type: [String], default: [] },
  requiredDocuments: { type: [String], default: [] },
  applicationDeadline: { type: Date, default: null },
  deadlineLabel: { type: String, default: '', trim: true, maxlength: 200 },
  startDate: { type: Date, default: null },
  endDate: { type: Date, default: null },
  officialWebsite: { type: String, default: '', validate: { validator: isOfficialUrl, message: 'Official website must be a secure .gov.in or .nic.in URL.' } },
  officialApplicationLink: { type: String, default: '', validate: { validator: isOfficialUrl, message: 'Application link must be a secure .gov.in or .nic.in URL.' } },
  category: { type: String, required: true, trim: true, maxlength: 100 },
  isCentralScheme: { type: Boolean, required: true, default: true },
  applicableStates: { type: [String], default: [], index: true },
  applicableDistricts: { type: [String], default: [], index: true },
  applicableCrops: { type: [String], default: [], index: true },
  landRequirement: { type: String, default: '', trim: true },
  incomeRequirement: { type: String, default: '', trim: true },
  farmerCategory: { type: String, default: 'All Farmers', trim: true },
  genderRestrictions: { type: String, default: 'None', trim: true },
  ageRequirement: { type: String, default: '', trim: true },
  importantNotes: { type: [String], default: [] },
  faqs: { type: [faqSchema], default: [] },
  languageVersions: { type: Map, of: String, default: {} },
  isFeatured: { type: Boolean, default: false, index: true },
  priorityScore: { type: Number, default: 0, min: 0, max: 100, index: true },
  status: { type: String, enum: ['Active', 'Inactive', 'Upcoming', 'Closed'], default: 'Active', index: true },
  source: { type: String, enum: ['seed', 'admin', 'import'], default: 'admin', index: true },
}, { timestamps: true, collection: 'government_schemes' });

GovernmentSchemeSchema.index({ name: 'text', shortDescription: 'text', detailedDescription: 'text', benefits: 'text', category: 'text', applicableCrops: 'text', applicableStates: 'text', applicableDistricts: 'text' }, { weights: { name: 10, shortDescription: 5, category: 4, applicableCrops: 4, benefits: 3 } });
GovernmentSchemeSchema.index({ status: 1, isFeatured: 1, priorityScore: -1 });
GovernmentSchemeSchema.index({ category: 1, isCentralScheme: 1, createdAt: -1 });
GovernmentSchemeSchema.index({ applicationDeadline: 1 });

module.exports = mongoose.model('GovernmentScheme', GovernmentSchemeSchema);
