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

  /// Guarda los datos del formulario de asistencia.
  ///
  /// Este método envía una solicitud POST al servidor para actualizar la
  /// asistencia de salida con los datos proporcionados.
  ///
  /// Parámetros:
  /// - `context`: El contexto de la aplicación.
  ///
  /// Acciones:
  /// - Carga los datos de autenticación.
  /// - Obtiene el token de autenticación.
  /// - Envía una solicitud POST al servidor con los datos de asistencia.
  /// - Muestra una notificación de éxito si la solicitud es exitosa.
  /// - Muestra una notificación de error si la solicitud falla.
  ///
  /// Excepciones:
  /// - Puede lanzar excepciones relacionadas con la solicitud HTTP.
  Future<void> saveFormData(BuildContext context) async {
    authService.loadData();
    final token = authService.getToken();
    final dio = Dio();
    final url = '${Environment.apiUrl}/asistencia/updateExitAsistence';

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
    }

    if (response.statusCode != 200) {
      scanAlerts.WrongToast('Error al guardar al novedad');
    }
  }
}
