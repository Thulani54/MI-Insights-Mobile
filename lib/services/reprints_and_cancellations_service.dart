import "dart:convert";
import "dart:math";

import "package:fl_chart/fl_chart.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:intl/intl.dart";
import "package:mi_insights/services/longPrint.dart";

import "../constants/Constants.dart";
import "../models/ReprintByAgent.dart";
import '../screens/Reports/Executive/ExecutiveCollectionsReport.dart' as cllc;
import "../screens/Reports/ReprintsAndCancellations.dart";

Future<void> getReprintsData(String date_from, String date_to,
    int selectedButton1, BuildContext context) async {
  String baseUrl =
      "${Constants.analitixAppBaseUrl}sales/get_reprints_and_cancellations_data/";
  if (Constants.myUserRoleLevel.toLowerCase() == "tester") {
    baseUrl =
        "${Constants.analitixAppBaseUrl}sales/get_reprints_and_cancellations_data_test/";
  }

  int days_difference = 0;
  DateTime startDateTime = DateFormat('yyyy-MM-dd').parse(date_from);
  DateTime endDateTime = DateFormat('yyyy-MM-dd').parse(date_to);

  days_difference = endDateTime.difference(startDateTime).inDays;

  try {
    Map<String, String>? payload = {
      "client_id": Constants.cec_client_id.toString(),
      "start_date": date_from,
      "end_date": date_to
    };
    if (kDebugMode) {
      //print("baseUrl $baseUrl");
      print("payloadhjk $payload");
    }

    await http
        .post(
      Uri.parse(
        baseUrl,
      ),
      body: payload,
    )
        .then((value) {
      http.Response response = value;
      // print("payload ${payload}");
      // logLongString("thjhjts1b $selectedButton1 ${response.body}");

      if (response.statusCode != 200) {
      } else {
        var jsonResponse1 = jsonDecode(response.body);

        logLongString(
            "thjhjts1a $selectedButton1 ${date_from} ${date_to} ${jsonResponse1}");

        if (selectedButton1 == 1) {
          Constants.reprints_sectionsList1a = [
            cllc.gridmodel1("Approved", 0, 0),
            cllc.gridmodel1("Exp. & Decl.", 0, 0),
            cllc.gridmodel1("Pending", 0, 0),
          ];
          Constants.reprints_sectionsList1a_1 = [
            cllc.gridmodel1("Approved", 0, 0),
            cllc.gridmodel1("Exp. & Decl.", 0, 0),
            cllc.gridmodel1("Pending", 0, 0),
          ];
          Constants.cancellations_sectionsList1a = [
            cllc.gridmodel1("Approved", 0, 0),
            cllc.gridmodel1("Exp. & Decl.", 0, 0),
            cllc.gridmodel1("Pending", 0, 0),
          ];
          Constants.cancellations_sectionsList1a_1 = [
            cllc.gridmodel1("Approved", 0, 0),
            cllc.gridmodel1("Exp. & Decl.", 0, 0),
            cllc.gridmodel1("Pending", 0, 0),
          ];
          if (!jsonResponse1["cancellations_total_counts"].isEmpty) {
            //logLongString("thjhjts1a_cancellations_total_counts $selectedButton1 ${jsonResponse1["cancellations_total_counts"]}");

            jsonResponse1["cancellations_total_counts"].forEach((element) {
              Map m1 = element as Map;

              if (m1["status"] == "Approved") {
                Constants.cancellations_sectionsList1a[0].amount +=
                    double.parse((m1["total_amount"]).toString());
                Constants.cancellations_sectionsList1a[0].count +=
                    int.parse((m1["count"]).toString());
              }
              if (m1["status"] == "Expired" || m1["status"] == "Declined") {
                Constants.cancellations_sectionsList1a[1].amount +=
                    double.parse((m1["total_amount"]).toString());
                Constants.cancellations_sectionsList1a[1].count +=
                    int.parse((m1["count"]).toString());
              }
              if (m1["status"] == "Awaiting Action") {
                Constants.cancellations_sectionsList1a[2].amount +=
                    double.parse((m1["total_amount"]).toString());
                Constants.cancellations_sectionsList1a[2].count +=
                    int.parse((m1["count"]).toString());
              }
            });
          }

          //Reprints
          if (!jsonResponse1["reprints_total_counts"].isEmpty) {
            jsonResponse1["reprints_total_counts"].forEach((element) {
              Map m1 = element as Map;
              print(
                  "ddssdssd $selectedButton1 ${m1["status"]} ${m1["total_amount"]} ${m1["count"]}");
              if (m1["status"] == "Approved") {
                Constants.reprints_sectionsList1a[0].amount +=
                    double.parse((m1["total_amount"]).toString());
                Constants.reprints_sectionsList1a[0].count +=
                    int.parse((m1["count"]).toString());
              }
              if (m1["status"] == "Expired" || m1["status"] == "Declined") {
                Constants.reprints_sectionsList1a[1].amount +=
                    double.parse((m1["total_amount"]).toString());
                Constants.reprints_sectionsList1a[1].count +=
                    int.parse((m1["count"]).toString());
              }
              if (m1["status"] == "Awaiting Action") {
                Constants.reprints_sectionsList1a[2].amount +=
                    double.parse((m1["total_amount"]).toString());
                Constants.reprints_sectionsList1a[2].count +=
                    int.parse((m1["count"]).toString());
              }
            });
          }

          reprints_barChartData1 = [];
          reprints_barChartData1 = processDataForReprintsDaily1(response.body);
          reprints_barChartData1_1 =
              processDataForReprintsDaily1_1(response.body);
          //logLongString(response.body);
          if (kDebugMode) {
            print(
                "top_reprint_agentshjjfghg $date_from $date_to ${jsonResponse1["top_reprint_agents"] ?? ""}");
          }
          Map<String, dynamic> topEmployeeList =
              jsonResponse1["top_10_cancellations_agents"];
          topEmployeeList.forEach((key, value) {
            Constants.cancellations_agents1a.add(ReprintByAgent(key, value));
          });
          Constants.reprints_agents1a = [];
          Map<String, dynamic> toprepEmployeeList =
              jsonResponse1["top_reprint_agents"];
          toprepEmployeeList.forEach((key, value) {
            Constants.reprints_agents1a.add(ReprintByAgent(key, value));
          });
          if (kDebugMode) {
            print("toprepEmployeeList $toprepEmployeeList");
          }

          Constants.bottomscancellations_agents1a = [];

          Map<String, dynamic> bottomEmployeesList =
              jsonResponse1["bottom_10_cancellations_agents"];
          bottomEmployeesList.forEach((key, value) {
            Constants.bottomscancellations_agents1a
                .add(ReprintByAgent(key, value));
          });

          Map<String, dynamic> bottomrepEmployeesList =
              jsonResponse1["bottom_10_reprints_agents"];
          bottomrepEmployeesList.forEach((key, value) {
            Constants.bottomsreprints_agents1a.add(ReprintByAgent(key, value));
          });

          int totalReprints = Constants.reprints_sectionsList1a[0].count +
              Constants.reprints_sectionsList1a[1].count +
              Constants.reprints_sectionsList1a[2].count;

          int totalCancellations =
              Constants.cancellations_sectionsList1a[0].count +
                  Constants.cancellations_sectionsList1a[1].count +
                  Constants.cancellations_sectionsList1a[2].count;
          if (totalReprints > 0) {
            if (kDebugMode) {
              print("sddjhkd0 $totalReprints");
            }
            (Constants.reprints_request_approval_rate1a =
                    Constants.reprints_sectionsList1a[0].count /
                        totalReprints) /
                100;
          }
          if (totalCancellations > 0) {
            (Constants.cancellations_request_approval_rate1a =
                    Constants.cancellations_sectionsList1a[0].count /
                        totalCancellations) /
                100;
          }
          if (kDebugMode) {
            print(
                "sddjhkd ${Constants.cancellations_request_approval_rate1a}  ${Constants.reprints_request_approval_rate1a}");
          }

          reprintsValue.value++;
        } else if (selectedButton1 == 2) {
          // print("jsronResp $selectedButton1 $jsonResponse1");
          Constants.reprints_sectionsList2a = [
            cllc.gridmodel1("Approved", 0, 0),
            cllc.gridmodel1("Exp. & Decl.", 0, 0),
            cllc.gridmodel1("Pending", 0, 0),
          ];
          Constants.reprints_sectionsList2a_1 = [
            cllc.gridmodel1("Approved", 0, 0),
            cllc.gridmodel1("Exp. & Decl.", 0, 0),
            cllc.gridmodel1("Pending", 0, 0),
          ];
          Constants.cancellations_sectionsList2a = [
            cllc.gridmodel1("Approved", 0, 0),
            cllc.gridmodel1("Exp. & Decl.", 0, 0),
            cllc.gridmodel1("Pending", 0, 0),
          ];
          Constants.cancellations_sectionsList2a_1 = [
            cllc.gridmodel1("Approved", 0, 0),
            cllc.gridmodel1("Exp. & Decl.", 0, 0),
            cllc.gridmodel1("Pending", 0, 0),
          ];

          if (!jsonResponse1["cancellations_total_counts"].isEmpty) {
            jsonResponse1["cancellations_total_counts"].forEach((element) {
              Map m1 = element as Map;
              if (m1["status"] == "Approved") {
                Constants.cancellations_sectionsList2a[0].amount +=
                    double.parse((m1["total_amount"]).toString());
                Constants.cancellations_sectionsList2a[0].count +=
                    int.parse((m1["count"]).toString());
              }
              if (m1["status"] == "Expired" || m1["status"] == "Declined") {
                Constants.cancellations_sectionsList2a[1].amount +=
                    double.parse((m1["total_amount"]).toString());
                Constants.cancellations_sectionsList2a[1].count +=
                    int.parse((m1["count"]).toString());
              }
              if (m1["status"] == "Awaiting Action") {
                Constants.cancellations_sectionsList2a[2].amount +=
                    double.parse((m1["total_amount"]).toString());
                Constants.cancellations_sectionsList2a[2].count +=
                    int.parse((m1["count"]).toString());
              }
            });
          }

          //Reprints
          if (!jsonResponse1["reprints_total_counts"].isEmpty) {
            jsonResponse1["reprints_total_counts"].forEach((element) {
              Map m1 = element as Map;
              if (m1["status"] == "Approved") {
                Constants.reprints_sectionsList2a[0].amount +=
                    double.parse((m1["total_amount"]).toString());
                Constants.reprints_sectionsList2a[0].count +=
                    int.parse((m1["count"]).toString());
              }
              if (m1["status"] == "Expired" || m1["status"] == "Declined") {
                Constants.reprints_sectionsList2a[1].amount +=
                    double.parse((m1["total_amount"]).toString());
                Constants.reprints_sectionsList2a[1].count +=
                    int.parse((m1["count"]).toString());
              }
              if (m1["status"] == "Awaiting Action") {
                Constants.reprints_sectionsList2a[2].amount +=
                    double.parse((m1["total_amount"]).toString());
                Constants.reprints_sectionsList2a[2].count +=
                    int.parse((m1["count"]).toString());
              }
            });
          }

          reprints_barChartData2 = [];
          reprints_barChartData2_1 = [];

          reprints_barChartData2 = processDataForReprintsCountMonthly2(
              response.body, date_from, date_to, context);
          reprints_barChartData2_1 = processDataForReprintsCountMonthly2_1(
              response.body, date_from, date_to, context);

          Map<String, dynamic> topEmployeeList =
              jsonResponse1["top_10_cancellations_agents"];
          topEmployeeList.forEach((key, value) {
            Constants.cancellations_agents2a.add(ReprintByAgent(key, value));
          });
          Map<String, dynamic> toprepEmployeeList =
              jsonResponse1["top_reprint_agents"];
          toprepEmployeeList.forEach((key, value) {
            Constants.reprints_agents2a.add(ReprintByAgent(key, value));
          });
          Map<String, dynamic> bottom_employees_list =
              jsonResponse1["bottom_10_reprints_agents"];
          bottom_employees_list.forEach((key, value) {
            Constants.bottomsreprintbyagent2a.add(ReprintByAgent(key, value));
          });
          if (kDebugMode) {
            /*print(
                "top_reprint_agentshjjhh2a $date_from $date_to ${jsonResponse1["top_10_cancellations_agents"]}");*/
          }

          Map<String, dynamic> bottomEmployeesList =
              jsonResponse1["bottom_10_cancellations_agents"];
          bottomEmployeesList.forEach((key, value) {
            Constants.bottomscancellations_agents2a
                .add(ReprintByAgent(key, value));
          });
          int totalReprints = Constants.reprints_sectionsList2a[0].count +
              Constants.reprints_sectionsList2a[1].count +
              Constants.reprints_sectionsList2a[2].count;

          int totalCancellations =
              Constants.cancellations_sectionsList2a[0].count +
                  Constants.cancellations_sectionsList2a[1].count +
                  Constants.cancellations_sectionsList2a[2].count;
          if (totalReprints > 0) {
            print(
                "sddjhkd2 $totalReprints ${Constants.reprints_sectionsList2a[0].count}");
            (Constants.reprints_request_approval_rate2a =
                    Constants.reprints_sectionsList2a[0].count /
                        totalReprints) /
                100;
          }
          if (totalCancellations > 0) {
            (Constants.cancellations_request_approval_rate2a =
                    Constants.cancellations_sectionsList2a[0].count /
                        totalCancellations) /
                100;
          }

          reprintsValue.value++;
        } else if (selectedButton1 == 3 && days_difference <= 31) {
          Constants.reprints_sectionsList3a = [
            cllc.gridmodel1("Approved", 0, 0),
            cllc.gridmodel1("Exp. & Decl.", 0, 0),
            cllc.gridmodel1("Pending", 0, 0),
          ];
          Constants.reprints_sectionsList3a_1 = [
            cllc.gridmodel1("Approved", 0, 0),
            cllc.gridmodel1("Exp. & Decl.", 0, 0),
            cllc.gridmodel1("Pending", 0, 0),
          ];
          Constants.cancellations_sectionsList3a = [
            cllc.gridmodel1("Approved", 0, 0),
            cllc.gridmodel1("Exp. & Decl.", 0, 0),
            cllc.gridmodel1("Pending", 0, 0),
          ];
          Constants.cancellations_sectionsList3a_1 = [
            cllc.gridmodel1("Approved", 0, 0),
            cllc.gridmodel1("Exp. & Decl.", 0, 0),
            cllc.gridmodel1("Pending", 0, 0),
          ];
          logLongString(
              "thjhjts1a_cancellations_total_counts $selectedButton1 ${jsonResponse1["cancellations_total_counts"]}");

          //Cancellations
          if (!jsonResponse1["cancellations_total_counts"].isEmpty) {
            jsonResponse1["cancellations_total_counts"].forEach((element) {
              Map m1 = element as Map;
              if (m1["status"] == "Approved") {
                Constants.cancellations_sectionsList3a[0].amount +=
                    double.parse((m1["total_amount"]).toString());
                Constants.cancellations_sectionsList3a[0].count +=
                    int.parse((m1["count"]).toString());
              }
              if (m1["status"] == "Expired" || m1["status"] == "Declined") {
                Constants.cancellations_sectionsList3a[1].amount +=
                    double.parse((m1["total_amount"]).toString());
                Constants.cancellations_sectionsList3a[1].count +=
                    int.parse((m1["count"]).toString());
              }
              if (m1["status"] == "Awaiting Action") {
                Constants.cancellations_sectionsList3a[2].amount +=
                    double.parse((m1["total_amount"]).toString());
                Constants.cancellations_sectionsList3a[2].count +=
                    int.parse((m1["count"]).toString());
              }
            });
          }

          //Reprints
          if (!jsonResponse1["reprints_total_counts"].isEmpty) {
            jsonResponse1["reprints_total_counts"].forEach((element) {
              Map m1 = element as Map;
              if (m1["status"] == "Approved") {
                Constants.reprints_sectionsList3a[0].amount +=
                    double.parse((m1["total_amount"]).toString());
                Constants.reprints_sectionsList3a[0].count +=
                    int.parse((m1["count"]).toString());
              }
              if (m1["status"] == "Expired" || m1["status"] == "Declined") {
                Constants.reprints_sectionsList3a[1].amount +=
                    double.parse((m1["total_amount"]).toString());
                Constants.reprints_sectionsList3a[1].count +=
                    int.parse((m1["count"]).toString());
              }
              if (m1["status"] == "Awaiting Action") {
                Constants.reprints_sectionsList3a[2].amount +=
                    double.parse((m1["total_amount"]).toString());
                Constants.reprints_sectionsList3a[2].count +=
                    int.parse((m1["count"]).toString());
              }
            });
          }
          int totalReprints = Constants.reprints_sectionsList3a[0].count +
              Constants.reprints_sectionsList3a[1].count +
              Constants.reprints_sectionsList3a[2].count;

          int totalCancellations =
              Constants.cancellations_sectionsList3a[0].count +
                  Constants.cancellations_sectionsList3a[1].count +
                  Constants.cancellations_sectionsList3a[2].count;
          if (totalReprints > 0) {
            print("sddjhkd0 $totalReprints");
            (Constants.reprints_request_approval_rate3a =
                    Constants.reprints_sectionsList3a[0].count /
                        totalReprints) /
                100;
          }
          if (totalCancellations > 0) {
            (Constants.cancellations_request_approval_rate3a =
                    Constants.cancellations_sectionsList3a[0].count /
                        totalCancellations) /
                100;
          }
          Constants.reprints_agents3a = [];
          Constants.cancellations_agents3a = [];
          Constants.bottomscancellations_agents3a = [];
          Constants.bottomsreprints_agents3a = [];

          reprints_barChartData3 = [];
          reprints_barChartData3 = processDataForReprintsDaily3(
              response.body, date_from, date_to, context);
          reprints_barChartData3_1 = processDataForReprintsDaily3_1(
              response.body, date_from, date_to, context);
          //logLongString(response.body);
          if (kDebugMode) {
            print(
                "top_reprint_agentshjjhh $date_from $date_to ${jsonResponse1["top_10_cancellations_agents"]}");
          }
          Map<String, dynamic> topEmployeeList =
              jsonResponse1["top_10_cancellations_agents"];
          topEmployeeList.forEach((key, value) {
            Constants.cancellations_agents3a.add(ReprintByAgent(key, value));
          });

          Map<String, dynamic> bottomEmployeesList =
              jsonResponse1["bottom_10_cancellations_agents"];
          bottomEmployeesList.forEach((key, value) {
            Constants.bottomscancellations_agents3a
                .add(ReprintByAgent(key, value));
          });
          Map<String, dynamic> toprepEmployeeList =
              jsonResponse1["top_reprint_agents"];
          toprepEmployeeList.forEach((key, value) {
            Constants.reprints_agents3a.add(ReprintByAgent(key, value));
          });
          print("toprepEmployeeList $toprepEmployeeList");
          Map<String, dynamic> bottomrepEmployeesList =
              jsonResponse1["bottom_10_reprints_agents"];
          bottomrepEmployeesList.forEach((key, value) {
            Constants.bottomsreprints_agents3a.add(ReprintByAgent(key, value));
          });
          reprintsValue.value++;
        } else {
          Constants.reprints_sectionsList3b = [
            cllc.gridmodel1("Approved", 0, 0),
            cllc.gridmodel1("Exp. & Decl.", 0, 0),
            cllc.gridmodel1("Pending", 0, 0),
          ];
          Constants.reprints_sectionsList3b_1 = [
            cllc.gridmodel1("Approved", 0, 0),
            cllc.gridmodel1("Exp. & Decl.", 0, 0),
            cllc.gridmodel1("Pending", 0, 0),
          ];
          Constants.cancellations_sectionsList3b = [
            cllc.gridmodel1("Approved", 0, 0),
            cllc.gridmodel1("Exp. & Decl.", 0, 0),
            cllc.gridmodel1("Pending", 0, 0),
          ];
          Constants.cancellations_sectionsList3b_1 = [
            cllc.gridmodel1("Approved", 0, 0),
            cllc.gridmodel1("Exp. & Decl.", 0, 0),
            cllc.gridmodel1("Pending", 0, 0),
          ];
          Constants.reprints_agents3b = [];
          Constants.bottomscancellations_agents3b = [];
          Constants.cancellations_agents3b = [];
          Constants.bottomsreprints_agents3b = [];

          Map<String, dynamic> topEmployeeList =
              jsonResponse1["top_10_cancellations_agents"];
          topEmployeeList.forEach((key, value) {
            Constants.cancellations_agents3b.add(ReprintByAgent(key, value));
          });
          Map<String, dynamic> toprepEmployeeList =
              jsonResponse1["top_reprint_agents"];
          toprepEmployeeList.forEach((key, value) {
            Constants.reprints_agents3b.add(ReprintByAgent(key, value));
          });

          //Cancellations
          if (!jsonResponse1["cancellations_total_counts"].isEmpty) {
            jsonResponse1["cancellations_total_counts"].forEach((element) {
              Map m1 = element as Map;
              if (m1["status"] == "Approved") {
                Constants.cancellations_sectionsList3b[0].amount +=
                    double.parse((m1["total_amount"]).toString());
                Constants.cancellations_sectionsList3b[0].count +=
                    int.parse((m1["count"]).toString());
              }
              if (m1["status"] == "Expired" || m1["status"] == "Declined") {
                Constants.cancellations_sectionsList3b[1].amount +=
                    double.parse((m1["total_amount"]).toString());
                Constants.cancellations_sectionsList3b[1].count +=
                    int.parse((m1["count"]).toString());
              }
              if (m1["status"] == "Awaiting Action") {
                Constants.cancellations_sectionsList3b[2].amount +=
                    double.parse((m1["total_amount"]).toString());
                Constants.cancellations_sectionsList3b[2].count +=
                    int.parse((m1["count"]).toString());
              }
            });
          }

          //Reprints
          if (!jsonResponse1["reprints_total_counts"].isEmpty) {
            jsonResponse1["reprints_total_counts"].forEach((element) {
              Map m1 = element as Map;
              if (m1["status"] == "Approved") {
                Constants.reprints_sectionsList3b[0].amount +=
                    double.parse((m1["total_amount"]).toString());
                Constants.reprints_sectionsList3b[0].count +=
                    int.parse((m1["count"]).toString());
              }
              if (m1["status"] == "Expired" || m1["status"] == "Declined") {
                Constants.reprints_sectionsList3b[1].amount +=
                    double.parse((m1["total_amount"]).toString());
                Constants.reprints_sectionsList3b[1].count +=
                    int.parse((m1["count"]).toString());
              }
              if (m1["status"] == "Awaiting Action") {
                Constants.reprints_sectionsList3b[2].amount +=
                    double.parse((m1["total_amount"]).toString());
                Constants.reprints_sectionsList3b[2].count +=
                    int.parse((m1["count"]).toString());
              }
            });
          }
          int totalReprints = Constants.reprints_sectionsList3b[0].count +
              Constants.reprints_sectionsList3b[1].count +
              Constants.reprints_sectionsList3b[2].count;

          int totalCancellations =
              Constants.cancellations_sectionsList3b[0].count +
                  Constants.cancellations_sectionsList3b[1].count +
                  Constants.cancellations_sectionsList3b[2].count;
          if (totalReprints > 0) {
            print("sddjhkd0 $totalReprints");
            (Constants.reprints_request_approval_rate3b =
                    Constants.reprints_sectionsList3b[0].count /
                        totalReprints) /
                100;
          }
          if (totalCancellations > 0) {
            (Constants.cancellations_request_approval_rate3b =
                    Constants.cancellations_sectionsList3b[0].count /
                        totalCancellations) /
                100;
          }
          reprints_barChartData4 = [];
          reprints_barChartData4 = processDataForReprintsCountMonthly4(
              response.body, date_from, date_to, context);
          reprints_barChartData4_1 = processDataForReprintsCountMonthly4_1(
              response.body, date_from, date_to, context);

          Constants.reprintbyagent = Constants.reprintbyagent3b;
          reprintsValue.value++;
        }
      }
    });
  } on Exception catch (_, exception) {
    //Exception exc = exception as Exception;
    print(exception);
  }
}

Map<Color, int> colorOrder = {
  Colors.green: 1,
  Colors.blue: 2,
  Colors.orange: 3,
};
List<BarChartGroupData> processDataForReprintsDaily1(String jsonString) {
  print("aasagHA1 ${jsonString}");
  bool contains_data = false;
  List<dynamic> jsonData =
      jsonDecode(jsonString)["cancellations_total_counts_by_date"];

  DateTime now = DateTime.now();
  int currentMonth = now.month;
  int currentYear = now.year;
  int daysInCurrentMonth = DateTime(currentYear, currentMonth + 1, 0).day;

  Map<int, Map<String, double>> dailySales = {
    for (var day = 1; day <= daysInCurrentMonth; day++) day: {}
  };

  for (var reprintItem in jsonData) {
    if (reprintItem is Map<String, dynamic>) {
      //print("aasagHA2 ${reprintItem['date']}");
      DateTime date = DateTime.parse(reprintItem['date']);
      if (date.month == currentMonth && date.year == currentYear) {
        int dayOfMonth = date.day;
        String type = reprintItem["status"];
        double count = reprintItem["count"].toDouble();
        if (count > 0) {
          contains_data = true;
        }
        //print("dayOfMonth $dayOfMonth $count");

        dailySales[dayOfMonth]!
            .update(type, (value) => value + count, ifAbsent: () => count);
      }
    }
  }

  List<BarChartGroupData> reprintsGroupedData = [];
  dailySales.forEach((dayOfMonth, salesData) {
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    var sortedSalesData = sortReprintCancellationsData(salesData);

    sortedSalesData.forEach((entry) {
      String type = entry.key;
      double amount = entry.value;
      Color color;

      switch (type) {
        case 'Approved':
          color = Colors.green;
          break;
        case 'Expired':
          color = Colors.blue;
          break;
        case 'Declined':
          color = Colors.blue;
          break;
        case 'Awaiting Action':
          color = Colors.orange;
          break;
        default:
          color = Colors.grey;
      }

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, color));
      cumulativeAmount += amount;
    });
    rodStackItems.sort(
        (a, b) => colorOrder[a.color] ?? 0.compareTo(colorOrder[b.color] ?? 0));
    rodStackItems = rodStackItems.reversed.toList();

    // Add a bar for each day of the month
    reprintsGroupedData.add(BarChartGroupData(
      x: dayOfMonth,
      barRods: [
        BarChartRodData(
            toY: cumulativeAmount,
            rodStackItems: rodStackItems.isEmpty
                ? [BarChartRodStackItem(0, 0, Colors.transparent)]
                : rodStackItems,
            borderRadius: BorderRadius.zero,
            width: (Constants.screenWidth / daysInCurrentMonth) - 3.1),
      ],
    ));
  });

  if (contains_data == false) {
    return [];
  } else {
    return reprintsGroupedData;
  }
}

List<BarChartGroupData> processDataForReprintsDaily1_1(String jsonString) {
  bool contains_data = false;
  List<dynamic> jsonData =
      jsonDecode(jsonString)["reprints_total_counts_by_date"];

  DateTime now = DateTime.now();
  int currentMonth = now.month;
  int currentYear = now.year;
  int daysInCurrentMonth = DateTime(currentYear, currentMonth + 1, 0).day;

  // Initialize data structure for daily sales for the current month
  Map<int, Map<String, double>> dailySales = {
    for (var day = 1; day <= daysInCurrentMonth; day++) day: {}
  };

  for (var reprintItem in jsonData) {
    if (reprintItem is Map<String, dynamic>) {
      DateTime date = DateTime.parse(reprintItem['date']);
      if (date.month == currentMonth && date.year == currentYear) {
        int dayOfMonth = date.day;
        String type = reprintItem["status"];
        double count = reprintItem["count"].toDouble();

        if (count > 0) {
          contains_data = true;
        }
        //print("dayOfMonth $dayOfMonth $count");

        dailySales[dayOfMonth]!
            .update(type, (value) => value + count, ifAbsent: () => count);
      }
    }
  }

  List<BarChartGroupData> reprintsGroupedData = [];
  dailySales.forEach((dayOfMonth, salesData) {
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    var sortedSalesData = sortReprintCancellationsData(salesData);

    sortedSalesData.forEach((entry) {
      String type = entry.key;
      double amount = entry.value;
      Color color;

      switch (type) {
        case 'Approved':
          color = Colors.green;
          break;
        case 'Expired':
          color = Colors.blue;
          break;
        case 'Declined':
          color = Colors.blue;
          break;
        case 'Awaiting Action':
          color = Colors.orange;
          break;
        default:
          color = Colors.grey;
      }

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, color));
      cumulativeAmount += amount;
    });
    rodStackItems.sort(
        (a, b) => colorOrder[a.color] ?? 0.compareTo(colorOrder[b.color] ?? 0));
    rodStackItems = rodStackItems.reversed.toList();

    // Add a bar for each day of the month
    reprintsGroupedData.add(BarChartGroupData(
      x: dayOfMonth,
      barRods: [
        BarChartRodData(
            toY: cumulativeAmount,
            rodStackItems: rodStackItems.isEmpty
                ? [BarChartRodStackItem(0, 0, Colors.transparent)]
                : rodStackItems,
            borderRadius: BorderRadius.zero,
            width: (Constants.screenWidth / daysInCurrentMonth) - 3.3),
      ],
    ));
  });
  if (contains_data == false) {
    print("contains_data == false");
    return [];
  } else {
    return reprintsGroupedData;
  }
}

List<BarChartGroupData> processDataForReprintsCountMonthly2(
    String jsonString, String startDate, String endDate, BuildContext context) {
  //print("aaxdss");
  bool contains_data = false;
  List<dynamic> jsonData =
      jsonDecode(jsonString)["cancellations_total_counts_by_date"];

  DateTime end = DateTime.parse(endDate);
  DateTime start = DateTime(end.year - 1, end.month, end.day);
  int monthsInRange = 12;

  Map<int, Map<String, double>> monthlySales = {
    for (var i = 0; i < monthsInRange; i++)
      DateTime(end.year, end.month - i, 1).month: {}
  };

  for (var reprintItem in jsonData) {
    if (reprintItem is Map<String, dynamic>) {
      DateTime paymentDate = DateTime.parse(reprintItem['date'] + "-01");
      if (paymentDate.isAfter(start) &&
          paymentDate.isBefore(end.add(const Duration(days: 1)))) {
        int monthIndex = paymentDate.month;
        String type = reprintItem["status"];
        double count = reprintItem["count"].toDouble();
        if (count > 0) {
          contains_data = true;
        }

        monthlySales.putIfAbsent(monthIndex, () => {});
        monthlySales[monthIndex]
            ?.update(type, (value) => value + count, ifAbsent: () => count);
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

  List<BarChartGroupData> reprintsGroupedData = [];
  monthlySales.forEach((monthIndex, salesData) {
    //print("aaxdss $monthIndex $salesData");
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];
    var sortedSalesData = sortReprintCancellationsData(salesData);

    sortedSalesData.forEach((entry) {
      String type = entry.key;
      double amount = entry.value;
      Color color;

      switch (type) {
        case 'Approved':
          color = Colors.green;
          break;
        case 'Expired':
          color = Colors.blue;
          break;
        case 'Declined':
          color = Colors.blue;
          break;
        case 'Awaiting Action':
          color = Colors.orange;
          break;
        default:
          color = Colors.grey;
      }

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, color));
      cumulativeAmount += amount;
    });
    rodStackItems.sort(
        (a, b) => (colorOrder[a.color] ?? 0).compareTo(colorOrder[b.color] ?? 0));
    rodStackItems = rodStackItems.reversed.toList();
    print(rodStackItems);

    reprintsGroupedData.add(BarChartGroupData(
      x: monthIndex,
      barRods: [
        BarChartRodData(
          toY: cumulativeAmount,
          rodStackItems: rodStackItems.isEmpty
              ? [BarChartRodStackItem(0, 0, Colors.transparent)]
              : rodStackItems,
          borderRadius: BorderRadius.zero,
          width: (Constants.screenWidth / 12) - 9.1,
        ),
      ],
      barsSpace: barsSpace,
    ));
  });

  if (contains_data == false) {
    return [];
  } else {
    return reprintsGroupedData;
  }
}

List<BarChartGroupData> processDataForReprintsCountMonthly2_1(
    String jsonString, String startDate, String endDate, BuildContext context) {
  bool contains_data = false;

  List<dynamic> jsonData =
      jsonDecode(jsonString)["reprints_total_counts_by_date"];
  if (jsonData == null || jsonData.isEmpty) {
    return [];
  }

/*  jsonData = [
    {"date": "2023-01-01", "status": "Approved", "count": 20},
    {"date": "2023-01-01", "status": "Awaiting Action", "count": 10},
    {"date": "2023-01-01", "status": "Declined", "count": 14},
    {"date": "2023-02-01", "status": "Approved", "count": 10},
    {"date": "2023-02-01", "status": "Awaiting Action", "count": 60},
    {"date": "2023-02-01", "status": "Declined", "count": 10},
    {"date": "2023-03-01", "status": "Approved", "count": 10},
    {"date": "2023-03-01", "status": "Awaiting Action", "count": 5},
    {"date": "2023-03-01", "status": "Declined", "count": 8},
    {"date": "2023-04-01", "status": "Approved", "count": 12},
    {"date": "2023-04-01", "status": "Awaiting Action", "count": 0},
    {"date": "2023-04-01", "status": "Declined", "count": 0},
    {"date": "2023-05-01", "status": "Approved", "count": 0},
    {"date": "2023-05-01", "status": "Awaiting Action", "count": 0},
    {"date": "2023-05-01", "status": "Declined", "count": 0},
    {"date": "2023-06-01", "status": "Approved", "count": 0},
    {"date": "2023-06-01", "status": "Awaiting Action", "count": 0},
    {"date": "2023-06-01", "status": "Declined", "count": 0},
    {"date": "2023-07-01", "status": "Approved", "count": 0},
    {"date": "2023-07-01", "status": "Awaiting Action", "count": 0},
    {"date": "2023-07-01", "status": "Declined", "count": 0},
    {"date": "2023-08-01", "status": "Approved", "count": 0},
    {"date": "2023-08-01", "status": "Awaiting Action", "count": 0},
    {"date": "2023-08-01", "status": "Declined", "count": 0},
    {"date": "2023-09-01", "status": "Approved", "count": 0},
    {"date": "2023-09-01", "status": "Awaiting Action", "count": 0},
    {"date": "2023-09-01", "status": "Declined", "count": 0},
    {"date": "2023-10-01", "status": "Approved", "count": 0},
    {"date": "2023-10-01", "status": "Awaiting Action", "count": 0},
    {"date": "2023-10-01", "status": "Declined", "count": 0},
    {"date": "2023-11-01", "status": "Approved", "count": 0},
  ];*/

  DateTime end = DateTime.parse(endDate);
  DateTime start = DateTime(end.year - 1, end.month, end.day);
  int monthsInRange = 12;

  // Initialize monthlySales for each month in the range
  Map<int, Map<String, double>> monthlySales = {
    for (var i = 0; i < monthsInRange; i++)
      DateTime(end.year, end.month - i, 1).month: {}
  };

  for (var reprintItem in jsonData) {
    if (reprintItem is Map<String, dynamic>) {
      DateTime paymentDate = DateTime.parse(reprintItem['date'] + "-01");
      if (paymentDate.isAfter(start) &&
          paymentDate.isBefore(end.add(const Duration(days: 1)))) {
        int monthIndex = paymentDate.month;
        String type = reprintItem["status"];
        double count = reprintItem["count"].toDouble();
        if (count > 0) {
          contains_data = true;
        }

        monthlySales.putIfAbsent(monthIndex, () => {});
        monthlySales[monthIndex]
            ?.update(type, (value) => value + count, ifAbsent: () => count);
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

  List<BarChartGroupData> reprintsGroupedData = [];
  monthlySales.forEach((monthIndex, salesData) {
    //print("aaxdss $monthIndex $salesData");
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];
    var sortedSalesData = sortReprintCancellationsData(salesData);

    sortedSalesData.forEach((entry) {
      String type = entry.key;
      double amount = entry.value;
      Color color;

      switch (type) {
        case 'Approved':
          color = Colors.green;
          break;
        case 'Expired':
          color = Colors.blue;
          break;
        case 'Declined':
          color = Colors.blue;
          break;
        case 'Awaiting Action':
          color = Colors.orange;
          break;
        default:
          color = Colors.grey;
      }

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, color));
      cumulativeAmount += amount;
    });
    rodStackItems.sort(
        (a, b) => (colorOrder[a.color] ?? 0).compareTo(colorOrder[b.color] ?? 0));
    rodStackItems = rodStackItems.reversed.toList();
    print(rodStackItems);
    print("monthIndex $monthIndex ${cumulativeAmount}");

    reprintsGroupedData.add(BarChartGroupData(
      x: monthIndex,
      barRods: [
        BarChartRodData(
          toY: cumulativeAmount,
          rodStackItems: rodStackItems.isEmpty
              ? [BarChartRodStackItem(0, 0, Colors.transparent)]
              : rodStackItems,
          borderRadius: BorderRadius.zero,
          width: (Constants.screenWidth / 12) - 9.1,
        ),
      ],
      barsSpace: barsSpace,
    ));
  });

  if (contains_data == false) {
    return [];
  } else {
    return reprintsGroupedData;
  }
}

List<BarChartGroupData> processDataForReprintsDaily3(
    String jsonString, String startDate, String endDate, BuildContext context) {
  List<dynamic> jsonData =
      jsonDecode(jsonString)["cancellations_total_counts_by_date"] ?? [];

  DateTime start = DateTime.parse(startDate);
  DateTime end = start.add(Duration(days: 30));

  // Create a map for each day in the 31-day range
  Map<int, Map<String, double>> dailySales = {
    for (var i = 0; i < 31; i++) i: {}
  };

  for (var collectionItem in jsonData) {
    if (collectionItem is Map<String, dynamic>) {
      DateTime paymentDate = DateTime.parse(collectionItem['date']);
      if (paymentDate.isAfter(start.subtract(const Duration(days: 1))) &&
          paymentDate.isBefore(end.add(const Duration(days: 1)))) {
        int dayIndex = paymentDate.difference(start).inDays;
        String collectionType = collectionItem["status"];
        double premium = collectionItem["count"].toDouble();

        dailySales[dayIndex]!.update(collectionType, (value) => value + premium,
            ifAbsent: () => premium);
      }
    }
  }

  List<BarChartGroupData> collectionsGroupedData = [];
  dailySales.forEach((dayIndex, salesData) {
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    var sortedSalesData = sortReprintCancellationsData(salesData);

    sortedSalesData.forEach((entry) {
      String type = entry.key;
      double amount = entry.value;
      Color color;

      switch (type) {
        case 'Approved':
          color = Colors.green;
          break;
        case 'Declined':
          color = Colors.blue;
          break;
        case 'Expired':
          color = Colors.blue;
          break;
        case 'Awaiting Action':
          color = Colors.orange;
          break;
        default:
          color = Colors.grey;
      }

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, color));
      cumulativeAmount += amount;
    });
    rodStackItems.sort(
        (a, b) => (colorOrder[a.color] ?? 0).compareTo(colorOrder[b.color] ?? 0));
    rodStackItems = rodStackItems.reversed.toList();
    print(rodStackItems);

    DateTime barDate = start.add(Duration(days: dayIndex));
    int dayOfMonth = barDate.day;
    int numberOfBars = dailySales.length;
    double chartWidth = MediaQuery.of(context).size.width;
    double maxBarWidth = 30; // Maximum width of a bar
    double minBarSpace = 4; // Minimum space between bars

    double barWidth = min(maxBarWidth, (chartWidth / (2 * numberOfBars))) + 2;
    double barsSpace = max(minBarSpace,
        (chartWidth - (barWidth * numberOfBars)) / (numberOfBars - 1));
    //print("barWidth $barWidth");
    //print("barWidth $barsSpace");

    // Add a bar for each day in the range
    collectionsGroupedData.add(BarChartGroupData(
      x: dayOfMonth, // Or use dayIndex if you prefer
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
      barsSpace: barsSpace,
    ));
  });

  return collectionsGroupedData;
}

List<BarChartGroupData> processDataForReprintsDaily3_1(
    String jsonString, String startDate, String endDate, BuildContext context) {
  List<dynamic> jsonData =
      jsonDecode(jsonString)["reprints_total_counts_by_date"] ?? [];

  DateTime start = DateTime.parse(startDate);
  DateTime end = start.add(Duration(days: 30));

  // Create a map for each day in the 31-day range
  Map<int, Map<String, double>> dailySales = {
    for (var i = 0; i < 31; i++) i: {}
  };

  for (var collectionItem in jsonData) {
    if (collectionItem is Map<String, dynamic>) {
      DateTime paymentDate = DateTime.parse(collectionItem['date']);
      if (paymentDate.isAfter(start.subtract(const Duration(days: 1))) &&
          paymentDate.isBefore(end.add(const Duration(days: 1)))) {
        int dayIndex = paymentDate.difference(start).inDays;
        String collectionType = collectionItem["status"];
        double premium = collectionItem["count"].toDouble();

        dailySales[dayIndex]!.update(collectionType, (value) => value + premium,
            ifAbsent: () => premium);
      }
    }
  }

  List<BarChartGroupData> collectionsGroupedData = [];
  dailySales.forEach((dayIndex, salesData) {
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    var sortedSalesData = sortReprintCancellationsData(salesData);

    sortedSalesData.forEach((entry) {
      String type = entry.key;
      double amount = entry.value;
      Color color;

      switch (type) {
        case 'Approved':
          color = Colors.green;
          break;
        case 'Declined':
          color = Colors.blue;
          break;
        case 'Expired':
          color = Colors.blue;
          break;
        case 'Awaiting Action':
          color = Colors.orange;
          break;
        default:
          color = Colors.grey;
      }

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, color));
      cumulativeAmount += amount;
    });
    rodStackItems.sort(
        (a, b) => (colorOrder[a.color] ?? 0).compareTo(colorOrder[b.color] ?? 0));
    rodStackItems = rodStackItems.reversed.toList();
    print(rodStackItems);

    DateTime barDate = start.add(Duration(days: dayIndex));
    int dayOfMonth = barDate.day;
    int numberOfBars = dailySales.length;
    double chartWidth = MediaQuery.of(context).size.width;
    double maxBarWidth = 30; // Maximum width of a bar
    double minBarSpace = 4; // Minimum space between bars

    double barWidth = min(maxBarWidth, (chartWidth / (2 * numberOfBars))) + 2;
    double barsSpace = max(minBarSpace,
        (chartWidth - (barWidth * numberOfBars)) / (numberOfBars - 1));
    //print("barWidth $barWidth");
    //print("barWidth $barsSpace");

    // Add a bar for each day in the range
    collectionsGroupedData.add(BarChartGroupData(
      x: dayOfMonth, // Or use dayIndex if you prefer
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
      barsSpace: barsSpace,
    ));
  });

  return collectionsGroupedData;
}

List<BarChartGroupData> processDataForReprintsCountMonthly4(
    String jsonString, String startDate, String endDate, BuildContext context) {
  List<dynamic> jsonData =
      jsonDecode(jsonString)["cancellations_total_counts_by_date"];
  print("dsjkkjdssdjds0 ${jsonData}");

  bool contains_data = false;

  DateTime end = DateTime.parse(endDate);
  DateTime start = DateTime(end.year - 1, end.month, end.day);
  int monthsInRange = 12;

  Map<int, Map<String, double>> monthlySales = {
    for (var i = 0; i < monthsInRange; i++)
      DateTime(end.year, end.month - i, 1).month: {}
  };

  for (var reprintItem in jsonData) {
    if (reprintItem is Map<String, dynamic>) {
      print("dsjkkjdssdjds ${reprintItem['date'] + "-01"}");
      DateTime paymentDate = DateTime.parse(reprintItem['date'] + "-01");

      int monthIndex = paymentDate.month;
      String type = reprintItem["status"];
      double count = reprintItem["count"].toDouble();
      if (count > 0) {
        contains_data = true;
      }

      monthlySales.putIfAbsent(monthIndex, () => {});
      monthlySales[monthIndex]
          ?.update(type, (value) => value + count, ifAbsent: () => count);
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
  double chartWidth = MediaQuery.of(context).size.width;
  double maxBarWidth = 30; // Maximum width of a bar
  double minBarSpace = 4; // Minimum space between bars

  double barWidth = min(maxBarWidth, (chartWidth / (2 * numberOfBars)));
  double barsSpace = max(minBarSpace,
      (chartWidth - (barWidth * numberOfBars)) / (numberOfBars - 1));

  List<BarChartGroupData> reprintsGroupedData = [];
  monthlySales.forEach((monthIndex, salesData) {
    //print("aaxdss $monthIndex $salesData");
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];
    var sortedSalesData = sortReprintCancellationsData(salesData);

    sortedSalesData.forEach((entry) {
      String type = entry.key;
      double amount = entry.value;
      Color color;

      switch (type) {
        case 'Approved':
          color = Colors.green;
          break;
        case 'Expired':
          color = Colors.blue;
          break;
        case 'Declined':
          color = Colors.blue;
          break;
        case 'Awaiting Action':
          color = Colors.orange;
          break;
        default:
          color = Colors.grey;
      }

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, color));
      cumulativeAmount += amount;
    });
    rodStackItems.sort(
        (a, b) => (colorOrder[a.color] ?? 0).compareTo(colorOrder[b.color] ?? 0));
    rodStackItems = rodStackItems.reversed.toList();
    print(rodStackItems);

    reprintsGroupedData.add(BarChartGroupData(
      x: monthIndex,
      barRods: [
        BarChartRodData(
          toY: cumulativeAmount,
          rodStackItems: rodStackItems.isEmpty
              ? [BarChartRodStackItem(0, 0, Colors.transparent)]
              : rodStackItems,
          borderRadius: BorderRadius.zero,
          width: (Constants.screenWidth / 12) - 9.1,
        ),
      ],
      barsSpace: barsSpace,
    ));
  });

  if (contains_data == false) {
    return [];
  } else {
    return reprintsGroupedData;
  }
}

List<BarChartGroupData> processDataForReprintsCountMonthly4_1(
    String jsonString, String startDate, String endDate, BuildContext context) {
  bool contains_data = false;
  print("aaxdsgjjhjs $startDate $endDate");
  List<dynamic> jsonData =
      jsonDecode(jsonString)["reprints_total_counts_by_date"];
  if (jsonData == null || jsonData.isEmpty) {
    return [];
  }
/*  jsonData = [
    {"date": "2023-01-01", "status": "Approved", "count": 20},
    {"date": "2023-01-01", "status": "Awaiting Action", "count": 10},
    {"date": "2023-01-01", "status": "Declined", "count": 14},
    {"date": "2023-02-01", "status": "Approved", "count": 10},
    {"date": "2023-02-01", "status": "Awaiting Action", "count": 60},
    {"date": "2023-02-01", "status": "Declined", "count": 10},
    {"date": "2023-03-01", "status": "Approved", "count": 10},
    {"date": "2023-03-01", "status": "Awaiting Action", "count": 5},
    {"date": "2023-03-01", "status": "Declined", "count": 8},
    {"date": "2023-04-01", "status": "Approved", "count": 12},
    {"date": "2023-04-01", "status": "Awaiting Action", "count": 0},
    {"date": "2023-04-01", "status": "Declined", "count": 0},
    {"date": "2023-05-01", "status": "Approved", "count": 0},
    {"date": "2023-05-01", "status": "Awaiting Action", "count": 0},
    {"date": "2023-05-01", "status": "Declined", "count": 0},
    {"date": "2023-06-01", "status": "Approved", "count": 0},
    {"date": "2023-06-01", "status": "Awaiting Action", "count": 0},
    {"date": "2023-06-01", "status": "Declined", "count": 0},
    {"date": "2023-07-01", "status": "Approved", "count": 0},
    {"date": "2023-07-01", "status": "Awaiting Action", "count": 0},
    {"date": "2023-07-01", "status": "Declined", "count": 0},
    {"date": "2023-08-01", "status": "Approved", "count": 0},
    {"date": "2023-08-01", "status": "Awaiting Action", "count": 0},
    {"date": "2023-08-01", "status": "Declined", "count": 0},
    {"date": "2023-09-01", "status": "Approved", "count": 0},
    {"date": "2023-09-01", "status": "Awaiting Action", "count": 0},
    {"date": "2023-09-01", "status": "Declined", "count": 0},
    {"date": "2023-10-01", "status": "Approved", "count": 0},
    {"date": "2023-10-01", "status": "Awaiting Action", "count": 0},
    {"date": "2023-10-01", "status": "Declined", "count": 0},
    {"date": "2023-11-01", "status": "Approved", "count": 0},
  ];*/

  DateTime end = DateTime.parse(endDate);
  DateTime start = DateTime(end.year - 1, end.month, end.day);
  int monthsInRange = 12;

  // Initialize monthlySales for each month in the range
  Map<int, Map<String, double>> monthlySales = {
    for (var i = 0; i < monthsInRange; i++)
      DateTime(end.year, end.month - i, 1).month: {}
  };

  for (var reprintItem in jsonData) {
    if (reprintItem is Map<String, dynamic>) {
      DateTime paymentDate = DateTime.parse(reprintItem['date'] + "-01");
      //print("hghghg ${reprintItem['date']} ${reprintItem["count"].toDouble()}");

      int monthIndex = paymentDate.month;
      String type = reprintItem["status"];
      double count = reprintItem["count"].toDouble();
      if (count > 0) {
        contains_data = true;
      }

      monthlySales.putIfAbsent(monthIndex, () => {});
      monthlySales[monthIndex]
          ?.update(type, (value) => value + count, ifAbsent: () => count);
      // print("aaxdsshgggf2 $monthIndex $count");
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
  double chartWidth = MediaQuery.of(context).size.width;
  double maxBarWidth = 30; // Maximum width of a bar
  double minBarSpace = 4; // Minimum space between bars

  double barWidth = min(maxBarWidth, (chartWidth / (2 * numberOfBars)));
  double barsSpace = max(minBarSpace,
      (chartWidth - (barWidth * numberOfBars)) / (numberOfBars - 1));

  List<BarChartGroupData> reprintsGroupedData = [];
  monthlySales.forEach((monthIndex, salesData) {
    //print("aaxdss $monthIndex $salesData");
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];
    var sortedSalesData = sortReprintCancellationsData(salesData);

    sortedSalesData.forEach((entry) {
      String type = entry.key;
      double amount = entry.value;
      Color color;

      switch (type) {
        case 'Approved':
          color = Colors.green;
          break;
        case 'Expired':
          color = Colors.blue;
          break;
        case 'Declined':
          color = Colors.blue;
          break;
        case 'Awaiting Action':
          color = Colors.orange;
          break;
        default:
          color = Colors.grey;
      }

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, color));
      cumulativeAmount += amount;
    });
    rodStackItems.sort(
        (a, b) => (colorOrder[a.color] ?? 0).compareTo(colorOrder[b.color] ?? 0));
    rodStackItems = rodStackItems.reversed.toList();
    print(rodStackItems);

    reprintsGroupedData.add(BarChartGroupData(
      x: monthIndex,
      barRods: [
        BarChartRodData(
          toY: cumulativeAmount,
          rodStackItems: rodStackItems.isEmpty
              ? [BarChartRodStackItem(0, 0, Colors.transparent)]
              : rodStackItems,
          borderRadius: BorderRadius.zero,
          width: (Constants.screenWidth / 12) - 9.1,
        ),
      ],
      barsSpace: barsSpace,
    ));
  });

  if (contains_data == false) {
    return [];
  } else {
    return reprintsGroupedData;
  }
}

List<BarChartGroupData> processDataForReprintsCountDaily2(
    String jsonString, String startDate, String endDate) {
  List<dynamic> jsonData = jsonDecode(jsonString)["message"];
  bool contains_data = false;

  DateTime start = DateTime.parse(startDate);
  DateTime end = DateTime.parse(endDate);
  int daysInRange = end.difference(start).inDays;

  Map<int, Map<String, double>> dailySales = {
    for (var i = 0; i <= daysInRange; i++) i: {}
  };

  for (var reprintItem in jsonData) {
    if (reprintItem is Map<String, dynamic>) {
      DateTime paymentDate = DateTime.parse(reprintItem['date']);
      if (paymentDate.isAfter(start.subtract(const Duration(days: 1))) &&
          paymentDate.isBefore(end.add(const Duration(days: 1)))) {
        int dayIndex = paymentDate.difference(start).inDays;
        String type = reprintItem["status"];
        double count = reprintItem["count"];
        if (count > 0) {
          contains_data = true;
        }

        dailySales[dayIndex]!
            .update(type, (value) => value + count, ifAbsent: () => count);
      }
    }
  }

  List<BarChartGroupData> reprintsGroupedData = [];
  dailySales.forEach((dayIndex, salesData) {
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    var sortedSalesData = sortReprintCancellationsData(salesData);

    sortedSalesData.forEach((entry) {
      String type = entry.key;
      double amount = entry.value;
      Color color;

      switch (type) {
        case 'Approved':
          color = Colors.green;
          break;
        case 'Expired':
          color = Colors.blue;
          break;
        case 'Declined':
          color = Colors.blue;
          break;
        case 'Awaiting Action':
          color = Colors.orange;
          break;
        default:
          color = Colors.grey;
      }

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, color));
      cumulativeAmount += amount;
    });
    rodStackItems.sort(
        (a, b) => (colorOrder[a.color] ?? 0).compareTo(colorOrder[b.color] ?? 0));
    rodStackItems = rodStackItems.reversed.toList();
    print(rodStackItems);

    DateTime barDate = start.add(Duration(days: dayIndex));
    int dayOfMonth = barDate.day;

    reprintsGroupedData.add(BarChartGroupData(
      x: dayOfMonth, // Or use dayIndex if you prefer
      barRods: [
        BarChartRodData(
            toY: cumulativeAmount,
            rodStackItems: rodStackItems.isEmpty
                ? [BarChartRodStackItem(0, 0, Colors.transparent)]
                : rodStackItems,
            borderRadius: BorderRadius.zero,
            width: (Constants.screenWidth / daysInRange) - 3.3),
      ],
    ));
  });

  if (contains_data == false) {
    return [];
  } else {
    return reprintsGroupedData;
  }
}

List<MapEntry<String, double>> sortReprintCancellationsData(
    Map<String, double> salesData) {
  Map<String, Color> typeToColor = {
    'Approved': Colors.green,
    'Declined': Colors.blue,
    'Expired': Colors.blue,
    'Awaiting Action': Colors.green,
    'Other': Colors.grey,
  };

  Map<Color, int> colorOrder = {
    Colors.green: 1,
    Colors.blue: 2,
    Colors.orange: 3,
    Colors.grey: 4,
  };

  var entries = salesData.entries.toList();

  entries.sort((a, b) {
    Color colorA =
        typeToColor[a.key] ?? Colors.grey; // Default to grey if not found
    Color colorB =
        typeToColor[b.key] ?? Colors.grey; // Default to grey if not found
    return (colorOrder[colorA] ?? 0).compareTo(colorOrder[colorB] ?? 0);
  });

  return entries;
}
