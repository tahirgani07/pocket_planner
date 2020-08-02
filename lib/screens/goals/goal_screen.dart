import 'package:auto_size_text/auto_size_text.dart';
import 'package:financial_and_tax_planning_app/models/extras/my_color.dart';
import 'package:financial_and_tax_planning_app/models/goals/goals_internal_model.dart';
import 'package:financial_and_tax_planning_app/models/goals/goals_model.dart';
import 'package:financial_and_tax_planning_app/screens/app_drawer.dart';
import 'package:financial_and_tax_planning_app/screens/goals/add_goal_screen.dart';
import 'package:financial_and_tax_planning_app/screens/others/fade_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class GoalScreen extends StatefulWidget {
  @override
  _GoalScreenState createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  double get maxWidth => MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    List<GoalsInternalModel> goalsList =
        Provider.of<List<GoalsInternalModel>>(context) ?? [];
    int lengthOfGoalsList = goalsList.length;

    return Scaffold(
        drawer: AppDrawer(1),
        appBar: AppBar(
          title: Text(
            "Goals",
            style: GoogleFonts.aBeeZee(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () => _showInfoFlushBar(context),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: MyColor.mainPurple,
          elevation: 14.0,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddGoalScreen(),
              ),
            );
          },
        ),
        body: lengthOfGoalsList > 0
            ? Container(
                child: ListView.separated(
                  padding: EdgeInsets.all(10),
                  itemCount: lengthOfGoalsList,
                  itemBuilder: (context, index) {
                    GoalsInternalModel currentGoal =
                        goalsList[lengthOfGoalsList - index - 1];
                    return FadeAnimation(
                      1 + index * 0.1,
                      GestureDetector(
                        onTap: () => _showGoalDetailsAlertBox(
                          context,
                          user.uid,
                          currentGoal,
                          lengthOfGoalsList - index - 1,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          color: currentGoal.reached
                              ? MyColor.mainGreen
                              : MyColor.mainOrange,
                          elevation: 14.0,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      height: 85,
                                      width: 85,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: CircularProgressIndicator(
                                              value: 1 -
                                                  (currentGoal.targetAmt -
                                                          currentGoal
                                                              .savedAmt) /
                                                      currentGoal.targetAmt,
                                              backgroundColor: Colors.black
                                                  .withOpacity(0.10),
                                              strokeWidth: 5.5,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                MyColor.someYellow,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 85,
                                      width: 85,
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        ((1 -
                                                            (currentGoal.targetAmt -
                                                                    currentGoal
                                                                        .savedAmt) /
                                                                currentGoal
                                                                    .targetAmt) *
                                                        100)
                                                    .round() >=
                                                100
                                            ? "100%"
                                            : ((1 -
                                                            (currentGoal.targetAmt -
                                                                    currentGoal
                                                                        .savedAmt) /
                                                                currentGoal
                                                                    .targetAmt) *
                                                        100)
                                                    .round()
                                                    .toString() +
                                                "%",
                                        style: GoogleFonts.aBeeZee(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Container(
                                    height: 100,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            AutoSizeText(
                                              currentGoal.name,
                                              maxLines: 1,
                                              style: GoogleFonts.aBeeZee(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                letterSpacing: 0.6,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async =>
                                                  await GoalsModel().deleteGoal(
                                                      user.uid,
                                                      currentGoal.creationDate),
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.red[400],
                                              ),
                                            ),
                                          ],
                                        ),
                                        AutoSizeText(
                                          currentGoal.creationDate
                                                      .toLocal()
                                                      .toString()
                                                      .split(' ')[0] ==
                                                  currentGoal.desiredDate
                                                      .toLocal()
                                                      .toString()
                                                      .split(' ')[0]
                                              ? "No target date"
                                              : "Target Date - ${currentGoal.desiredDate.day}/${currentGoal.desiredDate.month}/${currentGoal.desiredDate.year}",
                                          maxLines: 2,
                                          style: GoogleFonts.aBeeZee(
                                            fontSize: 13,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  AutoSizeText(
                                                    "Saved",
                                                    maxLines: 2,
                                                    style: GoogleFonts.aBeeZee(
                                                      fontSize: 18,
                                                      color: Colors.white60,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2),
                                                  AutoSizeText(
                                                    "₹" +
                                                        currentGoal.savedAmt
                                                            .toStringAsFixed(2),
                                                    maxLines: 1,
                                                    style: GoogleFonts.aBeeZee(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  AutoSizeText(
                                                    "Target",
                                                    maxLines: 2,
                                                    style: GoogleFonts.aBeeZee(
                                                      fontSize: 18,
                                                      color: Colors.white60,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2),
                                                  AutoSizeText(
                                                    "₹" +
                                                        currentGoal.targetAmt
                                                            .toStringAsFixed(2),
                                                    maxLines: 1,
                                                    style: GoogleFonts.aBeeZee(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      type: AnimationType.rightToLeft,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10);
                  },
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      child: Icon(
                        MdiIcons.bullseyeArrow,
                        size: 65,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AutoSizeText(
                      "Save for your goals",
                      style: GoogleFonts.aBeeZee(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: MyColor.mainPurple,
                        letterSpacing: 0.8,
                      ),
                      maxLines: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(70, 10, 70, 10),
                      child: AutoSizeText(
                        "Manage all your goals here. Tap the plus button to add the first one.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.aBeeZee(
                          fontSize: 15,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w900,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ));
  }

  _showGoalDetailsAlertBox(BuildContext context, String uid,
      GoalsInternalModel currentGoal, int indexOfGoalInList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Column(
              children: <Widget>[
                Text(
                  currentGoal.reached ? "Goal Detail - Reached" : "Goal Detail",
                  style: GoogleFonts.aBeeZee(
                    color: currentGoal.reached
                        ? MyColor.mainGreen
                        : MyColor.mainOrange,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Divider(),
              ],
            ),
            content: Container(
              height: 350,
              width: 300,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      title: AutoSizeText(
                        currentGoal.name,
                        style: GoogleFonts.aBeeZee(
                          fontSize: 22,
                          color: MyColor.mainPurple,
                          fontWeight: FontWeight.w900,
                        ),
                        maxLines: 1,
                      ),
                      subtitle: Text(
                        currentGoal.creationDate
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0] ==
                                currentGoal.desiredDate
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0]
                            ? "No target date"
                            : "Target date ${currentGoal.desiredDate.day}/${currentGoal.desiredDate.month}/${currentGoal.desiredDate.year}",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 17,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                          height: 200,
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: CircularProgressIndicator(
                                  value: 1 -
                                      (currentGoal.targetAmt -
                                              currentGoal.savedAmt) /
                                          currentGoal.targetAmt,
                                  backgroundColor: Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 200,
                          width: 200,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              AutoSizeText(
                                currentGoal.savedAmt.toString(),
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 35,
                                  color: currentGoal.reached
                                      ? MyColor.mainGreen
                                      : MyColor.mainOrange,
                                  fontWeight: FontWeight.w800,
                                ),
                                maxLines: 2,
                              ),
                              Text(
                                "₹",
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Note",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        currentGoal.note.trim() == ""
                            ? "No note"
                            : currentGoal.note,
                        style: GoogleFonts.aBeeZee(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Cancel",
                  style: GoogleFonts.aBeeZee(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              !currentGoal.reached
                  ? FlatButton(
                      child: Text(
                        "Add saved Amount",
                        style: GoogleFonts.aBeeZee(),
                      ),
                      onPressed: () {
                        TextEditingController addSavedAmountTextController =
                            new TextEditingController();
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                content: TextField(
                                  controller: addSavedAmountTextController,
                                  autofocus: true,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "Enter amount",
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  enableInteractiveSelection: false,
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("Add"),
                                    onPressed: () {
                                      String addAmount =
                                          addSavedAmountTextController.text;
                                      if (addAmount.trim() == "") {
                                        Flushbar(
                                          message: "Amount cannot be empty",
                                          duration: Duration(seconds: 1),
                                        ).show(context);
                                        return;
                                      } else if (addAmount.contains(",") ||
                                          addAmount.contains("-")) {
                                        Flushbar(
                                          message: "Please check the number",
                                          duration: Duration(seconds: 1),
                                        ).show(context);
                                        return;
                                      }
                                      GoalsModel().addToSavedAmt(
                                        uid,
                                        currentGoal,
                                        double.parse(addAmount),
                                      );
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                    )
                  : SizedBox(),
            ],
          );
        });
      },
    );
  }

  _showInfoFlushBar(BuildContext context) {
    return Flushbar(
      icon: Icon(Icons.info),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.white,
      duration: Duration(seconds: 3),
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: MyColor.mainOrange,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 15,
                width: 15,
              ),
              SizedBox(width: 5),
              AutoSizeText(
                "Active Goals",
                style: GoogleFonts.aBeeZee(
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: MyColor.mainGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 15,
                width: 15,
              ),
              SizedBox(width: 5),
              AutoSizeText(
                "Completed Goals",
                style: GoogleFonts.aBeeZee(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    )..show(context);
  }
}
