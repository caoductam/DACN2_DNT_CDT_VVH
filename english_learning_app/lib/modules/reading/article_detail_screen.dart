import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import để mở link
import '../../config/app_colors.dart';

class ArticleDetailScreen extends StatelessWidget {
  final dynamic article; // Nhận object bài báo thật

  const ArticleDetailScreen({super.key, required this.article});

  // Hàm mở trình duyệt
  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(article['url']);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // HEADER ẢNH THẬT
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            leading: const BackButton(
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white54)),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                article['urlToImage'] ?? '',
                fit: BoxFit.cover,
                errorBuilder: (_,__,___) => Container(color: Colors.grey),
              ),
            ),
          ),

          // NỘI DUNG
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nguồn & Ngày
                  Row(
                    children: [
                      Chip(
                        label: Text(article['source']['name'] ?? 'News'),
                        backgroundColor: AppColors.readingBg,
                        labelStyle: const TextStyle(color: AppColors.readingColor, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        (article['publishedAt'] as String).substring(0, 10), // Lấy ngày YYYY-MM-DD
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Tiêu đề
                  Text(
                    article['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Mô tả (Đậm hơn chút)
                  Text(
                    article['description'] ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Nội dung (API miễn phí chỉ trả về 1 đoạn ngắn)
                  Text(
                    article['content'] != null 
                        ? article['content'].toString().split('[')[0] // Cắt bỏ phần [+chars]
                        : 'No content preview available.',
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Nút Đọc Full
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _launchUrl,
                      icon: const Icon(Icons.open_in_browser, color: Colors.white),
                      label: const Text("Read Full Article on Web", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.readingColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}