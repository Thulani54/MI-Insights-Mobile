import 'dart:convert';
import 'dart:math';

import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../constants/Constants.dart';
import '../../models/OrdinalSales.dart';
import '../../models/SalesByAgent.dart';
import '../../models/SalesDataResponse.dart';
import '../../screens/Reports/Executive/ExecutiveSalesReport.dart';
import '../../screens/Reports/MarketingReport.dart';
import '../../utils/login_utils.dart';

List<DateTime> holidays = [
  DateTime(2024, 1, 1), // New Year's Day
  // For Good Friday and Easter Monday, I need to calculate based on the Easter date for the year 2024
  DateTime(2024, 3, 21), // Human Rights Day
  DateTime(2024, 4, 27), // Freedom Day
  DateTime(2024, 5, 1), // Workers' Day
  DateTime(2024, 6,
      16), // Youth Day, observed on the following Monday if it falls on a Sunday
  DateTime(2024, 8, 9), // National Women's Day
  DateTime(2024, 9, 24), // Heritage Day
  DateTime(2024, 12, 16), // Day of Reconciliation
  DateTime(2024, 12, 25), // Christmas Day
  DateTime(2024, 12, 26), // Day of Goodwill
];
Map<String, dynamic> leads_jsonResponse1a = {};
Map<String, dynamic> leads_jsonResponse2a = {};
Map<String, dynamic> leads_jsonResponse3a = {};
Map<String, dynamic> leads_jsonResponse4a = {};

Future<void> getExecutiveLeadsReport(String dateFrom, String dateTo,
    int selectedButton1, int daysDifference, BuildContext context) async {
  try {
    String baseUrl =
        "${Constants.analitixAppBaseUrl}sales/get_normalized_leads_data/";
    if (Constants.myUserRoleLevel.toLowerCase() == "tester") {
      baseUrl =
          "${Constants.analitixAppBaseUrl}sales/get_normalized_leads_data_test/";
    }

    if (kDebugMode) {
      print(baseUrl);
    }

    if (selectedButton1 == 1) {
      isLoadingMarketingData = true;
    } else if (selectedButton1 == 2) {
      isLoadingMarketingData = true;
    } else if (selectedButton1 == 3 && daysDifference <= 31) {
      isLoadingMarketingData = true;
    } else if (selectedButton1 == 3 && daysDifference > 31) {
      isLoadingMarketingData = true;
    }
    // Trigger UI update to show loading state
    marketingValue.value++;

    Map<String, String>? payload = {
      "client_id": "${Constants.cec_client_id}",
      "start_date": dateFrom,
      "end_date": dateTo
    };

    await http
        .post(
            Uri.parse(
              baseUrl,
            ),
            body: payload)
        .then((value) {
      http.Response response = value;
      print("hjkjkjgggg1 $dateFrom $dateTo $payload ${response.body} ");
      print("📊 Executive Leads Report - selectedButton1: $selectedButton1, daysDifference: $daysDifference");
      if (kDebugMode) {
        //print("baseUrljhjh $selectedButton1 $baseUrl");
      }
      if (response.statusCode != 200) {
        if (kDebugMode) {
          print("yhgghgh ${response.body}");
        }
        sectionsList = [
          gridmodel1("Submitted", 0, 0),
          gridmodel1("Captured", 0, 0),
          gridmodel1("Declined", 0, 0),
        ];
        sectionsListPercentages = [
          0,
          0,
          0,
        ];

        sectionsList2 = [
          gridmodel1("Total Members", 0, 0),
          gridmodel1("Main Under 65", 0, 0),
          gridmodel1("Main Under 85", 0, 0),
          gridmodel1("Main Over 85", 0, 0),
          gridmodel1("Extended", 0, 0),
        ];
        sectionsList3 = [
          gridmodel1("0 - 1 WEEK", 0, 0),
          gridmodel1("1 - 2 WEEKS", 0, 0),
          gridmodel1(">2 WEEKS", 0, 0),
        ];
        isLoadingMarketingData = false;
        marketingValue.value++;
        return;
      } else {
        var jsonResponse = jsonDecode(response.body);
        if (kDebugMode) {
          print("jhjkkhh $jsonResponse");
        }
        if (jsonResponse["error"] == "No data found for the given date range") {
          sectionsList = [
            gridmodel1("Submitted", 0, 0),
            gridmodel1("Captured", 0, 0),
            gridmodel1("Declined", 0, 0),
          ];

          sectionsList2 = [
            gridmodel1("Total Members", 0, 0),
            gridmodel1("Main Under 65", 0, 0),
            gridmodel1("Main Under 85", 0, 0),
            gridmodel1("Main Over 85", 0, 0),
            gridmodel1("Extended", 0, 0),
          ];
          sectionsList3 = [
            gridmodel1("0 - 1 WEEK", 0, 0),
            gridmodel1("1 - 2 WEEKS", 0, 0),
            gridmodel1(">2 WEEKS", 0, 0),
          ];
          sectionsListPercentages = [
            0,
            0,
            0,
          ];
          isLoadingMarketingData = false;
          marketingValue.value++;
          return;
        }

        if (selectedButton1 == 1) {
          Map m1LeadStatusCounts = jsonResponse["lead_status_counts"] ?? {};

          Constants.leads_rejection_rate1a =
              (jsonResponse["rejection_rate_percentage"] ?? 0.0) / 100;

          int totalLeads = (m1LeadStatusCounts["completed"] ?? 0) +
              (m1LeadStatusCounts["submitted"] ?? 0) +
              (m1LeadStatusCounts["server_rejected"] ?? 0) +
              (m1LeadStatusCounts["callback"] ?? 0) +
              (m1LeadStatusCounts["not_qualified"] ?? 0) +
              (m1LeadStatusCounts["unknown"] ?? 0);

          int totalRejected = (m1LeadStatusCounts["server_rejected"] ?? 0) +
              (m1LeadStatusCounts["not_qualified"] ?? 0);

          Constants.exec_leads_sectionsList1a[0].amount = totalLeads;
          Constants.exec_leads_sectionsList1a[0].percentage = 1;
          Constants.exec_leads_sectionsList1a[1].amount =
              (m1LeadStatusCounts["submitted"] ?? 0) +
                  (m1LeadStatusCounts["callback"] ?? 0) +
                  (m1LeadStatusCounts["completed"] ?? 0) +
                  (m1LeadStatusCounts["unknown"] ?? 0);
          Constants.exec_leads_sectionsList1a[1].percentage =
              (Constants.exec_leads_sectionsList1a[1].amount /
                  Constants.exec_leads_sectionsList1a[0].amount);

          Constants.exec_leads_sectionsList1a[2].percentage =
              (1 - Constants.exec_leads_sectionsList1a[1].percentage);
          Constants.exec_leads_sectionsList1a[2].amount = totalRejected;
          Constants.quoteAcceptance_rate[0] =
              (Constants.exec_leads_sectionsList1a[1].amount) / (totalLeads);

          leads_jsonResponse1a = formatMap(
              Map<String, dynamic>.from(jsonResponse["reasons_group"]));
          print("asghsa $leads_jsonResponse1a");

          var hourlySummary = jsonResponse["hourly_summary"];

          // Reset the FlSpot lists
          Constants.leads_spots1a = [];
          Constants.leads_spots1b = [];

          // Create a map to store the sum of leads for each hour
          Map<int, int> hourlyLeadsSubmittedSum = {};
          Map<int, int> hourlyLeadsCompletedSum = {};

          // Iterate through the hourly_summary to sum the leads for each hour
          for (var entry in hourlySummary) {
            int hour = int.parse((entry["hour"] ?? 0).toString());
            int leadsSubmittedCount =
                int.parse((entry["leads_submitted_count"] ?? 0).toString());
            int leadsCompletedCount =
                int.parse((entry["leads_completed_count"] ?? 0).toString());

            if (hourlyLeadsSubmittedSum.containsKey(hour)) {
              hourlyLeadsSubmittedSum[hour] =
                  hourlyLeadsSubmittedSum[hour]! + leadsSubmittedCount;
            } else {
              hourlyLeadsSubmittedSum[hour] = leadsSubmittedCount;
            }

            if (hourlyLeadsCompletedSum.containsKey(hour)) {
              hourlyLeadsCompletedSum[hour] =
                  hourlyLeadsCompletedSum[hour]! + leadsCompletedCount;
            } else {
              hourlyLeadsCompletedSum[hour] = leadsCompletedCount;
            }
          }

          // Convert the summed leads data to FlSpots and add them to the lists
          hourlyLeadsSubmittedSum.forEach((hour, totalSubmitted) {
            Constants.leads_spots1a
                .add(FlSpot(hour.toDouble(), totalSubmitted.toDouble()));
          });

          hourlyLeadsCompletedSum.forEach((hour, totalCompleted) {
            Constants.leads_spots1b
                .add(FlSpot(hour.toDouble(), totalCompleted.toDouble()));
          });

          // Sort the FlSpot lists by the x value (hour)
          Constants.leads_spots1a.sort((a, b) => a.x.compareTo(b.x));
          Constants.leads_spots1b.sort((a, b) => a.x.compareTo(b.x));

          var daily_leads_summary = jsonResponse["daily_summary"];

          Constants.d_leads_spots1a = [];
          Constants.d_leads_spots1b = [];

          // Create a map to store the sum of leads for each day
          Map<int, int> dailyLeadsSubmittedSum = {};
          Map<int, int> dailyLeadsCompletedSum = {};

          // First pass: collect all the data including weekends
          for (var entry in daily_leads_summary) {
            DateTime entryDate = DateTime.parse(entry["date"]);
            int day = entryDate.day;
            int leadsSubmittedCount =
                int.parse((entry["leads_submitted_count"] ?? 0).toString());
            int leadsCompletedCount =
                int.parse((entry["leads_completed_count"] ?? 0).toString());

            if (dailyLeadsSubmittedSum.containsKey(day)) {
              dailyLeadsSubmittedSum[day] =
                  dailyLeadsSubmittedSum[day]! + leadsSubmittedCount;
            } else {
              dailyLeadsSubmittedSum[day] = leadsSubmittedCount;
            }

            if (dailyLeadsCompletedSum.containsKey(day)) {
              dailyLeadsCompletedSum[day] =
                  dailyLeadsCompletedSum[day]! + leadsCompletedCount;
            } else {
              dailyLeadsCompletedSum[day] = leadsCompletedCount;
            }
          }

          // Second pass: Handle weekend aggregation
          Map<int, int> adjustedLeadsSubmittedSum = {};
          Map<int, int> adjustedLeadsCompletedSum = {};

          // Copy all weekday data first
          for (var entry in daily_leads_summary) {
            DateTime entryDate = DateTime.parse(entry["date"]);
            int day = entryDate.day;
            int weekday = entryDate.weekday; // 1=Monday, 7=Sunday

            // If it's a weekday (Monday=1 to Friday=5), keep the data
            if (weekday >= 1 && weekday <= 5) {
              adjustedLeadsSubmittedSum[day] = dailyLeadsSubmittedSum[day] ?? 0;
              adjustedLeadsCompletedSum[day] = dailyLeadsCompletedSum[day] ?? 0;
            }
          }

          // Now handle weekend data - add to following Monday
          for (var entry in daily_leads_summary) {
            DateTime entryDate = DateTime.parse(entry["date"]);
            int day = entryDate.day;
            int weekday = entryDate.weekday; // 1=Monday, 7=Sunday

            // If it's a weekend (Saturday=6 or Sunday=7)
            if (weekday == 6 || weekday == 7) {
              // Find the next Monday
              DateTime nextMonday = entryDate;
              while (nextMonday.weekday != 1) {
                nextMonday = nextMonday.add(Duration(days: 1));
              }

              int mondayDay = nextMonday.day;

              // Add weekend leads to Monday
              int weekendSubmitted = dailyLeadsSubmittedSum[day] ?? 0;
              int weekendCompleted = dailyLeadsCompletedSum[day] ?? 0;

              adjustedLeadsSubmittedSum[mondayDay] =
                  (adjustedLeadsSubmittedSum[mondayDay] ?? 0) +
                      weekendSubmitted;
              adjustedLeadsCompletedSum[mondayDay] =
                  (adjustedLeadsCompletedSum[mondayDay] ?? 0) +
                      weekendCompleted;
            }
          }

          // Create FlSpots using the adjusted data (without weekends)
          for (int day in adjustedLeadsSubmittedSum.keys) {
            Constants.d_leads_spots1a.add(FlSpot(
                day.toDouble(), adjustedLeadsSubmittedSum[day]!.toDouble()));
          }

          for (int day in adjustedLeadsCompletedSum.keys) {
            Constants.d_leads_spots1b.add(FlSpot(
                day.toDouble(), adjustedLeadsCompletedSum[day]!.toDouble()));
          }

          // Sort the FlSpots by x value (day) to ensure proper order
          Constants.d_leads_spots1a.sort((a, b) => a.x.compareTo(b.x));
          Constants.d_leads_spots1b.sort((a, b) => a.x.compareTo(b.x));

          // Convert the summed leads data to FlSpots and add them to the lists
          dailyLeadsSubmittedSum.forEach((day, totalSubmitted) {
            Constants.d_leads_spots1a
                .add(FlSpot(day.toDouble(), totalSubmitted.toDouble()));
          });

          dailyLeadsCompletedSum.forEach((day, totalCompleted) {
            Constants.d_leads_spots1b
                .add(FlSpot(day.toDouble(), totalCompleted.toDouble()));
          });

          // Sort the FlSpot lists by the x value (hour)
          Constants.d_leads_spots1a.sort((a, b) => a.x.compareTo(b.x));
          Constants.d_leads_spots1b.sort((a, b) => a.x.compareTo(b.x));

          List top_employees1a = jsonResponse["agent_stats"] ?? [];
          Constants.field_leadbyagent1a = [];
          for (var value in top_employees1a) {
            Map m = value as Map;

            Constants.field_leadbyagent1a.add(
              FieldsSalesByAgent(
                cec_employeeid: m["cec_employeeid"],
                employee_name: m["employee_name"],
                total_leads: m["total_leads"],
                completed_leads: m["completed_leads"],
                completion_percentage: m["completion_percentage"] ?? 0.0,
                decline_rate: m["decline_rate"] ?? 0.0,
                submitted: m["submitted"] ?? 0,
                completed: m["completed"] ?? 0,
                not_qualified: m["not_qualified"] ?? 0,
                no_documents_count: m["no_documents_count"] ?? 0,
                rejected_by_server_count: m["rejected_by_server_count"] ?? 0,
                incomplete_no_desc_count: m["incomplete_no_desc_count"] ?? 0,
                transfer_count: m["transfer_count"] ?? 0,
                call_back_count: m["call_back_count"] ?? 0,
                no_contact_voice_mail_count:
                    m["no_contact_voice_mail_count"] ?? 0,
                no_contact_no_answer_count:
                    m["no_contact_no_answer_count"] ?? 0,
                does_not_qualify_count: m["does_not_qualify_count"] ?? 0,
                prank_call_count: m["prank_call_count"] ?? 0,
                duplicate_lead_count: m["duplicate_lead_count"] ?? 0,
                mystery_shopper_count: m["mystery_shopper_count"] ?? 0,
                not_interested_count: m["not_interested_count"] ?? 0,
                no_contact_number_does_not_exist_count:
                    m["no_contact_number_does_not_exist_count"] ?? 0,
              ),
            );
          }

          // Print the results for verification

          if (kDebugMode) {
            // print("Leads Spots 1a (Submitted): ${Constants.leads_spots1a}");
            //  print("Leads Spots 1b (Completed): ${Constants.leads_spots1b}");
          }
        } else if (selectedButton1 == 2) {
          // Extract lead status counts with null fallback
          Map<String, dynamic> m1_lead_status_counts =
              Map<String, dynamic>.from(
                  jsonResponse["lead_status_counts"] ?? {});

          // Calculate rejection rate and total leads
          Constants.leads_rejection_rate2a =
              (jsonResponse["rejection_rate_percentage"] ?? 0.0) / 100;

          int total_leads = (m1_lead_status_counts["completed"] ?? 0) +
              (m1_lead_status_counts["submitted"] ?? 0) +
              (m1_lead_status_counts["server_rejected"] ?? 0) +
              (m1_lead_status_counts["callback"] ?? 0) +
              (m1_lead_status_counts["not_qualified"] ?? 0) +
              (m1_lead_status_counts["unknown"] ?? 0);

          int total_rejected = (m1_lead_status_counts["server_rejected"] ?? 0) +
              (m1_lead_status_counts["not_qualified"] ?? 0);

          // Update Constants
          Constants.exec_leads_sectionsList2a[0].amount = total_leads;
          Constants.exec_leads_sectionsList2a[0].percentage = 1;
          Constants.exec_leads_sectionsList2a[1].amount =
              (m1_lead_status_counts["submitted"] ?? 0) +
                  (m1_lead_status_counts["callback"] ?? 0) +
                  (m1_lead_status_counts["completed"] ?? 0) +
                  (m1_lead_status_counts["unknown"] ?? 0);
          Constants.exec_leads_sectionsList2a[1].percentage =
              Constants.exec_leads_sectionsList2a[1].amount / total_leads;

          Constants.exec_leads_sectionsList2a[2].percentage =
              1 - Constants.exec_leads_sectionsList2a[1].percentage;
          Constants.exec_leads_sectionsList2a[2].amount = total_rejected;
          Constants.quoteAcceptance_rate[1] =
              Constants.exec_leads_sectionsList2a[1].amount / total_leads;

          // Update lead reasons
          leads_jsonResponse2a = formatMap(
              Map<String, dynamic>.from(jsonResponse["reasons_group"] ?? {}));

          // Process top employees
          List<dynamic> top_employees2a = jsonResponse["agent_stats"] ?? [];
          for (var value in top_employees2a) {
            Map<String, dynamic> m = Map<String, dynamic>.from(value);
            Constants.field_leadbyagent2a.add(
              FieldsSalesByAgent(
                cec_employeeid: m["cec_employeeid"],
                employee_name: m["employee_name"],
                total_leads: m["total_leads"] ?? 0,
                completed_leads: m["completed_leads"] ?? 0,
                completion_percentage: m["completion_percentage"] ?? 0.0,
                decline_rate: m["decline_rate"] ?? 0.0,
                submitted: m["submitted"] ?? 0,
                completed: m["completed"] ?? 0,
                not_qualified: m["not_qualified"] ?? 0,
                no_documents_count: m["no_documents_count"] ?? 0,
                rejected_by_server_count: m["rejected_by_server_count"] ?? 0,
                incomplete_no_desc_count: m["incomplete_no_desc_count"] ?? 0,
                transfer_count: m["transfer_count"] ?? 0,
                call_back_count: m["call_back_count"] ?? 0,
                no_contact_voice_mail_count:
                    m["no_contact_voice_mail_count"] ?? 0,
                no_contact_no_answer_count:
                    m["no_contact_no_answer_count"] ?? 0,
                does_not_qualify_count: m["does_not_qualify_count"] ?? 0,
                prank_call_count: m["prank_call_count"] ?? 0,
                duplicate_lead_count: m["duplicate_lead_count"] ?? 0,
                mystery_shopper_count: m["mystery_shopper_count"] ?? 0,
                not_interested_count: m["not_interested_count"] ?? 0,
                no_contact_number_does_not_exist_count:
                    m["no_contact_number_does_not_exist_count"] ?? 0,
              ),
            );
          }

          // Process hourly summary
          List<dynamic> hourly_summary = jsonResponse["hourly_summary"] ?? [];
          Constants.leads_spots2a.clear();
          Constants.leads_spots2b.clear();

          Map<int, int> hourlyLeadsSubmittedSum = {};
          Map<int, int> hourlyLeadsCompletedSum = {};

          for (var entry in hourly_summary) {
            int hour = int.parse(entry["hour"].toString());
            int leadsSubmittedCount =
                int.parse(entry["leads_submitted_count"].toString());
            int leadsCompletedCount =
                int.parse(entry["leads_completed_count"].toString());

            hourlyLeadsSubmittedSum[hour] =
                (hourlyLeadsSubmittedSum[hour] ?? 0) + leadsSubmittedCount;
            hourlyLeadsCompletedSum[hour] =
                (hourlyLeadsCompletedSum[hour] ?? 0) + leadsCompletedCount;
          }

          hourlyLeadsSubmittedSum.forEach((hour, totalSubmitted) {
            Constants.leads_spots2a
                .add(FlSpot(hour.toDouble(), totalSubmitted.toDouble()));
          });

          hourlyLeadsCompletedSum.forEach((hour, totalCompleted) {
            Constants.leads_spots2b
                .add(FlSpot(hour.toDouble(), totalCompleted.toDouble()));
          });

          Constants.leads_spots2a.sort((a, b) => a.x.compareTo(b.x));
          Constants.leads_spots2b.sort((a, b) => a.x.compareTo(b.x));

          // Process daily summary
          List<dynamic> daily_leads_summary =
              jsonResponse["daily_summary"] ?? [];
          Constants.d_leads_spots2a.clear();
          Constants.d_leads_spots2b.clear();

          Map<int, int> dailyLeadsSubmittedSum = {};
          Map<int, int> dailyLeadsCompletedSum = {};

          // First pass: Collect all daily data
          for (var entry in daily_leads_summary) {
            DateTime entryDate = DateTime.parse(entry["date"]);
            int day = entryDate.day;
            int leadsSubmittedCount =
                int.parse(entry["leads_submitted_count"].toString());
            int leadsCompletedCount =
                int.parse(entry["leads_completed_count"].toString());

            dailyLeadsSubmittedSum[day] =
                (dailyLeadsSubmittedSum[day] ?? 0) + leadsSubmittedCount;
            dailyLeadsCompletedSum[day] =
                (dailyLeadsCompletedSum[day] ?? 0) + leadsCompletedCount;
          }

          // Second pass: Handle weekend aggregation (push weekend leads to next Monday)
          Map<int, int> adjustedLeadsSubmittedSum = {};
          Map<int, int> adjustedLeadsCompletedSum = {};

          // Copy all weekday data first
          for (var entry in daily_leads_summary) {
            DateTime entryDate = DateTime.parse(entry["date"]);
            int day = entryDate.day;
            int weekday = entryDate.weekday; // 1=Monday, 7=Sunday

            // If it's a weekday (Monday=1 to Friday=5), keep the data
            if (weekday >= 1 && weekday <= 5) {
              adjustedLeadsSubmittedSum[day] = dailyLeadsSubmittedSum[day] ?? 0;
              adjustedLeadsCompletedSum[day] = dailyLeadsCompletedSum[day] ?? 0;
            }
          }

          // Now handle weekend data - add to following Monday
          for (var entry in daily_leads_summary) {
            DateTime entryDate = DateTime.parse(entry["date"]);
            int day = entryDate.day;
            int weekday = entryDate.weekday; // 1=Monday, 7=Sunday

            // If it's a weekend (Saturday=6 or Sunday=7)
            if (weekday == 6 || weekday == 7) {
              // Find the next Monday
              DateTime nextMonday = entryDate;
              while (nextMonday.weekday != 1) {
                nextMonday = nextMonday.add(Duration(days: 1));
              }

              int mondayDay = nextMonday.day;

              // Add weekend leads to Monday
              int weekendSubmitted = dailyLeadsSubmittedSum[day] ?? 0;
              int weekendCompleted = dailyLeadsCompletedSum[day] ?? 0;

              adjustedLeadsSubmittedSum[mondayDay] =
                  (adjustedLeadsSubmittedSum[mondayDay] ?? 0) + weekendSubmitted;
              adjustedLeadsCompletedSum[mondayDay] =
                  (adjustedLeadsCompletedSum[mondayDay] ?? 0) + weekendCompleted;
            }
          }

          // Create FlSpots using the adjusted data (without weekends)
          for (int day in adjustedLeadsSubmittedSum.keys) {
            Constants.d_leads_spots2a.add(FlSpot(
                day.toDouble(), adjustedLeadsSubmittedSum[day]!.toDouble()));
          }
          for (int day in adjustedLeadsCompletedSum.keys) {
            Constants.d_leads_spots2b.add(FlSpot(
                day.toDouble(), adjustedLeadsCompletedSum[day]!.toDouble()));
          }

          // Sort the FlSpots by x value (day) to ensure proper order
          Constants.d_leads_spots2a.sort((a, b) => a.x.compareTo(b.x));
          Constants.d_leads_spots2b.sort((a, b) => a.x.compareTo(b.x));

          if (kDebugMode) {
            // Debug prints
          }
        } else if (selectedButton1 == 3) {
          // Extract lead status counts with null fallback
          Constants.exec_leads_sectionsList3a[0].amount = 0;
          Constants.exec_leads_sectionsList3a[1].amount = 0;
          Constants.exec_leads_sectionsList3a[2].amount = 0;

          Constants.exec_leads_sectionsList3a[0].percentage = 0;
          Constants.exec_leads_sectionsList3a[1].percentage = 0;
          Constants.exec_leads_sectionsList3a[2].percentage = 0;
          Map<String, dynamic> m1_lead_status_counts =
              Map<String, dynamic>.from(
                  jsonResponse["lead_status_counts"] ?? {});

          // Calculate rejection rate and total leads
          Constants.leads_rejection_rate3a =
              (jsonResponse["rejection_rate_percentage"] ?? 0.0) / 100;

          int total_leads = (m1_lead_status_counts["completed"] ?? 0) +
              (m1_lead_status_counts["submitted"] ?? 0) +
              (m1_lead_status_counts["server_rejected"] ?? 0) +
              (m1_lead_status_counts["callback"] ?? 0) +
              (m1_lead_status_counts["not_qualified"] ?? 0) +
              (m1_lead_status_counts["unknown"] ?? 0);

          int total_rejected = (m1_lead_status_counts["server_rejected"] ?? 0) +
              (m1_lead_status_counts["not_qualified"] ?? 0);

          // Update Constants

          Constants.exec_leads_sectionsList3a[0].amount = total_leads;
          Constants.exec_leads_sectionsList3a[0].percentage = 1;
          Constants.exec_leads_sectionsList3a[1].amount =
              (m1_lead_status_counts["submitted"] ?? 0) +
                  (m1_lead_status_counts["callback"] ?? 0) +
                  (m1_lead_status_counts["completed"] ?? 0) +
                  (m1_lead_status_counts["unknown"] ?? 0);
          Constants.exec_leads_sectionsList3a[1].percentage =
              Constants.exec_leads_sectionsList3a[1].amount / total_leads;

          Constants.exec_leads_sectionsList3a[2].percentage =
              1 - Constants.exec_leads_sectionsList3a[1].percentage;
          Constants.exec_leads_sectionsList3a[2].amount = total_rejected;
          Constants.quoteAcceptance_rate[2] =
              Constants.exec_leads_sectionsList3a[1].amount / total_leads;

          // Process hourly summary
          List<dynamic> hourly_summary = jsonResponse["hourly_summary"] ?? [];
          Constants.leads_spots3a.clear();
          Constants.leads_spots3b.clear();

          Map<int, int> hourlyLeadsSubmittedSum = {};
          Map<int, int> hourlyLeadsCompletedSum = {};

          for (var entry in hourly_summary) {
            int hour = int.parse(entry["hour"].toString());
            int leadsSubmittedCount =
                int.parse(entry["leads_submitted_count"].toString());
            int leadsCompletedCount =
                int.parse(entry["leads_completed_count"].toString());

            hourlyLeadsSubmittedSum[hour] =
                (hourlyLeadsSubmittedSum[hour] ?? 0) + leadsSubmittedCount;
            hourlyLeadsCompletedSum[hour] =
                (hourlyLeadsCompletedSum[hour] ?? 0) + leadsCompletedCount;
          }

          hourlyLeadsSubmittedSum.forEach((hour, totalSubmitted) {
            Constants.leads_spots3a
                .add(FlSpot(hour.toDouble(), totalSubmitted.toDouble()));
          });

          hourlyLeadsCompletedSum.forEach((hour, totalCompleted) {
            Constants.leads_spots3b
                .add(FlSpot(hour.toDouble(), totalCompleted.toDouble()));
          });

          Constants.leads_spots3a.sort((a, b) => a.x.compareTo(b.x));
          Constants.leads_spots3b.sort((a, b) => a.x.compareTo(b.x));

          // Process daily summary
          List<dynamic> daily_leads_summary =
              jsonResponse["daily_summary"] ?? [];
          Constants.d_leads_spots3a.clear();
          Constants.d_leads_spots3b.clear();

          Map<int, int> dailyLeadsSubmittedSum = {};
          Map<int, int> dailyLeadsCompletedSum = {};

          // First pass: Collect all daily data
          for (var entry in daily_leads_summary) {
            DateTime entryDate = DateTime.parse(entry["date"]);
            int day = entryDate.day;
            int leadsSubmittedCount =
                int.parse(entry["leads_submitted_count"].toString());
            int leadsCompletedCount =
                int.parse(entry["leads_completed_count"].toString());

            dailyLeadsSubmittedSum[day] =
                (dailyLeadsSubmittedSum[day] ?? 0) + leadsSubmittedCount;
            dailyLeadsCompletedSum[day] =
                (dailyLeadsCompletedSum[day] ?? 0) + leadsCompletedCount;
          }

          // Second pass: Handle weekend aggregation (push weekend leads to next Monday)
          Map<int, int> adjustedLeadsSubmittedSum = {};
          Map<int, int> adjustedLeadsCompletedSum = {};

          // Copy all weekday data first
          for (var entry in daily_leads_summary) {
            DateTime entryDate = DateTime.parse(entry["date"]);
            int day = entryDate.day;
            int weekday = entryDate.weekday; // 1=Monday, 7=Sunday

            // If it's a weekday (Monday=1 to Friday=5), keep the data
            if (weekday >= 1 && weekday <= 5) {
              adjustedLeadsSubmittedSum[day] = dailyLeadsSubmittedSum[day] ?? 0;
              adjustedLeadsCompletedSum[day] = dailyLeadsCompletedSum[day] ?? 0;
            }
          }

          // Now handle weekend data - add to following Monday
          for (var entry in daily_leads_summary) {
            DateTime entryDate = DateTime.parse(entry["date"]);
            int day = entryDate.day;
            int weekday = entryDate.weekday; // 1=Monday, 7=Sunday

            // If it's a weekend (Saturday=6 or Sunday=7)
            if (weekday == 6 || weekday == 7) {
              // Find the next Monday
              DateTime nextMonday = entryDate;
              while (nextMonday.weekday != 1) {
                nextMonday = nextMonday.add(Duration(days: 1));
              }

              int mondayDay = nextMonday.day;

              // Add weekend leads to Monday
              int weekendSubmitted = dailyLeadsSubmittedSum[day] ?? 0;
              int weekendCompleted = dailyLeadsCompletedSum[day] ?? 0;

              adjustedLeadsSubmittedSum[mondayDay] =
                  (adjustedLeadsSubmittedSum[mondayDay] ?? 0) + weekendSubmitted;
              adjustedLeadsCompletedSum[mondayDay] =
                  (adjustedLeadsCompletedSum[mondayDay] ?? 0) + weekendCompleted;
            }
          }

          // Create FlSpots using the adjusted data (without weekends)
          for (int day in adjustedLeadsSubmittedSum.keys) {
            Constants.d_leads_spots3a.add(FlSpot(
                day.toDouble(), adjustedLeadsSubmittedSum[day]!.toDouble()));
          }
          for (int day in adjustedLeadsCompletedSum.keys) {
            Constants.d_leads_spots3b.add(FlSpot(
                day.toDouble(), adjustedLeadsCompletedSum[day]!.toDouble()));
          }

          // Sort the FlSpots by x value (day) to ensure proper order
          Constants.d_leads_spots3a.sort((a, b) => a.x.compareTo(b.x));
          Constants.d_leads_spots3b.sort((a, b) => a.x.compareTo(b.x));
          Constants.field_leadbyagent3a = [];

          // Process top employees
          List<dynamic> top_employees3a = jsonResponse["agent_stats"] ?? [];
          for (var value in top_employees3a) {
            Map<String, dynamic> m = Map<String, dynamic>.from(value);

            Constants.field_leadbyagent3a.add(
              FieldsSalesByAgent(
                cec_employeeid: m["cec_employeeid"],
                employee_name: m["employee_name"],
                total_leads: m["total_leads"] ?? 0,
                completed_leads: m["completed_leads"] ?? 0,
                completion_percentage: m["completion_percentage"] ?? 0.0,
                decline_rate: m["decline_rate"] ?? 0.0,
                submitted: m["submitted"] ?? 0,
                completed: m["completed"] ?? 0,
                not_qualified: m["not_qualified"] ?? 0,
                no_documents_count: m["no_documents_count"] ?? 0,
                rejected_by_server_count: m["rejected_by_server_count"] ?? 0,
                incomplete_no_desc_count: m["incomplete_no_desc_count"] ?? 0,
                transfer_count: m["transfer_count"] ?? 0,
                call_back_count: m["call_back_count"] ?? 0,
                no_contact_voice_mail_count:
                    m["no_contact_voice_mail_count"] ?? 0,
                no_contact_no_answer_count:
                    m["no_contact_no_answer_count"] ?? 0,
                does_not_qualify_count: m["does_not_qualify_count"] ?? 0,
                prank_call_count: m["prank_call_count"] ?? 0,
                duplicate_lead_count: m["duplicate_lead_count"] ?? 0,
                mystery_shopper_count: m["mystery_shopper_count"] ?? 0,
                not_interested_count: m["not_interested_count"] ?? 0,
                no_contact_number_does_not_exist_count:
                    m["no_contact_number_does_not_exist_count"] ?? 0,
              ),
            );
          }

          // Update lead reasons
          leads_jsonResponse3a =
              Map<String, dynamic>.from(jsonResponse["reasons_group"] ?? {});

          // Debugging (optional)
          if (kDebugMode) {
            // Debug print statements can be added here if needed
          }
        }
        // Set loading to false when processing completes
        print("✅ Executive Leads Report Complete - Setting isLoadingMarketingData = false for selectedButton1: $selectedButton1");
        isLoadingMarketingData = false;
        // Trigger UI update to reflect loading state change
        marketingValue.value++;
      }
    });
  } on Exception catch (_, exception) {
    //Exception exc = exception as Exception;
    print(exception);
    sectionsList = [
      gridmodel1("Submitted", 0, 0),
      gridmodel1("Captured", 0, 0),
      gridmodel1("Declined", 0, 0),
    ];

    sectionsList2 = [
      gridmodel1("Total Members", 0, 0),
      gridmodel1("Main Under 65", 0, 0),
      gridmodel1("Main Under 85", 0, 0),
      gridmodel1("Main Over 85", 0, 0),
      gridmodel1("Extended", 0, 0),
    ];
    sectionsList3 = [
      gridmodel1("0 - 1 WEEK", 0, 0),
      gridmodel1("1 - 2 WEEKS", 0, 0),
      gridmodel1(">2 WEEKS", 0, 0),
    ];
    sectionsListPercentages = [
      0,
      0,
      0,
    ];
    isLoadingMarketingData = false;
    marketingValue.value++;
  }
}

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
Color _getStatusColor(String status) {
  Color color;
  switch (status) {
    case 'Cash Payment':
      color = Colors.blue;
      break;
    case 'EFT':
      color = Colors.blue;
      break;
    case 'Debit Order':
      color = Colors.blue;
      break;
    case 'persal':
      color = Colors.blue;
      break;
    case 'Easypay':
      color = Colors.blue;
      break;
    case 'Salary Deduction':
      color = Colors.blue;
      break;
    default:
      //print("fgghgh " + status);
      color = Colors.blue;
  }
  return color;
}

List<BarChartGroupData> processDataForSalesDaily1(List<dynamic> jsonData) {
  bool containsData = false;

  DateTime now = DateTime.now();
  int currentMonth = now.month;
  int currentYear = now.year;
  int daysInCurrentMonth = DateTime(currentYear, currentMonth + 1, 0).day;

  Map<int, Map<String, double>> dailyAttendance = {
    for (var day = 1; day <= daysInCurrentMonth; day++) day: {}
  };

  for (var item in jsonData) {
    if (item is Map<String, dynamic>) {
      DateTime date = DateTime.parse(item['date_or_month']);
      if (date.month == currentMonth && date.year == currentYear) {
        int dayOfMonth = date.day;
        String status = item["type"] ?? "";
        double count =
            double.parse((item["average_premium"] ?? "0").toString());
        dailyAttendance[dayOfMonth]
            ?.update(status, (value) => value + count, ifAbsent: () => count);
        if (count > 0) containsData = true;
      }
    }
  }

  List<BarChartGroupData> barChartData = [];
  dailyAttendance.forEach((dayOfMonth, statusData) {
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    var sortedEntries = statusData.entries
        .map((e) => MapEntry(_getStatusColor(e.key), e.value))
        .toList()
      ..sort(
          (a, b) => (colorOrder[a.key] ?? 0).compareTo(colorOrder[b.key] ?? 0));

    for (var entry in sortedEntries) {
      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + entry.value, entry.key));
      cumulativeAmount += entry.value;
    }

    // Calculate the average amount if there are any items
    double averageAmount = sortedEntries.isNotEmpty
        ? cumulativeAmount / sortedEntries.length
        : 0.0;

    barChartData.add(BarChartGroupData(
      x: dayOfMonth,
      barRods: [
        BarChartRodData(
          toY: averageAmount, // Use averageAmount instead of cumulativeAmount
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

  return containsData ? barChartData : [];
}

List<BarChartGroupData> processDataForSalesDaily3(
    List<dynamic> jsonData, DateTime startDate) {
  bool containsData = false;
  DateTime endDate = startDate.add(Duration(days: 30));

  Map<int, Map<String, double>> dailyAttendance = {};

  for (int i = 0; i <= 30; i++) {
    dailyAttendance[i] = {};
  }
  int daysInCurrentMonth = 30;

  for (var item in jsonData) {
    if (item is Map<String, dynamic>) {
      DateTime date = DateTime.parse(item['date_or_month']);
      if (date.isBefore(startDate) || date.isAfter(endDate)) continue;

      String status = item["type"] ?? "";
      double count = double.parse((item["average_premium"] ?? "0").toString());
      int dayDifference = date.difference(startDate).inDays;

      if (dayDifference >= 0 && dayDifference <= 30) {
        dailyAttendance[dayDifference]
            ?.update(status, (value) => value + count, ifAbsent: () => count);
        if (count > 0) containsData = true;
      }
    }
  }

  List<BarChartGroupData> barChartData = [];
  dailyAttendance.forEach((dayDifference, statusData) {
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    statusData.forEach((status, value) {
      Color color = _getStatusColor(status);
      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + value, color));
      cumulativeAmount += value;
    });

    double averageAmount =
        statusData.isNotEmpty ? cumulativeAmount / statusData.length : 0.0;

    if (cumulativeAmount > 0 || dayDifference <= dailyAttendance.keys.length) {
      barChartData.add(BarChartGroupData(
        x: dayDifference,
        barRods: [
          BarChartRodData(
            toY: averageAmount,
            rodStackItems: rodStackItems.isEmpty
                ? [BarChartRodStackItem(0, 0, Colors.transparent)]
                : rodStackItems,
            borderRadius: BorderRadius.zero,
            width: (Constants.screenWidth / daysInCurrentMonth - 4),
          ),
        ],
        barsSpace: 4,
      ));
    }
  });

  return containsData ? barChartData : [];
}

List<BarChartGroupData> processDataForAveragePremiumMonthly2(
  List<dynamic> jsonData,
  BuildContext context,
) {
  bool containsData = false;

  Map<String, Map<String, double>> monthlySales = {};

  for (var item in jsonData) {
    if (item is Map<String, dynamic>) {
      DateTime date = DateTime.parse(item['date_or_month'] + "-01");

      String monthKey = "${date.year}-${date.month.toString().padLeft(2, '0')}";
      String type = item["type"] ?? "";
      double count = double.parse((item["average_premium"] ?? "0").toString());

      monthlySales.putIfAbsent(monthKey, () => {});
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

    var sortedEntries = sortSalesData(statusData!);
    sortedEntries.forEach((entry) {
      Color color = _getStatusColor(entry.key);
      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + entry.value, color));
      cumulativeAmount += entry.value;
    });

    double averageAmount = sortedEntries.isNotEmpty
        ? cumulativeAmount / sortedEntries.length
        : 0.0;

    barChartData.add(BarChartGroupData(
      x: DateTime.parse(monthKey + "-01").month,
      barRods: [
        BarChartRodData(
          toY: averageAmount, // Use averageAmount instead of cumulativeAmount
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

List<charts.Series<OrdinalSales2A, String>>
    processDataForAveragePremiumMonthly2A(
        List<dynamic> jsonData, BuildContext context) {
  List<OrdinalSales2A> data = [];
  //print("gfghghghh ${jsonData}");

  for (var item in jsonData) {
    // print("gfghgh ${item}");
    if (item is Map<String, dynamic>) {
      DateTime date = DateTime.parse(item['date_or_month'] + "-01");
      // String monthKey = "${date.year}-${date.month.toString().padLeft(2, '0')}";
      double averagePremium =
          double.parse((item["average_premium"] ?? "0").toString());
      data.add(OrdinalSales2A(
          getMonthAbbreviation(date.month), averagePremium.round()));
    }
  }

  return [
    charts.Series<OrdinalSales2A, String>(
      id: 'Average Premium',
      domainFn: (OrdinalSales2A sales, _) => sales.year,
      measureFn: (OrdinalSales2A sales, _) => sales.sales,
      data: data,
      labelAccessorFn: (OrdinalSales2A sales, _) =>
          'R${sales.sales.toString()}',
    )
  ];
}

List<MapEntry<String, double>> sortSalesData(Map<String, double> salesData) {
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
    Color colorA = typeToColor[a.key] ?? Colors.grey;
    Color colorB = typeToColor[b.key] ?? Colors.grey;
    return colorOrder[colorA]!.compareTo(colorOrder[colorB]!);
  });

  return entries;
}

class AgeDistribution {
  final String ageRange;
  final int beneficiaryCount;
  final int childCount;
  final int mainMemberCount;

  AgeDistribution(this.ageRange, this.beneficiaryCount, this.childCount,
      this.mainMemberCount);
}

List<AgeDistribution> processData(
    Map<String, Map<String, int>> mainMemberAges) {
  List<AgeDistribution> distributions = [];
  mainMemberAges.forEach((ageRange, counts) {
    distributions.add(AgeDistribution(
      ageRange,
      counts['beneficiary'] ?? 0,
      counts['child'] ?? 0,
      counts['main_member'] ?? 0,
    ));
  });
  return distributions;
}

class SalesData {
  int monthlySalesTarget;
  Map<DateTime, int> actualDailySales;
  List<DateTime> holidays;

  SalesData({
    required this.monthlySalesTarget,
    required this.actualDailySales,
    required this.holidays,
  });

  Map<String, dynamic> calculateTarget(DateTime date) {
    int workingDays = _countWorkingDays(date);
    int previousDaySales = _getPreviousDaySales(date);
    int monthToDateSales = _getMonthToDateSales(date);
    int remainingSalesTarget = monthlySalesTarget - monthToDateSales;
    double averageDailySales = monthlySalesTarget / workingDays;
    double actualAverageDailySales =
        monthToDateSales / _countElapsedWorkingDays(date);

    Map<String, dynamic> m1 = {
      'actual': monthToDateSales,
      'target': monthlySalesTarget,
      'averageDaily': averageDailySales,
      'workingDays': workingDays,
      'previousDaySales': previousDaySales,
      'salesRemaining': remainingSalesTarget,
      'actualAverageDailySales': actualAverageDailySales
    };
    //print("dsmnda0 ${m1}");

    return m1;
  }

  int _countWorkingDays(DateTime date) {
    int workingDays = 0;
    for (int i = 1; i <= DateTime(date.year, date.month + 1, 0).day; i++) {
      DateTime currentDate = DateTime(date.year, date.month, i);
      if (!_isWeekend(currentDate) && !_isHoliday(currentDate)) {
        workingDays++;
      }
    }
    //print("fghggh ${workingDays}");
    return workingDays;
  }

  int _countElapsedWorkingDays(DateTime date) {
    int elapsedWorkingDays = 0;
    for (int i = 1; i <= date.day; i++) {
      DateTime currentDate = DateTime(date.year, date.month, i);
      if (currentDate.subtract(Duration(days: 1)).day == DateTime.sunday &&
          _isHoliday(currentDate.subtract(Duration(days: 1)))) {
      } else if (!_isWeekend(currentDate) && !_isHoliday(currentDate)) {
        elapsedWorkingDays++;
      }
    }
    return elapsedWorkingDays;
  }

  int _getPreviousDaySales(DateTime date) {
    DateTime previousDay = date.subtract(Duration(days: 1));
    String formattedDate = DateFormat('yyyy-MM-dd').format(previousDay);
    return actualDailySales[formattedDate] ?? 0;
  }

  int _getMonthToDateSales(DateTime date) {
    int totalSales = 0;
    for (DateTime dateString in actualDailySales.keys) {
      DateTime currentDate = dateString;
      if (currentDate.isBefore(date) || currentDate.isAtSameMomentAs(date)) {
        totalSales += actualDailySales[dateString] ?? 0;
      }
    }
    return totalSales;
  }

  bool _isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  bool _isHoliday(DateTime date) {
    for (DateTime holiday in holidays) {
      if (holiday.isAtSameMomentAs(date)) {
        return true;
      }
    }
    return false;
  }

  Map<String, dynamic> calculateTarget2(DateTime startDate, DateTime endDate) {
    int workingDays = _countWorkingDaysInRange2(startDate, endDate);
    int previousDaySales = _getPreviousDaySales2(endDate);
    int monthToDateSales = _getMonthToDateSales2(startDate);
    int remainingSalesTarget = monthlySalesTarget - monthToDateSales;
    double averageDailySales = monthlySalesTarget / workingDays;
    double actualAverageDailySales =
        monthToDateSales / _countElapsedWorkingDays2(startDate, endDate);
    Map<String, dynamic> m1 = {
      'actual': monthToDateSales,
      'target': monthlySalesTarget,
      'averageDaily': averageDailySales,
      'workingDays': workingDays,
      'previousDaySales': previousDaySales,
      'salesRemaining': remainingSalesTarget,
      'actualAverageDailySales': actualAverageDailySales
    };
    //print("dsmnda ${m1}");

    return m1;
  }

  int _countWorkingDaysInRange2(DateTime startDate, DateTime endDate) {
    int workingDays = 0;
    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      if (!_isWeekend2(currentDate) && !_isHoliday2(currentDate)) {
        workingDays++;
      }
      currentDate = currentDate.add(Duration(days: 1));
    }
    return workingDays;
  }

  int _countElapsedWorkingDays2(DateTime startDate, DateTime endDate) {
    // This function now counts elapsed working days in the provided date range
    int elapsedWorkingDays = 0;
    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      if (!_isWeekend2(currentDate) && !_isHoliday2(currentDate)) {
        elapsedWorkingDays++;
      }
      currentDate = currentDate.add(Duration(days: 1));
    }
    return elapsedWorkingDays;
  }

  int _getPreviousDaySales2(DateTime date) {
    DateTime previousDay = date.subtract(Duration(days: 1));
    String formattedDate = DateFormat('yyyy-MM-dd').format(previousDay);
    return actualDailySales[formattedDate] ?? 0;
  }

  int _getMonthToDateSales2(DateTime date) {
    int totalSales = 0;
    for (DateTime dateString in actualDailySales.keys) {
      DateTime currentDate = dateString;

      totalSales += actualDailySales[dateString] ?? 0;
    }
    return totalSales;
  }

  bool _isWeekend2(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  bool _isHoliday2(DateTime date) {
    return holidays.any((holiday) => isSameDay2(holiday, date));
  }

  bool isSameDay2(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

int monthDifference(DateTime startDate, DateTime endDate) {
  return (endDate.year - startDate.year) * 12 + endDate.month - startDate.month;
}

List<FlSpot> generateFlSpots(DateTime startDate, DateTime endDate) {
  List<FlSpot> spots = [];
  double startValue = (startDate.year * 12 + startDate.month).toDouble();
  double endValue = (endDate.year * 12 + endDate.month).toDouble();

  int startIndex = targets_3b.indexWhere((spot) => spot.x >= startValue);
  if (startIndex == -1) {
    return spots;
  }

  int endIndex = targets_3b.indexWhere((spot) => spot.x > endValue, startIndex);
  if (endIndex == -1) {
    endIndex = targets_3b.length;
  }

  for (int i = startIndex; i < endIndex; i++) {
    spots.add(targets_3b[i]);
  }

  return spots;
}

/*
List<FlSpot> generateFlSpots(DateTime startDate, int months) {
  List<FlSpot> spots = [];
  for (int i = 0; i <= months; i++) {
    DateTime date = DateTime(startDate.year, startDate.month + i);
    double xValue = (date.year * 12 + date.month).toDouble();
    double yValue = (date.year == 2024 && date.month <= 2) ? 1200 : 800;
    spots.add(FlSpot(xValue, yValue));
  }
  return spots;
}
*/

List<FlSpot> targets_3b = [
  FlSpot((2023 * 12 + 06).toDouble(), 800),
  FlSpot((2023 * 12 + 07).toDouble(), 800),
  FlSpot((2023 * 12 + 08).toDouble(), 800),
  FlSpot((2023 * 12 + 09).toDouble(), 800),
  FlSpot((2023 * 12 + 10).toDouble(), 800),
  FlSpot((2023 * 12 + 11).toDouble(), 800),
  FlSpot((2023 * 12 + 12).toDouble(), 800),
  FlSpot((2024 * 12 + 01).toDouble(), 1200),
  FlSpot((2024 * 12 + 02).toDouble(), 1200),
  FlSpot((2024 * 12 + 03).toDouble(), 1200),
  FlSpot((2024 * 12 + 04).toDouble(), 1200),
  FlSpot((2024 * 12 + 05).toDouble(), 1200),
  FlSpot((2024 * 12 + 06).toDouble(), 1200),
  FlSpot((2024 * 12 + 07).toDouble(), 1200),
  FlSpot((2024 * 12 + 08).toDouble(), 1200),
  FlSpot((2024 * 12 + 09).toDouble(), 1200),
];

class OrdinalSales2A {
  final String year;
  final int sales;

  OrdinalSales2A(this.year, this.sales);
}

Map<String, dynamic> formatMap(Map<String, dynamic> input) {
  // Function to format a key
  String formatKey(String key) {
    // Remove '_count' and extra spaces/newlines, then capitalize each word
    return key
        .replaceAll('_count', '') // Remove '_count'
        .replaceAll('_', ' ') // Remove '_count'
        .replaceAll(RegExp(r'\s+'),
            ' ') // Replace multiple spaces/newlines with a single space
        .trim()
        .split(' ') // Split by spaces
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : word)
        .join(' ');
  }

  // Process the map recursively
  Map<String, dynamic> processMap(Map<String, dynamic> map) {
    Map<String, dynamic> formattedMap = {};
    map.forEach((key, value) {
      // Format the current key
      String formattedKey = formatKey(key);
      print("Processing key: '$key'");
      print("Formatted key: '$formattedKey'");
      print("Value: ${value}");

      // Check if the value is another map and process it recursively
      if (value is Map<String, dynamic>) {
        formattedMap[formattedKey] = processMap(value);
      } else {
        formattedMap[formattedKey] = value; // Keep the value as is
      }
    });
    return formattedMap;
  }

  return processMap(input);
}

/// New function to fetch executive sales report data from analytix API
Future<void> getExecutiveSalesReport(
    String startDate,
    String endDate,
    int clientId,
    int selectedButton1,
    int days_difference,
    BuildContext context) async {
  if (selectedButton1 == 1) {
    isSalesDataLoading1a = true;
  } else if (selectedButton1 == 2) {
    isSalesDataLoading2a = true;
  } else if (selectedButton1 == 3 && days_difference <= 31) {
    isSalesDataLoading3a = true;
  } else if (selectedButton1 == 3 && days_difference > 31) {
    isSalesDataLoading3a = true;
  }
  try {
    // Print debug information
    if (kDebugMode) {
      print(
          "🔄 Calling getExecutiveSalesReport with dates: $startDate to $endDate, clientId: $clientId");
    }

    var headers = {'Content-Type': 'application/json'};
    String url =
        '${Constants.analitixAppBaseUrl}sales/view_normalized_sales_data/';
    if (hasTemporaryTesterRole(Constants.myUserRoles)) {
      url = '${Constants.analitixAppBaseUrl}sales/get_sales_data_test/';
    }

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode(
        {"client_id": clientId, "start_date": startDate, "end_date": endDate});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();

      // Parse the JSON response
      Map<String, dynamic> responseData = json.decode(responseBody);
      if (kDebugMode) {
        print("✅ getExecutiveSalesReport response received $responseData");
        // print("Response length: ${responseBody.length} characters");
      }

      // Store the response in Constants
      Constants.currentSalesDataResponse =
          SalesDataResponse.fromJson(responseData);
      if (selectedButton1 == 1) isSalesDataLoading1a = false;
      if (selectedButton1 == 2) isSalesDataLoading2a = false;
      if (selectedButton1 == 3) isSalesDataLoading3a = false;
      if (selectedButton1 == 4) isSalesDataLoading3a = false;
      salesValue.value++;

      if (kDebugMode) {}
    } else {
      if (selectedButton1 == 1) isSalesDataLoading1a = false;
      if (selectedButton1 == 2) isSalesDataLoading2a = false;
      if (selectedButton1 == 3) isSalesDataLoading3a = false;
      if (selectedButton1 == 4) isSalesDataLoading3a = false;
      salesValue.value++;
      if (kDebugMode) {
        print(
            "❌ getExecutiveSalesReport failed with status: ${response.statusCode}");
        print("❌ Reason: ${response.reasonPhrase}");
      }

      // You could also show an error message to the user here if needed
      throw Exception(
          'Failed to fetch sales data: ${response.statusCode} - ${response.reasonPhrase}');
    }
  } catch (e) {
    if (selectedButton1 == 1) isSalesDataLoading1a = false;
    if (selectedButton1 == 2) isSalesDataLoading2a = false;
    if (selectedButton1 == 3) isSalesDataLoading3a = false;
    if (selectedButton1 == 4) isSalesDataLoading3a = false;
    salesValue.value++;

    if (kDebugMode) {
      print("❌ getExecutiveSalesReport error: $e");
    }

    // Re-throw the error so calling code can handle it
    throw e;
  }
}

extension FlSpotExtension on FlSpot {
  /// Convert FlSpot to JSON
  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }

  /// Check if FlSpot is empty (both x and y are 0)
  bool get isEmpty => x == 0.0 && y == 0.0;

  /// Check if FlSpot is not empty
  bool get isNotEmpty => !isEmpty;

  /// Create a copy of FlSpot with new values
  FlSpot copyWith({double? x, double? y}) {
    return FlSpot(x ?? this.x, y ?? this.y);
  }

  /// Distance from another FlSpot
  //double distanceTo(FlSpot other) {
  //return ((x - other.x) * (x - other.x) + (y - other.y) * (y - other.y)).sqrt();
  //}

  /// String representation for debugging
  //@override
  //String toString() => 'FlSpot(x: $x, y: $y)';
}

// Static helper class for FlSpot operations
class FlSpotHelper {
  /// Create FlSpot from JSON
  static FlSpot fromJson(Map<String, dynamic> json) {
    return FlSpot(
      (json['x'] ?? 0).toDouble(),
      (json['y'] ?? 0).toDouble(),
    );
  }

  /// Create empty FlSpot
  static FlSpot empty() {
    return FlSpot(0.0, 0.0);
  }

  /// Parse list of FlSpots from JSON
  static List<FlSpot> parseFlSpotList(dynamic list) {
    if (list == null) return [];
    return (list as List).map((item) => FlSpotHelper.fromJson(item)).toList();
  }
}

// Helper functions for parsing lists
extension FlSpotListExtension on List<FlSpot> {
  /// Convert list of FlSpots to JSON array
  List<Map<String, dynamic>> toJson() {
    return map((spot) => spot.toJson()).toList();
  }

  /// Get the maximum Y value from the list
  double get maxY {
    if (isEmpty) return 0.0;
    return map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
  }

  /// Get the minimum Y value from the list
  double get minY {
    if (isEmpty) return 0.0;
    return map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
  }

  /// Get the maximum X value from the list
  double get maxX {
    if (isEmpty) return 0.0;
    return map((spot) => spot.x).reduce((a, b) => a > b ? a : b);
  }

  /// Get the minimum X value from the list
  double get minX {
    if (isEmpty) return 0.0;
    return map((spot) => spot.x).reduce((a, b) => a < b ? a : b);
  }

  /// Get X range as (min, max)
  (double, double) get xRange {
    if (isEmpty) return (0.0, 1.0);
    return (minX, maxX);
  }

  /// Get Y range as (min, max)
  (double, double) get yRange {
    if (isEmpty) return (0.0, 1.0);
    return (minY, maxY);
  }

  /// Filter out spots where y = 0
  List<FlSpot> get nonZeroY => where((spot) => spot.y != 0.0).toList();

  /// Filter out spots where x = 0
  List<FlSpot> get nonZeroX => where((spot) => spot.x != 0.0).toList();

  /// Filter out spots where both x and y are not 0
  List<FlSpot> get nonZero =>
      where((spot) => spot.x != 0.0 && spot.y != 0.0).toList();
}
