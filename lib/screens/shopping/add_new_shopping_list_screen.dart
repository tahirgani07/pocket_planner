import 'package:auto_size_text/auto_size_text.dart';
import 'package:financial_and_tax_planning_app/models/extras/my_color.dart';
import 'package:financial_and_tax_planning_app/models/extras/my_icons_icons.dart';
import 'package:financial_and_tax_planning_app/models/shopping/shopping_list_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

import 'add_item_screen.dart';

class AddNewShoppingListScreen extends StatefulWidget {
  @override
  _AddNewShoppingListScreenState createState() =>
      _AddNewShoppingListScreenState();
}

class _AddNewShoppingListScreenState extends State<AddNewShoppingListScreen> {
  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<FirebaseUser>(context).uid;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Shopping List",
          style: GoogleFonts.aBeeZee(
            fontSize: 22,
            letterSpacing: 0.6,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      //backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 30, 50, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AutoSizeText(
              "Select Category of your Shopping list",
              textAlign: TextAlign.center,
              style: GoogleFonts.aBeeZee(
                fontSize: 20,
                letterSpacing: 0.6,
                color: MyColor.darkPurple,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 10),
              child: AutoSizeText(
                "Monthly Grocery? Weekend Shopping? We got you!",
                textAlign: TextAlign.center,
                style: GoogleFonts.aBeeZee(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ResponsiveGridList(
                  desiredItemWidth: 110,
                  minSpacing: 10,
                  children: [
                    [MyIcons.shopping_icon, "Groceries"],
                    [MyIcons.electronics_icon, "Electronics"],
                    [
                      MyIcons.dressandaccessoriesicon,
                      "Clothes and Accessories"
                    ],
                    [MyIcons.furnitures_icon, "Furnitures"],
                    [MyIcons.fast_foods_icon, "Foods"],
                    [MdiIcons.medicalBag, "Pharmaceuticals"],
                  ].map((i) {
                    return Card(
                      elevation: 10.0,
                      child: GestureDetector(
                        onTap: () {
                          DateTime date = DateTime.now();
                          ShoppingListModel().addNewShoppingList(
                            uid,
                            "",
                            i[1].toString(),
                            date.millisecondsSinceEpoch,
                          );
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => AddItemScreen.toCategory(
                                creationDate: date.millisecondsSinceEpoch,
                                category: i[1].toString(),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 110,
                          alignment: Alignment.center,
                          color: Color(0xff7a9bee),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(),
                              Icon(
                                i[0],
                                color: Colors.white,
                                size: 70,
                              ),
                              AutoSizeText(
                                i[1].toString(),
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList()),
            ),
          ],
        ),
      ),
    );
  }
}
