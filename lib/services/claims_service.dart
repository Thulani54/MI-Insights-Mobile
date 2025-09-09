import 'dart:convert';

import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constants/Constants.dart';
import '../models/ClaimStageCategory.dart';
import '../models/ClaimsSectionGridModel.dart';
import '../models/OrdinalSales.dart';
import '../screens/Reports/ClaimsReport.dart';

Map claims_by_category1a = {};
Future<void> getClaimsReport(
  String date_from,
  String date_to,
  int selectedButton1,
  BuildContext context,
) async {
  String baseUrl = "${Constants.analitixAppBaseUrl}sales/get_claims_data/";

  if (Constants.myUserRoleLevel.toLowerCase() == "tester") {
    baseUrl = "${Constants.analitixAppBaseUrl}sales/get_claims_data_test/";
  }

  try {
    Map<String, String>? payload = {
      "client_id": Constants.cec_client_id.toString(),
      // "client_id": Constants.cec_client_id.toString(),
      "start_date": "2025-08-01",
      "end_date": date_to,
    };
    if (kDebugMode) {
      print("baseUrl_claims $baseUrl ${selectedButton1}");
    }
    List<Map<String, dynamic>> sales = [];
    isLoadingClaimsData = true;
    if (selectedButton1 == 2) isLoadingClaimsData2 = true;
    claimsValue.value++;
    Map<String, List<Map<String, dynamic>>> groupedSales1a = {};
    Map<String, List<Map<String, dynamic>>> groupedSales2a = {};
    Map<String, List<Map<String, dynamic>>>? groupedSalesByBranch1a = {};
    Map<String, List<Map<String, dynamic>>>? groupedSalesByBranch2a = {};
    double totalCompleted = 0;
    double totalOngoing = 0;
    double totalDeclined = 0;

    double totalCompletedCount = 0;
    double totalOngoingCount = 0;
    double totalDeclinedCount = 0;
    claimsValue.value++;

    await http.post(Uri.parse(baseUrl), body: payload).then((value) {
      http.Response response = value;
      if (kDebugMode) {
        //print(response.bodyBytes);
        //print(response.statusCode);
        //print(response.body);
        //print(response.body);
      }
      if (response.statusCode != 200) {
        isLoadingClaimsData = false;
      } else if ((jsonDecode(response.body)["message"] ?? "") ==
          "list is empty") {
        isLoadingClaimsData = false;
        if (selectedButton1 == 1) {
          isSalesDataLoading1a = false;
          Constants.claims_deceased_ages_list1a = [];
          Constants.claims_sectionsList1a_1 = [
            claims_sections_gridmodel("Within 5 Hours", "0"),
            claims_sections_gridmodel("Within 12 Hours", "0"),
            claims_sections_gridmodel("Within 24 Hours", "0"),
            claims_sections_gridmodel("Within 2 Days", "0"),
            claims_sections_gridmodel("Within 5 Days", "0"),
            claims_sections_gridmodel("After 5 Days", "0"),
          ];
          Constants.claims_sectionsList1a = [
            claims_sections_gridmodel("Within 5 Hours", "0%"),
            claims_sections_gridmodel("Within 12 Hours", "0%"),
            claims_sections_gridmodel("Within 24 Hours", "0%"),
            claims_sections_gridmodel("Within 2 Days", "0%"),
            claims_sections_gridmodel("Within 5 Days", "0%"),
            claims_sections_gridmodel("After 5 Days", "0%"),
          ];

          Constants.claims_sectionsList1b = [
            claims_sections_gridmodel("Within 5 Hours", "0"),
            claims_sections_gridmodel("Within 12 Hours", "0"),
            claims_sections_gridmodel("Within 24 Hours", "0"),
            claims_sections_gridmodel("Within 2 Days", "0"),
            claims_sections_gridmodel("Within 5 Days", "0"),
            claims_sections_gridmodel("After 5 Days", "0"),
          ];

          Constants.claims_sectionsList1b_1 = [
            claims_sections_gridmodel("Within 5 Hours", "0"),
            claims_sections_gridmodel("Within 12 Hours", "0"),
            claims_sections_gridmodel("Within 24 Hours", "0"),
            claims_sections_gridmodel("Within 2 Days", "0"),
            claims_sections_gridmodel("Within 5 Days", "0"),
            claims_sections_gridmodel("After 5 Days", "0"),
          ];

          Constants.claims_sectionsList2c = [
            claims_sections_gridmodel("Within 5 Hours", "0"),
            claims_sections_gridmodel("Within 12 Hours", "0"),
            claims_sections_gridmodel("After 12 Hours", "0"),
          ];

          Constants.claims_sectionsList2c_1 = [
            claims_sections_gridmodel("Within 5 Hours", "0"),
            claims_sections_gridmodel("Within 12 Hours", "0"),
            claims_sections_gridmodel("After 12 Hours", "0"),
          ];
          Constants.claims_droupedChartData1 = processDataForClaimsGroups1({});
          print("dgjhsd1 ${Constants.claims_droupedChartData1}");
        }
        if (selectedButton1 == 2) {
          if (kDebugMode) {
            print("ghjlkkgjgg 2 ${payload}" + response.body);
            /*  print("ghjgjgg " + response.body.runtimeType.toString());*/
          }

          isLoadingClaimsData2 = false;
          Constants.claims_deceased_ages_list2a = [];
          Constants.claims_sectionsList2a_1 = [
            claims_sections_gridmodel("Within 5 Hours", "0"),
            claims_sections_gridmodel("Within 12 Hours", "0"),
            claims_sections_gridmodel("Within 24 Hours", "0"),
            claims_sections_gridmodel("Within 2 Days", "0"),
            claims_sections_gridmodel("Within 5 Days", "0"),
            claims_sections_gridmodel("After 5 Days", "0"),
          ];
          Constants.claims_sectionsList2a = [
            claims_sections_gridmodel("Within 5 Hours", "0%"),
            claims_sections_gridmodel("Within 12 Hours", "0%"),
            claims_sections_gridmodel("Within 24 Hours", "0%"),
            claims_sections_gridmodel("Within 2 Days", "0%"),
            claims_sections_gridmodel("Within 5 Days", "0%"),
            claims_sections_gridmodel("After 5 Days", "0%"),
          ];

          Constants.claims_sectionsList2b = [
            claims_sections_gridmodel("Within 5 Hours", "0"),
            claims_sections_gridmodel("Within 12 Hours", "0"),
            claims_sections_gridmodel("Within 24 Hours", "0"),
            claims_sections_gridmodel("Within 2 Days", "0"),
            claims_sections_gridmodel("Within 5 Days", "0"),
            claims_sections_gridmodel("After 5 Days", "0"),
          ];

          Constants.claims_sectionsList2b_1 = [
            claims_sections_gridmodel("Within 5 Hours", "0"),
            claims_sections_gridmodel("Within 12 Hours", "0"),
            claims_sections_gridmodel("Within 24 Hours", "0"),
            claims_sections_gridmodel("Within 2 Days", "0"),
            claims_sections_gridmodel("Within 5 Days", "0"),
            claims_sections_gridmodel("After 5 Days", "0"),
          ];

          Constants.claims_sectionsList2c = [
            claims_sections_gridmodel("Within 5 Hours", "0"),
            claims_sections_gridmodel("Within 12 Hours", "0"),
            claims_sections_gridmodel("After 12 Hours", "0"),
          ];

          Constants.claims_sectionsList2c_1 = [
            claims_sections_gridmodel("Within 5 Hours", "0"),
            claims_sections_gridmodel("Within 12 Hours", "0"),
            claims_sections_gridmodel("After 12 Hours", "0"),
          ];
          Constants.claims_droupedChartData2 = processDataForClaimsGroups1({});
          print("dgjhsd,m1 ${Constants.claims_droupedChartData2}");
        }
      } else {
        int id_y = 1;
        var jsonResponse = jsonDecode(response.body);

        if (selectedButton1 == 1) {
          Constants.claims_salesbyagent1a = [];
          Constants.claims_bottomTitles1a = [];
          Constants.claims_maxY5a = 0;
          Constants.claims_details1a = [];
          Constants.claims_deceased_ages_list1a = [];
          Constants.claims_deceased_ages_list1a = List<int>.from(
            jsonResponse["deceased_ages_list"] ?? [],
          );

          Constants.claims_section_list1a = jsonResponse;

          List claims_details1a = jsonResponse["claims_list"] ?? [];
          for (var value in claims_details1a) {
            Map m = value as Map;
            // print("dfgffg1 ${m["policy_number"]} ${m["amount"]} $m");
            Constants.claims_details1a.add(
              Claims_Details(
                m["claim_reference"] ?? "",
                m["policy_num"] ?? "",
                m["claim_first_name"] ?? "",
                m["claim_last_name"] ?? "",
                m["claim_cell_number"] ?? "",
                double.parse((m["claim_amount"] ?? 0).toString()),
                m["policy_status"] ?? "",
                m["policy_reference"] ?? "",
                m["policy_life"] ?? "",
                m["claim_id_num"] ?? "",
                m["claim_date"] ?? "",
                m["claim_status_description"] ?? "",
              ),
            );
          }
          isLoadingClaimsData = false;
          claimsValue.value++;
          // print("jhkklioopoi ${Constants.claims_section_list1a.length}");
        } else if (selectedButton1 == 2) {
          Constants.claims_salesbyagent2a = [];
          Constants.claims_bottomTitles2a = [];
          Constants.claims_details2a = [];
          Constants.claims_maxY5b = 0;
          Constants.claims_deceased_ages_list2a = [];
          Constants.claims_deceased_ages_list2a = List<int>.from(
            jsonResponse["deceased_ages_list"] ?? [],
          );
          Constants.claims_section_list2a = jsonResponse;
          List claims_details2a = jsonResponse["claims_list"] ?? [];
          for (var value in claims_details2a) {
            Map m = value as Map;
            Constants.claims_details2a.add(
              Claims_Details(
                m["claim_reference"] ?? "",
                m["policy_num"] ?? "",
                m["claim_first_name"] ?? "",
                m["claim_last_name"] ?? "",
                m["claim_cell_number"] ?? "",
                double.parse((m["claim_amount"] ?? 0).toString()),
                m["policy_status"] ?? "",
                m["policy_reference"] ?? "",
                m["policy_life"] ?? "",
                m["claim_id_num"] ?? "",
                m["claim_date"] ?? "",
                m["claim_status_description"] ?? "",
              ),
            );
          }
          isLoadingClaimsData2 = false;
          claimsValue.value++;
        } else if (selectedButton1 == 3 && days_difference < 31) {
          Constants.claims_salesbyagent3a = [];
          Constants.claims_bottomTitles3a = [];
          Constants.claims_details3a = [];
          Constants.claims_maxY5c = 0;
          Constants.claims_deceased_ages_list3a = [];
          Constants.claims_deceased_ages_list3a = List<int>.from(
            jsonResponse["deceased_ages_list"] ?? [],
          );
          Constants.claims_section_list3a = jsonResponse;
          List claims_details3a = jsonResponse["claims_list"] ?? [];
          for (var value in claims_details3a) {
            Map m = value as Map;
            Constants.claims_details3a.add(
              Claims_Details(
                m["claim_reference"] ?? "",
                m["policy_num"] ?? "",
                m["claim_first_name"] ?? "",
                m["claim_last_name"] ?? "",
                m["claim_cell_number"] ?? "",
                double.parse((m["claim_amount"] ?? 0).toString()),
                m["policy_status"] ?? "",
                m["policy_reference"] ?? "",
                m["policy_life"] ?? "",
                m["claim_id_num"] ?? "",
                m["claim_date"] ?? "",
                m["claim_status_description"] ?? "",
              ),
            );
          }
          claimsValue.value++;
        } else {
          Constants.claims_salesbyagent3b = [];
          Constants.claims_bottomTitles3b = [];
          Constants.claims_details3a = [];
          Constants.claims_maxY5d = 0;
          Constants.claims_deceased_ages_list3b = [];
          Constants.claims_deceased_ages_list3b = List<int>.from(
            jsonResponse["deceased_ages_list"] ?? [],
          );
          Constants.claims_section_list3a = jsonResponse;

          List claims_details3a = jsonResponse["claims_list"] ?? [];
          for (var value in claims_details3a) {
            Map m = value as Map;
            Constants.claims_details3a.add(
              Claims_Details(
                m["claim_reference"] ?? "",
                m["policy_num"] ?? "",
                m["claim_first_name"] ?? "",
                m["claim_last_name"] ?? "",
                m["claim_cell_number"] ?? "",
                double.parse((m["claim_amount"] ?? 0).toString()),
                m["policy_status"] ?? "",
                m["policy_reference"] ?? "",
                m["policy_life"] ?? "",
                m["claim_id_num"] ?? "",
                m["claim_date"] ?? "",
                m["claim_status_description"] ?? "",
              ),
            );
          }
          claimsValue.value++;
        }

        Constants.claims_salesbyagent1b = [];

        //print("fthggth ${jsonResponse}");
        /*   if (selectedButton1 == 1) {
          jsonResponse = jsonDecode(Sample_Jsons.claims_mtd_data1a);
        } else {
          jsonResponse = jsonDecode(Sample_Jsons.claims_ytd_data2a);
        }*/
        // Process jsonResponse

        //var jsonResponse = jsonDecode(response.body);
        DateTime startDateTime = DateFormat('yyyy-MM-dd').parse(date_from);
        DateTime endDateTime = DateFormat('yyyy-MM-dd').parse(date_to);
        /* print("date_from $date_from");
        print("date_to $date_to");*/

        int days_difference1 = endDateTime.difference(startDateTime).inDays;
        int totalClaims = 0;

        int index = 0;

        if (jsonResponse["claims_percentages"].toString().isNotEmpty) {
          Map m1 = jsonResponse["claims_percentages"] ?? {};
          Map m2 = jsonResponse["claims_amounts"] ?? {};

          if (selectedButton1 == 1) {
            Constants.claims_by_category1a =
                jsonResponse["claims_by_category"] ?? {};
            Constants.claims_sum_by_category1a =
                jsonResponse["claims_sum_by_category"] ?? {};
            Map<String, int> predefinedCategories = {
              "Lodging": 0,
              "Processing": 0,
              "Finalised": 0,
            };

            Constants.claims_sum_paid1a = jsonResponse["sum_paid"] ?? 0.0;
            Constants.myClaimsSumOfPremiums1 = double.parse(
              (jsonResponse["sum_of_premiums"] ?? 0.0).toString(),
            );
            /* Map<String, dynamic> completedClaims =
                jsonResponse['claims_amounts']['complete'];
            totalCompleted = 0;
            totalCompletedCount = 0;
            totalOngoing = 0;
            totalOngoingCount = 0;
            totalDeclined = 0;
            totalDeclinedCount = 0;

            completedClaims.forEach((key, value) {
              if (kDebugMode) {
                print("dtfgfgjjggh0 ${key} ${value}");
              }
              if (value > 0) {
                totalCompleted += value;
                totalCompletedCount++;
              }
            });
*/
            /*    Map<String, dynamic> ongoingClaims =
                jsonResponse['claims_amounts']['ongoing'];
            ongoingClaims.forEach((key, value) {
              */ /*  if (kDebugMode) {
                print("dtfgfgjjggh1 ${key} ${value}");
              }*/ /*
              if (value > 0) {
                totalOngoing += value;
                totalOngoingCount++;
                */ /*if (kDebugMode) {
                  print("dtfgfgjjggh12 ${key} ${value}");
                }*/ /*
              }
            });

            Map<String, dynamic> declinedClaims =
                jsonResponse['claims_amounts']['declined'];
            declinedClaims.forEach((key, value) {
              if (value > 0) {
                totalDeclined += value;
                totalDeclinedCount++;
              }
              // if (kDebugMode) {
              //   print("dtfgfgjjggh2 ${key} ${value}");
              // }
            });
            Constants.claims_sum_paid1a = totalCompleted;
            Constants.claims_sum_declined1a = totalDeclined;
            Constants.claims_sum_ongoing1a = totalOngoing;

            Constants.claims_count_paid1a = totalCompletedCount;
            Constants.claims_count_declined1a = totalDeclinedCount;
            Constants.claims_count_ongoing1a = totalOngoingCount;*/

            Map<String, int> claimsByCategory = Map<String, int>.from(
              jsonResponse["claims_by_category"],
            );

            claims_by_category1a_processed = preprocessClaimsData(
              claimsByCategory,
            );

            claimsByCategory.forEach((key, value) {
              if (predefinedCategories.containsKey(key)) {
                predefinedCategories[key] = value;
              }
            });

            List<BarChartGroupData> barChartData = [];

            int indexbar1 = 0;
            predefinedCategories.forEach((category, value) {
              final color = categoryColors[category] ?? Colors.lightBlueAccent;
              final barGroup = BarChartGroupData(
                x: indexbar1,
                barRods: [
                  BarChartRodData(
                    width: 40,
                    color: color,
                    borderRadius: BorderRadius.circular(0),
                    toY: value.toDouble(),
                  ),
                ],
                showingTooltipIndicators: [0],
              );
              barChartData.add(barGroup);
              indexbar1++;
            });

            Constants.claims_barChartData1 = barChartData;

            DateTime thisMonth = DateTime.now();
            String formattedDate =
                "${thisMonth.year}-${thisMonth.month.toString().padLeft(2, '0')}-01";

            Constants.claims_maxY5a = 0;
            if (jsonResponse["claims_ratio_dict"] != null) {
              if (jsonResponse["claims_ratio_dict"][formattedDate] != null) {
                Constants.claims_ratio1a =
                    double.parse(
                      (jsonResponse["claims_ratio_dict"][formattedDate])
                          .toStringAsFixed(2),
                    ) *
                    100;
              }
            } else {
              Constants.claims_ratio1a = 0;
            }

            Constants.claims_paid_claims_amount1a = double.parse(
              (jsonResponse["sum_paid"] ?? "0").toString(),
            );
            Constants.claims_outstanding_claims_amount1a = double.parse(
              (jsonResponse["sum_outstanding"] ?? "0").toString(),
            );

            Constants.claims_repudiated_claims_amount1a = double.parse(
              (jsonResponse["sum_declined"] ?? "0").toString(),
            );
            // Constants.claims_sectionsList1a_1 = [
            //   claims_sections_gridmodel("Within 5 Hours",
            //       (m2["complete"]?["Within 5 Hours"] ?? "0").toString()),
            //   claims_sections_gridmodel("Within 12 Hours",
            //       (m2["complete"]?["Within 12 Hours"] ?? "0").toString()),
            //   claims_sections_gridmodel("Within 24 Hours",
            //       (m2["complete"]?["Within 24 Hours"] ?? "0").toString()),
            //   claims_sections_gridmodel("Within 2 Days",
            //       (m2["complete"]?["Within 48 Hours"] ?? "0").toString()),
            //   claims_sections_gridmodel("Within 5 Days",
            //       (m2["complete"]?["After 48 Hours"] ?? "0").toString()),
            //   claims_sections_gridmodel("After 5 Days",
            //       (m2["complete"]?["After 5 Days"] ?? "0").toString()),
            // ];
            // Constants.claims_sectionsList1a = [
            //   claims_sections_gridmodel("Within 5 Hours",
            //       (m1["complete"]?["Within 5 Hours"] ?? "0%").toString()),
            //   claims_sections_gridmodel("Within 12 Hours",
            //       (m1["complete"]?["Within 12 Hours"] ?? "0%").toString()),
            //   claims_sections_gridmodel("Within 24 Hours",
            //       (m1["complete"]?["Within 24 Hours"] ?? "0%").toString()),
            //   claims_sections_gridmodel("Within 2 Days",
            //       (m1["complete"]?["Within 48 Hours"] ?? "0%").toString()),
            //   claims_sections_gridmodel("Within 5 Days",
            //       (m1["complete"]?["After 48 Hours"] ?? "0%").toString()),
            //   claims_sections_gridmodel("After 5 Days",
            //       (m1["complete"]?["After 5 Days"] ?? "0%").toString()),
            // ];
            //
            // Constants.claims_sectionsList1b = [
            //   claims_sections_gridmodel("Within 5 Hours",
            //       (m1["ongoing"]?["Within 5 Hours"] ?? "0").toString()),
            //   claims_sections_gridmodel("Within 12 Hours",
            //       (m1["ongoing"]?["Within 12 Hours"] ?? "0").toString()),
            //   claims_sections_gridmodel("Within 24 Hours",
            //       (m1["ongoing"]?["Within 24 Hours"] ?? "0").toString()),
            //   claims_sections_gridmodel("Within 2 Days",
            //       (m1["ongoing"]?["Within 48 Hours"] ?? "0").toString()),
            //   claims_sections_gridmodel("Within 5 Days",
            //       (m1["ongoing"]?["After 48 Hours"] ?? "0").toString()),
            //   claims_sections_gridmodel("After 5 Days",
            //       (m1["ongoing"]?["After 5 Days"] ?? "0").toString()),
            // ];
            //
            // Constants.claims_sectionsList1b_1 = [
            //   claims_sections_gridmodel("Within 5 Hours",
            //       (m2["ongoing"]?["Within 5 Hours"] ?? "0").toString()),
            //   claims_sections_gridmodel("Within 12 Hours",
            //       (m2["ongoing"]?["Within 12 Hours"] ?? "0").toString()),
            //   claims_sections_gridmodel("Within 24 Hours",
            //       (m2["ongoing"]?["Within 24 Hours"] ?? "0").toString()),
            //   claims_sections_gridmodel("Within 2 Days",
            //       (m2["ongoing"]?["Within 48 Hours"] ?? "0").toString()),
            //   claims_sections_gridmodel("Within 5 Days",
            //       (m2["ongoing"]?["After 48 Hours"] ?? "0").toString()),
            //   claims_sections_gridmodel("After 5 Days",
            //       (m2["ongoing"]?["After 5 Days"] ?? "0").toString()),
            // ];
            //
            // Constants.claims_sectionsList1c = [
            //   claims_sections_gridmodel("Within 5 Hours",
            //       (m1["declined"]?["Within 5 Hours"] ?? "0").toString()),
            //   claims_sections_gridmodel("Within 12 Hours",
            //       (m1["declined"]?["Within 12 Hours"] ?? "0").toString()),
            //   claims_sections_gridmodel("After 12 Hours", ("0").toString()),
            // ];
            //
            // Constants.claims_sectionsList1c_1 = [
            //   claims_sections_gridmodel("Within 5 Hours",
            //       (m2["declined"]?["Within 5 Hours"] ?? "0").toString()),
            //   claims_sections_gridmodel("Within 12 Hours",
            //       (m2["declined"]?["Within 12 Hours"] ?? "0").toString()),
            //   claims_sections_gridmodel("After 12 Hours", ("0").toString()),
            // ];

            Constants.claims_ordinary_sales1a.add(
              OrdinalSales("All", totalClaims),
            );
            Constants.claims_ordinary_sales1a.add(
              OrdinalSales(
                "Logged",
                jsonResponse["claims_by_category"]["Logged"] ?? 0,
              ),
            );
            Constants.claims_ordinary_sales1a.add(
              OrdinalSales(
                "Processed",
                jsonResponse["claims_by_category"]["Processed"] ?? 0,
              ),
            );
            Constants.claims_ordinary_sales1a.add(
              OrdinalSales(
                "Finalised",
                jsonResponse["claims_by_category"]["deceased Finalised"] ?? 0,
              ),
            );

            Constants.claims_bardata5a.add(
              charts.Series<OrdinalSales, String>(
                id: 'BranchSales',
                domainFn: (OrdinalSales sale, _) => sale.branch,
                measureFn: (OrdinalSales sale, _) => sale.sales,
                data: Constants.claims_ordinary_sales1a,
                labelAccessorFn: (OrdinalSales sale, _) => '${sale.sales}',
              ),
            );
            print("fgjgghhgghgh4 $jsonResponse");
            Constants.claims_droupedChartData1 = processDataForClaimsGroups1(
              jsonResponse["claims_by_type"] ?? [],
            );
            claimsValue.value++;
          }
          if (selectedButton1 == 2) {
            print("dfgfhg $selectedButton1");
            Constants.claims_by_category2a =
                jsonResponse["claims_by_category"] ?? {};
            Constants.claims_sum_by_category2a =
                jsonResponse["claims_sum_by_category"] ?? {};

            jsonResponse["claims_sum_by_category"] ?? {};
            Map<String, int> predefinedCategories = {
              "Lodging": 0,
              "Processing": 0,
              "Finalised": 0,
            };

            Constants.claims_sum_paid2a = totalCompleted;
            Constants.claims_sum_declined2a = totalDeclined;
            Constants.claims_sum_ongoing2a = totalOngoing;

            Constants.claims_count_paid2a = totalCompletedCount;
            Constants.claims_count_declined2a = totalDeclinedCount;
            Constants.claims_count_ongoing2a = totalOngoingCount;
            Constants.jsonMonthlyClaimsData2 = jsonResponse;
            // Assuming jsonResponse["claims_ratio_dict"] is a Map
            Map claimsRatioDict = jsonResponse["claims_ratio_dict"];
            double sum = 0;
            int count = 0;

            claimsRatioDict.forEach((key, value) {
              if (value > 0) {
                // Check if the claims ratio value is greater than 0
                sum += value; // Add the value to the sum
                count++; // Increment the count of valid entries
              }
            });

            // Calculate the average claims ratio if count is not zero to avoid division by zero
            double averageClaimsRatio = count > 0 ? (sum / count) : 0;

            // Convert average to percentage and format
            Constants.claims_ratio2a =
                double.parse(averageClaimsRatio.toStringAsFixed(2)) * 100;

            Map<String, int> claimsByCategory = Map<String, int>.from(
              jsonResponse["claims_by_category"],
            );
            print("ffggffg ${claimsByCategory}");
            claims_by_category1a_processed = preprocessClaimsData(
              claimsByCategory,
            );
            claimsByCategory.forEach((key, value) {
              if (predefinedCategories.containsKey(key)) {
                predefinedCategories[key] = value;
              }
            });

            List<BarChartGroupData> barChartData = [];

            int indexbar1 = 0;
            predefinedCategories.forEach((category, value) {
              final color =
                  categoryColors[category] ??
                  Colors.lightBlueAccent; // Fallback color
              final barGroup = BarChartGroupData(
                x: indexbar1,
                barRods: [
                  BarChartRodData(
                    width: 40,
                    color: color,
                    borderRadius: BorderRadius.circular(0),
                    toY: value.toDouble(),
                  ),
                ],
                showingTooltipIndicators: [0],
              );
              barChartData.add(barGroup);
              indexbar1++;
            });

            Constants.claims_barChartData2 = barChartData;

            Map m1 = jsonResponse["claims_ratio_dict"] ?? {};
            if (kDebugMode) {
              // print("sajgsdh ${m1}");
            }
            Constants.jsonMonthlyClaimsData1 =
                jsonResponse["claims_ratio_dict"];
            Constants.jsonMonthlyClaimsPremiumData1 =
                jsonResponse["monthly_premiums_dict"];
            if (kDebugMode) {
              // print("hghgjhjh ${Constants.jsonMonthlyClaimsPremiumData1}");
            }

            double claims_ratio_count = 0;
            double claims_ratio_sum = 0;

            m1.forEach((key, value) {
              double new_value = double.parse(value.toString());
              if (new_value != null) {
                claims_ratio_count++;
                claims_ratio_sum += value;
              }
            });

            Constants.claims_maxY5a = 0;
            /* Constants.claims_paid_claims_amount2a =
                double.parse((jsonResponse["sum_paid"] ?? "0").toString());*/
            Constants.claims_paid_claims_amount2a = double.parse(
              (jsonResponse["sum_paid"] ?? "0").toString(),
            );
            Constants.myClaimsSumOfPremiums2 = double.parse(
              (jsonResponse["sum_of_premiums"] ?? 0.0).toString(),
            );

            Constants.claims_outstanding_claims_amount1b = double.parse(
              (jsonResponse["sum_outstanding"] ?? "0").toString(),
            );
            print("dgfgg ${jsonResponse["sum_outstanding"]}");

            Constants.claims_repudiated_claims_amount1b = double.parse(
              (jsonResponse["sum_declined"] ?? "0").toString(),
            );

            Constants.claims_sectionsList2a_1 = [
              claims_sections_gridmodel(
                "Within 5 Hours",
                (m2["complete"]?["Within 5 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 12 Hours",
                (m2["complete"]?["Within 12 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 24 Hours",
                (m2["complete"]?["Within 24 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 2 Days",
                (m2["complete"]?["Within 48 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 5 Days",
                (m2["complete"]?["After 48 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "After 5 Days",
                (m2["complete"]?["After 5 Days"] ?? "0").toString(),
              ),
            ];
            Constants.claims_sectionsList2a = [
              claims_sections_gridmodel(
                "Within 5 Hours",
                (m1["complete"]?["Within 5 Hours"] ?? "0%").toString(),
              ),
              claims_sections_gridmodel(
                "Within 12 Hours",
                (m1["complete"]?["Within 12 Hours"] ?? "0%").toString(),
              ),
              claims_sections_gridmodel(
                "Within 24 Hours",
                (m1["complete"]?["Within 24 Hours"] ?? "0%").toString(),
              ),
              claims_sections_gridmodel(
                "Within 2 Days",
                (m1["complete"]?["Within 48 Hours"] ?? "0%").toString(),
              ),
              claims_sections_gridmodel(
                "Within 5 Days",
                (m1["complete"]?["After 48 Hours"] ?? "0%").toString(),
              ),
              claims_sections_gridmodel(
                "After 5 Days",
                (m1["complete"]?["After 5 Days"] ?? "0%").toString(),
              ),
            ];

            Constants.claims_sectionsList2b = [
              claims_sections_gridmodel(
                "Within 5 Hours",
                (m1["ongoing"]?["Within 5 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 12 Hours",
                (m1["ongoing"]?["Within 12 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 24 Hours",
                (m1["ongoing"]?["Within 24 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 2 Days",
                (m1["ongoing"]?["Within 48 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 5 Days",
                (m1["ongoing"]?["After 48 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "After 5 Days",
                (m1["ongoing"]?["After 5 Days"] ?? "0").toString(),
              ),
            ];

            Constants.claims_sectionsList2b_1 = [
              claims_sections_gridmodel(
                "Within 5 Hours",
                (m2["ongoing"]?["Within 5 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 12 Hours",
                (m2["ongoing"]?["Within 12 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 24 Hours",
                (m2["ongoing"]?["Within 24 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 2 Days",
                (m2["ongoing"]?["Within 48 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 5 Days",
                (m2["ongoing"]?["After 48 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "After 5 Days",
                (m2["ongoing"]?["After 5 Days"] ?? "0").toString(),
              ),
            ];

            Constants.claims_sectionsList2c = [
              claims_sections_gridmodel(
                "Within 5 Hours",
                (m1["declined"]?["Within 5 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 12 Hours",
                (m1["declined"]?["Within 12 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel("After 12 Hours", ("0").toString()),
            ];

            Constants.claims_sectionsList2c_1 = [
              claims_sections_gridmodel(
                "Within 5 Hours",
                (m2["declined"]?["Within 5 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 12 Hours",
                (m2["declined"]?["Within 12 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel("After 12 Hours", ("0").toString()),
            ];
            Constants.claims_droupedChartData2 = processDataForClaimsGroups1(
              jsonResponse["claims_by_type"] ?? [],
            );
            print("dgjhsd2 ${Constants.claims_droupedChartData2}");
            claimsValue.value++;

            if (kDebugMode) {
              print(
                "Constants.claims_sectionsList1a ${Constants.claims_sectionsList2a}",
              );
            }

            Constants.claims_ordinary_sales2a.add(
              OrdinalSales("All", totalClaims),
            );
            Constants.claims_ordinary_sales2a.add(
              OrdinalSales(
                "Logged",
                jsonResponse["claims_by_category"]["intimation"] ?? 0,
              ),
            );
            Constants.claims_ordinary_sales2a.add(
              OrdinalSales(
                "Processed",
                jsonResponse["claims_by_category"]["complete"] ?? 0,
              ),
            );
            Constants.claims_ordinary_sales2a.add(
              OrdinalSales(
                "Finalised",
                jsonResponse["claims_by_category"]["deceased collection"] ?? 0,
              ),
            );

            Constants.claims_bardata5b.add(
              charts.Series<OrdinalSales, String>(
                id: 'BranchSales',
                domainFn: (OrdinalSales sale, _) => sale.branch,
                measureFn: (OrdinalSales sale, _) => sale.sales,
                data: Constants.claims_ordinary_sales2a,
                labelAccessorFn: (OrdinalSales sale, _) => '${sale.sales}',
              ),
            );
            Constants.claims_droupedChartData2 = processDataForClaimsGroups1(
              jsonResponse["claims_by_type"] ?? [],
            );
            // print("dgjhsd2 ${Constants.claims_droupedChartData2}");
          }
          if (selectedButton1 == 3 && days_difference1 <= 31) {
            Constants.claims_sum_paid3a = jsonResponse["sum_paid"];
            Constants.myClaimsSumOfPremiums3 = double.parse(
              (jsonResponse["sum_of_premiums"] ?? 0.0).toString(),
            );
            Constants.claims_by_category3a =
                jsonResponse["claims_by_category"] ?? {};
            Constants.claims_sum_by_category3a =
                jsonResponse["claims_sum_by_category"] ?? {};
            Constants.claims_count_paid3a = totalCompleted;
            Constants.claims_count_declined3a = totalDeclined;
            Constants.claims_count_ongoing3a = totalDeclined;

            Constants.claims_count_paid3a = totalCompletedCount;
            Constants.claims_count_declined3a = totalDeclinedCount;
            Constants.claims_count_ongoing3a = totalDeclinedCount;
            isLoadingClaimsData = false;
            claimsValue.value++;
            DateTime thisMonth = DateTime.parse(date_from);
            String formattedDate =
                "${thisMonth.year}-${thisMonth.month.toString().padLeft(2, '0')}-01";

            Constants.claims_ratio3a =
                double.parse(
                  (jsonResponse["claims_ratio_dict"][formattedDate])
                      .toStringAsFixed(2),
                ) *
                100;

            Map<String, int> predefinedCategories = {
              "Lodging": 0,
              "Processing": 0,
              "Finalised": 0,
            };

            Map<String, int> claimsByCategory = Map<String, int>.from(
              jsonResponse["claims_by_category"],
            );
            print("ffggffg ${claimsByCategory}");
            claims_by_category1a_processed = preprocessClaimsData(
              claimsByCategory,
            );
            claimsByCategory.forEach((key, value) {
              if (predefinedCategories.containsKey(key)) {
                predefinedCategories[key] = value;
              }
            });

            List<BarChartGroupData> barChartData = [];

            int indexbar1 = 0;
            predefinedCategories.forEach((category, value) {
              final color =
                  categoryColors[category] ??
                  Colors.lightBlueAccent; // Fallback color
              final barGroup = BarChartGroupData(
                x: indexbar1,
                barRods: [
                  BarChartRodData(
                    width: 40,
                    color: color,
                    borderRadius: BorderRadius.circular(0),
                    toY: value.toDouble(),
                  ),
                ],
                showingTooltipIndicators: [0],
              );
              barChartData.add(barGroup);
              indexbar1++;
            });

            Constants.claims_barChartData3 = barChartData;

            Constants.claims_paid_claims_amount1c = double.parse(
              (jsonResponse["sum_paid"] ?? "0").toString(),
            );
            Constants.claims_outstanding_claims_amount1c = double.parse(
              (jsonResponse["sum_outstanding"] ?? "0").toString(),
            );

            Constants.claims_repudiated_claims_amount1c = double.parse(
              (jsonResponse["sum_declined"] ?? "0").toString(),
            );
            Constants.claims_sectionsList3a_1 = [
              claims_sections_gridmodel(
                "Within 5 Hours",
                (m2["complete"]?["Within 5 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 12 Hours",
                (m2["complete"]?["Within 12 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 24 Hours",
                (m2["complete"]?["Within 24 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 2 Days",
                (m2["complete"]?["Within 48 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 5 Days",
                (m2["complete"]?["After 48 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "After 5 Days",
                (m2["complete"]?["After 5 Days"] ?? "0").toString(),
              ),
            ];
            Constants.claims_sectionsList3a = [
              claims_sections_gridmodel(
                "Within 5 Hours",
                (m1["complete"]?["Within 5 Hours"] ?? "0%").toString(),
              ),
              claims_sections_gridmodel(
                "Within 12 Hours",
                (m1["complete"]?["Within 12 Hours"] ?? "0%").toString(),
              ),
              claims_sections_gridmodel(
                "Within 24 Hours",
                (m1["complete"]?["Within 24 Hours"] ?? "0%").toString(),
              ),
              claims_sections_gridmodel(
                "Within 2 Days",
                (m1["complete"]?["Within 48 Hours"] ?? "0%").toString(),
              ),
              claims_sections_gridmodel(
                "Within 5 Days",
                (m1["complete"]?["After 48 Hours"] ?? "0%").toString(),
              ),
              claims_sections_gridmodel(
                "After 5 Days",
                (m1["complete"]?["After 5 Days"] ?? "0%").toString(),
              ),
            ];

            Constants.claims_sectionsList3b = [
              claims_sections_gridmodel(
                "Within 5 Hours",
                (m1["ongoing"]?["Within 5 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 12 Hours",
                (m1["ongoing"]?["Within 12 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 24 Hours",
                (m1["ongoing"]?["Within 24 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 2 Days",
                (m1["ongoing"]?["Within 48 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 5 Days",
                (m1["ongoing"]?["After 48 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "After 5 Days",
                (m1["ongoing"]?["After 5 Days"] ?? "0").toString(),
              ),
            ];

            Constants.claims_sectionsList3b_1 = [
              claims_sections_gridmodel(
                "Within 5 Hours",
                (m2["ongoing"]?["Within 5 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 12 Hours",
                (m2["ongoing"]?["Within 12 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 24 Hours",
                (m2["ongoing"]?["Within 24 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 2 Days",
                (m2["ongoing"]?["Within 48 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 5 Days",
                (m2["ongoing"]?["After 48 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "After 5 Days",
                (m2["ongoing"]?["After 5 Days"] ?? "0").toString(),
              ),
            ];

            Constants.claims_sectionsList3c = [
              claims_sections_gridmodel(
                "Within 5 Hours",
                (m1["declined"]?["Within 5 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 12 Hours",
                (m1["declined"]?["Within 12 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel("After 12 Hours", ("0").toString()),
            ];

            Constants.claims_sectionsList3c_1 = [
              claims_sections_gridmodel(
                "Within 5 Hours",
                (m2["declined"]?["Within 5 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 12 Hours",
                (m2["declined"]?["Within 12 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel("After 12 Hours", ("0").toString()),
            ];
            Constants.claims_droupedChartData3 = processDataForClaimsGroups1(
              jsonResponse["claims_by_type"],
            );
            claimsValue.value++;
            isLoadingClaimsData = false;
            claimsValue.value++;
          } else {
            Constants.claims_by_category3b =
                jsonResponse["claims_amounts"] ?? {};
            Constants.claims_sum_by_category3b =
                jsonResponse["claims_sum_by_category"] ?? {};
            Constants.claims_count_paid3b = totalCompleted;
            Constants.claims_count_declined3b = totalDeclined;
            Constants.claims_count_ongoing3b = totalDeclined;

            Constants.claims_count_paid3b = totalCompletedCount;
            Constants.claims_count_declined3b = totalDeclinedCount;
            Constants.claims_count_ongoing3b = totalDeclinedCount;
            // Assuming jsonResponse["claims_ratio_dict"] is a Map
            Map claimsRatioDict = jsonResponse["claims_ratio_dict"];
            double sum = 0;
            int count = 0;

            claimsRatioDict.forEach((key, value) {
              if (value > 0) {
                // Check if the claims ratio value is greater than 0
                sum += value; // Add the value to the sum
                count++; // Increment the count of valid entries
              }
            });

            // Calculate the average claims ratio if count is not zero to avoid division by zero
            double averageClaimsRatio = count > 0 ? (sum / count) : 0;

            // Convert average to percentage and format
            Constants.claims_ratio3b =
                double.parse(averageClaimsRatio.toStringAsFixed(2)) * 100;

            Map<String, int> predefinedCategories = {
              "Lodging": 0,
              "Processing": 0,
              "Finalised": 0,
            };

            Map<String, int> claimsByCategory = Map<String, int>.from(
              jsonResponse["claims_by_category"],
            );
            print("ffggffg ${claimsByCategory}");
            claims_by_category1a_processed = preprocessClaimsData(
              claimsByCategory,
            );
            claimsByCategory.forEach((key, value) {
              if (predefinedCategories.containsKey(key)) {
                predefinedCategories[key] = value;
              }
            });

            List<BarChartGroupData> barChartData = [];

            int indexbar1 = 0;
            predefinedCategories.forEach((category, value) {
              final color =
                  categoryColors[category] ??
                  Colors.lightBlueAccent; // Fallback color
              final barGroup = BarChartGroupData(
                x: indexbar1,
                barRods: [
                  BarChartRodData(
                    width: 40,
                    color: color,
                    borderRadius: BorderRadius.circular(0),
                    toY: value.toDouble(),
                  ),
                ],
                showingTooltipIndicators: [0],
              );
              barChartData.add(barGroup);
              indexbar1++;
            });

            Constants.claims_barChartData4 = barChartData;

            Constants.claims_paid_claims_amount1d = double.parse(
              (jsonResponse["sum_paid"] ?? "0").toString(),
            );
            Constants.myClaimsSumOfPremiums3 = double.parse(
              (jsonResponse["sum_of_premiums"] ?? 0.0).toString(),
            );
            Constants.claims_outstanding_claims_amount1d = double.parse(
              (jsonResponse["sum_outstanding"] ?? "0").toString(),
            );

            Constants.claims_repudiated_claims_amount1d = double.parse(
              (jsonResponse["sum_declined"] ?? "0").toString(),
            );
            Constants.claims_maxY5d = 0;
            Constants.claims_sectionsList3a_1 = [
              claims_sections_gridmodel(
                "Within 5 Hours",
                (m2["complete"]?["Within 5 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 12 Hours",
                (m2["complete"]?["Within 12 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 24 Hours",
                (m2["complete"]?["Within 24 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 2 Days",
                (m2["complete"]?["Within 48 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 5 Days",
                (m2["complete"]?["After 48 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "After 5 Days",
                (m2["complete"]?["After 5 Days"] ?? "0").toString(),
              ),
            ];
            Constants.claims_sectionsList3a = [
              claims_sections_gridmodel(
                "Within 5 Hours",
                (m1["complete"]?["Within 5 Hours"] ?? "0%").toString(),
              ),
              claims_sections_gridmodel(
                "Within 12 Hours",
                (m1["complete"]?["Within 12 Hours"] ?? "0%").toString(),
              ),
              claims_sections_gridmodel(
                "Within 24 Hours",
                (m1["complete"]?["Within 24 Hours"] ?? "0%").toString(),
              ),
              claims_sections_gridmodel(
                "Within 2 Days",
                (m1["complete"]?["Within 48 Hours"] ?? "0%").toString(),
              ),
              claims_sections_gridmodel(
                "Within 5 Days",
                (m1["complete"]?["After 48 Hours"] ?? "0%").toString(),
              ),
              claims_sections_gridmodel(
                "After 5 Days",
                (m1["complete"]?["After 5 Days"] ?? "0%").toString(),
              ),
            ];

            Constants.claims_sectionsList3b = [
              claims_sections_gridmodel(
                "Within 5 Hours",
                (m1["ongoing"]?["Within 5 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 12 Hours",
                (m1["ongoing"]?["Within 12 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 24 Hours",
                (m1["ongoing"]?["Within 24 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 2 Days",
                (m1["ongoing"]?["Within 48 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 5 Days",
                (m1["ongoing"]?["After 48 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "After 5 Days",
                (m1["ongoing"]?["After 5 Days"] ?? "0").toString(),
              ),
            ];

            Constants.claims_sectionsList3b_1 = [
              claims_sections_gridmodel(
                "Within 5 Hours",
                (m2["ongoing"]?["Within 5 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 12 Hours",
                (m2["ongoing"]?["Within 12 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 24 Hours",
                (m2["ongoing"]?["Within 24 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 2 Days",
                (m2["ongoing"]?["Within 48 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 5 Days",
                (m2["ongoing"]?["After 48 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "After 5 Days",
                (m2["ongoing"]?["After 5 Days"] ?? "0").toString(),
              ),
            ];
            Constants.claims_droupedChartData4 = processDataForClaimsGroups1(
              jsonResponse["claims_by_type"],
            );
            claimsValue.value++;

            Constants.claims_sectionsList3c = [
              claims_sections_gridmodel(
                "Within 5 Hours",
                (m1["declined"]?["Within 5 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 12 Hours",
                (m1["declined"]?["Within 12 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel("After 12 Hours", ("0").toString()),
            ];

            Constants.claims_sectionsList3c_1 = [
              claims_sections_gridmodel(
                "Within 5 Hours",
                (m2["declined"]?["Within 5 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel(
                "Within 12 Hours",
                (m2["declined"]?["Within 12 Hours"] ?? "0").toString(),
              ),
              claims_sections_gridmodel("After 12 Hours", ("0").toString()),
            ];

            Constants.claims_ordinary_sales3b.add(
              OrdinalSales("All", totalClaims),
            );
            Constants.claims_ordinary_sales3b.add(
              OrdinalSales(
                "Logged",
                jsonResponse["claims_by_category"]["intimation"] ?? 0,
              ),
            );
            Constants.claims_ordinary_sales3b.add(
              OrdinalSales(
                "Processed",
                jsonResponse["claims_by_category"]["complete"] ?? 0,
              ),
            );
            Constants.claims_ordinary_sales3b.add(
              OrdinalSales(
                "Finalised",
                jsonResponse["claims_by_category"]["deceased collection"] ?? 0,
              ),
            );
            Constants.claims_bardata5d.add(
              charts.Series<OrdinalSales, String>(
                id: 'BranchSales',
                domainFn: (OrdinalSales sale, _) => sale.branch,
                measureFn: (OrdinalSales sale, _) => sale.sales,
                data: Constants.claims_ordinary_sales3b,
                // Set a label accessor to control the text of the bar label.
                labelAccessorFn: (OrdinalSales sale, _) => '${sale.sales}',
              ),
            );
            isLoadingClaimsData = false;
            claimsValue.value++;
          }

          //print("days_difference1_claims $days_difference1");
          isLoadingClaimsData = false;
          claimsValue.value++;
        }
      }
    });
  } on Exception catch (_, exception) {
    //Exception exc = exception as Exception;
    print(exception);
  }
}

String getEmployeeById(int cec_employeeid) {
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

String getBranchById(int branch_id) {
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

Map<String, double> preprocessClaimsData(Map<String, dynamic> originalData) {
  Map<String, double> defaultData = {
    "Lodging": 0.0,
    "Processing": 0.0,
    "Finalised": 0.0,
  };

  originalData.forEach((key, value) {
    if (defaultData.containsKey(key)) {
      defaultData[key] = double.parse(value.toString());
    }
  });

  return defaultData;
}

Map<String, Color> categoryColors = {
  "Lodging": Colors.grey,
  "Processing": Colors.blue,
  "Finalised": Colors.orange,
};

List<ClaimStageCategory> processDataForClaimsGroups1(
  Map<String, dynamic> claims_by_type2,
) {
  Map<String, dynamic> claims_by_type = {};
  if (claims_by_type2.isEmpty) {
    claims_by_type = {
      "claims_by_type": {
        "assessing": 0,
        "complete": 0,
        "deceased collection": 0,
      },
    };
  } else {
    claims_by_type = claims_by_type2;
  }

  Map<String, String> status_to_main_cat = {
    "First Notification of Loss": "Lodging",
    "intimation": "Lodging",
    "parked": "Lodging",
    "processing": "Processing",
    "deceased collection": "Closed",
    "failed processing": "Closed",
    "failed_synopsis": "Closed",
    "Already exist": "Closed",
  };
  /* Map<String, String> status_to_main_cat = {
    "Already exist": "Finalised",
    "First Notification of Loss": "Lodging",
    "deceased collection": "Lodging",
    "failed processing": "Lodging",
    "fnol": "Lodging",
    "intimation": "Lodging",
    "parked": "Processing"
  };*/

  Map<String, Map<String, int>> reorganized = {
    "Processing": {
      for (var k in status_to_main_cat.keys.where(
        (k) => status_to_main_cat[k] == "Processing",
      ))
        k: 0,
    },
    "Lodging": {
      for (var k in status_to_main_cat.keys.where(
        (k) => status_to_main_cat[k] == "Lodging",
      ))
        k: 0,
    },
    "Closed": {
      for (var k in status_to_main_cat.keys.where(
        (k) => status_to_main_cat[k] == "Closed",
      ))
        k: 0,
    },
    "Other": {},
  };

  claims_by_type.forEach((type, count) {
    String mainCat = status_to_main_cat[type] ?? "Other";
    // Ensure count is treated as an int
    int countAsInt = (count is int)
        ? count
        : int.tryParse(count.toString()) ?? 0;
    reorganized[mainCat]![type] = countAsInt;
  });

  List<ClaimStageCategory> categories = [];

  reorganized.forEach((categoryName, categoryItems) {
    List<ClaimStageCategoryItem> items = categoryItems.entries
        .map(
          (entry) => ClaimStageCategoryItem(
            title: capitalizeWords(entry.key),
            count: entry.value,
          ),
        )
        .toList();

    items.sort((a, b) => b.count.compareTo(a.count));

    categories.add(
      ClaimStageCategory(name: capitalizeWords(categoryName), items: items),
    );
  });

  return categories;
}

String capitalizeWords(String input) {
  return input.replaceAllMapped(RegExp(r'(\b[a-z])'), (Match match) {
    return match.group(0)!.toUpperCase();
  });
}
