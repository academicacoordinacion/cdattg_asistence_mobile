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
  AuthService authService = AuthService(); // Instancia de AuthService
  final ScanAlerts scanAlerts = ScanAlerts();
  final ExitData _exitData = ExitData();

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        // Parse the scanned data (assuming it's a delimited string)
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

  Future<void> _saveData() async {
    final dio = Dio();
    final url = '${Environment.apiUrl}/asistencia/store';

    try {
      authService.loadData();
      final token = authService.getToken();
      print('Token: $token');
      final response = await dio.post(url,
          data: {
            'caracterizacion_id': widget.selectedBoxData['id'],
            'attendance': attendanceList,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
          ));

      if (response.statusCode == 200) {
        scanAlerts.SuccessToast('Lista de asistencia guardada con éxito');
        print('Response data: ${response.data}');
      } else if (response.statusCode == 200) {
        scanAlerts.SuccessToast('Lista de asistencia guardada con éxito');
        print('Response data: ${response.data}');
      } else {
        scanAlerts.WrongToast('Error de recepcion de datos');
      }
    } catch (e) {
      scanAlerts.WrongToast('Fallo al guardar asistencia: $e');
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
              // Implement your logout functionality here
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
                                  'hora_entrada': item['hora_ingreso']
                                      .toString(), // Asegúrate de que este valor esté disponible
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
                  onPressed: _saveData,
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
