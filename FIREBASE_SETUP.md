# Firebase Setup Guide for KrishiSahayak

This guide explains how to connect your Firebase Project with **KrishiSahayak**.

---

## Step 1: Create Firebase Project
1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Click **Add Project** and name it `KrishiSahayak`.
3. Enable **Google Analytics** and **Crashlytics**.

---

## Step 2: Android App Configuration
1. Register Android app with package name: `com.krishisahayak.ai`.
2. Download `google-services.json` and place it in:
   `android/app/google-services.json`
3. Add SHA-1 and SHA-256 fingerprints in Firebase Settings for Google Sign-In and Phone Auth.

---

## Step 3: Enable Authentication Methods
1. Go to **Authentication** ➔ **Sign-in method**.
2. Enable **Phone Authentication**.
3. Enable **Google Sign-In**.

---

## Step 4: Cloud Firestore Security Rules
Paste the following security rules in Firestore Rules editor:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // User profile rules
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Scheme repository rules (Public read, admin write)
    match /schemes/{schemeId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }

    // Eligibility check logs
    match /eligibility_history/{historyId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

---

## Step 5: Enable Firebase Vertex AI (Firebase AI Logic)
1. Go to Firebase Console ➔ **Vertex AI for Firebase**.
2. Click **Get Started** to enable Vertex AI APIs in Google Cloud.
3. This powers Gemini 1.5 Flash streaming RAG responses natively in the Flutter app.
