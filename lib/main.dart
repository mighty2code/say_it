import 'package:say_it/app_pages.dart';
import 'package:say_it/constants/app_routes.dart';
import 'package:say_it/data/local/shared_prefs.dart';
import 'package:say_it/data/remote/firebase/firebase_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseClient.initSDK();
  SharedPrefs.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.list
    );
  }
}