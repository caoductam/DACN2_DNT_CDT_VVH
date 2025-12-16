import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/theme_manager.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import 'edit_profile_screen.dart';
import 'payment_screen.dart';
import 'help_center_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  
  // Dữ liệu hiển thị (Khởi tạo giá trị mặc định để không bị lỗi null)
  String _userName = "User";
  String _email = "";
  String _avatarUrl = "";
  
  // Trạng thái
  bool _isBackendLoading = false; // Chỉ dùng để hiện thanh loading nhỏ, không chặn UI
  bool _notificationsEnabled = true;
  String _currentLanguage = "English (US)";

  @override
  void initState() {
    super.initState();
    _initProfileData();
  }

  // Hàm khởi tạo dữ liệu tối ưu
  void _initProfileData() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    
    // 1. HIỆN NGAY LẬP TỨC dữ liệu từ Firebase (Local cache)
    if (firebaseUser != null) {
      if (mounted) {
        setState(() {
          _email = firebaseUser.email ?? "";
          _userName = firebaseUser.displayName ?? "User";
          _avatarUrl = firebaseUser.photoURL ?? "";
        });
      }
    }

    // 2. Gọi Backend lấy dữ liệu chi tiết (Chạy ngầm)
    if (mounted) setState(() => _isBackendLoading = true);
    
    try {
      final userData = await _userService.getUserProfile();
      
      if (mounted && userData != null) {
        setState(() {
          // Ưu tiên dữ liệu từ MongoDB nếu có
          if (userData['username'] != null) _userName = userData['username'];
          if (userData['avatar'] != null && userData['avatar'].toString().isNotEmpty) {
            _avatarUrl = userData['avatar'];
          }
        });
      }
    } catch (e) {
      print("Lỗi tải profile backend: $e");
    } finally {
      if (mounted) setState(() => _isBackendLoading = false);
    }
  }

  void _navigateToEdit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          currentName: _userName, 
          currentAvatar: _avatarUrl
        ),
      ),
    );
    
    // Nếu có chỉnh sửa, load lại dữ liệu
    if (result == true) {
      _initProfileData();
    }
  }

  void _showLanguageSelector(Color textColor, Color backgroundColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select Language", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 16),
              _buildLanguageItem("English (US)", "🇺🇸", textColor),
              _buildLanguageItem("Tiếng Việt", "🇻🇳", textColor),
              _buildLanguageItem("Français", "🇫🇷", textColor),
              _buildLanguageItem("日本語 (Japanese)", "🇯🇵", textColor),
              _buildLanguageItem("Español", "🇪🇸", textColor),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageItem(String language, String flag, Color textColor) {
    return InkWell(
      onTap: () {
        setState(() => _currentLanguage = language);
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 16),
            Text(
              language, 
              style: TextStyle(
                fontSize: 16, 
                fontWeight: _currentLanguage == language ? FontWeight.bold : FontWeight.normal,
                color: _currentLanguage == language ? AppColors.primary : textColor
              )
            ),
            const Spacer(),
            if (_currentLanguage == language)
              const Icon(Icons.check, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeManager().themeMode.value == ThemeMode.dark;
    Color textColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textPrimary;
    Color scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Column(
        children: [
          // Hiển thị thanh loading nhỏ xíu ở trên cùng nếu đang tải ngầm (không chặn UI)
          if (_isBackendLoading)
            const LinearProgressIndicator(minHeight: 2, color: AppColors.primary, backgroundColor: Colors.transparent),
            
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      "My Profile", 
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)
                    )
                  ),
                  const SizedBox(height: 30),
                  
                  // Avatar Section
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 4)),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: _avatarUrl.isNotEmpty 
                              ? NetworkImage(_avatarUrl) as ImageProvider 
                              : const AssetImage('assets/images/avatar_placeholder.png'),
                          onBackgroundImageError: (_, __) {},
                        ),
                      ),
                      Positioned(
                        bottom: 0, right: 0,
                        child: GestureDetector(
                          onTap: _navigateToEdit,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
                            child: const Icon(Icons.edit, color: Colors.white, size: 20),
                          ),
                        ),
                      )
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Tên và Email (Luôn hiển thị ngay lập tức)
                  Text(_userName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 4),
                  Text(_email, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                  
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 140, height: 40,
                    child: ElevatedButton(
                      onPressed: _navigateToEdit,
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), elevation: 0),
                      child: const Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // MENU OPTIONS
                  _buildSectionTitle("General", textColor),
                  const SizedBox(height: 10),
                  _buildMenuOption(
                    icon: Icons.person_outline_rounded, 
                    title: "Personal Data", 
                    color: Colors.blue, 
                    textColor: textColor,
                    onTap: _navigateToEdit // Bấm vào đây cũng mở trang Edit
                  ),
                  
                  _buildMenuOption(
                    icon: Icons.payment_rounded, 
                    title: "Payment", 
                    color: Colors.orange, 
                    textColor: textColor,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentScreen())),
                  ),
                  
                  _buildMenuOption(
                    icon: Icons.notifications_none_rounded,
                    title: "Notifications",
                    color: Colors.purple,
                    textColor: textColor,
                    trailing: Switch(
                      value: _notificationsEnabled, 
                      onChanged: (val) => setState(() => _notificationsEnabled = val),
                      activeColor: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 24),
                  _buildSectionTitle("Preferences", textColor),
                  const SizedBox(height: 10),
                  
                  _buildMenuOption(
                    icon: Icons.language_rounded,
                    title: "Language",
                    color: Colors.teal,
                    textColor: textColor,
                    trailingText: _currentLanguage,
                    onTap: () => _showLanguageSelector(textColor, scaffoldBg),
                  ),
                  
                  _buildMenuOption(
                    icon: Icons.dark_mode_outlined,
                    title: "Dark Mode",
                    color: Colors.indigo,
                    textColor: textColor,
                    trailing: Switch(
                      value: isDarkMode, 
                      onChanged: (val) => ThemeManager().toggleTheme(val),
                    ),
                  ),
                  
                  _buildMenuOption(
                    icon: Icons.help_outline_rounded,
                    title: "Help Center",
                    color: Colors.green,
                    textColor: textColor,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpCenterScreen())),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  TextButton(
                    onPressed: () async {
                      // Đăng xuất an toàn
                      try { await AuthService().signOut(); } catch (_) {}
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
                      }
                    },
                    child: const Text("Log Out", style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return Align(alignment: Alignment.centerLeft, child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)));
  }

  Widget _buildMenuOption({
    required IconData icon, 
    required String title, 
    required Color color, 
    required Color textColor, 
    Widget? trailing, 
    String? trailingText, 
    VoidCallback? onTap
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(width: 48, height: 48, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 24)),
        title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor)),
        trailing: trailing ?? (trailingText != null ? Row(mainAxisSize: MainAxisSize.min, children: [Text(trailingText, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)), const SizedBox(width: 8), const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey)]) : const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey)),
        onTap: onTap,
      ),
    );
  }
}