// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api

import 'package:cdattg_sena_mobile/config/constanst/enviroment.dart';
import 'package:cdattg_sena_mobile/features/asistence-scan/helpers/scan_alerts.dart';
import 'package:cdattg_sena_mobile/features/auth/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AsistenceForm extends StatefulWidget {
  final String caracterizacion_id;
  final String ficha;
  final String jornada;

  const AsistenceForm({
    super.key,
    required this.caracterizacion_id,
    required this.ficha,
    required this.jornada,
  });

  @override
  _AsistenceFormState createState() => _AsistenceFormState();
}

class _AsistenceFormState extends State<AsistenceForm> {
  final TextEditingController _nombres = TextEditingController();
  final TextEditingController _apellidos = TextEditingController();
  final TextEditingController _numero_identificacion = TextEditingController();
  final TextEditingController _hora_ingreso = TextEditingController();
  final AuthService _authService = AuthService();
  final ScanAlerts _scanAlerts = ScanAlerts();
  bool _isLoading = false;

  /*
   * Guarda el formulario de asistencia enviando los datos a la API.
   * 
   * Este método realiza las siguientes acciones:
   * 1. Carga los datos del servicio de autenticación.
   * 2. Crea una instancia de Dio para realizar la solicitud HTTP.
   * 3. Construye la URL de la API para almacenar la asistencia.
   * 4. Obtiene el token de autenticación.
   * 5. Prepara los datos del formulario para enviarlos.
   * 6. Si el token es válido, realiza una solicitud POST a la API con los datos y el token en el encabezado.
   * 7. Si la respuesta de la API es exitosa (código 200), muestra un mensaje de éxito después de un retraso de 4 segundos.
   * 8. Si la respuesta de la API indica un error (código 400), muestra un mensaje de error.
   * 
   * @param context El contexto de la aplicación.
   * @return Un Future que se completa cuando se guarda el formulario de asistencia.
   */
  Future<void> _saveAsistenceform(BuildContext context) async {
    _authService.loadData();
    Dio dio = Dio();
    final url = '${Environment.apiUrl}/asistencia/store';

    final token = _authService.getToken();

    final data = {
      'caracterizacion_id': widget.caracterizacion_id,
      'nombres': _nombres.text,
      'apellidos': _apellidos.text,
      'numero_identificacion': _numero_identificacion.text,
      'hora_ingreso': _hora_ingreso.text,
    };

    if (token != null) {
      final respose = await dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (respose.statusCode == 200) {
        setState(() {
          _isLoading = true;
        });

        Future.delayed(const Duration(seconds: 4), () {
          setState(() {
            _isLoading = false;
            _scanAlerts.SuccessToast(
                'Lista de asistencia guardada correctamente');
          });
        });

        if (respose.statusCode == 400) {
          _scanAlerts.WrongToast('Error: Asistencia no guardada');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _hora_ingreso.text = TimeOfDay.now().format(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Asistencia - ${widget.ficha}',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller:
                    TextEditingController(text: widget.caracterizacion_id),
                decoration: InputDecoration(
                  labelText: 'Caracterizacion',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                enabled: false,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _hora_ingreso,
                decoration: InputDecoration(
                  labelText: 'Hora de Ingreso',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                enabled: false,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nombres,
                decoration: InputDecoration(
                  labelText: 'Nombres',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _apellidos,
                decoration: InputDecoration(
                  labelText: 'Apellidos',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _numero_identificacion,
                decoration: InputDecoration(
                  labelText: 'Identificación',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading) const LinearProgressIndicator(),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed:
                      _isLoading ? null : () => _saveAsistenceform(context),
                  child: const Text(
                    'Guardar Asistencia',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
