import 'package:financial_and_tax_planning_app/models/shopping/get_Icons_for_shopping_list.dart';
import 'package:flutter/material.dart';

class PanelItem {
  String headerValue;
  List<Item> expandedValue;
  bool isExpanded;

  PanelItem({
    this.headerValue,
    this.expandedValue,
    this.isExpanded = false,
  });
}

class Item {
  String name;
  String category;
  int iconIndex;
  int creationDate;
  IconData iconData;
  bool isSelected;

  Item({
    this.creationDate,
    this.iconIndex,
    this.name,
    this.category,
    this.isSelected = false,
  }) {
    switch (this.category) {
      case "Groceries":
        this.iconData = GetShoppingIcons().grocery[this.iconIndex];
        break;
      case "Electronics":
        this.iconData = GetShoppingIcons().electronics[this.iconIndex];
        break;
      case "Clothes and Accessories":
        this.iconData = GetShoppingIcons().clothes[this.iconIndex];
        break;
      case "Furnitures":
        this.iconData = GetShoppingIcons().furnitures[this.iconIndex];
        break;
      case "Foods":
        this.iconData = GetShoppingIcons().foods[this.iconIndex];
        break;
    }
  }
}
