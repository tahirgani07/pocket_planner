import 'package:financial_and_tax_planning_app/models/financial/daily_transactons_model.dart';

class MonthlyTransactionsModel {
  int monthNo;
  List<DailyTransactionsModel> dailyTransactionsList = [];

  MonthlyTransactionsModel(this.monthNo);
}
