const mongoose = require('mongoose');

/**
 * Configure & Establish MongoDB Atlas Connection with Quick Fallback
 */
const connectDB = async () => {
  const mongoURI = process.env.MONGODB_URI || 'mongodb://localhost:27017/krishisahayak';

  const options = {
    autoIndex: true,
    serverSelectionTimeoutMS: 2000,
    socketTimeoutMS: 10000,
    family: 4,
  };

  try {
    const conn = await mongoose.connect(mongoURI, options);
    console.log(`[MongoDB Atlas] Connected to Host: ${conn.connection.host} (DB: ${conn.connection.name})`);
  } catch (err) {
    console.warn(`[MongoDB Notice] ${err.message}. Backend running in active REST API mode.`);
  }
};

mongoose.connection.on('disconnected', () => {
  console.warn('[MongoDB] Warning: Connection lost.');
});

const closeDB = async () => {
  try {
    await mongoose.connection.close();
  } catch (_) {}
};

module.exports = {
  connectDB,
  closeDB,
  isConnected: () => mongoose.connection.readyState === 1,
};
