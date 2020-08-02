import 'package:financial_and_tax_planning_app/models/authentication/database.dart';
import 'package:financial_and_tax_planning_app/models/financial/yearly_transactions_model.dart';

class TransactionsModel {
  List<YearlyTransactionsModel> yearlyTransactionsList = [];

  Future addToTransactionsList(String uid, String description, String type,
      String amt, String fromAccount, String toAccount) async {
    DateTime date = DateTime.now();

    // We have to pu dummy data test in every document since a document cannot be empty and subcollections does not count.
    await DatabaseService()
        .mainCollection
        .document(uid)
        .collection('years')
        .document(date.year.toString())
        .setData({'test': 'test'});

    await DatabaseService()
        .mainCollection
        .document(uid)
        .collection('years')
        .document(date.year.toString())
        .collection('months')
        .document(date.month.toString())
        .setData({'test': 'test'});

    await DatabaseService()
        .mainCollection
        .document(uid)
        .collection('years')
        .document(date.year.toString())
        .collection('months')
        .document(date.month.toString())
        .collection('days')
        .document(date.day.toString())
        .setData({'test': 'test'});

    return await DatabaseService()
        .mainCollection
        .document(uid)
        .collection('years')
        .document(date.year.toString())
        .collection('months')
        .document(date.month.toString())
        .collection('days')
        .document(date.day.toString())
        .collection('transactions')
        .document(date.millisecondsSinceEpoch.toString())
        .setData({
      'description': description,
      'type': type,
      'amt': amt,
      'creationDate': date.millisecondsSinceEpoch,
      'fromAccount': fromAccount,
      'toAccount': toAccount,
    });
  }
}
