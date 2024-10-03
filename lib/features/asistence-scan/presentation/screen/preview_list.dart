import 'package:cdattg_sena_mobile/features/asistence-scan/presentation/screen/new_entrace_screen.dart';
import 'package:flutter/material.dart';
import 'new_exit_screen.dart';

class PreviewList extends StatelessWidget {
  final List<dynamic> attendanceList;

  const PreviewList({super.key, required this.attendanceList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Lista de asistencia',
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 22,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: ListView.builder(
        itemCount: attendanceList.length,
        itemBuilder: (context, index) {
          final item = attendanceList[index];
          return Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Novedad_salida') {
                    // Navegar a la nueva pantalla con los datos del item
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewByPreview(item: item),
                      ),
                    );
                  }
                  if (value == 'Novedad_entrada') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewEntranceScreen(item: item),
                      ),
                    );
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'Novedad_salida',
                      child: Text(
                        'Novedad Salida',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Novedad_entrada',
                      child: Text(
                        'Novedad Entrada',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ];
                },
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ingreso: ${item['hora_ingreso']}".toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Nombres: ${item['nombres']}".toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Apellidos: ${item['apellidos']}".toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "N° Identificación: ${item['numero_identificacion']}"
                        .toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
