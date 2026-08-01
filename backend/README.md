# KrishiSahayak Node.js Express & MongoDB Atlas Backend (Phase 1 Foundation)

Production-ready Node.js & Express.js backend infrastructure for **KrishiSahayak** agricultural platform.

---

## 🛠️ Architecture & Tech Stack

- **Runtime**: Node.js (>= 18.0.0)
- **Framework**: Express.js
- **Database**: MongoDB Atlas (via Mongoose ODM)
- **Security**: Helmet, CORS, JWT Authentication, Express Rate Limit
- **Utilities**: Morgan, Compression, Cookie Parser, Express Validator, Multer

---

## 📂 Folder Structure

```text
backend/
├── config/             # Database connection & environment setup (database.js)
├── controllers/        # Express controllers (HTTP 501 placeholders for Phase 1)
├── middleware/         # Auth, Error Handler, Async Wrapper, Rate Limiter
├── models/             # Mongoose schemas (User, Profile, Scheme, Eligibility, etc.)
├── repositories/       # Data access layer repositories
├── routes/             # Express API v1 route definitions
├── services/           # Business logic service class skeletons
├── validators/         # Request input validation rules
├── utils/              # Helper utilities
├── uploads/            # Temporary file upload storage
├── logs/               # Application log files
├── tests/              # Jest integration tests
├── app.js              # Express app initialization & route registration
├── server.js           # Server entry point & database connection
├── package.json        # Node dependencies & npm scripts
└── .env.example        # Environment variable placeholders
```

---

## 🚀 API Endpoints Overview (Phase 1 Scaffold)

- `GET /health` -> `{"status": "OK", "database": "Connected", "server": "Running"}`
- `POST /api/v1/auth/*` -> 501 Not Implemented Yet
- `GET /api/v1/profile/*` -> 501 Not Implemented Yet
- `GET /api/v1/schemes/*` -> 501 Not Implemented Yet
- `POST /api/v1/eligibility/*` -> 501 Not Implemented Yet
- `POST /api/v1/chat/*` -> 501 Not Implemented Yet
- `POST /api/v1/pdf/*` -> 501 Not Implemented Yet

---

## 💻 Getting Started

```bash
# 1. Install dependencies
cd backend
npm install

# 2. Copy environment file
cp .env.example .env

# 3. Start development server
npm run dev
```
