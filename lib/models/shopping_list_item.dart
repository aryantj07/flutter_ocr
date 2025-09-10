import 'package:list/models/product.dart';

class ShoppingListItem {
  final Product product;
  int quantity;
  bool isCollected;

  ShoppingListItem({
    required this.product,
    this.quantity = 1,
    this.isCollected = false,
  });

  double get totalPrice => product.price * quantity;
}