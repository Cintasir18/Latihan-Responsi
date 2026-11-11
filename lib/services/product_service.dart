import 'dart:convert';

import 'package:http/http.dart' as http;

import '../app_config.dart';
import '../models/product.dart';

class ProductService {
  Future<List<Product>> getProducts() async {
    final response = await http
        .get(Uri.parse(AppConfig.productsUrl))
        .timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> productData = data['products'] as List<dynamic>;

      return productData
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Gagal mengambil produk. Kode: ${response.statusCode}');
  }
}
