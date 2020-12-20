import 'package:finance_car_manager/models/category.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {

  Category category = categories.first;

  void updateCategoryId(Category selectedCategory) {
    this.category  = selectedCategory;
    notifyListeners();
  }
}