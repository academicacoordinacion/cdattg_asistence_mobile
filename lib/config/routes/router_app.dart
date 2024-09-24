import 'package:cdattg_sena_mobile/features/asistence-scan/presentation/screen/assistence_out_screen.dart';
import 'package:cdattg_sena_mobile/features/asistence-scan/presentation/screen/instructor_screen.dart.dart';
import 'package:cdattg_sena_mobile/features/asistence-scan/presentation/screen/start_scaner_screen.dart';
import 'package:cdattg_sena_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:cdattg_sena_mobile/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter routerApp = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/asistence-scan',
      builder: (BuildContext context, GoRouterState state) {
        return const InstructorScreen();
      },
    ),
    GoRoute(
      path: '/start-scan',
      builder: (BuildContext context, GoRouterState state) {
        return const StartScanerScreen();
      },
    ),
    GoRoute(
      path: '/instructor-screen',
      builder: (BuildContext context, GoRouterState state) {
        return const InstructorScreen();
      },
    ),
    GoRoute(
      path: '/assistence-out',
      builder: (BuildContext context, GoRouterState state) {
        final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        return AssistenceOutScreen(
          caracterizacionId: extra['caracterizacion_id'] as String,
          numeroIdentificacion: extra['numero_identificacion'] as String,
        );
      },
    ),
    // Agrega más rutas aquí
  ],
);
