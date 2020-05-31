
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterseed/src//model/price_history.dart';
import 'package:flutterseed/src//service/price_service_client.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;


class Chart extends StatelessWidget {
  final String title;

  Chart({Key key, this.title}) : super(key: key);

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
      body: _createCharts(),
    );
  }

  _createCharts(){
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
