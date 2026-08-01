const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const compression = require('compression');
const cookieParser = require('cookie-parser');
const { isConnected } = require('./config/database');
const errorHandler = require('./middleware/error.middleware');
const { apiLimiter, authLimiter, aiLimiter } = require('./middleware/rate_limiter.middleware');

// Route Imports
const authRoutes = require('./routes/auth.routes');
const profileRoutes = require('./routes/profile.routes');
const schemeRoutes = require('./routes/scheme.routes');
const eligibilityRoutes = require('./routes/eligibility.routes');
const chatRoutes = require('./routes/chat.routes');
const pdfRoutes = require('./routes/pdf.routes');
const checklistRoutes = require('./routes/checklist.routes');
const notificationRoutes = require('./routes/notification.routes');
const bookmarkRoutes = require('./routes/bookmark.routes');
const recommendationRoutes = require('./routes/recommendation.routes');

const app = express();

// ─── Security Middlewares ─────────────────────────────────────────────────────
app.use(
  helmet({
    crossOriginEmbedderPolicy: false,
    contentSecurityPolicy: {
      directives: {
        defaultSrc: ["'self'"],
        scriptSrc: ["'self'"],
        styleSrc: ["'self'", "'unsafe-inline'"],
        imgSrc: ["'self'", 'data:', 'https:'],
        connectSrc: ["'self'"],
      },
    },
  })
);

// CORS — allow configured origins only
const allowedOrigins = process.env.CORS_ORIGIN
  ? process.env.CORS_ORIGIN.split(',').map((o) => o.trim())
  : ['*'];

app.use(
  cors({
    origin: (origin, callback) => {
      if (!origin || allowedOrigins.includes('*') || allowedOrigins.includes(origin)) {
        callback(null, true);
      } else {
        callback(new Error('Not allowed by CORS'));
      }
    },
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
  })
);

// ─── Utility Middlewares ──────────────────────────────────────────────────────
app.use(compression());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));
app.use(cookieParser());

// Logging: compact in production, verbose in dev
app.use(
  morgan(process.env.NODE_ENV === 'production' ? 'combined' : 'dev', {
    skip: (req) => req.path === '/health',
  })
);

// ─── Rate Limiting ────────────────────────────────────────────────────────────
app.use('/api/', apiLimiter);
app.use('/api/v1/auth', authLimiter); // stricter for auth
app.use('/api/v1/chat', aiLimiter);  // stricter for AI

// ─── Health Check ─────────────────────────────────────────────────────────────
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'OK',
    version: '8.0.0',
    environment: process.env.NODE_ENV || 'development',
    database: isConnected() ? 'Connected' : 'Offline (fallback mode)',
    uptime: Math.floor(process.uptime()),
    timestamp: new Date().toISOString(),
  });
});

// ─── API v1 Route Registration ────────────────────────────────────────────────
app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/profile', profileRoutes);
app.use('/api/v1/schemes', schemeRoutes);
app.use('/api/v1/eligibility', eligibilityRoutes);
app.use('/api/v1/chat', chatRoutes);
app.use('/api/v1/pdf', pdfRoutes);
app.use('/api/v1/checklist', checklistRoutes);
app.use('/api/v1/notifications', notificationRoutes);
app.use('/api/v1/bookmarks', bookmarkRoutes);
app.use('/api/v1/recommendations', recommendationRoutes);

// ─── Legacy Compatibility Routes (Phase 3 contract) ──────────────────────────
app.use('/api/schemes', schemeRoutes);
app.use('/api/bookmarks', bookmarkRoutes);
app.use('/api/eligibility', eligibilityRoutes);
app.use('/api/recommendations', recommendationRoutes);
app.use('/api/chat', chatRoutes);
app.use('/api/pdf', pdfRoutes);
app.use('/api/checklist', checklistRoutes);

// ─── 404 Handler ─────────────────────────────────────────────────────────────
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: `Route ${req.originalUrl} not found.`,
  });
});

// ─── Global Error Handler ─────────────────────────────────────────────────────
app.use(errorHandler);

module.exports = app;
