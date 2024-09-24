import 'package:cdattg_sena_mobile/features/auth/domain/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cdattg_sena_mobile/config/constanst/enviroment.dart';
import 'package:cdattg_sena_mobile/features/asistence-scan/helpers/scan_alerts.dart';

class AssistenceOutScreen extends StatelessWidget {
  final String caracterizacionId;
  final String numeroIdentificacion;
  final String horaEntrada;
  final TextEditingController novedadController = TextEditingController();
  final ScanAlerts scanAlerts = ScanAlerts();
  final _formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  AssistenceOutScreen({
    Key? key,
    required this.caracterizacionId,
    required this.numeroIdentificacion,
    required this.horaEntrada,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Novedad Salida',
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 22,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: caracterizacionId,
                decoration: InputDecoration(
                  labelText: 'Caracterización ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: numeroIdentificacion,
                decoration: InputDecoration(
                  labelText: 'Número de Identificación',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: horaEntrada,
                decoration: InputDecoration(
                  labelText: 'Hora de Entrada',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: novedadController,
                decoration: InputDecoration(
                  labelText: 'Novedad',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una novedad';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _saveNovedad(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Guardar Novedad',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 18,
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

  Future<void> _saveNovedad(BuildContext context) async {
    final dio = Dio();
    final url = '${Environment.apiUrl}/asistencia/novedad';
    final ScanAlerts scanAlerts = ScanAlerts();
    authService.loadData();
    final token = authService.getToken();

    final response = await dio.post(
      url,
      data: {
        'caracterizacion_id': caracterizacionId,
        'numero_identificacion': numeroIdentificacion,
        'hora_entrada': horaEntrada,
        'novedad': novedadController.text,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    print('Response data: ${response.data}');
    print(token);

    if (response.data != false) {
      scanAlerts.SuccessToast('Novedad guardada con éxito');
    }

    if (response.statusCode == 200 && response.data != false) {
      scanAlerts.SuccessToast('Novedad guardada con éxito');
    }

    if (response.statusCode != 200 && response.data == false) {
      scanAlerts.WrongToast('Error al guardar novedad');
    }
  }
}
