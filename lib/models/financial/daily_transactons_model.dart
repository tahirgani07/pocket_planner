import 'package:financial_and_tax_planning_app/models/financial/transactions_internal_model.dart';

class DailyTransactionsModel {
  int day;
  List<TransactionsInternalModel> actualtransactionsList = [];
  DailyTransactionsModel(this.day);
}
