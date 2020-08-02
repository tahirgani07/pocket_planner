import 'package:auto_size_text/auto_size_text.dart';
import 'package:financial_and_tax_planning_app/models/extras/my_color.dart';
import 'package:financial_and_tax_planning_app/models/tax/tax_model.dart';
import 'package:financial_and_tax_planning_app/screens/app_drawer.dart';
import 'package:financial_and_tax_planning_app/screens/tax/tax_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TaxScreen extends StatefulWidget {
  @override
  _TaxScreenState createState() => _TaxScreenState();
}

class _TaxScreenState extends State<TaxScreen>
    with SingleTickerProviderStateMixin {
  TextStyle labelsTextStyle = GoogleFonts.aBeeZee(
    fontSize: 15,
    color: MyColor.mainPurple,
    fontWeight: FontWeight.w700,
  );

  TextStyle textFieldTextStyle = GoogleFonts.aBeeZee(
    fontSize: 15,
    color: Colors.black,
    fontWeight: FontWeight.w600,
  );

  TextStyle textFieldTextStyle2 = GoogleFonts.aBeeZee(
    fontSize: 15,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  List<Tab> taxTabs = [
    Tab(
      child: Text(
        "TAX CALCULATOR",
        style: GoogleFonts.aBeeZee(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    ),
    Tab(
      child: Text(
        "TAX INFO",
        style: GoogleFonts.aBeeZee(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    ),
  ];
  TabController _tabController;

  TextEditingController _grossIncomeTextFieldController;
  TextEditingController _taxreliefTextFieldController;
  TextEditingController _surchargeTextFieldController;
  TextEditingController _cessTextFieldController;
  TextEditingController _totalTaxTextFieldController;
  TextEditingController _individualIncomeTextFieldController;
  TextEditingController _individualInterestIncomeTextFieldController;
  TextEditingController _individualRentalIncomeTextFieldController;
  FocusNode _grossIncomeTextFieldFocusNode;
  FocusNode _individualIncomeTextFieldFocusNode;

  List<String> listOfAges = [
    "Male",
    "Female",
    "Senior Citizen",
    "Super Senior Citizen",
  ];
  List<String> listOfTaxPayers = [
    "Individual",
    "HUF",
    "AOP/BOI",
    "Domestic Company",
    "Foreign Company",
    "Firms",
    "LLP",
    "Co-operative Society",
  ];

  SnackBar incomeFieldEmptyErrorSnackBar;
  String taxPayerDropDownVal;
  String ageDropDownVal;
  String _radioButtonGroupVal;

  bool showCalculatedFields;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: taxTabs.length);
    _grossIncomeTextFieldController = new TextEditingController();
    _taxreliefTextFieldController = new TextEditingController();
    _surchargeTextFieldController = new TextEditingController();
    _cessTextFieldController = new TextEditingController();
    _totalTaxTextFieldController = new TextEditingController();
    _individualIncomeTextFieldController = new TextEditingController();
    _individualInterestIncomeTextFieldController = new TextEditingController();
    _individualRentalIncomeTextFieldController = new TextEditingController();
    _grossIncomeTextFieldFocusNode = new FocusNode();
    _individualIncomeTextFieldFocusNode = new FocusNode();

    showCalculatedFields = false;

    taxPayerDropDownVal = listOfTaxPayers[0];
    ageDropDownVal = listOfAges[0];
    incomeFieldEmptyErrorSnackBar = new SnackBar(
        content: Text(
      "Please Enter all * Marked Fields!",
      style: GoogleFonts.aBeeZee(
        fontSize: 15,
      ),
    ));
    _radioButtonGroupVal = "upto400Cr";
  }

  @override
  void dispose() {
    _tabController.dispose();
    _grossIncomeTextFieldController.dispose();
    _taxreliefTextFieldController.dispose();
    _surchargeTextFieldController.dispose();
    _cessTextFieldController.dispose();
    _totalTaxTextFieldController.dispose();
    _individualIncomeTextFieldController.dispose();
    _individualInterestIncomeTextFieldController.dispose();
    _individualRentalIncomeTextFieldController.dispose();
    _grossIncomeTextFieldFocusNode.dispose();
    _individualIncomeTextFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        //backgroundColor: Color(0xff273238),
        drawer: AppDrawer(3),
        appBar: AppBar(
          title: Text(
            "Tax",
            style: GoogleFonts.aBeeZee(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: taxTabs,
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            // Calculator Screen
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(
                        maxWidth: 400,
                      ),
                      padding: EdgeInsets.only(bottom: 10),
                      child: AutoSizeText(
                        "Financial Year 2020-21(AY 2021-22) New Tax Regime",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.aBeeZee(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            "Tax Payer",
                            style: labelsTextStyle,
                          ),
                        ),
                        Flexible(
                          child: DropdownButton(
                            value: taxPayerDropDownVal,
                            items: listOfTaxPayers.map((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                  style: textFieldTextStyle,
                                ),
                              );
                            }).toList(),
                            onChanged: (String newValue) {
                              _clearAllTextFields();
                              setState(() {
                                taxPayerDropDownVal = newValue;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    // Only Visible if taxpayer is an individual
                    taxPayerDropDownVal == "Individual"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  "Male / Female / Senior Citizen",
                                  style: labelsTextStyle,
                                ),
                              ),
                              Flexible(
                                child: DropdownButton(
                                  value: ageDropDownVal,
                                  items: listOfAges.map((String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: textFieldTextStyle,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      ageDropDownVal = newValue;
                                    });
                                  },
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                    SizedBox(height: 15),
                    // Only Visible if taxpayer is a Domestic Company
                    taxPayerDropDownVal == "Domestic Company"
                        ? Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Radio(
                                      activeColor: MyColor.mainPurple,
                                      value: "upto400Cr",
                                      groupValue: _radioButtonGroupVal,
                                      onChanged: (val) {
                                        setState(() {
                                          _radioButtonGroupVal = val;
                                        });
                                      }),
                                  Flexible(
                                    child: Text(
                                      "Gross turnover up to Rs.400 Cr. in the previous year",
                                      style: labelsTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Radio(
                                      activeColor: MyColor.mainPurple,
                                      value: "greaterThan400Cr",
                                      groupValue: _radioButtonGroupVal,
                                      onChanged: (val) {
                                        setState(() {
                                          _radioButtonGroupVal = val;
                                        });
                                      }),
                                  Flexible(
                                    child: Text(
                                      "Gross turnover exceeding Rs.400 Cr. in the previous year",
                                      style: labelsTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : SizedBox(),
                    SizedBox(height: 15),
                    // If the tax payer is an individual then multiple income fields will be displayed, else just one
                    taxPayerDropDownVal == "Individual"
                        ? Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      "Income from Salary*",
                                      style: labelsTextStyle,
                                    ),
                                  ),
                                  Flexible(
                                    child: TextField(
                                      style: textFieldTextStyle,
                                      focusNode:
                                          _individualIncomeTextFieldFocusNode,
                                      textAlign: TextAlign.right,
                                      controller:
                                          _individualIncomeTextFieldController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        WhitelistingTextInputFormatter
                                            .digitsOnly,
                                      ],
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      "Income from Interest",
                                      style: labelsTextStyle,
                                    ),
                                  ),
                                  Flexible(
                                    child: TextField(
                                      style: textFieldTextStyle,
                                      textAlign: TextAlign.right,
                                      controller:
                                          _individualInterestIncomeTextFieldController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        WhitelistingTextInputFormatter
                                            .digitsOnly,
                                      ],
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      "Rental Income Received",
                                      style: labelsTextStyle,
                                    ),
                                  ),
                                  Flexible(
                                    child: TextField(
                                      style: textFieldTextStyle,
                                      textAlign: TextAlign.right,
                                      controller:
                                          _individualRentalIncomeTextFieldController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        WhitelistingTextInputFormatter
                                            .digitsOnly,
                                      ],
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  "Gross Income*",
                                  style: labelsTextStyle,
                                ),
                              ),
                              Flexible(
                                child: TextField(
                                  style: textFieldTextStyle,
                                  focusNode: _grossIncomeTextFieldFocusNode,
                                  textAlign: TextAlign.right,
                                  controller: _grossIncomeTextFieldController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    SizedBox(height: 15),
                    showCalculatedFields
                        ? Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      "Income Tax after relief u/s 87A",
                                      style: labelsTextStyle,
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: MyColor.mainPurple,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextField(
                                        style: textFieldTextStyle2,
                                        textAlign: TextAlign.right,
                                        controller:
                                            _taxreliefTextFieldController,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          filled: false,
                                        ),
                                        readOnly: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      "Surcharge",
                                      style: labelsTextStyle,
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: MyColor.mainPurple,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextField(
                                        style: textFieldTextStyle2,
                                        textAlign: TextAlign.right,
                                        controller:
                                            _surchargeTextFieldController,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          filled: false,
                                        ),
                                        readOnly: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      "Health and Education Cess",
                                      style: labelsTextStyle,
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: MyColor.mainPurple,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextField(
                                        style: textFieldTextStyle2,
                                        textAlign: TextAlign.right,
                                        controller: _cessTextFieldController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          filled: false,
                                        ),
                                        readOnly: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      "Total Tax Liability",
                                      style: labelsTextStyle,
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: MyColor.mainPurple,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextField(
                                        style: textFieldTextStyle2,
                                        textAlign: TextAlign.right,
                                        controller:
                                            _totalTaxTextFieldController,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          filled: false,
                                        ),
                                        readOnly: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : SizedBox(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 30, 50, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RaisedButton(
                            child: Text(
                              "Reset",
                              style: GoogleFonts.aBeeZee(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            splashColor: Colors.red[200],
                            highlightColor: Colors.transparent,
                            textColor: Colors.white,
                            color: Colors.red[300],
                            onPressed: () {
                              _clearAllTextFields();
                              setState(() {
                                taxPayerDropDownVal = listOfTaxPayers[0];
                                ageDropDownVal = listOfAges[0];
                                showCalculatedFields = false;
                              });
                            },
                          ),
                          // Builder is used to pass the correct  context to the Snackbar
                          Builder(
                            builder: (context) {
                              return RaisedButton(
                                child: Text(
                                  "Calculate",
                                  style: GoogleFonts.aBeeZee(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                splashColor: Colors.green[200],
                                highlightColor: Colors.transparent,
                                textColor: Colors.white,
                                color: Colors.green[400],
                                onPressed: () {
                                  if (taxPayerDropDownVal != "Individual" &&
                                      (_grossIncomeTextFieldController.text ==
                                              null ||
                                          _grossIncomeTextFieldController
                                                  .text ==
                                              "")) {
                                    Scaffold.of(context).showSnackBar(
                                        incomeFieldEmptyErrorSnackBar);
                                    FocusScope.of(context).requestFocus(
                                        _grossIncomeTextFieldFocusNode);
                                    return;
                                  } else if (taxPayerDropDownVal ==
                                          "Individual" &&
                                      (_individualIncomeTextFieldController
                                                  .text ==
                                              null ||
                                          _individualIncomeTextFieldController
                                                  .text ==
                                              "")) {
                                    Scaffold.of(context).showSnackBar(
                                        incomeFieldEmptyErrorSnackBar);
                                    FocusScope.of(context).requestFocus(
                                        _individualIncomeTextFieldFocusNode);
                                    return;
                                  }
                                  // Since we should not change the DropDown list's variable 'ageDropDownVal', It can lead to errors.
                                  String ageOrTypeParam;
                                  // Since for HUF calculation is same as Individual male or Individual female
                                  if (taxPayerDropDownVal == "HUF") {
                                    ageOrTypeParam = "Male";
                                  } else if (taxPayerDropDownVal ==
                                      "Domestic Company") {
                                    ageOrTypeParam = _radioButtonGroupVal;
                                  } else {
                                    ageOrTypeParam = ageDropDownVal;
                                  }
                                  FinalTaxResult ft;
                                  if (taxPayerDropDownVal != "Individual") {
                                    ft = TaxModel.calculateFinalTaxResult(
                                        taxPayerDropDownVal,
                                        ageOrTypeParam,
                                        int.parse(
                                            _grossIncomeTextFieldController
                                                .text));
                                  } else {
                                    int individualIncome = int.parse(
                                        _individualIncomeTextFieldController
                                            .text);
                                    int individualInterest =
                                        (_individualInterestIncomeTextFieldController
                                                        .text ==
                                                    null ||
                                                _individualInterestIncomeTextFieldController
                                                        .text ==
                                                    "")
                                            ? 0
                                            : int.parse(
                                                _individualInterestIncomeTextFieldController
                                                    .text);
                                    int individualRental =
                                        (_individualRentalIncomeTextFieldController
                                                        .text ==
                                                    null ||
                                                _individualRentalIncomeTextFieldController
                                                        .text ==
                                                    "")
                                            ? 0
                                            : int.parse(
                                                _individualRentalIncomeTextFieldController
                                                    .text);
                                    int totalTaxableIncome = individualIncome +
                                        individualInterest +
                                        (individualRental * 70 / 100).round();

                                    ft = TaxModel.calculateFinalTaxResult(
                                        taxPayerDropDownVal,
                                        ageOrTypeParam,
                                        totalTaxableIncome);
                                  }

                                  setState(() {
                                    showCalculatedFields = true;
                                  });

                                  _taxreliefTextFieldController.text =
                                      ft.incomeTaxReliefAfter87A.toString();
                                  _surchargeTextFieldController.text =
                                      ft.surcharge.toString();
                                  _cessTextFieldController.text =
                                      ft.cess.toString();
                                  _totalTaxTextFieldController.text =
                                      ft.totalTaxLiability.toString();
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Tax Info Screen
            TaxInfoScreen(),
          ],
        ),
      ),
    );
  }

  _clearAllTextFields() {
    _grossIncomeTextFieldController.clear();
    _taxreliefTextFieldController.clear();
    _surchargeTextFieldController.clear();
    _cessTextFieldController.clear();
    _totalTaxTextFieldController.clear();
    _individualIncomeTextFieldController.clear();
    _individualInterestIncomeTextFieldController.clear();
    _individualRentalIncomeTextFieldController.clear();
  }
}
