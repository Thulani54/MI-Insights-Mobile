import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mi_insights/models/SalesByAgent.dart';

import '../constants/Constants.dart';
import '../models/MoraleIndexCategory.dart';
import '../models/salesgridmodel.dart';
import '../screens/Reports/MoralIndexReport.dart';

List<BarChartGroupData> barChartData1 = [];
List<BarChartGroupData> barChartData2 = [];
List<BarChartGroupData> barChartData3 = [];
List<BarChartGroupData> barChartData4 = [];
List<dynamic> moods_list = [];
Future<void> getMoralIndexReport(String date_from, String date_to,
    int selectedButton1, BuildContext context) async {
  https: //uat.miinsightsapps.net/fieldV6/getLeadss?empId=3&searchKey=6&status=all&cec_client_id=1&type=field&startDate=2023-08-01&endDate=2023-08-31
  String baseUrl =
      "${Constants.insightsBackendBaseUrl}files/count_users_moods/";

  try {
    Map<String, String>? payload = {
      "client_id": Constants.cec_client_id.toString(),
      "start_date": date_from,
      "end_date": date_to
    };
    if (kDebugMode) {
      //print("baseUrl $baseUrl");
      // print("payload $payload");
    }

    List<Map<String, dynamic>> sales = [];
    Map<String, List<Map<String, dynamic>>> groupedSales1a = {};
    Map<String, List<Map<String, dynamic>>> groupedSales2a = {};
    Map<String, List<Map<String, dynamic>>>? groupedSalesByBranch1a = {};
    Map<String, List<Map<String, dynamic>>>? groupedSalesByBranch2a = {};

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
        if (kDebugMode) {
          //print("ghjgjgg " + response.body);
          //print("ghjgjgg " + response.body.runtimeType.toString());
        }
        //print(response.bodyBytes);
        //print(response.statusCode);
        //print(response.body);
        //print(response.body);
      }
      if (response.statusCode != 200) {
      } else {
        int id_y = 1;

        Constants.moral_index_barData = [];

        Constants.moral_index_bottomTitles2a = [];
        Map<int, int> dailySalesCount = {};
        Map<int, int> dailySalesCount1b = {};
        Map<int, int> dailySalesCount1c = {};
        Map<int, int> monthlySalesCount2a = {};
        Map<int, int> monthlySalesCount2b = {};
        Map<int, int> monthlySalesCount2c = {};
        int monthlyTotal = 0;

        if (selectedButton1 == 1) {
          Constants.moral_index_salesbyagent1a = [];
          Constants.moral_index_bottomTitles1a = [];
          Constants.moral_index_maxY5a = 0;
        } else if (selectedButton1 == 2) {
          Constants.moral_index_salesbyagent2a = [];
          Constants.moral_index_bottomTitles2a = [];
          Constants.moral_index_maxY5b = 0;
        } else if (selectedButton1 == 3 && days_difference < 31) {
          Constants.moral_index_salesbyagent3a = [];
          Constants.moral_index_bottomTitles3a = [];
          Constants.moral_index_maxY5c = 0;
        } else {
          Constants.moral_index_salesbyagent3b = [];
          Constants.moral_index_bottomTitles3b = [];
          Constants.moral_index_maxY5d = 0;
        }
        Constants.moral_index_salesbyagent1b = [];

        var jsonResponse = jsonDecode(response.body);
        //var jsonResponse = jsonDecode(Sample_Jsons.morale_index);
        //print("fdfgg $jsonResponse");
        DateTime startDateTime = DateFormat('yyyy-MM-dd').parse(date_from);
        DateTime endDateTime = DateFormat('yyyy-MM-dd').parse(date_to);
        //print("date_from $date_from");
        //print("date_to $date_to");
        //print("date_to $date_to");
        moods_list = jsonResponse["moods"] ?? [];

        int days_difference1 = endDateTime.difference(startDateTime).inDays;

        if (selectedButton1 == 1) {
          Constants.moral_index_sectionsList1a = [
            salesgridmodel("Happy", jsonResponse["counts_by_type"]["3"] ?? 0),
            salesgridmodel("Unsure", jsonResponse["counts_by_type"]["2"] ?? 0),
            salesgridmodel("Sad", jsonResponse["counts_by_type"]["1"] ?? 0),
          ];
          double happy_value =
              (jsonResponse["counts_by_type"]["3"] ?? 0).toDouble();
          double unsure_value =
              (jsonResponse["counts_by_type"]["2"] ?? 0).toDouble();
          double sad_value =
              (jsonResponse["counts_by_type"]["1"] ?? 0).toDouble();
          double sum_of_values = happy_value + unsure_value + sad_value;
          String happy_percentage =
              (happy_value / sum_of_values).toStringAsFixed(2);
          String unsure_percentage =
              (unsure_value / sum_of_values).toStringAsFixed(2);
          String sad_percentage =
              (sad_value / sum_of_values).toStringAsFixed(2);
          //print("sum_of_values $sum_of_values");
          //print("happy_percentage $happy_percentage");
          //print("unsure_percentage $unsure_percentage");
          //print("sad_percentage $sad_percentage");
          Constants.moral_index_pieData_1 = [];
          Constants.moral_index_pieData_1.add(PieChartSectionData(
              value: double.parse(happy_percentage),
              title:
                  "${(double.parse(happy_percentage) * 100).toStringAsFixed(0)}%",
              titleStyle: TextStyle(color: Colors.white, fontSize: 11),
              color: Colors.green));
          Constants.moral_index_pieData_1.add(PieChartSectionData(
              value: double.parse(unsure_percentage),
              title:
                  "${(double.parse(unsure_percentage) * 100).toStringAsFixed(0)}%",
              titleStyle: TextStyle(color: Colors.white, fontSize: 11),
              color: Colors.blue));
          Constants.moral_index_pieData_1.add(PieChartSectionData(
              value: double.parse(sad_percentage),
              title:
                  "${(double.parse(sad_percentage) * 100).toStringAsFixed(0)}%",
              titleStyle: TextStyle(color: Colors.white, fontSize: 11),
              color: Colors.red));
          barChartData1 == [];

          barChartData1 = processDataForMoraleCountDaily2(jsonResponse);
        } else if (selectedButton1 == 2) {
          Constants.moral_index_sectionsList2a = [
            salesgridmodel("Happy", jsonResponse["counts_by_type"]["3"] ?? 0),
            salesgridmodel("Unsure", jsonResponse["counts_by_type"]["2"] ?? 0),
            salesgridmodel("Sad", jsonResponse["counts_by_type"]["1"] ?? 0),
          ];
          double happy_value =
              (jsonResponse["counts_by_type"]["3"] ?? 0).toDouble();
          double unsure_value =
              (jsonResponse["counts_by_type"]["2"] ?? 0).toDouble();
          double sad_value =
              (jsonResponse["counts_by_type"]["1"] ?? 0).toDouble();
          double sum_of_values = happy_value + unsure_value + sad_value;
          String happy_percentage =
              (happy_value / sum_of_values).toStringAsFixed(2);
          String unsure_percentage =
              (unsure_value / sum_of_values).toStringAsFixed(2);
          String sad_percentage =
              (sad_value / sum_of_values).toStringAsFixed(2);
          //print("sum_of_values $sum_of_values");
          //print("happy_percentage2 $happy_percentage");
          //print("unsure_percentage2 $unsure_percentage");
          //print("sad_percentage2 $sad_percentage");
          Constants.moral_index_pieData_2 = [];
          Constants.moral_index_pieData_2.add(PieChartSectionData(
              value: double.parse(happy_percentage),
              title:
                  "${(double.parse(happy_percentage) * 100).toStringAsFixed(0)}%",
              titleStyle: TextStyle(color: Colors.white, fontSize: 11),
              color: Colors.green));
          Constants.moral_index_pieData_2.add(PieChartSectionData(
              value: double.parse(unsure_percentage),
              title:
                  "${(double.parse(unsure_percentage) * 100).toStringAsFixed(0)}%",
              titleStyle: TextStyle(color: Colors.white, fontSize: 11),
              color: Colors.blue));
          Constants.moral_index_pieData_2.add(PieChartSectionData(
              value: double.parse(sad_percentage),
              title:
                  "${(double.parse(sad_percentage) * 100).toStringAsFixed(0)}%",
              titleStyle: TextStyle(color: Colors.white, fontSize: 11),
              color: Colors.red));
          barChartData2 = processDataForCollectionsCountMonthly(
            jsonResponse["grouped_data"],
            DateTime.parse(date_from),
            DateTime.parse(date_to),
          );
        } else if (selectedButton1 == 3 && days_difference1 <= 31) {
          isLoading = false;
          moraleValue.value++;
          Constants.moral_index_sectionsList3a = [
            salesgridmodel("Happy", jsonResponse["counts_by_type"]["3"] ?? 0),
            salesgridmodel("Unsure", jsonResponse["counts_by_type"]["2"] ?? 0),
            salesgridmodel("Sad", jsonResponse["counts_by_type"]["1"] ?? 0),
          ];

          double happy_value =
              (jsonResponse["counts_by_type"]["3"] ?? 0).toDouble();
          double unsure_value =
              (jsonResponse["counts_by_type"]["2"] ?? 0).toDouble();
          double sad_value =
              (jsonResponse["counts_by_type"]["1"] ?? 0).toDouble();
          double sum_of_values = happy_value + unsure_value + sad_value;
          String happy_percentage =
              (happy_value / sum_of_values).toStringAsFixed(2);
          String unsure_percentage =
              (unsure_value / sum_of_values).toStringAsFixed(2);
          String sad_percentage =
              (sad_value / sum_of_values).toStringAsFixed(2);
          /*  print("happy_value $happy_value");
          print("sum_of_values3 $sum_of_values");
          print("happy_percentage3 $happy_percentage");
          print("unsure_percentage3 $unsure_percentage");
          print("sad_percentage3 $sad_percentage");*/
          Constants.moral_index_pieData_3 = [];
          Constants.moral_index_pieData_3.add(PieChartSectionData(
              value: double.parse(happy_percentage),
              title:
                  "${(double.parse(happy_percentage) * 100).toStringAsFixed(0)}%",
              titleStyle: TextStyle(color: Colors.white, fontSize: 11),
              color: Colors.green));
          Constants.moral_index_pieData_3.add(PieChartSectionData(
              value: double.parse(unsure_percentage),
              title:
                  "${(double.parse(unsure_percentage) * 100).toStringAsFixed(0)}%",
              titleStyle: TextStyle(color: Colors.white, fontSize: 11),
              color: Colors.blue));
          Constants.moral_index_pieData_3.add(PieChartSectionData(
              value: double.parse(sad_percentage),
              title:
                  "${(double.parse(sad_percentage) * 100).toStringAsFixed(0)}%",
              titleStyle: TextStyle(color: Colors.white, fontSize: 11),
              color: Colors.red));
          Constants.moral_index_chartKey3a = UniqueKey();
          moraleValue.value++;
        } else {
          Constants.moral_index_sectionsList3b = [
            salesgridmodel("Happy", jsonResponse["counts_by_type"]["3"] ?? 0),
            salesgridmodel("Unsure", jsonResponse["counts_by_type"]["2"] ?? 0),
            salesgridmodel("Sad", jsonResponse["counts_by_type"]["1"] ?? 0),
          ];

          double happy_value =
              (jsonResponse["counts_by_type"]["3"] ?? 0).toDouble();
          double unsure_value =
              (jsonResponse["counts_by_type"]["2"] ?? 0).toDouble();
          double sad_value =
              (jsonResponse["counts_by_type"]["1"] ?? 0).toDouble();
          double sum_of_values = happy_value + unsure_value + sad_value;
          String happy_percentage =
              (happy_value / sum_of_values).toStringAsFixed(2);
          String unsure_percentage =
              (unsure_value / sum_of_values).toStringAsFixed(2);
          String sad_percentage =
              (sad_value / sum_of_values).toStringAsFixed(2);
          // print("sum_of_values4 $sum_of_values");
          // print("happy_percentage4 $happy_percentage");
          // print("unsure_percentage4 $unsure_percentage");
          // print("sad_percentage4 $sad_percentage");
          Constants.moral_index_pieData_4 = [];
          Constants.moral_index_pieData_4.add(PieChartSectionData(
              value: double.parse(happy_percentage),
              title:
                  "${(double.parse(happy_percentage) * 100).toStringAsFixed(0)}%",
              titleStyle: TextStyle(color: Colors.white, fontSize: 11),
              color: Colors.green));
          Constants.moral_index_pieData_4.add(PieChartSectionData(
              value: double.parse(unsure_percentage),
              title:
                  "${(double.parse(unsure_percentage) * 100).toStringAsFixed(0)}%",
              titleStyle: TextStyle(color: Colors.white, fontSize: 11),
              color: Colors.blue));
          Constants.moral_index_pieData_4.add(PieChartSectionData(
              value: double.parse(sad_percentage),
              title:
                  "${(double.parse(sad_percentage) * 100).toStringAsFixed(0)}%",
              titleStyle: TextStyle(color: Colors.white, fontSize: 11),
              color: Colors.red));
          Constants.moral_index_chartKey3b = UniqueKey();
          isLoading = false;
          moraleValue.value++;
        }
        if (kDebugMode) {
          //print("got here ghhgjjhh ${selectedButton1}");
        }

        if (selectedButton1 == 1) {
          //print("days_difference1 $days_difference1 ");
          processDataForMoraleIndexCountDailylineGraph(
              jsonResponse["totals_daily"] ?? {});
          /*     Constants.moral_index_barChartData1 =
              processDataForMaintenanceCountDaily(
                  jsonResponse["totals_daily"] ?? {});*/
          Constants.moral_index_groupedChartData1 =
              processDataForMoraleIndexGroups(
                  jsonResponse["categorized_by_transactor"] ?? {});
          Map moraleIndexByAgent =
              jsonResponse["categorized_by_transactor"] ?? {};
          moraleIndexByAgent.forEach((key, value) {
            if (key.isNotEmpty) {
              try {
                int keyInt = int.parse(key);
                if (keyInt != 0) {
                  Constants.moral_index_salesbyagent2a
                      .add(SalesByAgent(getEmployeeById(keyInt), value));
                }
              } on FormatException {
                // print("Invalid integer format for key: $key");
                /*    Constants.moral_index_salesbyagent2a
                    .add(SalesByAgent(getEmployeeByEmail(key), value));*/
              }
            }
          });

          //print("fghhg ${jsonResponse["totals_daily"].runtimeType}");
        } else if (selectedButton1 == 2) {
          Constants.moral_index_barChartData2 =
              processDataForMoraleIndexCountMonthly(
                  jsonResponse["grouped_data"], context);
          Constants.moral_index_droupedChartData2 =
              processDataForMoraleIndexGroups(
                  jsonResponse["categorized_by_transactor"]);
          Map moraleIndexByAgent = jsonResponse["categorized_by_transactor"];
          moraleIndexByAgent.forEach((key, value) {
            if (key.isNotEmpty) {
              try {
                int keyInt = int.parse(key);
                if (keyInt != 0) {
                  Constants.moral_index_salesbyagent2a
                      .add(SalesByAgent(getEmployeeById(keyInt), value));
                }
              } on FormatException {
                // print("Invalid integer formatjhj for key: $key $value");
                Map m1 = value as Map;
                m1.forEach((key, value1) {
                  Constants.moral_index_salesbyagent2a.add(
                      SalesByAgent(getEmployeeByEmail(key), value1.round()));
                });
              }
            }
          });

          processDataForMoraleCountMonthlylineGraph(
              jsonResponse["totals_monthly"] ?? {});
        } else if (selectedButton1 == 3 && days_difference1 <= 31) {
          barChartData3 == [];

          barChartData3 = processDataForMoraleCountDaily2a(
            jsonResponse["grouped_data"],
            DateTime.parse(date_from),
            DateTime.parse(date_to),
          );

          // print("barChartData3 $barChartData3");
          Constants.moral_index_chartKey3a = UniqueKey();
          moraleValue.value++;

          Constants.moral_index_droupedChartData3 =
              processDataForMoraleIndexGroups(
                  jsonResponse["categorized_by_transactor"] ?? {});
          Map moraleIndexByAgent =
              jsonResponse["categorized_by_transactor"] ?? {};
          moraleIndexByAgent.forEach((key, value) {
            if (key.isNotEmpty) {
              try {
                int keyInt = int.parse(key);
                if (keyInt != 0) {
                  Constants.moral_index_salesbyagent2a
                      .add(SalesByAgent(getEmployeeById(keyInt), value));
                }
              } on FormatException {
                // print("Invalid integer formatjhj for key: $key $value");
                Map m1 = value as Map;
                m1.forEach((key, value1) {
                  Constants.moral_index_salesbyagent2a.add(
                      SalesByAgent(getEmployeeByEmail(key), value1.round()));
                });
              }
            }
          });
          processDataForMaintenanceCountDailylineGraph2(
              jsonResponse["totals_daily"] ?? {});
        } else if (selectedButton1 == 3 && days_difference1 > 31) {
          Constants.moral_index_barChartData4 =
              processDataForMoraleIndexCountMonthly(
                  jsonResponse["grouped_data"], context);
          barChartData4 = processDataForCollectionsCountMonthly(
            jsonResponse["grouped_data"],
            DateTime.parse(date_from),
            DateTime.parse(date_to),
          );
          Constants.moral_index_droupedChartData4 =
              processDataForMoraleIndexGroups(
                  jsonResponse["categorized_by_transactor"]);
          Map maintenanceByAgent = jsonResponse["categorized_by_transactor"];
          maintenanceByAgent.forEach((key, value) {
            if (int.parse(key.toString()) != 0) {
              Constants.moral_index_salesbyagent3b.add(SalesByAgent(
                  getEmployeeById(int.parse(key.toString())), value));
            }
          });
          processDataForMaintenanceCountMonthlylineGraph2(
              jsonResponse["totals_monthly"]);
        }
        isLoading = false;
        moraleValue.value++;
      }
    });
  } on Exception catch (_, exception) {
    //Exception exc = exception as Exception;
    print(exception);
  }
}

List<String> remove_main_memeber_list = [
  "Add Beneficiary",
  "Add Beneficiary",
  "Add Member",
  "Beneficiary Details",
  "Remove Beneficiary",
  "Removed Member",
];
List<String> remove_dependant_list = [
  "Add Beneficiary",
  "Add Beneficiary",
  "Address Details",
  "Banking Details",
  "Beneficiary Details",
  "Cancellation",
  "Collection Date Change",
  "Combine Premium Change",
  "Continuation",
  "Downgrade",
  "Inception Date",
  "Inception_Date",
  "Payment Method Change",
  "Policy Status Change",
  "Premium Reallocation",
  "Product Change",
  "Product Details",
  "Reinstatement",
  "Remove Beneficiary",
  "Restart",
  "Special Collection Date",
  "Upgrade",
  "Edited Beneficiary",
];
List<String> remove_beficiary_list = [
  "Add Member",
  "Address Details",
  "Banking Details",
  "Collection Date Change",
  "Combine Premium Change",
  "Continuation",
  "Downgrade",
  "Inception Date",
  "Inception_Date",
  "Member Cover Amount",
  "Member Details",
  "Member Rate Update",
  "Payment Method Change",
  "Policy Status Change",
  "Premium Adjustment/Change",
  "Premium Reallocation",
  "Product Change",
  "Product Details",
  "Reinstatement",
  "Removed Member",
  "Restart",
  "Special Collection Date",
  "Upgrade",
  "Cancellation",
  "Edited Beneficiary",
];
List<MoraleIndexCategory> processDataForMaintenanceGroups2(
    Map<String, dynamic> data) {
  List<MoraleIndexCategory> categories = [];

  // print("fghfh $data");
  data.forEach((categoryName, categoryItems) {
    //print("hgjjhjh $categoryItems");
    List<MoraleIndexCategoryItem> items = [];
    categoryItems.forEach((itemTitle, itemCount) {
      if (itemTitle != "Premium Payment" && itemTitle != "Claim") {
        if (categoryName == "Self") {
          if (!remove_main_memeber_list.contains(itemTitle)) {
            items.add(
                MoraleIndexCategoryItem(title: itemTitle, count: itemCount));
          }
        } else if (categoryName == "Dependant") {
          if (!remove_dependant_list.contains(itemTitle)) {
            items.add(
                MoraleIndexCategoryItem(title: itemTitle, count: itemCount));
          }
        } else if (categoryName == "Beneficiary") {
          if (!remove_beficiary_list.contains(itemTitle)) {
            items.add(
                MoraleIndexCategoryItem(title: itemTitle, count: itemCount));
          }
        }
      }
    });

    categories.add(MoraleIndexCategory(name: categoryName, items: items));
  });
  return categories;
}

List<MoraleIndexCategory> processDataForMoraleIndexGroups(data) {
  //print("ffhhjgh $data");
  List<MoraleIndexCategory> categories = [];

  data.forEach((transactor, categoryData) {
    List<MoraleIndexCategoryItem> items = [];

    (categoryData as Map).forEach((categoryID, count) {
      if (getMoodById(int.parse(categoryID.toString())).isNotEmpty) {
        items.add(MoraleIndexCategoryItem(
            title: getMoodById(int.parse(categoryID.toString())),
            count: count.round()));
      }
    });

    //items.sort((a, b) => b.count.compareTo(a.count));

    if (getEmployeeByEmail(transactor).isNotEmpty) {
      categories.add(MoraleIndexCategory(
          name: getEmployeeByEmail(transactor), items: items));
    }
  });

/*  categories.sort((a, b) => b.items
      .fold(0, (prev, item) => prev + item.count)
      .compareTo(a.items.fold(0, (prev, item) => prev + item.count)));*/

  return categories;
}

List<BarChartGroupData> processDataForMaintenanceCountDaily(Map jsonString) {
  Map jsonData = jsonString as Map;

  DateTime now = DateTime.now();
  int currentMonth = now.month;
  int currentYear = now.year;
  int daysInCurrentMonth = DateTime(currentYear, currentMonth + 1, 0).day;
  Map<int, Map<String, double>> dailySales = {
    for (var day = 1; day <= daysInCurrentMonth; day++) day: {}
  };

  // Process the jsonData
  jsonData.forEach((key, value) {
    List<String> parts = key.split("-");
    // print("gghgf $value");

    String dateString = "${parts[0]}-${parts[1].replaceAll('/', '-')}";

    if (kDebugMode) {
      //print("Formatted Date Stringhjhhj: $dateString");
    }

    DateTime date;
    try {
      date = DateTime.parse(dateString);
    } catch (e) {
      // print("Error parsing date: $e");
      return;
    }

    String collectionType = parts[1].split('/')[1];

    int dayOfMonth = date.day;
    double premium = value.toDouble();

    dailySales[dayOfMonth]!.update(
        collectionType, (existingValue) => existingValue + premium,
        ifAbsent: () => premium);
  });

  List<BarChartGroupData> collectionsGroupedData = [];
  dailySales.forEach((dayOfMonth, salesData) {
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    //Add purple and green

    salesData.forEach((type, amount) {
      Color? color; // Define color based on the type

      switch (type) {
        case 'Sad':
          color = Colors.red;
          break;
        case 'Unsure':
          color = Colors.blue;
          break;
        case 'Happy':
          color = Colors.green;
          break;

        default:
          // print("rgfgghuy $type");
          color = Colors.grey; // Default color for unknown types
      }

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, color!));
      cumulativeAmount += amount;
    });

    // Add a bar for each day of the month
    collectionsGroupedData.add(BarChartGroupData(
      x: dayOfMonth,
      barRods: [
        BarChartRodData(
          toY: cumulativeAmount,
          rodStackItems: rodStackItems.isEmpty
              ? [BarChartRodStackItem(0, 0, Colors.transparent)]
              : rodStackItems,
          borderRadius: BorderRadius.zero,
          width: 8,
        ),
      ],
      barsSpace: 4,
    ));
  });

  return collectionsGroupedData;
}

List<BarChartGroupData> processDataForMoraleCountDaily3(
    Map<String, dynamic> jsonString, DateTime startDate) {
  List<BarChartGroupData> collectionsGroupedData = [];

  // Assuming totalsDaily contains date strings as keys and sales as values
  Map<String, dynamic> totalsDaily = jsonString["totals_daily"] ?? {};

  // Generate a list of 30 daily dates from the start date
  List<DateTime> dateList =
      List.generate(30, (index) => startDate.add(Duration(days: index)));

  // Initialize a map to hold total sales for each day, defaulting to 0.0
  Map<DateTime, double> dailyTotals = {for (var date in dateList) date: 0.0};

  // Populate dailyTotals with actual sales data where available
  totalsDaily.forEach((key, value) {
    DateTime date;
    try {
      date = DateTime.parse(key);
      if (dailyTotals.containsKey(date)) {
        dailyTotals[date] = (value as num).toDouble();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error parsing date: $e");
      }
    }
  });

  // Sort the dates in dailyTotals just in case (should already be in order)
  var sortedDates = dailyTotals.keys.toList()..sort((a, b) => a.compareTo(b));

  // Convert sorted daily totals to BarChartGroupData
  int xValue = 0; // Use this to incrementally assign X values
  for (var date in sortedDates) {
    double total = dailyTotals[date]!;
    collectionsGroupedData.add(BarChartGroupData(
      x: xValue++, // Increment xValue for each entry to maintain order
      barRods: [
        BarChartRodData(
          toY: total,
          rodStackItems: [BarChartRodStackItem(0, total, Colors.blue)],
          borderRadius: BorderRadius.zero,
          width: 8,
        ),
      ],
      barsSpace: 4,
    ));
  }

  return collectionsGroupedData;
}

getColor(type) {
  // print("dhdhd " + type);
  Color? color; // Define color based on the type
  switch (type) {
    case 'Sad':
      color = Colors.red;
      break;
    case 'Unsure':
      color = Colors.blue;
      break;
    case 'Happy':
      color = Colors.green;
      break;

    default:
      // print("rgfgghuy $type");
      color = Colors.grey; // Default color for unknown types
  }
}

void processDataForMoraleIndexCountDailylineGraph(Map dailySalesCount) {
  Constants.moral_index_spots1a = [];
  Constants.moral_index_spots1b = [];
  Constants.moral_index_spots1c = [];
  Constants.moral_index_chartKey1a = UniqueKey();
  Constants.moral_index_chartKey1b = UniqueKey();
  Constants.moral_index_chartKey1c = UniqueKey();
  // print("fghhg0 $dailySalesCount");
  dailySalesCount.forEach((dateString, count) {
    // print("fghhgfghjgjdateString $dateString");
    DateTime parsedDate = DateTime.parse(dateString);

    int day = parsedDate.day;
    if (parsedDate.month == DateTime.now().month &&
        parsedDate.year == DateTime.now().year) {
      Constants.moral_index_spots1a
          .add(FlSpot(day.toDouble(), count.toDouble()));
      Constants.moral_index_spots1b
          .add(FlSpot(day.toDouble(), count.toDouble()));
      Constants.moral_index_spots1c
          .add(FlSpot(day.toDouble(), count.toDouble()));
    }
    if (count > Constants.moral_index_maxY) {
      Constants.moral_index_maxY = count;
    }
  });
  /* dailySalesCount.forEach((day, count) {
    if (kDebugMode) {
      print(day);
    }

  });*/
/*  dailySalesCount.forEach((day, count) {
    if (kDebugMode) {
      print(day);
    }

  });*/
  Constants.moral_index_spots1a.sort((a, b) => a.x.compareTo(b.x));
  Constants.moral_index_spots1b.sort((a, b) => a.x.compareTo(b.x));
  Constants.moral_index_spots1c.sort((a, b) => a.x.compareTo(b.x));
}

void processDataForMaintenanceCountDailylineGraph2(
    Map<String, dynamic> dailySalesCount) {
  Constants.moral_index_spots3a = [];
  Constants.moral_index_spots3b = [];
  Constants.moral_index_spots3c = [];
  Constants.moral_index_chartKey3a = UniqueKey();
  Constants.moral_index_chartKey3b = UniqueKey();
  Constants.moral_index_chartKey3c = UniqueKey();

  // print("fghhg ${dailySalesCount.length}");

  dailySalesCount.forEach((dateString, count) {
    DateTime parsedDate = DateTime.parse(dateString);
    int day = parsedDate.day;
    double yValue = (count is int) ? count.toDouble() : 0.0;
    //print("fgfhhg $dateString ${day.toDouble()} $yValue");

    Constants.moral_index_spots3a.add(FlSpot(day.toDouble(), yValue));
    if (yValue > Constants.moral_index_maxY3) {
      Constants.moral_index_maxY3 = yValue.round();
    }
  });
  Constants.moral_index_spots3a.sort((a, b) => a.x.compareTo(b.x));

  dailySalesCount.forEach((dateString, count) {
    DateTime parsedDate = DateTime.parse(dateString);
    int day = parsedDate.day;
    double yValue = (count is int) ? count.toDouble() : 0.0;

    Constants.moral_index_spots3b.add(FlSpot(day.toDouble(), yValue));
  });

  dailySalesCount.forEach((dateString, count) {
    DateTime parsedDate = DateTime.parse(dateString);
    int day = parsedDate.day;
    double yValue = (count is int) ? count.toDouble() : 0.0;

    Constants.moral_index_spots3c.add(FlSpot(day.toDouble(), yValue));
  });
}

void processDataForMoraleCountMonthlylineGraph(Map dailySalesCount) {
  Constants.moral_index_spots2a = [];
  Constants.moral_index_spots2b = [];
  Constants.moral_index_spots2c = [];
  Constants.moral_index_chartKey2a = UniqueKey();
  Constants.moral_index_chartKey2b = UniqueKey();
  Constants.moral_index_chartKey2c = UniqueKey();
  //print("yuu $dailySalesCount");
  dailySalesCount.forEach((dateString, count) {
    DateTime parsedDate = DateTime.parse(dateString + "-01");

    int day = parsedDate.month;
    Constants.moral_index_spots2a.add(FlSpot(day.toDouble(), count.toDouble()));
    Constants.moral_index_spots2b.add(FlSpot(day.toDouble(), count.toDouble()));
    Constants.moral_index_spots2c.add(FlSpot(day.toDouble(), count.toDouble()));
    if (count > Constants.moral_index_maxY2) {
      Constants.moral_index_maxY2 = count;
    }
  });
/*  dailySalesCount.forEach((day, count) {
    if (kDebugMode) {
      print(day);
    }

  });
  dailySalesCount.forEach((day, count) {
    if (kDebugMode) {
      print(day);
    }

  });*/
}

void processDataForMaintenanceCountMonthlylineGraph2(
    Map<String, dynamic> dailySalesCount) {
  Constants.moral_index_spots4a = [];
  Constants.moral_index_spots4b = [];
  Constants.moral_index_spots4c = [];
  Constants.moral_index_chartKey3a = UniqueKey();
  Constants.moral_index_chartKey3b = UniqueKey();
  Constants.moral_index_chartKey3c = UniqueKey();
  //print("Data: $dailySalesCount");

  dailySalesCount.forEach((dateString, count) {
    DateTime parsedDate = DateTime.parse(dateString + "-01");

    int month = parsedDate.month;
    double yValue = (count is int) ? count.toDouble() : 0.0;

    Constants.moral_index_spots4a.add(FlSpot(month.toDouble(), yValue));
    if (yValue > Constants.moral_index_maxY4) {
      Constants.moral_index_maxY4 = yValue.round();
    }
  });

  dailySalesCount.forEach((dateString, count) {
    DateTime parsedDate = DateTime.parse(dateString + "-01");
    int month = parsedDate.month;
    double yValue = (count is int) ? count.toDouble() : 0.0;

    Constants.moral_index_spots4b.add(FlSpot(month.toDouble(), yValue));
  });

  dailySalesCount.forEach((dateString, count) {
    DateTime parsedDate = DateTime.parse(dateString + "-01");
    int month = parsedDate.month;
    double yValue = (count is int) ? count.toDouble() : 0.0;

    Constants.moral_index_spots4c.add(FlSpot(month.toDouble(), yValue));
  });
}

List<BarChartGroupData> processDataForMoraleIndexCountMonthly(
    Map<String, dynamic> jsonString, BuildContext context) {
  Map jsonData = jsonString;
  //print("vnmjhh $jsonString");

  // Initialize data structure for monthly sales for the current year
  Map<int, Map<String, double>> monthlySales = {
    for (var month = 1; month <= 12; month++) month: {}
  };

  // Process the jsonData
  jsonData.forEach((key, value) {
    if (kDebugMode) {
      //print(key);
    }

    List<String> parts = key.split("-");

    String dateString = "${parts[0]}-${parts[1].replaceAll('/', '-')}";

    if (kDebugMode) {
      //print("Formatted Date Stringhjhhj: $dateString");
    }

    DateTime date;
    try {
      date = DateTime.parse(dateString);
    } catch (e) {
      // print("Error parsing date: $e");
      return;
    }

    String collectionType = parts[1].split('/')[1];

    int month = date.month;
    double premium = value.toDouble();

    monthlySales[month]!.update(
        collectionType, (existingValue) => existingValue + premium,
        ifAbsent: () => premium);
  });
  List<BarChartGroupData> collectionsGroupedData = [];
  monthlySales.forEach((month, salesData) {
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    // Add colors and rodStackItems as in your original code

    salesData.forEach((type, amount) {
      Color? color; // Define color based on the type
      switch (type) {
        case 'Sad':
          color = Colors.red;
          break;
        case 'Unsure':
          color = Colors.blue;
          break;
        case 'Happy':
          color = Colors.green;
          break;

        default:
          // print("rgfgghuy $type");
          color = Colors.grey; // Default color for unknown types
      }

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, color!));
      cumulativeAmount += amount;
    });

    // Add a bar for each month
    collectionsGroupedData.add(BarChartGroupData(
      x: month,
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
      barsSpace: 5,
    ));
  });

  return collectionsGroupedData;
}

String getEmployeeById(
  int cec_employeeid,
) {
  String result = "";
  for (var employee in Constants.cec_employees) {
    if (employee['cec_employeeid'].toString() == cec_employeeid.toString()) {
      result =
          "${employee["employee_name"]} ${employee["employee_surname"].toString()}";
      if (kDebugMode) {
        //print("fgfghg $result");
      }
      return result;
    }
  }
  if (result.isEmpty) {
    return "";
  } else
    return result;
}

String getEmployeeByEmail(
  String employee_email,
) {
  String result = "";
  //print("hfhggj ${Constants.cec_employees}");
  for (var employee in Constants.cec_employees) {
    if (employee['employee_email'].toString() == employee_email.toString()) {
      result = employee["employee_name"] + " " + employee["employee_surname"];
      if (kDebugMode) {
        //print("fgfghg $result");
      }
      return result;
    }
  }
  if (result.isEmpty) {
    return "";
  } else
    return result;
}

String getBranchById(
  int branch_id,
) {
  String result = "";
  for (var branch in Constants.all_branches) {
    if (branch['cec_organo_branches_id'].toString() == branch_id.toString()) {
      result = branch["branch_name"];
      //print("fgfghg $result");
      return result;
    }
  }
  if (result.isEmpty) {
    return "";
  } else
    return result;
}

String getMoodById(int mood_id) {
  //print("dfdfgmoods_list $moods_list");
  for (var mood in moods_list) {
    if (mood['id'] == mood_id) {
      return mood["mood"];
    }
  }
  return ""; // Return an empty string if no match is found
}

List<BarChartGroupData> processDataForMoraleCountDaily(
    Map<String, dynamic> groupedData, DateTime startDate, DateTime endDate) {
  List<BarChartGroupData> collectionsGroupedData = [];

  int currentMonth = startDate.month;
  int currentYear = startDate.year;

  // Initialize data structure for daily sales with 31 days regardless of the current month
  Map<int, Map<String, double>> dailySales = {
    for (var day = 1; day <= 31; day++) day: {}
  };

  groupedData.forEach((collectionItem, value1) {
    DateTime date = DateTime.parse(collectionItem.split("/")[0]);

    if (date.month == currentMonth && date.year == currentYear) {
      int dayOfMonth = date.day;
      // Convert mood_id to a string
      String collectionType = collectionItem.split("/")[1];

      dailySales[dayOfMonth]!.update(collectionType, (value) => value + value1,
          ifAbsent: () => value1);
    }
  });

  // Calculate the bar width based on a fixed number of 31 bars
  double barWidth = (Constants.screenWidth / 31) - 4; // Adjust for spacing

  dailySales.forEach((dayOfMonth, moraledataData) {
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = moraledataData
        .map((type, amount) {
          Color color; // Define color based on the type
          switch (type) {
            case '1':
              color = Colors.red;
              break;
            case '2':
              color = Colors.blue;
              break;
            case '3':
              color = Colors.green;
              break;
            default:
              color = Colors.grey; // Default color for unknown types
          }
          return MapEntry(
              type,
              BarChartRodStackItem(
                  cumulativeAmount, cumulativeAmount + amount, color));
        })
        .values
        .toList();

    if (rodStackItems.isNotEmpty) {
      cumulativeAmount = rodStackItems.last.toY;
    }

    collectionsGroupedData.add(BarChartGroupData(
      x: dayOfMonth,
      barRods: [
        BarChartRodData(
          toY: cumulativeAmount,
          rodStackItems: rodStackItems.isEmpty
              ? [BarChartRodStackItem(0, 0, Colors.transparent)]
              : rodStackItems,
          borderRadius: BorderRadius.zero,
          width: barWidth,
        ),
      ],
      barsSpace: 4,
    ));
  });

  // Ensure collectionsGroupedData has entries for all 31 positions
  // This step fills in any missing days with transparent bars
  for (int i = 1; i <= 31; i++) {
    if (!collectionsGroupedData.any((data) => data.x == i)) {
      collectionsGroupedData.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
              toY: 0,
              rodStackItems: [BarChartRodStackItem(0, 0, Colors.transparent)],
              borderRadius: BorderRadius.zero,
              width: barWidth)
        ],
        barsSpace: 4,
      ));
    }
  }

  // Sort collectionsGroupedData by dayOfMonth to ensure correct order
  collectionsGroupedData.sort((a, b) => a.x.compareTo(b.x));

  return collectionsGroupedData;
}

List<BarChartGroupData> processDataForCollectionsCountMonthly(
    Map<String, dynamic> groupedData, DateTime startDate, DateTime endDate) {
  DateTime endRangeDate = DateTime(startDate.year, startDate.month + 12, 0);

  // Initialize monthly data with placeholders
  Map<int, List<BarChartRodStackItem>> monthlyData = {};
  for (int i = 0; i < 12; i++) {
    monthlyData[i] = [];
  }

  // Process grouped data
  groupedData.forEach((key, value) {
    List<String> parts = key.split("/");
    String yearMonth = parts[0];
    int moodId = int.parse(parts[1]);
    DateTime date = DateTime.parse("$yearMonth-01");

    int monthIndex =
        ((date.year - startDate.year) * 12) + date.month - startDate.month;

    Color color = Colors.grey; // Default color
    switch (moodId) {
      case 1:
        color = Colors.red;
        break;
      case 2:
        color = Colors.blue;
        break;
      case 3:
        color = Colors.green;
        break;
      // Define more colors for other moodIds as needed
    }

    monthlyData[monthIndex]?.add(BarChartRodStackItem(0, value, color));
  });

  // Generate BarChartGroupData for each month using cumulativeAmount for rod stacking
  List<BarChartGroupData> collectionsGroupedData = [];
  monthlyData.forEach((monthIndex, rodItems) {
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = rodItems.map((item) {
      if (cumulativeAmount > 0.0) {
        final rodStackItem = BarChartRodStackItem(
            cumulativeAmount, cumulativeAmount + item.toY, item.color);
        cumulativeAmount += item.toY;
        return rodStackItem;
      } else {
        return BarChartRodStackItem(0, 0 + item.toY, Colors.white);
      }
    }).toList();
    for (var item in rodItems) {
      if (item.toY > 0) {
        // Check if the value is greater than 0
        rodStackItems.add(BarChartRodStackItem(
            cumulativeAmount, cumulativeAmount + item.toY, item.color));
        cumulativeAmount += item.toY;
      }
    }

    // Ensure there's at least one item to avoid drawing issues
    if (rodStackItems.isEmpty) {
      rodStackItems
          .add(BarChartRodStackItem(0, 0, Colors.white)); // Transparent item
    }
    //logLongString(rodStackItems.toString());

    collectionsGroupedData.add(BarChartGroupData(
      x: monthIndex, // Adjust X to start from 1
      barRods: [
        BarChartRodData(
          color: Colors.white,
          toY: 100, // Since values are percentages, this should sum up to 100%
          rodStackItems: rodStackItems,
          borderRadius: BorderRadius.zero,
          width: (Constants.screenWidth / 14 - 4),
        ),
      ],
      barsSpace: 4,
    ));
  });

  return collectionsGroupedData;
}

List<BarChartGroupData> processDataForMoraleCountDaily2(
    Map<String, dynamic> jsonData) {
  List<BarChartGroupData> collectionsGroupedData = [];

  DateTime now = DateTime.now();
  int currentMonth = now.month;
  int currentYear = now.year;
  int daysInCurrentMonth = DateTime(currentYear, currentMonth + 1, 0).day;

  // Initialize data structure for daily sales for the current month
  Map<int, Map<String, double>> dailySales = {
    for (var day = 1; day <= daysInCurrentMonth; day++) day: {}
  };

  jsonData['grouped_data']?.forEach((collectionItem, value1) {
    DateTime date = DateTime.parse(collectionItem.split("/")[0]);

    if (date.month == currentMonth && date.year == currentYear) {
      int dayOfMonth = date.day;

      // Convert mood_id to a string
      String collectionType = collectionItem.split("/")[1];

      dailySales[dayOfMonth]!.update(collectionType, (value) => value + value1,
          ifAbsent: () => value1);
    }
  });

  dailySales.forEach((dayOfMonth, moraledataData) {
    print("value1 $dayOfMonth $moraledataData");
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    moraledataData.forEach((type, amount) {
      Color? color; // Define color based on the type
      switch (type) {
        case '1':
          color = Colors.red;
          break;
        case '2':
          color = Colors.blue;
          break;
        case '3':
          color = Colors.green;
          break;
        default:
          color = Colors.grey; // Default color for unknown types
      }

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, color!));
      cumulativeAmount += amount;
    });

    collectionsGroupedData.add(BarChartGroupData(
      x: dayOfMonth,
      barRods: [
        BarChartRodData(
          toY: cumulativeAmount,
          rodStackItems: rodStackItems.isEmpty
              ? [BarChartRodStackItem(0, 0, Colors.transparent)]
              : rodStackItems,
          borderRadius: BorderRadius.zero,
          width: (Constants.screenWidth / daysInCurrentMonth - 4),
        ),
      ],
      barsSpace: 4,
    ));
  });

  return collectionsGroupedData;
}

List<BarChartGroupData> processDataForMoraleCountDaily2a(
    Map<String, dynamic> jsonDataDateTime, startDate, DateTime endDate) {
  List<BarChartGroupData> collectionsGroupedData = [];

  int currentMonth = startDate.month;
  int currentYear = startDate.year;

  int daysInCurrentMonth = DateTime(currentYear, currentMonth + 1, 0).day;

  // Initialize data structure for daily sales for the current month
  Map<int, Map<String, double>> dailySales = {};
  for (int i = 0; i < 31; i++) {
    DateTime date = startDate.add(Duration(days: i));
    dailySales[date.day] = {};
  }

  jsonDataDateTime?.forEach((collectionItem, value1) {
    DateTime date = DateTime.parse(collectionItem.split("/")[0]);

    int dayOfMonth = date.day;

    // Convert mood_id to a string
    String collectionType = collectionItem.split("/")[1];

    dailySales[dayOfMonth]!.update(collectionType, (value) => value + value1,
        ifAbsent: () => value1);
  });

  dailySales.forEach((dayOfMonth, moraledataData) {
    print("value1 $dayOfMonth $moraledataData");
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    moraledataData.forEach((type, amount) {
      Color? color; // Define color based on the type
      switch (type) {
        case '1':
          color = Colors.red;
          break;
        case '2':
          color = Colors.blue;
          break;
        case '3':
          color = Colors.green;
          break;
        default:
          color = Colors.grey; // Default color for unknown types
      }

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, color!));
      cumulativeAmount += amount;
    });

    collectionsGroupedData.add(BarChartGroupData(
      x: dayOfMonth,
      barRods: [
        BarChartRodData(
          toY: cumulativeAmount,
          rodStackItems: rodStackItems.isEmpty
              ? [BarChartRodStackItem(0, 0, Colors.transparent)]
              : rodStackItems,
          borderRadius: BorderRadius.zero,
          width: (Constants.screenWidth / daysInCurrentMonth - 4),
        ),
      ],
      barsSpace: 4,
    ));
  });

  return collectionsGroupedData;
}

List<BarChartGroupData> Za(jsonString) {
  List<dynamic> jsonData = jsonString["user_moods"];

  DateTime now = DateTime.now();
  int currentMonth = now.month;
  int currentYear = now.year;
  int daysInCurrentMonth = DateTime(currentYear, currentMonth + 1, 0).day;

  Map<int, Map<String, double>> dailySales = {
    for (var day = 1; day <= daysInCurrentMonth; day++) day: {}
  };

  for (var collectionItem in jsonData) {
    for (var item in collectionItem) {
      DateTime date = DateTime.parse(item['datecreated']);

      if (date.month == currentMonth && date.year == currentYear) {
        int dayOfMonth = date.day;

        // Convert mood_id to a string
        String collectionType = item["mood_id"].toString();

        dailySales[dayOfMonth]!
            .update(collectionType, (value) => value + 1, ifAbsent: () => 1);
      }
    }
  }

  List<BarChartGroupData> collectionsGroupedData = [];
  dailySales.forEach((dayOfMonth, moraledataData) {
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    //Add purple and green

    moraledataData.forEach((type, amount) {
      Color? color; // Define color based on the type
      switch (type) {
        case '1':
          color = Colors.red;
          break;
        case '2':
          color = Colors.blue;
          break;
        case '3':
          color = Colors.green;
          break;

        // Add more cases for different collection types
        default:
          // print("rgfgghggh $type");
          color = Colors.grey; // Default color for unknown types
      }

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, color!));
      cumulativeAmount += amount;
    });

    collectionsGroupedData.add(BarChartGroupData(
      x: dayOfMonth,
      barRods: [
        BarChartRodData(
          toY: cumulativeAmount,
          rodStackItems: rodStackItems.isEmpty
              ? [BarChartRodStackItem(0, 0, Colors.transparent)]
              : rodStackItems,
          borderRadius: BorderRadius.zero,
          width: 8,
        ),
      ],
      barsSpace: 4,
    ));
  });

  return collectionsGroupedData;
}

// List<BarChartGroupData> processDataForCollectionsCountMonthly(
//     String jsonString, String startDate, String endDate, BuildContext context) {
//   List<dynamic> jsonData = jsonDecode(jsonString)["user_moods"];
//   //print("gffghffg ${jsonData}");
//
//   DateTime start = DateTime.parse(startDate);
//   DateTime end = DateTime.parse(endDate);
//   int monthsInRange =
//       ((end.year - start.year) * 12) + end.month - start.month + 1;
//
//   Map<int, Map<String, double>> monthlySales = {
//     for (var i = 0; i < monthsInRange; i++) i: {}
//   };
//
//   for (var collectionItem1 in jsonData) {
//     for (var collectionItem in collectionItem1) {
//       DateTime dateCreated = DateTime.parse(collectionItem['datecreated']);
//       if (dateCreated.isAfter(start.subtract(const Duration(days: 1))) &&
//           dateCreated.isBefore(end.add(const Duration(days: 1)))) {
//         int monthIndex = ((dateCreated.year - start.year) * 12) +
//             dateCreated.month -
//             start.month;
//
//         // Check and safely handle mood_id type
//         int moodId;
//         if (collectionItem["mood_id"] is int) {
//           moodId = collectionItem["mood_id"];
//         } else if (collectionItem["mood_id"] is String) {
//           moodId = int.tryParse(collectionItem["mood_id"]) ??
//               0; // Fallback to a default value if parsing fails
//         } else {
//           continue; // Skip this item if mood_id is neither int nor String
//         }
//
//         String moodType = getMoodById(moodId);
//         double count = 1.0;
//
//         monthlySales[monthIndex]!
//             .update(moodType, (value) => value + count, ifAbsent: () => count);
//       }
//     }
//   }
//
//   double maxBarWidth = 38;
//   double minBarSpace = 4;
//   double barWidth =
//       min(maxBarWidth, (Constants.screenWidth / (1.4 * monthsInRange)));
//   double barsSpace = max(
//       minBarSpace,
//       (Constants.screenWidth - (barWidth * monthsInRange)) /
//           (monthsInRange - 1));
//
//   // Process data into BarChartGroupData
//   List<BarChartGroupData> collectionsGroupedData = [];
//   monthlySales.forEach((monthIndex, moralIndexData) {
//     double cumulativeAmount = 0.0;
//     List<BarChartRodStackItem> rodStackItems = [];
//
//     moralIndexData.forEach((type, amount) {
//       //print("fgfgf $type $amount");
//       Color? color;
//       // Define color based on the type
//       switch (type) {
//         case 'Sad':
//           color = Colors.red;
//           break;
//         case 'Unsure':
//           color = Colors.blue;
//           break;
//         case 'Happy':
//           color = Colors.green;
//           break;
//
//         default:
//           // print("rgfgghuy $type");
//           color = Colors.grey; // Default color for unknown types
//       }
//
//       rodStackItems.add(BarChartRodStackItem(
//           cumulativeAmount, cumulativeAmount + amount, color!));
//       cumulativeAmount += amount;
//     });
//
//     collectionsGroupedData.add(BarChartGroupData(
//       x: monthIndex + 1,
//       barRods: [
//         BarChartRodData(
//           toY: cumulativeAmount,
//           rodStackItems: rodStackItems,
//           borderRadius: BorderRadius.zero,
//           width: barWidth,
//         ),
//       ],
//       barsSpace: 6,
//     ));
//   });
//
//   return collectionsGroupedData;
// }

Color getColorForMood(String mood) {
  Color? color; // Define color based on the type
  switch (mood) {
    case '1':
      color = Colors.red;
      break;
    case '2':
      color = Colors.blue;
      break;
    case '3':
      color = Colors.green;
      break;

    // Add more cases for different collection types
    default:
      //print("rgfggh $type");
      color = Colors.grey; // Default color for unknown types
  }
  return color;
}
