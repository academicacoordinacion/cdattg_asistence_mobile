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
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 70),
                      child: ListTile(
                        leading: Icon(Icons.supervised_user_circle_rounded,
                            color: appColor.primary),
                        title: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text('Iniciar sesión',
                              style: TextStyle(color: appColor.primary)),
                        ),
                        onTap: () {
                          routerApp.go('/login');
                        },
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: appColor.primary,
                        ),
                      )),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    alignment: Alignment.center,
                    child: Text(
                      'AGROINDUSTRIA Y TECNOLOGÍA SENA GUAVIARE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: appColor.primary,
                        fontFamily: 'OpenSans',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
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
