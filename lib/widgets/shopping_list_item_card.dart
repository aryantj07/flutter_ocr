import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:list/models/shopping_list_item.dart';
import 'package:list/providers/cart_provider.dart';

class ShoppingListItemCard extends StatelessWidget {
  final ShoppingListItem item;
  final bool isAllergen;

  const ShoppingListItemCard({super.key, required this.item, required this.isAllergen});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: isAllergen ? Colors.red[50] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                cartProvider.toggleCollected(item.product.id);
              },
              child: Icon(
                item.isCollected ? Icons.check_circle : Icons.circle_outlined,
                color: item.isCollected ? Colors.green : Colors.grey,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'by ${item.product.brand}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Qty: ${item.quantity}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  if (isAllergen)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.warning, color: Colors.red, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Contains allergens: ${item.product.allergens.join(', ')}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Text(
              '\$${item.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}