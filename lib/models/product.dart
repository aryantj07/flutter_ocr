class Product {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String category;
  final String safetyLevel;
  final List<String> allergens;
  final String aisle;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.category,
    required this.safetyLevel,
    this.allergens = const [],
    this.aisle = '',
  });
}