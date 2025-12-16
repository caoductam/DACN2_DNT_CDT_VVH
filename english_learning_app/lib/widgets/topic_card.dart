import 'package:flutter/material.dart';
import '../modules/grammar/topic.dart';
import '../theme.dart';

class TopicCard extends StatelessWidget {
  final Topic topic;
  final VoidCallback? onTap;

  const TopicCard({super.key, required this.topic, this.onTap});

  @override
  Widget build(BuildContext context) {
    final completedLessons = topic.lessons.where((l) => l.completed).length;
    final progress = topic.totalLessons > 0
        ? (completedLessons / topic.totalLessons * 100)
        : 0.0;

    final TopicStatus status;
    if (topic.isLocked) {
      status = TopicStatus.locked;
    } else if (progress == 100) {
      status = TopicStatus.completed;
    } else {
      status = TopicStatus.inProgress;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        elevation: 2,
        shadowColor: AppColors.cardShadow,
        child: InkWell(
          onTap: status != TopicStatus.locked ? onTap : null,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Row(
              children: [
                // Icon trong vòng tròn nền nhạt
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    _getTopicIcon(),
                    size: 24,
                    color: status == TopicStatus.locked
                        ? AppColors.locked
                        : AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                // Thông tin topic
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        topic.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${topic.totalLessons} lessons',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Progress bar
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: progress / 100,
                                minHeight: 6,
                                backgroundColor: AppColors.progressBg,
                                valueColor: AlwaysStoppedAnimation(
                                  status == TopicStatus.locked
                                      ? AppColors.progressBg
                                      : AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${progress.round()}%',
                            style: TextStyle(
                              color: status == TopicStatus.locked
                                  ? AppColors.locked
                                  : AppColors.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Status icon
                _buildStatusIcon(status),
              ],
            ),
          ),
        ),
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

  Widget _buildStatusIcon(TopicStatus status) {
    switch (status) {
      case TopicStatus.completed:
        return Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: AppColors.completed,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 14, color: Colors.white),
        );
      case TopicStatus.inProgress:
        return const Icon(
          Icons.chevron_right,
          size: 22,
          color: AppColors.locked,
        );
      case TopicStatus.locked:
        return Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.locked, width: 2),
          ),
          child: const Icon(Icons.lock, size: 14, color: AppColors.locked),
        );
    }
  }
}
