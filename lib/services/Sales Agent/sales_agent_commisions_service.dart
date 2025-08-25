import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants/Constants.dart';
import '../../screens/Sales Agent/SalesAgentCommisionsReport.dart';

Future<void> getSalesAgentCommissionReport(
    String date_from,
    String date_to,
    int selectedButton1,
    String type,
    String employee,
    BuildContext context) async {
  String baseUrl = "https://miinsightsapps.net/files/get_commision_data/";
  int days_difference = 0;
  DateTime now = DateTime.now();

  //print("sghgjgjhsg $date_from $date_to");

  try {
    Map<String, String>? payload = {
      "client_id": "379",
      "start_date": date_from,
      "end_date": date_to,
      "type": type,
      "employee": "Maria Sibanyoni"
    };
    // print("body_comm_fgfgfg $payload");
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
        //print("baseUrljhjjh $baseUrl");
        //print("payloadgfghgh_error ${response.statusCode} ${response.body}");
      }
      if (response.statusCode != 200) {
      } else {
        var jsonResponse1 = jsonDecode(response.body);
        /* print(
            "shjsdhsdfhgg ${jsonResponse1["current_month_receiving_commision_list"]}");*/
        if (type == "all_employees") {
          Constants.commssions_data_employees = List<String>.from(
              jsonResponse1["current_month_receiving_commision_list"]);
        }
        current_month_commission = jsonResponse1["current_month_commission"];
        current_number_of_sales = jsonResponse1["current_number_of_sales"];
        current_month_receiving_commision =
            jsonResponse1["current_month_receiving_commision"];
        commissionsValue.value++;

        isLoadingCommisionData = false;
        /* commission_barChartData2 =
            processDataForCommissionCountMonthly2(response.body, context);
*/
        //print("collection_by_type ${jsonResponse1["commission_by_type"]}");

        commision_data_policies = [];
        commision_data_policies =
            List<Map<String, dynamic>>.from(jsonResponse1["commisions"]);

        commissionsValue.value++;

        isLoadingCommisionData = false;

        if (selectedButton1 == 1) {}

        sectionsList2 = [
          commission_gridmodel("Cash", 0, 0),
          commission_gridmodel("Debit Order", 0, 0),
          commission_gridmodel("Salary Deduction", 0, 0),
          commission_gridmodel("Persal", 0, 0),
        ];

        List collection_by_type = jsonResponse1["commission_by_type"] ?? [];

        collection_by_type.forEach((element) {
          Map m1 = element as Map;
          if (m1["payment_type"] == "Cash Payment") {
            //print("fghggh0 ${m1["total_amount"]}");
            //print("fghggh0 ${m1["percentage"]}");
            sectionsList2[0].count = (m1["total_amount"] ?? 0).toInt();
            sectionsList2[0].amount = m1["percentage"] ?? 0;
          } else if (m1["payment_type"] == "Debit Order") {
            sectionsList2[1].count = (m1["total_amount"] ?? 0).toInt();
            sectionsList2[1].amount = m1["percentage"] ?? 0;
            //print("fghggh1 ${m1["total_amount"]}");
            //print("fghggh1 ${m1["percentage"]}");
          } else if (m1["payment_type"] == "Salary Deduction") {
            sectionsList2[2].count = (m1["total_amount"] ?? 0).toInt();
            sectionsList2[2].amount = m1["percentage"] ?? 0;
            //print("fghggh2 ${m1["total_amount"]}");
            //print("fghggh2 ${m1["percentage"]}");
          } else if (m1["payment_type"] == "persal") {
            sectionsList2[3].count = (m1["total_amount"] ?? 0).toInt();
            sectionsList2[3].amount = m1["percentage"];
            //print("fghggh3 ${m1["total_amount"]}");
            //print("fghggh3 ${m1["percentage"]}");
          }
        });
        commissionsValue.value++;
      }
    });
  } on Exception catch (_, exception) {
    //Exception exc = exception as Exception;
    // print(exception);
  }
}

Future<void> getSalesAgentCommissionReport2(
    String date_from,
    String date_to,
    int selectedButton1,
    String type,
    String employee,
    BuildContext context) async {
  String baseUrl = "https://miinsightsapps.net/files/get_commision_data/";
  int days_difference = 0;
  DateTime now = DateTime.now();

  //print("sghgjgjhsg $date_from $date_to");

  try {
    Map<String, String>? payload = {
      "client_id": "379",
      "start_date": date_from,
      "end_date": date_to,
      "type": "all_employees1",
      "employee": "Maria Sibanyoni"
    };

    // print("body_comm_fgfgfg2 $payload");
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
        // print("baseUrljhjjh $baseUrl");
        // print("payloadgfghgh2_error ${response.statusCode} ${response.body}");
      }
      if (response.statusCode != 200) {
      } else {
        var jsonResponse1 = jsonDecode(response.body);

        commissionsValue.value++;

        isLoadingCommisionData = false;

        commissionsValue.value++;
        commission_barChartData1 = processDataForCommissionCountMonthly2(
            response.body, date_from, date_to, context);
        //print("fghgghgf $commission_barChartData1");
        isLoadingCommisionData = false;

        commissionsValue.value++;
      }
    });
  } on Exception catch (_, exception) {
    //Exception exc = exception as Exception;
    // print(exception);
  }
}

List<BarChartGroupData> processDataForCommissionCountMonthly(
  String jsonString,
  BuildContext context,
) {
  bool containsData = false;
  List<dynamic> jsonData = jsonDecode(jsonString)["commission_summary"];

  Map<String, Map<String, double>> monthlySales = {};

  for (var item in jsonData) {
    if (item is Map<String, dynamic>) {
      //print("datehhghghhg $item ");
      DateTime date = DateTime.parse(item['formatted_date'] + "01");

      String monthKey = "${date.year}-${date.month.toString().padLeft(2, '0')}";
      String type = item["type"] ?? "";
      double count = (item["count"] as num).toDouble();

      monthlySales.putIfAbsent(monthKey, () => {});
      //print("ghgghjj $monthKey $type $count");
      monthlySales[monthKey]
          ?.update(type, (value) => value + count, ifAbsent: () => count);
      containsData = true;
    }
  }

  var sortedMonths = monthlySales.keys.toList()..sort();

  List<BarChartGroupData> barChartData = [];
  for (var monthKey in sortedMonths) {
    print("monthKey $monthKey");
    var statusData = monthlySales[monthKey];
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    // Assuming sortReprintCancellationsData and colorOrder are defined elsewhere

    //print("statusData $statusData");
    if (statusData != null)
      statusData.forEach((entry, value) {
        rodStackItems.add(BarChartRodStackItem(
            cumulativeAmount, cumulativeAmount + value, Colors.blue));
        cumulativeAmount += value;
      });

    /*print(
        "barChartData ${DateTime.parse(monthKey + "01").month} ${cumulativeAmount}");
*/
    barChartData.add(BarChartGroupData(
      x: DateTime.parse(monthKey + "01").month,
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

List<BarChartGroupData> processDataForCommissionCountMonthly2(
    String jsonString, String startDate, String endDate, BuildContext context) {
  //print("aaxdss");
  List<dynamic> jsonData = jsonDecode(jsonString)["commission_summary"];

  DateTime end = DateTime.parse(endDate);
  DateTime start = DateTime(end.year - 1, end.month, end.day);
  int monthsInRange = 12;

  // Initialize monthlySales for each month in the range
  Map<int, Map<String, double>> monthlySales = {
    for (var i = 0; i < monthsInRange; i++)
      DateTime(end.year, end.month - i, 1).month: {}
  };

  for (var collectionItem in jsonData) {
    if (collectionItem is Map<String, dynamic>) {
      DateTime paymentDate =
          DateTime.parse(collectionItem['formatted_date'] + "-01");
      if (paymentDate.isAfter(start) &&
          paymentDate.isBefore(end.add(const Duration(days: 1)))) {
        int monthIndex = paymentDate.month;
        String collectionType = collectionItem["payment_type"];
        double premium = collectionItem["total_commission"];

        monthlySales.putIfAbsent(monthIndex, () => {});
        monthlySales[monthIndex]?.update(
            collectionType, (value) => value + premium,
            ifAbsent: () => premium);
      }
    }
  }

  monthlySales = monthlySales.entries
      .toList()
      .reversed
      .fold<Map<int, Map<String, double>>>({},
          (Map<int, Map<String, double>> newMap, entry) {
    newMap[entry.key] = entry.value;
    return newMap;
  });

  int numberOfBars = monthlySales.length;
  double chartWidth = Constants.screenWidth;
  double maxBarWidth = 30; // Maximum width of a bar
  double minBarSpace = 4; // Minimum space between bars

  double barWidth = min(maxBarWidth, (chartWidth / (2 * numberOfBars)));
  double barsSpace = max(minBarSpace,
      (chartWidth - (barWidth * numberOfBars)) / (numberOfBars - 1));

  List<BarChartGroupData> collectionsGroupedData = [];
  monthlySales.forEach((monthIndex, salesData) {
    //print("aaxdss $monthIndex $salesData");
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    salesData.forEach((key, value) {
      String type = key;
      double amount = value;
      Color color;

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, Colors.blue));
      cumulativeAmount += amount;
    });
    rodStackItems
        .sort((a, b) => colorOrder[a.color]!.compareTo(colorOrder[b.color]!));
    rodStackItems = rodStackItems.reversed.toList();
    // print(rodStackItems);

    collectionsGroupedData.add(BarChartGroupData(
      x: monthIndex,
      barRods: [
        BarChartRodData(
          toY: cumulativeAmount,
          rodStackItems: rodStackItems.isEmpty
              ? [BarChartRodStackItem(0, 0, Colors.transparent)]
              : rodStackItems,
          borderRadius: BorderRadius.zero,
          width: 23.5,
        ),
      ],
      barsSpace: barsSpace,
    ));
  });
  // print("ghhjhkkj ${collectionsGroupedData}");

  return collectionsGroupedData;
}

Map<Color, int> colorOrder = {
  Colors.blue: 1,
  Colors.purple: 2,
  Colors.orange: 3,
  Colors.grey: 4,
  Colors.green: 5,
  Colors.yellow: 6,
};
