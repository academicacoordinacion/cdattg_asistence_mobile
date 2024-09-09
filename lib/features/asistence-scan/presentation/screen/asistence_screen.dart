import 'package:cdattg_sena_mobile/config/routes/router_app.dart';
import 'package:flutter/material.dart';

class AsistenceScreen extends StatelessWidget {
  const AsistenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorApp = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Datos del instructor',
          style: TextStyle(
            color: Colors.teal,
            fontSize: 20,
            fontFamily: 'OpenSans',
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: IconButton(
              icon: Icon(Icons.logout_rounded, color: colorApp.primary),
              onPressed: () {
                routerApp.go('/');
              },
            ),
          ),
        ],
      ),
    );
  }
}
