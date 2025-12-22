// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'topic.dart';

// class GrammarApiService {
//   // static const String baseUrl = 'http://localhost:3000/api';
//   static const String baseUrl = 'http://10.0.2.2:3000/api';
//   // Khi deploy: 'https://your-api.onrender.com/api'

//   // Lấy tất cả topics
//   static Future<List<Topic>> getTopics() async {
//     final response = await http.get(Uri.parse('$baseUrl/topics'));

//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body);
//       return data.map((json) => Topic.fromJson(json)).toList();
//     }
//     throw Exception('Failed to load topics');
//   }

//   // Lấy chi tiết 1 topic
//   static Future<Topic> getTopicDetail(String topicId) async {
//     final response = await http.get(Uri.parse('$baseUrl/topics/$topicId'));

//     if (response.statusCode == 200) {
//       return Topic.fromJson(json.decode(response.body));
//     }
//     throw Exception('Failed to load topic detail');
//   }

//   // Lấy user progress
//   static Future<Map<String, dynamic>> getUserProgress(String userId) async {
//     final response = await http.get(Uri.parse('$baseUrl/progress/$userId'));

//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     }
//     throw Exception('Failed to load progress');
//   }

//   // Đánh dấu lesson hoàn thành
//   static Future<void> completeLesson({
//     required String userId,
//     required String topicId,
//     required String lessonId,
//     int score = 0,
//   }) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/progress/$userId/complete'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'topicId': topicId,
//         'lessonId': lessonId,
//         'score': score,
//       }),
//     );

//     if (response.statusCode != 200) {
//       throw Exception('Failed to complete lesson');
//     }
//   }

//   // Unlock topic
//   static Future<void> unlockTopic(String topicId) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/topics/$topicId/unlock'),
//     );

//     if (response.statusCode != 200) {
//       throw Exception('Failed to unlock topic');
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'topic.dart';

class GrammarApiService {
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  // ✅ HÀM LẤY TOKEN
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print('🔑 Token retrieved: ${token?.substring(0, 20)}...'); // Debug
    return token;
  }

  // ✅ HÀM TẠO HEADERS VỚI TOKEN
  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ✅ Lấy tất cả topics (CÓ TOKEN)
  static Future<List<Topic>> getTopics() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/topics'),
      headers: headers,
    );

    print('📡 GET /topics - Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Topic.fromJson(json)).toList();
    }
    throw Exception('Failed to load topics: ${response.body}');
  }

  // ✅ Lấy chi tiết 1 topic (CÓ TOKEN)
  static Future<Topic> getTopicDetail(String topicId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/topics/$topicId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Topic.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to load topic detail: ${response.body}');
  }

  // ✅ Lấy user progress (CÓ TOKEN)
  static Future<Map<String, dynamic>> getUserProgress(String userId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/progress/$userId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load progress: ${response.body}');
  }

  // ✅ Đánh dấu lesson hoàn thành (CÓ TOKEN)
  static Future<void> completeLesson({
    required String userId,
    required String topicId,
    required String lessonId,
    int score = 0,
  }) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/progress/$userId/complete'),
      headers: headers,
      body: json.encode({
        'topicId': topicId,
        'lessonId': lessonId,
        'score': score,
      }),
    );

    print('📡 POST /complete - Status: ${response.statusCode}');

    if (response.statusCode != 200) {
      throw Exception('Failed to complete lesson: ${response.body}');
    }
  }

  // ✅ Unlock topic (CÓ TOKEN)
  static Future<void> unlockTopic(String topicId) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/topics/$topicId/unlock'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to unlock topic: ${response.body}');
    }
  }
}
