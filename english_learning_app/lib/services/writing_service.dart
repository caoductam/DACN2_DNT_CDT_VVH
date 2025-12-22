import 'dart:convert';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class WritingService {
  // ⚠️ SỬA LẠI PORT THÀNH 3000 (Để khớp với Server Node.js)
  // Máy ảo Android dùng 10.0.2.2
  static const String _baseUrl = 'http://10.0.2.2:5000/api/writing';

  Future<String?> _getToken() async {
    return await FirebaseAuth.instance.currentUser?.getIdToken();
  }

  // 1. saveWriting (Khớp với WritingEditorScreen)
  Future<bool> saveWriting({
    String? id, 
    required String title, 
    required String content, 
    required String type
  }) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      print("🚀 Gửi request tới: $_baseUrl/save");

      final response = await http.post(
        Uri.parse('$_baseUrl/save'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'id': id,
          'title': title,
          'content': content,
          'type': type,
          'status': 'draft'
        }),
      ).timeout(const Duration(seconds: 15));

      print("📩 Server phản hồi: ${response.statusCode}");
      
      // Chấp nhận 200 hoặc 201
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("❌ Lỗi lưu: $e");
      return false;
    }
  }

  // 2. getSubmissions (Đã đổi tên từ getMyWritings để khớp với WritingScreen)
  Future<List<dynamic>> getSubmissions() async {
    try {
      final token = await _getToken();
      if (token == null) return [];
      
      print("🚀 Đang tải danh sách: $_baseUrl/my-work");

      final response = await http.get(
        Uri.parse('$_baseUrl/my-work'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print("❌ Lỗi lấy danh sách: $e");
      return [];
    }
  }

  // 3. deleteSubmission (Đã đổi tên từ deleteWriting để khớp với WritingScreen)
  Future<bool> deleteSubmission(String id) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 15));

      return response.statusCode == 200;
    } catch (e) {
      print("❌ Lỗi xóa: $e");
      return false;
    }
  }
}