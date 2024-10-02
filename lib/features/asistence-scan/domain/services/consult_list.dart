import 'package:cdattg_sena_mobile/config/constanst/enviroment.dart';
import 'package:dio/dio.dart';
import 'package:cdattg_sena_mobile/features/auth/domain/services/auth_service.dart';

class ConsultList {
  final Dio dio = Dio();
  final AuthService authService = AuthService();

  Future<List<dynamic>> getList(String ficha, String jornada) async {
    await authService.loadData(); // Asegúrate de que los datos estén cargados
    final token = authService.getToken(); // Obtén el token

    try {
      final response = await dio.get(
        '${Environment.apiUrl}/asistencia/getFicha/$ficha/$jornada',
        options: Options(
          headers: {
            'Authorization':
                'Bearer $token', // Incluye el token en los encabezados
          },
        ),
      );

      final status = response.statusCode;
      print('Status: $status');
      print('Response data: ${response.data}');

      if (status == 200) {
        if (response.data is List) {
          return response.data;
        } else if (response.data is Map<String, dynamic> &&
            response.data['asistencias'] is List) {
          return response.data['asistencias'];
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load attendance list');
      }
    } catch (e) {
      throw Exception('Error fetching attendance list: $e');
    }
  }
}
