const EligibilityEngine = require('./EligibilityEngine');

class RecommendationEngine {
  rank({ schemes, rulesBySchemeId, profile, documents, policy }) {
    const weights = policy.weights instanceof Map ? Object.fromEntries(policy.weights) : policy.weights;
    const totalWeight = Object.values(weights).reduce((sum, value) => sum + Number(value), 0);
    const newest = Math.max(...schemes.map((scheme) => new Date(scheme.updatedAt).getTime()));
    const oldest = Math.min(...schemes.map((scheme) => new Date(scheme.updatedAt).getTime()));
    return schemes.map((scheme) => {
      const eligibility = EligibilityEngine.evaluate({ scheme, rule: rulesBySchemeId.get(scheme._id.toString()), profile, documents });
      const freshness = newest === oldest ? 1 : (new Date(scheme.updatedAt).getTime() - oldest) / (newest - oldest);
      const priority = Number(scheme.priorityScore || 0) / 100;
      const score = totalWeight ? Math.round(((eligibility.matchPercentage / 100 * Number(weights.eligibility || 0)) + (priority * Number(weights.priority || 0)) + (freshness * Number(weights.recency || 0))) / totalWeight * 100) : eligibility.matchPercentage;
      return { scheme, eligibility, score, reasons: [...eligibility.reasons, `Priority and recency are evaluated using policy version ${policy.version}.`] };
    }).sort((a, b) => b.score - a.score || b.eligibility.matchPercentage - a.eligibility.matchPercentage);
  }
}
module.exports = new RecommendationEngine();
