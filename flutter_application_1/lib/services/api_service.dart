import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_application_1/Utils/constValues.dart';

import '../models/product.dart';

class ApiService {
  static Future<List<Product>> fetchProducts() async {
    final response = await http
        .get(Uri.parse('${ConstValues.baseUrl}/a907f54f4d95e9e31711'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static const String baseUrl = '${ConstValues.baseUrl}/7fe4c3d8d85298ece626';

  static Future<Product> fetchProductDetails(String productId) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      if (jsonData['id'] == productId) {
        return Product.fromJson(jsonData);
      } else {
        throw Exception('Product not found');
      }
    } else {
      throw Exception('Failed to load product');
    }
  }
}
