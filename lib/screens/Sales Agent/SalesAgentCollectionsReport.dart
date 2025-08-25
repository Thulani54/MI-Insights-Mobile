import 'dart:async';
import 'dart:convert';
import 'dart:math';
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

import '../../../customwidgets/CustomCard.dart';
import '../../../customwidgets/custom_date_range_picker.dart';
import '../../../services/inactivitylogoutmixin.dart';
import '../../../services/window_manager.dart';

String jsonString = "";
List<BarChartGroupData> barChartData1 = [];
List<BarChartGroupData> barChartData2 = [];
List<BarChartGroupData> barChartData3 = [];
List<BarChartGroupData> barChartData4 = [];
Map<int, double> dailySalesCount1a = {};
bool isLoadingCollections = false;
bool isShowingType = false;
bool isShowingAPI = false;
List<SalesByBranch> salesbybranch = [];

DateTime datefrom = DateTime.now().subtract(Duration(days: 60));
DateTime dateto = DateTime.now();
int days_difference = 0;
List<gridmodel1> sectionsList = [];
List<gridmodel1> sectionsList2 = [];
int report_index = 0;
int sales_index = 0;
String data2 = "";
double maxY = 0;
double maxY2 = 0;
double maxY3 = 0;
double maxY4 = 0;
double maxY5 = 0;
double maxY6 = 0;

double actual_collected_premium = 0;
double expected_sum_of_premiums = 0;
double variance_sum_of_premiums = 0;
double sum_of_premiums = 0;
double sum_of_premiums2 = 0;
int expected_count_of_premiums = 0;
int count_of_premiums = 0;
int count_of_premiums2 = 0;
int variance_count_of_premiums = 0;
int touchedIndex = -1;
List<BarChartGroupData> barData = [];
List<String> bottomTitles1 = [];
String formattedStartDate = "";
String formattedEndDate = "";
List<charts.Series<dynamic, String>> seriesList = [];
List<charts.Series<OrdinalSales, String>> bardata5 = [];
Widget barsWidget = Container();
List<OrdinalSales> ordinary_sales = [];
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
  final double sales;
  SalesByBranch(this.branch_name, this.sales);
}

class SalesAgentCollectionsReport extends StatefulWidget {
  const SalesAgentCollectionsReport({Key? key}) : super(key: key);

  @override
  State<SalesAgentCollectionsReport> createState() =>
      _SalesAgentCollectionsReportState();
}

List<SalesByAgent> topsalesbyagent = [];
List<SalesByAgent> bottomsalesbyagent = [];
List<BarChartGroupData> collections_grouped_data = [];
List<Map<String, dynamic>> leads = [];
List<List<Map<String, dynamic>>> policies = [];
double _sliderPosition = 0.0; // Initial position for the sliding animation
int _selectedButton = 1;
Color dark = Constants.ctaColorLight;
Color normal = Colors.blue;
List<BarChartRodData> rods_data = [];
Color light = Constants.ctaColorLight.withOpacity(0.35);

class _SalesAgentCollectionsReportState
    extends State<SalesAgentCollectionsReport> with InactivityLogoutMixin {
  Color _button1Color = Colors.grey.withOpacity(0.0);
  Color _button2Color = Colors.grey.withOpacity(0.0);
  Color _button3Color = Colors.grey.withOpacity(0.0);
  List<OrdinalData> ordinalList = [
    OrdinalData(domain: 'Mon', measure: 3),
    OrdinalData(domain: 'Tue', measure: 5),
    OrdinalData(domain: 'Wed', measure: 9),
    OrdinalData(domain: 'Thu', measure: 6.5),
  ];
  List<int> showingTooltipOnSpots = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  List<OrdinalGroup> ordinalGroup = [];

  List<FlSpot> spots1ca = [];
  List<FlSpot> spots1ca_amount = [];
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
    expected_sum_of_premiums = 0;
    expected_count_of_premiums = 0;
    barChartData1 = [];
    barChartData2 = [];
    barChartData3 = [];
    barChartData4 = [];
    topsalesbyagent = [];
    bottomsalesbyagent = [];
    sectionsList = [
      gridmodel1("Expected", 0, 0),
      gridmodel1("Actual", 0, 0),
      gridmodel1("Variance", 0, 0),
    ];
    sectionsList2 = [
      gridmodel1("Cash", 0, 0),
      gridmodel1("Card", 0, 0),
      gridmodel1("Easypay", 0, 0),
      gridmodel1("Debit Order", 0, 0),
      gridmodel1("Salary Deduction", 0, 0),
      gridmodel1("Persal", 0, 0),
      gridmodel1("Voucher", 0, 0),
    ];
    isShowingType = false;
    setState(() {});
    restartInactivityTimer();

    //print("jhhh " + buttonNumber.toString());
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
        startDate = DateTime(now.year - 1, now.month, now.day);
        endDate = DateTime.now();
      }

      formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
      formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
      if (kDebugMode) {
        //print("formattedStartDate7 ${formattedStartDate}");
      }

      getSalesAgentCollectionsReport(
          context, formattedStartDate, formattedEndDate);

      setState(() {});
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            shadowColor: Colors.black.withOpacity(0.6),
            leading: InkWell(
                onTap: () {
                  restartInactivityTimer();
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
              "My Collections",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollStartNotification ||
                  scrollNotification is ScrollUpdateNotification) {
                restartInactivityTimer();
              }
              return true; // Return true to indicate the notification is handled
            },
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
                                    width: (MediaQuery.of(context).size.width /
                                            3) -
                                        12,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(360)),
                                    height: 35,
                                    child: Center(
                                      child: Text(
                                        '1 Mth View',
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
                                    width: (MediaQuery.of(context).size.width /
                                            3) -
                                        12,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(360)),
                                    child: Center(
                                      child: Text(
                                        '12 Mths View',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    restartInactivityTimer();
                                    _animateButton(3);
                                    DateTime? startDate = DateTime.now();
                                    DateTime? endDate = DateTime.now();
                                    showCustomDateRangePicker(
                                      context,
                                      dismissible: true,
                                      minimumDate: DateTime.now()
                                          .subtract(const Duration(days: 360)),
                                      maximumDate: DateTime.now()
                                          .add(Duration(days: 360)),
                                      backgroundColor: Colors.white,
                                      primaryColor: Constants.ctaColorLight,
                                      onApplyClick: (start, end) {
                                        setState(() {
                                          endDate = end;
                                          startDate = start;
                                        });
                                        print("fffhh $start");
                                        formattedStartDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(startDate!);
                                        formattedEndDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(endDate!);
                                        formattedStartDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(startDate!);
                                        formattedEndDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(endDate!);
                                        setState(() {});

                                        String dateRange =
                                            '$formattedStartDate - $formattedEndDate';
                                        print(
                                            "currently loading1 ${dateRange}");
                                        DateTime startDateTime =
                                            DateFormat('yyyy-MM-dd')
                                                .parse(formattedStartDate);
                                        DateTime endDateTime =
                                            DateFormat('yyyy-MM-dd')
                                                .parse(formattedEndDate);

                                        days_difference = endDateTime
                                            .difference(startDateTime)
                                            .inDays;
                                        if (kDebugMode) {
                                          print(
                                              "days_difference ${days_difference}");
                                          print(
                                              "formattedEndDate9 ${formattedEndDate}");
                                        }
                                        getSalesAgentCollectionsReport(
                                            context,
                                            formattedStartDate,
                                            formattedEndDate);
                                        restartInactivityTimer();
                                      },
                                      onCancelClick: () {
                                        print("user cancelled.");
                                        restartInactivityTimer();
                                        setState(() {
                                          _animateButton(1);
                                        });
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width /
                                            3) -
                                        12,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(360)),
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
                              color: Constants
                                  .ctaColorLight, // Color of the slider
                              borderRadius: BorderRadius.circular(36),
                            ),
                            child: _selectedButton == 1
                                ? Center(
                                    child: Text(
                                      '1 Mth View',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : _selectedButton == 2
                                    ? Center(
                                        child: Text(
                                          '12 Mths View',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : Center(
                                        child: InkWell(
                                          onTap: () {
                                            restartInactivityTimer();
                                            print("fffhh");
                                            _animateButton(3);
                                            DateTime? startDate =
                                                DateTime.now();
                                            DateTime? endDate = DateTime.now();
                                            showCustomDateRangePicker(
                                              context,
                                              dismissible: true,
                                              minimumDate: DateTime.now()
                                                  .subtract(const Duration(
                                                      days: 360)),
                                              maximumDate: DateTime.now()
                                                  .add(Duration(days: 360)),
                                              endDate: null,
                                              startDate: null,
                                              backgroundColor: Colors.white,
                                              primaryColor:
                                                  Constants.ctaColorLight,
                                              onApplyClick: (start, end) {
                                                setState(() {
                                                  endDate = end;
                                                  startDate = start;
                                                });
                                                formattedStartDate =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(startDate!);
                                                formattedEndDate =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(endDate!);
                                                formattedStartDate =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(startDate!);
                                                formattedEndDate =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(endDate!);
                                                setState(() {});

                                                String dateRange =
                                                    '$formattedStartDate - $formattedEndDate';
                                                print(
                                                    "currently loading ${dateRange}");
                                                DateTime startDateTime =
                                                    DateFormat('yyyy-MM-dd')
                                                        .parse(
                                                            formattedStartDate);
                                                DateTime endDateTime =
                                                    DateFormat('yyyy-MM-dd')
                                                        .parse(
                                                            formattedEndDate);

                                                days_difference = endDateTime
                                                    .difference(startDateTime)
                                                    .inDays;
                                                if (kDebugMode) {
                                                  print(
                                                      "days_difference ${days_difference}");
                                                  print(
                                                      "formattedEndDate9 ${formattedEndDate}");
                                                }

                                                getSalesAgentCollectionsReport(
                                                    context,
                                                    formattedStartDate,
                                                    formattedEndDate);
                                              },
                                              onCancelClick: () {
                                                print("user cancelled.");
                                                setState(() {
                                                  _animateButton(1);
                                                });
                                              },
                                            );
                                          },
                                          child: Text(
                                            'Select Dates',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                isLoadingCollections == true
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
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 12),
                  child: Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.35),
                  ),
                ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollStartNotification ||
                          scrollNotification is ScrollUpdateNotification) {
                        Constants.inactivityTimer =
                            Timer(const Duration(minutes: 3), () => {});
                      }
                      return true; // Return true to indicate the notification is handled
                    },
                    child: SingleChildScrollView(
                        child: Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  height: 120,
                                  child: InkWell(
                                      onTap: () {
                                        restartInactivityTimer();
                                      },
                                      child: Container(
                                        height: 120,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.9,
                                        child: Stack(
                                          children: [
                                            InkWell(
                                              onTap: () {},
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 4.0, right: 8),
                                                child: Card(
                                                  surfaceTintColor:
                                                      Colors.white,
                                                  elevation: 6,
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        color: Colors.white70,
                                                        width: 0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                  child: ClipPath(
                                                    clipper: ShapeBorderClipper(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
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
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.05),
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.0)),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8)),
                                                              child: Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            14),
                                                                  ),
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  height: 290,
                                                                  /*     decoration: BoxDecoration(
                                                                        color:Colors.white,
                                                                        borderRadius:
                                                                        BorderRadius.circular(
                                                                            8),
                                                                        border: Border.all(
                                                                            width: 1,
                                                                            color: Colors
                                                                                .grey.withOpacity(0.2))),*/
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              0,
                                                                          left:
                                                                              0,
                                                                          bottom:
                                                                              4),
                                                                  child: isLoadingCollections ==
                                                                          true
                                                                      ? Center(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Container(
                                                                              width: 18,
                                                                              height: 18,
                                                                              child: CircularProgressIndicator(
                                                                                color: Constants.ctaColorLight,
                                                                                strokeWidth: 1.8,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 8,
                                                                            ),
                                                                            Expanded(
                                                                              child: Center(
                                                                                  child: Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Text(
                                                                                  "R" + formatLargeNumber3(expected_sum_of_premiums.toString()),
                                                                                  style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
                                                                                  textAlign: TextAlign.center,
                                                                                  maxLines: 2,
                                                                                ),
                                                                              )),
                                                                            ),
                                                                            Center(
                                                                                child: Padding(
                                                                              padding: const EdgeInsets.only(top: 0.0),
                                                                              child: Text(
                                                                                expected_count_of_premiums.toString(),
                                                                                style: TextStyle(fontSize: 12.5),
                                                                                textAlign: TextAlign.center,
                                                                                maxLines: 1,
                                                                              ),
                                                                            )),
                                                                            Center(
                                                                                child: Padding(
                                                                              padding: const EdgeInsets.all(6.0),
                                                                              child: Text(
                                                                                sectionsList[0].id,
                                                                                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
                                                                                textAlign: TextAlign.center,
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
                                      )),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 120,
                                  child: InkWell(
                                      onTap: () {
                                        restartInactivityTimer();
                                      },
                                      child: Container(
                                        height: 120,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.9,
                                        child: Stack(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                restartInactivityTimer();
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 4.0, right: 8),
                                                child: Card(
                                                  surfaceTintColor:
                                                      Colors.white,
                                                  elevation: 6,
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        color: Colors.white70,
                                                        width: 0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                  child: ClipPath(
                                                    clipper: ShapeBorderClipper(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16))),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  color: Constants
                                                                      .ctaColorLight,
                                                                  width: 6))),
                                                      child:
                                                          isLoadingCollections ==
                                                                  true
                                                              ? Center(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        Container(
                                                                      width: 18,
                                                                      height:
                                                                          18,
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        color: Constants
                                                                            .ctaColorLight,
                                                                        strokeWidth:
                                                                            1.8,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : Column(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.grey.withOpacity(0.45),
                                                                            border: Border.all(color: Colors.grey.withOpacity(0.0)),
                                                                            borderRadius: BorderRadius.circular(8)),
                                                                        child: Container(
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(14),
                                                                            ),
                                                                            width: MediaQuery.of(context).size.width,
                                                                            height: 290,
                                                                            /*     decoration: BoxDecoration(
                                                                        color:Colors.white,
                                                                        borderRadius:
                                                                        BorderRadius.circular(
                                                                            8),
                                                                        border: Border.all(
                                                                            width: 1,
                                                                            color: Colors
                                                                                .grey.withOpacity(0.2))),*/
                                                                            margin: EdgeInsets.only(right: 0, left: 0, bottom: 4),
                                                                            child: Column(
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: 8,
                                                                                ),
                                                                                Expanded(
                                                                                  child: Center(
                                                                                      child: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Text(
                                                                                      "R" + formatLargeNumber3(sum_of_premiums.toString()),
                                                                                      style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
                                                                                      textAlign: TextAlign.center,
                                                                                      maxLines: 2,
                                                                                    ),
                                                                                  )),
                                                                                ),
                                                                                Center(
                                                                                    child: Padding(
                                                                                  padding: const EdgeInsets.only(top: 0.0),
                                                                                  child: Text(
                                                                                    count_of_premiums.toString(),
                                                                                    style: TextStyle(fontSize: 12.5),
                                                                                    textAlign: TextAlign.center,
                                                                                    maxLines: 1,
                                                                                  ),
                                                                                )),
                                                                                Center(
                                                                                    child: Padding(
                                                                                  padding: const EdgeInsets.all(6.0),
                                                                                  child: Text(
                                                                                    sectionsList[1].id,
                                                                                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
                                                                                    textAlign: TextAlign.center,
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
                                      )),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 120,
                                  child: InkWell(
                                      onTap: () {
                                        restartInactivityTimer();
                                      },
                                      child: Container(
                                        height: 120,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.9,
                                        child: Stack(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                restartInactivityTimer();
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 4.0, right: 8),
                                                child: Card(
                                                  elevation: 6,
                                                  surfaceTintColor:
                                                      Colors.white,
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        color: Colors.white70,
                                                        width: 0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                  child: ClipPath(
                                                    clipper: ShapeBorderClipper(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16))),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  color: Constants
                                                                      .ctaColorLight,
                                                                  width: 6))),
                                                      child:
                                                          isLoadingCollections ==
                                                                  true
                                                              ? Center(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        Container(
                                                                      width: 18,
                                                                      height:
                                                                          18,
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        color: Constants
                                                                            .ctaColorLight,
                                                                        strokeWidth:
                                                                            1.8,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : Column(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.grey.withOpacity(0.05),
                                                                            border: Border.all(color: Colors.grey.withOpacity(0.0)),
                                                                            borderRadius: BorderRadius.circular(8)),
                                                                        child: Container(
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(14),
                                                                            ),
                                                                            width: MediaQuery.of(context).size.width,
                                                                            height: 290,
                                                                            /*     decoration: BoxDecoration(
                                                                        color:Colors.white,
                                                                        borderRadius:
                                                                        BorderRadius.circular(
                                                                            8),
                                                                        border: Border.all(
                                                                            width: 1,
                                                                            color: Colors
                                                                                .grey.withOpacity(0.2))),*/
                                                                            margin: EdgeInsets.only(right: 0, left: 0, bottom: 4),
                                                                            child: Column(
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: 8,
                                                                                ),
                                                                                Expanded(
                                                                                  child: Center(
                                                                                      child: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Text(
                                                                                      "R" + formatLargeNumber3(variance_sum_of_premiums.toString()),
                                                                                      style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
                                                                                      textAlign: TextAlign.center,
                                                                                      maxLines: 2,
                                                                                    ),
                                                                                  )),
                                                                                ),
                                                                                Center(
                                                                                    child: Padding(
                                                                                  padding: const EdgeInsets.only(top: 0.0),
                                                                                  child: Text(
                                                                                    variance_count_of_premiums.toString(),
                                                                                    style: TextStyle(fontSize: 12.5),
                                                                                    textAlign: TextAlign.center,
                                                                                    maxLines: 1,
                                                                                  ),
                                                                                )),
                                                                                Center(
                                                                                    child: Padding(
                                                                                  padding: const EdgeInsets.all(6.0),
                                                                                  child: Text(
                                                                                    sectionsList[2].id,
                                                                                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
                                                                                    textAlign: TextAlign.center,
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
                                      )),
                                ),
                              ),
                              SizedBox(width: 6),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          InkWell(
                            onTap: () {
                              restartInactivityTimer();
                              //isShowingType = !isShowingType;
                              setState(() {});
                              //restartInactivityTimer();
                            },
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(360),
                                      color: Constants.ctaColorLight
                                          .withOpacity(0.1)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      isShowingType == false
                                          ? "Actual Collection By Type"
                                          : "Actual Collection By Type",
                                      style: TextStyle(
                                          color: Constants.ctaColorLight,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, top: 12, right: 6),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: MediaQuery.of(context)
                                              .size
                                              .width /
                                          (MediaQuery.of(context).size.height /
                                              2.1)),
                              itemCount: sectionsList2.length,
                              padding: EdgeInsets.all(2.0),
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                    onTap: () {
                                      restartInactivityTimer();
                                    },
                                    child: Container(
                                      height: 320,
                                      width: MediaQuery.of(context).size.width /
                                          2.1,
                                      child: Stack(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              restartInactivityTimer();
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
                                                surfaceTintColor: Colors.white,
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
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16))),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: Constants
                                                                    .ctaColorLight,
                                                                width: 6))),
                                                    child:
                                                        isLoadingCollections ==
                                                                true
                                                            ? Center(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child:
                                                                      Container(
                                                                    width: 18,
                                                                    height: 18,
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      color: Constants
                                                                          .ctaColorLight,
                                                                      strokeWidth:
                                                                          1.8,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Column(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          /*  color: sales_index ==
                                                                          index
                                                                      ? Colors.grey
                                                                          .withOpacity(
                                                                              0.2)
                                                                      : Colors.grey
                                                                          .withOpacity(
                                                                              0.05),*/
                                                                          border: Border.all(color: Colors.grey.withOpacity(0.0)),
                                                                          borderRadius: BorderRadius.circular(8)),
                                                                      child: Container(
                                                                          decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(14),
                                                                          ),
                                                                          width: MediaQuery.of(context).size.width,
                                                                          height: 290,
                                                                          /*     decoration: BoxDecoration(
                                                                color:Colors.white,
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    8),
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .grey.withOpacity(0.2))),*/
                                                                          margin: EdgeInsets.only(right: 0, left: 0, bottom: 4),
                                                                          child: Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 8,
                                                                              ),
                                                                              Expanded(
                                                                                child: Center(
                                                                                    child: Padding(
                                                                                  padding: const EdgeInsets.only(top: 10.0),
                                                                                  child: Text(
                                                                                    "R" + formatLargeNumber(sectionsList2[index].amount.toString()),
                                                                                    style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
                                                                                    textAlign: TextAlign.center,
                                                                                    maxLines: 2,
                                                                                  ),
                                                                                )),
                                                                              ),
                                                                              Center(
                                                                                  child: Padding(
                                                                                padding: const EdgeInsets.only(top: 0.0),
                                                                                child: (isLoadingCollections == true)
                                                                                    ? Center(
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(4.0),
                                                                                          child: Container(
                                                                                            width: 10,
                                                                                            height: 10,
                                                                                            child: CircularProgressIndicator(
                                                                                              color: Constants.ctaColorLight,
                                                                                              strokeWidth: 1.8,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    : Text(
                                                                                        (_selectedButton == 1
                                                                                                ? ((sectionsList2[index].amount / sum_of_premiums) * 100).toStringAsFixed(1)
                                                                                                : _selectedButton == 2
                                                                                                    ? ((sectionsList2[index].amount / sum_of_premiums) * 100).toStringAsFixed(1)
                                                                                                    : _selectedButton == 3 && days_difference <= 31
                                                                                                        ? ((sectionsList2[index].amount / sum_of_premiums) * 100).toStringAsFixed(1)
                                                                                                        : ((sectionsList2[index].amount / sum_of_premiums) * 100).toStringAsFixed(1)) +
                                                                                            "%",
                                                                                        style: TextStyle(fontSize: 12.5),
                                                                                        textAlign: TextAlign.center,
                                                                                        maxLines: 1,
                                                                                      ),
                                                                              )),
                                                                              Center(
                                                                                  child: Padding(
                                                                                padding: const EdgeInsets.all(6.0),
                                                                                child: Text(
                                                                                  sectionsList2[index].id,
                                                                                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
                                                                                  textAlign: TextAlign.center,
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
                          Container(
                            height: 16,
                          ),
                          _selectedButton == 1
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(
                                      "Collections Overview (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                )
                              : _selectedButton == 2
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Text(
                                          "Collections Overview (12 Months View)"),
                                    )
                                  : Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Text(
                                          "Collections Overview (${formattedStartDate} to ${formattedEndDate})"),
                                    ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.withOpacity(0.00)),
                                height: 250,
                                child: isLoadingCollections == false
                                    ? _selectedButton == 1
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 8.0, right: 10),
                                            child: CustomCard(
                                              surfaceTintColor: Colors.white,
                                              elevation: 6,
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Colors.white70,
                                                    width: 0),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: AspectRatio(
                                                aspectRatio: 1.66,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 16),
                                                  child: LayoutBuilder(
                                                    builder:
                                                        (context, constraints) {
                                                      final double barsSpace =
                                                          1.0 *
                                                              constraints
                                                                  .maxWidth /
                                                              200;

                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: BarChart(
                                                          BarChartData(
                                                            alignment:
                                                                BarChartAlignment
                                                                    .center,
                                                            barTouchData:
                                                                BarTouchData(
                                                                    enabled:
                                                                        false),
                                                            gridData:
                                                                FlGridData(
                                                              show: true,
                                                              drawVerticalLine:
                                                                  false,
                                                              getDrawingHorizontalLine:
                                                                  (value) {
                                                                return FlLine(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.10),
                                                                  strokeWidth:
                                                                      1,
                                                                );
                                                              },
                                                              getDrawingVerticalLine:
                                                                  (value) {
                                                                return FlLine(
                                                                  color: Colors
                                                                      .grey,
                                                                  strokeWidth:
                                                                      1,
                                                                );
                                                              },
                                                            ),
                                                            titlesData:
                                                                FlTitlesData(
                                                              bottomTitles:
                                                                  AxisTitles(
                                                                sideTitles:
                                                                    SideTitles(
                                                                  showTitles:
                                                                      true,
                                                                  interval: 1,
                                                                  getTitlesWidget:
                                                                      (value,
                                                                          meta) {
                                                                    return Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          0.0),
                                                                      child:
                                                                          Text(
                                                                        value
                                                                            .toInt()
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                6.5),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                                axisNameWidget:
                                                                    Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              0.0),
                                                                  child: Text(
                                                                    'Days of the month',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ),
                                                              topTitles:
                                                                  AxisTitles(
                                                                sideTitles:
                                                                    SideTitles(
                                                                  showTitles:
                                                                      false,
                                                                  getTitlesWidget:
                                                                      (value,
                                                                          meta) {
                                                                    return Text(value
                                                                        .toInt()
                                                                        .toString());
                                                                  },
                                                                ),
                                                              ),
                                                              rightTitles:
                                                                  AxisTitles(
                                                                sideTitles:
                                                                    SideTitles(
                                                                  showTitles:
                                                                      false,
                                                                  getTitlesWidget:
                                                                      (value,
                                                                          meta) {
                                                                    return Text(value
                                                                        .toInt()
                                                                        .toString());
                                                                  },
                                                                ),
                                                              ),
                                                              leftTitles:
                                                                  AxisTitles(
                                                                sideTitles:
                                                                    SideTitles(
                                                                  showTitles:
                                                                      true,
                                                                  reservedSize:
                                                                      32,
                                                                  getTitlesWidget:
                                                                      (value,
                                                                          meta) {
                                                                    return Text(
                                                                      formatLargeNumber4(value
                                                                          .toInt()
                                                                          .toString()),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              7.5),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            borderData:
                                                                FlBorderData(
                                                                    show:
                                                                        false),
                                                            groupsSpace:
                                                                barsSpace,
                                                            barGroups:
                                                                barChartData1,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : _selectedButton == 2
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Card(
                                                  elevation: 6,
                                                  surfaceTintColor:
                                                      Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16)),
                                                  child: AspectRatio(
                                                    aspectRatio: 1.66,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 16),
                                                      child: LayoutBuilder(
                                                        builder: (context,
                                                            constraints) {
                                                          final double
                                                              barsSpace = 1.2 *
                                                                  constraints
                                                                      .maxWidth /
                                                                  200;

                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: BarChart(
                                                              BarChartData(
                                                                alignment:
                                                                    BarChartAlignment
                                                                        .center,
                                                                barTouchData:
                                                                    BarTouchData(
                                                                        enabled:
                                                                            false),
                                                                gridData:
                                                                    FlGridData(
                                                                  show: true,
                                                                  drawVerticalLine:
                                                                      false,
                                                                  getDrawingHorizontalLine:
                                                                      (value) {
                                                                    return FlLine(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.10),
                                                                      strokeWidth:
                                                                          1,
                                                                    );
                                                                  },
                                                                  getDrawingVerticalLine:
                                                                      (value) {
                                                                    return FlLine(
                                                                      color: Colors
                                                                          .grey,
                                                                      strokeWidth:
                                                                          1,
                                                                    );
                                                                  },
                                                                ),
                                                                titlesData:
                                                                    FlTitlesData(
                                                                  bottomTitles:
                                                                      AxisTitles(
                                                                    sideTitles:
                                                                        SideTitles(
                                                                      showTitles:
                                                                          true,
                                                                      interval:
                                                                          1,
                                                                      getTitlesWidget:
                                                                          (value,
                                                                              meta) {
                                                                        return Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            getMonthAbbreviation(value.toInt()).toString(),
                                                                            style:
                                                                                TextStyle(fontSize: 9.5),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                    axisNameWidget:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              0.0),
                                                                      child:
                                                                          Text(
                                                                        'Months of the Year',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                11,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  topTitles:
                                                                      AxisTitles(
                                                                    sideTitles:
                                                                        SideTitles(
                                                                      showTitles:
                                                                          false,
                                                                      getTitlesWidget:
                                                                          (value,
                                                                              meta) {
                                                                        return Text(value
                                                                            .toInt()
                                                                            .toString());
                                                                      },
                                                                    ),
                                                                  ),
                                                                  rightTitles:
                                                                      AxisTitles(
                                                                    sideTitles:
                                                                        SideTitles(
                                                                      showTitles:
                                                                          false,
                                                                      getTitlesWidget:
                                                                          (value,
                                                                              meta) {
                                                                        return Text(value
                                                                            .toInt()
                                                                            .toString());
                                                                      },
                                                                    ),
                                                                  ),
                                                                  leftTitles:
                                                                      AxisTitles(
                                                                    sideTitles:
                                                                        SideTitles(
                                                                      showTitles:
                                                                          true,
                                                                      reservedSize:
                                                                          32,
                                                                      getTitlesWidget:
                                                                          (value,
                                                                              meta) {
                                                                        return Text(
                                                                          formatLargeNumber4(value
                                                                              .toInt()
                                                                              .toString()),
                                                                          style:
                                                                              TextStyle(fontSize: 7.5),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                                borderData:
                                                                    FlBorderData(
                                                                        show:
                                                                            false),
                                                                groupsSpace:
                                                                    barsSpace,
                                                                barGroups:
                                                                    barChartData2,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : _selectedButton == 3 &&
                                                    days_difference <= 31
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Card(
                                                      surfaceTintColor:
                                                          Colors.white,
                                                      color: Colors.white,
                                                      elevation: 6,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16)),
                                                      child: AspectRatio(
                                                        aspectRatio: 1.66,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 16),
                                                          child: LayoutBuilder(
                                                            builder: (context,
                                                                constraints) {
                                                              final double
                                                                  barsSpace =
                                                                  1.0 *
                                                                      constraints
                                                                          .maxWidth /
                                                                      200;

                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: BarChart(
                                                                  BarChartData(
                                                                    alignment:
                                                                        BarChartAlignment
                                                                            .center,
                                                                    barTouchData:
                                                                        BarTouchData(
                                                                            enabled:
                                                                                false),
                                                                    gridData:
                                                                        FlGridData(
                                                                      show:
                                                                          true,
                                                                      drawVerticalLine:
                                                                          false,
                                                                      getDrawingHorizontalLine:
                                                                          (value) {
                                                                        return FlLine(
                                                                          color: Colors
                                                                              .grey
                                                                              .withOpacity(0.10),
                                                                          strokeWidth:
                                                                              1,
                                                                        );
                                                                      },
                                                                      getDrawingVerticalLine:
                                                                          (value) {
                                                                        return FlLine(
                                                                          color:
                                                                              Colors.grey,
                                                                          strokeWidth:
                                                                              1,
                                                                        );
                                                                      },
                                                                    ),
                                                                    titlesData:
                                                                        FlTitlesData(
                                                                      bottomTitles:
                                                                          AxisTitles(
                                                                        sideTitles:
                                                                            SideTitles(
                                                                          showTitles:
                                                                              true,
                                                                          interval:
                                                                              1,
                                                                          getTitlesWidget:
                                                                              (value, meta) {
                                                                            return Padding(
                                                                              padding: const EdgeInsets.all(0.0),
                                                                              child: Text(
                                                                                value.toInt().toString(),
                                                                                style: TextStyle(fontSize: 6.5),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                        axisNameWidget:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              top: 0.0),
                                                                          child:
                                                                              Text(
                                                                            'Days of the month',
                                                                            style: TextStyle(
                                                                                fontSize: 11,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      topTitles:
                                                                          AxisTitles(
                                                                        sideTitles:
                                                                            SideTitles(
                                                                          showTitles:
                                                                              false,
                                                                          getTitlesWidget:
                                                                              (value, meta) {
                                                                            return Text(value.toInt().toString());
                                                                          },
                                                                        ),
                                                                      ),
                                                                      rightTitles:
                                                                          AxisTitles(
                                                                        sideTitles:
                                                                            SideTitles(
                                                                          showTitles:
                                                                              false,
                                                                          getTitlesWidget:
                                                                              (value, meta) {
                                                                            return Text(value.toInt().toString());
                                                                          },
                                                                        ),
                                                                      ),
                                                                      leftTitles:
                                                                          AxisTitles(
                                                                        sideTitles:
                                                                            SideTitles(
                                                                          showTitles:
                                                                              true,
                                                                          reservedSize:
                                                                              32,
                                                                          getTitlesWidget:
                                                                              (value, meta) {
                                                                            return Text(
                                                                              formatLargeNumber4(value.toInt().toString()),
                                                                              style: TextStyle(fontSize: 7.5),
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    borderData:
                                                                        FlBorderData(
                                                                            show:
                                                                                false),
                                                                    groupsSpace:
                                                                        barsSpace,
                                                                    barGroups:
                                                                        barChartData3,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : _selectedButton == 3 &&
                                                        days_difference > 31
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Card(
                                                          surfaceTintColor:
                                                              Colors.white,
                                                          color: Colors.white,
                                                          elevation: 6,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16)),
                                                          child: AspectRatio(
                                                            aspectRatio: 1.66,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 16),
                                                              child:
                                                                  LayoutBuilder(
                                                                builder: (context,
                                                                    constraints) {
                                                                  final double
                                                                      barsSpace =
                                                                      1.0 *
                                                                          constraints
                                                                              .maxWidth /
                                                                          200;

                                                                  return Column(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                          child:
                                                                              BarChart(
                                                                            BarChartData(
                                                                              alignment: BarChartAlignment.center,
                                                                              barTouchData: BarTouchData(enabled: false),
                                                                              gridData: FlGridData(
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
                                                                              ),
                                                                              titlesData: FlTitlesData(
                                                                                bottomTitles: AxisTitles(
                                                                                  sideTitles: SideTitles(
                                                                                    showTitles: true,
                                                                                    interval: 1,
                                                                                    getTitlesWidget: (value, meta) {
                                                                                      return Padding(
                                                                                        padding: const EdgeInsets.all(0.0),
                                                                                        child: Text(
                                                                                          // value.toString(),
                                                                                          getMonthAbbreviation(value.toInt()).toString(),
                                                                                          style: TextStyle(fontSize: 9.5),
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                  axisNameWidget: Padding(
                                                                                    padding: const EdgeInsets.only(top: 0.0),
                                                                                    child: Text(
                                                                                      'Months of the Year',
                                                                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                topTitles: AxisTitles(
                                                                                  sideTitles: SideTitles(
                                                                                    showTitles: false,
                                                                                    getTitlesWidget: (value, meta) {
                                                                                      return Text(value.toInt().toString());
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                                rightTitles: AxisTitles(
                                                                                  sideTitles: SideTitles(
                                                                                    showTitles: false,
                                                                                    getTitlesWidget: (value, meta) {
                                                                                      return Text(value.toInt().toString());
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                                leftTitles: AxisTitles(
                                                                                  sideTitles: SideTitles(
                                                                                    showTitles: true,
                                                                                    reservedSize: 32,
                                                                                    getTitlesWidget: (value, meta) {
                                                                                      return Text(
                                                                                        formatLargeNumber4(value.toInt().toString()),
                                                                                        style: TextStyle(fontSize: 7.5),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              borderData: FlBorderData(show: false),
                                                                              groupsSpace: barsSpace,
                                                                              barGroups: barChartData4,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container()
                                    : Center(
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
                                      ))),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 42.0, top: 8),
                                child: Text(
                                  "Updates real-time except D/O, 7 day lag",
                                  style: TextStyle(fontSize: 9),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16),
                            child: CollectionTypeGrid(),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                        ],
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    final GlobalKey<ScaffoldState> _key = GlobalKey();
    startInactivityTimer();
    secureScreen();
    DateTime now = DateTime.now();
    DateTime startDate = DateTime(now.year, now.month, 1);
    DateTime endDate = DateTime.now();

    _animateButton(1);

    super.initState();
  }

  Future<void> getSalesAgentCollectionsReport(
    BuildContext context,
    String date_from,
    String date_to,
  ) async {
    setState(() {
      isLoadingCollections = true;
    });
    String baseUrl =
        "https://miinsightsapps.net/files/get_collection_data_by_agent/";
    try {
      Map<String, String>? payload = {
        "client_id": "${Constants.cec_client_id}",
        "start_date": date_from,
        "end_date": date_to,
        "cec_employee_id": "${Constants.cec_empid}"
      };
      if (kDebugMode) {
        // print("fghhgggh $payload");
      }
      List<Map<String, dynamic>> sales = [];
      Map<String, List<Map<String, dynamic>>> groupedSales = {};
      Map<String, List<Map<String, dynamic>>> groupedSalesByBranch = {};

      await http
          .post(
        Uri.parse(
          baseUrl,
        ),
        body: payload,
      )
          .then((value) {
        http.Response response = value;
        if (kDebugMode) {
          // print(response.bodyBytes);
          //print(response.statusCode);
          // print("jgjhjh " + response.body.runtimeType);
          //print(response.body);
        }

        if (response.statusCode != 200) {
          print(response.statusCode);
          print("jgjhjhf " + response.body);
          setState(() {
            isLoadingCollections =
                false; // Stop loading when request is complete
          });
          Fluttertoast.showToast(
              msg: "Error loading data, please refresh",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Constants.ctaColorLight,
              textColor: Colors.white,
              fontSize: 16.0);
          if (kDebugMode) {}
        } else {
          var jsonResponse = jsonDecode(response.body);
          LogPrint("fghghgfgghfhg 3jg00 ${jsonResponse}");

          if (jsonResponse["message"] == "list is empty") {
            isLoadingCollections = false;
            setState(() {});
          } else {
            //processDataForCollectionsCount(response.body);

            if (_selectedButton == 1) {
              barChartData1 =
                  processDataForCollectionsCountDaily(response.body);
            }
            if (_selectedButton == 3 && days_difference <= 31) {
              barChartData3 = processDataForCollectionsCountDaily2b(
                  response.body, date_from, date_to, context);
            }
            if (_selectedButton == 3 && days_difference > 31) {
              barChartData4 = processDataForCollectionsCountMonthly4(
                  response.body, date_from, date_to, context);
            }
            if (_selectedButton == 2) {
              barChartData2 = processDataForCollectionsCountMonthly(
                  response.body, date_from, date_to, context);
              setState(() {});
            }

            Map<int, Map<String, double>> monthlySales = {
              for (var month = 1; month <= 12; month++) month: {}
            };

            List<BarChartGroupData> collectionsGroupedData = [];

            if (kDebugMode) {
              //print(barChartData1);
            }
            isLoadingCollections = false;
            setState(() {});

            jsonString = response.body;

            if (kDebugMode) {
              // print(jsonResponse);
            }
            sum_of_premiums =
                jsonResponse["sum_collected_premiums"]?.toDouble() ?? 0.0;
            expected_sum_of_premiums =
                jsonResponse["sum_of_premiums"]?.toDouble() ?? 0.0;
            //print("sum_of_premiums $sum_of_premiums");
            count_of_premiums =
                jsonResponse["count_of_unique_policies"]?.toInt() ?? 0;
            expected_count_of_premiums =
                jsonResponse["count_of_premiums"]?.toInt() ?? 0;
            variance_sum_of_premiums =
                sum_of_premiums - expected_sum_of_premiums;
            variance_count_of_premiums =
                count_of_premiums - expected_count_of_premiums;

            //sectionsList2[0] = jsonResponse["api_collected_amount"] ?? 0;
            List collection_by_type = jsonResponse["collection_by_type"];
            collection_by_type.forEach((element) {
              Map m1 = element as Map;
              if (m1["collection_type"] == "Cash") {
                sectionsList2[0].amount = m1["total_amount"];
                sectionsList2[0].count = m1["count"];
              } else if (m1["collection_type"] == "EFT") {
                sectionsList2[1].amount = m1["total_amount"];
                sectionsList2[1].count = m1["count"];
              } else if (m1["collection_type"] == "Easypay") {
                sectionsList2[2].amount = m1["total_amount"];
                sectionsList2[2].count = m1["count"];
              } else if (m1["collection_type"] == "Debit Order") {
                sectionsList2[3].amount = m1["total_amount"];
                sectionsList2[3].count = m1["count"];
              } else if (m1["collection_type"] == "Salary Deduction") {
                sectionsList2[4].amount = m1["total_amount"];
                sectionsList2[4].count = m1["count"];
              } else if (m1["collection_type"] == "persal") {
                sectionsList2[5].amount = m1["total_amount"];
                sectionsList2[5].count = m1["count"];
              }
            });
            print("got here!!!");

            isLoadingCollections = false;
            setState(() {});

            int idY = 1;
            maxY5 = 0;
            List top_employee_list = jsonResponse["top_employee_list"] ?? [];
            top_employee_list.forEach((element) {
              Map m1 = element as Map;
              topsalesbyagent.add(SalesByAgent(
                  m1["employee"], m1["total_collected_amount"] ?? []));
            });
            List bottom_employees_list =
                jsonResponse["bottom_employees_list"] ?? [];
            bottom_employees_list.forEach((element) {
              Map m1 = element as Map;
              bottomsalesbyagent.add(SalesByAgent(
                  m1["employee"], m1["total_collected_amount"] ?? []));
            });

            salesbybranch = [];
            bardata5 = [];
            isLoadingCollections = false;
            setState(() {});

            List top_branch_list = jsonResponse["branch_sales"] ?? [];
            top_branch_list.forEach((element) {
              Map m1 = element as Map;
              salesbybranch.add(SalesByBranch(
                  m1["branch_name"], m1["total_collected_amount"]));
            });

            barData = [];
            ordinary_sales.clear();

            for (var element in salesbybranch) {
              if (element.sales > maxY5) {
                maxY5 = element.sales;
              }

              bottomTitles1.add(element.branch_name);
              ordinary_sales.add(OrdinalSales(
                  element.branch_name, double.parse(element.sales.toString())));
              DateTime now = DateTime.now();
              int currentMonth = now.month;
              int currentYear = now.year;
              int daysInCurrentMonth =
                  DateTime(currentYear, currentMonth + 1, 0).day;

              barData.add(
                BarChartGroupData(
                  x: idY++,
                  barRods: [
                    BarChartRodData(
                      toY: element.sales.toDouble(),
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.zero,
                      width: (Constants.screenWidth / daysInCurrentMonth),
                    ),
                  ],
                ),
              );
            }

            ordinary_sales.sort((a, b) => b.sales.compareTo(a.sales));

            //print("maxY5 ${maxY5}");

            bardata5.add(charts.Series<OrdinalSales, String>(
                id: 'BranchSales',
                domainFn: (OrdinalSales sale, _) => sale.branch,
                measureFn: (OrdinalSales sale, _) =>
                    double.parse(sale.sales.toStringAsFixed(0)),
                data: ordinary_sales,
                // Set a label accessor to control the text of the bar label.
                labelAccessorFn: (OrdinalSales sale, _) =>
                    'R${formatLargeNumber3(sale.sales.toString())}'));
          }
        }
      });

      setState(() {
        isLoadingCollections = false;
      });
      startInactivityTimer();
    } on Exception catch (_, exception) {
      setState(() {
        isLoadingCollections = false;
      });
      print(exception);
      Fluttertoast.showToast(
          msg: exception.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.ctaColorLight,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  static void LogPrint(Object object) async {
    int defaultPrintLength = 1020;
    if (object == null || object.toString().length <= defaultPrintLength) {
      print(object);
    } else {
      String log = object.toString();
      int start = 0;
      int endIndex = defaultPrintLength;
      int logLength = log.length;
      int tmpLogLength = log.length;
      while (endIndex < logLength) {
        print(log.substring(start, endIndex));
        endIndex += defaultPrintLength;
        start += defaultPrintLength;
        tmpLogLength -= defaultPrintLength;
      }
      if (tmpLogLength > 0) {
        print(log.substring(start, logLength));
      }
    }
  }
}

List<BarChartGroupData> processDataForCollectionsCountMonthly(
    String jsonString, String startDate, String endDate, BuildContext context) {
  //
  List<dynamic> jsonData = jsonDecode(jsonString)["daily_collection_summary"];

  DateTime end = DateTime.parse(endDate);
  DateTime start = DateTime(end.year - 1, end.month, end.day);
  int monthsInRange = 12;

  // Initialize monthlySales for each month in the range
  Map<int, Map<String, double>> monthlySales = {
    for (var i = 0; i < monthsInRange; i++)
      DateTime(end.year, end.month - i, 1).month: {}
  };

  for (var collectionItem in jsonData) {
    if (collectionItem is Map<String, dynamic>) {
      //Try catch
      DateTime paymentDate =
          DateTime.parse(collectionItem['date_or_month'] + "-01");
      if (paymentDate.isAfter(start) &&
          paymentDate.isBefore(end.add(const Duration(days: 1)))) {
        int monthIndex = paymentDate.month;
        String collectionType = collectionItem["collection_type"];
        double premium = collectionItem["total_amount"];

        monthlySales.putIfAbsent(monthIndex, () => {});
        monthlySales[monthIndex]?.update(
            collectionType, (value) => value + premium,
            ifAbsent: () => premium);
      }
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

  List<BarChartGroupData> collectionsGroupedData = [];
  monthlySales.forEach((monthIndex, salesData) {
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];
    var sortedSalesData = sortSalesData(salesData);

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
          color = Colors.grey; // Default color for unknown types
      }

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, color));
      cumulativeAmount += amount;
    });
    rodStackItems
        .sort((a, b) => colorOrder[a.color]!.compareTo(colorOrder[b.color]!));
    rodStackItems = rodStackItems.reversed.toList();
    print(rodStackItems);

    collectionsGroupedData.add(BarChartGroupData(
      x: monthIndex,
      barRods: [
        BarChartRodData(
          toY: cumulativeAmount,
          rodStackItems: rodStackItems.isEmpty
              ? [BarChartRodStackItem(0, 0, Colors.transparent)]
              : rodStackItems,
          borderRadius: BorderRadius.zero,
          width: (Constants.screenWidth / 12) - 5.1,
        ),
      ],
      barsSpace: barsSpace,
    ));
  });

  return collectionsGroupedData;
}

List<MapEntry<String, double>> sortSalesData(Map<String, double> salesData) {
  Map<String, Color> typeToColor = {
    'Cash': Colors.blue,
    'EFT': Colors.purple,
    'Easypay': Colors.green,
    'Debit Order': Colors.orange,
    'Persal': Colors.grey,
    'Salary Deduction': Colors.yellow,
  };

  Map<Color, int> colorOrder = {
    Colors.blue: 1,
    Colors.purple: 2,
    Colors.green: 3,
    Colors.orange: 4,
    Colors.grey: 5,
    Colors.yellow: 6,
    // Add more colors if needed
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

List<BarChartGroupData> processDataForCollectionsCountMonthly4(
    String jsonString, String startDate, String endDate, BuildContext context) {
  print("aaxdjyjhss $jsonString");
  List<dynamic> jsonData = jsonDecode(jsonString)["daily_collection_summary"];

  DateTime end = DateTime.parse(endDate);
  DateTime start = DateTime(end.year - 1, end.month, end.day);
  int monthsInRange = 12;

  // Initialize monthlySales for each month in the range
  Map<int, Map<String, double>> monthlySales = {
    for (var i = 0; i < monthsInRange; i++)
      DateTime(end.year, end.month - i, 1).month: {}
  };

  for (var collectionItem in jsonData) {
    if (collectionItem is Map<String, dynamic>) {
      DateTime paymentDate =
          DateTime.parse(collectionItem['date_or_month'] + "-01");

      int monthIndex = paymentDate.month;
      String collectionType = collectionItem["collection_type"];
      double premium = collectionItem["total_amount"];

      monthlySales.putIfAbsent(monthIndex, () => {});
      monthlySales[monthIndex]?.update(
          collectionType, (value) => value + premium,
          ifAbsent: () => premium);
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

  List<BarChartGroupData> collectionsGroupedData = [];
  monthlySales.forEach((monthIndex, salesData) {
    //print("aaxdss $monthIndex $salesData");
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];
    var sortedSalesData = sortSalesData(salesData);

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
          color = Colors.grey; // Default color for unknown types
      }

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, color));
      cumulativeAmount += amount;
    });
    rodStackItems
        .sort((a, b) => colorOrder[a.color]!.compareTo(colorOrder[b.color]!));
    rodStackItems = rodStackItems.reversed.toList();
    print(rodStackItems);

    collectionsGroupedData.add(BarChartGroupData(
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

  return collectionsGroupedData;
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
      padding: const EdgeInsets.only(top: 0.0),
      child: Row(
        children: <Widget>[
          CustomShapeIndicator(
            color: color,
          ),
          const SizedBox(
            width: 4,
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 8.5,
                fontWeight: FontWeight.w300,
                color: textColor ?? Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomShapeIndicator extends StatelessWidget {
  final Color color;
  final double size;
  final bool isSquare;

  const CustomShapeIndicator({
    Key? key,
    required this.color,
    this.size = 10,
    this.isSquare = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: ShapePainter(color, isSquare),
    );
  }
}

class ShapePainter extends CustomPainter {
  final Color color;
  final bool isSquare;

  ShapePainter(this.color, this.isSquare);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    if (isSquare) {
      canvas.drawRect(Offset.zero & size, paint);
    } else {
      canvas.drawOval(Offset.zero & size, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/*String getEmployeeById(
  int cec_employeeid,
) {
  String result = "";
  for (var employee in Constants.cec_employees) {
    if (employee['cec_employeeid'].toString() == cec_employeeid.toString()) {
      result =
          "${employee["employee_name"]} ${employee["employee_surname"].toString()}";
      if (kDebugMode) {
        //print("fgfghg $result");
      }
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
}*/

class gridmodel1 {
  String id;
  int count;
  double amount;
  gridmodel1(
    this.id,
    this.count,
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

String formatWithCommas3(double value, [bool forceDecimal = false]) {
  bool isNegative = value < 0;
  double absValue = value.abs();

  final format = absValue < 1000000 && !forceDecimal
      ? NumberFormat("#,##0", "en_US")
      : NumberFormat("#,##0.00", "en_US");

  // Format the number and add back the negative sign if necessary
  return isNegative ? "-${format.format(absValue)}" : format.format(absValue);
}

String formatLargeNumber3(String valueStr) {
  const List<String> suffixes = [
    "",
    "k",
    "m",
    "b",
    "t"
  ]; // Add more suffixes as needed

  double value;
  try {
    value = double.parse(valueStr);
  } catch (e) {
    return 'Invalid Number';
  }

  bool isNegative = value < 0; // Check if the number is negative
  value = value.abs(); // Work with the absolute value

  // If the value is less than a million, return it with commas
  if (value < 1000000) {
    return isNegative
        ? "-${formatWithCommas3(value)}"
        : formatWithCommas3(value);
  }

  int index = 0;
  double newValue = value;

  while (newValue >= 1000 && index < suffixes.length - 1) {
    newValue /= 1000;
    index++;
  }

  // Force decimal places for large numbers with suffixes
  return isNegative
      ? "-${formatWithCommas3(newValue, true)}${suffixes[index]}"
      : "${formatWithCommas3(newValue, true)}${suffixes[index]}";
}

String formatLargeNumber4(String valueStr) {
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

  int index = 0;
  double newValue = value;

  while (newValue >= 1000 && index < suffixes.length - 1) {
    newValue /= 1000;
    index++;
  }

  if (value > 999) {
    return '${((newValue)).toStringAsFixed(1)}${suffixes[index]}';
  } else
    return value.toStringAsFixed(0);
}

String formatWithCommas(double value) {
  final format = NumberFormat("#,##0", "en_US"); // Updated pattern
  return format.format(value);
}

String formatLargeNumber(String valueStr) {
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
  if (value < 1000000) {
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
    return months[DateTime.now().month - 1];
  }

  // Return the corresponding month abbreviation
  return months[monthNumber - 1];
}

class OrdinalSales {
  final String branch;
  final double sales;

  OrdinalSales(this.branch, this.sales);
}

Widget bottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(fontSize: 10);
  String text;
  switch (value.toInt()) {
    case 0:
      text = 'Apr';
      break;
    case 1:
      text = 'May';
      break;
    case 2:
      text = 'Jun';
      break;
    case 3:
      text = 'Jul';
      break;
    case 4:
      text = 'Aug';
      break;
    default:
      text = '';
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(text, style: style),
  );
}

Widget leftTitles(double value, TitleMeta meta) {
  if (value == meta.max) {
    return Container();
  }
  const style = TextStyle(
    fontSize: 13,
  );
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(
      meta.formattedValue,
      style: style,
    ),
  );
}

List<BarChartGroupData> processDataForCollectionsCountDaily(String jsonString) {
  List<dynamic> jsonData = jsonDecode(jsonString)["daily_collection_summary"];

  DateTime now = DateTime.now();
  int currentMonth = now.month;
  int currentYear = now.year;
  int daysInCurrentMonth = DateTime(currentYear, currentMonth + 1, 0).day;

  // Initialize data structure for daily sales for the current month
  Map<int, Map<String, double>> dailySales = {
    for (var day = 1; day <= daysInCurrentMonth; day++) day: {}
  };

  for (var collectionItem in jsonData) {
    if (collectionItem is Map<String, dynamic>) {
      DateTime date = DateTime.parse(collectionItem['date_or_month']);
      if (date.month == currentMonth && date.year == currentYear) {
        int dayOfMonth = date.day;
        String collectionType = collectionItem["collection_type"];
        double premium = collectionItem["total_amount"];

        dailySales[dayOfMonth]!.update(
            collectionType, (value) => value + premium,
            ifAbsent: () => premium);
      }
    }
  }

  List<BarChartGroupData> collectionsGroupedData = [];
  dailySales.forEach((dayOfMonth, salesData) {
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    var sortedSalesData = sortSalesData(salesData);

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
          color = Colors.grey; // Default color for unknown types
      }

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, color));
      cumulativeAmount += amount;
    });
    rodStackItems
        .sort((a, b) => colorOrder[a.color]!.compareTo(colorOrder[b.color]!));
    rodStackItems = rodStackItems.reversed.toList();

    // Add a bar for each day of the month
    collectionsGroupedData.add(BarChartGroupData(
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

  return collectionsGroupedData;
}

List<BarChartGroupData> processDataForCollectionsCountDaily2(
    String jsonString, String startDate, String endDate) {
  List<dynamic> jsonData = jsonDecode(jsonString)["message"];

  DateTime start = DateTime.parse(startDate);
  DateTime end = DateTime.parse(endDate);
  int daysInRange = end.difference(start).inDays;

  Map<int, Map<String, double>> dailySales = {
    for (var i = 0; i <= daysInRange; i++) i: {}
  };

  for (var collectionItem in jsonData) {
    if (collectionItem is Map<String, dynamic>) {
      DateTime paymentDate = DateTime.parse(collectionItem['payment_date']);
      if (paymentDate.isAfter(start.subtract(const Duration(days: 1))) &&
          paymentDate.isBefore(end.add(const Duration(days: 1)))) {
        int dayIndex = paymentDate.difference(start).inDays;
        String collectionType = collectionItem["collection_type"];
        double premium = collectionItem["collected_premium"];

        dailySales[dayIndex]!.update(collectionType, (value) => value + premium,
            ifAbsent: () => premium);
      }
    }
  }

  List<BarChartGroupData> collectionsGroupedData = [];
  dailySales.forEach((dayIndex, salesData) {
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    var sortedSalesData = sortSalesData(salesData);

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
          color = Colors.grey; // Default color for unknown types
      }

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, color));
      cumulativeAmount += amount;
    });
    rodStackItems
        .sort((a, b) => colorOrder[a.color]!.compareTo(colorOrder[b.color]!));
    rodStackItems = rodStackItems.reversed.toList();
    print(rodStackItems);

    DateTime barDate = start.add(Duration(days: dayIndex));
    int dayOfMonth = barDate.day;

    collectionsGroupedData.add(BarChartGroupData(
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

  return collectionsGroupedData;
}

List<BarChartGroupData> processDataForCollectionsCountDaily2b(
    String jsonString, String startDate, String endDate, BuildContext context) {
  print("gjhjhj $jsonString");
  List<dynamic> jsonData = jsonDecode(jsonString)["daily_collection_summary"];
  print("gjhjhjjsonData $jsonData");

  DateTime start = DateTime.parse(startDate);
  DateTime end = start.add(Duration(days: 30));

  // Create a map for each day in the 31-day range
  Map<int, Map<String, double>> dailySales = {
    for (var i = 0; i < 31; i++) i: {}
  };

  for (var collectionItem in jsonData) {
    if (collectionItem is Map<String, dynamic>) {
      DateTime paymentDate = DateTime.parse(collectionItem['date_or_month']);
      if (paymentDate.isAfter(start.subtract(const Duration(days: 1))) &&
          paymentDate.isBefore(end.add(const Duration(days: 1)))) {
        int dayIndex = paymentDate.difference(start).inDays;
        String collectionType = collectionItem["collection_type"];
        double premium = collectionItem["total_amount"];

        dailySales[dayIndex]!.update(collectionType, (value) => value + premium,
            ifAbsent: () => premium);
      }
    }
  }

  List<BarChartGroupData> collectionsGroupedData = [];
  dailySales.forEach((dayIndex, salesData) {
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    var sortedSalesData = sortSalesData(salesData);

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
          color = Colors.grey; // Default color for unknown types
      }

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, color));
      cumulativeAmount += amount;
    });
    rodStackItems
        .sort((a, b) => colorOrder[a.color]!.compareTo(colorOrder[b.color]!));
    rodStackItems = rodStackItems.reversed.toList();
    print(rodStackItems);

    DateTime barDate = start.add(Duration(days: dayIndex));
    int dayOfMonth = barDate.day;
    int numberOfBars = dailySales.length;
    double chartWidth = MediaQuery.of(context).size.width;
    double maxBarWidth = 30; // Maximum width of a bar
    double minBarSpace = 4; // Minimum space between bars

    double barWidth = min(maxBarWidth, (chartWidth / (2 * numberOfBars))) + 2;
    double barsSpace = max(minBarSpace,
        (chartWidth - (barWidth * numberOfBars)) / (numberOfBars - 1));
    //print("barWidth $barWidth");
    //print("barWidth $barsSpace");

    // Add a bar for each day in the range
    collectionsGroupedData.add(BarChartGroupData(
      x: dayOfMonth, // Or use dayIndex if you prefer
      barRods: [
        BarChartRodData(
          toY: cumulativeAmount,
          rodStackItems: rodStackItems.isEmpty
              ? [BarChartRodStackItem(0, 0, Colors.transparent)]
              : rodStackItems,
          borderRadius: BorderRadius.zero,
          width: barWidth,
        ),
      ],
      barsSpace: barsSpace,
    ));
  });

  return collectionsGroupedData;
}

class SalesByAgent {
  final String agent_name;
  final double sales;
  SalesByAgent(this.agent_name, this.sales);
}

class CollectionTypeGrid extends StatelessWidget {
  final List<Map<String, dynamic>> collectionTypes = [
    {'type': 'Cash', 'color': Colors.blue},
    {'type': 'EFT', 'color': Colors.purple},
    {'type': 'Easypay', 'color': Colors.green},
    {'type': 'D/O', 'color': Colors.orange},
    {'type': 'Persal', 'color': Colors.grey},
    {'type': 'Sal. Ded.', 'color': Colors.yellow},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics:
            const ClampingScrollPhysics(), // To handle scrolling behavior properly
        padding: const EdgeInsets.all(0), // No padding inside the GridView
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6, // Number of columns
          crossAxisSpacing: 0, // Horizontal space between cards
          mainAxisSpacing: 0, // Vertical space between cards
          childAspectRatio: 1, // Aspect ratio of the cards
        ),
        itemCount: collectionTypes.length,
        itemBuilder: (context, index) {
          return Indicator(
            color: collectionTypes[index]['color']!,
            text: collectionTypes[index]['type'],
            isSquare: false, // Change to true if you want square shapes
          );
        },
      ),
    );
  }
}

Map<Color, int> colorOrder = {
  Colors.blue: 1, // Cash
  Colors.purple: 2, // EFT
  Colors.orange: 3, // Debit Order
  Colors.grey: 4, // Persal and default
  Colors.green: 5, // Easypay
  Colors.yellow: 6, // Salary Deduction
};
