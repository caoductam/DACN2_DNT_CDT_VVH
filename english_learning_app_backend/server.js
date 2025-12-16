// ====== IMPORTS & CONFIG ======
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');
dotenv.config();

const app = express();

// ====== CORS CONFIG ======
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(express.json());

// ====== LOGGING MIDDLEWARE ======
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} ${req.method} ${req.url}`);
  next();
});

// ====== IMPORT ROUTES ======
const topicRoutes = require('./routes/topic.routes.js');
const authRoute = require('./routes/auth');
const userRoute = require('./routes/user'); // <--- user profile

// ====== CONNECT MONGODB ======
const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/grammar-app');
    console.log('✅ MongoDB connected successfully');
  } catch (error) {
    console.error('❌ MongoDB connection error:', error.message);
    process.exit(1);
  }
};
connectDB();

// ====== TEST & HEALTH ENDPOINTS ======
app.get('/api/test-connection', (req, res) => {
  res.json({ 
    success: true,
    message: 'Connection successful!',
    timestamp: new Date().toISOString(),
    server: 'Grammar API Server',
    version: '1.0.0'
  });
});

app.get('/api/simple-progress', (req, res) => {
  res.json({
    totalTopics: 5,
    totalLessons: 20,
    completedTopics: 0,
    completedLessons: 0,
    message: 'Progress data (mock)'
  });
});

app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'OK',
    server: 'Grammar API',
    timestamp: new Date().toISOString(),
    mongodb: mongoose.connection.readyState === 1 ? 'Connected' : 'Disconnected',
    endpoints: [
      '/api/health',
      '/api/topics',
      '/api/topics/progress',
      '/api/test-connection',
      '/api/simple-progress',
      '/api/auth',
      '/api/user'
    ]
  });
});

app.get('/', (req, res) => {
  res.json({ 
    message: 'Grammar API is running!',
    endpoints: {
      health: '/api/health',
      topics: '/api/topics',
      progress: '/api/topics/progress',
      testConnection: '/api/test-connection',
      simpleProgress: '/api/simple-progress',
      auth: '/api/auth',
      user: '/api/user'
    }
  });
});

// ====== USE ROUTES ======
app.use('/api', topicRoutes);
app.use('/api/auth', authRoute);
app.use('/api/user', userRoute);

// ====== 404 HANDLER ======
app.use((req, res) => {
  console.log(`❌ 404 - Route not found: ${req.method} ${req.originalUrl}`);
  res.status(404).json({ 
    error: 'Route not found',
    requested: `${req.method} ${req.originalUrl}`,
    availableEndpoints: [
      'GET /api/health',
      'GET /api/topics',
      'GET /api/topics/progress',
      'GET /api/test-connection',
      'GET /api/simple-progress',
      'POST /api/topics',
      'PUT /api/topics/:id',
      'DELETE /api/topics/:id',
      'GET /api/topics/:id',
      'POST /api/auth/*',
      'GET /api/user/*'
    ]
  });
});

// ====== ERROR HANDLING ======
app.use((err, req, res, next) => {
  console.error('🚨 Server error:', err.message);
  console.error(err.stack);
  res.status(500).json({ 
    error: 'Internal server error',
    message: err.message 
  });
});

// ====== START SERVER ======
const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`🌐 Access URLs:`);
  console.log(`   Local: http://localhost:${PORT}`);
  console.log(`   Android Emulator: http://10.0.2.2:${PORT}`);
  console.log(`\n📋 Test these URLs in browser:`);
  console.log(`   1. http://localhost:${PORT}/api/health`);
  console.log(`   2. http://localhost:${PORT}/api/test-connection`);
  console.log(`   3. http://localhost:${PORT}/api/topics/progress`);
});