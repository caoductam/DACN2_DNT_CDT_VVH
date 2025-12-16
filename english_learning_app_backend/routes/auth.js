const router = require('express').Router();
const admin = require('../config/firebase');
const User = require('../models/User');

// POST /api/auth/sync
router.post('/sync', async (req, res) => {
  const { idToken } = req.body;

  if (!idToken) return res.status(400).json({ error: "No token provided" });

  try {
    // 1. Xác thực token với Firebase
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const { uid, email, name, picture, firebase } = decodedToken;
    const provider = firebase.sign_in_provider || 'password';

    // 2. Tìm hoặc Tạo User trong MongoDB
    let user = await User.findOne({ firebaseUid: uid });

    if (user) {
      // Đã có -> Trả về thông tin
      return res.json(user);
    } else {
      // Chưa có -> Tạo mới
      const newUser = new User({
        firebaseUid: uid,
        email: email,
        fullName: name || email.split('@')[0],
        photoUrl: picture || "",
        authProvider: provider
      });
      await newUser.save();
      return res.status(201).json(newUser);
    }
  } catch (error) {
    console.error("Auth Error:", error);
    res.status(401).json({ error: "Invalid Token" });
  }
});

module.exports = router;