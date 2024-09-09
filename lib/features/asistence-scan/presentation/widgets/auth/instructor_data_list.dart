import 'package:flutter/material.dart';
import 'package:cdattg_sena_mobile/features/auth/domain/services/auth_service.dart';

class InstructorDataList extends StatefulWidget {
  final AuthService authService;

  InstructorDataList({required this.authService});

  @override
  _InstructorDataListState createState() => _InstructorDataListState();
}

class _InstructorDataListState extends State<InstructorDataList> {
  Map<String, dynamic>? userData;
  Map<String, dynamic>? personData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await widget.authService.loadData();
    setState(() {
      userData = widget.authService.getUserData();
      personData = widget.authService.getPersonData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorApp = Theme.of(context).colorScheme;
    return userData != null && personData != null
        ? ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              ListTile(
                title: Text(
                  'Correo',
                  style: TextStyle(color: colorApp.primary),
                ),
                subtitle: Text(
                  userData!['email'] ?? 'N/A',
                  style: TextStyle(color: colorApp.secondary),
                ),
              ),
              ListTile(
                title: Text(
                  'Nombre',
                  style: TextStyle(color: colorApp.primary),
                ),
                subtitle: Text(personData!['primer_nombre'] ?? 'N/A',
                    style: TextStyle(color: colorApp.secondary)),
              ),
              ListTile(
                title:
                    Text('Apellido', style: TextStyle(color: colorApp.primary)),
                subtitle: Text(personData!['primer_apellido'] ?? 'N/A',
                    style: TextStyle(color: colorApp.secondary)),
              ),
              // Agrega más ListTile según sea necesario
              Center(
                child: FilledButton(
                  onPressed: () {
                    // Lógica para iniciar el escáner
                  },
                  child: Text('Iniciar Scanner'),
                ),
              ),
            ],
          )
        : Center(child: CircularProgressIndicator());
  }
}
