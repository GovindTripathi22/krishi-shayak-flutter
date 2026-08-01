# Phase 3 – Scheme Repository

The MongoDB `government_schemes` collection stores official scheme content, targeting information, eligibility, dates, official `.gov.in`/`.nic.in` links, FAQs, language labels, source provenance, and lifecycle status. Text, list-filter, status, priority, deadline, and browse indexes support the API.

## API

Both `/api/v1` and `/api` prefixes are available. Public endpoints are `GET /schemes`, `GET /schemes/:id`, `GET /schemes/search?q=`, `GET /schemes/categories`, `GET /schemes/featured`, and `GET /schemes/latest`.

List/search accepts `page` (from 1), `limit` (1–50), `state`, `district`, `crop`, `category`, `schemeType=central|state`, `isCentralScheme`, `featured`, `status`, `deadline=upcoming`, and `sort=newest|updated|benefits|deadline|alphabetical|popular`. Responses contain `data` and pagination metadata. Empty queries return an empty `data` list; an out-of-range page returns 404.

Bookmarks are authenticated: `GET /bookmarks`, `POST /bookmarks` with `{ "schemeId": "..." }`, and `DELETE /bookmarks/:schemeId`. The `(userId, schemeId)` unique index makes saves idempotent.

## Seed data

Run `npm run seed:schemes` from `backend` with `MONGODB_URI` configured. Seed records use `source: "seed"` and are upserted by scheme code, keeping them distinct from future `admin` and `import` records. The command also upserts controlled eligibility rules and a versioned recommendation policy. Official links must use HTTPS and a `.gov.in` or `.nic.in` host.

## Flutter integration

Flutter reads list, search, details, featured, latest, and bookmarks through the HTTP API. The local scheme cache is retained only for offline fallback; it performs no filtering, sorting, or bookmark persistence.
