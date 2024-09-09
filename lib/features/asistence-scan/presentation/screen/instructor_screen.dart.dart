import 'package:cdattg_sena_mobile/config/routes/router_app.dart';
import 'package:cdattg_sena_mobile/features/asistence-scan/presentation/widgets/auth/instructor_data_list.dart';
import 'package:cdattg_sena_mobile/features/auth/domain/services/auth_service.dart';
import 'package:flutter/material.dart';

class InstructorScreen extends StatelessWidget {
  const InstructorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorApp = Theme.of(context).colorScheme;
    final authService = AuthService(); // Crear una instancia de AuthService

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Datos del instructor',
          style: TextStyle(
            color: colorApp.primary,
            fontSize: 20,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: IconButton(
              icon: Icon(Icons.logout_rounded, color: colorApp.primary),
              onPressed: () async {
                await authService
                    .logout(); // Llamar al método de logout en AuthService
                routerApp.go('/'); // Redirigir al usuario a la ruta de inicio
              },
            ),
          ),
        ],
      ),
      body: InstructorDataList(authService: authService),
    );
  }
}
