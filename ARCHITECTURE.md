# KrishiSahayak — System Architecture

KrishiSahayak adheres strictly to **Clean Architecture** and **MVVM** design principles, ensuring complete decoupling between UI views, state management, domain business logic, and backend data sources.

---

## 🏛️ Layer Breakdown

```
lib/
├── core/
│   ├── config/            # App environment configurations
│   ├── constants/         # Color palettes, typography, assets, constants
│   ├── di/                # GetIt dependency injection container
│   ├── error/             # Global error handler & exception classes
│   ├── localization/      # 7 regional languages translations & delegates
│   ├── logger/            # AppLogger utility
│   ├── routing/           # GoRouter route definitions & guards
│   ├── services/          # Firebase, AI RAG, MLKit OCR, Voice TTS/STT, Secure Storage
│   ├── theme/             # Material Design 3 light and dark themes
│   └── utils/             # Responsive layout helpers
├── data/
│   ├── datasources/       # Remote (Firestore/Firebase Auth) & Local (Disk/SecureStorage)
│   ├── models/            # JSON serializable data transfer models
│   └── repositories/      # Concrete repository implementations (Offline-first caching)
├── domain/
│   ├── entities/          # Pure immutable domain entities
│   └── repositories/      # Abstract repository interfaces
└── presentation/
    ├── common_widgets/    # Reusable M3 UI component library (Buttons, Cards, Dialogs, Search, Top/Bottom Bars)
    ├── providers/         # Riverpod StateNotifiers & StateProviders
    └── screens/           # Clean MVVM screen views (Home, Schemes, Chat, Eligibility, PDF Explainer, Checklist)
```

---

## 🔄 RAG AI Query Flow

```
[ Farmer Voice / Text Query ]
             │
             ▼
[ Language Translation & Sanitization ]
             │
             ▼
[ RagSearchEngine Semantic Retrieval ] ──► Queries Firestore Schemes Knowledge Base
             │
             ▼
[ Prompt Assembly with Profile Context ] (State, Crop, Land Size, Category)
             │
             ▼
[ Firebase Vertex AI (Gemini 1.5 Flash) ] ──► Streaming Structured Response
             │
             ▼
[ UI Chat Bubble Rendering + TTS Read Aloud ]
```

---

## 🛡️ Security Architecture

1. **Client-side API Secrets Protection**: Zero committed `.env` files or API secrets inside client code. Keys injected securely at build time via `--dart-define=GEMINI_API_KEY=xxx`.
2. **Encrypted Session Token Storage**: Sensitive auth credentials stored via Android Keystore / iOS Keychain using `flutter_secure_storage`.
3. **Official External Link Safety**: All portal redirection URLs must use `HTTPS` and pass an explicit user confirmation modal (`AppDialog`) before launching external applications.
