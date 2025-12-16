import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'topic.dart';

class GoogleSheetsService {
  // Thay YOUR_API_KEY bằng API key từ Google Cloud Console
  static const String apiKey = 'AIzaSyBt9uBOZgk6oJKdN0JaLrvCdrVJPG7MEy0';

  // Thay YOUR_SPREADSHEET_ID bằng ID của Google Sheet
  // ID nằm trong URL: https://docs.google.com/spreadsheets/d/{SPREADSHEET_ID}/edit
  static const String spreadsheetId =
      '1Ep0BKqr6eH-Nmt89hEiuNsQ50wcmRwJQ1Q4sX_jyiTE';

  static const Duration timeout = Duration(seconds: 30);

  // Map từ khóa với icon phù hợp
  static IconData _getIconForTopic(String topicName) {
    final nameLower = topicName.toLowerCase();

    if (nameLower.contains('gia đình') || nameLower.contains('gia dinh')) {
      return Icons.home_rounded;
    } else if (nameLower.contains('thời tiết') ||
        nameLower.contains('thoi tiet')) {
      return Icons.wb_sunny_rounded;
    } else if (nameLower.contains('nghề nghiệp') ||
        nameLower.contains('nghe nghiep')) {
      return Icons.work_rounded;
    } else if (nameLower.contains('quần áo') ||
        nameLower.contains('quan ao') ||
        nameLower.contains('thời trang')) {
      return Icons.checkroom_rounded;
    } else if (nameLower.contains('tính cách') ||
        nameLower.contains('tinh cach') ||
        nameLower.contains('cảm xúc')) {
      return Icons.favorite_rounded;
    } else if (nameLower.contains('rau củ') ||
        nameLower.contains('rau cu') ||
        nameLower.contains('trái cây')) {
      return Icons.eco_rounded;
    } else if (nameLower.contains('môi trường') ||
        nameLower.contains('moi truong')) {
      return Icons.public_rounded;
    } else if (nameLower.contains('con vật') ||
        nameLower.contains('con vat') ||
        nameLower.contains('động vật')) {
      return Icons.pets_rounded;
    } else if (nameLower.contains('đồ ăn') ||
        nameLower.contains('do an') ||
        nameLower.contains('thức ăn') ||
        nameLower.contains('ẩm thực')) {
      return Icons.restaurant_rounded;
    } else if (nameLower.contains('trường học') ||
        nameLower.contains('truong hoc') ||
        nameLower.contains('giáo dục')) {
      return Icons.school_rounded;
    } else if (nameLower.contains('du lịch') ||
        nameLower.contains('du lich') ||
        nameLower.contains('travel')) {
      return Icons.flight_rounded;
    } else if (nameLower.contains('màu sắc') || nameLower.contains('mau sac')) {
      return Icons.palette_rounded;
    } else if (nameLower.contains('giao thông') ||
        nameLower.contains('giao thong') ||
        nameLower.contains('phương tiện')) {
      return Icons.directions_car_rounded;
    } else if (nameLower.contains('y tế') ||
        nameLower.contains('y te') ||
        nameLower.contains('sức khỏe') ||
        nameLower.contains('suc khoe')) {
      return Icons.favorite_border_rounded;
    } else if (nameLower.contains('thể thao') ||
        nameLower.contains('the thao') ||
        nameLower.contains('sport')) {
      return Icons.sports_soccer_rounded;
    } else if (nameLower.contains('công việc') ||
        nameLower.contains('cong viec') ||
        nameLower.contains('văn phòng')) {
      return Icons.business_center_rounded;
    } else if (nameLower.contains('âm nhạc') ||
        nameLower.contains('am nhac') ||
        nameLower.contains('music')) {
      return Icons.music_note_rounded;
    } else if (nameLower.contains('công nghệ') ||
        nameLower.contains('cong nghe') ||
        nameLower.contains('máy tính')) {
      return Icons.computer_rounded;
    } else if (nameLower.contains('mua sắm') ||
        nameLower.contains('mua sam') ||
        nameLower.contains('shopping')) {
      return Icons.shopping_cart_rounded;
    } else if (nameLower.contains('nấu ăn') ||
        nameLower.contains('nau an') ||
        nameLower.contains('bếp')) {
      return Icons.restaurant_menu_rounded;
    } else if (nameLower.contains('ngôi nhà') ||
        nameLower.contains('nhà cửa')) {
      return Icons.house_rounded;
    } else if (nameLower.contains('thời gian') ||
        nameLower.contains('thoi gian')) {
      return Icons.access_time_rounded;
    } else if (nameLower.contains('số đếm') ||
        nameLower.contains('so dem') ||
        nameLower.contains('number')) {
      return Icons.numbers_rounded;
    } else if (nameLower.contains('hình dạng') ||
        nameLower.contains('hinh dang')) {
      return Icons.category_rounded;
    } else if (nameLower.contains('cơ thể') ||
        nameLower.contains('co the') ||
        nameLower.contains('body')) {
      return Icons.accessibility_rounded;
    } else if (nameLower.contains('biển') || nameLower.contains('beach')) {
      return Icons.beach_access_rounded;
    } else if (nameLower.contains('lễ hội') ||
        nameLower.contains('le hoi') ||
        nameLower.contains('celebration')) {
      return Icons.celebration_rounded;
    } else if (nameLower.contains('bệnh viện') ||
        nameLower.contains('benh vien') ||
        nameLower.contains('bác sĩ')) {
      return Icons.local_hospital_rounded;
    } else if (nameLower.contains('hoa') ||
        nameLower.contains('flower') ||
        nameLower.contains('cây')) {
      return Icons.local_florist_rounded;
    } else if (nameLower.contains('phim ảnh') ||
        nameLower.contains('phim anh') ||
        nameLower.contains('movie') ||
        nameLower.contains('cinema')) {
      return Icons.movie_rounded;
    } else if (nameLower.contains('hải sản') ||
        nameLower.contains('hai san') ||
        nameLower.contains('seafood')) {
      return Icons.set_meal_rounded;
    } else if (nameLower.contains('bưu điện') ||
        nameLower.contains('buu dien') ||
        nameLower.contains('post')) {
      return Icons.mail_rounded;
    } else if (nameLower.contains('ngân hàng') ||
        nameLower.contains('ngan hang') ||
        nameLower.contains('bank')) {
      return Icons.account_balance_rounded;
    } else if (nameLower.contains('khách sạn') ||
        nameLower.contains('khach san') ||
        nameLower.contains('hotel')) {
      return Icons.hotel_rounded;
    } else if (nameLower.contains('nhà hàng') ||
        nameLower.contains('nha hang') ||
        nameLower.contains('restaurant')) {
      return Icons.restaurant_rounded;
    } else if (nameLower.contains('cafe') ||
        nameLower.contains('cà phê') ||
        nameLower.contains('coffee')) {
      return Icons.local_cafe_rounded;
    } else if (nameLower.contains('sách') ||
        nameLower.contains('book') ||
        nameLower.contains('đọc')) {
      return Icons.menu_book_rounded;
    } else if (nameLower.contains('quà tặng') ||
        nameLower.contains('qua tang') ||
        nameLower.contains('gift')) {
      return Icons.card_giftcard_rounded;
    } else if (nameLower.contains('tình yêu') ||
        nameLower.contains('tinh yeu') ||
        nameLower.contains('love')) {
      return Icons.favorite_rounded;
    } else if (nameLower.contains('gia vị') ||
        nameLower.contains('gia vi') ||
        nameLower.contains('spice')) {
      return Icons.local_dining_rounded;
    } else if (nameLower.contains('đồ uống') ||
        nameLower.contains('do uong') ||
        nameLower.contains('drink')) {
      return Icons.local_bar_rounded;
    }

    return Icons.book_rounded;
  }

  // Danh sách colors cho các topic
  static final List<Color> _colors = [
    const Color(0xFFEF5350),
    const Color(0xFF66BB6A),
    const Color(0xFFFFCA28),
    const Color(0xFFAB47BC),
    const Color(0xFF42A5F5),
    const Color(0xFFEC407A),
    const Color(0xFFFF7043),
    const Color(0xFF26A69A),
    const Color(0xFF5C6BC0),
    const Color(0xFF9CCC65),
    const Color(0xFFFFB74D),
    const Color(0xFF78909C),
    const Color(0xFFBA68C8),
    const Color(0xFF4DB6AC),
    const Color(0xFFFFD54F),
    const Color(0xFF7986CB),
  ];

  // Danh sách background colors
  static final List<Color> _bgColors = [
    const Color(0xFFFFEBEE),
    const Color(0xFFE8F5E9),
    const Color(0xFFFFF8E1),
    const Color(0xFFF3E5F5),
    const Color(0xFFE3F2FD),
    const Color(0xFFFCE4EC),
    const Color(0xFFFBE9E7),
    const Color(0xFFE0F2F1),
    const Color(0xFFE8EAF6),
    const Color(0xFFF1F8E9),
    const Color(0xFFFFF3E0),
    const Color(0xFFECEFF1),
    const Color(0xFFF3E5F5),
    const Color(0xFFE0F2F1),
    const Color(0xFFFFFDE7),
    const Color(0xFFE8EAF6),
  ];

  /// Lấy danh sách topics từ sheet "Topics"
  /// Sheet structure: | Topic Name | Sheet Name |
  Future<List<VocabTopic>> getTopics() async {
    try {
      final url =
          'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/Topics!A2:B?key=$apiKey';

      final response = await http.get(Uri.parse(url)).timeout(timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final values = data['values'] as List<dynamic>?;

        if (values == null || values.isEmpty) {
          return [];
        }

        List<VocabTopic> topics = [];

        for (int i = 0; i < values.length; i++) {
          final row = values[i] as List<dynamic>;
          if (row.isEmpty) continue;

          final topicName = row[0].toString().trim();
          final sheetName = row.length > 1
              ? row[1].toString().trim()
              : topicName;

          if (topicName.isEmpty) continue;

          topics.add(
            VocabTopic(
              name: topicName,
              url: sheetName, // Sử dụng sheetName thay vì URL
              icon: _getIconForTopic(topicName),
              color: _colors[i % _colors.length],
              bgColor: _bgColors[i % _bgColors.length],
              tableIndex: i,
            ),
          );
        }

        return topics;
      } else {
        throw Exception('Failed to load topics: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading topics: $e');
    }
  }

  /// Lấy từ vựng từ một sheet cụ thể
  /// Sheet structure: | Word | Phonetic | Meaning | Example |
  Future<List<Map<String, String>>> getVocabulary(String sheetName) async {
    try {
      // Encode sheet name để xử lý khoảng trắng và ký tự đặc biệt
      final encodedSheetName = Uri.encodeComponent(sheetName);
      final url =
          'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$encodedSheetName!A2:D?key=$apiKey';

      final response = await http.get(Uri.parse(url)).timeout(timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final values = data['values'] as List<dynamic>?;

        if (values == null || values.isEmpty) {
          return [];
        }

        List<Map<String, String>> vocabularies = [];

        for (var row in values) {
          if (row.isEmpty) continue;

          final word = row[0].toString().trim();
          if (word.isEmpty) continue;

          final phonetic = row.length > 1 ? row[1].toString().trim() : '';
          final meaning = row.length > 2 ? row[2].toString().trim() : '';
          final example = row.length > 3 ? row[3].toString().trim() : '';

          vocabularies.add({
            'word': word,
            'phonetic': phonetic,
            'meaning': meaning,
            'example': example,
          });
        }

        return vocabularies;
      } else {
        throw Exception('Failed to load vocabulary: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading vocabulary: $e');
    }
  }

  /// Lấy tất cả sheets trong spreadsheet (để kiểm tra)
  Future<List<String>> getAllSheetNames() async {
    try {
      final url =
          'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId?key=$apiKey';

      final response = await http.get(Uri.parse(url)).timeout(timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final sheets = data['sheets'] as List<dynamic>;

        return sheets
            .map((sheet) => sheet['properties']['title'].toString())
            .toList();
      } else {
        throw Exception('Failed to load sheet names: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading sheet names: $e');
    }
  }

  /// Test connection với Google Sheets
  Future<bool> testConnection() async {
    try {
      final url =
          'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId?key=$apiKey';
      final response = await http.get(Uri.parse(url)).timeout(timeout);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
