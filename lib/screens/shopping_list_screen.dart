import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:list/models/shopping_list_item.dart';
import 'package:list/providers/cart_provider.dart';
import 'package:list/widgets/shopping_list_item_card.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    // Group items by category for efficient shopping
    final Map<String, List<ShoppingListItem>> groupedItems = {};
    for (var item in cartProvider.cartItems) {
      if (!groupedItems.containsKey(item.product.category)) {
        groupedItems[item.product.category] = [];
      }
      groupedItems[item.product.category]!.add(item);
    }

    final sortedCategories = groupedItems.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Shopping List'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '2 of 5 items collected', // Hardcoded as per image, real logic needed
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      '\$${cartProvider.collectedItemsPrice.toStringAsFixed(2)} / \$${cartProvider.totalCartPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  '${(cartProvider.collectedItemsCount / cartProvider.totalItems * 100).toStringAsFixed(0)}% Complete',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: LinearProgressIndicator(
              value: cartProvider.collectedItemsCount / cartProvider.totalItems,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: sortedCategories.length,
              itemBuilder: (context, index) {
                final category = sortedCategories[index];
                final items = groupedItems[category]!;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            category,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text('${items.length} Items'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ...items.map((item) {
                        final isAllergen = cartProvider.isAllergen(item.product);
                        return ShoppingListItemCard(item: item, isAllergen: isAllergen);
                      }).toList(),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement store navigation logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Starting store navigation...')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Start Navigating',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}