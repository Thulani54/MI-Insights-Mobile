import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants/Constants.dart';
import '../../screens/Reports/Executive/ExecutiveCommisionsReport.dart';
import '../../utils/login_utils.dart';

Future<void> getExecutiveCommissionReport(
    String date_from,
    String date_to,
    int selectedButton1,
    String type,
    String employee,
    BuildContext context) async {
  String baseUrl =
      '${Constants.analitixAppBaseUrl}sales/view_normalized_commissions_data/';
  if (hasTemporaryTesterRole(Constants.myUserRoles)) {
    baseUrl =
        '${Constants.analitixAppBaseUrl}sales/view_normalized_commissions_data_test/';
  }

  //String baseUrl = "${Constants.analitixAppBaseUrl}get_commision_data/";
  int days_difference = 0;
  DateTime now = DateTime.now();

  //print("sghgjgjhsg $date_from $date_to");

  try {
    Map<String, String>? payload = {
      "client_id": Constants.cec_client_id.toString(),
      "start_date": date_from,
      "end_date": date_to,
      "type": type,
      "employee": employee
    };
    print("body_claims_fgfgfg $payload");
    //print(payload);
    isLoadingCommisionData = true;

    await http
        .post(
      Uri.parse(
        baseUrl,
      ),
      body: payload,
    )
        .then((value) {
      http.Response response = value;
      if (kDebugMode) {
        //print("baseUrl $baseUrl");
        //  print("payloadgfghgh_error ${response.statusCode} ${response.body}");
      }
      if (response.statusCode != 200) {
        // Set default values on error
        _setDefaultCommissionValues(type, context);
      } else {
        var jsonResponse1 = jsonDecode(response.body);

        // Use null-aware operators and provide defaults
        if (type == "all_employees") {
          Constants.commssions_data_employees = List<String>.from(
              jsonResponse1["current_month_receiving_commision_list"] ??
                  ["All Employees"]);
        }

        current_month_commission =
            jsonResponse1["current_month_commission"] ?? 0.0;
        current_number_of_sales = jsonResponse1["current_number_of_sales"] ?? 0;
        current_month_receiving_commision =
            jsonResponse1["current_month_receiving_commision"] ?? 0;

        // Check if context is still mounted before notifying
        if (context.mounted) {
          commissionsValue.value++;
        }

        commission_barChartData1 = [];

        /* commission_barChartData2 =
            processDataForCommissionCountMonthly2(response.body, context);
        */
        print("collection_by_type ${jsonResponse1["commission_by_type"]}");

        if (type == "all_employees") {
          commision_data_policies = [];
          commision_data_policies = List<Map<String, dynamic>>.from(
              jsonResponse1["commisions"] ?? []);
        }

        // Check if context is still mounted before notifying
        if (context.mounted) {
          commissionsValue.value++;
        }

        //commission_barChartData1 = processDataForCommissionCountMonthly2(response.body);

        if (selectedButton1 == 1) {}

        // Initialize with default values
        sectionsList2 = [
          commission_gridmodel("Cash", 0, 0),
          commission_gridmodel("Debit Order", 0, 0),
          commission_gridmodel("Salary Deduction", 0, 0),
          commission_gridmodel("Persal", 0, 0),
        ];

        List collection_by_type = jsonResponse1["commission_by_type"] ?? [];

        if (collection_by_type.isNotEmpty) {
          for (var element in collection_by_type) {
            Map m1 = element as Map;
            if (m1["payment_type"] == "Cash Payment") {
              if (kDebugMode) {
                //print("fghggh0 ${m1["total_amount"]}");
                //print("fghggh0 ${m1["percentage"]}");
              }

              sectionsList2[0].count = (m1["total_amount"] ?? 0).toInt();
              sectionsList2[0].amount = m1["percentage"] ?? 0;
            } else if (m1["payment_type"] == "Debit Order") {
              sectionsList2[1].count = (m1["total_amount"] ?? 0).toInt();
              sectionsList2[1].amount = m1["percentage"] ?? 0;
              print("fghggh1 ${m1["total_amount"]}");
              print("fghggh1 ${m1["percentage"]}");
            } else if (m1["payment_type"] == "Salary Deduction") {
              sectionsList2[2].count = (m1["total_amount"] ?? 0).toInt();
              sectionsList2[2].amount = m1["percentage"] ?? 0;
              print("fghggh2 ${m1["total_amount"]}");
              print("fghggh2 ${m1["percentage"]}");
            } else if (m1["payment_type"] == "persal") {
              sectionsList2[3].count = (m1["total_amount"] ?? 0).toInt();
              sectionsList2[3].amount = m1["percentage"] ?? 0;
              print("fghggh3 ${m1["total_amount"]}");
              print("fghggh3 ${m1["percentage"]}");
            }
          }
        }

        // Check if context is still mounted before final update
        if (context.mounted) {
          commissionsValue.value++;
        }
        isLoadingCommisionData = false;
      }
    });
  } on Exception catch (_, exception) {
    // Set default values on exception
    _setDefaultCommissionValues(type, context);
    //Exception exc = exception as Exception;
    // print(exception);
  }
}

// Helper method to set default values with mounted check
void _setDefaultCommissionValues(String type, BuildContext context) {
  if (type == "all_employees") {
    Constants.commssions_data_employees = ["All Employees"];
  }

  current_month_commission = 0.0;
  current_number_of_sales = 0;
  current_month_receiving_commision = 0;

  // Check if context is still mounted before notifying
  if (context.mounted) {
    commissionsValue.value++;
  }

  commission_barChartData1 = [];

  if (type == "all_employees") {
    commision_data_policies = [];
  }

  // Check if context is still mounted before notifying
  if (context.mounted) {
    commissionsValue.value++;
  }

  // Initialize with default values
  sectionsList2 = [
    commission_gridmodel("Cash", 0, 0),
    commission_gridmodel("Debit Order", 0, 0),
    commission_gridmodel("Salary Deduction", 0, 0),
    commission_gridmodel("Persal", 0, 0),
  ];

  // Check if context is still mounted before final update
  if (context.mounted) {
    commissionsValue.value++;
  }
  isLoadingCommisionData = false;
}

List<BarChartGroupData> processDataForCommissionCountMonthly2(
  String jsonString,
  BuildContext context,
) {
  bool containsData = false;
  List<dynamic> jsonData = jsonDecode(jsonString)["commission_summary"];

  Map<String, Map<String, double>> monthlySales = {};

  for (var item in jsonData) {
    if (item is Map<String, dynamic>) {
      print("datehhghghhg $item ");
      DateTime date = DateTime.parse(item['formatted_date']);

      String monthKey = "${date.year}-${date.month.toString().padLeft(2, '0')}";
      String type = item["type"] ?? "";
      double count = (item["count"] as num).toDouble();

      monthlySales.putIfAbsent(monthKey, () => {});
      print("ghgghjj $monthKey $type $count");
      monthlySales[monthKey]
          ?.update(type, (value) => value + count, ifAbsent: () => count);
      containsData = true;
    }
  }

  var sortedMonths = monthlySales.keys.toList()..sort();

  List<BarChartGroupData> barChartData = [];
  for (var monthKey in sortedMonths) {
    var statusData = monthlySales[monthKey];
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    // Assuming sortReprintCancellationsData and colorOrder are defined elsewhere
    var sortedEntries = sortReprintCancellationsData(statusData!);
    sortedEntries.forEach((entry) {
      Color color = _getStatusColor(entry.key);
      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + entry.value, color));
      cumulativeAmount += entry.value;
    });

    barChartData.add(BarChartGroupData(
      x: DateTime.parse(monthKey + "-01").month,
      barRods: [
        BarChartRodData(
          toY: cumulativeAmount,
          rodStackItems: rodStackItems.isEmpty
              ? [BarChartRodStackItem(0, 0, Colors.transparent)]
              : rodStackItems,
          borderRadius: BorderRadius.zero,
          width: (Constants.screenWidth / 12) - 8,
        ),
      ],
    ));
  }

  return containsData ? barChartData : [];
}

List<MapEntry<String, double>> sortReprintCancellationsData(
    Map<String, double> salesData) {
  Map<String, Color> typeToColor = {
    'Cash Payment': Colors.blue,
    'Debit Order': Colors.purple,
    'persal': Colors.green,
    'Salary Deduction': Colors.yellow,
    'Other': Colors.grey,
  };

  Map<Color, int> colorOrder = {
    Colors.blue: 1,
    Colors.purple: 2,
    Colors.green: 3,
    Colors.yellow: 4,
    Colors.grey: 5,
  };

  var entries = salesData.entries.toList();

  entries.sort((a, b) {
    Color colorA =
        typeToColor[a.key] ?? Colors.grey; // Default to grey if not found
    Color colorB =
        typeToColor[b.key] ?? Colors.grey; // Default to grey if not found
    return colorOrder[colorA]!.compareTo(colorOrder[colorB]!);
  });

  return entries;
}

Color _getStatusColor(String status) {
  Color color;
  switch (status) {
    case 'Cash Payment':
      color = Colors.blue;
      break;
    case 'EFT':
      color = Colors.purple;
      break;
    case 'Debit Order':
      color = Colors.orange;
      break;
    case 'persal':
      color = Colors.green;
      break;
    case 'Easypay':
      color = Colors.indigo;
      break;
    case 'Salary Deduction':
      color = Colors.yellow;
      break;
    default:
      print("fgghgh " + status);
      color = Colors.grey;
  }
  return color;
}
