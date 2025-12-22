import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../services/writing_service.dart';
// Sử dụng hide để tránh xung đột tên nếu file editor cũng export service
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

  // Tải dữ liệu từ Server
  void _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    // Gọi hàm getSubmissions (đã sửa trong service)
    final data = await _service.getSubmissions();
    
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
    // Nếu có lưu bài mới thì reload list và chuyển tab
    if (result == true) {
      _loadData();
      _tabController.animateTo(1); 
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
      // Gọi hàm deleteSubmission (đã sửa trong service)
      await _service.deleteSubmission(id);
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
        automaticallyImplyLeading: false, 
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
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: _loadData, 
              icon: const Icon(Icons.refresh), 
              label: const Text("Refresh List")
            )
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _loadData(),
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _myWritings.length,
        separatorBuilder: (_,__) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = _myWritings[index];
          String dateDisplay = "Unknown date";
          try {
            if (item['createdAt'] != null) {
              final dt = DateTime.parse(item['createdAt']).toLocal();
              dateDisplay = "${dt.day}/${dt.month}/${dt.year}";
            }
          } catch (_) {}

          final id = item['_id']; 

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
                        Text(item['title'] ?? "Untitled", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text("${item['type'] ?? 'Free Write'} • $dateDisplay", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () => _deleteItem(id),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- CÁC WIDGET CON (UI) ---
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
            Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(20)), child: const Text("Daily Prompt", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))), const Spacer(), const Icon(Icons.lightbulb, color: Colors.white, size: 20)]),
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
      {"icon": Icons.email, "name": "Email", "color": Colors.blue},
      {"icon": Icons.article, "name": "Essay", "color": Colors.orange},
      {"icon": Icons.book, "name": "Story", "color": Colors.purple},
      {"icon": Icons.history_edu, "name": "Journal", "color": Colors.teal},
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
    final topics = [
      {"title": "My Dream Job", "category": "Career", "words": "150 words", "level": "Easy", "icon": Icons.work_rounded, "color": Colors.blueAccent},
      {"title": "Technology in Future", "category": "Opinion", "words": "250 words", "level": "Hard", "icon": Icons.rocket_launch_rounded, "color": Colors.deepPurpleAccent},
    ];

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: topics.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _openEditor(type: topics[index]['title'] as String),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade100), boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 10, offset: const Offset(0, 4))]),
            child: Row(
              children: [
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: (topics[index]['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(14)), child: Icon(topics[index]['icon'] as IconData, color: topics[index]['color'] as Color, size: 24)),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: AppColors.writingBg, borderRadius: BorderRadius.circular(6)), child: Text(topics[index]['category'] as String, style: TextStyle(fontSize: 10, color: AppColors.writingColor.withOpacity(0.8), fontWeight: FontWeight.bold))), const Spacer(), Text(topics[index]['level'] as String, style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w600))]),
                  const SizedBox(height: 8),
                  Text(topics[index]['title'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text("Goal: ${topics[index]['words']}", style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                ])),
                const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }
}