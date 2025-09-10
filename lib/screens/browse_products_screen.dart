import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:list/models/product.dart';
import 'package:list/providers/allergen_provider.dart';
import 'package:list/providers/cart_provider.dart';
import 'package:list/screens/shopping_list_summary_screen.dart';
import 'package:list/widgets/product_card.dart';
import 'package:list/services/product_service.dart';

class BrowseProductsScreen extends StatefulWidget {
  const BrowseProductsScreen({super.key});

  @override
  _BrowseProductsScreenState createState() => _BrowseProductsScreenState();
}

class _BrowseProductsScreenState extends State<BrowseProductsScreen> {
  String _selectedCategory = 'All Categories';
  String _selectedSafetyLevel = 'All Safety Levels';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductService>(context, listen: false).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final allergenProvider = Provider.of<AllergenProvider>(context);
    final productService = Provider.of<ProductService>(context);

    final filteredProducts = productService.products.where((product) {
      final matchesCategory = _selectedCategory == 'All Categories' || product.category == _selectedCategory;
      final matchesSafety = _selectedSafetyLevel == 'All Safety Levels' || product.safetyLevel == _selectedSafetyLevel;
      final matchesSearch = _searchQuery.isEmpty || product.name.toLowerCase().contains(_searchQuery.toLowerCase()) || product.brand.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSafety && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Products'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ShoppingListSummaryScreen()));
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${cartProvider.totalItems}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                  items: <String>['All Categories', 'Beverage', 'Dairy', 'Dairy Alternative', 'Bakery', 'Spreads', 'Snacks']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedSafetyLevel,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedSafetyLevel = newValue!;
                    });
                  },
                  items: <String>['All Safety Levels', 'Safe', 'Check Ingredients', 'Allergen Alert']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  final isAllergen = cartProvider.isAllergen(product);
                  return ProductCard(
                    product: product,
                    isAllergen: isAllergen,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}