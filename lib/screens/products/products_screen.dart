import 'package:flutter/material.dart';
import 'package:pelviease_website/backend/models/product_model.dart';
import 'package:pelviease_website/screens/products/widgets/products_view.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
          itemCount: dummyProducts.length,
          itemBuilder: (context, index) {
            final product = dummyProducts[index];
            return ProductsView(
              product: product,
              isEven: index.isEven,
            );
          }),
    );
  }
}
