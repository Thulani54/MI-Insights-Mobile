import 'dart:convert';
import 'dart:ui' as ui;

import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:d_chart/commons/data_model/data_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mi_insights/constants/Constants.dart';

import '../../customwidgets/custom_date_range_picker.dart';

bool isLoading = false;
List<SalesByBranch> salesbybranch_mtd = [];
List<SalesByBranch> salesbybranch_ytd = [];
List<SalesByAgent> salesbyagent_mtd = [];
List<SalesByAgent> salesbyagent_ytd = [];
DateTime datefrom = DateTime.now().subtract(Duration(days: 60));
DateTime dateto = DateTime.now();
int days_difference = 0;
List<salesgridmodel> sectionsList = [];
int report_index = 0;
int sales_index = 0;
String data2 = "";
int maxY = 0;
int maxY2 = 0;
int maxY3 = 0;
int maxY4 = 0;
int maxY5 = 0;
int maxY6 = 0;

int allsales_mtd = 0;
int allsales_ytd = 0;
int allsales_custom = 0;

int inforced_mtd = 0;
int inforced_ytd = 0;
int inforced_custom = 0;

int not_accepted_mtd = 0;
int not_accepted_ytd = 0;
int not_accepted_custom = 0;

int touchedIndex = -1;
List<BarChartGroupData> barData = [];
List<PieChartSectionData> pieData = [];
List<String> bottomTitles1 = [];
String formattedStartDate = "";
String formattedEndDate = "";
List<charts.Series<dynamic, String>> seriesList = [];
List<charts.Series<OrdinalSales, String>> bardata5 = [];
List<charts.Series<OrdinalSales, String>> bardata6 = [];
List<OrdinalSales> ordinary_sales_mtd = [];
List<OrdinalSales> ordinary_sales_ytd = [];
Widget _sales_by_branch_mtd = Container();
Widget _sales_by_branch_ytd = Container();
Widget _sales_by_branch_mtda = Container();
List samplecolors = [
  Color(0xFF2196F3),
  Color(0xFFFFC300),
  Color(0xFFFF683B),
  Color(0xFF3BFF49),
  Color(0xFF6E1BFF),
  Color(0xFFFF3AF2),
  Color(0xFFE80054),
  Color(0xFF50E4FF),
  Color(0xFF2196F3),
  Color(0xFFFFC300),
  Color(0xFFFF683B),
  Color(0xFF3BFF49),
  Color(0xFF6E1BFF),
  Color(0xFFFF3AF2),
  Color(0xFFE80054),
  Color(0xFF50E4FF),
  Color(0xFF2196F3),
  Color(0xFFFFC300),
  Color(0xFFFF683B),
  Color(0xFF3BFF49),
  Color(0xFF6E1BFF),
  Color(0xFFFF3AF2),
  Color(0xFFE80054),
  Color(0xFF50E4FF),
  Color(0xFF2196F3),
  Color(0xFFFFC300),
  Color(0xFFFF683B),
  Color(0xFF3BFF49),
  Color(0xFF6E1BFF),
  Color(0xFFFF3AF2),
  Color(0xFFE80054),
  Color(0xFF50E4FF),
  Color(0xFF2196F3),
  Color(0xFFFFC300),
  Color(0xFFFF683B),
  Color(0xFF3BFF49),
  Color(0xFF6E1BFF),
  Color(0xFFFF3AF2),
  Color(0xFFE80054),
  Color(0xFF50E4FF),
  Color(0xFF2196F3),
  Color(0xFFFFC300),
  Color(0xFFFF683B),
  Color(0xFF3BFF49),
  Color(0xFF6E1BFF),
  Color(0xFFFF3AF2),
  Color(0xFFE80054),
  Color(0xFF50E4FF),
  Color(0xFF2196F3),
  Color(0xFFFFC300),
  Color(0xFFFF683B),
  Color(0xFF3BFF49),
  Color(0xFF6E1BFF),
  Color(0xFFFF3AF2),
  Color(0xFFE80054),
  Color(0xFF50E4FF),
  Color(0xFF2196F3),
  Color(0xFFFFC300),
  Color(0xFFFF683B),
  Color(0xFF3BFF49),
  Color(0xFF6E1BFF),
  Color(0xFFFF3AF2),
  Color(0xFFE80054),
  Color(0xFF50E4FF),
  Color(0xFF2196F3),
  Color(0xFFFFC300),
  Color(0xFFFF683B),
  Color(0xFF3BFF49),
  Color(0xFF6E1BFF),
  Color(0xFFFF3AF2),
  Color(0xFFE80054),
  Color(0xFF50E4FF),
  Color(0xFF2196F3),
  Color(0xFFFFC300),
  Color(0xFFFF683B),
  Color(0xFF3BFF49),
  Color(0xFF6E1BFF),
  Color(0xFFFF3AF2),
  Color(0xFFE80054),
  Color(0xFF50E4FF),
  Color(0xFF2196F3),
  Color(0xFFFFC300),
  Color(0xFFFF683B),
  Color(0xFF3BFF49),
  Color(0xFF6E1BFF),
  Color(0xFFFF3AF2),
  Color(0xFFE80054),
  Color(0xFF50E4FF),
];

class SalesByBranch {
  final String branch_name;
  final int sales;
  SalesByBranch(this.branch_name, this.sales);
}

class SalesByAgent {
  final String agent_name;
  final int sales;
  SalesByAgent(this.agent_name, this.sales);
}

class SalesReport1 extends StatefulWidget {
  const SalesReport1({Key? key}) : super(key: key);

  @override
  State<SalesReport1> createState() => _SalesReport1State();
}

List<Map<String, dynamic>> leads = [];
List<List<Map<String, dynamic>>> policies = [];
double _sliderPosition = 0.0; // Initial position for the sliding animation
int _selectedButton = 1;

class _SalesReport1State extends State<SalesReport1> {
  Color _button1Color = Colors.grey.withOpacity(0.0);
  Color _button2Color = Colors.grey.withOpacity(0.0);
  Color _button3Color = Colors.grey.withOpacity(0.0);
  int maxY7 = 0;
  int maxY8 = 0;
  int maxY9 = 0;
  List<OrdinalData> ordinalList = [
    OrdinalData(domain: 'Mon', measure: 3),
    OrdinalData(domain: 'Tue', measure: 5),
    OrdinalData(domain: 'Wed', measure: 9),
    OrdinalData(domain: 'Thu', measure: 6.5),
  ];
  List<int> showingTooltipOnSpots = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  List<OrdinalGroup> ordinalGroup = [];

  List<FlSpot> spots1a = [];
  List<FlSpot> spots1b = [];
  List<FlSpot> spots1c = [];
  List<FlSpot> spots2a = [];
  List<FlSpot> spots2b = [];
  List<FlSpot> spots2c = [];
  List<FlSpot> spots3a = [];
  List<FlSpot> spots3b = [];
  List<FlSpot> spots3c = [];
  List<FlSpot> spots4a = [];
  List<FlSpot> spots4b = [];
  List<FlSpot> spots4c = [];

  void _animateButton(int buttonNumber) {
    DateTime? startDate = DateTime.now();
    DateTime? endDate = DateTime.now();
    leads = [];

    print("jhhh " + buttonNumber.toString());
    _selectedButton = buttonNumber;
    if (buttonNumber == 1)
      _sliderPosition = 0.0;
    else if (buttonNumber == 2)
      _sliderPosition = (MediaQuery.of(context).size.width / 3) - 18;
    else if (buttonNumber == 3)
      _sliderPosition = 2 * (MediaQuery.of(context).size.width / 3) - 32;
    setState(() {});
    if (buttonNumber != 3) {
      setState(() {
        // Update colors
        _button1Color = buttonNumber == 1
            ? Constants.ctaColorLight
            : Colors.grey.withOpacity(0.0);
        _button2Color = buttonNumber == 2
            ? Constants.ctaColorLight
            : Colors.grey.withOpacity(0.0);
        _button3Color = buttonNumber == 3
            ? Constants.ctaColorLight
            : Colors.grey.withOpacity(0.0);

        // Update slider position based on the button tapped
      });
      DateTime now = DateTime.now();

      if (buttonNumber == 1) {
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime.now();
      } else if (buttonNumber == 2) {
        startDate = DateTime(now.year, 1, 1);
        endDate = DateTime.now();
      }

      formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
      formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
      if (kDebugMode) {
        print("formattedStartDate7 ${formattedStartDate}");
      }

      // getSalesReport(context, formattedStartDate, formattedEndDate);
      setState(() {});
    } else {
      showCustomDateRangePicker(
        context,
        dismissible: true,
        minimumDate: DateTime.now().subtract(const Duration(days: 360)),
        maximumDate: DateTime.now().add(const Duration(days: 30)),
        endDate: endDate,
        startDate: startDate,
        backgroundColor: Colors.white,
        primaryColor: Constants.ctaColorLight,
        onApplyClick: (start, end) {
          setState(() {
            endDate = end;
            startDate = start;
          });
          formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate!);
          formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate!);
          formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate!);
          formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate!);
          setState(() {});

          String dateRange = '$formattedStartDate - $formattedEndDate';
          print("currently loading ${dateRange}");
          DateTime startDateTime =
              DateFormat('yyyy-MM-dd').parse(formattedStartDate);
          DateTime endDateTime =
              DateFormat('yyyy-MM-dd').parse(formattedEndDate);

          days_difference = endDateTime.difference(startDateTime).inDays;
          if (kDebugMode) {
            print("days_difference ${days_difference}");
            print("formattedEndDate9 ${formattedEndDate}");
          }

          // getSalesReport(context, formattedStartDate, formattedEndDate);
        },
        onCancelClick: () {
          setState(() {
            // endDate = null;
            //  startDate = null;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            leading: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
              "Sales Report",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(36)),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(36)),
                        child: Center(
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _animateButton(1);
                                },
                                child: Container(
                                  width:
                                      (MediaQuery.of(context).size.width / 3) -
                                          12,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(360)),
                                  height: 35,
                                  child: Center(
                                    child: Text(
                                      'MTD',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _animateButton(2);
                                },
                                child: Container(
                                  width:
                                      (MediaQuery.of(context).size.width / 3) -
                                          12,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(360)),
                                  child: Center(
                                    child: Text(
                                      'YTD',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _animateButton(3);
                                },
                                child: Container(
                                  width:
                                      (MediaQuery.of(context).size.width / 3) -
                                          12,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(360)),
                                  child: Center(
                                    child: Text(
                                      'Select Dates',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        left: _sliderPosition,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 35,
                          decoration: BoxDecoration(
                            color:
                                Constants.ctaColorLight, // Color of the slider
                            borderRadius: BorderRadius.circular(36),
                          ),
                          child: _selectedButton == 1
                              ? Center(
                                  child: Text(
                                    'MTD',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : _selectedButton == 2
                                  ? Center(
                                      child: Text(
                                        'YTD',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        'Select Dates',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              isLoading
                  ? Center(
                      child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Constants.ctaColorLight,
                            strokeWidth: 1.8,
                          ),
                        ),
                      ),
                    ))
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 12),
                child: Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.35),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (isLoading)
                      SizedBox(
                        height: 12,
                      ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio:
                                MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 2.3)),
                        itemCount: sectionsList.length,
                        padding: EdgeInsets.all(2.0),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                              onTap: () {},
                              child: Container(
                                height: 300,
                                width: MediaQuery.of(context).size.width / 2.9,
                                child: Stack(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        sales_index = index;
                                        setState(() {});
                                        if (kDebugMode) {
                                          print("sales_index " +
                                              index.toString());
                                        }
                                        if (index == 1) {
                                          /*     Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => SalesReport()));*/
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 4.0, right: 8),
                                        child: Card(
                                          elevation: 6,
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.white70,
                                                width: 0),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: ClipPath(
                                            clipper: ShapeBorderClipper(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16))),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Constants
                                                              .ctaColorLight,
                                                          width: 6))),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: sales_index ==
                                                                  index
                                                              ? Colors.grey
                                                                  .withOpacity(
                                                                      0.2)
                                                              : Colors.grey
                                                                  .withOpacity(
                                                                      0.05),
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.0)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        14),
                                                          ),
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 270,
                                                          /*     decoration: BoxDecoration(
                                                          color:Colors.white,
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                          border: Border.all(
                                                              width: 1,
                                                              color: Colors
                                                                  .grey.withOpacity(0.2))),*/
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 0,
                                                                  left: 0,
                                                                  bottom: 4),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 8,
                                                              ),
                                                              Expanded(
                                                                child: Center(
                                                                    child:
                                                                        Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child: Text(
                                                                    formatLargeNumber(index ==
                                                                            0
                                                                        ? (_selectedButton == 1
                                                                                ? allsales_mtd
                                                                                : _selectedButton == 2
                                                                                    ? allsales_ytd
                                                                                    : allsales_custom)
                                                                            .toString()
                                                                        : index == 1
                                                                            ? (_selectedButton == 1
                                                                                    ? inforced_mtd
                                                                                    : _selectedButton == 2
                                                                                        ? inforced_ytd
                                                                                        : inforced_custom)
                                                                                .toString()
                                                                            : (_selectedButton == 1
                                                                                    ? not_accepted_mtd
                                                                                    : _selectedButton == 2
                                                                                        ? not_accepted_ytd
                                                                                        : not_accepted_custom)
                                                                                .toString()),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18.5,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    maxLines: 2,
                                                                  ),
                                                                )),
                                                              ),
                                                              Center(
                                                                  child:
                                                                      Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Text(
                                                                  sectionsList[
                                                                          index]
                                                                      .id,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12.5),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  maxLines: 1,
                                                                ),
                                                              )),
                                                            ],
                                                          )),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(_selectedButton == 1
                          ? "Sales Overview (MTD - ${getMonthAbbreviation(DateTime.now().month)})"
                          : _selectedButton == 2
                              ? "Sales Overview (YTD - ${DateTime.now().year})"
                              : "Sales Overview (${formattedStartDate} to ${formattedEndDate})"),
                    ),

                    Container(
                        height: 280,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 120,
                                            child: LineChart(
                                              LineChartData(
                                                lineBarsData: [
                                                  LineChartBarData(
                                                    showingIndicators:
                                                        showingTooltipOnSpots,
                                                    spots: (_selectedButton ==
                                                                1 &&
                                                            sales_index == 0)
                                                        ? spots1a
                                                        : (_selectedButton ==
                                                                    1 &&
                                                                sales_index ==
                                                                    1)
                                                            ? spots1b
                                                            : (_selectedButton ==
                                                                        1 &&
                                                                    sales_index ==
                                                                        2)
                                                                ? spots1c
                                                                : (_selectedButton ==
                                                                            2 &&
                                                                        sales_index ==
                                                                            0)
                                                                    ? spots2a
                                                                    : (_selectedButton ==
                                                                                2 &&
                                                                            sales_index ==
                                                                                1)
                                                                        ? spots2b
                                                                        : (_selectedButton == 2 &&
                                                                                sales_index == 2)
                                                                            ? spots2c
                                                                            : (_selectedButton == 3 && sales_index == 0)
                                                                                ? spots3a
                                                                                : (_selectedButton == 3 && sales_index == 1)
                                                                                    ? spots3b
                                                                                    : spots3c,
                                                    isCurved: true,
                                                    barWidth: 3,
                                                    color: Colors.grey.shade400,
                                                    dotData: FlDotData(
                                                      show: true,
                                                      getDotPainter: (spot,
                                                          percent,
                                                          barData,
                                                          index) {
                                                        // Show custom dot and text for specific x-values

                                                        return FlDotCirclePainter(
                                                            radius: 2,
                                                            color: Colors.red,
                                                            strokeColor:
                                                                Colors.green);
                                                        /*    if (_selectedButton == 1) {
                                                    return CustomDotPainter(
                                                        yValue: spot.y,
                                                        maxY: maxY.toDouble(),
                                                        chartHeight: 120,
                                                        xValue: spot.x,
                                                        maxX: 30,
                                                        chartWidth:
                                                            MediaQuery.of(context).size.width +
                                                                45);
                                                  } else {
                                                    return CustomDotPainter(
                                                        yValue: spot.y,
                                                        maxY: maxY.toDouble(),
                                                        chartHeight: 120,
                                                        xValue: spot.x,
                                                        maxX: 12,
                                                        chartWidth:
                                                            MediaQuery.of(context).size.width +
                                                                45);
                                                  }*/
                                                      },
                                                    ),
                                                  ),
                                                ],
                                                gridData: FlGridData(
                                                  show: true,
                                                  drawVerticalLine: false,
                                                  getDrawingHorizontalLine:
                                                      (value) {
                                                    return FlLine(
                                                      color: Colors.grey
                                                          .withOpacity(0.10),
                                                      strokeWidth: 1,
                                                    );
                                                  },
                                                  getDrawingVerticalLine:
                                                      (value) {
                                                    return FlLine(
                                                      color: Colors.grey,
                                                      strokeWidth: 1,
                                                    );
                                                  },
                                                ),
                                                titlesData: FlTitlesData(
                                                  bottomTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: true,
                                                      interval: 1,
                                                      getTitlesWidget:
                                                          (value, meta) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: Text(
                                                            value
                                                                .toInt()
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 7),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    axisNameWidget: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 0.0),
                                                      child: Text(
                                                        _selectedButton == 1
                                                            ? 'Days of the Month'
                                                            : _selectedButton ==
                                                                    2
                                                                ? "Months of the Year"
                                                                : days_difference <=
                                                                        30
                                                                    ? 'Days of the Month'
                                                                    : "Months of the Year",
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  topTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: false,
                                                      getTitlesWidget:
                                                          (value, meta) {
                                                        return Text(value
                                                            .toInt()
                                                            .toString());
                                                      },
                                                    ),
                                                  ),
                                                  rightTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: false,
                                                      getTitlesWidget:
                                                          (value, meta) {
                                                        return Text(value
                                                            .toInt()
                                                            .toString());
                                                      },
                                                    ),
                                                  ),
                                                  leftTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: true,
                                                      reservedSize: 20,
                                                      getTitlesWidget:
                                                          (value, meta) {
                                                        return Text(
                                                          formatLargeNumber2(
                                                              value
                                                                  .toInt()
                                                                  .toString()),
                                                          style: TextStyle(
                                                              fontSize: 7.5),
                                                        );
                                                      },
                                                    ),
                                                    /*axisNameWidget: Padding(
                                                          padding:
                                                              const EdgeInsets.only(top: 0.0),
                                                          child: Text(
                                                            'Sales',
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                fontWeight: FontWeight.w500,
                                                                color: Colors.black),
                                                          ),
                                                        ),*/
                                                  ),
                                                ),
                                                minY: 0,
                                                maxY: _selectedButton == 1
                                                    ? maxY.toDouble()
                                                    : maxY2.toDouble(),
                                                borderData: FlBorderData(
                                                  show: true,
                                                  border: Border(
                                                    left: BorderSide.none,
                                                    bottom: BorderSide(
                                                      color: Colors.grey
                                                          .withOpacity(0.35),
                                                      width: 1,
                                                    ),
                                                    right: BorderSide.none,
                                                    top: BorderSide.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          "Weekend Sales are Added to / Accounted For On The Next Monday",
                                          style: TextStyle(fontSize: 7),
                                        )
                                      ],
                                    ))))),
                    if (_selectedButton == 2)
                      Container(
                          height: 250,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: sales_index == 0
                                        ? LineChart(
                                            LineChartData(
                                              lineBarsData: [
                                                LineChartBarData(
                                                  showingIndicators:
                                                      showingTooltipOnSpots,
                                                  spots: spots2a,
                                                  isCurved: false,
                                                  barWidth: 3,
                                                  color: Colors.grey.shade400,
                                                  dotData: FlDotData(
                                                    show: true,
                                                    getDotPainter: (spot,
                                                        percent,
                                                        barData,
                                                        index) {
                                                      // Show custom dot and text for specific x-values

                                                      return FlDotCirclePainter(
                                                          radius: 2,
                                                          color: Colors.red,
                                                          strokeColor:
                                                              Colors.green);
                                                      /*    if (_selectedButton == 1) {
                                            return CustomDotPainter(
                                                yValue: spot.y,
                                                maxY: maxY.toDouble(),
                                                chartHeight: 120,
                                                xValue: spot.x,
                                                maxX: 30,
                                                chartWidth:
                                                    MediaQuery.of(context).size.width +
                                                        45);
                                          } else {
                                            return CustomDotPainter(
                                                yValue: spot.y,
                                                maxY: maxY.toDouble(),
                                                chartHeight: 120,
                                                xValue: spot.x,
                                                maxX: 12,
                                                chartWidth:
                                                    MediaQuery.of(context).size.width +
                                                        45);
                                          }*/
                                                    },
                                                  ),
                                                ),
                                              ],
                                              gridData: FlGridData(
                                                show: true,
                                                drawVerticalLine: false,
                                                getDrawingHorizontalLine:
                                                    (value) {
                                                  return FlLine(
                                                    color: Colors.grey
                                                        .withOpacity(0.10),
                                                    strokeWidth: 1,
                                                  );
                                                },
                                                getDrawingVerticalLine:
                                                    (value) {
                                                  return FlLine(
                                                    color: Colors.grey,
                                                    strokeWidth: 1,
                                                  );
                                                },
                                              ),
                                              titlesData: FlTitlesData(
                                                bottomTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: true,
                                                    interval: 1,
                                                    getTitlesWidget:
                                                        (value, meta) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: Text(
                                                          getMonthAbbreviation(
                                                              value.toInt()),
                                                          style: TextStyle(
                                                              fontSize: 10),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  axisNameWidget: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 0.0),
                                                    child: Text(
                                                      'Months of the Year',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                topTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: false,
                                                    getTitlesWidget:
                                                        (value, meta) {
                                                      return Text(value
                                                          .toInt()
                                                          .toString());
                                                    },
                                                  ),
                                                ),
                                                rightTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: false,
                                                    getTitlesWidget:
                                                        (value, meta) {
                                                      return Text(value
                                                          .toInt()
                                                          .toString());
                                                    },
                                                  ),
                                                ),
                                                leftTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: true,
                                                    reservedSize: 20,
                                                    getTitlesWidget:
                                                        (value, meta) {
                                                      return Text(
                                                        formatLargeNumber2(value
                                                            .toInt()
                                                            .toString()),
                                                        style: TextStyle(
                                                            fontSize: 8),
                                                      );
                                                    },
                                                  ),
                                                  /* axisNameWidget: Padding(
                                                  padding:
                                                      const EdgeInsets.only(top: 0.0),
                                                  child: Text(
                                                    'Sales',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                ),*/
                                                ),
                                              ),
                                              minY: 0,
                                              maxY: maxY2.toDouble(),
                                              borderData: FlBorderData(
                                                show: true,
                                                border: Border(
                                                  left: BorderSide.none,
                                                  bottom: BorderSide(
                                                    color: Colors.grey
                                                        .withOpacity(0.35),
                                                    width: 1,
                                                  ),
                                                  right: BorderSide.none,
                                                  top: BorderSide.none,
                                                ),
                                              ),
                                            ),
                                          )
                                        : sales_index == 1
                                            ? LineChart(
                                                LineChartData(
                                                  lineBarsData: [
                                                    LineChartBarData(
                                                      showingIndicators:
                                                          showingTooltipOnSpots,
                                                      spots: spots2b,
                                                      isCurved: false,
                                                      barWidth: 3,
                                                      color:
                                                          Colors.grey.shade400,
                                                      dotData: FlDotData(
                                                        show: true,
                                                        getDotPainter: (spot,
                                                            percent,
                                                            barData,
                                                            index) {
                                                          // Show custom dot and text for specific x-values

                                                          return FlDotCirclePainter(
                                                              radius: 2,
                                                              color: Colors.red,
                                                              strokeColor:
                                                                  Colors.green);
                                                          /*    if (_selectedButton == 1) {
                                            return CustomDotPainter(
                                                yValue: spot.y,
                                                maxY: maxY.toDouble(),
                                                chartHeight: 120,
                                                xValue: spot.x,
                                                maxX: 30,
                                                chartWidth:
                                                    MediaQuery.of(context).size.width +
                                                        45);
                                          } else {
                                            return CustomDotPainter(
                                                yValue: spot.y,
                                                maxY: maxY.toDouble(),
                                                chartHeight: 120,
                                                xValue: spot.x,
                                                maxX: 12,
                                                chartWidth:
                                                    MediaQuery.of(context).size.width +
                                                        45);
                                          }*/
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                  gridData: FlGridData(
                                                    show: true,
                                                    drawVerticalLine: false,
                                                    getDrawingHorizontalLine:
                                                        (value) {
                                                      return FlLine(
                                                        color: Colors.grey
                                                            .withOpacity(0.10),
                                                        strokeWidth: 1,
                                                      );
                                                    },
                                                    getDrawingVerticalLine:
                                                        (value) {
                                                      return FlLine(
                                                        color: Colors.grey,
                                                        strokeWidth: 1,
                                                      );
                                                    },
                                                  ),
                                                  titlesData: FlTitlesData(
                                                    bottomTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: true,
                                                        interval: 1,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            child: Text(
                                                              getMonthAbbreviation(
                                                                  value
                                                                      .toInt()),
                                                              style: TextStyle(
                                                                  fontSize: 10),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      axisNameWidget: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 0.0),
                                                        child: Text(
                                                          'Months of the Year',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                    topTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: false,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          return Text(value
                                                              .toInt()
                                                              .toString());
                                                        },
                                                      ),
                                                    ),
                                                    rightTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: false,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          return Text(value
                                                              .toInt()
                                                              .toString());
                                                        },
                                                      ),
                                                    ),
                                                    leftTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: true,
                                                        reservedSize: 20,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          return Text(
                                                            formatLargeNumber2(
                                                                value
                                                                    .toInt()
                                                                    .toString()),
                                                            style: TextStyle(
                                                                fontSize: 8),
                                                          );
                                                        },
                                                      ),
                                                      /* axisNameWidget: Padding(
                                                  padding:
                                                      const EdgeInsets.only(top: 0.0),
                                                  child: Text(
                                                    'Sales',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                ),*/
                                                    ),
                                                  ),
                                                  minY: 0,
                                                  maxY: maxY2.toDouble(),
                                                  borderData: FlBorderData(
                                                    show: true,
                                                    border: Border(
                                                      left: BorderSide.none,
                                                      bottom: BorderSide(
                                                        color: Colors.grey
                                                            .withOpacity(0.35),
                                                        width: 1,
                                                      ),
                                                      right: BorderSide.none,
                                                      top: BorderSide.none,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : LineChart(
                                                LineChartData(
                                                  lineBarsData: [
                                                    LineChartBarData(
                                                      showingIndicators:
                                                          showingTooltipOnSpots,
                                                      spots: spots2c,
                                                      isCurved: false,
                                                      barWidth: 3,
                                                      color:
                                                          Colors.grey.shade400,
                                                      dotData: FlDotData(
                                                        show: true,
                                                        getDotPainter: (spot,
                                                            percent,
                                                            barData,
                                                            index) {
                                                          // Show custom dot and text for specific x-values

                                                          return FlDotCirclePainter(
                                                              radius: 2,
                                                              color: Colors.red,
                                                              strokeColor:
                                                                  Colors.green);
                                                          /*    if (_selectedButton == 1) {
                                            return CustomDotPainter(
                                                yValue: spot.y,
                                                maxY: maxY.toDouble(),
                                                chartHeight: 120,
                                                xValue: spot.x,
                                                maxX: 30,
                                                chartWidth:
                                                    MediaQuery.of(context).size.width +
                                                        45);
                                          } else {
                                            return CustomDotPainter(
                                                yValue: spot.y,
                                                maxY: maxY.toDouble(),
                                                chartHeight: 120,
                                                xValue: spot.x,
                                                maxX: 12,
                                                chartWidth:
                                                    MediaQuery.of(context).size.width +
                                                        45);
                                          }*/
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                  gridData: FlGridData(
                                                    show: true,
                                                    drawVerticalLine: false,
                                                    getDrawingHorizontalLine:
                                                        (value) {
                                                      return FlLine(
                                                        color: Colors.grey
                                                            .withOpacity(0.10),
                                                        strokeWidth: 1,
                                                      );
                                                    },
                                                    getDrawingVerticalLine:
                                                        (value) {
                                                      return FlLine(
                                                        color: Colors.grey,
                                                        strokeWidth: 1,
                                                      );
                                                    },
                                                  ),
                                                  titlesData: FlTitlesData(
                                                    bottomTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: true,
                                                        interval: 1,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            child: Text(
                                                              getMonthAbbreviation(
                                                                  value
                                                                      .toInt()),
                                                              style: TextStyle(
                                                                  fontSize: 10),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      axisNameWidget: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 0.0),
                                                        child: Text(
                                                          'Months of the Year',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                    topTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: false,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          return Text(value
                                                              .toInt()
                                                              .toString());
                                                        },
                                                      ),
                                                    ),
                                                    rightTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: false,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          return Text(value
                                                              .toInt()
                                                              .toString());
                                                        },
                                                      ),
                                                    ),
                                                    leftTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: true,
                                                        reservedSize: 20,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          return Text(
                                                            formatLargeNumber2(
                                                                value
                                                                    .toInt()
                                                                    .toString()),
                                                            style: TextStyle(
                                                                fontSize: 8),
                                                          );
                                                        },
                                                      ),
                                                      /* axisNameWidget: Padding(
                                                  padding:
                                                      const EdgeInsets.only(top: 0.0),
                                                  child: Text(
                                                    'Sales',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                ),*/
                                                    ),
                                                  ),
                                                  minY: 0,
                                                  maxY: maxY2.toDouble(),
                                                  borderData: FlBorderData(
                                                    show: true,
                                                    border: Border(
                                                      left: BorderSide.none,
                                                      bottom: BorderSide(
                                                        color: Colors.grey
                                                            .withOpacity(0.35),
                                                        width: 1,
                                                      ),
                                                      right: BorderSide.none,
                                                      top: BorderSide.none,
                                                    ),
                                                  ),
                                                ),
                                              ))),
                          )),
                    if (_selectedButton == 3 && days_difference <= 32)
                      Container(
                          height: 250,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: sales_index == 0
                                        ? LineChart(
                                            LineChartData(
                                              lineBarsData: [
                                                LineChartBarData(
                                                  showingIndicators:
                                                      showingTooltipOnSpots,
                                                  spots: spots3a,
                                                  isCurved: true,
                                                  barWidth: 3,
                                                  color: Colors.grey.shade400,
                                                  dotData: FlDotData(
                                                    show: true,
                                                    getDotPainter: (spot,
                                                        percent,
                                                        barData,
                                                        index) {
                                                      // Show custom dot and text for specific x-values

                                                      return FlDotCirclePainter(
                                                          radius: 2,
                                                          color: Colors.red,
                                                          strokeColor:
                                                              Colors.green);
                                                      /*    if (_selectedButton == 1) {
                                            return CustomDotPainter(
                                                yValue: spot.y,
                                                maxY: maxY.toDouble(),
                                                chartHeight: 120,
                                                xValue: spot.x,
                                                maxX: 30,
                                                chartWidth:
                                                    MediaQuery.of(context).size.width +
                                                        45);
                                          } else {
                                            return CustomDotPainter(
                                                yValue: spot.y,
                                                maxY: maxY.toDouble(),
                                                chartHeight: 120,
                                                xValue: spot.x,
                                                maxX: 12,
                                                chartWidth:
                                                    MediaQuery.of(context).size.width +
                                                        45);
                                          }*/
                                                    },
                                                  ),
                                                ),
                                              ],
                                              gridData: FlGridData(
                                                show: true,
                                                drawVerticalLine: false,
                                                getDrawingHorizontalLine:
                                                    (value) {
                                                  return FlLine(
                                                    color: Colors.grey
                                                        .withOpacity(0.10),
                                                    strokeWidth: 1,
                                                  );
                                                },
                                                getDrawingVerticalLine:
                                                    (value) {
                                                  return FlLine(
                                                    color: Colors.grey,
                                                    strokeWidth: 1,
                                                  );
                                                },
                                              ),
                                              titlesData: FlTitlesData(
                                                bottomTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: true,
                                                    interval: 1,
                                                    getTitlesWidget:
                                                        (value, meta) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: Text(
                                                          value
                                                              .toInt()
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 7),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  axisNameWidget: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 0.0),
                                                    child: Text(
                                                      'Days of the Month',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                topTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: false,
                                                    getTitlesWidget:
                                                        (value, meta) {
                                                      return Text(value
                                                          .toInt()
                                                          .toString());
                                                    },
                                                  ),
                                                ),
                                                rightTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: false,
                                                    getTitlesWidget:
                                                        (value, meta) {
                                                      return Text(value
                                                          .toInt()
                                                          .toString());
                                                    },
                                                  ),
                                                ),
                                                leftTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: true,
                                                    reservedSize: 20,
                                                    getTitlesWidget:
                                                        (value, meta) {
                                                      return Text(
                                                        formatLargeNumber2(value
                                                            .toInt()
                                                            .toString()),
                                                        style: TextStyle(
                                                            fontSize: 7.5),
                                                      );
                                                    },
                                                  ),
                                                  /*axisNameWidget: Padding(
                                                  padding:
                                                      const EdgeInsets.only(top: 0.0),
                                                  child: Text(
                                                    'Sales',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                ),*/
                                                ),
                                              ),
                                              minY: 0,
                                              maxY: maxY3.toDouble(),
                                              borderData: FlBorderData(
                                                show: true,
                                                border: Border(
                                                  left: BorderSide.none,
                                                  bottom: BorderSide(
                                                    color: Colors.grey
                                                        .withOpacity(0.35),
                                                    width: 1,
                                                  ),
                                                  right: BorderSide.none,
                                                  top: BorderSide.none,
                                                ),
                                              ),
                                            ),
                                          )
                                        : sales_index == 1
                                            ? LineChart(
                                                LineChartData(
                                                  lineBarsData: [
                                                    LineChartBarData(
                                                      showingIndicators:
                                                          showingTooltipOnSpots,
                                                      spots: spots3b,
                                                      isCurved: true,
                                                      barWidth: 3,
                                                      color:
                                                          Colors.grey.shade400,
                                                      dotData: FlDotData(
                                                        show: true,
                                                        getDotPainter: (spot,
                                                            percent,
                                                            barData,
                                                            index) {
                                                          // Show custom dot and text for specific x-values

                                                          return FlDotCirclePainter(
                                                              radius: 2,
                                                              color: Colors.red,
                                                              strokeColor:
                                                                  Colors.green);
                                                          /*    if (_selectedButton == 1) {
                                            return CustomDotPainter(
                                                yValue: spot.y,
                                                maxY: maxY.toDouble(),
                                                chartHeight: 120,
                                                xValue: spot.x,
                                                maxX: 30,
                                                chartWidth:
                                                    MediaQuery.of(context).size.width +
                                                        45);
                                          } else {
                                            return CustomDotPainter(
                                                yValue: spot.y,
                                                maxY: maxY.toDouble(),
                                                chartHeight: 120,
                                                xValue: spot.x,
                                                maxX: 12,
                                                chartWidth:
                                                    MediaQuery.of(context).size.width +
                                                        45);
                                          }*/
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                  gridData: FlGridData(
                                                    show: true,
                                                    drawVerticalLine: false,
                                                    getDrawingHorizontalLine:
                                                        (value) {
                                                      return FlLine(
                                                        color: Colors.grey
                                                            .withOpacity(0.10),
                                                        strokeWidth: 1,
                                                      );
                                                    },
                                                    getDrawingVerticalLine:
                                                        (value) {
                                                      return FlLine(
                                                        color: Colors.grey,
                                                        strokeWidth: 1,
                                                      );
                                                    },
                                                  ),
                                                  titlesData: FlTitlesData(
                                                    bottomTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: true,
                                                        interval: 1,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            child: Text(
                                                              value
                                                                  .toInt()
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 7),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      axisNameWidget: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 0.0),
                                                        child: Text(
                                                          'Days of the Month',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                    topTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: false,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          return Text(value
                                                              .toInt()
                                                              .toString());
                                                        },
                                                      ),
                                                    ),
                                                    rightTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: false,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          return Text(value
                                                              .toInt()
                                                              .toString());
                                                        },
                                                      ),
                                                    ),
                                                    leftTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: true,
                                                        reservedSize: 20,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          return Text(
                                                            formatLargeNumber2(
                                                                value
                                                                    .toInt()
                                                                    .toString()),
                                                            style: TextStyle(
                                                                fontSize: 7.5),
                                                          );
                                                        },
                                                      ),
                                                      /*axisNameWidget: Padding(
                                                  padding:
                                                      const EdgeInsets.only(top: 0.0),
                                                  child: Text(
                                                    'Sales',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                ),*/
                                                    ),
                                                  ),
                                                  minY: 0,
                                                  maxY: maxY3.toDouble(),
                                                  borderData: FlBorderData(
                                                    show: true,
                                                    border: Border(
                                                      left: BorderSide.none,
                                                      bottom: BorderSide(
                                                        color: Colors.grey
                                                            .withOpacity(0.35),
                                                        width: 1,
                                                      ),
                                                      right: BorderSide.none,
                                                      top: BorderSide.none,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : LineChart(
                                                LineChartData(
                                                  lineBarsData: [
                                                    LineChartBarData(
                                                      showingIndicators:
                                                          showingTooltipOnSpots,
                                                      spots: spots3c,
                                                      isCurved: true,
                                                      barWidth: 3,
                                                      color:
                                                          Colors.grey.shade400,
                                                      dotData: FlDotData(
                                                        show: true,
                                                        getDotPainter: (spot,
                                                            percent,
                                                            barData,
                                                            index) {
                                                          // Show custom dot and text for specific x-values

                                                          return FlDotCirclePainter(
                                                              radius: 2,
                                                              color: Colors.red,
                                                              strokeColor:
                                                                  Colors.green);
                                                          /*    if (_selectedButton == 1) {
                                            return CustomDotPainter(
                                                yValue: spot.y,
                                                maxY: maxY.toDouble(),
                                                chartHeight: 120,
                                                xValue: spot.x,
                                                maxX: 30,
                                                chartWidth:
                                                    MediaQuery.of(context).size.width +
                                                        45);
                                          } else {
                                            return CustomDotPainter(
                                                yValue: spot.y,
                                                maxY: maxY.toDouble(),
                                                chartHeight: 120,
                                                xValue: spot.x,
                                                maxX: 12,
                                                chartWidth:
                                                    MediaQuery.of(context).size.width +
                                                        45);
                                          }*/
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                  gridData: FlGridData(
                                                    show: true,
                                                    drawVerticalLine: false,
                                                    getDrawingHorizontalLine:
                                                        (value) {
                                                      return FlLine(
                                                        color: Colors.grey
                                                            .withOpacity(0.10),
                                                        strokeWidth: 1,
                                                      );
                                                    },
                                                    getDrawingVerticalLine:
                                                        (value) {
                                                      return FlLine(
                                                        color: Colors.grey,
                                                        strokeWidth: 1,
                                                      );
                                                    },
                                                  ),
                                                  titlesData: FlTitlesData(
                                                    bottomTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: true,
                                                        interval: 1,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            child: Text(
                                                              value
                                                                  .toInt()
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 7),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      axisNameWidget: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 0.0),
                                                        child: Text(
                                                          'Days of the Month',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                    topTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: false,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          return Text(value
                                                              .toInt()
                                                              .toString());
                                                        },
                                                      ),
                                                    ),
                                                    rightTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: false,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          return Text(value
                                                              .toInt()
                                                              .toString());
                                                        },
                                                      ),
                                                    ),
                                                    leftTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: true,
                                                        reservedSize: 20,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          return Text(
                                                            formatLargeNumber2(
                                                                value
                                                                    .toInt()
                                                                    .toString()),
                                                            style: TextStyle(
                                                                fontSize: 7.5),
                                                          );
                                                        },
                                                      ),
                                                      /*axisNameWidget: Padding(
                                                  padding:
                                                      const EdgeInsets.only(top: 0.0),
                                                  child: Text(
                                                    'Sales',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                ),*/
                                                    ),
                                                  ),
                                                  minY: 0,
                                                  maxY: maxY3.toDouble(),
                                                  borderData: FlBorderData(
                                                    show: true,
                                                    border: Border(
                                                      left: BorderSide.none,
                                                      bottom: BorderSide(
                                                        color: Colors.grey
                                                            .withOpacity(0.35),
                                                        width: 1,
                                                      ),
                                                      right: BorderSide.none,
                                                      top: BorderSide.none,
                                                    ),
                                                  ),
                                                ),
                                              ))),
                          )),
                    if (_selectedButton == 3 && days_difference > 32)
                      Container(
                          height: 250,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: sales_index == 0
                                        ? LineChart(
                                            LineChartData(
                                              lineBarsData: [
                                                LineChartBarData(
                                                  showingIndicators:
                                                      showingTooltipOnSpots,
                                                  spots: spots4a,
                                                  isCurved: false,
                                                  barWidth: 3,
                                                  color: Colors.grey.shade400,
                                                  dotData: FlDotData(
                                                    show: true,
                                                    getDotPainter: (spot,
                                                        percent,
                                                        barData,
                                                        index) {
                                                      // Show custom dot and text for specific x-values

                                                      return FlDotCirclePainter(
                                                          radius: 2,
                                                          color: Colors.red,
                                                          strokeColor:
                                                              Colors.green);
                                                      /*    if (_selectedButton == 1) {
                                            return CustomDotPainter(
                                                yValue: spot.y,
                                                maxY: maxY.toDouble(),
                                                chartHeight: 120,
                                                xValue: spot.x,
                                                maxX: 30,
                                                chartWidth:
                                                    MediaQuery.of(context).size.width +
                                                        45);
                                          } else {
                                            return CustomDotPainter(
                                                yValue: spot.y,
                                                maxY: maxY.toDouble(),
                                                chartHeight: 120,
                                                xValue: spot.x,
                                                maxX: 12,
                                                chartWidth:
                                                    MediaQuery.of(context).size.width +
                                                        45);
                                          }*/
                                                    },
                                                  ),
                                                ),
                                              ],
                                              gridData: FlGridData(
                                                show: true,
                                                drawVerticalLine: false,
                                                getDrawingHorizontalLine:
                                                    (value) {
                                                  return FlLine(
                                                    color: Colors.grey
                                                        .withOpacity(0.10),
                                                    strokeWidth: 1,
                                                  );
                                                },
                                                getDrawingVerticalLine:
                                                    (value) {
                                                  return FlLine(
                                                    color: Colors.grey,
                                                    strokeWidth: 1,
                                                  );
                                                },
                                              ),
                                              titlesData: FlTitlesData(
                                                bottomTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: true,
                                                    interval: 1,
                                                    getTitlesWidget:
                                                        (value, meta) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: Text(
                                                          getMonthAbbreviation(
                                                              value.toInt()),
                                                          style: TextStyle(
                                                              fontSize: 10),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  axisNameWidget: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 0.0),
                                                    child: Text(
                                                      'Months of the Year',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                topTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: false,
                                                    getTitlesWidget:
                                                        (value, meta) {
                                                      return Text(value
                                                          .toInt()
                                                          .toString());
                                                    },
                                                  ),
                                                ),
                                                rightTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: false,
                                                    getTitlesWidget:
                                                        (value, meta) {
                                                      return Text(value
                                                          .toInt()
                                                          .toString());
                                                    },
                                                  ),
                                                ),
                                                leftTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: true,
                                                    reservedSize: 20,
                                                    getTitlesWidget:
                                                        (value, meta) {
                                                      return Text(
                                                        formatLargeNumber2(value
                                                            .toInt()
                                                            .toString()),
                                                        style: TextStyle(
                                                            fontSize: 8),
                                                      );
                                                    },
                                                  ),
                                                  /* axisNameWidget: Padding(
                                                  padding:
                                                      const EdgeInsets.only(top: 0.0),
                                                  child: Text(
                                                    'Sales',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                ),*/
                                                ),
                                              ),
                                              minY: 0,
                                              maxY: maxY4.toDouble(),
                                              borderData: FlBorderData(
                                                show: true,
                                                border: Border(
                                                  left: BorderSide.none,
                                                  bottom: BorderSide(
                                                    color: Colors.grey
                                                        .withOpacity(0.35),
                                                    width: 1,
                                                  ),
                                                  right: BorderSide.none,
                                                  top: BorderSide.none,
                                                ),
                                              ),
                                            ),
                                          )
                                        : sales_index == 1
                                            ? LineChart(
                                                LineChartData(
                                                  lineBarsData: [
                                                    LineChartBarData(
                                                      showingIndicators:
                                                          showingTooltipOnSpots,
                                                      spots: spots4b,
                                                      isCurved: false,
                                                      barWidth: 3,
                                                      color:
                                                          Colors.grey.shade400,
                                                      dotData: FlDotData(
                                                        show: true,
                                                        getDotPainter: (spot,
                                                            percent,
                                                            barData,
                                                            index) {
                                                          // Show custom dot and text for specific x-values

                                                          return FlDotCirclePainter(
                                                              radius: 2,
                                                              color: Colors.red,
                                                              strokeColor:
                                                                  Colors.green);
                                                          /*    if (_selectedButton == 1) {
                                            return CustomDotPainter(
                                                yValue: spot.y,
                                                maxY: maxY.toDouble(),
                                                chartHeight: 120,
                                                xValue: spot.x,
                                                maxX: 30,
                                                chartWidth:
                                                    MediaQuery.of(context).size.width +
                                                        45);
                                          } else {
                                            return CustomDotPainter(
                                                yValue: spot.y,
                                                maxY: maxY.toDouble(),
                                                chartHeight: 120,
                                                xValue: spot.x,
                                                maxX: 12,
                                                chartWidth:
                                                    MediaQuery.of(context).size.width +
                                                        45);
                                          }*/
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                  gridData: FlGridData(
                                                    show: true,
                                                    drawVerticalLine: false,
                                                    getDrawingHorizontalLine:
                                                        (value) {
                                                      return FlLine(
                                                        color: Colors.grey
                                                            .withOpacity(0.10),
                                                        strokeWidth: 1,
                                                      );
                                                    },
                                                    getDrawingVerticalLine:
                                                        (value) {
                                                      return FlLine(
                                                        color: Colors.grey,
                                                        strokeWidth: 1,
                                                      );
                                                    },
                                                  ),
                                                  titlesData: FlTitlesData(
                                                    bottomTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: true,
                                                        interval: 1,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            child: Text(
                                                              getMonthAbbreviation(
                                                                  value
                                                                      .toInt()),
                                                              style: TextStyle(
                                                                  fontSize: 10),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      axisNameWidget: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 0.0),
                                                        child: Text(
                                                          'Months of the Year',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                    topTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: false,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          return Text(value
                                                              .toInt()
                                                              .toString());
                                                        },
                                                      ),
                                                    ),
                                                    rightTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: false,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          return Text(value
                                                              .toInt()
                                                              .toString());
                                                        },
                                                      ),
                                                    ),
                                                    leftTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: true,
                                                        reservedSize: 20,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          return Text(
                                                            formatLargeNumber2(
                                                                value
                                                                    .toInt()
                                                                    .toString()),
                                                            style: TextStyle(
                                                                fontSize: 8),
                                                          );
                                                        },
                                                      ),
                                                      /* axisNameWidget: Padding(
                                                  padding:
                                                      const EdgeInsets.only(top: 0.0),
                                                  child: Text(
                                                    'Sales',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                ),*/
                                                    ),
                                                  ),
                                                  minY: 0,
                                                  maxY: maxY4.toDouble(),
                                                  borderData: FlBorderData(
                                                    show: true,
                                                    border: Border(
                                                      left: BorderSide.none,
                                                      bottom: BorderSide(
                                                        color: Colors.grey
                                                            .withOpacity(0.35),
                                                        width: 1,
                                                      ),
                                                      right: BorderSide.none,
                                                      top: BorderSide.none,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : LineChart(
                                                LineChartData(
                                                  lineBarsData: [
                                                    LineChartBarData(
                                                      showingIndicators:
                                                          showingTooltipOnSpots,
                                                      spots: spots4c,
                                                      isCurved: true,
                                                      barWidth: 3,
                                                      color:
                                                          Colors.grey.shade400,
                                                      dotData: FlDotData(
                                                        show: true,
                                                        getDotPainter: (spot,
                                                            percent,
                                                            barData,
                                                            index) {
                                                          // Show custom dot and text for specific x-values

                                                          return FlDotCirclePainter(
                                                              radius: 2,
                                                              color: Colors.red,
                                                              strokeColor:
                                                                  Colors.green);
                                                          /*    if (_selectedButton == 1) {
                                            return CustomDotPainter(
                                                yValue: spot.y,
                                                maxY: maxY.toDouble(),
                                                chartHeight: 120,
                                                xValue: spot.x,
                                                maxX: 30,
                                                chartWidth:
                                                    MediaQuery.of(context).size.width +
                                                        45);
                                          } else {
                                            return CustomDotPainter(
                                                yValue: spot.y,
                                                maxY: maxY.toDouble(),
                                                chartHeight: 120,
                                                xValue: spot.x,
                                                maxX: 12,
                                                chartWidth:
                                                    MediaQuery.of(context).size.width +
                                                        45);
                                          }*/
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                  gridData: FlGridData(
                                                    show: true,
                                                    drawVerticalLine: false,
                                                    getDrawingHorizontalLine:
                                                        (value) {
                                                      return FlLine(
                                                        color: Colors.grey
                                                            .withOpacity(0.10),
                                                        strokeWidth: 1,
                                                      );
                                                    },
                                                    getDrawingVerticalLine:
                                                        (value) {
                                                      return FlLine(
                                                        color: Colors.grey,
                                                        strokeWidth: 1,
                                                      );
                                                    },
                                                  ),
                                                  titlesData: FlTitlesData(
                                                    bottomTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: true,
                                                        interval: 1,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            child: Text(
                                                              getMonthAbbreviation(
                                                                  value
                                                                      .toInt()),
                                                              style: TextStyle(
                                                                  fontSize: 10),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      axisNameWidget: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 0.0),
                                                        child: Text(
                                                          'Months of the Year',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                    topTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: false,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          return Text(value
                                                              .toInt()
                                                              .toString());
                                                        },
                                                      ),
                                                    ),
                                                    rightTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: false,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          return Text(value
                                                              .toInt()
                                                              .toString());
                                                        },
                                                      ),
                                                    ),
                                                    leftTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: true,
                                                        reservedSize: 20,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          return Text(
                                                            formatLargeNumber2(
                                                                value
                                                                    .toInt()
                                                                    .toString()),
                                                            style: TextStyle(
                                                                fontSize: 8),
                                                          );
                                                        },
                                                      ),
                                                      /* axisNameWidget: Padding(
                                                  padding:
                                                      const EdgeInsets.only(top: 0.0),
                                                  child: Text(
                                                    'Sales',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                ),*/
                                                    ),
                                                  ),
                                                  minY: 0,
                                                  maxY: maxY4.toDouble(),
                                                  borderData: FlBorderData(
                                                    show: true,
                                                    border: Border(
                                                      left: BorderSide.none,
                                                      bottom: BorderSide(
                                                        color: Colors.grey
                                                            .withOpacity(0.35),
                                                        width: 1,
                                                      ),
                                                      right: BorderSide.none,
                                                      top: BorderSide.none,
                                                    ),
                                                  ),
                                                ),
                                              ))),
                          )),

                    _selectedButton == 1
                        ? Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 12),
                            child: Text(
                                "Top 10 Sales Agents (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                          )
                        : _selectedButton == 2
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 16.0, top: 12),
                                child: Text(
                                    "Top 10 Sales By Agent (YTD - ${DateTime.now().year})"),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.only(left: 16.0, top: 12),
                                child: Text(
                                    "Top 10 Sales By Agent (${formattedStartDate} to ${formattedEndDate})"),
                              ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                            child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.35),
                                  borderRadius: BorderRadius.circular(36)),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 45,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 0.0),
                                        child: Text("#"),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 4,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 0.0),
                                          child: Text("Agent Name"),
                                        )),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                  "Sales",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            _selectedButton == 1
                                ? Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: ListView.builder(
                                        itemCount: salesbyagent_mtd.length > 10
                                            ? 10
                                            : salesbyagent_mtd.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 45,
                                                        child: Text(
                                                            "${index + 1} "),
                                                      ),
                                                      Expanded(
                                                          flex: 4,
                                                          child: Text(
                                                              "${salesbyagent_mtd[index].agent_name}")),
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Center(
                                                                child: Text(
                                                                  "${salesbyagent_mtd[index].sales.toInt()}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Container(
                                                      height: 1,
                                                      color: Colors.grey
                                                          .withOpacity(0.10),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  )
                                : _selectedButton == 2
                                    ? Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: ListView.builder(
                                            itemCount:
                                                salesbyagent_ytd.length > 10
                                                    ? 10
                                                    : salesbyagent_ytd.length,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Container(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 45,
                                                            child: Text(
                                                                "${index + 1} "),
                                                          ),
                                                          Expanded(
                                                              flex: 4,
                                                              child: Text(
                                                                  "${salesbyagent_ytd[index].agent_name}")),
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Center(
                                                                    child: Text(
                                                                      "${salesbyagent_ytd[index].sales.toInt()}",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Container(
                                                          height: 1,
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.10),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: ListView.builder(
                                            itemCount:
                                                salesbyagent_mtd.length > 10
                                                    ? 10
                                                    : salesbyagent_mtd.length,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Container(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 45,
                                                            child: Text(
                                                                "${index + 1} "),
                                                          ),
                                                          Expanded(
                                                              flex: 4,
                                                              child: Text(
                                                                  "${salesbyagent_mtd[index].agent_name}")),
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Center(
                                                                    child: Text(
                                                                      "${salesbyagent_mtd[index].sales.toInt()}",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Container(
                                                          height: 1,
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.10),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                          ],
                        )),
                      ),
                    ),
                    _selectedButton == 1
                        ? Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 12),
                            child: Text(
                                "All Sales By Branch (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                          )
                        : _selectedButton == 2
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 16.0, top: 12),
                                child: Text(
                                    "All Sales By Branch (YTD - ${DateTime.now().year})"),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.only(left: 16.0, top: 12),
                                child: Text(
                                    "All Sales By Branch (${formattedStartDate} to ${formattedEndDate})"),
                              ),
                    //Text("$maxY"),
                    _selectedButton == 1
                        ? _sales_by_branch_mtd
                        : _selectedButton == 2
                            ? _sales_by_branch_ytd
                            : _sales_by_branch_mtda,
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _sales_by_branch_mtd = Container(
      height: 200,
      child: Center(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              color: Constants.ctaColorLight,
              strokeWidth: 1.8,
            ),
          ),
        ),
      )),
    );
    _sales_by_branch_mtda = Container(
      height: 200,
      child: Center(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              color: Constants.ctaColorLight,
              strokeWidth: 1.8,
            ),
          ),
        ),
      )),
    );
    _sales_by_branch_ytd = Container(
      height: 200,
      child: Center(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              color: Constants.ctaColorLight,
              strokeWidth: 1.8,
            ),
          ),
        ),
      )),
    );
    setState(() {});
    getSalesDate();

    Future.delayed(Duration(seconds: 2)).then((value) {
      setState(() {});
    });
    DateTime now = DateTime.now();
    DateTime startDate = DateTime(now.year, now.month, 1);
    DateTime endDate = DateTime.now();

    // _animateButton(1);
    sectionsList = [
      /* salesgridmodel("Total", 0),
      salesgridmodel("New", 0),
      salesgridmodel("Updated", 0),
      salesgridmodel("Incepted", 0),
      salesgridmodel("Pending Inforce", 0),
      salesgridmodel("Inforced", 0),
      salesgridmodel("Failed", 0),
      salesgridmodel("Not Accepted", 0),*/

      salesgridmodel("All Sales", 0),
      salesgridmodel("Inforced Sales", 0),
      salesgridmodel("Not Accepted", 0),
    ];
    leads = [];
    // getSalesReport(context, formattedStartDate, formattedEndDate);

    super.initState();
  }

  Future<void> getSalesDate() async {
    String baseUrl =
        "${Constants.insightsBackendBaseUrl}files/get_sales_report?cid=${Constants.cec_client_id}";
    String jsonData = '';
    salesbybranch_mtd = [];
    salesbybranch_ytd = [];
    ordinalList = [];
    bardata5 = [];
    bardata6 = [];

    if (kDebugMode) {
      print("baseUrl $baseUrl");
    }

    await http.get(
        Uri.parse(
          baseUrl,
        ),
        headers: {
          "Cookie":
              "userid=expiry=2021-04-25&client_modules=1001#1002#1003#1004#1005#1006#1007#1008#1009#1010#1011#1012#1013#1014#1015#1017#1018#1020#1021#1022#1024#1025#1026#1027#1028#1029#1030#1031#1032#1033#1034#1035&clientid=&empid=3&empfirstname=Mncedisi&emplastname=Khumalo&email=mncedisi@athandwe.co.za&username=mncedisi@athandwe.co.za&dob=8/28/1985 12:00:00 AM&fullname=Mncedisi Khumalo&userRole=5&userImage=mncedisi@athandwe.co.za.jpg&employedAt=branch&role=leader&branchid=6&branchname=Boulders&jobtitle=Administrative Assistant&dialing_strategy=Campaign Manager&clientname=Test 1 Funeral Parlour&foldername=maafrica&client_abbr=AS&pbx_account=pbx1051ef0a&soft_phone_ip=&agent_type=branch&mip_username=mnces@mip.co.za&agent_email=Mr Mncedisi Khumalo&ViciDial_phone_login=&ViciDial_phone_password=&ViciDial_agent_user=99&ViciDial_agent_password=&device_id=dC7JwXFwwdI:APA91bF0gTbuXlfT6wIcGMLY57Xo7VxUMrMH-MuFYL5PnjUVI0G5X1d3d90FNRb8-XmcjI40L1XqDH-KAc1KWnPpxNg8Z8SK4Ty0xonbz4L3sbKz3Rlr4hyBqePWx9ZfEp53vWwkZ3tx&servername=http://localhost:55661"
        }).then((value) {
      http.Response response = value;
      if (kDebugMode) {
        //print(response.bodyBytes);
        //print(response.statusCode);
        //print(response.body);
        //print(response.body);
      }
      if (response.statusCode != 200) {
        setState(() {
          isLoading = false; // Stop loading when request is complete
        });
        Fluttertoast.showToast(
            msg: "Error loading data,please refresh",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.ctaColorLight,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        jsonData = response.body;
      }
    });

    print("datafg0 ${jsonData}");
    // Parse JSON data
    List<dynamic> data = jsonDecode(jsonData);
    print("datafg1 ${data}");

    // Get current month and year
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;
    int currentDay = now.day;

    // Calculate MTD sales
    var mtdSales =
        calculateMtdSales(data, currentYear, currentMonth, currentDay);
    calculateYtdSales(data, currentYear, currentMonth, currentDay);

    // Print results
    print('MTD Sales: $mtdSales');
  }

  Map<String, int> calculateMtdSales(
      List<dynamic> data, int year, int month, int currentDay) {
    num totalInforced = 0;
    maxY7 = 0;
    num totalNotAccepted = 0;
    allsales_mtd = 0;
    allsales_ytd = 0;
    allsales_custom = 0;
    ordinary_sales_mtd = [];

    inforced_mtd = 0;
    inforced_ytd = 0;
    inforced_custom = 0;

    not_accepted_mtd = 0;
    not_accepted_ytd = 0;
    not_accepted_custom = 0;
    Map<String, Map<String, int>> dailyData = {};
    Map<String, Map<String, int>> totalByAgentMTD = {};
    Map<String, Map<String, int>> totalByBranchMTD = {};
    salesbyagent_mtd = [];

    var yearData = data.firstWhere((y) => y.containsKey(year.toString()),
        orElse: () => null);
    if (yearData != null) {
      var monthsData = yearData[year.toString()] as List;

      var monthData = monthsData.firstWhere(
          (m) => m.containsKey(month.toString()),
          orElse: () => null);

      if (monthData != null) {
        var daysData = monthData[month.toString()] as List;

        for (var dayData in daysData) {
          String dayKey = dayData.keys.first;

          if (int.parse(dayKey) <= currentDay) {
            var branchDataList = dayData[dayKey] as List;

            for (var branchData in branchDataList) {
              var employeeDataList = branchData.values.first as List;

              for (var employeeData in employeeDataList) {
                var salesData = employeeData.values.first;
                if (kDebugMode) {
                  print("salesData $salesData");
                }
                for (Map item in salesData) {
                  if (item['inforced'] != null) {
                    totalInforced += item['inforced'];
                  }
                  if (item['not_accepted'] != null) {
                    totalNotAccepted += item['not_accepted'];
                  }
                }
              }
              for (var branchData in branchDataList) {
                var employeeDataList = branchData.values.first as List;

                for (var employeeData in employeeDataList) {
                  String agentName = employeeData.keys
                      .first; // Assuming each employee data has agent name as key
                  var salesData = employeeData[
                      agentName]; // This is the list of sales data for each agent

                  for (Map item in salesData) {
                    var inforced = item['inforced'] ?? 0;
                    var notAccepted = item['not_accepted'] ?? 0;

                    if (!totalByAgentMTD.containsKey(agentName)) {
                      totalByAgentMTD[agentName] = {
                        'inforced': inforced,
                        'not_accepted': notAccepted
                      };
                    } else {
                      totalByAgentMTD[agentName]!['inforced'] =
                          totalByAgentMTD[agentName]!['inforced']! + inforced!
                              as int;
                      totalByAgentMTD[agentName]!['not_accepted'] =
                          totalByAgentMTD[agentName]!['not_accepted']! +
                              notAccepted as int;
                    }
                  }
                }
              }
            }
            for (var branchData in branchDataList) {
              String branchId =
                  branchData.keys.first; // Assuming the branch ID is the key
              var employeeDataList = branchData[branchId] as List;

              for (var employeeData in employeeDataList) {
                var salesData = employeeData.values.first;

                for (Map item in salesData) {
                  var inforced = item['inforced'] ?? 0;
                  var notAccepted = item['not_accepted'] ?? 0;

                  if (!totalByBranchMTD.containsKey(branchId)) {
                    totalByBranchMTD[branchId] = {
                      'inforced': inforced,
                      'not_accepted': notAccepted
                    };
                  } else {
                    totalByBranchMTD[branchId]!['inforced'] =
                        totalByBranchMTD[branchId]!['inforced']! + inforced
                            as int;
                    totalByBranchMTD[branchId]!['not_accepted'] =
                        totalByBranchMTD[branchId]!['not_accepted']! +
                            notAccepted as int;
                  }
                }
              }
            }
          }
          spots1a.add(FlSpot(double.parse(dayKey),
              double.parse((totalInforced + totalNotAccepted).toString())));
          if (double.parse((totalInforced + totalNotAccepted).toString()) >
              maxY) {
            maxY = int.parse((totalInforced + totalNotAccepted).toString());
          }
          spots1b.add(FlSpot(
              double.parse(dayKey), double.parse(totalInforced.toString())));

          spots1c.add(FlSpot(
              double.parse(dayKey), double.parse(totalNotAccepted.toString())));

          dailyData[dayKey] = {
            'inforced': totalInforced.toInt(),
            'not_accepted': totalNotAccepted.toInt()
          };
        }
      }
    }

    Map<int, int> totalByAgent_result = {};
    totalByAgentMTD.forEach((key, value) {
      if (value.containsKey('inforced')) {
        print("hhjh $key");
        totalByAgent_result.update(int.parse(key),
            (existingValue) => existingValue + value['inforced']!,
            ifAbsent: () => value['inforced']!);
      }
    });
    totalByAgent_result.forEach((key, value) {
      salesbyagent_mtd.add(SalesByAgent(getEmployeeById(key), value));
    });
    salesbyagent_mtd.sort((a, b) => b.sales.compareTo(a.sales));

    Map<int, int> totalByBranch_result = {};
    int id_y = 1;
    print("totalByBranch $totalByBranchMTD");
    totalByBranchMTD.forEach((key, value) {
      print("hhjh ${getBranchById(int.parse(key))} ${value['inforced']}");

      if (value.containsKey('inforced')) {
        if (value['inforced'] != null) {
          totalByBranch_result.update(int.parse(key),
              (existingValue) => existingValue + value['inforced']!,
              ifAbsent: () => value['inforced']!);
        }
      }
    });
    totalByBranch_result.forEach((key, value) {
      String branchname = getBranchById(key);
      salesbybranch_mtd.add(SalesByBranch(branchname, value));
      bottomTitles1.add(branchname);
      if (maxY7 < value) {
        maxY7 = value.round();
        print("maxY7 $maxY7");
        setState(() {});
      }
      print("branchname $branchname $value");

      ordinary_sales_mtd.add(OrdinalSales(branchname, value));
    });
    salesbybranch_mtd.sort((a, b) => b.sales.compareTo(a.sales));
    salesbyagent_mtd.sort((a, b) => b.sales.compareTo(a.sales));
    ordinary_sales_mtd.sort((a, b) => b.sales.compareTo(a.sales));
    print("ordinary_sales $ordinary_sales_mtd");

    allsales_mtd = int.parse((totalInforced + totalNotAccepted).toString());
    inforced_mtd = int.parse((totalInforced).toString());
    not_accepted_mtd = int.parse((totalNotAccepted).toString());
    bardata5.add(charts.Series<OrdinalSales, String>(
        id: 'BranchSales',
        domainFn: (OrdinalSales sale, _) => sale.branch,
        measureFn: (OrdinalSales sale, _) => sale.sales,
        data: ordinary_sales_mtd,
        // Set a label accessor to control the text of the bar label.
        labelAccessorFn: (OrdinalSales sale, _) => '${sale.sales}'));
    _sales_by_branch_mtd = Container(
      height: salesbybranch_mtd.length * 35,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: charts.BarChart(
              bardata5,
              animate: false,
              vertical: false,
              barRendererDecorator: new charts.BarLabelDecorator<String>(),
              primaryMeasureAxis: new charts.NumericAxisSpec(
                renderSpec: new charts.NoneRenderSpec(),
                viewport: new charts.NumericExtents(0, maxY7),
              ),
              domainAxis: new charts.OrdinalAxisSpec(
                renderSpec: new charts.SmallTickRendererSpec(
                  labelStyle: new charts.TextStyleSpec(
                    fontSize: 10,
                    color: charts.MaterialPalette.black,
                  ),
                  lineStyle: new charts.LineStyleSpec(
                    color: charts.MaterialPalette.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    setState(() {});

    return {
      'inforced': totalInforced.toInt(),
      'not_accepted': totalNotAccepted.toInt()
    };
  }

  Map<String, int> calculateYtdSales(
      List<dynamic> data, int year, int month, int currentDay) {
    num totalInforcedYTD = 0;
    num totalNotAcceptedYTD = 0;
    salesbyagent_ytd = [];
    ordinary_sales_ytd = [];
    maxY8 = 0;
    allsales_ytd = 0;
    inforced_ytd = 0;
    not_accepted_ytd = 0;
    Map<String, Map<String, int>> totalByAgentYTD = {};
    Map<String, Map<String, int>> totalByBranchYTD = {};

    var yearData = data.firstWhere((y) => y.containsKey(year.toString()),
        orElse: () => null);
    if (yearData != null) {
      var monthsData = yearData[year.toString()] as List;
      for (int monthIndex1 = 1; monthIndex1 <= 12; monthIndex1++) {
        if (monthIndex1 < monthsData.length) {
          var monthData = monthsData[monthIndex1];
          int monthlyTotal = 0;
          var daysData = monthData[monthIndex1.toString()] ?? [] as List;
          for (var dayData in daysData) {
            var branchDataList = dayData.values.first as List;
            for (var branchData in branchDataList) {
              var employeeDataList = branchData.values.first as List;
              for (var employeeData in employeeDataList) {
                var salesData = employeeData.values.first;
                for (Map item in salesData) {
                  if (item['inforced'] != null) {
                    monthlyTotal =
                        (monthlyTotal + item['inforced'] ?? 0) as int;
                  }
                  if (item['not_accepted'] != null) {
                    monthlyTotal =
                        (monthlyTotal + item['not_accepted'] ?? 0) as int;
                  }
                }
              }
            }
          }
          spots2a.add(FlSpot(monthIndex1.toDouble(), monthlyTotal.toDouble()));

          if (monthlyTotal.toDouble() > maxY2) {
            maxY2 = int.parse((monthlyTotal.round()).toString());
          }
          if (kDebugMode) {
            print(
                "monthlyTotal ${monthIndex1.toDouble()} ${monthlyTotal.toDouble()}");
          }
        }
      }

      for (var monthIndex = 0; monthIndex <= month; monthIndex++) {
        var monthData = monthsData.firstWhere(
            (m) => m.containsKey(monthIndex.toString()),
            orElse: () => null);

        if (monthData != null) {
          var daysData = monthData[monthIndex.toString()] as List;

          for (var dayData in daysData) {
            String dayKey = dayData.keys.first;
            var branchDataList = dayData[dayKey] as List;

            for (var branchData in branchDataList) {
              var employeeDataList = branchData.values.first as List;

              for (var employeeData in employeeDataList) {
                var salesData = employeeData.values.first;
                for (Map item in salesData) {
                  if (item['inforced'] != null) {
                    totalInforcedYTD += item['inforced'];
                  }
                  if (item['not_accepted'] != null) {
                    totalNotAcceptedYTD += item['not_accepted'];
                  }

                  String agentName = employeeData.keys.first;
                  var inforced = item['inforced'] ?? 0;
                  var notAccepted = item['not_accepted'] ?? 0;

                  if (!totalByAgentYTD.containsKey(agentName)) {
                    totalByAgentYTD[agentName] = {
                      'inforced': inforced,
                      'not_accepted': notAccepted
                    };
                  } else {
                    totalByAgentYTD[agentName]!['inforced'] =
                        totalByAgentYTD[agentName]!['inforced']! + inforced
                            as int;
                    totalByAgentYTD[agentName]!['not_accepted'] =
                        totalByAgentYTD[agentName]!['not_accepted']! +
                            notAccepted as int;
                  }
                }
              }

              String branchId = branchData.keys.first;
              var employeeDataList1 = branchData[branchId] as List;

              for (var employeeData in employeeDataList1) {
                var salesData = employeeData.values.first;

                for (Map item in salesData) {
                  var inforced = item['inforced'] ?? 0;
                  var notAccepted = item['not_accepted'] ?? 0;

                  if (!totalByBranchYTD.containsKey(branchId)) {
                    totalByBranchYTD[branchId] = {
                      'inforced': inforced,
                      'not_accepted': notAccepted
                    };
                  } else {
                    totalByBranchYTD[branchId]!['inforced'] =
                        totalByBranchYTD[branchId]!['inforced']! + inforced
                            as int;
                    totalByBranchYTD[branchId]!['not_accepted'] =
                        totalByBranchYTD[branchId]!['not_accepted']! +
                            notAccepted as int;
                  }
                }
              }
            }
          }
        }
      }
    }

    inforced_ytd = totalInforcedYTD.toInt();
    not_accepted_ytd = totalNotAcceptedYTD.toInt();
    allsales_ytd = inforced_ytd + not_accepted_ytd;
    print("inforced_ytd $inforced_ytd");
    print("not_accepted_ytd $not_accepted_ytd");
    print("allsales_ytd $allsales_ytd");
    Map<int, int> totalByAgent_result = {};
    totalByAgentYTD.forEach((key, value) {
      if (value.containsKey('inforced')) {
        if (kDebugMode) {
          print("bmnmnb $key");
        }
        totalByAgent_result.update(int.parse(key),
            (existingValue) => existingValue + value['inforced']!,
            ifAbsent: () => value['inforced']!);
      }
    });
    totalByAgent_result.forEach((key, value) {
      salesbyagent_ytd.add(SalesByAgent(getEmployeeById(key), value));
    });
    salesbyagent_ytd.sort((a, b) => b.sales.compareTo(a.sales));

    Map<int, int> totalByBranch_result = {};
    int id_y = 1;
    print("totalByBranch $totalByBranchYTD");
    totalByBranchYTD.forEach((key, value) {
      print("hhjh ${getBranchById(int.parse(key))} ${value['inforced']}");

      if (value.containsKey('inforced')) {
        if (value['inforced'] != null) {
          totalByBranch_result.update(int.parse(key),
              (existingValue) => existingValue + value['inforced']!,
              ifAbsent: () => value['inforced']!);
        }
      }
    });
    totalByBranch_result.forEach((key, value) {
      String branchname = getBranchById(key);
      salesbybranch_ytd.add(SalesByBranch(branchname, value));
      bottomTitles1.add(branchname);
      if (maxY8 < value) {
        maxY8 = value.round();
        print("maxY8 $maxY8");
        setState(() {});
      }
      print("branchname $branchname $value");

      ordinary_sales_ytd.add(OrdinalSales(branchname, value));
    });
    salesbybranch_ytd.sort((a, b) => b.sales.compareTo(a.sales));
    salesbyagent_ytd.sort((a, b) => b.sales.compareTo(a.sales));
    ordinary_sales_ytd.sort((a, b) => b.sales.compareTo(a.sales));
    print("ordinary_sales $ordinary_sales_ytd");

    allsales_ytd =
        int.parse((totalInforcedYTD + totalNotAcceptedYTD).toString());
    inforced_ytd = int.parse((totalInforcedYTD).toString());
    not_accepted_ytd = int.parse((totalNotAcceptedYTD).toString());
    bardata6.add(charts.Series<OrdinalSales, String>(
        id: 'BranchSales',
        domainFn: (OrdinalSales sale, _) => sale.branch,
        measureFn: (OrdinalSales sale, _) => sale.sales,
        data: ordinary_sales_ytd,
        labelAccessorFn: (OrdinalSales sale, _) => '${sale.sales}'));
    _sales_by_branch_ytd = Container(
      height: salesbybranch_ytd.length * 35,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: charts.BarChart(
              bardata6,
              animate: false,
              vertical: false,
              // Set a bar label decorator.
              // Example configuring different styles for inside/outside:
              //       barRendererDecorator: new charts.BarLabelDecorator(
              //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
              //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
              barRendererDecorator: new charts.BarLabelDecorator<String>(),
              // Hide domain axis.
              /*          domainAxis: new charts.OrdinalAxisSpec(
                                  renderSpec: new charts.NoneRenderSpec()),*/
              primaryMeasureAxis: new charts.NumericAxisSpec(
                renderSpec: new charts.NoneRenderSpec(),
                viewport: new charts.NumericExtents(0, maxY8),
              ),
              domainAxis: new charts.OrdinalAxisSpec(
                renderSpec: new charts.SmallTickRendererSpec(
                  labelStyle: new charts.TextStyleSpec(
                    fontSize: 10,
                    color: charts.MaterialPalette.black,
                  ),
                  lineStyle: new charts.LineStyleSpec(
                    color: charts.MaterialPalette.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return {'inforced_ytd': inforced_ytd, 'not_accepted': not_accepted_ytd};
  }

  String _getMonthName(int monthNumber) {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[monthNumber - 1];
  }

  FlTitlesData getTitlesData(List<String> bottomTitles) {
    return FlTitlesData(
      show: true,
      topTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
          getTitlesWidget: (double value, TitleMeta meta) {
            int index = value.toInt();
            return SideTitleWidget(
              axisSide: meta.axisSide,
              space: 8.0,
              child: Text(
                salesbybranch_mtd[index - 1].branch_name,
                maxLines: 1,
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            );
          },
        ),
      ),
      leftTitles: const AxisTitles(
          sideTitles: SideTitles(
        showTitles: false,
      )),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          reservedSize: 100,
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            int index = value.toInt();
            return SideTitleWidget(
              axisSide: meta.axisSide,
              space: 8.0,
              child: RotatedBox(
                quarterTurns: -1,
                child: Text(
                  bottomTitles[index - 1],
                  maxLines: 2,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            );
          },
        ),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
          getTitlesWidget: (double value, TitleMeta meta) {
            return SideTitleWidget(
              axisSide: meta.axisSide,
              space: 6.0,
              child: RotatedBox(
                quarterTurns: -1,
                child: Text(
                  value.toInt().toString(),
                  style: TextStyle(color: Colors.black),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(360),
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w300,
                color: textColor,
              ),
            ),
          )
        ],
      ),
    );
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
    return "";
  } else
    return result;
}

class salesgridmodel {
  String id;
  int amount;
  salesgridmodel(
    this.id,
    this.amount,
  );
}

class CustomDotPainter extends FlDotPainter {
  final double yValue;
  final double xValue;
  final double maxX; // Maximum X-value of the chart
  final double maxY; // Maximum Y-value of the chart
  final double chartWidth; // Width of the chart
  final double chartHeight; // Height of the chart

  CustomDotPainter({
    required this.yValue,
    required this.xValue,
    required this.maxX,
    required this.maxY,
    required this.chartWidth,
    required this.chartHeight,
  });

  @override
  void paint(Canvas canvas, Size size, FlSpot spot, double xPercent,
      double yPercent, LineChartBarData bar, int index) {
    // Calculate the position based on chart dimensions and spot's value
    double xPosition = (xValue / maxX) * chartWidth;
    double yPosition = chartHeight - (yValue / maxY) * chartHeight;

    // Paint the dot
    final paint = Paint()..color = Constants.ctaColorLight;
    canvas.drawCircle(Offset(xPosition, yPosition), size.width / 2, paint);

    // Draw the text
    TextSpan span = TextSpan(
        style: TextStyle(color: Colors.black), text: yValue.round().toString());
    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: ui.TextDirection.ltr);
    tp.layout();

    // Adjust the position to paint the text
    double textX = xPosition - tp.width / 2;
    double textY = yPosition - tp.height - 10;

    // Paint the text
    tp.paint(canvas, Offset(textX, textY));
  }

  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    paint(canvas, getSize(spot), spot, 0, 0,
        LineChartBarData(color: Colors.blue), 0); // Example call
  }

  @override
  Size getSize(FlSpot spot) {
    // Return the size of your dot
    return const Size(12, 12); // Example size, adjust as needed
  }

  @override
  List<Object?> get props => [yValue];

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) {
    // TODO: implement lerp
    throw UnimplementedError();
  }

  @override
  // TODO: implement mainColor
  ui.Color get mainColor => throw UnimplementedError();
}

String formatWithCommas(double value) {
  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String mathFunc(Match match) => '${match[1]},';
  return value
      .toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)
      .replaceAllMapped(reg, mathFunc);
}

String formatLargeNumber(String valueStr) {
  const List<String> suffixes = [
    "",
    'K',
    'M',
    'B',
    'T'
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

  // If the value is less than 100000, return it as is with commas
  if (value < 100000) {
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

String formatLargeNumber2(String valueStr) {
  const List<String> suffixes = [
    "",
    'k',
    'M',
    'B',
    'T'
  ]; // Add more suffixes as needed

  // Convert string to double and handle invalid inputs
  double value;
  try {
    value = double.parse(valueStr);
  } catch (e) {
    return 'Invalid Number';
  }

  int index = 0;
  double newValue = value;

  while (newValue >= 1000 && index < suffixes.length - 1) {
    newValue /= 1000;
    index++;
  }

  return '${formatWithCommas(newValue)}${suffixes[index]}';
}

String getMonthAbbreviation(int monthNumber) {
  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  // Check if the month number is valid
  if (monthNumber < 1 || monthNumber > 12) {
    return "-";
  }

  // Return the corresponding month abbreviation
  return months[monthNumber - 1];
}

class OrdinalSales {
  final String branch;
  final int sales;

  OrdinalSales(this.branch, this.sales);
}
