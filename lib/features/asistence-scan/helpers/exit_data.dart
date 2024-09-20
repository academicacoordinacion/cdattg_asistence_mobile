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
      print('Token: $token');
      print('Sending data to $url');
      print('Data: ${{
        'caracterizacion_id': caracterizacionId,
        'fecha': fecha,
        'hora_salida': horaSalida,
      }}');

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
        print('Hora de salida guardada exitosamente');
        print('Response data: ${response.data}');
        scanAlert.SuccessToast('Hora de salida guardada exitosamente');
      } else if (response.statusCode == 200) {
        print('Redirección detectada: Error 302');
        scanAlert.SuccessToast('Hora de salida guardada exitosamente');
      } else {
        print('Failed to save hora de salida');
        scanAlert.WrongToast('Error al guardar la hora de salida');
      }
    } catch (e) {
      print('Error saving hora de salida: $e');
      scanAlert.WrongToast('Status de salida diferente a 200: $e');
    }
  }
}
