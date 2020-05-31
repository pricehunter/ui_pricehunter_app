import 'package:flutter/material.dart';
import 'package:flutterseed/src//component/chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Grafico';

    return MaterialApp(
      title: appTitle,
      home: Chart(title: appTitle),
    );
  }
}



