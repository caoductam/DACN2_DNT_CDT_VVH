import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  // ⚠️ THAY API KEY CỦA BẠN VÀO ĐÂY
  static const String _apiKey = '5747e7cca7e14fcc9ed0fbc3fc8afe31'; 
  static const String _baseUrl = 'https://newsapi.org/v2';

  // Hàm lấy tin tức theo Level (Ánh xạ Level -> Category)
  Future<List<dynamic>> fetchArticlesByLevel(String level) async {
    String category = 'general';
    
    // Chiến thuật: Gợi ý chủ đề dựa theo trình độ
    switch (level) {
      case 'Beginner':
        category = 'entertainment'; // Giải trí thường dễ đọc
        break;
      case 'Intermediate':
        category = 'technology'; // Công nghệ từ vựng vừa phải
        break;
      case 'Advanced':
        category = 'business'; // Kinh tế nhiều từ chuyên ngành
        break;
    }

    return await fetchArticlesByCategory(category);
  }

  // Hàm lấy tin theo chủ đề cụ thể (Khi bấm Chip)
  Future<List<dynamic>> fetchArticlesByCategory(String category) async {
    try {
      final url = Uri.parse('$_baseUrl/top-headlines?country=us&category=${category.toLowerCase()}&apiKey=$_apiKey');
      
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Lọc bỏ các bài không có ảnh hoặc bị lỗi
        return (data['articles'] as List).where((article) {
          return article['title'] != null && 
                 article['urlToImage'] != null && 
                 article['description'] != null &&
                 article['title'] != '[Removed]';
        }).toList();
      } else {
        print("Lỗi API: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Lỗi kết nối NewsAPI: $e");
      return [];
    }
  }
}