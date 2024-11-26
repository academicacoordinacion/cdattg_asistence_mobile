import 'package:cdattg_sena_mobile/features/asistence-scan/domain/services/save_entrace_new.dart';
import 'package:flutter/material.dart';

class NewEntranceScreen extends StatelessWidget {
  final Map<String, dynamic> item;
  final TextEditingController novedadController = TextEditingController();

  NewEntranceScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final saveEntranceNew = SaveEntranceNew(
      item: item,
      novedadController: novedadController,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Novedad de entrada',
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            TextFormField(
              initialValue: item['hora_ingreso'],
              decoration: InputDecoration(
                labelText: 'Ingreso',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
              readOnly: true,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: item['nombres'],
              decoration: InputDecoration(
                labelText: 'Nombres',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
              readOnly: true,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: item['apellidos'],
              decoration: InputDecoration(
                labelText: 'Apellidos',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
              readOnly: true,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: item['numero_identificacion'].toString(),
              decoration: InputDecoration(
                labelText: 'N° Identificación',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                color: Theme.of(context).colorScheme.secondary,
              ),
              readOnly: true,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: novedadController,
              decoration: InputDecoration(
                labelText: 'Novedad',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              style: TextStyle(
                fontFamily: 'OpenSans',
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 16,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  saveEntranceNew.saveFormData(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  iconColor: Theme.of(context).primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Guardar Novedad',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
