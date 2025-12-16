import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'topic.dart';
import 'package:diacritic/diacritic.dart'; // Thêm package này để loại dấu tiếng Việt

class WebScraperService {
  // Base URL cho LangMaster
  static const String baseUrl = 'https://langmaster.edu.vn';

  // Timeout duration
  static const Duration timeout = Duration(seconds: 30);

  // Map từ khóa với icon phù hợp
  static IconData _getIconForTopic(String topicName) {
    final nameLower = topicName.toLowerCase();

    // Mapping chi tiết từ khóa -> icon
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
      return Icons.favorite_border_rounded; // Icon trái tim cho sức khỏe
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
    } else if (nameLower.contains('hài sản') ||
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

    // Default icons nếu không match
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

  /// Scrape topics từ trang web với selector chính xác hơn
  Future<List<VocabTopic>> scrapeTopics(String url) async {
    try {
      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'User-Agent':
                  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
              'Accept':
                  'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
            },
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        var document = parser.parse(response.body);

        List<VocabTopic> topics = [];

        // Tìm tất cả thẻ <p> hoặc <li> hoặc <div> chứa pattern "X. Từ vựng tiếng Anh..."
        var allElements = document.querySelectorAll('p, li, div');

        int tableIndex = 0; // Đánh số thứ tự chủ đề

        for (var element in allElements) {
          final text = element.text.trim();

          // Regex để match pattern: "1. Từ vựng tiếng Anh chủ đề..."
          final regex = RegExp(
            r'^\d+\.\s*Từ vựng tiếng Anh\s+(.+?)$',
            caseSensitive: false,
          );
          final match = regex.firstMatch(text);

          if (match != null) {
            // Lấy phần sau "Từ vựng tiếng Anh"
            final topicPart = match.group(1)?.trim() ?? '';

            if (topicPart.isEmpty) continue;

            // Tìm link trong element hoặc element cha
            String topicUrl = '';
            var linkElement =
                element.querySelector('a') ??
                element.parent?.querySelector('a');

            if (linkElement != null) {
              topicUrl = linkElement.attributes['href'] ?? '';

              // Xử lý relative URL
              if (topicUrl.startsWith('/')) {
                topicUrl = '$baseUrl$topicUrl';
              } else if (topicUrl.isNotEmpty && !topicUrl.startsWith('http')) {
                topicUrl = '$baseUrl/$topicUrl';
              }
            }

            // Tạo topic name từ text đã clean
            final topicName = _cleanTopicName(topicPart);

            topics.add(
              VocabTopic(
                name: topicName,
                url: topicUrl,
                icon: _getIconForTopic(topicName),
                color: _colors[topics.length % _colors.length],
                bgColor: _bgColors[topics.length % _bgColors.length],
                tableIndex: tableIndex, // Thêm index vào topic
              ),
            );
            tableIndex++; // Tăng index cho chủ đề tiếp theo
          }
        }

        // Nếu không tìm thấy bằng cách trên, thử cách khác
        if (topics.isEmpty) {
          topics = await _scrapeFallback(document);
        }

        return topics;
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on TimeoutException catch (_) {
      throw Exception(
        'Request timeout. Please check your internet connection.',
      );
    } catch (e) {
      throw Exception('Error scraping: $e');
    }
  }

  /// Fallback scraping method
  Future<List<VocabTopic>> _scrapeFallback(dynamic document) async {
    List<VocabTopic> topics = [];

    // Thử tìm các link chứa "tu-vung"
    var topicElements = document.querySelectorAll('a[href*="tu-vung"]');

    for (var i = 0; i < topicElements.length && i < 20; i++) {
      final element = topicElements[i];
      final text = element.text.trim();
      var topicUrl = element.attributes['href'] ?? '';

      // Skip nếu text quá ngắn hoặc không hợp lệ
      if (text.length < 5 || text.contains('»') || text.contains('|')) {
        continue;
      }

      // Xử lý relative URL
      if (topicUrl.startsWith('/')) {
        topicUrl = '$baseUrl$topicUrl';
      } else if (!topicUrl.startsWith('http')) {
        topicUrl = '$baseUrl/$topicUrl';
      }

      final topicName = _cleanTopicName(text);

      topics.add(
        VocabTopic(
          name: topicName,
          url: topicUrl,
          icon: _getIconForTopic(topicName),
          color: _colors[topics.length % _colors.length],
          bgColor: _bgColors[topics.length % _bgColors.length],
          tableIndex: i, // Đúng: dùng i làm index
        ),
      );
    }

    return topics;
  }

  /// Clean topic name từ raw text
  String _cleanTopicName(String text) {
    // Remove số thứ tự đầu dòng
    var cleaned = text.replaceAll(RegExp(r'^\d+\.\s*'), '');

    // Remove "Từ vựng tiếng Anh" nếu có
    cleaned = cleaned.replaceAll(
      RegExp(r'Từ vựng tiếng Anh\s*', caseSensitive: false),
      '',
    );

    cleaned = cleaned.replaceAll(
      RegExp(r'đầy đủ nhất\s*', caseSensitive: false),
      '',
    );

    // Xử lý pattern "cơ bản chủ đề X" -> "X"
    var basicTopicMatch = RegExp(
      r'cơ bản\s+chủ đề\s+(.+)',
      caseSensitive: false,
    ).firstMatch(cleaned);
    if (basicTopicMatch != null) {
      cleaned = basicTopicMatch.group(1) ?? cleaned;
    } else {
      // Xử lý pattern "chủ đề X" -> "X"
      var topicMatch = RegExp(
        r'chủ đề\s+(.+)',
        caseSensitive: false,
      ).firstMatch(cleaned);
      if (topicMatch != null) {
        cleaned = topicMatch.group(1) ?? cleaned;
      }
    }

    // Remove các từ không cần thiết ở đầu
    cleaned = cleaned.replaceAll(
      RegExp(r'^(thông dụng|giao tiếp)\s+', caseSensitive: false),
      '',
    );

    // Capitalize first letter
    if (cleaned.isNotEmpty) {
      cleaned = cleaned[0].toUpperCase() + cleaned.substring(1);
    }

    return cleaned.trim();
  }

  Future<List<Map<String, String>>> scrapeVocabulary(
    String topicUrl, {
    int? tableIndex, // truyền index của bảng cần lấy
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse(topicUrl),
            headers: {
              'User-Agent':
                  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
            },
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        var document = parser.parse(response.body);
        List<Map<String, String>> vocabularies = [];
        var tables = document.querySelectorAll('table');

        // Nếu có index, lấy đúng bảng theo index
        if (tableIndex != null && tableIndex < tables.length) {
          var rows = tables[tableIndex].querySelectorAll('tr');
          for (var i = 1; i < rows.length; i++) {
            var row = rows[i];
            var cells = row.querySelectorAll('td, th');
            if (cells.length >= 2) {
              final word = cells[0].text.trim();
              final meaning = cells[1].text.trim();
              final phonetic = cells.length > 2 ? cells[2].text.trim() : '';
              if (word.isNotEmpty && meaning.isNotEmpty) {
                vocabularies.add({
                  'word': word,
                  'meaning': meaning,
                  'phonetic': phonetic,
                  'example': '',
                });
              }
            }
          }
          return vocabularies;
        }

        // Nếu không có index, fallback: lấy bảng đầu tiên
        if (tables.isNotEmpty) {
          var rows = tables.first.querySelectorAll('tr');
          for (var i = 1; i < rows.length; i++) {
            var row = rows[i];
            var cells = row.querySelectorAll('td, th');
            if (cells.length >= 2) {
              final word = cells[0].text.trim();
              final meaning = cells[1].text.trim();
              final phonetic = cells.length > 2 ? cells[2].text.trim() : '';
              if (word.isNotEmpty && meaning.isNotEmpty) {
                vocabularies.add({
                  'word': word,
                  'meaning': meaning,
                  'phonetic': phonetic,
                  'example': '',
                });
              }
            }
          }
        }
        return vocabularies;
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error scraping vocabulary: $e');
    }
  }

  /// Check xem URL có hợp lệ không
  bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
}

// Timeout Exception
class TimeoutException implements Exception {
  final String message;
  TimeoutException([this.message = 'Operation timed out']);

  @override
  String toString() => message;
}
