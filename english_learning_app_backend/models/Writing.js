const mongoose = require('mongoose');

const WritingSchema = new mongoose.Schema({
  firebaseUid: { type: String, required: true }, // ID người dùng
  title: { type: String, required: true },       // Tiêu đề
  content: { type: String, default: "" },        // Nội dung
  type: { type: String, default: "Free Write" }, // Loại: Email, Essay, Story...
  wordCount: { type: Number, default: 0 },       // Số từ
  status: { type: String, default: "draft" },    // draft (nháp), submitted (nộp)
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Writing', WritingSchema);