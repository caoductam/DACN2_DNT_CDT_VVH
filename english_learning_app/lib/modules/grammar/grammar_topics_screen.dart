import 'package:flutter/material.dart';
import 'topic.dart';
import 'grammar_api_service.dart';
import '../../widgets/progress_section.dart';
import '../../widgets/topics_list.dart';
import '../../theme.dart';
import 'topic_detail_screen.dart';

class GrammarTopicsScreen extends StatefulWidget {
  const GrammarTopicsScreen({super.key});

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
      // final progress = await GrammarApiService.getUserProgress(_userId);

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
      backgroundColor: AppColors.background,
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
              color: AppColors.background,
              borderRadius: isSmallScreen
                  ? BorderRadius.zero
                  : BorderRadius.circular(20),
              border: isSmallScreen
                  ? null
                  : Border.all(color: AppColors.border, width: 2),
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
                                ProgressSection(
                                  completedCount: _completedCount,
                                  totalLessons: _totalLessons,
                                ),
                                const SizedBox(height: 8),
                                TopicsList(
                                  topics: _topics,
                                  onTopicTap: _navigateToTopicDetail,
                                ),
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
              onTap: () => Navigator.of(context).maybePop(),
              child: const SizedBox(
                width: 18,
                height: 28,
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              child: const Text('Grammar Topics', style: AppTextStyles.header),
            ),
          ),
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
    ).then((_) => _loadTopics());
  }
}
