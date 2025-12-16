const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  firebaseUid: { type: String, required: true, unique: true }, // Khóa chính liên kết Firebase
  email: { type: String, required: true },
  fullName: { type: String, default: "User" },
  photoUrl: { type: String, default: "" },
  authProvider: { type: String, default: "email" }, // google, facebook, password
  createdAt: { type: Date, default: Date.now },
  
  // Các trường mở rộng cho App học tiếng Anh
  level: { type: String, default: "Beginner" },
  coins: { type: Number, default: 0 },
});

module.exports = mongoose.model('User', UserSchema);