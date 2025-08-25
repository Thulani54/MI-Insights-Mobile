import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'package:intl/intl.dart';

import '../constants/Constants.dart';

UniqueKey keyrr1 = UniqueKey();

class SalesData1 {
  final DateTime dateTime;
  final double amount;

  SalesData1(this.dateTime, this.amount);

  @override
  String toString() {
    return 'SalesData1{dateTime: $dateTime, amount: $amount}';
  }
}

class PayoverBarChart2 extends StatefulWidget {
  final String dataUrl;
  final String selectedMonth;

  const PayoverBarChart2(
      {Key? key, required this.dataUrl, required this.selectedMonth})
      : super(key: key);

  @override
  _PayoverBarChart2State createState() => _PayoverBarChart2State();
}

class _PayoverBarChart2State extends State<PayoverBarChart2> {
  List<SalesData1>? _salesData;
  DateTime? _selectedDate;
  String? _selectedMonth; // Add this to track the current selection
  bool _isLoading = false; // Add loading state
  bool _hasError = false; // Add error state
  Map<DateTime, double>? _allData; // Store all data for filtering
  double totalCollectionSum = 0.0; // Total collection sum
  final List<String> _last12Months = List.generate(12, (index) {
    DateTime date = DateTime.now().subtract(Duration(days: index * 30));
    return DateFormat("MMM yyyy").format(date);
  }).reversed.toList(); // Generate last 12 months
  ValueNotifier<int> paymentsValue = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _selectedMonth = widget.selectedMonth; // Initialize with widget value
    _loadInitialData();
  }

  void _loadInitialData() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    fetchPaymentsData(widget.dataUrl).then((data) {
      setState(() {
        _salesData = data;
        _isLoading = false;
        _hasError = false;
      });
    }).catchError((error) {
      print("Error fetching sales data: $error");
      setState(() {
        _isLoading = false;
        _hasError = true;
        // Set empty data and zero total when error occurs
        _salesData = [];
        totalCollectionSum = 0.0;
      });
    });
  }

  // Add method to refresh data when dropdown changes
  void _refreshDataForSelectedMonth(String selectedMonth) {
    if (_allData != null && !_hasError) {
      // Use cached data if available and no error
      setState(() {
        _isLoading = true;
      });

      List<SalesData1> newData =
          createWindowDataForMonth(_allData!, selectedMonth);

      setState(() {
        _salesData = newData;
        _isLoading = false;
      });
    } else {
      // Re-fetch data if not cached or had error
      _loadInitialData();
    }
  }

  DateTime shiftMonths(DateTime dt, int months) {
    return DateTime(dt.year, dt.month + months, 1);
  }

  Future<List<SalesData1>> fetchPaymentsData(String url) async {
    final response = await http.get(Uri.parse(url));

    // Handle non-200 status codes
    if (response.statusCode != 200) {
      print("Failed to load data, status code: ${response.statusCode}");
      // Set total collection sum to 0 for error cases
      totalCollectionSum = 0.0;
      keyrr1 = UniqueKey();
      if (mounted) setState(() {});

      throw Exception(
          "Failed to load data, status code: ${response.statusCode}");
    }

    // Check if response is JSON (from our new endpoint) or CSV (from old endpoint)
    final responseBody = response.body;

    try {
      // Try to parse as JSON first (new endpoint)
      final jsonData = json.decode(responseBody);
      if (jsonData['success'] == true && jsonData['chart_data'] != null) {
        if (jsonData["summary_stats"] != null) {
          totalCollectionSum = jsonData["summary_stats"]["total_collected"];
          keyrr1 = UniqueKey();
          if (mounted) setState(() {});
          paymentsValue.value++;
        }

        return processJsonData(jsonData['chart_data']);
      }
    } catch (e) {
      // If JSON parsing fails, fall back to CSV parsing
      print("Not JSON data, trying CSV parsing...");
    }

    // Fall back to CSV parsing (original logic)
    return processCsvData(responseBody);
  }

  List<SalesData1> processJsonData(List<dynamic> chartData) {
    const Map<String, int> monthOrder = {
      "January": 1,
      "February": 2,
      "March": 3,
      "April": 4,
      "May": 5,
      "June": 6,
      "July": 7,
      "August": 8,
      "September": 9,
      "October": 10,
      "November": 11,
      "December": 12,
    };

    Map<DateTime, double> dateSums = {};

    for (var item in chartData) {
      final monthStr = item['month'].toString();
      final year = item['year'] as int;
      final amount = (item['amount'] as num).toDouble();

      int? monthNum = monthOrder[monthStr];
      if (monthNum != null) {
        final dt = DateTime(year, monthNum, 1);
        dateSums[dt] = (dateSums[dt] ?? 0) + amount;
      }
    }

    // Cache all data for future use
    _allData = dateSums;

    return createWindowData(dateSums);
  }

  List<SalesData1> processCsvData(String csvString) {
    final lines = csvString
        .split(RegExp(r'\r?\n'))
        .where((line) => line.trim().isNotEmpty)
        .toList();
    if (lines.isEmpty) return [];

    final csvData = lines.map((line) => line.split(';')).toList();
    final header = csvData[0];

    int monthIndex = header.indexOf("monthFor");
    int yearIndex = header.indexOf("yearFor");
    int amountIndex = header.indexOf("RecAmount");
    if (monthIndex == -1 || yearIndex == -1 || amountIndex == -1) {
      throw Exception(
          "CSV missing required columns: monthFor, yearFor, RecAmount");
    }

    const Map<String, int> monthOrder = {
      "January": 1,
      "February": 2,
      "March": 3,
      "April": 4,
      "May": 5,
      "June": 6,
      "July": 7,
      "August": 8,
      "September": 9,
      "October": 10,
      "November": 11,
      "December": 12,
    };

    Map<DateTime, double> dateSums = {};
    for (int i = 1; i < csvData.length; i++) {
      final row = csvData[i];
      if (row.length <= amountIndex) continue;

      final monthStr = row[monthIndex].trim();
      final yearStr = row[yearIndex].trim();
      final amountStr = row[amountIndex].replaceAll(",", ".").trim();

      double? amount = double.tryParse(amountStr);
      int? monthNum = monthOrder[monthStr];
      int? year = int.tryParse(yearStr);

      if (amount == null || monthNum == null || year == null) continue;

      final dt = DateTime(year, monthNum, 1);
      dateSums[dt] = (dateSums[dt] ?? 0) + amount;
    }

    // Cache all data for future use
    _allData = dateSums;

    return createWindowData(dateSums);
  }

  List<SalesData1> createWindowData(Map<DateTime, double> dateSums) {
    if (dateSums.isEmpty) return [];

    // Use the current selected month
    DateTime selectedDate =
        DateFormat("MMM yyyy").parse(_selectedMonth ?? widget.selectedMonth);
    DateTime startDate = DateTime(selectedDate.year, selectedDate.month, 1);
    _selectedDate = startDate;

    return _createWindowForDate(dateSums, startDate);
  }

  // New method to create window data for a specific month
  List<SalesData1> createWindowDataForMonth(
      Map<DateTime, double> dateSums, String monthStr) {
    if (dateSums.isEmpty) return [];

    DateTime selectedDate = DateFormat("MMM yyyy").parse(monthStr);
    DateTime startDate = DateTime(selectedDate.year, selectedDate.month, 1);
    _selectedDate = startDate;

    return _createWindowForDate(dateSums, startDate);
  }

  // Helper method to create the 7-month window
  List<SalesData1> _createWindowForDate(
      Map<DateTime, double> dateSums, DateTime centerDate) {
    // Create 7-month window: 3 before, selected, 3 after
    DateTime start = shiftMonths(centerDate, -3);
    DateTime end = shiftMonths(centerDate, 3);

    // Generate all months in the 7-month range
    List<SalesData1> windowData = [];
    DateTime current = start;
    while (!current.isAfter(end)) {
      final amount = dateSums[current] ?? 0.0;
      windowData.add(SalesData1(current, amount));
      current = shiftMonths(current, 1);
    }

    return windowData;
  }

  // Format large numbers function
  String formatLargeNumber4(String amountStr) {
    double amount = double.tryParse(amountStr) ?? 0;
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }

  // Method to calculate total collection sum for selected period
  void _updateTotalCollectionSum() {
    if (_salesData == null || _salesData!.isEmpty) {
      // Set to 0 when no data or error
      if (!_hasError) {
        setState(() {
          totalCollectionSum = 0.0;
        });
      }
      return;
    }

    // Calculate sum for the 7-month window
    double sum =
        _salesData!.fold(0.0, (prev, element) => prev + element.amount);

    setState(() {
      totalCollectionSum = sum;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Always show the dropdown and total amount section
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: 200,
        width: 400,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Dropdown - always visible and functional
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                          color: Constants.ctaColorLight,
                          borderRadius: BorderRadius.circular(360)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24.0, top: 0),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedMonth,
                            onChanged: (String? newValue) {
                              if (newValue != null &&
                                  newValue != _selectedMonth) {
                                setState(() {
                                  _selectedMonth = newValue;
                                  print(
                                      "Selected month changed to: $_selectedMonth");
                                });

                                // Refresh data for the new selected month
                                _refreshDataForSelectedMonth(newValue);

                                // Update key for refresh
                                keyrr1 = UniqueKey();
                              }
                            },
                            selectedItemBuilder: (BuildContext ctxt) {
                              return _last12Months.map<Widget>((item) {
                                return DropdownMenuItem(
                                    child: Center(
                                      child: Text("${item}",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    value: item);
                              }).toList();
                            },
                            items: _last12Months.map<DropdownMenuItem<String>>(
                                (String monthName) {
                              return DropdownMenuItem<String>(
                                value: monthName,
                                child: Center(
                                  child: Text(
                                    monthName,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      color: Colors
                                          .black, // Dropdown items text color
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            underline:
                                Container(), // Removes underline if not needed
                            dropdownColor:
                                Colors.white, // Dropdown background color
                            style: TextStyle(
                              color: Colors
                                  .white, // This sets the selected item text color
                            ),
                            iconEnabledColor:
                                Colors.white, // Changes the dropdown icon color
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  // Total Collection Sum Display - always visible
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 8),
                          child: Container(
                            height: 110,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Constants.ftaColorLight,
                              ),
                              child: ClipPath(
                                clipper: ShapeBorderClipper(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16))),
                                child: Column(
                                  children: [
                                    Spacer(),
                                    Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Total Collected",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                      ),
                                    )),
                                    SizedBox(height: 0),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        _hasError
                                            ? "R0"
                                            : "R${formatLargeNumber2b(totalCollectionSum.toString())}",
                                        style: TextStyle(
                                            fontSize: 16.5,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Chart Display - conditional based on loading/error state
            Expanded(
              flex: 3,
              child: _buildChartSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection() {
    // Show loading indicator only when loading
    if (_isLoading) {
      return Center(
        child: Container(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Constants.ctaColorLight,
            strokeWidth: 1.8,
          ),
        ),
      );
    }

    // Show error message when there's an error
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.grey[400],
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              "Failed to load data",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    // Show "No data" when data is empty but no error
    if (_salesData == null || _salesData!.isEmpty) {
      return const Center(child: Text("No data"));
    }

    // Update total collection sum when data changes
    _updateTotalCollectionSum();

    // Calculate maxY with 10% padding
    double maxY =
        _salesData!.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
    maxY = maxY == 0 ? 10 : maxY * 1.1;

    final series = [
      charts.Series<SalesData1, String>(
        id: 'Sales',
        domainFn: (SalesData1 sd, _) =>
            DateFormat('MMM yy').format(sd.dateTime).toString(),
        measureFn: (SalesData1 sd, _) => sd.amount,
        data: _salesData!,
        labelAccessorFn: (SalesData1 sd, _) =>
            'R${formatLargeNumber4(sd.amount.toString())}',
      )
    ];

    return charts.BarChart(
      series,
      animate: true,
      animationDuration: const Duration(milliseconds: 500),
      vertical: true,
      defaultInteractions: false,
      barGroupingType: charts.BarGroupingType.grouped,
      barRendererDecorator: charts.BarLabelDecorator<String>(
        outsideLabelStyleSpec: const charts.TextStyleSpec(
          fontSize: 7,
          fontWeight: "bold",
        ),
      ),
      domainAxis: const charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 6,
            color: charts.MaterialPalette.black,
            fontWeight: "bold",
          ),
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
          (num? value) => 'R${value?.round() ?? 0}',
        ),
        renderSpec: const charts.NoneRenderSpec(),
        viewport: charts.NumericExtents(0, maxY),
      ),
    );
  }

  String formatLargeNumber2B(String valueStr) {
    const List<String> suffixes = [
      "",
      "k",
      "m",
      "b",
      "t"
    ]; // Add more suffixes as needed

    // Convert string to double and handle invalid inputs
    double value;
    try {
      value = double.parse(valueStr);
    } catch (e) {
      return 'Invalid Number';
    }

    // If the value is less than 1000, return it as a string with commas
    if (value < 1000) {
      return formatWithCommas(value);
    }

    int index = 0;
    double newValue = value;

    while (newValue >= 1000 && index < suffixes.length - 1) {
      newValue /= 1000;
      index++;
    }

    return '${formatWithCommas(newValue)}${suffixes[index]}';
  }

  String formatWithCommas(double value) {
    final format = NumberFormat("#,##0", "en_US"); // Updated pattern
    return format.format(value);
  }

  String formatLargeNumber2b(String valueStr) {
    const List<String> suffixes = [
      "",
      "k",
      "m",
      "b",
      "t"
    ]; // Add more suffixes as needed

    // Convert string to double and handle invalid inputs
    double value;
    try {
      value = double.parse(valueStr);
    } catch (e) {
      return 'Invalid Number';
    }

    // If the value is less than 1000, return it as a string with commas
    if (value < 1000) {
      return formatWithCommas(value);
    }

    int index = 0;
    double newValue = value;

    while (newValue >= 1000 && index < suffixes.length - 1) {
      newValue /= 1000;
      index++;
    }

    return '${formatWithCommas(newValue)}${suffixes[index]}';
  }
}

// Helper function to generate URL for payover data (same structure as your getOneMonthUrl)
String getOneMonthUrl(String selectedMonth) {
  int clientId = 140; // Replace with Constants.cec_client_id if available

  // Parse the selected month string using the format "MMM yyyy".
  // If parsing fails, fallback to the current month.
  DateTime selectedDate;
  try {
    // Use explicit format parsing with locale if needed
    selectedDate = DateFormat("MMM yyyy").parse(selectedMonth);
  } catch (e) {
    print("Error parsing date: $e");
    selectedDate = DateTime.now();
  }

  // Calculate start date (first day of the selected month)
  DateTime startDate = DateTime(
    selectedDate.year,
    selectedDate.month,
    1,
  );

  // Calculate last day of the selected month
  DateTime endDate = DateTime(
    selectedDate.year,
    selectedDate.month + 1,
    0, // Last day of previous month (which is current month's last day)
  );

  // Alternative using a helper function
  int lastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
  String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

  // Build the URL - use the new JSON endpoint for better performance
  String url = "https://miinsightsapps.net/files/get_payover_chart_data?"
      "client_id=$clientId&start_date=$formattedStartDate&end_date=$formattedEndDate"
      "&with_underwriter_only=1&underwriter=1";

  print("Final URL 0000: $url");
  return url;
}

// Backward compatibility function (same as getOneMonthUrl)
String getPayoverUrl(String selectedMonth, {int? clientId}) {
  return getOneMonthUrl(selectedMonth);
}

// Usage example:
class PayoverChartExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String selectedMonth = "Apr 2025"; // Example month
    String dataUrl = getPayoverUrl(selectedMonth, clientId: 140);

    return Scaffold(
      appBar: AppBar(
        title: Text('Payover Chart - $selectedMonth'),
      ),
      body: Center(
        child: PayoverBarChart2(
          dataUrl: dataUrl,
          selectedMonth: selectedMonth,
        ),
      ),
    );
  }
}
