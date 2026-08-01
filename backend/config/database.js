const mongoose = require('mongoose');

/**
 * Configure & Establish MongoDB Atlas Connection
 */
const connectDB = async () => {
  const mongoURI = process.env.MONGODB_URI || 'mongodb://localhost:27017/krishisahayak';

  const options = {
    autoIndex: true,
    serverSelectionTimeoutMS: 5000,
    socketTimeoutMS: 45000,
    family: 4,
  };

  try {
    const conn = await mongoose.connect(mongoURI, options);
    console.log(`[MongoDB] Connected to Host: ${conn.connection.host} (DB: ${conn.connection.name})`);
  } catch (err) {
    console.error(`[MongoDB] Connection Failed: ${err.message}`);
    console.log('[MongoDB] Retrying connection in 5 seconds...');
    setTimeout(connectDB, 5000);
  }
};

// Handle Connection Events
mongoose.connection.on('disconnected', () => {
  console.warn('[MongoDB] Warning: Database connection lost.');
});

mongoose.connection.on('reconnected', () => {
  console.log('[MongoDB] Reconnected to Database successfully.');
});

// Graceful Shutdown
const closeDB = async () => {
  try {
    await mongoose.connection.close();
    console.log('[MongoDB] Database connection closed cleanly.');
  } catch (err) {
    console.error(`[MongoDB] Error closing connection: ${err.message}`);
  }
};

module.exports = {
  connectDB,
  closeDB,
  isConnected: () => mongoose.connection.readyState === 1,
};
