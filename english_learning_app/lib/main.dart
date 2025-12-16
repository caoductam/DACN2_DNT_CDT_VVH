import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'config/app_colors.dart';
import 'config/app_routes.dart';
import 'config/theme_manager.dart'; // 1. Import ThemeManager mới tạo

// Import các màn hình
import 'modules/auth/login_screen.dart';
import 'modules/auth/signup_screen.dart';
import 'modules/onboarding/onboarding_screen.dart';
import 'modules/home/home_screen.dart';
import 'modules/vocabulary/vocab_screen.dart';
import 'modules/grammar/grammar_screen.dart';
import 'modules/listening/listening_screen.dart';
import 'modules/speaking/speaking_screen.dart';
import 'modules/reading/reading_screen.dart';
import 'modules/writing/writing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Bọc MaterialApp bằng ValueListenableBuilder để lắng nghe thay đổi theme
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeManager().themeMode,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: 'English Learning App',
          debugShowCheckedModeBanner: false,

          // --- CẤU HÌNH GIAO DIỆN SÁNG (LIGHT) ---
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: AppColors.background, // Màu trắng
            fontFamily: 'Poppins',
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black, // Màu chữ AppBar
            ),
          ),

          // --- CẤU HÌNH GIAO DIỆN TỐI (DARK) ---
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: const Color(0xFF121212), // Màu nền đen xám
            fontFamily: 'Poppins',
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E1E1E),
              foregroundColor: Colors.white,
            ),
            // Tự động đổi màu chữ
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
            ),
          ),

          // 3. Chế độ hiện tại (Sáng hay Tối do ThemeManager quyết định)
          themeMode: currentMode,

          initialRoute: AppRoutes.home,

          routes: {
            AppRoutes.onboarding: (context) => const OnboardingScreen(),
            AppRoutes.login: (context) => const LoginScreen(),
            AppRoutes.signUp: (context) => const SignUpScreen(),
            AppRoutes.home: (context) => const HomeScreen(),
            AppRoutes.vocabulary: (context) => const VocabScreen(),
            AppRoutes.grammar: (context) => const GrammarTopicsScreen(),
            AppRoutes.listening: (context) => const ListeningScreen(),
            AppRoutes.speaking: (context) => const SpeakingScreen(),
            AppRoutes.reading: (context) => const ReadingScreen(),
            AppRoutes.writing: (context) => const WritingScreen(),
          },
        );
      },
    );
  }
}
