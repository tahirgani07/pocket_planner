class FinalTaxResult {
  int incomeTaxReliefAfter87A;
  int surcharge;
  int cess;
  int totalTaxLiability;

  FinalTaxResult(this.incomeTaxReliefAfter87A, this.surcharge, this.cess,
      this.totalTaxLiability);
}

class TaxModel {
  static FinalTaxResult calculateFinalTaxResult(
      String taxPayer, String ageOrTypeOfTaxPayer, int netTaxableIncome) {
    int incomeTaxReliefAfter87A = 0;
    int surcharge = 0;
    int cess = 0;
    int totalTaxLiability = 0;
    switch (taxPayer) {
      case "Individual":
      case "HUF":
        {
          if (ageOrTypeOfTaxPayer == "Male" ||
              ageOrTypeOfTaxPayer == "Female") {
            if (netTaxableIncome <= 250000)
              incomeTaxReliefAfter87A = 0;
            else if (netTaxableIncome <= 500000) {
              incomeTaxReliefAfter87A =
                  ((netTaxableIncome - 250000) * 5 / 100).round();
            } else if (netTaxableIncome <= 750000) {
              incomeTaxReliefAfter87A =
                  (((netTaxableIncome - 500000) * 10 / 100) + 12500).round();
            } else if (netTaxableIncome <= 1000000) {
              incomeTaxReliefAfter87A =
                  (((netTaxableIncome - 750000) * 15 / 100) + 25000).round();
            } else if (netTaxableIncome <= 1250000) {
              incomeTaxReliefAfter87A =
                  (((netTaxableIncome - 1000000) * 20 / 100) + 37500).round();
            } else if (netTaxableIncome <= 1500000) {
              incomeTaxReliefAfter87A =
                  (((netTaxableIncome - 1250000) * 25 / 100) + 50000).round();
            } else if (netTaxableIncome > 1500000) {
              incomeTaxReliefAfter87A =
                  (((netTaxableIncome - 1500000) * 30 / 100) + 62500).round();
            }
          }

          if (taxPayer == "Individual" && incomeTaxReliefAfter87A <= 500000)
            incomeTaxReliefAfter87A = 0;

          if (netTaxableIncome > 5000000 && netTaxableIncome <= 10000000) {
            surcharge = (incomeTaxReliefAfter87A * 10 / 100).round();
          } else if (netTaxableIncome > 10000000 &&
              netTaxableIncome <= 20000000) {
            surcharge = (incomeTaxReliefAfter87A * 15 / 100).round();
          } else if (netTaxableIncome > 20000000 &&
              netTaxableIncome <= 50000000) {
            surcharge = (incomeTaxReliefAfter87A * 25 / 100).round();
          } else if (netTaxableIncome > 50000000) {
            surcharge = (incomeTaxReliefAfter87A * 37 / 100).round();
          }

          break;
        }
      case "AOP/BOI":
        {
          if (netTaxableIncome <= 250000)
            incomeTaxReliefAfter87A = 0;
          else if (netTaxableIncome <= 500000) {
            incomeTaxReliefAfter87A =
                ((netTaxableIncome - 250000) * 5 / 100).round();
          } else if (netTaxableIncome <= 1000000) {
            incomeTaxReliefAfter87A =
                (((netTaxableIncome - 500000) * 20 / 100) + 12500).round();
          } else if (netTaxableIncome > 1000000) {
            incomeTaxReliefAfter87A =
                (((netTaxableIncome - 1000000) * 30 / 100) + 112500).round();
          }

          if (netTaxableIncome > 5000000 && netTaxableIncome <= 10000000) {
            surcharge = (incomeTaxReliefAfter87A * 10 / 100).round();
          } else if (netTaxableIncome > 10000000 &&
              netTaxableIncome <= 20000000) {
            surcharge = (incomeTaxReliefAfter87A * 15 / 100).round();
          } else if (netTaxableIncome > 20000000 &&
              netTaxableIncome <= 50000000) {
            surcharge = (incomeTaxReliefAfter87A * 25 / 100).round();
          } else if (netTaxableIncome > 50000000) {
            surcharge = (incomeTaxReliefAfter87A * 37 / 100).round();
          }
          break;
        }
      case "Firms":
      case "LLP":
        {
          incomeTaxReliefAfter87A = (netTaxableIncome * 30 / 100).round();

          surcharge = netTaxableIncome > 10000000
              ? (incomeTaxReliefAfter87A * 12 / 100).round()
              : 0;

          break;
        }
      case "Domestic Company":
        {
          if (ageOrTypeOfTaxPayer == "upto400Cr")
            incomeTaxReliefAfter87A = (netTaxableIncome * 25 / 100).round();
          else if (ageOrTypeOfTaxPayer == "greaterThan400Cr")
            incomeTaxReliefAfter87A = (netTaxableIncome * 30 / 100).round();

          if (netTaxableIncome > 10000000 && netTaxableIncome < 100000000) {
            surcharge = (incomeTaxReliefAfter87A * 7 / 100).round();
          } else if (netTaxableIncome > 100000000) {
            surcharge = (incomeTaxReliefAfter87A * 12 / 100).round();
          }
          break;
        }
      case "Foreign Company":
        {
          incomeTaxReliefAfter87A = (netTaxableIncome * 40 / 100).round();

          if (netTaxableIncome > 10000000 && netTaxableIncome < 100000000) {
            surcharge = (incomeTaxReliefAfter87A * 2 / 100).round();
          } else if (netTaxableIncome > 100000000) {
            surcharge = (incomeTaxReliefAfter87A * 5 / 100).round();
          }
          break;
        }
      case "Co-operative Society":
        {
          if (netTaxableIncome <= 10000)
            incomeTaxReliefAfter87A = (netTaxableIncome * 10 / 100).round();
          else if (netTaxableIncome <= 20000)
            incomeTaxReliefAfter87A =
                ((netTaxableIncome - 10000) * 20 / 100 + 1000).round();
          else if (netTaxableIncome > 20000)
            incomeTaxReliefAfter87A =
                ((netTaxableIncome - 20000) * 30 / 100 + 3000).round();

          if (netTaxableIncome > 10000000)
            surcharge = (incomeTaxReliefAfter87A * 12 / 100).round();
          break;
        }
    }

    cess = ((incomeTaxReliefAfter87A + surcharge) * 4 / 100).round();

    totalTaxLiability = incomeTaxReliefAfter87A + surcharge + cess;

    return FinalTaxResult(
        incomeTaxReliefAfter87A, surcharge, cess, totalTaxLiability);
  }
}
