// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:heroicons/heroicons.dart';
// import 'package:intl/intl.dart';
// import 'package:bills_app/l10n/app_localizations.dart';
// import 'package:bills_app/model/transaction_model.dart';
// import 'package:bills_app/providers/isar_providers.dart';

// /// category model
// class CategoryReportItem {
//   final String title;
//   final double amountValue;
//   final String formattedAmount;
//   final String percentString;
//   final double percentValue;
//   final HeroIcons icon;
//   final Color color;

//   const CategoryReportItem({
//     required this.title,
//     required this.amountValue,
//     required this.formattedAmount,
//     required this.percentString,
//     required this.percentValue,
//     required this.icon,
//     required this.color,
//   });
// }
// //for monthly compare
// class MonthlyComparisonItem {
//   final String monthName;
//   final double income;
//   final double expense;

//   const MonthlyComparisonItem({
//     required this.monthName,
//     required this.income,
//     required this.expense,
//   });
// }

// /// selected month
// final reportsSelectedDateProvider = StateProvider<DateTime>((ref) {
//   return DateTime.now();
// });

// ///  view type  
// final reportsSelectedViewProvider = StateProvider<int>((ref) => 0);

// final reportsCategoryTypeProvider = StateProvider<int>((ref) => 0);