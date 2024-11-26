import 'package:cdattg_sena_mobile/config/routes/router_app.dart';
import 'package:cdattg_sena_mobile/config/theme/theme_app.dart';
import 'package:cdattg_sena_mobile/features/auth/domain/domain.dart';
// import 'package:cdattg_sena_mobile/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    //   return FutureBuilder<bool>(
    //     future: authService.isAuthenticated(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const CircularProgressIndicator(); // Mostrar un indicador de carga mientras se verifica la autenticación
    //       } else {
    //         final bool isLoggedIn = snapshot.data ?? false;
    //         final routerConfig = isLoggedIn ? routerApp : routerApp;

    //         return MaterialApp.router(
    //           debugShowCheckedModeBanner: false,
    //           routerConfig: routerConfig,
    //           theme: ThemeApp(colorSelector: 0).themeData,
    //         );
    //       }
    //     },
    //   );
    // }
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: routerApp,
      theme: ThemeApp(colorSelector: 0).themeData,
    );
  }
}
