import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/assests.dart';
import 'package:flutter/material.dart';
import 'package:list/models/product.dart';

class ProductService with ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  Future<void> loadProducts() async {
    final rawData = await rootBundle.loadString('assets/products_enriched.csv');
    List<List<dynamic>> csvTable = const csvToListConverter().convert(rawData);

    // Assuming the first row is a header and skipping it
    _products = csvTable.sublist(1).map((row) {
      return Product(
        id: row[0].toString(),
        name: row[1],
        category: row[2],
        brand: row[5],
        price: row[6].toDouble(),
        allergens: (row[7] as String).split(',').where((e) => e.isNotEmpty).toList(),
        safetyLevel: row[8],
        aisle: row[9],
      );
    }).toList();
    notifyListeners();
  }
}