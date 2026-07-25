# Deployment Guide for KrishiSahayak

This guide outlines the production deployment steps for Android and Web.

---

## 📱 Android Release Deployment

### 1. Build APK
```bash
flutter build apk --release --dart-define=GEMINI_API_KEY="YOUR_PRODUCTION_API_KEY"
```
The output APK is generated at:
`build/app/outputs/flutter-apk/app-release.apk`

### 2. Build Android App Bundle (.aab) for Google Play Store
```bash
flutter build appbundle --release --dart-define=GEMINI_API_KEY="YOUR_PRODUCTION_API_KEY"
```
The output App Bundle is generated at:
`build/app/outputs/bundle/release/app-release.aab`

---

## 🌐 Web Deployment (Firebase Hosting / Vercel)

### 1. Build Web Release Bundle
```bash
flutter build web --release --dart-define=GEMINI_API_KEY="YOUR_PRODUCTION_API_KEY"
```

### 2. Deploy to Firebase Hosting
```bash
firebase deploy --only hosting
```
The live web app bundle is located under `build/web/`.
