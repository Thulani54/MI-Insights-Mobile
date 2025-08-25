import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:screenshot/screenshot.dart';

import '../../../customwidgets/CustomCard.dart';
import '../../admin/ClientSearchPage.dart';
import '../../constants/Constants.dart';
import '../../customwidgets/custom_date_range_picker.dart';
import '../../customwidgets/custom_treemap/pages/tree_diagram.dart';
import '../../models/SalesByAgent.dart';
import '../../models/SalesByBranch.dart';
import '../../services/Executive/executive_sales_report_service.dart';
import '../../services/Sales Agent/sales_agent_sales_report_service.dart'
    hide colorOrder;
import '../../services/inactivitylogoutmixin.dart';
import 'Executive/ExecutiveSalesReport.dart';

class MarketingReport extends StatefulWidget {
  const MarketingReport({super.key});

  @override
  State<MarketingReport> createState() => _MarketingReportState();
}

final marketingValue = ValueNotifier<int>(0);
String jsonString = "";
List<BarChartGroupData> barChartData1 = [];
List<BarChartGroupData> barChartData2 = [];
List<BarChartGroupData> barChartData3 = [];
List<BarChartGroupData> barChartData4 = [];
Map<int, double> dailySalesCount1a = {};
bool isLoadingMarketingData = false;
String formattedStartDate = "";
String formattedEndDate = "";
int collections_grid_index = 0;
List<SalesByBranch> salesbybranch = [];
double _sliderPosition = 0.0; // Initial position for the sliding animation
double _sliderPosition5 = 0.0;
double _marketing_main_sliderPosition = 0.0;
double _sliderPosition2 = 0.0;
double _sliderPosition9 = 0.0;
double _sliderPosition11 = 0.0;

bool isLoadingLeadsReport = false;
DateTime datefrom = DateTime.now().subtract(Duration(days: 50));
DateTime dateto = DateTime.now();
int days_difference = 0;
List<gridmodel1> sectionsList = [];
List<gridmodel1> sectionsList2 = [];
List<gridmodel1> sectionsList3 = [];
List<double> sectionsListPercentages = [
  0,
  0,
  0,
];
Map<String, dynamic> collections_jsonResponse1a = {};
Map<String, dynamic> collections_jsonResponse2a = {};
Map<String, dynamic> collections_jsonResponse3a = {};
int report_index = 0;
int grid_index_2 = 0;
int _marketing_main_sliderPosition_index_2 = 0;
int collections_index = 0;
int target_index = 0;
int target_index_2 = 0;
int target_index_9 = 0;
int target_index_11 = 0;
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
List<QuotesByAgent> topquotesbyagent = [];
List<QuotesByClient> topquotesbyclient = [];
List<QuotesByAgent> topquotesbyagent1 = [];
int time_index = 0;

List<SalesByAgent> bottomsalesbyagent = [];
List<SalesByAgent> topsalesbyreceptionist = [];
List<SalesByAgent> bottomsalesbyreceptionist = [];
List<BarChartGroupData> collections_grouped_data = [];
ScreenshotController screenshotController = ScreenshotController();
bool isShowingType = false;
int _selectedButton = 1;
double _sliderPosition10 = 0.0;
int sales_index = 0;
int target_index9 = 0;

class _MarketingReportState extends State<MarketingReport>
    with InactivityLogoutMixin {
  Color _button1Color = Colors.grey.withOpacity(0.0);
  Color _button2Color = Colors.grey.withOpacity(0.0);
  Color _button3Color = Colors.grey.withOpacity(0.0);
  void _animateButton(int buttonNumber) {
    DateTime? startDate = DateTime.now();
    DateTime? endDate = DateTime.now();
    expected_sum_of_premiums = 0;
    expected_count_of_premiums = 0;
    barChartData1 = [];
    barChartData2 = [];
    barChartData3 = [];
    barChartData4 = [];
    topquotesbyagent = [];
    topquotesbyclient = [];
    bottomsalesbyagent = [];
    topsalesbyreceptionist = [];
    bottomsalesbyreceptionist = [];
    sectionsList = [
      gridmodel1("Submitted", 0, 0),
      gridmodel1("Captured", 0, 0),
      gridmodel1("Declined", 0, 0),
    ];
    sectionsListPercentages = [
      0,
      0,
      0,
    ];
    sectionsList2 = [
      gridmodel1("Total Members", 0, 0),
      gridmodel1("Main Under 65", 0, 0),
      gridmodel1("Main Under 85", 0, 0),
      gridmodel1("Main Over 85", 0, 0),
      gridmodel1("Extended", 0, 0),
    ];
    sectionsList3 = [
      gridmodel1("0 - 1 WEEK", 0, 0),
      gridmodel1("1 - 2 WEEKS", 0, 0),
      gridmodel1(">2 WEEKS", 0, 0),
    ];
    isLoadingMarketingData = true;
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

      if (kDebugMode) {
        //print("days_difference ${days_difference}");
        print(
            "_marketing_main_sliderPosition_index_2 ${_marketing_main_sliderPosition_index_2}");
      }

      if (_marketing_main_sliderPosition_index_2 == 0 ||
          _marketing_main_sliderPosition_index_2 == 1) {
        //  getMarketingReport(context, formattedStartDate, formattedEndDate);
      } else {
        getExecutiveLeadsReport(
            formattedStartDate, formattedEndDate, 3, days_difference, context);
      }

      getExecutiveLeadsReport(
        formattedStartDate,
        formattedEndDate,
        _selectedButton,
        2,
        context,
      ).then((val) {
        setState(() {});
      });

      // Add getSalesAgentLeadsReport call with loading state
      setState(() {
        isLoadingLeadsReport = true;
      });

      getSalesAgentLeadsReport(formattedStartDate, formattedEndDate,
              buttonNumber, days_difference, context)
          .then((_) {
        setState(() {
          isLoadingLeadsReport = false;
        });
      }).catchError((error) {
        print("❌ _animateButton: getSalesAgentLeadsReport error: $error");
        setState(() {
          isLoadingLeadsReport = false;
        });
      });

      setState(() {});
    } else {}
  }

  void _animateButton10(int buttonNumber) {
    restartInactivityTimer();

    setState(() {});

    time_index = buttonNumber;
    if (buttonNumber == 0) {
      _sliderPosition10 = 0.0;
    } else if (buttonNumber == 1) {
      _sliderPosition10 = (MediaQuery.of(context).size.width / 2) - 18;
    } else if (buttonNumber == 3) {
      if (days_difference < 31) {
        _sliderPosition10 = 2 * (MediaQuery.of(context).size.width / 3) - 32;
      }
      setState(() {});
    }
  }

  void _marketing_main_animateButton(int buttonNumber) {
    restartInactivityTimer();

    setState(() {});

    _marketing_main_sliderPosition_index_2 = buttonNumber;
    if (buttonNumber == 0) {
      _marketing_main_sliderPosition = 0.0;
    } else if (buttonNumber == 1) {
      _marketing_main_sliderPosition =
          (MediaQuery.of(context).size.width / 3) - 18;
    } else if (buttonNumber == 2) {
      _marketing_main_sliderPosition =
          2 * (MediaQuery.of(context).size.width / 3) - 32;
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
              surfaceTintColor: Colors.white,
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
                "Prospects",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: [
                if (Constants.myUserRoleLevel.toLowerCase() ==
                        "administrator" ||
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
                                        ClientSearchPage(
                                            onClientSelected: (val) {
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
              elevation: 6,
              shadowColor: Colors.black.withOpacity(0.6),
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
                              style:
                                  TextStyle(fontSize: 9.5, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    SizedBox(
                      height: 24,
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
                                            (MediaQuery.of(context).size.width /
                                                    3) -
                                                12,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(350)),
                                        height: 35,
                                        child: Center(
                                          child: Text(
                                            '1 Mth View',
                                            style:
                                                TextStyle(color: Colors.black),
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
                                            (MediaQuery.of(context).size.width /
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
                                                color: Colors.black,
                                                fontSize: 14),
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
                                          minimumDate:
                                              DateTime.utc(2023, 06, 01),
                                          maximumDate: DateTime.now()
                                              .add(Duration(days: 350)),
                                          backgroundColor: Colors.white,
                                          primaryColor: Constants.ctaColorLight,
                                          onApplyClick: (start, end) {
                                            setState(() {
                                              endDate = end;
                                              startDate = start;
                                              // Set loading states for circular progress indicators
                                              isLoadingMarketingData = true;

                                              _animateButton2(1);
                                              Future.delayed(
                                                      Duration(seconds: 2))
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
                                              print(
                                                  "_marketing_main_sliderPosition_index_2 ${_marketing_main_sliderPosition_index_2}");
                                            }

                                            if (_marketing_main_sliderPosition_index_2 ==
                                                    0 ||
                                                _marketing_main_sliderPosition_index_2 ==
                                                    1) {
                                              getExecutiveLeadsReport(
                                                  formattedStartDate,
                                                  formattedEndDate,
                                                  3,
                                                  days_difference,
                                                  context);
                                            } else {
                                              getExecutiveLeadsReport(
                                                  formattedStartDate,
                                                  formattedEndDate,
                                                  3,
                                                  days_difference,
                                                  context);
                                            }

                                            // Add getSalesAgentLeadsReport call with loading state
                                            print(
                                                "🔄 Date picker: Calling getSalesAgentLeadsReport with dates: $formattedStartDate to $formattedEndDate, days_difference: $days_difference");
                                            setState(() {
                                              isLoadingLeadsReport = true;
                                            });

                                            getSalesAgentLeadsReport(
                                                    formattedStartDate,
                                                    formattedEndDate,
                                                    _selectedButton,
                                                    days_difference,
                                                    context)
                                                .then((_) {
                                              print(
                                                  "✅ Date picker: getSalesAgentLeadsReport completed $_selectedButton");
                                              setState(() {
                                                isLoadingLeadsReport = false;
                                              });
                                            }).catchError((error) {
                                              print(
                                                  "❌ Date picker: getSalesAgentLeadsReport error: $error");
                                              setState(() {
                                                isLoadingLeadsReport = false;
                                              });
                                            });

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
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    3) -
                                                12,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(350)),
                                        child: Center(
                                          child: Text(
                                            'Select Dates',
                                            style:
                                                TextStyle(color: Colors.black),
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
                                              style: TextStyle(
                                                  color: Colors.white),
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
                                                DateTime? endDate =
                                                    DateTime.now();
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
                                                      // Set loading states for circular progress indicators
                                                      isLoadingMarketingData =
                                                          true;
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

                                                    days_difference =
                                                        endDateTime
                                                            .difference(
                                                                startDateTime)
                                                            .inDays;
                                                    if (kDebugMode) {
                                                      //print("days_difference ${days_difference}");
                                                      // print("formattedEndDate9 ${formattedEndDate}");
                                                    }

                                                    if (kDebugMode) {
                                                      //print("days_difference ${days_difference}");
                                                      print(
                                                          "_marketing_main_sliderPosition_index_2 ${_marketing_main_sliderPosition_index_2}");
                                                    }

                                                    if (_marketing_main_sliderPosition_index_2 ==
                                                            0 ||
                                                        _marketing_main_sliderPosition_index_2 ==
                                                            1) {
                                                      getExecutiveLeadsReport(
                                                          formattedStartDate,
                                                          formattedEndDate,
                                                          3,
                                                          days_difference,
                                                          context);
                                                    } else {
                                                      getExecutiveLeadsReport(
                                                          formattedStartDate,
                                                          formattedEndDate,
                                                          3,
                                                          days_difference,
                                                          context);
                                                    }

                                                    // Add getSalesAgentLeadsReport call with loading state
                                                    print(
                                                        "🔄 Date picker 2: Calling getSalesAgentLeadsReport with dates: $formattedStartDate to $formattedEndDate, days_difference: $days_difference");
                                                    setState(() {
                                                      isLoadingLeadsReport =
                                                          true;
                                                    });

                                                    getSalesAgentLeadsReport(
                                                            formattedStartDate,
                                                            formattedEndDate,
                                                            3,
                                                            days_difference,
                                                            context)
                                                        .then((_) {
                                                      print(
                                                          "✅ Date picker 2: getSalesAgentLeadsReport completed");
                                                      setState(() {
                                                        isLoadingLeadsReport =
                                                            false;
                                                      });
                                                    }).catchError((error) {
                                                      print(
                                                          "❌ Date picker 2: getSalesAgentLeadsReport error: $error");
                                                      setState(() {
                                                        isLoadingLeadsReport =
                                                            false;
                                                      });
                                                    });
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
                    SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20, top: 12),
                      child: Container(
                        height: 1,
                        color: Colors.grey.withOpacity(0.35),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    isLoadingMarketingData || isLoadingLeadsReport
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
                          const EdgeInsets.only(left: 16.0, right: 16, top: 8),
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
                                        _marketing_main_animateButton(0);
                                      },
                                      child: Container(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    3) -
                                                12,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(360)),
                                        height: 35,
                                        child: Center(
                                          child: Text(
                                            'Individual',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _marketing_main_animateButton(1);
                                      },
                                      child: Container(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    3) -
                                                12,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(360)),
                                        child: Center(
                                          child: Text(
                                            'Employer',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _marketing_main_animateButton(2);
                                      },
                                      child: Container(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    3) -
                                                12,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(360)),
                                        child: Center(
                                          child: Text(
                                            'Affinity',
                                            style:
                                                TextStyle(color: Colors.black),
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
                              left: _marketing_main_sliderPosition,
                              child: InkWell(
                                onTap: () {
                                  _marketing_main_animateButton(2);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Constants
                                        .ctaColorLight, // Color of the slider
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: _marketing_main_sliderPosition_index_2 ==
                                          0
                                      ? Center(
                                          child: Text(
                                            'Individual',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      : _marketing_main_sliderPosition_index_2 ==
                                              1
                                          ? Center(
                                              child: Text(
                                                'Employer ',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          : Center(
                                              child: Text(
                                                'Affinity',
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
                    SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (_marketing_main_sliderPosition_index_2 == 1)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 125,
                                          child: InkWell(
                                              onTap: () {
                                                restartInactivityTimer();
                                              },
                                              child: Container(
                                                height: 125,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.9,
                                                child: Stack(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {},
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 4.0,
                                                                right: 8),
                                                        child: Card(
                                                          surfaceTintColor:
                                                              Colors.white,
                                                          elevation: 6,
                                                          color: Colors.white,
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
                                                                        BorderRadius.circular(
                                                                            16))),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border(
                                                                      bottom: BorderSide(
                                                                          color: Constants
                                                                              .ftaColorLight,
                                                                          width:
                                                                              6))),
                                                              child: Column(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Colors.grey.withOpacity(
                                                                              0.05),
                                                                          border:
                                                                              Border.all(color: Colors.grey.withOpacity(0.0)),
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
                                                                          child: isLoadingMarketingData == true
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
                                                                                          "R" + formatLargeNumber3(sectionsList[0].amount.toString()),
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
                                                                                        formatLargeNumber2(sectionsList[0].count.toString()),
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
                                          height: 125,
                                          child: InkWell(
                                              onTap: () {
                                                restartInactivityTimer();
                                              },
                                              child: Container(
                                                height: 125,
                                                width: MediaQuery.of(context)
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
                                                                bottom: 4.0,
                                                                right: 8),
                                                        child: Card(
                                                          surfaceTintColor:
                                                              Colors.white,
                                                          elevation: 6,
                                                          color: Colors.white,
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
                                                                        BorderRadius.circular(
                                                                            16))),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border(
                                                                      bottom: BorderSide(
                                                                          color: Constants
                                                                              .ftaColorLight,
                                                                          width:
                                                                              6))),
                                                              child:
                                                                  isLoadingMarketingData ==
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
                                                                                              "R" + formatLargeNumber3(sectionsList[1].amount.toString()),
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
                                                                                            formatLargeNumber2(sectionsList[1].count.toString()),
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
                                          height: 125,
                                          child: InkWell(
                                              onTap: () {
                                                restartInactivityTimer();
                                              },
                                              child: Container(
                                                height: 125,
                                                width: MediaQuery.of(context)
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
                                                                        BorderRadius.circular(
                                                                            16))),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border(
                                                                      bottom: BorderSide(
                                                                          color: Constants
                                                                              .ftaColorLight,
                                                                          width:
                                                                              6))),
                                                              child:
                                                                  isLoadingMarketingData ==
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
                                                                                              "R" + formatLargeNumber3(sectionsList[2].amount.toString()),
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
                                                                                            formatLargeNumber2(sectionsList[2].count.toString()),
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
                                      SizedBox(
                                        width: 8,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  _selectedButton == 1
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              left: 0.0, bottom: 0),
                                          child: Center(
                                              child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0,
                                                          right: 16,
                                                          bottom: 8),
                                                  child: Text(
                                                      "Quote Acceptance Rate (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                                ),
                                              )
                                            ],
                                          )),
                                        )
                                      : _selectedButton == 2
                                          ? Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20.0,
                                                            right: 16,
                                                            bottom: 8),
                                                    child: Text(
                                                        "Quote Acceptance Rate (12 Months View)"),
                                                  ),
                                                )
                                              ],
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0.0, bottom: 12),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20.0,
                                                              right: 16,
                                                              bottom: 8),
                                                      child: Text(
                                                          "Quote Acceptance Rate (${formattedStartDate} to ${formattedEndDate})"),
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
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: LinearPercentIndicator(
                                      width: MediaQuery.of(context).size.width -
                                          14,
                                      animation: true,
                                      lineHeight: 20.0,
                                      animationDuration: 500,
                                      percent: sectionsListPercentages[0],
                                      center: Text(
                                          "${(sectionsListPercentages[0] * 100).toStringAsFixed(0)}%",
                                          style: TextStyle(
                                            color:
                                                sectionsListPercentages[0] < 0.4
                                                    ? Colors.black
                                                    : Colors.white,
                                          )),
                                      barRadius: ui.Radius.circular(12),
                                      //linearStrokeCap: LinearStrokeCap.roundAll,
                                      progressColor:
                                          sectionsListPercentages[0] < 1
                                              ? Colors.red
                                              : Colors.green,
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  _selectedButton == 1
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Text(
                                              "Quotation Overview (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                        )
                                      : _selectedButton == 2
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: Text(
                                                  "Quotation Overview (12 Months View)"),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: Text(
                                                  "Quotation Overview (${formattedStartDate} to ${formattedEndDate})"),
                                            ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, right: 4.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color:
                                                Colors.grey.withOpacity(0.00)),
                                        height: 250,
                                        child: isLoadingMarketingData == false
                                            ? _selectedButton == 1
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 12,
                                                            top: 8.0,
                                                            right: 12),
                                                    child: (isLoadingMarketingData ==
                                                            true)
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(12.0),
                                                            child: CustomCard(
                                                              elevation: 6,
                                                              color:
                                                                  Colors.white,
                                                              child: Container(
                                                                height: 200,
                                                                child: Center(
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
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : (_selectedButton ==
                                                                    1 &&
                                                                Constants
                                                                    .leads_spots1a
                                                                    .isEmpty)
                                                            ? const CustomCard(
                                                                elevation: 6,
                                                                color: Colors
                                                                    .white,
                                                                child: Center(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.only(
                                                                        bottom:
                                                                            12.0),
                                                                    child: Text(
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
                                                                  ),
                                                                ),
                                                              )
                                                            : (_selectedButton ==
                                                                        2 &&
                                                                    Constants
                                                                        .leads_spots2a
                                                                        .isEmpty)
                                                                ? const Center(
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.only(
                                                                          bottom:
                                                                              12.0),
                                                                      child:
                                                                          Text(
                                                                        "No data available for the selected range",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : CustomCard(
                                                                    surfaceTintColor:
                                                                        Colors
                                                                            .white,
                                                                    elevation:
                                                                        6,
                                                                    color: Colors
                                                                        .white,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      side: const BorderSide(
                                                                          color: Colors
                                                                              .white70,
                                                                          width:
                                                                              0),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16),
                                                                    ),
                                                                    child:
                                                                        AspectRatio(
                                                                      aspectRatio:
                                                                          1.66,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                                16),
                                                                        child:
                                                                            LayoutBuilder(
                                                                          builder:
                                                                              (context, constraints) {
                                                                            final double barsSpace = 1.0 *
                                                                                constraints.maxWidth /
                                                                                200;

                                                                            return Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: BarChart(
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
                                                                                              value.toInt().toString(),
                                                                                              style: TextStyle(fontSize: 6.5),
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                      ),
                                                                                      axisNameWidget: Padding(
                                                                                        padding: const EdgeInsets.only(top: 0.0),
                                                                                        child: Text(
                                                                                          'Days of the month',
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
                                                                                        reservedSize: 20,
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
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 8.0,
                                                                left: 10,
                                                                right: 10),
                                                        child: CustomCard(
                                                          elevation: 6,
                                                          color: Colors.white,
                                                          surfaceTintColor:
                                                              Colors.white,
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
                                                                      1.2 *
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
                                                                            BarChartAlignment.center,
                                                                        barTouchData:
                                                                            BarTouchData(enabled: false),
                                                                        gridData:
                                                                            FlGridData(
                                                                          show:
                                                                              true,
                                                                          drawVerticalLine:
                                                                              false,
                                                                          getDrawingHorizontalLine:
                                                                              (value) {
                                                                            return FlLine(
                                                                              color: Colors.grey.withOpacity(0.10),
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
                                                                        titlesData:
                                                                            FlTitlesData(
                                                                          bottomTitles:
                                                                              AxisTitles(
                                                                            sideTitles:
                                                                                SideTitles(
                                                                              showTitles: true,
                                                                              interval: 1,
                                                                              getTitlesWidget: (value, meta) {
                                                                                return Padding(
                                                                                  padding: const EdgeInsets.all(0.0),
                                                                                  child: Text(
                                                                                    getMonthAbbreviation(value.toInt()).toString(),
                                                                                    style: TextStyle(fontSize: 9.5),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                            axisNameWidget:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(top: 0.0),
                                                                              child: Text(
                                                                                'Months of the Year',
                                                                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          topTitles:
                                                                              AxisTitles(
                                                                            sideTitles:
                                                                                SideTitles(
                                                                              showTitles: false,
                                                                              getTitlesWidget: (value, meta) {
                                                                                return Text(value.toInt().toString());
                                                                              },
                                                                            ),
                                                                          ),
                                                                          rightTitles:
                                                                              AxisTitles(
                                                                            sideTitles:
                                                                                SideTitles(
                                                                              showTitles: true,
                                                                              reservedSize: 20,
                                                                              getTitlesWidget: (value, meta) {
                                                                                return Container();
                                                                              },
                                                                            ),
                                                                          ),
                                                                          leftTitles:
                                                                              AxisTitles(
                                                                            sideTitles:
                                                                                SideTitles(
                                                                              showTitles: true,
                                                                              reservedSize: 35,
                                                                              getTitlesWidget: (value, meta) {
                                                                                return Text(
                                                                                  formatLargeNumber4(value.toInt().toString()),
                                                                                  style: TextStyle(fontSize: 7.5),
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        borderData:
                                                                            FlBorderData(show: false),
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
                                                            days_difference <=
                                                                31
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 8.0),
                                                            child: CustomCard(
                                                              surfaceTintColor:
                                                                  Colors.white,
                                                              color:
                                                                  Colors.white,
                                                              elevation: 6,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16)),
                                                              child:
                                                                  AspectRatio(
                                                                aspectRatio:
                                                                    1.66,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              16),
                                                                  child:
                                                                      LayoutBuilder(
                                                                    builder:
                                                                        (context,
                                                                            constraints) {
                                                                      final double
                                                                          barsSpace =
                                                                          1.0 *
                                                                              constraints.maxWidth /
                                                                              200;

                                                                      return Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            BarChart(
                                                                          BarChartData(
                                                                            alignment:
                                                                                BarChartAlignment.center,
                                                                            barTouchData:
                                                                                BarTouchData(enabled: false),
                                                                            gridData:
                                                                                FlGridData(
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
                                                                            titlesData:
                                                                                FlTitlesData(
                                                                              bottomTitles: AxisTitles(
                                                                                sideTitles: SideTitles(
                                                                                  showTitles: true,
                                                                                  interval: 1,
                                                                                  getTitlesWidget: (value, meta) {
                                                                                    return Padding(
                                                                                      padding: const EdgeInsets.all(0.0),
                                                                                      child: Text(
                                                                                        value.toInt().toString(),
                                                                                        style: TextStyle(fontSize: 6.5),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                ),
                                                                                axisNameWidget: Padding(
                                                                                  padding: const EdgeInsets.only(top: 0.0),
                                                                                  child: Text(
                                                                                    'Days of the month',
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
                                                                                  reservedSize: 20,
                                                                                  getTitlesWidget: (value, meta) {
                                                                                    return Container();
                                                                                  },
                                                                                ),
                                                                              ),
                                                                              leftTitles: AxisTitles(
                                                                                sideTitles: SideTitles(
                                                                                  showTitles: true,
                                                                                  reservedSize: 35,
                                                                                  getTitlesWidget: (value, meta) {
                                                                                    return Text(
                                                                                      formatLargeNumber4(value.toInt().toString()),
                                                                                      style: TextStyle(fontSize: 7.5),
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            borderData:
                                                                                FlBorderData(show: false),
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
                                                        : _selectedButton ==
                                                                    3 &&
                                                                days_difference >
                                                                    31
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            8.0),
                                                                child:
                                                                    CustomCard(
                                                                  surfaceTintColor:
                                                                      Colors
                                                                          .white,
                                                                  color: Colors
                                                                      .white,
                                                                  elevation: 6,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16)),
                                                                  child:
                                                                      AspectRatio(
                                                                    aspectRatio:
                                                                        1.66,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              16),
                                                                      child:
                                                                          LayoutBuilder(
                                                                        builder:
                                                                            (context,
                                                                                constraints) {
                                                                          final double barsSpace = 1.0 *
                                                                              constraints.maxWidth /
                                                                              200;

                                                                          return Column(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: BarChart(
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
                                                                                            reservedSize: 20,
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
                                                    left: 8.0,
                                                    right: 8,
                                                    top: 8),
                                                child: CustomCard(
                                                    elevation: 5,
                                                    surfaceTintColor:
                                                        Colors.white,
                                                    color: Colors.white,
                                                    child: Center(
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
                                                            strokeWidth: 1.8,
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                              )),
                                  ),
                                  SizedBox(height: 16),
                                  if (collections_grid_index == 0)
                                    _selectedButton == 1
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                              left: 16.0,
                                              top: 16,
                                              right: 16,
                                            ),
                                            child: Text(
                                                "Top 10 Agents (MTD- ${getMonthAbbreviation(DateTime.now().month)})"),
                                          )
                                        : _selectedButton == 2
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  top: 16,
                                                  right: 16,
                                                ),
                                                child: Text(
                                                    "Top 10 Agents (12 Months View)"),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  top: 16,
                                                  right: 16,
                                                ),
                                                child: Text(
                                                    "Top 10 Agents (${formattedStartDate} to ${formattedEndDate})"),
                                              ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 16, top: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.10),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.10),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Center(
                                              child: Row(
                                                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      _animateButton2(0);
                                                    },
                                                    child: Container(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2) -
                                                          16,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      350)),
                                                      height: 35,
                                                      child: Center(
                                                        child: Text(
                                                          'Quoted',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      _animateButton2(1);
                                                      Future.delayed(Duration(
                                                              seconds: 1))
                                                          .then((value) {
                                                        setState(() {});
                                                      });
                                                    },
                                                    child: Container(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2) -
                                                          16,
                                                      height: 35,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      350)),
                                                      child: Center(
                                                        child: Text(
                                                          'Accepted',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
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
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.easeInOut,
                                            left: _sliderPosition2,
                                            child: InkWell(
                                              onTap: () {
                                                // _animateButton2(3);
                                              },
                                              child: Container(
                                                  width: (MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2) -
                                                      16,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    color: Constants
                                                        .ctaColorLight, // Color of the slider
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: target_index == 0
                                                      ? Center(
                                                          child: Text(
                                                            'Quoted',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                      : target_index == 1
                                                          ? Center(
                                                              child: Text(
                                                                'Accepted',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
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
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        elevation: 6,
                                        surfaceTintColor: Colors.white,
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Container(
                                            child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(0.35),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          36)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 28,
                                                      height: 28,
                                                      decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      350)),
                                                      child: Center(
                                                        child: Text(
                                                          "#",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
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
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 0.0),
                                                          child: Text(
                                                              "Agent Name"),
                                                        )),
                                                    Expanded(
                                                      flex: 4,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 4.0),
                                                        child: Text(
                                                          "Qoutes",
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 4,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 4.0),
                                                        child: Text(
                                                          "Amount",
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, right: 8),
                                              child:
                                                  isLoadingMarketingData == true
                                                      ? Center(
                                                          child: Center(
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
                                                        ))
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8,
                                                                  right: 12,
                                                                  top: 12),
                                                          child: ListView
                                                              .builder(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              0,
                                                                          bottom:
                                                                              16),
                                                                  itemCount: topquotesbyagent
                                                                              .length >
                                                                          10
                                                                      ? 10
                                                                      : topquotesbyagent
                                                                          .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  physics:
                                                                      NeverScrollableScrollPhysics(),
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int index) {
                                                                    return Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              8.0),
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Container(
                                                                                  width: 30,
                                                                                  child: Text("${index + 1} "),
                                                                                ),
                                                                                Expanded(flex: 10, child: Text("${topquotesbyagent[index].agent_name.trimLeft()}")),
                                                                                Expanded(
                                                                                  flex: 4,
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: Container(
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.only(
                                                                                              right: 5,
                                                                                            ),
                                                                                            child: Center(
                                                                                              child: Text(
                                                                                                "${formatLargeNumber2(topquotesbyagent[index].sales.toStringAsFixed(0))}",
                                                                                                style: TextStyle(fontSize: 13),
                                                                                                textAlign: TextAlign.left,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  flex: 4,
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: Container(
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.only(
                                                                                              left: 12,
                                                                                            ),
                                                                                            child: Text(
                                                                                              "R${formatLargeNumber2(topquotesbyagent[index].amount.toStringAsFixed(0))}",
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
                                                                              padding: const EdgeInsets.only(top: 8.0),
                                                                              child: Container(
                                                                                height: 1,
                                                                                color: Colors.grey.withOpacity(0.10),
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
                                  if (target_index == 1)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        elevation: 6,
                                        surfaceTintColor: Colors.white,
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Container(
                                            child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(0.35),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          36)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 28,
                                                      height: 28,
                                                      decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      350)),
                                                      child: Center(
                                                        child: Text(
                                                          "#",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
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
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 0.0),
                                                          child: Text(
                                                              "Agent Name"),
                                                        )),
                                                    Expanded(
                                                      flex: 4,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 4.0),
                                                        child: Text(
                                                          "Qoutes",
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 4,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 4.0),
                                                        child: Text(
                                                          "Amount",
                                                          textAlign:
                                                              TextAlign.left,
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
                                              child:
                                                  isLoadingMarketingData == true
                                                      ? Center(
                                                          child: Center(
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
                                                        ))
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8,
                                                                  right: 12,
                                                                  top: 12),
                                                          child: ListView
                                                              .builder(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              0,
                                                                          bottom:
                                                                              16),
                                                                  itemCount: topquotesbyagent1
                                                                              .length >
                                                                          10
                                                                      ? 10
                                                                      : topquotesbyagent1
                                                                          .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  physics:
                                                                      NeverScrollableScrollPhysics(),
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int index) {
                                                                    return Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              8.0),
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Container(
                                                                                  width: 30,
                                                                                  child: Text("${index + 1} "),
                                                                                ),
                                                                                Expanded(flex: 10, child: Text("${topquotesbyagent1[index].agent_name.trimLeft()}")),
                                                                                Expanded(
                                                                                  flex: 4,
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: Container(
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.only(
                                                                                              right: 5,
                                                                                            ),
                                                                                            child: Center(
                                                                                              child: Text(
                                                                                                "${formatLargeNumber2(topquotesbyagent1[index].sales.toStringAsFixed(0))}",
                                                                                                style: TextStyle(fontSize: 13),
                                                                                                textAlign: TextAlign.left,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  flex: 4,
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: Container(
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.only(
                                                                                              left: 12,
                                                                                            ),
                                                                                            child: Text(
                                                                                              "R${formatLargeNumber2(topquotesbyagent1[index].amount.toStringAsFixed(0))}",
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
                                                                              padding: const EdgeInsets.only(top: 8.0),
                                                                              child: Container(
                                                                                height: 1,
                                                                                color: Colors.grey.withOpacity(0.10),
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
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _selectedButton == 1
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              left: 0.0, bottom: 0),
                                          child: Center(
                                              child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0,
                                                          right: 16,
                                                          bottom: 8),
                                                  child: Text(
                                                      "Member And Quote Age Analysis (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                                ),
                                              )
                                            ],
                                          )),
                                        )
                                      : _selectedButton == 2
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  left: 0.0, bottom: 0),
                                              child: Center(
                                                  child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16.0,
                                                              right: 16,
                                                              bottom: 8),
                                                      child: Text(
                                                          "Member And Quote Age Analysis (12 Months View)"),
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16.0,
                                                              right: 16,
                                                              bottom: 8),
                                                      child: Text(
                                                          "Member And Quote Age Analysis (${formattedStartDate} to ${formattedEndDate})"),
                                                    ),
                                                  )
                                                ],
                                              )),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 16),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.10),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.10),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Center(
                                              child: Row(
                                                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      _animateButton9(0);
                                                    },
                                                    child: Container(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2) -
                                                          16,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      350)),
                                                      height: 35,
                                                      child: Center(
                                                        child: Text(
                                                          'Member Type',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      _animateButton9(1);
                                                    },
                                                    child: Container(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2) -
                                                          16,
                                                      height: 35,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      350)),
                                                      child: Center(
                                                        child: Text(
                                                          'Quote Age Analysis',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
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
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.easeInOut,
                                            left: _sliderPosition9,
                                            child: InkWell(
                                              onTap: () {
                                                // _animateButton2(3);
                                              },
                                              child: Container(
                                                  width: (MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2) -
                                                      16,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    color: Constants
                                                        .ctaColorLight, // Color of the slider
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: target_index_9 == 0
                                                      ? Center(
                                                          child: Text(
                                                            'Member Type',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                      : target_index_9 == 1
                                                          ? Center(
                                                              child: Text(
                                                                'Quote Age Analysis',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )
                                                          : Container()),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (target_index_9 == 0)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 14.0,
                                          top: 12,
                                          bottom: 14,
                                          right: 16),
                                      child: CustomCard(
                                        surfaceTintColor: Colors.white,
                                        elevation: 6,
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.white70, width: 0),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 6.0, top: 4),
                                          child: GridView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    childAspectRatio:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                2.1)),
                                            itemCount: sectionsList2.length,
                                            padding: EdgeInsets.all(2.0),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return InkWell(
                                                  onTap: () {
                                                    restartInactivityTimer();
                                                  },
                                                  child: Container(
                                                    height: 320,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.3,
                                                    child: Stack(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            restartInactivityTimer();
                                                            collections_index =
                                                                index;
                                                            setState(() {});
                                                            if (kDebugMode) {
                                                              print("collections_index " +
                                                                  index
                                                                      .toString());
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
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 4.0,
                                                                    right: 8),
                                                            child: Card(
                                                              elevation: 6,
                                                              surfaceTintColor:
                                                                  Colors.white,
                                                              color:
                                                                  Colors.white,
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
                                                                  decoration: BoxDecoration(
                                                                      border: Border(
                                                                          bottom: BorderSide(
                                                                              color: Constants.ctaColorLight,
                                                                              width: 6))),
                                                                  child: isLoadingMarketingData ==
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
                                                                            Expanded(
                                                                              child: Container(
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
                                                                                            padding: const EdgeInsets.only(top: 10.0),
                                                                                            child: Text(
                                                                                              formatLargeNumber(sectionsList2[index].count.toString()),
                                                                                              style: TextStyle(fontSize: 19.5, fontWeight: FontWeight.w500),
                                                                                              textAlign: TextAlign.center,
                                                                                              maxLines: 2,
                                                                                            ),
                                                                                          )),
                                                                                        ),
                                                                                        Center(
                                                                                            child: Padding(
                                                                                          padding: const EdgeInsets.all(6.0),
                                                                                          child: Text(
                                                                                            sectionsList2[index].id,
                                                                                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500),
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
                                  if (target_index_9 == 1)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 14.0,
                                          top: 12,
                                          bottom: 14,
                                          right: 16),
                                      child: CustomCard(
                                        surfaceTintColor: Colors.white,
                                        elevation: 6,
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.white70, width: 0),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 6.0, top: 4),
                                          child: GridView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    childAspectRatio:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                2.1)),
                                            itemCount: sectionsList3.length,
                                            padding: EdgeInsets.all(2.0),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return InkWell(
                                                  onTap: () {
                                                    restartInactivityTimer();
                                                  },
                                                  child: Container(
                                                    height: 320,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.9,
                                                    child: Stack(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            restartInactivityTimer();
                                                            //collections_index = index;
                                                            setState(() {});
                                                            if (kDebugMode) {
                                                              print("target_index_9 " +
                                                                  index
                                                                      .toString());
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
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 4.0,
                                                                    right: 8),
                                                            child: Card(
                                                              elevation: 6,
                                                              surfaceTintColor:
                                                                  Colors.white,
                                                              color:
                                                                  Colors.white,
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
                                                                  decoration: BoxDecoration(
                                                                      border: Border(
                                                                          bottom: BorderSide(
                                                                              color: Constants.ctaColorLight,
                                                                              width: 6))),
                                                                  child: isLoadingMarketingData ==
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
                                                                            Expanded(
                                                                              child: Container(
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
                                                                                      borderRadius: BorderRadius.circular(14),
                                                                                    ),
                                                                                    width: MediaQuery.of(context).size.width,
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
                                                                                              formatLargeNumber(sectionsList3[index].count.toString()),
                                                                                              style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.w500),
                                                                                              textAlign: TextAlign.center,
                                                                                              maxLines: 2,
                                                                                            ),
                                                                                          )),
                                                                                        ),
                                                                                        Center(
                                                                                            child: Padding(
                                                                                          padding: const EdgeInsets.all(6.0),
                                                                                          child: Text(
                                                                                            sectionsList3[index].id,
                                                                                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500),
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
                                  SizedBox(
                                    height: 24,
                                  ),
                                  _selectedButton == 1
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              left: 0.0, bottom: 0),
                                          child: Center(
                                              child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0,
                                                          right: 16,
                                                          bottom: 4),
                                                  child: Text(
                                                      "Product Mix (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                                ),
                                              )
                                            ],
                                          )),
                                        )
                                      : _selectedButton == 2
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  left: 0.0, bottom: 0),
                                              child: Center(
                                                  child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16.0,
                                                              right: 16,
                                                              bottom: 4),
                                                      child: Text(
                                                          "Product Mix(12 Months View)"),
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16.0,
                                                              right: 16,
                                                              bottom: 4),
                                                      child: Text(
                                                          "Product Mix (${formattedStartDate} to ${formattedEndDate})"),
                                                    ),
                                                  )
                                                ],
                                              )),
                                  _selectedButton == 1
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 14.0, left: 14, right: 14),
                                          child: Container(
                                            height: 700,
                                            key: Constants.marketing_tree_key1a,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: CustomCard(
                                              elevation: 6,
                                              surfaceTintColor: Colors.white,
                                              color: Colors.white,
                                              child: Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
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
                                                      .marketing_tree_key2a,
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
                                                        .marketing_tree_key3a,
                                                    height: 500,
                                                    width:
                                                        MediaQuery.of(context)
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
                                                        .collections_tree_key3a,
                                                    height: 500,
                                                    width:
                                                        MediaQuery.of(context)
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
                                                  )),
                                  SizedBox(height: 24),
                                  _selectedButton == 1
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0, top: 8),
                                          child: Text(
                                              "Top 10 Clients, (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                        )
                                      : _selectedButton == 2
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0, top: 8),
                                              child: Text(
                                                  "Top 10 Clients (12 Months View)"),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0, top: 8),
                                              child: Text(
                                                  "Top 10 Clients (${formattedStartDate} to ${formattedEndDate})"),
                                            ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      elevation: 6,
                                      surfaceTintColor: Colors.white,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Container(
                                          child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.35),
                                                borderRadius:
                                                    BorderRadius.circular(36)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 28,
                                                    height: 28,
                                                    decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(350)),
                                                    child: Center(
                                                      child: Text(
                                                        "#",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
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
                                                            const EdgeInsets
                                                                .only(
                                                                left: 0.0),
                                                        child:
                                                            Text("Client Name"),
                                                      )),
                                                  Expanded(
                                                    flex: 4,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4.0),
                                                      child: Text(
                                                        "Amount",
                                                        textAlign:
                                                            TextAlign.left,
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
                                            child: isLoadingMarketingData ==
                                                    true
                                                ? Center(
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
                                                  ))
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8,
                                                            right: 12,
                                                            top: 12),
                                                    child: ListView.builder(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 0,
                                                                bottom: 16),
                                                        itemCount: topquotesbyclient
                                                                    .length >
                                                                10
                                                            ? 10
                                                            : topquotesbyclient
                                                                .length,
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 8.0),
                                                            child: Container(
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            30,
                                                                        child: Text(
                                                                            "${index + 1} "),
                                                                      ),
                                                                      Expanded(
                                                                          flex:
                                                                              10,
                                                                          child:
                                                                              Text("${topquotesbyclient[index].client_name.trimLeft()}")),
                                                                      Expanded(
                                                                        flex: 4,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Container(
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(
                                                                                    left: 8,
                                                                                  ),
                                                                                  child: Text(
                                                                                    "R${formatLargeNumber2(topquotesbyclient[index].amount.toStringAsFixed(0))}",
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
                                                          );
                                                        }),
                                                  ),
                                          ),
                                        ],
                                      )),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                ],
                              ),
                            if (_marketing_main_sliderPosition_index_2 == 2)
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 125,
                                            child: InkWell(
                                                onTap: () {
                                                  restartInactivityTimer();
                                                },
                                                child: Container(
                                                  height: 125,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.9,
                                                  child: Stack(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {},
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 4.0,
                                                                  right: 8),
                                                          child: Card(
                                                            surfaceTintColor:
                                                                Colors.white,
                                                            elevation: 6,
                                                            color: Colors.white,
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
                                                                          BorderRadius.circular(
                                                                              16))),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                            color:
                                                                                Constants.ctaColorLight,
                                                                            width: 6))),
                                                                child: Column(
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
                                                                            child: isLoadingMarketingData == true
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
                                                                                            "R" + formatLargeNumber3(sectionsList[0].amount.toString()),
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
                                                                                          formatLargeNumber2(sectionsList[0].count.toString()),
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
                                            height: 125,
                                            child: InkWell(
                                                onTap: () {
                                                  restartInactivityTimer();
                                                },
                                                child: Container(
                                                  height: 125,
                                                  width: MediaQuery.of(context)
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
                                                                  bottom: 4.0,
                                                                  right: 8),
                                                          child: Card(
                                                            surfaceTintColor:
                                                                Colors.white,
                                                            elevation: 6,
                                                            color: Colors.white,
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
                                                                          BorderRadius.circular(
                                                                              16))),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                            color:
                                                                                Constants.ctaColorLight,
                                                                            width: 6))),
                                                                child:
                                                                    isLoadingMarketingData ==
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
                                                                                                "R" + formatLargeNumber3(sectionsList[1].amount.toString()),
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
                                                                                              formatLargeNumber2(sectionsList[1].count.toString()),
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
                                            height: 125,
                                            child: InkWell(
                                                onTap: () {
                                                  restartInactivityTimer();
                                                },
                                                child: Container(
                                                  height: 125,
                                                  width: MediaQuery.of(context)
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
                                                                          BorderRadius.circular(
                                                                              16))),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                            color:
                                                                                Constants.ctaColorLight,
                                                                            width: 6))),
                                                                child:
                                                                    isLoadingMarketingData ==
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
                                                                                                "R" + formatLargeNumber3(sectionsList[2].amount.toString()),
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
                                                                                              formatLargeNumber2(sectionsList[2].count.toString()),
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
                                        SizedBox(
                                          width: 8,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 24,
                                    ),
                                    _selectedButton == 1
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                left: 0.0, bottom: 0),
                                            child: Center(
                                                child: Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20.0,
                                                            right: 16,
                                                            bottom: 8),
                                                    child: Text(
                                                        "Quote Acceptance Rate (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                                  ),
                                                )
                                              ],
                                            )),
                                          )
                                        : _selectedButton == 2
                                            ? Row(
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20.0,
                                                              right: 16,
                                                              bottom: 8),
                                                      child: Text(
                                                          "Quote Acceptance Rate (12 Months View)"),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0.0, bottom: 12),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 20.0,
                                                                right: 16,
                                                                bottom: 8),
                                                        child: Text(
                                                            "Quote Acceptance Rate (${formattedStartDate} to ${formattedEndDate})"),
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
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: LinearPercentIndicator(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                14,
                                        animation: true,
                                        lineHeight: 20.0,
                                        animationDuration: 500,
                                        percent: variance_percentage,
                                        center: Text(
                                            "${(actual_variance_percentage * 100).toStringAsFixed(0)}%",
                                            style: TextStyle(
                                              color:
                                                  actual_variance_percentage <
                                                          0.4
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
                                    SizedBox(height: 24),
                                    _selectedButton == 1
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: Text(
                                                "Quotation Overview (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                          )
                                        : _selectedButton == 2
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20.0),
                                                child: Text(
                                                    "Quotation Overview (12 Months View)"),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20.0),
                                                child: Text(
                                                    "Quotation Overview (${formattedStartDate} to ${formattedEndDate})"),
                                              ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4, right: 4.0),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.grey
                                                  .withOpacity(0.00)),
                                          height: 250,
                                          child: isLoadingMarketingData == false
                                              ? _selectedButton == 1
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              top: 8.0,
                                                              right: 10),
                                                      child: CustomCard(
                                                        surfaceTintColor:
                                                            Colors.white,
                                                        elevation: 6,
                                                        color: Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side: BorderSide(
                                                              color: Colors
                                                                  .white70,
                                                              width: 0),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                        ),
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
                                                                                20,
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
                                                                                35,
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
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 8.0,
                                                                  left: 10,
                                                                  right: 10),
                                                          child: CustomCard(
                                                            elevation: 6,
                                                            color: Colors.white,
                                                            surfaceTintColor:
                                                                Colors.white,
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
                                                                        1.2 *
                                                                            constraints.maxWidth /
                                                                            200;

                                                                    return Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                          BarChart(
                                                                        BarChartData(
                                                                          alignment:
                                                                              BarChartAlignment.center,
                                                                          barTouchData:
                                                                              BarTouchData(enabled: false),
                                                                          gridData:
                                                                              FlGridData(
                                                                            show:
                                                                                true,
                                                                            drawVerticalLine:
                                                                                false,
                                                                            getDrawingHorizontalLine:
                                                                                (value) {
                                                                              return FlLine(
                                                                                color: Colors.grey.withOpacity(0.10),
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
                                                                          titlesData:
                                                                              FlTitlesData(
                                                                            bottomTitles:
                                                                                AxisTitles(
                                                                              sideTitles: SideTitles(
                                                                                showTitles: true,
                                                                                interval: 1,
                                                                                getTitlesWidget: (value, meta) {
                                                                                  return Padding(
                                                                                    padding: const EdgeInsets.all(0.0),
                                                                                    child: Text(
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
                                                                            topTitles:
                                                                                AxisTitles(
                                                                              sideTitles: SideTitles(
                                                                                showTitles: false,
                                                                                getTitlesWidget: (value, meta) {
                                                                                  return Text(value.toInt().toString());
                                                                                },
                                                                              ),
                                                                            ),
                                                                            rightTitles:
                                                                                AxisTitles(
                                                                              sideTitles: SideTitles(
                                                                                showTitles: true,
                                                                                reservedSize: 20,
                                                                                getTitlesWidget: (value, meta) {
                                                                                  return Container();
                                                                                },
                                                                              ),
                                                                            ),
                                                                            leftTitles:
                                                                                AxisTitles(
                                                                              sideTitles: SideTitles(
                                                                                showTitles: true,
                                                                                reservedSize: 35,
                                                                                getTitlesWidget: (value, meta) {
                                                                                  return Text(
                                                                                    formatLargeNumber4(value.toInt().toString()),
                                                                                    style: TextStyle(fontSize: 7.5),
                                                                                  );
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          borderData:
                                                                              FlBorderData(show: false),
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
                                                              days_difference <=
                                                                  31
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 8.0,
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              child: CustomCard(
                                                                color: Colors
                                                                    .white,
                                                                surfaceTintColor:
                                                                    Colors
                                                                        .white,
                                                                elevation: 6,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16)),
                                                                child:
                                                                    AspectRatio(
                                                                  aspectRatio:
                                                                      1.66,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            16),
                                                                    child:
                                                                        LayoutBuilder(
                                                                      builder:
                                                                          (context,
                                                                              constraints) {
                                                                        final double
                                                                            barsSpace =
                                                                            1.0 *
                                                                                constraints.maxWidth /
                                                                                200;

                                                                        return Padding(
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
                                                                                          value.toInt().toString(),
                                                                                          style: TextStyle(fontSize: 6.5),
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                  axisNameWidget: Padding(
                                                                                    padding: const EdgeInsets.only(top: 0.0),
                                                                                    child: Text(
                                                                                      'Days of the month',
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
                                                                                    reservedSize: 20,
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
                                                                              barGroups: barChartData3,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : _selectedButton ==
                                                                      3 &&
                                                                  days_difference >
                                                                      31
                                                              ? Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              8.0),
                                                                  child: Card(
                                                                    surfaceTintColor:
                                                                        Colors
                                                                            .white,
                                                                    color: Colors
                                                                        .white,
                                                                    elevation:
                                                                        6,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(16)),
                                                                    child:
                                                                        AspectRatio(
                                                                      aspectRatio:
                                                                          1.66,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                                16),
                                                                        child:
                                                                            LayoutBuilder(
                                                                          builder:
                                                                              (context, constraints) {
                                                                            final double barsSpace = 1.0 *
                                                                                constraints.maxWidth /
                                                                                200;

                                                                            return Column(
                                                                              children: [
                                                                                Expanded(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: BarChart(
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
                                                                                              reservedSize: 20,
                                                                                              getTitlesWidget: (value, meta) {
                                                                                                return Container();
                                                                                              },
                                                                                            ),
                                                                                          ),
                                                                                          leftTitles: AxisTitles(
                                                                                            sideTitles: SideTitles(
                                                                                              showTitles: true,
                                                                                              reservedSize: 35,
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8,
                                                          top: 8),
                                                  child: CustomCard(
                                                      elevation: 5,
                                                      surfaceTintColor:
                                                          Colors.white,
                                                      color: Colors.white,
                                                      child: Center(
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
                                                              strokeWidth: 1.8,
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                )),
                                    ),
                                    SizedBox(height: 16),
                                    _selectedButton == 1
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                              left: 16.0,
                                              top: 16,
                                              right: 16,
                                            ),
                                            child: Text(
                                                "Top 10 Agents (MTD- ${getMonthAbbreviation(DateTime.now().month)})"),
                                          )
                                        : _selectedButton == 2
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  top: 16,
                                                  right: 16,
                                                ),
                                                child: Text(
                                                    "Top 10 Agents (12 Months View)"),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  top: 16,
                                                  right: 16,
                                                ),
                                                child: Text(
                                                    "Top 10 Agents (${formattedStartDate} to ${formattedEndDate})"),
                                              ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16, top: 8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.grey.withOpacity(0.10),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(0.10),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Center(
                                                child: Row(
                                                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        _animateButton2(0);
                                                      },
                                                      child: Container(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2) -
                                                            16,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        350)),
                                                        height: 35,
                                                        child: Center(
                                                          child: Text(
                                                            'Quoted',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        _animateButton2(1);
                                                        Future.delayed(Duration(
                                                                seconds: 1))
                                                            .then((value) {
                                                          setState(() {});
                                                        });
                                                      },
                                                      child: Container(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2) -
                                                            16,
                                                        height: 35,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        350)),
                                                        child: Center(
                                                          child: Text(
                                                            'Accepted',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
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
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                              left: _sliderPosition2,
                                              child: InkWell(
                                                onTap: () {
                                                  // _animateButton2(3);
                                                },
                                                child: Container(
                                                    width:
                                                        (MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                2) -
                                                            16,
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                      color: Constants
                                                          .ctaColorLight, // Color of the slider
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: target_index == 0
                                                        ? Center(
                                                            child: Text(
                                                              'Quoted',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          )
                                                        : target_index == 1
                                                            ? Center(
                                                                child: Text(
                                                                  'Accepted',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
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
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          elevation: 6,
                                          surfaceTintColor: Colors.white,
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Container(
                                              child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey
                                                        .withOpacity(0.35),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            36)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 28,
                                                        height: 28,
                                                        decoration: BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        350)),
                                                        child: Center(
                                                          child: Text(
                                                            "#",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
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
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 0.0),
                                                            child: Text(
                                                                "Agent Name"),
                                                          )),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 4.0),
                                                          child: Text(
                                                            "Qoutes",
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 4.0),
                                                          child: Text(
                                                            "Amount",
                                                            textAlign:
                                                                TextAlign.left,
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
                                                child:
                                                    isLoadingMarketingData ==
                                                            true
                                                        ? Center(
                                                            child: Center(
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
                                                          ))
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 8,
                                                                    right: 12,
                                                                    top: 12),
                                                            child: ListView
                                                                .builder(
                                                                    padding: EdgeInsets.only(
                                                                        top: 0,
                                                                        bottom:
                                                                            16),
                                                                    itemCount: topquotesbyagent.length >
                                                                            10
                                                                        ? 10
                                                                        : topquotesbyagent
                                                                            .length,
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        NeverScrollableScrollPhysics(),
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                                8.0),
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Container(
                                                                                    width: 35,
                                                                                    child: Text("${index + 1} "),
                                                                                  ),
                                                                                  Expanded(flex: 10, child: Text("${topquotesbyagent[index].agent_name.trimLeft()}")),
                                                                                  Expanded(
                                                                                    flex: 4,
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: Container(
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(
                                                                                                left: 8,
                                                                                              ),
                                                                                              child: Text(
                                                                                                "R${formatLargeNumber2(topquotesbyagent[index].sales.toStringAsFixed(0))}",
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
                                                                                padding: const EdgeInsets.only(top: 8.0),
                                                                                child: Container(
                                                                                  height: 1,
                                                                                  color: Colors.grey.withOpacity(0.10),
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
                                    if (target_index == 1)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          elevation: 6,
                                          surfaceTintColor: Colors.white,
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Container(
                                              child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey
                                                        .withOpacity(0.35),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            36)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 28,
                                                        height: 28,
                                                        decoration: BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        350)),
                                                        child: Center(
                                                          child: Text(
                                                            "#",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
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
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 0.0),
                                                            child: Text(
                                                                "Agent Name"),
                                                          )),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 4.0),
                                                          child: Text(
                                                            "Qoutes",
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 4.0),
                                                          child: Text(
                                                            "Amount",
                                                            textAlign:
                                                                TextAlign.left,
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
                                                child:
                                                    isLoadingMarketingData ==
                                                            true
                                                        ? Center(
                                                            child: Center(
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
                                                          ))
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 8,
                                                                    right: 12,
                                                                    top: 12),
                                                            child: ListView
                                                                .builder(
                                                                    padding: EdgeInsets.only(
                                                                        top: 0,
                                                                        bottom:
                                                                            16),
                                                                    itemCount: topquotesbyagent1.length >
                                                                            10
                                                                        ? 10
                                                                        : topquotesbyagent1
                                                                            .length,
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        NeverScrollableScrollPhysics(),
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                                8.0),
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Container(
                                                                                    width: 35,
                                                                                    child: Text("${index + 1} "),
                                                                                  ),
                                                                                  Expanded(flex: 10, child: Text("${topquotesbyagent1[index].agent_name.trimLeft()}")),
                                                                                  Expanded(
                                                                                    flex: 4,
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: Container(
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(
                                                                                                left: 8,
                                                                                              ),
                                                                                              child: Text(
                                                                                                "R${formatLargeNumber2(topquotesbyagent1[index].sales.toStringAsFixed(0))}",
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
                                                                                padding: const EdgeInsets.only(top: 8.0),
                                                                                child: Container(
                                                                                  height: 1,
                                                                                  color: Colors.grey.withOpacity(0.10),
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
                                              left: 16.0,
                                              top: 16,
                                              right: 16,
                                            ),
                                            child: Text(
                                                "Top 10 Agents (MTD- ${getMonthAbbreviation(DateTime.now().month)})"),
                                          )
                                        : _selectedButton == 2
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  top: 24,
                                                  right: 16,
                                                ),
                                                child: Text(
                                                    "Top 10 Agents (12 Months View)"),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  top: 24,
                                                  right: 16,
                                                ),
                                                child: Text(
                                                    "Top 10 Agents (${formattedStartDate} to ${formattedEndDate})"),
                                              ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16, top: 8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.grey.withOpacity(0.10),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(0.10),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Center(
                                                child: Row(
                                                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        _animateButton2(0);
                                                      },
                                                      child: Container(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2) -
                                                            16,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        350)),
                                                        height: 35,
                                                        child: Center(
                                                          child: Text(
                                                            'Top 10 Agents',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        _animateButton2(1);
                                                        Future.delayed(Duration(
                                                                seconds: 1))
                                                            .then((value) {
                                                          setState(() {});
                                                        });
                                                      },
                                                      child: Container(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2) -
                                                            16,
                                                        height: 35,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        350)),
                                                        child: Center(
                                                          child: Text(
                                                            'Bottom 10 Sales Agents',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
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
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                              left: _sliderPosition2,
                                              child: InkWell(
                                                onTap: () {
                                                  // _animateButton2(3);
                                                },
                                                child: Container(
                                                    width:
                                                        (MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                2) -
                                                            16,
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                      color: Constants
                                                          .ctaColorLight, // Color of the slider
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: target_index == 0
                                                        ? Center(
                                                            child: Text(
                                                              'Top 10 Agentss',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          )
                                                        : target_index == 1
                                                            ? Center(
                                                                child: Text(
                                                                  'Bottom 10 Sales Agents',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
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
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          elevation: 6,
                                          surfaceTintColor: Colors.white,
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Container(
                                              child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey
                                                        .withOpacity(0.35),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            36)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 28,
                                                        height: 28,
                                                        decoration: BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        350)),
                                                        child: Center(
                                                          child: Text(
                                                            "#",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
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
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 0.0),
                                                            child: Text(
                                                                "Agent Name"),
                                                          )),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 4.0),
                                                          child: Text(
                                                            "Qoutes",
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 4.0),
                                                          child: Text(
                                                            "Amount",
                                                            textAlign:
                                                                TextAlign.left,
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
                                                child:
                                                    isLoadingMarketingData ==
                                                            true
                                                        ? Center(
                                                            child: Center(
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
                                                          ))
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 8,
                                                                    right: 12,
                                                                    top: 12),
                                                            child: ListView
                                                                .builder(
                                                                    padding: EdgeInsets.only(
                                                                        top: 0,
                                                                        bottom:
                                                                            16),
                                                                    itemCount: min(
                                                                        10,
                                                                        topquotesbyagent
                                                                            .length),
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        NeverScrollableScrollPhysics(),
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                                8.0),
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Container(
                                                                                    width: 35,
                                                                                    child: Text("${index + 1} "),
                                                                                  ),
                                                                                  Expanded(flex: 10, child: Text("${topquotesbyagent[index].agent_name.trimLeft()}")),
                                                                                  Expanded(
                                                                                    flex: 4,
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: Container(
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(
                                                                                                left: 8,
                                                                                              ),
                                                                                              child: Text(
                                                                                                "R${formatLargeNumber2(topquotesbyagent[index].sales.toStringAsFixed(0))}",
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
                                                                                padding: const EdgeInsets.only(top: 8.0),
                                                                                child: Container(
                                                                                  height: 1,
                                                                                  color: Colors.grey.withOpacity(0.10),
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
                                    if (target_index == 1)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          elevation: 6,
                                          surfaceTintColor: Colors.white,
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Container(
                                              child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey
                                                        .withOpacity(0.35),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            36)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 28,
                                                        height: 28,
                                                        decoration: BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        350)),
                                                        child: Center(
                                                          child: Text(
                                                            "#",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
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
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 0.0),
                                                            child: Text(
                                                                "Agent Name"),
                                                          )),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 4.0),
                                                          child: Text(
                                                            "Qoutes",
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 4.0),
                                                          child: Text(
                                                            "Amount",
                                                            textAlign:
                                                                TextAlign.left,
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
                                                child:
                                                    isLoadingMarketingData ==
                                                            true
                                                        ? Center(
                                                            child: Center(
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
                                                          ))
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 8,
                                                                    right: 12,
                                                                    top: 12),
                                                            child: ListView
                                                                .builder(
                                                                    padding: EdgeInsets.only(
                                                                        top: 0,
                                                                        bottom:
                                                                            16),
                                                                    itemCount: min(
                                                                        10,
                                                                        topquotesbyagent1
                                                                            .length),
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        NeverScrollableScrollPhysics(),
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                                8.0),
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Container(
                                                                                    width: 35,
                                                                                    child: Text("${index + 1} "),
                                                                                  ),
                                                                                  Expanded(flex: 10, child: Text("${topquotesbyagent1[index].agent_name.trimLeft()}")),
                                                                                  Expanded(
                                                                                    flex: 4,
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: Container(
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(
                                                                                                left: 8,
                                                                                              ),
                                                                                              child: Text(
                                                                                                "R${formatLargeNumber2(topquotesbyagent1[index].sales.toStringAsFixed(0))}",
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
                                                                                padding: const EdgeInsets.only(top: 8.0),
                                                                                child: Container(
                                                                                  height: 1,
                                                                                  color: Colors.grey.withOpacity(0.10),
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
                                  ]),
                            if (_marketing_main_sliderPosition_index_2 == 0)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 125,
                                          child: InkWell(
                                              onTap: () {
                                                restartInactivityTimer();
                                              },
                                              child: Container(
                                                height: 125,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.9,
                                                child: Stack(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {},
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 4.0,
                                                                right: 8),
                                                        child: Card(
                                                          surfaceTintColor:
                                                              Colors.white,
                                                          elevation: 6,
                                                          color: Colors.white,
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
                                                                        BorderRadius.circular(
                                                                            16))),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border(
                                                                      bottom: BorderSide(
                                                                          color: Constants
                                                                              .ftaColorLight,
                                                                          width:
                                                                              6))),
                                                              child: Column(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Colors.grey.withOpacity(
                                                                              0.05),
                                                                          border:
                                                                              Border.all(color: Colors.grey.withOpacity(0.0)),
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
                                                                          child: isLoadingMarketingData == true
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
                                                                                            formatLargeNumber((_selectedButton == 1
                                                                                                    ? Constants.exec_leads_sectionsList1a[0].amount
                                                                                                    : _selectedButton == 2
                                                                                                        ? Constants.exec_leads_sectionsList2a[0].amount
                                                                                                        : Constants.exec_leads_sectionsList3a[0].amount)
                                                                                                .toString()),
                                                                                            style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
                                                                                            textAlign: TextAlign.center,
                                                                                            maxLines: 2,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Center(
                                                                                        child: Padding(
                                                                                      padding: const EdgeInsets.only(top: 0.0),
                                                                                      child: Text(
                                                                                        ((_selectedButton == 1
                                                                                                        ? Constants.exec_leads_sectionsList1a[0].percentage
                                                                                                        : _selectedButton == 2
                                                                                                            ? Constants.exec_leads_sectionsList2a[0].percentage
                                                                                                            : _selectedButton == 3 && days_difference <= 31
                                                                                                                ? Constants.exec_leads_sectionsList3a[0].percentage
                                                                                                                : Constants.exec_leads_sectionsList3a[0].percentage) *
                                                                                                    100)
                                                                                                .toStringAsFixed(1) +
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
                                                                                        (_selectedButton == 1
                                                                                            ? Constants.exec_leads_sectionsList1a[0].id
                                                                                            : _selectedButton == 2
                                                                                                ? Constants.exec_leads_sectionsList2a[0].id
                                                                                                : _selectedButton == 3 && days_difference <= 31
                                                                                                    ? Constants.exec_leads_sectionsList3a[0].id
                                                                                                    : Constants.exec_leads_sectionsList3a[0].id),
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
                                          height: 125,
                                          child: InkWell(
                                              onTap: () {
                                                restartInactivityTimer();
                                              },
                                              child: Container(
                                                height: 125,
                                                width: MediaQuery.of(context)
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
                                                                bottom: 4.0,
                                                                right: 8),
                                                        child: Card(
                                                          surfaceTintColor:
                                                              Colors.white,
                                                          elevation: 6,
                                                          color: Colors.white,
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
                                                                        BorderRadius.circular(
                                                                            16))),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border(
                                                                      bottom: BorderSide(
                                                                          color: Constants
                                                                              .ftaColorLight,
                                                                          width:
                                                                              6))),
                                                              child:
                                                                  isLoadingMarketingData ==
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
                                                                                              formatLargeNumber3(((_selectedButton == 1
                                                                                                      ? Constants.exec_leads_sectionsList1a[1].amount
                                                                                                      : _selectedButton == 2
                                                                                                          ? Constants.exec_leads_sectionsList2a[1].amount
                                                                                                          : _selectedButton == 3 && days_difference <= 31
                                                                                                              ? Constants.exec_leads_sectionsList3a[1].amount
                                                                                                              : Constants.exec_leads_sectionsList3a[1].amount))
                                                                                                  .toString()),
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
                                                                                            ((_selectedButton == 1
                                                                                                            ? Constants.exec_leads_sectionsList1a[1].percentage
                                                                                                            : _selectedButton == 2
                                                                                                                ? Constants.exec_leads_sectionsList2a[1].percentage
                                                                                                                : _selectedButton == 3 && days_difference <= 31
                                                                                                                    ? Constants.exec_leads_sectionsList3a[1].percentage
                                                                                                                    : Constants.exec_leads_sectionsList3b[1].percentage) *
                                                                                                        100)
                                                                                                    .toStringAsFixed(1) +
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
                                          height: 125,
                                          child: InkWell(
                                              onTap: () {
                                                restartInactivityTimer();
                                              },
                                              child: Container(
                                                height: 125,
                                                width: MediaQuery.of(context)
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
                                                                        BorderRadius.circular(
                                                                            16))),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border(
                                                                      bottom: BorderSide(
                                                                          color: Constants
                                                                              .ftaColorLight,
                                                                          width:
                                                                              6))),
                                                              child:
                                                                  isLoadingMarketingData ==
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
                                                                                              formatLargeNumber3((_selectedButton == 1
                                                                                                      ? Constants.exec_leads_sectionsList1a[2].amount
                                                                                                      : _selectedButton == 2
                                                                                                          ? Constants.exec_leads_sectionsList2a[2].amount
                                                                                                          : _selectedButton == 3 && days_difference <= 31
                                                                                                              ? Constants.exec_leads_sectionsList3a[2].amount
                                                                                                              : Constants.exec_leads_sectionsList3a[2].amount)
                                                                                                  .toString()),
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
                                                                                            ((_selectedButton == 1
                                                                                                            ? Constants.exec_leads_sectionsList1a[2].percentage
                                                                                                            : _selectedButton == 2
                                                                                                                ? Constants.exec_leads_sectionsList2a[2].percentage
                                                                                                                : _selectedButton == 3 && days_difference <= 31
                                                                                                                    ? Constants.exec_leads_sectionsList3a[2].percentage
                                                                                                                    : Constants.exec_leads_sectionsList3b[2].percentage) *
                                                                                                        100)
                                                                                                    .toStringAsFixed(1) +
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
                                  SizedBox(
                                    height: 24,
                                  ),
                                  _selectedButton == 1
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              left: 0.0, bottom: 0),
                                          child: Center(
                                              child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0,
                                                          right: 16,
                                                          bottom: 8),
                                                  child: Text(
                                                      "Quote Acceptance Rate (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                                ),
                                              )
                                            ],
                                          )),
                                        )
                                      : _selectedButton == 2
                                          ? Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20.0,
                                                            right: 16,
                                                            bottom: 8),
                                                    child: Text(
                                                        "Quote Acceptance Rate (12 Months View)"),
                                                  ),
                                                )
                                              ],
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0.0, bottom: 12),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20.0,
                                                              right: 16,
                                                              bottom: 8),
                                                      child: Text(
                                                          "Quote Acceptance Rate (${formattedStartDate} to ${formattedEndDate})"),
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
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: LinearPercentIndicator(
                                      width: MediaQuery.of(context).size.width -
                                          14,
                                      animation: true,
                                      lineHeight: 20.0,
                                      animationDuration: 500,
                                      percent: isLoadingMarketingData == true
                                          ? 0
                                          : _selectedButton == 1
                                              ? Constants
                                                  .quoteAcceptance_rate[0]
                                              : _selectedButton == 2
                                                  ? Constants
                                                      .quoteAcceptance_rate[1]
                                                  : Constants
                                                      .quoteAcceptance_rate[2],
                                      center: Text(
                                          "${((isLoadingMarketingData == true ? 0 : _selectedButton == 1 ? Constants.quoteAcceptance_rate[0] : _selectedButton == 2 ? Constants.quoteAcceptance_rate[1] : Constants.quoteAcceptance_rate[2]) * 100).toStringAsFixed(1)}%",
                                          style: TextStyle(
                                            color:
                                                Constants.quoteAcceptance_rate[
                                                            0] <
                                                        0.4
                                                    ? Colors.black
                                                    : Colors.white,
                                          )),
                                      barRadius: ui.Radius.circular(12),
                                      //linearStrokeCap: LinearStrokeCap.roundAll,
                                      progressColor: (_selectedButton == 1
                                                  ? Constants
                                                      .quoteAcceptance_rate[0]
                                                  : _selectedButton == 2
                                                      ? Constants
                                                              .quoteAcceptance_rate[
                                                          1]
                                                      : Constants
                                                              .quoteAcceptance_rate[
                                                          2]) <
                                              0.4
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  _selectedButton == 1
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              left: 0.0, bottom: 0),
                                          child: Center(
                                              child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0,
                                                          right: 16,
                                                          bottom: 8),
                                                  child: Text(
                                                      "Lead Arrival & Capture Pattern (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                                ),
                                              )
                                            ],
                                          )),
                                        )
                                      : _selectedButton == 2
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  left: 0.0, bottom: 0),
                                              child: Center(
                                                  child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16.0,
                                                              right: 16,
                                                              bottom: 8),
                                                      child: Text(
                                                          "Lead Arrival & Capture Pattern (12 Months View)"),
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16.0,
                                                              right: 16,
                                                              bottom: 8),
                                                      child: Text(
                                                          "Lead Arrival & Capture Pattern (${formattedStartDate} to ${formattedEndDate})"),
                                                    ),
                                                  )
                                                ],
                                              )),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 16),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.10),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.10),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Center(
                                              child: Row(
                                                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      _animateButton10(0);
                                                    },
                                                    child: Container(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2) -
                                                          16,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      360)),
                                                      height: 35,
                                                      child: Center(
                                                        child: Text(
                                                          'Hourly View',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      _animateButton10(1);
                                                    },
                                                    child: Container(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2) -
                                                          16,
                                                      height: 35,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      360)),
                                                      child: Center(
                                                        child: Text(
                                                          'Daily View',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
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
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.easeInOut,
                                            left: _sliderPosition10,
                                            child: InkWell(
                                              onTap: () {
                                                // _animateButton2(3);
                                              },
                                              child: Container(
                                                  width: (MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2) -
                                                      16,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    color: Constants
                                                        .ctaColorLight, // Color of the slider
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: time_index == 0
                                                      ? Center(
                                                          child: Text(
                                                            'Hourly View',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                      : time_index == 1
                                                          ? Center(
                                                              child: Text(
                                                                'Daily View',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )
                                                          : Container()),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  time_index == 0
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0.0),
                                          child: Container(
                                              height: 280,
                                              child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 8.0,
                                                      bottom: 8,
                                                      left: 16.0,
                                                      right: 16),
                                                  child: CustomCard(
                                                      elevation: 6,
                                                      color: Colors.white,
                                                      surfaceTintColor:
                                                          Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  16)),
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                  left: 14.0,
                                                                  right: 14,
                                                                  top: 20,
                                                                  bottom: 14),
                                                          child:
                                                              isLoadingMarketingData ==
                                                                      true
                                                                  ? Center(
                                                                      child:
                                                                          Center(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              18,
                                                                          height:
                                                                              18,
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                            color:
                                                                                Constants.ctaColorLight,
                                                                            strokeWidth:
                                                                                1.8,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ))
                                                                  : LayoutBuilder(builder:
                                                                      (context,
                                                                          constraints) {
                                                                      if ((_selectedButton == 1 && Constants.leads_spots1a.length < 1) ||
                                                                          (_selectedButton == 2 &&
                                                                              Constants.leads_spots2a.length <
                                                                                  1) ||
                                                                          (_selectedButton == 3 &&
                                                                              Constants.leads_spots3a.length < 1)) {
                                                                        return Center(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(bottom: 12.0),
                                                                            child:
                                                                                Text(
                                                                              "No data available for the selected range",
                                                                              style: TextStyle(
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.normal,
                                                                                color: Colors.grey,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      } else {
                                                                        return Column(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(top: 12.0),
                                                                                child: LineChart(
                                                                                  key: Constants.leads_chartKey1b,
                                                                                  LineChartData(
                                                                                    lineBarsData: [
                                                                                      LineChartBarData(
                                                                                        spots: _selectedButton == 1
                                                                                            ? Constants.leads_spots1a
                                                                                            : _selectedButton == 2
                                                                                                ? Constants.leads_spots2a
                                                                                                : Constants.leads_spots3a,
                                                                                        isCurved: true,
                                                                                        preventCurveOverShooting: true,
                                                                                        barWidth: 3,
                                                                                        color: Colors.green,
                                                                                        dotData: FlDotData(
                                                                                          show: true,
                                                                                          getDotPainter: (spot, percent, barData, index) {
                                                                                            return CustomDotPainter(
                                                                                              dotColor: Constants.ftaColorLight,
                                                                                              dotSize: 6,
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      LineChartBarData(
                                                                                        spots: _selectedButton == 1
                                                                                            ? Constants.leads_spots1b
                                                                                            : _selectedButton == 2
                                                                                                ? Constants.leads_spots2b
                                                                                                : Constants.leads_spots3b,
                                                                                        preventCurveOverShooting: true,
                                                                                        isCurved: true,
                                                                                        barWidth: 3,
                                                                                        color: Colors.grey,
                                                                                        dotData: FlDotData(
                                                                                          show: false,
                                                                                          getDotPainter: (spot, percent, barData, index) {
                                                                                            /*        return FlDotCirclePainter(
                                                                              strokeWidth:
                                                                                  1,
                                                                              radius: 2,
                                                                              color: Colors
                                                                                  .red,
                                                                              strokeColor:
                                                                                  Colors
                                                                                      .green);*/
                                                                                            return CustomDotPainter(
                                                                                              dotColor: Constants.ftaColorLight,
                                                                                              dotSize: 6,
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                    lineTouchData: LineTouchData(
                                                                                        enabled: true,
                                                                                        touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                                                                                          // TODO : Utilize touch event here to perform any operation
                                                                                        },
                                                                                        touchTooltipData: LineTouchTooltipData(
                                                                                          getTooltipColor: (value) {
                                                                                            return Colors.blueGrey;
                                                                                          },
                                                                                          tooltipRoundedRadius: 20.0,
                                                                                          showOnTopOfTheChartBoxArea: false,
                                                                                          fitInsideHorizontally: true,
                                                                                          tooltipMargin: 0,
                                                                                          getTooltipItems: (touchedSpots) {
                                                                                            return touchedSpots.map(
                                                                                              (LineBarSpot touchedSpot) {
                                                                                                const textStyle = TextStyle(
                                                                                                  fontSize: 10,
                                                                                                  fontWeight: FontWeight.w700,
                                                                                                  color: Colors.white70,
                                                                                                );
                                                                                                return LineTooltipItem(
                                                                                                  touchedSpot.y.round().toString(),
                                                                                                  textStyle,
                                                                                                );
                                                                                              },
                                                                                            ).toList();
                                                                                          },
                                                                                        ),
                                                                                        getTouchedSpotIndicator: (LineChartBarData barData, List<int> indicators) {
                                                                                          return indicators.map(
                                                                                            (int index) {
                                                                                              final line = FlLine(color: Colors.grey, strokeWidth: 1, dashArray: [2, 4]);
                                                                                              return TouchedSpotIndicatorData(
                                                                                                line,
                                                                                                FlDotData(show: false),
                                                                                              );
                                                                                            },
                                                                                          ).toList();
                                                                                        },
                                                                                        getTouchLineEnd: (_, __) => double.infinity),
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
                                                                                            interval: 2, // Show every 2nd hour instead of every hour
                                                                                            getTitlesWidget: (value, meta) {
                                                                                              return Padding(
                                                                                                padding: const EdgeInsets.all(0.0),
                                                                                                child: Text(
                                                                                                  value.toInt().toString(),
                                                                                                  style: TextStyle(fontSize: 7),
                                                                                                ),
                                                                                              );
                                                                                            },
                                                                                          ),
                                                                                          axisNameSize: 35,
                                                                                          axisNameWidget: HourlyLeadsOverviewTypeGrid()),
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
                                                                                          reservedSize: 20,
                                                                                          getTitlesWidget: (value, meta) {
                                                                                            return Container();
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      leftTitles: AxisTitles(
                                                                                        sideTitles: SideTitles(
                                                                                          showTitles: true,
                                                                                          reservedSize: 35,
                                                                                          getTitlesWidget: (value, meta) {
                                                                                            return Text(
                                                                                              formatLargeNumber3(value.toInt().toString()),
                                                                                              style: const TextStyle(fontSize: 7.5),
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
                                                                                    minX: 4,
                                                                                    maxX: 22,
                                                                                    maxY: () {
                                                                                      List<FlSpot> allSpots = [];
                                                                                      allSpots.addAll(_selectedButton == 1
                                                                                          ? Constants.leads_spots1a
                                                                                          : _selectedButton == 2
                                                                                              ? Constants.leads_spots2a
                                                                                              : Constants.leads_spots3a);
                                                                                      allSpots.addAll(_selectedButton == 1
                                                                                          ? Constants.leads_spots1b
                                                                                          : _selectedButton == 2
                                                                                              ? Constants.leads_spots2b
                                                                                              : Constants.leads_spots3b);
                                                                                      if (allSpots.isEmpty) return 10.0;
                                                                                      double maxYValue = allSpots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b).toDouble();
                                                                                      return maxYValue * 1.1; // Add 10% padding
                                                                                    }(),
                                                                                    borderData: FlBorderData(
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
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      }
                                                                    }))))))
                                      : (isLoadingMarketingData == true)
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  right: 16,
                                                  top: 12),
                                              child: CustomCard(
                                                elevation: 6,
                                                color: Colors.white,
                                                child: Container(
                                                  height: 280,
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
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 0.0),
                                              child: Container(
                                                  height: 280,
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0,
                                                              bottom: 8,
                                                              left: 16.0,
                                                              right: 16),
                                                      child: _selectedButton == 1
                                                          ? CustomCard(
                                                              elevation: 6,
                                                              color: Colors.white,
                                                              surfaceTintColor: Colors.white,
                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                              child: Padding(
                                                                  padding: const EdgeInsets.only(left: 14.0, right: 14, top: 20, bottom: 14),
                                                                  child: isLoadingMarketingData == true
                                                                      ? Center(
                                                                          child: Center(
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
                                                                        ))
                                                                      : LayoutBuilder(builder: (context, constraints) {
                                                                          if (Constants.d_leads_spots1a.length <
                                                                              1) {
                                                                            return Center(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(bottom: 12.0),
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
                                                                          } else
                                                                            return Column(
                                                                              children: [
                                                                                Expanded(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(top: 12.0),
                                                                                    child: LineChart(
                                                                                      key: Constants.d_leads_chartKey1b,
                                                                                      LineChartData(
                                                                                        lineBarsData: [
                                                                                          LineChartBarData(
                                                                                            spots: Constants.d_leads_spots1b,
                                                                                            isCurved: true,
                                                                                            preventCurveOverShooting: true,
                                                                                            barWidth: 3,
                                                                                            color: Colors.green,
                                                                                            dotData: FlDotData(
                                                                                              show: false,
                                                                                              getDotPainter: (spot, percent, barData, index) {
                                                                                                /*        return FlDotCirclePainter(
                                                                              strokeWidth:
                                                                                  1,
                                                                              radius: 2,
                                                                              color: Colors
                                                                                  .red,
                                                                              strokeColor:
                                                                                  Colors
                                                                                      .green);*/
                                                                                                return CustomDotPainter(
                                                                                                  dotColor: Constants.ftaColorLight,
                                                                                                  dotSize: 6,
                                                                                                );
                                                                                              },
                                                                                            ),
                                                                                          ),
                                                                                          LineChartBarData(
                                                                                            spots: Constants.d_leads_spots1a,
                                                                                            isCurved: true,
                                                                                            preventCurveOverShooting: true,
                                                                                            barWidth: 3,
                                                                                            color: Colors.grey.shade400,
                                                                                            dotData: FlDotData(
                                                                                              show: true,
                                                                                              getDotPainter: (spot, percent, barData, index) {
                                                                                                /*        return FlDotCirclePainter(
                                                                              strokeWidth:
                                                                                  1,
                                                                              radius: 2,
                                                                              color: Colors
                                                                                  .red,
                                                                              strokeColor:
                                                                                  Colors
                                                                                      .green);*/
                                                                                                return CustomDotPainter(
                                                                                                  dotColor: Constants.ftaColorLight,
                                                                                                  dotSize: 6,
                                                                                                );
                                                                                              },
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                        lineTouchData: LineTouchData(
                                                                                            enabled: true,
                                                                                            touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                                                                                              // TODO : Utilize touch event here to perform any operation
                                                                                            },
                                                                                            touchTooltipData: LineTouchTooltipData(
                                                                                              getTooltipColor: (value) {
                                                                                                return Colors.blueGrey;
                                                                                              },
                                                                                              tooltipRoundedRadius: 20.0,
                                                                                              showOnTopOfTheChartBoxArea: false,
                                                                                              fitInsideHorizontally: true,
                                                                                              tooltipMargin: 0,
                                                                                              getTooltipItems: (touchedSpots) {
                                                                                                return touchedSpots.map(
                                                                                                  (LineBarSpot touchedSpot) {
                                                                                                    const textStyle = TextStyle(
                                                                                                      fontSize: 10,
                                                                                                      fontWeight: FontWeight.w700,
                                                                                                      color: Colors.white70,
                                                                                                    );
                                                                                                    return LineTooltipItem(
                                                                                                      touchedSpot.y.round().toString(),
                                                                                                      textStyle,
                                                                                                    );
                                                                                                  },
                                                                                                ).toList();
                                                                                              },
                                                                                            ),
                                                                                            getTouchedSpotIndicator: (LineChartBarData barData, List<int> indicators) {
                                                                                              return indicators.map(
                                                                                                (int index) {
                                                                                                  final line = FlLine(color: Colors.grey, strokeWidth: 1, dashArray: [2, 4]);
                                                                                                  return TouchedSpotIndicatorData(
                                                                                                    line,
                                                                                                    FlDotData(show: false),
                                                                                                  );
                                                                                                },
                                                                                              ).toList();
                                                                                            },
                                                                                            getTouchLineEnd: (_, __) => double.infinity),
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
                                                                                                      value.toInt().toString(),
                                                                                                      style: TextStyle(fontSize: 7),
                                                                                                    ),
                                                                                                  );
                                                                                                },
                                                                                              ),
                                                                                              axisNameWidget: LeadsOverviewTypeGrid()),
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
                                                                                              reservedSize: 20,
                                                                                              getTitlesWidget: (value, meta) {
                                                                                                return Container();
                                                                                              },
                                                                                            ),
                                                                                          ),
                                                                                          leftTitles: AxisTitles(
                                                                                            sideTitles: SideTitles(
                                                                                              showTitles: true,
                                                                                              reservedSize: 30,
                                                                                              getTitlesWidget: (value, meta) {
                                                                                                return Text(
                                                                                                  formatLargeNumber3(value.toInt().toString()),
                                                                                                  style: TextStyle(fontSize: 7.5),
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
                                                                                        minX: 1,
                                                                                        maxX: 31,
                                                                                        maxY: () {
                                                                                          List<FlSpot> allSpots = [];
                                                                                          allSpots.addAll(Constants.d_leads_spots1b);
                                                                                          if (allSpots.isEmpty) return 10.0;
                                                                                          double maxYValue = allSpots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b).toDouble();
                                                                                          return maxYValue * 1.1; // Add 10% padding
                                                                                        }(),
                                                                                        borderData: FlBorderData(
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
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 6,
                                                                                ),
                                                                                Text(
                                                                                  "Weekend Leads are Added to / Accounted For On The Next Monday",
                                                                                  style: TextStyle(fontSize: 9),
                                                                                )
                                                                              ],
                                                                            );
                                                                        })))
                                                          : _selectedButton == 2
                                                              ? CustomCard(
                                                                  elevation: 6,
                                                                  color: Colors.white,
                                                                  surfaceTintColor: Colors.white,
                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                                  child: Padding(
                                                                      padding: const EdgeInsets.only(left: 14.0, right: 14, top: 20, bottom: 14),
                                                                      child: isLoadingMarketingData == true
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
                                                                          : LayoutBuilder(builder: (context, constraints) {
                                                                              if (Constants.d_leads_spots2a.length < 1) {
                                                                                return Center(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(bottom: 12.0),
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
                                                                              } else
                                                                                return Column(
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.only(top: 12.0),
                                                                                        child: LineChart(
                                                                                          key: Constants.d_leads_chartKey2b,
                                                                                          LineChartData(
                                                                                            lineBarsData: [
                                                                                              LineChartBarData(
                                                                                                spots: Constants.d_leads_spots2b,
                                                                                                preventCurveOverShooting: true,
                                                                                                isCurved: true,
                                                                                                barWidth: 3,
                                                                                                color: Colors.green,
                                                                                                dotData: FlDotData(
                                                                                                  show: false,
                                                                                                  getDotPainter: (spot, percent, barData, index) {
                                                                                                    /*        return FlDotCirclePainter(
                                                                              strokeWidth:
                                                                                  1,
                                                                              radius: 2,
                                                                              color: Colors
                                                                                  .red,
                                                                              strokeColor:
                                                                                  Colors
                                                                                      .green);*/
                                                                                                    return CustomDotPainter(
                                                                                                      dotColor: Constants.ftaColorLight,
                                                                                                      dotSize: 6,
                                                                                                    );
                                                                                                  },
                                                                                                ),
                                                                                              ),
                                                                                              LineChartBarData(
                                                                                                spots: Constants.d_leads_spots2a,
                                                                                                isCurved: true,
                                                                                                preventCurveOverShooting: true,
                                                                                                barWidth: 3,
                                                                                                color: Colors.grey.shade400,
                                                                                                dotData: FlDotData(
                                                                                                  show: true,
                                                                                                  getDotPainter: (spot, percent, barData, index) {
                                                                                                    /*        return FlDotCirclePainter(
                                                                              strokeWidth:
                                                                                  1,
                                                                              radius: 2,
                                                                              color: Colors
                                                                                  .red,
                                                                              strokeColor:
                                                                                  Colors
                                                                                      .green);*/
                                                                                                    return CustomDotPainter(
                                                                                                      dotColor: Constants.ftaColorLight,
                                                                                                      dotSize: 6,
                                                                                                    );
                                                                                                  },
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                            lineTouchData: LineTouchData(
                                                                                                enabled: true,
                                                                                                touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                                                                                                  // TODO : Utilize touch event here to perform any operation
                                                                                                },
                                                                                                touchTooltipData: LineTouchTooltipData(
                                                                                                  getTooltipColor: (value) {
                                                                                                    return Colors.blueGrey;
                                                                                                  },
                                                                                                  tooltipRoundedRadius: 20.0,
                                                                                                  showOnTopOfTheChartBoxArea: false,
                                                                                                  fitInsideHorizontally: true,
                                                                                                  tooltipMargin: 0,
                                                                                                  getTooltipItems: (touchedSpots) {
                                                                                                    return touchedSpots.map(
                                                                                                      (LineBarSpot touchedSpot) {
                                                                                                        const textStyle = TextStyle(
                                                                                                          fontSize: 10,
                                                                                                          fontWeight: FontWeight.w700,
                                                                                                          color: Colors.white70,
                                                                                                        );
                                                                                                        return LineTooltipItem(
                                                                                                          touchedSpot.y.round().toString(),
                                                                                                          textStyle,
                                                                                                        );
                                                                                                      },
                                                                                                    ).toList();
                                                                                                  },
                                                                                                ),
                                                                                                getTouchedSpotIndicator: (LineChartBarData barData, List<int> indicators) {
                                                                                                  return indicators.map(
                                                                                                    (int index) {
                                                                                                      final line = FlLine(color: Colors.grey, strokeWidth: 1, dashArray: [2, 4]);
                                                                                                      return TouchedSpotIndicatorData(
                                                                                                        line,
                                                                                                        FlDotData(show: false),
                                                                                                      );
                                                                                                    },
                                                                                                  ).toList();
                                                                                                },
                                                                                                getTouchLineEnd: (_, __) => double.infinity),
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
                                                                                                          value.toInt().toString(),
                                                                                                          style: TextStyle(fontSize: 7),
                                                                                                        ),
                                                                                                      );
                                                                                                    },
                                                                                                  ),
                                                                                                  axisNameWidget: LeadsOverviewTypeGrid()),
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
                                                                                                  reservedSize: 20,
                                                                                                  getTitlesWidget: (value, meta) {
                                                                                                    return Container();
                                                                                                  },
                                                                                                ),
                                                                                              ),
                                                                                              leftTitles: AxisTitles(
                                                                                                sideTitles: SideTitles(
                                                                                                  showTitles: true,
                                                                                                  reservedSize: 30,
                                                                                                  getTitlesWidget: (value, meta) {
                                                                                                    return Text(
                                                                                                      formatLargeNumber3(value.toInt().toString()),
                                                                                                      style: TextStyle(fontSize: 7.5),
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
                                                                                            minX: 1,
                                                                                            maxX: 31,
                                                                                            maxY: () {
                                                                                              List<FlSpot> allSpots = [];
                                                                                              allSpots.addAll(Constants.d_leads_spots3a);
                                                                                              allSpots.addAll(Constants.d_leads_spots3b);
                                                                                              if (allSpots.isEmpty) return 10.0;
                                                                                              double maxYValue = allSpots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b).toDouble();
                                                                                              return maxYValue * 1.1; // Add 10% padding
                                                                                            }(),
                                                                                            borderData: FlBorderData(
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
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 6,
                                                                                    ),
                                                                                    Text(
                                                                                      "Weekend Leads are Added to / Accounted For On The Next Monday",
                                                                                      style: TextStyle(fontSize: 9),
                                                                                    )
                                                                                  ],
                                                                                );
                                                                            })))
                                                              : CustomCard(
                                                                  elevation: 6,
                                                                  color: Colors.white,
                                                                  surfaceTintColor: Colors.white,
                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                                  child: Padding(
                                                                      padding: const EdgeInsets.only(left: 14.0, right: 14, top: 20, bottom: 14),
                                                                      child: isLoadingMarketingData == true
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
                                                                          : LayoutBuilder(builder: (context, constraints) {
                                                                              if (Constants.d_leads_spots3a.length < 1) {
                                                                                return Center(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(bottom: 12.0),
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
                                                                              } else
                                                                                return Column(
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.only(top: 12.0),
                                                                                        child: LineChart(
                                                                                          key: Constants.d_leads_chartKey3b,
                                                                                          LineChartData(
                                                                                            lineBarsData: [
                                                                                              LineChartBarData(
                                                                                                spots: Constants.d_leads_spots3b,
                                                                                                preventCurveOverShooting: true,
                                                                                                isCurved: true,
                                                                                                barWidth: 3,
                                                                                                color: Colors.green,
                                                                                                dotData: FlDotData(
                                                                                                  show: false,
                                                                                                  getDotPainter: (spot, percent, barData, index) {
                                                                                                    /*        return FlDotCirclePainter(
                                                                              strokeWidth:
                                                                                  1,
                                                                              radius: 2,
                                                                              color: Colors
                                                                                  .red,
                                                                              strokeColor:
                                                                                  Colors
                                                                                      .green);*/
                                                                                                    return CustomDotPainter(
                                                                                                      dotColor: Constants.ftaColorLight,
                                                                                                      dotSize: 6,
                                                                                                    );
                                                                                                  },
                                                                                                ),
                                                                                              ),
                                                                                              LineChartBarData(
                                                                                                spots: Constants.d_leads_spots3a,
                                                                                                isCurved: true,
                                                                                                preventCurveOverShooting: true,
                                                                                                barWidth: 3,
                                                                                                color: Colors.grey.shade400,
                                                                                                dotData: FlDotData(
                                                                                                  show: true,
                                                                                                  getDotPainter: (spot, percent, barData, index) {
                                                                                                    /*        return FlDotCirclePainter(
                                                                              strokeWidth:
                                                                                  1,
                                                                              radius: 2,
                                                                              color: Colors
                                                                                  .red,
                                                                              strokeColor:
                                                                                  Colors
                                                                                      .green);*/
                                                                                                    return CustomDotPainter(
                                                                                                      dotColor: Constants.ftaColorLight,
                                                                                                      dotSize: 6,
                                                                                                    );
                                                                                                  },
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                            lineTouchData: LineTouchData(
                                                                                                enabled: true,
                                                                                                touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                                                                                                  // TODO : Utilize touch event here to perform any operation
                                                                                                },
                                                                                                touchTooltipData: LineTouchTooltipData(
                                                                                                  getTooltipColor: (value) {
                                                                                                    return Colors.blueGrey;
                                                                                                  },
                                                                                                  tooltipRoundedRadius: 20.0,
                                                                                                  showOnTopOfTheChartBoxArea: false,
                                                                                                  fitInsideHorizontally: true,
                                                                                                  tooltipMargin: 0,
                                                                                                  getTooltipItems: (touchedSpots) {
                                                                                                    return touchedSpots.map(
                                                                                                      (LineBarSpot touchedSpot) {
                                                                                                        const textStyle = TextStyle(
                                                                                                          fontSize: 10,
                                                                                                          fontWeight: FontWeight.w700,
                                                                                                          color: Colors.white70,
                                                                                                        );
                                                                                                        return LineTooltipItem(
                                                                                                          touchedSpot.y.round().toString(),
                                                                                                          textStyle,
                                                                                                        );
                                                                                                      },
                                                                                                    ).toList();
                                                                                                  },
                                                                                                ),
                                                                                                getTouchedSpotIndicator: (LineChartBarData barData, List<int> indicators) {
                                                                                                  return indicators.map(
                                                                                                    (int index) {
                                                                                                      final line = FlLine(color: Colors.grey, strokeWidth: 1, dashArray: [2, 4]);
                                                                                                      return TouchedSpotIndicatorData(
                                                                                                        line,
                                                                                                        FlDotData(show: false),
                                                                                                      );
                                                                                                    },
                                                                                                  ).toList();
                                                                                                },
                                                                                                getTouchLineEnd: (_, __) => double.infinity),
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
                                                                                                          value.toInt().toString(),
                                                                                                          style: TextStyle(fontSize: 7),
                                                                                                        ),
                                                                                                      );
                                                                                                    },
                                                                                                  ),
                                                                                                  axisNameWidget: LeadsOverviewTypeGrid()),
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
                                                                                                  reservedSize: 20,
                                                                                                  getTitlesWidget: (value, meta) {
                                                                                                    return Container();
                                                                                                  },
                                                                                                ),
                                                                                              ),
                                                                                              leftTitles: AxisTitles(
                                                                                                sideTitles: SideTitles(
                                                                                                  showTitles: true,
                                                                                                  reservedSize: 30,
                                                                                                  getTitlesWidget: (value, meta) {
                                                                                                    return Text(
                                                                                                      formatLargeNumber3(value.toInt().toString()),
                                                                                                      style: TextStyle(fontSize: 7.5),
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
                                                                                            minX: 1,
                                                                                            maxX: 31,
                                                                                            maxY: () {
                                                                                              List<FlSpot> allSpots = [];
                                                                                              allSpots.addAll(Constants.d_leads_spots3a);
                                                                                              allSpots.addAll(Constants.d_leads_spots3b);
                                                                                              if (allSpots.isEmpty) return 10.0;
                                                                                              double maxYValue = allSpots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b).toDouble();
                                                                                              return maxYValue * 1.1; // Add 10% padding
                                                                                            }(),
                                                                                            borderData: FlBorderData(
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
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 6,
                                                                                    ),
                                                                                    Text(
                                                                                      "Weekend Leads are Added to / Accounted For On The Next Monday",
                                                                                      style: TextStyle(fontSize: 9),
                                                                                    )
                                                                                  ],
                                                                                );
                                                                            })))))),
                                  SizedBox(height: 12),
                                  _selectedButton == 1
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0, top: 12),
                                          child: Text(
                                              "Top 10 Agents & Rejection Mix (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                        )
                                      : _selectedButton == 2
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0, top: 12),
                                              child: Text(
                                                  "Top 10 Agents & Rejection Mix (12 Months View)"),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0, top: 12),
                                              child: Text(
                                                  "Top 10 Agents & Rejection Mix (${formattedStartDate} to ${formattedEndDate})"),
                                            ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 16, top: 12),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.10),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.10),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Center(
                                              child: Row(
                                                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      _animateButton11(0);
                                                    },
                                                    child: Container(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2) -
                                                          16,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      360)),
                                                      height: 35,
                                                      child: Center(
                                                        child: Text(
                                                          'Top 10 Agents',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      print("hggjhh");
                                                      _animateButton11(1);
                                                    },
                                                    child: Container(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2) -
                                                          16,
                                                      height: 35,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      360)),
                                                      child: Center(
                                                        child: Text(
                                                          'Rejection Mix',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
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
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.easeInOut,
                                            left: _sliderPosition11,
                                            child: InkWell(
                                              onTap: () {
                                                //   _animateButton11(2);
                                              },
                                              child: Container(
                                                  width: (MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2) -
                                                      16,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    color: Constants
                                                        .ctaColorLight, // Color of the slider
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: target_index_11 == 0
                                                      ? Center(
                                                          child: Text(
                                                            'Top 10 Agents',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                      : target_index_11 == 1
                                                          ? Center(
                                                              child: Text(
                                                                'Rejection Mix',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )
                                                          : Container()),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  // Text(leads_jsonResponse1a.toString()),
                                  target_index_11 == 0
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0,
                                              bottom: 8,
                                              left: 12,
                                              right: 12),
                                          child: Card(
                                            surfaceTintColor: Colors.white,
                                            color: Colors.white,
                                            elevation: 6,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: Container(
                                                child: Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey
                                                          .withOpacity(0.35),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            6.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 28,
                                                          height: 28,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.green,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          360)),
                                                          child: Center(
                                                            child: Text(
                                                              "#",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 12,
                                                        ),
                                                        Expanded(
                                                            flex: 4,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          0.0),
                                                              child: Text(
                                                                  "Agent Submissions"),
                                                            )),
                                                        Container(
                                                          width: 80,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right:
                                                                        12.0),
                                                            child: Text(
                                                              "Count",
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 28),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                //    Text(Constants.sales_persistencybyagent4b.length.toString()),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12.0,
                                                          right: 12,
                                                          top: 12),
                                                  child: (isLoadingMarketingData ==
                                                          true)
                                                      ? Container(
                                                          height: 200,
                                                          child: Center(
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
                                                          ),
                                                        )
                                                      : (_selectedButton == 1 &&
                                                              sales_index ==
                                                                  0 &&
                                                              Constants.field_leadbyagent1a
                                                                      .length ==
                                                                  0)
                                                          ? Center(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            12.0),
                                                                child: Text(
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
                                                              ),
                                                            )
                                                          : (_selectedButton ==
                                                                      2 &&
                                                                  sales_index ==
                                                                      1 &&
                                                                  Constants
                                                                          .field_leadbyagent1b
                                                                          .length ==
                                                                      0)
                                                              ? Center(
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            12.0),
                                                                    child: Text(
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
                                                                  ),
                                                                )
                                                              : ListView.builder(
                                                                  padding: EdgeInsets.only(top: 0, bottom: 16),
                                                                  itemCount: (_selectedButton == 1)
                                                                      ? min(Constants.field_leadbyagent1a.length, 10)
                                                                      : (_selectedButton == 2)
                                                                          ? min(Constants.field_leadbyagent2a.length, 10)
                                                                          : min(Constants.field_leadbyagent3a.length, 10),
                                                                  shrinkWrap: true,
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  itemBuilder: (BuildContext context, int index) {
                                                                    return Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              8.0),
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            SizedBox(height: 2),
                                                                            Row(
                                                                              children: [
                                                                                Container(
                                                                                  width: 35,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(left: 4.0),
                                                                                    child: Text("${index + 1} "),
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                    flex: 4,
                                                                                    child: Text("${extractFirstAndLastName((_selectedButton == 1) ? Constants.field_leadbyagent1a[index].employee_name : (_selectedButton == 2) ? Constants.field_leadbyagent2a[index].employee_name.trimLeft() : Constants.field_leadbyagent3a[index].employee_name.trimLeft())}")),
                                                                                Container(
                                                                                  width: 80,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(right: 0.0),
                                                                                    child: Text(
                                                                                      "${(_selectedButton == 1) ? (sales_index == 0 ? Constants.field_leadbyagent1a[index].total_leads : sales_index == 1 ? Constants.field_leadbyagent1a[index].total_leads.toInt() : Constants.field_leadbyagent1a[index].total_leads.toInt()) : (_selectedButton == 2) ? (sales_index == 0 ? Constants.field_leadbyagent2a[index].total_leads.toInt() : sales_index == 1 ? Constants.field_leadbyagent2a[index].total_leads.toInt() : Constants.field_leadbyagent2a[index].total_leads.toInt()) : (_selectedButton == 3 && days_difference <= 31) ? (sales_index == 0 ? Constants.field_leadbyagent3a[index].total_leads.toInt() : sales_index == 1 ? Constants.field_leadbyagent3a[index].total_leads.toInt() : Constants.field_leadbyagent3a[index].total_leads.toInt()) : (sales_index == 0 ? Constants.field_leadbyagent3a[index].total_leads.toInt() : sales_index == 1 ? Constants.field_leadbyagent3a[index].total_leads.toInt() : Constants.field_leadbyagent3a[index].total_leads.toInt())}",
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: 16),
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 3),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 8.0),
                                                                              child: Container(
                                                                                height: 1,
                                                                                color: Colors.grey.withOpacity(0.10),
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
                                        )
                                      : (isLoadingMarketingData == true)
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  right: 16,
                                                  top: 12),
                                              child: CustomCard(
                                                elevation: 6,
                                                color: Colors.white,
                                                child: Container(
                                                  height: 700,
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
                                                  ),
                                                ),
                                              ),
                                            )
                                          : _selectedButton == 1
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 16.0,
                                                      right: 16,
                                                      top: 8),
                                                  child: Container(
                                                    height: 700,
                                                    key: Constants
                                                        .marketing_tree_key1a,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: CustomCard(
                                                      elevation: 6,
                                                      surfaceTintColor:
                                                          Colors.white,
                                                      color: Colors.white,
                                                      child: Container(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16.0),
                                                          child:
                                                              isLoadingMarketingData
                                                                  ? Container(
                                                                      height:
                                                                          200,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                18,
                                                                            height:
                                                                                18,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              color: Constants.ctaColorLight,
                                                                              strokeWidth: 1.8,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : CustomTreemap(
                                                                      treeMapdata:
                                                                          leads_jsonResponse1a),
                                                        ),
                                                      ),
                                                    ),
                                                  ))
                                              : _selectedButton == 2
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 16.0,
                                                          right: 16,
                                                          top: 8),
                                                      child: FadeOut(
                                                        child: Container(
                                                          height: 700,
                                                          key: Constants
                                                              .marketing_tree_key2a,
                                                          child: CustomCard(
                                                            elevation: 6,
                                                            surfaceTintColor:
                                                                Colors.white,
                                                            color: Colors.white,
                                                            child: Container(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        16.0),
                                                                child: CustomTreemap(
                                                                    treeMapdata:
                                                                        leads_jsonResponse2a),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ))
                                                  : _selectedButton == 3
                                                      ? Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 16.0,
                                                                  right: 16,
                                                                  top: 8),
                                                          child: Container(
                                                            key: Constants
                                                                .leads_tree_key3a,
                                                            height: 700,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: CustomCard(
                                                              elevation: 6,
                                                              surfaceTintColor:
                                                                  Colors.white,
                                                              color:
                                                                  Colors.white,
                                                              child: Container(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          16.0),
                                                                  child: isLoadingMarketingData
                                                                      ? Container(
                                                                          height:
                                                                              200,
                                                                          child:
                                                                              Center(
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
                                                                          ),
                                                                        )
                                                                      : CustomTreemap(treeMapdata: leads_jsonResponse3a

                                                                          //  treeMapdata: jsonResponse1["reorganized_by_module"],

                                                                          ),
                                                                ),
                                                              ),
                                                            ),
                                                          ))
                                                      : Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 16.0,
                                                                  right: 16,
                                                                  top: 12),
                                                          child: Container(
                                                            key: Constants
                                                                .leads_tree_key3a,
                                                            height: 700,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: CustomCard(
                                                              elevation: 6,
                                                              surfaceTintColor:
                                                                  Colors.white,
                                                              color:
                                                                  Colors.white,
                                                              child: Container(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          16.0),
                                                                  child: isLoadingMarketingData
                                                                      ? Container(
                                                                          height:
                                                                              200,
                                                                          child:
                                                                              Center(
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
                                                                          ),
                                                                        )
                                                                      : CustomTreemap(treeMapdata: leads_jsonResponse3a

                                                                          //  treeMapdata: jsonResponse1["reorganized_by_module"],

                                                                          ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                ],
                              )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  @override
  void initState() {
    time_index = 0;
    target_index = 0;
    _marketing_main_sliderPosition_index_2 = 0;
    sectionsList = [
      gridmodel1("Submitted", 0, 0),
      gridmodel1("Captured", 0, 0),
      gridmodel1("Declined", 0, 0),
    ];

    sectionsList2 = [
      gridmodel1("Total Members", 0, 0),
      gridmodel1("Main Under 65", 0, 0),
      gridmodel1("Main Under 85", 0, 0),
      gridmodel1("Main Over 85", 0, 0),
      gridmodel1("Extended", 0, 0),
    ];
    sectionsList3 = [
      gridmodel1("0 - 1 WEEK", 0, 0),
      gridmodel1("1 - 2 WEEKS", 0, 0),
      gridmodel1(">2 WEEKS", 0, 0),
    ];
    super.initState();
    _animateButton(1);

    // Call getSalesAgentLeadsReport with selectedButton = 1
    DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    DateTime endDate = DateTime.now();
    String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
    String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

    setState(() {
      isLoadingLeadsReport = true;
    });

    getExecutiveLeadsReport(formattedStartDate, formattedEndDate, 1, 1, context)
        .then((_) {
      setState(() {
        isLoadingLeadsReport = false;
      });
    }).catchError((error) {
      print("❌ initState: getExecutiveLeadsReport error: $error");
      setState(() {
        isLoadingLeadsReport = false;
      });
    });

    marketingValue.addListener(() {
      kyrt = UniqueKey();

      if (mounted) setState(() {});
      Future.delayed(Duration(seconds: 2)).then((value) {
        //print("noOfDaysThisMonth $noOfDaysThisMonth");
        if (mounted) setState(() {});

        if (kDebugMode) {
          print("jhh;l $_selectedButton");
        }
      });
    });
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
    const List<String> suffixes = ["", "k", "m", "b", "t"];

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

  Future<bool> getMarketingReport(BuildContext context,
      String formattedStartDate, String formattedEndDate) async {
    String baseUrl =
        "${Constants.InsightsReportsbaseUrl}/api/reports/get_normalized_underwriting_data/";

    try {
      Map<String, String> payload = {
        // "client_id": "${Constants.cec_client_id}",
        "client_id": "1",
        "start_date": formattedStartDate,
        "end_date": formattedEndDate
      };

      if (kDebugMode) {
        print("Payload: $payload");
      }

      var response = await http.post(
        Uri.parse(baseUrl),
        body: payload,
      );

      if (kDebugMode) {
        print("Response Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
      }

      if (response.statusCode != 200) {
        /* Fluttertoast.showToast(
            msg: "Error loading data, please refresh",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.ctaColorLight,
            textColor: Colors.white,
            fontSize: 16.0);*/
        setState(() {
          isLoadingMarketingData =
              false; // Stop loading when request is complete
        });
        return false;
      } else {
        String jsonString4 = response.body.toString();
        Map<String, dynamic> m1 = jsonDecode(jsonString4);

        print("Overall Summary: ${m1["overall_summary"]}");

        setState(() {
          if (m1["overall_summary"] != null) {
            sectionsList[0].count = int.parse(
                (m1["overall_summary"]["total_quotes"] ?? 0).toString());
            sectionsList[0].amount = double.parse(
                (m1["overall_summary"]["total_quote_amount"] ?? 0).toString());
            sectionsList[1].count = int.parse(
                (m1["overall_summary"]["total_accepted"] ?? 0).toString());
            sectionsList[1].amount = double.parse(
                (m1["overall_summary"]["total_accepted_amount"] ?? 0)
                    .toString());
            sectionsList[2].count = int.parse(
                (m1["overall_summary"]["total_declined"] ?? 0).toString());
            sectionsList[2].amount = double.parse(
                (m1["overall_summary"]["total_declined_amount"] ?? 0)
                    .toString());

            sectionsListPercentages[0] = double.parse(
                    ((m1["overall_summary"]["acceptance_rate"] ?? 0))
                        .toString()) /
                100;

            sectionsList2[0].count =
                m1["overall_summary"]["total_main_members"] ?? 0;
            sectionsList2[1].count =
                m1["overall_summary"]["members_under_65"] ?? 0;
            sectionsList2[2].count =
                m1["overall_summary"]["members_under_85"] ?? 0;
            sectionsList2[3].count =
                m1["overall_summary"]["member_over_84"] ?? 0;
            sectionsList2[4].count =
                m1["overall_summary"]["additional_members"] ?? 0;
          }
          if (m1["quote_durations"] != null) {
            sectionsList3[0].count =
                m1["quote_durations"]["within_1_week"] ?? 0;
            sectionsList3[1].count =
                m1["quote_durations"]["within_2_weeks"] ?? 0;
            sectionsList3[2].count = m1["quote_durations"]["over_2_weeks"] ?? 0;
          }
          if (_selectedButton == 1) {
            collections_jsonResponse1a =
                m1["products_group"] as Map<String, dynamic>;
            //print("dfdfggf $collections_jsonResponse1a");
            Constants.marketing_tree_key1a = UniqueKey();
          } else if (_selectedButton == 2) {
            collections_jsonResponse2a =
                m1["products_group"] as Map<String, dynamic>;
            Constants.marketing_tree_key2a = UniqueKey();
          } else if (_selectedButton == 3 && days_difference <= 31) {
            collections_jsonResponse3a =
                m1["products_group"] as Map<String, dynamic>;
            Constants.marketing_tree_key3a = UniqueKey();
          } else {
            collections_jsonResponse3a =
                m1["products_group"] as Map<String, dynamic>;
            Constants.marketing_tree_key3a = UniqueKey();
          }

          if (_selectedButton == 1) {
            barChartData1 = processDataForCollectionsCountDaily(response.body);
          }
          if (_selectedButton == 3 && days_difference <= 31) {
            barChartData3 = processDataForCollectionsCountDaily2b(
                response.body, formattedStartDate, formattedEndDate, context);
          }
          if (_selectedButton == 3 && days_difference > 31) {
            barChartData4 = processDataForCollectionsCountMonthly4(
                response.body, formattedStartDate, formattedEndDate, context);
          }
          if (_selectedButton == 2) {
            barChartData2 = processDataForCollectionsCountMonthly(
                m1["result_lista"] ?? [],
                formattedStartDate,
                formattedEndDate,
                context);
            setState(() {});
          }

          isLoadingMarketingData = false;
        });
        topquotesbyagent = [];
        topquotesbyagent1 = [];
        topquotesbyclient = [];
        List top_employee_list = m1["top_employees_overall"] ?? [];
        top_employee_list.forEach((element) {
          Map m2 = element as Map;
          topquotesbyagent.add(QuotesByAgent(
              m2["employee_name"] ?? "",
              m2["total_quotes_count"] ?? 0,
              double.parse((m2["total_quotes_amount"] ?? "0.0").toString())));
          setState(() {});
        });
        List topquotesbyagent1_list = m1["top_employees_overall"] ?? [];
        topquotesbyagent1_list.forEach((element) {
          Map m2 = element as Map;
          topquotesbyagent1.add(QuotesByAgent(
              m2["employee_name"] ?? "",
              m2["accepted_quotes_amount"] ?? 0,
              double.parse((m2["total_quotes_amount"] ?? "0.0").toString())));
          setState(() {});
        });
        List topquotesbyclient_list = m1["top_clients"] ?? [];
        print(topquotesbyclient_list);
        topquotesbyclient_list.forEach((element) {
          Map m2 = element as Map;
          topquotesbyclient.add(QuotesByClient(m2["client_name"] ?? "",
              double.parse((m2["total_quote_amount"] ?? "0.0").toString())));
          setState(() {});
        });

        return true;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Exception: $e");
      }
      /* Fluttertoast.showToast(
          msg: "Error loading data, please refresh",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.ctaColorLight,
          textColor: Colors.white,
          fontSize: 16.0);*/
      setState(() {
        isLoadingMarketingData = false;
      });
      return false;
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

  String formatWithCommas(double value) {
    final format = NumberFormat("#,##0", "en_US"); // Updated pattern
    return format.format(value);
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
    }
    setState(() {});
  }

  void _animateButton11(int buttonNumber) {
    restartInactivityTimer();

    setState(() {});

    target_index_11 = buttonNumber;
    if (buttonNumber == 0) {
      _sliderPosition11 = 0.0;
    } else if (buttonNumber == 1) {
      _sliderPosition11 = (MediaQuery.of(context).size.width / 2) - 18;
    }
    setState(() {});
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

  List<BarChartGroupData> processDataForCollectionsCountDaily(
      String jsonString) {
    List<dynamic> jsonData = jsonDecode(jsonString)["result_lista"] ?? [];
    if (kDebugMode) {
      print("ssajas0 ${jsonData}");
    }

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
        print("ssajas3 ${collectionItem['date_or_month']}");
        DateTime date = DateTime.parse(collectionItem['date_or_month']);
        if (collectionItem['date_or_month'] != null) {
          //   if (date.month == currentMonth && date.year == currentYear) {
          int dayOfMonth = date.day;
          String collectionType = collectionItem["quote_type"];
          double premium =
              double.parse((collectionItem["total_amount"] ?? "0").toString());

          dailySales[dayOfMonth]!.update(
              collectionType, (value) => value + premium,
              ifAbsent: () => premium);
        }
        //  }
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
          case 'total':
            color = Colors.blue;
            break;
          case 'accepted':
            color = Colors.purple;
            break;
          case 'quoted':
            color = Colors.grey;
            break;
          case 'declined':
            color = Colors.green;
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

  List<BarChartGroupData> processDataForCollectionsCountMonthly(
      List<dynamic> jsonData,
      String startDate,
      String endDate,
      BuildContext context) {
    print("aaxdss $startDate $endDate ${jsonData} ");

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
            String collectionType = collectionItem["quote_type"];
            double premium = double.parse(
                (collectionItem["total_amount"] ?? "0.0").toString());

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
          case 'total':
            color = Colors.blue;
            break;
          case 'accepted':
            color = Colors.purple;
            break;
          case 'quoted':
            color = Colors.grey;
            break;
          case 'declined':
            color = Colors.green;
            break;
          default:
            color = Colors.grey;
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
        barsSpace: barsSpace + 2,
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
          String collectionType = collectionItem["quote_type"];
          double premium = collectionItem["collected_premium"];

          dailySales[dayIndex]!.update(
              collectionType, (value) => value + premium,
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
          case 'total':
            color = Colors.blue;
            break;
          case 'accepted':
            color = Colors.purple;
            break;
          case 'quoted':
            color = Colors.grey;
            break;
          case 'declined':
            color = Colors.green;
            break;
          default:
            color = Colors.grey;
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
      String jsonString,
      String startDate,
      String endDate,
      BuildContext context) {
    // print("gjhjhj $jsonString");
    List<dynamic> jsonData = jsonDecode(jsonString)["result_lista"];
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
          String collectionType = collectionItem["quote_type"];
          double premium =
              double.parse((collectionItem["total_amount"] ?? "0").toString());

          dailySales[dayIndex]!.update(
              collectionType, (value) => value + premium,
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
          case 'total':
            color = Colors.blue;
            break;
          case 'accepted':
            color = Colors.purple;
            break;
          case 'quoted':
            color = Colors.grey;
            break;
          case 'declined':
            color = Colors.green;
            break;
          default:
            color = Colors.grey;
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

  List<BarChartGroupData> processDataForCollectionsCountMonthly4(
      String jsonString,
      String startDate,
      String endDate,
      BuildContext context) {
    print("aaxdjyjhss $jsonString");
    List<dynamic> jsonData = jsonDecode(jsonString)["result_lista"];

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
          String collectionType = collectionItem["quote_type"];
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
          case 'total':
            color = Colors.blue;
            break;
          case 'accepted':
            color = Colors.purple;
            break;
          case 'quoted':
            color = Colors.grey;
            break;
          case 'declined':
            color = Colors.green;
            break;
          default:
            color = Colors.grey;
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
}

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

String extractFirstAndLastName(String fullName) {
  RegExp regex = RegExp(r'^(\S+)\s+([^\s]+)\s+(\S+)+(\S+)$');
  Match? match = regex.firstMatch(fullName);
  if (match != null) {
    return '${match.group(1)} ${match.group(3)}';
  } else {
    return fullName;
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

class HourlyLeadsOverviewTypeGrid extends StatelessWidget {
  final List<MemberTypGridItem> spotsTypes = [
    MemberTypGridItem('Submitted', Colors.grey),
    MemberTypGridItem('Captured', Colors.green),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (MemberTypGridItem item in spotsTypes)
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 4,
                        width: 16,
                        decoration: BoxDecoration(
                            color: item.color,
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      SizedBox(width: 8),
                      Text(item.type, style: TextStyle(fontSize: 12)),
                      SizedBox(width: 8),
                    ],
                  ),
                )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Hours of the day",
            style: TextStyle(fontSize: 9),
          ),
        ],
      ),
    );
  }
}

class LeadsOverviewTypeGrid extends StatelessWidget {
  final List<MemberTypGridItem> spotsTypes = [
    MemberTypGridItem('Submitted', Colors.grey),
    MemberTypGridItem('Captured', Colors.green),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (MemberTypGridItem item in spotsTypes)
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 4,
                    width: 20,
                    decoration: BoxDecoration(
                        color: item.color,
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  SizedBox(width: 8),
                  Text(item.type, style: TextStyle(fontSize: 12)),
                  SizedBox(width: 8),
                ],
              ),
            )
        ],
      ),
    );
  }
}
