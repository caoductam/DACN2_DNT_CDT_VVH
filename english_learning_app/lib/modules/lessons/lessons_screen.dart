import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/theme_manager.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. COURSE OVERVIEW CARD
            _buildCourseHeader(),

            const SizedBox(height: 30),

            // 2. SEARCH BAR
            _buildSearchBar(),

            const SizedBox(height: 24),

            // 3. UNITS LIST
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Curriculum",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  "12 Units",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildUnitsList(),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS CON ---

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false, // Tắt nút back vì đây là màn hình chính trong Tab
      title: const Text(
        "My Course",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_horiz_rounded, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildCourseHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4B7BE5), Color(0xFF6495ED)], // Xanh dương Gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4B7BE5).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Intermediate B1",
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 24),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "General English",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Unit 4 - Travel & Adventure",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.35, // 35%
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "35%",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search lessons...",
          hintStyle: const TextStyle(color: AppColors.inputHint),
          prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildUnitsList() {
    // Dữ liệu mẫu các bài học
    final units = [
      {
        "number": "01",
        "title": "Introduction",
        "desc": "Greetings & Personal Info",
        "progress": 1.0,
        "status": "completed",
        "color": Colors.green,
      },
      {
        "number": "02",
        "title": "Daily Routine",
        "desc": "Present Simple Tense",
        "progress": 1.0,
        "status": "completed",
        "color": Colors.green,
      },
      {
        "number": "03",
        "title": "Family & Friends",
        "desc": "Describing People",
        "progress": 1.0,
        "status": "completed",
        "color": Colors.green,
      },
      {
        "number": "04",
        "title": "Travel & Adventure",
        "desc": "Past Experiences",
        "progress": 0.4,
        "status": "current", // Đang học
        "color": AppColors.primary,
      },
      {
        "number": "05",
        "title": "Food & Culture",
        "desc": "Ordering & Preferences",
        "progress": 0.0,
        "status": "locked",
        "color": Colors.grey,
      },
      {
        "number": "06",
        "title": "Work & Career",
        "desc": "Job Interviews",
        "progress": 0.0,
        "status": "locked",
        "color": Colors.grey,
      },
    ];

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: units.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildUnitCard(units[index]);
      },
    );
  }

  Widget _buildUnitCard(Map<String, dynamic> unit) {
    bool isLocked = unit['status'] == 'locked';
    bool isCompleted = unit['status'] == 'completed';
    bool isCurrent = unit['status'] == 'current';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCurrent ? AppColors.primary.withOpacity(0.5) : Colors.grey.shade100,
          width: isCurrent ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isCurrent ? AppColors.primary.withOpacity(0.1) : Colors.grey.shade100,
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          // Number Box
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isLocked ? Colors.grey[100] : (isCompleted ? const Color(0xFFE8F5E9) : const Color(0xFFE3F2FD)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              unit['number'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isLocked ? Colors.grey : (isCompleted ? Colors.green : AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unit['title'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isLocked ? Colors.grey : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  unit['desc'],
                  style: TextStyle(
                    fontSize: 13,
                    color: isLocked ? Colors.grey[400] : AppColors.textSecondary,
                  ),
                ),
                if (isCurrent) ...[
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: unit['progress'],
                      backgroundColor: Colors.grey[200],
                      color: AppColors.primary,
                      minHeight: 4,
                    ),
                  ),
                ]
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Status Icon
          if (isCompleted)
            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 24)
          else if (isLocked)
            Icon(Icons.lock_rounded, color: Colors.grey[300], size: 22)
          else
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 6, offset: const Offset(0, 2))
                ]
              ),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
            )
        ],
      ),
    );
  }
}
