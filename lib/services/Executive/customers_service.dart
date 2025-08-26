import 'dart:convert';
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants/Constants.dart';
import '../../models/CustomerProfile.dart';
import '../../models/GenderDistribution.dart';
import '../../screens/Reports/Executive/CustomersReport.dart';
import '../../utils/login_utils.dart';

Future<void> getExecutiveCustomersReport(String dateFrom, String dateTo,
    int selectedButton, int daysDifference, BuildContext context) async {
  try {
    _setLoadingState(selectedButton, daysDifference, true);

    final response = await _makeApiRequest(dateFrom, dateTo);

    if (response.statusCode != 200) {
      _handleApiError(selectedButton, daysDifference);
      return;
    }

    final jsonResponse = jsonDecode(response.body);
    await _processApiResponse(jsonResponse, selectedButton, daysDifference);
  } catch (exception) {
    // _handleException(selectedButton, daysDifference, exception);
  }
}

// API Request handling
Future<http.Response> _makeApiRequest(String dateFrom, String dateTo) async {
  String baseUrl = '${Constants.analitixAppBaseUrl}sales/get_customers_data/';
  if (hasTemporaryTesterRole(Constants.myUserRoles)) {
    baseUrl = '${Constants.analitixAppBaseUrl}sales/get_customers_data_test/';
  }

  if (kDebugMode) {
    print("baseUrl $baseUrl");
  }

  final payload = {
    "client_id": "${Constants.cec_client_id}",
    "start_date": dateFrom,
    "end_date": dateTo
  };

  return await http.post(Uri.parse(baseUrl), body: payload);
}

// Loading state management
void _setLoadingState(int selectedButton, int daysDifference, bool isLoading) {
  switch (selectedButton) {
    case 1:
      isCustomerDataLoading = isLoading;
      break;
    case 2:
      isCustomerDataLoading = isLoading;
      break;
    case 3:
      if (daysDifference <= 31) {
        isCustomerDataLoading = isLoading;
      } else {
        isCustomerDataLoading = isLoading;
      }
      break;
  }
}

// Error handling
void _handleApiError(int selectedButton, int daysDifference) {
  _setLoadingState(selectedButton, daysDifference, false);
  _resetSectionData(selectedButton, daysDifference);
  customersReportValue.value++;
}

void _handleException(
    int selectedButton, int daysDifference, Exception exception) {
  _setLoadingState(selectedButton, daysDifference, false);
  _resetSectionData(selectedButton, daysDifference);
  if (kDebugMode) {
    print("Error in getExecutiveCustomersReport: $exception");
  }
}

// Reset section data on error
void _resetSectionData(int selectedButton, int daysDifference) {
  switch (selectedButton) {
    case 1:
      _resetSectionsList1a();
      break;
    case 2:
      _resetSectionsList2a();
      break;
    case 3:
      _resetSectionsList3a();
      break;
    case 4:
      _resetSectionsList3b();
      break;
  }
}

void _resetSectionsList1a() {
  for (int i = 0; i < 3; i++) {
    Constants.customers_sectionsList1a_1_1[i].amount = 0;
  }
}

void _resetSectionsList2a() {
  for (int i = 0; i < 3; i++) {
    Constants.customers_sectionsList2a_1_1[i].amount = 0;
  }
}

void _resetSectionsList3a() {
  for (int i = 0; i < 3; i++) {
    Constants.customers_sectionsList3a_1_1[i].amount = 0;
  }
}

void _resetSectionsList3b() {
  for (int i = 0; i < 3; i++) {
    Constants.customers_sectionsList3b_1_1[i].amount = 0;
  }
}

// Main response processing router
Future<void> _processApiResponse(Map<String, dynamic> jsonResponse,
    int selectedButton, int daysDifference) async {
  _setLoadingState(selectedButton, daysDifference, false);
  Constants.currentCustomerProfile = CustomerProfile.fromJson(jsonResponse);

  customersReportValue.value++;
}

// Age distribution data processing (reusable)
class AgeDistributionProcessor {
  static void processAgeDistributionData(Map<String, dynamic> jsonResponse,
      String suffix // e.g., "1a", "2a", "3a", "3b"
      ) {
    _processAgeDistributionMaps(jsonResponse, suffix);
    _processAgeDistributionLists(jsonResponse, suffix);
    _processClaimsAgeDistribution(jsonResponse, suffix);
    _processDeceasedAgesList(jsonResponse, suffix);
  }

  static void _processAgeDistributionMaps(
      Map<String, dynamic> jsonResponse, String suffix) {
    final targets = [
      'age_distribution_by_gender_and_type_${suffix}_1',
      'age_distribution_by_gender_and_type_${suffix}_2',
      'age_distribution_by_gender_and_type_${suffix}_3'
    ];

    final sources = [
      'age_distribution_by_gender_and_type',
      'age_distribution_by_gender_and_type_inforced',
      'age_distribution_by_gender_and_type_not_inforced'
    ];

    for (int i = 0; i < targets.length; i++) {
      _setConstantValue(targets[i], jsonResponse[sources[i]] ?? {});
    }
  }

  static void _processAgeDistributionLists(
      Map<String, dynamic> jsonResponse, String suffix) {
    final memberTypes = ['main_member', 'partner', 'child', 'extended_family'];
    final listSources = [
      'age_distribution_lists',
      'age_distribution_lists_inforced',
      'age_distribution_lists_not_inforced'
    ];

    for (int memberTypeIndex = 0;
        memberTypeIndex < memberTypes.length;
        memberTypeIndex++) {
      for (int sourceIndex = 0;
          sourceIndex < listSources.length;
          sourceIndex++) {
        final targetKey =
            'age_distribution_lists_${suffix}_${memberTypeIndex + 1}_${sourceIndex + 1}';
        final sourceData = jsonResponse[listSources[sourceIndex]]
                [memberTypes[memberTypeIndex]] ??
            [];

        _setConstantValue(targetKey,
            List<double>.from(sourceData.map((item) => item.toDouble())));
      }
    }
  }

  static void _processClaimsAgeDistribution(
      Map<String, dynamic> jsonResponse, String suffix) {
    // Claims age distribution maps
    final claimsTargets = [
      'claims_age_distribution_by_gender_and_type_${suffix}_1',
      'claims_age_distribution_by_gender_and_type_${suffix}_2',
      'claims_age_distribution_by_gender_and_type_${suffix}_3'
    ];

    final claimsSources = [
      'claims_age_distribution_by_gender_and_type',
      'claims_age_distribution_by_gender_and_type_inforced',
      'claims_age_distribution_by_gender_and_type_not_inforced'
    ];

    for (int i = 0; i < claimsTargets.length; i++) {
      _setConstantValue(claimsTargets[i], jsonResponse[claimsSources[i]] ?? {});
    }

    // Claims age distribution lists
    final memberTypes = ['main_member', 'partner', 'child', 'extended_family'];
    final claimsListSources = [
      'claims_age_distribution_lists',
      'claims_age_distribution_lists_inforced',
      'claims_age_distribution_lists_not_inforced'
    ];

    for (int memberTypeIndex = 0;
        memberTypeIndex < memberTypes.length;
        memberTypeIndex++) {
      for (int sourceIndex = 0;
          sourceIndex < claimsListSources.length;
          sourceIndex++) {
        final targetKey =
            'claims_age_distribution_lists_${suffix}_${memberTypeIndex + 1}_${sourceIndex + 1}';
        final sourceData = jsonResponse[claimsListSources[sourceIndex]]
                [memberTypes[memberTypeIndex]] ??
            [];

        _setConstantValue(targetKey,
            List<double>.from(sourceData.map((item) => item.toDouble())));
      }
    }
  }

  static void _processDeceasedAgesList(
      Map<String, dynamic> jsonResponse, String suffix) {
    final targetKey = suffix.startsWith('3b')
        ? 'claims_deceased_ages_list3b'
        : 'customers_claims_deceased_ages_list${suffix}';
    final sourceData = jsonResponse["deceased_ages_list"] ?? [];

    _setConstantValue(
        targetKey,
        List<int>.from(sourceData
            .map((item) => item is int ? item : int.parse(item.toString()))));
  }
}

// Section data processor (reusable)
class SectionDataProcessor {
  static void processSectionData(
      Map<String, dynamic> jsonResponse, String suffix) {
    final sectionKeys = [
      'customers_sectionsList${suffix}_1_1',
      'customers_claims_sectionsList${suffix}_1_1'
    ];

    final dataKeys = [
      ['total_members', 'on_inforced_policies', 'on_not_inforced_policies'],
      [
        'claims_total_members',
        'claims_on_inforced_policies',
        'claims_on_not_inforced_policies'
      ]
    ];

    for (int sectionIndex = 0;
        sectionIndex < sectionKeys.length;
        sectionIndex++) {
      for (int dataIndex = 0; dataIndex < 3; dataIndex++) {
        final targetList = _getConstantValue(sectionKeys[sectionIndex]);
        if (targetList != null && targetList.length > dataIndex) {
          targetList[dataIndex].amount =
              jsonResponse[dataKeys[sectionIndex][dataIndex]] ?? 0;
        }
      }
    }
  }
}

// Data initializer (reusable)
class DataInitializer {
  static void initializeCustomerData(String suffix) {
    _initializeAgeBarGroups(suffix);
    _initializePercentageData(suffix);
    _initializeCountData(suffix);
    _clearSegmentData(suffix);
  }

  static void initializeClaimsData(String suffix) {
    _initializeClaimsAgeBarGroups(suffix);
    _initializeClaimsPercentageData(suffix);
    _initializeClaimsCountData(suffix);
    _clearClaimsSegmentData(suffix);
  }

  static void _initializeAgeBarGroups(String suffix) {
    final groupKeys = [
      'customers_age_barGroups${suffix}_1_1',
      'customers_age_barGroups${suffix}_1_2',
      'customers_age_barGroups${suffix}_1_3',
      'customers_age_barGroups${suffix}_2_1',
      'customers_age_barGroups${suffix}_2_2',
      'customers_age_barGroups${suffix}_2_3',
      'customers_age_barGroups${suffix}_3_1',
      'customers_age_barGroups${suffix}_3_2',
      'customers_age_barGroups${suffix}_3_3',
      'customers_age_barGroups${suffix.replaceFirst('a', 'b')}_1_1',
      'customers_age_barGroups${suffix.replaceFirst('a', 'b')}_1_2',
      'customers_age_barGroups${suffix.replaceFirst('a', 'b')}_1_3',
      'customers_age_barGroups${suffix.replaceFirst('a', 'b')}_2_1',
      'customers_age_barGroups${suffix.replaceFirst('a', 'b')}_2_2',
      'customers_age_barGroups${suffix.replaceFirst('a', 'b')}_2_3',
      'customers_age_barGroups${suffix.replaceFirst('a', 'b')}_3_1',
      'customers_age_barGroups${suffix.replaceFirst('a', 'b')}_3_2',
      'customers_age_barGroups${suffix.replaceFirst('a', 'b')}_3_3'
    ];

    for (final key in groupKeys) {
      _setConstantValue(key, []);
    }
  }

  static void _initializePercentageData(String suffix) {
    final percentageKeys = [
      'customers_malePercentage${suffix}_1_1',
      'customers_malePercentage${suffix}_1_2',
      'customers_malePercentage${suffix}_1_3',
      'customers_femalePercentage${suffix}_1_1',
      'customers_femalePercentage${suffix}_1_2',
      'customers_femalePercentage${suffix}_1_3',
      'customers_maxPercentage${suffix}_1_1',
      'customers_maxPercentage${suffix}_2_1',
      'customers_maxPercentage${suffix}_3_1'
    ];

    for (final key in percentageKeys) {
      _setConstantValue(key, 0);
    }
  }

  static void _initializeCountData(String suffix) {
    final countKeys = [
      'customers_maleCount${suffix}_1_1',
      'customers_maleCount${suffix}_1_2',
      'customers_maleCount${suffix}_1_3',
      'customers_femaleCount${suffix}_1_1',
      'customers_femaleCount${suffix}_1_2',
      'customers_femaleCount${suffix}_1_3'
    ];

    for (final key in countKeys) {
      _setConstantValue(key, 0);
    }
  }

  static void _clearSegmentData(String suffix) {
    _setConstantValue('customers_segment_${suffix}', []);
  }

  static void _initializeClaimsAgeBarGroups(String suffix) {
    // Similar pattern for claims data
    final groupKeys = [
      'customers_claims_age_barGroups${suffix}_1_1',
      'customers_claims_age_barGroups${suffix}_1_2',
      'customers_claims_age_barGroups${suffix}_1_3',
      'customers_claims_age_barGroups${suffix}_2_1',
      'customers_claims_age_barGroups${suffix}_2_2',
      'customers_claims_age_barGroups${suffix}_2_3',
      'customers_claims_age_barGroups${suffix}_3_1',
      'customers_claims_age_barGroups${suffix}_3_2',
      'customers_claims_age_barGroups${suffix}_3_3'
    ];

    for (final key in groupKeys) {
      _setConstantValue(key, []);
    }
  }

  static void _initializeClaimsPercentageData(String suffix) {
    final percentageKeys = [
      'customers_claims_malePercentage${suffix}_1_1',
      'customers_claims_malePercentage${suffix}_1_2',
      'customers_claims_malePercentage${suffix}_1_3',
      'customers_claims_femalePercentage${suffix}_1_1',
      'customers_claims_femalePercentage${suffix}_1_2',
      'customers_claims_femalePercentage${suffix}_1_3',
      'customers_claims_maxPercentage${suffix}_1_1',
      'customers_claims_maxPercentage${suffix}_2_1',
      'customers_claims_maxPercentage${suffix}_3_1'
    ];

    for (final key in percentageKeys) {
      _setConstantValue(key, 0);
    }
  }

  static void _initializeClaimsCountData(String suffix) {
    final countKeys = [
      'customers_claims_maleCount${suffix}_1_1',
      'customers_claims_maleCount${suffix}_1_2',
      'customers_claims_maleCount${suffix}_1_3',
      'customers_claims_femaleCount${suffix}_1_1',
      'customers_claims_femaleCount${suffix}_1_2',
      'customers_claims_femaleCount${suffix}_1_3'
    ];

    for (final key in countKeys) {
      _setConstantValue(key, 0);
    }
  }

  static void _clearClaimsSegmentData(String suffix) {
    _setConstantValue('customers_claims_segment_${suffix}', []);
  }
}

// Individual button processors - now much cleaner
Future<void> _processButton1Response(Map<String, dynamic> jsonResponse) async {
  print("Processing Button 1: ${jsonResponse}");

  // Initialize data structures
  _initializeButton1Data();

  // Process age distribution data
  AgeDistributionProcessor.processAgeDistributionData(jsonResponse, "1a");

  // Process section data
  SectionDataProcessor.processSectionData(jsonResponse, "1a");

  // Process specific calculations
  DataInitializer.initializeCustomerData("1a");
  DataInitializer.initializeClaimsData("1a");
}

Future<void> _processButton2Response(Map<String, dynamic> jsonResponse) async {
  // Initialize data structures
  _initializeButton2Data();

  // Process age distribution data
  AgeDistributionProcessor.processAgeDistributionData(jsonResponse, "2a");

  // Process section data
  SectionDataProcessor.processSectionData(jsonResponse, "2a");

  // Process specific calculations
  DataInitializer.initializeCustomerData("2a");
  DataInitializer.initializeClaimsData("2a");

  // Calculate claims ratio
  if (jsonResponse["claims_ratio_dict"] != null) {
    double sum = double.parse((jsonResponse["claims_ratio_dict"].values.fold(
        0, (previousValue, element) => previousValue + element)).toString());
    Constants.customers_claims_2a = double.parse(
            (sum / jsonResponse["claims_ratio_dict"].length)
                .toStringAsFixed(2)) *
        100;
  }
}

Future<void> _processButton3Response(Map<String, dynamic> jsonResponse) async {
  // Initialize data structures
  _initializeButton3Data();

  // Process age distribution data
  AgeDistributionProcessor.processAgeDistributionData(jsonResponse, "3a");

  // Process section data
  SectionDataProcessor.processSectionData(jsonResponse, "3a");

  // Process specific calculations
  DataInitializer.initializeCustomerData("3a");
  DataInitializer.initializeClaimsData("3a");
}

Future<void> _processButton4Response(Map<String, dynamic> jsonResponse) async {
  // Initialize data structures
  _initializeButton4Data();

  // Process age distribution data
  AgeDistributionProcessor.processAgeDistributionData(jsonResponse, "3b");

  // Reset claims max values
  Constants.claims_maxY5d = 0;
}

// Data initialization helpers
void _initializeButton1Data() {
  Constants.claims_bottomTitles1a = [];
  Constants.claims_maxY5a = 0;
  Constants.age_distribution_by_gender_and_type_1a_1 = {};
  Constants.age_distribution_by_gender_and_type_1a_2 = {};
  Constants.age_distribution_by_gender_and_type_1a_3 = {};
}

void _initializeButton2Data() {
  Constants.claims_bottomTitles2a = [];
  Constants.claims_maxY5b = 0;
  Constants.customers_claims_deceased_ages_list2a = [];
}

void _initializeButton3Data() {
  Constants.claims_maxY5c = 0;
  Constants.customers_claims_deceased_ages_list3a = [];
}

void _initializeButton4Data() {
  Constants.claims_maxY5d = 0;
  Constants.claims_deceased_ages_list3b = [];
}

// Helper functions for reflection-like behavior
void _setConstantValue(String key, dynamic value) {
  // This would need to be implemented based on your Constants class structure
  // You might need to use a Map<String, dynamic> or reflection
  // For now, this is a placeholder that shows the pattern
  switch (key) {
    // Add cases for each constant you need to set
    // Example:
    // case 'customers_sectionsList1a_1_1': Constants.customers_sectionsList1a_1_1 = value; break;
    default:
      if (kDebugMode) {
        print("Unknown constant key: $key");
      }
  }
}

dynamic _getConstantValue(String key) {
  // Similar pattern for getting values
  switch (key) {
    // Add cases for each constant you need to get
    default:
      if (kDebugMode) {
        print("Unknown constant key: $key");
      }
      return null;
  }
}

Map<String, Color> typeToColor = {
  'Cash Payment': Colors.green,
  'Debit Order': Colors.purple,
  'persal': Colors.green,
  'Salary Deduction': Colors.yellow,
  'Other': Colors.grey,
};

Map<Color, int> colorOrder = {
  Colors.green: 1,
  Colors.purple: 2,
  Colors.green: 3,
  Colors.yellow: 4,
  Colors.grey: 5,
};
Color _getStatusColor(String status) {
  Color color;
  switch (status) {
    case 'Cash Payment':
      color = Colors.green;
      break;
    case 'EFT':
      color = Colors.green;
      break;
    case 'Debit Order':
      color = Colors.green;
      break;
    case 'persal':
      color = Colors.green;
      break;
    case 'Easypay':
      color = Colors.green;
      break;
    case 'Salary Deduction':
      color = Colors.green;
      break;
    default:
      //print("fgghgh " + status);
      color = Colors.green;
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
        double count = (item["average_premium"] as num)
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
      double count = (item["average_premium"] ?? "0.0" as num).toDouble();
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

List<BarChartGroupData> processDataForCommissionCountMonthly2(
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
      double count = (item["average_premium"] as num).toDouble();

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

    var sortedEntries = sortReprintCancellationsData(statusData!);
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

List<MapEntry<String, double>> sortReprintCancellationsData(
    Map<String, double> salesData) {
  Map<String, Color> typeToColor = {
    'Cash Payment': Colors.green,
    'Debit Order': Colors.purple,
    'persal': Colors.green,
    'Salary Deduction': Colors.yellow,
    'Other': Colors.grey,
  };

  Map<Color, int> colorOrder = {
    Colors.green: 1,
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

void getAllTotals1(Map<String, dynamic> jsonResponse) {
  // Helper function to calculate gender totals and percentages
  void calculateTotalsAndPercentages(
      int totalMale, int totalFemale, int sectionIndex) {
    double malePercentage = totalMale / (totalMale + totalFemale).toDouble();
    double femalePercentage =
        totalFemale / (totalMale + totalFemale).toDouble();

    // Set values in Constants
    Constants.customers_maleCount[sectionIndex] = totalMale;
    Constants.customers_femaleCount[sectionIndex] = totalFemale;
    Constants.customers_malePercentage[sectionIndex] = malePercentage;
    Constants.customers_femalePercentage[sectionIndex] = femalePercentage;
    Constants.customers_sectionsList[sectionIndex][0].amount =
        totalMale + totalFemale;
  }

  // Calculate partner totals
  int totalMalePartners =
      jsonResponse["members_counts"]["partner"]["genders"]["male"]["total"];
  int totalFemalePartners =
      jsonResponse["members_counts"]["partner"]["genders"]["female"]["total"];
  calculateTotalsAndPercentages(totalMalePartners, totalFemalePartners, 4);

  // Calculate dependant totals
  int totalMaleDependants = jsonResponse["members_counts"]["child"]["genders"]
          ["male"]["total"] +
      jsonResponse["members_counts"]["adult_child"]["genders"]["male"]
          ["total"] +
      jsonResponse["members_counts"]["beneficiary"]["genders"]["male"]
          ["total"] +
      jsonResponse["members_counts"]["extended_family"]["genders"]["male"]
          ["total"];

  int totalFemaleDependants = jsonResponse["members_counts"]["child"]["genders"]
          ["female"]["total"] +
      jsonResponse["members_counts"]["adult_child"]["genders"]["female"]
          ["total"] +
      jsonResponse["members_counts"]["beneficiary"]["genders"]["female"]
          ["total"] +
      jsonResponse["members_counts"]["extended_family"]["genders"]["female"]
          ["total"];

  // Calculate main member totals
  int totalMaleMainMembers =
      jsonResponse["members_counts"]["main_member"]["genders"]["male"]["total"];
  int totalFemaleMainMembers = jsonResponse["members_counts"]["main_member"]
      ["genders"]["female"]["total"];

  // Calculate total customer counts
  int totalMaleCustomers =
      totalMaleMainMembers + totalMaleDependants + totalMalePartners;
  int totalFemaleCustomers =
      totalFemaleMainMembers + totalFemaleDependants + totalFemalePartners;

  // Set overall totals
  calculateTotalsAndPercentages(totalMaleCustomers, totalFemaleCustomers, 1);
  calculateTotalsAndPercentages(
      totalMaleMainMembers, totalFemaleMainMembers, 2);
  calculateTotalsAndPercentages(totalMaleDependants, totalFemaleDependants, 3);

  if (jsonResponse["gender_distribution_by_age"] != null) {}
}
