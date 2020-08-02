import 'package:financial_and_tax_planning_app/models/extras/my_icons_icons.dart';
import 'package:flutter/material.dart';

// Defines the internal structure of a shopping list.
class ShoppingListInternalModel {
  String name;
  String category;
  double totalAmt;
  int noOfItems;
  IconData iconData;
  DateTime creationDate;

  ShoppingListInternalModel({
    this.name,
    this.category,
    this.totalAmt,
    this.noOfItems,
    this.creationDate,
  }) {
    switch (this.category) {
      case "Groceries":
        this.iconData = MyIcons.shopping_icon;
        break;
      case "Electronics":
        this.iconData = MyIcons.electronics_icon;
        break;
      case "Clothes and Accessories":
        this.iconData = MyIcons.dressandaccessoriesicon;
        break;
      case "Furnitures":
        this.iconData = MyIcons.furnitures_icon;
        break;
      case "Foods":
        this.iconData = MyIcons.fast_foods_icon;
        break;
    }
  }
}
