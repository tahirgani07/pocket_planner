import 'package:financial_and_tax_planning_app/models/extras/my_color.dart';
import 'package:financial_and_tax_planning_app/models/financial/transaction_categories.dart';
import 'package:financial_and_tax_planning_app/screens/financial/add_transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectCategoryScreen extends StatefulWidget {
  final TransactionCategoriesModel transactionCategoriesModel;

  SelectCategoryScreen(
    this.transactionCategoriesModel,
  );

  @override
  _SelectCategoryScreenState createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  TextStyle textStyle2 = GoogleFonts.aBeeZee(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  TextStyle textStyle = GoogleFonts.aBeeZee(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select a Category",
          style: GoogleFonts.aBeeZee(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount:
                    widget.transactionCategoriesModel.listOfCategories.length,
                itemBuilder: (context, index) {
                  TransactionCategoriesInternalModel currentCategory =
                      widget.transactionCategoriesModel.listOfCategories[index];
                  String desc = currentCategory.desc;
                  IconData iconData = currentCategory.icon;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColor.moreLightPurple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Icon(
                          iconData,
                          color: Colors.white,
                        ),
                        title: Text(
                          desc,
                          style: textStyle2,
                        ),
                        onTap: () {
                          if (currentCategory.subCategories == []) {
                            AddTransactionScreen.categoryDesc =
                                currentCategory.desc;
                            Navigator.of(context).pop();
                          } else {
                            _showSelectSubCategoryAlertBox(
                                context, currentCategory);
                          }
                        },
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  _showSelectSubCategoryAlertBox(BuildContext context,
      TransactionCategoriesInternalModel selectedCategory) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text(
                  "Select Transaction Category",
                  style: GoogleFonts.aBeeZee(
                    color: Colors.black,
                  ),
                ),
                content: Container(
                  height: 500,
                  width: 500,
                  child: ListView.builder(
                      itemCount: selectedCategory.subCategories.length,
                      itemBuilder: (context, index) {
                        TransactionCategoriesInternalModel currentSubCategory =
                            selectedCategory.subCategories[index];
                        String desc = currentSubCategory.desc;
                        IconData iconData = currentSubCategory.icon;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            index == 0
                                ? _getHeadingForSubCategories("GENERAL")
                                : SizedBox(),
                            index == 1
                                ? _getHeadingForSubCategories("SUB-CATEGORIES")
                                : SizedBox(),
                            ListTile(
                              leading: Icon(
                                iconData,
                                color: Colors.black,
                              ),
                              title: Text(
                                desc,
                                style: textStyle,
                              ),
                              onTap: () {
                                AddTransactionScreen.categoryDesc = desc;
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      }),
                ),
              );
            },
          );
        });
  }

  _getHeadingForSubCategories(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
      color: Colors.grey[300],
      child: Text(
        title,
        style: GoogleFonts.aBeeZee(
          color: Colors.grey[700],
          fontSize: 16,
        ),
      ),
    );
  }
}
