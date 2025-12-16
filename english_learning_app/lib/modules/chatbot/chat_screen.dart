import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../config/app_colors.dart'; // Import để dùng màu chung của App

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // --- CẤU HÌNH ---
  // Thay API Key của bạn vào đây
  static const String _apiKey = 'AIzaSyD2sOU2dJVDWjsP2tmbXaSmkA6mow3A8wc'; 
  
  // Model Name: Sử dụng gemini-1.5-flash (bản 2.5 chưa khả dụng public)
  static const String _modelName = 'gemini-1.5-flash';

  // Cấu hình User
  final ChatUser _currentUser = ChatUser(id: '1', firstName: 'Huy');
  final ChatUser _geminiUser = ChatUser(
    id: '2',
    firstName: 'AI Tutor',
    profileImage: 'https://www.gstatic.com/lamda/images/gemini_sparkle_v002_d4735304ff6292a690345.svg', // Logo Gemini chính gốc
  );

  List<ChatMessage> _messages = [];
  late final GenerativeModel _model;
  late ChatSession _chat; // Bỏ final để có thể gán lại khi reset
  bool _isTyping = false;

  // System prompt định hướng AI
  final String _systemPrompt = '''
  Bạn là trợ lý AI thông minh hỗ trợ học tiếng Anh. Nhiệm vụ của bạn:
  - Tư vấn phương pháp học phù hợp với trình độ người dùng
  - Giải đáp ngữ pháp, từ vựng
  - Đề xuất bài học, lộ trình học
  - Động viên và khuyến khích người học
  - Trả lời ngắn gọn, dễ hiểu, thân thiện
  - Nếu người dùng hỏi bằng tiếng Việt, trả lời bằng tiếng Việt

  Hãy luôn:
  ✓ Thân thiện và nhiệt tình
  ✓ Giải thích đơn giản, dễ hiểu
  ✓ Đưa ra ví dụ cụ thể
  ✓ Khuyến khích người học
  ✓ Cá nhân hóa lời khuyên theo trình độ

  Tránh:
  ✗ Trả lời quá dài dòng
  ✗ Sử dụng thuật ngữ phức tạp
  ✗ Phê phán hay chỉ trích người học
  ''';

  @override
  void initState() {
    super.initState();
    _initGemini();
  }

  void _initGemini() {
    try {
      // Khởi tạo model
      _model = GenerativeModel(
        model: _modelName,
        apiKey: _apiKey,
        systemInstruction: Content.system(_systemPrompt),
      );

      // Khởi tạo chat session
      _chat = _model.startChat();

      // Gửi tin nhắn chào mừng (chỉ thêm nếu danh sách trống)
      if (_messages.isEmpty) {
        _addWelcomeMessage();
      }
    } catch (e) {
      print("Lỗi khởi tạo Gemini: $e");
    }
  }

  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      user: _geminiUser,
      createdAt: DateTime.now(),
      text: '''Xin chào! 👋 Tôi là trợ lý AI giúp bạn học tiếng Anh. 

Tôi có thể giúp bạn:
📚 Tư vấn lộ trình học
💬 Giải thích ngữ pháp, từ vựng 
✍️ Đề xuất bài tập
🎯 Trả lời mọi thắc mắc

Bạn muốn bắt đầu từ đâu? 😊''',
    );

    setState(() {
      _messages = [welcomeMessage];
    });
  }

  // --- HÀM XỬ LÝ TIN NHẮN ---
  Future<void> _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      _messages = [chatMessage, ..._messages];
      _isTyping = true; // Hiển thị hiệu ứng đang gõ
    });

    try {
      // Gửi tin nhắn kèm context cũ
      final response = await _chat.sendMessage(Content.text(chatMessage.text));
      final textResponse = response.text;

      if (textResponse != null) {
        ChatMessage geminiMessage = ChatMessage(
          user: _geminiUser,
          createdAt: DateTime.now(),
          text: textResponse,
        );

        setState(() {
          _messages = [geminiMessage, ..._messages];
        });
      }
    } catch (e) {
      debugPrint("Lỗi Gemini: $e");
      
      ChatMessage errorMessage = ChatMessage(
        user: _geminiUser,
        createdAt: DateTime.now(),
        text: "Xin lỗi, tôi đang gặp chút vấn đề kết nối. Bạn vui lòng kiểm tra mạng hoặc hỏi lại sau nhé! 😓",
      );

      setState(() {
        _messages = [errorMessage, ..._messages];
      });
    } finally {
      setState(() {
        _isTyping = false; // Tắt hiệu ứng đang gõ
      });
    }
  }

  // --- HÀM RESET CHAT ---
  void _resetChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bắt đầu lại?'),
        content: const Text('Hội thoại hiện tại sẽ bị xóa. Bạn có chắc chắn không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _messages.clear(); // Xóa tin nhắn cũ
                _isTyping = false;
              });
              // Khởi tạo lại session mới để quên context cũ
              _chat = _model.startChat();
              _addWelcomeMessage();
              Navigator.pop(context);
            },
            child: const Text('Đồng ý', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // --- GIAO DIỆN ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Nền trắng sạch
      appBar: AppBar(
        title: const Text(
          'AI English Tutor',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary, // Dùng màu chủ đạo của App
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Làm mới cuộc hội thoại',
            onPressed: _resetChat,
          ),
        ],
      ),
      body: Column(
        children: [
          // Gợi ý nhanh
          _buildQuickReplies(),
          
          // Khung chat
          Expanded(
            child: DashChat(
              currentUser: _currentUser,
              typingUsers: _isTyping ? [_geminiUser] : [],
              onSend: _sendMessage,
              messages: _messages,
              inputOptions: InputOptions(
                inputDecoration: InputDecoration(
                  hintText: 'Ask me anything about English...',
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                alwaysShowSend: true,
                sendButtonBuilder: (onSend) => IconButton(
                  icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                  onPressed: onSend,
                ),
              ),
              messageOptions: const MessageOptions(
                currentUserContainerColor: AppColors.primary,
                containerColor: Color(0xFFF2F4F7), // Màu xám nhạt cho AI
                textColor: Colors.black87,
                currentUserTextColor: Colors.white,
                showOtherUsersAvatar: true,
                avatarBuilder: _buildAvatar, // Custom Avatar đẹp hơn
                timeFontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget gợi ý nhanh (Chips)
  Widget _buildQuickReplies() {
    final suggestions = [
      '📚 Lộ trình học',
      '💬 Luyện phát âm',
      '✍️ Sửa lỗi ngữ pháp',
      '📖 Từ vựng IELTS',
    ];

    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ActionChip(
            label: Text(suggestions[index], style: const TextStyle(fontSize: 12, color: AppColors.primary)),
            backgroundColor: AppColors.primary.withOpacity(0.1),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              final message = ChatMessage(
                user: _currentUser,
                createdAt: DateTime.now(),
                text: suggestions[index],
              );
              _sendMessage(message);
            },
          );
        },
      ),
    );
  }
}

// Hàm render Avatar để xử lý ảnh lỗi
Widget _buildAvatar(ChatUser user, Function? onPress, Function? onLongPress) {
  return Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: CircleAvatar(
      radius: 16,
      backgroundColor: Colors.transparent,
      backgroundImage: NetworkImage(user.profileImage ?? ''),
      onBackgroundImageError: (_, __) {},
      child: user.profileImage == null 
        ? const Icon(Icons.smart_toy_rounded, color: AppColors.primary) 
        : null,
    ),
  );
}