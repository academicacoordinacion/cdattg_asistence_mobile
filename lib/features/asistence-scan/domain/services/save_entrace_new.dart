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

  /// Guarda los datos del formulario enviándolos a la API especificada.
  ///
  /// Este método utiliza la librería Dio para enviar una solicitud POST a la URL
  /// de la API definida en `Environment.apiUrl`. Los datos enviados incluyen
  /// información de hora de ingreso, nombres, apellidos, número de identificación
  /// y novedad de entrada.
  ///
  /// Si la solicitud es exitosa (código de estado 200), se muestra un mensaje de
  /// éxito. Si la solicitud falla con un código de estado 404, se muestra un
  /// mensaje de error específico. Para cualquier otro código de estado, también
  /// se muestra un mensaje de error.
  ///
  /// Parámetros:
  /// - `context`: El contexto de la aplicación.
  ///
  /// Retorna:
  /// - Un `Future<void>` que completa cuando la operación de guardado ha terminado.
  Future<void> saveFormData(BuildContext context) async {
    final dio = Dio();
    authService.loadData();
    final token = authService.getToken();
    final url =
        '${Environment.apiUrl}/asistencia/updateEntraceAsistence'; // Reemplaza con tu URL de la API

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

    if (response.statusCode == 200) {
      scanAlerts.SuccessToast('Novedad guardada con éxito');
    }

    if (response.statusCode == 404) {
      scanAlerts.WrongToast('Error al guardar la novedad');
    }

    if (response.statusCode != 200) {
      scanAlerts.WrongToast('Error al guardar la novedad');
    }
  }
}
