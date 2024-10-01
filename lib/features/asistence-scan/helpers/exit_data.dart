import 'package:dio/dio.dart';
import 'package:cdattg_sena_mobile/config/constanst/enviroment.dart';
import 'package:cdattg_sena_mobile/features/asistence-scan/helpers/scan_alerts.dart';
import 'package:cdattg_sena_mobile/features/auth/domain/domain.dart';

class ExitData {
  final AuthService authService = AuthService();
  final ScanAlerts scanAlert = ScanAlerts();

  Future<void> finishFormation(dynamic caracterizacionId) async {
    final dio = Dio();
    final url = '${Environment.apiUrl}/asistencia/update';
    final horaSalida = DateTime.now().toIso8601String();
    final fecha = DateTime.now().toIso8601String().split('T')[0];

    try {
      authService.loadData();
      final token = authService.getToken();

      final response = await dio.post(url,
          data: {
            'caracterizacion_id': caracterizacionId,
            'fecha': fecha,
            'hora_salida': horaSalida,
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
        scanAlert.SuccessToast('Hora de salida guardada exitosamente');
      }
      if (response.statusCode == 200 && response.data != false) {
        scanAlert.SuccessToast('Hora de salida guardada exitosamente');
      } else {
        scanAlert.SuccessToast(
            'Datos validados, preciona el botón Finalizar formación');
      }
    } catch (e) {
      scanAlert.WrongToast(
          'Error de solicitud: Verifica tu conexión a internet o consulta con la mesa de dirección agroindustria y tecnólogía');
    }
  }
}
