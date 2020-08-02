import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_and_tax_planning_app/models/financial/accounts_internal_model.dart';
import 'package:financial_and_tax_planning_app/models/financial/transactions_internal_model.dart';
import 'package:financial_and_tax_planning_app/models/goals/goals_internal_model.dart';
import 'package:financial_and_tax_planning_app/models/shopping/shopping_list_internal_model.dart';
import 'package:financial_and_tax_planning_app/models/shopping/shopping_list_item_internal_model.dart';

class DatabaseService {
  final String uid;
  int creationDateOfShoppingList;

  DatabaseService({this.uid, this.creationDateOfShoppingList});

  // Main collection reference.
  CollectionReference mainCollection = Firestore.instance.collection('main');

  ////////////////////////// GOALS MODEL

  // goal list from snapshot
  List<GoalsInternalModel> _goalListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return GoalsInternalModel(
        name: doc.data['name'],
        note: doc.data['note'],
        targetAmt: doc.data['targetAmt'],
        savedAmt: doc.data['savedAmt'],
        creationDate:
            DateTime.fromMillisecondsSinceEpoch(doc.data['creationDate']),
        desiredDate:
            DateTime.fromMillisecondsSinceEpoch(doc.data['desiredDate']),
        reached: doc.data['reached'],
      );
    }).toList();
  }

  // get shoppingList stream
  Stream<List<GoalsInternalModel>> get goalsList {
    if (uid == null) print("uid is null in getter of goalsList");
    return mainCollection
        .document(uid)
        .collection("goals")
        .snapshots()
        .map(_goalListFromSnapshot);
  }

  ////////////////////////////// SHOPPING MODEL
  List<ShoppingListInternalModel> _listOfShoppingListsFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return ShoppingListInternalModel(
        name: doc.data['name'],
        category: doc.data['category'],
        totalAmt: doc.data['totalAmt'],
        noOfItems: doc.data['noOfItems'],
        creationDate:
            DateTime.fromMillisecondsSinceEpoch(doc.data['creationDate']),
      );
    }).toList();
  }

  Stream<List<ShoppingListInternalModel>> get listOfShoppingLists {
    if (uid == null) print("uid is null in getter of listOfShoppingLists");
    return mainCollection
        .document(uid)
        .collection("shopping")
        .snapshots()
        .map(_listOfShoppingListsFromSnapshot);
  }

  // get itemList of a particular shopppingList
  Stream<List<Item>> get itemList {
    return mainCollection
        .document(this.uid)
        .collection('shopping')
        .document(this.creationDateOfShoppingList.toString())
        .collection('items')
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map((doc) {
        return Item(
          creationDate: doc.data['creationDate'],
          name: doc.data['name'],
          iconIndex: doc.data['iconIndex'],
          category: doc.data['category'],
          isSelected: doc.data['isSelected'],
        );
      }).toList();
    });
  }

  ///////////////////////////////// ACCOUNTS MODEL
  List<AccountsInternalModel> _listOfAccountsFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return AccountsInternalModel(
        name: doc.data['name'],
        balance: doc.data['balance'],
        cardNumber: doc.data['cardNumber'],
        creationDate:
            DateTime.fromMillisecondsSinceEpoch(doc.data['creationDate']),
      );
    }).toList();
  }

  Stream<List<AccountsInternalModel>> get accountsList {
    return mainCollection
        .document(uid)
        .collection("accounts")
        .snapshots()
        .map(_listOfAccountsFromSnapshot);
  }

  //////////////////////////////// TRANSACTIONS MODEL
  List<String> _stringOfDaysFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return doc.documentID;
    }).toList();
  }

  Future<List<String>> getDaysAsFuture(String uid, int year, int month) {
    return mainCollection
        .document(uid)
        .collection('years')
        .document(year.toString())
        .collection('months')
        .document(month.toString())
        .collection('days')
        .getDocuments()
        .then(_stringOfDaysFromSnapshot);
  }

  List<TransactionsInternalModel> _listOfTransactionsFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return TransactionsInternalModel(
        description: doc.data['description'],
        type: doc.data['type'],
        amt: doc.data['amt'].toString(),
        creationDate:
            DateTime.fromMillisecondsSinceEpoch(doc.data['creationDate']),
        fromAccount: doc.data['fromAccount'],
        toAccount: doc.data['toAccount'],
      );
    }).toList();
  }

  Future<List<TransactionsInternalModel>> transactionsList(
      String uid, int year, int month, int day) {
    return mainCollection
        .document(uid)
        .collection("years")
        .document(year.toString())
        .collection('months')
        .document(month.toString())
        .collection('days')
        .document(day.toString())
        .collection('transactions')
        .getDocuments()
        .then(_listOfTransactionsFromSnapshot);
  }

  List<String> _listOfStringFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return doc.documentID;
    }).toList();
  }

  Stream<List<String>> transYearsListStream(String uid) {
    return mainCollection
        .document(uid)
        .collection('years')
        .snapshots()
        .map(_listOfStringFromSnapshot);
  }

  Stream<List<String>> transMonthsListStream(String uid, String year) {
    return mainCollection
        .document(uid)
        .collection('years')
        .document(year)
        .collection('months')
        .snapshots()
        .map(_listOfStringFromSnapshot);
  }

  Future<List<String>> transMonthsListFuture(String uid, String year) {
    return mainCollection
        .document(uid)
        .collection('years')
        .document(year)
        .collection('months')
        .getDocuments()
        .then(_listOfStringFromSnapshot);
  }
}
