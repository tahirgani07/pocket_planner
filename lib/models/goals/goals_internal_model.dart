class GoalsInternalModel {
  String name;
  String note;
  double targetAmt;
  double savedAmt;
  DateTime creationDate;
  DateTime desiredDate;
  bool reached;

  GoalsInternalModel({
    this.name,
    this.note = "",
    this.targetAmt,
    this.savedAmt = 0.0,
    this.creationDate,
    this.desiredDate,
    this.reached = false,
  });
}
