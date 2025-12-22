const admin = require('../firebaseAdmin');

module.exports = async (req, res, next) => {
  console.log("🔐 VERIFY TOKEN");

  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    console.log("❌ NO AUTH HEADER");
    return res.status(401).json({ message: "No token provided" });
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = await admin.auth().verifyIdToken(token);
    console.log("✅ TOKEN OK:", decoded.uid);

    req.user = decoded;   // ✅ BẮT BUỘC
    next();               // ✅ BẮT BUỘC
  } catch (err) {
    console.log("❌ TOKEN INVALID:", err.message);
    return res.status(401).json({ message: "Invalid token" });
  }
};
