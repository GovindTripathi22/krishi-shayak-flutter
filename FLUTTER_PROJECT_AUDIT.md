# KrishiSahayak — Flutter Project Complete Technical Audit Report (Phase 1)

> **Audit Target**: `d:\agrisathi_ai`  
> **Framework**: Flutter 3.10+ (Clean Architecture + MVVM + Riverpod + GetIt DI)  
> **Date**: August 2026  

---

## 1. Executive Summary

This complete technical audit scans the entire Flutter codebase to prepare for integration with the new **Node.js + Express.js + MongoDB Atlas** production backend. The audit evaluates code architecture, identifying reusable components, mock services, hardcoded data sources, and security considerations.

---

## 2. Category Audit Breakdown

### A. Reusable Code (Kept Unchanged)
These modules strictly follow Clean Architecture and MVVM principles and will seamlessly consume the new Node.js REST API:

1. **Domain Layer Entities (`lib/domain/entities/`)**:
   - [`farmer_profile_entity.dart`](file:///d:/agrisathi_ai/lib/domain/entities/farmer_profile_entity.dart): Immutable farmer profile entity.
   - [`government_scheme_entity.dart`](file:///d:/agrisathi_ai/lib/domain/entities/government_scheme_entity.dart): Government scheme business model.
   - [`eligibility_input_params.dart`](file:///d:/agrisathi_ai/lib/domain/entities/eligibility_input_params.dart) & [`eligibility_result_entity.dart`](file:///d:/agrisathi_ai/lib/domain/entities/eligibility_result_entity.dart): Rule evaluator inputs & outputs.
   - [`checklist_item_entity.dart`](file:///d:/agrisathi_ai/lib/domain/entities/checklist_item_entity.dart) & [`scheme_checklist_entity.dart`](file:///d:/agrisathi_ai/lib/domain/entities/scheme_checklist_entity.dart): Document checklist entities.

2. **Core Utilities & Presentation (`lib/core/` & `lib/presentation/`)**:
   - [`app_router.dart`](file:///d:/agrisathi_ai/lib/core/routing/app_router.dart): GoRouter navigation configuration.
   - [`injection_container.dart`](file:///d:/agrisathi_ai/lib/core/di/injection_container.dart): GetIt Dependency Injection container.
   - [`app_theme.dart`](file:///d:/agrisathi_ai/lib/core/theme/app_theme.dart) & [`app_colors.dart`](file:///d:/agrisathi_ai/lib/core/constants/app_colors.dart): Material Design 3 design system.
   - [`app_localizations.dart`](file:///d:/agrisathi_ai/lib/core/localization/app_localizations.dart): 7 regional Indian language delegates.

---

### B. Code to Replace (Future REST API Integration Target)
These client-side data sources currently rely on local storage or hardcoded fallback lists and will be migrated to the Express REST API in Phase 2+:

1. **Authentication Data Source**:
   - File: [`lib/data/datasources/auth_remote_datasource.dart`](file:///d:/agrisathi_ai/lib/data/datasources/auth_remote_datasource.dart)
   - Current State: Uses `flutter_secure_storage` & local memory maps.
   - Target API: `POST /api/v1/auth/login`, `POST /api/v1/auth/register`, `GET /api/v1/profile`

2. **Scheme Repository Data Source**:
   - File: [`lib/data/datasources/scheme_remote_datasource.dart`](file:///d:/agrisathi_ai/lib/data/datasources/scheme_remote_datasource.dart)
   - Current State: Hardcoded array of 8 government schemes in Dart.
   - Target API: `GET /api/v1/schemes`, `GET /api/v1/schemes/:id`

3. **AI Chatbot & RAG Engine**:
   - File: [`lib/core/services/ai/gemini_ai_service.dart`](file:///d:/agrisathi_ai/lib/core/services/ai/gemini_ai_service.dart)
   - Current State: Direct Gemini Vertex AI call & local HTTP fallback.
   - Target API: `POST /api/v1/chat`

4. **PDF Explainer & Document Intelligence**:
   - File: [`lib/core/services/document/ocr_text_extractor.dart`](file:///d:/agrisathi_ai/lib/core/services/document/ocr_text_extractor.dart)
   - Current State: Client MLKit text recognition.
   - Target API: `POST /api/v1/pdf/explain`

5. **Eligibility Engine**:
   - File: [`lib/core/services/eligibility/eligibility_engine.dart`](file:///d:/agrisathi_ai/lib/core/services/eligibility/eligibility_engine.dart)
   - Current State: Client Dart rule evaluator.
   - Target API: `POST /api/v1/eligibility/check`

---

### C. Security Audit & Recommendations
1. **JWT Authentication**: Node.js backend will handle JWT access tokens & refresh tokens stored securely in HTTP-only cookies and `flutter_secure_storage`.
2. **CORS & Rate Limiting**: Express backend uses `helmet`, `cors`, and `express-rate-limit` to prevent brute force & unauthorized access.
3. **Environment Secrets**: Zero committed production credentials. All database URIs, JWT secrets, and Gemini API keys configured via `.env`.
