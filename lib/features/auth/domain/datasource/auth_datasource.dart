import 'package:cdattg_sena_mobile/config/routes/router_app.dart';
import 'package:cdattg_sena_mobile/features/auth/domain/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuhtDataSource {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final AuthService authService;

  AuhtDataSource({
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.authService,
  });

  Future<void> login(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      final username = usernameController.text;
      final password = passwordController.text;

      final success = await authService.authenticate(username, password);

      if (success == true) {
        // Redirige a la pantalla de inicio usando GoRouter
        routerApp.go('/asistence-scan');
      } else {
        // Muestra un SnackBar de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'error de inicio de sesión',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            duration: const Duration(seconds: 2), // Duración de 3 segundos
          ),
        );
      }
    }
  }

  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
  }
}
