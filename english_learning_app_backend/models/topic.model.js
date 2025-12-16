const mongoose = require('mongoose');

const LessonSchema = new mongoose.Schema({
  lessonId: { type: String, required: true },
  title: { type: String, required: true },
  content: { type: String },
  examples: [String],
  completed: { type: Boolean, default: false }
});

const TopicSchema = new mongoose.Schema({
  topicId: { type: String, required: true, unique: true },
  title: { type: String, required: true },
  icon: { type: String }, // emoji hoặc icon name
  totalLessons: { type: Number, required: true },
  lessons: [LessonSchema],
  isLocked: { type: Boolean, default: true },
  order: { type: Number, required: true }
}, {
  timestamps: true
});

// Thêm virtual field để tính progress
TopicSchema.virtual('progress').get(function() {
  if (this.lessons.length === 0) return 0;
  const completed = this.lessons.filter(l => l.completed).length;
  return Math.round((completed / this.lessons.length) * 100);
});

TopicSchema.set('toJSON', { virtuals: true });

module.exports = mongoose.model('Topic', TopicSchema);