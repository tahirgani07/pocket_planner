import 'package:financial_and_tax_planning_app/models/financial/get_icons_for_category.dart';
import 'package:flutter/material.dart';

class TransactionsInternalModel {
  String description;
  String type;
  String amt;
  DateTime creationDate;
  IconData icon;
  String fromAccount;
  String toAccount;

  TransactionsInternalModel({
    this.description,
    this.type,
    this.amt,
    this.creationDate,
    this.fromAccount,
    this.toAccount,
  }) {
    this.icon = GetIconsForCategory().icons[description];
  }
}
