import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_and_tax_planning_app/models/authentication/database.dart';
import 'package:financial_and_tax_planning_app/models/financial/accounts_internal_model.dart';

class AccountsModel {
  List<AccountsInternalModel> accountsList = [
    // Cash account will be already present.
    AccountsInternalModel(
      name: "Cash",
      balance: 0,
    ),
  ];

  Future addNewAccount(
      String uid, String name, double balance, String cardNo) async {
    name = name.trim().toUpperCase();
    DateTime date = DateTime.now();
    bool error = false;
    await DatabaseService()
        .mainCollection
        .document(uid)
        .collection('accounts')
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        if (ds.data['name'].toUpperCase() == name) {
          error = true;
          return;
        }
      }
    });
    if (error) return error;
    return await DatabaseService()
        .mainCollection
        .document(uid)
        .collection('accounts')
        .document(date.millisecondsSinceEpoch.toString())
        .setData({
      'name': name,
      'balance': balance,
      'cardNumber': cardNo,
      'creationDate': date.millisecondsSinceEpoch,
    }).catchError((e) => print(e.toString()));
  }

  Future deleteAccount(String uid, int creationDate) async {
    return await DatabaseService()
        .mainCollection
        .document(uid)
        .collection('accounts')
        .document(creationDate.toString())
        .delete()
        .catchError((e) => print(e.toString()));
  }
}
