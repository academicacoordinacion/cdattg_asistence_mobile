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

  /*
   * Obtiene el token de autenticación.
   *
   * @return El token de autenticación, o null si no está disponible.
   */
  String? getToken() {
    return _token;
  }

  /*
   * Obtiene los datos del usuario.
   *
   * @return Un mapa con los datos del usuario, o null si no hay datos disponibles.
   */
  Map<String, dynamic>? getUserData() {
    return _user;
  }

  /*
   * Obtiene los datos de la persona.
   *
   * @return Un mapa con los datos de la persona, o null si no hay datos disponibles.
   */
  Map<String, dynamic>? getPersonData() {
    return _person;
  }

  /*
   * Autentica al usuario con el correo electrónico y la contraseña proporcionados.
   *
   * Envía una solicitud POST al endpoint de autenticación con los datos del usuario.
   * Si la respuesta es exitosa (código de estado 200), almacena el token, el usuario y la persona
   * en las variables correspondientes y guarda los datos localmente.
   *
   * Retorna `true` si la autenticación es exitosa, de lo contrario, retorna `false`.
   *
   * @param email El correo electrónico del usuario.
   * @param password La contraseña del usuario.
   * @return Un `Future` que resuelve a `true` si la autenticación es exitosa, de lo contrario `false`.
   */
  Future<bool> authenticate(String email, String password) async {
    try {
      final response = await dio.post(
        '${Environment.apiUrl}/authenticate',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        _token = response.data['token'];
        _user = response.data['user'];
        _person = response.data['persona'];

        if (_token != null && _user != null) {
          await storeData();
          return true;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }

    return false;
  }

  /*
   * Almacena datos en las preferencias compartidas.
   * 
   * Este método guarda el token, el usuario y la persona en las preferencias
   * compartidas si no son nulos. Los datos se almacenan como cadenas JSON.
   * 
   * @return Un Future que se completa cuando los datos han sido almacenados.
   */
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

  /*
   * Carga los datos almacenados en las preferencias compartidas.
   * 
   * Obtiene la instancia de `SharedPreferences` y recupera los valores
   * almacenados para 'token', 'user' y 'person'. Si los valores de 'user' 
   * y 'person' no son nulos, los decodifica de JSON y los asigna a las 
   * variables `_user` y `_person` respectivamente.
   * 
   * @return Un `Future` que se completa cuando los datos han sido cargados.
   */
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

  /*
   * Obtiene el ID del usuario actual.
   *
   * @return El ID del usuario como una cadena de texto si está disponible, de lo contrario, null.
   */
  String? getUserId() {
    final userId = _person?['id'];
    if (userId != null) {
      return userId.toString();
    }
    return null;
  }

  /*
   * Cierra la sesión del usuario actual.
   * 
   * Este método realiza las siguientes acciones:
   * - Establece los valores de `_token`, `_user` y `_person` a `null`.
   * - Obtiene una instancia de `SharedPreferences`.
   * - Elimina las claves 'token', 'user' y 'person' de `SharedPreferences`.
   * 
   * @return Un `Future` que se completa cuando se han eliminado las claves de `SharedPreferences`.
   */
  Future<void> logout() async {
    _token = null;
    _user = null;
    _person = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.remove('token');
    await prefs.remove('user');
    await prefs.remove('person');
  }

  /*
   * Verifica si el usuario está autenticado.
   *
   * Este método carga los datos necesarios y luego verifica si el token de autenticación no es nulo.
   *
   * @return Un Future que resuelve a true si el usuario está autenticado, de lo contrario false.
   */

  /*Future<bool> isAuthenticated() async {
    await loadData();
    return _token != null;
  }*/

  Future<bool> isAuthenticated() async {
    await loadData();
    if (getToken() != null) {
      return true;
    }

    return false;
  }
}
