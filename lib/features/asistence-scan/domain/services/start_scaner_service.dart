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
    await authService.loadData();
    final token = authService.getToken();
    final userId = authService.getUserId();

    print('Token: $token');
    print('User ID: $userId');

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
    // ignore: unused_local_variable
    final data = await getDataFromPreferences();
  }
}
