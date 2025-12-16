const router = require('express').Router();
const User = require('../models/User');
const verifyToken = require('../middleware/auth'); // Import middleware vừa tạo

// 1. LẤY THÔNG TIN PROFILE
// GET /api/user/profile
router.get('/profile', verifyToken, async (req, res) => {
  try {
    const uid = req.user.uid; // Lấy UID từ token đã xác thực
    
    const user = await User.findOne({ firebaseUid: uid });
    
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    
    res.json(user);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// 2. CẬP NHẬT PROFILE
// PUT /api/user/profile
router.put('/profile', verifyToken, async (req, res) => {
  try {
    const uid = req.user.uid;
    const { username, avatar } = req.body; // Dữ liệu gửi lên

    const updatedUser = await User.findOneAndUpdate(
      { firebaseUid: uid },
      { 
        $set: { 
          username: username,
          avatar: avatar 
        } 
      },
      { new: true } // Trả về dữ liệu mới sau khi update
    );

    res.json(updatedUser);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;