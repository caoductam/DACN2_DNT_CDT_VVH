const router = require('express').Router();
const Writing = require('../models/Writing');
const verifyToken = require('../middleware/auth');

// =========================
// 1. SAVE / UPDATE WRITING
// =========================
router.post('/save', verifyToken, async (req, res) => {
  console.log("🔥 /api/writing/save HIT");

  try {
    if (!req.user || !req.user.uid) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const { id, title, content, type, status } = req.body;
    const uid = req.user.uid;

    const wordCount = content?.trim()
      ? content.trim().split(/\s+/).length
      : 0;

    let writing;

    if (id) {
      // 🔁 UPDATE
      writing = await Writing.findOneAndUpdate(
        { _id: id, firebaseUid: uid },
        {
          title,
          content,
          wordCount,
          type,
          status,
          updatedAt: new Date(),
        },
        { new: true }
      );

      if (!writing) {
        return res.status(404).json({ message: "Writing not found" });
      }
    } else {
      // 🆕 CREATE
      writing = await Writing.create({
        firebaseUid: uid,
        title: title || "Untitled Draft",
        content,
        type: type || "Free Write",
        wordCount,
        status: status || "draft",
      });
    }

    console.log("✅ SAVE SUCCESS:", writing._id);

    return res.status(200).json({
      success: true,
      message: "Saved successfully",
      data: writing,
    });

  } catch (error) {
    console.error("❌ SAVE ERROR:", error);
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// =========================
// 2. GET MY WRITINGS
// =========================
router.get('/my-work', verifyToken, async (req, res) => {
  console.log("🔥 /api/writing/my-work HIT");

  try {
    const list = await Writing
      .find({ firebaseUid: req.user.uid })
      .sort({ updatedAt: -1 });

    return res.status(200).json(list);
  } catch (error) {
    console.error("❌ GET LIST ERROR:", error);
    return res.status(500).json({ message: error.message });
  }
});

// =========================
// 3. DELETE WRITING
// =========================
router.delete('/:id', verifyToken, async (req, res) => {
  console.log("🔥 DELETE:", req.params.id);

  try {
    const deleted = await Writing.findOneAndDelete({
      _id: req.params.id,
      firebaseUid: req.user.uid,
    });

    if (!deleted) {
      return res.status(404).json({
        message: "Not found or no permission",
      });
    }

    return res.status(200).json({ message: "Deleted successfully" });
  } catch (error) {
    console.error("❌ DELETE ERROR:", error);
    return res.status(500).json({ message: error.message });
  }
});

module.exports = router;
