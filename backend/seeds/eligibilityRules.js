// Controlled configuration. Rules are data, not application logic; update through approved admin/import workflows.
module.exports = {
  policy: { key: 'default', version: 1, active: true, weights: { eligibility: 75, priority: 15, recency: 10 } },
  rules: [
    { schemeCode: 'PM-KISAN', allowedFarmerTypes: ['Owner'], applicableStates: ['All India'], requiredDocumentsList: ['Aadhaar', 'Land records', 'Bank account details'], criterionWeights: { state: 2, district: 0, village: 0, crop: 1, category: 2, farmerType: 3, gender: 1, age: 0, income: 1, land: 2, irrigation: 0, documents: 3 } },
    { schemeCode: 'PMFBY', allowedFarmerTypes: ['Owner', 'Tenant', 'Sharecropper'], applicableStates: ['All India'], applicableCrops: ['Notified Crops'], requiredDocumentsList: ['Aadhaar', 'Bank details', 'Land or crop-sowing evidence as applicable'], criterionWeights: { state: 2, district: 1, village: 0, crop: 3, category: 1, farmerType: 2, gender: 1, age: 0, income: 1, land: 1, irrigation: 0, documents: 3 } },
    { schemeCode: 'PMKSY-PDMC', allowedFarmerTypes: ['Owner', 'Tenant'], allowedIrrigationTypes: ['Drip', 'Sprinkler', 'Canal', 'Borewell'], applicableStates: ['All India'], requiredDocumentsList: ['Aadhaar', 'Land record', 'Bank details'], criterionWeights: { state: 3, district: 1, village: 0, crop: 2, category: 2, farmerType: 2, gender: 1, age: 0, income: 1, land: 2, irrigation: 3, documents: 3 } },
  ],
};
