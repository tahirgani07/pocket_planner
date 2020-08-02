import 'package:financial_and_tax_planning_app/models/authentication/auth.dart';
import 'package:financial_and_tax_planning_app/models/authentication/database.dart';
import 'package:financial_and_tax_planning_app/models/extras/my_color.dart';
import 'package:financial_and_tax_planning_app/models/financial/accounts_internal_model.dart';
import 'package:financial_and_tax_planning_app/models/goals/goals_internal_model.dart';
import 'package:financial_and_tax_planning_app/models/shopping/shopping_list_internal_model.dart';
import 'package:financial_and_tax_planning_app/screens/authentication/authentication_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
        stream: AuthService().user,
        builder: (context, snapshot) {
          return MultiProvider(
            providers: [
              StreamProvider<FirebaseUser>.value(
                value: AuthService().user,
              ),
              StreamProvider<List<GoalsInternalModel>>.value(
                value: DatabaseService(
                  uid: snapshot.hasData ? snapshot.data.uid : null,
                ).goalsList,
              ),
              StreamProvider<List<ShoppingListInternalModel>>.value(
                value: DatabaseService(
                  uid: snapshot.hasData ? snapshot.data.uid : null,
                ).listOfShoppingLists,
              ),
              StreamProvider<List<AccountsInternalModel>>.value(
                value: DatabaseService(
                  uid: snapshot.hasData ? snapshot.data.uid : null,
                ).accountsList,
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: MyColor.mainPurple,
                scaffoldBackgroundColor: Colors.white,
                textTheme: Theme.of(context).textTheme.apply(
                      bodyColor: Colors.black,
                      displayColor: Colors.black,
                    ),
                primarySwatch: Colors.deepPurple,
                canvasColor: Colors.white,
              ),
              initialRoute: '/',
              routes: {
                '/': (context) => AuthenticationManager(),
              },
            ),
          );
        });
  }
}
