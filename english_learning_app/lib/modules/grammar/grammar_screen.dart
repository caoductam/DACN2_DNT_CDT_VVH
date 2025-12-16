import 'package:flutter/material.dart';
import 'grammar_api_service.dart';
import 'topic.dart';

// =================== GrammarTopicsScreen ===================
class GrammarTopicsScreen extends StatefulWidget {
  const GrammarTopicsScreen({Key? key}) : super(key: key);

  @override
  State<GrammarTopicsScreen> createState() => _GrammarTopicsScreenState();
}

class _GrammarTopicsScreenState extends State<GrammarTopicsScreen> {
  List<Topic> _topics = [];
  bool _isLoading = true;
  String _userId = 'user123'; // TODO: Lấy từ authentication
  int _completedCount = 0;
  int _totalLessons = 0;

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    setState(() => _isLoading = true);

    try {
      final topics = await GrammarApiService.getTopics();
      final progress = await GrammarApiService.getUserProgress(_userId);

      // Tính toán progress
      int completed = 0;
      int total = 0;

      for (var topic in topics) {
        total += topic.totalLessons;
        completed += topic.lessons.where((l) => l.completed).length;
      }

      setState(() {
        _topics = topics;
        _completedCount = completed;
        _totalLessons = total;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading topics: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth <= 640;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxWidth: isSmallScreen ? double.infinity : 412,
            ),
            margin: isSmallScreen
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: isSmallScreen
                  ? BorderRadius.zero
                  : BorderRadius.circular(20),
              border: isSmallScreen
                  ? null
                  : Border.all(color: const Color(0xFFCED4DA), width: 2),
            ),
            child: Column(
              children: [
                _buildHeader(context, isSmallScreen),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : RefreshIndicator(
                          onRefresh: _loadTopics,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                const SizedBox(height: 8),
                                _buildProgressSection(),
                                const SizedBox(height: 8),
                                _buildTopicsList(),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isSmallScreen) {
    return Container(
      width: double.infinity,
      height: 61,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const SizedBox(
                width: 18,
                height: 28,
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              child: const Text(
                'Grammar Topics',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.56,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    final progressPercentage = _totalLessons > 0
        ? (_completedCount / _totalLessons * 100)
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Progress',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$_completedCount',
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '/$_totalLessons Topics',
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              CircleAvatar(
                radius: 32,
                backgroundColor: const Color(0xFFE0F2FE),
                child: Text(
                  '${progressPercentage.round()}%',
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: LinearProgressIndicator(
              value: progressPercentage / 100,
              minHeight: 8,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF2563EB)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicsList() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ALL TOPICS',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 16),
          ..._topics.map(
            (topic) => TopicCard(
              topic: topic,
              onTap: () => _navigateToTopicDetail(topic),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _navigateToTopicDetail(Topic topic) {
    if (topic.isLocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete previous topics to unlock this one'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TopicDetailScreen(topic: topic, userId: _userId),
      ),
    ).then((_) => _loadTopics()); // Reload after returning
  }
}

// =================== TopicCard ===================
class TopicCard extends StatelessWidget {
  final Topic topic;
  final VoidCallback? onTap;

  const TopicCard({Key? key, required this.topic, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width > 640
        ? 335.0
        : MediaQuery.of(context).size.width - 40;

    // Tính progress từ lessons
    final completedLessons = topic.lessons.where((l) => l.completed).length;
    final progress = topic.totalLessons > 0
        ? (completedLessons / topic.totalLessons * 100)
        : 0.0;

    // Xác định status
    final TopicStatus status;
    if (topic.isLocked) {
      status = TopicStatus.locked;
    } else if (progress == 100) {
      status = TopicStatus.completed;
    } else {
      status = TopicStatus.inProgress;
    }

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.05),
        child: InkWell(
          onTap: status != TopicStatus.locked ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Row(
              children: [
                _buildIcon(status),
                const SizedBox(width: 12),
                Expanded(child: _buildInfo(progress, status)),
                const SizedBox(width: 12),
                _buildStatusIcon(status),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(TopicStatus status) {
    final IconData iconData = _getTopicIcon();
    final isLocked = status == TopicStatus.locked;

    return CircleAvatar(
      backgroundColor: const Color(0xFFEBF8FF),
      radius: 20,
      child: Icon(
        iconData,
        size: 18,
        color: isLocked ? const Color(0xFF9CA3AF) : const Color(0xFF2563EB),
      ),
    );
  }

  IconData _getTopicIcon() {
    switch (topic.title.toLowerCase()) {
      case 'present tenses':
        return Icons.access_time;
      case 'past tenses':
        return Icons.history;
      case 'future tenses':
        return Icons.fast_forward;
      case 'passive voice':
        return Icons.swap_horiz;
      case 'conditionals':
        return Icons.account_tree;
      case 'reported speech':
        return Icons.format_quote;
      case 'modal verbs':
        return Icons.help_outline;
      case 'relative clauses':
        return Icons.link;
      default:
        return Icons.book;
    }
  }

  Widget _buildInfo(double progress, TopicStatus status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          topic.title,
          style: const TextStyle(
            color: Color(0xFF111827),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '${topic.totalLessons} lessons',
          style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9999),
                child: LinearProgressIndicator(
                  value: progress / 100,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFE5E7EB),
                  valueColor: AlwaysStoppedAnimation(
                    status == TopicStatus.locked
                        ? const Color(0xFFE5E7EB)
                        : const Color(0xFF2563EB),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${progress.round()}%',
              style: TextStyle(
                color: status == TopicStatus.locked
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF2563EB),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusIcon(TopicStatus status) {
    switch (status) {
      case TopicStatus.completed:
        return Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Color(0xFF22C55E),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 12, color: Colors.white),
        );
      case TopicStatus.inProgress:
        return const Icon(
          Icons.chevron_right,
          size: 18,
          color: Color(0xFF9CA3AF),
        );
      case TopicStatus.locked:
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFD1D5DB), width: 2),
          ),
          child: const Icon(Icons.lock, size: 12, color: Color(0xFFD1D5DB)),
        );
    }
  }
}

// =================== TopicDetailScreen ===================
class TopicDetailScreen extends StatefulWidget {
  final Topic topic;
  final String userId;

  const TopicDetailScreen({Key? key, required this.topic, required this.userId})
    : super(key: key);

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

      // Reload topic detail
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2563EB)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _topic.title,
          style: const TextStyle(
            color: Color(0xFF111827),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
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
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFE0F2FE),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: lesson.completed
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Color(0xFF2563EB),
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
                          color: Color(0xFF111827),
                        ),
                      ),
                      if (lesson.content.isNotEmpty)
                        Text(
                          lesson.content,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
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

// =================== LessonDetailScreen (Placeholder) ===================
class LessonDetailScreen extends StatelessWidget {
  final Lesson lesson;
  final Function(int score) onComplete;

  const LessonDetailScreen({
    Key? key,
    required this.lesson,
    required this.onComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Content',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(lesson.content),
            const SizedBox(height: 24),
            if (lesson.examples.isNotEmpty) ...[
              const Text(
                'Examples',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...lesson.examples.map(
                (ex) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('• $ex'),
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  onComplete(100);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Complete Lesson',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =================== Enums & Models (nếu chưa có) ===================
enum TopicStatus { completed, inProgress, locked }
