import 'package:say_it/constants/app_routes.dart';
import 'package:say_it/presentation/auth/login_screen.dart';
import 'package:say_it/presentation/auth/signup_screen.dart';
import 'package:say_it/presentation/chat_page.dart';
import 'package:say_it/presentation/homepage.dart';
import 'package:say_it/presentation/splash_screen.dart';
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