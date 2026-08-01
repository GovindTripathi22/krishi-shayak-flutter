# Phase 4 – Eligibility and Recommendations

Eligibility is evaluated on the server against the active MongoDB scheme records and their per-scheme `EligibilityRule` documents. The evaluator checks location, crop, farmer category/type, gender, age, income, land size, irrigation, and submitted documents whenever a rule or scheme restricts that factor. Each evaluated factor is recorded with an administrator-configured criterion weight. A hard restriction failure produces `Not Eligible`; unmet soft requirements or documents produces `Partially Eligible`; otherwise the result is `Eligible`. The percentage is the earned criterion weight divided by all applicable criterion weight.

`POST /api/v1/eligibility/check` accepts an optional `schemeId`, an optional complete `profile` override, and `documents`; it saves every evaluation in `eligibility_checks`. `GET /api/v1/eligibility/history` returns the caller's prior checks.

Recommendations evaluate every active scheme using the same eligibility result, then apply the MongoDB `recommendation_policies` weights for eligibility, scheme priority, and relative update recency. `POST /api/v1/recommendations/refresh` stores a ranked recommendation snapshot. `GET /recommendations`, `/top`, and `/history` retrieve the current ranked set and prior refreshes. All endpoints are authenticated. The unversioned `/api` aliases remain available for scheme and bookmark APIs from Phase 3.

Run `npm run seed:schemes` to install the controlled scheme, eligibility-rule, and policy records. Rules and policy are versioned database configuration rather than Flutter or service-layer scores.

Flutter's eligibility and home recommendations call these APIs. Eligibility results show status, percentage, matched and missing requirements, missing documents, and suggestions; recommendation cards display their API-provided score and explanation. Bookmarks retain the Phase 3 MongoDB flow.
