import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../services/news_service.dart'; // Import Service
import 'article_detail_screen.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  final NewsService _newsService = NewsService();
  
  // Trạng thái
  String _selectedLevel = "Beginner";
  String _selectedCategory = "All";
  List<dynamic> _articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  // Hàm tải tin tức
  void _loadNews() async {
    setState(() => _isLoading = true);
    
    // Nếu đang chọn Topic cụ thể thì ưu tiên Topic, không thì theo Level
    List<dynamic> news;
    if (_selectedCategory != "All") {
      news = await _newsService.fetchArticlesByCategory(_selectedCategory);
    } else {
      news = await _newsService.fetchArticlesByLevel(_selectedLevel);
    }

    if (mounted) {
      setState(() {
        _articles = news;
        _isLoading = false;
      });
    }
  }

  // Đổi Level (Tab)
  void _onLevelChanged(String level) {
    setState(() {
      _selectedLevel = level;
      _selectedCategory = "All"; // Reset category khi đổi level
    });
    _loadNews();
  }

  // Đổi Category (Chip)
  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _loadNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // 1. LEVEL TABS (Beginner - Inter - Advanced)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _buildLevelTab("Beginner"),
                  _buildLevelTab("Intermediate"),
                  _buildLevelTab("Advanced"),
                ],
              ),
            ),
          ),

          // 2. TOPICS CHIPS (Scroll ngang)
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                _buildFilterChip("All"),
                _buildFilterChip("Health"),
                _buildFilterChip("Science"),
                _buildFilterChip("Sports"),
                _buildFilterChip("Technology"),
                _buildFilterChip("Business"),
              ],
            ),
          ),
          
          const SizedBox(height: 16),

          // 3. DANH SÁCH BÀI BÁO (Real Data)
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _articles.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.newspaper, size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          const Text("No articles found", style: TextStyle(color: Colors.grey)),
                          TextButton(onPressed: _loadNews, child: const Text("Retry"))
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      itemCount: _articles.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return _buildArticleItem(_articles[index]);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS ---

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: const BackButton(color: Colors.black),
      title: const Text(
        "News Feed",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.black),
          onPressed: _loadNews,
        )
      ],
    );
  }

  Widget _buildLevelTab(String level) {
    bool isSelected = _selectedLevel == level;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onLevelChanged(level),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))] : [],
          ),
          child: Text(
            level,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.readingColor : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _selectedCategory == label;
    // Map tên hiển thị sang tên API (ví dụ All -> general)
    // Nhưng ở đây mình để đơn giản là truyền trực tiếp
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => _onCategoryChanged(label == "All" ? "general" : label),
        backgroundColor: Colors.white,
        selectedColor: AppColors.readingBg,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.readingColor : Colors.grey[600],
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isSelected ? AppColors.readingColor : Colors.grey.shade200),
        ),
        showCheckmark: false,
      ),
    );
  }

  Widget _buildArticleItem(dynamic article) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: article),
          ),
        );
      },
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            // Ảnh Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
              child: Image.network(
                article['urlToImage'] ?? '',
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 110, 
                  color: Colors.grey[200], 
                  child: const Icon(Icons.image_not_supported, color: Colors.grey)
                ),
              ),
            ),
            
            // Nội dung
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      article['title'] ?? 'No Title',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          article['source']['name'] ?? 'News',
                          style: const TextStyle(fontSize: 11, color: AppColors.readingColor, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        const Icon(Icons.access_time, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        // Giả lập thời gian đọc dựa trên độ dài nội dung
                        Text(
                          "${((article['content']?.length ?? 500) / 200).ceil()} min", 
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}