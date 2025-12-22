const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    if (!process.env.MONGODB_URI) {
      throw new Error('MONGODB_URI is not defined in .env');
    }

    console.log("⏳ Connecting to MongoDB...");

    await mongoose.connect(process.env.MONGODB_URI, {
      serverSelectionTimeoutMS: 5000, // ⛔ không treo vô hạn
    });

    console.log("✅ MongoDB Connected Successfully");
  } catch (err) {
    console.error("❌ MongoDB Connection Failed:");
    console.error(err.message);
    process.exit(1);
  }
};

// 🔥 BẮT BUỘC LOG TRẠNG THÁI
mongoose.connection.on("connected", () => {
  console.log("🟢 MongoDB Ready");
});

mongoose.connection.on("error", (err) => {
  console.error("❌ MongoDB Runtime Error:", err.message);
});

mongoose.connection.on("disconnected", () => {
  console.error("❌ MongoDB Disconnected");
});

module.exports = connectDB;
