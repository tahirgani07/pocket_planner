import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Calculator extends StatelessWidget {
  final TextEditingController calculatorText;
  static int operatorCount = 0;
  static int dotCount = 0;

  Calculator(this.calculatorText);
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width / 4;
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: size,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CalculatorButton("7", calculatorText),
                CalculatorButton("4", calculatorText),
                CalculatorButton("1", calculatorText),
                CalculatorButton(".", calculatorText),
              ],
            ),
          ),
          Container(
            width: size,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CalculatorButton("8", calculatorText),
                CalculatorButton("5", calculatorText),
                CalculatorButton("2", calculatorText),
                CalculatorButton("0", calculatorText),
              ],
            ),
          ),
          Container(
            width: size,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CalculatorButton("9", calculatorText),
                CalculatorButton("6", calculatorText),
                CalculatorButton("3", calculatorText),
                CalculatorButton("c", calculatorText),
              ],
            ),
          ),
          Container(
            width: size,
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CalculatorButton("÷", calculatorText),
                CalculatorButton("*", calculatorText),
                CalculatorButton("-", calculatorText),
                CalculatorButton("+", calculatorText),
                CalculatorButton("=", calculatorText),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String btnValue;
  final TextEditingController calculatorText;
  static double n1 = 0, n2 = 0, res = 0;
  static String valString = "";
  static String currentOperator = "";

  CalculatorButton(this.btnValue, this.calculatorText);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FlatButton(
        child: Text(
          this.btnValue,
          textAlign: TextAlign.center,
          style: GoogleFonts.aBeeZee(
            fontSize: 45,
          ),
        ),
        splashColor: Colors.lightBlue[200],
        highlightColor: Colors.lightBlue[100],
        onPressed: () {
          switch (this.btnValue) {
            case "c":
              {
                calculatorText.text = "0";
                Calculator.operatorCount = 0;
                Calculator.dotCount = 0;
                n1 = n2 = res = 0;
                valString = currentOperator = "";
                break;
              }
            case "+":
            case "-":
            case "÷":
            case "*":
            case "=":
              {
                String currentCalcText = calculatorText.text;
                int lengthOfCurrentCalcText = currentCalcText.length;
                if (currentCalcText == "0") return;
                if (currentCalcText[lengthOfCurrentCalcText - 1] == "+" ||
                    currentCalcText[lengthOfCurrentCalcText - 1] == "-" ||
                    currentCalcText[lengthOfCurrentCalcText - 1] == "÷" ||
                    currentCalcText[lengthOfCurrentCalcText - 1] == "*") {
                  if (currentCalcText[lengthOfCurrentCalcText - 1] ==
                          this.btnValue ||
                      this.btnValue == "=") return;
                  String temp = "";
                  for (int i = 0; i < lengthOfCurrentCalcText - 1; i++)
                    temp += currentCalcText[i];
                  calculatorText.text = temp + this.btnValue;
                  currentOperator = this.btnValue;
                  return;
                }
                if (Calculator.operatorCount == 0 && this.btnValue != "=") {
                  Calculator.operatorCount++;
                  for (int i = 0; i < currentCalcText.length; i++) {
                    if (currentCalcText[i] == this.btnValue) break;
                    valString += currentCalcText[i];
                  }
                  n1 = double.parse(valString);
                  valString = "";
                  currentOperator = this.btnValue;
                  calculatorText.text += this.btnValue;
                } else if (Calculator.operatorCount == 1) {
                  bool tempBool = false;
                  for (int i = 0; i < currentCalcText.length; i++) {
                    // && tempBool is added beacause both the previous currentOperator and current currentOperator can be same.
                    if (currentCalcText[i] == this.btnValue && tempBool) break;
                    if (tempBool) valString += currentCalcText[i];
                    if (currentCalcText[i] == currentOperator[0])
                      tempBool = true;
                  }
                  n2 = double.parse(valString);
                  valString = "";
                  switch (currentOperator) {
                    case "+":
                      res = (n1 + n2);
                      break;
                    case "-":
                      res = (n1 - n2);
                      break;
                    case "*":
                      res = (n1 * n2);
                      break;
                    case "÷":
                      res = (n1 / n2);
                      break;
                    default:
                  }
                  if (res.isNegative) res = 0;
                  if (isInteger(res)) {
                    Calculator.dotCount = 0;
                    calculatorText.text = res.toStringAsFixed(0);
                  } else {
                    Calculator.dotCount = 1;
                    calculatorText.text = res.toStringAsFixed(2);
                  }
                  if (this.btnValue != "=") {
                    calculatorText.text += this.btnValue;
                    currentOperator = this.btnValue;
                    n1 = res;
                  } else {
                    Calculator.operatorCount--;
                  }
                }
                break;
              }
            case ".":
              {
                String currentCalcText = calculatorText.text;
                int lengthOfCurrentCalcText = currentCalcText.length;
                if (Calculator.dotCount == 2) return;
                if ((Calculator.operatorCount == 1 &&
                        Calculator.dotCount < 2) ||
                    Calculator.dotCount == 0) {
                  if (currentCalcText[lengthOfCurrentCalcText - 1] == "+" ||
                      currentCalcText[lengthOfCurrentCalcText - 1] == "-" ||
                      currentCalcText[lengthOfCurrentCalcText - 1] == "÷" ||
                      currentCalcText[lengthOfCurrentCalcText - 1] == "*") {
                    return;
                  } else {
                    calculatorText.text += this.btnValue;
                    Calculator.dotCount++;
                  }
                } else if (Calculator.operatorCount == 0 &&
                    Calculator.dotCount == 1) {
                  return;
                }
                break;
              }
            default:
              {
                if (calculatorText.text == "0")
                  calculatorText.text = btnValue;
                else
                  calculatorText.text += btnValue;
              }
          }
        },
      ),
    );
  }

  bool isInteger(num value) => value is int || value == value.roundToDouble();
}
