import 'dart:convert';
import 'package:http/http.dart' as http;
import 'topic.dart';

class GrammarApiService {
  // static const String baseUrl = 'http://localhost:3000/api';
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  // Khi deploy: 'https://your-api.onrender.com/api'

  // Lấy tất cả topics
  static Future<List<Topic>> getTopics() async {
    final response = await http.get(Uri.parse('$baseUrl/topics'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Topic.fromJson(json)).toList();
    }
    throw Exception('Failed to load topics');
  }

  // Lấy chi tiết 1 topic
  static Future<Topic> getTopicDetail(String topicId) async {
    final response = await http.get(Uri.parse('$baseUrl/topics/$topicId'));

    if (response.statusCode == 200) {
      return Topic.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to load topic detail');
  }

  // Lấy user progress
  static Future<Map<String, dynamic>> getUserProgress(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/progress/$userId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load progress');
  }

  // Đánh dấu lesson hoàn thành
  static Future<void> completeLesson({
    required String userId,
    required String topicId,
    required String lessonId,
    int score = 0,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/progress/$userId/complete'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'topicId': topicId,
        'lessonId': lessonId,
        'score': score,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to complete lesson');
    }
  }

  // Unlock topic
  static Future<void> unlockTopic(String topicId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/topics/$topicId/unlock'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to unlock topic');
    }
  }
}
