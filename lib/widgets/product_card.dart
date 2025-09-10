import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:list/models/product.dart';
import 'package:list/providers/cart_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isAllergen;

  const ProductCard({super.key, required this.product, required this.isAllergen});

  Color get cardColor => isAllergen ? Colors.red[50]! : Colors.white;
  Color get borderColor => isAllergen ? Colors.red : Colors.grey[200]!;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: borderColor),
      ),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: _buildSafetyBadge(product.safetyLevel),
            ),
            const SizedBox(height: 5),
            Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              'by ${product.brand}',
              style: const TextStyle(color: Colors.grey),
            ),
            const Spacer(),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (isAllergen)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.red, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Allergen Alert',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ],
                  ),
                  Text(
                    'Contains: ${product.allergens.join(', ')}',
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
              ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  cartProvider.addItem(product);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyBadge(String safetyLevel) {
    Color color;
    IconData icon;
    switch (safetyLevel) {
      case 'Safe':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'Allergen Alert':
        color = Colors.red;
        icon = Icons.warning;
        break;
      case 'Check Ingredients':
        color = Colors.yellow[800]!;
        icon = Icons.info;
        break;
      default:
        color = Colors.grey;
        icon = Icons.info;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        safetyLevel,
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
