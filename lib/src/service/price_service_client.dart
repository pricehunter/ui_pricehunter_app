import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutterseed/src//model/price_history.dart';
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