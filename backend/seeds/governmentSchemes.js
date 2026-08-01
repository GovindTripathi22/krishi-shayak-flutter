// Curated references to official Government of India portals. Keep this file
// separate from operational writes; admin/import tooling should use source=admin/import.
module.exports = [
  {
    schemeCode: 'PM-KISAN', name: 'PM-KISAN (Pradhan Mantri Kisan Samman Nidhi)',
    shortDescription: 'Income support for eligible landholding farmer families.',
    detailedDescription: 'PM-KISAN is a Central Sector Scheme that provides income support to eligible landholding farmer families, subject to the scheme guidelines and exclusions published by the Government of India.',
    benefits: '₹6,000 per year is provided in three instalments, subject to eligibility and verification.', financialAssistance: 'Direct Benefit Transfer', financialAssistanceAmount: 6000,
    eligibilityCriteria: ['Landholding farmer family subject to PM-KISAN guidelines.', 'Aadhaar-based e-KYC and bank details as required by the portal.'],
    requiredDocuments: ['Aadhaar', 'Land records', 'Bank account details'], deadlineLabel: 'Ongoing', startDate: '2018-12-01',
    officialWebsite: 'https://pmkisan.gov.in/', officialApplicationLink: 'https://pmkisan.gov.in/RegistrationFormNew.aspx', category: 'Financial Assistance', isCentralScheme: true,
    applicableStates: ['All India'], applicableDistricts: ['All Districts'], applicableCrops: ['All Crops'], landRequirement: 'Landholding as per scheme rules', incomeRequirement: 'As per scheme exclusions', farmerCategory: 'Eligible landholding farmers', ageRequirement: '', importantNotes: ['e-KYC is mandatory where required by the official portal.'],
    faqs: [{ question: 'Where can I register?', answer: 'Use only the official PM-KISAN portal or authorised service channels.' }], languageVersions: { en: 'PM-KISAN' }, isFeatured: true, priorityScore: 100, status: 'Active', source: 'seed',
  },
  {
    schemeCode: 'PMFBY', name: 'Pradhan Mantri Fasal Bima Yojana',
    shortDescription: 'Crop insurance for notified crops and notified areas.',
    detailedDescription: 'PMFBY supports farmers against specified crop losses in notified areas. Coverage, premium, and enrolment dates vary by season, crop, and state notification.',
    benefits: 'Insurance protection for notified crops against covered risks.', financialAssistance: 'Premium support as notified', financialAssistanceAmount: 0,
    eligibilityCriteria: ['Farmer growing a notified crop in a notified area.', 'Application within the seasonal enrolment window.'], requiredDocuments: ['Aadhaar', 'Bank details', 'Land or crop-sowing evidence as applicable'], deadlineLabel: 'Check seasonal notification',
    officialWebsite: 'https://pmfby.gov.in/', officialApplicationLink: 'https://pmfby.gov.in/', category: 'Crop Insurance', isCentralScheme: true, applicableStates: ['All India'], applicableDistricts: ['Notified Districts'], applicableCrops: ['Notified Crops'], landRequirement: 'As notified', incomeRequirement: 'No general income limit', farmerCategory: 'Farmers of notified crops', genderRestrictions: 'None', ageRequirement: '', importantNotes: ['Enrolment and claim reporting windows are set by the current notification.'], faqs: [], languageVersions: { en: 'Pradhan Mantri Fasal Bima Yojana' }, isFeatured: true, priorityScore: 95, status: 'Active', source: 'seed',
  },
  {
    schemeCode: 'PMKSY-PDMC', name: 'PMKSY – Per Drop More Crop', shortDescription: 'Support for micro-irrigation and improved water-use efficiency.',
    detailedDescription: 'The Per Drop More Crop component promotes micro-irrigation systems. Availability, beneficiary share, and application procedures are implemented through state agriculture departments.',
    benefits: 'Financial assistance for eligible micro-irrigation installations as per prevailing norms.', financialAssistance: 'As per central and state norms', financialAssistanceAmount: 0,
    eligibilityCriteria: ['Eligible farmer under applicable state implementation guidelines.'], requiredDocuments: ['Aadhaar', 'Land record', 'Bank details', 'Supplier documentation where required'], deadlineLabel: 'Check state portal',
    officialWebsite: 'https://pmksy.gov.in/', officialApplicationLink: '', category: 'Irrigation & Water', isCentralScheme: true, applicableStates: ['All India'], applicableDistricts: ['All Districts'], applicableCrops: ['Horticulture', 'Vegetables', 'Sugarcane', 'Cotton'], landRequirement: 'As per state guidelines', incomeRequirement: 'As per state guidelines', farmerCategory: 'Eligible farmers', genderRestrictions: 'None', ageRequirement: '', importantNotes: ['Apply only through your state agriculture department channel when applications are open.'], faqs: [], languageVersions: { en: 'PMKSY Per Drop More Crop' }, isFeatured: false, priorityScore: 80, status: 'Active', source: 'seed',
  },
];
