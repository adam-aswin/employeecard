import 'package:employeecard/homepage.dart';
import 'package:employeecard/temp.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      routes: {
        "/temp": (context) => Temppage(),
      },
      home: Homepage(),
    ),
  );
}
