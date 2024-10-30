import 'package:flutter/material.dart';
import 'package:flutter_application_1/Utils/appColors.dart';
import 'package:flutter_application_1/Utils/appfonts.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductDetail extends StatelessWidget {
  final String productId;

  const ProductDetail({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: FutureBuilder<Product>(
        future: ApiService.fetchProductDetails(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final product = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Image.network(product.imageUrl)),
                    const SizedBox(height: 10),
                    Text(
                      product.name,
                      style: const TextStyle(
                          fontSize: AppFonts.font24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      product.price,
                      style: const TextStyle(
                          fontSize: AppFonts.font20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.green1),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      product.description,
                      style: const TextStyle(fontSize: AppFonts.font16),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
