# KrishiSahayak Phase 7 — Voice, Multilingual & Notifications Architecture

---

## 🎙️ Voice Assistant Architecture

```
Flutter UI (mic button / speak button)
        │
        ▼
VoiceService (voice_service.dart)
  ├── SpeechToText (speech_to_text ^7.0.0)
  │     ├── Requests Microphone Permission
  │     ├── Initializes for 7 language locales (en_IN, hi_IN, mr_IN, gu_IN, ta_IN, te_IN, kn_IN)
  │     ├── Streams partial & final recognized text
  │     └── Retry on error / cancel / pause support
  │
  └── FlutterTts (flutter_tts ^4.0.2)
        ├── Reads AI chatbot responses aloud
        ├── Reads PDF summaries aloud
        ├── 7 language TTS engines (en-IN, hi-IN, mr-IN, gu-IN, ta-IN, te-IN, kn-IN)
        └── Completion / error handlers
```

**Usage in AiChatScreen:**
- 🎤 Mic button → STT → sends message automatically
- 🔊 Per-message TTS button on each AI response
- 🔊 Global "Read last response" button in AppBar
- 🛑 Stop/cancel buttons on active voice states

---

## 🌐 Multilingual Flow

```
User taps language → Settings Screen
        │
        ▼
LanguageSelectorWidget.showLanguageModal()
        │
        ▼
LocaleNotifier.setLanguageCode(code)
  ├── Updates Riverpod localeProvider state
  ├── Persists to SharedPreferences (preferred_language key)
  └── Flutter rebuilds with new Locale → MaterialApp locale updates

On App Restart:
  LocaleNotifier._loadSavedLocale()
  └── Reads SharedPreferences → restores language immediately
```

**7 Languages fully supported:**
| Code | Language | Native Name |
|------|----------|-------------|
| en | English | English |
| hi | Hindi | हिंदी |
| mr | Marathi | मराठी |
| gu | Gujarati | ગુજરાતી |
| ta | Tamil | தமிழ் |
| te | Telugu | తెలుగు |
| kn | Kannada | ಕನ್ನಡ |

---

## 🔔 Notification System Architecture

```
Node.js Express Backend
        │
  ┌─────┼────────────────────────┐
  │     │                        │
GET    PUT                    DELETE
/api/v1/notifications    /api/v1/notifications/:id
  │     │
  │   /read (mark read)
  │
POST /api/v1/notifications/test

        │
        ▼
MongoDB Atlas — Notification Collection
  Fields: title, body, category, topic, isRead, readAt, userId, timestamps

        │
        ▼
Flutter NotificationService (notification_service.dart)
  ├── fetchNotifications() — GET /api/v1/notifications
  ├── markAsRead(id) — PUT /api/v1/notifications/read
  ├── deleteNotification(id) — DELETE /api/v1/notifications/:id
  └── In-memory fallback when backend is connecting

        │
        ▼
NotificationsScreen (notifications_screen.dart)
  ├── Pull-to-refresh
  ├── Mark all read button
  ├── Swipe-to-dismiss per notification
  ├── Category color badges
  ├── Unread dot indicator
  └── Time-ago display
```

**Notification Categories:**
- `Scheme Update` → Green
- `Deadline Reminder` → Orange
- `Recommendation` → Primary Blue
- `Document Reminder` → Blue
- `General` → Secondary
