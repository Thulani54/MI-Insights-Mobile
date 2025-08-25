import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mi_insights/screens/Reports/CommsReport.dart';

import '../constants/Constants.dart';
import '../customwidgets/custom_treemap/pages/tree_diagram.dart';
import '../models/commsgridmodel.dart';
import '../utils/login_utils.dart';

Future<void> getCommsReport(String date_from, String date_to,
    int selectedButton1, int days_difference, BuildContext context) async {
  String baseUrl =
      '${Constants.analitixAppBaseUrl}sales/view_normalized_comms_data/';

  if (hasTemporaryTesterRole(Constants.myUserRoles)) {
    baseUrl =
        '${Constants.analitixAppBaseUrl}sales/view_normalized_comms_data_test/';
  } else {
    baseUrl =
        '${Constants.analitixAppBaseUrl}sales/view_normalized_comms_data/';
  }
  print("rgtghg ${baseUrl}");
  Map<String, String>? payload = {
    "client_id": Constants.cec_client_id.toString(),
    "start_date": date_from,
    "end_date": date_to
  };
  try {
    if (selectedButton1 == 1) {
      isLoadingFullfilment1a = true;
    } else if (selectedButton1 == 2) {
      isLoadingFullfilment2a = true;
    } else if (selectedButton1 == 3) {
      isLoadingFullfilment3a = true;
    }
    if (selectedButton1 == 1) {
      Constants.comms_sectionsList1a = [
        commsgridmodel("Total Issued", 0, 0),
        commsgridmodel("Delivered", 0, 0),
        commsgridmodel("Undelivered", 0, 0),
      ];
      Constants.comms_sectionsList1a_a = [
        commsgridmodel("Delivered", 0, 0),
        commsgridmodel("Undelivered", 0, 0),
        commsgridmodel("Expired", 0, 0),
        commsgridmodel("Blacklisted", 0, 0),
        commsgridmodel("Submitted", 0, 0),
        commsgridmodel("Cancelled", 0, 0),
      ];
    } else if (selectedButton1 == 2) {
      Constants.comms_sectionsList2a = [
        commsgridmodel("Total Issued", 0, 0),
        commsgridmodel("Delivered", 0, 0),
        commsgridmodel("Undelivered", 0, 0),
      ];
      Constants.comms_sectionsList2a_a = [
        commsgridmodel("Delivered", 0, 0),
        commsgridmodel("Undelivered", 0, 0),
        commsgridmodel("Expired", 0, 0),
        commsgridmodel("Blacklisted", 0, 0),
        commsgridmodel("Submitted", 0, 0),
        commsgridmodel("Cancelled", 0, 0),
      ];
    } else if (selectedButton1 == 3) {
      Constants.comms_sectionsList3a = [
        commsgridmodel("Total Issued", 0, 0),
        commsgridmodel("Delivered", 0, 0),
        commsgridmodel("Undelivered", 0, 0),
      ];
      Constants.comms_sectionsList3a_a = [
        commsgridmodel("Delivered", 0, 0),
        commsgridmodel("Undelivered", 0, 0),
        commsgridmodel("Expired", 0, 0),
        commsgridmodel("Blacklisted", 0, 0),
        commsgridmodel("Submitted", 0, 0),
        commsgridmodel("Cancelled", 0, 0),
      ];
    }
    commsValue.value++;

    await http
        .post(
            Uri.parse(
              baseUrl,
            ),
            body: payload)
        .then((value) {
      http.Response response = value;
      if (kDebugMode) {
        print("rgtghg0 ${response.body}");
      }
      if (response.statusCode != 200) {
        if (selectedButton1 == 1) {
          isLoadingFullfilment1a = false;
          Constants.comms_sectionsList1a = [
            commsgridmodel("Total Issued", 0, 0),
            commsgridmodel("Delivered", 0, 0),
            commsgridmodel("Undelivered", 0, 0),
          ];
          Constants.comms_sectionsList1a_a = [
            commsgridmodel("Delivered", 0, 0),
            commsgridmodel("Undelivered", 0, 0),
            commsgridmodel("Expired", 0, 0),
            commsgridmodel("Blacklisted", 0, 0),
            commsgridmodel("Submitted", 0, 0),
            commsgridmodel("Cancelled", 0, 0),
          ];
        } else if (selectedButton1 == 2) {
          isLoadingFullfilment2a = false;
          Constants.comms_sectionsList2a = [
            commsgridmodel("Total Issued", 0, 0),
            commsgridmodel("Delivered", 0, 0),
            commsgridmodel("Undelivered", 0, 0),
          ];
          Constants.comms_sectionsList2a_a = [
            commsgridmodel("Delivered", 0, 0),
            commsgridmodel("Undelivered", 0, 0),
            commsgridmodel("Expired", 0, 0),
            commsgridmodel("Blacklisted", 0, 0),
            commsgridmodel("Submitted", 0, 0),
            commsgridmodel("Cancelled", 0, 0),
          ];
        } else if (selectedButton1 == 3) {
          isLoadingFullfilment3a = false;
          Constants.comms_sectionsList3a = [
            commsgridmodel("Total Issued", 0, 0),
            commsgridmodel("Delivered", 0, 0),
            commsgridmodel("Undelivered", 0, 0),
          ];
          Constants.comms_sectionsList3a_a = [
            commsgridmodel("Delivered", 0, 0),
            commsgridmodel("Undelivered", 0, 0),
            commsgridmodel("Expired", 0, 0),
            commsgridmodel("Blacklisted", 0, 0),
            commsgridmodel("Submitted", 0, 0),
            commsgridmodel("Cancelled", 0, 0),
          ];
        }
        commsValue.value++;
      } else {
        Constants.comms_barData = [];
        Constants.comms_bottomTitles2a = [];
        Map<int, int> dailyCommsCount = {};
        Map<int, int> dailyCommsCount1b = {};
        Map<int, int> dailyCommsCount1c = {};
        Map<int, int> dailyCommsCount3a = {};
        Map<int, int> dailyCommsCount3b = {};
        Map<int, int> dailyCommsCount3c = {};
        Map<int, int> monthlyCommsCount2a = {};
        Map<int, int> monthlyCommsCount2b = {};
        Map<int, int> monthlyCommsCount2c = {};

        Map<int, int> monthlyCommsCount3a = {};
        Map<int, int> monthlyCommsCount3b = {};
        Map<int, int> monthlyCommsCount3c = {};
        int monthlyTotal = 0;

        var jsonResponse = jsonDecode(response.body);
        //  if (selectedButton1 == 1) Constants.jsonMonthlyCommsData1 = jsonResponse;

        if (kDebugMode) {
          print(
              "formattedStartDate2aia ${date_from} formattedStartDate2aia ${date_to}");
        }

        if (kDebugMode) {
          //print(jsonResponse);
        }
        if (jsonResponse is Map) {
          if (selectedButton1 == 1) {
            isLoadingFullfilment1a = false;
            commsValue.value++;
            Constants.comms_salesbyagent1a = [];
            Constants.comms_bottomTitles1a = [];
            Constants.comms_maxY5a = 0;
            Constants.comms_sectionsList1a = [];

            Constants.comms_sectionsList1a = [
              commsgridmodel("Total Issued", 0, 0),
              commsgridmodel("Delivered", 0, 0),
              commsgridmodel("Undelivered", 0, 0),
            ];
            Constants.comms_sectionsList1a_a = [
              commsgridmodel("Delivered", 0, 0),
              commsgridmodel("Undelivered", 0, 0),
              commsgridmodel("Expired", 0, 0),
              commsgridmodel("Blacklisted", 0, 0),
              commsgridmodel("Submitted", 0, 0),
              commsgridmodel("Cancelled", 0, 0),
            ];
            Constants.comms_sectionsList1a_b = [
              commsgridmodel("Delivered", 0, 0),
              commsgridmodel("Undelivered", 0, 0),
              commsgridmodel("Expired", 0, 0),
              commsgridmodel("Blacklisted", 0, 0),
              commsgridmodel("Submitted", 0, 0),
              commsgridmodel("Cancelled", 0, 0),
            ];
            Constants.comms_sectionsList1a_c = [
              commsgridmodel("Delivered", 0, 0),
              commsgridmodel("Undelivered", 0, 0),
              commsgridmodel("Expired", 0, 0),
              commsgridmodel("Blacklisted", 0, 0),
              commsgridmodel("Submitted", 0, 0),
              commsgridmodel("Cancelled", 0, 0),
            ];
            Constants.comms_sectionsList_1_1a = [
              commsgridmodel("Sales", 0, 0),
              commsgridmodel("Collections", 0, 0),
              commsgridmodel("Maintenence", 0, 0),
              // commsgridmodel("FSCA Remedial", 0, 0),
            ];

            Constants.comms_sectionsList_3_1a = [
              //   commsgridmodel("FSCA Remedial", 0, 0),
            ];
            if (jsonResponse["amounts_by_delivery"] == null) {
              Constants.comms_sectionsList1a = [
                commsgridmodel("Total Issued", 0, 0),
                commsgridmodel("Delivered", 0, 0),
                commsgridmodel("Undelivered", 0, 0),
              ];
            } else {
              Constants.comms_sectionsList1a[0].amount =
                  jsonResponse["amounts_by_delivery"]["TOTAL"]["Count"];
              Constants.comms_sectionsList1a[1].amount =
                  jsonResponse["amounts_by_delivery"]["DELIVERED"]["Count"];
              Constants.comms_sectionsList1a[2].amount =
                  jsonResponse["amounts_by_delivery"]["UNDELIVERED"]["Count"];
              if (jsonResponse["amounts_by_delivery"]["DELIVERED"]["Count"] >
                  0) {
                Constants.percentage_delivered1a =
                    (jsonResponse["amounts_by_delivery"]["DELIVERED"]
                            ["Count"]) /
                        (jsonResponse["amounts_by_delivery"]["TOTAL"]["Count"]);
              }
            }
            var deliveredData = calculateCountsAndPercentages(
                Map<String, dynamic>.from(jsonResponse), "DELIVRD");
            int delivered_count1a = deliveredData["count"];
            double delivery_percentage1a = deliveredData["percentage"];

            var undeliveredData = calculateCountsAndPercentages(
                Map<String, dynamic>.from(jsonResponse), "UNDELIV");
            int udelivered_count1a = undeliveredData["count"];
            double udelivered_percentagea = undeliveredData["percentage"];

            var expiredData = calculateCountsAndPercentages(
                Map<String, dynamic>.from(jsonResponse), "EXPIRED");
            int expired_count1a = expiredData["count"];
            double expired_percentage1a = expiredData["percentage"];
            var blacklistedData = calculateCountsAndPercentages(
                Map<String, dynamic>.from(jsonResponse), "BLIST");
            int blacklisted_count1a = blacklistedData["count"];
            double blacklisted_percentage1a =
                blacklistedData["percentage"] ?? 0.00;
            int submitted_count1a = 0;
            double submitted_percentage1a = 0.0;
            if (jsonResponse["comms_amounts"] != null) {
              submitted_count1a =
                  jsonResponse["comms_amounts"]["SUBMITD"] == null
                      ? 0
                      : (jsonResponse["comms_amounts"]["STAGED"]["Count"] ?? 0)
                          .toInt();
              submitted_percentage1a =
                  jsonResponse["comms_amounts"]["SUBMITD"] == null
                      ? 0
                      : jsonResponse["comms_amounts"]["SUBMITD"]
                              ["Percentage"] ??
                          0 +
                              jsonResponse["comms_amounts"]["STAGED"]
                                  ["Percentage"] ??
                          0;
            }

            int cancelled_count1a =
                jsonResponse["comms_amounts"]["CANCELLED"] == null
                    ? 0
                    : jsonResponse["comms_amounts"]["CANCELLED"]["Count"] ??
                        0 + jsonResponse["comms_amounts"]["NOROUTE"]["Count"] ??
                        0;
            double cancelled_percentage1a =
                jsonResponse["comms_amounts"]["CANCELLED"] == null
                    ? 0
                    : jsonResponse["comms_amounts"]["CANCELLED"]
                            ["Percentage"] ??
                        0 +
                            jsonResponse["comms_amounts"]["NOROUTE"]
                                ["Percentage"] ??
                        0;

            int sales_module_count1a =
                jsonResponse["counts_by_module"]["Sales Module"] ?? 0;

            int collections_module_count =
                jsonResponse["counts_by_module"]["Collections Module"] ?? 0;

            int maintenace_module_count =
                jsonResponse["counts_by_module"]["Maintenance Module"] ?? 0;
            int fsca_remedial_module_count =
                jsonResponse["counts_by_module"]["FSCA Remedial"] ?? 0;
            int total_counts = sales_module_count1a +
                collections_module_count +
                maintenace_module_count;

            double sales_module_percentage = 0.0;
            if (sales_module_count1a != 0) {
              sales_module_percentage = sales_module_count1a / total_counts;
            }
            double collections_module_percentage = 0.0;
            if (collections_module_count != 0 && total_counts != 0) {
              collections_module_percentage =
                  collections_module_count.toDouble() / total_counts.toDouble();
            }
            double maintenace_module_percentage = 0.0;
            if (maintenace_module_count != 0 && total_counts != 0) {
              maintenace_module_percentage =
                  maintenace_module_count.toDouble() / total_counts.toDouble();
            }

            //1b
            int delivered_count1b =
                (jsonResponse["comms_amounts"]["DELIVRD"]["Count"] ?? 0)
                    .toInt();
            double delivery_percentage1b =
                (jsonResponse["comms_amounts"]["DELIVRD"]["Percentage"] ?? 0.0)
                    .toDouble();
            //print("delivered_count1b $delivered_count1b");
            //print("delivery_percentage1b $delivery_percentage1b");
            int udelivered_count1b =
                (jsonResponse["comms_amounts"]["UNDELIV"]["Count"] ?? 0)
                    .toInt();
            double udelivered_percentageb =
                (jsonResponse["comms_amounts"]["UNDELIV"]["Percentage"] ?? 0.0)
                    .toDouble();
            //print("delivery_percentage1a $udelivered_percentagea");
            int expired_count1b =
                (jsonResponse["comms_amounts"]["EXPIRED"]["Count"] ?? 0)
                    .toInt();
            double expired_percentage1b =
                (jsonResponse["comms_amounts"]["EXPIRED"]["Percentage"] ?? 0.0)
                    .toDouble();
            int blacklisted_count1b =
                (jsonResponse["comms_amounts"]["BLIST"]["Count"] ?? 0).toInt();
            double blacklisted_percentage1b =
                (jsonResponse["comms_amounts"]["BLIST"]["Percentage"] ?? 0.0)
                    .toDouble();
            int submitted_count1b =
                jsonResponse["comms_amounts"]["SUBMITD"] == null
                    ? 0
                    : (jsonResponse["comms_amounts"]["STAGED"]["Count"] ?? 0)
                        .toInt();
            double submitted_percentage1b =
                jsonResponse["comms_amounts"]["SUBMITD"] == null
                    ? 0.0
                    : (jsonResponse["comms_amounts"]["SUBMITD"]["Percentage"] ??
                                0.0)
                            .toDouble() +
                        (jsonResponse["comms_amounts"]["STAGED"]
                                    ["Percentage"] ??
                                0.0)
                            .toDouble();
            int cancelled_count1b = jsonResponse["comms_amounts"]["CANCELLED"]
                    ["Count"] ??
                0 + jsonResponse["comms_amounts"]["NOROUTE"]["Count"] ??
                0;
            double cancelled_percentage1b = jsonResponse["comms_amounts"]
                    ["CANCELLED"]["Percentage"] ??
                0 + jsonResponse["comms_amounts"]["NOROUTE"]["Percentage"] ??
                0;
            //1c
            int delivered_count1c =
                (jsonResponse["fsca_counts"]["DELIVRD"]["Count"] ?? 0).toInt();
            double delivery_percentage1c = double.parse(
                (jsonResponse["fsca_counts"]["DELIVRD"]["Percentage"] ?? 0)
                    .toString());
            //print("delivery_percentage1a $delivery_percentage1a");
            int udelivered_count1c =
                (jsonResponse["fsca_counts"]["UNDELIV"]["Count"] ?? 0).toInt();
            double udelivered_percentagec = double.parse(
                (jsonResponse["fsca_counts"]["UNDELIV"]["Percentage"] ?? 0)
                    .toString());
            //print("delivery_percentage1a $udelivered_percentagea");
            int expired_count1c =
                (jsonResponse["fsca_counts"]["EXPIRED"]["Count"] ?? 0).toInt();
            double expired_percentage1c =
                (jsonResponse["comms_amounts"]["EXPIRED"]["Percentage"] ?? 0.0)
                    .toDouble();
            int blacklisted_count1c =
                (jsonResponse["fsca_counts"]["BLIST"]["Count"] ?? 0).toInt();
            double blacklisted_percentage1c =
                (jsonResponse["fsca_counts"]["BLIST"]["Percentage"] ?? 0.0)
                    .toDouble();
            int submitted_count1c =
                (jsonResponse["fsca_counts"]["STAGED"]["Count"] ?? 0).toInt();
            double submitted_percentage1c =
                (jsonResponse["fsca_counts"]["SUBMITD"]["Percentage"] ?? 0.0)
                        .toDouble() +
                    (jsonResponse["fsca_counts"]["STAGED"]["Percentage"] ?? 0.0)
                        .toDouble();
            int cancelled_count1c = jsonResponse["fsca_counts"]["CANCELLED"]
                    ["Count"] ??
                0 + jsonResponse["comms_amounts"]["NOROUTE"]["Count"] ??
                0;
            double cancelled_percentage1c = (jsonResponse["comms_amounts"]
                            ["CANCELLED"]["Percentage"] ??
                        0.0)
                    .toDouble() +
                (jsonResponse["comms_amounts"]["NOROUTE"]["Percentage"] ?? 0.0)
                    .toDouble();

            Constants.comms_sectionsList_1_1a[0].amount = sales_module_count1a;
            Constants.comms_sectionsList_1_1a[0].percentage =
                sales_module_percentage * 100;
            Constants.comms_sectionsList_1_1a[1].amount =
                collections_module_count;
            Constants.comms_sectionsList_1_1a[1].percentage =
                collections_module_percentage * 100;
            Constants.comms_sectionsList_1_1a[2].amount =
                maintenace_module_count;
            Constants.comms_sectionsList_1_1a[2].percentage =
                maintenace_module_percentage * 100;
            // Constants.comms_sectionsList_1_1a[3].amount =
            //     fsca_remedial_module_count;
            // Constants.comms_sectionsList_1_1a[3].percentage =
            //     fsca_remedial_percentage * 100;

            Constants.comms_sectionsList_1_1a[0].amount = sales_module_count1a;
            Constants.comms_sectionsList_1_1a[0].percentage =
                sales_module_percentage * 100;
            Constants.comms_sectionsList_1_1a[1].amount =
                collections_module_count;
            Constants.comms_sectionsList_1_1a[1].percentage =
                collections_module_percentage * 100;
            Constants.comms_sectionsList_1_1a[2].amount =
                maintenace_module_count;
            Constants.comms_sectionsList_1_1a[2].percentage =
                maintenace_module_percentage * 100;
            // Constants.comms_sectionsList_3_1a[0].amount =
            //     fsca_remedial_module_count;
            // Constants.comms_sectionsList_3_1a[0].percentage =
            //     fsca_remedial_percentage * 100;

            /*        int total_sent =
                (jsonResponse["amounts_by_delivery"]["TOTAL"]["Count"] ?? 0).toInt();
            int other_count = total_sent -
                (delivered_count1a + udelivered_count1a + expired_count1a);
            double other_percentage = 1 -
                (delivery_percentage1a +
                    udelivered_percentagea +
                    expired_percentage1a);*/
            //print("other_percentage $other_percentage");

            // Calculate total percentage to ensure it sums to 100%
            double totalPercentage_list = delivery_percentage1a + 
                                   udelivered_percentagea + 
                                   expired_percentage1a + 
                                   blacklisted_percentage1a + 
                                   submitted_percentage1a + 
                                   cancelled_percentage1a;
            
            // Calculate the difference from 100%
            double percentageDifference_list = 1.0 - totalPercentage_list;
            
            // Adjust undelivered percentage to make total equal to 100%
            double adjusted_undelivered_percentage_list = udelivered_percentagea + percentageDifference_list;
            
            // Ensure the adjusted percentage is not negative
            if (adjusted_undelivered_percentage_list < 0) {
                adjusted_undelivered_percentage_list = 0;
            }
            
            Constants.comms_sectionsList1a_a[0].amount = delivered_count1a;
            Constants.comms_sectionsList1a_a[0].percentage =
                delivery_percentage1a * 100;
            Constants.comms_sectionsList1a_a[1].amount = udelivered_count1a;
            Constants.comms_sectionsList1a_a[1].percentage =
                adjusted_undelivered_percentage_list * 100;
            Constants.comms_sectionsList1a_a[2].amount = expired_count1a;
            Constants.comms_sectionsList1a_a[2].percentage =
                expired_percentage1a * 100;
            Constants.comms_sectionsList1a_a[3].amount = blacklisted_count1a;
            Constants.comms_sectionsList1a_a[3].percentage =
                blacklisted_percentage1a * 100;

            Constants.comms_sectionsList1a_a[4].amount = submitted_count1a;
            Constants.comms_sectionsList1a_a[4].percentage =
                submitted_percentage1a * 100;

            Constants.comms_sectionsList1a_a[5].amount = cancelled_count1a;
            Constants.comms_sectionsList1a_a[5].percentage =
                cancelled_percentage1a * 100;
            Constants.comms_pieData1a = [];

            Constants.comms_sectionsList1a_b[0].amount = delivered_count1b;
            Constants.comms_sectionsList1a_b[0].percentage =
                delivery_percentage1b * 100;
            Constants.comms_sectionsList1a_b[1].amount = udelivered_count1b;
            Constants.comms_sectionsList1a_b[1].percentage =
                udelivered_percentageb * 100;
            Constants.comms_sectionsList1a_b[2].amount = expired_count1b;
            Constants.comms_sectionsList1a_b[2].percentage =
                expired_percentage1b * 100;
            Constants.comms_sectionsList1a_b[3].amount = blacklisted_count1b;
            Constants.comms_sectionsList1a_b[3].percentage =
                blacklisted_percentage1b * 100;

            Constants.comms_sectionsList1a_b[4].amount = submitted_count1b;
            Constants.comms_sectionsList1a_b[4].percentage =
                submitted_percentage1b * 100;

            Constants.comms_sectionsList1a_b[5].amount = cancelled_count1b;
            Constants.comms_sectionsList1a_b[5].percentage =
                cancelled_percentage1b * 100;

            Constants.comms_sectionsList1a_c[0].amount = delivered_count1c;
            Constants.comms_sectionsList1a_c[0].percentage =
                delivery_percentage1c * 100;
            Constants.comms_sectionsList1a_c[1].amount = udelivered_count1c;
            Constants.comms_sectionsList1a_c[1].percentage =
                udelivered_percentagec * 100;
            Constants.comms_sectionsList1a_c[2].amount = expired_count1c;
            Constants.comms_sectionsList1a_c[2].percentage =
                expired_percentage1c * 100;
            Constants.comms_sectionsList1a_c[3].amount = blacklisted_count1c;
            Constants.comms_sectionsList1a_c[3].percentage =
                blacklisted_percentage1c * 100;

            Constants.comms_sectionsList1a_c[4].amount = submitted_count1c;
            Constants.comms_sectionsList1a_c[4].percentage =
                submitted_percentage1c * 100;

            Constants.comms_sectionsList1a_c[5].amount = cancelled_count1c;
            Constants.comms_sectionsList1a_c[5].percentage =
                cancelled_percentage1c * 100;
            Constants.comms_pieData1a = [];

            double sms_un =
                (jsonResponse["comms_amounts"]["DELIVRD"]["Percentage"] ?? 0.0)
                    .toDouble();
            
            // Calculate total percentage to ensure it sums to 100%
            double totalPercentage = delivery_percentage1a + 
                                   udelivered_percentagea + 
                                   expired_percentage1a + 
                                   blacklisted_percentage1a + 
                                   submitted_percentage1a + 
                                   cancelled_percentage1a;
            
            // Calculate the difference from 100%
            double percentageDifference = 1.0 - totalPercentage;
            
            // Adjust undelivered percentage to make total equal to 100%
            double adjusted_undelivered_percentage = udelivered_percentagea + percentageDifference;
            
            // Ensure the adjusted percentage is not negative
            if (adjusted_undelivered_percentage < 0) {
                adjusted_undelivered_percentage = 0;
            }
            
            Constants.comms_pieData1a.add(PieChartSectionData(
                radius: 60,
                title: "${(delivery_percentage1a * 100).toStringAsFixed(1)}%",
                color: Color(0xff146080),
                value: delivery_percentage1a,
                titleStyle: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)));
            Constants.comms_pieData1a.add(PieChartSectionData(
                title: "${(adjusted_undelivered_percentage * 100).toStringAsFixed(1)}%",
                color: Colors.orange,
                radius: 60,
                value: adjusted_undelivered_percentage,
                titleStyle: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)));
            Constants.comms_pieData1a.add(PieChartSectionData(
                radius: 60,
                title: "${(expired_percentage1a * 100).toStringAsFixed(1)}%",
                color: Colors.green,
                value: expired_percentage1a,
                titleStyle: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)));
            Constants.comms_pieData1a.add(PieChartSectionData(
                radius: 60,
                title:
                    "${(blacklisted_percentage1a * 100).toStringAsFixed(1)}%",
                color: Colors.black,
                value: blacklisted_percentage1a,
                titleStyle: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)));
            Constants.comms_pieData1a.add(PieChartSectionData(
                radius: 60,
                title: "${(submitted_percentage1a * 100).toStringAsFixed(1)}%",
                color: Colors.blue,
                value: submitted_percentage1a,
                titleStyle: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)));
            Constants.comms_pieData1a.add(PieChartSectionData(
                radius: 60,
                title: "${(cancelled_percentage1a * 100).toStringAsFixed(1)}%",
                color: Colors.blue,
                value: cancelled_percentage1a,
                titleStyle: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)));
            Constants.comms_jsonResponse1a =
                jsonResponse as Map<String, dynamic>;
            commsValue.value++;
          } else if (selectedButton1 == 2) {
            Constants.comms_salesbyagent2a = [];
            Constants.comms_bottomTitles2a = [];
            Constants.comms_pieData2a = [];
            Constants.comms_sectionsList2a = [];
            Constants.comms_sectionsList2a = [
              commsgridmodel("Total Issued", 0, 0),
              commsgridmodel("Delivered", 0, 0),
              commsgridmodel("Undelivered", 0, 0),
            ];
            Constants.comms_sectionsList2a[0].amount =
                (jsonResponse["amounts_by_delivery"]["TOTAL"]["Count"] ?? 0)
                    .toInt();
            Constants.comms_sectionsList2a[1].amount =
                (jsonResponse["amounts_by_delivery"]["DELIVERED"]["Count"] ?? 0)
                    .toInt();
            Constants.comms_sectionsList2a[2].amount =
                (jsonResponse["amounts_by_delivery"]["UNDELIVERED"]["Count"] ??
                        0)
                    .toInt();
            if ((jsonResponse["amounts_by_delivery"]["DELIVERED"]["Count"] ??
                    0) >
                0) {
              Constants.percentage_delivered2a =
                  (jsonResponse["amounts_by_delivery"]["DELIVERED"]["Count"] ??
                              0)
                          .toDouble() /
                      (jsonResponse["amounts_by_delivery"]["TOTAL"]["Count"] ??
                              1)
                          .toDouble();
            }
            print("----- ${selectedButton1} ${jsonResponse}");

            Constants.comms_sectionsList2a_a = [
              commsgridmodel("Delivered", 0, 0),
              commsgridmodel("Undelivered", 0, 0),
              commsgridmodel("Expired", 0, 0),
              commsgridmodel("Blacklisted", 0, 0),
              commsgridmodel("Submitted", 0, 0),
              commsgridmodel("Cancelled", 0, 0),
            ];
            Constants.comms_sectionsList2a_b = [
              commsgridmodel("Delivered", 0, 0),
              commsgridmodel("Undelivered", 0, 0),
              commsgridmodel("Expired", 0, 0),
              commsgridmodel("Blacklisted", 0, 0),
              commsgridmodel("Submitted", 0, 0),
              commsgridmodel("Cancelled", 0, 0),
            ];
            Constants.comms_sectionsList2a_c = [
              commsgridmodel("Delivered", 0, 0),
              commsgridmodel("Undelivered", 0, 0),
              commsgridmodel("Expired", 0, 0),
              commsgridmodel("Blacklisted", 0, 0),
              commsgridmodel("Submitted", 0, 0),
              commsgridmodel("Cancelled", 0, 0),
            ];
            Constants.comms_sectionsList_2_1a = [
              commsgridmodel("Sales", 0, 0),
              commsgridmodel("Collections", 0, 0),
              commsgridmodel("Maintenence", 0, 0),
              commsgridmodel("Compliance", 0, 0),
            ];
            Constants.comms_sectionsList_2_2a = [
              commsgridmodel("Sales", 0, 0),
              commsgridmodel("Collections", 0, 0),
              commsgridmodel("Maintenence", 0, 0),
            ];
            isLoadingFullfilment2a = false;
            commsValue.value++;
            Constants.comms_sectionsList_3_2a = [
              //  commsgridmodel("FSCA Remedial", 0, 0),
            ];
            var deliveredData = calculateCountsAndPercentages(
                Map<String, dynamic>.from(jsonResponse), "DELIVRD");
            int delivered_count2a = deliveredData["count"] ?? 0;
            double delivery_percentage2a =
                (deliveredData["percentage"] ?? 0.0).toDouble();

            var undeliveredData = calculateCountsAndPercentages(
                Map<String, dynamic>.from(jsonResponse), "UNDELIV");
            int udelivered_count2a = undeliveredData["count"] ?? 0;
            double udelivered_percentage2a =
                (undeliveredData["percentage"] ?? 0.0).toDouble();

            var expiredData = calculateCountsAndPercentages(
                Map<String, dynamic>.from(jsonResponse), "EXPIRED");
            int expired_count2a = expiredData["count"] ?? 0;
            double expired_percentage2a =
                (expiredData["percentage"] ?? 0.0).toDouble();

            var blacklistedData = calculateCountsAndPercentages(
                Map<String, dynamic>.from(jsonResponse), "BLIST");
            int blacklisted_count2a = blacklistedData["count"] ?? 0;
            double blacklisted_percentage2a =
                (blacklistedData["percentage"] ?? 0.0).toDouble();

            int submitted_count2a = (jsonResponse["comms_amounts"]["STAGED"]
                        ["Count"] ??
                    0) +
                (jsonResponse["fsca_counts"]["STAGED"]["Count"] ?? 0).toInt();
            double submitted_percentage2a =
                (jsonResponse["comms_amounts"]["SUBMITD"]["Percentage"] ?? 0.0)
                    .toDouble();
            int cancelled_count2a =
                (jsonResponse["comms_amounts"]["CANCELLED"]["Count"] ?? 0) +
                    (jsonResponse["fsca_counts"]["CANCELLED"]["Count"] ?? 0) +
                    (jsonResponse["comms_amounts"]["NOROUTE"]["Count"] ?? 0) +
                    (jsonResponse["fsca_counts"]["NOROUTE"]["Count"] ?? 0);
            double cancelled_percentage2a = (jsonResponse["comms_amounts"]
                            ["CANCELLED"]["Percentage"] ??
                        0.0)
                    .toDouble() +
                (jsonResponse["comms_amounts"]["NOROUTE"]["Percentage"] ?? 0.0)
                    .toDouble();

            int sales_module_count2a =
                jsonResponse["counts_by_module"]["Sales Module"] ?? 0;

            int collections_module_count =
                jsonResponse["counts_by_module"]["Collections Module"] ?? 0;

            int maintenace_module_count =
                jsonResponse["counts_by_module"]["Maintenance Module"] ?? 0;

            int total_counts = sales_module_count2a +
                collections_module_count +
                maintenace_module_count;

            double sales_module_percentage = 0.0;
            if (sales_module_count2a != 0 && total_counts != 0) {
              sales_module_percentage =
                  sales_module_count2a.toDouble() / total_counts.toDouble();
            }
            double collections_module_percentage = 0.0;
            if (collections_module_count != 0 && total_counts != 0) {
              collections_module_percentage =
                  collections_module_count.toDouble() / total_counts.toDouble();
            }
            double maintenace_module_percentage = 0.0;
            if (maintenace_module_count != 0 && total_counts != 0) {
              maintenace_module_percentage =
                  maintenace_module_count.toDouble() / total_counts.toDouble();
            }
            double fsca_remedial_percentage = 0;

            //2b
            int delivered_count1b =
                (jsonResponse["comms_amounts"]["DELIVRD"]["Count"] ?? 0)
                    .toInt();
            double delivery_percentage1b =
                (jsonResponse["comms_amounts"]["DELIVRD"]["Percentage"] ?? 0.0)
                    .toDouble();
            print("delivered_count1b $delivered_count1b");
            print("delivery_percentage1b $delivery_percentage1b");
            int udelivered_count1b =
                (jsonResponse["comms_amounts"]["UNDELIV"]["Count"] ?? 0)
                    .toInt();
            double udelivered_percentageb =
                (jsonResponse["comms_amounts"]["UNDELIV"]["Percentage"] ?? 0.0)
                    .toDouble();
            //print("delivery_percentage1a $udelivered_percentagea");
            int expired_count1b =
                (jsonResponse["comms_amounts"]["EXPIRED"]["Count"] ?? 0)
                    .toInt();
            double expired_percentage1b =
                (jsonResponse["comms_amounts"]["EXPIRED"]["Percentage"] ?? 0.0)
                    .toDouble();
            int blacklisted_count1b =
                (jsonResponse["comms_amounts"]["BLIST"]["Count"] ?? 0).toInt();
            double blacklisted_percentage1b =
                (jsonResponse["comms_amounts"]["BLIST"]["Percentage"] ?? 0.0)
                    .toDouble();
            int submitted_count1b =
                jsonResponse["comms_amounts"]["SUBMITD"] == null
                    ? 0
                    : (jsonResponse["comms_amounts"]["STAGED"]["Count"] ?? 0)
                        .toInt();
            double submitted_percentage1b =
                jsonResponse["comms_amounts"]["SUBMITD"] == null
                    ? 0.0
                    : (jsonResponse["comms_amounts"]["SUBMITD"]["Percentage"] ??
                                0.0)
                            .toDouble() +
                        (jsonResponse["comms_amounts"]["STAGED"]
                                    ["Percentage"] ??
                                0.0)
                            .toDouble();
            int cancelled_count1b = jsonResponse["comms_amounts"]
                        ["CANCELLED"] ==
                    null
                ? 0
                : (jsonResponse["comms_amounts"]["CANCELLED"]["Count"] ?? 0) +
                    (jsonResponse["comms_amounts"]["NOROUTE"]["Count"] ?? 0);
            double cancelled_percentage1b = jsonResponse["comms_amounts"]
                        ["CANCELLED"] ==
                    null
                ? 0.0
                : (jsonResponse["comms_amounts"]["CANCELLED"]["Percentage"] ??
                            0.0)
                        .toDouble() +
                    (jsonResponse["comms_amounts"]["NOROUTE"]["Percentage"] ??
                            0.0)
                        .toDouble();
            //1c
            int delivered_count1c =
                (jsonResponse["fsca_counts"]["DELIVRD"]["Count"] ?? 0).toInt();
            double delivery_percentage1c = double.parse(
                (jsonResponse["fsca_counts"]["DELIVRD"]["Percentage"] ?? 0)
                    .toString());
            //print("delivery_percentage1a $delivery_percentage1a");
            int udelivered_count1c =
                (jsonResponse["fsca_counts"]["UNDELIV"]["Count"] ?? 0).toInt();
            double udelivered_percentagec = double.parse(
                (jsonResponse["fsca_counts"]["UNDELIV"]["Percentage"] ?? 0)
                    .toString());
            //print("delivery_percentage1a $udelivered_percentagea");
            int expired_count1c =
                (jsonResponse["fsca_counts"]["EXPIRED"]["Count"] ?? 0).toInt();
            double expired_percentage1c =
                (jsonResponse["comms_amounts"]["EXPIRED"]["Percentage"] ?? 0.0)
                    .toDouble();
            int blacklisted_count1c =
                (jsonResponse["fsca_counts"]["BLIST"]["Count"] ?? 0).toInt();
            double blacklisted_percentage1c =
                (jsonResponse["fsca_counts"]["BLIST"]["Percentage"] ?? 0.0)
                    .toDouble();
            int submitted_count1c =
                (jsonResponse["fsca_counts"]["STAGED"]["Count"] ?? 0).toInt();
            double submitted_percentage1c =
                (jsonResponse["fsca_counts"]["SUBMITD"]["Percentage"] ?? 0.0)
                        .toDouble() +
                    (jsonResponse["fsca_counts"]["STAGED"]["Percentage"] ?? 0.0)
                        .toDouble();
            int cancelled_count1c = jsonResponse["fsca_counts"]["CANCELLED"] ==
                    null
                ? 0
                : (jsonResponse["fsca_counts"]["CANCELLED"]["Count"] ?? 0) +
                    (jsonResponse["comms_amounts"]["NOROUTE"]["Count"] ?? 0);
            double cancelled_percentage1c = (jsonResponse["comms_amounts"]
                            ["CANCELLED"]["Percentage"] ??
                        0.0)
                    .toDouble() +
                (jsonResponse["comms_amounts"]["NOROUTE"]["Percentage"] ?? 0.0)
                    .toDouble();

            Constants.comms_sectionsList_2_1a[0].amount = sales_module_count2a;
            Constants.comms_sectionsList_2_1a[0].percentage =
                sales_module_percentage * 100;
            Constants.comms_sectionsList_2_1a[1].amount =
                collections_module_count;
            Constants.comms_sectionsList_2_1a[1].percentage =
                collections_module_percentage * 100;
            Constants.comms_sectionsList_2_1a[2].amount =
                maintenace_module_count;
            Constants.comms_sectionsList_2_1a[2].percentage =
                maintenace_module_percentage * 100;

            Constants.comms_sectionsList_2_1a[0].amount = sales_module_count2a;
            Constants.comms_sectionsList_2_1a[0].percentage =
                sales_module_percentage * 100;
            Constants.comms_sectionsList_2_1a[1].amount =
                collections_module_count;
            Constants.comms_sectionsList_2_2a[1].percentage =
                collections_module_percentage * 100;
            Constants.comms_sectionsList_2_2a[2].amount =
                maintenace_module_count;
            Constants.comms_sectionsList_2_2a[2].percentage =
                maintenace_module_percentage * 100;

            /*        int total_sent =
                (jsonResponse["amounts_by_delivery"]["TOTAL"]["Count"] ?? 0).toInt();
            int other_count = total_sent -
                (delivered_count1a + udelivered_count1a + expired_count1a);
            double other_percentage = 1 -
                (delivery_percentage1a +
                    udelivered_percentagea +
                    expired_percentage1a);*/
            //print("other_percentage $other_percentage");

            Constants.comms_sectionsList2a_a[0].amount = delivered_count2a;
            Constants.comms_sectionsList2a_a[0].percentage =
                delivery_percentage2a * 100;
            Constants.comms_sectionsList2a_a[1].amount = udelivered_count2a;
            Constants.comms_sectionsList2a_a[1].percentage =
                udelivered_percentage2a * 100;
            Constants.comms_sectionsList2a_a[2].amount = expired_count2a;
            Constants.comms_sectionsList2a_a[2].percentage =
                expired_percentage2a * 100;
            Constants.comms_sectionsList2a_a[3].amount = blacklisted_count2a;
            Constants.comms_sectionsList2a_a[3].percentage =
                blacklisted_percentage2a * 100;

            Constants.comms_sectionsList2a_a[4].amount = submitted_count2a;
            Constants.comms_sectionsList2a_a[4].percentage =
                submitted_percentage2a * 100;

            Constants.comms_sectionsList2a_a[5].amount = cancelled_count2a;
            Constants.comms_sectionsList2a_a[5].percentage =
                cancelled_percentage2a * 100;
            Constants.comms_pieData2a = [];

            Constants.comms_sectionsList2a_b[0].amount = delivered_count1b;
            Constants.comms_sectionsList2a_b[0].percentage =
                delivery_percentage1b * 100;
            Constants.comms_sectionsList2a_b[1].amount = udelivered_count1b;
            Constants.comms_sectionsList2a_b[1].percentage =
                udelivered_percentageb * 100;
            Constants.comms_sectionsList2a_b[2].amount = expired_count1b;
            Constants.comms_sectionsList2a_b[2].percentage =
                expired_percentage1b * 100;
            Constants.comms_sectionsList2a_b[3].amount = blacklisted_count1b;
            Constants.comms_sectionsList2a_b[3].percentage =
                blacklisted_percentage1b * 100;

            Constants.comms_sectionsList2a_b[4].amount = submitted_count1b;
            Constants.comms_sectionsList2a_b[4].percentage =
                submitted_percentage1b * 100;

            Constants.comms_sectionsList2a_b[5].amount = cancelled_count1b;
            Constants.comms_sectionsList2a_b[5].percentage =
                cancelled_percentage1b * 100;

            Constants.comms_sectionsList2a_c[0].amount = delivered_count1c;
            Constants.comms_sectionsList2a_c[0].percentage =
                delivery_percentage1c * 100;
            Constants.comms_sectionsList2a_c[1].amount = udelivered_count1c;
            Constants.comms_sectionsList2a_c[1].percentage =
                udelivered_percentagec * 100;
            Constants.comms_sectionsList2a_c[2].amount = expired_count1c;
            Constants.comms_sectionsList2a_c[2].percentage =
                expired_percentage1c * 100;
            Constants.comms_sectionsList2a_c[3].amount = blacklisted_count1c;
            Constants.comms_sectionsList2a_c[3].percentage =
                blacklisted_percentage1c * 100;

            Constants.comms_sectionsList2a_c[4].amount = submitted_count1c;
            Constants.comms_sectionsList2a_c[4].percentage =
                submitted_percentage1c * 100;

            Constants.comms_sectionsList2a_c[5].amount = cancelled_count1c;
            Constants.comms_sectionsList2a_c[5].percentage =
                cancelled_percentage1c * 100;

            // Constants.comms_pieData1a = [];

            double sms_un =
                (jsonResponse["comms_amounts"]["DELIVRD"]["Percentage"] ?? 0.0)
                    .toDouble();
            Constants.comms_pieData2a.add(PieChartSectionData(
                radius: 60,
                title: "${(delivery_percentage2a * 100).toStringAsFixed(1)}%",
                color: Color(0xff146080),
                value: (jsonResponse["comms_amounts"]["DELIVRD"]
                            ["Percentage"] ??
                        0.0)
                    .toDouble(),
                titleStyle: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)));
            Constants.comms_pieData2a.add(PieChartSectionData(
                title: "${(udelivered_percentage2a * 100).toStringAsFixed(1)}%",
                color: Colors.orange,
                radius: 60,
                value: (jsonResponse["comms_amounts"]["UNDELIV"]
                            ["Percentage"] ??
                        0.0)
                    .toDouble(),
                titleStyle: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)));
            Constants.comms_pieData2a.add(PieChartSectionData(
                radius: 60,
                title: "${(expired_percentage2a * 100).toStringAsFixed(1)}%",
                color: Colors.green,
                value: (jsonResponse["comms_amounts"]["EXPIRED"]
                            ["Percentage"] ??
                        0.0)
                    .toDouble(),
                titleStyle: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)));
            Constants.comms_pieData2a.add(PieChartSectionData(
                radius: 60,
                title:
                    "${(blacklisted_percentage1c * 100).toStringAsFixed(1)}%",
                color: Colors.black,
                value: blacklisted_percentage1c,
                titleStyle: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)));
            Constants.comms_jsonResponse2a =
                jsonResponse as Map<String, dynamic>;

            Constants.comms_treeMap1a_2 = Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                  height: 350,
                  child: CustomTreemap(
                      treeMapdata: jsonResponse["reorganized_by_module"]
                      //  treeMapdata: jsonResponse1["reorganized_by_module"],
                      )),
            );
            commsValue.value++;
          } else if (selectedButton1 == 3) {
            Constants.comms_salesbyagent3a = [];
            Constants.comms_bottomTitles3a = [];
            Constants.comms_pieData3a = [];
            Constants.comms_sectionsList3a = [];
            Constants.comms_sectionsList3a = [
              commsgridmodel("Total Issued", 0, 0),
              commsgridmodel("Delivered", 0, 0),
              commsgridmodel("Undelivered", 0, 0),
            ];
            isLoadingFullfilment3a = false;
            commsValue.value++;
            Constants.comms_sectionsList3a[0].amount =
                (jsonResponse["amounts_by_delivery"]["TOTAL"]["Count"] ?? 0)
                    .toInt();
            Constants.comms_sectionsList3a[1].amount =
                (jsonResponse["amounts_by_delivery"]["DELIVERED"]["Count"] ?? 0)
                    .toInt();
            Constants.comms_sectionsList3a[2].amount =
                (jsonResponse["amounts_by_delivery"]["UNDELIVERED"]["Count"] ??
                        0)
                    .toInt();
            if ((jsonResponse["amounts_by_delivery"]["DELIVERED"]["Count"] ??
                    0) >
                0) {
              Constants.percentage_delivered3a =
                  (jsonResponse["amounts_by_delivery"]["DELIVERED"]["Count"] ??
                              0)
                          .toDouble() /
                      (jsonResponse["amounts_by_delivery"]["TOTAL"]["Count"] ??
                              1)
                          .toDouble();
            }
            print("----- ${selectedButton1} ${jsonResponse}");

            Constants.comms_sectionsList3a_a = [
              commsgridmodel("Delivered", 0, 0),
              commsgridmodel("Undelivered", 0, 0),
              commsgridmodel("Expired", 0, 0),
              commsgridmodel("Blacklisted", 0, 0),
              commsgridmodel("Submitted", 0, 0),
              commsgridmodel("Cancelled", 0, 0),
            ];
            Constants.comms_sectionsList3a_b = [
              commsgridmodel("Delivered", 0, 0),
              commsgridmodel("Undelivered", 0, 0),
              commsgridmodel("Expired", 0, 0),
              commsgridmodel("Blacklisted", 0, 0),
              commsgridmodel("Submitted", 0, 0),
              commsgridmodel("Cancelled", 0, 0),
            ];
            Constants.comms_sectionsList3a_c = [
              commsgridmodel("Delivered", 0, 0),
              commsgridmodel("Undelivered", 0, 0),
              commsgridmodel("Expired", 0, 0),
              commsgridmodel("Blacklisted", 0, 0),
              commsgridmodel("Submitted", 0, 0),
              commsgridmodel("Cancelled", 0, 0),
            ];
            Constants.comms_sectionsList_3_1a = [
              commsgridmodel("Sales", 0, 0),
              commsgridmodel("Collections", 0, 0),
              commsgridmodel("Maintenence", 0, 0),
            ];
            Constants.comms_sectionsList_3_2a = [
              commsgridmodel("Sales", 0, 0),
              commsgridmodel("Collections", 0, 0),
              commsgridmodel("Maintenence", 0, 0),
            ];

            var deliveredData = calculateCountsAndPercentages(
                Map<String, dynamic>.from(jsonResponse), "DELIVRD");
            int delivered_count2a = deliveredData["count"];
            double delivery_percentage2a = deliveredData["percentage"];

            var undeliveredData = calculateCountsAndPercentages(
                Map<String, dynamic>.from(jsonResponse), "UNDELIV");
            int udelivered_count2a = undeliveredData["count"];
            double udelivered_percentage2a = undeliveredData["percentage"];

            var expiredData = calculateCountsAndPercentages(
                Map<String, dynamic>.from(jsonResponse), "EXPIRED");
            int expired_count2a = expiredData["count"];
            double expired_percentage2a = expiredData["percentage"];

            var blacklistedData = calculateCountsAndPercentages(
                Map<String, dynamic>.from(jsonResponse), "BLIST");
            int blacklisted_count2a = blacklistedData["count"];
            double blacklisted_percentage2a = blacklistedData["percentage"];

            int submitted_count2a = (jsonResponse["comms_amounts"]["STAGED"]
                        ["Count"] ??
                    0) +
                (jsonResponse["fsca_counts"]["STAGED"]["Count"] ?? 0).toInt();
            double submitted_percentage2a =
                (jsonResponse["comms_amounts"]["SUBMITD"]["Percentage"] ?? 0.0)
                    .toDouble();
            int cancelled_count2a =
                (jsonResponse["comms_amounts"]["CANCELLED"]["Count"] ?? 0) +
                    (jsonResponse["fsca_counts"]["CANCELLED"]["Count"] ?? 0) +
                    (jsonResponse["comms_amounts"]["NOROUTE"]["Count"] ?? 0) +
                    (jsonResponse["fsca_counts"]["NOROUTE"]["Count"] ?? 0);
            double cancelled_percentage2a = (jsonResponse["comms_amounts"]
                            ["CANCELLED"]["Percentage"] ??
                        0.0)
                    .toDouble() +
                (jsonResponse["comms_amounts"]["NOROUTE"]["Percentage"] ?? 0.0)
                    .toDouble();

            int sales_module_count2a =
                jsonResponse["counts_by_module"]["Sales Module"] ?? 0;

            int collections_module_count =
                jsonResponse["counts_by_module"]["Collections Module"] ?? 0;

            int maintenace_module_count =
                jsonResponse["counts_by_module"]["Maintenance Module"] ?? 0;

            int total_counts = sales_module_count2a +
                collections_module_count +
                maintenace_module_count;

            double sales_module_percentage = 0.0;
            if (sales_module_count2a != 0 && total_counts != 0) {
              sales_module_percentage =
                  sales_module_count2a.toDouble() / total_counts.toDouble();
            }
            double collections_module_percentage = 0.0;
            if (collections_module_count != 0 && total_counts != 0) {
              collections_module_percentage =
                  collections_module_count.toDouble() / total_counts.toDouble();
            }
            double maintenace_module_percentage = 0.0;
            if (maintenace_module_count != 0 && total_counts != 0) {
              maintenace_module_percentage =
                  maintenace_module_count.toDouble() / total_counts.toDouble();
            }
            double fsca_remedial_percentage = 0;

            //2b
            int delivered_count1b =
                (jsonResponse["comms_amounts"]["DELIVRD"]["Count"] ?? 0)
                    .toInt();
            double delivery_percentage1b =
                (jsonResponse["comms_amounts"]["DELIVRD"]["Percentage"] ?? 0.0)
                    .toDouble();
            print("delivered_count1b $delivered_count1b");
            print("delivery_percentage1b $delivery_percentage1b");
            int udelivered_count1b =
                (jsonResponse["comms_amounts"]["UNDELIV"]["Count"] ?? 0)
                    .toInt();
            double udelivered_percentageb =
                (jsonResponse["comms_amounts"]["UNDELIV"]["Percentage"] ?? 0.0)
                    .toDouble();
            //print("delivery_percentage1a $udelivered_percentagea");
            int expired_count1b =
                (jsonResponse["comms_amounts"]["EXPIRED"]["Count"] ?? 0)
                    .toInt();
            double expired_percentage1b =
                (jsonResponse["comms_amounts"]["EXPIRED"]["Percentage"] ?? 0.0)
                    .toDouble();
            int blacklisted_count1b =
                (jsonResponse["comms_amounts"]["BLIST"]["Count"] ?? 0).toInt();
            double blacklisted_percentage1b =
                (jsonResponse["comms_amounts"]["BLIST"]["Percentage"] ?? 0.0)
                    .toDouble();
            int submitted_count1b =
                jsonResponse["comms_amounts"]["SUBMITD"] == null
                    ? 0
                    : (jsonResponse["comms_amounts"]["STAGED"]["Count"] ?? 0)
                        .toInt();
            double submitted_percentage1b =
                jsonResponse["comms_amounts"]["SUBMITD"] == null
                    ? 0.0
                    : (jsonResponse["comms_amounts"]["SUBMITD"]["Percentage"] ??
                                0.0)
                            .toDouble() +
                        (jsonResponse["comms_amounts"]["STAGED"]
                                    ["Percentage"] ??
                                0.0)
                            .toDouble();
            int cancelled_count1b = jsonResponse["comms_amounts"]
                        ["CANCELLED"] ==
                    null
                ? 0
                : (jsonResponse["comms_amounts"]["CANCELLED"]["Count"] ?? 0) +
                    (jsonResponse["comms_amounts"]["NOROUTE"]["Count"] ?? 0);
            double cancelled_percentage1b = jsonResponse["comms_amounts"]
                        ["CANCELLED"] ==
                    null
                ? 0.0
                : (jsonResponse["comms_amounts"]["CANCELLED"]["Percentage"] ??
                            0.0)
                        .toDouble() +
                    (jsonResponse["comms_amounts"]["NOROUTE"]["Percentage"] ??
                            0.0)
                        .toDouble();
            //1c
            int delivered_count1c =
                (jsonResponse["fsca_counts"]["DELIVRD"]["Count"] ?? 0).toInt();
            double delivery_percentage1c = double.parse(
                (jsonResponse["fsca_counts"]["DELIVRD"]["Percentage"] ?? 0)
                    .toString());
            //print("delivery_percentage1a $delivery_percentage1a");
            int udelivered_count1c =
                (jsonResponse["fsca_counts"]["UNDELIV"]["Count"] ?? 0).toInt();
            double udelivered_percentagec = double.parse(
                (jsonResponse["fsca_counts"]["UNDELIV"]["Percentage"] ?? 0)
                    .toString());
            //print("delivery_percentage1a $udelivered_percentagea");
            int expired_count1c =
                (jsonResponse["fsca_counts"]["EXPIRED"]["Count"] ?? 0).toInt();
            double expired_percentage1c =
                (jsonResponse["comms_amounts"]["EXPIRED"]["Percentage"] ?? 0.0)
                    .toDouble();
            int blacklisted_count1c =
                (jsonResponse["fsca_counts"]["BLIST"]["Count"] ?? 0).toInt();
            double blacklisted_percentage1c =
                (jsonResponse["fsca_counts"]["BLIST"]["Percentage"] ?? 0.0)
                    .toDouble();
            int submitted_count1c =
                (jsonResponse["fsca_counts"]["STAGED"]["Count"] ?? 0).toInt();
            double submitted_percentage1c =
                (jsonResponse["fsca_counts"]["SUBMITD"]["Percentage"] ?? 0.0)
                        .toDouble() +
                    (jsonResponse["fsca_counts"]["STAGED"]["Percentage"] ?? 0.0)
                        .toDouble();
            int cancelled_count1c = jsonResponse["fsca_counts"]["CANCELLED"] ==
                    null
                ? 0
                : (jsonResponse["fsca_counts"]["CANCELLED"]["Count"] ?? 0) +
                    (jsonResponse["comms_amounts"]["NOROUTE"]["Count"] ?? 0);
            double cancelled_percentage1c = (jsonResponse["comms_amounts"]
                            ["CANCELLED"]["Percentage"] ??
                        0.0)
                    .toDouble() +
                (jsonResponse["comms_amounts"]["NOROUTE"]["Percentage"] ?? 0.0)
                    .toDouble();

            Constants.comms_sectionsList_3_1a[0].amount = sales_module_count2a;
            Constants.comms_sectionsList_3_1a[0].percentage =
                sales_module_percentage * 100;
            Constants.comms_sectionsList_3_1a[1].amount =
                collections_module_count;
            Constants.comms_sectionsList_3_1a[1].percentage =
                collections_module_percentage * 100;
            Constants.comms_sectionsList_3_1a[2].amount =
                maintenace_module_count;
            Constants.comms_sectionsList_3_1a[2].percentage =
                maintenace_module_percentage * 100;

            Constants.comms_sectionsList_3_1a[0].amount = sales_module_count2a;
            Constants.comms_sectionsList_3_1a[0].percentage =
                sales_module_percentage * 100;
            Constants.comms_sectionsList_3_1a[1].amount =
                collections_module_count;
            Constants.comms_sectionsList_3_2a[1].percentage =
                collections_module_percentage * 100;
            Constants.comms_sectionsList_3_2a[2].amount =
                maintenace_module_count;
            Constants.comms_sectionsList_3_2a[2].percentage =
                maintenace_module_percentage * 100;

            /*        int total_sent =
                (jsonResponse["amounts_by_delivery"]["TOTAL"]["Count"] ?? 0).toInt();
            int other_count = total_sent -
                (delivered_count1a + udelivered_count1a + expired_count1a);
            double other_percentage = 1 -
                (delivery_percentage1a +
                    udelivered_percentagea +
                    expired_percentage1a);*/
            //print("other_percentage $other_percentage");

            Constants.comms_sectionsList3a_a[0].amount = delivered_count2a;
            Constants.comms_sectionsList3a_a[0].percentage =
                delivery_percentage2a * 100;
            Constants.comms_sectionsList3a_a[1].amount = udelivered_count2a;
            Constants.comms_sectionsList3a_a[1].percentage =
                udelivered_percentage2a * 100;
            Constants.comms_sectionsList3a_a[2].amount = expired_count2a;
            Constants.comms_sectionsList3a_a[2].percentage =
                expired_percentage2a * 100;
            Constants.comms_sectionsList3a_a[3].amount = blacklisted_count2a;
            Constants.comms_sectionsList3a_a[3].percentage =
                blacklisted_percentage2a * 100;

            Constants.comms_sectionsList3a_a[4].amount = submitted_count2a;
            Constants.comms_sectionsList3a_a[4].percentage =
                submitted_percentage2a * 100;

            Constants.comms_sectionsList3a_a[5].amount = cancelled_count2a;
            Constants.comms_sectionsList3a_a[5].percentage =
                cancelled_percentage2a * 100;
            Constants.comms_pieData3a = [];

            Constants.comms_sectionsList3a_b[0].amount = delivered_count1b;
            Constants.comms_sectionsList3a_b[0].percentage =
                delivery_percentage1b * 100;
            Constants.comms_sectionsList3a_b[1].amount = udelivered_count1b;
            Constants.comms_sectionsList3a_b[1].percentage =
                udelivered_percentageb * 100;
            Constants.comms_sectionsList3a_b[2].amount = expired_count1b;
            Constants.comms_sectionsList3a_b[2].percentage =
                expired_percentage1b * 100;
            Constants.comms_sectionsList3a_b[3].amount = blacklisted_count1b;
            Constants.comms_sectionsList3a_b[3].percentage =
                blacklisted_percentage1b * 100;

            Constants.comms_sectionsList3a_b[4].amount = submitted_count1b;
            Constants.comms_sectionsList3a_b[4].percentage =
                submitted_percentage1b * 100;

            Constants.comms_sectionsList3a_b[5].amount = cancelled_count1b;
            Constants.comms_sectionsList3a_b[5].percentage =
                cancelled_percentage1b * 100;

            Constants.comms_sectionsList3a_c[0].amount = delivered_count1c;
            Constants.comms_sectionsList3a_c[0].percentage =
                delivery_percentage1c * 100;
            Constants.comms_sectionsList3a_c[1].amount = udelivered_count1c;
            Constants.comms_sectionsList3a_c[1].percentage =
                udelivered_percentagec * 100;
            Constants.comms_sectionsList3a_c[2].amount = expired_count1c;
            Constants.comms_sectionsList3a_c[2].percentage =
                expired_percentage1c * 100;
            Constants.comms_sectionsList3a_c[3].amount = blacklisted_count1c;
            Constants.comms_sectionsList3a_c[3].percentage =
                blacklisted_percentage1c * 100;

            Constants.comms_sectionsList3a_c[4].amount = submitted_count1c;
            Constants.comms_sectionsList3a_c[4].percentage =
                submitted_percentage1c * 100;

            Constants.comms_sectionsList3a_c[5].amount = cancelled_count1c;
            Constants.comms_sectionsList3a_c[5].percentage =
                cancelled_percentage1c * 100;

            // Constants.comms_pieData1a = [];

            double sms_un =
                (jsonResponse["comms_amounts"]["DELIVRD"]["Percentage"] ?? 0.0)
                    .toDouble();
            Constants.comms_pieData3a.add(PieChartSectionData(
                radius: 60,
                title: "${(delivery_percentage2a * 100).toStringAsFixed(1)}%",
                color: Color(0xff146080),
                value: (jsonResponse["comms_amounts"]["DELIVRD"]
                            ["Percentage"] ??
                        0.0)
                    .toDouble(),
                titleStyle: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)));
            Constants.comms_pieData3a.add(PieChartSectionData(
                title: "${(udelivered_percentage2a * 100).toStringAsFixed(1)}%",
                color: Colors.orange,
                radius: 60,
                value: (jsonResponse["comms_amounts"]["UNDELIV"]
                            ["Percentage"] ??
                        0.0)
                    .toDouble(),
                titleStyle: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)));
            Constants.comms_pieData3a.add(PieChartSectionData(
                radius: 60,
                title: "${(expired_percentage2a * 100).toStringAsFixed(1)}%",
                color: Colors.green,
                value: (jsonResponse["comms_amounts"]["EXPIRED"]
                            ["Percentage"] ??
                        0.0)
                    .toDouble(),
                titleStyle: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)));
            Constants.comms_pieData3a.add(PieChartSectionData(
                radius: 60,
                title:
                    "${(blacklisted_percentage1c * 100).toStringAsFixed(1)}%",
                color: Colors.black,
                value: blacklisted_percentage1c,
                titleStyle: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)));
            Constants.comms_jsonResponse3a =
                jsonResponse as Map<String, dynamic>;

            Constants.comms_treeMap1a_3 = Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                  height: 350,
                  child: CustomTreemap(
                      treeMapdata: jsonResponse["reorganized_by_module"]
                      //  treeMapdata: jsonResponse1["reorganized_by_module"],
                      )),
            );
            Constants.comms_tree_key3a = UniqueKey();
            Constants.comms_tree_key4a = UniqueKey();
            commsValue.value++;
          }
        }
        if (selectedButton1 == 1) {
          isLoadingFullfilment1a = false;
        } else if (selectedButton1 == 2) {
          isLoadingFullfilment2a = false;
        } else if (selectedButton1 == 3) {
          isLoadingFullfilment3a = false;
        }
        commsValue.value++;
      }
    });
  } on Exception catch (_, exception) {
    //Exception exc = exception as Exception;
    // print(exception);
  }
}

String getEmployeeById(
  int cec_employeeid,
) {
  String result = "";
  for (var employee in Constants.cec_employees) {
    if (employee['cec_employeeid'].toString() == cec_employeeid.toString()) {
      result = employee["employee_name"] + " " + employee["employee_surname"];
      //print("fgfghg $result");
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
    print("Branch is empty 2 $branch_id $result");
    return "";
  } else
    return result;
}

Map<String, dynamic> calculateCountsAndPercentages(
    Map<String, dynamic> jsonResponse, String key) {
  int count = 0;
  double percentage = 0.0;
  if (jsonResponse["comms_amounts"] != null) {
    count = (jsonResponse["comms_amounts"][key]["Count"] ?? 0).toInt();
    percentage =
        (jsonResponse["comms_amounts"][key]["Percentage"] ?? 0.0).toDouble();
  }

  return {"count": count, "percentage": percentage};
}
