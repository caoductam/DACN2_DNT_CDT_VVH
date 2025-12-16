const express = require('express');
const router = express.Router();
const Topic = require('../models/topic.model.js');

// GET - Lấy progress của user cụ thể (ĐẶT TRƯỚC tất cả routes khác)
router.get('/progress/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    console.log(`=== GET USER PROGRESS: ${userId} ===`);
    
    // Tìm tất cả topics
    const topics = await Topic.find();
    
    let totalTopics = topics.length;
    let totalLessons = 0;
    let completedLessons = 0;
    let completedTopics = 0;
    
    // Tính toán progress cho từng topic
    const topicProgress = topics.map(topic => {
      const lessonsCount = topic.lessons?.length || 0;
      totalLessons += lessonsCount;
      
      // Đếm completed lessons của user này
      const userCompletedLessons = topic.lessons?.filter(lesson => 
        lesson.completedBy && lesson.completedBy.includes(userId)
      ).length || 0;
      
      completedLessons += userCompletedLessons;
      
      // Nếu user hoàn thành tất cả lessons trong topic này
      if (userCompletedLessons === lessonsCount && lessonsCount > 0) {
        completedTopics++;
      }
      
      return {
        topicId: topic.topicId,
        title: topic.title,
        icon: topic.icon,
        totalLessons: lessonsCount,
        completedLessons: userCompletedLessons,
        progressPercentage: lessonsCount > 0 
          ? Math.round((userCompletedLessons / lessonsCount) * 100) 
          : 0
      };
    });
    
    const progressPercentage = totalLessons > 0 
      ? Math.round((completedLessons / totalLessons) * 100) 
      : 0;
    
    const response = {
      userId,
      totalTopics,
      totalLessons,
      completedTopics,
      completedLessons,
      progressPercentage,
      topics: topicProgress
    };
    
    console.log(`✅ User ${userId}: ${completedLessons}/${totalLessons} lessons (${progressPercentage}%)`);
    res.json(response);
    
  } catch (error) {
    console.error('❌ GET USER PROGRESS Error:', error);
    res.status(500).json({ 
      error: 'Failed to fetch user progress',
      message: error.message 
    });
  }
});

// GET - Lấy danh sách tất cả topics
router.get('/topics', async (req, res) => {
  try {
    console.log('=== GET ALL TOPICS ===');
    const topics = await Topic.find().sort({ order: 1 });
    console.log(`✅ Found ${topics.length} topics`);
    res.json(topics);
  } catch (error) {
    console.error('❌ GET Error:', error);
    res.status(500).json({ error: error.message });
  }
});

// GET - Lấy progress tổng hợp (không có userId)
router.get('/topics/progress', async (req, res) => {
  try {
    console.log('=== GET GENERAL PROGRESS ===');
    
    const topics = await Topic.find();
    
    const totalTopics = topics.length;
    const totalLessons = topics.reduce((sum, topic) => sum + (topic.totalLessons || 0), 0);
    
    // Tính toán progress
    let completedTopics = 0;
    let completedLessons = 0;
    
    topics.forEach(topic => {
      const topicLessons = topic.lessons || [];
      const topicCompleted = topicLessons.filter(lesson => lesson.completed).length;
      
      if (topicCompleted === topicLessons.length && topicLessons.length > 0) {
        completedTopics++;
      }
      completedLessons += topicCompleted;
    });
    
    const progress = {
      totalTopics,
      totalLessons,
      completedTopics,
      completedLessons,
      topics: topics.map(topic => ({
        id: topic._id,
        topicId: topic.topicId,
        title: topic.title,
        icon: topic.icon,
        totalLessons: topic.totalLessons || 0,
        completedLessons: (topic.lessons || []).filter(l => l.completed).length
      }))
    };
    
    console.log(`✅ Progress data: ${completedTopics}/${totalTopics} topics, ${completedLessons}/${totalLessons} lessons`);
    res.json(progress);
    
  } catch (error) {
    console.error('❌ GET PROGRESS Error:', error);
    res.status(500).json({ 
      error: error.message,
      type: error.name
    });
  }
});

// POST - Create new topic
router.post('/topics', async (req, res) => {
  try {
    console.log('=== POST REQUEST ===');
    console.log('Body received:', JSON.stringify(req.body, null, 2));
    
    const { topicId, icon, title, lessons } = req.body;
    
    console.log('Validation check:');
    console.log('- topicId:', topicId);
    console.log('- icon:', icon);
    console.log('- title:', title);
    console.log('- lessons count:', lessons?.length);
    
    if (!topicId || !icon || !title) {
      console.log('❌ Validation failed!');
      return res.status(400).json({ 
        error: 'Missing required fields',
        received: { topicId, icon, title }
      });
    }

    console.log('Creating new Topic...');
    const topic = new Topic(req.body);
    
    console.log('Saving to database...');
    await topic.save();
    
    console.log(`✅ Topic created: ${topic._id}`);
    res.status(201).json(topic);
    
  } catch (error) {
    console.error('❌ POST Error Details:');
    console.error('Name:', error.name);
    console.error('Message:', error.message);
    console.error('Stack:', error.stack);
    res.status(500).json({ 
      error: error.message,
      type: error.name
    });
  }
});

// PUT - Cập nhật topic theo ID
router.put('/topics/:id', async (req, res) => {
  try {
    console.log('=== PUT REQUEST ===');
    console.log('Topic ID:', req.params.id);
    console.log('Body received:', JSON.stringify(req.body, null, 2));
    
    const { topicId, icon, title, lessons, order, totalLessons } = req.body;
    
    console.log('Validation check:');
    console.log('- topicId:', topicId);
    console.log('- icon:', icon);
    console.log('- title:', title);
    console.log('- lessons count:', lessons?.length);
    console.log('- order:', order);
    console.log('- totalLessons:', totalLessons);
    
    if (!topicId || !icon || !title) {
      console.log('❌ Validation failed!');
      return res.status(400).json({ 
        error: 'Missing required fields',
        received: { topicId, icon, title }
      });
    }

    console.log('Updating topic...');
    const updatedTopic = await Topic.findByIdAndUpdate(
      req.params.id,
      {
        topicId,
        icon,
        title,
        lessons: lessons || [],
        order: order || 0,
        totalLessons: totalLessons || 0
      },
      { new: true, runValidators: true }
    );
    
    if (!updatedTopic) {
      console.log(`❌ Topic not found with id: ${req.params.id}`);
      return res.status(404).json({ error: 'Topic not found' });
    }
    
    console.log(`✅ Topic updated: ${updatedTopic._id}`);
    res.json(updatedTopic);
    
  } catch (error) {
    console.error('❌ PUT Error Details:');
    console.error('Name:', error.name);
    console.error('Message:', error.message);
    console.error('Stack:', error.stack);
    
    if (error.name === 'ValidationError') {
      return res.status(400).json({ 
        error: 'Validation failed',
        details: error.errors 
      });
    }
    
    res.status(500).json({ 
      error: error.message,
      type: error.name
    });
  }
});

// DELETE - Xóa topic theo ID
router.delete('/topics/:id', async (req, res) => {
  try {
    console.log('=== DELETE REQUEST ===');
    console.log('Topic ID:', req.params.id);
    
    const deletedTopic = await Topic.findByIdAndDelete(req.params.id);
    
    if (!deletedTopic) {
      console.log(`❌ Topic not found with id: ${req.params.id}`);
      return res.status(404).json({ error: 'Topic not found' });
    }
    
    console.log(`✅ Topic deleted: ${req.params.id}`);
    res.json({ message: 'Topic deleted successfully' });
    
  } catch (error) {
    console.error('❌ DELETE Error Details:');
    console.error('Name:', error.name);
    console.error('Message:', error.message);
    console.error('Stack:', error.stack);
    res.status(500).json({ 
      error: error.message,
      type: error.name
    });
  }
});

// GET - Lấy topic theo ID
router.get('/topics/:id', async (req, res) => {
  try {
    console.log('=== GET SINGLE TOPIC ===');
    console.log('Topic ID:', req.params.id);
    
    const topic = await Topic.findById(req.params.id);
    
    if (!topic) {
      console.log(`❌ Topic not found with id: ${req.params.id}`);
      return res.status(404).json({ error: 'Topic not found' });
    }
    
    console.log(`✅ Topic found: ${topic._id}`);
    res.json(topic);
    
  } catch (error) {
    console.error('❌ GET SINGLE Error Details:');
    console.error('Name:', error.name);
    console.error('Message:', error.message);
    console.error('Stack:', error.stack);
    res.status(500).json({ 
      error: error.message,
      type: error.name
    });
  }
});

module.exports = router;