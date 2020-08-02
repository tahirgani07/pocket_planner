import 'package:financial_and_tax_planning_app/screens/authentication/login_screen.dart';
import 'package:financial_and_tax_planning_app/screens/financial/transactions_screen_main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    if (user == null) {
      return LoginScreen(maxHeight: size.height, maxWidth: size.width);
    }
    return TransactionsScreen(uid: user.uid);
  }
}
