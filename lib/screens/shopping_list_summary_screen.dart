import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:list/providers/cart_provider.dart';
import 'package:list/screens/shopping_list_screen.dart';

class ShoppingListSummaryScreen extends StatelessWidget {
  const ShoppingListSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final totalItems = cartProvider.totalItems;
    final totalPrice = cartProvider.totalCartPrice;
    final allergenItemsCount = cartProvider.allergenItems.length;
    final nonAllergenItemsCount = totalItems - allergenItemsCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List Summary'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Total: \$${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatusBox(
                  icon: Icons.check_circle,
                  count: nonAllergenItemsCount,
                  label: 'Safe',
                  color: Colors.green,
                ),
                _buildStatusBox(
                  icon: Icons.warning,
                  count: 0, // Placeholder as per image, actual logic might be needed
                  label: 'Check Ingredients',
                  color: Colors.yellow,
                ),
                _buildStatusBox(
                  icon: Icons.error,
                  count: allergenItemsCount,
                  label: 'Allergen',
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (allergenItemsCount > 0)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red),
                ),
                child: Column(
                  children: [
                    Text(
                      '$allergenItemsCount item contain your allergens',
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Consider removing these items for safer shopping',
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ShoppingListScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Generate Shopping List'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBox({required IconData icon, required int count, required String label, required Color color}) {
    return Column(
      children: [
        Icon(icon, color: color, size: 40),
        const SizedBox(height: 4),
        Text('$count', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}