import 'package:flutter/material.dart';
import '../modules/grammar/topic.dart';
import '../widgets/topic_card.dart';
import '../constants.dart';
import '../theme.dart';

class TopicsList extends StatelessWidget {
  final List<Topic> topics;
  final Function(Topic) onTopicTap;

  const TopicsList({super.key, required this.topics, required this.onTopicTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppPaddings.screen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ALL TOPICS',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 16),
          ...topics.map(
            (topic) => TopicCard(topic: topic, onTap: () => onTopicTap(topic)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
