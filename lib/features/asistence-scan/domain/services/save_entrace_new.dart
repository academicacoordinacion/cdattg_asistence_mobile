import 'package:cdattg_sena_mobile/config/constanst/enviroment.dart';
import 'package:cdattg_sena_mobile/features/asistence-scan/helpers/scan_alerts.dart';
import 'package:cdattg_sena_mobile/features/auth/domain/domain.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SaveEntranceNew {
  final Map<String, dynamic> item;
  final TextEditingController novedadController;
  final AuthService authService = AuthService();
  final ScanAlerts scanAlerts = ScanAlerts();

  SaveEntranceNew({required this.item, required this.novedadController});

  Future<void> saveFormData(BuildContext context) async {
    final dio = Dio();
    authService.loadData();
    final token = authService.getToken();
    final url =
        '${Environment.apiUrl}/asistencia/updateEntraceAsistence'; // Reemplaza con tu URL de la API

    try {
      final response = await dio.post(
        url,
        data: {
          'hora_ingreso': item['hora_ingreso'],
          'nombres': item['nombres'],
          'apellidos': item['apellidos'],
          'numero_identificacion': item['numero_identificacion'],
          'novedad_entrada': novedadController.text,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data != null && response.data.isNotEmpty) {
        scanAlerts.SuccessToast('Datos de novedad de entrada Validados');
      }

      if (response.statusCode == 200) {
        scanAlerts.SuccessToast('Novedad guardada con éxito');
      }

      if (response.statusCode == 404) {
        scanAlerts.WrongToast('Error al guardar la novedad');
      }
    } catch (e) {
      scanAlerts.WrongToast('Error al guardar la novedad ${e.toString()}');
    }
  }
}
