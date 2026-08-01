const GovernmentScheme = require('../models/GovernmentScheme');
const EligibilityRule = require('../models/EligibilityRule');
const EligibilityCheck = require('../models/EligibilityCheck');
const EligibilityEngine = require('./EligibilityEngine');

class EligibilityService {
  async evaluateEligibility({ userId, profile, documents, schemeId }) {
    const filter = { status: 'Active' };
    if (schemeId) filter._id = schemeId;
    const schemes = await GovernmentScheme.find(filter).lean();
    const rules = await EligibilityRule.find({ schemeId: { $in: schemes.map((scheme) => scheme._id) } }).lean();
    const rulesBySchemeId = new Map(rules.map((rule) => [rule.schemeId.toString(), rule]));
    const results = schemes.map((scheme) => ({ scheme, ...EligibilityEngine.evaluate({ scheme, rule: rulesBySchemeId.get(scheme._id.toString()), profile, documents }) }));
    const checks = results.map((result) => ({ userId, schemeId: result.scheme._id, profileSnapshot: profile, status: result.status, matchPercentage: result.matchPercentage, missingCriteria: result.missingCriteria, missingDocuments: result.missingDocuments, reasons: result.reasons, suggestions: result.suggestions }));
    if (checks.length) await EligibilityCheck.insertMany(checks);
    return results.sort((a, b) => b.matchPercentage - a.matchPercentage);
  }
}
module.exports = new EligibilityService();
