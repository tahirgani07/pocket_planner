import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_and_tax_planning_app/models/authentication/database.dart';
import 'package:financial_and_tax_planning_app/models/shopping/shopping_list_internal_model.dart';
import 'package:financial_and_tax_planning_app/models/shopping/shopping_list_item_internal_model.dart';

// Sturcture of a shopping list in database ---->
// main(collection) -> uid(document) -> shopping(subcollection) -> listId(document - this will be its creation date) -> items(collection - this will be all the items inside that shopping list) -> itemId(document)
class ShoppingListModel {
  List<ShoppingListInternalModel> shoppingList = [];

  Future addNewShoppingList(
      String uid, String name, String category, int creationDate) async {
    return await DatabaseService()
        .mainCollection
        .document(uid)
        .collection('shopping')
        .document(creationDate.toString())
        .setData({
      'name': name,
      'category': category,
      'totalAmt': 0.0,
      'noOfItems': 0,
      'creationDate': creationDate,
    });
  }

  int isItemAlreadyAddedInList(List<Item> itemList, Item item) {
    for (Item i in itemList) {
      if (i.name == item.name) return i.creationDate;
    }
    return null;
  }

  Future removeListItem(
      String uid, int creationDateOfShoppingList, int indexOfItemInList) async {
    return await DatabaseService()
        .mainCollection
        .document(uid)
        .collection('shopping')
        .document(creationDateOfShoppingList.toString())
        .collection('items')
        .document(indexOfItemInList.toString())
        .delete()
        .catchError((onError) => print(onError.toString()));
  }

  // noOfSelectedItems will act as the index of the items of the shoppingList
  Future addListItem(
      String uid, Item item, int creationDateOfShoppingList) async {
    DateTime date = DateTime.now();
    return await DatabaseService()
        .mainCollection
        .document(uid)
        .collection('shopping')
        .document(creationDateOfShoppingList.toString())
        .collection('items')
        .document(date.millisecondsSinceEpoch.toString())
        .setData({
      'name': item.name,
      'creationDate': date.millisecondsSinceEpoch,
      'iconIndex': item.iconIndex,
      'category': item.category,
      'isSelected': item.isSelected,
    });
  }

  Future updateNoOfSelectedItemOfShoppingList(
      String uid, int creationDateOfShoppingList, int noOfSelectedItems) async {
    return await DatabaseService()
        .mainCollection
        .document(uid)
        .collection('shopping')
        .document(creationDateOfShoppingList.toString())
        .updateData({
      'noOfItems': noOfSelectedItems,
    }).catchError((onError) => print(onError.toString()));
  }

  // Deleting a document does not delete its subcollections, so you first have to dlete all the subcollections inside the document and then the document.
  deleteAList(String uid, int creationDateOfShoppingList) async {
    await DatabaseService()
        .mainCollection
        .document(uid)
        .collection('shopping')
        .document(creationDateOfShoppingList.toString())
        .collection('items')
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot s in snapshot.documents) {
        s.reference.delete();
      }
    });
    return await DatabaseService()
        .mainCollection
        .document(uid)
        .collection('shopping')
        .document(creationDateOfShoppingList.toString())
        .delete()
        .catchError((onError) => print(onError.toString()));
  }
}
