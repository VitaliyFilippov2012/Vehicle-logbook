import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Category {
  final String categoryId;
  String get getCategoryId => categoryId;
  final String name;
  final IconData icon;

  Category({this.categoryId, this.name, this.icon});
}

final allCategory = Category(
  categoryId: "e3581151-870d-4ea4-9d34-9756ffd87f84"+"a1bde902-b012-4b2e-b631-95b19c8ef795"+"6771dfdb-b42d-4538-87c6-9ed9af792a60",
  name: "All",
  icon: Icons.search,
);

final planingEventCategory = Category(
  categoryId: "e3581151-870d-4ea4-9d34-9756ffd87f84"+"a1bde902-b012-4b2e-b631-95b19c8ef795"+"6771dfdb-b42d-4538-87c6-9ed9af792a60",
  name: "Planned",
  icon: Icons.notifications_active,
);

final fuelCategory = Category(
  categoryId: "e3581151-870d-4ea4-9d34-9756ffd87f84",
  name: "Fuel",
  icon: Icons.opacity,
);

final serviceCategory = Category(
  categoryId: "6771dfdb-b42d-4538-87c6-9ed9af792a60",
  name: "Service",
  icon: Icons.build,
);

final otherCategory = Category(
  categoryId: "a1bde902-b012-4b2e-b631-95b19c8ef795",
  name: "Other",
  icon: Icons.add_shopping_cart,
);

final categories = [
  allCategory,
  planingEventCategory,
  fuelCategory,
  serviceCategory,
  otherCategory
];