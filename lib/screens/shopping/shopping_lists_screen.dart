import 'package:auto_size_text/auto_size_text.dart';
import 'package:financial_and_tax_planning_app/models/extras/my_color.dart';
import 'package:financial_and_tax_planning_app/models/shopping/shopping_list_internal_model.dart';
import 'package:financial_and_tax_planning_app/models/shopping/shopping_list_model.dart';
import 'package:financial_and_tax_planning_app/screens/others/fade_animation.dart';
import 'package:financial_and_tax_planning_app/screens/shopping/add_item_screen.dart';
import 'package:financial_and_tax_planning_app/screens/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'add_new_shopping_list_screen.dart';

class ShoppingListsScreen extends StatefulWidget {
  @override
  _ShoppingListsScreenState createState() => _ShoppingListsScreenState();
}

class _ShoppingListsScreenState extends State<ShoppingListsScreen> {
  int lengthOfListOfShoppingLists;

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    List<ShoppingListInternalModel> listOfShoppingLists =
        Provider.of<List<ShoppingListInternalModel>>(context) ?? [];
    int lengthOfListOfShoppingLists = listOfShoppingLists.length;
    return Scaffold(
      //backgroundColor: Colors.grey[300],
      drawer: AppDrawer(2),
      appBar: AppBar(
        title: Text(
          "Shopping Lists",
          style: GoogleFonts.aBeeZee(
            fontSize: 22,
            color: Colors.white,
            letterSpacing: 0.6,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColor.mainPurple,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddNewShoppingListScreen(),
            ),
          );
        },
      ),
      body: Container(
        child: lengthOfListOfShoppingLists != 0
            ? ListView.separated(
                padding: EdgeInsets.all(5),
                itemCount: lengthOfListOfShoppingLists,
                itemBuilder: (context, index) {
                  return FadeAnimation(
                    1 + index * 0.1,
                    Card(
                      elevation: 14.0,
                      color: MyColor.mainOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 20, 5, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return AddItemScreen.toCategory(
                                      category: listOfShoppingLists[
                                              lengthOfListOfShoppingLists -
                                                  index -
                                                  1]
                                          .category,
                                      creationDate: listOfShoppingLists[
                                              lengthOfListOfShoppingLists -
                                                  index -
                                                  1]
                                          .creationDate
                                          .millisecondsSinceEpoch,
                                    );
                                  }),
                                );
                              },
                              leading: Icon(
                                listOfShoppingLists[
                                        lengthOfListOfShoppingLists - index - 1]
                                    .iconData,
                                size: 45,
                                color: Colors.white,
                              ),
                              title: Text(
                                listOfShoppingLists[
                                        lengthOfListOfShoppingLists - index - 1]
                                    .category,
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                ),
                              ),
                              trailing: Text(
                                "${listOfShoppingLists[lengthOfListOfShoppingLists - index - 1].noOfItems} items",
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 17,
                                  color: Colors.white,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Divider(
                              indent: 25,
                              endIndent: 25,
                              height: 0,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SizedBox(),
                                  /*MaterialButton(
                                    padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
                                    onPressed: () {},
                                    child: Text(
                                      "SHARE LIST",
                                      style: GoogleFonts.aBeeZee(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    height: 20,
                                    splashColor: Colors.lightBlue[50],
                                    highlightColor: Colors.transparent,
                                    textColor: Colors.blue[500],
                                  ),*/
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red[400],
                                    ),
                                    onPressed: () {
                                      ShoppingListModel().deleteAList(
                                          user.uid,
                                          listOfShoppingLists[
                                                  lengthOfListOfShoppingLists -
                                                      index -
                                                      1]
                                              .creationDate
                                              .millisecondsSinceEpoch);
                                    },
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.red[50],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    type: AnimationType.rightToLeft,
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 10),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        Icons.shopping_basket,
                        size: 65,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Plan before you shop",
                      style: GoogleFonts.aBeeZee(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: MyColor.mainPurple,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(70, 10, 70, 10),
                      child: AutoSizeText(
                        "Manage all your shopping lists here. Tap the plus button to add the first one.",
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
              ),
      ),
    );
  }
}
