import 'dart:convert';
import 'package:cdattg_sena_mobile/config/constanst/enviroment.dart';
import 'package:cdattg_sena_mobile/features/auth/domain/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartScanerService {
  final AuthService authService;
  final Dio dio;

  StartScanerService({required this.authService, required this.dio}) {
    // Configurar tiempo de espera
    // dio.options.connectTimeout = const Duration(seconds: 10); // 10 segundos
    // dio.options.receiveTimeout = const Duration(seconds: 10); // 10 segundos
  }

  /*Método que obtiene datos de una API.
  
   Este método realiza una solicitud HTTP GET a un endpoint específico
   utilizando un token de autenticación y un ID de usuario obtenidos
   del servicio de autenticación. Los datos obtenidos se guardan en
   SharedPreferences.
  
   Retorna una lista de datos si la solicitud es exitosa, de lo contrario, retorna null.
  
   @return Future<List<dynamic>?> Lista de datos obtenidos de la API o null en caso de error.*/

  Future<List<dynamic>?> fetchDataFromApi() async {
    await authService.loadData();
    final token = authService.getToken();
    final userId = authService.getUserId();

    // Usar 10.0.2.2 para emulador de Android
    final endpoint =
        '${Environment.apiUrl}/caracterizacion/byInstructor/$userId';

    try {
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        final data = (response.data as List).map((e) => e).toList();
        await _saveDataToPreferences(
            data); // Guardar datos en SharedPreferences
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /*
   * Guarda los datos proporcionados en las preferencias compartidas.
   *
   * @param List<dynamic> data - La lista de datos que se guardarán.
   * @return Future<void> - Un futuro que se completa cuando los datos se han guardado.
   */
  Future<void> _saveDataToPreferences(List<dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('scanerData', jsonEncode(data));
  }

  /*
   * Retrieves a list of dynamic data from shared preferences.
   *
   * This method asynchronously fetches a JSON-encoded string from the shared 
   * preferences under the key 'scanerData', decodes it, and returns it as a 
   * list of dynamic objects. If no data is found, it returns null.
   *
   * @return A Future that resolves to a List of dynamic objects or null if no 
   * data is found.
   */
  Future<List<dynamic>?> getDataFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('scanerData');
    if (dataString != null) {
      return jsonDecode(dataString) as List<dynamic>;
    }
    return null;
  }

  /*
   * Método de prueba para obtener datos de las preferencias.
   * 
   * Este método es una función asíncrona que llama a `getDataFromPreferences`
   * para obtener datos almacenados en las preferencias del usuario.
   * 
   * Actualmente, los datos obtenidos no se utilizan dentro del método.
   * 
   * @return Un `Future` que se completa cuando la operación de obtención de datos ha finalizado.
   */
  Future<void> testGetDataFromPreferences() async {
    // ignore: unused_local_variable
    final data = await getDataFromPreferences();
  }
}
