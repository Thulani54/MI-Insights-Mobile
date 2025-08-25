import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mi_insights/models/SalesByAgent.dart';

import '../constants/Constants.dart';
import '../models/MaintanaceCategory.dart';
import '../models/salesgridmodel.dart';
import '../screens/Reports/MaintenanceReport.dart';
import '../utils/login_utils.dart';

Future<void> getMaintenanceReport(String date_from, String date_to,
    int selectedButton1, BuildContext context) async {
  https: //uat.miinsightsapps.net/fieldV6/getLeadss?empId=3&searchKey=6&status=all&cec_client_id=1&type=field&startDate=2023-08-01&endDate=2023-08-31

  String baseUrl = '${Constants.analitixAppBaseUrl}sales/get_maintenance_data/';
  if (hasTemporaryTesterRole(Constants.myUserRoles)) {
    baseUrl =
        '${Constants.analitixAppBaseUrl}sales/view_normalized_maintenance_data_test/';
  }
  try {
    Map<String, String>? payload = {
      "client_id": Constants.cec_client_id.toString(),
      "start_date": date_from,
      "end_date": date_to
    };
    if (kDebugMode) {
      //print("baseUrl $baseUrl");
      //print("payload $payload");
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
      var jsonResponse1 = jsonDecode(response.body);

      if (selectedButton1 == 1)
        Constants.jsonMonthlyMaintanenceData1 = jsonResponse1;
      if (selectedButton1 == 2)
        Constants.jsonMonthlyMaintanenceData2 = jsonResponse1;
      if (selectedButton1 == 3)
        Constants.jsonMonthlyMaintanenceData3 = jsonResponse1;
      if (selectedButton1 == 4)
        Constants.jsonMonthlyMaintanenceData4 = jsonResponse1;
      if (kDebugMode) {
        //print("ghjgjggddf " + response.body);

        //print(response.bodyBytes);
        //print(response.statusCode);
        //print(response.body);
        //print(response.body);
      }
      if (response.statusCode != 200) {
        //print("ghjgjgg0 " + response.body.toString());
        if (selectedButton1 == 1) {
          Constants.maintenance_sectionsList1a = [
            salesgridmodel("All", 0),
            salesgridmodel("Amendments", 0),
            salesgridmodel("Up/DownG", 0),
          ];
        } else if (selectedButton1 == 2) {
          Constants.maintenance_sectionsList2a = [
            salesgridmodel("All", 0),
            salesgridmodel("Amendments", 0),
            salesgridmodel("Up/DownG", 0),
          ];
        } else if (selectedButton1 == 2) {
          Constants.maintenance_sectionsList2a = [
            salesgridmodel("All", 0),
            salesgridmodel("Amendments", 0),
            salesgridmodel("Up/DownG", 0),
          ];
        }
      } else {
        int id_y = 1;
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse["message"] == "list is empty") {
          //print("ghjgjgg1 " + response.body.toString());
          if (selectedButton1 == 1) {
            Constants.maintenance_sectionsList1a = [
              salesgridmodel("All", 0),
              salesgridmodel("Amendments", 0),
              salesgridmodel("Up/DownG", 0),
            ];
          } else if (selectedButton1 == 2) {
            Constants.maintenance_sectionsList2a = [
              salesgridmodel("All", 0),
              salesgridmodel("Amendments", 0),
              salesgridmodel("Up/DownG", 0),
            ];
          } else if (selectedButton1 == 2) {
            Constants.maintenance_sectionsList2a = [
              salesgridmodel("All", 0),
              salesgridmodel("Amendments", 0),
              salesgridmodel("Up/DownG", 0),
            ];
          }
          isLoading = false;
          maintenanceValue.value++;
        }

        Constants.maintenance_barData = [];
        Constants.maintenance_pieData = [];

        Constants.maintenance_bottomTitles2a = [];
        Map<int, int> dailySalesCount = {};
        Map<int, int> dailySalesCount1b = {};
        Map<int, int> dailySalesCount1c = {};
        Map<int, int> monthlySalesCount2a = {};
        Map<int, int> monthlySalesCount2b = {};
        Map<int, int> monthlySalesCount2c = {};
        int monthlyTotal = 0;

        if (selectedButton1 == 1) {
          Constants.maintenance_salesbyagent1a = [];
          Constants.maintenance_bottomTitles1a = [];
          Constants.maintenance_maxY5a = 0;
        } else if (selectedButton1 == 2) {
          Constants.maintenance_salesbyagent2a = [];
          Constants.maintenance_bottomTitles2a = [];
          Constants.maintenance_maxY5b = 0;
        } else if (selectedButton1 == 3 && days_difference < 31) {
          Constants.maintenance_salesbyagent3a = [];
          Constants.maintenance_bottomTitles3a = [];
          Constants.maintenance_maxY5c = 0;
        } else {
          Constants.maintenance_salesbyagent3b = [];
          Constants.maintenance_bottomTitles3b = [];
          Constants.maintenance_maxY5d = 0;
        }
        Constants.maintenance_salesbyagent1b = [];

        DateTime startDateTime = DateFormat('yyyy-MM-dd').parse(date_from);
        DateTime endDateTime = DateFormat('yyyy-MM-dd').parse(date_to);
        //print("date_from $date_from");
        //print("date_to $date_to");

        int days_difference1 = endDateTime.difference(startDateTime).inDays;

        if (selectedButton1 == 1) {
          int upgdg = 0;
          if (jsonResponse["categorized_overall_counts"] == null) {
            upgdg = 0;
            Constants.maintenance_sectionsList1a = [
              salesgridmodel("All", 0),
              salesgridmodel("Amendments", 0),
              salesgridmodel("Up/DownG", 0),
            ];
          } else {
            upgdg = jsonResponse["categorized_overall_counts"]["Upgrades"] +
                jsonResponse["categorized_overall_counts"]["Downgrades"];
            Constants.maintenance_sectionsList1a = [
              salesgridmodel("All",
                  jsonResponse["categorized_overall_counts"]["All"] ?? 0),
              salesgridmodel(
                  "Amendments",
                  jsonResponse["categorized_overall_counts"]["Amendments"] ??
                      0),
              salesgridmodel("Up/DownG", upgdg),
            ];
          }

          Constants.maintenance_most_frequent_upgrades1a =
              findMostFrequentUpgradeValue(jsonResponse["response_data"] ?? []);
          Constants.maintenance_most_frequent_downgrades1a =
              findMostFrequentDowngradeValue(
                  jsonResponse["response_data"] ?? []);
          Constants.maintenance_most_frequent_upgrades1a_count =
              findMostFrequentValueCount(
                  jsonResponse["response_data"] ?? [], "Upgrade");
          Constants.maintenance_most_frequent_downgrades1a_count =
              findMostFrequentValueCount(
                  jsonResponse["response_data"] ?? [], "Downgrade");
        } else if (selectedButton1 == 2) {
          int upgdg = 0;
          if (jsonResponse["categorized_overall_counts"] == null) {
            upgdg = 0;
            Constants.maintenance_sectionsList2a = [
              salesgridmodel("All", 0),
              salesgridmodel("Amendments", 0),
              salesgridmodel("Up/DownG", 0),
            ];
          } else {
            upgdg = jsonResponse["categorized_overall_counts"]["Upgrades"] +
                jsonResponse["categorized_overall_counts"]["Downgrades"];
            Constants.maintenance_sectionsList2a = [
              salesgridmodel("All",
                  jsonResponse["categorized_overall_counts"]["All"] ?? 0),
              salesgridmodel(
                  "Amendments",
                  jsonResponse["categorized_overall_counts"]["Amendments"] ??
                      0),
              salesgridmodel("Up/DownG", upgdg),
            ];
          }
          Constants.maintenance_most_frequent_upgrades2a =
              findMostFrequentUpgradeValue(jsonResponse["response_data"] ?? []);
          Constants.maintenance_most_frequent_downgrades2a =
              findMostFrequentDowngradeValue(
                  jsonResponse["response_data"] ?? []);

          Constants.maintenance_most_frequent_upgrades2a_count =
              findMostFrequentValueCount(
                  jsonResponse["response_data"] ?? [], "Upgrade");
          Constants.maintenance_most_frequent_downgrades2a_count =
              findMostFrequentValueCount(
                  jsonResponse["response_data"] ?? [], "Downgrade");
        } else if (selectedButton1 == 3 && days_difference1 <= 31) {
          int? upgdg = jsonResponse["categorized_overall_counts"]["Upgrades"] +
              jsonResponse["categorized_overall_counts"]["Downgrades"];
          Constants.maintenance_sectionsList3a = [
            salesgridmodel(
                "All", jsonResponse["categorized_overall_counts"]["All"] ?? 0),
            salesgridmodel("Amendments",
                jsonResponse["categorized_overall_counts"]["Amendments"] ?? 0),
            salesgridmodel(
              "Up/DownG",
              upgdg ?? 0,
            )
          ];
          Constants.maintenance_most_frequent_upgrades3a =
              findMostFrequentUpgradeValue(jsonResponse["response_data"]);
          Constants.maintenance_most_frequent_downgrades3a =
              findMostFrequentDowngradeValue(jsonResponse["response_data"]);
          Constants.maintenance_most_frequent_upgrades3a_count =
              findMostFrequentValueCount(
                  jsonResponse["response_data"] ?? [], "Upgrade");
          Constants.maintenance_most_frequent_downgrades3a_count =
              findMostFrequentValueCount(
                  jsonResponse["response_data"] ?? [], "Downgrade");
        } else {
          int upgdg = jsonResponse["categorized_overall_counts"]["Upgrades"] +
              jsonResponse["categorized_overall_counts"]["Downgrades"];
          Constants.maintenance_sectionsList3b = [
            salesgridmodel(
                "All", jsonResponse["categorized_overall_counts"]["All"] ?? 0),
            salesgridmodel("Amendments",
                jsonResponse["categorized_overall_counts"]["Amendments"] ?? 0),
            salesgridmodel("Up/DownG", upgdg),
          ];
          Constants.maintenance_most_frequent_upgrades3b =
              findMostFrequentUpgradeValue(jsonResponse["response_data"]);
          Constants.maintenance_most_frequent_downgrades3b =
              findMostFrequentDowngradeValue(jsonResponse["response_data"]);
          Constants.maintenance_most_frequent_upgrades3b_count =
              findMostFrequentValueCount(
                  jsonResponse["response_data"] ?? [], "Upgrade");
          Constants.maintenance_most_frequent_downgrades3b_count =
              findMostFrequentValueCount(
                  jsonResponse["response_data"] ?? [], "Downgrade");
        }
        if (kDebugMode) {
          //print("got here ghhgjjhh ${selectedButton1}");
        }

        //print("days_difference1 $days_difference1");
        if (selectedButton1 == 1) {
          Constants.maintenance_barChartData1 =
              processDataForMaintenanceCountDaily(
                  jsonResponse["grouped_data"] ?? {});
          Constants.maintenance_droupedChartData1 =
              processDataForMaintenanceGroups(
                  jsonResponse["reorganized_dict"] ?? []);
          Map maintenanceByAgent =
              jsonResponse["categorized_by_transactor"] ?? {};
          maintenanceByAgent.forEach((key, value) {
            if (int.parse(key.toString()) != 0) {
              Constants.maintenance_salesbyagent1a.add(SalesByAgent(
                  getEmployeeById(int.parse(key.toString())), value));
            }
          });

          processDataForMaintenanceCountDailylineGraph(
              jsonResponse["totals_daily"] ?? {});

          //print("fghhg ${jsonResponse["totals_daily"].runtimeType}");
        } else if (selectedButton1 == 2) {
          Constants.maintenance_barChartData2 =
              processDataForCollectionsCountMonthly(
                  jsonResponse["grouped_data"], context);
          Constants.maintenance_droupedChartData2 =
              processDataForMaintenanceGroups(jsonResponse["reorganized_dict"]);
          Map maintenanceByAgent = jsonResponse["categorized_by_transactor"];
          maintenanceByAgent.forEach((key, value) {
            if (int.parse(key.toString()) != 0) {
              Constants.maintenance_salesbyagent2a.add(SalesByAgent(
                  getEmployeeById(int.parse(key.toString())), value));
            }
          });
          processDataForMaintenanceCountMonthlylineGraph(
              jsonResponse["totals_monthly"]);
        } else if (selectedButton1 == 3 && days_difference1 <= 31) {
          //print("fghhgghj ");
          //print("gfsaaghs ${jsonResponse["grouped_data"]}");

          Constants.maintenance_barChartData3 =
              processDataForMaintenanceCountDaily(jsonResponse["grouped_data"]);

          Constants.maintenance_droupedChartData3 =
              processDataForMaintenanceGroups(jsonResponse["reorganized_dict"]);
          maintenanceValue.value++;

          Map maintenanceByAgent = jsonResponse["categorized_by_transactor"];
          maintenanceByAgent.forEach((key, value) {
            if (int.parse(key.toString()) != 0) {
              //print("fgff");
              Constants.maintenance_salesbyagent3a.add(SalesByAgent(
                  getEmployeeById(int.parse(key.toString())), value));
            }
          });
          processDataForMaintenanceCountDailylineGraph2(
              jsonResponse["totals_daily"]);
        } else if (selectedButton1 == 3 && days_difference1 > 31) {
          Constants.maintenance_barChartData4 =
              processDataForCollectionsCountMonthly(
                  jsonResponse["grouped_data"], context);
          Constants.maintenance_droupedChartData4 =
              processDataForMaintenanceGroups(jsonResponse["reorganized_dict"]);
          Map maintenanceByAgent = jsonResponse["categorized_by_transactor"];
          maintenanceByAgent.forEach((key, value) {
            if (int.parse(key.toString()) != 0) {
              Constants.maintenance_salesbyagent3b.add(SalesByAgent(
                  getEmployeeById(int.parse(key.toString())), value));
            }
          });
          processDataForMaintenanceCountMonthlylineGraph2(
              jsonResponse["totals_monthly"]);
        }
        isLoading = false;
        maintenanceValue.value++;
        /*     print(
            "gfhghghg5 " + Constants.maintenance_droupedChartData3.toString());*/
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
List<MaintanaceCategory> processDataForMaintenanceGroups2(
    Map<String, dynamic> data) {
  List<MaintanaceCategory> categories = [];

  //print("fghfh $data");
  data.forEach((categoryName, categoryItems) {
    //print("hgjjhjh $categoryItems");
    List<MaintanaceCategoryItem> items = [];
    categoryItems.forEach((itemTitle, itemCount) {
      if (itemTitle != "Premium Payment" && itemTitle != "Claim") {
        if (categoryName == "Self") {
          if (!remove_main_memeber_list.contains(itemTitle)) {
            items.add(
                MaintanaceCategoryItem(title: itemTitle, count: itemCount));
          }
        } else if (categoryName == "Dependant") {
          if (!remove_dependant_list.contains(itemTitle)) {
            items.add(
                MaintanaceCategoryItem(title: itemTitle, count: itemCount));
          }
        } else if (categoryName == "Beneficiary") {
          if (!remove_beficiary_list.contains(itemTitle)) {
            items.add(
                MaintanaceCategoryItem(title: itemTitle, count: itemCount));
          }
        }
      }
    });
    items.sort((a, b) => b.count.compareTo(a.count));

    categories.add(MaintanaceCategory(name: categoryName, items: items));
  });
  return categories;
}

List<MaintanaceCategory> processDataForMaintenanceGroups(List<dynamic> data) {
  List<MaintanaceCategory> categories = [];
  //print("fghfh $data");
  if (data.length > 0) {
    data[0].forEach((categoryName, categoryItems) {
      // print("hgjjhjh $categoryItems");
      List<MaintanaceCategoryItem> items = [];
      categoryItems.forEach((itemTitle, itemCount) {
        items.add(MaintanaceCategoryItem(title: itemTitle, count: itemCount));
        items.sort((b, a) => a.count.compareTo(b.count));
      });

      categories.add(MaintanaceCategory(name: categoryName, items: items));
      // print(categories);
    });
  }
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
    //print("ghhg");
    //print(parts);

    DateTime date = DateTime.parse(
        parts[0] + "-" + parts[1] + "-" + parts[2].split(" ")[0]);
    String collectionType = parts[3];

    if (date.month == currentMonth && date.year == currentYear) {
      int dayOfMonth = date.day;
      double premium = value.toDouble();

      dailySales[dayOfMonth]!.update(
          collectionType, (existingValue) => existingValue + premium,
          ifAbsent: () => premium);
    }
  });

  List<BarChartGroupData> collectionsGroupedData = [];
  dailySales.forEach((dayOfMonth, salesData) {
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    //Add purple and green

    salesData.forEach((type, amount) {
      Color? color; // Define color based on the type
      switch (type) {
        case 'Premium Payment':
          color = Colors.blue;
          break;
        case 'Banking Details':
          color = Colors.purple;
          break;
        case 'Cancellation':
          color = Colors.orange;
          break;
        case 'Collection Date Change':
          color = Colors.grey;
          break;
        case 'Payment Method Change':
          color = Colors.green;
          break;

        case 'Add Beneficiary':
          color = Colors.yellow;
          break;

        case 'Member Details':
          color = Colors.green;
          break;
        // Add more cases for different collection types
        default:
          //print("rgfggh $type");
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

void processDataForMaintenanceCountDailylineGraph(Map dailySalesCount) {
  Constants.maintenance_spots1a = [];
  Constants.maintenance_spots1b = [];
  Constants.maintenance_spots1c = [];
  Constants.maintenance_chartKey1a = UniqueKey();
  Constants.maintenance_chartKey1b = UniqueKey();
  Constants.maintenance_chartKey1c = UniqueKey();
  //print("fghhg0 $dailySalesCount");
  dailySalesCount.forEach((dateString, count) {
    //print("fghhgfghjgjdateString $dateString");
    DateTime parsedDate = DateTime.parse(dateString);

    int day = parsedDate.day;
    if (parsedDate.month == DateTime.now().month &&
        parsedDate.year == DateTime.now().year) {
      // print("dfsfdd $day $count");
      Constants.maintenance_spots1a
          .add(FlSpot(day.toDouble(), count.toDouble()));
      Constants.maintenance_spots1b
          .add(FlSpot(day.toDouble(), count.toDouble()));
      Constants.maintenance_spots1c
          .add(FlSpot(day.toDouble(), count.toDouble()));
    }
    if (count > Constants.maintenance_maxY) {
      Constants.maintenance_maxY = count;
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
  Constants.maintenance_spots1a.sort((a, b) => a.x.compareTo(b.x));
  Constants.maintenance_spots1b.sort((a, b) => a.x.compareTo(b.x));
  Constants.maintenance_spots1c.sort((a, b) => a.x.compareTo(b.x));
}

void processDataForMaintenanceCountDailylineGraph2(
    Map<String, dynamic> dailySalesCount) {
  Constants.maintenance_spots3a = [];
  Constants.maintenance_spots3b = [];
  Constants.maintenance_spots3c = [];
  Constants.maintenance_chartKey3a = UniqueKey();
  Constants.maintenance_chartKey3b = UniqueKey();
  Constants.maintenance_chartKey3c = UniqueKey();

  //print("fghhg ${dailySalesCount.length}");

  dailySalesCount.forEach((dateString, count) {
    DateTime parsedDate = DateTime.parse(dateString);
    int day = parsedDate.day;
    double yValue = (count is int) ? count.toDouble() : 0.0;
    //print("fgfhhg $dateString ${day.toDouble()} $yValue");

    Constants.maintenance_spots3a.add(FlSpot(day.toDouble(), yValue));
    if (yValue > Constants.maintenance_maxY3) {
      Constants.maintenance_maxY3 = yValue.round();
    }
  });
  Constants.maintenance_spots3a.sort((a, b) => a.x.compareTo(b.x));

  dailySalesCount.forEach((dateString, count) {
    DateTime parsedDate = DateTime.parse(dateString);
    int day = parsedDate.day;
    double yValue = (count is int) ? count.toDouble() : 0.0;

    Constants.maintenance_spots3b.add(FlSpot(day.toDouble(), yValue));
  });

  dailySalesCount.forEach((dateString, count) {
    DateTime parsedDate = DateTime.parse(dateString);
    int day = parsedDate.day;
    double yValue = (count is int) ? count.toDouble() : 0.0;

    Constants.maintenance_spots3c.add(FlSpot(day.toDouble(), yValue));
  });
}

void processDataForMaintenanceCountMonthlylineGraph(Map dailySalesCount) {
  Constants.maintenance_spots2a = [];
  Constants.maintenance_spots2b = [];
  Constants.maintenance_spots2c = [];
  Constants.maintenance_chartKey2a = UniqueKey();
  Constants.maintenance_chartKey2b = UniqueKey();
  Constants.maintenance_chartKey2c = UniqueKey();
  //print("yuu $dailySalesCount");
  dailySalesCount.forEach((dateString, count) {
    DateTime parsedDate = DateTime.parse(dateString + "-01");

    int day = parsedDate.month;
    Constants.maintenance_spots2a.add(FlSpot(day.toDouble(), count.toDouble()));
    Constants.maintenance_spots2b.add(FlSpot(day.toDouble(), count.toDouble()));
    Constants.maintenance_spots2c.add(FlSpot(day.toDouble(), count.toDouble()));
    if (count > Constants.maintenance_maxY2) {
      Constants.maintenance_maxY2 = count;
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
  Constants.maintenance_spots4a = [];
  Constants.maintenance_spots4b = [];
  Constants.maintenance_spots4c = [];
  Constants.maintenance_chartKey3a = UniqueKey();
  Constants.maintenance_chartKey3b = UniqueKey();
  Constants.maintenance_chartKey3c = UniqueKey();
  //print("Data: $dailySalesCount");

  dailySalesCount.forEach((dateString, count) {
    DateTime parsedDate = DateTime.parse(dateString + "-01");

    int month = parsedDate.month;
    double yValue = (count is int) ? count.toDouble() : 0.0;

    Constants.maintenance_spots4a.add(FlSpot(month.toDouble(), yValue));
    if (yValue > Constants.maintenance_maxY4) {
      Constants.maintenance_maxY4 = yValue.round();
    }
  });

  dailySalesCount.forEach((dateString, count) {
    DateTime parsedDate = DateTime.parse(dateString + "-01");
    int month = parsedDate.month;
    double yValue = (count is int) ? count.toDouble() : 0.0;

    Constants.maintenance_spots4b.add(FlSpot(month.toDouble(), yValue));
  });

  dailySalesCount.forEach((dateString, count) {
    DateTime parsedDate = DateTime.parse(dateString + "-01");
    int month = parsedDate.month;
    double yValue = (count is int) ? count.toDouble() : 0.0;

    Constants.maintenance_spots4c.add(FlSpot(month.toDouble(), yValue));
  });
}

List<BarChartGroupData> processDataForCollectionsCountMonthly(
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

    // Add "-01" to create a valid date string for parsing
    String dateString = "${parts[0]}-${parts[1]}-01";

    if (kDebugMode) {
      // print("Formatted Date String: $dateString");
    }

    // Parse the date
    DateTime date;
    try {
      date = DateTime.parse(dateString);
    } catch (e) {
      //print("Error parsing date: $e");
      return; // Skip this iteration if parsing fails
    }

    // Extract collection type - it's the third part of your split string
    String collectionType = parts[2];

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
        case 'Premium Payment':
          color = Colors.blue;
          break;
        case 'Banking Details':
          color = Colors.purple;
          break;
        case 'Cancellation':
          color = Colors.orange;
          break;
        case 'Collection Date Change':
          color = Colors.grey;
          break;
        case 'Payment Method Change':
          color = Colors.green;
          break;

        case 'Add Beneficiary':
          color = Colors.yellow;
          break;

        case 'Member Details':
          color = Colors.green;
          break;
        // Add more cases for different collection types
        default:
          //print("rgfggh $type");
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

String findMostFrequentUpgradeValue(List<dynamic> jsonData) {
  // Create a map to count occurrences of each changed_value where transaction_name is "Upgrade".
  Map<String, int> valueCounts = {};

  for (var record in jsonData) {
    if (record['transaction_name'] == "Upgrade") {
      String changedValue = record['changed_value'];
      if (valueCounts.containsKey(changedValue)) {
        valueCounts[changedValue] = valueCounts[changedValue]! + 1;
      } else {
        valueCounts[changedValue] = 1;
      }
    }
  }

  // Find the changed_value with the maximum count.
  String mostFrequentValue = '';
  int maxCount = 0;

  valueCounts.forEach((key, value) {
    if (value > maxCount) {
      maxCount = value;
      mostFrequentValue = key;
    }
  });

  return mostFrequentValue;
}

String findMostFrequentDowngradeValue(List<dynamic> jsonData) {
  // Create a map to count occurrences of each changed_value where transaction_name is "Upgrade".
  Map<String, int> valueCounts = {};

  for (var record in jsonData) {
    if (record['transaction_name'] == "Downgrade") {
      String changedValue = record['changed_value'];
      if (valueCounts.containsKey(changedValue)) {
        valueCounts[changedValue] = valueCounts[changedValue]! + 1;
      } else {
        valueCounts[changedValue] = 1;
      }
    }
  }

  // Find the changed_value with the maximum count.
  String mostFrequentValue = '';
  int maxCount = 0;

  valueCounts.forEach((key, value) {
    if (value > maxCount) {
      maxCount = value;
      mostFrequentValue = key;
    }
  });

  return mostFrequentValue;
}

int findMostFrequentValueCount(List<dynamic> jsonData, String transactionName) {
  int valueCounts = 0;

  // Iterate over each record and count occurrences of each changed_value for the specified transaction type
  for (var record in jsonData) {
    if (record['transaction_name'] == transactionName) {
      valueCounts++;
    }
  }

  return valueCounts;
}

int findMostFrequentValueCount2(
    List<dynamic> jsonData, String transactionName) {
  Map<String, int> valueCounts = {};

  // Iterate over each record and count occurrences of each changed_value for the specified transaction type
  for (var record in jsonData) {
    if (record['transaction_name'] == transactionName) {
      String changedValue = record['changed_value'];
      if (valueCounts.containsKey(changedValue)) {
        valueCounts[changedValue] = valueCounts[changedValue]! + 1;
      } else {
        valueCounts[changedValue] = 1;
      }
    }
  }

  // Find the maximum count from the map
  int maxCount = 0;
  valueCounts.forEach((key, value) {
    if (value > maxCount) {
      maxCount = value;
    }
  });

  return maxCount; // Return the count of the most frequent changed_value
}
