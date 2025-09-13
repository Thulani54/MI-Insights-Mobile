import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:google_fonts/google_fonts.dart";
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mi_insights/constants/Constants.dart';
import 'package:mi_insights/models/SalesByAgent.dart';
import 'package:mi_insights/services/Sales%20Agent/sales_agent_sales_report_service.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:mrx_charts/mrx_charts.dart';

import '../../../customwidgets/custom_date_range_picker.dart';
import '../../../models/PolicyDetails.dart';
import '../../../services/MyNoyifier.dart';
import '../../../services/inactivitylogoutmixin.dart';
import '../../../services/window_manager.dart';
import '../PaymentHistoryPage.dart';
import 'SalesAgentNewSale.dart';

int noOfDaysThisMonth = 30;
bool isSalesDataLoading1a = false;
bool isSalesDataLoading2a = false;
bool isSalesDataLoading3a = false;
bool isSalesDataLoading3b = false;
Map<String, dynamic> sales_jsonResponse1a = {};
Map<String, dynamic> sales_jsonResponse2a = {};
Map<String, dynamic> sales_jsonResponse3a = {};
Map<String, dynamic> sales_jsonResponse4a = {};

Map<String, dynamic> leads_jsonResponse1a = {};
Map<String, dynamic> leads_jsonResponse2a = {};
Map<String, dynamic> leads_jsonResponse3a = {};
Map<String, dynamic> leads_jsonResponse4a = {};
List<BarChartGroupData> sales_barChartData1 = [];
List<BarChartGroupData> sales_barChartData2 = [];
List<BarChartGroupData> sales_barChartData3 = [];
List<BarChartGroupData> sales_barChartData4 = [];
final salesValue = ValueNotifier<int>(0);
MyNotifier? myNotifier;
DateTime datefrom = DateTime.now().subtract(Duration(days: 60));
DateTime dateto = DateTime.now();
int days_difference = 0;
int target_index = 0;
Widget wdg1 = Container();
int report_index = 0;
int sales_index = 0;
String data2 = "";
Key kyrt = UniqueKey();
int touchedIndex = -1;
double _sliderPosition2 = 0.0;

class SalesAgentReport extends StatefulWidget {
  const SalesAgentReport({Key? key}) : super(key: key);

  @override
  State<SalesAgentReport> createState() => _SalesAgentReportState();
}

List<Map<String, dynamic>> leads = [];
List<List<Map<String, dynamic>>> policies = [];
double _sliderPosition = 0.0;
int _selectedButton = 1;
bool isSameDaysRange = true;
Color _button1Color = Colors.grey.withOpacity(0.0);
Color _button2Color = Colors.grey.withOpacity(0.0);
Color _button3Color = Colors.grey.withOpacity(0.0);
int currentLevel = 0;
bool _searchingPolicy = false;
bool isLoaded = false;
String msgtx = "No Items found";
List<PolicyDetails> policydetails = [];
TextEditingController _searchContoller = TextEditingController();

class _SalesAgentReportState extends State<SalesAgentReport>
    with InactivityLogoutMixin {
  void _setCurrentMonthDateRange() {
    // Set loading state to true before starting data fetch
    isSalesDataLoading1a = true;
    setState(() {});
    
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    
    Constants.sales_formattedStartDate = DateFormat('yyyy-MM-dd').format(firstDayOfMonth);
    Constants.sales_formattedEndDate = DateFormat('yyyy-MM-dd').format(lastDayOfMonth);
    
    // Calculate days difference for the current month
    days_difference = lastDayOfMonth.difference(firstDayOfMonth).inDays;
    
    setState(() {});
    print("Current month range: ${Constants.sales_formattedStartDate} to ${Constants.sales_formattedEndDate}");
    print("Days difference: $days_difference");
    
    getSalesAgentSalesReport(Constants.sales_formattedStartDate,
            Constants.sales_formattedEndDate, 1, days_difference, context)
        .then((value) {
      kyrt = UniqueKey();
      setState(() {});
    });
    getSalesAgentLeadsReport(Constants.sales_formattedStartDate,
        Constants.sales_formattedEndDate, 1, days_difference, context);
  }

  Future<void> _animateButton(int buttonNumber) async {
    restartInactivityTimer();
    DateTime? startDate = DateTime.now();
    DateTime? endDate = DateTime.now();
    leads = [];

    setState(() {});

    if (kDebugMode) {
      print("jhhh $buttonNumber");
    }

    _selectedButton = buttonNumber;
    if (buttonNumber == 1) {
      _sliderPosition = 0.0;
      _setCurrentMonthDateRange();
    } else if (buttonNumber == 2) {
      _sliderPosition = (MediaQuery.of(context).size.width / 3) - 18;
    } else if (buttonNumber == 3) {
      _sliderPosition = 2 * (MediaQuery.of(context).size.width / 3) - 32;
      if (days_difference < 31) {
        isSalesDataLoading3a = true;
      } else {
        isSalesDataLoading3b = true;
      }
    }
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
      });
      DateTime now = DateTime.now();

      setState(() {});
    }
    if (buttonNumber == 2) {
      startInactivityTimer();
      final ThemeData datePickerTheme = ThemeData(
        colorScheme: ColorScheme.light(
          background: Colors.white,
          surfaceTint: Colors.white,
          primary: Constants.ctaColorLight,
          onPrimary: Colors.black,
          onSurface: Colors.black,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Constants.ctaColorLight,
          ),
        ),
      );

      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: datePickerTheme,
            child: child!,
          );
        },
      );

      if (pickedDate != null) {
        startInactivityTimer();
        String agent_selected_date =
            DateFormat('yyyy-MM-dd').format(pickedDate);
        setState(() {});
        print(pickedDate.toString());

        Constants.sales_formattedStartDate =
            DateFormat('yyyy-MM-dd').format(pickedDate);
        Constants.sales_formattedEndDate =
            DateFormat('yyyy-MM-dd').format(pickedDate);

        setState(() {});

        // Set loading state to true before starting data fetch
        isSalesDataLoading2a = true;
        setState(() {});

        getSalesAgentSalesReport(Constants.sales_formattedStartDate,
                Constants.sales_formattedEndDate, 2, days_difference, context)
            .then((value) {
          kyrt = UniqueKey();
          setState(() {});
        });
        getSalesAgentLeadsReport(Constants.sales_formattedStartDate,
            Constants.sales_formattedEndDate, 2, days_difference, context);
        restartInactivityTimer();
      } else {
        startInactivityTimer();
      }
    } else if (buttonNumber == 3) {
      showCustomDateRangePicker(
        context,
        dismissible: true,
        minimumDate: DateTime.now().subtract(const Duration(days: 360)),
        maximumDate: DateTime.now(),
        /*    endDate: endDate,
        startDate: startDate,*/
        backgroundColor: Colors.white,
        primaryColor: Constants.ctaColorLight,
        onApplyClick: (start, end) {
          setState(() {
            endDate = end;
            startDate = start;
          });

          days_difference = end!.difference(start).inDays;
          if (days_difference <= 31) {
            isSalesDataLoading3a = false;
          } else {
            isSalesDataLoading3b = false;
          }
          if (end.month == start.month) {
            isSameDaysRange = true;
          } else {
            isSameDaysRange = false;
          }
          Constants.sales_formattedStartDate =
              DateFormat('yyyy-MM-dd').format(start);
          Constants.sales_formattedEndDate =
              DateFormat('yyyy-MM-dd').format(end);

          setState(() {});

          getSalesAgentSalesReport(Constants.sales_formattedStartDate,
                  Constants.sales_formattedEndDate, 3, days_difference, context)
              .then((value) {
            kyrt = UniqueKey();
            setState(() {});
          });
          getSalesAgentLeadsReport(Constants.sales_formattedStartDate,
              Constants.sales_formattedEndDate, 3, days_difference, context);
          restartInactivityTimer();
        },
        onCancelClick: () {
          restartInactivityTimer();
          if (kDebugMode) {
            print("user cancelled.");
          }
          setState(() {
            _animateButton(1);
          });
        },
      );
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            elevation: 6,
            surfaceTintColor: Colors.white,
            shadowColor: Colors.black.withOpacity(0.6),
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
          decoration: BoxDecoration(color: Colors.white),
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
                                        'Select Date',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _animateButton(3);
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
                          child: InkWell(
                            onTap: () {
                              _animateButton(2);
                            },
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
                                            'Select Date',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      : Center(
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
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 12),
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
                      SizedBox(
                        height: 12,
                      ),
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
                                                  BorderRadius.circular(360)),
                                          height: 35,
                                          child: Center(
                                            child: Text(
                                              'My Leads',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _animateButton2(1);
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
                                                  BorderRadius.circular(360)),
                                          child: Center(
                                            child: Text(
                                              'My Sales',
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
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: target_index == 0
                                          ? Center(
                                              child: Text(
                                                'My Leads',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          : target_index == 1
                                              ? Center(
                                                  child: Text(
                                                    'My Sales',
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
                      _selectedButton == 1 && isSalesDataLoading1a
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
                      _selectedButton == 2 && isSalesDataLoading2a
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
                      _selectedButton == 3 &&
                              days_difference <= 31 &&
                              isSalesDataLoading3a
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
                      _selectedButton == 3 &&
                              days_difference > 31 &&
                              isSalesDataLoading3b
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
                      target_index == 0
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 11.0, right: 3, top: 12, bottom: 12),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: MediaQuery.of(context)
                                                .size
                                                .width /
                                            (MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2.3)),
                                itemCount: _selectedButton == 1
                                    ? Constants.leads_sectionsList1a.length
                                    : _selectedButton == 2
                                        ? Constants.leads_sectionsList2a.length
                                        : _selectedButton == 3 &&
                                                days_difference <= 31
                                            ? Constants
                                                .leads_sectionsList3a.length
                                            : Constants
                                                .leads_sectionsList3b.length,
                                padding: EdgeInsets.all(2.0),
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: 290,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.9,
                                        child: Stack(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                sales_index = index;
                                                setState(() {});
                                                if (kDebugMode) {
                                                  print("sales_indexjkjjk " +
                                                      index.toString());
                                                }
                                                if (index == 1) {
                                                  /*     Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => SalesReport()));*/
                                                }
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
                                                                      .ftaColorLight,
                                                                  width: 6))),
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: sales_index ==
                                                                          index
                                                                      ? Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.45)
                                                                      : Colors
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
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              0,
                                                                          left:
                                                                              0,
                                                                          bottom:
                                                                              4),
                                                                  child: Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            8,
                                                                      ),
                                                                      Expanded(
                                                                        child: Center(
                                                                            child: Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                          child:
                                                                              Text(
                                                                            formatLargeNumber((_selectedButton == 1
                                                                                    ? Constants.leads_sectionsList1a[index].amount
                                                                                    : _selectedButton == 2
                                                                                        ? Constants.leads_sectionsList2a[index].amount
                                                                                        : _selectedButton == 3 && days_difference <= 31
                                                                                            ? Constants.leads_sectionsList3a[index].amount
                                                                                            : Constants.leads_sectionsList3b[index].amount)
                                                                                .toString()),
                                                                            style:
                                                                                TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            maxLines:
                                                                                2,
                                                                          ),
                                                                        )),
                                                                      ),
                                                                      Center(
                                                                          child:
                                                                              Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Text(
                                                                          _selectedButton == 1
                                                                              ? Constants.leads_sectionsList1a[index].id
                                                                              : _selectedButton == 2
                                                                                  ? Constants.leads_sectionsList2a[index].id
                                                                                  : _selectedButton == 3 && days_difference <= 31
                                                                                      ? Constants.leads_sectionsList3a[index].id
                                                                                      : Constants.leads_sectionsList3b[index].id,
                                                                          style:
                                                                              TextStyle(fontSize: 12.5),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          maxLines:
                                                                              1,
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
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 11.0, right: 3, top: 12, bottom: 12),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: MediaQuery.of(context)
                                                .size
                                                .width /
                                            (MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2.3)),
                                itemCount: _selectedButton == 1
                                    ? Constants
                                        .sales_sectionsList1a_sales_agent.length
                                    : _selectedButton == 2
                                        ? Constants
                                            .sales_sectionsList2a_sales_agent
                                            .length
                                        : _selectedButton == 3 &&
                                                days_difference <= 31
                                            ? Constants
                                                .sales_sectionsList3a_sales_agent
                                                .length
                                            : Constants
                                                .sales_sectionsList3b_sales_agent
                                                .length,
                                padding: EdgeInsets.all(2.0),
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: 290,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.9,
                                        child: Stack(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                sales_index = index;
                                                setState(() {});
                                                if (kDebugMode) {
                                                  print("sales_indexjkjjk " +
                                                      index.toString());
                                                }
                                                if (index == 1) {
                                                  /*     Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => SalesReport()));*/
                                                }
                                                restartInactivityTimer();
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 4.0, right: 8),
                                                child: Card(
                                                  surfaceTintColor:
                                                      Colors.white,
                                                  color: Colors.white,
                                                  elevation: 6,
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
                                                                      .ftaColorLight,
                                                                  width: 6))),
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: sales_index ==
                                                                          index
                                                                      ? Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.45)
                                                                      : Colors
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
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              0,
                                                                          left:
                                                                              0,
                                                                          bottom:
                                                                              4),
                                                                  child: Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            8,
                                                                      ),
                                                                      Expanded(
                                                                        child: Center(
                                                                            child: Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                          child:
                                                                              Text(
                                                                            formatLargeNumber((_selectedButton == 1
                                                                                    ? Constants.sales_sectionsList1a_sales_agent[index].amount
                                                                                    : _selectedButton == 2
                                                                                        ? Constants.sales_sectionsList2a_sales_agent[index].amount
                                                                                        : _selectedButton == 3 && days_difference <= 31
                                                                                            ? Constants.sales_sectionsList3a_sales_agent[index].amount
                                                                                            : Constants.sales_sectionsList3b_sales_agent[index].amount)
                                                                                .toString()),
                                                                            style:
                                                                                TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            maxLines:
                                                                                2,
                                                                          ),
                                                                        )),
                                                                      ),
                                                                      Center(
                                                                          child:
                                                                              Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Text(
                                                                          _selectedButton == 1
                                                                              ? Constants.sales_sectionsList1a_sales_agent[index].id
                                                                              : _selectedButton == 2
                                                                                  ? Constants.sales_sectionsList2a_sales_agent[index].id
                                                                                  : _selectedButton == 3 && days_difference <= 31
                                                                                      ? Constants.sales_sectionsList3a_sales_agent[index].id
                                                                                      : Constants.sales_sectionsList3b_sales_agent[index].id,
                                                                          style:
                                                                              TextStyle(fontSize: 12.5),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          maxLines:
                                                                              1,
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
                      Center(
                        child: InkWell(
                          onTap: () {
                            startInactivityTimer();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SalesAgentNewSale(),
                              ),
                            );
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Constants.ctaColorLight,
                                  borderRadius: BorderRadius.circular(360)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8, left: 16, right: 16),
                                child: Text(
                                  "Click to Load a New Lead or Sale",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 30, right: 30, top: 4, bottom: 4),
                                child: Container(
                                  height: 32,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(360),
                                    child: Material(
                                      elevation: 10,
                                      child: TextFormField(
                                        autofocus: false,
                                        decoration: InputDecoration(
                                          suffixIcon: InkWell(
                                            onTap: () {
                                              _searchingPolicy = true;
                                              restartInactivityTimer();
                                              isLoading = true;
                                              setState(() {});
                                              getPolicyInfo2(
                                                  _searchContoller.text
                                                      .toUpperCase(),
                                                  "kjhjguytuyghjgjhg765764tyfu");
                                            },
                                            child: Container(
                                              height: 35,
                                              width: 70,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0.0,
                                                    bottom: 0.0,
                                                    right: 0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Constants
                                                          .ctaColorLight,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              360)),
                                                  child: Center(
                                                    child: Text(
                                                      "Search",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          hintText: 'Search a policy',
                                          hintStyle: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          filled: true,
                                          fillColor:
                                              Colors.grey.withOpacity(0.09),
                                          contentPadding:
                                              EdgeInsets.only(left: 24),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.0)),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.0)),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        controller: _searchContoller,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_searchingPolicy == true)
                        Center(
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
                      (policydetails.length > 1)
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 0.0, right: 16, top: 8, bottom: 8),
                              child: Center(
                                child: Text(
                                  "${policydetails.length} Policies Found, Scroll to See More",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            )
                          : Container(),
                      (policydetails.length == 1)
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 0.0, right: 16, top: 12),
                              child: Center(
                                child: Text(
                                  "1 Policy Found",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: 0,
                      ),
                      _selectedButton == 1
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, top: 12),
                              child: Text((target_index == 0
                                      ? ((sales_index == 0
                                          ? "Submitted"
                                          : sales_index == 1
                                              ? "In-Progress"
                                              : "Rejected"))
                                      : ((sales_index == 0
                                          ? "Inforced"
                                          : sales_index == 1
                                              ? "In-Progress"
                                              : "Rejected"))) +
                                  " (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                            )
                          : _selectedButton == 2
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 12),
                                  child: Text((target_index == 0
                                          ? ((sales_index == 0
                                              ? "Submitted"
                                              : sales_index == 1
                                                  ? "In-Progress"
                                                  : "Rejected"))
                                          : ((sales_index == 0
                                              ? "Inforced"
                                              : sales_index == 1
                                                  ? "In-Progress"
                                                  : "Rejected"))) +
                                      " (${Constants.sales_formattedEndDate})"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 12),
                                  child: Text((target_index == 0
                                          ? ((sales_index == 0
                                              ? "Submitted"
                                              : sales_index == 1
                                                  ? "In-Progress"
                                                  : "Rejected"))
                                          : ((sales_index == 0
                                              ? "Inforced"
                                              : sales_index == 1
                                                  ? "In-Progress"
                                                  : "Rejected"))) +
                                      " (${Constants.sales_formattedStartDate} to ${Constants.sales_formattedEndDate})"),
                                ),
                      target_index == 0
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8, bottom: 8, top: 4),
                              child: Card(
                                surfaceTintColor: Colors.white,
                                color: Colors.white,
                                elevation: 6,
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
                                                      BorderRadius.circular(
                                                          360)),
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: Text("Client Name "),
                                                )),
                                            Expanded(
                                              flex: 3,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 22.0),
                                                child: Text(
                                                  "Action",
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: (_selectedButton == 1 &&
                                              sales_index == 0 &&
                                              Constants.leadsByAgentSales1a
                                                      .length ==
                                                  0)
                                          ? Center(
                                              child: Text(
                                                "No data available for the selected range",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            )
                                          : (_selectedButton == 1 &&
                                                  sales_index == 1 &&
                                                  Constants.leadsByAgentSales1b
                                                          .length ==
                                                      0)
                                              ? Center(
                                                  child: Text(
                                                    "No data available for the selected range",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                )
                                              : (_selectedButton == 1 &&
                                                      sales_index == 2 &&
                                                      Constants
                                                              .leadsByAgentSales1c
                                                              .length ==
                                                          0)
                                                  ? Center(
                                                      child: Text(
                                                        "No data available for the selected range",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    )
                                                  : ListView.builder(
                                                      itemCount: (_selectedButton == 1)
                                                          ? (sales_index == 0
                                                              ? Constants.leadsByAgentSales1a.length
                                                              : sales_index == 1
                                                                  ? Constants.leadsByAgentSales1b.length
                                                                  : Constants.leadsByAgentSales1c.length)
                                                          : (_selectedButton == 2)
                                                              ? (sales_index == 0
                                                                  ? Constants.leadsByAgentSales2a.length
                                                                  : sales_index == 1
                                                                      ? Constants.leadsByAgentSales2b.length
                                                                      : Constants.leadsByAgentSales2c.length)
                                                              : (_selectedButton == 3 && days_difference <= 31)
                                                                  ? (sales_index == 0
                                                                      ? Constants.leadsByAgentSales3a.length
                                                                      : sales_index == 1
                                                                          ? Constants.leadsByAgentSales3b.length
                                                                          : Constants.leadsByAgentSales3c.length)
                                                                  : (sales_index == 0
                                                                      ? Constants.leadsByAgentSales4a.length
                                                                      : sales_index == 1
                                                                          ? Constants.leadsByAgentSales4b.length
                                                                          : Constants.leadsByAgentSales4c.length),
                                                      shrinkWrap: true,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      itemBuilder: (BuildContext context, int index) {
                                                        // Safety check for empty lists during data refresh
                                                        final currentList = (_selectedButton ==
                                                                1)
                                                            ? (sales_index == 0
                                                                ? Constants
                                                                    .leadsByAgentSales1a
                                                                : sales_index ==
                                                                        1
                                                                    ? Constants
                                                                        .leadsByAgentSales1b
                                                                    : Constants
                                                                        .leadsByAgentSales1c)
                                                            : (_selectedButton ==
                                                                    2)
                                                                ? (sales_index ==
                                                                        0
                                                                    ? Constants
                                                                        .leadsByAgentSales2a
                                                                    : sales_index ==
                                                                            1
                                                                        ? Constants
                                                                            .leadsByAgentSales2b
                                                                        : Constants
                                                                            .leadsByAgentSales2c)
                                                                : (_selectedButton ==
                                                                            3 &&
                                                                        days_difference <=
                                                                            31)
                                                                    ? (sales_index ==
                                                                            0
                                                                        ? Constants
                                                                            .leadsByAgentSales3a
                                                                        : sales_index ==
                                                                                1
                                                                            ? Constants
                                                                                .leadsByAgentSales3b
                                                                            : Constants
                                                                                .leadsByAgentSales3c)
                                                                    : (sales_index ==
                                                                            0
                                                                        ? Constants
                                                                            .leadsByAgentSales4a
                                                                        : sales_index ==
                                                                                1
                                                                            ? Constants.leadsByAgentSales4b
                                                                            : Constants.leadsByAgentSales4c);

                                                        if (index >=
                                                            currentList
                                                                .length) {
                                                          return SizedBox
                                                              .shrink(); // Return empty widget if index is out of bounds
                                                        }

                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 8.0),
                                                          child: InkWell(
                                                            onTap: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    true,
                                                                builder:
                                                                    (context) =>
                                                                        SingleLeadOverview(
                                                                  sale:
                                                                      currentList[
                                                                          index],
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            45,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 4.0),
                                                                          child:
                                                                              Text("${index + 1} "),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                          flex:
                                                                              4,
                                                                          child:
                                                                              Text("${currentList[index].title} ${currentList[index].first_name} ${currentList[index].last_name}")),
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              60,
                                                                          height:
                                                                              30,
                                                                          decoration: BoxDecoration(
                                                                              // color: ("${(_selectedButton == 1) ? (sales_index == 0 ? Constants.leadsByAgentSales1a[index].status : sales_index == 1 ? Constants.leadsByAgentSales1b[index].status : Constants.leadsByAgentSales1c[index].status) : (_selectedButton == 2) ? (sales_index == 0 ? Constants.leadsByAgentSales2a[index].status : sales_index == 1 ? Constants.leadsByAgentSales2b[index].status : Constants.leadsByAgentSales2c[index].status) : (_selectedButton == 3 && days_difference <= 31) ? (sales_index == 0 ? Constants.leadsByAgentSales3a[index].status : sales_index == 1 ? Constants.leadsByAgentSales3a[index].status : Constants.leadsByAgentSales3c[index].status) : (sales_index == 0 ? Constants.leadsByAgentSales4a[index].status : sales_index == 1 ? Constants.leadsByAgentSales4b[index].status : Constants.leadsByAgentSales4c[index].status)}") ==
                                                                              //             "Inforced" ||
                                                                              //         ("${(_selectedButton == 1) ? (sales_index == 0 ? Constants.leadsByAgentSales1a[index].status : sales_index == 1 ? Constants.leadsByAgentSales1b[index].status : Constants.leadsByAgentSales1c[index].status) : (_selectedButton == 2) ? (sales_index == 0 ? Constants.leadsByAgentSales2a[index].status : sales_index == 1 ? Constants.leadsByAgentSales2b[index].status : Constants.leadsByAgentSales2c[index].status) : (_selectedButton == 3 && days_difference <= 31) ? (sales_index == 0 ? Constants.leadsByAgentSales3a[index].status : sales_index == 1 ? Constants.leadsByAgentSales3a[index].status : Constants.leadsByAgentSales3c[index].status) : (sales_index == 0 ? Constants.leadsByAgentSales4a[index].status : sales_index == 1 ? Constants.leadsByAgentSales4b[index].status : Constants.leadsByAgentSales4c[index].status)}") ==
                                                                              //             "Completed"
                                                                              //     ? Colors.green
                                                                              color: sales_index == 0
                                                                                  ? Colors.green
                                                                                  : sales_index == 1
                                                                                      ? Colors.orange
                                                                                      : Colors.red,
                                                                              borderRadius: BorderRadius.circular(360)),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(4.0),
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                // ("${((_selectedButton == 1) ? (sales_index == 0 ? Constants.leadsByAgentSales1a[index].status : sales_index == 1 ? Constants.leadsByAgentSales1b[index].status : Constants.leadsByAgentSales1c[index].status) : (_selectedButton == 2) ? (sales_index == 0 ? Constants.leadsByAgentSales2a[index].status : sales_index == 1 ? Constants.leadsByAgentSales2b[index].status : Constants.leadsByAgentSales2c[index].status) : (_selectedButton == 3 && days_difference <= 31) ? (sales_index == 0 ? Constants.leadsByAgentSales3a[index].status : sales_index == 1 ? Constants.leadsByAgentSales3a[index].status : Constants.leadsByAgentSales3c[index].status) : (sales_index == 0 ? Constants.leadsByAgentSales4a[index].status : sales_index == 1 ? Constants.leadsByAgentSales4b[index].status : Constants.leadsByAgentSales4c[index].status))}")
                                                                                //         .substring(0, 1)
                                                                                //         .toUpperCase() +
                                                                                //     ("${((_selectedButton == 1) ? (sales_index == 0 ? Constants.leadsByAgentSales1a[index].status : sales_index == 1 ? Constants.leadsByAgentSales1b[index].status : Constants.leadsByAgentSales1c[index].status) : (_selectedButton == 2) ? (sales_index == 0 ? Constants.leadsByAgentSales2a[index].status : sales_index == 1 ? Constants.leadsByAgentSales2b[index].status : Constants.leadsByAgentSales2c[index].status) : (_selectedButton == 3 && days_difference <= 31) ? (sales_index == 0 ? Constants.leadsByAgentSales3a[index].status : sales_index == 1 ? Constants.leadsByAgentSales3a[index].status : Constants.leadsByAgentSales3c[index].status) : (sales_index == 0 ? Constants.leadsByAgentSales4a[index].status : sales_index == 1 ? Constants.leadsByAgentSales4b[index].status : Constants.leadsByAgentSales4c[index].status))}")
                                                                                //         .substring(1),
                                                                                "View",
                                                                                textAlign: TextAlign.left,
                                                                                style: TextStyle(color: Colors.white, fontSize: 12),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              14),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
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
                                                          ),
                                                        );
                                                      }),
                                    ),
                                  ],
                                )),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8, bottom: 8, top: 4),
                              child: Card(
                                surfaceTintColor: Colors.white,
                                color: Colors.white,
                                elevation: 6,
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
                                                      BorderRadius.circular(
                                                          360)),
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12.0),
                                                  child: Text("Policy Number "),
                                                )),
                                            Expanded(
                                              flex: 3,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 22.0),
                                                child: Text(
                                                  "Status",
                                                  textAlign: TextAlign.left,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: (_selectedButton == 1 &&
                                              sales_index == 0 &&
                                              Constants.salesByAgentSales1a.length ==
                                                  0)
                                          ? Center(
                                              child: Text(
                                                "No data available for the selected range",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            )
                                          : (_selectedButton == 1 &&
                                                  sales_index == 1 &&
                                                  Constants.salesByAgentSales1b.length ==
                                                      0)
                                              ? Center(
                                                  child: Text(
                                                    "No data available for the selected range",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                )
                                              : (_selectedButton == 1 &&
                                                      sales_index == 2 &&
                                                      Constants
                                                              .salesByAgentSales1c
                                                              .length ==
                                                          0)
                                                  ? Center(
                                                      child: Text(
                                                        "No data available for the selected range",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    )
                                                  : ListView.builder(
                                                      itemCount: (_selectedButton ==
                                                              1)
                                                          ? (sales_index == 0
                                                              ? Constants
                                                                  .salesByAgentSales1a
                                                                  .length
                                                              : sales_index == 1
                                                                  ? Constants.salesByAgentSales1b.length
                                                                  : Constants.salesByAgentSales1c.length)
                                                          : (_selectedButton == 2)
                                                              ? (sales_index == 0
                                                                  ? Constants.salesByAgentSales2a.length
                                                                  : sales_index == 1
                                                                      ? Constants.salesByAgentSales2b.length
                                                                      : Constants.salesByAgentSales2c.length)
                                                              : (_selectedButton == 3 && days_difference <= 31)
                                                                  ? (sales_index == 0
                                                                      ? Constants.salesByAgentSales3a.length
                                                                      : sales_index == 1
                                                                          ? Constants.salesByAgentSales3b.length
                                                                          : Constants.salesByAgentSales3c.length)
                                                                  : (sales_index == 0
                                                                      ? Constants.salesByAgentSales4a.length
                                                                      : sales_index == 1
                                                                          ? Constants.salesByAgentSales4b.length
                                                                          : Constants.salesByAgentSales4c.length),
                                                      shrinkWrap: true,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      itemBuilder: (BuildContext context, int index) {
                                                        // Safety check for empty lists during data refresh
                                                        final currentList = (_selectedButton ==
                                                                1)
                                                            ? (sales_index == 0
                                                                ? Constants
                                                                    .salesByAgentSales1a
                                                                : sales_index ==
                                                                        1
                                                                    ? Constants
                                                                        .salesByAgentSales1b
                                                                    : Constants
                                                                        .salesByAgentSales1c)
                                                            : (_selectedButton ==
                                                                    2)
                                                                ? (sales_index ==
                                                                        0
                                                                    ? Constants
                                                                        .salesByAgentSales2a
                                                                    : sales_index ==
                                                                            1
                                                                        ? Constants
                                                                            .salesByAgentSales2b
                                                                        : Constants
                                                                            .salesByAgentSales2c)
                                                                : (_selectedButton ==
                                                                            3 &&
                                                                        days_difference <=
                                                                            31)
                                                                    ? (sales_index ==
                                                                            0
                                                                        ? Constants
                                                                            .salesByAgentSales3a
                                                                        : sales_index ==
                                                                                1
                                                                            ? Constants
                                                                                .salesByAgentSales3b
                                                                            : Constants
                                                                                .salesByAgentSales3c)
                                                                    : (sales_index ==
                                                                            0
                                                                        ? Constants
                                                                            .salesByAgentSales4a
                                                                        : sales_index ==
                                                                                1
                                                                            ? Constants.salesByAgentSales4b
                                                                            : Constants.salesByAgentSales4c);

                                                        if (index >=
                                                            currentList
                                                                .length) {
                                                          return SizedBox
                                                              .shrink(); // Return empty widget if index is out of bounds
                                                        }

                                                        // Get the appropriate status field
                                                        final currentStatus =
                                                            (_selectedButton ==
                                                                            1 &&
                                                                        sales_index ==
                                                                            2) ||
                                                                    (_selectedButton ==
                                                                            2 &&
                                                                        sales_index ==
                                                                            2) ||
                                                                    (_selectedButton ==
                                                                            3 &&
                                                                        sales_index ==
                                                                            2)
                                                                ? currentList[
                                                                        index]
                                                                    .status
                                                                : currentList[
                                                                        index]
                                                                    .actual_status;
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 8.0),
                                                          child: InkWell(
                                                            onTap: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    true,
                                                                builder:
                                                                    (context) =>
                                                                        SinglePolicyOverview(
                                                                  index: index,
                                                                  target_index:
                                                                      sales_index,
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            45,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 4.0),
                                                                          child:
                                                                              Text("${index + 1} "),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                          flex:
                                                                              4,
                                                                          child: Text((_selectedButton == 1 && sales_index == 2 && currentList[index].policy_number.isEmpty)
                                                                              ? currentList[index].reference
                                                                              : currentList[index].policy_number)),
                                                                      Expanded(
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Container(
                                                                              width: 30,
                                                                              height: 30,
                                                                              decoration: BoxDecoration(
                                                                                  color: currentStatus == "Inforced"
                                                                                      ? Colors.green
                                                                                      : currentStatus == "Pending Inforce"
                                                                                          ? Colors.orange
                                                                                          : Colors.red,
                                                                                  borderRadius: BorderRadius.circular(360)),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(4.0),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    currentStatus.isNotEmpty ? currentStatus[0].toUpperCase() : "",
                                                                                    textAlign: TextAlign.left,
                                                                                    style: TextStyle(color: Colors.white),
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
                                                                    padding: const EdgeInsets
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
                                                          ),
                                                        );
                                                      }),
                                    ),
                                  ],
                                )),
                              ),
                            ),
                      SizedBox(
                        height: 12,
                      ),
                      if (target_index == 0)
                        SizedBox(
                          height: 12,
                        ),
                    ],
                  )),
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
    secureScreen();
    _animateButton(1);
    setState(() {});
    myNotifier = MyNotifier(salesValue, context);
    salesValue.addListener(() {
      kyrt = UniqueKey();

      if (mounted) setState(() {});
      Future.delayed(Duration(seconds: 2)).then((value) {
        print("ghjfgfgfgg");
        Constants.sales_tree_key3a = UniqueKey();
        if (mounted) setState(() {});

        print("ghjfgfgfgg $_selectedButton");
      });
    });
    Future.delayed(Duration(seconds: 3)).then((value) {
      if (mounted) setState(() {});
      Constants.sales_tree_key3a = UniqueKey();
      if (mounted) setState(() {});
    });
    Future.delayed(Duration(seconds: 5)).then((value) {
      if (mounted) setState(() {});
    });
    Future.delayed(Duration(seconds: 7)).then((value) {
      if (mounted) setState(() {});
    });

    Future.delayed(Duration(seconds: 7)).then((value) {
      if (mounted) setState(() {});
    });
/*    myNotifier = MyNotifier(salesValue, context);
    salesValue.addListener(() {
      kyrt = UniqueKey();
      setState(() {});
      Future.delayed(Duration(seconds: 2)).then((value) {
        print("ghjg");
        setState(() {});
      });
    });
    Future.delayed(Duration(seconds: 3)).then((value) {
      setState(() {});
    });
    print(Constants.sales_spots2a);*/

    /*  getSalesReport3a(Constants.sales_formattedStartDate,
        Constants.sales_formattedEndDate, 3, days_difference);*/
    if (mounted) setState(() {});
    // getSalesReport(context, formattedStartDate, formattedEndDate);
    Constants.pageLevel = 2;
    startInactivityTimer();

    super.initState();
  }

  init2() {
    DateTime now = DateTime.now();
    DateTime startDate = DateTime(now.year, now.month, 1);
    DateTime endDate = DateTime.now();

    DateTime firstDayNextMonth;

// Check if this month is December, then the next month is January of next year
    if (now.month == 12) {
      firstDayNextMonth = DateTime(now.year + 1, 1, 1);
    } else {
      firstDayNextMonth = DateTime(now.year, now.month + 1, 1);
    }

    DateTime lastDayThisMonth = firstDayNextMonth.subtract(Duration(days: 1));
    noOfDaysThisMonth = lastDayThisMonth.day;

    _animateButton(1);
    Constants.sales_formattedStartDate =
        DateFormat('yyyy-MM-dd').format(startDate!);
    Constants.sales_formattedEndDate =
        DateFormat('yyyy-MM-dd').format(endDate!);
    setState(() {});

    String dateRange =
        '${Constants.sales_formattedStartDate} - ${Constants.sales_formattedEndDate}';
    print("currently loading ${dateRange}");
    DateTime startDateTime =
        DateFormat('yyyy-MM-dd').parse(Constants.sales_formattedStartDate);
    DateTime endDateTime =
        DateFormat('yyyy-MM-dd').parse(Constants.sales_formattedEndDate);

    days_difference = endDateTime.difference(startDateTime).inDays;

    if (kDebugMode) {
      print("days_difference ${days_difference}");
      print("formattedEndDate9 ${Constants.sales_formattedEndDate}");
    }
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
                _selectedButton == 1
                    ? Constants.sales_salesbybranch1a[index - 1].branch_name
                    : Constants.sales_salesbybranch2a[index - 1].branch_name,
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

  FlTitlesData getTitlesData2(List<String> bottomTitles) {
    return FlTitlesData(
      show: true,
      topTitles: const AxisTitles(
          sideTitles: SideTitles(
        showTitles: false,
      )),
      rightTitles: const AxisTitles(
          sideTitles: SideTitles(
        showTitles: false,
      )),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            int index = value.toInt();
            return SideTitleWidget(
              axisSide: meta.axisSide,
              space: 8.0,
              child: Text(
                bottomTitles[index - 1],
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            return SideTitleWidget(
              axisSide: meta.axisSide,
              space: 6.0,
              child: Text(
                value.toInt().toString(),
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> getPolicyInfo2(String searchVal, String token) async {
    _searchingPolicy == true;
    isLoaded = true;
    setState(() {});
    restartInactivityTimer();
    Constants.selectedPolicydetails = [];
    policydetails = [];
    String urlPath =
        "onoloV6/getPoliciesMain?searchKey=${searchVal}&cec_client_id=${Constants.cec_client_id}&searchFrom=MOB&empid=${Constants.cec_employeeid}";
    String apiUrl = Constants.InsightsAdminbaseUrl + urlPath;
    print("cec_empid ${Constants.cec_employeeid}");

    // Map<String, dynamic> requestBody = {
    //   "empNum": Constants.cec_employeeid,
    //   //"empNum": 1331018,
    //   "searchVal": searchVal,
    //   "token": token,
    // };
    var response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
      },
    );
    print("fdgfh $apiUrl");
    if (response.statusCode == 200) {
      restartInactivityTimer();
      isLoaded = true;
      salesValue.value++;
      setState(() {});
      var data = jsonDecode(response.body);
      List<dynamic> policies_list = data;

      if (policies_list.isEmpty) {
        _searchingPolicy = false;
        isLoaded = false;
        print("msgtx $msgtx");
        salesValue.value++;
        MotionToast.error(
          onClose: () {},
          description: Text("Policy not found!"),
        ).show(context);
        setState(() {});
      } else {
        processElement(policies_list);

        _searchingPolicy = false;
        salesValue.value++;
        isLoaded = true;
        if (policydetails.isNotEmpty) {
          _searchingPolicy = false;
          salesValue.value++;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SinglePolicyOverview2()));
        } else {
          MotionToast.error(
            onClose: () {},
            description: Text("Policy not found!"),
          ).show(context);
        }
      }
    }

    setState(() {});
  }

  void processElement(dynamic elements) {
    try {
      for (var policy in elements) {
        /*String main_member_id = "";
        String main_member_name = "";
        String main_member_surname = "";
        String customer_contact = "";*/
        //List<dynamic> additional_members = lead['additional_members'];
        /*for (var member in additional_members) {
          if (member['member_type'] == 'main_member') {
            if (kDebugMode) {
              print("member0 " + member.toString());
              print("reference0 " + policy["reference"].toString());
            }

            main_member_id = (member["id"]).toString();
            main_member_name = (member["name"]).toString();
            customer_contact = (member["contact"]).toString();

            main_member_surname = member["surname"];
          }
        }
        print("empid " + (element["querying_emp_id"]).toString());
        Constants.cec_empid = element["querying_emp_id"];*/

        processPolicy(policy);

        /*    if (employeeidController.text.toUpperCase() ==
              main_member_id.toUpperCase()) {
            processPolicy(policy, element['paymentStatus'], main_member_id,
                main_member_name, main_member_surname);
          }
          else if (employeeidController.text.toUpperCase() ==
              policy["reference"]) {

          }*/
      }
    } catch (e) {
      print('Error processing element: $e');
    }
  }

  void processPolicy(dynamic policy) {
    try {
      Map mxcf = policy;

      String plantype = mxcf['product_type'];
      String policynumber = mxcf["policy_number"];
      String status = mxcf["quote_status"];
      double totalAmountPayable = mxcf["totalAmountPayable"];
      String inceptionDate = mxcf["inceptionDate"];
      String inforce_date = mxcf["inforce_date"];
      String main_member_id = mxcf["customer_id_number"];
      String main_member_name = mxcf["first_name"];
      String main_member_surname = mxcf["last_name"];
      double sumAssuredFamilyCover = mxcf["sumAssuredFamilyCover"] ?? 0;
      String customer_contact = mxcf["cell_number"];
      if (kDebugMode) {
        print("policy $policynumber main_member_name");
      }
      policydetails.add(PolicyDetails(
        policyNumber: policynumber,
        planType: plantype,
        status: status,
        monthsToPayFor: 1,
        paymentStatus: "paymentStatus",
        paymentsBehind: 0,
        monthlyPremium: totalAmountPayable,
        benefitAmount: sumAssuredFamilyCover,
        inforce_date: inforce_date,
        acceptTerms: false,
        customer_id_number: main_member_id,
        customer_first_name: main_member_name,
        customer_last_name: main_member_surname,
        customer_contact: customer_contact.toString(),
        inceptionDate: inceptionDate,
      ));

      Future.delayed(Duration(milliseconds: 100)).then((value) {
        // Your code to be executed after the delay
      });
    } catch (e) {
      print('Error processing policy: $e');
    }
  }

  /* List<TreemapLevel> _buildSecondLevel() {
    return [
      TreemapLevel(
        groupMapper: (int index) =>
            Constants.salesProductsGrouped1a[index].productType,
        color: Colors.green,
        padding: EdgeInsets.all(2),
        labelBuilder: (BuildContext context, TreemapTile tile) {
          return GestureDetector(
            onTap: () {
              Constants.sales_product_type_key = UniqueKey();
              setState(() {
                currentLevel = 0; // Set to show the first level
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${tile.group}',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          );
        },
      ),
    ];
  }*/
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

class CustomDotPainter extends FlDotPainter {
  final Color dotColor; // Color of the dot
  final double dotSize; // Size of the dot

  CustomDotPainter({
    required this.dotColor,
    required this.dotSize,
  });

  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    final paint = Paint()..color = dotColor;
    canvas.drawCircle(offsetInCanvas, dotSize / 2, paint);

    // Draw the text
    TextSpan span = TextSpan(
      style: TextStyle(
          color: Colors.black, fontSize: 7), // Adjust font size as needed
      text: spot.y.round().toString(),
    );
    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.ltr,
    );
    tp.layout();

    // Adjust the position to paint the text
    final Offset textOffset = Offset(
      offsetInCanvas.dx - tp.width / 2,
      offsetInCanvas.dy - tp.height - dotSize / 2 - 4,
    );

    // Paint the text
    tp.paint(canvas, textOffset);
  }

  @override
  Size getSize(FlSpot spot) {
    // Return the size of your dot
    return Size(dotSize, dotSize); // Example size, adjust as needed
  }

  @override
  List<Object?> get props =>
      [dotColor, dotSize]; // Include all the properties that can change

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) {
    if (a is CustomDotPainter && b is CustomDotPainter) {
      return CustomDotPainter(
        dotColor: Color.lerp(a.dotColor, b.dotColor, t)!,
        dotSize: lerpDouble(a.dotSize, b.dotSize, t)!,
      );
    }
    return b;
  }

  @override
  Color get mainColor => dotColor; // Provide your main color here

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Return true if the new instance has different properties
  }
}

class CustomDotPainterold extends FlDotPainter {
  final double yValue;
  final double xValue;
  final double maxX; // Maximum X-value of the chart
  final double maxY; // Maximum Y-value of the chart
  final double chartWidth; // Width of the chart
  final double chartHeight; // Height of the chart

  CustomDotPainterold({
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
    double yPosition =
        chartHeight - (yValue / Constants.sales_maxY) * chartHeight;

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
    return const Size(6, 6); // Example size, adjust as needed
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

  // If the value is less than 100 000, return it as a string with commas
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

String formatLargeNumber3(String valueStr) {
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

  return months[monthNumber - 1];
}

class LinePage extends StatefulWidget {
  const LinePage({Key? key}) : super(key: key);

  @override
  State<LinePage> createState() => _LinePageState();
}

class _LinePageState extends State<LinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 20.0,
            ),
            child: GestureDetector(
              onTap: () => setState(() {}),
              child: const Icon(
                Icons.refresh,
                size: 26.0,
              ),
            ),
          ),
        ],
        shadowColor: Colors.black.withOpacity(0.6),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text('Line'),
      ),
      backgroundColor: const Color(0xFF1B0E41),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 400.0,
            maxWidth: 600.0,
          ),
          padding: const EdgeInsets.all(24.0),
          child: Chart(
            layers: layers(),
            padding: const EdgeInsets.symmetric(horizontal: 30.0).copyWith(
              bottom: 12.0,
            ),
          ),
        ),
      ),
    );
  }

  List<ChartLayer> layers() {
    DateTime now = DateTime.now();
    final from = DateTime(now.year, now.month, 1);
    final to = DateTime.now();

    final frequency =
        (to.millisecondsSinceEpoch - from.millisecondsSinceEpoch) / 12;
    List<ChartLineDataItem> items = [];
    int index = 0;
    Constants.dailySalesCount_new.forEach((key, value) {
      print("dgjj $value");
      items.add(
        ChartLineDataItem(
          x: key.millisecondsSinceEpoch.toDouble(),
          value: value,
        ),
      );
      index++;
    });
    return [
      ChartHighlightLayer(
        shape: () => ChartHighlightLineShape<ChartLineDataItem>(
          backgroundColor: const Color(0xFF331B6D),
          currentPos: (item) => item.currentValuePos,
          radius: const BorderRadius.all(Radius.circular(8.0)),
          width: 60.0,
        ),
      ),
      ChartAxisLayer(
        settings: ChartAxisSettings(
          x: ChartAxisSettingsAxis(
            frequency: frequency,
            max: to.millisecondsSinceEpoch.toDouble(),
            min: from.millisecondsSinceEpoch.toDouble(),
            textStyle: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 10.0,
            ),
          ),
          y: ChartAxisSettingsAxis(
            frequency: Constants.sales_maxY.toDouble() / 5,
            max: 120,
            min: 0.0,
            textStyle: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 10.0,
            ),
          ),
        ),
        labelX: (value) => DateFormat('d')
            .format(DateTime.fromMillisecondsSinceEpoch(value.toInt())),

        /*labelX: (value) => DateFormat('MMM')
            .format(DateTime.fromMillisecondsSinceEpoch(value.toInt())),*/
        labelY: (value) => (value.toInt()).toString(),
      ),
      ChartLineLayer(
        items: items,
        settings: const ChartLineSettings(
          color: Color(0xFF8043F9),
          thickness: 4.0,
        ),
      ),
      ChartTooltipLayer(
        shape: () => ChartTooltipLineShape<ChartLineDataItem>(
          backgroundColor: Colors.white,
          circleBackgroundColor: Colors.white,
          circleBorderColor: const Color(0xFF331B6D),
          circleSize: 4.0,
          circleBorderThickness: 2.0,
          currentPos: (item) => item.currentValuePos,
          onTextValue: (item) => '${item.value.toInt().toString()}',
          marginBottom: 6.0,
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
          radius: 6.0,
          textStyle: const TextStyle(
            color: Color(0xFF8043F9),
            letterSpacing: 0.2,
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ];
  }
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

class SalesCollectionTypeGrid extends StatefulWidget {
  const SalesCollectionTypeGrid({super.key});

  @override
  State<SalesCollectionTypeGrid> createState() =>
      _SalesCollectionTypeGridState();
}

class _SalesCollectionTypeGridState extends State<SalesCollectionTypeGrid> {
  final List<Map<String, dynamic>> collectionTypes = [
    {'type': 'Cash', 'color': Colors.blue},
    {'type': 'Debit Order', 'color': Colors.orange},
    {'type': 'Persal', 'color': Colors.green},
    {'type': 'Sal. Ded.', 'color': Colors.yellow},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: collectionTypes.map((collectionType) {
            return Indicator1(
              color: collectionType['color']!,
              text: collectionType['type'],
              isSquare: false,
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState;
  }

  void processElement(dynamic element) {
    try {
      List<dynamic> leads = element['Lead'];
      Constants.cec_client_id = element["Lead"][0]["lead"]["cec_client_id"];

      for (var lead in leads) {
        List<dynamic> policies = lead['policy'];

        for (var policy in policies) {
          String main_member_id = "";
          String main_member_name = "";
          String main_member_surname = "";
          String customer_contact = "";
          List<dynamic> additional_members = lead['additional_members'];
          for (var member in additional_members) {
            if (member['member_type'] == 'main_member') {
              if (kDebugMode) {
                print("member0 " + member.toString());
                print("reference0 " + policy["reference"].toString());
              }

              main_member_id = (member["id"]).toString();
              main_member_name = (member["name"]).toString();
              customer_contact = (member["contact"]).toString();

              main_member_surname = member["surname"];
            }
          }
          print("empid " + (element["querying_emp_id"]).toString());
          Constants.cec_empid = element["querying_emp_id"];

          processPolicy(policy, element['paymentStatus'], main_member_id,
              main_member_name, main_member_surname, customer_contact);

          /*    if (employeeidController.text.toUpperCase() ==
              main_member_id.toUpperCase()) {
            processPolicy(policy, element['paymentStatus'], main_member_id,
                main_member_name, main_member_surname);
          }
          else if (employeeidController.text.toUpperCase() ==
              policy["reference"]) {

          }*/
        }
      }
    } catch (e) {
      print('Error processing element: $e');
    }
  }

  void processPolicy(
    dynamic policy,
    String paymentStatus,
    String main_member_id,
    String main_member_name,
    String main_member_surname,
    String customer_contact,
  ) {
    try {
      Map mxcf = policy['qoute'];

      String plantype = mxcf['product_type'];
      String policynumber = mxcf["policy_number"];
      String status = mxcf["status"];
      double totalAmountPayable = mxcf["totalAmountPayable"];
      String inceptionDate = mxcf["inceptionDate"];
      String inforce_date = mxcf["inforce_date"];
      double sumAssuredFamilyCover = mxcf["sumAssuredFamilyCover"];
      if (kDebugMode) {
        print("policy $policynumber main_member_name $main_member_name");
      }
      policydetails.add(PolicyDetails(
        policyNumber: policynumber,
        planType: plantype,
        status: status,
        monthsToPayFor: 1,
        paymentStatus: paymentStatus,
        paymentsBehind: 0,
        monthlyPremium: totalAmountPayable,
        benefitAmount: sumAssuredFamilyCover,
        inforce_date: inforce_date,
        acceptTerms: false,
        customer_id_number: main_member_id,
        customer_first_name: main_member_name,
        customer_last_name: main_member_surname,
        customer_contact: customer_contact,
        inceptionDate: inceptionDate,
      ));

      Future.delayed(Duration(milliseconds: 100)).then((value) {
        // Your code to be executed after the delay
      });
    } catch (e) {
      print('Error processing policy: $e');
    }
  }
}

class Indicator1 extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;

  const Indicator1({
    Key? key,
    required this.color,
    required this.text,
    this.isSquare = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Just an example, you can customize it as per your need
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Container(
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(36)),
            padding: EdgeInsets.all(4),
            margin: EdgeInsets.symmetric(horizontal: 4),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Text(
            text,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class SinglePolicyOverview extends StatefulWidget {
  final int index;
  final int target_index;
  const SinglePolicyOverview(
      {super.key, required this.index, required this.target_index});

  @override
  State<SinglePolicyOverview> createState() => _SinglePolicyOverviewState();
}

class _SinglePolicyOverviewState extends State<SinglePolicyOverview> {
  @override
  Widget build(BuildContext context) {
    // Safety check for empty lists during data refresh
    final currentList = (_selectedButton == 1) 
        ? (widget.target_index == 0 ? Constants.salesByAgentSales1a 
           : widget.target_index == 1 ? Constants.salesByAgentSales1b 
           : Constants.salesByAgentSales1c)
        : (_selectedButton == 2) 
            ? (widget.target_index == 0 ? Constants.salesByAgentSales2a 
               : widget.target_index == 1 ? Constants.salesByAgentSales2b 
               : Constants.salesByAgentSales2c)
            : (widget.target_index == 0 ? Constants.salesByAgentSales3a 
               : widget.target_index == 1 ? Constants.salesByAgentSales3b 
               : Constants.salesByAgentSales3c);
    
    if (widget.index >= currentList.length) {
      return Dialog(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Text("Data not available"),
        ),
      );
    }
    
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: EdgeInsets.only(left: 6.0, right: 6),
          surfaceTintColor: Colors.white,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0)),
                  child: Container(
                    color: Color(0xff44556a),
                    height: 16,
                  ),
                ),
                Container(
                  color: Color(0xff44556a),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Icon(CupertinoIcons.clear_circled,
                                    color: Colors.white),
                              )),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          "Policy Summary",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 32,
                      ),
                      Spacer()
                    ],
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 8, bottom: 8, top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("Policy #",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Text(currentList[widget.index].policy_number),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8),
                  child: Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("Sale Date",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                          child: Text((_selectedButton == 1
                                      ? widget.target_index == 0
                                          ? Constants
                                              .salesByAgentSales1a[widget.index]
                                              .sale_datetime
                                          : widget.target_index == 1
                                              ? Constants
                                                  .salesByAgentSales1b[
                                                      widget.index]
                                                  .sale_datetime
                                              : Constants
                                                  .salesByAgentSales1c[
                                                      widget.index]
                                                  .sale_datetime
                                      : _selectedButton == 2
                                          ? widget.target_index == 0
                                              ? Constants
                                                  .salesByAgentSales2a[
                                                      widget.index]
                                                  .sale_datetime
                                              : widget.target_index == 1
                                                  ? Constants
                                                      .salesByAgentSales2b[widget
                                                          .index]
                                                      .sale_datetime
                                                  : Constants
                                                      .salesByAgentSales2c[
                                                          widget.index]
                                                      .sale_datetime
                                          : widget.target_index == 0
                                              ? Constants
                                                  .salesByAgentSales3a[
                                                      widget.index]
                                                  .sale_datetime
                                              : widget.target_index == 1
                                                  ? Constants
                                                      .salesByAgentSales3b[
                                                          widget.index]
                                                      .sale_datetime
                                                  : Constants
                                                      .salesByAgentSales3c[
                                                          widget.index]
                                                      .sale_datetime)
                                  .isEmpty
                              ? ""
                              : DateFormat('EEE, d MMMM yyyy').format(
                                  DateTime.parse((_selectedButton == 1
                                      ? widget.target_index == 0
                                          ? Constants
                                              .salesByAgentSales1a[widget.index]
                                              .sale_datetime
                                          : widget.target_index == 1
                                              ? Constants
                                                  .salesByAgentSales1b[
                                                      widget.index]
                                                  .sale_datetime
                                              : Constants
                                                  .salesByAgentSales1c[
                                                      widget.index]
                                                  .sale_datetime
                                      : _selectedButton == 2
                                          ? widget.target_index == 0
                                              ? Constants
                                                  .salesByAgentSales2a[
                                                      widget.index]
                                                  .sale_datetime
                                              : widget.target_index == 1
                                                  ? Constants
                                                      .salesByAgentSales2b[
                                                          widget.index]
                                                      .sale_datetime
                                                  : Constants
                                                      .salesByAgentSales2c[
                                                          widget.index]
                                                      .sale_datetime
                                          : widget.target_index == 0
                                              ? Constants
                                                  .salesByAgentSales3a[
                                                      widget.index]
                                                  .sale_datetime
                                              : widget.target_index == 1
                                                  ? Constants
                                                      .salesByAgentSales3b[
                                                          widget.index]
                                                      .sale_datetime
                                                  : Constants
                                                      .salesByAgentSales3c[widget.index]
                                                      .sale_datetime))))),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8),
                  child: Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("Inception Date",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                          child: Text((_selectedButton == 1
                                      ? widget.target_index == 0
                                          ? Constants
                                              .salesByAgentSales1a[widget.index]
                                              .inception_date
                                          : widget.target_index == 1
                                              ? Constants
                                                  .salesByAgentSales1b[
                                                      widget.index]
                                                  .inception_date
                                              : Constants
                                                  .salesByAgentSales1c[
                                                      widget.index]
                                                  .inception_date
                                      : _selectedButton == 2
                                          ? widget.target_index == 0
                                              ? Constants
                                                  .salesByAgentSales2a[
                                                      widget.index]
                                                  .inception_date
                                              : widget.target_index == 1
                                                  ? Constants
                                                      .salesByAgentSales2b[
                                                          widget.index]
                                                      .inception_date
                                                  : Constants
                                                      .salesByAgentSales2c[
                                                          widget.index]
                                                      .inception_date
                                          : widget.target_index == 0
                                              ? Constants
                                                  .salesByAgentSales3a[
                                                      widget.index]
                                                  .inception_date
                                              : widget.target_index == 1
                                                  ? Constants
                                                      .salesByAgentSales3b[
                                                          widget.index]
                                                      .inception_date
                                                  : Constants
                                                      .salesByAgentSales3c[
                                                          widget.index]
                                                      .inception_date)
                                  .isEmpty
                              ? ""
                              : DateFormat('EEE, d MMMM yyyy').format(
                                  DateTime.parse(_selectedButton == 1
                                      ? widget.target_index == 0
                                          ? Constants
                                              .salesByAgentSales1a[widget.index]
                                              .inception_date
                                          : widget.target_index == 1
                                              ? Constants
                                                  .salesByAgentSales1b[
                                                      widget.index]
                                                  .inception_date
                                              : Constants
                                                  .salesByAgentSales1c[
                                                      widget.index]
                                                  .inception_date
                                      : _selectedButton == 2
                                          ? widget.target_index == 0
                                              ? Constants
                                                  .salesByAgentSales2a[
                                                      widget.index]
                                                  .inception_date
                                              : widget.target_index == 1
                                                  ? Constants
                                                      .salesByAgentSales2b[
                                                          widget.index]
                                                      .inception_date
                                                  : Constants
                                                      .salesByAgentSales2c[
                                                          widget.index]
                                                      .inception_date
                                          : widget.target_index == 0
                                              ? Constants
                                                  .salesByAgentSales3a[
                                                      widget.index]
                                                  .inception_date
                                              : widget.target_index == 1
                                                  ? Constants
                                                      .salesByAgentSales3b[
                                                          widget.index]
                                                      .inception_date
                                                  : Constants
                                                      .salesByAgentSales3c[widget.index]
                                                      .inception_date)))),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8),
                  child: Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                currentList[widget.index].totalAmountPayable ==
                        0
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "Premium",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text("R" +
                                  (double.tryParse((_selectedButton == 1
                                                  ? widget.target_index == 0
                                                      ? Constants
                                                          .salesByAgentSales1a[
                                                              widget.index]
                                                          .totalAmountPayable
                                                      : widget.target_index == 1
                                                          ? Constants
                                                              .salesByAgentSales1b[
                                                                  widget.index]
                                                              .totalAmountPayable
                                                          : Constants
                                                              .salesByAgentSales1c[
                                                                  widget.index]
                                                              .totalAmountPayable
                                                  : _selectedButton == 2
                                                      ? widget.target_index == 0
                                                          ? Constants
                                                              .salesByAgentSales2a[
                                                                  widget.index]
                                                              .totalAmountPayable
                                                          : widget.target_index ==
                                                                  1
                                                              ? Constants
                                                                  .salesByAgentSales2b[
                                                                      widget
                                                                          .index]
                                                                  .totalAmountPayable
                                                              : Constants
                                                                  .salesByAgentSales2c[
                                                                      widget
                                                                          .index]
                                                                  .totalAmountPayable
                                                      : widget.target_index == 0
                                                          ? Constants
                                                              .salesByAgentSales3a[
                                                                  widget.index]
                                                              .totalAmountPayable
                                                          : widget.target_index ==
                                                                  1
                                                              ? Constants
                                                                  .salesByAgentSales3b[
                                                                      widget
                                                                          .index]
                                                                  .totalAmountPayable
                                                              : Constants
                                                                  .salesByAgentSales3c[
                                                                      widget
                                                                          .index]
                                                                  .totalAmountPayable)
                                              .toString()) ??
                                          0)
                                      .toStringAsFixed(2)),
                            ),
                          ],
                        ),
                      ),
                currentList[widget.index].totalAmountPayable ==
                        0
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Container(
                          height: 1,
                          color: Colors.grey.withOpacity(0.1),
                        ),
                      ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("Product",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                          child: Text((_selectedButton == 1
                                  ? widget.target_index == 0
                                      ? Constants
                                          .salesByAgentSales1a[widget.index]
                                          .product
                                      : widget.target_index == 1
                                          ? Constants
                                              .salesByAgentSales1b[widget.index]
                                              .product
                                          : Constants
                                              .salesByAgentSales1c[widget.index]
                                              .product
                                  : _selectedButton == 1
                                      ? widget.target_index == 0
                                          ? Constants
                                              .salesByAgentSales2a[widget.index]
                                              .product
                                          : widget.target_index == 1
                                              ? Constants
                                                  .salesByAgentSales2b[
                                                      widget.index]
                                                  .product
                                              : Constants
                                                  .salesByAgentSales2c[
                                                      widget.index]
                                                  .product
                                      : widget.target_index == 0
                                          ? Constants
                                              .salesByAgentSales3a[widget.index]
                                              .product
                                          : widget.target_index == 1
                                              ? Constants
                                                  .salesByAgentSales3b[
                                                      widget.index]
                                                  .product
                                              : Constants
                                                  .salesByAgentSales3c[
                                                      widget.index]
                                                  .product) ??
                              "")),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8),
                  child: Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("Product Type",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                          child: Text((_selectedButton == 1
                              ? widget.target_index == 0
                                  ? currentList[widget.index]
                                      .product_type
                                  : widget.target_index == 1
                                      ? Constants
                                          .salesByAgentSales1b[widget.index]
                                          .product_type
                                      : Constants
                                          .salesByAgentSales1c[widget.index]
                                          .product_type
                              : _selectedButton == 2
                                  ? widget.target_index == 0
                                      ? Constants
                                          .salesByAgentSales2a[widget.index]
                                          .product_type
                                      : widget.target_index == 1
                                          ? Constants
                                              .salesByAgentSales2b[widget.index]
                                              .product_type
                                          : Constants
                                              .salesByAgentSales2c[widget.index]
                                              .product_type
                                  : widget.target_index == 0
                                      ? Constants
                                          .salesByAgentSales3a[widget.index]
                                          .product_type
                                      : widget.target_index == 1
                                          ? Constants
                                              .salesByAgentSales3b[widget.index]
                                              .product_type
                                          : Constants
                                              .salesByAgentSales3c[widget.index]
                                              .product_type))),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8),
                  child: Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Expanded(
                        child: Text("Payment Method",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                          child: Text((_selectedButton == 1
                              ? widget.target_index == 0
                                  ? currentList[widget.index]
                                      .payment_type
                                  : widget.target_index == 1
                                      ? Constants
                                          .salesByAgentSales1b[widget.index]
                                          .payment_type
                                      : Constants
                                          .salesByAgentSales1c[widget.index]
                                          .payment_type
                              : _selectedButton == 2
                                  ? widget.target_index == 0
                                      ? Constants
                                          .salesByAgentSales2a[widget.index]
                                          .payment_type
                                      : widget.target_index == 1
                                          ? Constants
                                              .salesByAgentSales2b[widget.index]
                                              .payment_type
                                          : Constants
                                              .salesByAgentSales2c[widget.index]
                                              .payment_type
                                  : widget.target_index == 0
                                      ? Constants
                                          .salesByAgentSales3a[widget.index]
                                          .payment_type
                                      : widget.target_index == 1
                                          ? Constants
                                              .salesByAgentSales3b[widget.index]
                                              .payment_type
                                          : Constants
                                              .salesByAgentSales3c[widget.index]
                                              .payment_type))),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8),
                  child: Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                if ((_selectedButton == 1
                        ? widget.target_index == 1
                            ? Constants
                                .salesByAgentSales1a[widget.index].description
                            : widget.target_index == 1
                                ? currentList[widget.index]
                                    .description
                                : currentList[widget.index]
                                    .description.isNotEmpty
                        : _selectedButton == 2
                            ? widget.target_index == 2
                                ? currentList[widget.index]
                                    .description
                                : widget.target_index == 1
                                    ? Constants
                                        .salesByAgentSales2b[widget.index]
                                        .description
                                    : Constants
                                        .salesByAgentSales2c[widget.index]
                                        .payment_type
                            : widget.target_index == 0
                                ? currentList[widget.index]
                                    .description
                                : widget.target_index == 1
                                    ? Constants
                                        .salesByAgentSales3b[widget.index]
                                        .description
                                    : Constants
                                        .salesByAgentSales3c[widget.index]
                                        .description)
                    .toString()
                    .isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16.0, right: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text("Description",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                            child: Text((_selectedButton == 1
                                ? widget.target_index == 0
                                    ? Constants
                                        .salesByAgentSales1a[widget.index]
                                        .description
                                    : widget.target_index == 1
                                        ? Constants
                                            .salesByAgentSales1b[widget.index]
                                            .description
                                        : Constants
                                            .salesByAgentSales1c[widget.index]
                                            .description
                                : _selectedButton == 2
                                    ? widget.target_index == 0
                                        ? Constants
                                            .salesByAgentSales2a[widget.index]
                                            .description
                                        : widget.target_index == 1
                                            ? Constants
                                                .salesByAgentSales2b[
                                                    widget.index]
                                                .description
                                            : Constants
                                                .salesByAgentSales2c[
                                                    widget.index]
                                                .description
                                    : widget.target_index == 0
                                        ? Constants
                                            .salesByAgentSales3a[widget.index]
                                            .description
                                        : widget.target_index == 1
                                            ? Constants
                                                .salesByAgentSales3b[
                                                    widget.index]
                                                .description
                                            : Constants
                                                .salesByAgentSales3c[
                                                    widget.index]
                                                .description))),
                      ],
                    ),
                  ),
                SizedBox(
                  height: 24,
                ),
              ]),
        ));
  }

  @override
  void initState() {
    super.initState();
    // print("fghghkjj ${widget.sale.status} ${widget.sale.actual_status}");
  }
}

class SingleLeadOverview extends StatefulWidget {
  final SalesByAgentLead sale;
  const SingleLeadOverview({super.key, required this.sale});

  @override
  State<SingleLeadOverview> createState() => _SingleLeadOverviewState();
}

class _SingleLeadOverviewState extends State<SingleLeadOverview> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: EdgeInsets.only(left: 6.0, right: 6),
          surfaceTintColor: Colors.white,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0)),
                  child: Container(
                    color: Color(0xff44556a),
                    height: 16,
                  ),
                ),
                Container(
                  color: Color(0xff44556a),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Icon(CupertinoIcons.clear_circled,
                                    color: Colors.white),
                              )),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          "Lead Summary",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 32,
                      ),
                      Spacer()
                    ],
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 8, bottom: 8, top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("Onololeadid #",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Text(widget.sale.onololeadid.toString()),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8),
                  child: Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("Sale Date",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                          child: Text(widget.sale.timestamp.isEmpty
                              ? ""
                              : DateFormat('EEE, d MMMM yyyy').format(
                                  DateTime.parse(widget.sale.timestamp)))),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8),
                  child: Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("Client Name",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                          child: Text(
                              "${widget.sale.title} ${widget.sale.last_name}")),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8),
                  child: Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "Ref #",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Text(widget.sale.reference),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("Assigned To",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                          child:
                              Text(widget.sale.assigned_to.toString() ?? "")),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8),
                  child: Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("Product Type",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(child: Text(widget.sale.product_type)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8),
                  child: Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Expanded(
                        child: Text("Mobile Number",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(child: Text(widget.sale.cell_number)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8),
                  child: Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Expanded(
                        child: Text("Lead Status",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                          child: Text(capitalizeWords(widget.sale.status))),
                    ],
                  ),
                ),
                if (widget.sale.hang_up_reason.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 8),
                    child: Container(
                      height: 1,
                      color: Colors.grey.withOpacity(0.1),
                    ),
                  ),
                if (widget.sale.hang_up_reason.isNotEmpty)
                  SizedBox(
                    height: 12,
                  ),
                if (widget.sale.hang_up_reason.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16.0, right: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Expanded(
                          child: Text("Reason",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                            child: Text(widget.sale.hang_up_reason +
                                " ${widget.sale.hang_up_desc2.isNotEmpty ? "- " + widget.sale.hang_up_desc2 : ""}")),
                      ],
                    ),
                  ),
                SizedBox(
                  height: 24,
                ),
              ]),
        ));
  }
}

class SinglePolicyOverview2 extends StatefulWidget {
  const SinglePolicyOverview2({
    super.key,
  });

  @override
  State<SinglePolicyOverview2> createState() => _SinglePolicyOverview2State();
}

class _SinglePolicyOverview2State extends State<SinglePolicyOverview2> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Search results"),
          elevation: 6,
          leading: InkWell(
              onTap: () {
                policydetails = [];
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
        ),
        body: ListView.builder(
            shrinkWrap: true,
            itemCount: policydetails.length,
            itemBuilder: (context, index) {
              PolicyDetails policydetails1 = policydetails[index];

              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  elevation: 5,
                  surfaceTintColor: Colors.white,
                  color: Colors.white,
                  /*decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(
                                  width: 1.2,
                                  color: Colors.grey.withOpacity(0.55),
                                ),

                            ),*/
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Row(
                            children: [
                              Text(
                                "Policy # : ${policydetails[index].policyNumber}",
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(
                              top: 4.0,
                              left: 0,
                              right: 0,
                            ),
                            height: 1,
                            color: Colors.grey.withOpacity(0.15)),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Main Member",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 16),
                              child: Text(
                                ":",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                                child: Text(
                              policydetails[index].customer_first_name,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Plan Type",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 16),
                              child: Text(
                                ":",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                                child: Text(
                              policydetails[index].planType,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Inception Date",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 16),
                              child: Text(
                                ":",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                                child: Text(
                              DateFormat('EEE, dd MMM').format(DateTime.parse(
                                  policydetails[index].inceptionDate)),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Inforce Date",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 16),
                              child: Text(
                                ":",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                                child: Text(
                              DateFormat('EEE, dd MMM').format(DateTime.parse(
                                  policydetails[index].inforce_date)),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Status",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 16),
                              child: Text(
                                ":",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                                child: Text(
                              policydetails[index].status,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Premium Amount",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 16),
                              child: Text(
                                ":",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xffED7D32),
                                          borderRadius:
                                              BorderRadius.circular(360),
                                          border: Border.all(
                                            width: 1.2,
                                            color: Color(0xffED7D32),
                                          )),
                                      padding:
                                          EdgeInsets.only(left: 0, right: 16),
                                      width: MediaQuery.of(context).size.width,
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          "R " +
                                              policydetails[index]
                                                  .monthlyPremium
                                                  .toString() +
                                              " p.m",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ))),
                                ),
                              ),
                            ),
                            /*Expanded(
                                          child: Text(
                                        "R${policydetails[index].monthlyPremium.toStringAsFixed(2)}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Color(0xffED7D32),
                                        ),
                                      )),*/
                          ],
                        ),
                        // SizedBox(
                        //   height: 12,
                        // ),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //         child: Text(
                        //       "Payment Status",
                        //       style: TextStyle(fontWeight: FontWeight.w500),
                        //     )),
                        //     Padding(
                        //       padding:
                        //           const EdgeInsets.only(left: 16.0, right: 16),
                        //       child: Text(
                        //         ":",
                        //         style: TextStyle(fontWeight: FontWeight.w500),
                        //       ),
                        //     ),
                        //     Expanded(
                        //         child: Text(
                        //       policydetails[index].paymentStatus,
                        //       style: TextStyle(fontWeight: FontWeight.w500),
                        //     )),
                        //   ],
                        // ),
                        // SizedBox(
                        //   height: 12,
                        // ),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //         child: Text(
                        //       "Benefit Amount",
                        //       style: TextStyle(fontWeight: FontWeight.w500),
                        //     )),
                        //     Padding(
                        //       padding:
                        //           const EdgeInsets.only(left: 16.0, right: 16),
                        //       child: Text(
                        //         ":",
                        //         style: TextStyle(fontWeight: FontWeight.w500),
                        //       ),
                        //     ),
                        //     Expanded(
                        //         child: Text(
                        //       "R${policydetails[index].benefitAmount.toStringAsFixed(2)}",
                        //       style: TextStyle(fontWeight: FontWeight.w500),
                        //     )),
                        //   ],
                        // ),
                        SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PaymentHistoryPage(
                                                policiynumber:
                                                    policydetails[index]
                                                        .policyNumber,
                                                planType: policydetails[index]
                                                    .planType,
                                                status:
                                                    policydetails[index].status,
                                              )));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(360),
                                      border: Border.all(
                                        width: 1.2,
                                        color: Color(0xffED7D32),
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Text(
                                        "Payment Management",
                                        style: TextStyle(
                                            color: Color(0xffED7D32),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}

String capitalizeWords(String input) {
  return input.replaceAllMapped(RegExp(r'(\b[a-z])'), (Match match) {
    return match.group(0)!.toUpperCase();
  });
}
