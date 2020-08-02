import 'package:financial_and_tax_planning_app/models/extras/categories_icon_icons.dart';
import 'package:financial_and_tax_planning_app/models/extras/my_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TransactionCategoriesInternalModel {
  String desc;
  IconData icon;
  List<TransactionCategoriesInternalModel> subCategories = [];

  TransactionCategoriesInternalModel(this.desc, this.icon, this.subCategories);
}

class TransactionCategoriesModel {
  String transactionType;
  String transactionSign;
  List<TransactionCategoriesInternalModel> listOfCategories = [];

  TransactionCategoriesModel(String transactionType) {
    this.transactionType = transactionType;
    switch (this.transactionType) {
      case "Transfer":
        // No transaction Sign
        transactionSign = " ";
        // Only One Icon
        listOfCategories = [
          TransactionCategoriesInternalModel("Transfer", Icons.transform, []),
        ];
        break;
      case "Income":
        {
          transactionSign = "+";
          listOfCategories = getActualTransactionCategories();
          break;
        }
      case "Expense":
        {
          transactionSign = "-";
          listOfCategories = getActualTransactionCategories();
          break;
        }
    }
  }

  // Actual categories list for income and expense both.
  List<TransactionCategoriesInternalModel> getActualTransactionCategories() {
    return [
      // Food & Drinks
      TransactionCategoriesInternalModel(
        "Food & Drinks",
        Icons.fastfood,
        [
          TransactionCategoriesInternalModel(
              "Food & Drinks", Icons.fastfood, []),
          TransactionCategoriesInternalModel(
              "Bar & Cafe", CategoriesIcon.bar_cafe, []),
          TransactionCategoriesInternalModel(
              "Groceries", CategoriesIcon.groceries, []),
          TransactionCategoriesInternalModel(
              "Restaurant, fast-food", CategoriesIcon.restaurant, []),
        ],
      ),

      // Shopping
      TransactionCategoriesInternalModel(
        "Shopping",
        Icons.shopping_basket,
        [
          TransactionCategoriesInternalModel(
              "Shopping", Icons.shopping_basket, []),
          TransactionCategoriesInternalModel(
              "Clothes & Shoes", MyIcons.dressandaccessoriesicon, []),
          TransactionCategoriesInternalModel(
              "Drug-store, chemist", MdiIcons.medicalBag, []),
          TransactionCategoriesInternalModel("Electronics, accessories",
              CategoriesIcon.electronics_smartphone, []),
          TransactionCategoriesInternalModel(
              "Free time", CategoriesIcon.emoji_smiley, []),
          TransactionCategoriesInternalModel(
              "Gifts, joy", CategoriesIcon.gifts, []),
          TransactionCategoriesInternalModel(
              "Health & Beauty", CategoriesIcon.health_beauty_cream, []),
          TransactionCategoriesInternalModel(
            "Home, garden",
            CategoriesIcon.house,
            [],
          ),
          TransactionCategoriesInternalModel(
              "Jewels, accessories", CategoriesIcon.jewels_diamond, []),
          TransactionCategoriesInternalModel("Kids", CategoriesIcon.kids, []),
          TransactionCategoriesInternalModel(
              "Pets, animals", CategoriesIcon.pets_pawprint, []),
          TransactionCategoriesInternalModel(
              "Stationery, tools", CategoriesIcon.stationery, []),
        ],
      ),

      // Housing
      TransactionCategoriesInternalModel(
        "Housing",
        CategoriesIcon.house,
        [
          TransactionCategoriesInternalModel(
              "Housing", CategoriesIcon.house, []),
          TransactionCategoriesInternalModel(
              "Energy, utilities", CategoriesIcon.energy_bulb, []),
          TransactionCategoriesInternalModel("Kids", CategoriesIcon.kids, []),
          TransactionCategoriesInternalModel(
              "Maintainence, repairs", CategoriesIcon.repair, []),
          TransactionCategoriesInternalModel(
              "Mortgage", CategoriesIcon.mortgage, []),
          TransactionCategoriesInternalModel(
              "Property insurance", CategoriesIcon.property_insurance, []),
          TransactionCategoriesInternalModel("Rent", CategoriesIcon.rent, []),
          TransactionCategoriesInternalModel(
              "Services", CategoriesIcon.services_support_settings, []),
        ],
      ),

      // Transportation
      TransactionCategoriesInternalModel(
        "Transportation",
        CategoriesIcon.transport_bus,
        [
          TransactionCategoriesInternalModel(
              "Transportation", CategoriesIcon.transport_bus, []),
          TransactionCategoriesInternalModel(
              "Business trips", CategoriesIcon.transport_businessbag, []),
          TransactionCategoriesInternalModel(
              "Long distance", CategoriesIcon.transport_airplane, []),
          TransactionCategoriesInternalModel(
              "Public transport", CategoriesIcon.transport_bus, []),
          TransactionCategoriesInternalModel(
              "Taxi", CategoriesIcon.transport_taxi, []),
        ],
      ),

      // Vehicle
      TransactionCategoriesInternalModel(
        "Vehicle",
        CategoriesIcon.transport_car,
        [
          TransactionCategoriesInternalModel(
              "Vehicle", CategoriesIcon.transport_car, []),
          TransactionCategoriesInternalModel(
              "Fuel", CategoriesIcon.vehicle_fuel, []),
          TransactionCategoriesInternalModel(
              "Leasing", CategoriesIcon.vehicle_leasing, []),
          TransactionCategoriesInternalModel(
              "Parking", CategoriesIcon.vehicle_parking, []),
          TransactionCategoriesInternalModel(
              "Rentals", CategoriesIcon.vehicle_car_rental, []),
          TransactionCategoriesInternalModel(
              "Vehicle insurance", CategoriesIcon.vehicle_car_insurance, []),
          TransactionCategoriesInternalModel(
              "Vehicle maintainence", CategoriesIcon.vehicle_maintenance, []),
        ],
      ),

      // Life & Entertainment
      TransactionCategoriesInternalModel(
        "Life & Entertainment",
        CategoriesIcon.life_and_entertainment_main,
        [
          TransactionCategoriesInternalModel("Life & Entertainment",
              CategoriesIcon.life_and_entertainment_main, []),
          TransactionCategoriesInternalModel("Active sport, fitness",
              CategoriesIcon.life_and_entertainment_fitness, []),
          TransactionCategoriesInternalModel("Alcohol, tobacco",
              CategoriesIcon.life_and_entertainment_alcohol, []),
          TransactionCategoriesInternalModel("Books, audio, subscriptions",
              CategoriesIcon.life_and_entertainment_book, []),
          TransactionCategoriesInternalModel(
              "Charity, gifts", CategoriesIcon.gifts, []),
          TransactionCategoriesInternalModel("Culture, sport events",
              CategoriesIcon.life_and_entertainment_sports_events, []),
          TransactionCategoriesInternalModel("Education, development",
              CategoriesIcon.life_and_entertainment_education, []),
          TransactionCategoriesInternalModel("Health care, doctor",
              CategoriesIcon.life_and_entertainment_healthcare, []),
          TransactionCategoriesInternalModel("Hobbies",
              CategoriesIcon.life_and_entertainment_hobbies_heart, []),
          TransactionCategoriesInternalModel("Holiday, trips, hotels",
              CategoriesIcon.life_and_entertainment_holiday_trip, []),
          TransactionCategoriesInternalModel(
              "Life events",
              CategoriesIcon.life_and_entertainment_life_events_birthday_cake,
              []),
          TransactionCategoriesInternalModel("Lottery, gambling",
              CategoriesIcon.life_and_entertainment_lottery, []),
          TransactionCategoriesInternalModel("TV, streaming",
              CategoriesIcon.life_and_entertainment_tv_streamingnetflix, []),
          TransactionCategoriesInternalModel("Wellness, beauty",
              CategoriesIcon.life_and_entertainment_wellness_cosmetics, []),
        ],
      ),

      // Communication, PC
      TransactionCategoriesInternalModel(
        "Communication, PC",
        CategoriesIcon.electronics_smartphone,
        [
          TransactionCategoriesInternalModel(
              "Communication, PC", CategoriesIcon.electronics_smartphone, []),
          TransactionCategoriesInternalModel(
              "Internet", CategoriesIcon.communication_internet_wifi, []),
          TransactionCategoriesInternalModel(
              "Phone, cell phone", CategoriesIcon.communication_phone, []),
          TransactionCategoriesInternalModel("Postal services",
              CategoriesIcon.communication_postal_services, []),
          TransactionCategoriesInternalModel("Software, apps, games",
              CategoriesIcon.communication_software, []),
        ],
      ),

      // Financial expenses
      TransactionCategoriesInternalModel(
        "Financial expenses",
        CategoriesIcon.financial_expense_main_money,
        [
          TransactionCategoriesInternalModel("Financial expenses",
              CategoriesIcon.financial_expense_main_money, []),
          TransactionCategoriesInternalModel(
              "Advisory", CategoriesIcon.financial_expense_advisory, []),
          TransactionCategoriesInternalModel("Charges, fees",
              CategoriesIcon.financial_expense_charge_fees, []),
          TransactionCategoriesInternalModel("Child support",
              CategoriesIcon.financial_expense_child_support, []),
          TransactionCategoriesInternalModel(
              "Fines", CategoriesIcon.financial_expense_main_money, []),
          TransactionCategoriesInternalModel(
              "Insurances", CategoriesIcon.vehicle_car_insurance, []),
          TransactionCategoriesInternalModel(
              "Loans, interests", CategoriesIcon.financial_expense_loan, []),
          TransactionCategoriesInternalModel(
              "Taxes", CategoriesIcon.financial_expense_tax, []),
        ],
      ),

      // Investments
      TransactionCategoriesInternalModel(
        "Investments",
        CategoriesIcon.investments_main,
        [
          TransactionCategoriesInternalModel(
              "Investments", CategoriesIcon.investments_main, []),
          TransactionCategoriesInternalModel(
              "Collections", CategoriesIcon.investments_collection, []),
          TransactionCategoriesInternalModel("Financial investments",
              CategoriesIcon.investments_financial_investment, []),
          TransactionCategoriesInternalModel(
              "Realty", CategoriesIcon.investments_realty, []),
          TransactionCategoriesInternalModel(
              "Savings", CategoriesIcon.investments_savings, []),
          TransactionCategoriesInternalModel(
              "Vehicles, chattels", CategoriesIcon.transport_car, []),
        ],
      ),

      // Income
      TransactionCategoriesInternalModel(
        "Income",
        CategoriesIcon.income_main_coins,
        [
          TransactionCategoriesInternalModel(
              "Income", CategoriesIcon.income_main_coins, []),
          TransactionCategoriesInternalModel(
              "Checks, coupons", CategoriesIcon.income_main_coins, []),
          TransactionCategoriesInternalModel("Child Support",
              CategoriesIcon.financial_expense_child_support, []),
          TransactionCategoriesInternalModel(
              "Dues & grants", CategoriesIcon.income_grant, []),
          TransactionCategoriesInternalModel("Gifts", CategoriesIcon.gifts, []),
          TransactionCategoriesInternalModel(
              "Interests, dividends", CategoriesIcon.income_interests, []),
          TransactionCategoriesInternalModel(
              "Lending, renting", CategoriesIcon.income_lending, []),
          TransactionCategoriesInternalModel("Lottery, gambling",
              CategoriesIcon.life_and_entertainment_lottery, []),
          TransactionCategoriesInternalModel(
              "Refunds (tax, purchase)", CategoriesIcon.income_refund, []),
          TransactionCategoriesInternalModel(
              "Rental income", CategoriesIcon.income_rental_income, []),
          TransactionCategoriesInternalModel(
              "Sale", CategoriesIcon.income_sale, []),
          TransactionCategoriesInternalModel(
              "Wage, invoices", CategoriesIcon.income_wages, []),
        ],
      ),
    ];
  }
}
