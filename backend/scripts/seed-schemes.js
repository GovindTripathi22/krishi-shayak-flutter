require('dotenv').config();
const { connectDB, closeDB } = require('../config/database');
const GovernmentScheme = require('../models/GovernmentScheme');
const EligibilityRule = require('../models/EligibilityRule');
const RecommendationPolicy = require('../models/RecommendationPolicy');
const schemes = require('../seeds/governmentSchemes');
const eligibilityConfiguration = require('../seeds/eligibilityRules');

async function seed() {
  await connectDB();
  if (!require('../config/database').isConnected()) throw new Error('MongoDB connection is required to seed schemes.');
  for (const scheme of schemes) {
    await GovernmentScheme.updateOne({ schemeCode: scheme.schemeCode }, { $set: scheme }, { upsert: true, runValidators: true });
  }
  for (const rule of eligibilityConfiguration.rules) {
    const scheme = await GovernmentScheme.findOne({ schemeCode: rule.schemeCode }).select('_id');
    if (!scheme) throw new Error(`Unable to create rule: scheme ${rule.schemeCode} was not found.`);
    const { schemeCode, ...ruleData } = rule;
    await EligibilityRule.updateOne({ schemeId: scheme._id }, { $set: { ...ruleData, schemeId: scheme._id } }, { upsert: true, runValidators: true });
  }
  await RecommendationPolicy.updateOne({ key: eligibilityConfiguration.policy.key }, { $set: eligibilityConfiguration.policy }, { upsert: true, runValidators: true });
  console.log(`Seeded ${schemes.length} schemes, ${eligibilityConfiguration.rules.length} eligibility rules, and one recommendation policy.`);
  await closeDB();
}
seed().catch(async (error) => { console.error(error.message); await closeDB(); process.exitCode = 1; });
