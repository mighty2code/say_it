import 'package:say_it/app_router.dart';
import 'package:say_it/constants/app_routes.dart';
import 'package:say_it/presentation/auth/login_screen.dart';
import 'package:say_it/presentation/auth/signup_screen.dart';
import 'package:say_it/presentation/chat_page.dart';
import 'package:say_it/presentation/homepage.dart';
import 'package:say_it/presentation/splash_screen.dart';

class AppPages {
  static List<AppPage> get list => [
    AppPage(name: AppRoutes.splash, pageBuilder: (_) => const SplashScreen()),
    AppPage(name: AppRoutes.login, pageBuilder: (_) => LoginScreen()),
    AppPage(name: AppRoutes.signUp, pageBuilder: (_) => SignUpScreen()),
    AppPage(name: AppRoutes.homePage, pageBuilder: (_) => const HomePage()),
    AppPage(name: AppRoutes.chat, pageBuilder: (_) => const ChatPage()),
  ];
}