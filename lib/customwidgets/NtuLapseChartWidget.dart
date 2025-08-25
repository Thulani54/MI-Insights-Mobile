import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../constants/Constants.dart';
import '../models/SalesDataResponse.dart';
import '../screens/Reports/Executive/ExecutiveSalesReport.dart';
import 'CustomCard.dart';

class NtuLapseChartWidget extends StatefulWidget {
  final int selectedButton;
  final int days;
  final SalesDataResponse? salesDataResponse;

  const NtuLapseChartWidget({
    Key? key,
    required this.selectedButton,
    required this.days,
    this.salesDataResponse,
  }) : super(key: key);

  @override
  State<NtuLapseChartWidget> createState() => _NtuLapseChartWidgetState();
}

class _NtuLapseChartWidgetState extends State<NtuLapseChartWidget> {
  int ntu_lapse_index = 0;
  double _sliderPosition3 = 0;
  bool isSalesDataLoading2a = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTabSelector(),
        _buildChartTitle(),
        _buildChart(),
      ],
    );
  }

  // Tab selector widget
  Widget _buildTabSelector() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Row(
                  children: [
                    _buildTabButton('NTU Rate', 0),
                    _buildTabButton('Lapse Rate', 1),
                  ],
                ),
              ),
            ),
            _buildAnimatedSlider(),
          ],
        ),
      ),
    );
  }

  // Individual tab button
  Widget _buildTabButton(String title, int index) {
    return GestureDetector(
      onTap: () => _animateButton3(index),
      child: Container(
        width: (MediaQuery.of(context).size.width / 2) - 16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(360),
        ),
        height: 35,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  // Animated slider for tab selection
  Widget _buildAnimatedSlider() {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      left: _sliderPosition3,
      child: InkWell(
        onTap: () {},
        child: Container(
          width: (MediaQuery.of(context).size.width / 2) - 16,
          height: 35,
          decoration: BoxDecoration(
            color: Constants.ctaColorLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              ntu_lapse_index == 0 ? 'NTU Rate' : 'Lapse Rate',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  // Chart title based on selected tab - always shows 12 months
  Widget _buildChartTitle() {
    if (ntu_lapse_index == -1) return Container();

    String chartType = ntu_lapse_index == 0 ? 'NTU Rate' : 'Lapse Rate';

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 12),
      child: Text("$chartType (Past 12 Months)"),
    );
  }

  // Main chart container
  Widget _buildChart() {
    return Container(
      height: 280,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          bottom: 0,
          left: 16.0,
          right: 16,
        ),
        child: CustomCard(
          elevation: 6,
          color: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: _buildChartContent(),
          ),
        ),
      ),
    );
  }

  // Chart content with loading and data states
  Widget _buildChartContent() {
    if (isSalesDataLoading2a) {
      return _buildLoadingIndicator();
    }

    List<FlSpot> chartData = _getChartData();

    if (chartData.isEmpty) {
      return _buildNoDataState();
    }

    return _buildLineChart(chartData);
  }

  // Loading indicator
  Widget _buildLoadingIndicator() {
    return Center(
      child: Container(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          color: Constants.ctaColorLight,
          strokeWidth: 1.8,
        ),
      ),
    );
  }

  // No data state
  Widget _buildNoDataState() {
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No data available for the past 12 months",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 12),
          Icon(
            Icons.auto_graph_sharp,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  // Line chart widget
  Widget _buildLineChart(List<FlSpot> chartData) {
    return Column(
      children: [
        Expanded(
          child: LineChart(
            key: Constants.sales_lapsechartKey2a,
            LineChartData(
              lineTouchData: _buildLineTouchData(),
              lineBarsData: _buildLineBarsData(chartData),
              gridData: _buildGridData(),
              titlesData: _buildTitlesData(),
              minY: 0,
              maxY: _getMaxY(),
              minX: _getMinX(),
              maxX: _getMaxX(),
              borderData: _buildBorderData(),
            ),
          ),
        ),
        SizedBox(height: 0),
      ],
    );
  }

  // Line touch data configuration
  LineTouchData _buildLineTouchData() {
    return LineTouchData(
      enabled: true,
      touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
        // Handle touch events
      },
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (value) => Colors.blueGrey,
        tooltipRoundedRadius: 20.0,
        showOnTopOfTheChartBoxArea: false,
        fitInsideHorizontally: true,
        tooltipMargin: 0,
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((LineBarSpot touchedSpot) {
            const textStyle = TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white70,
            );
            return LineTooltipItem(
              '${touchedSpot.y.round()}%',
              textStyle,
            );
          }).toList();
        },
      ),
      getTouchedSpotIndicator:
          (LineChartBarData barData, List<int> indicators) {
        return indicators.map((int index) {
          final line = FlLine(
            color: Colors.grey,
            strokeWidth: 1,
            dashArray: [2, 4],
          );
          return TouchedSpotIndicatorData(
            line,
            FlDotData(show: false),
          );
        }).toList();
      },
      getTouchLineEnd: (_, __) => double.infinity,
    );
  }

  // Line bars data configuration
  List<LineChartBarData> _buildLineBarsData(List<FlSpot> chartData) {
    List<FlSpot> targetData = _getTargetData();

    return [
      LineChartBarData(
        spots: chartData,
        isCurved: true,
        barWidth: 3,
        color: Colors.grey.shade400,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) {
            return CustomDotPainter2(
              dotColor: Constants.ctaColorLight,
              dotSize: 6,
            );
          },
        ),
      ),
      if (targetData.isNotEmpty)
        LineChartBarData(
          spots: targetData,
          isCurved: false, // Straight line for target
          barWidth: 2,
          color: Colors.green,
          dotData: FlDotData(show: false),
          dashArray: [5, 5], // Make target line dashed
        ),
    ];
  }

  // Grid data configuration
  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.grey.withOpacity(0.10),
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: Colors.grey,
          strokeWidth: 1,
        );
      },
    );
  }

  // Titles data configuration
  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: (value, meta) {
            return _getBottomTitleWidget(value);
          },
        ),
        axisNameWidget: LapseLineTypeGrid(),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: _getYAxisInterval(),
          getTitlesWidget: (value, meta) {
            return _getLeftTitleWidget(value);
          },
        ),
      ),
    );
  }

  // Bottom title widget - shows month abbreviations for past 12 months
  Widget _getBottomTitleWidget(double value) {
    List<FlSpot> data = _getChartData();
    if (data.isEmpty) return Container();

    // Find the data point that matches this x value
    FlSpot? matchingSpot;
    try {
      matchingSpot = data.firstWhere((spot) => spot.x == value);
    } catch (e) {
      return Container();
    }

    // Get the corresponding date from the original data
    String monthAbbreviation = _getMonthAbbreviationFromX(value);

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Text(
        monthAbbreviation,
        style: TextStyle(fontSize: 10),
      ),
    );
  }

  // Get month abbreviation from x value
  String _getMonthAbbreviationFromX(double x) {
    // Get the 12-month data source
    List<MonthlyRateData> sourceData = ntu_lapse_index == 0
        ? (widget.salesDataResponse?.ntuResultList12Months ?? [])
        : (widget.salesDataResponse?.lapseResultList12Months ?? []);

    try {
      // Use array index to find the matching month
      int index = x.toInt();
      if (index >= 0 && index < sourceData.length) {
        String dateStr = sourceData[index].date;
        if (dateStr.isNotEmpty) {
          // Parse month from format like "2024-07"
          if (dateStr.contains('-')) {
            List<String> parts = dateStr.split('-');
            if (parts.length >= 2) {
              int month = int.tryParse(parts[1]) ?? 1;
              return getMonthAbbreviation(month);
            }
          }
        }
      }
    } catch (e) {
      // Fallback
    }

    // Final fallback: calculate from x value
    int totalMonths = x.toInt();
    int month = (totalMonths % 12) + 1;
    return getMonthAbbreviation(month);
  }

  // Left title widget (Y-axis labels)
  Widget _getLeftTitleWidget(double value) {
    // Show percentage labels at regular intervals
    if (value % _getYAxisInterval() == 0) {
      return Text(
        '${value.toInt()}%',
        style: TextStyle(fontSize: 8, color: Colors.grey[600]),
      );
    }
    return Container();
  }

  // Get appropriate Y-axis interval based on data range
  double _getYAxisInterval() {
    double maxY = _getMaxY();
    if (maxY <= 20) return 5;
    if (maxY <= 50) return 10;
    if (maxY <= 100) return 20;
    return 25;
  }

  // Border data configuration
  FlBorderData _buildBorderData() {
    return FlBorderData(
      show: true,
      border: Border(
        left: BorderSide.none,
        bottom: BorderSide(
          color: Colors.grey.withOpacity(0.35),
          width: 1,
        ),
        right: BorderSide.none,
        top: BorderSide.none,
      ),
    );
  }

  // Data retrieval methods - use 12 months data directly
  List<FlSpot> _getChartData() {
    List<MonthlyRateData> sourceData =
        ntu_lapse_index == 0 ? _get12MonthsNTUData() : _get12MonthsLapseData();

    return _convertMonthlyRateToFlSpot(sourceData);
  }

  // FIXED: Target data implementation
  List<FlSpot> _getTargetData() {
    List<FlSpot> chartData = _getChartData();
    if (chartData.isEmpty) return [];

    // Define target values: NTU = 30%, Lapse = 49%
    double targetValue = ntu_lapse_index == 0 ? 30.0 : 49.0;

    // Create a straight line across all x points
    return chartData.map((spot) => FlSpot(spot.x, targetValue)).toList();
  }

  List<MonthlyRateData> _get12MonthsNTUData() {
    return Constants.currentSalesDataResponse.ntuResultList12Months ?? [];
  }

  // Get 12 months of Lapse data from the dedicated field
  List<MonthlyRateData> _get12MonthsLapseData() {
    return Constants.currentSalesDataResponse.lapseResultList12Months ?? [];
  }

  // Helper method to convert MonthlyRateData to FlSpot
  List<FlSpot> _convertMonthlyRateToFlSpot(List<MonthlyRateData> monthlyRateList) {
    // Only take the last 12 months if there are more than 12 entries
    List<MonthlyRateData> last12Months = monthlyRateList.length > 12
        ? monthlyRateList.sublist(monthlyRateList.length - 12)
        : monthlyRateList;

    return last12Months.asMap().entries.map((entry) {
      int index = entry.key;
      MonthlyRateData monthlyRate = entry.value;
      // Use index as x-coordinate for consistent spacing (0-11 for 12 months)
      return FlSpot(index.toDouble(), monthlyRate.rate);
    }).toList();
  }

  // Chart bounds methods
  double _getMinX() {
    List<FlSpot> data = _getChartData();
    return data.isEmpty ? 0 : 0; // Always start from 0 for consistent view
  }

  double _getMaxX() {
    List<FlSpot> data = _getChartData();
    return data.isEmpty
        ? 11
        : (data.length - 1).toDouble(); // 0-11 for 12 months
  }

  // FIXED: Get maximum Y value for chart scaling - no longer always 100%
  double _getMaxY() {
    List<FlSpot> data = _getChartData();
    if (data.isEmpty) return 100;

    double maxDataValue =
        data.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);

    // Get target value for comparison
    double targetValue = ntu_lapse_index == 0 ? 30.0 : 49.0;

    // Take the maximum of data value and target value
    double maxValue = maxDataValue > targetValue ? maxDataValue : targetValue;

    // Add some padding (20%) and round up to nearest 10
    double paddedMax = maxValue * 1.2;
    return (paddedMax / 10).ceil() * 10;
  }

  // Animation method
  void _animateButton3(int index) {
    setState(() {
      ntu_lapse_index = index;
      _sliderPosition3 = index * ((MediaQuery.of(context).size.width / 2) - 16);
    });
  }
}
