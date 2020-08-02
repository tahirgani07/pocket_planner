import 'package:financial_and_tax_planning_app/models/financial/monthly_transactions_model.dart';

class YearlyTransactionsModel {
  int year;
  List<MonthlyTransactionsModel> monthlyTransactionsList = [];

  YearlyTransactionsModel(this.year);
}
