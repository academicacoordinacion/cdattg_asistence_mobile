import 'dart:convert';
import 'package:cdattg_sena_mobile/config/constanst/enviroment.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Campos privados para almacenar el token, los datos del usuario y los datos de la persona
  String? _token;
  Map<String, dynamic>? _user;
  Map<String, dynamic>? _person;
  Dio dio = Dio();

  AuthService()
      : dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 30), // 5 segundos
          receiveTimeout: const Duration(seconds: 30), // 3 segundos
        ));

  // Método para obtener el token
  String? getToken() {
    return _token;
  }

  // Método para obtener los datos del usuario
  Map<String, dynamic>? getUserData() {
    return _user;
  }

  // Método para obtener los datos de la persona
  Map<String, dynamic>? getPersonData() {
    return _person;
  }

  // Método de autenticación
  Future<bool> authenticate(String email, String password) async {
    try {
      final response = await dio.post(
        '${Environment.apiUrl}/authenticate',
        data: {
          'email': email,
          'password': password,
        },
      );

      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        _token = response.data['token'];
        _user = response.data['user'];
        _person = response.data['persona'];

        if (_token != null && _user != null) {
          await storeData();
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

    return false;
  }

  Future<void> storeData() async {
    final prefs = await SharedPreferences.getInstance();
    if (_token != null) {
      await prefs.setString('token', _token!);
    }
    if (_user != null) {
      await prefs.setString('user', jsonEncode(_user));
    }
    if (_person != null) {
      await prefs.setString('person', jsonEncode(_person));
    }
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final userString = prefs.getString('user');
    final personString = prefs.getString('person');

    if (userString != null) {
      _user = Map<String, dynamic>.from(jsonDecode(userString));
    }

    if (personString != null) {
      _person = Map<String, dynamic>.from(jsonDecode(personString));
    }
  }

  String? getUserId() {
    final userId = _user?['id'];
    if (userId != null) {
      return userId.toString();
    }
    return null;
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    _person = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    await prefs.remove('person');
  }

  Future<bool> isAuthenticated() async {
    await loadData();
    return _token != null;
  }
}
