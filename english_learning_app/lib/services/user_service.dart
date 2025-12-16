import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class UserService {
  // ⚠️ CẤU HÌNH IP (Máy ảo: 10.0.2.2, Máy thật: IP LAN)
  static const String _baseUrl = 'http://10.0.2.2:5000/api/user';

  // Lấy thông tin Profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;
      final String? token = await user.getIdToken();

      final response = await http.get(
        Uri.parse('$_baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print("❌ Lỗi kết nối: $e");
      return null;
    }
  }

  // --- HÀM MỚI: CẬP NHẬT PROFILE ---
  Future<bool> updateUserProfile(String name, String avatarUrl) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;
      
      // 1. Cập nhật trên Firebase trước (để App hiển thị ngay)
      await user.updateDisplayName(name);
      if (avatarUrl.isNotEmpty) {
        await user.updatePhotoURL(avatarUrl);
      }

      // 2. Gửi về Backend lưu trữ
      final String? token = await user.getIdToken();
      final response = await http.put(
        Uri.parse('$_baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'username': name,
          'avatar': avatarUrl
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("❌ Lỗi cập nhật: $e");
      return false;
    }
  }
}