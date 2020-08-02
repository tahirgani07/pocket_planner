import 'package:financial_and_tax_planning_app/models/extras/my_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  final String text;
  final double iconSize;
  final double textSize;
  final Color iconColor;
  final Color textColor;
  final Color backgroundColor;

  const SplashScreen({
    Key key,
    this.text = "Hang on...",
    this.iconSize = 40,
    this.textSize = 20,
    this.iconColor = MyColor.mainOrange,
    this.textColor = Colors.white,
    this.backgroundColor = MyColor.mainPurple,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: this.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitWave(
            color: this.iconColor,
            size: this.iconSize,
          ),
          SizedBox(height: 20),
          Text(
            this.text,
            style: GoogleFonts.aBeeZee(
              fontSize: this.textSize,
              color: this.textColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
