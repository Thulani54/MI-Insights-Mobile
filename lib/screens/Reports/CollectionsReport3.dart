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

import '../../customwidgets/custom_date_range_picker.dart';

String jsonString = "";
List<BarChartGroupData> barChartData1 = [];
List<BarChartGroupData> barChartData2 = [];
List<BarChartGroupData> barChartData3 = [];
List<BarChartGroupData> barChartData4 = [];
Map<int, double> dailySalesCount1a = {};
bool isLoading = false;
bool isLoadingStackedBarGraph = false;
bool isShowingType = false;
List<SalesByBranch> salesbybranch = [];

DateTime datefrom = DateTime.now().subtract(Duration(days: 60));
DateTime dateto = DateTime.now();
int days_difference = 0;
List<salesgridmodel> sectionsList = [];
List<salesgridmodel> sectionsList2 = [];
int report_index = 0;
int sales_index = 0;
String data2 = "";
double maxY = 0;
double maxY2 = 0;
double maxY3 = 0;
double maxY4 = 0;
double maxY5 = 0;
double maxY6 = 0;
int touchedIndex = -1;
List<BarChartGroupData> barData = [];
List<PieChartSectionData> pieData = [];
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

class CollectionsReport extends StatefulWidget {
  const CollectionsReport({Key? key}) : super(key: key);

  @override
  State<CollectionsReport> createState() => _CollectionsReportState();
}

List<SalesByAgent> salesbyagent = [];
List<BarChartGroupData> collections_grouped_data = [];
List<Map<String, dynamic>> leads = [];
List<List<Map<String, dynamic>>> policies = [];
double _sliderPosition = 0.0; // Initial position for the sliding animation
int _selectedButton = 1;
Color dark = Constants.ctaColorLight;
Color normal = Colors.blue;
List<BarChartRodData> rods_data = [];
Color light = Constants.ctaColorLight.withOpacity(0.35);

class _CollectionsReportState extends State<CollectionsReport> {
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
    leads = [];
    barChartData1 = [];
    barChartData2 = [];
    barChartData3 = [];
    barChartData4 = [];

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

      getCollectionsReport(context, formattedStartDate, formattedEndDate);
      getCollectionsRepor3(context, formattedStartDate, formattedEndDate);
      getCollectionsReport2(context, formattedStartDate, formattedEndDate);
      setState(() {});
    } else {}
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
              "Collections Report",
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
                              InkWell(
                                onTap: () {
                                  print("fffhh");
                                  _animateButton(3);
                                  DateTime? startDate = DateTime.now();
                                  DateTime? endDate = DateTime.now();
                                  showCustomDateRangePicker(
                                    context,
                                    dismissible: true,
                                    minimumDate: DateTime.now()
                                        .subtract(const Duration(days: 360)),
                                    maximumDate: DateTime.now(),
                                    // endDate: endDate,
                                    //startDate: startDate,
                                    backgroundColor: Colors.white,
                                    primaryColor: Constants.ctaColorLight,
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
                                      print("currently loading ${dateRange}");
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

                                      getCollectionsReport(context,
                                          formattedStartDate, formattedEndDate);
                                      getCollectionsRepor3(context,
                                          formattedStartDate, formattedEndDate);
                                      getCollectionsReport2(context,
                                          formattedStartDate, formattedEndDate);
                                    },
                                    onCancelClick: () {
                                      setState(() {
                                        // endDate = null;
                                        //  startDate = null;
                                      });
                                    },
                                  );
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
                                      child: InkWell(
                                        onTap: () {
                                          print("fffhh");
                                          _animateButton(3);
                                          DateTime? startDate = DateTime.now();
                                          DateTime? endDate = DateTime.now();
                                          showCustomDateRangePicker(
                                            context,
                                            dismissible: true,
                                            minimumDate: DateTime.now()
                                                .subtract(
                                                    const Duration(days: 360)),
                                            maximumDate: DateTime.now(),
                                            endDate: endDate,
                                            startDate: startDate,
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

                                              getCollectionsReport(
                                                  context,
                                                  formattedStartDate,
                                                  formattedEndDate);
                                              getCollectionsRepor3(
                                                  context,
                                                  formattedStartDate,
                                                  formattedEndDate);
                                              getCollectionsReport2(
                                                  context,
                                                  formattedStartDate,
                                                  formattedEndDate);
                                            },
                                            onCancelClick: () {
                                              setState(() {
                                                // endDate = null;
                                                //  startDate = null;
                                              });
                                            },
                                          );
                                        },
                                        child: Text(
                                          'Select Dates',
                                          style: TextStyle(color: Colors.white),
                                        ),
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
                                    (MediaQuery.of(context).size.height / 1.9)),
                        itemCount: sectionsList.length,
                        padding: EdgeInsets.all(2.0),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                              onTap: () {},
                              child: Container(
                                height: 320,
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
                                                                    "R" +
                                                                        formatLargeNumber(sectionsList[index]
                                                                            .amount
                                                                            .toString()),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16.5,
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
                                                                        .only(
                                                                        top:
                                                                            0.0),
                                                                child: Text(
                                                                  sectionsList[
                                                                          index]
                                                                      .count
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12.5),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  maxLines: 1,
                                                                ),
                                                              )),
                                                              Center(
                                                                  child:
                                                                      Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        6.0),
                                                                child: Text(
                                                                  sectionsList[
                                                                          index]
                                                                      .id,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12.5,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
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
                    InkWell(
                      onTap: () {
                        isShowingType = !isShowingType;
                        setState(() {});
                      },
                      child: Center(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: Text(
                              isShowingType == false
                                  ? "Show Actual Collection By Type"
                                  : "Hide Actual Collection By Type",
                              style: TextStyle(
                                  color: Constants.ctaColorLight,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (isShowingType == true)
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 12),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width /
                                          (MediaQuery.of(context).size.height /
                                              1.9)),
                          itemCount: sectionsList2.length,
                          padding: EdgeInsets.all(2.0),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                                onTap: () {},
                                child: Container(
                                  height: 320,
                                  width:
                                      MediaQuery.of(context).size.width / 1.9,
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
                                                        decoration:
                                                            BoxDecoration(
                                                                /*  color: sales_index ==
                                                                    index
                                                                ? Colors.grey
                                                                    .withOpacity(
                                                                        0.2)
                                                                : Colors.grey
                                                                    .withOpacity(
                                                                        0.05),*/
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
                                                                  BorderRadius
                                                                      .circular(
                                                                          14),
                                                            ),
                                                            width:
                                                                MediaQuery.of(
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
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            10.0),
                                                                    child: Text(
                                                                      "R" +
                                                                          formatLargeNumber(sectionsList2[index]
                                                                              .amount
                                                                              .toString()),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16.5,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      maxLines:
                                                                          2,
                                                                    ),
                                                                  )),
                                                                ),
                                                                Center(
                                                                    child:
                                                                        Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              0.0),
                                                                  child: Text(
                                                                    _selectedButton ==
                                                                            1
                                                                        ? ((sectionsList2[index].amount / sectionsList[1].amount) *
                                                                                100)
                                                                            .toStringAsFixed(
                                                                                0)
                                                                        : _selectedButton ==
                                                                                2
                                                                            ? ((sectionsList2[index].amount / sectionsList[1].amount) * 100).toStringAsFixed(0)
                                                                            : _selectedButton == 3 && days_difference <= 31
                                                                                ? ((sectionsList2[index].amount / sectionsList[1].amount) * 100).toStringAsFixed(0)
                                                                                : ((sectionsList2[index].amount / sectionsList[1].amount) * 100).toStringAsFixed(0) + "%",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12.5),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    maxLines: 1,
                                                                  ),
                                                                )),
                                                                Center(
                                                                    child:
                                                                        Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          6.0),
                                                                  child: Text(
                                                                    sectionsList2[
                                                                            index]
                                                                        .id,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12.5,
                                                                        fontWeight:
                                                                            FontWeight.w500),
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
                    if (isShowingType == false)
                      Container(
                        height: 12,
                      ),
                    _selectedButton == 1
                        ? Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                                "Collections Overview (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                          )
                        : _selectedButton == 2
                            ? Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                    "Collections Overview (YTD - ${DateTime.now().year})"),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                    "Collections Overview (${formattedStartDate} to ${formattedEndDate})"),
                              ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.withOpacity(0.05)),
                          height: 250,
                          child: isLoadingStackedBarGraph == true
                              ? _selectedButton == 1
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: AspectRatio(
                                          aspectRatio: 1.66,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 16),
                                            child: LayoutBuilder(
                                              builder: (context, constraints) {
                                                final double barsSpace = 1.0 *
                                                    constraints.maxWidth /
                                                    200;

                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: BarChart(
                                                    BarChartData(
                                                      alignment:
                                                          BarChartAlignment
                                                              .center,
                                                      barTouchData:
                                                          BarTouchData(
                                                              enabled: false),
                                                      gridData: FlGridData(
                                                        show: true,
                                                        drawVerticalLine: false,
                                                        getDrawingHorizontalLine:
                                                            (value) {
                                                          return FlLine(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.10),
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
                                                        bottomTitles:
                                                            AxisTitles(
                                                          sideTitles:
                                                              SideTitles(
                                                            showTitles: true,
                                                            interval: 1,
                                                            getTitlesWidget:
                                                                (value, meta) {
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        0.0),
                                                                child: Text(
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
                                                                    top: 0.0),
                                                            child: Text(
                                                              'Days of the month',
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ),
                                                        topTitles: AxisTitles(
                                                          sideTitles:
                                                              SideTitles(
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
                                                          sideTitles:
                                                              SideTitles(
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
                                                          sideTitles:
                                                              SideTitles(
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
                                                                    fontSize:
                                                                        7.5),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      borderData: FlBorderData(
                                                          show: false),
                                                      groupsSpace: barsSpace,
                                                      barGroups: barChartData1,
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: AspectRatio(
                                              aspectRatio: 1.66,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16),
                                                child: LayoutBuilder(
                                                  builder:
                                                      (context, constraints) {
                                                    final double barsSpace =
                                                        1.2 *
                                                            constraints
                                                                .maxWidth /
                                                            200;

                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
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
                                                          gridData: FlGridData(
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
                                                                strokeWidth: 1,
                                                              );
                                                            },
                                                            getDrawingVerticalLine:
                                                                (value) {
                                                              return FlLine(
                                                                color:
                                                                    Colors.grey,
                                                                strokeWidth: 1,
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
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            0.0),
                                                                    child: Text(
                                                                      getMonthAbbreviation(
                                                                              value.toInt())
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              9.5),
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
                                                                  'Months of the Year',
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
                                                                    20,
                                                                getTitlesWidget:
                                                                    (value,
                                                                        meta) {
                                                                  return Text(
                                                                    formatLargeNumber2(value
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
                                                                  show: false),
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
                                                  const EdgeInsets.all(8.0),
                                              child: Card(
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
                                                                          style:
                                                                              TextStyle(fontSize: 6.5),
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
                                                                    child: Text(
                                                                      'Days of the month',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              11,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color:
                                                                              Colors.black),
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
                                                                        20,
                                                                    getTitlesWidget:
                                                                        (value,
                                                                            meta) {
                                                                      return Text(
                                                                        formatLargeNumber2(value
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
                                                      const EdgeInsets.all(8.0),
                                                  child: Card(
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
                                                                .only(top: 16),
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
                                                                            .withOpacity(0.10),
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
                                                                            padding:
                                                                                const EdgeInsets.all(0.0),
                                                                            child:
                                                                                Text(
                                                                              getMonthAbbreviation(value.toInt()).toString(),
                                                                              style: TextStyle(fontSize: 9.5),
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
                                                                            20,
                                                                        getTitlesWidget:
                                                                            (value,
                                                                                meta) {
                                                                          return Text(
                                                                            formatLargeNumber2(value.toInt().toString()),
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
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: CollectionTypeGrid(),
                    ),
                    _selectedButton == 1
                        ? Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 12),
                            child: Text(
                                "Collections - Top 10 Sales Agents (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                          )
                        : _selectedButton == 2
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 16.0, top: 12),
                                child: Text(
                                    "Collections - Top 10 Sales Agents (YTD - ${DateTime.now().year})"),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.only(left: 16.0, top: 12),
                                child: Text(
                                    "Collections - Top 10 Sales Agents (${formattedStartDate} to ${formattedEndDate})"),
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
                                          child: Text("Sales Agent Name"),
                                        )),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0.0),
                                                child: Text(
                                                  "Amount",
                                                  textAlign: TextAlign.left,
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
                          ],
                        )),
                      ),
                    ),
                    isLoading || salesbyagent.isEmpty
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
                        : Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 12),
                            child: ListView.builder(
                                itemCount: salesbyagent.length > 10
                                    ? 10
                                    : salesbyagent.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 45,
                                                child: Text("${index + 1} "),
                                              ),
                                              Expanded(
                                                  flex: 4,
                                                  child: Text(
                                                      "${salesbyagent[index].agent_name}")),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        child: Text(
                                                          "R${salesbyagent[index].sales.toStringAsFixed(0)}",
                                                          style: TextStyle(
                                                              fontSize: 13),
                                                          textAlign:
                                                              TextAlign.left,
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
                                                const EdgeInsets.only(top: 8.0),
                                            child: Container(
                                              height: 1,
                                              color:
                                                  Colors.grey.withOpacity(0.10),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                    Container(
                      height: (salesbybranch.length + 5) * 35,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: isLoading || salesbyagent.isEmpty
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
                              : Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: charts.BarChart(
                                    bardata5,
                                    animate: true,
                                    vertical: false,
                                    // Set a bar label decorator.
                                    // Example configuring different styles for inside/outside:
                                    //       barRendererDecorator: new charts.BarLabelDecorator(
                                    //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
                                    //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
                                    barRendererDecorator:
                                        new charts.BarLabelDecorator<String>(),
                                    // Hide domain axis.
                                    /*          domainAxis: new charts.OrdinalAxisSpec(
                                  renderSpec: new charts.NoneRenderSpec()),*/
                                    primaryMeasureAxis:
                                        new charts.NumericAxisSpec(
                                      renderSpec: new charts.NoneRenderSpec(),
                                      viewport:
                                          new charts.NumericExtents(0, maxY5),
                                    ),
                                    domainAxis: new charts.OrdinalAxisSpec(
                                      renderSpec:
                                          new charts.SmallTickRendererSpec(
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
                    ),
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
    isLoadingStackedBarGraph = false;
    DateTime now = DateTime.now();
    DateTime startDate = DateTime(now.year, now.month, 1);
    DateTime endDate = DateTime.now();

    _animateButton(1);
    sectionsList = [
      salesgridmodel("Expected", 0, 0),
      salesgridmodel("Actual", 0, 0),
      salesgridmodel("Variance", 0, 0),
    ];
    sectionsList2 = [
      salesgridmodel("Cash", 0, 0),
      salesgridmodel("Card", 0, 0),
      salesgridmodel("Easypay", 0, 0),
      salesgridmodel("Debit Order", 0, 0),
      salesgridmodel("Salary Deduction", 0, 0),
      salesgridmodel("Persal", 0, 0),
      salesgridmodel("Voucher", 0, 0),
    ];
    leads = [];

    super.initState();
  }

  Future<void> getCollectionsReport(
    BuildContext context,
    String date_from,
    String date_to,
  ) async {
    setState(() {
      isLoading = true;
    });
    String baseUrl =
        "${Constants.insightsBackendBaseUrl}collection/getCollectionItems";
    try {
      Map<String, String>? payload = {
        "cec_client_id": '["${Constants.cec_client_id}"]',
        "startDate": date_from,
        "endDate": date_to,
        "dateTypeFilter": "payment"
      };
      if (kDebugMode) {
        print("baseUrl $baseUrl");
      }
      List<Map<String, dynamic>> sales = [];
      Map<String, List<Map<String, dynamic>>> groupedSales = {};
      Map<String, List<Map<String, dynamic>>>? groupedSalesByBranch = {};

      await http.post(
          Uri.parse(
            baseUrl,
          ),
          body: payload,
          headers: {
            "Cookie":
                "userid=expiry=2021-04-25&client_modules=1001#1002#1003#1004#1005#1006#1007#1008#1009#1010#1011#1012#1013#1014#1015#1017#1018#1020#1021#1022#1024#1025#1026#1027#1028#1029#1030#1031#1032#1033#1034#1035&clientid=&empid=3&empfirstname=Mncedisi&emplastname=Khumalo&email=mncedisi@athandwe.co.za&username=mncedisi@athandwe.co.za&dob=8/28/1985 12:00:00 AM&fullname=Mncedisi Khumalo&userRole=5&userImage=mncedisi@athandwe.co.za.jpg&employedAt=branch&role=leader&branchid=6&branchname=Boulders&jobtitle=Administrative Assistant&dialing_strategy=Campaign Manager&clientname=Test 1 Funeral Parlour&foldername=maafrica&client_abbr=AS&pbx_account=pbx1051ef0a&soft_phone_ip=&agent_type=branch&mip_username=mnces@mip.co.za&agent_email=Mr Mncedisi Khumalo&ViciDial_phone_login=&ViciDial_phone_password=&ViciDial_agent_user=99&ViciDial_agent_password=&device_id=dC7JwXFwwdI:APA91bF0gTbuXlfT6wIcGMLY57Xo7VxUMrMH-MuFYL5PnjUVI0G5X1d3d90FNRb8-XmcjI40L1XqDH-KAc1KWnPpxNg8Z8SK4Ty0xonbz4L3sbKz3Rlr4hyBqePWx9ZfEp53vWwkZ3tx&servername=http://localhost:55661"
          }).then((value) {
        http.Response response = value;
        if (kDebugMode) {
          //print(response.bodyBytes);
          //print(response.statusCode);
          print("jgjhjh " + response.body);
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
          if (kDebugMode) {
            print("fghghg 300 ${response.body}");
          }
          //processDataForCollectionsCount(response.body);

          if (_selectedButton == 1) {
            barChartData1 = processDataForCollectionsCountDaily(response.body);
          }
          if (_selectedButton == 3 && days_difference <= 31) {
            barChartData3 = processDataForCollectionsCountDaily2b(
                response.body, date_from, date_to, context);
          }
          if (_selectedButton == 3 && days_difference > 31) {
            barChartData4 = processDataForCollectionsCountMonthly(
                response.body, date_from, date_to, context);
          }

          Map<int, Map<String, double>> monthlySales = {
            for (var month = 1; month <= 12; month++) month: {}
          };

          List<BarChartGroupData> collectionsGroupedData = [];

          if (kDebugMode) {
            print(barChartData1);
          }
          isLoadingStackedBarGraph = true;
          setState(() {});

          var jsonResponse = jsonDecode(response.body);
          jsonString = response.body;

          if (kDebugMode) {
            // print(jsonResponse);
          }

          if (jsonResponse is List) {
            sales = List<Map<String, dynamic>>.from(jsonResponse);
            leads = sales;

            collections_grouped_data = [];
            for (var sale in sales) {
              if (sale["payment_status"] == "paid") {
                sectionsList[1].count++;
                sectionsList[1].amount =
                    sectionsList[1].amount + sale["collected_premium"];
              } else if (sale["payment_status"] == "unpaid") {
                sectionsList[2].count++;
                sectionsList[2].amount =
                    sectionsList[2].amount + sale["premium"];
              }
              if (sale["collection_type"] == "Cash") {
                sectionsList2[0].count++;
                sectionsList2[0].amount =
                    sectionsList2[0].amount + sale["premium"];
              } else if (sale["collection_type"] == "EFT") {
                sectionsList2[1].count++;
                sectionsList2[1].amount =
                    sectionsList2[1].amount + sale["premium"];
              } else if (sale["collection_type"] == "Easypay") {
                sectionsList2[2].count++;
                sectionsList2[2].amount =
                    sectionsList2[2].amount + sale["premium"];
              } else if (sale["collection_type"] == "Debit Order") {
                sectionsList2[3].count++;
                sectionsList2[3].amount =
                    sectionsList2[3].amount + sale["premium"];
              } else if (sale["collection_type"] == "Salary Deduction") {
                sectionsList2[4].count++;
                sectionsList2[4].amount =
                    sectionsList2[4].amount + sale["premium"];
              } else if (sale["collection_type"] == "persal") {
                sectionsList2[5].count++;
                sectionsList2[5].amount =
                    sectionsList2[5].amount + sale["premium"];
              } else if (sale["collection_type"] == "Voucher") {
                sectionsList2[6].count++;
                sectionsList2[6].amount =
                    sectionsList2[6].amount + sale["premium"];
              } else {}
              DateTime date = DateTime.parse(sale['payment_date']);
              int month = date.month;
              String collectionType = sale["collection_type"];
              double premium = sale["premium"];

              monthlySales[month]!.update(
                  collectionType, (value) => value + premium,
                  ifAbsent: () => premium);
            }
            monthlySales.forEach((month, salesData) {
              double cumulativeAmount = 0.0;
              List<BarChartRodStackItem> rodStackItems = [];

              salesData.forEach((type, amount) {
                Color? color; // Define color based on the type
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
                  // Add more cases for different collection types
                  default:
                    //print("rgfggh $type");
                    color = Colors.grey; // Default color for unknown types
                }

                rodStackItems.add(BarChartRodStackItem(
                    cumulativeAmount, cumulativeAmount + amount, color!));
                cumulativeAmount += amount;
              });

              // Add a bar for the month, even if it's empty
              collectionsGroupedData.add(BarChartGroupData(
                x: month,
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
                barsSpace: 5,
              ));
            });

            barChartData2 = collectionsGroupedData;

            setState(() {});
          } else {
            int id_y = 1;
            maxY5 = 0;

            ordinalGroup = [
              OrdinalGroup(
                id: '1',
                data: ordinalList,
              ),
            ];
            setState(() {});
          }
        }
      });
      setState(() {
        isLoading = false;
      });
    } on Exception catch (_, exception) {
      setState(() {
        isLoading = false;
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

  Future<void> getCollectionsReport2(
    BuildContext context,
    String date_from,
    String date_to,
  ) async {
    setState(() {
      isLoading = true; // Start loading
    });
    //https: //uat.miinsightsapps.net/fieldV6/getLeadss?empId=3&searchKey=6&status=all&cec_client_id=1&type=field&startDate=2023-08-01&endDate=2023-08-31
    //String baseUrl = "${Constants.insightsBackendBaseUrl}parlour/getSalesAll?cec_client_id=${Constants.cec_client_id}&type=field&startDate=${date_from}&endDate=${date_to}";
    String baseUrl =
        "${Constants.insightsBackendBaseUrl}collection/getCashUp?cec_client_id=${Constants.cec_client_id}&start_date=${date_from}&end_date=${date_to}";
    try {
      if (kDebugMode) {
        print("baseUrl2 $baseUrl");
      }
      List<Map<String, dynamic>> sales = [];
      Map<String, List<Map<String, dynamic>>> groupedSales = {};
      Map<String, List<Map<String, dynamic>>>? groupedSalesByBranch = {};
      bottomTitles1 = [];
      salesbybranch = [];
      salesbyagent = [];
      setState(() {});
      await http.get(
          Uri.parse(
            baseUrl,
          ),
          // body: payload,
          headers: {
            "Cookie":
                "userid=expiry=2021-04-25&client_modules=1001#1002#1003#1004#1005#1006#1007#1008#1009#1010#1011#1012#1013#1014#1015#1017#1018#1020#1021#1022#1024#1025#1026#1027#1028#1029#1030#1031#1032#1033#1034#1035&clientid=&empid=3&empfirstname=Mncedisi&emplastname=Khumalo&email=mncedisi@athandwe.co.za&username=mncedisi@athandwe.co.za&dob=8/28/1985 12:00:00 AM&fullname=Mncedisi Khumalo&userRole=5&userImage=mncedisi@athandwe.co.za.jpg&employedAt=branch&role=leader&branchid=6&branchname=Boulders&jobtitle=Administrative Assistant&dialing_strategy=Campaign Manager&clientname=Test 1 Funeral Parlour&foldername=maafrica&client_abbr=AS&pbx_account=pbx1051ef0a&soft_phone_ip=&agent_type=branch&mip_username=mnces@mip.co.za&agent_email=Mr Mncedisi Khumalo&ViciDial_phone_login=&ViciDial_phone_password=&ViciDial_agent_user=99&ViciDial_agent_password=&device_id=dC7JwXFwwdI:APA91bF0gTbuXlfT6wIcGMLY57Xo7VxUMrMH-MuFYL5PnjUVI0G5X1d3d90FNRb8-XmcjI40L1XqDH-KAc1KWnPpxNg8Z8SK4Ty0xonbz4L3sbKz3Rlr4hyBqePWx9ZfEp53vWwkZ3tx&servername=http://localhost:55661"
          }).then((value) {
        http.Response response = value;
        if (kDebugMode) {
          //print(response.bodyBytes);
          //print(response.statusCode);
          //print("dggf " + response.body);
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
          if (kDebugMode) {
            // print("fghghg 500 ${response.body}");
          }
          var jsonResponse = jsonDecode(response.body);
          print("gnjhgjh ${jsonResponse}");

          if (kDebugMode) {
            // print(jsonResponse);
          }

          if (jsonResponse is List) {
            sales = List<Map<String, dynamic>>.from(jsonResponse);
            leads = sales;

            for (var sale in sales) {
              // print("ajh" + sale.toString());
              String employeeName =
                  sale["employee_name"] + " " + sale["employee_surname"];

              if (employeeName.isNotEmpty) {
                groupedSales.putIfAbsent(employeeName, () => []);
                groupedSales[employeeName]!.add(sale);
                if (kDebugMode) {
                  //print("achuy ${employeeName}" + sale.toString());
                }
              } else {
                if (kDebugMode) {
                  print("Sale does not have an employee: $sale");
                }
              }
              if (sale["branch_name"] != null) {
                String branch_name = sale["branch_name"];
                groupedSalesByBranch.putIfAbsent(branch_name, () => []);
                groupedSalesByBranch[branch_name]?.add(sale);
              }
            }
          } else {}

          int id_y = 1;
          maxY5 = 0;

          groupedSales.forEach((key, value) {
            double collectionAmount = 0.0;
            for (var value1 in value) {
              Map m1 = value1 as Map;
              collectionAmount = collectionAmount +
                      double.parse(m1["collected_premium"].toString()) ??
                  0.0;
            }
            if (key.isNotEmpty) {
              salesbyagent.add(SalesByAgent(key, collectionAmount));
              setState(() {});
            }
          });
          salesbyagent.sort((a, b) => b.sales.compareTo(a.sales));
          salesbybranch = [];
          bardata5 = [];

          groupedSalesByBranch.forEach((key, value) {
            double collection_amount = 0.0;
            value.forEach((value1) {
              Map m1 = value1 as Map;
              collection_amount =
                  collection_amount + m1["collected_premium"] ?? 0.0;
            });

            salesbybranch.add(SalesByBranch(key, collection_amount));
            if (key.isNotEmpty) {
              setState(() {});
            }
          });
          int _section_id = 0;

          salesbybranch.sort((a, b) => b.sales.compareTo(a.sales));
          for (var element in salesbybranch) {
            if (element.sales > maxY5) {
              maxY5 = element.sales;
            }

            bottomTitles1.add(element.branch_name);
            ordinary_sales.add(OrdinalSales(
                element.branch_name, double.parse(element.sales.toString())));

            barData.add(
              BarChartGroupData(
                x: id_y++,
                barRods: [
                  BarChartRodData(
                    toY: element.sales.toDouble(),
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.zero,
                    width: 12,
                  ),
                ],
              ),
            );
          }
          if (_selectedButton == 1) {
            ordinary_sales.sort((a, b) => b.sales.compareTo(a.sales));
          }
          //print("maxY5 ${maxY5}");

          bardata5.add(charts.Series<OrdinalSales, String>(
              id: 'BranchSales',
              domainFn: (OrdinalSales sale, _) => sale.branch,
              measureFn: (OrdinalSales sale, _) =>
                  double.parse(sale.sales.toStringAsFixed(0)),
              data: ordinary_sales,
              // Set a label accessor to control the text of the bar label.
              labelAccessorFn: (OrdinalSales sale, _) =>
                  'R${double.parse(sale.sales.toStringAsFixed(0))}'));

          //Map responsedata = jsonDecode(response.body);
          //print(responsedata["byAgent"]);
        }
      });
      setState(() {
        isLoading = false;
      });
    } on Exception catch (_, exception) {
      setState(() {
        isLoading = false;
      });
      //Exception exc = exception as Exception;
      print("exception $exception");
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

  Future<void> getCollectionsRepor3(
    BuildContext context,
    String date_from,
    String date_to,
  ) async {
    setState(() {
      isLoading = true; // Start loading
    });
    String baseUrl =
        "${Constants.insightsBackendBaseUrl}collection/getCollectionItems";
    try {
      Map<String, String>? payload = {
        "cec_client_id": '["${Constants.cec_client_id}"]',
        "startDate": date_from,
        "endDate": date_to,
        //"startDate": "2023-12-01",
        //"endDate": "2023-12-31",
        "dateTypeFilter": "collection"
      };
      if (kDebugMode) {
        print("baseUrl $baseUrl");
      }
      List<Map<String, dynamic>> sales = [];
      Map<String, List<Map<String, dynamic>>> groupedSales = {};
      Map<String, List<Map<String, dynamic>>>? groupedSalesByBranch = {};

      await http.post(
          Uri.parse(
            baseUrl,
          ),
          body: payload,
          headers: {
            "Cookie":
                "userid=expiry=2021-04-25&client_modules=1001#1002#1003#1004#1005#1006#1007#1008#1009#1010#1011#1012#1013#1014#1015#1017#1018#1020#1021#1022#1024#1025#1026#1027#1028#1029#1030#1031#1032#1033#1034#1035&clientid=&empid=3&empfirstname=Mncedisi&emplastname=Khumalo&email=mncedisi@athandwe.co.za&username=mncedisi@athandwe.co.za&dob=8/28/1985 12:00:00 AM&fullname=Mncedisi Khumalo&userRole=5&userImage=mncedisi@athandwe.co.za.jpg&employedAt=branch&role=leader&branchid=6&branchname=Boulders&jobtitle=Administrative Assistant&dialing_strategy=Campaign Manager&clientname=Test 1 Funeral Parlour&foldername=maafrica&client_abbr=AS&pbx_account=pbx1051ef0a&soft_phone_ip=&agent_type=branch&mip_username=mnces@mip.co.za&agent_email=Mr Mncedisi Khumalo&ViciDial_phone_login=&ViciDial_phone_password=&ViciDial_agent_user=99&ViciDial_agent_password=&device_id=dC7JwXFwwdI:APA91bF0gTbuXlfT6wIcGMLY57Xo7VxUMrMH-MuFYL5PnjUVI0G5X1d3d90FNRb8-XmcjI40L1XqDH-KAc1KWnPpxNg8Z8SK4Ty0xonbz4L3sbKz3Rlr4hyBqePWx9ZfEp53vWwkZ3tx&servername=http://localhost:55661"
          }).then((value) {
        http.Response response = value;
        if (kDebugMode) {
          //print(response.bodyBytes);
          //print(response.statusCode);
          print("jgjhjh " + response.body);
          //print(response.body);
        }
        if (response.statusCode != 200) {
          setState(() {
            isLoading = false; // Stop loading when request is complete
          });
        } else {
          //processDataForCollectionsCount(response.body);

          var jsonResponse = jsonDecode(response.body);
          jsonString = response.body;

          if (jsonResponse is List) {
            sales = List.from(jsonResponse);
            print("cxxcx " + sales.length.toString());

            for (var sale in sales) {
              print("dfdfv " + sale["premium"].toString());
              sectionsList[0].count++;
              sectionsList[0].amount = sectionsList[0].amount + sale["premium"];
              setState(() {});
            }
          }
        }
      });
      setState(() {
        //  isLoading = false;
      });
    } on Exception catch (_, exception) {
      setState(() {
        isLoading = false;
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
}

List<BarChartGroupData> processDataForCollectionsCountMonthly(
    String jsonString, String startDate, String endDate, BuildContext context) {
  List<dynamic> jsonData = jsonDecode(jsonString);

  DateTime start = DateTime.parse(startDate);
  DateTime end = DateTime.parse(endDate);
  int monthsInRange =
      ((end.year - start.year) * 12) + end.month - start.month + 1;

  // Initialize data structure for monthly sales within the date range
  Map<int, Map<String, double>> monthlySales = {
    for (var i = 0; i < monthsInRange; i++) i: {}
  };

  // Process the jsonData
  for (var collectionItem in jsonData) {
    if (collectionItem is Map<String, dynamic>) {
      DateTime paymentDate = DateTime.parse(collectionItem['payment_date']);
      if (paymentDate.isAfter(start.subtract(const Duration(days: 1))) &&
          paymentDate.isBefore(end.add(const Duration(days: 1)))) {
        int monthIndex = ((paymentDate.year - start.year) * 12) +
            paymentDate.month -
            start.month;
        String collectionType = collectionItem["collection_type"];
        double premium = collectionItem["premium"];

        monthlySales[monthIndex]!.update(
            collectionType, (value) => value + premium,
            ifAbsent: () => premium);
      }
    }
  }

  int numberOfBars = monthlySales.length;
  double chartWidth =
      MediaQuery.of(context).size.width; // Get the width of the device screen
  double maxBarWidth = 30; // Maximum width of a bar
  double minBarSpace = 4; // Minimum space between bars

  // Calculate the bar width and space based on the number of bars and chart width
  double barWidth = min(maxBarWidth, (chartWidth / (2 * numberOfBars)));
  double barsSpace = max(minBarSpace,
      (chartWidth - (barWidth * numberOfBars)) / (numberOfBars - 1));

  List<BarChartGroupData> collectionsGroupedData = [];
  monthlySales.forEach((monthIndex, salesData) {
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    salesData.forEach((type, amount) {
      Color? color; // Define color based on the type
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
        // Add more cases for different collection types
        default:
          //print("rgfggh $type");
          color = Colors.grey; // Default color for unknown types
      }

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, color!));
      cumulativeAmount += amount;
    });

    // Add a bar for each month in the range
    collectionsGroupedData.add(BarChartGroupData(
      x: monthIndex + 1, // Assuming months are 1-indexed
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

String getEmployeeById(
  int cec_employeeid,
) {
  String result = "";
  for (var employee in Constants.cec_employees) {
    if (employee['cec_employeeid'].toString() == cec_employeeid.toString()) {
      result = employee["employee_name"] + " " + employee["employee_surname"];
      print("fgfghg $result");
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
      print("fgfghg $result");
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
  int count;
  num amount;
  salesgridmodel(
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
  List<dynamic> jsonData = jsonDecode(jsonString);

  DateTime now = DateTime.now();
  int currentMonth = now.month;
  int currentYear = now.year;
  int daysInCurrentMonth = DateTime(currentYear, currentMonth + 1, 0).day;

  // Initialize data structure for daily sales for the current month
  Map<int, Map<String, double>> dailySales = {
    for (var day = 1; day <= daysInCurrentMonth; day++) day: {}
  };

  // Process the jsonData
  for (var collectionItem in jsonData) {
    if (collectionItem is Map<String, dynamic>) {
      DateTime date = DateTime.parse(collectionItem['payment_date']);
      if (date.month == currentMonth && date.year == currentYear) {
        int dayOfMonth = date.day;
        String collectionType = collectionItem["collection_type"];
        double premium = collectionItem["premium"];

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

    //Add purple and green

    salesData.forEach((type, amount) {
      Color? color; // Define color based on the type
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
        case 'persal':
          color = Colors.grey;
          break;
        case 'Easypay':
          color = Colors.green;
          break;

        case 'Salary Deduction':
          color = Colors.yellow;
          break;
        // Add more cases for different collection types
        default:
          //print("rgfggh $type");
          color = Colors.grey; // Default color for unknown types
      }

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, color!));
      cumulativeAmount += amount;
    });

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
  List<dynamic> jsonData = jsonDecode(jsonString);

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
        double premium = collectionItem["premium"];

        dailySales[dayIndex]!.update(collectionType, (value) => value + premium,
            ifAbsent: () => premium);
      }
    }
  }

  List<BarChartGroupData> collectionsGroupedData = [];
  dailySales.forEach((dayIndex, salesData) {
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    salesData.forEach((type, amount) {
      Color? color; // Define color based on the type
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
        // Add more cases for different collection types
        default:
          //print("rgfggh $type");
          color = Colors.grey; // Default color for unknown types
      }

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, color!));
      cumulativeAmount += amount;
    });
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
  List<dynamic> jsonData = jsonDecode(jsonString);

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
        double premium = collectionItem["premium"];

        dailySales[dayIndex]!.update(collectionType, (value) => value + premium,
            ifAbsent: () => premium);
      }
    }
  }

  List<BarChartGroupData> collectionsGroupedData = [];
  dailySales.forEach((dayIndex, salesData) {
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    salesData.forEach((type, amount) {
      Color? color; // Define color based on the type
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
        // Add more cases for different collection types
        default:
          //print("rgfggh $type");
          color = Colors.grey; // Default color for unknown types
      }

      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + amount, color!));
      cumulativeAmount += amount;
    });
    DateTime barDate = start.add(Duration(days: dayIndex));
    int dayOfMonth = barDate.day;
    int numberOfBars = dailySales.length;
    double chartWidth = MediaQuery.of(context).size.width;
    double maxBarWidth = 30; // Maximum width of a bar
    double minBarSpace = 4; // Minimum space between bars

    // Calculate the bar width and space based on the number of bars and chart width
    double barWidth = min(maxBarWidth, (chartWidth / (2 * numberOfBars))) + 2;
    double barsSpace = max(minBarSpace,
        (chartWidth - (barWidth * numberOfBars)) / (numberOfBars - 1));
    print("barWidth $barWidth");
    print("barWidth $barsSpace");

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
    {'type': 'D/O', 'color': Colors.orange},
    {'type': 'Persal', 'color': Colors.grey},
    {'type': 'Easypay', 'color': Colors.green},
    {'type': 'Salary Ded', 'color': Colors.yellow},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12),
      child: Container(
        child: GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
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
      ),
    );
  }
}
