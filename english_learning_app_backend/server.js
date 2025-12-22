// ====== IMPORTS & CONFIG ======
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');

dotenv.config(); // 🔥 PHẢI GỌI SỚM

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
const userRoute = require('./routes/user');
const writingRoute = require('./routes/writing');

// ====== CONNECT MONGODB ======
const connectDB = async () => {
  try {
    console.log('⏳ Connecting to MongoDB...');
    console.log('🔎 URI:', process.env.MONGODB_URI ? 'FOUND' : '❌ NOT FOUND');

    await mongoose.connect(process.env.MONGODB_URI, {
      serverSelectionTimeoutMS: 5000, // 🔥 CHỐNG TREO
    });

    console.log('✅ MongoDB connected successfully');
  } catch (error) {
    console.error('❌ MongoDB connection error:', error.message);
    process.exit(1);
  }
};

connectDB();

// 🔥 ADDED: BẮT TRẠNG THÁI MONGO RUNTIME
mongoose.connection.on('connected', () => {
  console.log('🟢 MongoDB READY');
});

mongoose.connection.on('disconnected', () => {
  console.error('🔴 MongoDB DISCONNECTED');
});

mongoose.connection.on('error', err => {
  console.error('❌ MongoDB RUNTIME ERROR:', err.message);
});

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
      '/api/user',
      '/api/writing'
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
      user: '/api/user',
      writing: '/api/writing'
    }
  });
});

// ====== USE ROUTES ======
app.use('/api', topicRoutes);
app.use('/api/auth', authRoute);
app.use('/api/user', userRoute);
app.use('/api/writing', writingRoute);

// ====== 404 HANDLER ======
app.use((req, res) => {
  console.log(`❌ 404 - Route not found: ${req.method} ${req.originalUrl}`);
  res.status(404).json({ 
    error: 'Route not found',
    requested: `${req.method} ${req.originalUrl}`
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

// 🔥 ADDED: BẮT LỖI PROMISE TREO (QUAN TRỌNG)
process.on('unhandledRejection', reason => {
  console.error('🔥 UNHANDLED PROMISE:', reason);
});

// ====== START SERVER ======
const PORT = process.env.PORT || 5000;

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`🌐 Local: http://localhost:${PORT}`);
  console.log(`📱 Android Emulator: http://10.0.2.2:${PORT}`);
});
