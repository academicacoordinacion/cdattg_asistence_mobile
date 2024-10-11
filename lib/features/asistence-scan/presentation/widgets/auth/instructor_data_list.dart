// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cdattg_sena_mobile/features/auth/domain/services/auth_service.dart';
import 'package:cdattg_sena_mobile/features/asistence-scan/domain/services/start_scaner_service.dart';
import 'package:dio/dio.dart';
import 'package:cdattg_sena_mobile/config/routes/router_app.dart';

class InstructorDataList extends StatefulWidget {
  final AuthService authService;

  const InstructorDataList({super.key, required this.authService});

  @override
  _InstructorDataListState createState() => _InstructorDataListState();
}

class _InstructorDataListState extends State<InstructorDataList> {
  Map<String, dynamic>? userData;
  Map<String, dynamic>? personData;
  final AuthService auth = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await widget.authService.loadData();
    setState(() {
      userData = widget.authService.getUserData();
      personData = widget.authService.getPersonData();
    });
  }

  Future<void> _startScanner(BuildContext context) async {
    auth.loadData();
    final dio = Dio();
    final startScanerService =
        StartScanerService(authService: widget.authService, dio: dio);

    final data = await startScanerService.fetchDataFromApi();
    print(data);

    if (data != null) {
      // Redirigir a otra pantalla
      routerApp.push('/start-scan');
    } else {
      // Mostrar SnackBar de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Error al iniciar el escáner. Por favor, inténtelo de nuevo.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorApp = Theme.of(context).colorScheme;
    return userData != null && personData != null
        ? ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const SizedBox(
                height: 40,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Correo',
                        style: TextStyle(
                          color: colorApp.primary,
                          fontFamily: 'OpenSans',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        userData!['email'] ?? 'N/A',
                        style: TextStyle(
                          color: colorApp.primary,
                          fontFamily: 'OpenSans',
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Divider(color: colorApp.primary),
                    ListTile(
                      title: Text(
                        'Nombre',
                        style: TextStyle(
                          color: colorApp.primary,
                          fontFamily: 'OpenSans',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        personData!['primer_nombre'] ?? 'N/A',
                        style: TextStyle(
                          color: colorApp.primary,
                          fontFamily: 'OpenSans',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40), // Espacio adicional

              SizedBox(
                width: 60, // Ajusta el ancho según sea necesario
                child: FloatingActionButton(
                  onPressed: () => _startScanner(context),
                  backgroundColor: colorApp.primary,
                  child: const Text(
                    'Iniciar Scaner',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50), // Espacio adicional
              // Agrega más ListTile según sea necesario
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }
}
