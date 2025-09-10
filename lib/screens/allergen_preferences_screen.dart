import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:list/providers/allergen_provider.dart';
import 'package:list/screens/browse_products_screen.dart';

class AllergenPreferencesScreen extends StatelessWidget {
  const AllergenPreferencesScreen({super.key});

  final List<String> allergens = const [
    'Milk', 'Eggs', 'Fish', 'Shellfish', 'Tree nuts', 'Peanuts', 'Wheat', 'Soybeans', 'Sesame', 'Mustard', 'Celery', 'Lupin'
  ];

  @override
  Widget build(BuildContext context) {
    final allergenProvider = Provider.of<AllergenProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FoodLens'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Set Your Allergen Preferences',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select any allergens you need to avoid. We\'ll help you shop safely.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: allergens.length,
                itemBuilder: (context, index) {
                  final allergen = allergens[index];
                  final isSelected = allergenProvider.isAllergenSelected(allergen);
                  return GestureDetector(
                    onTap: () {
                      if (isSelected) {
                        allergenProvider.removeAllergen(allergen);
                      } else {
                        allergenProvider.addAllergen(allergen);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green.withOpacity(0.1) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? Colors.green : Colors.transparent,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          allergen,
                          style: TextStyle(
                            color: isSelected ? Colors.green : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BrowseProductsScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}