// import 'package:flutter/material.dart';
// import '../../config/app_colors.dart';

// class GrammarScreen extends StatelessWidget {
//   const GrammarScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: _buildAppBar(context),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 1. PROGRESS CARD
//             _buildProgressCard(),

//             const SizedBox(height: 30),

//             // 2. TITLE
//             const Text(
//               "All Topics",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textPrimary,
//               ),
//             ),
//             const SizedBox(height: 16),

//             // 3. TOPICS LIST
//             _buildTopicsList(),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- WIDGETS CON ---

//   PreferredSizeWidget _buildAppBar(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       centerTitle: true,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
//         onPressed: () => Navigator.pop(context),
//       ),
//       title: const Text(
//         "Grammar Topics",
//         style: TextStyle(
//           color: Colors.black,
//           fontWeight: FontWeight.bold,
//           fontSize: 18,
//         ),
//       ),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.search_rounded, color: Colors.black),
//           onPressed: () {},
//         ),
//       ],
//     );
//   }

//   Widget _buildProgressCard() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xFFE3F2FD), // Xanh dương rất nhạt
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               Text(
//                 "Your Progress",
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.textPrimary,
//                   fontSize: 16,
//                 ),
//               ),
//               Text(
//                 "12/24 completed",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.primary,
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: LinearProgressIndicator(
//               value: 0.5, // 50%
//               backgroundColor: Colors.white,
//               color: AppColors.primary,
//               minHeight: 10,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTopicsList() {
//     // Dữ liệu giả lập khớp với ảnh
//     final topics = [
//       {
//         "title": "Tenses",
//         "sub": "Past, Present & Future",
//         "icon": Icons.access_time_filled_rounded,
//         "color": const Color(0xFF42A5F5), // Blue
//         "bg": const Color(0xFFE3F2FD),
//         "status": "completed"
//       },
//       {
//         "title": "Passive Voice",
//         "sub": "Active to Passive",
//         "icon": Icons.swap_horiz_rounded,
//         "color": const Color(0xFFAB47BC), // Purple
//         "bg": const Color(0xFFF3E5F5),
//         "status": "progress",
//         "progressStr": "3/5"
//       },
//       {
//         "title": "Conditionals",
//         "sub": "If clauses & Types",
//         "icon": Icons.help_outline_rounded,
//         "color": const Color(0xFFFFCA28), // Orange
//         "bg": const Color(0xFFFFF8E1),
//         "status": "locked"
//       },
//       {
//         "title": "Modal Verbs",
//         "sub": "Can, Could, Should",
//         "icon": Icons.chat_bubble_outline_rounded,
//         "color": const Color(0xFF66BB6A), // Green
//         "bg": const Color(0xFFE8F5E9),
//         "status": "completed"
//       },
//       {
//         "title": "Reported Speech",
//         "sub": "Direct & Indirect",
//         "icon": Icons.format_quote_rounded,
//         "color": const Color(0xFFEF5350), // Red
//         "bg": const Color(0xFFFFEBEE),
//         "status": "progress",
//         "progressStr": "1/4"
//       },
//       {
//         "title": "Articles",
//         "sub": "A, An, The",
//         "icon": Icons.text_fields_rounded,
//         "color": const Color(0xFF5C6BC0), // Indigo
//         "bg": const Color(0xFFE8EAF6),
//         "status": "completed"
//       },
//       {
//         "title": "Prepositions",
//         "sub": "In, On, At, By",
//         "icon": Icons.near_me_rounded,
//         "color": const Color(0xFF26A69A), // Teal
//         "bg": const Color(0xFFE0F2F1),
//         "status": "locked"
//       },
//     ];

//     return ListView.separated(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: topics.length,
//       separatorBuilder: (context, index) => const SizedBox(height: 16),
//       itemBuilder: (context, index) {
//         final topic = topics[index];
//         return _buildTopicItem(topic);
//       },
//     );
//   }

//   Widget _buildTopicItem(Map<String, dynamic> topic) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.02),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           )
//         ],
//       ),
//       child: Row(
//         children: [
//           // Icon Box
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               color: topic['bg'],
//               borderRadius: BorderRadius.circular(14),
//             ),
//             child: Icon(topic['icon'], color: topic['color'], size: 26),
//           ),
//           const SizedBox(width: 16),

//           // Text Content
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   topic['title'],
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   topic['sub'],
//                   style: const TextStyle(
//                     fontSize: 13,
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Status Icon (Logic hiển thị trạng thái)
//           if (topic['status'] == 'completed')
//             Container(
//               padding: const EdgeInsets.all(6),
//               decoration: const BoxDecoration(
//                 color: Color(0xFF4CAF50), // Green
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(Icons.check, color: Colors.white, size: 14),
//             )
//           else if (topic['status'] == 'progress')
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: AppColors.primary,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Text(
//                 topic['progressStr'],
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 12,
//                 ),
//               ),
//             )
//           else if (topic['status'] == 'locked')
//             const Icon(Icons.lock_rounded, color: Colors.grey, size: 22),

//           const SizedBox(width: 12),
//           const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

// =================== ProgressSection ===================
class ProgressSection extends StatelessWidget {
  final int completedTopics;
  final int totalTopics;
  final double progressPercentage;

  const ProgressSection({
    Key? key,
    required this.completedTopics,
    required this.totalTopics,
    required this.progressPercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                        '$completedTopics',
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '/$totalTopics Topics',
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
}

// =================== Topic Model ===================
enum TopicStatus { completed, inProgress, locked }

class Topic {
  final String title;
  final String iconSvg;
  final int lessonCount;
  final double progressPercentage;
  final TopicStatus status;

  const Topic({
    required this.title,
    required this.iconSvg,
    required this.lessonCount,
    required this.progressPercentage,
    required this.status,
  });
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

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.05),
        child: InkWell(
          onTap: topic.status != TopicStatus.locked ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Row(
              children: [
                _buildIcon(),
                const SizedBox(width: 12),
                Expanded(child: _buildInfo()),
                const SizedBox(width: 12),
                _buildStatusIcon(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (topic.status == TopicStatus.locked) {
      return CircleAvatar(
        backgroundColor: const Color(0xFFEBF8FF),
        radius: 20,
        child: Icon(
          topic.title == 'Modal Verbs' ? Icons.help_outline : Icons.swap_horiz,
          size: 18,
          color: const Color(0xFF9CA3AF),
        ),
      );
    }
    IconData iconData;
    switch (topic.title) {
      case 'Present Tenses':
        iconData = Icons.access_time;
        break;
      case 'Past Tenses':
        iconData = Icons.history;
        break;
      case 'Future Tenses':
        iconData = Icons.fast_forward;
        break;
      case 'Passive Voice':
        iconData = Icons.swap_horiz;
        break;
      case 'Conditionals':
        iconData = Icons.account_tree;
        break;
      case 'Reported Speech':
        iconData = Icons.format_quote;
        break;
      case 'Modal Verbs':
        iconData = Icons.help_outline;
        break;
      case 'Relative Clauses':
        iconData = Icons.link;
        break;
      default:
        iconData = Icons.book;
    }
    return CircleAvatar(
      backgroundColor: const Color(0xFFEBF8FF),
      radius: 20,
      child: Icon(iconData, size: 18, color: const Color(0xFF2563EB)),
    );
  }

  Widget _buildInfo() {
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
          '${topic.lessonCount} lessons',
          style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9999),
                child: LinearProgressIndicator(
                  value: topic.progressPercentage / 100,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFE5E7EB),
                  valueColor: AlwaysStoppedAnimation(
                    topic.status == TopicStatus.locked
                        ? const Color(0xFFE5E7EB)
                        : const Color(0xFF2563EB),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${topic.progressPercentage.round()}%',
              style: TextStyle(
                color: topic.status == TopicStatus.locked
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

  Widget _buildStatusIcon() {
    switch (topic.status) {
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

// =================== GrammarTopicsScreen ===================
class GrammarTopicsScreen extends StatelessWidget {
  const GrammarTopicsScreen({Key? key}) : super(key: key);

  static final List<Topic> _topics = [
    const Topic(
      title: 'Present Tenses',
      iconSvg: '',
      lessonCount: 12,
      progressPercentage: 100,
      status: TopicStatus.completed,
    ),
    const Topic(
      title: 'Past Tenses',
      iconSvg: '',
      lessonCount: 10,
      progressPercentage: 70,
      status: TopicStatus.inProgress,
    ),
    const Topic(
      title: 'Future Tenses',
      iconSvg: '',
      lessonCount: 8,
      progressPercentage: 40,
      status: TopicStatus.inProgress,
    ),
    const Topic(
      title: 'Passive Voice',
      iconSvg: '',
      lessonCount: 15,
      progressPercentage: 0,
      status: TopicStatus.locked,
    ),
    const Topic(
      title: 'Conditionals',
      iconSvg: '',
      lessonCount: 14,
      progressPercentage: 0,
      status: TopicStatus.locked,
    ),
    const Topic(
      title: 'Reported Speech',
      iconSvg: '',
      lessonCount: 11,
      progressPercentage: 0,
      status: TopicStatus.locked,
    ),
    const Topic(
      title: 'Modal Verbs',
      iconSvg: '',
      lessonCount: 13,
      progressPercentage: 0,
      status: TopicStatus.locked,
    ),
    const Topic(
      title: 'Relative Clauses',
      iconSvg: '',
      lessonCount: 9,
      progressPercentage: 0,
      status: TopicStatus.locked,
    ),
  ];

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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        ProgressSection(
                          completedTopics: 12,
                          totalTopics: 24,
                          progressPercentage: 50,
                        ),
                        const SizedBox(height: 8),
                        _buildTopicsList(),
                      ],
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

  Widget _buildTopicsList() {
    return Builder(
      builder: (context) => Container(
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
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tapped on ${topic.title}')),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
