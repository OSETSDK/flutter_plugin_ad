import 'package:flutter/material.dart';

Widget buildCommonButton(String label, {required VoidCallback callback}) {
  return ElevatedButton(onPressed: callback, child: Text(label));
}