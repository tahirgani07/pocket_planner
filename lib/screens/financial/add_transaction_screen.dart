import 'package:auto_size_text/auto_size_text.dart';
import 'package:financial_and_tax_planning_app/models/extras/my_color.dart';
import 'package:financial_and_tax_planning_app/models/financial/accounts_internal_model.dart';
import 'package:financial_and_tax_planning_app/models/authentication/database.dart';
import 'package:financial_and_tax_planning_app/models/financial/transaction_categories.dart';
import 'package:financial_and_tax_planning_app/models/financial/transactions_model.dart';
import 'package:financial_and_tax_planning_app/screens/financial/calculator.dart';
import 'package:financial_and_tax_planning_app/screens/financial/select_category_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class AddTransactionScreen extends StatefulWidget {
  static String categoryDesc;

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
    with SingleTickerProviderStateMixin {
  FirebaseUser user;
  List<AccountsInternalModel> accountsList;

  TabController _tabController;
  TextEditingController calculatorTextController;
  String calculatorText = "0";
  String accountsDropDownVal = "CASH";
  String anotherAccountsDropDownVal = "...Outside";
  IconData accountsCategoryDropDownVal;

  List<String> tabList = ["INCOME", "EXPENSE", "TRANSFER"];
  List<String> listOfAccounts = [];
  List<String> listOfAccounts2 = [];

  TextStyle labelTextStyle = GoogleFonts.aBeeZee(
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.6,
  );

  TextStyle buttonTextStyle = GoogleFonts.aBeeZee(
    fontSize: 17,
    color: Colors.white,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.6,
  );

  double get maxHeight => MediaQuery.of(context).size.height;
  double get maxWidth => MediaQuery.of(context).size.width;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    calculatorTextController = new TextEditingController(text: "0");
    AddTransactionScreen.categoryDesc = "Food & Drinks";
  }

  @override
  void dispose() {
    _tabController.dispose();
    calculatorTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    accountsList = Provider.of<List<AccountsInternalModel>>(context);

    calculatorTextController.addListener(() {
      setState(() {
        calculatorText = calculatorTextController.text;
      });
    });

    listOfAccounts = accountsList.map((i) {
      return i.name;
    }).toList();
    listOfAccounts2 = ["...Outside"];
    listOfAccounts2.addAll(listOfAccounts);

    return WillPopScope(
      onWillPop: () => _onBackButtonPress(context),
      child: Scaffold(
        backgroundColor: MyColor.mainOrange,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () => _onBackButtonPress(context),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () async {
                String amt = calculatorText;
                if (Calculator.operatorCount > 0) {
                  Toast.show(
                    "Please correct the amount.",
                    context,
                    duration: Toast.LENGTH_LONG,
                  );
                  return;
                }
                if (double.parse(amt).round() == 0) {
                  Toast.show(
                    "Transaction Amount cannot be zero",
                    context,
                    duration: Toast.LENGTH_LONG,
                  );
                  return;
                }
                String fromAccountName = accountsDropDownVal;
                String toAccountName = anotherAccountsDropDownVal;

                String typeOfTransaction;
                if (_tabController.index == 0)
                  typeOfTransaction = "Income";
                else if (_tabController.index == 1)
                  typeOfTransaction = "Expense";
                else
                  typeOfTransaction = "Transfer";

                AccountsInternalModel fromAccount =
                    _getAccountByName(accountsList, fromAccountName);
                AccountsInternalModel toAccount =
                    _getAccountByName(accountsList, toAccountName);

                _changeAccountsBalanceAfterTransaction(
                  typeOfTransaction: typeOfTransaction,
                  fromAccount: fromAccount,
                  toAccount: toAccount,
                  amt: double.parse(amt),
                );

                await TransactionsModel().addToTransactionsList(
                  user.uid,
                  AddTransactionScreen.categoryDesc,
                  typeOfTransaction,
                  amt,
                  fromAccountName,
                  toAccountName,
                );

                _onBackButtonPress(context);
              },
            ),
          ],
          title: Text(
            "Add Transaction",
            style: GoogleFonts.aBeeZee(
              fontSize: 22,
              color: Colors.white,
              letterSpacing: 0.6,
            ),
          ),
          bottom: TabBar(
              indicatorColor: Colors.white,
              controller: _tabController,
              tabs: tabList.map((title) {
                return new Tab(
                  child: AutoSizeText(
                    title,
                    style: GoogleFonts.aBeeZee(
                      fontSize: 18,
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                  ),
                );
              }).toList()),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            TransactionCategoriesModel("Income"),
            TransactionCategoriesModel("Expense"),
            TransactionCategoriesModel("Transfer"),
          ].map((transactionCategoryModel) {
            return Column(
              children: <Widget>[
                Container(
                  height: 150,
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            transactionCategoryModel.transactionSign,
                            style: GoogleFonts.aBeeZee(
                              fontSize: 70,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: AutoSizeText(
                              calculatorText,
                              style: GoogleFonts.aBeeZee(
                                fontSize: 100,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.right,
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "INR",
                            style: GoogleFonts.aBeeZee(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: maxWidth / 2,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                transactionCategoryModel.transactionType ==
                                        "Transfer"
                                    ? "From Account"
                                    : "Account",
                                style: labelTextStyle,
                              ),
                              Theme(
                                data: ThemeData(
                                  canvasColor: Colors.grey[800],
                                ),
                                child: DropdownButton(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  ),
                                  value: accountsDropDownVal,
                                  items: listOfAccounts.map((String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: buttonTextStyle,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String newValue) {
                                    if (newValue ==
                                        anotherAccountsDropDownVal) {
                                      Toast.show(
                                          "Both From and to Accounts cannot be same",
                                          context,
                                          duration: Toast.LENGTH_LONG);
                                    } else {
                                      setState(() {
                                        accountsDropDownVal = newValue;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // If Transaction type is transfer then category is not needed instead to which account it should be transfered that should be asked
                      transactionCategoryModel.transactionType == "Transfer"
                          ? Container(
                              width: maxWidth / 2,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "To Account",
                                      style: labelTextStyle,
                                    ),
                                    Theme(
                                      data: ThemeData(
                                        canvasColor: Colors.grey[800],
                                      ),
                                      child: DropdownButton(
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.white,
                                        ),
                                        value: anotherAccountsDropDownVal,
                                        items:
                                            listOfAccounts2.map((String value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: buttonTextStyle,
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String newValue) {
                                          if (newValue == accountsDropDownVal) {
                                            Toast.show(
                                                "Both From and to Accounts cannot be same",
                                                context,
                                                duration: Toast.LENGTH_LONG);
                                          } else {
                                            setState(() {
                                              anotherAccountsDropDownVal =
                                                  newValue;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              width: maxWidth / 2,
                              child: Center(
                                child: FlatButton(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        "Category",
                                        style: labelTextStyle,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 12, bottom: 12),
                                        child: Text(
                                          AddTransactionScreen.categoryDesc,
                                          style: buttonTextStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SelectCategoryScreen(
                                          transactionCategoryModel,
                                        ),
                                      ),
                                    );
                                  },
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.white30,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                Calculator(calculatorTextController),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  _onBackButtonPress(BuildContext context) {
    try {
      // Resetting these values
      Calculator.operatorCount = 0;
      Calculator.dotCount = 0;

      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  AccountsInternalModel _getAccountByName(
      List<AccountsInternalModel> accountsList, String nameOfAccount) {
    for (AccountsInternalModel a in accountsList) {
      if (a.name == nameOfAccount) return a;
    }
    return null;
  }

  Future _changeAccountsBalanceAfterTransaction({
    String typeOfTransaction,
    AccountsInternalModel fromAccount,
    AccountsInternalModel toAccount,
    double amt,
  }) async {
    if (typeOfTransaction == "Income" || typeOfTransaction == "Expense") {
      double totalAmt = (typeOfTransaction == "Income")
          ? (fromAccount.balance + amt)
          : (fromAccount.balance - amt);

      return await DatabaseService()
          .mainCollection
          .document(user.uid)
          .collection('accounts')
          .document(fromAccount.creationDate.millisecondsSinceEpoch.toString())
          .updateData({
        'balance': totalAmt,
      });
    } else {
      double fromAccountTotalBal = fromAccount.balance - amt;
      double toAccountTotalBal = toAccount.balance + amt;

      await DatabaseService()
          .mainCollection
          .document(user.uid)
          .collection('accounts')
          .document(fromAccount.creationDate.millisecondsSinceEpoch.toString())
          .updateData({
        'balance': fromAccountTotalBal,
      });

      return await DatabaseService()
          .mainCollection
          .document(user.uid)
          .collection('accounts')
          .document(toAccount.creationDate.millisecondsSinceEpoch.toString())
          .updateData({
        'balance': toAccountTotalBal,
      });
    }
  }
}
