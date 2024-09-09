import 'package:cdattg_sena_mobile/config/routes/router_app.dart';
import 'package:cdattg_sena_mobile/features/auth/domain/services/auth_servive.dart';
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
          const SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    }
  }

  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
  }
}
