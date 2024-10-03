import 'package:cdattg_sena_mobile/config/constanst/enviroment.dart';
import 'package:cdattg_sena_mobile/features/asistence-scan/helpers/scan_alerts.dart';
import 'package:cdattg_sena_mobile/features/auth/domain/domain.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SaveEntranceUpdate {
  final Map<String, dynamic> item;
  final TextEditingController novedadController;
  final AuthService authService = AuthService();
  final ScanAlerts scanAlerts = ScanAlerts();

  SaveEntranceUpdate({required this.item, required this.novedadController});

  Future<void> saveFormData(BuildContext context) async {
    authService.loadData();
    final token = authService.getToken();
    final dio = Dio();
    final url = '${Environment.apiUrl}/asistencia/updateExitAsistence';

    try {
      final response = await dio.post(
        url,
        data: {
          'hora_ingreso': item['hora_ingreso'],
          'nombres': item['nombres'],
          'apellidos': item['apellidos'],
          'numero_identificacion': item['numero_identificacion'],
          'novedad_salida': novedadController.text,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        scanAlerts.SuccessToast('Novedad de salida guardada');
      } else {
        scanAlerts.WrongToast('Error al guardar al novedad');
      }
    } catch (e) {
      scanAlerts.WrongToast('Error al guardar al novedad: ${e.toString()}');
    }
  }
}
