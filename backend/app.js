const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const compression = require('compression');
const cookieParser = require('cookie-parser');
const { isConnected } = require('./config/database');
const errorHandler = require('./middleware/error.middleware');
const { apiLimiter } = require('./middleware/rate_limiter.middleware');

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

// Security & Utility Middlewares
app.use(helmet());
app.use(cors({ origin: process.env.CORS_ORIGIN || '*', credentials: true }));
app.use(compression());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));
app.use(cookieParser());
app.use(morgan(process.env.NODE_ENV === 'development' ? 'dev' : 'combined'));

// Rate Limiter
app.use('/api/', apiLimiter);

// Health Check Endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'OK',
    database: isConnected() ? 'Connected' : 'Disconnected',
    server: 'Running',
  });
});

// API v1 Route Registration
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

// Global Error Handler
app.use(errorHandler);

module.exports = app;
