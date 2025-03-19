import 'package:chat_app/constants/app_routes.dart';
import 'package:chat_app/presentation/auth/login_screen.dart';
import 'package:chat_app/presentation/auth/signup_screen.dart';
import 'package:chat_app/presentation/chat_page.dart';
import 'package:chat_app/presentation/homepage.dart';
import 'package:chat_app/presentation/splash_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static List<GetPage> get list => [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.login, page: () => LoginScreen()),
    GetPage(name: AppRoutes.signUp, page: () => SignUpScreen()),
    GetPage(name: AppRoutes.homePage, page: () => const HomePage()),
    // GetPage(name: AppRoutes.chat, page: () => const ChatPage()),
  ];
}