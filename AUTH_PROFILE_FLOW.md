# KrishiSahayak Phase 2 — Authentication & Profile Flow Architecture

This document describes the production **Authentication, JWT Session Management, and Profile Persistence Architecture** connecting the Flutter mobile app to the Node.js + Express + MongoDB Atlas backend.

---

## 🔄 Authentication & Token Architecture

```
[ Flutter Mobile App ]
         │
         │ 1. POST /api/v1/auth/send-otp (Phone number)
         ▼
[ Node.js Express Backend ] ──► Sends OTP SMS
         │
         │ 2. POST /api/v1/auth/verify-otp (Phone + OTP)
         ▼
[ Node.js Express Backend ]
         │
         ├──► Creates / Updates User record in MongoDB `users` collection
         ├──► Generates JWT Access Token (1d) & Refresh Token (7d)
         └──► Returns JWT Tokens & User Object
         │
         ▼
[ Flutter Secure Storage ]
         └── Stores ONLY JWT Access & Refresh Tokens on device securely. Zero profile maps stored on disk!

[ Subsequent API Calls ]
         └── Automatically attaches `Authorization: Bearer <jwt_token>` header via `ApiClient`.
```

---

## 💾 Profile Persistence Flow

1. **Profile Creation / Wizard**:
   - Flutter user completes 5-step registration wizard.
   - Flutter invokes `FarmerProfileRepositoryImpl.saveProfile(...)`.
   - Sends `PUT /api/v1/profile` HTTP request to Node.js backend.
   - Express validates input via `profile.validator.js` and persists profile in MongoDB `profiles` collection linked via `userId`.

2. **App Restart & Session Restore**:
   - Flutter loads JWT token from `SecureStorageService`.
   - Sends `GET /api/v1/profile` with Bearer Token.
   - Express retrieves farmer profile directly from MongoDB Atlas.
   - Data persists reliably across app restarts!
