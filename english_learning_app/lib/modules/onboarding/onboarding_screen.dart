import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Controller để quản lý việc vuốt trang
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // Dữ liệu giả lập cho 3 màn hình Onboarding
  final List<Map<String, String>> _onboardingData = [
    {
      "image": "assets/images/onboarding_1.png",
      "title": "Learn New Words",
      "subtitle":
          "Master thousands of vocabulary words with interactive flashcards and fun exercises",
    },
    {
      "image": "assets/images/onboarding_2.png",
      "title": "Practice Daily",
      "subtitle":
          "Consistent practice is the key to success. Keep your streak alive!",
    },
    {
      "image": "assets/images/onboarding_3.png",
      "title": "Master Grammar",
      "subtitle":
          "Understand complex grammar rules with simple explanations and examples.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. NÚT SKIP (Góc phải) ---
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _completeOnboarding,
                child: const Text(
                  "Skip",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // --- 2. PAGE VIEW (Ảnh + Text trượt) ---
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildOnboardingContent(
                    image: _onboardingData[index]["image"]!,
                    title: _onboardingData[index]["title"]!,
                    subtitle: _onboardingData[index]["subtitle"]!,
                  );
                },
              ),
            ),

            // --- 3. INDICATOR & BUTTON ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  // Các chấm tròn (Indicator)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => _buildDot(index),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Nút NEXT to đẹp
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentIndex == _onboardingData.length - 1) {
                          // Nếu ở trang cuối thì vào Home
                          _completeOnboarding();
                        } else {
                          // Nếu chưa cuối thì next trang tiếp
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.onboardingPrimary, // Màu tím
                        elevation: 8,
                        shadowColor: AppColors.onboardingPrimary.withOpacity(
                          0.4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        _currentIndex == _onboardingData.length - 1
                            ? "Get Started"
                            : "Next",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HÀM CHUYỂN SANG HOME (ĐÃ SỬA) ---
  void _completeOnboarding() {
    // Sửa AppRoutes.login thành AppRoutes.home
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  // Widget nội dung từng trang
  Widget _buildOnboardingContent({
    required String image,
    required String title,
    required String subtitle,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Ảnh minh họa
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Image.asset(
              image,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image, size: 100, color: Colors.grey),
            ),
          ),
        ),

        // Text nội dung
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget chấm tròn tùy chỉnh
  Widget _buildDot(int index) {
    bool isActive = _currentIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.onboardingPrimary : AppColors.dotInactive,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}