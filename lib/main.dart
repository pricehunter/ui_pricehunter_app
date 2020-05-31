import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<PriceHistory>> fetchPrices(http.Client client) async {
  final response =
  await client.get('http://10.0.2.2:8080/api/v1/products/1/prices');

  // Usa la función compute para ejecutar parsePhotos en un isolate separado
  return compute(parsePriceHistory, response.body);
}

// Una función que convierte el body de la respuesta en un List<Photo>
List<PriceHistory> parsePriceHistory(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<PriceHistory>((json) => PriceHistory.fromJson(json)).toList();
}

class PriceHistory {
  final int id;
  final double value;

  PriceHistory({ this.id, this.value});

  factory PriceHistory.fromJson(Map<String, dynamic> json) {
    return PriceHistory(
      id: json['id'] as int,
      value: json['value'] as double,
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Isolate Demo';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<PriceHistory>>(
        future: fetchPrices(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PriceHistoryList(priceList: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class PriceHistoryList extends StatelessWidget {
  final List<PriceHistory> priceList;

  PriceHistoryList({Key key, this.priceList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: priceList.length,
      itemBuilder: (context, index) {
        return Text(priceList[index].value.toString());
      },
    );
  }
}
