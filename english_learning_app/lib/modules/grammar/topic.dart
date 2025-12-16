enum TopicStatus { completed, inProgress, locked }

class Topic {
  final String topicId;
  final String title;
  final String icon;
  final int totalLessons;
  final List<Lesson> lessons;
  final bool isLocked;
  final int progress;
  final int order;

  Topic({
    required this.topicId,
    required this.title,
    required this.icon,
    required this.totalLessons,
    required this.lessons,
    required this.isLocked,
    required this.progress,
    required this.order,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      topicId: json['topicId'],
      title: json['title'],
      icon: json['icon'] ?? '📚',
      totalLessons: json['totalLessons'],
      lessons:
          (json['lessons'] as List?)?.map((l) => Lesson.fromJson(l)).toList() ??
          [],
      isLocked: json['isLocked'] ?? false,
      progress: json['progress'] ?? 0,
      order: json['order'] ?? 0,
    );
  }
}

class Lesson {
  final String lessonId;
  final String title;
  final String content;
  final List<String> examples;
  final bool completed;

  Lesson({
    required this.lessonId,
    required this.title,
    required this.content,
    required this.examples,
    required this.completed,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      lessonId: json['lessonId'],
      title: json['title'],
      content: json['content'] ?? '',
      examples: List<String>.from(json['examples'] ?? []),
      completed: json['completed'] ?? false,
    );
  }
}
