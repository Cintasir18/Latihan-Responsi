
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'services/session_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('cart');

  final String? savedUsername =
      await SessionService.getUsername();

  runApp(
    TokoOnlineApp(initialUsername: savedUsername),
  );
}

class TokoOnlineApp extends StatelessWidget {
  final String? initialUsername;

  const TokoOnlineApp({
    super.key,
    required this.initialUsername,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MOYA Shop',
      theme: AppTheme.light,
      home: initialUsername == null
          ? const LoginScreen()
          : MainScreen(username: initialUsername!),
    );
  }
}
