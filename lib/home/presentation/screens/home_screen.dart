import 'package:cdattg_sena_mobile/config/routes/router_app.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorApp = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('CDTTGA MOBILE', style: TextStyle(color: colorApp.primary)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.supervised_user_circle, size: 50),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                routerApp.go('/login'); // Go to Login
              },
              child: const Text('Inciar sesión'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        // Set secondary background color
        child: SizedBox(
          height: 50,
          child: Center(
            child: Text(
              'AGROIDUSTRIA Y TECNOLOGÍA',
              style: TextStyle(),
            ),
          ),
        ),
      ),
    );
  }
}
