const mongoose = require('mongoose');

/**
 * Configure & Establish MongoDB Atlas Connection
 * Production-ready connection pooling and fallback logic.
 */
const connectDB = async () => {
  const mongoURI = process.env.MONGODB_URI || 'mongodb://localhost:27017/krishisahayak';

  const options = {
    autoIndex: process.env.NODE_ENV !== 'production',
    serverSelectionTimeoutMS: 5000,
    socketTimeoutMS: 45000,
    maxPoolSize: 10,
    family: 4,
  };

  try {
    const conn = await mongoose.connect(mongoURI, options);
    console.log(`[MongoDB Atlas] Connected to Host: ${conn.connection.host} (DB: ${conn.connection.name})`);
  } catch (err) {
    if (process.env.NODE_ENV === 'production') {
      console.error(`[MongoDB Atlas Error] Connection failed: ${err.message}`);
    } else {
      console.warn(`[MongoDB Notice] ${err.message}. Backend running in active REST API fallback mode.`);
    }
  }
};

mongoose.connection.on('disconnected', () => {
  console.warn('[MongoDB] Warning: Connection lost.');
});

mongoose.connection.on('reconnected', () => {
  console.log('[MongoDB] Reconnected to Atlas cluster.');
});

const closeDB = async () => {
  try {
    await mongoose.connection.close();
    console.log('[MongoDB] Connection closed cleanly.');
  } catch (_) {}
};

module.exports = {
  connectDB,
  closeDB,
  isConnected: () => mongoose.connection.readyState === 1,
};
