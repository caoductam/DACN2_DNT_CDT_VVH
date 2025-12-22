const mongoose = require('mongoose');
require('dotenv').config();

console.log("⏳ Testing MongoDB connection...");
console.log("🔎 MONGODB_URI =", process.env.MONGODB_URI);

(async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI, {
      serverSelectionTimeoutMS: 5000,
    });

    console.log("✅ MongoDB CONNECTED SUCCESSFULLY");
    process.exit(0);
  } catch (err) {
    console.error("❌ MongoDB FAILED:");
    console.error(err.message);
    process.exit(1);
  }
})();
