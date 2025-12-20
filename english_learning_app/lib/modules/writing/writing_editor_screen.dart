import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../services/writing_service.dart';

class WritingEditorScreen extends StatefulWidget {
  final Map<String, dynamic>? existingWriting; // Bài cũ để sửa
  final String? initialType; // Loại bài (Email, Essay...)

  const WritingEditorScreen({super.key, this.existingWriting, this.initialType});

  @override
  State<WritingEditorScreen> createState() => _WritingEditorScreenState();
}

class _WritingEditorScreenState extends State<WritingEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final WritingService _service = WritingService();
  
  bool _isSaving = false;
  int _wordCount = 0;
  String _currentType = "Free Write";

  @override
  void initState() {
    super.initState();
    // Load dữ liệu cũ nếu có
    if (widget.existingWriting != null) {
      _titleController.text = widget.existingWriting!['title'];
      _contentController.text = widget.existingWriting!['content'];
      _currentType = widget.existingWriting!['type'] ?? "Free Write";
      _updateWordCount(_contentController.text);
    } else {
      if (widget.initialType != null) _currentType = widget.initialType!;
    }
  }

  void _updateWordCount(String text) {
    setState(() {
      _wordCount = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
    });
  }

  void _save() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Title cannot be empty")));
      return;
    }

    setState(() => _isSaving = true);
    
    final success = await _service.saveWriting(
      id: widget.existingWriting?['_id'], // Gửi ID nếu đang sửa
      title: _titleController.text,
      content: _contentController.text,
      type: _currentType,
    );

    setState(() => _isSaving = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saved successfully!"), backgroundColor: Colors.green)
      );
      Navigator.pop(context, true); // Trả về true để reload list
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save. Check connection."), backgroundColor: Colors.red)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Writing Editor", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
            Text(_currentType, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton.icon(
              onPressed: _isSaving ? null : _save,
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
              ),
              icon: _isSaving 
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) 
                  : const Icon(Icons.check, size: 20, color: AppColors.primary),
              label: Text("Save", style: TextStyle(fontWeight: FontWeight.bold, color: _isSaving ? Colors.grey : AppColors.primary)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: "Title...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            const Divider(),
            
            // Toolbar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.notes, size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text("$_wordCount words", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.format_bold), onPressed: () {}, color: Colors.grey),
                  IconButton(icon: const Icon(Icons.format_italic), onPressed: () {}, color: Colors.grey),
                ],
              ),
            ),
            const Divider(),
            
            // Editor Area
            Expanded(
              child: TextField(
                controller: _contentController,
                onChanged: _updateWordCount,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(fontSize: 16, height: 1.5),
                decoration: const InputDecoration(
                  hintText: "Start writing your masterpiece here...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}