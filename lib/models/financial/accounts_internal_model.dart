class AccountsInternalModel {
  String name;
  double balance;
  String cardNumber;
  DateTime creationDate;
  AccountsInternalModel({
    this.name,
    this.balance,
    this.cardNumber = "",
    this.creationDate,
  });
}
