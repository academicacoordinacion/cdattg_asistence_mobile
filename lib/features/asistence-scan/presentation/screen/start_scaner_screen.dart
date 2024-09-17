import 'package:flutter/material.dart';
import 'package:cdattg_sena_mobile/features/asistence-scan/domain/services/start_scaner_service.dart';
import 'package:cdattg_sena_mobile/features/auth/domain/services/auth_service.dart';
import 'package:dio/dio.dart';

class StartScanerScreen extends StatefulWidget {
  const StartScanerScreen({super.key});

  @override
  _StartScanerScreenState createState() => _StartScanerScreenState();
}

class _StartScanerScreenState extends State<StartScanerScreen> {
  final StartScanerService startScanerService = StartScanerService(
    authService: AuthService(),
    dio: Dio(),
  );

  List<dynamic>? scanerData;
  Map<int, bool> selectedItems = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await startScanerService.getDataFromPreferences();
    if (data != null) {
      setState(() {
        scanerData = data;
        selectedItems = {for (var item in data) item['id']: false};
      });
    } else {
      final apiData = await startScanerService.fetchDataFromApi();
      if (apiData != null) {
        setState(() {
          scanerData = apiData;
          selectedItems = {for (var item in apiData) item['id']: false};
        });
      }
    }
  }

  Future<void> _saveSelectedItems() async {
    if (scanerData != null) {
      final selectedData = scanerData!
          .where((item) => selectedItems[item['id']] == true)
          .toList();
      if (selectedData.isNotEmpty) {
        final dio = Dio();
        final response = await dio.post(
          'http://10.0.2.2:8000/api/saveSelectedItems',
          data: selectedData,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Datos guardados exitosamente.'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al guardar los datos.'),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caracterización'),
      ),
      body: scanerData == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: ListView.builder(
                      itemCount: scanerData!.length,
                      itemBuilder: (context, index) {
                        final item = scanerData![index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              CheckboxListTile(
                                title: Text(
                                  item['programa_formacion'] ?? 'N/A',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontFamily: 'OpenSans',
                                    fontSize: 17,
                                  ),
                                ),
                                subtitle: Text(
                                  'Ficha: ${item['ficha'] ?? 'N/A'}\nInstructor: ${item['persona'] ?? 'N/A'}\nJornada: ${item['jornada'] ?? 'N/A'}\nSede: ${item['sede'] ?? 'N/A'}\n',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                value: selectedItems[item['id']],
                                onChanged: (bool? value) {
                                  setState(() {
                                    selectedItems[item['id']] = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _saveSelectedItems,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Guardar Selección'),
                  ),
                ),
              ],
            ),
    );
  }
}
