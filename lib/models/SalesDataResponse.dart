import 'package:fl_chart/fl_chart.dart';
import 'package:mi_insights/services/longPrint.dart';

import '../screens/Reports/Executive/ExecutiveSalesReport.dart';

class SalesDataResponse {
  MtdData? mtdData;
  CustomRangeData? customRangeData;
  final double percentageWithExtPolicy;
  final int totalSaleCounts;
  final int totalInforcedCounts;
  final int totalNotInforcedCounts;
  final List<DateValueWithX> resultLista;
  final List<DateValueWithX> resultListb;
  final List<DateValueWithX> resultListc;
  final List<DateRateWithX> lapseResultList;
  final List<DateRateWithX> ntuResultList;
  final List<MonthlyRateData> lapseResultList12Months;
  final List<MonthlyRateData> ntuResultList12Months;
  final List<Employee> topEmployeesa;
  final List<Employee> topEmployeesb;
  final List<Employee> topEmployeesc;
  final List<EmployeeRate> topEmployeeRates;
  final List<Employee> bottomEmployeesa;
  final List<Employee> bottomEmployeesb;
  final List<Employee> bottomEmployeesc;
  final List<BranchSales> branchSalesa;
  final List<BranchSales> branchSalesb;
  final List<BranchSales> branchSalesc;
  final int branchMaxYa;
  final int branchMaxYb;
  final int branchMaxYc;
  final int dailyOrMonthlya;
  final int dailyOrMonthlyb;
  final int dailyOrMonthlyc;
  final List<SaleSummary> saleSummary;
  final Map<String, dynamic> productsGroup;
  final List<DateTargetWithX> targetResultLista;
  final int monthlyTargetValue;
  final List<FlSpot> salesSpotsDaily;
  final List<FlSpot> salesSpotsMonthly;
  final List<FlSpot> targetSpotsDaily;
  final List<FlSpot> targetSpotsMonthly;
  final Map<String, SalesDataSpotsByMonth> salesDataSpotsByMonth;
  final SalesInfo salesInfo;
  final bool isDailyView;

  var targetAverageSpotsDaily;
  final List<PremiumResult>? premiumResultList;
  final double averageDailyPremium;
  final double averageMonthlyPremium;
  final double overallAveragePremium;
  final double maxAveragePremium;

  SalesDataResponse({
    required this.percentageWithExtPolicy,
    required this.totalSaleCounts,
    required this.totalInforcedCounts,
    required this.totalNotInforcedCounts,
    required this.resultLista,
    required this.resultListb,
    required this.resultListc,
    required this.lapseResultList,
    required this.ntuResultList,
    required this.lapseResultList12Months,
    required this.ntuResultList12Months,
    required this.topEmployeesa,
    required this.topEmployeesb,
    required this.topEmployeesc,
    required this.topEmployeeRates,
    required this.bottomEmployeesa,
    required this.bottomEmployeesb,
    required this.bottomEmployeesc,
    required this.branchSalesa,
    required this.branchSalesb,
    required this.branchSalesc,
    required this.branchMaxYa,
    required this.branchMaxYb,
    required this.branchMaxYc,
    required this.dailyOrMonthlya,
    required this.dailyOrMonthlyb,
    required this.dailyOrMonthlyc,
    required this.saleSummary,
    required this.productsGroup,
    required this.targetResultLista,
    required this.monthlyTargetValue,
    required this.salesSpotsDaily,
    required this.salesSpotsMonthly,
    required this.targetSpotsDaily,
    required this.targetSpotsMonthly,
    required this.salesDataSpotsByMonth,
    required this.salesInfo,
    required this.isDailyView,
    this.premiumResultList,
    required this.averageDailyPremium,
    required this.averageMonthlyPremium,
    required this.overallAveragePremium,
    required this.maxAveragePremium,
  });

  factory SalesDataResponse.fromJson(Map<String, dynamic> json) {
    logLongString("fgfghg $json");
    return SalesDataResponse(
      percentageWithExtPolicy:
          (json['percentage_with_ext_policy'] ?? 0).toDouble(),
      totalSaleCounts: _parseToInt(json['total_sale_counts']),
      totalInforcedCounts: _parseToInt(json['total_inforced_counts']),
      totalNotInforcedCounts: _parseToInt(json['total_not_inforced_counts']),
      resultLista: _parseDateValueWithXList(json['result_lista']),
      resultListb: _parseDateValueWithXList(json['result_listb']),
      resultListc: _parseDateValueWithXList(json['result_listc']),
      lapseResultList: _parseDateRateWithXList(json['lapse_result_list']),
      ntuResultList: _parseDateRateWithXList(json['ntu_result_list']),
      lapseResultList12Months:
          _parseMonthlyRateDataList(json['lapse_result_list_12_months']),
      ntuResultList12Months:
          _parseMonthlyRateDataList(json['ntu_result_list_12_months']),
      topEmployeesa: _parseEmployeeList(json['top_employeesa']),
      topEmployeesb: _parseEmployeeList(json['top_employeesb']),
      topEmployeesc: _parseEmployeeList(json['top_employeesc']),
      topEmployeeRates: _parseEmployeeRateList(json['top_employee_rates']),
      bottomEmployeesa: _parseEmployeeList(json['bottom_employeesa']),
      bottomEmployeesb: _parseEmployeeList(json['bottom_employeesb']),
      bottomEmployeesc: _parseEmployeeList(json['bottom_employeesc']),
      branchSalesa: _parseBranchSalesList(json['branch_salesa']),
      branchSalesb: _parseBranchSalesList(json['branch_salesb']),
      branchSalesc: _parseBranchSalesList(json['branch_salesc']),
      branchMaxYa: _parseToInt(json['branch_maxYa']),
      branchMaxYb: _parseToInt(json['branch_maxYb']),
      branchMaxYc: _parseToInt(json['branch_maxYc']),
      dailyOrMonthlya: _parseToInt(json['daily_or_monthlya']),
      dailyOrMonthlyb: _parseToInt(json['daily_or_monthlyb']),
      dailyOrMonthlyc: _parseToInt(json['daily_or_monthlyc']),
      saleSummary: _parseSaleSummaryList(json['sale_summary']),
      productsGroup: json['products_group'] ?? {},
      targetResultLista: _parseDateTargetWithXList(json['target_result_lista']),
      monthlyTargetValue: _parseToInt(json['monthly_target_value']),
      salesSpotsDaily: _parseFlSpotList(json['sales_spots_daily']),
      salesSpotsMonthly: _parseFlSpotList(json['sales_spots_monthly']),
      targetSpotsDaily: _parseFlSpotList(json['target_spots_daily']),
      targetSpotsMonthly: _parseFlSpotList(json['target_spots_monthly']),
      salesDataSpotsByMonth:
          _parseSalesDataSpotsByMonth(json['sales_data_spots_by_month']),
      salesInfo: SalesInfo.fromJson(json['sales_info'] ?? {}),
      isDailyView: json['is_daily_view'] ?? true,
      premiumResultList: _parsePremiumResultList(json['sale_summary']),
      averageDailyPremium: (json['average_daily_premium'] ?? 0.0).toDouble(),
      averageMonthlyPremium:
          (json['average_monthly_premium'] ?? 0.0).toDouble(),
      overallAveragePremium:
          (json['overall_average_premium'] ?? 0.0).toDouble(),
      maxAveragePremium: (json['max_average_premium'] ?? 100.0).toDouble(),
    );
  }
  static List<PremiumResult>? _parsePremiumResultList(dynamic list) {
    if (list == null) return null;
    return (list as List).map((item) => PremiumResult.fromJson(item)).toList();
  }

  static List<DateRateWithX> _parseSimpleRateList(dynamic list) {
    if (list == null) return [];
    return (list as List).map((item) {
      return DateRateWithX(
        date: '', // No date in simplified format
        rate: (item['rate'] ?? 0).toDouble(),
        x: (item['x'] ?? 0).toDouble(),
      );
    }).toList();
  }

  // Helper method to safely parse to int
  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static List<DateValueWithX> _parseDateValueWithXList(dynamic list) {
    if (list == null) return [];
    return (list as List).map((item) => DateValueWithX.fromJson(item)).toList();
  }

  static List<DateRateWithX> _parseDateRateWithXList(dynamic list) {
    if (list == null) return [];
    return (list as List).map((item) => DateRateWithX.fromJson(item)).toList();
  }

  static List<MonthlyRateData> _parseMonthlyRateDataList(dynamic list) {
    if (list == null) return [];
    return (list as List)
        .map((item) => MonthlyRateData.fromJson(item))
        .toList();
  }

  static List<DateTargetWithX> _parseDateTargetWithXList(dynamic list) {
    if (list == null) return [];
    return (list as List)
        .map((item) => DateTargetWithX.fromJson(item))
        .toList();
  }

  static List<Employee> _parseEmployeeList(dynamic list) {
    if (list == null) return [];
    return (list as List).map((item) => Employee.fromJson(item)).toList();
  }

  static List<EmployeeRate> _parseEmployeeRateList(dynamic list) {
    if (list == null) return [];
    return (list as List).map((item) => EmployeeRate.fromJson(item)).toList();
  }

  static List<BranchSales> _parseBranchSalesList(dynamic list) {
    if (list == null) return [];
    return (list as List).map((item) => BranchSales.fromJson(item)).toList();
  }

  static List<SaleSummary> _parseSaleSummaryList(dynamic list) {
    if (list == null) return [];
    return (list as List).map((item) => SaleSummary.fromJson(item)).toList();
  }

  static List<FlSpot> _parseFlSpotList(dynamic list) {
    if (list == null) return [];
    return (list as List).map((item) => FlSpotHelper.fromJson(item)).toList();
  }

  static Map<String, SalesDataSpotsByMonth> _parseSalesDataSpotsByMonth(
      dynamic map) {
    if (map == null) return {};
    Map<String, SalesDataSpotsByMonth> result = {};
    (map as Map<String, dynamic>).forEach((key, value) {
      result[key] = SalesDataSpotsByMonth.fromJson(value);
    });
    return result;
  }

  // Rest of the methods remain the same...
  Map<String, dynamic> toJson() {
    return {
      'percentage_with_ext_policy': percentageWithExtPolicy,
      'total_sale_counts': totalSaleCounts,
      'total_inforced_counts': totalInforcedCounts,
      'total_not_inforced_counts': totalNotInforcedCounts,
      'result_lista': resultLista.map((e) => e.toJson()).toList(),
      'result_listb': resultListb.map((e) => e.toJson()).toList(),
      'result_listc': resultListc.map((e) => e.toJson()).toList(),
      'lapse_result_list': lapseResultList.map((e) => e.toJson()).toList(),
      'ntu_result_list': ntuResultList.map((e) => e.toJson()).toList(),
      'lapse_result_list_12_months':
          lapseResultList12Months.map((e) => e.toJson()).toList(),
      'ntu_result_list_12_months':
          ntuResultList12Months.map((e) => e.toJson()).toList(),
      'top_employeesa': topEmployeesa.map((e) => e.toJson()).toList(),
      'top_employeesb': topEmployeesb.map((e) => e.toJson()).toList(),
      'top_employeesc': topEmployeesc.map((e) => e.toJson()).toList(),
      'top_employee_rates': topEmployeeRates.map((e) => e.toJson()).toList(),
      'bottom_employeesa': bottomEmployeesa.map((e) => e.toJson()).toList(),
      'bottom_employeesb': bottomEmployeesb.map((e) => e.toJson()).toList(),
      'bottom_employeesc': bottomEmployeesc.map((e) => e.toJson()).toList(),
      'branch_salesa': branchSalesa.map((e) => e.toJson()).toList(),
      'branch_salesb': branchSalesb.map((e) => e.toJson()).toList(),
      'branch_salesc': branchSalesc.map((e) => e.toJson()).toList(),
      'branch_maxYa': branchMaxYa,
      'branch_maxYb': branchMaxYb,
      'branch_maxYc': branchMaxYc,
      'daily_or_monthlya': dailyOrMonthlya,
      'daily_or_monthlyb': dailyOrMonthlyb,
      'daily_or_monthlyc': dailyOrMonthlyc,
      'sale_summary': saleSummary.map((e) => e.toJson()).toList(),
      'products_group': productsGroup,
      'target_result_lista': targetResultLista.map((e) => e.toJson()).toList(),
      'monthly_target_value': monthlyTargetValue,
      'sales_spots_daily': salesSpotsDaily.map((e) => e.toJson()).toList(),
      'sales_spots_monthly': salesSpotsMonthly.map((e) => e.toJson()).toList(),
      'target_spots_daily': targetSpotsDaily.map((e) => e.toJson()).toList(),
      'target_spots_monthly':
          targetSpotsMonthly.map((e) => e.toJson()).toList(),
      'sales_data_spots_by_month': salesDataSpotsByMonth
          .map((key, value) => MapEntry(key, value.toJson())),
      'sales_info': salesInfo.toJson(),
      'is_daily_view': isDailyView,
    };
  }

  factory SalesDataResponse.empty() {
    return SalesDataResponse(
      percentageWithExtPolicy: 0.0,
      totalSaleCounts: 0,
      totalInforcedCounts: 0,
      totalNotInforcedCounts: 0,
      resultLista: [],
      resultListb: [],
      resultListc: [],
      lapseResultList: [],
      ntuResultList: [],
      lapseResultList12Months: [],
      ntuResultList12Months: [],
      topEmployeesa: [],
      topEmployeesb: [],
      topEmployeesc: [],
      topEmployeeRates: [],
      bottomEmployeesa: [],
      bottomEmployeesb: [],
      bottomEmployeesc: [],
      branchSalesa: [],
      branchSalesb: [],
      branchSalesc: [],
      branchMaxYa: 0,
      branchMaxYb: 0,
      branchMaxYc: 0,
      dailyOrMonthlya: 0,
      dailyOrMonthlyb: 0,
      dailyOrMonthlyc: 0,
      saleSummary: [],
      productsGroup: {},
      targetResultLista: [],
      monthlyTargetValue: 0,
      salesSpotsDaily: [],
      salesSpotsMonthly: [],
      targetSpotsDaily: [],
      targetSpotsMonthly: [],
      salesDataSpotsByMonth: {},
      salesInfo: SalesInfo.empty(),
      isDailyView: true,
      averageDailyPremium: 0,
      averageMonthlyPremium: 0,
      maxAveragePremium: 0,
      overallAveragePremium: 0,
    );
  }

  bool get isEmpty {
    return totalSaleCounts == 0 &&
        totalInforcedCounts == 0 &&
        totalNotInforcedCounts == 0 &&
        topEmployeesa.isEmpty &&
        branchSalesa.isEmpty;
  }

  bool get isNotEmpty => !isEmpty;

  SalesDataResponse copyWith({
    double? percentageWithExtPolicy,
    int? totalSaleCounts,
    int? totalInforcedCounts,
    int? totalNotInforcedCounts,
    List<DateValueWithX>? resultLista,
    List<DateValueWithX>? resultListb,
    List<DateValueWithX>? resultListc,
    List<DateRateWithX>? lapseResultList,
    List<DateRateWithX>? ntuResultList,
    List<MonthlyRateData>? lapseResultList12Months,
    List<MonthlyRateData>? ntuResultList12Months,
    List<Employee>? topEmployeesa,
    List<Employee>? topEmployeesb,
    List<Employee>? topEmployeesc,
    List<EmployeeRate>? topEmployeeRates,
    List<Employee>? bottomEmployeesa,
    List<Employee>? bottomEmployeesb,
    List<Employee>? bottomEmployeesc,
    List<BranchSales>? branchSalesa,
    List<BranchSales>? branchSalesb,
    List<BranchSales>? branchSalesc,
    int? branchMaxYa,
    int? branchMaxYb,
    int? branchMaxYc,
    int? dailyOrMonthlya,
    int? dailyOrMonthlyb,
    int? dailyOrMonthlyc,
    List<SaleSummary>? saleSummary,
    Map<String, dynamic>? productsGroup,
    List<DateTargetWithX>? targetResultLista,
    int? monthlyTargetValue,
    List<FlSpot>? salesSpotsDaily,
    List<FlSpot>? salesSpotsMonthly,
    List<FlSpot>? targetSpotsDaily,
    List<FlSpot>? targetSpotsMonthly,
    Map<String, SalesDataSpotsByMonth>? salesDataSpotsByMonth,
    SalesInfo? salesInfo,
    bool? isDailyView,
  }) {
    return SalesDataResponse(
      percentageWithExtPolicy:
          percentageWithExtPolicy ?? this.percentageWithExtPolicy,
      totalSaleCounts: totalSaleCounts ?? this.totalSaleCounts,
      totalInforcedCounts: totalInforcedCounts ?? this.totalInforcedCounts,
      totalNotInforcedCounts:
          totalNotInforcedCounts ?? this.totalNotInforcedCounts,
      resultLista: resultLista ?? this.resultLista,
      resultListb: resultListb ?? this.resultListb,
      resultListc: resultListc ?? this.resultListc,
      lapseResultList: lapseResultList ?? this.lapseResultList,
      ntuResultList: ntuResultList ?? this.ntuResultList,
      lapseResultList12Months:
          lapseResultList12Months ?? this.lapseResultList12Months,
      ntuResultList12Months:
          ntuResultList12Months ?? this.ntuResultList12Months,
      topEmployeesa: topEmployeesa ?? this.topEmployeesa,
      topEmployeesb: topEmployeesb ?? this.topEmployeesb,
      topEmployeesc: topEmployeesc ?? this.topEmployeesc,
      topEmployeeRates: topEmployeeRates ?? this.topEmployeeRates,
      bottomEmployeesa: bottomEmployeesa ?? this.bottomEmployeesa,
      bottomEmployeesb: bottomEmployeesb ?? this.bottomEmployeesb,
      bottomEmployeesc: bottomEmployeesc ?? this.bottomEmployeesc,
      branchSalesa: branchSalesa ?? this.branchSalesa,
      branchSalesb: branchSalesb ?? this.branchSalesb,
      branchSalesc: branchSalesc ?? this.branchSalesc,
      branchMaxYa: branchMaxYa ?? this.branchMaxYa,
      branchMaxYb: branchMaxYb ?? this.branchMaxYb,
      branchMaxYc: branchMaxYc ?? this.branchMaxYc,
      dailyOrMonthlya: dailyOrMonthlya ?? this.dailyOrMonthlya,
      dailyOrMonthlyb: dailyOrMonthlyb ?? this.dailyOrMonthlyb,
      dailyOrMonthlyc: dailyOrMonthlyc ?? this.dailyOrMonthlyc,
      saleSummary: saleSummary ?? this.saleSummary,
      productsGroup: productsGroup ?? this.productsGroup,
      targetResultLista: targetResultLista ?? this.targetResultLista,
      monthlyTargetValue: monthlyTargetValue ?? this.monthlyTargetValue,
      salesSpotsDaily: salesSpotsDaily ?? this.salesSpotsDaily,
      salesSpotsMonthly: salesSpotsMonthly ?? this.salesSpotsMonthly,
      targetSpotsDaily: targetSpotsDaily ?? this.targetSpotsDaily,
      targetSpotsMonthly: targetSpotsMonthly ?? this.targetSpotsMonthly,
      salesDataSpotsByMonth:
          salesDataSpotsByMonth ?? this.salesDataSpotsByMonth,
      salesInfo: salesInfo ?? this.salesInfo,
      isDailyView: isDailyView ?? this.isDailyView,
      premiumResultList: this.premiumResultList,
      averageDailyPremium: this.averageDailyPremium,
      averageMonthlyPremium: this.averageMonthlyPremium,
      overallAveragePremium: this.overallAveragePremium,
      maxAveragePremium: this.maxAveragePremium,
    );
  }
}

// Updated DateValueWithX class with safe parsing
class DateValueWithX {
  final String date;
  final int count;
  final double x;

  DateValueWithX({
    required this.date,
    required this.count,
    required this.x,
  });

  factory DateValueWithX.fromJson(Map<String, dynamic> json) {
    return DateValueWithX(
      date: json['date'] ?? '',
      count: _parseToInt(json['count']),
      x: (json['x'] ?? 0).toDouble(),
    );
  }

  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'count': count,
      'x': x,
    };
  }

  factory DateValueWithX.empty() {
    return DateValueWithX(date: '', count: 0, x: 0.0);
  }

  FlSpot toFlSpot() => FlSpot(x, count.toDouble());
}

// Updated DateTargetWithX class with safe parsing
class DateTargetWithX {
  final String date;
  final int target;
  final double x;

  DateTargetWithX({
    required this.date,
    required this.target,
    required this.x,
  });

  factory DateTargetWithX.fromJson(Map<String, dynamic> json) {
    return DateTargetWithX(
      date: json['date'] ?? '',
      target: _parseToInt(json['target']),
      x: (json['x'] ?? 0).toDouble(),
    );
  }

  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'target': target,
      'x': x,
    };
  }

  factory DateTargetWithX.empty() {
    return DateTargetWithX(date: '', target: 0, x: 0.0);
  }

  FlSpot toFlSpot() => FlSpot(x, target.toDouble());
}

// Updated Employee class with safe parsing
class Employee {
  final String employee;
  final int totalSales;

  Employee({
    required this.employee,
    required this.totalSales,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      employee: json['employee'] ?? '',
      totalSales: _parseToInt(json['total_sales']),
    );
  }

  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'employee': employee,
      'total_sales': totalSales,
    };
  }

  factory Employee.empty() {
    return Employee(employee: '', totalSales: 0);
  }
}

// Updated BranchSales class with safe parsing
class BranchSales {
  final String branchName;
  final int totalSales;

  BranchSales({
    required this.branchName,
    required this.totalSales,
  });

  factory BranchSales.fromJson(Map<String, dynamic> json) {
    return BranchSales(
      branchName: json['branch_name'] ?? '',
      totalSales: _parseToInt(json['total_sales']),
    );
  }

  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'branch_name': branchName,
      'total_sales': totalSales,
    };
  }

  factory BranchSales.empty() {
    return BranchSales(branchName: '', totalSales: 0);
  }
}

// Continue with other updated classes...
class DateRateWithX {
  final String date;
  final double rate;
  final double x;

  DateRateWithX({
    required this.date,
    required this.rate,
    required this.x,
  });

  factory DateRateWithX.fromJson(Map<String, dynamic> json) {
    return DateRateWithX(
      date: json['date'] ?? '',
      rate: (json['rate'] ?? 0).toDouble(),
      x: (json['x'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'rate': rate,
      'x': x,
    };
  }

  factory DateRateWithX.empty() {
    return DateRateWithX(date: '', rate: 0.0, x: 0.0);
  }

  FlSpot toFlSpot() => FlSpot(x, rate);
}

// MonthlyRateData class for 12-month lapse and NTU data
class MonthlyRateData {
  final String date;
  final double x;
  final double rate;
  final int count;
  final int totalSales;
  final int totalInforced;

  MonthlyRateData({
    required this.date,
    required this.x,
    required this.rate,
    required this.count,
    required this.totalSales,
    required this.totalInforced,
  });

  factory MonthlyRateData.fromJson(Map<String, dynamic> json) {
    return MonthlyRateData(
      date: json['date'] ?? '',
      x: (json['x'] ?? 0).toDouble(),
      rate: (json['rate'] ?? 0).toDouble(),
      count: _parseToInt(json['count']),
      totalSales: _parseToInt(json['total_sales']),
      totalInforced: _parseToInt(json['total_inforced']),
    );
  }

  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'x': x,
      'rate': rate,
      'count': count,
      'total_sales': totalSales,
      'total_inforced': totalInforced,
    };
  }

  factory MonthlyRateData.empty() {
    return MonthlyRateData(
      date: '',
      x: 0.0,
      rate: 0.0,
      count: 0,
      totalSales: 0,
      totalInforced: 0,
    );
  }

  FlSpot toFlSpot() => FlSpot(x, rate);
}

class SalesDataSpotsByMonth {
  final double x;
  final double y;
  final int monthlyTarget;
  final int workingDays;
  final String startDate;

  SalesDataSpotsByMonth({
    required this.x,
    required this.y,
    required this.monthlyTarget,
    required this.workingDays,
    required this.startDate,
  });

  factory SalesDataSpotsByMonth.fromJson(Map<String, dynamic> json) {
    return SalesDataSpotsByMonth(
      x: (json['x'] ?? 0).toDouble(),
      y: (json['y'] ?? 0).toDouble(),
      monthlyTarget: _parseToInt(json['monthly_target']),
      workingDays: _parseToInt(json['working_days']),
      startDate: json['start_date'] ?? '',
    );
  }

  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'monthly_target': monthlyTarget,
      'working_days': workingDays,
      'start_date': startDate,
    };
  }

  factory SalesDataSpotsByMonth.empty() {
    return SalesDataSpotsByMonth(
      x: 0.0,
      y: 0.0,
      monthlyTarget: 0,
      workingDays: 0,
      startDate: '',
    );
  }
}

class SalesInfo {
  final String formattedStartDate;
  final String formattedEndDate;
  final String targetAverageSpotsDaily;
  final int actual;
  final int target;
  final double averageDaily;
  final int workingDays;
  final int previousDaySales;
  final int salesRemaining;
  final double actualAverageDailySales;
  final int targetSet;

  SalesInfo({
    required this.formattedStartDate,
    required this.formattedEndDate,
    required this.targetAverageSpotsDaily,
    required this.actual,
    required this.target,
    required this.averageDaily,
    required this.workingDays,
    required this.previousDaySales,
    required this.salesRemaining,
    required this.actualAverageDailySales,
    required this.targetSet,
  });

  factory SalesInfo.fromJson(Map<String, dynamic> json) {
    print("dffgfg $json");
    return SalesInfo(
      formattedStartDate: json['formatted_start_date'] ?? '',
      formattedEndDate: json['formatted_end_date'] ?? '',
      targetAverageSpotsDaily: json['target_average_spots_daily'] ?? '',
      actual: _parseToInt(json['actual']),
      target: _parseToInt(json['target']),
      averageDaily: (json['averageDaily'] ?? 0).toDouble(),
      workingDays: _parseToInt(json['workingDays']),
      previousDaySales: _parseToInt(json['previousDaySales']),
      salesRemaining: _parseToInt(json['salesRemaining']),
      actualAverageDailySales:
          (json['actualAverageDailySales'] ?? 0).toDouble(),
      targetSet: _parseToInt(json['target_set']),
    );
  }

  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'formatted_start_date': formattedStartDate,
      'formatted_end_date': formattedEndDate,
      'target_average_spots_daily': targetAverageSpotsDaily,
      'actual': actual,
      'target': target,
      'averageDaily': averageDaily,
      'workingDays': workingDays,
      'previousDaySales': previousDaySales,
      'salesRemaining': salesRemaining,
      'actualAverageDailySales': actualAverageDailySales,
      'target_set': targetSet,
    };
  }

  factory SalesInfo.empty() {
    return SalesInfo(
      formattedStartDate: '',
      formattedEndDate: '',
      targetAverageSpotsDaily: '',
      actual: 0,
      target: 0,
      averageDaily: 0.0,
      workingDays: 0,
      previousDaySales: 0,
      salesRemaining: 0,
      actualAverageDailySales: 0.0,
      targetSet: 0,
    );
  }

  SalesInfo copyWith({
    String? formattedStartDate,
    String? formattedEndDate,
    String? targetAverageSpotsDaily,
    int? actual,
    int? target,
    double? averageDaily,
    int? workingDays,
    int? previousDaySales,
    int? salesRemaining,
    double? actualAverageDailySales,
    int? targetSet,
  }) {
    return SalesInfo(
      formattedStartDate: formattedStartDate ?? this.formattedStartDate,
      formattedEndDate: formattedEndDate ?? this.formattedEndDate,
      targetAverageSpotsDaily:
          targetAverageSpotsDaily ?? this.targetAverageSpotsDaily,
      actual: actual ?? this.actual,
      target: target ?? this.target,
      averageDaily: averageDaily ?? this.averageDaily,
      workingDays: workingDays ?? this.workingDays,
      previousDaySales: previousDaySales ?? this.previousDaySales,
      salesRemaining: salesRemaining ?? this.salesRemaining,
      actualAverageDailySales:
          actualAverageDailySales ?? this.actualAverageDailySales,
      targetSet: targetSet ?? this.targetSet,
    );
  }

  bool get isEmpty => actual == 0 && target == 0 && targetSet == 0;
  bool get isNotEmpty => !isEmpty;

  String get actualFormatted => actual.toString();
  String get targetFormatted => target.toString();
  String get targetSetFormatted => targetSet.toString();
  String get salesRemainingFormatted => salesRemaining.toString();
  String get workingDaysFormatted => workingDays.toString();
  String get averageDailyFormatted => averageDaily.toStringAsFixed(1);
  String get actualAverageDailySalesFormatted =>
      actualAverageDailySales.toStringAsFixed(1);

  bool get isAheadOfTarget => salesRemaining <= 0;
  bool get isBehindTarget => salesRemaining > 0;
  double get targetCompletionPercentage =>
      targetSet > 0 ? (actual / targetSet) * 100 : 0.0;
  String get targetCompletionPercentageFormatted =>
      "${targetCompletionPercentage.toStringAsFixed(1)}%";
}

class EmployeeRate {
  final int employeeId;
  final String employeeName;
  final int totalSales;
  final double totalCollected;
  final double lapseRate;
  final double ntuRate;
  final double cashCollected;
  final double debitOrderCollected;
  final int eftCollected;
  final double persalCollected;
  final double salaryDeductionCollected;
  final int totalCashClients;
  final int totalDebitOrderClients;
  final int totalSalaryDeductionClients;
  final int totalPersalClients;
  final double percentageCashClients;
  final double percentageDebitOrderClients;
  final double percentageSalaryDeductionClients;
  final double percentagePersalClients;

  EmployeeRate({
    required this.employeeId,
    required this.employeeName,
    required this.totalSales,
    required this.totalCollected,
    required this.lapseRate,
    required this.ntuRate,
    required this.cashCollected,
    required this.debitOrderCollected,
    required this.eftCollected,
    required this.persalCollected,
    required this.salaryDeductionCollected,
    required this.totalCashClients,
    required this.totalDebitOrderClients,
    required this.totalSalaryDeductionClients,
    required this.totalPersalClients,
    required this.percentageCashClients,
    required this.percentageDebitOrderClients,
    required this.percentageSalaryDeductionClients,
    required this.percentagePersalClients,
  });

  factory EmployeeRate.fromJson(Map<String, dynamic> json) {
    print("Employee Rate JSONb: $json");
    return EmployeeRate(
      employeeId: _parseToInt(json['employee_id']),
      employeeName: json['employee_name'] ?? '',
      totalSales: _parseToInt(json['total_sales']),
      totalCollected: (json['total_collected'] ?? 0).toDouble(),
      lapseRate: (json['lapse_rate'] ?? 0).toDouble(),
      ntuRate: (json['ntu_rate'] ?? 0).toDouble(),
      cashCollected: (json['cash_collected'] ?? 0).toDouble(),
      debitOrderCollected: (json['debit_order_collected'] ?? 0).toDouble(),
      eftCollected: _parseToInt(json['eft_collected']),
      persalCollected: (json['persal_collected'] ?? 0).toDouble(),
      salaryDeductionCollected:
          (json['salary_deduction_collected'] ?? 0).toDouble(),
      totalCashClients: _parseToInt(json['total_cash_clients']),
      totalDebitOrderClients: _parseToInt(json['total_debit_order_clients']),
      totalSalaryDeductionClients:
          _parseToInt(json['total_salary_deduction_clients']),
      totalPersalClients: _parseToInt(json['total_persal_clients']),
      percentageCashClients: (json['percentage_cash_clients'] ?? 0).toDouble(),
      percentageDebitOrderClients:
          (json['percentage_debit_order_clients'] ?? 0).toDouble(),
      percentageSalaryDeductionClients:
          (json['percentage_salary_deduction_clients'] ?? 0).toDouble(),
      percentagePersalClients:
          (json['percentage_persal_clients'] ?? 0).toDouble(),
    );
  }

  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'employee_id': employeeId,
      'employee_name': employeeName,
      'total_sales': totalSales,
      'total_collected': totalCollected,
      'lapse_rate': lapseRate,
      'ntu_rate': ntuRate,
      'cash_collected': cashCollected,
      'debit_order_collected': debitOrderCollected,
      'eft_collected': eftCollected,
      'persal_collected': persalCollected,
      'salary_deduction_collected': salaryDeductionCollected,
      'total_cash_clients': totalCashClients,
      'total_debit_order_clients': totalDebitOrderClients,
      'total_salary_deduction_clients': totalSalaryDeductionClients,
      'total_persal_clients': totalPersalClients,
      'percentage_cash_clients': percentageCashClients,
      'percentage_debit_order_clients': percentageDebitOrderClients,
      'percentage_salary_deduction_clients': percentageSalaryDeductionClients,
      'percentage_persal_clients': percentagePersalClients,
    };
  }

  factory EmployeeRate.empty() {
    return EmployeeRate(
      employeeId: 0,
      employeeName: '',
      totalSales: 0,
      totalCollected: 0.0,
      lapseRate: 0.0,
      ntuRate: 0.0,
      cashCollected: 0.0,
      debitOrderCollected: 0.0,
      eftCollected: 0,
      persalCollected: 0.0,
      salaryDeductionCollected: 0.0,
      totalCashClients: 0,
      totalDebitOrderClients: 0,
      totalSalaryDeductionClients: 0,
      totalPersalClients: 0,
      percentageCashClients: 0.0,
      percentageDebitOrderClients: 0.0,
      percentageSalaryDeductionClients: 0.0,
      percentagePersalClients: 0.0,
    );
  }
}

class SaleSummary {
  final String dateOrMonth;
  final String type;
  final int count;
  final double totalAmount;
  final double averagePremium;
  final double percentage;
  final double x;

  SaleSummary({
    required this.dateOrMonth,
    required this.type,
    required this.count,
    required this.totalAmount,
    required this.averagePremium,
    required this.percentage,
    required this.x,
  });

  factory SaleSummary.fromJson(Map<String, dynamic> json) {
    return SaleSummary(
      dateOrMonth: json['date_or_month'] ?? '',
      type: json['type'] ?? '',
      count: _parseToInt(json['count']),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      averagePremium: (json['average_premium'] ?? 0).toDouble(),
      percentage: (json['percentage'] ?? 0).toDouble(),
      x: (json['x'] ?? 0).toDouble(),
    );
  }

  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'date_or_month': dateOrMonth,
      'type': type,
      'count': count,
      'total_amount': totalAmount,
      'average_premium': averagePremium,
      'percentage': percentage,
      'x': x,
    };
  }

  factory SaleSummary.empty() {
    return SaleSummary(
      dateOrMonth: '',
      type: '',
      count: 0,
      totalAmount: 0.0,
      averagePremium: 0.0,
      percentage: 0.0,
      x: 0.0,
    );
  }

  FlSpot toFlSpot() => FlSpot(x, count.toDouble());
}

class FlSpotHelper {
  static FlSpot fromJson(Map<String, dynamic> json) {
    return FlSpot(
      (json['x'] ?? 0).toDouble(),
      (json['y'] ?? 0).toDouble(),
    );
  }

  static FlSpot empty() {
    return FlSpot(0.0, 0.0);
  }

  static List<FlSpot> parseFlSpotList(dynamic list) {
    if (list == null) return [];
    return (list as List).map((item) => FlSpotHelper.fromJson(item)).toList();
  }
}

extension on FlSpot {
  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }

  static FlSpot fromJson(Map<String, dynamic> json) {
    return FlSpot(
      (json['x'] ?? 0).toDouble(),
      (json['y'] ?? 0).toDouble(),
    );
  }

  static FlSpot empty() {
    return FlSpot(0.0, 0.0);
  }
}

// Extension methods for easy data manipulation
extension SalesDataResponseExtensions on SalesDataResponse {
  List<FlSpot> get currentSalesSpots =>
      isDailyView ? salesSpotsDaily : salesSpotsMonthly;
  List<FlSpot> get currentTargetSpots =>
      isDailyView ? targetSpotsDaily : targetSpotsMonthly;

  List<FlSpot> get currentResultListaAsFlSpots =>
      resultLista.map((item) => item.toFlSpot()).toList();
  List<FlSpot> get currentResultListbAsFlSpots =>
      resultListb.map((item) => item.toFlSpot()).toList();
  List<FlSpot> get currentResultListcAsFlSpots =>
      resultListc.map((item) => item.toFlSpot()).toList();
  List<FlSpot> get currentLapseResultAsFlSpots =>
      lapseResultList.map((item) => item.toFlSpot()).toList();
  List<FlSpot> get currentNtuResultAsFlSpots =>
      ntuResultList.map((item) => item.toFlSpot()).toList();
  List<FlSpot> get currentTargetResultAsFlSpots =>
      targetResultLista.map((item) => item.toFlSpot()).toList();

  List<FlSpot> get lapseResult12MonthsAsFlSpots =>
      lapseResultList12Months.map((item) => item.toFlSpot()).toList();
  List<FlSpot> get ntuResult12MonthsAsFlSpots =>
      ntuResultList12Months.map((item) => item.toFlSpot()).toList();

  double get maxYValue {
    double maxSales = 0;
    double maxTarget = 0;

    if (currentSalesSpots.isNotEmpty) {
      maxSales = currentSalesSpots
          .map((spot) => spot.y)
          .reduce((a, b) => a > b ? a : b);
    }

    if (currentTargetSpots.isNotEmpty) {
      maxTarget = currentTargetSpots
          .map((spot) => spot.y)
          .reduce((a, b) => a > b ? a : b);
    }

    return (maxSales > maxTarget ? maxSales : maxTarget) * 1.1;
  }

  (double, double) get xRange {
    if (currentSalesSpots.isEmpty) return (0, 1);

    double minX =
        currentSalesSpots.map((spot) => spot.x).reduce((a, b) => a < b ? a : b);
    double maxX =
        currentSalesSpots.map((spot) => spot.x).reduce((a, b) => a > b ? a : b);

    return (minX, maxX);
  }

  Employee? get topPerformer =>
      topEmployeesa.isNotEmpty ? topEmployeesa.first : null;
  BranchSales? get topBranch =>
      branchSalesa.isNotEmpty ? branchSalesa.first : null;

  double get conversionRate {
    return totalSaleCounts > 0
        ? (totalInforcedCounts / totalSaleCounts) * 100
        : 0.0;
  }

  String get conversionRateFormatted => "${conversionRate.toStringAsFixed(1)}%";

  Map<String, int> get salesByDate {
    Map<String, int> result = {};
    for (var item in resultLista) {
      result[item.date] = item.count;
    }
    return result;
  }

  List<MapEntry<String, SalesDataSpotsByMonth>> get targetChanges {
    return salesDataSpotsByMonth.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
  }

  bool get hasTargetChanges => salesDataSpotsByMonth.isNotEmpty;

  DateValueWithX? getSalesDataForDate(String date) {
    try {
      return resultLista.firstWhere((item) => item.date == date);
    } catch (e) {
      return null;
    }
  }

  DateValueWithX? getSalesDataForX(double x) {
    try {
      return resultLista.firstWhere((item) => item.x == x);
    } catch (e) {
      return null;
    }
  }

  List<String> get allDates => resultLista.map((item) => item.date).toList();
  List<double> get allXValues => resultLista.map((item) => item.x).toList();
}

// Utility class for data formatting
class SalesDataFormatter {
  static String formatLargeNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }

  static String formatLargeNumberDouble(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toStringAsFixed(0);
    }
  }

  static String formatCurrency(double amount, {String symbol = 'R'}) {
    return '$symbol${formatLargeNumberDouble(amount)}';
  }

  static String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(1)}%';
  }

  static String formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

class MtdData {
  double? target;
  double? actual;
  double? salesRemaining;
  double? targetSet;
  double? averageDaily;
  double? actualAverageDailySales;
}

class CustomRangeData {
  double? target;
  double? actual;
  double? salesRemaining;
  double? targetSet;
  double? averageDaily;
}
