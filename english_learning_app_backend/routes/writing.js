const router = require('express').Router();
const Writing = require('../models/Writing');
const verifyToken = require('../middleware/auth'); // Middleware xác thực token

// 1. LƯU BÀI VIẾT (Tạo mới hoặc Cập nhật)
// POST /api/writing/save
router.post('/save', verifyToken, async (req, res) => {
  try {
    const { id, title, content, type, status } = req.body;
    const wordCount = content.trim() === '' ? 0 : content.trim().split(/\s+/).length;
    const uid = req.user.uid; // Lấy UID từ token

    let writing;

    if (id) {
      // Nếu có ID -> Cập nhật bài cũ
      writing = await Writing.findOneAndUpdate(
        { _id: id, firebaseUid: uid },
        { title, content, wordCount, type, status, updatedAt: Date.now() },
        { new: true }
      );
    } else {
      // Không có ID -> Tạo bài mới
      writing = new Writing({
        firebaseUid: uid,
        title: title || "Untitled Draft",
        content,
        type: type || "Free Write",
        wordCount,
        status: status || 'draft'
      });
      await writing.save();
    }

    res.status(201).json(writing);
  } catch (error) {
    console.error("Lỗi lưu bài viết:", error);
    res.status(500).json({ message: error.message });
  }
});

// 2. LẤY DANH SÁCH BÀI VIẾT CỦA TÔI
// GET /api/writing/my-work
router.get('/my-work', verifyToken, async (req, res) => {
  try {
    const list = await Writing.find({ firebaseUid: req.user.uid })
      .sort({ updatedAt: -1 }); // Mới nhất lên đầu
    res.json(list);
  } catch (error) {
    console.error("Lỗi lấy danh sách:", error);
    res.status(500).json({ message: error.message });
  }
});

// 3. XÓA BÀI VIẾT
// DELETE /api/writing/:id
router.delete('/:id', verifyToken, async (req, res) => {
  try {
    const deleted = await Writing.findOneAndDelete({ 
      _id: req.params.id, 
      firebaseUid: req.user.uid 
    });
    
    if (!deleted) {
      return res.status(404).json({ message: "Bài viết không tồn tại hoặc không có quyền xóa" });
    }

    res.json({ message: "Deleted successfully" });
  } catch (error) {
    console.error("Lỗi xóa bài viết:", error);
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;