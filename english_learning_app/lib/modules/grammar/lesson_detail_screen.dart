// import 'package:flutter/material.dart';
// import 'topic.dart';
// import '../../theme.dart';

// class LessonDetailScreen extends StatelessWidget {
//   final Lesson lesson;
//   final Function(int score) onComplete;

//   const LessonDetailScreen({
//     super.key,
//     required this.lesson,
//     required this.onComplete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(lesson.title),
//         backgroundColor: AppColors.background,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: AppColors.primary),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Content',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             Text(lesson.content),
//             const SizedBox(height: 24),
//             if (lesson.examples.isNotEmpty) ...[
//               const Text(
//                 'Examples',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               ...lesson.examples.map(
//                 (ex) => Padding(
//                   padding: const EdgeInsets.only(bottom: 8),
//                   child: Text('• $ex'),
//                 ),
//               ),
//             ],
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   onComplete(100);
//                   Navigator.pop(context);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   'Complete Lesson',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'topic.dart';
import '../../theme.dart';

class LessonDetailScreen extends StatelessWidget {
  final Lesson lesson;
  final Function(int score) onComplete;

  const LessonDetailScreen({
    super.key,
    required this.lesson,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(lesson.title, style: AppTextStyles.header),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Content Section
                Row(
                  children: const [
                    Icon(Icons.menu_book, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      'Content',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  lesson.content,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
                const SizedBox(height: 24),
                // Examples Section
                if (lesson.examples.isNotEmpty) ...[
                  Row(
                    children: const [
                      Icon(Icons.lightbulb, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Examples',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...lesson.examples.map(
                    (ex) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '• $ex',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                // Complete Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      onComplete(100);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      'Complete Lesson',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
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
}
