import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:animate_do/animate_do.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:d_chart/commons/data_model/data_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mi_insights/constants/Constants.dart';
import 'package:mi_insights/services/longPrint.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:screenshot/screenshot.dart';

import '../../../admin/ClientSearchPage.dart';
import '../../../customwidgets/CustomCard.dart';
import '../../../customwidgets/custom_date_range_picker.dart';
import '../../../customwidgets/custom_treemap/pages/tree_diagram.dart';
import '../../../models/SalesByAgent.dart';
import '../../../models/SalesDataResponse.dart';
import '../../../models/Segment2.dart';
import '../../../services/Executive/executive_sales_report_service.dart';
import '../../../services/inactivitylogoutmixin.dart';
import '../../../services/window_manager.dart';
import '../../../utils/login_utils.dart';

String jsonString = "";
List<BarChartGroupData> barChartData1 = [];
List<BarChartGroupData> barChartData2 = [];
List<BarChartGroupData> barChartData3 = [];
List<BarChartGroupData> barChartData4 = [];
Map<int, double> dailySalesCount1a = {};
bool isLoading = false;
bool isLoadingApi = false;
bool isShowingType = false;
bool isShowingAPI = false;
int collections_grid_index = 0;
List<SalesByBranch> salesbybranch = [];
bool isSalesDataLoading1a = false;
bool isSalesDataLoading2a = false;
bool isSalesDataLoading3a = false;
DateTime datefrom = DateTime.now().subtract(Duration(days: 50));
DateTime dateto = DateTime.now();
int days_difference = 0;
List<gridmodel1> sectionsList = [];
List<gridmodel1> sectionsList2 = [];
int report_index = 0;
int grid_index_2 = 0;
int collections_index = 0;
int target_index = 0;
int target_index_2 = 0;
int target_index_9 = 0;
int target_index_10 = 0;
String data2 = "";
double maxY = 0;
double maxY2 = 0;
double maxY3 = 0;
double maxY4 = 0;
double maxY5 = 0;
double maxY6 = 0;
double based_on_sales = 0;
double based_on_first_premium_collected = 0;
double actual_api_collected = 0;
double based_on_sales1 = 0;
double based_on_first_premium_collected1 = 0;
double actual_api_collected1 = 0;
double actual_collected_premium = 0;
double expected_sum_of_premiums = 0;
double variance_sum_of_premiums = 0;
double variance_percentage = 0;
double actual_variance_percentage = 0;
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
Map<String, dynamic> collections_jsonResponse1a = {};
Map<String, dynamic> collections_jsonResponse2a = {};
Map<String, dynamic> collections_jsonResponse3a = {};
Map<String, dynamic> collections_jsonResponse4a = {};
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
String? _selectedYear;
List<String> _last6Years = [];
Map<String, Map<String, DateTime>> _yearRanges = {};

class SalesByBranch {
  final String branch_name;
  final double sales;
  SalesByBranch(this.branch_name, this.sales);
}

class ExecutiveCollectionsReport extends StatefulWidget {
  const ExecutiveCollectionsReport({Key? key}) : super(key: key);

  @override
  State<ExecutiveCollectionsReport> createState() =>
      _ExecutiveCollectionsReportState();
}

List<SalesByAgent> topsalesbyagent = [];

List<SalesByAgent> bottomsalesbyagent = [];
List<SalesByAgent> topsalesbyreceptionist = [];
List<EmployeeRate> topsalesbycollectionistRates = [];
List<EmployeeRate> topsalesbyreceptionistRates = [];
List<SalesByAgent> bottomsalesbyreceptionist = [];
List<BarChartGroupData> collections_grouped_data = [];
ScreenshotController screenshotController = ScreenshotController();
List<Map<String, dynamic>> leads = [];
List<List<Map<String, dynamic>>> policies = [];
double _sliderPosition = 0.0; // Initial position for the sliding animation
double _sliderPosition5 = 0.0;
double _sliderPosition2 = 0.0;
double _sliderPosition9 = 0.0;
int _selectedButton = 1;
Color dark = Constants.ctaColorLight;
Color normal = Colors.blue;
List<BarChartRodData> rods_data = [];
Color light = Constants.ctaColorLight.withOpacity(0.35);

class _ExecutiveCollectionsReportState extends State<ExecutiveCollectionsReport>
    with InactivityLogoutMixin {
  Color _button1Color = Colors.grey.withOpacity(0.0);
  Color _button2Color = Colors.grey.withOpacity(0.0);
  Color _button3Color = Colors.grey.withOpacity(0.0);
  List<OrdinalData> ordinalList = [
    OrdinalData(domain: 'Mon', measure: 3),
    OrdinalData(domain: 'Tue', measure: 5),
    OrdinalData(domain: 'Wed', measure: 9),
    OrdinalData(domain: 'Thu', measure: 6.5),
  ];
  GlobalKey _globalKey = GlobalKey();
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
    topsalesbyreceptionist = [];
    bottomsalesbyreceptionist = [];
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
      gridmodel1("PayAt", 0, 0),
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

      getCollectionsReport(context, formattedStartDate, formattedEndDate);

      setState(() {});
    } else {}
  }

  Future<void> _capturePng() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = (await getApplicationDocumentsDirectory()).path;
      File imgFile = File('$directory/screenshot.png');
      imgFile.writeAsBytes(pngBytes);

      print('Screenshot saved to $directory/screenshot.png');
    } catch (e) {
      print(e);
    }
  }

  void _animateButton2(int buttonNumber) {
    restartInactivityTimer();

    setState(() {});

    target_index = buttonNumber;
    if (buttonNumber == 0) {
      _sliderPosition2 = 0.0;
    } else if (buttonNumber == 1) {
      _sliderPosition2 = (MediaQuery.of(context).size.width / 2) - 18;
    } else if (buttonNumber == 3) {
      if (days_difference < 31) {
        _sliderPosition2 = 2 * (MediaQuery.of(context).size.width / 3) - 32;
      }
      setState(() {});
    }
  }

  void _animateButton9(int buttonNumber) {
    restartInactivityTimer();

    setState(() {});

    target_index_9 = buttonNumber;
    if (buttonNumber == 0) {
      _sliderPosition9 = 0.0;
    } else if (buttonNumber == 1) {
      _sliderPosition9 = (MediaQuery.of(context).size.width / 2) - 18;
    } else if (buttonNumber == 3) {
      if (days_difference < 31) {
        _sliderPosition9 = 2 * (MediaQuery.of(context).size.width / 3) - 32;
      }
      setState(() {});
    }
  }

  void _animateButton5(int buttonNumber) {
    restartInactivityTimer();

    setState(() {});

    grid_index_2 = buttonNumber;
    if (buttonNumber == 0) {
      _sliderPosition5 = 0.0;
    } else if (buttonNumber == 1) {
      _sliderPosition5 = (MediaQuery.of(context).size.width / 3) - 18;
    } else if (buttonNumber == 2) {
      _sliderPosition5 = 2 * (MediaQuery.of(context).size.width / 3) - 32;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                restartInactivityTimer();
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          actions: [
            if (Constants.myUserRoleLevel.toLowerCase() == "administrator" ||
                Constants.myUserRoleLevel.toLowerCase() == "underwriter")
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Dialog(
                            backgroundColor: Colors.white,
                            child: Container(
                              constraints: BoxConstraints(
                                  minHeight: 300, maxHeight: 400),

                              //padding: EdgeInsets.symmetric(horizontal: 20),
                              child: SingleChildScrollView(
                                physics: NeverScrollableScrollPhysics(),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClientSearchPage(onClientSelected: (val) {
                                      _animateButton(_selectedButton);
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Icon(CupertinoIcons.arrow_right_arrow_left)),
              )
          ],
          backgroundColor: Colors.white,
          centerTitle: true,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black.withOpacity(0.6),
          title: const Text(
            "Collections Report",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          elevation: 6,
        ),
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
                if (Constants.selectedClientName.isNotEmpty)
                  SizedBox(
                    height: 12,
                  ),
                if (Constants.selectedClientName.isNotEmpty)
                  Row(
                    children: [
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Text(
                          Constants.selectedClientName,
                          style: TextStyle(fontSize: 9.5, color: Colors.black),
                        ),
                      )
                    ],
                  ),
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
                                            BorderRadius.circular(350)),
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
                                            BorderRadius.circular(350)),
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
                                      minimumDate: DateTime.utc(2023, 06, 01),
                                      maximumDate: DateTime.now()
                                          .add(Duration(days: 350)),
                                      backgroundColor: Colors.white,
                                      primaryColor: Constants.ctaColorLight,
                                      onApplyClick: (start, end) {
                                        setState(() {
                                          endDate = end;
                                          startDate = start;
                                          _animateButton2(1);
                                          Future.delayed(Duration(seconds: 2))
                                              .then((value) {
                                            setState(() {});
                                          });
                                        });
                                        // print("fffhh $start");
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
                                        //print("currently loading1 ${dateRange}");
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
                                          //print("days_difference ${days_difference}");
                                          // print("formattedEndDate9 ${formattedEndDate}");
                                        }
                                        getCollectionsReport(
                                            context,
                                            formattedStartDate,
                                            formattedEndDate);

                                        restartInactivityTimer();
                                      },
                                      onCancelClick: () {
                                        //print("user cancelled.");
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
                                            BorderRadius.circular(350)),
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
                                            //print("fffhh");
                                            _animateButton(3);
                                            DateTime? startDate =
                                                DateTime.now();
                                            DateTime? endDate = DateTime.now();
                                            showCustomDateRangePicker(
                                              context,
                                              dismissible: true,
                                              minimumDate: DateTime.now()
                                                  .subtract(const Duration(
                                                      days: 350)),
                                              maximumDate: DateTime.now()
                                                  .add(Duration(days: 350)),
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
                                                //print("currently loading ${dateRange}");
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
                                                  //print("days_difference ${days_difference}");
                                                  // print("formattedEndDate9 ${formattedEndDate}");
                                                }

                                                getCollectionsReport(
                                                    context,
                                                    formattedStartDate,
                                                    formattedEndDate);
                                              },
                                              onCancelClick: () {
                                                //print("user cancelled.");
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
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 16,
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
                                      width: MediaQuery.of(context).size.width /
                                          2.9,
                                      child: Stack(
                                        children: [
                                          InkWell(
                                            onTap: () {},
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4.0, right: 8),
                                              child: Card(
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
                                                                    .ftaColorLight,
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
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            0,
                                                                        left: 0,
                                                                        bottom:
                                                                            4),
                                                                child:
                                                                    isLoading ==
                                                                            true
                                                                        ? Center(
                                                                            child:
                                                                                Padding(
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
                                                                                  formatLargeNumber2(expected_count_of_premiums.toString()),
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
                                      width: MediaQuery.of(context).size.width /
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
                                                                    .ftaColorLight,
                                                                width: 6))),
                                                    child: isLoading == true
                                                        ? Center(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Container(
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
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.45),
                                                                      border: Border.all(
                                                                          color: Colors.grey.withOpacity(
                                                                              0.0)),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
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
                                                                            height:
                                                                                8,
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
                                                                            padding:
                                                                                const EdgeInsets.only(top: 0.0),
                                                                            child:
                                                                                Text(
                                                                              formatLargeNumber2(count_of_premiums.toString()),
                                                                              style: TextStyle(fontSize: 12.5),
                                                                              textAlign: TextAlign.center,
                                                                              maxLines: 1,
                                                                            ),
                                                                          )),
                                                                          Center(
                                                                              child: Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(6.0),
                                                                            child:
                                                                                Text(
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
                                      width: MediaQuery.of(context).size.width /
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
                                                                    .ftaColorLight,
                                                                width: 6))),
                                                    child: isLoading == true
                                                        ? Center(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Container(
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
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.05),
                                                                      border: Border.all(
                                                                          color: Colors.grey.withOpacity(
                                                                              0.0)),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
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
                                                                            height:
                                                                                8,
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
                                                                            padding:
                                                                                const EdgeInsets.only(top: 0.0),
                                                                            child:
                                                                                Text(
                                                                              formatLargeNumber2(variance_count_of_premiums.toString()),
                                                                              style: TextStyle(fontSize: 12.5),
                                                                              textAlign: TextAlign.center,
                                                                              maxLines: 1,
                                                                            ),
                                                                          )),
                                                                          Center(
                                                                              child: Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(6.0),
                                                                            child:
                                                                                Text(
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
                            SizedBox(
                              width: 8,
                            ),
                          ],
                        ),

                        Screenshot(
                          controller: screenshotController,
                          child: InkWell(
                            onTap: () async {
                              final bytes =
                                  await screenshotController.capture();
                              print(bytes);
                              if (bytes != null) {
                                await saveImage(bytes);
                              }
                            },
                            child: Row(
                              children: [
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 42.0, top: 0),
                                  child: Text(
                                    "Updates real-time except D/O, 7 day lag",
                                    style: TextStyle(fontSize: 9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        _selectedButton == 1
                            ? Padding(
                                padding: EdgeInsets.only(left: 0.0, bottom: 0),
                                child: Center(
                                    child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, right: 16, bottom: 8),
                                        child: Text(
                                            "Collections Actual vs Expected (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                      ),
                                    )

                                    /*        Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Transform.scale(
                                        scale:
                                            0.9, // Adjust the scale factor to your preference
                                        child: CupertinoSwitch(
                                          value: _months12RollingswitchValue,
                                          onChanged: (bool value) {
                                            setState(() {
                                              _months12RollingswitchValue = value;
                                            });
                                          },
                                          activeColor: Constants.ctaColorLight,
                                        ),
                                      ),
                                    )*/
                                  ],
                                )),
                              )
                            : _selectedButton == 2
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0, right: 16, bottom: 8),
                                          child: Text(
                                              "Collections Actual vs Expected (12 Months View)"),
                                        ),
                                      )

                                      /*        Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Transform.scale(
                                        scale:
                                            0.9, // Adjust the scale factor to your preference
                                        child: CupertinoSwitch(
                                          value: _months12RollingswitchValue,
                                          onChanged: (bool value) {
                                            setState(() {
                                              _months12RollingswitchValue = value;
                                            });
                                          },
                                          activeColor: Constants.ctaColorLight,
                                        ),
                                      ),
                                    )*/
                                    ],
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, bottom: 12),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0,
                                                right: 16,
                                                bottom: 8),
                                            child: Text(
                                                "Collections Actual vs Expected (${formattedStartDate} to ${formattedEndDate})"),
                                          ),
                                        )

                                        /*        Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Transform.scale(
                                        scale:
                                            0.9, // Adjust the scale factor to your preference
                                        child: CupertinoSwitch(
                                          value: _months12RollingswitchValue,
                                          onChanged: (bool value) {
                                            setState(() {
                                              _months12RollingswitchValue = value;
                                            });
                                          },
                                          activeColor: Constants.ctaColorLight,
                                        ),
                                      ),
                                    )*/
                                      ],
                                    )),
                        RepaintBoundary(
                          key: _globalKey,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6.0, right: 6),
                            child: InkWell(
                              onTap: () {
                                _capturePng();
                              },
                              child: LinearPercentIndicator(
                                width: MediaQuery.of(context).size.width - 14,
                                animation: true,
                                lineHeight: 20.0,
                                animationDuration: 500,
                                percent: variance_percentage,
                                center: Text(
                                    "${(actual_variance_percentage * 100).toStringAsFixed(0)}%",
                                    style: TextStyle(
                                      color: actual_variance_percentage < 0.4
                                          ? Colors.black
                                          : Colors.white,
                                    )),
                                barRadius: ui.Radius.circular(12),
                                //linearStrokeCap: LinearStrokeCap.roundAll,
                                progressColor: variance_percentage < 1
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        _selectedButton == 1
                            ? Padding(
                                padding: EdgeInsets.only(left: 0.0, bottom: 0),
                                child: Center(
                                    child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, right: 16, bottom: 8),
                                        child: Text(
                                            "API And Actual Collection Mix (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                      ),
                                    )
                                  ],
                                )),
                              )
                            : _selectedButton == 2
                                ? Padding(
                                    padding:
                                        EdgeInsets.only(left: 0.0, bottom: 0),
                                    child: Center(
                                        child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0,
                                                right: 16,
                                                bottom: 8),
                                            child: Text(
                                                "API And Actual Collection Mix (12 Months View)"),
                                          ),
                                        )
                                      ],
                                    )),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, bottom: 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0,
                                                right: 16,
                                                bottom: 8),
                                            child: Text(
                                                "API And Actual Collection Mix (${formattedStartDate} to ${Constants.sales_formattedEndDate})"),
                                          ),
                                        )
                                      ],
                                    )),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(12)),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.10),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Center(
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _animateButton9(0);
                                          },
                                          child: Container(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2) -
                                                16,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(350)),
                                            height: 35,
                                            child: Center(
                                              child: Text(
                                                'Annual Premium Income',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _animateButton9(1);
                                          },
                                          child: Container(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2) -
                                                16,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(350)),
                                            child: Center(
                                              child: Text(
                                                'Actual Collection Mix',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
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
                                  left: _sliderPosition9,
                                  child: InkWell(
                                    onTap: () {
                                      // _animateButton2(3);
                                    },
                                    child: Container(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    2) -
                                                16,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Constants
                                              .ctaColorLight, // Color of the slider
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: target_index_9 == 0
                                            ? Center(
                                                child: Text(
                                                  'Annual Premium Income',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            : target_index_9 == 1
                                                ? Center(
                                                    child: Text(
                                                      'Actual Collection Mix',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  )
                                                : Container()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     restartInactivityTimer();
                        //     isShowingType = !isShowingType;
                        //     setState(() {});
                        //     restartInactivityTimer();
                        //   },
                        //   child: Center(
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Container(
                        //         decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(350),
                        //             color: Constants.ctaColorLight
                        //                 .withOpacity(0.1)),
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(8),
                        //           child: Text(
                        //             isShowingType == false
                        //                 ? "Show Actual Collection By Type"
                        //                 : "Hide Actual Collection By Type",
                        //             style: TextStyle(
                        //                 color: Constants.ctaColorLight,
                        //                 fontWeight: FontWeight.bold),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        if (target_index_9 == 1)
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 14.0, top: 12, bottom: 14, right: 16),
                            child: CustomCard(
                              surfaceTintColor: Colors.white,
                              elevation: 6,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.white70, width: 0),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 6.0, top: 4),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio:
                                              MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  (MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2.1)),
                                  itemCount: sectionsList2.length,
                                  padding: EdgeInsets.all(2.0),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                        onTap: () {
                                          restartInactivityTimer();
                                        },
                                        child: Container(
                                          height: 320,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.9,
                                          child: Stack(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  restartInactivityTimer();
                                                  collections_index = index;
                                                  setState(() {});
                                                  if (kDebugMode) {
                                                    print("collections_index " +
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 4.0,
                                                          right: 8),
                                                  child: Card(
                                                    elevation: 6,
                                                    surfaceTintColor:
                                                        Colors.white,
                                                    color: Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
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
                                                                        .ftaColorLight,
                                                                    width: 6))),
                                                        child: isLoading == true
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
                                                                          /*  color: collections_index ==
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
                                                                                child: isLoading == true
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
                                                                                        sum_of_premiums == 0
                                                                                            ? "0%"
                                                                                            : (_selectedButton == 1
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
                            ),
                          ),

                        /*  GestureDetector(
                          onTap: () {
                            restartInactivityTimer();
                            isShowingAPI = !isShowingAPI;
                            setState(() {});
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(350),
                                    color: Constants.ctaColorLight
                                        .withOpacity(0.1)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    _selectedButton == 3
                                        ? isShowingAPI == false
                                            ? "Show API (Annual Premium Income)"
                                            : "Hide API (Annual Premium Income)"
                                        : isShowingAPI == false
                                            ? "Show API (Annual Premium Income)"
                                            : "Hide API (Annual Premium Income)",
                                    style: TextStyle(
                                        color: Constants.ctaColorLight,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),*/
                        if (target_index_9 == 0)
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 14, right: 14, top: 16),
                            child: CustomCard(
                              surfaceTintColor: Colors.white,
                              elevation: 6,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.white70, width: 0),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Center(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2 -
                                                  24,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: GestureDetector(
                                                  onTap: () {},
                                                  child: Container(
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                        color: target_index_10 ==
                                                                0
                                                            ? Constants
                                                                .ctaColorLight
                                                            : Colors.grey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(350)),
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 24.0,
                                                                top: 0),
                                                        child: DropdownButton<
                                                            String>(
                                                          isExpanded: true,
                                                          value: _selectedYear,
                                                          icon: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 8.0),
                                                            child: Icon(Icons
                                                                .arrow_drop_down),
                                                          ),
                                                          onChanged: (String?
                                                              newValue) {
                                                            target_index_10 = 0;
                                                            setState(() {
                                                              _selectedYear =
                                                                  newValue!;
                                                              _getApiData(
                                                                  _selectedYear!);
                                                            });
                                                          },
                                                          selectedItemBuilder:
                                                              (BuildContext
                                                                  ctxt) {
                                                            return _last6Years
                                                                .map<Widget>(
                                                                    (item) {
                                                              return DropdownMenuItem(
                                                                  child: Center(
                                                                    child: Text(
                                                                        "Policy Yr - ${item}",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 12)),
                                                                  ),
                                                                  value: item);
                                                            }).toList();
                                                          },
                                                          items: _last6Years.map<
                                                              DropdownMenuItem<
                                                                  String>>((String
                                                              monthName) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: monthName,
                                                              child: Center(
                                                                child: Text(
                                                                  monthName,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  softWrap:
                                                                      false,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black, // Dropdown items text color
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          underline:
                                                              Container(), // Removes underline if not needed
                                                          dropdownColor: Colors
                                                              .white, // Dropdown background color
                                                          style: TextStyle(
                                                            color: Colors
                                                                .white, // This sets the selected item text color
                                                          ),
                                                          iconEnabledColor: Colors
                                                              .white, // Changes the dropdown icon color
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Center(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2 -
                                                  24,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: GestureDetector(
                                                  onTap: () {},
                                                  child: Container(
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                        color: target_index_10 ==
                                                                1
                                                            ? Constants
                                                                .ctaColorLight
                                                            : Colors.grey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(350)),
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 24.0,
                                                                top: 0),
                                                        child: DropdownButton<
                                                            String>(
                                                          isExpanded: true,
                                                          value: _selectedYear,
                                                          icon: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 8.0),
                                                            child: Icon(Icons
                                                                .arrow_drop_down),
                                                          ),
                                                          onChanged: (String?
                                                              newValue) {
                                                            target_index_10 = 1;
                                                            setState(() {
                                                              _selectedYear =
                                                                  newValue!;
                                                              _getApiData(
                                                                  _selectedYear!);
                                                            });
                                                          },
                                                          selectedItemBuilder:
                                                              (BuildContext
                                                                  ctxt) {
                                                            return _last6Years
                                                                .map<Widget>(
                                                                    (item) {
                                                              return DropdownMenuItem(
                                                                  child: Center(
                                                                    child: Text(
                                                                        "Calendar Yr - ${item}",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 12)),
                                                                  ),
                                                                  value: item);
                                                            }).toList();
                                                          },
                                                          items: _last6Years.map<
                                                              DropdownMenuItem<
                                                                  String>>((String
                                                              monthName) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: monthName,
                                                              child: Center(
                                                                child: Text(
                                                                  monthName,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  softWrap:
                                                                      false,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black, // Dropdown items text color
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          underline:
                                                              Container(), // Removes underline if not needed
                                                          dropdownColor: Colors
                                                              .white, // Dropdown background color
                                                          style: TextStyle(
                                                            color: Colors
                                                                .white, // This sets the selected item text color
                                                          ),
                                                          iconEnabledColor: Colors
                                                              .white, // Changes the dropdown icon color
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (target_index_10 == 0)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          children: [
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
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.9,
                                                      child: Stack(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              restartInactivityTimer();
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          0.0,
                                                                      right: 8),
                                                              child: Card(
                                                                elevation: 6,
                                                                surfaceTintColor:
                                                                    Colors
                                                                        .white,
                                                                color: Colors
                                                                    .white,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  side: BorderSide(
                                                                      color: Colors
                                                                          .white70,
                                                                      width: 0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16),
                                                                ),
                                                                child: ClipPath(
                                                                  clipper: ShapeBorderClipper(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(16))),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            border:
                                                                                Border(bottom: BorderSide(color: Constants.ftaColorLight, width: 6))),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Container(
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.grey.withOpacity(0.05),
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
                                                                                child: (isLoadingApi || isLoading) == true
                                                                                    ? Center(
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
                                                                                                "R" + formatLargeNumber3(based_on_sales1.toString()),
                                                                                                style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
                                                                                                textAlign: TextAlign.center,
                                                                                                maxLines: 2,
                                                                                              ),
                                                                                            )),
                                                                                          ),
                                                                                          Center(
                                                                                              child: Padding(
                                                                                            padding: const EdgeInsets.all(6.0),
                                                                                            child: Text(
                                                                                              "API On Sales",
                                                                                              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500),
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
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.9,
                                                      child: Stack(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              restartInactivityTimer();
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          0.0,
                                                                      right: 8),
                                                              child: Card(
                                                                elevation: 6,
                                                                surfaceTintColor:
                                                                    Colors
                                                                        .white,
                                                                color: Colors
                                                                    .white,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  side: BorderSide(
                                                                      color: Colors
                                                                          .white70,
                                                                      width: 0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16),
                                                                ),
                                                                child: ClipPath(
                                                                  clipper: ShapeBorderClipper(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(16))),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            border:
                                                                                Border(bottom: BorderSide(color: Constants.ftaColorLight, width: 6))),
                                                                    child: (isLoadingApi ||
                                                                                isLoading) ==
                                                                            true
                                                                        ? Center(
                                                                            child:
                                                                                Padding(
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
                                                                          )
                                                                        : Column(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05), border: Border.all(color: Colors.grey.withOpacity(0.0)), borderRadius: BorderRadius.circular(8)),
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
                                                                                                "R" + formatLargeNumber3(based_on_first_premium_collected1.toString()),
                                                                                                style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
                                                                                                textAlign: TextAlign.center,
                                                                                                maxLines: 2,
                                                                                              ),
                                                                                            )),
                                                                                          ),
                                                                                          Center(
                                                                                              child: Padding(
                                                                                            padding: const EdgeInsets.all(6.0),
                                                                                            child: Text(
                                                                                              "On 1st Premium",
                                                                                              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500),
                                                                                              textAlign: TextAlign.center,
                                                                                              maxLines: 2,
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
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.9,
                                                      child: Stack(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              restartInactivityTimer();
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          0.0,
                                                                      right: 0),
                                                              child: Card(
                                                                elevation: 6,
                                                                surfaceTintColor:
                                                                    Colors
                                                                        .white,
                                                                color: Colors
                                                                    .white,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  side: BorderSide(
                                                                      color: Colors
                                                                          .white70,
                                                                      width: 0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16),
                                                                ),
                                                                child: ClipPath(
                                                                  clipper: ShapeBorderClipper(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(16))),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            border:
                                                                                Border(bottom: BorderSide(color: Constants.ftaColorLight, width: 6))),
                                                                    child: (isLoadingApi ||
                                                                                isLoading) ==
                                                                            true
                                                                        ? Center(
                                                                            child:
                                                                                Padding(
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
                                                                          )
                                                                        : Column(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05), border: Border.all(color: Colors.grey.withOpacity(0.0)), borderRadius: BorderRadius.circular(8)),
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
                                                                                                "R" + formatLargeNumber3(actual_api_collected.toString()),
                                                                                                style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
                                                                                                textAlign: TextAlign.center,
                                                                                                maxLines: 2,
                                                                                              ),
                                                                                            )),
                                                                                          ),
                                                                                          Center(
                                                                                              child: Padding(
                                                                                            padding: const EdgeInsets.all(6.0),
                                                                                            child: Text(
                                                                                              "Actual Premium",
                                                                                              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500),
                                                                                              textAlign: TextAlign.center,
                                                                                              maxLines: 2,
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
                                          ],
                                        ),
                                      ),
                                    if (target_index_10 == 1)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          children: [
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
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.9,
                                                      child: Stack(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              restartInactivityTimer();
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          0.0,
                                                                      right: 8),
                                                              child: Card(
                                                                elevation: 6,
                                                                surfaceTintColor:
                                                                    Colors
                                                                        .white,
                                                                color: Colors
                                                                    .white,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  side: BorderSide(
                                                                      color: Colors
                                                                          .white70,
                                                                      width: 0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16),
                                                                ),
                                                                child: ClipPath(
                                                                  clipper: ShapeBorderClipper(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(16))),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            border:
                                                                                Border(bottom: BorderSide(color: Constants.ftaColorLight, width: 6))),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Container(
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.grey.withOpacity(0.05),
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
                                                                                child: (isLoadingApi || isLoading) == true
                                                                                    ? Center(
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
                                                                                                "R" + formatLargeNumber3(based_on_sales.toString()),
                                                                                                style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
                                                                                                textAlign: TextAlign.center,
                                                                                                maxLines: 2,
                                                                                              ),
                                                                                            )),
                                                                                          ),
                                                                                          Center(
                                                                                              child: Padding(
                                                                                            padding: const EdgeInsets.all(6.0),
                                                                                            child: Text(
                                                                                              "API On Sales",
                                                                                              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500),
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
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.9,
                                                      child: Stack(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              restartInactivityTimer();
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          0.0,
                                                                      right: 8),
                                                              child: Card(
                                                                elevation: 6,
                                                                surfaceTintColor:
                                                                    Colors
                                                                        .white,
                                                                color: Colors
                                                                    .white,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  side: BorderSide(
                                                                      color: Colors
                                                                          .white70,
                                                                      width: 0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16),
                                                                ),
                                                                child: ClipPath(
                                                                  clipper: ShapeBorderClipper(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(16))),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            border:
                                                                                Border(bottom: BorderSide(color: Constants.ftaColorLight, width: 6))),
                                                                    child: (isLoadingApi ||
                                                                                isLoading) ==
                                                                            true
                                                                        ? Center(
                                                                            child:
                                                                                Padding(
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
                                                                          )
                                                                        : Column(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05), border: Border.all(color: Colors.grey.withOpacity(0.0)), borderRadius: BorderRadius.circular(8)),
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
                                                                                                "R" + formatLargeNumber3(based_on_first_premium_collected.toString()),
                                                                                                style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
                                                                                                textAlign: TextAlign.center,
                                                                                                maxLines: 2,
                                                                                              ),
                                                                                            )),
                                                                                          ),
                                                                                          Center(
                                                                                              child: Padding(
                                                                                            padding: const EdgeInsets.all(6.0),
                                                                                            child: Text(
                                                                                              "On 1st Premium",
                                                                                              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500),
                                                                                              textAlign: TextAlign.center,
                                                                                              maxLines: 2,
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
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.9,
                                                      child: Stack(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              restartInactivityTimer();
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          0.0,
                                                                      right: 0),
                                                              child: Card(
                                                                elevation: 6,
                                                                surfaceTintColor:
                                                                    Colors
                                                                        .white,
                                                                color: Colors
                                                                    .white,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  side: BorderSide(
                                                                      color: Colors
                                                                          .white70,
                                                                      width: 0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16),
                                                                ),
                                                                child: ClipPath(
                                                                  clipper: ShapeBorderClipper(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(16))),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            border:
                                                                                Border(bottom: BorderSide(color: Constants.ftaColorLight, width: 6))),
                                                                    child: (isLoadingApi ||
                                                                                isLoading) ==
                                                                            true
                                                                        ? Center(
                                                                            child:
                                                                                Padding(
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
                                                                          )
                                                                        : Column(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05), border: Border.all(color: Colors.grey.withOpacity(0.0)), borderRadius: BorderRadius.circular(8)),
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
                                                                                                "R" + formatLargeNumber3(actual_api_collected1.toString()),
                                                                                                style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
                                                                                                textAlign: TextAlign.center,
                                                                                                maxLines: 2,
                                                                                              ),
                                                                                            )),
                                                                                          ),
                                                                                          Center(
                                                                                              child: Padding(
                                                                                            padding: const EdgeInsets.all(6.0),
                                                                                            child: Text(
                                                                                              "Actual Premium",
                                                                                              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500),
                                                                                              textAlign: TextAlign.center,
                                                                                              maxLines: 2,
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
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
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
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(
                                        "Collections Overview (12 Months View)"),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(
                                        "Collections Overview (${formattedStartDate} to ${formattedEndDate})"),
                                  ),

                        Padding(
                          padding: const EdgeInsets.only(left: 4, right: 4.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey.withOpacity(0.00)),
                              height: 250,
                              child: isLoading == false
                                  ? _selectedButton == 1
                                      ? barChartData1.isEmpty
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  left: 16.0,
                                                  right: 16,
                                                  top: 16),
                                              child: CustomCard(
                                                elevation: 6,
                                                surfaceTintColor: Colors.white,
                                                color: Colors.white,
                                                child: Container(
                                                    height: 250,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "No data available for the selected range",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        SizedBox(height: 12),
                                                        Icon(
                                                          Icons
                                                              .auto_graph_sharp,
                                                          color: Colors.grey,
                                                        )
                                                      ],
                                                    )),
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  top: 8.0,
                                                  right: 10),
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
                                                                        true,
                                                                    reservedSize:
                                                                        10,
                                                                    getTitlesWidget:
                                                                        (value,
                                                                            meta) {
                                                                      return Container();
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
                                          ? barChartData2.isEmpty
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 16.0,
                                                      right: 16,
                                                      top: 16),
                                                  child: CustomCard(
                                                    elevation: 6,
                                                    surfaceTintColor:
                                                        Colors.white,
                                                    color: Colors.white,
                                                    child: Container(
                                                        height: 250,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "No data available for the selected range",
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 12),
                                                            Icon(
                                                              Icons
                                                                  .auto_graph_sharp,
                                                              color:
                                                                  Colors.grey,
                                                            )
                                                          ],
                                                        )),
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0,
                                                          left: 12,
                                                          right: 12),
                                                  child: CustomCard(
                                                    elevation: 6,
                                                    surfaceTintColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16)),
                                                    color: Colors.white,
                                                    child: Padding(
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
                                                                    true,
                                                                reservedSize:
                                                                    15,
                                                                getTitlesWidget:
                                                                    (value,
                                                                        meta) {
                                                                  return Container();
                                                                },
                                                              ),
                                                            ),
                                                            rightTitles:
                                                                AxisTitles(
                                                              sideTitles:
                                                                  SideTitles(
                                                                showTitles:
                                                                    true,
                                                                reservedSize:
                                                                    15,
                                                                getTitlesWidget:
                                                                    (value,
                                                                        meta) {
                                                                  return Container();
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
                                                                  show: false),
                                                          barGroups:
                                                              barChartData2,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                          : _selectedButton == 3 &&
                                                  days_difference <= 31
                                              ? barChartData3.isEmpty
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 16.0,
                                                          right: 16,
                                                          top: 16),
                                                      child: CustomCard(
                                                        elevation: 6,
                                                        surfaceTintColor:
                                                            Colors.white,
                                                        color: Colors.white,
                                                        child: Container(
                                                            height: 250,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "No data available for the selected range",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 12),
                                                                Icon(
                                                                  Icons
                                                                      .auto_graph_sharp,
                                                                  color: Colors
                                                                      .grey,
                                                                )
                                                              ],
                                                            )),
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
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

                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child:
                                                                      BarChart(
                                                                    BarChartData(
                                                                      alignment:
                                                                          BarChartAlignment
                                                                              .center,
                                                                      barTouchData:
                                                                          BarTouchData(
                                                                              enabled: false),
                                                                      gridData:
                                                                          FlGridData(
                                                                        show:
                                                                            true,
                                                                        drawVerticalLine:
                                                                            false,
                                                                        getDrawingHorizontalLine:
                                                                            (value) {
                                                                          return FlLine(
                                                                            color:
                                                                                Colors.grey.withOpacity(0.10),
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
                                                                            padding:
                                                                                const EdgeInsets.only(top: 0.0),
                                                                            child:
                                                                                Text(
                                                                              'Days of the month',
                                                                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black),
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
                                                                                true,
                                                                            reservedSize:
                                                                                10,
                                                                            getTitlesWidget:
                                                                                (value, meta) {
                                                                              return Container();
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
                                                                              show: false),
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
                                                  ? barChartData4.isEmpty
                                                      ? Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 16.0,
                                                                  right: 16,
                                                                  top: 16),
                                                          child: CustomCard(
                                                            elevation: 6,
                                                            surfaceTintColor:
                                                                Colors.white,
                                                            color: Colors.white,
                                                            child: Container(
                                                                height: 250,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "No data available for the selected range",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            12),
                                                                    Icon(
                                                                      Icons
                                                                          .auto_graph_sharp,
                                                                      color: Colors
                                                                          .grey,
                                                                    )
                                                                  ],
                                                                )),
                                                          ),
                                                        )
                                                      : Padding(
                                                          padding:
                                                              EdgeInsets.only(),
                                                          child: CustomCard(
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
                                                                        top:
                                                                            16),
                                                                child:
                                                                    LayoutBuilder(
                                                                  builder: (context,
                                                                      constraints) {
                                                                    final double
                                                                        barsSpace =
                                                                        1.0 *
                                                                            constraints.maxWidth /
                                                                            200;

                                                                    return Column(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
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
                                                                                      showTitles: true,
                                                                                      reservedSize: 15,
                                                                                      getTitlesWidget: (value, meta) {
                                                                                        return Container();
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
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12.0, right: 12, top: 8),
                                      child: CustomCard(
                                          elevation: 5,
                                          surfaceTintColor: Colors.white,
                                          color: Colors.white,
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: 18,
                                                height: 18,
                                                child:
                                                    CircularProgressIndicator(
                                                  color:
                                                      Constants.ctaColorLight,
                                                  strokeWidth: 1.8,
                                                ),
                                              ),
                                            ),
                                          )),
                                    )),
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
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: CollectionTypeGrid(),
                        ),
                        SizedBox(height: 8),
                        _selectedButton == 1
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 16.0, top: 12),
                                child: Text(
                                    "Customer Payment Preferences (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                              )
                            : _selectedButton == 2
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 12),
                                    child: Text(
                                        "Customer Payment Preferences (12 Months View)"),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 12),
                                    child: Text(
                                        "Customer Payment Preferences (${formattedStartDate} to ${formattedEndDate})"),
                                  ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(12)),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.10),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Center(
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _animateButton5(0);
                                          },
                                          child: Container(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3) -
                                                12,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(350)),
                                            height: 35,
                                            child: Center(
                                              child: Text(
                                                'Method',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _animateButton5(1);
                                          },
                                          child: Container(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3) -
                                                12,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(350)),
                                            child: Center(
                                              child: Text(
                                                'Bank',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _animateButton5(2);
                                          },
                                          child: Container(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3) -
                                                12,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(350)),
                                            child: Center(
                                              child: Text(
                                                'Cash Point',
                                                style: TextStyle(
                                                    color: Colors.black),
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
                                  left: _sliderPosition5,
                                  child: InkWell(
                                    onTap: () {
                                      _animateButton5(2);
                                    },
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: Constants
                                            .ctaColorLight, // Color of the slider
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: grid_index_2 == 0
                                          ? Center(
                                              child: Text(
                                                'Method',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          : grid_index_2 == 1
                                              ? Center(
                                                  child: Text(
                                                    'Bank',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              : Center(
                                                  child: Text(
                                                    'Cash Point',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        grid_index_2 == 0
                            ? isLoading == true
                                ? Container(
                                    height: 350,
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8, top: 16),
                                      child: CustomCard(
                                          elevation: 5,
                                          surfaceTintColor: Colors.white,
                                          color: Colors.white,
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: 18,
                                                height: 18,
                                                child:
                                                    CircularProgressIndicator(
                                                  color:
                                                      Constants.ctaColorLight,
                                                  strokeWidth: 1.8,
                                                ),
                                              ),
                                            ),
                                          )),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 400,
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 6.0,
                                            right: 8,
                                            top: 4,
                                            bottom: 8),
                                        child: CustomCard(
                                          elevation: 5,
                                          surfaceTintColor: Colors.white,
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              (Constants.customers_segment_1a
                                                          .length ==
                                                      0)
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 16.0,
                                                          right: 16,
                                                          top: 16),
                                                      child: Container(
                                                          height: 320,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "No data available for the selected range",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 12),
                                                              Icon(
                                                                Icons
                                                                    .auto_graph_sharp,
                                                                color:
                                                                    Colors.grey,
                                                              )
                                                            ],
                                                          )),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 0,
                                                              bottom: 8,
                                                              left: 8.0,
                                                              right: 8),
                                                      child: Container(
                                                        height: 320,
                                                        child: PieChart(
                                                          PieChartData(
                                                            centerSpaceRadius:
                                                                0,
                                                            sections: [
                                                              if (Constants
                                                                      .customers_segment_1a
                                                                      .length >
                                                                  0)
                                                                PieChartSectionData(
                                                                  color: Constants
                                                                      .customers_segment_1a[
                                                                          0]
                                                                      .color,
                                                                  value: 30 +
                                                                      Constants
                                                                          .customers_segment_1a[
                                                                              0]
                                                                          .pecentage,
                                                                  title:
                                                                      '${Constants.customers_segment_1a[0].pecentage.toStringAsFixed(1)}',
                                                                  radius: (MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          2) -
                                                                      86,
                                                                  titleStyle: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color(
                                                                          0xffffffff)),
                                                                ),
                                                              if (Constants
                                                                      .customers_segment_1a
                                                                      .length >
                                                                  1)
                                                                PieChartSectionData(
                                                                  color: Constants
                                                                      .customers_segment_1a[
                                                                          1]
                                                                      .color,
                                                                  value: 30 +
                                                                      Constants
                                                                          .customers_segment_1a[
                                                                              1]
                                                                          .pecentage,
                                                                  title:
                                                                      '${Constants.customers_segment_1a[1].pecentage.toStringAsFixed(1)}',
                                                                  radius: (MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          2) -
                                                                      86,
                                                                  titleStyle: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color(
                                                                          0xffffffff)),
                                                                ),
                                                              if (Constants
                                                                      .customers_segment_1a
                                                                      .length >
                                                                  2)
                                                                PieChartSectionData(
                                                                  color: Constants
                                                                      .customers_segment_1a[
                                                                          2]
                                                                      .color,
                                                                  value: 30 +
                                                                      Constants
                                                                          .customers_segment_1a[
                                                                              2]
                                                                          .pecentage,
                                                                  title:
                                                                      '${Constants.customers_segment_1a[2].pecentage.toStringAsFixed(1)}',
                                                                  radius: (MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          2) -
                                                                      86,
                                                                  titleStyle: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color(
                                                                          0xffffffff)),
                                                                ),
                                                              if (Constants
                                                                      .customers_segment_1a
                                                                      .length >
                                                                  3)
                                                                PieChartSectionData(
                                                                  color: Constants
                                                                      .customers_segment_1a[
                                                                          3]
                                                                      .color,
                                                                  value: 30 +
                                                                      Constants
                                                                          .customers_segment_1a[
                                                                              3]
                                                                          .pecentage,
                                                                  title:
                                                                      '${Constants.customers_segment_1a[3].pecentage.toStringAsFixed(1)}',
                                                                  radius: (MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          2) -
                                                                      86,
                                                                  titleStyle: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color(
                                                                          0xffffffff)),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                              Container(
                                                  height: 28,
                                                  child: CollectionsTypeGrid()),
                                              SizedBox(height: 16),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                            : grid_index_2 == 1
                                ? isLoading == true
                                    ? Container(
                                        height: 350,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: CustomCard(
                                              elevation: 5,
                                              surfaceTintColor: Colors.white,
                                              color: Colors.white,
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    width: 18,
                                                    height: 18,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Constants
                                                          .ctaColorLight,
                                                      strokeWidth: 1.8,
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ),
                                      )
                                    : (Constants.cutomers_banks_barChartData1a
                                                .length ==
                                            0)
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                left: 12.0, right: 12, top: 12),
                                            child: CustomCard(
                                              elevation: 6,
                                              surfaceTintColor: Colors.white,
                                              color: Colors.white,
                                              child: Container(
                                                  height: 600,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "No data available for the selected range",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      SizedBox(height: 12),
                                                      Icon(
                                                        Icons.auto_graph_sharp,
                                                        color: Colors.grey,
                                                      )
                                                    ],
                                                  )),
                                            ),
                                          )
                                        : Container(
                                            height: 400,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 12.0,
                                                  left: 14,
                                                  right: 12),
                                              child: CustomCard(
                                                elevation: 5,
                                                surfaceTintColor: Colors.white,
                                                color: Colors.white,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
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
                                                            reservedSize: 40,
                                                            getTitlesWidget:
                                                                (value, meta) {
                                                              Widget image =
                                                                  Container();
                                                              String bankname =
                                                                  Constants.cutomers_banks_names1a[
                                                                          value
                                                                              .round()]
                                                                      [
                                                                      "bankname"];
                                                              if (bankname
                                                                      .toLowerCase() ==
                                                                  "CAPITEC"
                                                                      .toLowerCase()) {
                                                                image =
                                                                    Image.asset(
                                                                  "assets/icons/bank_icons/capitec.png",
                                                                  height: 50,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                );
                                                              } else if (bankname
                                                                      .toLowerCase() ==
                                                                  "STANDARD BANK"
                                                                      .toLowerCase()) {
                                                                image =
                                                                    Image.asset(
                                                                  "assets/icons/bank_icons/standard_bank.png",
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  height: 25,
                                                                  width: 25,
                                                                );
                                                              } else if (bankname
                                                                      .toLowerCase() ==
                                                                  "NEDBANK"
                                                                      .toLowerCase()) {
                                                                image =
                                                                    Image.asset(
                                                                  "assets/icons/bank_icons/nedbank.png",
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  height: 28,
                                                                  width: 28,
                                                                );
                                                              } else if (bankname
                                                                      .toLowerCase() ==
                                                                  "TYMEBANK"
                                                                      .toLowerCase()) {
                                                                image =
                                                                    Image.asset(
                                                                  "assets/icons/bank_icons/tymebank.png",
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  height: 30,
                                                                  width: 30,
                                                                );
                                                              } else if (bankname
                                                                      .toLowerCase() ==
                                                                  "FNB"
                                                                      .toLowerCase()) {
                                                                image =
                                                                    Image.asset(
                                                                  "assets/icons/bank_icons/fnb.png",
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  height: 28,
                                                                  width: 28,
                                                                );
                                                              } else if (bankname
                                                                      .toLowerCase() ==
                                                                  "ABSA"
                                                                      .toLowerCase()) {
                                                                image =
                                                                    Image.asset(
                                                                  "assets/icons/bank_icons/absa.png",
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  height: 30,
                                                                  width: 30,
                                                                );
                                                              } else if (bankname
                                                                      .toLowerCase() ==
                                                                  "AFRICAN BANK"
                                                                      .toLowerCase()) {
                                                                image =
                                                                    Image.asset(
                                                                  "assets/icons/bank_icons/african_bank.png",
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  height: 30,
                                                                  width: 30,
                                                                );
                                                              } else if (bankname
                                                                      .toLowerCase() ==
                                                                  "OLD MUTUAL BANK"
                                                                      .toLowerCase()) {
                                                                image =
                                                                    Image.asset(
                                                                  "assets/icons/bank_icons/old_mutual.png",
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  height: 35,
                                                                  width: 35,
                                                                );
                                                              } else if (bankname
                                                                      .toLowerCase() ==
                                                                  "DISCOVERY BANK"
                                                                      .toLowerCase()) {
                                                                image =
                                                                    Image.asset(
                                                                  "assets/icons/bank_icons/discovery.png",
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  height: 30,
                                                                  width: 30,
                                                                );
                                                              }

                                                              return image;
                                                            },
                                                          ),
                                                          axisNameWidget:
                                                              Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 0.0),
                                                            child: Text(
                                                              'Bank',
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
                                                            showTitles: true,
                                                            getTitlesWidget:
                                                                (value, meta) {
                                                              String
                                                                  bank_count =
                                                                  (Constants.cutomers_banks_names1a[value.round()]
                                                                              [
                                                                              "count"] ??
                                                                          "0")
                                                                      .toString();
                                                              return Text(
                                                                formatLargeNumber4(
                                                                    bank_count
                                                                        .toString()),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10.5),
                                                              );
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
                                                            reservedSize: 25,
                                                            getTitlesWidget:
                                                                (value, meta) {
                                                              return Text(
                                                                value
                                                                        .toInt()
                                                                        .toString() +
                                                                    "%",
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
                                                      groupsSpace: 8,
                                                      barGroups: Constants
                                                          .cutomers_banks_barChartData1a,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                : _selectedButton == 1
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12.0, left: 14, right: 12),
                                        child: Container(
                                          height: 600,
                                          key: Constants.collections_tree_key1a,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: CustomCard(
                                            elevation: 6,
                                            surfaceTintColor: Colors.white,
                                            color: Colors.white,
                                            child: Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: CustomTreemap(
                                                    treeMapdata:
                                                        collections_jsonResponse1a),
                                              ),
                                            ),
                                          ),
                                        ))
                                    : _selectedButton == 2
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                              left: 16.0,
                                              right: 16,
                                              top: 12.0,
                                            ),
                                            child: FadeOut(
                                              child: Container(
                                                height: 500,
                                                key: Constants
                                                    .collections_tree_key2a,
                                                child: Card(
                                                  elevation: 6,
                                                  surfaceTintColor:
                                                      Colors.white,
                                                  color: Colors.white,
                                                  child: Container(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: CustomTreemap(
                                                          treeMapdata:
                                                              collections_jsonResponse2a),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ))
                                        : _selectedButton == 3 &&
                                                days_difference <= 31
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                  left: 16.0,
                                                  right: 16,
                                                  top: 12.0,
                                                ),
                                                child: Container(
                                                  key: Constants
                                                      .collections_tree_key3a,
                                                  height: 500,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Card(
                                                    elevation: 6,
                                                    surfaceTintColor:
                                                        Colors.white,
                                                    color: Colors.white,
                                                    child: Container(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        child: CustomTreemap(
                                                            treeMapdata:
                                                                collections_jsonResponse3a

                                                            //  treeMapdata: jsonResponse1["reorganized_by_module"],

                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ))
                                            : Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16.0, right: 16),
                                                child: Container(
                                                  key: Constants
                                                      .collections_tree_key4a,
                                                  height: 500,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Card(
                                                    elevation: 6,
                                                    surfaceTintColor:
                                                        Colors.white,
                                                    color: Colors.white,
                                                    child: Container(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        child: CustomTreemap(
                                                            treeMapdata:
                                                                collections_jsonResponse4a

                                                            //  treeMapdata: jsonResponse1["reorganized_by_module"],

                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                )),

                        /* Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 4, top: 12),
                                  child: GestureDetector(
                                    onTap: () {
                                      collections_grid_index = 0;
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 38,
                                      decoration: BoxDecoration(
                                          color: (collections_grid_index == 0)
                                              ? Constants.ctaColorLight
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: (collections_grid_index == 0)
                                                ? Constants.ctaColorLight
                                                    .withOpacity(0.35)
                                                : Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Center(
                                          child: Text(
                                        "By Sales Agent",
                                        style: TextStyle(
                                            color: (collections_grid_index == 0)
                                                ? Colors.white
                                                : Colors.grey),
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4.0, right: 12, top: 12),
                                  child: GestureDetector(
                                    onTap: () {
                                      collections_grid_index = 1;
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 38,
                                      decoration: BoxDecoration(
                                          color: (collections_grid_index == 1)
                                              ? Constants.ctaColorLight
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: (collections_grid_index == 1)
                                                ? Constants.ctaColorLight
                                                    .withOpacity(0.35)
                                                : Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Center(
                                          child: Text(
                                        "By Collections Agent",
                                        style: TextStyle(
                                            color: (collections_grid_index == 1)
                                                ? Colors.white
                                                : Colors.grey),
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),*/
                        SizedBox(height: 0),

                        if (collections_grid_index == 0)
                          _selectedButton == 1
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                    left: 16.0,
                                    top: 32,
                                    right: 16,
                                  ),
                                  child: Text(
                                      "Collections By Top 10 Agents (MTD- ${getMonthAbbreviation(DateTime.now().month)})"),
                                )
                              : _selectedButton == 2
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16.0,
                                        top: 32,
                                        right: 16,
                                      ),
                                      child: Text(
                                          "Collections By Top 10 Agents (12 Months View)"),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16.0,
                                        top: 32,
                                        right: 16,
                                      ),
                                      child: Text(
                                          "Collections By Top 10 Agents (${formattedStartDate} to ${formattedEndDate})"),
                                    ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(12)),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.10),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Center(
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _animateButton2(0);
                                          },
                                          child: Container(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2) -
                                                16,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(350)),
                                            height: 35,
                                            child: Center(
                                              child: Text(
                                                'By Sales Agent',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _animateButton2(1);
                                            Future.delayed(Duration(seconds: 1))
                                                .then((value) {
                                              setState(() {});
                                            });
                                          },
                                          child: Container(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2) -
                                                16,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(350)),
                                            child: Center(
                                              child: Text(
                                                'By Collections Agent',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
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
                                  left: _sliderPosition2,
                                  child: InkWell(
                                    onTap: () {
                                      // _animateButton2(3);
                                    },
                                    child: Container(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    2) -
                                                16,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Constants
                                              .ctaColorLight, // Color of the slider
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: target_index == 0
                                            ? Center(
                                                child: Text(
                                                  'By Sales Agent',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            : target_index == 1
                                                ? Center(
                                                    child: Text(
                                                      'By Collections Agent',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  )
                                                : Container()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (target_index == 0)
                          AgentPersistencyWidget(
                            selectedButton: _selectedButton,
                            daysDifference: days_difference,
                            isLoading: isLoading,
                          ),

                        if (target_index == 1)
                          SalesCollectionAgentWidget(
                            salesCollectionAgent: topsalesbyreceptionistRates,
                          ),
                        if (collections_grid_index == 0)
                          _selectedButton == 1
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 24, right: 16),
                                  child: Text(
                                      "Collections - Bottom 10 Sales Agents (MTD- ${getMonthAbbreviation(DateTime.now().month)})"),
                                )
                              : _selectedButton == 2
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, top: 24, right: 16),
                                      child: Text(
                                          "Collections - Bottom 10 Sales Agents (12 Months View)"),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16.0,
                                        top: 24,
                                        right: 16,
                                      ),
                                      child: Text(
                                          "Collections - Bottom 10 Sales Agents (${formattedStartDate} to ${formattedEndDate})"),
                                    ),
                        if (collections_grid_index == 0)
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 12, top: 8, bottom: 8),
                            child: CustomCard3(
                              elevation: 6,
                              surfaceTintColor: Colors.white,
                              color: Colors.white,
                              boderRadius: 20,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                  child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.35),
                                        borderRadius:
                                            BorderRadius.circular(36)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 28,
                                            height: 28,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(350)),
                                            child: Center(
                                              child: Text(
                                                "#",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 10,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20.0),
                                                child: Text("Sales Agent Name"),
                                              )),
                                          Expanded(
                                            flex: 4,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text(
                                                "Amount",
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8),
                                    child: isLoading == true
                                        ? Center(
                                            child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: 18,
                                                height: 18,
                                                child:
                                                    CircularProgressIndicator(
                                                  color:
                                                      Constants.ctaColorLight,
                                                  strokeWidth: 1.8,
                                                ),
                                              ),
                                            ),
                                          ))
                                        : (bottomsalesbyagent.length == 0)
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Center(
                                                  child: Text(
                                                    "No data available for the selected range",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: ListView.builder(
                                                    padding: EdgeInsets.only(
                                                        top: 0, bottom: 0),
                                                    itemCount:
                                                        bottomsalesbyagent
                                                                    .length >
                                                                10
                                                            ? 10
                                                            : bottomsalesbyagent
                                                                .length,
                                                    shrinkWrap: true,
                                                    reverse: false,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Container(
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    width: 35,
                                                                    child: Text(
                                                                        "${((index).abs()) + 1} "),
                                                                  ),
                                                                  Expanded(
                                                                      flex: 10,
                                                                      child: Text(
                                                                          "${extractFirstAndLastName(bottomsalesbyagent.reversed.toList()[index].agent_name.trimLeft())}")),
                                                                  Expanded(
                                                                    flex: 4,
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(
                                                                                left: 8,
                                                                              ),
                                                                              child: Text(
                                                                                "R${formatLargeNumber2(bottomsalesbyagent.reversed.toList()[index].sales.toStringAsFixed(0))}",
                                                                                style: TextStyle(fontSize: 13),
                                                                                textAlign: TextAlign.left,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            8.0),
                                                                child:
                                                                    Container(
                                                                  height: 1,
                                                                  color: Colors
                                                                      .grey
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
                                  ),
                                ],
                              )),
                            ),
                          ),
                        if (collections_grid_index == 1)
                          _selectedButton == 1
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                    left: 16.0,
                                    top: 24,
                                    right: 16,
                                  ),
                                  child: Text(
                                      "POS Collections - Top 10 Receptionists (MTD- ${getMonthAbbreviation(DateTime.now().month)})"),
                                )
                              : _selectedButton == 2
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16.0,
                                        top: 24,
                                        right: 16,
                                      ),
                                      child: Text(
                                          "POS Collections - Top 10 Receptionists (12 Months View)"),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16.0,
                                        top: 24,
                                        right: 16,
                                      ),
                                      child: Text(
                                          "POS Collections - Top 10 Receptionists (${formattedStartDate} to ${formattedEndDate})"),
                                    ),
                        if (collections_grid_index == 1)
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8, top: 0, bottom: 8),
                            child: Card(
                              elevation: 6,
                              surfaceTintColor: Colors.white,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                  child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.35),
                                        borderRadius:
                                            BorderRadius.circular(36)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 28,
                                            height: 28,
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(350)),
                                            child: Center(
                                              child: Text(
                                                "#",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                              flex: 10,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20.0),
                                                child: Text("Sales Agent Name"),
                                              )),
                                          Expanded(
                                            flex: 4,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text(
                                                "Amount",
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8, top: 8),
                                    child: isLoading == true
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8, top: 8),
                                            child: CustomCard(
                                                elevation: 5,
                                                surfaceTintColor: Colors.white,
                                                color: Colors.white,
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      width: 18,
                                                      height: 18,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Constants
                                                            .ctaColorLight,
                                                        strokeWidth: 1.8,
                                                      ),
                                                    ),
                                                  ),
                                                )))
                                        : (topsalesbyreceptionist.length == 0)
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Center(
                                                  child: Text(
                                                    "No data available for the selected range",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: ListView.builder(
                                                    padding: EdgeInsets.only(
                                                        top: 0, bottom: 0),
                                                    itemCount:
                                                        topsalesbyreceptionist
                                                                    .length >
                                                                10
                                                            ? 10
                                                            : topsalesbyreceptionist
                                                                .length,
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
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
                                                                      flex: 10,
                                                                      child: Text(
                                                                          "${topsalesbyreceptionist[index].agent_name.trimLeft()}")),
                                                                  Expanded(
                                                                    flex: 4,
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(
                                                                                left: 8,
                                                                              ),
                                                                              child: Text(
                                                                                "R${formatLargeNumber2(topsalesbyreceptionist[index].sales.toStringAsFixed(0))}",
                                                                                style: TextStyle(fontSize: 13),
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
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            8.0),
                                                                child:
                                                                    Container(
                                                                  height: 1,
                                                                  color: Colors
                                                                      .grey
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
                                  ),
                                ],
                              )),
                            ),
                          ),
                        if (collections_grid_index == 1)
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, top: 24, right: 16),
                            child: Text(
                                "POS Collections - Bottom 10 Receptionists"),
                          ),
                        if (collections_grid_index == 1)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              margin: EdgeInsets.zero,
                              elevation: 6,
                              surfaceTintColor: Colors.white,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                  child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.35),
                                        borderRadius:
                                            BorderRadius.circular(36)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 28,
                                            height: 28,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(350)),
                                            child: Center(
                                              child: Text(
                                                "#",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                              flex: 10,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20.0),
                                                child: Text("Sales Agent Name"),
                                              )),
                                          Expanded(
                                            flex: 4,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text(
                                                "Amount",
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8),
                                    child: isLoading ||
                                            bottomsalesbyreceptionist.isEmpty
                                        ? Center(
                                            child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: 18,
                                                height: 18,
                                                child:
                                                    CircularProgressIndicator(
                                                  color:
                                                      Constants.ctaColorLight,
                                                  strokeWidth: 1.8,
                                                ),
                                              ),
                                            ),
                                          ))
                                        : (bottomsalesbyreceptionist.length ==
                                                0)
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Center(
                                                  child: Text(
                                                    "No data available for the selected range",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: ListView.builder(
                                                    padding: EdgeInsets.only(
                                                        top: 0, bottom: 0),
                                                    itemCount:
                                                        bottomsalesbyreceptionist
                                                                    .length >
                                                                10
                                                            ? 10
                                                            : bottomsalesbyreceptionist
                                                                .length,
                                                    shrinkWrap: true,
                                                    reverse: false,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Container(
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    width: 45,
                                                                    child: Text(
                                                                        "${((index).abs()) + 1} "),
                                                                  ),
                                                                  Expanded(
                                                                      flex: 10,
                                                                      child: Text(
                                                                          "${bottomsalesbyreceptionist.reversed.toList()[index].agent_name.trimLeft()}")),
                                                                  Expanded(
                                                                    flex: 4,
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(
                                                                                left: 8,
                                                                              ),
                                                                              child: Text(
                                                                                "R${formatLargeNumber2(bottomsalesbyreceptionist.reversed.toList()[index].sales.toStringAsFixed(0))}",
                                                                                style: TextStyle(fontSize: 13),
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
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            8.0),
                                                                child:
                                                                    Container(
                                                                  height: 1,
                                                                  color: Colors
                                                                      .grey
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
                                  ),
                                ],
                              )),
                            ),
                          ),
                        _selectedButton == 1
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, top: 24, bottom: 10),
                                child: Text(
                                    "All Collections By Sales Branch (MTD- ${getMonthAbbreviation(DateTime.now().month)})"),
                              )
                            : _selectedButton == 2
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 24, bottom: 10),
                                    child: Text(
                                        "All Collections By Sales Branch (12 Months View)"),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 24, bottom: 10),
                                    child: Text(
                                        "All Collections By Sales Branch (${formattedStartDate} to ${formattedEndDate})"),
                                  ),
                        Container(
                          height: bardata5.isEmpty
                              ? 380
                              : (salesbybranch.length + 5) * 35,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 12.0,
                              right: 12,
                              top: 0,
                            ),
                            child: CustomCard(
                              elevation: 6,
                              surfaceTintColor: Colors.white,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: isLoading == true
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
                                  : bardata5.isEmpty
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              left: 16.0, right: 16, top: 16),
                                          child: Container(
                                              height: 700,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "No data available for the selected range",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  SizedBox(height: 12),
                                                  Icon(
                                                    Icons.auto_graph_sharp,
                                                    color: Colors.grey,
                                                  )
                                                ],
                                              )),
                                        )
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
                                            barRendererDecorator: new charts
                                                .BarLabelDecorator<String>(),
                                            // Hide domain axis.
                                            /*          domainAxis: new charts.OrdinalAxisSpec(
                                      renderSpec: new charts.NoneRenderSpec()),*/
                                            primaryMeasureAxis:
                                                new charts.NumericAxisSpec(
                                              renderSpec:
                                                  new charts.NoneRenderSpec(),
                                              viewport:
                                                  new charts.NumericExtents(
                                                      0, maxY5),
                                            ),
                                            domainAxis:
                                                new charts.OrdinalAxisSpec(
                                              renderSpec: new charts
                                                  .SmallTickRendererSpec(
                                                labelStyle:
                                                    new charts.TextStyleSpec(
                                                  fontSize: 10,
                                                  color: charts
                                                      .MaterialPalette.black,
                                                ),
                                                lineStyle:
                                                    new charts.LineStyleSpec(
                                                  color: charts
                                                      .MaterialPalette.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                            ),
                          ),
                        ),
                        /*  _selectedButton == 1
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 16.0, top: 12),
                                child: Text(
                                    "POS By Collecting Branch (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                              )
                            : _selectedButton == 2
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 12),
                                    child: Text(
                                        "POS By Collecting Branch (12 Months View)"),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 12),
                                    child: Text(
                                        "POS By Collecting Branch (${formattedStartDate} to ${formattedEndDate})"),
                                  ),*/
                        SizedBox(
                          height: 12,
                        ),

                        /*  _selectedButton == 1
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 16.0, top: 12),
                                child: Text(
                                    "Preferred Collection Method (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                              )
                            : _selectedButton == 2
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 12),
                                    child: Text(
                                        "Preferred Collection Method (12 Months View)"),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 12),
                                    child: Text(
                                        "Preferred Collection Method (${formattedStartDate} to ${formattedEndDate})"),
                                  ),*/

                        // _selectedButton == 1
                        //     ? Padding(
                        //         padding:
                        //             const EdgeInsets.only(left: 16.0, top: 12),
                        //         child: Text(
                        //             "Preferred Collection By Bank (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                        //       )
                        //     : _selectedButton == 2
                        //         ? Padding(
                        //             padding: const EdgeInsets.only(
                        //                 left: 16.0, top: 12),
                        //             child: Text(
                        //                 "Preferred Collection By Bank (12 Months View)"),
                        //           )
                        //         : Padding(
                        //             padding: const EdgeInsets.only(
                        //                 left: 16.0, top: 12),
                        //             child: Text(
                        //                 "Preferred Collection By Bank (${formattedStartDate} to ${formattedEndDate})"),
                        //           ),

                        SizedBox(
                          height: 25,
                        ),
                      ],
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

  void _generateLast6Years() {
    final DateFormat formatter = DateFormat('yyyy');
    final DateTime now = DateTime.now();

    // Ensure that the loop starts from the current year and goes backwards
    int startYear = now.year;

    _last6Years.clear();
    _yearRanges.clear();

    List<String> tempYears = [];
    for (int i = 0; i < 6; i++) {
      int year = startYear - i;
      // Only add the year if it's greater than 2022
      if (year > 2022) {
        String yearName = formatter.format(DateTime(year));
        tempYears.add(yearName);

        DateTime startOfYear = DateTime(year, 1, 1);
        DateTime endOfYear = DateTime(year, 12, 31);
        _yearRanges[yearName] = {
          'start': startOfYear,
          'end': endOfYear,
        };
      }
    }

    // _last6Years = tempYears.reversed.toList();
    _last6Years = tempYears;

    // _last6Years.insert(0, "All");

    _selectedYear = _last6Years[0];
    //_getApiData(_selectedYear!);

    setState(() {});
  }

  @override
  void initState() {
    final GlobalKey<ScaffoldState> _key = GlobalKey();
    startInactivityTimer();
    secureScreen();
    DateTime now = DateTime.now();
    DateTime startDate = DateTime(now.year, now.month, 1);
    DateTime endDate = DateTime.now();
    isShowingAPI = false;
    isShowingType = false;
    setState(() {});
    _generateLast6Years();

    _animateButton(1);

    super.initState();
  }

  Future<void> getCollectionsReport(
    BuildContext context,
    String date_from,
    String date_to,
  ) async {
    variance_percentage = 0;
    actual_variance_percentage = 0;
    setState(() {
      isLoading = true;
    });

    String baseUrl =
        '${Constants.analitixAppBaseUrl}sales/get_normalized_collection_data/';
    if (hasTemporaryTesterRole(Constants.myUserRoles)) {
      baseUrl =
          '${Constants.analitixAppBaseUrl}sales/get_collection_data_test/';
    }

    try {
      Map<String, String>? payload = {
        "client_id": "${Constants.cec_client_id}",
        "start_date": date_from,
        "end_date": date_to
      };
      if (kDebugMode) {
        //print("fghhgggh1 $payload");
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
          print(response.bodyBytes);
          print(response.statusCode);
          //print("jhhjk " + response.body.toString());
        }

        if (response.statusCode != 200) {
          _resetCollectionsData();
          print(response.statusCode);
          setState(() {
            isLoading = false; // Stop loading when request is complete
          });
          if (kDebugMode) {}
        } else {
          var jsonResponse = jsonDecode(response.body);

          if (jsonResponse["message"] == "list is empty") {
            if (kDebugMode) {
              print("fghghgfgghfhg 3jg00 ${jsonResponse["message"]}");
            }
            _resetCollectionsData();
            setState(() {});
          } else {
            _resetCollectionsData();
            logLongString("jgjhjhhkj " + response.body);

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

            setState(() {});

            jsonString = response.body;

            if (kDebugMode) {
              // print(jsonResponse);
            }

            // Safe parsing with null checks
            sum_of_premiums =
                _parseDouble(jsonResponse["sum_collected_premiums"]);
            expected_sum_of_premiums =
                _parseDouble(jsonResponse["sum_of_premiums"]);
            count_of_premiums =
                _parseInt(jsonResponse["count_collected_premiums1_unique"]);
            expected_count_of_premiums =
                _parseInt(jsonResponse["count_collected_premiums1"]);

            variance_sum_of_premiums =
                sum_of_premiums - expected_sum_of_premiums;
            variance_count_of_premiums =
                count_of_premiums - expected_count_of_premiums;

            actual_variance_percentage = expected_sum_of_premiums > 0
                ? (sum_of_premiums / expected_sum_of_premiums)
                : 0;

            if (actual_variance_percentage < 1) {
              variance_percentage = actual_variance_percentage;
            } else {
              variance_percentage = 1;
            }

            based_on_sales = _parseInt(jsonResponse["total_api"]).toDouble();
            based_on_first_premium_collected =
                _parseInt(jsonResponse["total_api_by_collection"]).toDouble();
            actual_api_collected = _parseDouble(
                jsonResponse["sum_collected_premiums_policy_year"]);
            based_on_sales1 =
                _parseDouble(jsonResponse["total_api_sum_policy_year"]);
            based_on_first_premium_collected1 = _parseDouble(
                jsonResponse["total_collected_api_sum_policy_year"]);
            actual_api_collected1 =
                _parseDouble(jsonResponse["api_collected_amount"]);

            // Process collection by type
            List collection_by_type = jsonResponse["collection_by_type"] ?? [];
            _processCollectionByType(collection_by_type);

            isLoadingApi = false;
            isLoading = false;
            setState(() {});

            int idY = 1;
            maxY5 = 0;

            // Set collections JSON response based on selected button
            _setCollectionsJsonResponse(jsonResponse);

            // Process employee lists
            _processEmployeeLists(jsonResponse);

            // Process branch sales
            _processBranchSales(jsonResponse);

            // Process payment types and bank data
            _processPaymentTypesAndBankData(jsonResponse);
          }
        }
      });

      setState(() {
        isLoading = false;
      });
      startInactivityTimer();
    } on Exception catch (_, exception) {
      setState(() {
        isLoading = false;
      });
      print(exception);
    }
  }

  // Helper method to safely parse double values
  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  // Helper method to safely parse int values
  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  // Helper method to reset all collections data
  void _resetCollectionsData() {
    based_on_sales = 0;
    based_on_first_premium_collected = 0;
    actual_api_collected = 0;
    based_on_sales1 = 0;
    based_on_first_premium_collected1 = 0;
    actual_api_collected1 = 0;
    actual_collected_premium = 0;
    expected_sum_of_premiums = 0;
    variance_sum_of_premiums = 0;
    variance_percentage = 0;
    sum_of_premiums = 0;
    sum_of_premiums2 = 0;
    expected_count_of_premiums = 0;
    isLoading = false;
    topsalesbyagent = [];
    bottomsalesbyagent = [];
    topsalesbyreceptionist = [];
    bottomsalesbyreceptionist = [];
    salesbybranch = [];
    bardata5 = [];
    Constants.customers_segment_1a = [];
    Constants.cutomers_banks_names1a = [];
    Constants.cutomers_banks_barChartData1a = [];

    if (_selectedButton == 1) {
      collections_jsonResponse1a = {};
      Constants.collections_tree_key1a = UniqueKey();
    } else if (_selectedButton == 2) {
      collections_jsonResponse2a = {};
      Constants.collections_tree_key2a = UniqueKey();
    } else if (_selectedButton == 3 && days_difference <= 31) {
      collections_jsonResponse3a = {};
      Constants.collections_tree_key3a = UniqueKey();
    } else {
      collections_jsonResponse4a = {};
      Constants.collections_tree_key4a = UniqueKey();
    }
  }

  // Helper method to process collection by type
  void _processCollectionByType(List collection_by_type) {
    collection_by_type.forEach((element) {
      Map m1 = element as Map;
      String collectionType = m1["collection_type"] ?? "";
      double amount = _parseDouble(m1["total_amount"]);
      int count = _parseInt(m1["count"]);

      switch (collectionType) {
        case "Cash":
          sectionsList2[0].amount = amount;
          sectionsList2[0].count = count;
          break;
        case "EFT":
          sectionsList2[1].amount = amount;
          sectionsList2[1].count = count;
          break;
        case "Easypay":
          sectionsList2[2].amount = amount;
          sectionsList2[2].count = count;
          break;
        case "Debit Order":
          sectionsList2[3].amount = amount;
          sectionsList2[3].count = count;
          break;
        case "PayAt":
          sectionsList2[4].amount = amount;
          sectionsList2[4].count = count;
          break;
        case "Salary Deduction":
          sectionsList2[5].amount = amount;
          sectionsList2[5].count = count;
          break;
        case "Persal":
          sectionsList2[6].amount = amount;
          sectionsList2[6].count = count;
          break;
      }
    });
  }

  // Helper method to set collections JSON response
  void _setCollectionsJsonResponse(Map<String, dynamic> jsonResponse) {
    Map<String, dynamic> branchesDict = jsonResponse["branches_dict"] ?? {};

    if (_selectedButton == 1) {
      collections_jsonResponse1a = branchesDict;
      Constants.collections_tree_key1a = UniqueKey();
    } else if (_selectedButton == 2) {
      collections_jsonResponse2a = branchesDict;
      Constants.collections_tree_key2a = UniqueKey();
    } else if (_selectedButton == 3 && days_difference <= 31) {
      collections_jsonResponse3a = branchesDict;
      Constants.collections_tree_key3a = UniqueKey();
    } else {
      collections_jsonResponse4a = branchesDict;
      Constants.collections_tree_key4a = UniqueKey();
    }
  }

  // Helper method to process employee lists
  void _processEmployeeLists(Map<String, dynamic> jsonResponse) {
    List top_employee_list = jsonResponse["top_employee_list"] ?? [];
    top_employee_list.forEach((element) {
      Map m1 = element as Map;
      String employee = m1["employee"] ?? "";
      double amount = _parseDouble(m1["total_collected_amount"]);
      topsalesbyagent.add(SalesByAgent(employee, amount));
      setState(() {});
    });

    List bottom_employees_list = jsonResponse["bottom_employee_list"] ?? [];
    bottom_employees_list.forEach((element) {
      Map m1 = element as Map;
      String employee = m1["employee"] ?? "";
      double amount = _parseDouble(m1["total_collected_amount"]);
      bottomsalesbyagent.add(SalesByAgent(employee, amount));
      setState(() {});
    });

    List top_employee_rates = jsonResponse["top_employee_rates"] ?? [];
    for (var element in top_employee_rates) {
      Map m1 = element as Map;

      topsalesbycollectionistRates
          .add(EmployeeRate.fromJson(Map<String, dynamic>.from(m1)));

      setState(() {});
    }
    List top_10_collection_receptionists =
        jsonResponse["top_10_collection_receptionists"] ?? [];
    for (var element in top_10_collection_receptionists) {
      Map m1 = element as Map;

      topsalesbyreceptionistRates
          .add(EmployeeRate.fromJson(Map<String, dynamic>.from(m1)));

      setState(() {});
    }
    List top_receptionist_list =
        jsonResponse["top_10_collection_receptionists"] ?? [];
    for (var element in top_receptionist_list) {
      Map m1 = element as Map;
      String employee = m1["employee"] ?? "";
      double amount = _parseDouble(m1["payment_item_amount"]);
      topsalesbyreceptionist.add(SalesByAgent(employee, amount));

      setState(() {});
    }

    List bottom_receptionist_list =
        jsonResponse["bottom_10_collection_receptionists"] ?? [];
    if (kDebugMode) {
      print("fghghhg $bottom_receptionist_list");
    }
    for (var element in bottom_receptionist_list) {
      Map m1 = element as Map;
      String employee = m1["employee"] ?? "";
      double amount = _parseDouble(m1["payment_item_amount"]);
      bottomsalesbyreceptionist.add(SalesByAgent(employee, amount));
      setState(() {});
    }
  }

  // Helper method to process branch sales
  void _processBranchSales(Map<String, dynamic> jsonResponse) {
    salesbybranch = [];
    bardata5 = [];

    List top_branch_list = jsonResponse["branch_sales"] ?? [];
    top_branch_list.forEach((element) {
      Map m1 = element as Map;
      String branchName = m1["branch_name"] ?? "";
      double amount = _parseDouble(m1["total_collected_amount"]);
      salesbybranch.add(SalesByBranch(branchName, amount));
    });

    barData = [];
    ordinary_sales.clear();
    int idY = 1;

    for (var element in salesbybranch) {
      if (element.sales > maxY5) {
        maxY5 = element.sales;
      }

      bottomTitles1.add(element.branch_name);
      ordinary_sales.add(OrdinalSales(
          element.branch_name, double.parse(element.sales.toString())));

      barData.add(
        BarChartGroupData(
          x: idY++,
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

    ordinary_sales.sort((a, b) => b.sales.compareTo(a.sales));

    bardata5.add(charts.Series<OrdinalSales, String>(
        id: 'BranchSales',
        domainFn: (OrdinalSales sale, _) => sale.branch,
        measureFn: (OrdinalSales sale, _) =>
            double.parse(sale.sales.toStringAsFixed(0)),
        data: ordinary_sales,
        labelAccessorFn: (OrdinalSales sale, _) =>
            'R${formatLargeNumber3(sale.sales.toString())}'));
  }

  // Helper method to process payment types and bank data
  void _processPaymentTypesAndBankData(Map<String, dynamic> jsonResponse) {
    Constants.customers_segment_1a = [];
    List<Map> payment_types_data =
        List<Map>.from(jsonResponse["payment_type_data"] ?? []);
    List<Map> bankdata2 = List<Map>.from(jsonResponse["bankname_data"] ?? []);

    print("bankdata2 $bankdata2");
    int available_banks = bankdata2.length;
    int ixb_bank = 0;
    Constants.cutomers_banks_barChartData1a = [];
    Constants.cutomers_banks_names1a = [];
    double bank_bar_width1 = 0;

    if (available_banks > 0) {
      bank_bar_width1 = Constants.screenWidth / available_banks;
    } else {
      bank_bar_width1 = 8;
    }

    Constants.cutomers_banks_barChartData1a = [];
    Constants.cutomers_banks_names1a = [];

    bank_bar_width1 = Constants.screenWidth / 9;

    List<String> bank_names_list = [
      "CAPITEC",
      "STANDARD BANK",
      "NEDBANK",
      "TYMEBANK",
      "FNB",
      "ABSA",
      "AFRICAN BANK",
      "OLD MUTUAL BANK",
      "DISCOVERY BANK"
    ];

    Constants.cutomers_banks_barChartData1a = [];
    Constants.cutomers_banks_names1a = [];

    bank_names_list.forEach((element) {
      Map m1 = bankdata2.firstWhere((bank) => bank["bankname"] == element,
          orElse: () => {});
      print("fffh $m1");

      if (m1.isNotEmpty) {
        Constants.cutomers_banks_names1a.add(m1);
        double percentage = _parseDouble(m1["percentage"]);
        Constants.cutomers_banks_barChartData1a.add(BarChartGroupData(
          x: ixb_bank++,
          barRods: [
            BarChartRodData(
              borderRadius: BorderRadius.circular(2),
              toY: percentage,
              width: bank_bar_width1 - 12,
              color: Colors.orangeAccent,
              rodStackItems: [
                BarChartRodStackItem(
                  0,
                  percentage,
                  Colors.orangeAccent,
                  BorderSide(color: Colors.white, width: 0),
                ),
              ],
              borderSide:
                  BorderSide(color: Colors.grey.withOpacity(0.3), width: 0),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: 100,
                color: Colors.grey.withOpacity(0.3),
              ),
            )
          ],
          barsSpace: 20,
        ));
      } else {
        Constants.cutomers_banks_names1a
            .add({"bankname": element, "count": 0, "percentage": 0.0});
        Constants.cutomers_banks_barChartData1a.add(BarChartGroupData(
          x: ixb_bank++,
          barRods: [
            BarChartRodData(
              borderRadius: BorderRadius.circular(2),
              toY: 0.0,
              width: bank_bar_width1 - 12,
              color: Colors.orangeAccent,
              rodStackItems: [
                BarChartRodStackItem(
                  0,
                  0.0,
                  Colors.orangeAccent,
                  BorderSide(color: Colors.white, width: 0),
                ),
              ],
              borderSide:
                  BorderSide(color: Colors.grey.withOpacity(0.3), width: 0),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: 100,
                color: Colors.grey.withOpacity(0.3),
              ),
            )
          ],
          barsSpace: 20,
        ));
      }
    });

    Map<String, int> banknameCount = {};
    bankdata2.forEach((bank) {
      String bankname = bank["bankname"] ?? "";
      banknameCount[bankname] = (banknameCount[bankname] ?? 0) + 1;
    });

    bankdata2.sort((a, b) {
      int countA = banknameCount[a["bankname"]] ?? 0;
      int countB = banknameCount[b["bankname"]] ?? 0;
      return countB.compareTo(countA);
    });

    bankdata2.forEach((bank) {
      print("${bank['bankname']}: ${banknameCount[bank['bankname']]}");
    });

    Constants.customers_segment_1a = [];
    payment_types_data.forEach((element) {
      Map m1 = element as Map;
      String paymentType = m1["payment_type"] ?? "";
      if (paymentType.isNotEmpty) {
        int count = _parseInt(m1["count"]);
        double percentage = _parseDouble(m1["percentage"]);
        Constants.customers_segment_1a.add(Segment2(
          color: typeToColor[paymentType] ?? Colors.grey,
          value: count,
          label: paymentType,
          valueLabel: Text(percentage.toStringAsFixed(1)),
          pecentage: percentage,
        ));
      }
    });
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

  Future<void> _getApiData(String s) async {
    isLoadingApi = true;
    setState(() {});
    int year = int.tryParse(s) ?? 0;

    // Check if the year is valid (greater than 0)
    if (year > 0) {
      // Construct the start and end dates of the year
      DateTime startDate =
          DateTime(year, 1, 1); // January 1st of the input year
      DateTime endDate =
          DateTime(year, 12, 31, 23, 59, 59); // December 31st of the input year

      // Format dates if needed (e.g., for API calls)
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      String formattedStartDate = formatter.format(startDate);
      String formattedEndDate = formatter.format(endDate);

      print('Start Date: $formattedStartDate, End Date: $formattedEndDate');

      // final response = await fetchApiData(formattedStartDate, formattedEndDate);
      // processApiResponse(response);

      String baseUrl =
          "https://miinsightsapps.net/files/get_api_data_by_date_range/";
      Map<String, String>? payload = {
        "client_id": "${Constants.cec_client_id}",
        "start_date": formattedStartDate,
        "end_date": formattedEndDate
      };
      await http
          .post(
              Uri.parse(
                baseUrl,
              ),
              body: payload)
          .then((value) {
        http.Response response = value;
        print("ggjjgjd ${response.body}");

        if (response.statusCode != 200) {
        } else {
          var jsonResponse = jsonDecode(response.body);
          print(jsonResponse);

          based_on_sales = jsonResponse["total_api"] ?? 0;
          based_on_first_premium_collected =
              jsonResponse["total_api_by_collection"] ?? 0;

          actual_api_collected =
              jsonResponse["sum_collected_premiums_policy_year"] ?? 0;

          based_on_sales1 = double.parse(
              (jsonResponse["total_api_sum_policy_year"] ?? 0).toString());
          print("based_on_sales1 $based_on_sales1");
          based_on_first_premium_collected1 = double.parse(
              (jsonResponse["total_collected_api_sum_policy_year"] ?? 0)
                  .toString());

          actual_api_collected1 = double.parse(
              (jsonResponse["api_collected_amount"] ?? 0).toString());
          isLoadingApi = false;
          setState(() {});
        }
      });
    } else {
      isLoadingApi = false;
      setState(() {});
      // Handle invalid year input
      print('Invalid year input: $s');
    }
  }

  Future<void> saveImage(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/captured_image.png';
    final imageFile = File(imagePath);
    await imageFile.writeAsBytes(bytes);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Image saved to $imagePath'),
    ));
  }
}

class SalesCollectionAgentWidget extends StatelessWidget {
  final List<EmployeeRate> salesCollectionAgent;
  final bool isLoading;
  final int maxItems;

  const SalesCollectionAgentWidget({
    Key? key,
    required this.salesCollectionAgent,
    this.isLoading = false,
    this.maxItems = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 12, right: 12),
      child: CustomCard3(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        elevation: 6,
        boderRadius: 20,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          child: Column(
            children: [
              _buildHeader(),
              _buildContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.35),
        borderRadius: BorderRadius.circular(36),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(350),
              ),
              child: Center(
                child: Text(
                  "#",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Text("Sales Agent Name"),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  "Amount",
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return _buildLoadingIndicator();
    }

    if (topsalesbyreceptionistRates.isEmpty) {
      return _buildNoDataMessage();
    }

    return _buildAgentsList(context);
  }

  Widget _buildLoadingIndicator() {
    return Center(
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
    );
  }

  Widget _buildNoDataMessage() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 12, top: 12, bottom: 16),
      child: Center(
        child: Text(
          "No data available for the selected range",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildAgentsList(BuildContext context) {
    final displayCount = topsalesbyreceptionistRates.length > maxItems
        ? maxItems
        : topsalesbyreceptionistRates.length;

    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 12, top: 12, bottom: 16),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 0, bottom: 16),
        itemCount: displayCount,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return _buildAgentItem(
              context, topsalesbyreceptionistRates[index], index);
        },
      ),
    );
  }

  Widget _buildAgentItem(BuildContext context, EmployeeRate agent, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 35,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Text("${index + 1} "),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Text(
                    extractFirstAndLastName(agent.employeeName.trimLeft()),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        formatCollection(agent.totalCollected),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(350),
                  ),
                  child: InkWell(
                    onTap: () => _showAgentDetailsDialog(context, agent),
                    child: Center(
                      child: Icon(
                        Icons.remove_red_eye_outlined,
                        size: 18,
                        color: Constants.ctaColorLight,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAgentDetailsDialog(BuildContext context, EmployeeRate agent) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(
                Icons.person,
                color: Constants.ctaColorLight,
                size: 20,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Collections Mix',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    CupertinoIcons.clear,
                    color: Colors.grey[600],
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAgentDetailsCard(agent),
                SizedBox(height: 16),
                _buildPieChart(agent, context),
                SizedBox(height: 16),
                Container(
                  height: 26,
                  width: MediaQuery.of(context).size.width,
                  child: CollectionsTypeGrid(),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAgentDetailsCard(EmployeeRate agent) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              agent.employeeName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Constants.ctaColorLight,
              ),
            ),
            SizedBox(height: 12),
            _buildMetricRow(
                'Total Sales', '${agent.totalSales}', Icons.shopping_cart),
            _buildMetricRow(
                'Total Collected',
                'R ${formatLargeNumber(agent.totalCollected.toStringAsFixed(1))}',
                Icons.account_balance_wallet),
            _buildMetricRow('NTU Rate', '${agent.ntuRate.toStringAsFixed(1)}%',
                Icons.trending_up),
            _buildMetricRow('Lapse Rate',
                '${agent.lapseRate.toStringAsFixed(1)}%', Icons.trending_down),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart(EmployeeRate agent, BuildContext context) {
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 40,
          sections: _buildPieChartSections(agent),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(EmployeeRate employee) {
    List<PieChartSectionData> sections = [];

    // Base radius for all sections
    const double baseRadius = 60.0;
    const double minPercentageForLabel = 25.0;

    if (employee.percentageDebitOrderClients > 0) {
      sections.add(PieChartSectionData(
        color: Colors.orange,
        value: employee
            .percentageDebitOrderClients, // Use actual percentage as value
        title: employee.percentageDebitOrderClients >= minPercentageForLabel
            ? '${employee.percentageDebitOrderClients.toStringAsFixed(1)}%'
            : '', // Hide text if less than 25%
        radius: baseRadius,
        titleStyle:
            employee.percentageDebitOrderClients >= minPercentageForLabel
                ? const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)
                : const TextStyle(fontSize: 0), // Invisible text style
      ));
    }

    if (employee.percentageCashClients > 0) {
      sections.add(PieChartSectionData(
        color: Colors.blue,
        value: employee.percentageCashClients, // Use actual percentage as value
        title: employee.percentageCashClients >= minPercentageForLabel
            ? '${employee.percentageCashClients.toStringAsFixed(1)}%'
            : '', // Hide text if less than 25%
        radius: baseRadius,
        titleStyle: employee.percentageCashClients >= minPercentageForLabel
            ? const TextStyle(
                fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)
            : const TextStyle(fontSize: 0), // Invisible text style
      ));
    }

    if (employee.percentageSalaryDeductionClients > 0) {
      sections.add(PieChartSectionData(
        color: Colors.yellow,
        value: employee
            .percentageSalaryDeductionClients, // Use actual percentage as value
        title: employee.percentageSalaryDeductionClients >=
                minPercentageForLabel
            ? '${employee.percentageSalaryDeductionClients.toStringAsFixed(1)}%'
            : '', // Hide text if less than 25%
        radius: baseRadius,
        titleStyle:
            employee.percentageSalaryDeductionClients >= minPercentageForLabel
                ? const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)
                : const TextStyle(fontSize: 0), // Invisible text style
      ));
    }

    if (employee.percentagePersalClients > 0) {
      sections.add(PieChartSectionData(
        color: Colors.grey,
        value:
            employee.percentagePersalClients, // Use actual percentage as value
        title: employee.percentagePersalClients >= minPercentageForLabel
            ? '${employee.percentagePersalClients.toStringAsFixed(1)}%'
            : '', // Hide text if less than 25%
        radius: baseRadius,
        titleStyle: employee.percentagePersalClients >= minPercentageForLabel
            ? const TextStyle(
                fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)
            : const TextStyle(fontSize: 0), // Invisible text style
      ));
    }

    return sections;
  }

  // Alternative version with helper method for cleaner code
  List<PieChartSectionData> _buildPieChartSectionsClean(EmployeeRate employee) {
    const double baseRadius = 60.0;
    const double minPercentageForLabel = 25.0;

    List<({double percentage, Color color, String name})> chartData = [
      (
        percentage: employee.percentageDebitOrderClients,
        color: Colors.orange,
        name: 'Debit Order'
      ),
      (
        percentage: employee.percentageCashClients,
        color: Colors.blue,
        name: 'Cash'
      ),
      (
        percentage: employee.percentageSalaryDeductionClients,
        color: Colors.yellow,
        name: 'Salary Deduction'
      ),
      (
        percentage: employee.percentagePersalClients,
        color: Colors.grey,
        name: 'Persal'
      ),
    ];

    return chartData
        .where(
            (data) => data.percentage > 0) // Only include non-zero percentages
        .map((data) => _createPieSection(
              value: data.percentage,
              color: data.color,
              radius: baseRadius,
              showLabel: data.percentage >= minPercentageForLabel,
            ))
        .toList();
  }

  PieChartSectionData _createPieSection({
    required double value,
    required Color color,
    required double radius,
    required bool showLabel,
  }) {
    return PieChartSectionData(
      color: color,
      value: value,
      title: showLabel ? '${value.toStringAsFixed(1)}%' : '',
      radius: radius,
      titleStyle: showLabel
          ? const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )
          : const TextStyle(fontSize: 0), // Invisible for small sections
    );
  }

  // Enhanced version with dynamic font sizing based on section size
  List<PieChartSectionData> _buildPieChartSectionsEnhanced(
      EmployeeRate employee) {
    const double baseRadius = 60.0;
    const double minPercentageForLabel = 25.0;

    List<PieChartSectionData> sections = [];

    // Helper function to get font size based on percentage
    double _getFontSize(double percentage) {
      if (percentage >= 40) return 12.0;
      if (percentage >= 30) return 11.0;
      if (percentage >= 25) return 10.0;
      return 0.0; // Invisible for small sections
    }

    if (employee.percentageDebitOrderClients > 0) {
      sections.add(PieChartSectionData(
        color: Colors.orange,
        value: employee.percentageDebitOrderClients,
        title: employee.percentageDebitOrderClients >= minPercentageForLabel
            ? '${employee.percentageDebitOrderClients.toStringAsFixed(1)}%'
            : '',
        radius: baseRadius,
        titleStyle: TextStyle(
          fontSize: _getFontSize(employee.percentageDebitOrderClients),
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }

    if (employee.percentageCashClients > 0) {
      sections.add(PieChartSectionData(
        color: Colors.blue,
        value: employee.percentageCashClients,
        title: employee.percentageCashClients >= minPercentageForLabel
            ? '${employee.percentageCashClients.toStringAsFixed(1)}%'
            : '',
        radius: baseRadius,
        titleStyle: TextStyle(
          fontSize: _getFontSize(employee.percentageCashClients),
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }

    if (employee.percentageSalaryDeductionClients > 0) {
      sections.add(PieChartSectionData(
        color: Colors.yellow,
        value: employee.percentageSalaryDeductionClients,
        title: employee.percentageSalaryDeductionClients >=
                minPercentageForLabel
            ? '${employee.percentageSalaryDeductionClients.toStringAsFixed(1)}%'
            : '',
        radius: baseRadius,
        titleStyle: TextStyle(
          fontSize: _getFontSize(employee.percentageSalaryDeductionClients),
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }

    if (employee.percentagePersalClients > 0) {
      sections.add(PieChartSectionData(
        color: Colors.grey,
        value: employee.percentagePersalClients,
        title: employee.percentagePersalClients >= minPercentageForLabel
            ? '${employee.percentagePersalClients.toStringAsFixed(1)}%'
            : '',
        radius: baseRadius,
        titleStyle: TextStyle(
          fontSize: _getFontSize(employee.percentagePersalClients),
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }

    return sections;
  }
}

List<BarChartGroupData> processDataForCollectionsCountMonthly(
    String jsonString, String startDate, String endDate, BuildContext context) {
  //print("aaxdss");
  List<dynamic> jsonData = jsonDecode(jsonString)["daily_collection_summary"];

  DateTime end = DateTime.parse(endDate);
  DateTime start = DateTime(end.year - 1, end.month, end.day);
  int monthsInRange = 12;

  // Initialize monthlySales for each month in the range
  Map<int, Map<String, double>> monthlySales = {
    for (var i = 0; i < monthsInRange; i++)
      DateTime(end.year, end.month - i, 1).month: {}
  };
  if (jsonData.length > 0) {
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
          width: (Constants.screenWidth / 12) - 9,
        ),
      ],
      barsSpace: barsSpace + 2,
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
  if (jsonData.length > 0) {
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
          width: (Constants.screenWidth / 12) - 7.1,
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

String formatCollection(double value) {
  return "R${formatLargeNumber2(value.toStringAsFixed(1))}";
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
      print("ssajas ${collectionItem['date_or_month']}");
      DateTime date = DateTime.parse(collectionItem['date_or_month']);
      if (collectionItem['date_or_month'] != null) {
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
          width: (Constants.screenWidth / daysInCurrentMonth) - 3.3,
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
  // print("gjhjhj $jsonString");
  List<dynamic> jsonData = jsonDecode(jsonString)["daily_collection_summary"];
  //print("gjhjhjjsonData $jsonData");

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
          childAspectRatio: 1.9,
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

class CollectionsTypeGrid extends StatelessWidget {
  final List<CustomersTypGridItem> collectionTypes = [
    CustomersTypGridItem('Cash', Colors.blue),
    CustomersTypGridItem('D/0.', Colors.orange),
    CustomersTypGridItem('Persal', Colors.grey),
    CustomersTypGridItem('Sal. Ded', Colors.yellow),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          childAspectRatio: 2,
        ),
        itemCount: collectionTypes.length,
        itemBuilder: (context, index) {
          return Container(
            alignment: Alignment.center, // Center the contents
            child: Row(
              mainAxisSize: MainAxisSize
                  .min, // Use the minimum space that the row can take.
              children: <Widget>[
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(350),
                    color: collectionTypes[index].color,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  collectionTypes[index].type,
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CustomersTypGridItem {
  final String type;
  final Color color;

  CustomersTypGridItem(this.type, this.color);
}

Map<String, Color> typeToColor = {
  'Cash Payment': Colors.blue,
  'Debit Order': Colors.orange,
  'persal': Colors.grey,
  'Salary Deduction': Colors.yellow,
  'Other': Colors.grey,
};

class AgentPersistencyWidget extends StatelessWidget {
  final int selectedButton;
  final int daysDifference;
  final bool isLoading;

  const AgentPersistencyWidget({
    Key? key,
    required this.selectedButton,
    required this.daysDifference,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 12, right: 12),
      child: CustomCard3(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        elevation: 6,
        boderRadius: 20,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          child: Column(
            children: [
              _buildHeader(),
              _buildContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.35),
        borderRadius: BorderRadius.circular(36),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(350),
              ),
              child: Center(
                child: Text(
                  "#",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Text("Sales Agent Name"),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  "Amount",
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return _buildLoadingIndicator();
    }

    List<EmployeeRate> agentList = topsalesbycollectionistRates;

    if (agentList.isEmpty) {
      return _buildNoDataMessage();
    }

    return _buildAgentsList(context, agentList);
  }

  Widget _buildLoadingIndicator() {
    return Center(
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
    );
  }

  Widget _buildNoDataMessage() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 12, top: 12, bottom: 16),
      child: Center(
        child: Text(
          "No data available for the selected range",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildAgentsList(BuildContext context, List<EmployeeRate> agentList) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 12, top: 12, bottom: 16),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 0, bottom: 16),
        itemCount: min(agentList.length, 10),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return _buildAgentItem(context, agentList[index], index);
        },
      ),
    );
  }

  Widget _buildAgentItem(BuildContext context, EmployeeRate agent, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 35,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Text("${index + 1} "),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Text(
                    extractFirstAndLastName(agent.employeeName.trimLeft()),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        formatCollection(agent.totalCollected),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(350),
                  ),
                  child: InkWell(
                    onTap: () => _showAgentDialog(context, agent),
                    child: Center(
                      child: Icon(
                        Icons.remove_red_eye_outlined,
                        size: 18,
                        color: Constants.ctaColorLight,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: 1,
                color: Colors.grey.withOpacity(0.10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<EmployeeRate> _getAgentList() {
    return Constants.currentSalesDataResponse.topEmployeeRates ?? [];
  }

  void _showAgentDialog(BuildContext context, EmployeeRate agent) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Center(
            child: Row(
              children: [
                SizedBox(width: 8),
                Spacer(),
                const Text('Collections Mix'),
                Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    CupertinoIcons.clear_circled,
                    color: Constants.ctaColorLight,
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildAgentCard(agent),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    height: 280,
                    width: MediaQuery.of(context).size.width,
                    child: PieChart(
                      PieChartData(
                        centerSpaceRadius: 0,
                        sections: _buildPieChartSections(agent),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  height: 26,
                  width: MediaQuery.of(context).size.width,
                  child: CollectionsTypeGrid(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAgentCard(EmployeeRate agent) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        surfaceTintColor: Colors.white,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 4),
                child: Text(agent.employeeName),
              ),
              SizedBox(height: 6),
              Text(
                ' • Total Sales: ${agent.totalSales}',
                style: TextStyle(fontSize: 11),
              ),
              Text(
                ' • Total Collected: R ${formatLargeNumber(agent.totalCollected.toStringAsFixed(1))}',
                style: TextStyle(fontSize: 11),
              ),
              Text(
                ' • NTU Rate: ${agent.ntuRate.toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 11),
              ),
              Text(
                ' • Lapse Rate: ${agent.lapseRate.toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 11),
              ),
              SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(EmployeeRate agent) {
    List<PieChartSectionData> sections = [];

    if (agent.percentageDebitOrderClients > 0) {
      sections.add(PieChartSectionData(
        color: Colors.orange,
        value: 45 + agent.percentageDebitOrderClients,
        title: '${agent.percentageDebitOrderClients.toStringAsFixed(1)}%',
        radius: agent.percentageDebitOrderClients < 10
            ? (agent.percentageDebitOrderClients + 40)
            : 45 + agent.percentageDebitOrderClients.roundToDouble(),
        titleStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xffffffff),
        ),
      ));
    }

    if (agent.percentageCashClients > 0) {
      sections.add(PieChartSectionData(
        color: Colors.blue,
        value: 45 + agent.percentageCashClients,
        title: '${agent.percentageCashClients.toStringAsFixed(1)}%',
        radius: agent.percentageCashClients < 10
            ? (agent.percentageCashClients + 40)
            : 45 + agent.percentageCashClients.roundToDouble(),
        titleStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xffffffff),
        ),
      ));
    }

    if (agent.percentageSalaryDeductionClients > 0) {
      sections.add(PieChartSectionData(
        color: Colors.yellow,
        value: 45 + agent.percentageSalaryDeductionClients,
        title: '${agent.percentageSalaryDeductionClients.toStringAsFixed(1)}%',
        radius: agent.percentageSalaryDeductionClients < 10
            ? (agent.percentageSalaryDeductionClients + 40)
            : 45 + agent.percentageSalaryDeductionClients.roundToDouble(),
        titleStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xffffffff),
        ),
      ));
    }

    if (agent.percentagePersalClients > 0) {
      sections.add(PieChartSectionData(
        color: Colors.grey,
        value: 45 + agent.percentagePersalClients,
        title: '${agent.percentagePersalClients.toStringAsFixed(1)}%',
        radius: agent.percentagePersalClients < 10
            ? (agent.percentagePersalClients + 40)
            : 45 + agent.percentagePersalClients.roundToDouble(),
        titleStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xffffffff),
        ),
      ));
    }

    return sections;
  }
}

String extractFirstAndLastName(String fullName) {
  RegExp regex = RegExp(r'^(\S+)\s+([^\s]+)\s+(\S+)+(\S+)$');
  Match? match = regex.firstMatch(fullName);
  if (match != null) {
    return '${match.group(1)} ${match.group(3)}';
  } else {
    return fullName;
  }
}
