import 'package:flutter/material.dart';

class NewByPreview extends StatelessWidget {
  final Map<String, dynamic> item;

  NewByPreview({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Novedad de salida',
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
            SizedBox(height: 10),
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
            SizedBox(height: 10),
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
            SizedBox(height: 10),
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
            SizedBox(height: 10),
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
            SizedBox(height: 10),
            TextFormField(
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
              maxLines: 3, // This will increase the height of the TextFormField
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle submit action
                },
                child: Text(
                  'Guardar Novedad',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  iconColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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
