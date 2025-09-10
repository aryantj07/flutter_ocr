import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:list/providers/allergen_provider.dart';
import 'package:list/providers/cart_provider.dart';
import 'package:list/screens/allergen_preferences_screen.dart';

void main() {
  runApp(const FoodLensApp());
}

class FoodLensApp extends StatelessWidget {
  const FoodLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AllergenProvider()),
        ChangeNotifierProxyProvider<AllergenProvider, CartProvider>(
          create: (context) => CartProvider(Provider.of<AllergenProvider>(context, listen: false)),
          update: (context, allergenProvider, cartProvider) => CartProvider(allergenProvider),
        ),
      ],
      child: MaterialApp(
        title: 'FoodLens',
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'Roboto',
        ),
        home: const AllergenPreferencesScreen(),
      ),
    );
  }
}