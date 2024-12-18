import 'package:cdattg_sena_mobile/config/routes/router_app.dart';
import 'package:cdattg_sena_mobile/features/auth/domain/domain.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final appColor = Theme.of(context).colorScheme;
    final AuthService authService = AuthService();

    /*void verificate() {
      if (authService.getToken() == null) {
        return routerApp.go('/login');
      }

      return routerApp.go('/instructor-screen');
    }*/

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'CDATTG MOBILE',
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 22,
                  color: appColor.primary,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 55, vertical: 50),
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo_sena.png',
                  height: 100,
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(
                      vertical: 150), // Increased vertical margin
                  child: ElevatedButton.icon(
                      icon: Icon(Icons.supervised_user_circle_rounded,
                          color: appColor.onPrimary),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Iniciar sesión',
                            style: TextStyle(color: appColor.onPrimary)),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            appColor.primary, // Set the background color
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        bool authenticate = await authService.isAuthenticated();
                        if (authenticate == true) {
                          return routerApp.go('/instructor-screen');
                        }

                        return routerApp.go('/login');
                      }),
                ),
                const Spacer(),
                Center(
                  child: Container(
                    height: 70,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        'Agroindustria y Tecnología SENA Guaviare',
                        textAlign: TextAlign.center, // Center the text
                        style: TextStyle(
                          fontSize: 18,
                          color: appColor.primary,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
