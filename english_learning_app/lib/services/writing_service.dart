import 'dart:convert';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class WritingService {
  // ⚠️ CẤU HÌNH IP & PORT (Dùng 5000 để khớp với Server mới)
  // - Máy ảo Android: 10.0.2.2
  // - Máy thật: IP LAN (192.168.1.X)
  static const String _baseUrl = 'http://10.0.2.2:5000/api/writing';

  // Helper lấy Token
  Future<String?> _getToken() async {
    return await FirebaseAuth.instance.currentUser?.getIdToken();
  }

  // 1. LƯU BÀI VIẾT
  Future<bool> saveWriting({String? id, required String title, required String content, required String type}) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      print("🚀 Đang lưu bài viết tới: $_baseUrl/save");

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
      ).timeout(const Duration(seconds: 10)); // Timeout 10s

      print("📩 Server phản hồi: ${response.statusCode}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("❌ Lỗi kết nối khi lưu: $e");
      return false;
    }
  }

  // 2. LẤY DANH SÁCH BÀI VIẾT
  Future<List<dynamic>> getMyWritings() async {
    try {
      final token = await _getToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse('$_baseUrl/my-work'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print("❌ Lỗi lấy danh sách: $e");
      return [];
    }
  }

  // 3. XÓA BÀI VIẾT
  Future<bool> deleteWriting(String id) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      print("❌ Lỗi xóa bài: $e");
      return false;
    }
  }
}