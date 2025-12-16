const admin = require('../config/firebase');

const verifyToken = async (req, res, next) => {
  // Lấy token từ header: "Authorization: Bearer <token>"
  const token = req.headers.authorization?.split(' ')[1];

  if (!token) {
    return res.status(401).json({ message: "Không tìm thấy Token" });
  }

  try {
    // Xác thực token với Firebase
    const decodedToken = await admin.auth().verifyIdToken(token);
    req.user = decodedToken; // Lưu thông tin user vào request
    next(); // Cho phép đi tiếp
  } catch (error) {
    return res.status(403).json({ message: "Token không hợp lệ hoặc đã hết hạn" });
  }
};

module.exports = verifyToken;