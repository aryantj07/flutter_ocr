import 'package:flutter/material.dart';
import 'package:list/models/product.dart';
import 'package:list/models/shopping_list_item.dart';
import 'package:list/providers/allergen_provider.dart';

class CartProvider with ChangeNotifier {
  final AllergenProvider _allergenProvider;
  final List<ShoppingListItem> _cartItems = [];

  CartProvider(this._allergenProvider);

  List<ShoppingListItem> get cartItems => _cartItems;

  void addItem(Product product) {
    final existingItemIndex = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (existingItemIndex >= 0) {
      _cartItems[existingItemIndex].quantity++;
    } else {
      _cartItems.add(ShoppingListItem(product: product));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void decreaseQuantity(String productId) {
    final itemIndex = _cartItems.indexWhere((item) => item.product.id == productId);
    if (itemIndex >= 0) {
      if (_cartItems[itemIndex].quantity > 1) {
        _cartItems[itemIndex].quantity--;
      } else {
        _cartItems.removeAt(itemIndex);
      }
      notifyListeners();
    }
  }

  void toggleCollected(String productId) {
    final itemIndex = _cartItems.indexWhere((item) => item.product.id == productId);
    if (itemIndex >= 0) {
      _cartItems[itemIndex].isCollected = !_cartItems[itemIndex].isCollected;
      notifyListeners();
    }
  }

  double get totalCartPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItems {
    return _cartItems.length;
  }

  List<ShoppingListItem> get shoppingList {
    return _cartItems.where((item) {
      if (item.product.allergens.isEmpty) {
        return true;
      }
      for (var allergen in item.product.allergens) {
        if (_allergenProvider.selectedAllergens.contains(allergen)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  List<ShoppingListItem> get allergenItems {
    return _cartItems.where((item) {
      if (item.product.allergens.isEmpty) {
        return false;
      }
      for (var allergen in item.product.allergens) {
        if (_allergenProvider.selectedAllergens.contains(allergen)) {
          return true;
        }
      }
      return false;
    }).toList();
  }

  int get collectedItemsCount {
    return _cartItems.where((item) => item.isCollected).length;
  }

  double get collectedItemsPrice {
    return _cartItems.where((item) => item.isCollected).fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  bool isAllergen(Product product) {
    if (product.allergens.isEmpty) return false;
    for (var allergen in product.allergens) {
      if (_allergenProvider.selectedAllergens.contains(allergen)) {
        return true;
      }
    }
    return false;
  }
}