import 'package:financial_and_tax_planning_app/models/authentication/auth.dart';
import 'package:financial_and_tax_planning_app/models/extras/my_color.dart';
import 'package:financial_and_tax_planning_app/screens/financial/financial_news_screen.dart';
import 'package:financial_and_tax_planning_app/screens/goals/goal_screen.dart';
import 'package:financial_and_tax_planning_app/screens/financial/transactions_screen_main.dart';
import 'package:financial_and_tax_planning_app/screens/others/splash_screen.dart';
import 'package:financial_and_tax_planning_app/screens/shopping/shopping_lists_screen.dart';
import 'package:financial_and_tax_planning_app/screens/tax/tax_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class AppDrawer extends StatefulWidget {
  final int indexForDrawerItemHighlight;

  // Constructor that takes index for highlighting ListTile in app drawer
  AppDrawer(this.indexForDrawerItemHighlight);

  final drawerItems = [
    new DrawerItem("Home", Icons.dashboard),
    new DrawerItem("Goals", Icons.person),
    new DrawerItem("Shopping Lists", Icons.shopping_cart),
    new DrawerItem("Tax Calculator", Icons.crop_landscape),
    new DrawerItem("Financial News", MdiIcons.newspaper),
  ];

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final AuthService _auth = AuthService();

  bool loading = false;

  _goToScreen(int pos) {
    // this pop is responsible closeing drawer and also clearing the navigation stack
    Navigator.popUntil(context, ModalRoute.withName('/'));
    switch (pos) {
      case 0:
        {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => TransactionsScreen()));
          break;
        }
      case 1:
        {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => GoalScreen()));
          break;
        }
      case 2:
        {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ShoppingListsScreen()));
          break;
        }
      case 3:
        {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TaxScreen()));
          break;
        }
      case 4:
        {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => FinancialNewsScreen()));
          break;
        }

      default:
        {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return Text("ERROR");
          }));
          break;
        }
    }
  }

  _onSelectItem(int index) {
    _goToScreen(index);
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    var drawerOptions = <Widget>[];
    // we use widget.drawerItems, since drawerItems is declared in the statefull class of this class
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
        Container(
          color: i == widget.indexForDrawerItemHighlight
              ? MyColor.mainPurple.withOpacity(0.7)
              : Colors.transparent,
          child: FlatButton(
            padding: EdgeInsets.only(left: 40),
            onPressed: () => _onSelectItem(i),
            splashColor: Colors.grey[200],
            highlightColor: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(height: 15),
                Row(
                  children: [
                    Icon(
                      d.icon,
                      color: i == widget.indexForDrawerItemHighlight
                          ? Colors.white
                          : Colors.black,
                    ),
                    SizedBox(width: 10),
                    new Text(
                      d.title,
                      style: GoogleFonts.aBeeZee(
                        fontSize: 15,
                        // beacause when color is null the selected attribute applies the apps primary color on the text else it should be grey
                        color: i == widget.indexForDrawerItemHighlight
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      );
    }

    return loading
        ? SplashScreen(text: "Signing out...")
        : Drawer(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //The empty SizedBox()'s are for proper layout arrangement by using MainAxisAlignment.spacebetween
                  SizedBox(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: user != null
                            ? Image.network(user.photoUrl)
                            : SizedBox(),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              user != null ? user.displayName : '',
                              style: GoogleFonts.aBeeZee(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.6,
                              ),
                            ),
                            Text(
                              user != null ? user.email : '',
                              style: GoogleFonts.aBeeZee(
                                fontSize: 17,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Column(
                        children: drawerOptions,
                      ),
                    ],
                  ),
                  SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: FlatButton(
                      padding: EdgeInsets.only(left: 40),
                      onPressed: () async {
                        try {
                          // Show SplashSreen.
                          setState(() {
                            loading = true;
                          });
                          // Logout.
                          await _auth.logOut();
                          // Hide SplashScreen.
                          setState(() {
                            loading = false;
                          });
                          // Clear the stack and return to main.dart
                          Navigator.popUntil(context, ModalRoute.withName('/'));
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                      splashColor: Colors.grey[200],
                      highlightColor: Colors.grey[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Icon(
                                Icons.settings,
                                color: Colors.redAccent,
                              ),
                              SizedBox(width: 10),
                              new Text(
                                "Log out",
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.redAccent,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
