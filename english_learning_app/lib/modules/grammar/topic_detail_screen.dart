import 'package:flutter/material.dart';
import 'topic.dart';
import 'grammar_api_service.dart';
import 'lesson_detail_screen.dart';
import '../../theme.dart';

class TopicDetailScreen extends StatefulWidget {
  final Topic topic;
  final String userId;

  const TopicDetailScreen({
    super.key,
    required this.topic,
    required this.userId,
  });

  @override
  State<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  late Topic _topic;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _topic = widget.topic;
  }

  Future<void> _completeLesson(Lesson lesson, int score) async {
    setState(() => _isLoading = true);

    try {
      await GrammarApiService.completeLesson(
        userId: widget.userId,
        topicId: _topic.topicId,
        lessonId: lesson.lessonId,
        score: score,
      );

      final updatedTopic = await GrammarApiService.getTopicDetail(
        _topic.topicId,
      );

      setState(() {
        _topic = updatedTopic;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lesson completed! 🎉'),
            backgroundColor: Color(0xFF22C55E),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(_topic.title, style: AppTextStyles.header),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _topic.lessons.length,
              itemBuilder: (context, index) {
                final lesson = _topic.lessons[index];
                return _buildLessonCard(lesson, index);
              },
            ),
    );
  }

  Widget _buildLessonCard(Lesson lesson, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 1,
        child: InkWell(
          onTap: () => _showLessonDetail(lesson),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: lesson.completed
                        ? AppColors.completed
                        : const Color(0xFFE0F2FE),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: lesson.completed
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (lesson.content.isNotEmpty)
                        Text(
                          lesson.content,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.locked),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLessonDetail(Lesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonDetailScreen(
          lesson: lesson,
          onComplete: (score) => _completeLesson(lesson, score),
        ),
      ),
    );
  }
}
