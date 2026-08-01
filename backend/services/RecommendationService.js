const GovernmentScheme = require('../models/GovernmentScheme');
const EligibilityRule = require('../models/EligibilityRule');
const Recommendation = require('../models/Recommendation');
const RecommendationPolicy = require('../models/RecommendationPolicy');
const RecommendationEngine = require('./RecommendationEngine');

class RecommendationService {
  async generateRecommendationsForFarmer({ userId, profile, documents = [] }) {
    const [schemes, rules, policy] = await Promise.all([
      GovernmentScheme.find({ status: 'Active' }).lean(),
      EligibilityRule.find().lean(),
      RecommendationPolicy.findOne({ key: 'default', active: true }).lean(),
    ]);
    if (!policy) { const error = new Error('No active recommendation policy is configured.'); error.statusCode = 503; throw error; }
    const rulesBySchemeId = new Map(rules.map((rule) => [rule.schemeId.toString(), rule]));
    const ranked = RecommendationEngine.rank({ schemes, rulesBySchemeId, profile, documents, policy });
    const history = await Recommendation.create({
      userId, profileSnapshot: profile, policyVersion: policy.version,
      recommendations: ranked.map((item) => ({ schemeId: item.scheme._id, matchPercentage: item.eligibility.matchPercentage, eligibilityStatus: item.eligibility.status, score: item.score, reasons: item.reasons, missingDocuments: item.eligibility.missingDocuments })),
    });
    return { history, ranked };
  }
}
module.exports = new RecommendationService();
