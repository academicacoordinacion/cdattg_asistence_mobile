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

  Future<List<dynamic>?> fetchDataFromApi() async {
    print('Loading data from SharedPreferences...');
    await authService.loadData();
    final token = authService.getToken();
    final userId = authService.getUserId();

    print('Token: $token');
    print('User ID: $userId');

    if (token == null) {
      print('No token available');
      return null;
    }

    if (userId == null) {
      print('No user ID available');
      return null;
    }

    // Usar 10.0.2.2 para emulador de Android
    final endpoint =
        '${Environment.apiUrl}/caracterizacion/byInstructor/$userId';
    print('Endpoint: $endpoint');

    try {
      dio.options.headers['Authorization'] = 'Bearer $token';

      // Imprimir encabezados antes de la solicitud
      print('Request Headers: ${dio.options.headers}');

      final response = await dio.get(endpoint);

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        print('Data fetched successfully');
        final data = (response.data as List).map((e) => e).toList();
        await _saveDataToPreferences(
            data); // Guardar datos en SharedPreferences
        return data;
      } else {
        print('Failed to fetch data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }

  Future<void> _saveDataToPreferences(List<dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('scanerData', jsonEncode(data));
  }

  Future<List<dynamic>?> getDataFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('scanerData');
    if (dataString != null) {
      return jsonDecode(dataString) as List<dynamic>;
    }
    return null;
  }

  // Método de prueba para ver qué devuelve getDataFromPreferences
  Future<void> testGetDataFromPreferences() async {
    final data = await getDataFromPreferences();
    print('Data from preferences: $data');
  }
}
