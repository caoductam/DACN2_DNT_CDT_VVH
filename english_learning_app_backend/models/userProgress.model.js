const mongoose = require('mongoose');

const UserProgressSchema = new mongoose.Schema({
  userId: { type: String, required: true, unique: true },
  completedLessons: [{
    topicId: String,
    lessonId: String,
    completedAt: Date,
    score: Number
  }],
  totalProgress: { type: Number, default: 0 }, // % tổng thể
  lastAccessedTopic: String
}, {
  timestamps: true
});

module.exports = mongoose.model('UserProgress', UserProgressSchema);