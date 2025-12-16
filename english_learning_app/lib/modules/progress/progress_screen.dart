import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/theme_manager.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // 1. HEADER
            const Center(
              child: Text(
                "Statistics",
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold, 
                  color: AppColors.textPrimary
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 2. TOGGLE (Weekly / Monthly)
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTabOption("Weekly", true),
                    _buildTabOption("Monthly", false),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 3. BAR CHART (Biểu đồ cột tự tạo)
            _buildWeeklyChart(),

            const SizedBox(height: 30),

            // 4. OVERVIEW STATISTICS (Grid 2x2)
            const Text(
              "Overview",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            _buildOverviewGrid(),

            const SizedBox(height: 30),

            // 5. SKILL PROGRESS LIST
            const Text(
              "Course Progress",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            _buildSkillProgressList(),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS CON ---

  Widget _buildTabOption(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildWeeklyChart() {
    // Dữ liệu giả lập cho 7 ngày
    final data = [0.4, 0.6, 0.3, 0.8, 0.5, 0.9, 0.4];
    final days = ["M", "T", "W", "T", "F", "S", "S"];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Activity", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text("2.5 hrs this week", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              final height = 150.0 * data[index]; // Chiều cao tối đa 150
              final isToday = index == 5; // Giả sử hôm nay là Thứ 7 (S)
              
              return Column(
                children: [
                  // Cột biểu đồ
                  Container(
                    width: 16,
                    height: 150,
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      width: 16,
                      height: height,
                      decoration: BoxDecoration(
                        color: isToday ? AppColors.primary : const Color(0xFFB3E5FC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Nhãn ngày
                  Text(
                    days[index],
                    style: TextStyle(
                      color: isToday ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(Icons.check_circle_outline_rounded, "Completed", "24 Lessons", Colors.green, const Color(0xFFE8F5E9)),
        _buildStatCard(Icons.access_time_rounded, "Hours Spent", "18.5 Hrs", Colors.orange, const Color(0xFFFFF3E0)),
        _buildStatCard(Icons.local_fire_department_rounded, "Streak", "12 Days", Colors.redAccent, const Color(0xFFFFEBEE)),
        _buildStatCard(Icons.emoji_events_rounded, "Points", "450 XP", Colors.purple, const Color(0xFFF3E5F5)),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(color: color.withOpacity(0.8), fontSize: 13, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillProgressList() {
    return Column(
      children: [
        _buildSkillItem("Vocabulary", 0.8, AppColors.vocabColor),
        const SizedBox(height: 16),
        _buildSkillItem("Grammar", 0.5, AppColors.grammarColor),
        const SizedBox(height: 16),
        _buildSkillItem("Speaking", 0.3, AppColors.speakingColor),
        const SizedBox(height: 16),
        _buildSkillItem("Listening", 0.6, AppColors.listeningColor),
      ],
    );
  }

  Widget _buildSkillItem(String skill, double progress, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            skill,
            style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.1),
              color: color,
              minHeight: 10,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          "${(progress * 100).toInt()}%",
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
