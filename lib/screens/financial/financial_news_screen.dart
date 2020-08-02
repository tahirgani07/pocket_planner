import 'package:financial_and_tax_planning_app/screens/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FinancialNewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(4),
      appBar: AppBar(
        title: Text(
          "Latest Financial News",
          style: GoogleFonts.aBeeZee(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Source - https://www.cnbc.com",
            style: GoogleFonts.aBeeZee(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: WebView(
              initialUrl: 'https://www.cnbc.com/finance',
            ),
          ),
        ],
      ),
    );
  }
}
