import 'package:say_it/app_router.dart';
import 'package:say_it/constants/app_colors.dart';
import 'package:say_it/constants/app_routes.dart';
import 'package:say_it/constants/constants.dart';
import 'package:say_it/data/local/shared_prefs.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      if(SharedPrefs.getBool(SharedPrefsKeys.isLoggedIn) ?? false) {
        AppRouter.pushReplacementNamed(AppRoutes.homePage);
      } else {
        AppRouter.pushReplacementNamed(AppRoutes.login);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: AppColors.appColor.shade400,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(AppConfig.name, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(width: 5),
            Icon(Icons.emoji_emotions_outlined, size: 30, color: AppColors.yellow),
          ],
        ),
      ),
    );
  }
}