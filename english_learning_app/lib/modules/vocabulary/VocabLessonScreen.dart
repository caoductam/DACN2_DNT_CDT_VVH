import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import 'topic.dart';
import 'GoogleSheetsService.dart'; // ✅ Thay đổi import

class VocabLessonScreen extends StatefulWidget {
  final VocabTopic topic;

  const VocabLessonScreen({Key? key, required this.topic}) : super(key: key);

  @override
  State<VocabLessonScreen> createState() => _VocabLessonScreenState();
}

class _VocabLessonScreenState extends State<VocabLessonScreen> {
  final GoogleSheetsService _sheetsService =
      GoogleSheetsService(); // ✅ Thay đổi service

  bool _isLoading = true;
  List<Map<String, String>> _vocabularies = [];
  int _currentWordIndex = 0;
  bool _isFavorite = false;
  String? _errorMessage; // ✅ Thêm biến error message

  @override
  void initState() {
    super.initState();
    _loadVocabularies();
  }

  // ✅ Cập nhật method load vocabularies
  Future<void> _loadVocabularies() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Lấy từ vựng từ Google Sheets bằng sheet name
      // topic.url chứa sheet name (ví dụ: "Family", "Weather")
      final vocabularies = await _sheetsService.getVocabulary(widget.topic.url);

      if (vocabularies.isEmpty) {
        throw Exception(
          'Sheet "${widget.topic.url}" không có dữ liệu hoặc không tồn tại',
        );
      }

      setState(() {
        _vocabularies = vocabularies;
        _isLoading = false;
      });
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');

      setState(() {
        _vocabularies = [];
        _isLoading = false;
        _errorMessage = errorMsg;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể tải từ vựng: $errorMsg'),
            backgroundColor: Colors.red.shade400,
            action: SnackBarAction(
              label: 'Thử lại',
              textColor: Colors.white,
              onPressed: _loadVocabularies,
            ),
          ),
        );
      }
    }
  }

  void _nextWord() {
    if (_currentWordIndex < _vocabularies.length - 1) {
      setState(() {
        _currentWordIndex++;
        _isFavorite = false; // Reset favorite cho từ mới
      });
    } else {
      // Hoàn thành tất cả từ
      _showCompletionDialog();
    }
  }

  void _previousWord() {
    if (_currentWordIndex > 0) {
      setState(() {
        _currentWordIndex--;
        _isFavorite = false;
      });
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Hoàn thành! 🎉',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Bạn đã học xong ${_vocabularies.length} từ vựng trong chủ đề "${widget.topic.name}"!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Back to vocab screen
            },
            child: const Text('Hoàn thành'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _currentWordIndex = 0); // Restart
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.topic.color,
            ),
            child: const Text('Học lại'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentWord =
        _vocabularies.isNotEmpty && _currentWordIndex < _vocabularies.length
        ? _vocabularies[_currentWordIndex]
        : null;

    final progress = _vocabularies.isNotEmpty
        ? (_currentWordIndex + 1) / _vocabularies.length
        : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: widget.topic.color),
                    const SizedBox(height: 16),
                    Text(
                      'Đang tải dữ liệu...', // ✅ Cập nhật text
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            : _vocabularies.isEmpty
            ? _buildEmptyState() // ✅ Thêm empty state
            : Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 412),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFCED4DA),
                      width: 2,
                    ),
                    color: const Color(0xFFF8F9FA),
                  ),
                  child: Column(
                    children: [
                      _Header(
                        topic: widget.topic,
                        currentWord: _currentWordIndex + 1,
                        totalWords: _vocabularies.length,
                        onBack: () => Navigator.of(context).pop(),
                        onSettings: () {},
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x1A000000),
                                blurRadius: 6,
                                offset: Offset(0, 4),
                              ),
                              BoxShadow(
                                color: Color(0x1A000000),
                                blurRadius: 15,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: currentWord != null
                              ? SingleChildScrollView(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    children: [
                                      _WordCard(
                                        word: currentWord['word'] ?? '',
                                        phonetic: currentWord['phonetic'] ?? '',
                                        meaning: currentWord['meaning'] ?? '',
                                        color: widget.topic.color,
                                      ),
                                      const SizedBox(height: 24),
                                      // ✅ Chỉ hiển thị nếu có example
                                      if (currentWord['example']?.isNotEmpty ??
                                          false) ...[
                                        _ExampleSection(
                                          example: currentWord['example'] ?? '',
                                          color: widget.topic.color,
                                        ),
                                        const SizedBox(height: 24),
                                      ],
                                      _AudioButton(
                                        onPressed: () {
                                          // TODO: Implement text-to-speech
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Phát âm: ${currentWord['word']}',
                                              ),
                                              duration: const Duration(
                                                seconds: 1,
                                              ),
                                            ),
                                          );
                                        },
                                        color: widget.topic.color,
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _ActionButton(
                                              icon: _isFavorite
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              label: 'Favorite',
                                              color: Colors.white,
                                              textColor: const Color(
                                                0xFF374151,
                                              ),
                                              iconColor: _isFavorite
                                                  ? Colors.red
                                                  : const Color(0xFF374151),
                                              onTap: () {
                                                setState(() {
                                                  _isFavorite = !_isFavorite;
                                                });
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _ActionButton(
                                              icon: Icons.arrow_forward,
                                              label: 'Next Word',
                                              color: widget.topic.color,
                                              textColor: Colors.white,
                                              iconColor: Colors.white,
                                              onTap: _nextWord,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      // Navigation buttons
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton.icon(
                                              onPressed: _currentWordIndex > 0
                                                  ? _previousWord
                                                  : null,
                                              icon: const Icon(
                                                Icons.arrow_back,
                                                size: 16,
                                              ),
                                              label: const Text('Previous'),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor:
                                                    widget.topic.color,
                                                side: BorderSide(
                                                  color: widget.topic.color,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            '${_currentWordIndex + 1}/${_vocabularies.length}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF6B7280),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: OutlinedButton.icon(
                                              onPressed:
                                                  _currentWordIndex <
                                                      _vocabularies.length - 1
                                                  ? _nextWord
                                                  : null,
                                              icon: const Icon(
                                                Icons.arrow_forward,
                                                size: 16,
                                              ),
                                              label: const Text('Next'),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor:
                                                    widget.topic.color,
                                                side: BorderSide(
                                                  color: widget.topic.color,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      _ProgressSection(
                                        progress: progress,
                                        color: widget.topic.color,
                                      ),
                                    ],
                                  ),
                                )
                              : const Center(
                                  child: Text('No vocabulary found'),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // ✅ Thêm empty state widget
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.table_chart_outlined,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 24),
            Text(
              'Không có từ vựng',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Sheet "${widget.topic.url}" không có dữ liệu',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Quay lại'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _loadVocabularies,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Thử lại'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.topic.color,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Header Widget
class _Header extends StatelessWidget {
  final VocabTopic topic;
  final int currentWord;
  final int totalWords;
  final VoidCallback onBack;
  final VoidCallback onSettings;

  const _Header({
    required this.topic,
    required this.currentWord,
    required this.totalWords,
    required this.onBack,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        color: topic.color,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: onBack,
              splashRadius: 24,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    topic.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Word $currentWord of $totalWords',
                    style: const TextStyle(
                      color: Color(0xFFDBEAFE),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            Icon(topic.icon, color: Colors.white, size: 22),
          ],
        ),
      ),
    );
  }
}

// Word Card Widget
class _WordCard extends StatelessWidget {
  final String word;
  final String phonetic;
  final String meaning;
  final Color color;

  const _WordCard({
    required this.word,
    required this.phonetic,
    required this.meaning,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 200),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 15,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            word,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 32,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
              letterSpacing: 0.9,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (phonetic.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              phonetic,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 10),
          Text(
            meaning,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
              height: 1.3,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ✅ Cập nhật Example Section - bỏ translation vì Google Sheets không có
class _ExampleSection extends StatelessWidget {
  final String example;
  final Color color;

  const _ExampleSection({required this.example, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.format_quote, color: color, size: 16),
              const SizedBox(width: 8),
              const Text(
                'Example',
                style: TextStyle(
                  color: Color(0xFF1F2937),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '"$example"',
            style: const TextStyle(
              color: Color(0xFF374151),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter',
              height: 1.625,
            ),
          ),
        ],
      ),
    );
  }
}

// Audio Button Widget
class _AudioButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;

  const _AudioButton({required this.onPressed, required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size.fromHeight(60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        shadowColor: const Color(0x1A000000),
      ),
      icon: const Icon(Icons.volume_up, color: Colors.white, size: 25),
      label: const Text(
        'Hear Pronunciation',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
      onPressed: onPressed,
    );
  }
}

// Action Button Widget
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color textColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.textColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 52,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Progress Section Widget
class _ProgressSection extends StatelessWidget {
  final double progress;
  final Color color;

  const _ProgressSection({required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(17),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  color: Color(0xFF4B5563),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}
