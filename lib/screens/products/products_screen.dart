import 'package:flutter/material.dart';
import 'package:pelviease_website/backend/providers/product_provider.dart';
import 'package:pelviease_website/screens/products/widgets/products_view.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.error != null) {
          return Center(child: Text(provider.error!));
        }
        return ListView.builder(
          itemCount: provider.products.length,
          itemBuilder: (context, index) {
            final product = provider.products[index];
            return ProductsView(
              product: product,
              isEven: index.isEven,
            );
          },
        );
      },
    );
  }
}
