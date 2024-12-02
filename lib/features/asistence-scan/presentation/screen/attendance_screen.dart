// ignore_for_file: library_private_types_in_public_api

import 'package:cdattg_sena_mobile/config/constanst/enviroment.dart';
import 'package:cdattg_sena_mobile/config/routes/router_app.dart';
import 'package:cdattg_sena_mobile/features/asistence-scan/helpers/exit_data.dart';
import 'package:cdattg_sena_mobile/features/asistence-scan/helpers/scan_alerts.dart';
import 'package:cdattg_sena_mobile/features/auth/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:dio/dio.dart';

class AttendanceScreen extends StatefulWidget {
  final dynamic selectedBoxData;
  const AttendanceScreen({super.key, required this.selectedBoxData});
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  List<Map<String, String>> attendanceList = [];
  QRViewController? controller;
  AuthService authService = AuthService();
  final ScanAlerts scanAlerts = ScanAlerts();
  final ExitData _exitData = ExitData();
  bool _isLoading = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  /*
   * Método que se ejecuta cuando se crea la vista del lector de QR.
   * 
   * @param controller El controlador de la vista del lector de QR.
   * 
   * Este método escucha el flujo de datos escaneados y, si el código escaneado no es nulo,
   * analiza el código QR. Si los datos analizados no son nulos y no están ya presentes en la lista de asistencia,
   * se agrega un nuevo registro con la hora de ingreso actual.
   */
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        final data = parseQRCode(scanData.code!);
        if (data != null &&
            !attendanceList.any((item) =>
                item['numero_identificacion'] ==
                data['numero_identificacion'])) {
          setState(() {
            data['hora_ingreso'] = DateTime.now().toIso8601String();
            attendanceList.add(data);
          });
        }
      }
    });
  }

  /*
   * Analiza un código QR y extrae información específica.
   *
   * Este método toma un código QR en forma de cadena, lo divide en partes
   * utilizando el carácter '|' como delimitador y extrae los nombres,
   * apellidos y número de identificación del usuario.
   *
   * Si el código QR contiene al menos tres partes, se devuelve un mapa con
   * las claves 'nombres', 'apellidos' y 'numero_identificacion'. Si el código
   * QR no contiene suficiente información, se muestra una alerta de error y
   * se devuelve null.
   *
   * En caso de que ocurra una excepción durante el análisis del código QR,
   * se muestra una alerta de error con el mensaje de la excepción y se
   * devuelve null.
   *
   * @param code El código QR en forma de cadena.
   * @return Un mapa con la información extraída del código QR o null si el
   *         código QR no es válido o ocurre un error durante el análisis.
   */
  Map<String, String>? parseQRCode(String code) {
    try {
      final parts = code.split('|');
      if (parts.length >= 3) {
        return {
          'nombres': parts[0],
          'apellidos': parts[1],
          'numero_identificacion': parts[2],
        };
      } else {
        scanAlerts.WrongToast('Error: QR sin contenido válido');
        return null;
      }
    } catch (e) {
      scanAlerts.WrongToast('Error parsing QR code: $e');
      return null;
    }
  }

  /*
   * Guarda los datos de asistencia en el servidor.
   * 
   * Este método envía una solicitud POST al servidor para almacenar los datos de asistencia.
   * Utiliza la biblioteca Dio para realizar la solicitud HTTP.
   * 
   * Si la lista de asistencia está vacía y la respuesta del servidor es exitosa (código 200),
   * muestra una alerta indicando que no hay asistencias para guardar.
   * 
   * Si la respuesta del servidor es exitosa (código 200), muestra una alerta de éxito,
   * limpia la lista de asistencia y actualiza el estado de carga después de un retraso de 4 segundos.
   * 
   * Si la respuesta del servidor es un error 404, muestra una alerta indicando que el listado no se ha guardado.
   * 
   * @return Future<void> Un futuro que se completa cuando se han guardado los datos.
   */
  Future<void> _saveData() async {
    final dio = Dio();
    final url = '${Environment.apiUrl}/asistencia/store';

    authService.loadData();
    final token = authService.getToken();

    final response = await dio.post(url,
        data: {
          'caracterizacion_id': widget.selectedBoxData['id'],
          'attendance': attendanceList,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ));

    if (attendanceList.isEmpty && response.statusCode == 200) {
      scanAlerts.WrongToast('No hay asistencias para guardar');
      return;
    }

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(seconds: 4), () {
        setState(() {
          _isLoading = false;
          scanAlerts.SuccessToast('Lista de asistencia guardada correctamente');
          attendanceList.clear();
        });
      });
    }

    if (_isLoading == false) {}

    if (response.statusCode == 404) {
      scanAlerts.WrongToast('Error: El listado no se a guardado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Asistencia - ${widget.selectedBoxData['ficha']}',
          style: TextStyle(
            fontFamily: 'OpenSans',
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authService.logout();
              routerApp.go('/');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Theme.of(context).colorScheme.primary,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 200,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: attendanceList.length,
              itemBuilder: (context, index) {
                final item = attendanceList[index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      ListTile(
                        title: Text(
                            'Nombres: ${item['nombres']}\nApellidos: ${item['apellidos']}'),
                        subtitle: Text(
                            'ID: ${item['numero_identificacion']}\nHora de Ingreso: ${item['hora_ingreso']}'),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'Novedad Salida') {
                              routerApp.push(
                                '/assistence-out',
                                extra: {
                                  'caracterizacion_id':
                                      widget.selectedBoxData['id'].toString(),
                                  'numero_identificacion':
                                      item['numero_identificacion'],
                                  'hora_entrada':
                                      item['hora_ingreso'].toString(),
                                },
                              );
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return {
                              'Novedad Salida',
                            }.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_isLoading) const CircularProgressIndicator(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    textStyle: const TextStyle(
                      fontFamily: 'OpenSans',
                      color: Colors.white,
                    ),
                  ),
                  onPressed: _isLoading ? null : _saveData,
                  child: const Text('Guardar Asistencia',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    textStyle: const TextStyle(
                      fontFamily: 'OpenSans',
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    _exitData.finishFormation(widget.selectedBoxData['id']);
                  },
                  child: const Text('Finalizar Formación',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
