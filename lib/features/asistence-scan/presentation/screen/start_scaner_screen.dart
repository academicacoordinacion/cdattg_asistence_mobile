// ignore_for_file: library_private_types_in_public_api, unused_element, use_build_context_synchronously, empty_catches

import 'package:cdattg_sena_mobile/config/routes/router_app.dart';
import 'package:flutter/material.dart';
import 'package:cdattg_sena_mobile/features/auth/domain/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'attendance_screen.dart';
import 'package:cdattg_sena_mobile/features/asistence-scan/domain/services/services.dart';

class StartScanerScreen extends StatefulWidget {
  const StartScanerScreen({super.key});

  @override
  _StartScanerScreenState createState() => _StartScanerScreenState();
}

class _StartScanerScreenState extends State<StartScanerScreen> {
  final StartScanerService startScanerService = StartScanerService(
    authService: AuthService(),
    dio: Dio(),
  );

  List<dynamic>? scanerData;
  Map<int, bool> selectedItems = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await startScanerService.getDataFromPreferences();
    if (data != null) {
      setState(() {
        scanerData = data;
        selectedItems = {for (var item in data) item['id']: false};
      });
    } else {
      final apiData = await startScanerService.fetchDataFromApi();
      if (apiData != null) {
        setState(() {
          scanerData = apiData;
          selectedItems = {for (var item in apiData) item['id']: false};
        });
      }
    }
  }

  Future<void> _saveSelectedItems() async {
    if (scanerData != null) {
      final selectedData = scanerData!
          .where((item) => selectedItems[item['id']] == true)
          .toList();
      if (selectedData.isNotEmpty) {
        final dio = Dio();
        final response = await dio.post(
          'http://10.0.2.2:8000/api/saveSelectedItems',
          data: selectedData,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Datos guardados exitosamente.'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al guardar los datos.'),
            ),
          );
        }
      }
    }
  }

  void _navigateToAttendanceScreen(dynamic selectedBoxData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AttendanceScreen(selectedBoxData: selectedBoxData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Caracterización',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontFamily: 'OpenSans',
            fontSize: 22,
          ),
        ),
      ),
      body: scanerData == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: ListView.builder(
                      itemCount: scanerData!.length,
                      itemBuilder: (context, index) {
                        final item = scanerData![index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              CheckboxListTile(
                                title: Text(
                                  item['programa_formacion'] ?? 'N/A',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontFamily: 'OpenSans',
                                    fontSize: 17,
                                  ),
                                ),
                                subtitle: Text(
                                  'Caracterizacion: ${item['id']}\nFicha: ${item['ficha'] ?? 'N/A'}\nInstructor: ${item['persona'] ?? 'N/A'}\nJornada: ${item['jornada'] ?? 'N/A'}\nSede: ${item['sede'] ?? 'N/A'}\n',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                value: selectedItems[item['id']],
                                onChanged: (bool? value) {
                                  setState(() {
                                    selectedItems[item['id']] = value!;
                                  });
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () =>
                                          _navigateToAttendanceScreen(item),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        textStyle: const TextStyle(
                                          fontFamily: 'OpenSans',
                                          fontSize: 16,
                                        ),
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Tomar Asistencia'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        ConsultList consultList = ConsultList();
                                        try {
                                          List<dynamic> attendanceList =
                                              await consultList.getList(
                                                  item['ficha'].toString(),
                                                  item['jornada'].toString());

                                          if (attendanceList.isNotEmpty) {
                                            // Redirigir a la pantalla PreviewList con la lista de asistencia
                                            routerApp.push('/list-consult',
                                                extra: attendanceList);
                                          } else {}
                                        } catch (e) {}
                                      },
                                      child: const Text('Novedades'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Agroindustria y Tecnología Guaviare',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontFamily: 'OpenSans',
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
    );
  }
}
