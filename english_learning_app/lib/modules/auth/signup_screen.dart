import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../services/auth_service.dart';

// --- ĐÃ SỬA TÊN CLASS THÀNH SignUpScreen ---
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    // Gọi hàm đăng ký (Trả về bool: true nếu thành công)
    final bool success = await _authService.signUpWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _nameController.text.trim(),
      context
    );

    if (mounted) {
      setState(() => _isLoading = false);
      
      if (success) {
        // --- THÀNH CÔNG: Chuyển về màn hình Login ---
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account created! Please login."),
            backgroundColor: Colors.green,
          )
        );
        // Quay lại màn hình Login (Vì SignUp thường được push từ Login)
        Navigator.pop(context); 
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                
                // Header Image
                Container(
                  width: 150, height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, 
                    color: Colors.grey[200], 
                    image: const DecorationImage(
                      image: AssetImage('assets/images/login_illustration.png'), 
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                const Text("Create Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary, letterSpacing: -0.5)),
                const SizedBox(height: 8),
                const Text("Sign up to get started!", style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),

                const SizedBox(height: 30),

                // Form Inputs
                _buildLabel("Full Name"),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _nameController,
                  hintText: "Enter your full name",
                  icon: Icons.person_outline_rounded,
                ),
                
                const SizedBox(height: 16),
                _buildLabel("Email"),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _emailController,
                  hintText: "Enter your email",
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),
                _buildLabel("Password"),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _passwordController,
                  hintText: "Create a password",
                  isPassword: true,
                  isVisible: _isPasswordVisible,
                  onVisibilityToggle: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),

                const SizedBox(height: 30),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                    ),
                    child: _isLoading 
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                      : const Text("Sign Up", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),

                const SizedBox(height: 24),
                
                const Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("or sign up with", style: TextStyle(color: Color(0xFF9E9E9E)))), Expanded(child: Divider())]),
                const SizedBox(height: 24),

                // Social Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildSocialButton(
                        text: "Google",
                        imagePath: 'assets/images/icon_google.png',
                        onTap: () async {
                          // Với Google, đăng nhập thành công thì vào Home luôn
                          final user = await _authService.signInWithGoogle(context);
                          if (user != null && mounted) {
                            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSocialButton(
                        text: "Facebook",
                        imagePath: 'assets/images/icon_facebook.png',
                        onTap: () async {
                          final user = await _authService.signInWithFacebook(context);
                          if (user != null && mounted) {
                            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? ", style: TextStyle(color: AppColors.textSecondary, fontSize: 15)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text("Login", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Align(alignment: Alignment.centerLeft, child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)));

  Widget _buildTextField({required String hintText, TextEditingController? controller, IconData? icon, bool isPassword = false, bool isVisible = false, VoidCallback? onVisibilityToggle, TextInputType? keyboardType}) {
    return Container(
      decoration: BoxDecoration(color: AppColors.inputBackground, borderRadius: BorderRadius.circular(16)),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isVisible,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.inputHint),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          suffixIcon: isPassword ? IconButton(icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off_outlined, color: Colors.grey), onPressed: onVisibilityToggle) : Icon(icon, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildSocialButton({required String text, required String imagePath, required VoidCallback onTap}) {
    return Container(
      height: 56,
      decoration: BoxDecoration(border: Border.all(color: AppColors.borderColor), borderRadius: BorderRadius.circular(16), color: Colors.white),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 24, width: 24, errorBuilder: (context, error, stackTrace) => const Icon(Icons.error_outline, color: Colors.red)),
            const SizedBox(width: 12),
            Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}