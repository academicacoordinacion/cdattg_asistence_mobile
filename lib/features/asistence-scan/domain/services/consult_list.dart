import 'package:cdattg_sena_mobile/config/constanst/enviroment.dart';
import 'package:dio/dio.dart';
import 'package:cdattg_sena_mobile/features/auth/domain/services/auth_service.dart';

class ConsultList {
  final Dio dio = Dio();
  final AuthService authService = AuthService();

  /// Obtiene una lista de asistencia basada en la ficha y la jornada proporcionadas.
  ///
  /// Este método realiza una solicitud HTTP GET al servidor para obtener la lista de asistencia.
  /// Primero, asegura que los datos de autenticación estén cargados y obtiene el token de autenticación.
  /// Luego, realiza la solicitud con el token incluido en los encabezados.
  ///
  /// Si la respuesta del servidor es exitosa (código de estado 200), verifica el formato de los datos
  /// recibidos. Si los datos son una lista, los retorna directamente. Si los datos son un mapa que contiene
  /// una lista bajo la clave 'asistencias', retorna esa lista. Si el formato de la respuesta es inesperado,
  /// lanza una excepción.
  ///
  /// Si la solicitud falla o si el código de estado no es 200, lanza una excepción indicando que no se pudo
  /// cargar la lista de asistencia.
  ///
  /// En caso de cualquier error durante la solicitud, lanza una excepción con el mensaje de error.
  ///
  /// Parámetros:
  /// - [ficha]: La ficha para la cual se desea obtener la lista de asistencia.
  /// - [jornada]: La jornada para la cual se desea obtener la lista de asistencia.
  ///
  /// Retorna:
  /// - Una lista de asistencia en formato dinámico.
  ///
  /// Excepciones:
  /// - Lanza una [Exception] si ocurre algún error durante la solicitud o si el formato de la respuesta es inesperado.
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
