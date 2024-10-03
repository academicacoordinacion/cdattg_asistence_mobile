import 'package:flutter/material.dart';

class NewExitScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  NewExitScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Novedad de Entrada',
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 22,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: item['hora_ingreso'],
                decoration: InputDecoration(
                  labelText: 'Ingreso',
                  labelStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                readOnly: true,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: item['nombres'],
                decoration: InputDecoration(
                  labelText: 'Nombres',
                  labelStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                readOnly: true,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: item['apellidos'],
                decoration: InputDecoration(
                  labelText: 'Apellidos',
                  labelStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                readOnly: true,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: item['numero_identificacion'].toString(),
                decoration: InputDecoration(
                  labelText: 'N° Identificación',
                  labelStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                readOnly: true,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Novedad Entrada',
                  labelStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Guardar Novedad',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              // Agrega más campos según sea necesario
            ],
          ),
        ),
      ),
    );
  }
}
