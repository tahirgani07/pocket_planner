import 'package:financial_and_tax_planning_app/models/authentication/database.dart';
import 'package:financial_and_tax_planning_app/models/goals/goals_internal_model.dart';

class GoalsModel {
  ///// Methods after database implementation
  Future addGoal(String uid, String name, String note, double targetAmt,
      double savedAmt, DateTime desiredDate) async {
    DateTime date = DateTime.now();

    return await DatabaseService()
        .mainCollection
        .document(uid)
        .collection('goals')
        .document(date.millisecondsSinceEpoch.toString())
        .setData({
      'name': name,
      'note': note,
      'targetAmt': targetAmt,
      'savedAmt': savedAmt,
      'creationDate': date.millisecondsSinceEpoch,
      'desiredDate': desiredDate.millisecondsSinceEpoch,
      'reached': false,
    });
  }

  // We take the creation date as the creation date acts as an id for individual goals.
  Future deleteGoal(String uid, DateTime creationDate) async {
    return await DatabaseService()
        .mainCollection
        .document(uid)
        .collection('goals')
        .document(creationDate.millisecondsSinceEpoch.toString())
        .delete()
        .catchError((onError) => print(onError.toString()));
  }

  Future addToSavedAmt(
      String uid, GoalsInternalModel goal, double addAmt) async {
    double totalAmt = goal.savedAmt + addAmt;
    bool val = totalAmt >= goal.targetAmt ? true : false;
    return await DatabaseService()
        .mainCollection
        .document(uid)
        .collection('goals')
        .document(goal.creationDate.millisecondsSinceEpoch.toString())
        .updateData({
      'savedAmt': totalAmt,
      'reached': val,
    }).catchError((onError) => print(onError.toString()));
  }
}
