import "dart:convert";
import "dart:math";

import "package:fl_chart/fl_chart.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:intl/intl.dart";

import "../constants/Constants.dart";
import "../screens/Reports/AttendanceReport.dart";
import "../utils/login_utils.dart";

Future<void> getAttendanceReportData(String date_from, String date_to,
    int selectedButton1, BuildContext context) async {
  String baseUrl = '${Constants.analitixAppBaseUrl}sales/get_attendance_data/';
  if (hasTemporaryTesterRole(Constants.myUserRoles)) {
    baseUrl =
        '${Constants.analitixAppBaseUrl}sales/view_normalized_customers_data/';
  }
  int days_difference = 0;
  DateTime startDateTime = DateFormat('yyyy-MM-dd').parse(date_from);
  DateTime endDateTime = DateFormat('yyyy-MM-dd').parse(date_to);

  days_difference = endDateTime.difference(startDateTime).inDays;
  // print(baseUrl);

  try {
    Map<String, String>? payload = {
      //"cec_client_id": Constants.cec_client_id.toString(),
      "cec_client_id": "1",
      "start_date": date_from,
      "end_date": date_to,
      "search_for":
          "Branch" //Head Office or "Branch" depending on your requirement
    };
    if (kDebugMode) {
      //print("baseUrl $baseUrl");
      // print("payloadjhjj $payload");
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
      if (response.statusCode != 200) {
        //  print("hjjhhkh ${response.body}");
      } else {
        var jsonResponse1 = jsonDecode(response.body);
        /* print("Response: $jsonResponse1");
        print(
            "Daily/Monthly Counts: ${jsonResponse1["daily_or_monthly_counts"]}");
*/
        if (selectedButton1 == 1) {
          Constants.attendance_sectionsList1a = [
            attendance_gridmodel("Total Staff", 0, 0),
            attendance_gridmodel("Present", 0, 0),
            attendance_gridmodel("Absent", 0, 0),
            attendance_gridmodel("Not Marked", 0, 0),
          ];

          var jsonResponse1 = jsonDecode(response.body);

          if (selectedButton1 == 1) {
            Constants.attendance_sectionsList1a = [
              attendance_gridmodel("Total Staff", 0, 0),
              attendance_gridmodel("Present", 0, 0),
              attendance_gridmodel("Absent", 0, 0),
              attendance_gridmodel("Not Marked", 0, 0),
            ];

            int total_staff_count = 0;
            int total_present_count = 0;
            int total_absent_count = 0;
            int total_not_marked_count = 0;

            jsonResponse1["overall_status_counts"].forEach((value) {
              Map m1 = value as Map;
              int count = int.tryParse(m1["count"].toString()) ?? 0;
              total_staff_count += count;

              if (m1["attendance_status"] == "Present" ||
                  m1["attendance_status"] == "Late Coming") {
                total_present_count += count;
              } else if (m1["attendance_status"] == "Not Marked" ||
                  m1["attendance_status"] == "Unknown") {
                total_not_marked_count += count;
              } else {
                total_absent_count += count;
              }
            });

            double total_present_percentage =
                (total_present_count / total_staff_count) * 100;
            double total_absent_percentage =
                (total_absent_count / total_staff_count) * 100;
            double total_not_marked_percentage =
                (total_not_marked_count / total_staff_count) * 100;
            Constants.absenteeism_ratio1a =
                double.parse(total_absent_percentage.toStringAsFixed(2));

            Constants.attendance_sectionsList1a[0].count = total_staff_count;
            Constants.attendance_sectionsList1a[0].percentage =
                100; // Assuming 100 is a placeholder

            Constants.attendance_sectionsList1a[1].count = total_present_count;
            Constants.attendance_sectionsList1a[1].percentage =
                total_present_percentage;

            Constants.attendance_sectionsList1a[2].count = total_absent_count;
            Constants.attendance_sectionsList1a[2].percentage =
                total_absent_percentage;
            Constants.attendance_sectionsList1a[3].count =
                total_not_marked_count;
            Constants.attendance_sectionsList1a[3].percentage =
                total_not_marked_percentage;
          }

          attendance_barChartData1 = [];
          attendance_barChartData1 =
              processDataForAttendanceDaily1(response.body);
          List<dynamic> overallStatusCounts =
              jsonResponse1["overall_status_counts"];

          // Iterate over each status count in the JSON data.
          for (var statusCount in overallStatusCounts) {
            // Extract the attendance status and count.
            String attendanceStatus = statusCount["attendance_status"];
            int count = statusCount["count"];

            for (var attendanceType in Constants.attendanceTypes1a) {
              if (attendanceType.type == "NOT MARKED") {
                attendanceType.count =
                    Constants.attendance_sectionsList1a[3].count;
              } else
              // Assuming that the 'type' in AttendanceTypeGridItem is uppercase.
              if (attendanceType.type == attendanceStatus.toUpperCase()) {
                attendanceType.count = count;
                break; // Break the loop once the matching type is found and updated.
              }
            }
          }
        } else if (selectedButton1 == 2) {
          Constants.attendance_sectionsList2a = [
            attendance_gridmodel("Total Staff", 0, 0),
            attendance_gridmodel("Present", 0, 0),
            attendance_gridmodel("Absent", 0, 0),
            attendance_gridmodel("Not Marked", 0, 0),
          ];

          var jsonResponse1 = jsonDecode(response.body);

          int total_staff_count = 0;
          int total_present_count = 0;
          int total_absent_count = 0;
          int total_not_marked_count = 0;

          jsonResponse1["overall_status_counts"].forEach((value) {
            Map m1 = value as Map;
            int count = int.tryParse(m1["count"].toString()) ?? 0;
            total_staff_count += count;

            if (m1["attendance_status"] == "Present" ||
                m1["attendance_status"] == "Late Coming") {
              total_present_count += count;
            } else if (m1["attendance_status"] == "Not Marked" ||
                m1["attendance_status"] == "Unknown") {
              total_not_marked_count += count;
            } else {
              total_absent_count += count;
            }
          });

          double total_present_percentage =
              (total_present_count / total_staff_count) * 100;
          double total_absent_percentage =
              (total_absent_count / total_staff_count) * 100;
          double total_not_marked_percentage =
              (total_not_marked_count / total_staff_count) * 100;
          Constants.absenteeism_ratio2a =
              double.parse(total_absent_percentage.toStringAsFixed(2));

          Constants.attendance_sectionsList2a[0].count = total_staff_count;
          Constants.attendance_sectionsList2a[0].percentage =
              100; // Assuming 100 is a placeholder

          Constants.attendance_sectionsList2a[1].count = total_present_count;
          Constants.attendance_sectionsList2a[1].percentage =
              total_present_percentage;

          Constants.attendance_sectionsList2a[2].count = total_absent_count;
          Constants.attendance_sectionsList2a[2].percentage =
              total_absent_percentage;
          Constants.attendance_sectionsList2a[3].count = total_not_marked_count;
          Constants.attendance_sectionsList2a[3].percentage =
              total_not_marked_percentage;

          attendance_barChartData2 = [];
          attendance_barChartData2 =
              processDataForAttendanceCountMonthly2(response.body);
          List<dynamic> overallStatusCounts =
              jsonResponse1["overall_status_counts"];

          // Iterate over each status count in the JSON data.
          for (var statusCount in overallStatusCounts) {
            // Extract the attendance status and count.
            String attendanceStatus = statusCount["attendance_status"];
            int count = statusCount["count"];

            for (var attendanceType in Constants.attendanceTypes1a) {
              // Assuming that the 'type' in AttendanceTypeGridItem is uppercase.
              if (attendanceType.type == attendanceStatus.toUpperCase()) {
                attendanceType.count = count;
                break; // Break the loop once the matching type is found and updated.
              }
            }
          }
        } else if (selectedButton1 == 3 && days_difference <= 31) {
          Constants.attendance_sectionsList3a = [
            attendance_gridmodel("Total Staff", 0, 0),
            attendance_gridmodel("Present", 0, 0),
            attendance_gridmodel("Absent", 0, 0),
            attendance_gridmodel("Not Marked", 0, 0),
          ];

          int total_staff_count = 0;
          int total_present_count = 0;
          int total_absent_count = 0;
          int total_not_marked_count = 0;

          jsonResponse1["overall_status_counts"].forEach((value) {
            Map m1 = value as Map;
            int count = int.tryParse(m1["count"].toString()) ?? 0;
            total_staff_count += count;

            if (m1["attendance_status"] == "Present" ||
                m1["attendance_status"] == "Late Coming") {
              total_present_count += count;
            } else if (m1["attendance_status"] == "Not Marked" ||
                m1["attendance_status"] == "Unknown") {
              total_not_marked_count += count;
            } else {
              total_absent_count += count;
            }
          });

          double total_present_percentage =
              (total_present_count / total_staff_count) * 100;
          double total_absent_percentage =
              (total_absent_count / total_staff_count) * 100;
          double total_not_marked_percentage =
              (total_not_marked_count / total_staff_count) * 100;
          Constants.absenteeism_ratio3a = total_absent_percentage;

          Constants.attendance_sectionsList3a[0].count = total_staff_count;
          Constants.attendance_sectionsList3a[0].percentage =
              100; // Assuming 100 is a placeholder

          Constants.attendance_sectionsList3a[1].count = total_present_count;
          Constants.attendance_sectionsList3a[1].percentage =
              total_present_percentage;

          Constants.attendance_sectionsList3a[2].count = total_absent_count;
          Constants.attendance_sectionsList3a[2].percentage =
              total_absent_percentage;
          Constants.attendance_sectionsList3a[3].count = total_not_marked_count;
          Constants.attendance_sectionsList3a[3].percentage =
              total_not_marked_percentage;
          attendance_barChartData3 = [];
          attendance_barChartData3 =
              processDataForAttendanceDaily1(response.body);
          List<dynamic> overallStatusCounts =
              jsonResponse1["overall_status_counts"];

          // Iterate over each status count in the JSON data.
          for (var statusCount in overallStatusCounts) {
            // Extract the attendance status and count.
            String attendanceStatus = statusCount["attendance_status"];
            int count = statusCount["count"];

            for (var attendanceType in Constants.attendanceTypes3a) {
              // Assuming that the 'type' in AttendanceTypeGridItem is uppercase.
              if (attendanceType.type == attendanceStatus.toUpperCase()) {
                attendanceType.count = count;
                break; // Break the loop once the matching type is found and updated.
              }
            }
          }
        } else {
          Constants.attendance_sectionsList3b = [
            attendance_gridmodel("Total Staff", 0, 0),
            attendance_gridmodel("Present", 0, 0),
            attendance_gridmodel("Absent", 0, 0),
          ];

          Constants.attendance_sectionsList3b[0].count =
              jsonResponse1["daily_or_monthly_counts"][1]["total_amount"];
          Constants.attendance_sectionsList3b[0].percentage =
              jsonResponse1["daily_or_monthly_counts"][1]["count"].round();

          Constants.attendance_sectionsList3b[1].count =
              jsonResponse1["daily_or_monthly_counts"][2]["total_amount"];
          Constants.attendance_sectionsList3b[1].percentage =
              jsonResponse1["daily_or_monthly_counts"][2]["count"].round();

          Constants.attendance_sectionsList3b[2].count =
              jsonResponse1["attendance_total_counts"][0]["total_amount"];
          Constants.attendance_sectionsList3b[2].percentage =
              jsonResponse1["attendance_total_counts"][0]["count"].round();

          attendance_barChartData4 = [];
          attendance_barChartData4 = processDataForAttendanceCountMonthly4(
              response.body, date_from, date_to, context);
        }
      }
    });
  } on Exception catch (_, exception) {
    //Exception exc = exception as Exception;
    print(exception);
  }
}

List<BarChartGroupData> processDataForAttendanceDaily1(String jsonString) {
  bool containsData = false;
  List<dynamic> jsonData = jsonDecode(jsonString)["daily_or_monthly_counts"];

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
        String status = item["status"];
        double count = (item["count"] as num)
            .toDouble(); // Cast to num first to avoid errors
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

    // Create a sorted list of MapEntry from statusData
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

    barChartData.add(BarChartGroupData(
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

  return containsData ? barChartData : [];
}

Map<Color, int> colorOrder = {
  Colors.grey: 1,
  Colors.green: 2,
  Colors.blue: 3,
  Colors.orange: 4,
  Colors.red: 5,
  Colors.purple: 6,
  Colors.yellow: 7,
  Colors.pink: 8,
  Colors.teal: 9,
  Colors.brown: 10,
  Colors.indigo: 11,
  Colors.cyan: 12,
};

Color _getStatusColor(String status) {
  switch (status) {
    case 'P': // Present
      return Colors.green;
    case 'AL': // Annual Leave
      return Colors.blue;
    case 'DO': // Day Off
      return Colors.orange;
    case 'LC': // Late Coming
      return Colors.red;
    case 'ML': // Maternity Leave
      return Colors.purple;
    case 'PC': // Paternity Leave
      return Colors.yellow;
    case 'T': // Training
      return Colors.pink;
    case 'S': // Suspended
      return Colors.teal;
    case 'SL': // Sick Leave
      return Colors.brown;
    case 'R': // Resigned
      return Colors.indigo;
    case 'FR': // Family Responsibility Leave
      return Colors.cyan;
    default:
      return Colors.grey;
  }
}

List<BarChartGroupData> processDataForAttendanceCountMonthly2(
  String jsonString,
) {
  bool containsData = false;
  List<dynamic> jsonData = jsonDecode(jsonString)["daily_or_monthly_counts"];

  // Initialize monthlySales map
  Map<String, Map<String, double>> monthlySales = {};

  for (var item in jsonData) {
    if (item is Map<String, dynamic>) {
      DateTime date = DateTime.parse(item['date_or_month']);

      String monthKey = "${date.year}-${date.month.toString().padLeft(2, '0')}";
      String status = item["status"];
      double count = (item["count"] as num).toDouble();

      monthlySales.putIfAbsent(monthKey, () => {});
      monthlySales[monthKey]
          ?.update(status, (value) => value + count, ifAbsent: () => count);
      containsData = true;
    }
  }

  // Sort the months
  var sortedMonths = monthlySales.keys.toList()..sort();

  // Build BarChartGroupData
  List<BarChartGroupData> barChartData = [];
  for (var monthKey in sortedMonths) {
    var statusData = monthlySales[monthKey];
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    // Assuming sortReprintCancellationsData and colorOrder are defined elsewhere
    var sortedEntries = sortReprintCancellationsData(statusData!);
    sortedEntries.forEach((entry) {
      Color color = _getStatusColor(
          entry.key); // Define this function to match status to color
      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + entry.value, color));
      cumulativeAmount += entry.value;
    });

    // Add the data to the chart
    barChartData.add(BarChartGroupData(
      x: DateTime.parse(monthKey + "-01").month,
      barRods: [
        BarChartRodData(
          toY: cumulativeAmount,
          rodStackItems: rodStackItems.isEmpty
              ? [BarChartRodStackItem(0, 0, Colors.transparent)]
              : rodStackItems,
          borderRadius: BorderRadius.zero,
          width: 20, // Adjust as needed
        ),
      ],
    ));
  }

  return containsData ? barChartData : [];
}

List<BarChartGroupData> processDataForAttendanceDaily3(String jsonString) {
  List<dynamic> jsonData = jsonDecode(jsonString)["daily_or_monthly_counts"];
  bool contains_data = false;

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
      DateTime date = DateTime.parse(reprintItem['date_or_month']);
      if (date.month == currentMonth && date.year == currentYear) {
        int dayOfMonth = date.day;
        String type = reprintItem["status"];
        double count = reprintItem["count"].toDouble();
        if (count > 0) {
          contains_data = true;
        }

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
        case 'Present':
          color = Colors.blue;
          break;
        case 'Sick Leave':
          color = Colors.purple;
          break;
        case 'Day Off':
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
          width: 8,
        ),
      ],
      barsSpace: 4,
    ));
  });

  if (contains_data == false) {
    return [];
  } else {
    return reprintsGroupedData;
  }
}

List<BarChartGroupData> processDataForAttendanceDaily3_1(String jsonString) {
  List<dynamic> jsonData = jsonDecode(jsonString)["daily_or_monthly_counts"];
  bool contains_data = false;

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
      DateTime date = DateTime.parse(reprintItem['date_or_month']);
      if (date.month == currentMonth && date.year == currentYear) {
        int dayOfMonth = date.day;
        String type = reprintItem["status"];
        double count = reprintItem["count"].toDouble();
        if (count > 0) {
          contains_data = true;
        }

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
        case 'Present':
          color = Colors.blue;
          break;
        case 'Sick Leave':
          color = Colors.purple;
          break;
        case 'Day Off':
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
          width: 8,
        ),
      ],
      barsSpace: 4,
    ));
  });

  if (contains_data == false) {
    return [];
  } else {
    return reprintsGroupedData;
  }
}

List<BarChartGroupData> processDataForAttendanceCountMonthly4(
    String jsonString, String startDate, String endDate, BuildContext context) {
  List<dynamic> jsonData = jsonDecode(jsonString)["daily_or_monthly_counts"];

  bool contains_data = false;

/*  jsonData = [
    {"date_or_month": "2023-01-01", "status": "Total Staff", "count": 20},
    {"date_or_month": "2023-01-01", "status": "Awaiting Action", "count": 10},
    {"date_or_month": "2023-01-01", "status": "Declined", "count": 14},
    {"date_or_month": "2023-02-01", "status": "Total Staff", "count": 10},
    {"date_or_month": "2023-02-01", "status": "Awaiting Action", "count": 60},
    {"date_or_month": "2023-02-01", "status": "Declined", "count": 10},
    {"date_or_month": "2023-03-01", "status": "Total Staff", "count": 10},
    {"date_or_month": "2023-03-01", "status": "Awaiting Action", "count": 5},
    {"date_or_month": "2023-03-01", "status": "Declined", "count": 8},
    {"date_or_month": "2023-04-01", "status": "Total Staff", "count": 12},
    {"date_or_month": "2023-04-01", "status": "Awaiting Action", "count": 0},
    {"date_or_month": "2023-04-01", "status": "Declined", "count": 0},
    {"date_or_month": "2023-05-01", "status": "Total Staff", "count": 0},
    {"date_or_month": "2023-05-01", "status": "Awaiting Action", "count": 0},
    {"date_or_month": "2023-05-01", "status": "Declined", "count": 0},
    {"date_or_month": "2023-06-01", "status": "Total Staff", "count": 0},
    {"date_or_month": "2023-06-01", "status": "Awaiting Action", "count": 0},
    {"date_or_month": "2023-06-01", "status": "Declined", "count": 0},
    {"date_or_month": "2023-07-01", "status": "Total Staff", "count": 0},
    {"date_or_month": "2023-07-01", "status": "Awaiting Action", "count": 0},
    {"date_or_month": "2023-07-01", "status": "Declined", "count": 0},
    {"date_or_month": "2023-08-01", "status": "Total Staff", "count": 0},
    {"date_or_month": "2023-08-01", "status": "Awaiting Action", "count": 0},
    {"date_or_month": "2023-08-01", "status": "Declined", "count": 0},
    {"date_or_month": "2023-09-01", "status": "Total Staff", "count": 0},
    {"date_or_month": "2023-09-01", "status": "Awaiting Action", "count": 0},
    {"date_or_month": "2023-09-01", "status": "Declined", "count": 0},
    {"date_or_month": "2023-10-01", "status": "Total Staff", "count": 0},
    {"date_or_month": "2023-10-01", "status": "Awaiting Action", "count": 0},
    {"date_or_month": "2023-10-01", "status": "Declined", "count": 0},
    {"date_or_month": "2023-11-01", "status": "Total Staff", "count": 0},
  ];*/

  DateTime end = DateTime.parse(endDate);
  DateTime start = DateTime(end.year - 1, end.month, end.day);
  int monthsInRange = 12;

  Map<int, Map<String, double>> monthlySales = {
    for (var i = 0; i < monthsInRange; i++)
      DateTime(end.year, end.month - i, 1).month: {}
  };

  for (var reprintItem in jsonData) {
    if (reprintItem is Map<String, dynamic>) {
      DateTime paymentDate = DateTime.parse(reprintItem['date_or_month']);

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
        case 'Present':
          color = Colors.blue;
          break;
        case 'Late Coming':
          color = Colors.purple;
          break;
        case 'Sick Leave':
          color = Colors.purple;
          break;
        case 'Day Off':
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
        (a, b) => colorOrder[a.color]!.compareTo(colorOrder[b.color] ?? 0));
    rodStackItems = rodStackItems.reversed.toList();
    //print(rodStackItems);

    reprintsGroupedData.add(BarChartGroupData(
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

  if (contains_data == false) {
    return [];
  } else {
    return reprintsGroupedData;
  }
}

List<BarChartGroupData> processDataForAttendanceCountMonthly4_1(
    String jsonString, String startDate, String endDate, BuildContext context) {
  bool contains_data = false;
  //print("aaxdsgjjhjs $startDate $endDate");
  List<dynamic> jsonData = jsonDecode(jsonString)["daily_or_monthly_counts"];
  if (jsonData == null || jsonData.isEmpty) {
    return [];
  }
/*  jsonData = [
    {"date_or_month": "2023-01-01", "status": "Total Staff", "count": 20},
    {"date_or_month": "2023-01-01", "status": "Awaiting Action", "count": 10},
    {"date_or_month": "2023-01-01", "status": "Declined", "count": 14},
    {"date_or_month": "2023-02-01", "status": "Total Staff", "count": 10},
    {"date_or_month": "2023-02-01", "status": "Awaiting Action", "count": 60},
    {"date_or_month": "2023-02-01", "status": "Declined", "count": 10},
    {"date_or_month": "2023-03-01", "status": "Total Staff", "count": 10},
    {"date_or_month": "2023-03-01", "status": "Awaiting Action", "count": 5},
    {"date_or_month": "2023-03-01", "status": "Declined", "count": 8},
    {"date_or_month": "2023-04-01", "status": "Total Staff", "count": 12},
    {"date_or_month": "2023-04-01", "status": "Awaiting Action", "count": 0},
    {"date_or_month": "2023-04-01", "status": "Declined", "count": 0},
    {"date_or_month": "2023-05-01", "status": "Total Staff", "count": 0},
    {"date_or_month": "2023-05-01", "status": "Awaiting Action", "count": 0},
    {"date_or_month": "2023-05-01", "status": "Declined", "count": 0},
    {"date_or_month": "2023-06-01", "status": "Total Staff", "count": 0},
    {"date_or_month": "2023-06-01", "status": "Awaiting Action", "count": 0},
    {"date_or_month": "2023-06-01", "status": "Declined", "count": 0},
    {"date_or_month": "2023-07-01", "status": "Total Staff", "count": 0},
    {"date_or_month": "2023-07-01", "status": "Awaiting Action", "count": 0},
    {"date_or_month": "2023-07-01", "status": "Declined", "count": 0},
    {"date_or_month": "2023-08-01", "status": "Total Staff", "count": 0},
    {"date_or_month": "2023-08-01", "status": "Awaiting Action", "count": 0},
    {"date_or_month": "2023-08-01", "status": "Declined", "count": 0},
    {"date_or_month": "2023-09-01", "status": "Total Staff", "count": 0},
    {"date_or_month": "2023-09-01", "status": "Awaiting Action", "count": 0},
    {"date_or_month": "2023-09-01", "status": "Declined", "count": 0},
    {"date_or_month": "2023-10-01", "status": "Total Staff", "count": 0},
    {"date_or_month": "2023-10-01", "status": "Awaiting Action", "count": 0},
    {"date_or_month": "2023-10-01", "status": "Declined", "count": 0},
    {"date_or_month": "2023-11-01", "status": "Total Staff", "count": 0},
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
      DateTime paymentDate = DateTime.parse(reprintItem['date_or_month']);
      /* print(
          "hghghg ${reprintItem['date_or_month']} ${reprintItem["count"].toDouble()}");
*/
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
        case 'Present':
          color = Colors.blue;
          break;
        case 'Late Coming':
          color = Colors.purple;
          break;
        case 'Sick Leave':
          color = Colors.purple;
          break;
        case 'Day Off':
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
        (a, b) => colorOrder[a.color]!.compareTo(colorOrder[b.color] ?? 0));
    rodStackItems = rodStackItems.reversed.toList();
    //print(rodStackItems);

    reprintsGroupedData.add(BarChartGroupData(
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

  if (contains_data == false) {
    return [];
  } else {
    return reprintsGroupedData;
  }
}

List<BarChartGroupData> processDataForAttendanceCountDaily2(
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
      DateTime paymentDate = DateTime.parse(reprintItem['date_or_month']);
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
        case 'Cash':
          color = Colors.blue;
          break;
        case 'EFT':
          color = Colors.purple;
          break;
        case 'Debit Order':
          color = Colors.orange;
          break;
        case 'Persal':
          color = Colors.grey;
          break;
        case 'Easypay':
          color = Colors.green;
          break;
        case 'Salary Deduction':
          color = Colors.yellow;
          break;
        default:
          color = Colors.grey;
      }

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, color));
      cumulativeAmount += amount;
    });
    rodStackItems
        .sort((a, b) => colorOrder[a.color]!.compareTo(colorOrder[b.color]!));
    rodStackItems = rodStackItems.reversed.toList();
    //print(rodStackItems);

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
          width: 8,
        ),
      ],
      barsSpace: 4,
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
    'Present': Colors.blue,
    'Sick Leave': Colors.purple,
    'Late Coming': Colors.purple,
    'Day Off': Colors.green,
    'Other': Colors.grey,
  };

  Map<Color, int> colorOrder = {
    Colors.blue: 1,
    Colors.purple: 2,
    Colors.green: 3,
    Colors.grey: 4,
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
