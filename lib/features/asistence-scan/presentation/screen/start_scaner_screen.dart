// ignore_for_file: library_private_types_in_public_api, empty_catches

import 'package:cdattg_sena_mobile/config/routes/router_app.dart';
import 'package:cdattg_sena_mobile/features/asistence-scan/helpers/exit_data.dart';
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
  final ExitData exitData = ExitData();
  final ExitData _exitData = ExitData();

  List<dynamic>? scanerData;
  List<dynamic>? filteredData;
  Map<int, bool> selectedItems = {};
  final TextEditingController _filterController = TextEditingController();

  @override
  /*
   * Método que se llama cuando el widget se inserta en el árbol de widgets.
   * Sobrescribe el método initState de la clase State.
   * Llama al método _loadData para cargar los datos necesarios.
   */
  void initState() {
    super.initState();
    _loadData();
  }

  /*
   * Carga los datos necesarios para la pantalla del escáner.
   * 
   * Este método intenta obtener los datos almacenados en las preferencias del usuario.
   * Si los datos están disponibles, actualiza el estado con estos datos.
   * Si no hay datos en las preferencias, intenta obtener los datos desde una API.
   * 
   * Actualiza las siguientes variables de estado:
   * - scanerData: Los datos del escáner obtenidos.
   * - filteredData: Los mismos datos del escáner para ser filtrados.
   * - selectedItems: Un mapa de elementos seleccionados, inicializado con todos los elementos no seleccionados.
   * 
   * @return Future<void> Un futuro que se completa cuando los datos han sido cargados.
   */
  Future<void> _loadData() async {
    final data = await startScanerService.getDataFromPreferences();
    if (data != null) {
      setState(() {
        scanerData = data;
        filteredData = data;
        selectedItems = {for (var item in data) item['id']: false};
      });
    } else {
      final apiData = await startScanerService.fetchDataFromApi();
      if (apiData != null) {
        setState(() {
          scanerData = apiData;
          filteredData = apiData;
          selectedItems = {for (var item in apiData) item['id']: false};
        });
      }
    }
  }

  /*
   * Filtra los datos de `scanerData` según la consulta proporcionada.
   * 
   * Este método actualiza el estado de `filteredData` con los elementos de `scanerData`
   * que contienen la consulta proporcionada en el campo 'ficha'.
   * 
   * @param query La cadena de texto utilizada para filtrar los datos.
   */
  void _filterData(String query) {
    setState(() {
      filteredData = scanerData?.where((item) {
        final ficha = item['ficha'].toString().toLowerCase();
        final input = query.toLowerCase();
        return ficha.contains(input);
      }).toList();
    });
  }

  /*
   * Navega a la pantalla de asistencia.
   *
   * Este método utiliza el `Navigator` para empujar una nueva ruta a la pila de navegación,
   * llevando al usuario a la pantalla de asistencia (`AttendanceScreen`).
   *
   * @param selectedBoxData Los datos seleccionados que se pasarán a la pantalla de asistencia.
   */
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
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: _filterController,
                    decoration: InputDecoration(
                      labelText: 'Buscar por número de ficha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: _filterData,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: ListView.builder(
                      itemCount: filteredData?.length ?? 0,
                      itemBuilder: (context, index) {
                        final item = filteredData![index];
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
                              Align(
                                alignment: Alignment.topRight,
                                child: PopupMenuButton<String>(
                                  onSelected: (String result) {
                                    _exitData.finishFormation(item['id']);
                                  },
                                  itemBuilder: (BuildContext context) => [
                                    const PopupMenuItem<String>(
                                      value: 'option1',
                                      child: Text('Finalizar formación'),
                                    ),
                                  ],
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
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
                                          fontSize: 14,
                                        ),
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Qr'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        routerApp.push(
                                          '/asistence-form',
                                          extra: {
                                            'caracterizacion_id': item['id'],
                                            'ficha': item['ficha'],
                                            'jornada': item['jornada'],
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        textStyle: const TextStyle(
                                          fontFamily: 'OpenSans',
                                          fontSize: 14,
                                        ),
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('registro manual'),
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
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
    );
  }
}
