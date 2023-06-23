import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:rive/rive.dart';
import 'Rams.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Rams Tango",
      home: Rams(),
    );
  }
}
