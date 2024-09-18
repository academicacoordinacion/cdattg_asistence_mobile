import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class AttendanceScreen extends StatefulWidget {
  final dynamic selectedBoxData;

  const AttendanceScreen({super.key, required this.selectedBoxData});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  List<String> attendanceList = [];

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        setState(() {
          attendanceList.add(scanData.code!);
        });
      }
    });
  }

  void _saveData() {
    // Implement your save data logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Asistencia - ${widget.selectedBoxData['ficha']}',
          style: TextStyle(
            fontFamily: 'OpenSans',
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: 200,
              height: 200,
              color: Theme.of(context).colorScheme.secondary,
              child: const Center(
                child: Text('cdattg'),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: attendanceList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(attendanceList[index]),
                );
              },
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              iconColor: Theme.of(context).primaryColor,
              textStyle: const TextStyle(
                fontFamily: 'OpenSans',
                color: Colors.white,
              ),
            ),
            onPressed: _saveData,
            child: const Text('Guardar Asistencia'),
          ),
        ],
      ),
    );
  }
}
