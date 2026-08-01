const jwt = require('jsonwebtoken');

/**
 * JWT Authentication Middleware — Production Hardened
 * Validates Bearer tokens from Authorization header or HTTP-only cookie.
 */
const protect = (req, res, next) => {
  let token;

  // Prefer Authorization header, fall back to cookie
  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer ')) {
    token = req.headers.authorization.split(' ')[1].trim();
  } else if (req.cookies && req.cookies.token) {
    token = req.cookies.token;
  }

  if (!token) {
    return res.status(401).json({
      success: false,
      message: 'Access denied. No authentication token provided.',
    });
  }

  const jwtSecret = process.env.JWT_SECRET;
  if (!jwtSecret) {
    console.error('[Auth Middleware] CRITICAL: JWT_SECRET is not set in environment variables.');
    return res.status(500).json({
      success: false,
      message: 'Server configuration error.',
    });
  }

  try {
    const decoded = jwt.verify(token, jwtSecret);
    req.user = decoded;
    next();
  } catch (err) {
    const message =
      err.name === 'TokenExpiredError'
        ? 'Authentication token has expired. Please log in again.'
        : 'Invalid authentication token.';
    return res.status(401).json({ success: false, message });
  }
};

/**
 * Optional auth — attaches user if token present, but does not block.
 */
const optionalAuth = (req, res, next) => {
  let token;
  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer ')) {
    token = req.headers.authorization.split(' ')[1].trim();
  } else if (req.cookies && req.cookies.token) {
    token = req.cookies.token;
  }

  if (!token) return next();

  const jwtSecret = process.env.JWT_SECRET;
  if (!jwtSecret) return next();

  try {
    const decoded = jwt.verify(token, jwtSecret);
    req.user = decoded;
  } catch (_) {
    // Silently ignore invalid tokens in optional auth
  }
  next();
};

module.exports = { protect, optionalAuth };
