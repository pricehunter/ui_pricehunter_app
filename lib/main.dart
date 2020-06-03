import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Detalle - Producto'),
        ),
        body: Center(
          child: Container(
            height: 30,
            width: 90,
            child: RaisedButton(
              onPressed: _launchURL,
              child: Text('Go'),
            ),
          ),
        ),
      ),
    );
  }
}

_launchURL() async {
  const url = 'https://listado.mercadolibre.com.ar/chromecast#D[A:chromecast]';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
