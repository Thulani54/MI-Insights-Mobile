import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

// FlSpot Extensions
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
  double distanceTo(FlSpot other) {
    return math
        .sqrt((x - other.x) * (x - other.x) + (y - other.y) * (y - other.y));
  }
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

// FlSpot List Extensions
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

// Employee Model
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
      totalSales: json['total_sales'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee': employee,
      'total_sales': totalSales,
    };
  }

  factory Employee.empty() {
    return Employee(
      employee: '',
      totalSales: 0,
    );
  }

  Employee copyWith({
    String? employee,
    int? totalSales,
  }) {
    return Employee(
      employee: employee ?? this.employee,
      totalSales: totalSales ?? this.totalSales,
    );
  }

  bool get isEmpty => employee.isEmpty && totalSales == 0;
  bool get isNotEmpty => !isEmpty;
}

// Employee Rate Model
class EmployeeRate {
  final int employeeId;
  final String employeeName;
  final int totalSales;
  final int totalInforcedSales;
  final int totalNotInforcedSales;
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
    required this.totalInforcedSales,
    required this.totalNotInforcedSales,
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
    return EmployeeRate(
      employeeId: json['employee_id'] ?? 0,
      employeeName: json['employee_name'] ?? '',
      totalSales: json['total_sales'] ?? 0,
      totalInforcedSales: json['total_inforced_sales'] ?? 0,
      totalNotInforcedSales: json['total_not_inforced_sales'] ?? 0,
      totalCollected: (json['total_collected'] ?? 0).toDouble(),
      lapseRate: (json['lapse_rate'] ?? 0).toDouble(),
      ntuRate: (json['ntu_rate'] ?? 0).toDouble(),
      cashCollected: (json['cash_collected'] ?? 0).toDouble(),
      debitOrderCollected: (json['debit_order_collected'] ?? 0).toDouble(),
      eftCollected: json['eft_collected'] ?? 0,
      persalCollected: (json['persal_collected'] ?? 0).toDouble(),
      salaryDeductionCollected:
          (json['salary_deduction_collected'] ?? 0).toDouble(),
      totalCashClients: json['total_cash_clients'] ?? 0,
      totalDebitOrderClients: json['total_debit_order_clients'] ?? 0,
      totalSalaryDeductionClients: json['total_salary_deduction_clients'] ?? 0,
      totalPersalClients: json['total_persal_clients'] ?? 0,
      percentageCashClients: (json['percentage_cash_clients'] ?? 0).toDouble(),
      percentageDebitOrderClients:
          (json['percentage_debit_order_clients'] ?? 0).toDouble(),
      percentageSalaryDeductionClients:
          (json['percentage_salary_deduction_clients'] ?? 0).toDouble(),
      percentagePersalClients:
          (json['percentage_persal_clients'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee_id': employeeId,
      'employee_name': employeeName,
      'total_sales': totalSales,
      'total_inforced_sales': totalInforcedSales,
      'total_not_inforced_sales': totalNotInforcedSales,
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
      totalInforcedSales: 0,
      totalNotInforcedSales: 0,
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

  bool get isEmpty =>
      employeeId == 0 && employeeName.isEmpty && totalSales == 0;
  bool get isNotEmpty => !isEmpty;

  // Helper getters for formatted values
  String get totalCollectedFormatted =>
      SalesDataFormatter.formatCurrency(totalCollected);
  String get lapseRateFormatted =>
      SalesDataFormatter.formatPercentage(lapseRate);
  String get ntuRateFormatted => SalesDataFormatter.formatPercentage(ntuRate);
  String get cashCollectedFormatted =>
      SalesDataFormatter.formatCurrency(cashCollected);
  String get debitOrderCollectedFormatted =>
      SalesDataFormatter.formatCurrency(debitOrderCollected);
  String get persalCollectedFormatted =>
      SalesDataFormatter.formatCurrency(persalCollected);
  String get salaryDeductionCollectedFormatted =>
      SalesDataFormatter.formatCurrency(salaryDeductionCollected);
}

// Branch Sales Model
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
      totalSales: json['total_sales'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch_name': branchName,
      'total_sales': totalSales,
    };
  }

  factory BranchSales.empty() {
    return BranchSales(
      branchName: '',
      totalSales: 0,
    );
  }

  BranchSales copyWith({
    String? branchName,
    int? totalSales,
  }) {
    return BranchSales(
      branchName: branchName ?? this.branchName,
      totalSales: totalSales ?? this.totalSales,
    );
  }

  bool get isEmpty => branchName.isEmpty && totalSales == 0;
  bool get isNotEmpty => !isEmpty;

  String get totalSalesFormatted =>
      SalesDataFormatter.formatLargeNumber(totalSales);
}

// Sale Summary Model
class SaleSummary {
  final String dateOrMonth;
  final String type;
  final int count;
  final double totalAmount;
  final double averagePremium;
  final double percentage;
  final int? x; // For chart positioning

  SaleSummary({
    required this.dateOrMonth,
    required this.type,
    required this.count,
    required this.totalAmount,
    required this.averagePremium,
    required this.percentage,
    this.x,
  });

  factory SaleSummary.fromJson(Map<String, dynamic> json) {
    return SaleSummary(
      dateOrMonth: json['date_or_month'] ?? '',
      type: json['type'] ?? '',
      count: json['count'] ?? 0,
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      averagePremium: (json['average_premium'] ?? 0).toDouble(),
      percentage: (json['percentage'] ?? 0).toDouble(),
      x: json['x'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date_or_month': dateOrMonth,
      'type': type,
      'count': count,
      'total_amount': totalAmount,
      'average_premium': averagePremium,
      'percentage': percentage,
      if (x != null) 'x': x,
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
    );
  }

  bool get isEmpty => dateOrMonth.isEmpty && type.isEmpty && count == 0;
  bool get isNotEmpty => !isEmpty;

  // Helper getters for formatted values
  String get totalAmountFormatted =>
      SalesDataFormatter.formatCurrency(totalAmount);
  String get averagePremiumFormatted =>
      SalesDataFormatter.formatCurrency(averagePremium);
  String get percentageFormatted =>
      SalesDataFormatter.formatPercentage(percentage);
  String get countFormatted => SalesDataFormatter.formatLargeNumber(count);
}

// Sales Data Spots By Month Model
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
      monthlyTarget: json['monthly_target'] ?? 0,
      workingDays: json['working_days'] ?? 0,
      startDate: json['start_date'] ?? '',
    );
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

  SalesDataSpotsByMonth copyWith({
    double? x,
    double? y,
    int? monthlyTarget,
    int? workingDays,
    String? startDate,
  }) {
    return SalesDataSpotsByMonth(
      x: x ?? this.x,
      y: y ?? this.y,
      monthlyTarget: monthlyTarget ?? this.monthlyTarget,
      workingDays: workingDays ?? this.workingDays,
      startDate: startDate ?? this.startDate,
    );
  }

  bool get isEmpty => x == 0.0 && y == 0.0 && monthlyTarget == 0;
  bool get isNotEmpty => !isEmpty;

  // Convert to FlSpot for chart use
  FlSpot toFlSpot() => FlSpot(x, y);

  // Helper getters
  String get monthlyTargetFormatted =>
      SalesDataFormatter.formatLargeNumber(monthlyTarget);
  String get dailyTargetFormatted => y.toStringAsFixed(1);
  String get startDateFormatted => SalesDataFormatter.formatDate(startDate);
}

// Sales Info Model
class SalesInfo {
  final int actual;
  final int target;
  final double averageDaily;
  final int workingDays;
  final int previousDaySales;
  final int salesRemaining;
  final double actualAverageDailySales;
  final int targetSet;

  SalesInfo({
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
    return SalesInfo(
      actual: json['actual'] ?? 0,
      target: json['target'] ?? 0,
      averageDaily: (json['averageDaily'] ?? 0).toDouble(),
      workingDays: json['workingDays'] ?? 0,
      previousDaySales: json['previousDaySales'] ?? 0,
      salesRemaining: json['salesRemaining'] ?? 0,
      actualAverageDailySales:
          (json['actualAverageDailySales'] ?? 0).toDouble(),
      targetSet: json['target_set'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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

  // Performance indicators
  bool get isAheadOfTarget => salesRemaining <= 0;
  bool get isBehindTarget => salesRemaining > 0;
  double get targetCompletionPercentage =>
      targetSet > 0 ? (actual / targetSet) * 100 : 0.0;

  // Helper methods for formatted values
  String get actualFormatted => SalesDataFormatter.formatLargeNumber(actual);
  String get targetFormatted =>
      SalesDataFormatter.formatLargeNumber(target.toInt());
  String get targetSetFormatted =>
      SalesDataFormatter.formatLargeNumber(targetSet);
  String get salesRemainingFormatted =>
      SalesDataFormatter.formatLargeNumber(salesRemaining);
  String get workingDaysFormatted => workingDays.toString();
  String get averageDailyFormatted => averageDaily.toStringAsFixed(1);
  String get actualAverageDailySalesFormatted =>
      actualAverageDailySales.toStringAsFixed(1);
  String get targetCompletionPercentageFormatted =>
      "${targetCompletionPercentage.toStringAsFixed(1)}%";
}

// Lapse/NTU Result Model
class LapseNtuResult {
  final int x;
  final double rate;
  final int count;
  final int? totalSales;
  final int? totalInforced;
  final String? date;

  LapseNtuResult({
    required this.x,
    required this.rate,
    required this.count,
    this.totalSales,
    this.totalInforced,
    this.date,
  });

  factory LapseNtuResult.fromJson(Map<String, dynamic> json) {
    return LapseNtuResult(
      x: json['x'] ?? 0,
      rate: (json['rate'] ?? 0).toDouble(),
      count: json['count'] ?? 0,
      totalSales: json['total_sales'],
      totalInforced: json['total_inforced'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'rate': rate,
      'count': count,
      if (totalSales != null) 'total_sales': totalSales,
      if (totalInforced != null) 'total_inforced': totalInforced,
      if (date != null) 'date': date,
    };
  }

  factory LapseNtuResult.empty() {
    return LapseNtuResult(
      x: 0,
      rate: 0.0,
      count: 0,
    );
  }

  bool get isEmpty => x == 0 && rate == 0.0 && count == 0;
  bool get isNotEmpty => !isEmpty;

  // Convert to FlSpot for chart use
  FlSpot toFlSpotRate() => FlSpot(x.toDouble(), rate);
  FlSpot toFlSpotCount() => FlSpot(x.toDouble(), count.toDouble());

  // Helper getters
  String get rateFormatted => SalesDataFormatter.formatPercentage(rate);
  String get countFormatted => SalesDataFormatter.formatLargeNumber(count);
  String get totalSalesFormatted => totalSales != null
      ? SalesDataFormatter.formatLargeNumber(totalSales!)
      : 'N/A';
  String get totalInforcedFormatted => totalInforced != null
      ? SalesDataFormatter.formatLargeNumber(totalInforced!)
      : 'N/A';
}

// Main Sales Data Response Model
class SalesDataResponse {
  final double percentageWithExtPolicy;
  final int totalSaleCounts;
  final int totalInforcedCounts;
  final int totalNotInforcedCounts;
  final List<Map<String, dynamic>> resultLista;
  final List<Map<String, dynamic>> resultListb;
  final List<Map<String, dynamic>> resultListc;
  final List<LapseNtuResult> lapseResultList;
  final List<LapseNtuResult> ntuResultList;
  final List<LapseNtuResult> lapseResultList12Months;
  final List<LapseNtuResult> ntuResultList12Months;
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
  final List<Map<String, dynamic>> targetResultLista;
  final List<FlSpot> targetAverageSpotsDaily;
  final int monthlyTargetValue;
  final List<FlSpot> salesSpotsDaily;
  final List<FlSpot> salesSpotsMonthly;
  final List<FlSpot> targetSpotsDaily;
  final List<FlSpot> targetSpotsMonthly;
  final Map<String, SalesDataSpotsByMonth> salesDataSpotsByMonth;
  final SalesInfo salesInfo;
  final bool isDailyView;

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
    required this.targetAverageSpotsDaily,
    required this.monthlyTargetValue,
    required this.salesSpotsDaily,
    required this.salesSpotsMonthly,
    required this.targetSpotsDaily,
    required this.targetSpotsMonthly,
    required this.salesDataSpotsByMonth,
    required this.salesInfo,
    required this.isDailyView,
  });

  factory SalesDataResponse.fromJson(Map<String, dynamic> json) {
    return SalesDataResponse(
      percentageWithExtPolicy:
          (json['percentage_with_ext_policy'] ?? 0).toDouble(),
      totalSaleCounts: json['total_sale_counts'] ?? 0,
      totalInforcedCounts: json['total_inforced_counts'] ?? 0,
      totalNotInforcedCounts: json['total_not_inforced_counts'] ?? 0,
      resultLista: _parseResultList(json['result_lista']),
      resultListb: _parseResultList(json['result_listb']),
      resultListc: _parseResultList(json['result_listc']),
      lapseResultList: _parseLapseNtuResultList(json['lapse_result_list']),
      ntuResultList: _parseLapseNtuResultList(json['ntu_result_list']),
      lapseResultList12Months:
          _parseLapseNtuResultList(json['lapse_result_list_12_months']),
      ntuResultList12Months:
          _parseLapseNtuResultList(json['ntu_result_list_12_months']),
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
      branchMaxYa: json['branch_maxYa'] ?? 0,
      branchMaxYb: json['branch_maxYb'] ?? 0,
      branchMaxYc: json['branch_maxYc'] ?? 0,
      dailyOrMonthlya: json['daily_or_monthlya'] ?? 0,
      dailyOrMonthlyb: json['daily_or_monthlyb'] ?? 0,
      dailyOrMonthlyc: json['daily_or_monthlyc'] ?? 0,
      saleSummary: _parseSaleSummaryList(json['sale_summary']),
      productsGroup: json['products_group'] ?? {},
      targetResultLista: _parseResultList(json['target_result_lista']),
      targetAverageSpotsDaily:
          FlSpotHelper.parseFlSpotList(json['target_average_spots_daily']),
      monthlyTargetValue: json['monthly_target_value'] ?? 0,
      salesSpotsDaily: FlSpotHelper.parseFlSpotList(json['sales_spots_daily']),
      salesSpotsMonthly:
          FlSpotHelper.parseFlSpotList(json['sales_spots_monthly']),
      targetSpotsDaily:
          FlSpotHelper.parseFlSpotList(json['target_spots_daily']),
      targetSpotsMonthly:
          FlSpotHelper.parseFlSpotList(json['target_spots_monthly']),
      salesDataSpotsByMonth:
          _parseSalesDataSpotsByMonth(json['sales_data_spots_by_month']),
      salesInfo: SalesInfo.fromJson(json['sales_info'] ?? {}),
      isDailyView: json['is_daily_view'] ?? true,
    );
  }

  static List<Map<String, dynamic>> _parseResultList(dynamic list) {
    if (list == null) return [];
    return (list as List).map((item) {
      if (item is Map<String, dynamic>) {
        return Map<String, dynamic>.from(item);
      }
      return <String, dynamic>{};
    }).toList();
  }

  static List<LapseNtuResult> _parseLapseNtuResultList(dynamic list) {
    if (list == null) return [];
    return (list as List).map((item) => LapseNtuResult.fromJson(item)).toList();
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

  static Map<String, SalesDataSpotsByMonth> _parseSalesDataSpotsByMonth(
      dynamic map) {
    if (map == null) return {};
    Map<String, SalesDataSpotsByMonth> result = {};
    (map as Map<String, dynamic>).forEach((key, value) {
      result[key] = SalesDataSpotsByMonth.fromJson(value);
    });
    return result;
  }

  Map<String, dynamic> toJson() {
    return {
      'percentage_with_ext_policy': percentageWithExtPolicy,
      'total_sale_counts': totalSaleCounts,
      'total_inforced_counts': totalInforcedCounts,
      'total_not_inforced_counts': totalNotInforcedCounts,
      'result_lista': resultLista,
      'result_listb': resultListb,
      'result_listc': resultListc,
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
      'target_result_lista': targetResultLista,
      'target_average_spots_daily': targetAverageSpotsDaily.toJson(),
      'monthly_target_value': monthlyTargetValue,
      'sales_spots_daily': salesSpotsDaily.toJson(),
      'sales_spots_monthly': salesSpotsMonthly.toJson(),
      'target_spots_daily': targetSpotsDaily.toJson(),
      'target_spots_monthly': targetSpotsMonthly.toJson(),
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
      targetAverageSpotsDaily: [],
      monthlyTargetValue: 0,
      salesSpotsDaily: [],
      salesSpotsMonthly: [],
      targetSpotsDaily: [],
      targetSpotsMonthly: [],
      salesDataSpotsByMonth: {},
      salesInfo: SalesInfo.empty(),
      isDailyView: true,
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
    List<Map<String, dynamic>>? resultLista,
    List<Map<String, dynamic>>? resultListb,
    List<Map<String, dynamic>>? resultListc,
    List<LapseNtuResult>? lapseResultList,
    List<LapseNtuResult>? ntuResultList,
    List<LapseNtuResult>? lapseResultList12Months,
    List<LapseNtuResult>? ntuResultList12Months,
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
    List<Map<String, dynamic>>? targetResultLista,
    List<FlSpot>? targetAverageSpotsDaily,
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
      targetAverageSpotsDaily:
          targetAverageSpotsDaily ?? this.targetAverageSpotsDaily,
      monthlyTargetValue: monthlyTargetValue ?? this.monthlyTargetValue,
      salesSpotsDaily: salesSpotsDaily ?? this.salesSpotsDaily,
      salesSpotsMonthly: salesSpotsMonthly ?? this.salesSpotsMonthly,
      targetSpotsDaily: targetSpotsDaily ?? this.targetSpotsDaily,
      targetSpotsMonthly: targetSpotsMonthly ?? this.targetSpotsMonthly,
      salesDataSpotsByMonth:
          salesDataSpotsByMonth ?? this.salesDataSpotsByMonth,
      salesInfo: salesInfo ?? this.salesInfo,
      isDailyView: isDailyView ?? this.isDailyView,
    );
  }
}

// Extension methods for advanced data manipulation
extension SalesDataResponseExtensions on SalesDataResponse {
  // Get current spots based on view type
  List<FlSpot> get currentSalesSpots =>
      isDailyView ? salesSpotsDaily : salesSpotsMonthly;
  List<FlSpot> get currentTargetSpots =>
      isDailyView ? targetSpotsDaily : targetSpotsMonthly;

  // Get max Y value for chart scaling
  double get maxYValue {
    double maxSales = 0;
    double maxTarget = 0;

    if (currentSalesSpots.isNotEmpty) {
      maxSales = currentSalesSpots.maxY;
    }

    if (currentTargetSpots.isNotEmpty) {
      maxTarget = currentTargetSpots.maxY;
    }

    return (maxSales > maxTarget ? maxSales : maxTarget) *
        1.1; // Add 10% padding
  }

  // Get X range for charts
  (double, double) get xRange {
    if (currentSalesSpots.isEmpty) return (0, 1);
    return currentSalesSpots.xRange;
  }

  // Get top performer
  Employee? get topPerformer =>
      topEmployeesa.isNotEmpty ? topEmployeesa.first : null;

  // Get top branch
  BranchSales? get topBranch =>
      branchSalesa.isNotEmpty ? branchSalesa.first : null;

  // Calculate conversion rate
  double get conversionRate {
    return totalSaleCounts > 0
        ? (totalInforcedCounts / totalSaleCounts) * 100
        : 0.0;
  }

  String get conversionRateFormatted => "${conversionRate.toStringAsFixed(1)}%";

  // Get sales by date (for daily view)
  Map<String, int> get salesByDate {
    Map<String, int> result = {};
    for (var item in resultLista) {
      if (item['date'] != null && item['count'] != null) {
        result[item['date']] = item['count'];
      }
    }
    return result;
  }

  // Get target changes in current period
  List<MapEntry<String, SalesDataSpotsByMonth>> get targetChanges {
    return salesDataSpotsByMonth.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
  }

  // Check if there are target changes
  bool get hasTargetChanges => salesDataSpotsByMonth.isNotEmpty;

  // Get sales value at specific point
  double? getSalesValueAtPoint(double x) {
    for (FlSpot spot in currentSalesSpots) {
      if ((spot.x - x).abs() < 0.5) {
        return spot.y;
      }
    }
    return null;
  }

  // Get target value at specific point
  double? getTargetValueAtPoint(double x) {
    for (FlSpot spot in currentTargetSpots) {
      if ((spot.x - x).abs() < 0.5) {
        return spot.y;
      }
    }
    return null;
  }

  // Get lapse rate FlSpots for charting
  List<FlSpot> get lapseRateSpots =>
      lapseResultList.map((e) => e.toFlSpotRate()).toList();

  // Get NTU rate FlSpots for charting
  List<FlSpot> get ntuRateSpots =>
      ntuResultList.map((e) => e.toFlSpotRate()).toList();

  // Get 12-month lapse rate FlSpots
  List<FlSpot> get lapseRateSpots12Months =>
      lapseResultList12Months.map((e) => e.toFlSpotRate()).toList();

  // Get 12-month NTU rate FlSpots
  List<FlSpot> get ntuRateSpots12Months =>
      ntuResultList12Months.map((e) => e.toFlSpotRate()).toList();

  // Calculate average daily target from target spots
  double get averageDailyTarget {
    if (targetSpotsDaily.isEmpty) return 0.0;
    double total = targetSpotsDaily
        .where((spot) => spot.y > 0)
        .fold(0.0, (sum, spot) => sum + spot.y);
    int count = targetSpotsDaily.where((spot) => spot.y > 0).length;
    return count > 0 ? total / count : 0.0;
  }

  // Get performance indicators
  Map<String, dynamic> get performanceIndicators {
    return {
      'conversion_rate': conversionRate,
      'target_completion': salesInfo.targetCompletionPercentage,
      'is_ahead_of_target': salesInfo.isAheadOfTarget,
      'average_daily_actual': salesInfo.actualAverageDailySales,
      'average_daily_target': averageDailyTarget,
      'sales_remaining': salesInfo.salesRemaining,
      'working_days_remaining': salesInfo.workingDays,
    };
  }
}

// Chart Helper Class for creating FlChart data
class SalesChartHelper {
  static LineChartBarData createSalesLineData(
    List<FlSpot> spots, {
    Color? color,
    double barWidth = 3.0,
    bool isCurved = true,
    bool showDots = true,
  }) {
    return LineChartBarData(
      spots: spots,
      isCurved: isCurved,
      color: color ?? const Color(0xFF2196F3),
      barWidth: barWidth,
      dotData: FlDotData(show: showDots),
      belowBarData: BarAreaData(show: false),
    );
  }

  static LineChartBarData createTargetLineData(
    List<FlSpot> spots, {
    Color? color,
    double barWidth = 2.0,
    List<int>? dashArray,
  }) {
    return LineChartBarData(
      spots: spots,
      isCurved: false,
      color: color ?? const Color(0xFFFF5722),
      barWidth: barWidth,
      dotData: FlDotData(show: false),
      dashArray: dashArray ?? [5, 5],
      belowBarData: BarAreaData(show: false),
    );
  }

  static LineChartBarData createLapseNtuLineData(
    List<FlSpot> spots, {
    Color? color,
    double barWidth = 2.0,
    bool showDots = false,
  }) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color ?? const Color(0xFFF44336),
      barWidth: barWidth,
      dotData: FlDotData(show: showDots),
      belowBarData: BarAreaData(show: false),
    );
  }
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

  static String formatShortDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      List<String> months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${date.day} ${months[date.month - 1]}';
    } catch (e) {
      return dateString;
    }
  }
}

// Sales Data Spots Management Class
class SalesDataSpots {
  List<FlSpot> salesSpotsDaily = [];
  List<FlSpot> salesSpotsMonthly = [];
  List<FlSpot> targetSpotsDaily = [];
  List<FlSpot> targetSpotsMonthly = [];
  Map<String, SalesDataSpotsByMonth> salesDataSpotsByMonth = {};
  bool isDailyView = true;

  SalesDataSpots.fromSalesDataResponse(SalesDataResponse response) {
    salesSpotsDaily = response.salesSpotsDaily;
    salesSpotsMonthly = response.salesSpotsMonthly;
    targetSpotsDaily = response.targetSpotsDaily;
    targetSpotsMonthly = response.targetSpotsMonthly;
    salesDataSpotsByMonth = response.salesDataSpotsByMonth;
    isDailyView = response.isDailyView;
  }

  SalesDataSpots.fromJson(Map<String, dynamic> json) {
    isDailyView = json['is_daily_view'] ?? true;
    salesSpotsDaily = FlSpotHelper.parseFlSpotList(json['sales_spots_daily']);
    salesSpotsMonthly =
        FlSpotHelper.parseFlSpotList(json['sales_spots_monthly']);
    targetSpotsDaily = FlSpotHelper.parseFlSpotList(json['target_spots_daily']);
    targetSpotsMonthly =
        FlSpotHelper.parseFlSpotList(json['target_spots_monthly']);

    if (json['sales_data_spots_by_month'] != null) {
      salesDataSpotsByMonth = {};
      (json['sales_data_spots_by_month'] as Map<String, dynamic>)
          .forEach((key, value) {
        salesDataSpotsByMonth[key] = SalesDataSpotsByMonth.fromJson(value);
      });
    }
  }

  // Get current sales spots based on view type
  List<FlSpot> getCurrentSalesSpots() {
    return isDailyView ? salesSpotsDaily : salesSpotsMonthly;
  }

  // Get current target spots based on view type
  List<FlSpot> getCurrentTargetSpots() {
    return isDailyView ? targetSpotsDaily : targetSpotsMonthly;
  }

  // Get the maximum Y value for chart scaling
  double getMaxYValue() {
    List<FlSpot> currentSalesSpots = getCurrentSalesSpots();
    List<FlSpot> currentTargetSpots = getCurrentTargetSpots();

    double maxSales =
        currentSalesSpots.isNotEmpty ? currentSalesSpots.maxY : 0.0;
    double maxTarget =
        currentTargetSpots.isNotEmpty ? currentTargetSpots.maxY : 0.0;

    return (maxSales > maxTarget ? maxSales : maxTarget) *
        1.1; // Add 10% padding
  }

  // Get the minimum and maximum X values for chart range
  (double, double) getXRange() {
    List<FlSpot> currentSpots = getCurrentSalesSpots();
    if (currentSpots.isEmpty) return (0, 1);
    return currentSpots.xRange;
  }

  // Get target changes within a date range
  List<Map<String, dynamic>> getTargetChangesInRange(
      DateTime startDate, DateTime endDate) {
    List<Map<String, dynamic>> changes = [];

    salesDataSpotsByMonth.forEach((monthKey, data) {
      try {
        DateTime monthDate = DateTime.parse('$monthKey-01');
        if (monthDate.isAfter(startDate.subtract(Duration(days: 1))) &&
            monthDate.isBefore(endDate.add(Duration(days: 1)))) {
          changes.add({
            'month': monthKey,
            'data': data,
          });
        }
      } catch (e) {
        print('Error parsing month key: $monthKey');
      }
    });

    changes.sort((a, b) => a['month'].compareTo(b['month']));
    return changes;
  }

  // Check if there are target changes within the current view
  bool hasTargetChanges(DateTime startDate, DateTime endDate) {
    return getTargetChangesInRange(startDate, endDate).isNotEmpty;
  }

  // Get target value for a specific point (useful for tooltips)
  double? getTargetValueAtPoint(double x) {
    List<FlSpot> currentTargetSpots = getCurrentTargetSpots();

    for (FlSpot spot in currentTargetSpots) {
      if ((spot.x - x).abs() < 0.5) {
        return spot.y;
      }
    }

    return null;
  }

  // Get sales value for a specific point (useful for tooltips)
  double? getSalesValueAtPoint(double x) {
    List<FlSpot> currentSalesSpots = getCurrentSalesSpots();

    for (FlSpot spot in currentSalesSpots) {
      if ((spot.x - x).abs() < 0.5) {
        return spot.y;
      }
    }

    return null;
  }
}
