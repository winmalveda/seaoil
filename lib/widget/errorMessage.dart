import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void errorMessage(String errorMessage) {
  Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 15.0);
}
