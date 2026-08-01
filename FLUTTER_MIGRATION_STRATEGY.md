# KrishiSahayak — Flutter Client Migration Strategy (Phase 1)

This document maps current Flutter local data sources and services to the new **Node.js + Express.js + MongoDB Atlas** REST endpoints ready for Phase 2+ integration.

---

## 🗺️ Service Migration Map

| Current Flutter Service / Data Source | Current Storage / Logic | Future Node.js Express REST Endpoint | HTTP Method |
|---|---|---|---|
| `AuthRemoteDataSource` | `flutter_secure_storage` & local memory | `/api/v1/auth/login` <br> `/api/v1/auth/register` | `POST` |
| `FarmerProfileRepository` | Memory map | `/api/v1/profile` | `GET` / `PUT` |
| `SchemeRemoteDataSource` | Hardcoded Dart scheme array | `/api/v1/schemes` <br> `/api/v1/schemes/:id` | `GET` |
| `EligibilityEngine` | Client-side rule scoring | `/api/v1/eligibility/check` | `POST` |
| `GeminiAiService` | Client-side Vertex AI call | `/api/v1/chat` | `POST` |
| `OcrTextExtractor` | Client MLKit text recognition | `/api/v1/pdf/explain` | `POST` |
| `ChecklistEngine` | Client rule engine | `/api/v1/checklist/:schemeId` | `GET` |
| `FirebaseCloudMessagingService` | Client FCM wrapper | `/api/v1/notifications` | `GET` |
| `BookmarkRepository` | SharedPreferences | `/api/v1/bookmarks` | `GET` / `POST` |
| `RecommendationEngine` | Client score sorter | `/api/v1/recommendations` | `GET` |

---

## 🛠️ Step-by-step Client Migration Plan for Phase 2:
1. Update `lib/core/config/env_config.dart` with `NODE_API_BASE_URL` (`http://localhost:5000/api/v1`).
2. Replace mock datasources with HTTP REST client calls using `http` / `dio` package.
3. Attach JWT Bearer token headers automatically via Riverpod `authInterceptorProvider`.
4. Maintain `SchemeLocalDataSource` disk cache as offline fallback when device loses network connectivity.
