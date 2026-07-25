# KrishiSahayak — AI-Powered Agricultural Assistant for Farmers

**KrishiSahayak** is a production-grade, Google-quality Flutter mobile application engineered to help Indian farmers discover government agricultural schemes, evaluate eligibility automatically, extract insights from government PDFs/circulars, chat with an AI assistant in regional languages, track document checklists, and navigate to official application portals.

---

## 🌟 Core Features

- **🌾 Farmer Registration & Profile**: Phone OTP authentication, Google Sign-In, and 5-step registration wizard collecting location, land holding, crops, income, and preferred language.
- **📚 Government Scheme Repository**: Scalable scheme directory with multi-criteria filtering (State, Crop, Category, Central/State), smart search, and bookmark persistence.
- **🏡 Home Dashboard & Live Weather Advisory**: Real-time temperature, humidity, rain probability, farming advice, dismissible alerts, 2-tap quick action grid, recommended schemes, and continue reading card.
- **🤖 AI Scheme Eligibility Checker**: Dynamic rule evaluation engine calculating match percentages, explainability bullet points (*Why You Qualify*, *Missing Requirements*), and actionable insights.
- **💬 Gemini RAG Assistant & Voice Engine**: Retrieval-Augmented Generation (RAG) vector search over scheme repository powered by Firebase AI Logic (Vertex AI), Speech-to-Text (STT) microphone input, and Text-to-Speech (TTS) Read Aloud playback in 7 Indian languages.
- **📄 AI Document Intelligence & PDF Explainer**: Upload government PDFs or scan brochures (JPEG, PNG, HEIC) with Google MLKit OCR, Gemini summarization, smart highlights (`money`, `deadline`, `document`), and document Q&A.
- **📋 AI Document Checklist Generator**: Dynamically generates required document checklists for any scheme, tracks completion status (`Completed`, `Pending`, `Not Available`), provides AI purpose explanations, and calculates progress percentages.
- **🔔 Notifications & Alerts**: Firebase Cloud Messaging (FCM) topic subscriptions and local deadline reminders.
- **🌐 Official Application Links**: Verified HTTPS links opening official `.gov.in` portals with safety warning modals.

---

## 🛠️ Technology Architecture

- **Core**: Flutter 3.10+, Dart 3.0+
- **Architecture**: Clean Architecture (Domain, Data, Presentation, Core) + MVVM
- **State Management**: Riverpod (`flutter_riverpod`)
- **Dependency Injection**: GetIt (`get_it`)
- **Routing**: GoRouter (`go_router`)
- **Backend & Cloud**: Firebase Auth, Cloud Firestore, Firebase Storage, Firebase Messaging (FCM), Firebase Vertex AI Logic
- **Machine Learning & OCR**: Google MLKit Text Recognition (`google_mlkit_text_recognition`)
- **Voice**: `speech_to_text`, `flutter_tts`, `permission_handler`
- **Security**: `flutter_secure_storage`, HTTPS URL validation, zero hardcoded API keys

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>= 3.10.0)
- Android Studio / VS Code
- Firebase Account (Google Services configured)

### Installation
```bash
# 1. Clone repository
git clone https://github.com/GovindTripathi22/KrishiSahayak.git
cd KrishiSahayak

# 2. Get dependencies
flutter pub get

# 3. Run application with Gemini API Key
flutter run --dart-define=GEMINI_API_KEY="YOUR_API_KEY"

# 4. Build Android Release APK
flutter build apk --release --dart-define=GEMINI_API_KEY="YOUR_API_KEY"
```

---

## 📄 Documentation

- [Architecture Guide](ARCHITECTURE.md)
- [Firebase Setup Guide](FIREBASE_SETUP.md)
- [Deployment Guide](DEPLOYMENT_GUIDE.md)

---

## 📜 License
Crafted with ♥ for Indian Farmers.
