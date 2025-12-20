import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../services/writing_service.dart';
import 'writing_editor_screen.dart';

class WritingScreen extends StatefulWidget {
  const WritingScreen({super.key});

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final WritingService _service = WritingService();
  
  List<dynamic> _myWritings = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  void _loadData() async {
    setState(() => _isLoading = true);
    final data = await _service.getMyWritings();
    if (mounted) {
      setState(() {
        _myWritings = data;
        _isLoading = false;
      });
    }
  }

  void _openEditor({Map<String, dynamic>? existingItem, String? type}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WritingEditorScreen(existingWriting: existingItem, initialType: type),
      ),
    );
    if (result == true) {
      _loadData();
      _tabController.animateTo(1); // Chuyển sang tab My Work
    }
  }

  void _deleteItem(String id) async {
    final confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Writing"),
        content: const Text("Are you sure you want to delete this draft?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      await _service.deleteWriting(id);
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Writing Lab", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.writingColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.writingColor,
          tabs: const [
            Tab(text: "Practice"),
            Tab(text: "My Work"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPracticeTab(),
          _buildMyWorkTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        backgroundColor: AppColors.writingColor,
        label: const Text("New Draft", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        icon: const Icon(Icons.create, color: Colors.white),
      ),
    );
  }

  Widget _buildPracticeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDailyPromptCard(),
          const SizedBox(height: 30),
          const Text("Writing Modes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          _buildWritingModes(),
          const SizedBox(height: 30),
          const Text("Popular Topics", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          _buildTopicsList(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildMyWorkTab() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_myWritings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit_note, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text("No writings yet. Start practicing!", style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _myWritings.length,
      separatorBuilder: (_,__) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = _myWritings[index];
        final date = DateTime.parse(item['createdAt']).toLocal().toString().split(' ')[0];
        return InkWell(
          onTap: () => _openEditor(existingItem: item),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 5, offset: const Offset(0, 2))],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.writingBg, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.description, color: AppColors.writingColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Row(children: [
                        Text(item['type'] ?? 'Free Write', style: const TextStyle(color: AppColors.writingColor, fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Text("• $date", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(width: 8),
                        Text("• ${item['wordCount']} words", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ]),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () => _deleteItem(item['_id']),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // ... (Giữ nguyên các widget con _buildDailyPromptCard, _buildWritingModes từ code cũ của bạn)
  // Lưu ý: Sửa onTap trong các widget đó để gọi _openEditor(type: "...")
  
  Widget _buildDailyPromptCard() {
    return GestureDetector(
      onTap: () => _openEditor(type: "Daily Prompt"),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFFFC107), Color(0xFFFFD54F)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: const Color(0xFFFFC107).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(20)), child: const Text("Daily Prompt", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))), const Spacer(), const Icon(Icons.lightbulb_rounded, color: Colors.white, size: 20)]),
            const SizedBox(height: 16),
            const Text("If you could have\none superpower...", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2)),
            const SizedBox(height: 8),
            const Text("Describe what it would be and how you would use it.", style: TextStyle(color: Colors.white, fontSize: 14)),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => _openEditor(type: "Daily Prompt"), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.writingColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 12)), child: const Text("Start Writing", style: TextStyle(fontWeight: FontWeight.bold)))),
          ],
        ),
      ),
    );
  }

  Widget _buildWritingModes() {
    final modes = [
      {"icon": Icons.email_rounded, "name": "Email", "color": Colors.blue},
      {"icon": Icons.article_rounded, "name": "Essay", "color": Colors.orange},
      {"icon": Icons.book_rounded, "name": "Story", "color": Colors.purple},
      {"icon": Icons.edit_note_rounded, "name": "Journal", "color": Colors.teal},
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: modes.map((mode) {
        return GestureDetector(
          onTap: () => _openEditor(type: mode['name'] as String),
          child: Column(children: [Container(width: 60, height: 60, decoration: BoxDecoration(color: (mode['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(16)), child: Icon(mode['icon'] as IconData, color: mode['color'] as Color, size: 28)), const SizedBox(height: 8), Text(mode['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))]),
        );
      }).toList(),
    );
  }

  Widget _buildTopicsList() {
    return Container(); // Placeholder, bạn copy code ListView topics cũ vào nếu cần
  }
}