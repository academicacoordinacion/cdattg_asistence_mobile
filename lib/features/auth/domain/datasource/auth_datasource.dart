import 'package:cdattg_sena_mobile/config/routes/router_app.dart';
import 'package:cdattg_sena_mobile/features/auth/domain/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AuhtDataSource {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final AuthService authService;

  AuhtDataSource({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.authService,
  });

  Future<void> login(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      final email = emailController.text;
      final password = passwordController.text;

      try {
        final success = await authService.authenticate(email, password);
        print(success);
        print('hola');

        if (success == true) {
          print('Email: $email, Password: $password');
          // Redirige a la pantalla de inicio usando GoRouter
          if (context.mounted) {
            routerApp.go('/asistence-scan');
          }
        } else {
          // Muestra un SnackBar de error
          _showErrorSnackBar(context, 'Error de inicio de sesión');
        }
      } on DioException catch (dioError) {
        // Maneja errores específicos de Dio
        _showErrorSnackBar(
            context, 'Error de red con Dio: ${dioError.message}');
      } catch (e) {
        // Maneja cualquier otra excepción que ocurra durante la autenticación
        _showErrorSnackBar(context, 'Error de red: ${e.toString()}');
      }
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          // Duración de 2 segundos
        ),
      );
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
