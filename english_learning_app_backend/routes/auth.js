const admin = require('../config/firebase');

const verifyToken = async (req, res, next) => {
  console.log("🔐 VERIFY TOKEN");

  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      console.log("❌ NO AUTH HEADER");
      return res.status(401).json({ message: "Không tìm thấy Token" });
    }

    const token = authHeader.split(' ')[1];

    // ⏱️ CHỐNG TREO FIREBASE
    const decodedToken = await Promise.race([
      admin.auth().verifyIdToken(token),
      new Promise((_, reject) =>
        setTimeout(() => reject(new Error("Firebase verify timeout")), 5000)
      ),
    ]);

    req.user = decodedToken;
    console.log("✅ TOKEN OK:", decodedToken.uid);
    next();
  } catch (error) {
    console.error("❌ TOKEN ERROR:", error.message);
    return res.status(401).json({
      message: "Token không hợp lệ hoặc đã hết hạn",
    });
  }
};

module.exports = verifyToken;
