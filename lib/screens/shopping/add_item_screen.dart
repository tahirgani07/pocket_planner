import 'package:auto_size_text/auto_size_text.dart';
import 'package:financial_and_tax_planning_app/models/authentication/database.dart';
import 'package:financial_and_tax_planning_app/models/extras/my_color.dart';
import 'package:financial_and_tax_planning_app/models/shopping/actual_shopping_items.dart';
import 'package:financial_and_tax_planning_app/models/shopping/shopping_list_item_internal_model.dart';
import 'package:financial_and_tax_planning_app/models/shopping/shopping_list_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

class AddItemScreen extends StatefulWidget {
  final String category;
  // Using creation date we will identify which ShoppingList this is.
  final int creationDate;

  AddItemScreen.toCategory({
    this.category,
    this.creationDate,
  });

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  List<PanelItem> panelItems;
  List<Item> selectedShoppingItemsList;
  int noOfSelectedItems;

  @override
  void initState() {
    super.initState();

    switch (widget.category) {
      case "Groceries":
        {
          panelItems = ActualShoppingItems().getGroceryItems(widget.category);
          break;
        }
      case "Electronics":
        {
          panelItems = ActualShoppingItems().getGroceryItems(widget.category);
          break;
        }
      case "Clothes and Accessories":
        {
          panelItems = ActualShoppingItems().getGroceryItems(widget.category);
          break;
        }
      case "Furnitures":
        {
          panelItems = ActualShoppingItems().getGroceryItems(widget.category);
          break;
        }
      case "Foods":
        {
          panelItems = ActualShoppingItems().getGroceryItems(widget.category);
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    return StreamBuilder<List<Item>>(
        stream: DatabaseService(
                uid: user.uid, creationDateOfShoppingList: widget.creationDate)
            .itemList,
        builder: (context, snapshot) {
          selectedShoppingItemsList = snapshot.data ?? [];
          noOfSelectedItems = selectedShoppingItemsList.length;
          return WillPopScope(
            onWillPop: () => _onBackButtonPress(
                context, user.uid, widget.creationDate, noOfSelectedItems),
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text(
                  "Select Items",
                  style: GoogleFonts.aBeeZee(
                    fontSize: 22,
                    color: Colors.white,
                    letterSpacing: 0.6,
                  ),
                ),
                leading: IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () => _onBackButtonPress(
                    context,
                    user.uid,
                    widget.creationDate,
                    noOfSelectedItems,
                  ),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Center(
                      child: Text(
                        "$noOfSelectedItems Selected",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 17,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: ListView(
                children: <Widget>[
                  // Selected Items - This will only be shown if any items are selected
                  noOfSelectedItems > 0
                      ? Container(
                          padding: EdgeInsets.fromLTRB(17, 10, 17, 10),
                          child: ResponsiveGridList(
                              scroll: false,
                              desiredItemWidth: 90,
                              minSpacing: 0,
                              children: selectedShoppingItemsList.map((i) {
                                return Card(
                                  elevation: 10.0,
                                  child: GestureDetector(
                                    onTap: () {
                                      ShoppingListModel().removeListItem(
                                          user.uid,
                                          widget.creationDate,
                                          i.creationDate);
                                    },
                                    child: Container(
                                      height: 100,
                                      alignment: Alignment.center,
                                      color: Colors.redAccent,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(),
                                          Icon(
                                            i.iconData,
                                            color: Colors.white,
                                            size: 60,
                                          ),
                                          AutoSizeText(
                                            i.name,
                                            style: GoogleFonts.aBeeZee(
                                              fontSize: 17,
                                              color: Colors.white,
                                              letterSpacing: 0.6,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList()),
                        )
                      : Text(""),
                  // Panels
                  Container(
                    color: Colors.white,
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.fromLTRB(17, 0, 17, 0),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          cardColor:
                              MyColor.lightPurple), // past color - 36474F
                      child: ExpansionPanelList(
                        expansionCallback: (int index, bool isExpanded) {
                          setState(() {
                            panelItems[index].isExpanded = !isExpanded;
                          });
                        },
                        children:
                            panelItems.map<ExpansionPanel>((PanelItem pItem) {
                          return ExpansionPanel(
                            canTapOnHeader: true,
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                              return Container(
                                padding: EdgeInsets.only(left: 15),
                                alignment: Alignment.centerLeft,
                                color: MyColor.lightPurple, //Color(0xff36474F)
                                child: Text(
                                  pItem.headerValue,
                                  style: GoogleFonts.aBeeZee(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                            body: ResponsiveGridList(
                                scroll: false,
                                desiredItemWidth: 90,
                                minSpacing: 0,
                                children: pItem.expandedValue.map((Item i) {
                                  int indexOfItemInList = ShoppingListModel()
                                      .isItemAlreadyAddedInList(
                                          selectedShoppingItemsList, i);
                                  if (indexOfItemInList != null)
                                    i.isSelected = true;
                                  else
                                    i.isSelected = false;
                                  return Card(
                                    elevation: 10.0,
                                    child: GestureDetector(
                                      onTap: () {
                                        int indexOfItemInList =
                                            ShoppingListModel()
                                                .isItemAlreadyAddedInList(
                                                    selectedShoppingItemsList,
                                                    i);
                                        if (indexOfItemInList != null) {
                                          ShoppingListModel().removeListItem(
                                              user.uid,
                                              widget.creationDate,
                                              indexOfItemInList);
                                        } else {
                                          ShoppingListModel().addListItem(
                                              user.uid, i, widget.creationDate);
                                        }
                                      },
                                      child: Container(
                                        height: 100,
                                        alignment: Alignment.center,
                                        color: (!i.isSelected)
                                            ? MyColor.mainGreen
                                            : Colors.redAccent,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(),
                                            Icon(
                                              i.iconData,
                                              color: Colors.white,
                                              size: 60,
                                            ),
                                            Flexible(
                                              child: Text(
                                                i.name,
                                                style: GoogleFonts.aBeeZee(
                                                  fontSize: 17,
                                                  color: Colors.white,
                                                  letterSpacing: 0.6,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList()),
                            isExpanded: pItem.isExpanded,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _onBackButtonPress(BuildContext context, String uid,
      int creationDateOfShoppingList, int noOfSelectedItems) {
    ShoppingListModel().updateNoOfSelectedItemOfShoppingList(
        uid, creationDateOfShoppingList, noOfSelectedItems);
    Navigator.of(context).pop();
  }
}
