import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

class WritingScreen extends StatelessWidget {
  const WritingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. DAILY PROMPT CARD (Thẻ chủ đề hôm nay)
            _buildDailyPromptCard(),

            const SizedBox(height: 30),

            // 2. WRITING MODES (Các dạng bài viết)
            const Text(
              "What do you want to write?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildWritingModes(),

            const SizedBox(height: 30),

            // 3. POPULAR TOPICS TITLE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Popular Topics",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "View All",
                    style: TextStyle(color: AppColors.writingColor),
                  ),
                )
              ],
            ),

            const SizedBox(height: 10),

            // 4. TOPICS LIST
            _buildTopicsList(),
          ],
        ),
      ),
      // Nút tạo bài viết mới
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.writingColor,
        icon: const Icon(Icons.edit_rounded, color: Colors.white),
        label: const Text("New Draft", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // --- WIDGETS CON ---

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "Writing Practice",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.folder_open_rounded, color: Colors.black),
          onPressed: () {}, // Mở danh sách bài đã lưu
        ),
      ],
    );
  }

  Widget _buildDailyPromptCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFC107), Color(0xFFFFD54F)], // Vàng Gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFC107).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Daily Prompt",
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              const Icon(Icons.lightbulb_rounded, color: Colors.white, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "If you could have\none superpower...",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Describe what it would be and how you would use it.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.writingColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text("Start Writing", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
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
        return Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: (mode['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(mode['icon'] as IconData, color: mode['color'] as Color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              mode['name'] as String,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            )
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTopicsList() {
    final topics = [
      {
        "title": "My Dream Job",
        "category": "Career",
        "words": "150 words",
        "level": "Easy",
        "icon": Icons.work_rounded,
        "color": Colors.blueAccent
      },
      {
        "title": "Technology in Future",
        "category": "Opinion",
        "words": "250 words",
        "level": "Hard",
        "icon": Icons.rocket_launch_rounded,
        "color": Colors.deepPurpleAccent
      },
      {
        "title": "A Memorable Trip",
        "category": "Personal",
        "words": "200 words",
        "level": "Medium",
        "icon": Icons.flight_takeoff_rounded,
        "color": Colors.green
      },
      {
        "title": "Complaint Letter",
        "category": "Business",
        "words": "180 words",
        "level": "Hard",
        "icon": Icons.mail_outline_rounded,
        "color": Colors.redAccent
      },
    ];

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: topics.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildTopicItem(topics[index]);
      },
    );
  }

  Widget _buildTopicItem(Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          // Icon Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (item['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item['icon'], color: item['color'], size: 24),
          ),
          const SizedBox(width: 16),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.writingBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item['category'],
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.writingColor.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      item['level'],
                      style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Goal: ${item['words']}",
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          
          const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
