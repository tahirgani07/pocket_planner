import 'package:financial_and_tax_planning_app/models/authentication/auth.dart';
import 'package:financial_and_tax_planning_app/models/extras/my_color.dart';
import 'package:financial_and_tax_planning_app/screens/others/fade_animation.dart';
import 'package:financial_and_tax_planning_app/screens/others/login_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';

class LoginScreen extends StatefulWidget {
  final double maxHeight, maxWidth;
  LoginScreen({this.maxHeight, this.maxWidth});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final AuthService _auth = AuthService();
  bool loading = false;

  bool hideButtonLabels = false;

  AnimationController _scaleController;
  Animation<double> _scaleAnimation;

  double _width;
  double _height;
  double _borderRadius;

  @override
  void didChangeDependencies() {
    _width = widget.maxWidth - 60;
    _height = widget.maxHeight / 14;
    _borderRadius = 5;

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            loading = true;
          });
        }
      });

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 100.0).animate(_scaleController);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          LoginBackground(),
          Container(
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 100,
                  child: Container(
                    width: widget.maxWidth,
                    child: FadeAnimation(
                      1,
                      Center(
                        child: Text(
                          "Welcome!",
                          style: GoogleFonts.aBeeZee(
                            fontSize: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 160,
                  child: Container(
                    width: widget.maxWidth,
                    child: FadeAnimation(
                      1.5,
                      Center(
                        child: Text(
                          "Sign in to the app with your google account.",
                          style: GoogleFonts.aBeeZee(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 200,
                  child: Container(
                    width: widget.maxWidth,
                    child: Center(
                      child: AnimatedBuilder(
                          animation: _scaleController,
                          builder: (context, child) {
                            return FadeAnimation(
                              1.5,
                              Transform.scale(
                                scale: _scaleAnimation.value,
                                child: AnimatedContainer(
                                  height: _height,
                                  width: _width,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.fastOutSlowIn,
                                  decoration: BoxDecoration(
                                    color: MyColor.mainPurple,
                                    borderRadius:
                                        BorderRadius.circular(_borderRadius),
                                  ),
                                  child: FlatButton(
                                    onPressed: () async {
                                      await _startAnimations();
                                      FirebaseUser result =
                                          await _auth.loginWithGoogle();
                                      if (result == null) {
                                        setState(() {
                                          loading = false;
                                        });
                                        Flushbar(
                                          title: "Error!",
                                          message:
                                              "Could not sign in. Please try again.",
                                          duration: Duration(
                                            seconds: 3,
                                          ),
                                          flushbarPosition:
                                              FlushbarPosition.TOP,
                                        ).show(context);
                                        await _scaleController.reverse();
                                        setState(() {
                                          _width = widget.maxWidth - 60;
                                          _height = widget.maxHeight / 14;
                                          _borderRadius = 5;
                                        });
                                        Future.delayed(
                                            Duration(milliseconds: 700), () {
                                          setState(() {
                                            hideButtonLabels = false;
                                          });
                                        });
                                      }
                                    },
                                    padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                    child: hideButtonLabels
                                        ? SizedBox()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                height: 50,
                                                width: 50,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                ),
                                                padding: EdgeInsets.all(0),
                                                child: Icon(
                                                  MdiIcons.google,
                                                  color: MyColor.mainPurple,
                                                ),
                                              ),
                                              Expanded(
                                                child: Center(
                                                  child: AutoSizeText(
                                                    'SIGN IN WITH GOOGLE',
                                                    style: GoogleFonts.aBeeZee(
                                                      fontSize: 22,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                              type: AnimationType.bottomToTop,
                            );
                          }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          loading
              ? Container(
                  color: MyColor.mainPurple,
                  height: double.infinity,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SpinKitWave(
                        color: MyColor.mainOrange,
                        size: 40,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Signing in...",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  _startAnimations() {
    setState(() {
      hideButtonLabels = true;
      _width = _height = 10;
      _borderRadius = 80;
    });
    Future.delayed(Duration(milliseconds: 600), () {
      _scaleController.forward();
    });
  }
}
