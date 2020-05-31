import 'dart:async';
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;

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
  final String date;

  PriceHistory({ this.id, this.value,this.date});

  factory PriceHistory.fromJson(Map<String, dynamic> json) {
    return PriceHistory(
      id: json['id'] as int,
      value: json['value'] as double,
      date: json['date'] as String,
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Grafico';

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

    return Scaffold(
      body: _crearCharts(),
    );
  }

   _crearCharts(){
    return SimpleBarChart.withSampleData(priceList);
  }
}



class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData(List<PriceHistory> priceList) {
    return new SimpleBarChart(
      _createSampleData(priceList),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData(List<PriceHistory> priceList) {
    List<OrdinalSales> data = new List();

    priceList.map((e) => {

      data.add(new OrdinalSales(e.date.substring(0,4), e.value.toInt()))
    }).toList();
    
//    final data = [
//      new OrdinalSales('2014', 5),
//      new OrdinalSales('2015', 25),
//      new OrdinalSales('2016', 100),
//      new OrdinalSales('2017', 75),
//    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
