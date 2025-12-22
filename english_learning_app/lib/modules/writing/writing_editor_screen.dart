import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../services/writing_service.dart';

class WritingEditorScreen extends StatefulWidget {
  final Map<String, dynamic>? existingWriting;
  final String? initialType;

  const WritingEditorScreen({
    super.key,
    this.existingWriting,
    this.initialType,
  });

  @override
  State<WritingEditorScreen> createState() => _WritingEditorScreenState();
}

class _WritingEditorScreenState extends State<WritingEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final WritingService _service = WritingService();

  bool _isSaving = false;
  String _currentType = "Free Write";
  int _wordCount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.existingWriting != null) {
      _titleController.text = widget.existingWriting!['title'] ?? '';
      _contentController.text = widget.existingWriting!['content'] ?? '';
      _currentType = widget.existingWriting!['type'] ?? "Free Write";
      _updateWordCount(_contentController.text);
    } else if (widget.initialType != null) {
      _currentType = widget.initialType!;
    }
  }

  void _updateWordCount(String text) {
    setState(() {
      _wordCount = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
    });
  }

  Future<void> _save() async {
    if (_isSaving) return;

    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title cannot be empty")),
      );
      return;
    }

    setState(() => _isSaving = true);

    // Gọi hàm saveWriting (đã khớp với service)
    final success = await _service.saveWriting(
      id: widget.existingWriting?['_id'],
      title: _titleController.text,
      content: _contentController.text,
      type: _currentType,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Saved successfully"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Save failed. Check server connection."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Writing Editor", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            Text(_currentType, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
          IconButton(
            onPressed: _isSaving ? null : _save,
            icon: _isSaving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.check, color: AppColors.primary),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: "Title",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            const Divider(),
             // Toolbar đếm từ
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.notes, size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text("$_wordCount words", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: TextField(
                controller: _contentController,
                onChanged: _updateWordCount,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: "Start writing here...",
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