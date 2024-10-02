import 'package:dio/dio.dart';
import 'package:cdattg_sena_mobile/features/auth/domain/services/auth_service.dart';

class ConsultList {
  final Dio dio = Dio();
  final AuthService authService = AuthService();

  Future<List<dynamic>> getList(String ficha) async {
    await authService.loadData(); // Asegúrate de que los datos estén cargados
    final token = authService.getToken(); // Obtén el token

    try {
      final response = await dio.get(
        'your_api_endpoint_here',
        queryParameters: {'ficha': ficha},
        options: Options(
          headers: {
            'Authorization':
                'Bearer $token', // Incluye el token en los encabezados
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load attendance list');
      }
    } catch (e) {
      throw Exception('Error fetching attendance list: $e');
    }
  }
}
