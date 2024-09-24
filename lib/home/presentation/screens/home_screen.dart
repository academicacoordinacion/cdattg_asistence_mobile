import 'package:cdattg_sena_mobile/config/routes/router_app.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appColor = Theme.of(context).colorScheme;
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
              ),
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 55, vertical: 40),
          child: Center(
            child: Column(
              children: [
                Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqNShshQtVwuUvPYKggWuexaA2qArJwN495qs2j7CF0aYeIOl3vhkCka-EJOfouEfZFnc&usqp=CAU',
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
                    onPressed: () {
                      routerApp.go('/login');
                    },
                  ),
                ),
                const Spacer(),
                Center(
                  child: Container(
                    height: 70,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Agroindustria y Tecnología Guaviare',
                      style: TextStyle(
                        color: appColor.primary,
                        fontFamily: 'OpenSans',
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
