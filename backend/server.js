require('dotenv').config();
const app = require('./app');
const { connectDB, closeDB } = require('./config/database');

const PORT = process.env.PORT || 5000;

// Connect to MongoDB Atlas
connectDB();

// Start Server
const server = app.listen(PORT, () => {
  console.log(`====================================================`);
  console.log(`[KrishiSahayak Express Backend] Running on Port ${PORT}`);
  console.log(`[Environment] ${process.env.NODE_ENV || 'development'}`);
  console.log(`[Health Endpoint] http://localhost:${PORT}/health`);
  console.log(`====================================================`);
});

// Handle Graceful Shutdown
const handleShutdown = async (signal) => {
  console.log(`\n[Server] Received ${signal}. Shutting down gracefully...`);
  server.close(async () => {
    await closeDB();
    console.log('[Server] Process terminated cleanly.');
    process.exit(0);
  });
};

process.on('SIGTERM', () => handleShutdown('SIGTERM'));
process.on('SIGINT', () => handleShutdown('SIGINT'));

process.on('unhandledRejection', (err) => {
  console.error(`[Unhandled Rejection] ${err.message}`);
});
