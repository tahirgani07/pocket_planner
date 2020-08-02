import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TaxInfoScreen extends StatefulWidget {
  @override
  _TaxInfoScreenState createState() => _TaxInfoScreenState();
}

class _TaxInfoScreenState extends State<TaxInfoScreen> {
  WebViewController _webViewController;
  final TextStyle buttonTextStyle = GoogleFonts.aBeeZee(
    fontSize: 16,
    color: Colors.blue,
  );
  final EdgeInsetsGeometry paddingForLinkButtons =
      EdgeInsets.fromLTRB(30, 8, 30, 0);
  Color colorForLinkButtonContainer = Color(0xff393948);

  @override
  Widget build(BuildContext context) {
    // Tax Slab AY 2019-20
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: paddingForLinkButtons,
          child: RaisedButton(
            elevation: 26.0,
            padding: EdgeInsets.only(left: 30),
            color: colorForLinkButtonContainer,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: Container(
              width: double.infinity,
              color: colorForLinkButtonContainer,
              child: Text(
                "1. What is tax? Types of taxes.",
                style: buttonTextStyle,
              ),
            ),
            onPressed: () {
              _webViewController.loadUrl(
                  "https://financialandtaxplanning.wordpress.com/what-is-tax-types-of-tax");
            },
          ),
        ),
        Padding(
          padding: paddingForLinkButtons,
          child: RaisedButton(
            elevation: 26.0,
            padding: EdgeInsets.only(left: 30),
            color: colorForLinkButtonContainer,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: Container(
              width: double.infinity,
              color: colorForLinkButtonContainer,
              child: Text(
                "2. What is tax slab?",
                style: buttonTextStyle,
              ),
            ),
            onPressed: () {
              _webViewController
                  .loadUrl("https://financialandtaxplanning.wordpress.com");
            },
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
            child: WebView(
              initialUrl:
                  "https://financialandtaxplanning.wordpress.com/what-is-tax-types-of-tax",
              onWebViewCreated: (WebViewController webViewController) {
                _webViewController = webViewController;
              },
            ),
          ),
        ),
      ],
    );
  }
}
