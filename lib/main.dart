import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pretty_bloc_observer/pretty_bloc_observer.dart';
import 'package:say_it/app_router.dart';
import 'package:say_it/constants/app_routes.dart';
import 'package:say_it/data/local/shared_prefs.dart';
import 'package:say_it/data/remote/firebase/firebase_client.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseClient.initSDK();
  SharedPrefs.init();
  Bloc.observer = PrettyBlocObserver();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppRouter.navigatorKey,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRoutes.splash,
      debugShowCheckedModeBanner: false,
    );
  }
}