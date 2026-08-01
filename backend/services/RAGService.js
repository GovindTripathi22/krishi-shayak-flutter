const GovernmentScheme = require('../models/GovernmentScheme');
const EligibilityRule = require('../models/EligibilityRule');
const Profile = require('../models/Profile');
const Bookmark = require('../models/Bookmark');
const Recommendation = require('../models/Recommendation');

class RAGService {
  async retrieve({ userId, question, screenContext, schemeId }) {
    const base = { status: 'Active' }; if (schemeId) base._id = schemeId;
    const search = String(question).trim();
    const schemeQuery = schemeId ? base : (search ? { ...base, $text: { $search: search } } : base);
    const sort = schemeId || !search ? { priorityScore: -1, updatedAt: -1 } : { score: { $meta: 'textScore' }, priorityScore: -1 };
    const schemes = await GovernmentScheme.find(schemeQuery).sort(sort).limit(4).lean();
    const [rules, profile, bookmarks, latestRecommendations] = await Promise.all([
      EligibilityRule.find({ schemeId: { $in: schemes.map((scheme) => scheme._id) } }).lean(), Profile.findOne({ userId }).lean(),
      Bookmark.find({ userId, schemeId: { $in: schemes.map((scheme) => scheme._id) } }).lean(), Recommendation.findOne({ userId }).sort({ createdAt: -1 }).lean(),
    ]);
    const rulesByScheme = new Map(rules.map((rule) => [rule.schemeId.toString(), rule])); const bookmarked = new Set(bookmarks.map((item) => item.schemeId.toString()));
    const context = schemes.map((scheme) => ({ id: scheme._id.toString(), name: scheme.name, benefits: scheme.benefits, description: scheme.shortDescription, eligibility: scheme.eligibilityCriteria, documents: scheme.requiredDocuments, deadline: scheme.deadlineLabel || scheme.applicationDeadline?.toISOString().slice(0, 10) || 'Not specified', website: scheme.officialWebsite, applicationLink: scheme.officialApplicationLink, crops: scheme.applicableCrops, states: scheme.applicableStates, rule: rulesByScheme.get(scheme._id.toString()), bookmarked: bookmarked.has(scheme._id.toString()) }));
    return { schemes: context, profile: profile ? { state: profile.state, district: profile.district, cropType: profile.cropType, category: profile.category, farmerType: profile.farmerType, landSize: profile.landSize, annualIncome: profile.annualIncome } : null, hasRecommendations: Boolean(latestRecommendations), screenContext: screenContext || '' };
  }
  format(retrieval) { return JSON.stringify(retrieval); }
}
module.exports = new RAGService();
