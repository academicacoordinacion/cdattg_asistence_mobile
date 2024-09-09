import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio();

  AuthService() {
    _dio.options.validateStatus = (status) {
      // Acepta cualquier código de estado inferior a 500
      return status != null && status < 500;
    };
  }

  Future<bool> authenticate(String email, String password) async {
    final apiUrl = dotenv.env['API_URL'] ?? '';
    try {
      final response = await _dio.post(
        '$apiUrl/authenticate',
        data: {
          'email': email,
          'password': password,
        },
      );

      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final user = response.data['user'];

        if (token != null && user != null) {
          return true;
        }
      } else {
        print('Unexpected status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }

    // Add a return statement here
    return false;
  }
}
