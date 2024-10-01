// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ScanAlerts {
  void SuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG, // Changed to LONG for 5 seconds duration
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5, // Set duration to 5 seconds for Android
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void WrongToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG, // Changed to LONG for 5 seconds duration
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5, // Set duration to 5 seconds
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
