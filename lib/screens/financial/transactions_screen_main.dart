import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:financial_and_tax_planning_app/models/authentication/database.dart';
import 'package:financial_and_tax_planning_app/models/extras/dots_indicator.dart';
import 'package:financial_and_tax_planning_app/models/extras/my_color.dart';
import 'package:financial_and_tax_planning_app/models/financial/accounts_internal_model.dart';
import 'package:financial_and_tax_planning_app/models/financial/accounts_model.dart';
import 'package:financial_and_tax_planning_app/models/financial/transactions_internal_model.dart';
import 'package:financial_and_tax_planning_app/screens/app_drawer.dart';
import 'package:financial_and_tax_planning_app/screens/financial/add_transaction_screen.dart';
import 'package:financial_and_tax_planning_app/screens/others/fade_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class TransactionsScreen extends StatefulWidget {
  final String uid;
  TransactionsScreen({this.uid});

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  FirebaseUser user;
  var currentPageValue = 0.0;
  Future<List<String>> daysAsFuture;
  List<AccountsInternalModel> accountsList;

  double get maxHeight => MediaQuery.of(context).size.height;
  double get maxWidth => MediaQuery.of(context).size.width;

  String yearsDropDownVal = DateTime.now().year.toString();
  int indexForMonthsDropDownVal = 0;

  List<String> transYearsList = [];

  Stream<List<String>> transYearsStream;

  final _accountsCardController = PageController(
    initialPage: 0,
    viewportFraction: 0.85,
  );

  TextEditingController _accountNameController;
  TextEditingController _accountBalanceController;
  TextEditingController _accountNoController;

  @override
  void initState() {
    super.initState();

    _accountNameController = new TextEditingController();
    _accountBalanceController = new TextEditingController();
    _accountNoController = new TextEditingController();

    Future.delayed(Duration.zero, () {
      setState(() {
        yearsDropDownVal = yearsDropDownVal;
        indexForMonthsDropDownVal = indexForMonthsDropDownVal;
      });
    });
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    _accountBalanceController.dispose();
    _accountNoController.dispose();

    transYearsStream.drain();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);

    accountsList = Provider.of<List<AccountsInternalModel>>(context);

    transYearsStream = user != null
        ? DatabaseService().transYearsListStream(user.uid)
        : Stream.value([]);
    transYearsStream.listen((data) {
      transYearsList = data ?? [];
    });

    // Keep track of page on the PageView for my accounts
    _accountsCardController.addListener(() {
      setState(() {
        currentPageValue = _accountsCardController.page;
      });
    });

    return StreamBuilder<List<String>>(
        stream: user != null
            ? DatabaseService()
                .transMonthsListStream(user.uid, yearsDropDownVal)
            : null,
        builder: (context, monthListSnapshot) {
          bool monthListSnapshotCheck;
          try {
            monthListSnapshotCheck = monthListSnapshot != null &&
                monthListSnapshot.data.isNotEmpty &&
                monthListSnapshot.hasData;
          } catch (e) {
            print(e.toString());
          }

          if (monthListSnapshotCheck ?? false) {
            // Taking the days as future so thet they can be added in the FutureBuilder
            daysAsFuture = DatabaseService()
                .getDaysAsFuture(
                  user != null ? user.uid : '',
                  int.parse(yearsDropDownVal),
                  int.parse(monthListSnapshot.data[indexForMonthsDropDownVal]),
                )
                .catchError((e) => print(e.toString()));
          } else {
            daysAsFuture = null;
          }

          return Scaffold(
            backgroundColor: MyColor.mainPurple,
            floatingActionButton: FloatingActionButton(
              elevation: 24,
              backgroundColor: MyColor.mainPurple,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddTransactionScreen(),
                  ),
                );
              },
              child: Icon(Icons.add),
            ),
            drawer: AppDrawer(0),
            body: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Builder(builder: (context) {
                      return AppBar(
                        elevation: 0,
                        leading: IconButton(
                          icon: Icon(
                            MdiIcons.menu,
                            color: Colors.white,
                          ),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                        title: FadeAnimation(
                          1,
                          Text(
                            "Wallet",
                            style: GoogleFonts.aBeeZee(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        centerTitle: true,
                      );
                    }),
                    Container(
                      height: maxHeight / 2.8,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 48, right: 48),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                FadeAnimation(
                                  1.2,
                                  Text(
                                    "Cards",
                                    style: GoogleFonts.aBeeZee(
                                      fontSize: 23,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      _showAddAccountsAlertBox(context),
                                  child: Container(
                                    padding: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: MyColor.mainPurple,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: PageView.builder(
                              controller: _accountsCardController,
                              itemCount: accountsList != null
                                  ? accountsList.length
                                  : 0,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: (index == currentPageValue)
                                      ? EdgeInsets.all(10)
                                      : EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22)),
                                    color: MyColor.mainOrange,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              width: maxWidth / 4,
                                              alignment: Alignment.centerLeft,
                                              child: AutoSizeText(
                                                "Current Balance",
                                                maxLines: 1,
                                                style: GoogleFonts.aBeeZee(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.grey[200],
                                                ),
                                              ),
                                            ),
                                            // Bank Name
                                            Container(
                                              width: maxWidth / 4,
                                              alignment: Alignment.centerRight,
                                              child: AutoSizeText(
                                                accountsList[index].name,
                                                style: GoogleFonts.aBeeZee(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 3),
                                        Container(
                                          width: maxWidth / 1.8,
                                          child: AutoSizeText(
                                            "₹${accountsList[index].balance}",
                                            maxLines: 1,
                                            style: GoogleFonts.aBeeZee(
                                              color:
                                                  accountsList[index].balance <
                                                          0
                                                      ? Colors.red[400]
                                                      : Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 25.0,
                                            ),
                                          ),
                                        ),
                                        /*AutoSizeText(
                                          "${accountsList[index].cardNumber}",
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 15.0,
                                          ),
                                        ),*/
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            alignment: Alignment.bottomRight,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                              onPressed: () async {
                                                if (accountsList[index]
                                                        .name
                                                        .trim()
                                                        .toLowerCase() ==
                                                    "cash") {
                                                  errorFlushBar(
                                                      context,
                                                      "Error",
                                                      "Cash account cannot be deleted");
                                                  return;
                                                }
                                                return await AccountsModel()
                                                    .deleteAccount(
                                                        user.uid,
                                                        accountsList[index]
                                                            .creationDate
                                                            .millisecondsSinceEpoch);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            height: maxHeight / 15,
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: DotsIndicator(
                                activeColor: MyColor.mainOrange,
                                controller: _accountsCardController,
                                itemCount: accountsList != null
                                    ? accountsList.length
                                    : 0,
                                spacingBetweenDots: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                //////////////////////////////////////////
                ////////////////////////////////////////////////
                /////////////////////////////////////////// Transactions
                Positioned.fill(
                  child: DraggableScrollableSheet(
                      initialChildSize: 0.59,
                      minChildSize: 0.59,
                      maxChildSize: 1,
                      builder: (context, scrollController) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: SafeArea(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                ),
                              ),
                              child: (monthListSnapshotCheck ?? false)
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      child: FutureBuilder<List<String>>(
                                        future: daysAsFuture,
                                        builder: (context, daysSnapshot) {
                                          List<String> daysList =
                                              daysSnapshot.data ?? [];
                                          int lengthOfDaysList =
                                              daysList.length;
                                          return CustomScrollView(
                                            controller: scrollController,
                                            slivers: <Widget>[
                                              SliverList(
                                                  delegate:
                                                      SliverChildListDelegate([
                                                GestureDetector(
                                                  onTap: () => Flushbar(
                                                    icon: Icon(
                                                      Icons.help_outline,
                                                      color: Colors.white,
                                                    ),
                                                    message:
                                                        'Swipe the list up',
                                                    duration:
                                                        Duration(seconds: 3),
                                                    flushbarPosition:
                                                        FlushbarPosition.TOP,
                                                  )..show(context),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 8.0,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 10,
                                                                  bottom: 5),
                                                          height: 6,
                                                          width: 60,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey[300],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ])),
                                              SliverAppBar(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(40),
                                                    topRight:
                                                        Radius.circular(40),
                                                  ),
                                                ),
                                                backgroundColor: Colors.white,
                                                automaticallyImplyLeading:
                                                    false,
                                                floating: true,
                                                //pinned: true,
                                                title: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      FadeAnimation(
                                                        1.3,
                                                        AutoSizeText(
                                                          "Transactions",
                                                          style: GoogleFonts
                                                              .aBeeZee(
                                                            fontSize: 23,
                                                            color: MyColor
                                                                .mainPurple,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            letterSpacing: 0.6,
                                                          ),
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    5, 0, 0, 2),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: MyColor
                                                                  .mainPurple
                                                                  .withOpacity(
                                                                      0.1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                5,
                                                              ),
                                                            ),
                                                            child:
                                                                FadeAnimation(
                                                              1.3,
                                                              DropdownButton(
                                                                  isDense: true,
                                                                  underline:
                                                                      SizedBox(),
                                                                  value: monthListSnapshot
                                                                          .data[
                                                                      indexForMonthsDropDownVal],
                                                                  items: monthListSnapshot
                                                                      .data
                                                                      .map((String
                                                                          month) {
                                                                    return DropdownMenuItem(
                                                                      value:
                                                                          month,
                                                                      child:
                                                                          Text(
                                                                        _monthToName(
                                                                          int.parse(
                                                                              month),
                                                                        ),
                                                                        style: GoogleFonts.aBeeZee(
                                                                            fontSize:
                                                                                16),
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                  onChanged: (String
                                                                      newValue) {
                                                                    setState(
                                                                        () {
                                                                      indexForMonthsDropDownVal = _getIndexOfMonthInListFromMonthNo(
                                                                          monthListSnapshot
                                                                              .data,
                                                                          newValue);
                                                                    });
                                                                  }),
                                                            ),
                                                          ),
                                                          SizedBox(width: 5),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    5, 0, 0, 2),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: MyColor
                                                                  .mainPurple
                                                                  .withOpacity(
                                                                      0.1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                5,
                                                              ),
                                                            ),
                                                            child:
                                                                FadeAnimation(
                                                              1.3,
                                                              DropdownButton(
                                                                  isDense: true,
                                                                  underline:
                                                                      SizedBox(),
                                                                  value:
                                                                      yearsDropDownVal,
                                                                  items: transYearsList
                                                                      .map((String
                                                                          year) {
                                                                    return DropdownMenuItem(
                                                                      value:
                                                                          year,
                                                                      child: Text(
                                                                          year,
                                                                          style:
                                                                              GoogleFonts.aBeeZee(
                                                                            fontSize:
                                                                                16,
                                                                          )),
                                                                    );
                                                                  }).toList(),
                                                                  onChanged: (String
                                                                      newValue) async {
                                                                    setState(
                                                                        () {
                                                                      yearsDropDownVal =
                                                                          newValue;
                                                                    });
                                                                  }),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SliverList(
                                                delegate:
                                                    SliverChildBuilderDelegate(
                                                  (context, index) {
                                                    return Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 6, 0, 6),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          // Date - Checking if it is todays date or yesterday or any other day.
                                                          Text(
                                                            _showDateString(
                                                                daysList[
                                                                    lengthOfDaysList -
                                                                        index -
                                                                        1],
                                                                monthListSnapshot
                                                                        .data[
                                                                    indexForMonthsDropDownVal],
                                                                yearsDropDownVal),
                                                            style: GoogleFonts
                                                                .aBeeZee(
                                                              fontSize: 17,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          SizedBox(height: 10),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .stretch,
                                                            children: <Widget>[
                                                              FutureBuilder<
                                                                  List<
                                                                      TransactionsInternalModel>>(
                                                                future: DatabaseService()
                                                                    .transactionsList(
                                                                  user != null
                                                                      ? user.uid
                                                                      : null,
                                                                  int.parse(
                                                                      yearsDropDownVal),
                                                                  int.parse(monthListSnapshot
                                                                          .data[
                                                                      indexForMonthsDropDownVal]),
                                                                  int.parse(
                                                                    daysList[
                                                                        lengthOfDaysList -
                                                                            index -
                                                                            1],
                                                                  ),
                                                                ),
                                                                builder: (context,
                                                                    transactionsSnapshot) {
                                                                  List<TransactionsInternalModel>
                                                                      currentTransList =
                                                                      transactionsSnapshot
                                                                              .data ??
                                                                          [];
                                                                  int lengthOfCurrentTransList =
                                                                      currentTransList
                                                                          .length;
                                                                  return Column(
                                                                    children: List.generate(
                                                                        lengthOfCurrentTransList,
                                                                        (index2) {
                                                                      return FadeAnimation(
                                                                        index2 *
                                                                            0.1,
                                                                        Padding(
                                                                          padding: EdgeInsets.fromLTRB(
                                                                              0,
                                                                              6,
                                                                              0,
                                                                              10),
                                                                          child:
                                                                              Material(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(20)),
                                                                            child:
                                                                                ListTile(
                                                                              dense: true,
                                                                              leading: Container(
                                                                                height: 50,
                                                                                width: 50,
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.grey[100],
                                                                                  borderRadius: BorderRadius.circular(15),
                                                                                ),
                                                                                child: Icon(
                                                                                  currentTransList[lengthOfCurrentTransList - index2 - 1].icon,
                                                                                  size: 24,
                                                                                  color: Colors.black,
                                                                                ),
                                                                              ),
                                                                              title: Container(
                                                                                width: maxWidth / 2,
                                                                                child: AutoSizeText(
                                                                                  currentTransList[lengthOfCurrentTransList - index2 - 1].description,
                                                                                  style: GoogleFonts.aBeeZee(
                                                                                    fontSize: 15,
                                                                                    letterSpacing: 0.6,
                                                                                    fontWeight: FontWeight.w900,
                                                                                  ),
                                                                                  maxLines: 2,
                                                                                ),
                                                                              ),
                                                                              subtitle: Row(
                                                                                children: <Widget>[
                                                                                  Container(
                                                                                    width: maxWidth / 10,
                                                                                    child: AutoSizeText(
                                                                                      currentTransList[lengthOfCurrentTransList - index2 - 1].fromAccount ?? "",
                                                                                      style: GoogleFonts.aBeeZee(
                                                                                        fontSize: 13,
                                                                                        fontWeight: FontWeight.w900,
                                                                                        color: Colors.grey,
                                                                                        letterSpacing: 0.7,
                                                                                      ),
                                                                                      maxLines: 2,
                                                                                    ),
                                                                                  ),
                                                                                  currentTransList[lengthOfCurrentTransList - index2 - 1].type == "Transfer"
                                                                                      ? Icon(
                                                                                          Icons.arrow_forward,
                                                                                          size: 18,
                                                                                          color: Colors.grey,
                                                                                        )
                                                                                      : SizedBox(),
                                                                                  currentTransList[lengthOfCurrentTransList - index2 - 1].type == "Transfer"
                                                                                      ? Container(
                                                                                          width: maxWidth / 10,
                                                                                          child: AutoSizeText(
                                                                                            currentTransList[lengthOfCurrentTransList - index2 - 1].toAccount,
                                                                                            style: GoogleFonts.aBeeZee(
                                                                                              fontSize: 13,
                                                                                              fontWeight: FontWeight.w900,
                                                                                              color: Colors.grey,
                                                                                              letterSpacing: 0.7,
                                                                                            ),
                                                                                            maxLines: 2,
                                                                                          ),
                                                                                        )
                                                                                      : SizedBox(),
                                                                                ],
                                                                              ),
                                                                              // Amt, if income then green and +, if expense then red and -.
                                                                              trailing: currentTransList[lengthOfCurrentTransList - index2 - 1].type != "Transfer"
                                                                                  ? Container(
                                                                                      width: maxWidth / 4,
                                                                                      child: Center(
                                                                                        child: Container(
                                                                                          padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                                                                          decoration: BoxDecoration(
                                                                                            color: currentTransList[lengthOfCurrentTransList - index2 - 1].type == "Expense" ? MyColor.mainOrange : MyColor.mainGreen,
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                          ),
                                                                                          child: AutoSizeText(
                                                                                            currentTransList[lengthOfCurrentTransList - index2 - 1].type == "Expense" ? "- ₹" + currentTransList[lengthOfCurrentTransList - index2 - 1].amt : "+ ₹" + currentTransList[lengthOfCurrentTransList - index2 - 1].amt,
                                                                                            style: GoogleFonts.aBeeZee(
                                                                                              fontSize: 20,
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                            maxLines: 2,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  : Container(
                                                                                      width: maxWidth / 4,
                                                                                      child: Center(
                                                                                        child: Container(
                                                                                          padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                                                                          decoration: BoxDecoration(
                                                                                            color: MyColor.someYellow,
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                          ),
                                                                                          child: AutoSizeText(
                                                                                            "₹" + currentTransList[lengthOfCurrentTransList - index2 - 1].amt,
                                                                                            style: GoogleFonts.aBeeZee(
                                                                                              fontSize: 20,
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                            maxLines: 2,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        type: AnimationType
                                                                            .rightToLeft,
                                                                      );
                                                                    }),
                                                                  );
                                                                },
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  childCount: lengthOfDaysList,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    )
                                  : Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    MdiIcons.formatListText,
                                                    size: 100,
                                                    color: Colors.grey[700],
                                                  ),
                                                  Text(
                                                    "Track your spending",
                                                    style: GoogleFonts.aBeeZee(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: MyColor.mainPurple,
                                                      letterSpacing: 0.8,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        70, 10, 70, 10),
                                                    child: Text(
                                                      "Keep track of your expenses by manually adding your transactions. Click on the plus button to add a transaction.",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.aBeeZee(
                                                        fontSize: 16,
                                                        color: Colors.grey[700],
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }

  String _monthToName(int monthNo) {
    switch (monthNo) {
      case 1:
        return "January";
        break;
      case 2:
        return "February";
        break;
      case 3:
        return "March";
        break;
      case 4:
        return "April";
        break;
      case 5:
        return "May";
        break;
      case 6:
        return "June";
        break;
      case 7:
        return "July";
        break;
      case 8:
        return "August";
        break;
      case 9:
        return "September";
        break;
      case 10:
        return "October";
        break;
      case 11:
        return "November";
        break;
      case 12:
        return "December";
        break;
      default:
        return '';
    }
  }

  _resetAllTextFields() {
    _accountNameController.clear();
    _accountBalanceController.clear();
    _accountNoController.clear();
  }

  _showAddAccountsAlertBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool _accountNameEmptyBool = false;
        TextStyle hintStyle = GoogleFonts.aBeeZee(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        );
        TextStyle textStyle = GoogleFonts.aBeeZee(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        );
        TextStyle buttonStyle = GoogleFonts.aBeeZee(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        );
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              "Add New Account",
              style: GoogleFonts.aBeeZee(
                fontSize: 20,
                color: MyColor.mainPurple,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Container(
              height: 130,
              width: 300,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      controller: _accountNameController,
                      style: textStyle,
                      decoration: InputDecoration(
                        hintText: "Account Name",
                        hintStyle: hintStyle,
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _accountNameEmptyBool = false;
                        });
                      },
                    ),
                    _accountNameEmptyBool
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.warning,
                                color: Colors.red,
                                size: 13,
                              ),
                              SizedBox(width: 7),
                              Text(
                                "Account Name Cannot be Empty.",
                                style: GoogleFonts.aBeeZee(
                                  color: Colors.red,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                    SizedBox(height: 7),
                    TextField(
                      controller: _accountBalanceController,
                      style: textStyle,
                      enableInteractiveSelection: false,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Account's Initial Balance (Optional)",
                        hintStyle: hintStyle,
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 5),
                    /*TextField(
                      controller: _accountNoController,
                      style: textStyle,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Account Number (Optional)",
                        hintStyle: hintStyle,
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        border: OutlineInputBorder(),
                      ),
                    ),*/
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Cancel",
                  style: buttonStyle,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  "OK",
                  style: buttonStyle,
                ),
                onPressed: () async {
                  String accountName = _accountNameController.text;
                  if (accountName.trim().toLowerCase() == "cash") {
                    Flushbar(
                      message: "Account Name cannot be Cash",
                      duration: Duration(seconds: 2),
                    ).show(context);
                    return;
                  }
                  double accountBal =
                      (_accountBalanceController.text.trim() == "")
                          ? 0
                          : double.parse(_accountBalanceController.text);
                  String accountNo = _accountNoController.text;
                  if (accountName == "") {
                    setState(() {
                      _accountNameEmptyBool = true;
                    });
                    return;
                  }
                  if (accountNo == null) accountNo = "";
                  dynamic res = await AccountsModel().addNewAccount(
                      user.uid, accountName, accountBal, accountNo);
                  _resetAllTextFields();
                  Navigator.of(context).pop();
                  if (res == true) {
                    errorFlushBar(context, "Error",
                        "Account names cannot be repeated. Please change the account name and try again.");
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }

  errorFlushBar(BuildContext context, String title, String message) {
    Flushbar(
      icon: Icon(
        Icons.warning,
        color: Colors.red,
      ),
      title: title,
      message: message,
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
    )..show(context);
  }

  int _getIndexOfMonthInListFromMonthNo(List<String> list, String monthNo) {
    for (int i = 0; i < list.length; i++) {
      if (list[i] == monthNo) return i;
    }
    return null;
  }

  String _showDateString(String day, String month, String year) {
    DateTime date = DateTime.now();
    if (date.day.toString() == day &&
        date.month.toString() == month &&
        date.year.toString() == year)
      return "Today";
    else if ((date.day - 1).toString() == day &&
        date.month.toString() == month &&
        date.year.toString() == year) return "Yesterday";

    return day + " " + _monthToName(int.parse(month)) + " " + year;
  }
}
