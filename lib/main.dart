import 'package:cdattg_sena_mobile/config/routes/router_app.dart';
import 'package:cdattg_sena_mobile/config/theme/theme_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(
      fileName: ".env"); // Load environment variables from .env file
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: routerApp,
        theme: ThemeApp(colorSelector: 0).themeData);
  }
}
