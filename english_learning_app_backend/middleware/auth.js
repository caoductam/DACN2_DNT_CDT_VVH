const admin = require('../config/firebase');

const verifyToken = async (req, res, next) => {
  console.log('🔐 [AUTH] verifyToken HIT');

  const authHeader = req.headers.authorization;
  console.log('🔐 [AUTH] Authorization header:', authHeader ? 'FOUND' : 'NOT FOUND');

  const token = authHeader?.split(' ')[1];

  if (!token) {
    console.log('❌ [AUTH] NO TOKEN');
    return res.status(401).json({ message: "Không tìm thấy Token" });
  }

  try {
    console.log('⏳ [AUTH] Verifying token with Firebase...');
    
    const decodedToken = await admin.auth().verifyIdToken(token);

    console.log('✅ [AUTH] Token verified, uid =', decodedToken.uid);

    req.user = decodedToken;
    next();
  } catch (error) {
    console.error('❌ [AUTH] VERIFY FAILED:', error.message);
    return res.status(403).json({ message: "Token không hợp lệ hoặc đã hết hạn" });
  }
};

module.exports = verifyToken;
