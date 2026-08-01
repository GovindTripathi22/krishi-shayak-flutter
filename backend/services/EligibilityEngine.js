const normalise = (value) => String(value || '').trim().toLowerCase();
const includesOrAll = (allowed, value) => {
  if (!allowed || allowed.length === 0) return true;
  const options = allowed.map(normalise);
  return options.includes('all') || options.includes('all india') || options.includes('all crops') || options.includes('all districts') || options.includes('all villages') || options.includes(normalise(value));
};
const number = (value) => (typeof value === 'number' && Number.isFinite(value) ? value : null);
const weightOf = (rule, key) => Math.max(0, Number(rule?.criterionWeights?.get?.(key) ?? rule?.criterionWeights?.[key] ?? 1));

class EligibilityEngine {
  evaluate({ scheme, rule, profile, documents = [] }) {
    const factors = [];
    const missingCriteria = []; const missingDocuments = []; const reasons = []; const suggestions = []; const hardFailures = [];
    const record = (key, matched, passReason, failureReason, hard = false) => {
      const weight = weightOf(rule, key);
      if (weight === 0) return;
      factors.push({ key, matched, weight });
      if (matched) reasons.push(passReason);
      else { missingCriteria.push(failureReason); if (hard) hardFailures.push(failureReason); }
    };
    const states = rule?.applicableStates?.length ? rule.applicableStates : scheme.applicableStates;
    const districts = rule?.applicableDistricts?.length ? rule.applicableDistricts : scheme.applicableDistricts;
    const crops = rule?.applicableCrops?.length ? rule.applicableCrops : scheme.applicableCrops;
    record('state', includesOrAll(states, profile.state), `Available in ${profile.state}.`, `Not available in ${profile.state}.`, true);
    record('district', includesOrAll(districts, profile.district), `Available in ${profile.district} district.`, `Not available in ${profile.district} district.`, true);
    record('village', includesOrAll(rule?.applicableVillages, profile.village), 'Village requirement is met.', 'Village is outside the scheme area.', true);
    record('crop', includesOrAll(crops, profile.cropType?.[0]), `Covers your crop (${profile.cropType?.[0] || 'selected crop'}).`, `Your selected crop is not covered (${(crops || []).join(', ')}).`);
    const categoryRuleExists = Boolean(rule?.allowedCategories?.length);
    const categoryMatch = categoryRuleExists ? includesOrAll(rule.allowedCategories, profile.category) : true;
    record('category', categoryMatch, `Farmer category ${profile.category} is accepted.`, `Farmer category ${profile.category} does not meet the scheme restriction.`, categoryRuleExists);
    record('farmerType', includesOrAll(rule?.allowedFarmerTypes, profile.farmerType), `Farmer type ${profile.farmerType} is accepted.`, `Farmer type ${profile.farmerType} is not accepted.`, true);
    record('gender', includesOrAll(rule?.allowedGenders?.length ? rule.allowedGenders : [scheme.genderRestrictions], profile.gender) || normalise(scheme.genderRestrictions) === 'none', 'Gender requirement is met.', `Scheme is restricted to ${scheme.genderRestrictions || rule.allowedGenders.join(', ')}.`, true);
    record('irrigation', includesOrAll(rule?.allowedIrrigationTypes, profile.irrigationType), `Irrigation type ${profile.irrigationType} is accepted.`, `Irrigation type ${profile.irrigationType} is not accepted.`);
    const age = number(profile.age);
    const ageOK = age !== null && (!rule?.minAge || age >= rule.minAge) && (!rule?.maxAge || age <= rule.maxAge);
    record('age', ageOK, 'Age requirement is met.', `Age must be within the permitted range${rule?.minAge ? ` (minimum ${rule.minAge})` : ''}${rule?.maxAge ? ` (maximum ${rule.maxAge})` : ''}.`, Boolean(rule?.minAge || rule?.maxAge));
    const income = number(profile.annualIncome);
    const incomeOK = income !== null && (!rule?.maxIncome || income <= rule.maxIncome);
    record('income', incomeOK, 'Income requirement is met.', rule?.maxIncome ? `Annual income exceeds the permitted limit of ₹${rule.maxIncome}.` : 'Annual income is required.', Boolean(rule?.maxIncome));
    const land = number(profile.landSize);
    const landOK = land !== null && (!rule?.minLandSizeAcres || land >= rule.minLandSizeAcres) && (!rule?.maxLandSizeAcres || land <= rule.maxLandSizeAcres);
    record('land', landOK, 'Land-size requirement is met.', 'Land size does not meet the scheme requirement.', Boolean(rule?.minLandSizeAcres || rule?.maxLandSizeAcres));
    const supplied = new Set(documents.map(normalise));
    const requiredDocuments = [...new Set([...(scheme.requiredDocuments || []), ...(rule?.requiredDocumentsList || [])])];
    for (const doc of requiredDocuments) if (!supplied.has(normalise(doc))) missingDocuments.push(doc);
    const documentsOK = missingDocuments.length === 0;
    record('documents', documentsOK, 'Required documents are available.', 'Some required documents are not yet recorded.');
    if (missingDocuments.length) suggestions.push(`Prepare: ${missingDocuments.join(', ')}.`);
    if (hardFailures.length) suggestions.push('Review the failed eligibility requirements before applying.');
    else if (missingDocuments.length) suggestions.push('You may qualify after providing the missing documents.');
    else suggestions.push('Review the official scheme guidance and apply through the official portal.');
    const totalWeight = factors.reduce((sum, factor) => sum + factor.weight, 0);
    const earnedWeight = factors.filter((factor) => factor.matched).reduce((sum, factor) => sum + factor.weight, 0);
    const matchPercentage = totalWeight ? Math.round((earnedWeight / totalWeight) * 100) : 0;
    const status = hardFailures.length ? 'Not Eligible' : (missingCriteria.length || missingDocuments.length ? 'Partially Eligible' : 'Eligible');
    return { status, matchPercentage, missingCriteria: [...new Set(missingCriteria)], missingDocuments, reasons, suggestions, factors };
  }
}
module.exports = new EligibilityEngine();
