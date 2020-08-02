import 'package:financial_and_tax_planning_app/models/extras/my_color.dart';
import 'package:financial_and_tax_planning_app/models/goals/goals_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddGoalScreen extends StatefulWidget {
  @override
  _AddGoalScreenState createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  TextEditingController _goalNameTextFieldController;
  TextEditingController _goalTargetAmtTextFieldController;
  TextEditingController _goalSavedAmtTextFieldController;
  TextEditingController _goalDesiredDateTextFieldController;
  TextEditingController _goalNoteTextFieldController;

  TextStyle labelsTextStyle = GoogleFonts.aBeeZee(
    fontSize: 15,
    color: MyColor.mainPurple,
  );

  DateTime selectedDate = DateTime.now();

  SnackBar emptyErrorSnackBar = SnackBar(
    content: Text(
      "Name and target Amount cannot be empty",
      style: GoogleFonts.aBeeZee(
        fontSize: 18,
      ),
    ),
  );

  SnackBar amtErrorSnackBar = SnackBar(
    content: Text(
      "Saved Amount cannot be greater than or equal to Target Amount",
      style: GoogleFonts.aBeeZee(
        fontSize: 18,
      ),
    ),
  );

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _goalDesiredDateTextFieldController.text =
            _monthToName(selectedDate.month) +
                " ${selectedDate.day}, ${selectedDate.year}";
      });
  }

  @override
  void initState() {
    super.initState();
    _goalNameTextFieldController = new TextEditingController();
    _goalTargetAmtTextFieldController = new TextEditingController();
    _goalSavedAmtTextFieldController = new TextEditingController();
    _goalDesiredDateTextFieldController = new TextEditingController(
        text: _monthToName(selectedDate.month) +
            " ${selectedDate.day}, ${selectedDate.year}");
    _goalNoteTextFieldController = new TextEditingController();
  }

  @override
  void dispose() {
    _goalNameTextFieldController.dispose();
    _goalTargetAmtTextFieldController.dispose();
    _goalSavedAmtTextFieldController.dispose();
    _goalDesiredDateTextFieldController.dispose();
    _goalNoteTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Add a Goal",
          style: GoogleFonts.aBeeZee(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.done),
              onPressed: () async {
                String name = _goalNameTextFieldController.text;
                String targetAmt = _goalTargetAmtTextFieldController.text;
                if (name == '' || targetAmt == '') {
                  Scaffold.of(context).showSnackBar(emptyErrorSnackBar);
                  return;
                }
                String alreadySaved =
                    _goalSavedAmtTextFieldController.text == ""
                        ? "0"
                        : _goalSavedAmtTextFieldController.text;

                if (double.parse(alreadySaved) >= double.parse(targetAmt)) {
                  Scaffold.of(context).showSnackBar(amtErrorSnackBar);
                  return;
                }

                DateTime desiredDate = selectedDate;
                String note = _goalNoteTextFieldController.text;
                await GoalsModel().addGoal(
                  user.uid,
                  name,
                  note,
                  double.parse(targetAmt),
                  double.parse(alreadySaved),
                  desiredDate,
                );
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "What are you saving for?",
                        style: labelsTextStyle,
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: _goalNameTextFieldController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Target amount",
                        style: labelsTextStyle,
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: _goalTargetAmtTextFieldController,
                        enableInteractiveSelection: false,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Amount already saved",
                        style: labelsTextStyle,
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: _goalSavedAmtTextFieldController,
                        enableInteractiveSelection: false,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Desired date",
                        style: labelsTextStyle,
                      ),
                      SizedBox(height: 5),
                      // Wrapping the TextField in theme and builder to give the datepicker a custom theme.
                      TextField(
                        controller: _goalDesiredDateTextFieldController,
                        enableInteractiveSelection: false,
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          border: OutlineInputBorder(),
                        ),
                        onTap: () => _selectDate(context),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Note",
                        style: labelsTextStyle,
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: _goalNoteTextFieldController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
}
