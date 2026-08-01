# KrishiSahayak — System Architecture, Production Deployment & Quality Assurance Guide

---

## 1. System Architecture Overview

```
                          ┌──────────────────────────────────────────────┐
                          │         Flutter Android Mobile App           │
                          │   (Clean Architecture + Riverpod + STT/TTS) │
                          └──────────────────────┬───────────────────────┘
                                                 │
                                                 │ HTTPS / REST API (JWT)
                                                 ▼
                          ┌──────────────────────────────────────────────┐
                          │    Node.js + Express Production Backend       │
                          │  (Port 5005 / Helmet / RateLimiter / CORS)   │
                          └──────┬───────────────────────┬───────────────┘
                                 │                       │
                ┌────────────────┴────────┐     ┌────────┴─────────────────┐
                ▼                         ▼     ▼                          ▼
     ┌─────────────────────┐   ┌────────────────────┐   ┌────────────────────┐
     │ MongoDB Atlas Cloud │   │ Google Gemini AI   │   │  Tesseract OCR &   │
     │  (Indexes + Seed)   │   │  (RAG Reranking)   │   │ Document Analyzer  │
     └─────────────────────┘   └────────────────────┘   └────────────────────┘
```

---

## 2. Flutter Clean Architecture

- **`lib/core/`**: Configuration (`EnvConfig`), DI (`injection_container.dart`), Routing (`app_router.dart`), Localization (7 languages), Logger, Theme, Services (`VoiceService`, `NotificationService`, `LanguageService`, `ApiClient`).
- **`lib/data/`**: Remote & local datasources, Repositories (`GovernmentSchemeRepositoryImpl`, `AuthRepositoryImpl`, `BookmarkRepositoryImpl`, etc.).
- **`lib/domain/`**: Entities (`GovernmentSchemeEntity`, `FarmerProfileEntity`, `NotificationModel`, etc.) & Repository Interfaces.
- **`lib/presentation/`**: Screen controllers, Providers (Riverpod), Common UI components (`AppButton`, `AppCard`, `LanguageSelectorWidget`), and 15 production screens (`HomeScreen`, `AiChatScreen`, `VoiceAssistantScreen`, `NotificationsScreen`, `PdfExplainerScreen`, `EligibilityCheckerScreen`, `SettingsScreen`, etc.).

---

## 3. Node.js + Express Backend Architecture

- **`server.js`**: Cluster listener with graceful shutdown handling (SIGINT/SIGTERM).
- **`app.js`**: Express server setup with Helmet security, CORS origin whitelisting, Compression, Rate Limiting (Strict auth & AI limiters), standard 404 handler, and global error handling middleware.
- **`config/database.js`**: MongoDB connection pool (`maxPoolSize: 10`) with automatic active REST API fallback when offline.
- **`controllers/`**: 10 production controllers (`AuthController`, `ProfileController`, `SchemeController`, `EligibilityController`, `RecommendationController`, `ChatController`, `PdfController`, `ChecklistController`, `NotificationController`, `BookmarkController`).
- **`middleware/`**: `auth.middleware.js` (JWT protection with `protect` & `optionalAuth`), `error.middleware.js` (Production safe errors), `rate_limiter.middleware.js` (Per-route limits), `validation.middleware.js`.
- **`services/`**: `GeminiService.js` (AI integration), `RAGService.js` (Vector retrieval & prompt building), `EligibilityEngine.js` (Weighted rule evaluation), `RecommendationEngine.js` (Profile matching), `OCRService.js` (Document parsing), `TranslationService.js`.

---

## 4. MongoDB Atlas Schemas & Indexes

All MongoDB collections have optimized production indexes:

| Collection | Primary Indexes | Fulltext / Compound Indexes |
|---|---|---|
| `users` | `phoneNumber` (unique), `email` (sparse) | `{ createdAt: -1 }` |
| `profiles` | `userId` (unique) | `{ state: 1 }`, `{ cropTypes: 1 }` |
| `governmentschemes` | `schemeCode` (unique), `category` | `{ title: 'text', description: 'text', benefits: 'text' }` |
| `notifications` | `userId`, `isRead` | `{ userId: 1, isRead: 1 }`, `{ createdAt: -1 }` |
| `chathistories` | `userId` | `{ userId: 1, createdAt: -1 }` |
| `bookmarks` | `userId`, `schemeId` (compound unique) | `{ userId: 1 }` |
| `eligibilityrules` | `schemeId` | `{ isActive: 1 }` |
| `recommendations` | `userId` | `{ userId: 1, createdAt: -1 }` |

*Index script*: `node backend/scripts/create-indexes.js`

---

## 5. Production API Endpoints Summary

### Authentication & User Profile
- `POST /api/v1/auth/send-otp` — Send OTP to mobile
- `POST /api/v1/auth/verify-otp` — Verify OTP & generate JWT tokens
- `POST /api/v1/auth/google` — Google Auth login
- `POST /api/v1/auth/logout` — Revoke session
- `GET /api/v1/profile` — Fetch farmer profile
- `PUT /api/v1/profile` — Update farmer profile

### Schemes & Bookmarks
- `GET /api/v1/schemes` — Paginated scheme list with sorting & state filtering
- `GET /api/v1/schemes/:id` — Detailed scheme information
- `GET /api/v1/schemes/search?q=query` — Fulltext scheme search
- `GET /api/v1/bookmarks` — List bookmarked schemes
- `POST /api/v1/bookmarks` — Bookmark a scheme
- `DELETE /api/v1/bookmarks/:id` — Remove bookmark

### Eligibility & Recommendations
- `POST /api/v1/eligibility/check` — Rule-based scheme qualification check
- `GET /api/v1/recommendations` — AI profile-matched scheme recommendations

### AI Chatbot & Document Explainer
- `POST /api/v1/chat` — Context-aware scheme chatbot response
- `POST /api/v1/pdf/analyze` — Document OCR & AI analysis summary
- `POST /api/v1/checklist/generate` — Custom document checklist generator

### Notifications & Voice
- `GET /api/v1/notifications` — Fetch user notifications
- `PUT /api/v1/notifications/read` — Mark notification read
- `DELETE /api/v1/notifications/:id` — Dismiss notification
- `POST /api/v1/notifications/test` — Push test notification

---

## 6. Deployment Guide

### Deploying Node.js Backend to Production (VPS / Render / Railway)

1. **Environment Configuration**: Set environment variables on server:
   ```env
   PORT=5005
   NODE_ENV=production
   MONGODB_URI=mongodb+srv://<user>:<password>@cluster0.mongodb.net/krishisahayak?retryWrites=true&w=majority
   JWT_SECRET=production_jwt_secret_min_32_characters_long
   JWT_REFRESH_SECRET=production_jwt_refresh_secret_min_32_characters_long
   CORS_ORIGIN=https://app.krishisahayak.ai
   ```

2. **PM2 Process Management**:
   ```bash
   npm install -g pm2
   pm2 start server.js --name "krishisahayak-backend" -i max
   pm2 save
   pm2 startup
   ```

3. **Nginx Reverse Proxy Configuration**:
   ```nginx
   server {
       server_name api.krishisahayak.ai;
       location / {
           proxy_pass http://localhost:5005;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

---

## 7. Android Release APK Build Guide

1. **Build Preparation**:
   Copy `android/key.properties.example` to `android/key.properties` and fill keystore details.

2. **Run Build Command**:
   ```bash
   flutter clean
   flutter pub get
   flutter build apk --release
   ```

3. **Generated Artifact Location**:
   `build/app/outputs/flutter-apk/app-release.apk`

---

## 8. Final Acceptance Verification Checklist

| PDF Feature Requirement | Status | Details |
|---|---|---|
| 1. Farmer Registration & Profile | ✅ PASS | Phone OTP, Google Auth, Profile persistence in MongoDB Atlas |
| 2. Scheme Repository | ✅ PASS | 12+ schemes with official government portal links |
| 3. AI Chatbot | ✅ PASS | Context-aware scheme assistant with per-message TTS reading |
| 4. AI Scheme Explanation | ✅ PASS | Simplified benefits, eligibility & document requirements |
| 5. Multilingual Support | ✅ PASS | 7 regional languages (en, hi, mr, gu, ta, te, kn) persisted in SharedPreferences |
| 6. Eligibility Checker | ✅ PASS | Weighted match percentage engine with bullet points |
| 7. Personalized Recommendations | ✅ PASS | Profile-driven AI scheme matching |
| 8. AI PDF Explainer | ✅ PASS | OCR text extraction, summary generation, smart highlight chips |
| 9. Document Checklist Generator | ✅ PASS | Custom checklist generation & missing doc alerts |
| 10. Voice Assistant | ✅ PASS | Real STT + TTS integration, pulsing mic button screen |
| 11. Notifications & Alerts | ✅ PASS | Backend API connected, read status, swipe-to-dismiss |
| 12. Official Government Links | ✅ PASS | Verified links to pmkisan.gov.in, pmfby.gov.in, etc. |

**Final Quality Assessment**: PRODUCTION READY ✅
