import 'dart:math';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mi_insights/services/inactivitylogoutmixin.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../admin/ClientSearchPage.dart';
import '../../../constants/Constants.dart';
import '../../../customwidgets/BellCurveChart.dart' as bc;
import '../../../customwidgets/BellCurveChart.dart';
import '../../../customwidgets/CustomCard.dart';
import '../../../customwidgets/custom_date_range_picker.dart';
import '../../../models/CustomerProfile.dart';
import '../../../services/Executive/customers_service.dart';
import '../../../services/MyNoyifier.dart';

int grid_index = 0;
int grid_index_2 = 0;
int grid_index_3 = 0;
int grid_index_6 = 0;
int target_index = 0;
int target_index_2 = 0;
int target_index_7 = 0;
int noOfDaysThisMonth = 30;
bool isCustomerDataLoading1a = false;
bool isCustomerDataLoading2a = false;
bool isCustomerDataLoading3a = false;
bool isCustomerDataLoading3b = false;
Map<String, dynamic> sales_jsonResponse1a = {};
Map<String, dynamic> sales_jsonResponse2a = {};
Map<String, dynamic> sales_jsonResponse3a = {};
Map<String, dynamic> sales_jsonResponse4a = {};
List<BarChartGroupData> sales_barChartData1 = [];
List<BarChartGroupData> sales_barChartData2 = [];
List<BarChartGroupData> sales_barChartData3 = [];
List<BarChartGroupData> sales_barChartData4 = [];
final customersReportValue = ValueNotifier<int>(0);
MyNotifier? myNotifier;
DateTime datefrom = DateTime.now().subtract(Duration(days: 60));
DateTime dateto = DateTime.now();
int days_difference = 0;
Widget wdg1 = Container();
int report_index = 0;
int customers_index = 0;
String data2 = "";
Key kyrt = UniqueKey();
int touchedIndex = -1;
double _sliderPosition = 0.0;
double _sliderPosition2 = 0.0;
double _sliderPosition3 = 0.0;
double _sliderPosition4 = 0.0;
double _sliderPosition5 = 0.0;
double _sliderPosition6 = 0.0;
double _sliderPosition7 = 0.0;

class CustomersReport extends StatefulWidget {
  const CustomersReport({super.key});
  @override
  State<CustomersReport> createState() => _CustomersReportState();
}

int _selectedButton = 1;
bool isSameDaysRange = true;

class _CustomersReportState extends State<CustomersReport>
    with InactivityLogoutMixin {
  Color _button1Color = Colors.grey.withOpacity(0.0);
  Color _button2Color = Colors.grey.withOpacity(0.0);
  Color _button3Color = Colors.grey.withOpacity(0.0);
  int currentLevel = 0;
  void _animateButton(int buttonNumber) {
    restartInactivityTimer();
    DateTime? startDate = DateTime.now();
    DateTime? endDate = DateTime.now();

    setState(() {});

    if (kDebugMode) {
      if (kDebugMode) {
        print("jhhh $buttonNumber");
      }
    }

    _selectedButton = buttonNumber;
    if (buttonNumber == 1) {
      _sliderPosition = 0.0;
    } else if (buttonNumber == 2) {
      _sliderPosition = (MediaQuery.of(context).size.width / 3) - 18;
    } else if (buttonNumber == 3) {
      isCustomerDataLoading3a = true;

      _sliderPosition = 2 * (MediaQuery.of(context).size.width / 3) - 32;
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

        // Update slider position based on the button tapped
      });
      DateTime now = DateTime.now();

      // Set loading state
      if (buttonNumber == 1) {
        isCustomerDataLoading1a = true;
      } else if (buttonNumber == 2) {
        isCustomerDataLoading2a = true;
      }

      // Set date ranges based on button selection
      if (buttonNumber == 1) {
        // 1 Month View - current month
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime.now();
      } else if (buttonNumber == 2) {
        // 12 Months View - last 12 months
        startDate = DateTime(now.year - 1, now.month, now.day);
        endDate = DateTime.now();
      }

      // Format dates and calculate days difference
      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate!);
      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate!);
      days_difference = endDate.difference(startDate).inDays;

      // Update Constants
      Constants.sales_formattedStartDate = formattedStartDate;
      Constants.sales_formattedEndDate = formattedEndDate;

      // Call getExecutiveCustomersReport
      getExecutiveCustomersReport(formattedStartDate, formattedEndDate,
              buttonNumber, days_difference, context)
          .then((value) {
        kyrt = UniqueKey();
        if (mounted)
          setState(() {
            if (buttonNumber == 1) {
              isCustomerDataLoading1a = false;
            } else if (buttonNumber == 2) {
              isCustomerDataLoading2a = false;
            }
          });
      }).catchError((error) {
        if (kDebugMode) {
          print(
              "❌ Error in _animateButton getExecutiveCustomersReport: $error");
        }
        if (mounted)
          setState(() {
            if (buttonNumber == 1) {
              isCustomerDataLoading1a = false;
            } else if (buttonNumber == 2) {
              isCustomerDataLoading2a = false;
            }
          });
      });

      setState(() {});
    } else {
      showCustomDateRangePicker(
        context,
        dismissible: true,
        minimumDate: DateTime.utc(2023, 06, 01),
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

          isCustomerDataLoading3a = true;

          customersReportValue.value++;
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

          getExecutiveCustomersReport(Constants.sales_formattedStartDate,
                  Constants.sales_formattedEndDate, 3, days_difference, context)
              .then((value) {
            kyrt = UniqueKey();
            setState(() {});
          });
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

  void _animateButton4(int buttonNumber) {
    restartInactivityTimer();

    setState(() {
      grid_index = buttonNumber;
      if (buttonNumber == 0) {
        _sliderPosition4 = 0.0;
      } else if (buttonNumber == 1) {
        _sliderPosition4 = (MediaQuery.of(context).size.width / 4) - 24;
      } else if (buttonNumber == 2) {
        _sliderPosition4 = 2 * (MediaQuery.of(context).size.width / 4) - 32;
      } else if (buttonNumber == 3) {
        // Added case for button 3
        _sliderPosition4 = 3 * (MediaQuery.of(context).size.width / 4) - 32;
      }
    });
  }

  void _animateButton6(int buttonNumber) {
    setState(() {});

    if (buttonNumber == 0) {
      _sliderPosition6 = 0.0;
    } else if (buttonNumber == 1) {
      _sliderPosition6 = (MediaQuery.of(context).size.width / 4) - 18;
    } else if (buttonNumber == 2) {
      _sliderPosition6 = 2 * (MediaQuery.of(context).size.width / 4) - 32;
    } else if (buttonNumber == 3) {
      _sliderPosition6 = 3 * (MediaQuery.of(context).size.width / 4) - 32;
    }
    grid_index_6 = buttonNumber;
    setState(() {});
    restartInactivityTimer();
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

  void _animateButton7(int buttonNumber) {
    restartInactivityTimer();

    setState(() {});

    target_index_7 = buttonNumber;
    if (buttonNumber == 0) {
      _sliderPosition7 = 0.0;
    } else if (buttonNumber == 1) {
      _sliderPosition7 = (MediaQuery.of(context).size.width / 2) - 18;
    } else if (buttonNumber == 3) {
      if (days_difference < 31) {
        _sliderPosition7 = 2 * (MediaQuery.of(context).size.width / 3) - 32;
      }
      setState(() {});
    }
  }

  void _animateButton3(int buttonNumber) {
    restartInactivityTimer();

    setState(() {});

    grid_index_3 = buttonNumber;
    if (buttonNumber == 0) {
      _sliderPosition3 = 0.0;
    } else if (buttonNumber == 1) {
      _sliderPosition3 = (MediaQuery.of(context).size.width / 3) - 18;
    } else if (buttonNumber == 2) {
      _sliderPosition3 = 2 * (MediaQuery.of(context).size.width / 3) - 32;
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
              elevation: 6,
              leading: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  )),
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
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shadowColor: Colors.black.withOpacity(0.3),
              centerTitle: true,
              title: const Text(
                "Customer Profile",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              )),
          body: Container(
              color: Colors.white,
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
                      height: 12,
                    ),
                    if (isCustomerDataLoading1a)
                      SizedBox(
                        height: 12,
                      ),
                    _selectedButton == 1 && isCustomerDataLoading1a == true
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
                    _selectedButton == 2 && isCustomerDataLoading2a == true
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
                    _selectedButton == 3 && isCustomerDataLoading3a == true
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
                                                BorderRadius.circular(360)),
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
                                                BorderRadius.circular(360)),
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
                                    GestureDetector(
                                      onTap: () {
                                        _animateButton(3);
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
                              child: InkWell(
                                onTap: () {
                                  _animateButton(3);
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
                                            style:
                                                TextStyle(color: Colors.white),
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
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20, top: 12),
                      child: Container(
                        height: 1,
                        color: Colors.grey.withOpacity(0.35),
                      ),
                    ),
                    SizedBox(height: 18),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16.0, right: 16, top: 0),
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
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _animateButton4(0);
                                      },
                                      child: Container(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    4) -
                                                12,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(360)),
                                        height: 35,
                                        child: Center(
                                          child: Text(
                                            'Main',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _animateButton4(1);
                                      },
                                      child: Container(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    4) -
                                                12,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(360)),
                                        child: Center(
                                          child: Text(
                                            'All Lives',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _animateButton4(2);
                                      },
                                      child: Container(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    4) -
                                                12,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(360)),
                                        child: Center(
                                          child: Text(
                                            'Dependants',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _animateButton4(
                                            3); // Corrected to button 3
                                      },
                                      child: Container(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    4) -
                                                12,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(360)),
                                        child: Center(
                                          child: Text(
                                            'Spouse',
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
                              left: _sliderPosition4,
                              child: InkWell(
                                onTap: () {
                                  _animateButton4(2);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Constants
                                        .ctaColorLight, // Color of the slider
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      grid_index == 0
                                          ? 'Main'
                                          : grid_index == 1
                                              ? 'All Lives'
                                              : grid_index == 2
                                                  ? 'Dependants'
                                                  : 'Spouse',
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
                    SizedBox(height: 24),
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
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    2) -
                                                16,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(360)),
                                        height: 35,
                                        child: Center(
                                          child: Text(
                                            'Sales Demographics',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _animateButton2(1);
                                      },
                                      child: Container(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    2) -
                                                16,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(360)),
                                        child: Center(
                                          child: Text(
                                            'Claims Demographics',
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
                                    width: (MediaQuery.of(context).size.width /
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
                                              'Sales Demographics',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : target_index == 1
                                            ? Center(
                                                child: Text(
                                                  'Claims Demographics',
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
                    SizedBox(height: 8),
                    Expanded(
                        child: Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (target_index == 0)
                              Padding(
                                padding: const EdgeInsets.all(16.0),
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
                                                      2.3)),
                                  itemCount: _selectedButton == 1
                                      ? Constants
                                          .customers_sectionsList1a_1_1.length
                                      : _selectedButton == 2
                                          ? Constants
                                              .customers_sectionsList2a_1_1
                                              .length
                                          : _selectedButton == 3
                                              ? Constants
                                                  .customers_sectionsList3a_1_1
                                                  .length
                                              : 0,
                                  padding: EdgeInsets.all(2.0),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                        onTap: () {},
                                        child: Container(
                                          height: 290,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.9,
                                          child: Stack(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  customers_index = index;
                                                  setState(() {});
                                                  if (kDebugMode) {
                                                    print(
                                                        "customers_indexjkjjk " +
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
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                                    color: customers_index ==
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
                                                                        BorderRadius.circular(
                                                                            8)),
                                                                child:
                                                                    Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(14),
                                                                        ),
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        height:
                                                                            270,
                                                                        /*     decoration: BoxDecoration(
                                                            color:Colors.white,
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                8),
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey.withOpacity(0.2))),*/
                                                                        margin: EdgeInsets.only(
                                                                            right:
                                                                                0,
                                                                            left:
                                                                                0,
                                                                            bottom:
                                                                                4),
                                                                        child:
                                                                            Column(
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
                                                                                          ? grid_index == 1
                                                                                              ? Constants.customers_sectionsList1a_1_1[index].amount
                                                                                              : grid_index == 0
                                                                                                  ? Constants.customers_sectionsList1a_1_2[index].amount
                                                                                                  : grid_index == 2
                                                                                                      ? Constants.customers_sectionsList1a_1_3[index].amount
                                                                                                      : Constants.customers_sectionsList1a_1_4[index].amount
                                                                                          : _selectedButton == 2
                                                                                              ? grid_index == 1
                                                                                                  ? Constants.customers_sectionsList2a_1_1[index].amount
                                                                                                  : grid_index == 0
                                                                                                      ? Constants.customers_sectionsList2a_1_2[index].amount
                                                                                                      : grid_index == 2
                                                                                                          ? Constants.customers_sectionsList2a_1_3[index].amount
                                                                                                          : Constants.customers_sectionsList2a_1_4[index].amount
                                                                                              : _selectedButton == 3
                                                                                                  ? grid_index == 1
                                                                                                      ? Constants.customers_sectionsList3a_1_1[index].amount
                                                                                                      : grid_index == 0
                                                                                                          ? Constants.customers_sectionsList3a_1_2[index].amount
                                                                                                          : grid_index == 2
                                                                                                              ? Constants.customers_sectionsList3a_1_3[index].amount
                                                                                                              : Constants.customers_sectionsList3a_1_4[index].amount
                                                                                                  : 0)
                                                                                      .toString()),
                                                                                  style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
                                                                                  textAlign: TextAlign.center,
                                                                                  maxLines: 2,
                                                                                ),
                                                                              )),
                                                                            ),
                                                                            Center(
                                                                                child: Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text(
                                                                                _selectedButton == 1
                                                                                    ? Constants.customers_sectionsList1a_1_1[index].id
                                                                                    : _selectedButton == 2
                                                                                        ? Constants.customers_sectionsList2a_1_1[index].id
                                                                                        : _selectedButton == 3
                                                                                            ? Constants.customers_sectionsList3a_1_1[index].id
                                                                                            : "",
                                                                                style: TextStyle(fontSize: 12.5),
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
                            if (target_index == 1)
                              Padding(
                                padding: const EdgeInsets.all(16.0),
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
                                                      2.3)),
                                  itemCount: _selectedButton == 1
                                      ? Constants
                                          .customers_claims_sectionsList1a_1_1
                                          .length
                                      : _selectedButton == 2
                                          ? Constants
                                              .customers_claims_sectionsList2a_1_1
                                              .length
                                          : _selectedButton == 3
                                              ? Constants
                                                  .customers_claims_sectionsList3a_1_1
                                                  .length
                                              : 0,
                                  padding: EdgeInsets.all(2.0),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                        onTap: () {},
                                        child: Container(
                                          height: 290,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.9,
                                          child: Stack(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  customers_index = index;
                                                  setState(() {});
                                                  if (kDebugMode) {
                                                    print(
                                                        "customers_claims_indexjkjjk " +
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
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                                    color: customers_index ==
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
                                                                        BorderRadius.circular(
                                                                            8)),
                                                                child:
                                                                    Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(14),
                                                                        ),
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        height:
                                                                            270,
                                                                        /*     decoration: BoxDecoration(
                                                            color:Colors.white,
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                8),
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey.withOpacity(0.2))),*/
                                                                        margin: EdgeInsets.only(
                                                                            right:
                                                                                0,
                                                                            left:
                                                                                0,
                                                                            bottom:
                                                                                4),
                                                                        child:
                                                                            Column(
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
                                                                                          ? grid_index == 1
                                                                                              ? Constants.customers_claims_sectionsList1a_1_1[index].amount
                                                                                              : grid_index == 0
                                                                                                  ? Constants.customers_claims_sectionsList1a_1_2[index].amount
                                                                                                  : grid_index == 2
                                                                                                      ? Constants.customers_claims_sectionsList1a_1_3[index].amount
                                                                                                      : Constants.customers_claims_sectionsList1a_1_4[index].amount
                                                                                          : _selectedButton == 2
                                                                                              ? grid_index == 1
                                                                                                  ? Constants.customers_claims_sectionsList2a_1_1[index].amount
                                                                                                  : grid_index == 0
                                                                                                      ? Constants.customers_claims_sectionsList2a_1_2[index].amount
                                                                                                      : grid_index == 2
                                                                                                          ? Constants.customers_claims_sectionsList2a_1_3[index].amount
                                                                                                          : Constants.customers_claims_sectionsList2a_1_4[index].amount
                                                                                              : _selectedButton == 3
                                                                                                  ? grid_index == 1
                                                                                                      ? Constants.customers_claims_sectionsList3a_1_1[index].amount
                                                                                                      : grid_index == 0
                                                                                                          ? Constants.customers_claims_sectionsList3a_1_2[index].amount
                                                                                                          : grid_index == 2
                                                                                                              ? Constants.customers_claims_sectionsList3a_1_3[index].amount
                                                                                                              : Constants.customers_claims_sectionsList3a_1_4[index].amount
                                                                                                  : 0)
                                                                                      .toString()),
                                                                                  style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
                                                                                  textAlign: TextAlign.center,
                                                                                  maxLines: 2,
                                                                                ),
                                                                              )),
                                                                            ),
                                                                            Center(
                                                                                child: Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text(
                                                                                _selectedButton == 1
                                                                                    ? Constants.customers_claims_sectionsList1a_1_1[index].id
                                                                                    : _selectedButton == 2
                                                                                        ? Constants.customers_claims_sectionsList2a_1_1[index].id
                                                                                        : _selectedButton == 3
                                                                                            ? Constants.customers_claims_sectionsList3a_1_1[index].id
                                                                                            : "",
                                                                                style: TextStyle(fontSize: 12.5),
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
                            SizedBox(
                              height: 0,
                            ),
                            SizedBox(height: 8),
                            _selectedButton == 1
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
                                                "Customer Satisfaction (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
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
                                              padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  right: 16,
                                                  bottom: 8),
                                              child: Text(
                                                  "Customer Satisfaction (12 Months View)"),
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
                                                padding: const EdgeInsets.only(
                                                    left: 16.0,
                                                    right: 16,
                                                    bottom: 8),
                                                child: Text(
                                                    "Customer Satisfaction (${Constants.sales_formattedStartDate} to ${Constants.sales_formattedEndDate})"),
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
                              padding:
                                  const EdgeInsets.only(left: 6.0, right: 6),
                              child: LinearPercentIndicator(
                                width: MediaQuery.of(context).size.width - 12,
                                animation: true,
                                lineHeight: 20.0,
                                animationDuration: 500,
                                percent: 0.0,
                                center: Text("${(0.0).toStringAsFixed(1)}%"),
                                barRadius: ui.Radius.circular(12),
                                //linearStrokeCap: LinearStrokeCap.roundAll,
                                progressColor: Colors.green,
                              ),
                            ),
                            SizedBox(height: 24),
                            _selectedButton == 1
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                              "Demographics on Gender (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                        ),
                                      ],
                                    ),
                                  )
                                : _selectedButton == 2
                                    ? Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0),
                                            child: Text(
                                                "Demographics on Gender (12 Months View)"),
                                          ),
                                          Spacer(),
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
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Text(
                                            "Demographics on Gender (${Constants.sales_formattedStartDate} to ${Constants.sales_formattedEndDate})"),
                                      ),
                            (_selectedButton == 1 &&
                                        isCustomerDataLoading1a == true ||
                                    _selectedButton == 2 &&
                                        isCustomerDataLoading2a == true ||
                                    _selectedButton == 3 &&
                                        isCustomerDataLoading3a == true)
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0,
                                        top: 12,
                                        right: 16,
                                        bottom: 12),
                                    child: CustomCard(
                                        elevation: 6,
                                        surfaceTintColor: Colors.white,
                                        color: Colors.white,
                                        child: Container(
                                            height: 300,
                                            child: Center(
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
                                            )))),
                                  )
                                : Container(
                                    height: 300,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12.0,
                                          top: 8,
                                          right: 16,
                                          bottom: 12),
                                      child: CustomCard(
                                        surfaceTintColor: Colors.white,
                                        color: Colors.white,
                                        elevation: 6,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 24,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 2.0),
                                                        child: Text(
                                                          target_index == 0
                                                              ? ((getCustomerPercentage(
                                                                              "male")) *
                                                                          100)
                                                                      .toStringAsFixed(
                                                                          1) +
                                                                  "%"
                                                              : ((getCustomerClaimsPercentage(
                                                                              "male")) *
                                                                          100)
                                                                      .toStringAsFixed(
                                                                          1) +
                                                                  "%",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 0.0),
                                                        child: Center(
                                                          child: Text(
                                                            "Male",
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 8,
                                                            right: 8,
                                                            top: 4,
                                                            bottom: 4),
                                                        height: 1,
                                                        color: Colors.lightBlue,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 0.0),
                                                        child: Text(
                                                          target_index == 0
                                                              ? getCustomerCount(
                                                                          "male")
                                                                      .toString() +
                                                                  " lives"
                                                              : getCustomerClaimCount(
                                                                          "male")
                                                                      .toString() +
                                                                  " lives",
                                                          style: TextStyle(
                                                              fontSize: 11),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    width: 200,
                                                    height: 230,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(height: 15),
                                                        Container(
                                                          height: 30,
                                                          width: 30,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 3),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.6),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        360),
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Stack(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            children: [
                                                              SvgPicture.asset(
                                                                'assets/icons/man-toilet-color-icon.svg',
                                                                width: 200,
                                                                height: 170,
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.6),
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                              ClipPath(
                                                                clipper:
                                                                    CustomClipPath(
                                                                  percentage: double.parse(target_index ==
                                                                          0
                                                                      ? getCustomerPercentage(
                                                                              "male")
                                                                          .toStringAsFixed(
                                                                              3)
                                                                      : getCustomerClaimsPercentage(
                                                                              "male")
                                                                          .toStringAsFixed(
                                                                              3)),
                                                                ),
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  'assets/icons/man-toilet-color-icon.svg',
                                                                  color: Colors
                                                                      .lightBlue,
                                                                  width: 200,
                                                                  height: 170,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    width: 200,
                                                    height: 230,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(height: 17),
                                                        Container(
                                                          height: 30,
                                                          width: 30,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 3),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.6),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        360),
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Stack(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            children: [
                                                              SvgPicture.asset(
                                                                'assets/icons/women-toilet-color-icon.svg',
                                                                width: 200,
                                                                height: 170,
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.6),
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                              ClipPath(
                                                                clipper:
                                                                    CustomClipPath(
                                                                  percentage: double.parse(target_index ==
                                                                          0
                                                                      ? getCustomerPercentage(
                                                                              "female")
                                                                          .toStringAsFixed(
                                                                              3)
                                                                      : getCustomerClaimsPercentage(
                                                                              "female")
                                                                          .toStringAsFixed(
                                                                              3)),
                                                                ),
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  'assets/icons/women-toilet-color-icon.svg',
                                                                  color: Colors
                                                                      .green,
                                                                  width: 200,
                                                                  height: 170,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 2.0),
                                                        child: Text(
                                                          target_index == 0
                                                              ? (getCustomerPercentage(
                                                                              "female") *
                                                                          100)
                                                                      .toStringAsFixed(
                                                                          1) +
                                                                  "%"
                                                              : (getCustomerClaimsPercentage(
                                                                              "female") *
                                                                          100)
                                                                      .toStringAsFixed(
                                                                          1) +
                                                                  "%",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 0.0),
                                                        child: Center(
                                                          child: Text(
                                                            "Female",
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 8,
                                                            right: 8,
                                                            top: 4,
                                                            bottom: 4),
                                                        height: 1,
                                                        color: Colors.green,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 0.0),
                                                        child: Text(
                                                          "${target_index == 0 ? formatLargeNumber((getCustomerCount("female")).toStringAsFixed(1)) : formatLargeNumber((getCustomerClaimCount("female")).toStringAsFixed(1))} lives",
                                                          style: TextStyle(
                                                              fontSize: 11),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              height: 20,
                            ),
                            _selectedButton == 1
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                              "Age Distribution By Gender (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                        ),
                                      ],
                                    ),
                                  )
                                : _selectedButton == 2
                                    ? Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0),
                                            child: Text(
                                                "Age Distribution By Gender (12 Months View)"),
                                          ),
                                          Spacer(),
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
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Text(
                                            "Age Distribution By Gender(${Constants.sales_formattedStartDate} to ${Constants.sales_formattedEndDate})"),
                                      ),
                            bc.SalesBellCurveChart(
                              customersIndex:
                                  customers_index, // 0=total, 1=enforced, 2=not_enforced
                              selectedButton:
                                  _selectedButton, // 1=MTD, 2=12months, 3=custom
                              daysDifference: days_difference,
                              targetIndex7: target_index_7, // 0=line, 1=bar
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            target_index == 0
                                ? _selectedButton == 1
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                  "Age Distribution By Member Type (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                            ),
                                          ],
                                        ),
                                      )
                                    : _selectedButton == 2
                                        ? Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: Text(
                                                    "Age Distribution By Member Type (12 Months View)"),
                                              ),
                                              Spacer(),
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
                                                left: 16.0),
                                            child: Text(
                                                "Age Distribution By Member Type (${Constants.sales_formattedStartDate} to ${Constants.sales_formattedEndDate})"),
                                          )
                                : _selectedButton == 1
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                  "Age Distribution on Claims  (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                            ),
                                          ],
                                        ),
                                      )
                                    : _selectedButton == 2
                                        ? Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: Text(
                                                    "Age Distribution on Claims  (12 Months View)"),
                                              ),
                                              Spacer(),
                                            ],
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0),
                                            child: Text(
                                                "Age Distribution on Claims  (${Constants.sales_formattedStartDate} to ${Constants.sales_formattedEndDate})"),
                                          ),
                            SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12.0, right: 12),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.10),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Center(
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                _animateButton7(0);
                                              },
                                              child: Container(
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2) -
                                                    16,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            360)),
                                                height: 35,
                                                child: Center(
                                                  child: Text(
                                                    'Age Distr - Bell Curve',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _animateButton7(1);
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
                                                        BorderRadius.circular(
                                                            360)),
                                                child: Center(
                                                  child: Text(
                                                    'Age Distr - Age Counts',
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
                                      left: _sliderPosition7,
                                      child: InkWell(
                                        onTap: () {
                                          // _animateButton2(3);
                                        },
                                        child: Container(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2) -
                                                8,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: Constants
                                                  .ctaColorLight, // Color of the slider
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: target_index_7 == 0
                                                ? Center(
                                                    child: Text(
                                                      'Age Distr - Bell Curve',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  )
                                                : target_index_7 == 1
                                                    ? Center(
                                                        child: Text(
                                                          'Age Distr - Age Counts',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      )
                                                    : Container()),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, right: 16, top: 0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.10),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Center(
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                _animateButton6(0);
                                              },
                                              child: Container(
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        4) -
                                                    12,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            360)),
                                                height: 35,
                                                child: Center(
                                                  child: Text(
                                                    'All',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _animateButton6(1);
                                              },
                                              child: Container(
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        4) -
                                                    12,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            360)),
                                                child: Center(
                                                  child: Text(
                                                    'Main',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _animateButton6(2);
                                              },
                                              child: Container(
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        4) -
                                                    12,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            360)),
                                                child: Center(
                                                  child: Text(
                                                    'Partner',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _animateButton6(3);
                                              },
                                              child: Container(
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        4) -
                                                    12,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            360)),
                                                child: Center(
                                                  child: Text(
                                                    'Child',
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
                                      left: _sliderPosition6,
                                      child: InkWell(
                                        onTap: () {
                                          //   _animateButton6(2);
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            color: Constants
                                                .ctaColorLight, // Color of the slider
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: grid_index_6 == 0
                                              ? Center(
                                                  child: Text(
                                                    'All',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              : grid_index_6 == 1
                                                  ? Center(
                                                      child: Text(
                                                        'Main',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )
                                                  : grid_index_6 == 2
                                                      ? Center(
                                                          child: Text(
                                                            'Partner',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                      : Center(
                                                          child: Text(
                                                            'Child',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            (_selectedButton == 1 &&
                                        isCustomerDataLoading1a == true ||
                                    _selectedButton == 2 &&
                                        isCustomerDataLoading2a == true ||
                                    _selectedButton == 3 &&
                                        isCustomerDataLoading3a == true)
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0,
                                        top: 12,
                                        right: 16,
                                        bottom: 12),
                                    child: CustomCard(
                                        elevation: 6,
                                        surfaceTintColor: Colors.white,
                                        color: Colors.white,
                                        child: Container(
                                            height: 380,
                                            child: Center(
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
                                            )))),
                                  )
                                : target_index == 0
                                    ? grid_index_6 == 0
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0,
                                                top: 12,
                                                right: 16,
                                                bottom: 12),
                                            child: CustomCard(
                                              elevation: 6,
                                              surfaceTintColor: Colors.white,
                                              color: Colors.white,
                                              child: Container(
                                                  height: 380,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 14.0),
                                                    child:
                                                        bc.SalesBellCurveChart(
                                                            selectedButton:
                                                                _selectedButton,
                                                            daysDifference:
                                                                days_difference,
                                                            customersIndex:
                                                                customers_index,
                                                            targetIndex7:
                                                                target_index_7),
                                                  )),
                                            ),
                                          )
                                        : grid_index_6 == 1
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: CustomCard(
                                                  elevation: 6,
                                                  surfaceTintColor:
                                                      Colors.white,
                                                  color: Colors.white,
                                                  child: Container(
                                                      height: 380,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 16.0),
                                                        child: bc.AgesDistMainBellCurveChart(
                                                            Selected_Button:
                                                                _selectedButton,
                                                            days_difference:
                                                                days_difference,
                                                            customers_index:
                                                                customers_index,
                                                            target_index_7:
                                                                target_index_7),
                                                      )),
                                                ),
                                              )
                                            : grid_index_6 == 2
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: CustomCard(
                                                      elevation: 6,
                                                      surfaceTintColor:
                                                          Colors.white,
                                                      color: Colors.white,
                                                      child: Container(
                                                          height: 380,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 14.0),
                                                            child: bc.AgesDistPartnerBellCurveChart(
                                                                Selected_Button:
                                                                    _selectedButton,
                                                                days_difference:
                                                                    days_difference,
                                                                customers_index:
                                                                    customers_index,
                                                                target_index_7:
                                                                    target_index_7),
                                                          )),
                                                    ),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: CustomCard(
                                                      elevation: 6,
                                                      surfaceTintColor:
                                                          Colors.white,
                                                      color: Colors.white,
                                                      child: Container(
                                                          height: 380,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 14.0),
                                                            child: bc.AgesDistChildBellCurveChart(
                                                                Selected_Button:
                                                                    _selectedButton,
                                                                days_difference:
                                                                    days_difference,
                                                                customers_index:
                                                                    customers_index,
                                                                target_index_7:
                                                                    target_index_7),
                                                          )),
                                                    ),
                                                  )
                                    : grid_index_6 == 0
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0,
                                                top: 12,
                                                right: 16,
                                                bottom: 12),
                                            child: CustomCard(
                                              elevation: 6,
                                              surfaceTintColor: Colors.white,
                                              color: Colors.white,
                                              child: Container(
                                                  height: 380,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 14.0),
                                                    child:
                                                        bc.ClaimsBellCurveChart(
                                                            Selected_Button:
                                                                _selectedButton,
                                                            days_difference:
                                                                days_difference,
                                                            customers_index:
                                                                customers_index,
                                                            target_index_7:
                                                                target_index_7),
                                                  )),
                                            ),
                                          )
                                        : grid_index_6 == 1
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: CustomCard(
                                                  elevation: 6,
                                                  surfaceTintColor:
                                                      Colors.white,
                                                  color: Colors.white,
                                                  child: Container(
                                                      height: 380,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 16.0),
                                                        child: bc.ClaimsAgesDistMainBellCurveChart(
                                                            Selected_Button:
                                                                _selectedButton,
                                                            days_difference:
                                                                days_difference,
                                                            customers_index:
                                                                customers_index,
                                                            target_index_7:
                                                                target_index_7),
                                                      )),
                                                ),
                                              )
                                            : grid_index_6 == 2
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: CustomCard(
                                                      elevation: 6,
                                                      surfaceTintColor:
                                                          Colors.white,
                                                      color: Colors.white,
                                                      child: Container(
                                                          height: 380,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 14.0),
                                                            child: bc.ClaimsAgesDistPartnerBellCurveChart(
                                                                Selected_Button:
                                                                    _selectedButton,
                                                                days_difference:
                                                                    days_difference,
                                                                customers_index:
                                                                    customers_index,
                                                                target_index_7:
                                                                    target_index_7),
                                                          )),
                                                    ),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: CustomCard(
                                                      elevation: 6,
                                                      surfaceTintColor:
                                                          Colors.white,
                                                      color: Colors.white,
                                                      child: Container(
                                                          height: 380,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 14.0),
                                                            child: bc.ClaimsAgesDistChildBellCurveChart(
                                                                Selected_Button:
                                                                    _selectedButton,
                                                                days_difference:
                                                                    days_difference,
                                                                customers_index:
                                                                    customers_index,
                                                                target_index_7:
                                                                    target_index_7),
                                                          )),
                                                    ),
                                                  ),
                            SizedBox(
                              height: 55,
                            ),
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
              )),
        ));
  }

  @override
  void initState() {
    super.initState();
    myNotifier = MyNotifier(customersReportValue, context);
    customersReportValue.addListener(() {
      kyrt = UniqueKey();

      if (mounted) setState(() {});
      Future.delayed(Duration(seconds: 2)).then((value) {
        //print("noOfDaysThisMonth $noOfDaysThisMonth");
        /*       Constants.sales_tree_key3a = UniqueKey();
        if (mounted) setState(() {});
*/
        print("ghjdfgjkjk_hg $_selectedButton");
      });
    });

    // Load initial data for 1 month view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateButton(1);
    });
  }
}

class CustomClipPath extends CustomClipper<Path> {
  final double percentage;

  CustomClipPath({required this.percentage});

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * (0.9 - percentage));
    path.lineTo(0, size.height * (0.9 - percentage));
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class CustomProgressBar extends StatelessWidget {
  final double percentage;

  const CustomProgressBar({Key? key, required this.percentage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the position for the line and text based on the percentage.
    final double fillHeight =
        200 * (1 - percentage); // If the SVG fills from the bottom to the top

    return Container(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment
            .bottomCenter, // Align stack to the bottom for the fill effect from bottom to top
        children: [
          SvgPicture.asset(
            'assets/icons/man-toilet-color-icon.svg',
            width: 200,
            height: 200,
            fit: BoxFit.cover,
            color: Colors.grey.withOpacity(0.6),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(
                'assets/icons/man-toilet-color-icon.svg',
                width: 200,
                height:
                    200 * percentage, // Adjust height according to percentage
                color: Colors.green,
              ),
            ),
          ),
          Positioned(
            top: fillHeight, // Position from the top of the stack
            left: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min, // To wrap content size
              children: [
                Container(
                  color: Colors.black, // Line color
                  width: 2, // Line width
                  height: 20, // Line height
                ),
                SizedBox(width: 4), // Spacing between line and text
                Text(
                  '${(percentage * 100).toStringAsFixed(1)}%', // Text to display
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
    return 'Invalid Number3';
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
    return 'Invalid Number1';
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

String formatWithCommas(double value) {
  final format = NumberFormat("#,##0", "en_US");
  return format.format(value);
}

class CollectionsTypeGrid extends StatelessWidget {
  final List<bc.CustomersTypGridItem> collectionTypes = [
    bc.CustomersTypGridItem('Cash', Colors.blue),
    bc.CustomersTypGridItem('D/0', Colors.orange),
    bc.CustomersTypGridItem('Persal', Colors.green),
    bc.CustomersTypGridItem('Sal. Ded.', Colors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24),
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
                    borderRadius: BorderRadius.circular(360),
                    color: collectionTypes[index].color,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  collectionTypes[index].type,
                  style: TextStyle(
                    fontSize: 11.0,
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

final themeMode = ValueNotifier(Brightness.light);

class PaymentProgressBar extends StatelessWidget {
  final List<Map<String, dynamic>> paymentTypeData;

  PaymentProgressBar({Key? key, required this.paymentTypeData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalPercentage = paymentTypeData.fold(
        0,
        (previousValue, element) =>
            previousValue +
            double.parse(((element['percentage'] ?? "0").toString())).round());
    final screenWidth = MediaQuery.of(context).size.width;

    // Assign a color to each payment type
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.red];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: Size(
              screenWidth, 30), // You can set the size to the size you want
          painter: _ProgressBarPainter(
              paymentTypeData, totalPercentage.toDouble(), colors, 18),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: paymentTypeData.map((data) {
            int index = paymentTypeData.indexOf(data);
            return Column(
              children: [
                Text('${data['count']}',
                    style: TextStyle(
                        color: colors[index % colors.length], fontSize: 11)),
                Text('${data['percentage'].toStringAsFixed(1)}%',
                    style: TextStyle(
                        color: colors[index % colors.length], fontSize: 8)),
                Text(data['payment_type'],
                    style: TextStyle(
                        color: colors[index % colors.length], fontSize: 7.5)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ProgressBarPainter extends CustomPainter {
  final List<Map<String, dynamic>> paymentTypeData;
  final double totalPercentage;
  final List<Color> colors;
  final double barHeight;

  _ProgressBarPainter(
      this.paymentTypeData, this.totalPercentage, this.colors, this.barHeight);

  @override
  void paint(Canvas canvas, Size size) {
    double startWidth = 0;
    Paint paint = Paint();
    Path arrowPath = Path();

    // Draw each segment and its arrow
    for (var i = 0; i < paymentTypeData.length; i++) {
      var data = paymentTypeData[i];
      double segmentWidth = size.width * (data['percentage'] / totalPercentage);

      // Set the color for the current segment
      paint.color = colors[i % colors.length];

      // Draw segment with increased height
      canvas.drawRect(
          Rect.fromLTWH(startWidth, 0, segmentWidth, barHeight), paint);

      // Adjust the arrow drawing to the increased height
      if (data['percentage'] > 0) {
        double arrowCenter =
            startWidth + segmentWidth / 2; // Center the arrow in the segment
        arrowPath = Path();
        arrowPath.moveTo(arrowCenter, barHeight);
        arrowPath.lineTo(arrowCenter - 5, barHeight + 10);
        arrowPath.lineTo(arrowCenter + 5, barHeight + 10);
        arrowPath.close();
        canvas.drawPath(arrowPath, paint);
      }

      // Update the starting width for the next segment
      startWidth += segmentWidth;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// Define a model for the pie chart slices
class PieChartSlice {
  final double value;
  final double radius;
  final Color color;

  PieChartSlice(
      {required this.value, required this.radius, required this.color});
}

// Custom painter for the variable radius pie chart
class VariableRadiusPieChartPainter extends CustomPainter {
  final List<PieChartSlice> slices;

  VariableRadiusPieChartPainter({required this.slices});

  @override
  void paint(Canvas canvas, Size size) {
    double startAngle = -pi / 2;
    final paint = Paint()..style = PaintingStyle.fill;

    for (var slice in slices) {
      final radius = slice.radius;
      final sweepAngle = (slice.value / 100) * 2 * pi;
      paint.color = slice.color;

      canvas.drawArc(
        Rect.fromCircle(center: size.center(Offset.zero), radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// Usage example in a widget
class VariableRadiusPieChart extends StatelessWidget {
  final List<PieChartSlice> slices;

  VariableRadiusPieChart({required this.slices});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(200, 200), // Choose your desired size
      painter: VariableRadiusPieChartPainter(slices: slices),
    );
  }
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
    return 'Invalid Number2';
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

class ClaimsReportGraph2 extends StatefulWidget {
  const ClaimsReportGraph2({super.key});

  @override
  State<ClaimsReportGraph2> createState() => _ClaimsReport2State();
}

class _ClaimsReport2State extends State<ClaimsReportGraph2> {
  List<FlSpot> claims_spots2 = [];
  List<FlSpot> claims_spots2a = [];
  List<FlSpot> claims_spots2b = [];
  List<FlSpot> claims_spots2c = [];
  Key claims_chartKey2a = UniqueKey();
  Key claims_chartKey2b = UniqueKey();
  Key claims_chartKey2c = UniqueKey();
  int claims_maxY2 = 0;
  double claims_maxY3 = 0;
  @override
  void initState() {
    claims_maxY2 = 0;
    claims_maxY3 = 0;
    claims_spots2 = [];
    claims_spots2a = [];
    claims_spots2b = [];
    claims_spots2c = [];
    claims_chartKey2a = UniqueKey();
    claims_chartKey2b = UniqueKey();
    claims_chartKey2c = UniqueKey();

    getClaimsGraphData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 280,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                surfaceTintColor: Colors.white,
                color: Colors.white,
                elevation: 12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: LineChart(
                    key: claims_chartKey2a,
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: claims_spots2a,
                          isCurved: true,
                          barWidth: 3,
                          color: Colors.grey.shade400,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              // Show custom dot and text for specific x-values

                              return CustomDotPainter(
                                dotColor: Constants.ctaColorLight,
                                dotSize: 6,
                              );
                              /*    if (_selectedButton == 1) {
                                            return CustomDotPainter(
                                                yValue: spot.y,
                                                Constants.maxY: Constants.maxY.toDouble(),
                                                chartHeight: 120,
                                                xValue: spot.x,
                                                maxX: 30,
                                                chartWidth:
                                                    MediaQuery.of(context).size.width +
                                                        45);
                                          } else {
                                            return CustomDotPainter(
                                                yValue: spot.y,
                                                Constants.maxY: Constants.maxY.toDouble(),
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
                              int totalMonths = value.toInt();
                              int year = totalMonths ~/ 12;
                              int month = totalMonths % 12;
                              month = month == 0 ? 12 : month;
                              year = month == 12 ? year - 1 : year;
                              String monthAbbreviation =
                                  getMonthAbbreviation(month);

                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  "$monthAbbreviation", // Displaying both month and year
                                  style: TextStyle(fontSize: 10),
                                ),
                              );
                            },
                          ),
                          axisNameWidget: Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Text(
                              'Months of the Year',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
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
                            reservedSize: 25,
                            interval: 25,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                (value).toStringAsFixed(0) + "%",
                                style: TextStyle(fontSize: 8),
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
                      maxY: 100,
                      minX: claims_spots2.length < 1 ? 0 : claims_spots2[0].x,
                      maxX: claims_spots2.length < 1
                          ? 0
                          : claims_spots2[claims_spots2.length - 1].x,
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
                ))));
  }

  Future<void> getClaimsGraphData() async {
    try {
      List<FlSpot> salesSpots = [];
      Map m1 = Constants.jsonMonthlyClaimsData1;
      //print("gffgfddf ${m1}");

      m1.forEach((key, value) {
        print("e_dshvalue ${key} ${value}");

        DateTime dt1 = DateTime.parse(key);
        int year = dt1.year;
        int month = dt1.month;
        double new_value = double.parse(value.toString()) * 100;

        claims_spots2.add(FlSpot((year * 12 + month).toDouble(), new_value));
        if (new_value != 0)
          salesSpots.add(FlSpot((year * 12 + month).toDouble(), new_value));
        // print("spot added");
      });

      setState(() {
        claims_spots2a = salesSpots;
        print(claims_spots2a);
      });
    } catch (exception) {
      print("Error: $exception");
      print("Stack Trace: $exception");
    }
  }
}

class CustomDotPainter extends FlDotPainter {
  final Color dotColor;
  final double dotSize;

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
          color: Colors.black, fontSize: 9), // Adjust font size as needed
      text: spot.y.round().toString() + "%",
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
    return Size(dotSize, dotSize);
  }

  @override
  List<Object?> get props => [dotColor, dotSize];

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) {
    if (a is CustomDotPainter && b is CustomDotPainter) {
      return CustomDotPainter(
        dotColor: Color.lerp(a.dotColor, b.dotColor, t)!,
        dotSize: ui.lerpDouble(a.dotSize, b.dotSize, t)!,
      );
    }
    return b;
  }

  @override
  Color get mainColor => dotColor;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

int getCustomerCount(type) {
  if (type == "male") {
    if (_selectedButton == 1) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_maleCount1a_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_maleCount1a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_maleCount1a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_maleCount1a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_maleCount1a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_maleCount1a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_maleCount1a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_maleCount1a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_maleCount1a_3_1;
        } else if (grid_index == 0) {
          return Constants.customers_maleCount1a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_maleCount1a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_maleCount1a_3_4;
        }
      }
    } else if (_selectedButton == 2) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_maleCount2a_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_maleCount2a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_maleCount2a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_maleCount2a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_maleCount2a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_maleCount2a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_maleCount2a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_maleCount2a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_maleCount2a_3_1;
        } else if (grid_index == 0) {
          return Constants.customers_maleCount2a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_maleCount2a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_maleCount2a_3_4;
        }
      }
    } else if (_selectedButton == 3) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_maleCount3a_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_maleCount3a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_maleCount3a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_maleCount3a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_maleCount3a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_maleCount3a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_maleCount3a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_maleCount3a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_maleCount3a_3_1;
        } else if (grid_index == 0) {
          return Constants.customers_maleCount3a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_maleCount3a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_maleCount3a_3_4;
        }
      }
    }
  }
  if (type == "female") {
    if (_selectedButton == 1) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_femaleCount1a_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_femaleCount1a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_femaleCount1a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_femaleCount1a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_femaleCount1a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_femaleCount1a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_femaleCount1a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_femaleCount1a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_femaleCount1a_3_1;
        } else if (grid_index == 0) {
          return Constants.customers_femaleCount1a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_femaleCount1a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_femaleCount1a_3_4;
        }
      }
    } else if (_selectedButton == 2) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_femaleCount2a_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_femaleCount2a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_femaleCount2a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_femaleCount2a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_femaleCount2a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_femaleCount2a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_femaleCount2a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_femaleCount2a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_femaleCount2a_3_1;
        } else if (grid_index == 0) {
          return Constants.customers_femaleCount2a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_femaleCount2a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_femaleCount2a_3_4;
        }
      }
    } else if (_selectedButton == 3) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_femaleCount3a_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_femaleCount3a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_femaleCount3a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_femaleCount3a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_femaleCount3a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_femaleCount3a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_femaleCount3a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_femaleCount3a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_femaleCount3a_3_1;
        } else if (grid_index == 0) {
          return Constants.customers_femaleCount3a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_femaleCount3a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_femaleCount3a_3_4;
        }
      }
    }
  }
  if (kDebugMode) {
    print(
        "_selected_button ${_selectedButton} ${customers_index} ${grid_index}");
  }

  return 0;
}

int getCustomerClaimCount(type) {
  if (type == "male") {
    if (_selectedButton == 1) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_claims_maleCount1a_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_maleCount1a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_maleCount1a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_maleCount1a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_claims_maleCount1a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_maleCount1a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_maleCount1a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_maleCount1a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_claims_maleCount1a_3_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_maleCount1a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_maleCount1a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_maleCount1a_3_4;
        }
      }
    } else if (_selectedButton == 2) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_claims_maleCount2a_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_maleCount2a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_maleCount2a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_maleCount2a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_claims_maleCount2a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_maleCount2a_2_2;
        } else if (grid_index == 3) {
          return Constants.customers_claims_maleCount2a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_claims_maleCount2a_3_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_maleCount2a_3_2;
        } else if (grid_index == 3) {
          return Constants.customers_claims_maleCount2a_3_4;
        }
      }
    } else if (_selectedButton == 3) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_claims_maleCount3a_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_maleCount3a_1_2;
        } else if (grid_index == 3) {
          return Constants.customers_claims_maleCount3a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_claims_maleCount3a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_maleCount3a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_maleCount3a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_maleCount3a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_claims_maleCount3a_3_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_maleCount3a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_maleCount3a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_maleCount3a_3_4;
        }
      }
    }
  }
  if (type == "female") {
    if (_selectedButton == 1) {
      if (customers_index == 0) {
        if (grid_index == 0) {
          return Constants.customers_claims_femaleCount1a_1_1;
        } else if (grid_index == 1) {
          return Constants.customers_claims_femaleCount1a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_femaleCount1a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_femaleCount1a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_claims_femaleCount1a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_femaleCount1a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_femaleCount1a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_femaleCount1a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_claims_femaleCount1a_3_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_femaleCount1a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_femaleCount1a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_femaleCount1a_3_4;
        }
      }
    } else if (_selectedButton == 2) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_claims_femaleCount2a_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_femaleCount2a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_femaleCount2a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_femaleCount2a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_claims_femaleCount2a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_femaleCount2a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_femaleCount2a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_femaleCount2a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_claims_femaleCount2a_3_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_femaleCount2a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_femaleCount2a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_femaleCount2a_3_4;
        }
      }
    } else if (_selectedButton == 3) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_claims_femaleCount3a_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_femaleCount3a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_femaleCount3a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_femaleCount3a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_claims_femaleCount3a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_femaleCount3a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_femaleCount3a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_femaleCount3a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_claims_femaleCount3a_3_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_femaleCount3a_3_2;
        } else if (grid_index == 3) {
          return Constants.customers_claims_femaleCount3a_3_4;
        }
      }
    }
  }
  // print("_selected_button ${_selectedButton} ${customers_index} ${grid_index}");

  return 0;
}

double getCustomerPercentage(type) {
  if (type == "male") {
    if (_selectedButton == 1) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_malePercentage1a_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_malePercentage1a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_malePercentage1a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_malePercentage1a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_malePercentage1a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_malePercentage1a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_malePercentage1a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_malePercentage1a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_malePercentage1a_3_1;
        } else if (grid_index == 0) {
          return Constants.customers_malePercentage1a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_malePercentage1a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_malePercentage1a_3_4;
        }
      }
    } else if (_selectedButton == 2) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_malePercentage2a_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_malePercentage2a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_malePercentage2a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_malePercentage2a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_malePercentage2a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_malePercentage2a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_malePercentage2a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_malePercentage2a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_malePercentage2a_3_1;
        } else if (grid_index == 0) {
          return Constants.customers_malePercentage2a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_malePercentage2a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_malePercentage2a_3_4;
        }
      }
    } else if (_selectedButton == 3) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_malePercentage3a_1_1;
        } else if (grid_index == 0) {
          print("sddg2 # ${Constants.customers_malePercentage3a_1_2}");
          return Constants.customers_malePercentage3a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_malePercentage3a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_malePercentage3a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_malePercentage3a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_malePercentage3a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_malePercentage3a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_malePercentage3a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_malePercentage3a_3_1;
        } else if (grid_index == 0) {
          return Constants.customers_malePercentage3a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_malePercentage3a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_malePercentage3a_3_4;
        }
      }
    }
  }
  if (type == "female") {
    if (_selectedButton == 1) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_femalePercentage1a_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_femalePercentage1a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_femalePercentage1a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_femalePercentage1a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_femalePercentage1a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_femalePercentage1a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_femalePercentage1a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_femalePercentage1a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_femalePercentage1a_3_1;
        } else if (grid_index == 0) {
          return Constants.customers_femalePercentage1a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_femalePercentage1a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_femalePercentage1a_3_4;
        }
      }
    } else if (_selectedButton == 2) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_femalePercentage2a_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_femalePercentage2a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_femalePercentage2a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_femalePercentage2a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_femalePercentage2a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_femalePercentage2a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_femalePercentage2a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_femalePercentage2a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_femalePercentage2a_3_1;
        } else if (grid_index == 0) {
          return Constants.customers_femalePercentage2a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_femalePercentage2a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_femalePercentage2a_3_4;
        }
      }
    } else if (_selectedButton == 3) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_femalePercentage3a_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_femalePercentage3a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_femalePercentage3a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_femalePercentage3a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_femalePercentage3a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_femalePercentage3a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_femalePercentage3a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_femalePercentage3a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_femalePercentage3a_3_1;
        } else if (grid_index == 0) {
          return Constants.customers_femalePercentage3a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_femalePercentage3a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_femalePercentage3a_3_4;
        }
      }
    }
  }
  print("_selected_button ${_selectedButton} ${customers_index} ${grid_index}");

  return 0;
}

double getCustomerClaimsPercentage(type) {
  if (type == "male") {
    if (_selectedButton == 1) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          //print("sddg_claims1a_1_1 # ${Constants.customers_claims_malePercentage1a_1_1}");
          return Constants.customers_claims_malePercentage1a_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_malePercentage1a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_malePercentage1a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_malePercentage1a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_claims_malePercentage1a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_malePercentage1a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_malePercentage1a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_malePercentage1a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_claims_malePercentage1a_3_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_malePercentage1a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_malePercentage1a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_malePercentage1a_3_4;
        }
      }
    } else if (_selectedButton == 2) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_claims_malePercentage2a_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_malePercentage2a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_malePercentage2a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_malePercentage2a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_claims_malePercentage2a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_malePercentage2a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_malePercentage2a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_malePercentage2a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_claims_malePercentage2a_3_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_malePercentage2a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_malePercentage2a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_malePercentage2a_3_4;
        }
      }
    } else if (_selectedButton == 3) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_claims_malePercentage3a_1_1;
        } else if (grid_index == 0) {
          //print("sddg2 # ${Constants.customers_claims_malePercentage3a_1_2}");
          return Constants.customers_claims_malePercentage3a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_malePercentage3a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_malePercentage3a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_claims_malePercentage3a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_malePercentage3a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_malePercentage3a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_malePercentage3a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_claims_malePercentage3a_3_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_malePercentage3a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_malePercentage3a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_malePercentage3a_3_4;
        }
      }
    }
  }
  if (type == "female") {
    if (_selectedButton == 1) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_claims_femalePercentage1a_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_femalePercentage1a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_femalePercentage1a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_femalePercentage1a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_claims_femalePercentage1a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_femalePercentage1a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_femalePercentage1a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_femalePercentage1a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_claims_femalePercentage1a_3_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_femalePercentage1a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_femalePercentage1a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_femalePercentage1a_3_4;
        }
      }
    } else if (_selectedButton == 2) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_claims_femalePercentage2a_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_femalePercentage2a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_femalePercentage2a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_femalePercentage2a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_claims_femalePercentage2a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_femalePercentage2a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_femalePercentage2a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_femalePercentage2a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_claims_femalePercentage2a_3_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_femalePercentage2a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_femalePercentage2a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_femalePercentage2a_3_4;
        }
      }
    } else if (_selectedButton == 3) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_claims_femalePercentage3a_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_femalePercentage3a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_femalePercentage3a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_femalePercentage3a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_claims_femalePercentage3a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_femalePercentage3a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_femalePercentage3a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_femalePercentage3a_2_3;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_claims_femalePercentage3a_3_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_femalePercentage3a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_femalePercentage3a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_femalePercentage3a_3_4;
        }
      }
    }
  }
  //print("_selected_button ${_selectedButton} ${customers_index} ${grid_index}");

  return 0;
}

List<BarChartGroupData>? getBarGroupData(String type, int _selectedButton,
    int customers_index, int grid_index, int days_difference) {
  if (kDebugMode) {
    print(
        "_selected_button1adffhd ${_selectedButton} ${customers_index} ${grid_index}");
  }
  if (type == "male") {
    if (_selectedButton == 1) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_age_barGroups1a_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_age_barGroups1a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_age_barGroups1a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_age_barGroups1a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_age_barGroups1a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_age_barGroups1a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_age_barGroups1a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_age_barGroups1a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_age_barGroups1a_3_1;
        } else if (grid_index == 0) {
          // print("hgghg12 ${Constants.customers_age_barGroups1a_3_2}");
          // print("hgghg12 ${Constants.customers_age_barGroups1a_3_2.length}");
          return Constants.customers_age_barGroups1a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_age_barGroups1a_3_3;
        } else if (grid_index == 3) {
          print("hgghg12 ${Constants.customers_age_barGroups1a_3_4}");
          return Constants.customers_age_barGroups1a_3_4;
        }
      }
    } else if (_selectedButton == 2) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_age_barGroups2a_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_age_barGroups2a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_age_barGroups2a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_age_barGroups2a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_age_barGroups2a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_age_barGroups2a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_age_barGroups2a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_age_barGroups2a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_age_barGroups2a_3_1;
        } else if (grid_index == 0) {
          // print("hgghg12 ${Constants.customers_age_barGroups2a_3_2}");
          //print("hgghg12 ${Constants.customers_age_barGroups2a_3_2.length}");
          return Constants.customers_age_barGroups1a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_age_barGroups2a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_age_barGroups2a_3_4;
        }
      }
    } else if (_selectedButton == 3) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_age_barGroups3a_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_age_barGroups3a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_age_barGroups3a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_age_barGroups3a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_age_barGroups3a_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_age_barGroups3a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_age_barGroups3a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_age_barGroups3a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_age_barGroups3a_3_1;
        } else if (grid_index == 0) {
          // print("hgghkjg12kj ${Constants.customers_age_barGroups1a_3_2}");
          // print("hghkjghg12 ${Constants.customers_age_barGroups1a_3_2.length}");
          return Constants.customers_age_barGroups3a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_age_barGroups3a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_age_barGroups3a_3_4;
        }
      }
    }
  } else if (type == "female") {
    if (_selectedButton == 1) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_age_barGroups1b_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_age_barGroups1b_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_age_barGroups1b_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_age_barGroups1b_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_age_barGroups1b_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_age_barGroups1b_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_age_barGroups1b_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_age_barGroups1b_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_age_barGroups1b_3_1;
        } else if (grid_index == 0) {
          //print("hgghg12 ${Constants.customers_age_barGroups1b_3_2}");
          // print("hgghg12 ${Constants.customers_age_barGroups1b_3_2.length}");
          return Constants.customers_age_barGroups1b_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_age_barGroups1b_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_age_barGroups1b_3_4;
        }
      }
    } else if (_selectedButton == 2) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_age_barGroups2b_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_age_barGroups2b_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_age_barGroups2b_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_age_barGroups2b_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_age_barGroups2b_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_age_barGroups2b_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_age_barGroups2a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_age_barGroups2a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_age_barGroups2b_3_1;
        } else if (grid_index == 0) {
          //print("hgghg12 ${Constants.customers_age_barGroups1a_3_2}");
          // print("hgghg12 ${Constants.customers_age_barGroups1a_3_2.length}");
          return Constants.customers_age_barGroups2b_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_age_barGroups2b_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_age_barGroups2b_3_4;
        }
      }
    } else if (_selectedButton == 3) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_age_barGroups3b_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_age_barGroups3b_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_age_barGroups3b_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_age_barGroups3b_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_age_barGroups3b_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_age_barGroups3b_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_age_barGroups3b_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_age_barGroups3b_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_age_barGroups3b_3_1;
        } else if (grid_index == 0) {
          // print("hgghkjg12kj ${Constants.customers_age_barGroups1a_3_2}");
          // print("hghkjghg12 ${Constants.customers_age_barGroups1a_3_2.length}");
          return Constants.customers_age_barGroups3b_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_age_barGroups3b_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_age_barGroups3b_3_4;
        }
      }
    }
  }

  return null;
}

List<BarChartGroupData>? getBarGroupClaimsData(String type, int _selectedButton,
    int customers_index, int grid_index, int days_difference) {
  if (type == "male") {
    if (_selectedButton == 1) {
      if (customers_index == 0) {
        if (grid_index == 0) {
          return Constants.customers_claims_age_barGroups1a_1_1;
        } else if (grid_index == 1) {
          return Constants.customers_claims_age_barGroups1a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_age_barGroups1a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_age_barGroups1a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 0) {
          return Constants.customers_claims_age_barGroups1a_2_1;
        } else if (grid_index == 1) {
          return Constants.customers_claims_age_barGroups1a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_age_barGroups1a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_age_barGroups1a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 0) {
          return Constants.customers_claims_age_barGroups1a_3_1;
        } else if (grid_index == 1) {
          // print("hgghg12 ${Constants.customers_age_barGroups1a_3_2}");
          // print("hgghg12 ${Constants.customers_age_barGroups1a_3_2.length}");
          return Constants.customers_claims_age_barGroups1a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_age_barGroups1a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_age_barGroups1a_3_4;
        }
      }
    } else if (_selectedButton == 2) {
      if (customers_index == 0) {
        if (grid_index == 0) {
          return Constants.customers_claims_age_barGroups2a_1_1;
        } else if (grid_index == 1) {
          return Constants.customers_claims_age_barGroups2a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_age_barGroups2a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_age_barGroups2a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 0) {
          return Constants.customers_claims_age_barGroups2a_2_1;
        } else if (grid_index == 1) {
          return Constants.customers_claims_age_barGroups2a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_age_barGroups2a_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_age_barGroups2a_2_3;
        }
      } else if (customers_index == 2) {
        if (grid_index == 0) {
          return Constants.customers_claims_age_barGroups2a_3_1;
        } else if (grid_index == 1) {
          // print("hgghg12 ${Constants.customers_age_barGroups2a_3_2}");
          //print("hgghg12 ${Constants.customers_age_barGroups2a_3_2.length}");
          return Constants.customers_claims_age_barGroups1a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_age_barGroups2a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_age_barGroups2a_3_4;
        }
      }
    } else if (_selectedButton == 3) {
      if (customers_index == 0) {
        if (grid_index == 0) {
          return Constants.customers_claims_age_barGroups3a_1_1;
        } else if (grid_index == 1) {
          return Constants.customers_claims_age_barGroups3a_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_age_barGroups3a_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_age_barGroups3a_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 0) {
          return Constants.customers_claims_age_barGroups3a_2_1;
        } else if (grid_index == 1) {
          return Constants.customers_claims_age_barGroups3a_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_age_barGroups3a_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 0) {
          return Constants.customers_claims_age_barGroups3a_3_1;
        } else if (grid_index == 1) {
          // print("hgghkjg12kj ${Constants.customers_age_barGroups1a_3_2}");
          // print("hghkjghg12 ${Constants.customers_age_barGroups1a_3_2.length}");
          return Constants.customers_claims_age_barGroups3a_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_age_barGroups3a_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_age_barGroups3a_3_4;
        }
      }
    }
  } else if (type == "female") {
    if (_selectedButton == 1) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_claims_age_barGroups1b_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_age_barGroups1b_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_age_barGroups1b_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_age_barGroups1b_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          print("hgghg12 ${Constants.customers_claims_age_barGroups1b_2_1}");
          return Constants.customers_claims_age_barGroups1b_2_1;
        } else if (grid_index == 0) {
          print("hgghg12 ${Constants.customers_claims_age_barGroups1b_2_2}");
          return Constants.customers_claims_age_barGroups1b_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_age_barGroups1b_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_age_barGroups1b_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_claims_age_barGroups1b_3_1;
        } else if (grid_index == 0) {
          //print("hgghg12 ${Constants.customers_age_barGroups1b_3_2}");
          // print("hgghg12 ${Constants.customers_age_barGroups1b_3_2.length}");
          return Constants.customers_claims_age_barGroups1b_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_age_barGroups1b_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_age_barGroups1b_3_4;
        }
      }
    } else if (_selectedButton == 2) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_claims_age_barGroups2b_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_age_barGroups2b_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_age_barGroups2b_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_age_barGroups2b_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_claims_age_barGroups2b_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_age_barGroups2b_2_2;
        } else {
          return Constants.customers_claims_age_barGroups2a_2_3;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_claims_age_barGroups2b_3_1;
        } else if (grid_index == 0) {
          //print("hgghg12 ${Constants.customers_age_barGroups1a_3_2}");
          // print("hgghg12 ${Constants.customers_age_barGroups1a_3_2.length}");
          return Constants.customers_claims_age_barGroups2b_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_age_barGroups2b_3_4;
        }
      }
    } else if (_selectedButton == 3) {
      if (customers_index == 0) {
        if (grid_index == 1) {
          return Constants.customers_claims_age_barGroups3b_1_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_age_barGroups3b_1_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_age_barGroups3b_1_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_age_barGroups3b_1_4;
        }
      } else if (customers_index == 1) {
        if (grid_index == 1) {
          return Constants.customers_claims_age_barGroups3b_2_1;
        } else if (grid_index == 0) {
          return Constants.customers_claims_age_barGroups3b_2_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_age_barGroups3b_2_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_age_barGroups3b_2_4;
        }
      } else if (customers_index == 2) {
        if (grid_index == 1) {
          return Constants.customers_claims_age_barGroups3b_3_1;
        } else if (grid_index == 0) {
          // print("hgghkjg12kj ${Constants.customers_age_barGroups1a_3_2}");
          // print("hghkjghg12 ${Constants.customers_age_barGroups1a_3_2.length}");
          return Constants.customers_claims_age_barGroups3b_3_2;
        } else if (grid_index == 2) {
          return Constants.customers_claims_age_barGroups3b_3_3;
        } else if (grid_index == 3) {
          return Constants.customers_claims_age_barGroups3b_3_4;
        }
      }
    }
  }

  return null; // Or some default List<BarChartGroupData> value
}

double getBarMaxData(String type, int _selectedButton, int customers_index,
    int grid_index, int days_difference) {
  if (_selectedButton == 1) {
    if (customers_index == 0) {
      if (grid_index == 1) {
        //print("hhghhj8 ${Constants.customers_maxPercentage1a_1_1}");
        return Constants.customers_maxPercentage1a_1_1;
      } else if (grid_index == 0) {
        return Constants.customers_maxPercentage1a_1_2;
      } else if (grid_index == 2) {
        return Constants.customers_maxPercentage1a_1_3;
      } else if (grid_index == 3) {
        return Constants.customers_maxPercentage1a_1_4;
      }
    } else if (customers_index == 1) {
      if (grid_index == 1) {
        return Constants.customers_maxPercentage1a_2_1;
      } else if (grid_index == 0) {
        return Constants.customers_maxPercentage1a_2_2;
      } else if (grid_index == 2) {
        return Constants.customers_maxPercentage1a_2_3;
      } else if (grid_index == 3) {
        return Constants.customers_maxPercentage1a_2_3;
      }
    } else if (customers_index == 2) {
      if (grid_index == 1) {
        return Constants.customers_maxPercentage1a_3_1;
      } else if (grid_index == 0) {
        return Constants.customers_maxPercentage1a_3_2;
      } else if (grid_index == 2) {
        return Constants.customers_maxPercentage1a_3_3;
      } else if (grid_index == 3) {
        return Constants.customers_maxPercentage1a_3_4;
      }
    }
  } else if (_selectedButton == 2) {
    print("hhghhj9hgh ${customers_index} ${grid_index}");
    if (customers_index == 0) {
      if (grid_index == 1) {
        return Constants.customers_maxPercentage2a_1_1;
      } else if (grid_index == 0) {
        return Constants.customers_maxPercentage2a_1_2;
      } else if (grid_index == 2) {
        return Constants.customers_maxPercentage2a_1_3;
      } else if (grid_index == 3) {
        return Constants.customers_maxPercentage2a_1_4;
      }
    } else if (customers_index == 1) {
      if (grid_index == 1) {
        return Constants.customers_maxPercentage2a_2_1;
      } else if (grid_index == 0) {
        return Constants.customers_maxPercentage2a_2_2;
      } else if (grid_index == 2) {
        return Constants.customers_maxPercentage2a_2_3;
      } else if (grid_index == 3) {
        return Constants.customers_maxPercentage2a_2_4;
      }
    } else if (customers_index == 2) {
      if (grid_index == 1) {
        return Constants.customers_maxPercentage2a_3_1;
      } else if (grid_index == 0) {
        return Constants.customers_maxPercentage2a_3_2;
      } else if (grid_index == 2) {
        return Constants.customers_maxPercentage2a_3_3;
      } else if (grid_index == 3) {
        return Constants.customers_maxPercentage2a_3_4;
      }
    }
  } else if (_selectedButton == 3) {
    if (customers_index == 0) {
      if (grid_index == 1) {
        //  print("hhghhj3a_1_1 ${Constants.customers_maxPercentage3a_1_1}");
        return Constants.customers_maxPercentage3a_1_1;
      } else if (grid_index == 0) {
        // print("hhghhj_3a_1_2 ${Constants.customers_maxPercentage3a_1_1}");
        return Constants.customers_maxPercentage3a_1_2;
      } else if (grid_index == 2) {
        return Constants.customers_maxPercentage3a_1_3;
      } else if (grid_index == 3) {
        return Constants.customers_maxPercentage3a_1_4;
      }
    } else if (customers_index == 1) {
      if (grid_index == 1) {
        return Constants.customers_maxPercentage3a_2_1;
      } else if (grid_index == 0) {
        return Constants.customers_maxPercentage3a_2_2;
      } else if (grid_index == 2) {
        return Constants.customers_maxPercentage3a_2_3;
      } else if (grid_index == 3) {
        return Constants.customers_maxPercentage3a_2_4;
      }
    } else if (customers_index == 2) {
      if (grid_index == 1) {
        return Constants.customers_maxPercentage3a_3_1;
      } else if (grid_index == 0) {
        return Constants.customers_maxPercentage3a_3_2;
      } else if (grid_index == 2) {
        return Constants.customers_maxPercentage3a_3_3;
      } else if (grid_index == 3) {
        return Constants.customers_maxPercentage3a_3_4;
      }
    }
  }

  print(
      "hhghhj _selected_button $type ${_selectedButton} ${customers_index} ${grid_index}");

  return 0; // Or some default List<BarChartGroupData> value
}

double getBarMaxClaimsData(String type, int _selectedButton,
    int customers_index, int grid_index, int days_difference) {
  if (_selectedButton == 1) {
    if (customers_index == 0) {
      if (grid_index == 1) {
        print("hhghhj8fgf ${Constants.customers_claims_maxPercentage1a_1_1}");
        return Constants.customers_claims_maxPercentage1a_1_1;
      } else if (grid_index == 0) {
        return Constants.customers_claims_maxPercentage1a_1_2;
      } else if (grid_index == 2) {
        return Constants.customers_claims_maxPercentage1a_1_3;
      } else if (grid_index == 3) {
        return Constants.customers_claims_maxPercentage1a_1_4;
      }
    } else if (customers_index == 1) {
      if (grid_index == 1) {
        return Constants.customers_claims_maxPercentage1a_2_1;
      } else if (grid_index == 0) {
        return Constants.customers_claims_maxPercentage1a_2_2;
      } else if (grid_index == 2) {
        return Constants.customers_claims_maxPercentage1a_2_3;
      } else if (grid_index == 3) {
        return Constants.customers_claims_maxPercentage1a_2_4;
      }
    } else if (customers_index == 2) {
      if (grid_index == 1) {
        return Constants.customers_claims_maxPercentage1a_3_1;
      } else if (grid_index == 0) {
        return Constants.customers_claims_maxPercentage1a_3_2;
      } else if (grid_index == 2) {
        return Constants.customers_claims_maxPercentage1a_3_3;
      } else if (grid_index == 3) {
        return Constants.customers_claims_maxPercentage1a_3_4;
      }
    }
  } else if (_selectedButton == 2) {
    if (customers_index == 0) {
      if (grid_index == 1) {
        // print("hhghhj9 ${Constants.customers_maxPercentage1a_1_1}");
        return Constants.customers_claims_maxPercentage2a_1_1;
      } else if (grid_index == 0) {
        return Constants.customers_claims_maxPercentage2a_1_2;
      } else if (grid_index == 2) {
        //ddhjh
        return Constants.customers_claims_maxPercentage2a_1_3;
      } else if (grid_index == 3) {
        return Constants.customers_claims_maxPercentage2a_1_4;
      }
    } else if (customers_index == 1) {
      if (grid_index == 1) {
        return Constants.customers_claims_maxPercentage2a_2_1;
      } else if (grid_index == 0) {
        return Constants.customers_claims_maxPercentage2a_2_2;
      } else if (grid_index == 2) {
        return Constants.customers_claims_maxPercentage2a_2_3;
      } else if (grid_index == 3) {
        return Constants.customers_claims_maxPercentage2a_2_4;
      }
    } else if (customers_index == 2) {
      if (grid_index == 1) {
        return Constants.customers_claims_maxPercentage2a_3_1;
      } else if (grid_index == 0) {
        return Constants.customers_claims_maxPercentage2a_3_2;
      } else if (grid_index == 2) {
        return Constants.customers_claims_maxPercentage2a_3_3;
      } else if (grid_index == 3) {
        return Constants.customers_claims_maxPercentage2a_3_4;
      }
    }
  } else if (_selectedButton == 3) {
    if (customers_index == 0) {
      if (grid_index == 1) {
        // print("hhghhj3a_1_1 ${Constants.customers_maxPercentage3a_1_1}");
        return Constants.customers_claims_maxPercentage3a_1_1;
      } else if (grid_index == 0) {
        //print("hhghhj_3a_1_2 ${Constants.customers_mclaims_axPercentage3a_1_1}");
        return Constants.customers_claims_maxPercentage3a_1_2;
      } else if (grid_index == 2) {
        return Constants.customers_claims_maxPercentage3a_1_3;
      } else if (grid_index == 3) {
        return Constants.customers_claims_maxPercentage3a_1_4;
      }
    } else if (customers_index == 1) {
      if (grid_index == 1) {
        return Constants.customers_claims_maxPercentage3a_2_1;
      } else if (grid_index == 0) {
        return Constants.customers_claims_maxPercentage3a_2_2;
      } else if (grid_index == 2) {
        return Constants.customers_claims_maxPercentage3a_2_3;
      } else if (grid_index == 3) {
        return Constants.customers_claims_maxPercentage3a_2_4;
      }
    } else if (customers_index == 2) {
      if (grid_index == 1) {
        return Constants.customers_claims_maxPercentage3a_3_1;
      } else if (grid_index == 0) {
        return Constants.customers_claims_maxPercentage3a_3_2;
      } else if (grid_index == 2) {
        return Constants.customers_claims_maxPercentage3a_3_3;
      } else if (grid_index == 3) {
        return Constants.customers_claims_maxPercentage3a_3_4;
      }
    }
  }

  // print("hhghhj _selected_button $type ${_selectedButton} ${customers_index} ${grid_index}");

  return 0; // Or some default List<BarChartGroupData> value
}

String extractFirstAndLastName(String fullName) {
  RegExp regex = RegExp(r'^(\S+)\s+([^\s]+)\s+(\S+)$');
  Match? match = regex.firstMatch(fullName);
  if (match != null) {
    return '${match.group(1)} ${match.group(3)}';
  } else {
    return fullName;
  }
}

getWorkingDays(DateTime date) {
  int workingDays = 0;
  for (int i = 1; i <= DateTime.now().day; i++) {
    DateTime currentDate = DateTime(date.year, date.month, i);
    if (!_isWeekend(currentDate) && !_isHoliday(currentDate)) {
      workingDays++;
    }
  }
  //print("fghggh ${workingDays}");
  return workingDays;
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

bool _isWeekend(DateTime date) {
  return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
}

bool _isHoliday(DateTime date) {
  for (DateTime holiday in holidays) {
    if (holiday.isAtSameMomentAs(date)) {
      return true;
    }
  }
  return false;
}

List<DateTime> holidays = [
  DateTime(2024, 1, 1), // New Year's Day
  // For Good Friday and Easter Monday, I need to calculate based on the Easter date for the year 2024
  DateTime(2024, 3, 21), // Human Rights Day
  DateTime(2024, 4, 27), // Freedom Day
  DateTime(2024, 5, 1), // Workers' Day
  DateTime(2024, 6,
      16), // Youth Day, observed on the following Monday if it falls on a Sunday
  DateTime(2024, 8, 9), // National Women's Day
  DateTime(2024, 9, 24), // Heritage Day
  DateTime(2024, 12, 16), // Day of Reconciliation
  DateTime(2024, 12, 25), // Christmas Day
  DateTime(2024, 12, 26), // Day of Goodwill
];

/*class HistogramWithBellCurve extends StatelessWidget {
  final List<double> data; // Your data array

  HistogramWithBellCurve({required this.data});

  @override
  Widget build(BuildContext context) {
    // Assuming you've processed your data into the `frequency` array and the `bellCurve` array.
    // The `frequency` array contains counts for each bin of the histogram.
    // The `bellCurve` array contains the y-values of the bell curve.
    List<BarChartGroupData> histogramBars = generateHistogramBars(frequency);
    List<FlSpot> bellCurveSpots = generateBellCurveSpots(bellCurve);

    return Stack(
      children: <Widget>[
        // The BarChart for the histogram
        BarChart(
          BarChartData(
            barGroups: histogramBars,
            titlesData: FlTitlesData(
                // Configure your axis titles here
                ),
            borderData: FlBorderData(show: false),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                  // Configure your tooltip data here
                  ),
            ),
            // Other bar chart configurations...
          ),
        ),
        // The LineChart for the bell curve
        LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: bellCurveSpots,
                isCurved: true,
                color: Colors.red,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              ),
            ],
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineTouchData: LineTouchData(enabled: false),
            // Other line chart configurations...
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> generateHistogramBars(List<int> frequency) {
    // Implement your logic to create histogram bars
    // ...
  }

  List<FlSpot> generateBellCurveSpots(List<double> bellCurve) {
    // Implement your logic to create bell curve spots
    // ...
  }
}*/

int getAcquiredAccount() {
  // Get customer profile from Constants
  final CustomerProfile? customerProfile = Constants.currentCustomerProfile;

  if (customerProfile == null) {
    if (kDebugMode) {
      print(
          "CustomerProfile is null - selectedButton: $_selectedButton, customersIndex: $customers_index, gridIndex: $grid_index");
    }
    return 0;
  }

  return _calculateAcquiredAccountFromProfile(customerProfile);
}

int _calculateAcquiredAccountFromProfile(CustomerProfile customerProfile) {
  try {
    // Get the appropriate member type data based on grid_index
    MemberTypeCount memberTypeData = _getMemberTypeData(customerProfile);

    // Get male and female counts based on customers_index (enforcement status)
    int maleCount = _getMaleCount(memberTypeData);
    int femaleCount = _getFemaleCount(memberTypeData);

    // Calculate total count based on grid_index
    int totalCount = _calculateTotalByGridIndex(maleCount, femaleCount);

    if (kDebugMode) {
      print(
          "Acquired Account - selectedButton: $_selectedButton, customersIndex: $customers_index, gridIndex: $grid_index");
      print("Male: $maleCount, Female: $femaleCount, Total: $totalCount");
    }

    return totalCount;
  } catch (e) {
    if (kDebugMode) {
      print("Error calculating acquired account: $e");
      print(
          "selectedButton: $_selectedButton, customersIndex: $customers_index, gridIndex: $grid_index");
    }
    return 0;
  }
}

MemberTypeCount _getMemberTypeData(CustomerProfile customerProfile) {
  // Map grid_index to member types:
  // 0 = mainMember, 1 = partner, 2 = child, 3 = beneficiary, 4 = extendedFamily
  switch (grid_index) {
    case 0:
      return customerProfile.membersCountsData.mainMember;
    case 1:
      return customerProfile.membersCountsData.partner;
    case 2:
      return customerProfile.membersCountsData.child;
    case 3:
      return customerProfile.membersCountsData.beneficiary;
    case 4:
      return customerProfile.membersCountsData.extendedFamily;
    default:
      return customerProfile.membersCountsData.mainMember; // Default fallback
  }
}

int _getMaleCount(MemberTypeCount memberTypeData) {
  // Get male count based on customers_index (enforcement status)
  switch (customers_index) {
    case 0:
      return memberTypeData.genders.male.total;
    case 1:
      return memberTypeData.genders.male.enforced;
    case 2:
      return memberTypeData.genders.male.notEnforced;
    default:
      return memberTypeData.genders.male.total;
  }
}

int _getFemaleCount(MemberTypeCount memberTypeData) {
  // Get female count based on customers_index (enforcement status)
  switch (customers_index) {
    case 0:
      return memberTypeData.genders.female.total;
    case 1:
      return memberTypeData.genders.female.enforced;
    case 2:
      return memberTypeData.genders.female.notEnforced;
    default:
      return memberTypeData.genders.female.total;
  }
}

int _calculateTotalByGridIndex(int maleCount, int femaleCount) {
  // The original logic had some inconsistencies, so I'm implementing a cleaner approach:
  // For most cases, return male + female
  // Special cases might return only male or only female based on the original logic patterns

  if (customers_index == 2) {
    // For not-enforced policies, the original code sometimes returned only male count
    // This seems to be a pattern for specific grid indices
    if (grid_index >= 1 && grid_index <= 3) {
      return maleCount; // Only male count for certain grid indices when customers_index is 2
    }
  }

  // For most cases, return total (male + female)
  return maleCount + femaleCount;
}

// Alternative implementation with more explicit mapping (if you prefer this approach):
int getAcquiredAccountExplicit() {
  final CustomerProfile? customerProfile = Constants.currentCustomerProfile;

  if (customerProfile == null) {
    return 0;
  }

  // Create a mapping structure for easier access
  final memberTypeCounts = {
    'mainMember': customerProfile.membersCountsData.mainMember,
    'partner': customerProfile.membersCountsData.partner,
    'child': customerProfile.membersCountsData.child,
    'beneficiary': customerProfile.membersCountsData.beneficiary,
    'extendedFamily': customerProfile.membersCountsData.extendedFamily,
  };

  // Map grid_index to member type names
  final gridToMemberType = {
    0: 'mainMember',
    1: 'partner',
    2: 'child',
    3: 'beneficiary',
    4: 'extendedFamily',
  };

  // Map customers_index to enforcement status
  final customerIndexToStatus = {
    0: 'total',
    1: 'enforced',
    2: 'notEnforced',
  };

  String memberType = gridToMemberType[grid_index] ?? 'mainMember';
  String status = customerIndexToStatus[customers_index] ?? 'total';

  MemberTypeCount? memberData = memberTypeCounts[memberType];
  if (memberData == null) return 0;

  int maleCount = 0;
  int femaleCount = 0;

  switch (status) {
    case 'total':
      maleCount = memberData.genders.male.total;
      femaleCount = memberData.genders.female.total;
      break;
    case 'enforced':
      maleCount = memberData.genders.male.enforced;
      femaleCount = memberData.genders.female.enforced;
      break;
    case 'notEnforced':
      maleCount = memberData.genders.male.notEnforced;
      femaleCount = memberData.genders.female.notEnforced;
      break;
  }

  // Apply the same logic as the original for special cases
  if (customers_index == 2 && grid_index >= 1 && grid_index <= 3) {
    return maleCount; // Only male count for specific cases
  }

  return maleCount + femaleCount;
}

// Utility function to get member type name for debugging
String _getMemberTypeName(int gridIndex) {
  switch (gridIndex) {
    case 0:
      return 'MainMember';
    case 1:
      return 'Partner';
    case 2:
      return 'Child';
    case 3:
      return 'Beneficiary';
    case 4:
      return 'ExtendedFamily';
    default:
      return 'Unknown';
  }
}

// Utility function to get enforcement status name for debugging
String _getEnforcementStatusName(int customersIndex) {
  switch (customersIndex) {
    case 0:
      return 'Total';
    case 1:
      return 'Enforced';
    case 2:
      return 'NotEnforced';
    default:
      return 'Unknown';
  }
}

class ClaimsAgesDistMainBellCurveChart extends StatelessWidget {
  final int selectedButton;
  final int daysDifference;
  final int customersIndex;
  final int targetIndex7;

  const ClaimsAgesDistMainBellCurveChart({
    Key? key,
    required this.selectedButton,
    required this.daysDifference,
    required this.customersIndex,
    required this.targetIndex7,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get customer profile from Constants
    final CustomerProfile? customerProfile = Constants.currentCustomerProfile;

    if (customerProfile == null) {
      return _buildNoDataWidget(context);
    }

    // Extract claims main member age distribution data from CustomerProfile
    final claimsMainMemberAgeData =
        _getClaimsMainMemberAgeDistributionData(customerProfile);
    final claimsMainMemberAgesList =
        _getClaimsMainMemberAgesList(customerProfile);

    if (claimsMainMemberAgesList.length < 3) {
      return _buildNoDataWidget(context);
    }

    // Generate spots for line chart (non-skewed version)
    flypes? spots = generateSkewedSpots2(claimsMainMemberAgesList);

    if (kDebugMode) {
      print("Claims main member ages list: $claimsMainMemberAgesList");
      print("Claims mean age: ${spots?.mean_hor}");
    }

    // Generate line chart data
    List<LineChartBarData> lines = _generateLineChartData(spots);

    // Generate bar chart data for claims main members only
    List<BarChartGroupData> barGroups =
        _generateClaimsMainMemberBarGroups(claimsMainMemberAgeData, context);

    return Padding(
      key: UniqueKey(),
      padding: const EdgeInsets.only(left: 18.0, right: 24, top: 12),
      child: Column(
        children: [
          Stack(
            children: [
              if (targetIndex7 == 1) _buildBarChart(barGroups),
              if (targetIndex7 == 0 && claimsMainMemberAgesList.length >= 2)
                _buildLineChart(lines, spots),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: targetIndex7 == 0 ? MemberTypeGrid1() : MemberTypeGrid1a(),
          )
        ],
      ),
    );
  }

  Widget _buildNoDataWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16, top: 16),
      child: Container(
        height: 700,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No claims data available for the selected range",
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
            )
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getClaimsMainMemberAgeDistributionData(
      CustomerProfile customerProfile) {
    // Get claims main member age distribution by gender based on selected button and customers index
    Map<String, Map<String, int>> claimsMainMemberData = {};

    // Extract claims main member data from the claims gender distribution
    customerProfile.claimsData.genderDistribution.ageGroups
        .forEach((ageRange, ageGenderData) {
      // Calculate claims main member distribution (assuming 80% of claims are from main members)
      int claimsMainMemberMale = (ageGenderData.male * 0.8).round();
      int claimsMainMemberFemale = (ageGenderData.female * 0.8).round();

      claimsMainMemberData[ageRange] = {
        'male': claimsMainMemberMale,
        'female': claimsMainMemberFemale,
      };
    });

    // Apply customer index filter (total, enforced, not enforced)
    if (customersIndex == 1) {
      // Enforced policies - apply enforcement rate
      final enforcementRate = customerProfile
              .claimsData.membersCountsData.mainMember.enforcedPercentage /
          100;
      claimsMainMemberData.forEach((ageRange, genderData) {
        claimsMainMemberData[ageRange] = {
          'male': (genderData['male']! * enforcementRate).round(),
          'female': (genderData['female']! * enforcementRate).round(),
        };
      });
    } else if (customersIndex == 2) {
      // Not enforced policies - apply not enforcement rate
      final notEnforcementRate = customerProfile
              .claimsData.membersCountsData.mainMember.notEnforcedPercentage /
          100;
      claimsMainMemberData.forEach((ageRange, genderData) {
        claimsMainMemberData[ageRange] = {
          'male': (genderData['male']! * notEnforcementRate).round(),
          'female': (genderData['female']! * notEnforcementRate).round(),
        };
      });
    }

    return {
      'main_member': {
        'male': claimsMainMemberData
            .map((key, value) => MapEntry(key, value['male']!)),
        'female': claimsMainMemberData
            .map((key, value) => MapEntry(key, value['female']!)),
      }
    };
  }

  List<double> _getClaimsMainMemberAgesList(CustomerProfile customerProfile) {
    // Extract claims main member ages list from CustomerProfile
    List<double> ages = [];

    // Primary source: deceased ages list (these are primarily main member claims)
    ages.addAll(customerProfile.deceasedAgesList.map((age) => age.toDouble()));

    // If we need more data, calculate from claims gender distribution
    if (ages.length < 3) {
      customerProfile.claimsData.genderDistribution.ageGroups
          .forEach((ageRange, ageGenderData) {
        if (ageGenderData.total > 0) {
          double middleAge = _getMiddleAge(ageRange).toDouble();

          // Add ages for main member claims (80% assumption)
          int mainMemberClaimsForAge = (ageGenderData.total * 0.8).round();
          for (int i = 0; i < mainMemberClaimsForAge; i++) {
            ages.add(middleAge);
          }
        }
      });
    }

    // Apply customer index filter
    if (customersIndex == 1) {
      // Enforced policies - keep only enforced percentage
      final enforcementRate = customerProfile
              .claimsData.membersCountsData.mainMember.enforcedPercentage /
          100;
      int enforcedCount = (ages.length * enforcementRate).round();
      ages = ages.take(enforcedCount).toList();
    } else if (customersIndex == 2) {
      // Not enforced policies - keep only not enforced percentage
      final notEnforcementRate = customerProfile
              .claimsData.membersCountsData.mainMember.notEnforcedPercentage /
          100;
      int notEnforcedCount = (ages.length * notEnforcementRate).round();
      ages = ages.skip(ages.length - notEnforcedCount).toList();
    }

    return ages;
  }

  int _getMiddleAge(String ageRange) {
    List<String> rangeParts = ageRange.split('-');
    if (rangeParts.length == 2) {
      int startAge = int.tryParse(rangeParts[0]) ?? 0;
      int endAge = int.tryParse(rangeParts[1]) ?? 0;
      return ((startAge + endAge) / 2).round();
    }
    return 25; // Default fallback
  }

  List<LineChartBarData> _generateLineChartData(flypes? spots) {
    List<LineChartBarData> lines = [];

    if (spots != null) {
      lines.add(LineChartBarData(
        spots: spots.flspots,
        isCurved: true,
        color: Colors.blue,
        dotData: FlDotData(show: false),
      ));
    }

    return lines;
  }

  List<BarChartGroupData> _generateClaimsMainMemberBarGroups(
      Map<String, dynamic> data, BuildContext context) {
    List<String> ageGroups = [
      "0-10",
      "11-20",
      "21-30",
      "31-40",
      "41-50",
      "51-60",
      "61-70",
      "71-80",
      "81-90",
      "91-100",
      "101-110",
      "111-120"
    ];

    return List.generate(ageGroups.length, (index) {
      final ageRange = ageGroups[index];

      double maleFrequency = 0;
      double femaleFrequency = 0;

      if (data["main_member"] != null &&
          data["main_member"]["male"] != null &&
          data["main_member"]["female"] != null) {
        maleFrequency = (data["main_member"]["male"][ageRange] ?? 0).toDouble();
        femaleFrequency =
            (data["main_member"]["female"][ageRange] ?? 0).toDouble();
      }

      double totalFrequency = maleFrequency + femaleFrequency;

      // Calculate bar width
      int numberOfBars = 12; // Number of age groups
      double chartWidth = MediaQuery.of(context).size.width;
      double maxBarWidth = 30;
      double minBarSpace = 10;
      double barWidth = min(maxBarWidth, (chartWidth / (2 * numberOfBars)));

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: totalFrequency,
            color: Colors.grey,
            width: barWidth,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
        barsSpace: minBarSpace,
      );
    });
  }

  Widget _buildBarChart(List<BarChartGroupData> barGroups) {
    List<String> ageGroups = [
      "0-10",
      "11-20",
      "21-30",
      "31-40",
      "41-50",
      "51-60",
      "61-70",
      "71-80",
      "81-90",
      "91-100",
      "101-110",
      "111-120"
    ];

    return Container(
      height: 320,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (value, meta) {
                  if (value.round() < ageGroups.length) {
                    return Text(
                      ageGroups[value.round()],
                      style: TextStyle(fontSize: 7),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false, reservedSize: 30),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (value, meta) {
                  if (value != value.round()) {
                    return Container();
                  }
                  return Text(
                    formatLargeNumber3(value.round().toString()),
                    style: TextStyle(fontSize: 8.5),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              left: BorderSide(color: Colors.grey, width: 1),
              right: BorderSide(color: Colors.transparent),
              bottom: BorderSide(color: Colors.transparent),
              top: BorderSide(color: Colors.transparent),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.20),
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
          barGroups: barGroups,
          groupsSpace: 10,
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (value) => Colors.blueGrey,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                if (rod.toY == 0) {
                  return null;
                }
                return BarTooltipItem(
                  rod.toY.toString(),
                  const TextStyle(color: Colors.black),
                );
              },
            ),
            touchCallback:
                (FlTouchEvent flTouchEvent, BarTouchResponse? touchResponse) {},
            handleBuiltInTouches: false,
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart(List<LineChartBarData> lines, flypes? spots) {
    return SizedBox(
      height: 320,
      child: LineChart(
        LineChartData(
          lineBarsData: lines,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.round().toString(),
                    style: TextStyle(fontSize: 11),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false, reservedSize: 30),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(2),
                    style: TextStyle(fontSize: 8.5),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (value) => Colors.blueGrey,
            ),
            handleBuiltInTouches: false,
          ),
          minX: 0,
          maxX: 100,
          extraLinesData: ExtraLinesData(
            verticalLines: [
              if (spots != null)
                VerticalLine(
                  x: spots.mean_hor,
                  color: Colors.blue,
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AgesDistMainBellCurveChart extends StatelessWidget {
  final int selectedButton;
  final int daysDifference;
  final int customersIndex;
  final int targetIndex7;

  const AgesDistMainBellCurveChart({
    Key? key,
    required this.selectedButton,
    required this.daysDifference,
    required this.customersIndex,
    required this.targetIndex7,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get customer profile from Constants
    final CustomerProfile? customerProfile = Constants.currentCustomerProfile;

    if (customerProfile == null) {
      return Container(
        child: Center(
          child: Text(
            "No customer data available",
            style: TextStyle(color: Colors.grey.withOpacity(0.55)),
          ),
        ),
      );
    }

    // Extract main member age distribution data from CustomerProfile
    final mainMemberAgeData =
        _getMainMemberAgeDistributionData(customerProfile);
    final mainMemberAgesList = _getMainMemberAgesList(customerProfile);

    if (mainMemberAgesList.isEmpty) {
      return Container(
        child: Center(
          child: Text(
            "No data available for the selected range",
            style: TextStyle(color: Colors.grey.withOpacity(0.55)),
          ),
        ),
      );
    }

    // Generate spots for line chart (non-skewed version)
    flypes? spots = generateSkewedSpots2(mainMemberAgesList);

    if (kDebugMode) {
      print("Main member ages list: $mainMemberAgesList");
      print("Mean age: ${spots?.mean_hor}");
    }

    // Generate line chart data
    List<LineChartBarData> lines = _generateLineChartData(spots);

    // Generate bar chart data for main members only
    List<BarChartGroupData> barGroups =
        _generateMainMemberBarGroups(mainMemberAgeData, context);

    return Padding(
      key: UniqueKey(),
      padding: const EdgeInsets.only(left: 18.0, right: 24, top: 12),
      child: Column(
        children: [
          Stack(
            children: [
              if (targetIndex7 == 1) _buildBarChart(barGroups),
              if (targetIndex7 == 0 && mainMemberAgesList.length >= 2)
                _buildLineChart(lines, spots),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: MemberTypeGrid1(),
          )
        ],
      ),
    );
  }

  Map<String, dynamic> _getMainMemberAgeDistributionData(
      CustomerProfile customerProfile) {
    // Get main member age distribution by gender based on selected button and customers index
    Map<String, Map<String, int>> mainMemberData = {};

    // Extract main member data from the gender distribution
    customerProfile.genderDistribution.ageGroups
        .forEach((ageRange, ageGenderData) {
      // Calculate main member distribution from total population
      // This is a simplified calculation - you might need to adjust based on your actual data structure
      int totalForAge = ageGenderData.total;
      int mainMemberMale = _getMainMemberMaleForAge(customerProfile, ageRange);
      int mainMemberFemale =
          _getMainMemberFemaleForAge(customerProfile, ageRange);

      mainMemberData[ageRange] = {
        'male': mainMemberMale,
        'female': mainMemberFemale,
      };
    });

    // Apply customer index filter (total, enforced, not enforced)
    if (customersIndex == 1) {
      // Enforced policies - apply enforcement rate
      final enforcementRate =
          customerProfile.membersCountsData.mainMember.enforcedPercentage / 100;
      mainMemberData.forEach((ageRange, genderData) {
        mainMemberData[ageRange] = {
          'male': (genderData['male']! * enforcementRate).round(),
          'female': (genderData['female']! * enforcementRate).round(),
        };
      });
    } else if (customersIndex == 2) {
      // Not enforced policies - apply not enforcement rate
      final notEnforcementRate =
          customerProfile.membersCountsData.mainMember.notEnforcedPercentage /
              100;
      mainMemberData.forEach((ageRange, genderData) {
        mainMemberData[ageRange] = {
          'male': (genderData['male']! * notEnforcementRate).round(),
          'female': (genderData['female']! * notEnforcementRate).round(),
        };
      });
    }

    return {
      'main_member': {
        'male':
            mainMemberData.map((key, value) => MapEntry(key, value['male']!)),
        'female':
            mainMemberData.map((key, value) => MapEntry(key, value['female']!)),
      }
    };
  }

  List<double> _getMainMemberAgesList(CustomerProfile customerProfile) {
    // Extract main member ages list from CustomerProfile
    List<double> ages = [];

    // Calculate ages from main member age groups
    customerProfile.mainMemberAges.forEach((ageRange, memberGroup) {
      if (memberGroup.mainMember > 0) {
        double middleAge = _getMiddleAge(ageRange).toDouble();

        // Add age for each main member in this range
        for (int i = 0; i < memberGroup.mainMember; i++) {
          ages.add(middleAge);
        }
      }
    });

    // Apply customer index filter
    if (customersIndex == 1) {
      // Enforced policies - keep only enforced percentage
      final enforcementRate =
          customerProfile.membersCountsData.mainMember.enforcedPercentage / 100;
      int enforcedCount = (ages.length * enforcementRate).round();
      ages = ages.take(enforcedCount).toList();
    } else if (customersIndex == 2) {
      // Not enforced policies - keep only not enforced percentage
      final notEnforcementRate =
          customerProfile.membersCountsData.mainMember.notEnforcedPercentage /
              100;
      int notEnforcedCount = (ages.length * notEnforcementRate).round();
      ages = ages.skip(ages.length - notEnforcedCount).toList();
    }

    return ages;
  }

  int _getMiddleAge(String ageRange) {
    List<String> rangeParts = ageRange.split('-');
    if (rangeParts.length == 2) {
      int startAge = int.tryParse(rangeParts[0]) ?? 0;
      int endAge = int.tryParse(rangeParts[1]) ?? 0;
      return ((startAge + endAge) / 2).round();
    }
    return 25; // Default fallback
  }

  int _getMainMemberMaleForAge(
      CustomerProfile customerProfile, String ageRange) {
    // Extract main member male count for specific age range
    final memberGroup = customerProfile.mainMemberAges[ageRange];
    if (memberGroup != null) {
      // Assuming roughly 60% male for main members (adjust based on your data)
      return (memberGroup.mainMember * 0.6).round();
    }
    return 0;
  }

  int _getMainMemberFemaleForAge(
      CustomerProfile customerProfile, String ageRange) {
    final memberGroup = customerProfile.mainMemberAges[ageRange];
    if (memberGroup != null) {
      // Assuming roughly 40% female for main members (adjust based on your data)
      return (memberGroup.mainMember * 0.4).round();
    }
    return 0;
  }

  List<LineChartBarData> _generateLineChartData(flypes? spots) {
    List<LineChartBarData> lines = [];

    if (spots != null) {
      lines.add(LineChartBarData(
        spots: spots.flspots,
        isCurved: true,
        color: Colors.blue,
        dotData: FlDotData(show: false),
      ));
    }

    return lines;
  }

  List<BarChartGroupData> _generateMainMemberBarGroups(
      Map<String, dynamic> data, BuildContext context) {
    List<String> ageGroups = [
      "0-10",
      "11-20",
      "21-30",
      "31-40",
      "41-50",
      "51-60",
      "61-70",
      "71-80",
      "81-90",
      "91-100",
      "101-110",
      "111-120"
    ];

    return List.generate(ageGroups.length, (index) {
      final ageRange = ageGroups[index];

      double maleFrequency = 0;
      double femaleFrequency = 0;

      if (data["main_member"] != null &&
          data["main_member"]["male"] != null &&
          data["main_member"]["female"] != null) {
        maleFrequency = (data["main_member"]["male"][ageRange] ?? 0).toDouble();
        femaleFrequency =
            (data["main_member"]["female"][ageRange] ?? 0).toDouble();
      }

      double totalFrequency = maleFrequency + femaleFrequency;

      // Calculate bar width
      int numberOfBars = 12; // Number of age groups
      double chartWidth = MediaQuery.of(context).size.width;
      double maxBarWidth = 30;
      double minBarSpace = 10;
      double barWidth = min(maxBarWidth, (chartWidth / (2 * numberOfBars)));

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: totalFrequency,
            color: Colors.grey,
            width: barWidth,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
        barsSpace: minBarSpace,
      );
    });
  }

  Widget _buildBarChart(List<BarChartGroupData> barGroups) {
    List<String> ageGroups = [
      "0-10",
      "11-20",
      "21-30",
      "31-40",
      "41-50",
      "51-60",
      "61-70",
      "71-80",
      "81-90",
      "91-100",
      "101-110",
      "111-120"
    ];

    return Container(
      height: 320,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (value, meta) {
                  if (value.round() < ageGroups.length) {
                    return Text(
                      ageGroups[value.round()],
                      style: TextStyle(fontSize: 7),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false, reservedSize: 30),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (value, meta) {
                  if (value != value.round()) {
                    return Container();
                  }
                  return Text(
                    formatLargeNumber3(value.round().toString()),
                    style: TextStyle(fontSize: 8.5),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              left: BorderSide(color: Colors.grey, width: 1),
              right: BorderSide(color: Colors.transparent),
              bottom: BorderSide(color: Colors.transparent),
              top: BorderSide(color: Colors.transparent),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.20),
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
          barGroups: barGroups,
          groupsSpace: 10,
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (value) => Colors.blueGrey,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                if (rod.toY == 0) {
                  return null;
                }
                return BarTooltipItem(
                  rod.toY.toString(),
                  const TextStyle(color: Colors.black),
                );
              },
            ),
            touchCallback:
                (FlTouchEvent flTouchEvent, BarTouchResponse? touchResponse) {},
            handleBuiltInTouches: false,
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart(List<LineChartBarData> lines, flypes? spots) {
    return SizedBox(
      height: 320,
      child: LineChart(
        LineChartData(
          lineBarsData: lines,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.round().toString(),
                    style: TextStyle(fontSize: 11),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false, reservedSize: 30),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(2),
                    style: TextStyle(fontSize: 8.5),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (value) => Colors.blueGrey,
            ),
            handleBuiltInTouches: false,
          ),
          minX: 0,
          maxX: 100,
          extraLinesData: ExtraLinesData(
            verticalLines: [
              if (spots != null)
                VerticalLine(
                  x: spots.mean_hor,
                  color: Colors.blue,
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClaimsBellCurveChart extends StatelessWidget {
  final int selectedButton;
  final int daysDifference;
  final int customersIndex;
  final int targetIndex7;

  ClaimsBellCurveChart({
    Key? key,
    required this.customersIndex,
    required this.selectedButton,
    required this.daysDifference,
    required this.targetIndex7,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get customer profile from Constants
    final CustomerProfile? customerProfile = Constants.currentCustomerProfile;

    if (customerProfile == null) {
      return _buildNoDataWidget(context);
    }

    // Extract claims data from CustomerProfile
    final claimsAgeDistributionData =
        _getClaimsAgeDistributionData(customerProfile);
    final claimsAgeDistributionLists =
        _getClaimsAgeDistributionLists(customerProfile);

    // Generate spots for line chart
    flypes? spots =
        generateSkewedSpots(claimsAgeDistributionLists["main_member"] ?? []);
    flypes? spots2 =
        generateSkewedSpots(claimsAgeDistributionLists["partner"] ?? []);
    flypes? spots3 =
        generateSkewedSpots(claimsAgeDistributionLists["child"] ?? []);
    flypes? spots4 = generateSkewedSpots(
        claimsAgeDistributionLists["extended_family"] ?? []);

    // Check if we have sufficient data
    bool noDataAvailable =
        _checkIfNoDataAvailable(spots, spots2, spots3, spots4);

    if (noDataAvailable) {
      return _buildNoDataWidget(context);
    }

    // Generate bar chart data
    List<BarChartGroupData> barGroups =
        _generateClaimsBarGroups(claimsAgeDistributionData, context);

    // Generate line chart data
    List<LineChartBarData> lines =
        _generateLineChartData(spots, spots2, spots3, spots4);

    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 24, top: 12),
      child: Column(
        children: [
          if (targetIndex7 == 0)
            _buildLineChart(lines, spots, spots2, spots3, spots4),
          if (targetIndex7 == 1) _buildBarChart(barGroups),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: MemberTypeGrid(),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getClaimsAgeDistributionData(
      CustomerProfile customerProfile) {
    // Get claims age distribution by gender and type based on selected button and customers index

    if (customersIndex == 0) {
      // Total claims data - use original claims age distribution
      return customerProfile.claimsData.genderDistribution.ageGroups
          .map((ageRange, ageGenderData) {
        return MapEntry(ageRange, {
          'main_member': {
            'male': _getClaimsMainMemberMaleForAge(customerProfile, ageRange),
            'female':
                _getClaimsMainMemberFemaleForAge(customerProfile, ageRange),
          },
          'partner': {
            'male': _getClaimsPartnerMaleForAge(customerProfile, ageRange),
            'female': _getClaimsPartnerFemaleForAge(customerProfile, ageRange),
          },
          'child': {
            'male': _getClaimsChildMaleForAge(customerProfile, ageRange),
            'female': _getClaimsChildFemaleForAge(customerProfile, ageRange),
          },
        });
      });
    } else if (customersIndex == 1) {
      // Enforced claims policies data
      return _getEnforcedClaimsAgeDistribution(customerProfile);
    } else {
      // Not enforced claims policies data
      return _getNotEnforcedClaimsAgeDistribution(customerProfile);
    }
  }

  Map<String, List<dynamic>> _getClaimsAgeDistributionLists(
      CustomerProfile customerProfile) {
    // Extract claims age distribution lists from CustomerProfile
    // Using deceased ages and claims data

    return {
      "main_member": _calculateClaimsMainMemberAges(customerProfile),
      "partner": _calculateClaimsPartnerAges(customerProfile),
      "child": _calculateClaimsChildAges(customerProfile),
      "extended_family": _calculateClaimsExtendedFamilyAges(customerProfile),
    };
  }

  List<dynamic> _calculateClaimsMainMemberAges(
      CustomerProfile customerProfile) {
    // Use deceased ages list as primary source for claims ages
    List<int> ages = [];

    // Add deceased ages (these are primarily main members)
    ages.addAll(customerProfile.deceasedAgesList);

    // If we have additional claims data from members counts, add those
    final claimsMainMemberTotal =
        customerProfile.claimsData.membersCountsData.mainMember.total;
    if (claimsMainMemberTotal > ages.length) {
      // Fill in additional ages based on age distribution
      customerProfile.claimsData.genderDistribution.ageGroups
          .forEach((ageRange, ageGenderData) {
        int middleAge = _getMiddleAge(ageRange);
        int totalForAge = ageGenderData.total;
        for (int i = 0; i < totalForAge; i++) {
          ages.add(middleAge);
        }
      });
    }

    return ages;
  }

  List<dynamic> _calculateClaimsPartnerAges(CustomerProfile customerProfile) {
    List<int> ages = [];

    // Calculate partner ages from claims data
    final claimsPartnerTotal =
        customerProfile.claimsData.membersCountsData.partner.total;
    customerProfile.claimsData.genderDistribution.ageGroups
        .forEach((ageRange, ageGenderData) {
      int middleAge = _getMiddleAge(ageRange);
      // Assuming some proportion of claims come from partners
      int partnerClaimsForAge =
          (ageGenderData.total * 0.1).round(); // 10% assumption
      for (int i = 0; i < partnerClaimsForAge; i++) {
        ages.add(middleAge);
      }
    });

    return ages;
  }

  List<dynamic> _calculateClaimsChildAges(CustomerProfile customerProfile) {
    List<int> ages = [];

    // Calculate child ages from claims data
    final claimsChildTotal =
        customerProfile.claimsData.membersCountsData.child.total;
    customerProfile.claimsData.genderDistribution.ageGroups
        .forEach((ageRange, ageGenderData) {
      int middleAge = _getMiddleAge(ageRange);
      // Only include ages that would be children (under 21)
      if (middleAge <= 21) {
        int childClaimsForAge =
            (ageGenderData.total * 0.05).round(); // 5% assumption
        for (int i = 0; i < childClaimsForAge; i++) {
          ages.add(middleAge);
        }
      }
    });

    return ages;
  }

  List<dynamic> _calculateClaimsExtendedFamilyAges(
      CustomerProfile customerProfile) {
    // Extended family claims - typically minimal
    return [];
  }

  int _getMiddleAge(String ageRange) {
    List<String> rangeParts = ageRange.split('-');
    if (rangeParts.length == 2) {
      int startAge = int.tryParse(rangeParts[0]) ?? 0;
      int endAge = int.tryParse(rangeParts[1]) ?? 0;
      return ((startAge + endAge) / 2).round();
    }
    return 25; // Default fallback
  }

  int _getClaimsMainMemberMaleForAge(
      CustomerProfile customerProfile, String ageRange) {
    // Extract claims main member male count for specific age range
    final ageGenderData =
        customerProfile.claimsData.genderDistribution.ageGroups[ageRange];
    if (ageGenderData != null) {
      return (ageGenderData.male * 0.8)
          .round(); // 80% assumption for main members
    }
    return 0;
  }

  int _getClaimsMainMemberFemaleForAge(
      CustomerProfile customerProfile, String ageRange) {
    final ageGenderData =
        customerProfile.claimsData.genderDistribution.ageGroups[ageRange];
    if (ageGenderData != null) {
      return (ageGenderData.female * 0.8)
          .round(); // 80% assumption for main members
    }
    return 0;
  }

  int _getClaimsPartnerMaleForAge(
      CustomerProfile customerProfile, String ageRange) {
    final ageGenderData =
        customerProfile.claimsData.genderDistribution.ageGroups[ageRange];
    if (ageGenderData != null) {
      return (ageGenderData.male * 0.15).round(); // 15% assumption for partners
    }
    return 0;
  }

  int _getClaimsPartnerFemaleForAge(
      CustomerProfile customerProfile, String ageRange) {
    final ageGenderData =
        customerProfile.claimsData.genderDistribution.ageGroups[ageRange];
    if (ageGenderData != null) {
      return (ageGenderData.female * 0.15)
          .round(); // 15% assumption for partners
    }
    return 0;
  }

  int _getClaimsChildMaleForAge(
      CustomerProfile customerProfile, String ageRange) {
    final ageGenderData =
        customerProfile.claimsData.genderDistribution.ageGroups[ageRange];
    if (ageGenderData != null && _getMiddleAge(ageRange) <= 21) {
      return (ageGenderData.male * 0.05).round(); // 5% assumption for children
    }
    return 0;
  }

  int _getClaimsChildFemaleForAge(
      CustomerProfile customerProfile, String ageRange) {
    final ageGenderData =
        customerProfile.claimsData.genderDistribution.ageGroups[ageRange];
    if (ageGenderData != null && _getMiddleAge(ageRange) <= 21) {
      return (ageGenderData.female * 0.05)
          .round(); // 5% assumption for children
    }
    return 0;
  }

  Map<String, dynamic> _getEnforcedClaimsAgeDistribution(
      CustomerProfile customerProfile) {
    // Calculate enforced claims policies distribution
    final enforcementRate = customerProfile
            .claimsData.membersCountsData.mainMember.enforcedPercentage /
        100;

    return customerProfile.claimsData.genderDistribution.ageGroups
        .map((ageRange, ageGenderData) {
      return MapEntry(ageRange, {
        'main_member': {
          'male': (_getClaimsMainMemberMaleForAge(customerProfile, ageRange) *
                  enforcementRate)
              .round(),
          'female':
              (_getClaimsMainMemberFemaleForAge(customerProfile, ageRange) *
                      enforcementRate)
                  .round(),
        },
        'partner': {
          'male': (_getClaimsPartnerMaleForAge(customerProfile, ageRange) *
                  enforcementRate)
              .round(),
          'female': (_getClaimsPartnerFemaleForAge(customerProfile, ageRange) *
                  enforcementRate)
              .round(),
        },
        'child': {
          'male': (_getClaimsChildMaleForAge(customerProfile, ageRange) *
                  enforcementRate)
              .round(),
          'female': (_getClaimsChildFemaleForAge(customerProfile, ageRange) *
                  enforcementRate)
              .round(),
        },
      });
    });
  }

  Map<String, dynamic> _getNotEnforcedClaimsAgeDistribution(
      CustomerProfile customerProfile) {
    // Calculate not enforced claims policies distribution
    final notEnforcementRate = customerProfile
            .claimsData.membersCountsData.mainMember.notEnforcedPercentage /
        100;

    return customerProfile.claimsData.genderDistribution.ageGroups
        .map((ageRange, ageGenderData) {
      return MapEntry(ageRange, {
        'main_member': {
          'male': (_getClaimsMainMemberMaleForAge(customerProfile, ageRange) *
                  notEnforcementRate)
              .round(),
          'female':
              (_getClaimsMainMemberFemaleForAge(customerProfile, ageRange) *
                      notEnforcementRate)
                  .round(),
        },
        'partner': {
          'male': (_getClaimsPartnerMaleForAge(customerProfile, ageRange) *
                  notEnforcementRate)
              .round(),
          'female': (_getClaimsPartnerFemaleForAge(customerProfile, ageRange) *
                  notEnforcementRate)
              .round(),
        },
        'child': {
          'male': (_getClaimsChildMaleForAge(customerProfile, ageRange) *
                  notEnforcementRate)
              .round(),
          'female': (_getClaimsChildFemaleForAge(customerProfile, ageRange) *
                  notEnforcementRate)
              .round(),
        },
      });
    });
  }

  bool _checkIfNoDataAvailable(
      flypes? spots, flypes? spots2, flypes? spots3, flypes? spots4) {
    return (spots == null &&
            spots2 == null &&
            spots3 == null &&
            spots4 == null) ||
        ((spots?.flspots.length ?? 0) < 3 &&
            (spots2?.flspots.length ?? 0) < 3 &&
            (spots3?.flspots.length ?? 0) < 3 &&
            (spots4?.flspots.length ?? 0) < 3);
  }

  Widget _buildNoDataWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16, top: 16),
      child: Container(
        height: 700,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No claims data available for the selected range",
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
            )
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateClaimsBarGroups(
      Map<String, dynamic> data, BuildContext context) {
    List<String> ageGroups = [
      "0-10",
      "11-20",
      "21-30",
      "31-40",
      "41-50",
      "51-60",
      "61-70",
      "71-80",
      "81-90",
      "91-100",
      "101-110",
      "111-120"
    ];

    return List.generate(ageGroups.length, (index) {
      final ageRange = ageGroups[index];
      double cumulativeAmount = 0;

      List<BarChartRodStackItem> rodStackItems = [];

      // Define the order of colors
      Map<Color, int> colorOrder = {
        Colors.green: 1,
        Colors.blue: 2,
        Colors.purple: 3,
        Colors.orange: 4,
      };

      // Add stack items for main_member, partner, and child
      ['main_member', 'partner', 'child'].forEach((role) {
        if (data[ageRange] != null && data[ageRange][role] != null) {
          final maleFrequency = (data[ageRange][role]["male"] ?? 0).toDouble();
          final femaleFrequency =
              (data[ageRange][role]["female"] ?? 0).toDouble();

          double totalFrequency = maleFrequency + femaleFrequency;
          if (totalFrequency > 0) {
            rodStackItems.add(BarChartRodStackItem(
              cumulativeAmount,
              cumulativeAmount + totalFrequency,
              getColorForRole(role),
            ));
            cumulativeAmount += totalFrequency;
          }
        }
      });

      // Sort by predefined color order
      rodStackItems
          .sort((a, b) => colorOrder[a.color]!.compareTo(colorOrder[b.color]!));
      rodStackItems = rodStackItems.reversed.toList();

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: cumulativeAmount,
            width: 22,
            rodStackItems: rodStackItems,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
      );
    });
  }

  List<LineChartBarData> _generateLineChartData(
    flypes? spots,
    flypes? spots2,
    flypes? spots3,
    flypes? spots4,
  ) {
    List<LineChartBarData> lines = [];

    if (spots != null) {
      lines.add(LineChartBarData(
        spots: spots.flspots,
        isCurved: true,
        color: Colors.blue,
        dotData: FlDotData(show: false),
      ));
    }
    if (spots2 != null) {
      lines.add(LineChartBarData(
        spots: spots2.flspots,
        isCurved: true,
        color: Colors.orange,
        dotData: FlDotData(show: false),
      ));
    }
    if (spots3 != null) {
      lines.add(LineChartBarData(
        spots: spots3.flspots,
        isCurved: true,
        color: Colors.green,
        dotData: FlDotData(show: false),
      ));
    }
    if (spots4 != null) {
      lines.add(LineChartBarData(
        spots: spots4.flspots,
        isCurved: true,
        color: Colors.purple,
        dotData: FlDotData(show: false),
      ));
    }

    return lines;
  }

  Widget _buildLineChart(
    List<LineChartBarData> lines,
    flypes? spots,
    flypes? spots2,
    flypes? spots3,
    flypes? spots4,
  ) {
    return Container(
      height: 320,
      child: LineChart(
        LineChartData(
          lineBarsData: lines,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.round().toString(),
                    style: TextStyle(fontSize: 11),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false, reservedSize: 30),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(2),
                    style: TextStyle(fontSize: 8.5),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (value) => Colors.blueGrey,
            ),
            handleBuiltInTouches: false,
          ),
          minX: 0,
          maxX: 100,
          extraLinesData: ExtraLinesData(
            verticalLines: [
              if (spots != null)
                VerticalLine(
                  x: spots.mean_hor,
                  color: Colors.blue,
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
              if (spots2 != null)
                VerticalLine(
                  x: spots2.mean_hor,
                  color: Colors.orange,
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
              if (spots3 != null)
                VerticalLine(
                  x: spots3.mean_hor,
                  color: Colors.green,
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
              if (spots4 != null)
                VerticalLine(
                  x: spots4.mean_hor,
                  color: Colors.purple,
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart(List<BarChartGroupData> barGroups) {
    List<String> ageGroups = [
      "0-10",
      "11-20",
      "21-30",
      "31-40",
      "41-50",
      "51-60",
      "61-70",
      "71-80",
      "81-90",
      "91-100",
      "101-110",
      "111-120"
    ];

    return Container(
      height: 320,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (value, meta) {
                  if (value.round() < ageGroups.length) {
                    return Text(
                      ageGroups[value.round()],
                      style: TextStyle(fontSize: 7),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false, reservedSize: 30),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (value, meta) {
                  if (value != value.round()) {
                    return Container();
                  } else {
                    return Text(
                      formatLargeNumber3(value.round().toString()),
                      style: TextStyle(fontSize: 8.5),
                    );
                  }
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              left: BorderSide(color: Colors.grey, width: 1),
              right: BorderSide(color: Colors.transparent),
              bottom: BorderSide(color: Colors.transparent),
              top: BorderSide(color: Colors.transparent),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.20),
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
          barGroups: barGroups,
          groupsSpace: 10,
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (value) => Colors.blueGrey,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                if (rod.toY == 0) {
                  return null;
                }
                return BarTooltipItem(
                  rod.toY.toString(),
                  const TextStyle(color: Colors.black),
                );
              },
            ),
            touchCallback:
                (FlTouchEvent flTouchEvent, BarTouchResponse? touchResponse) {},
            handleBuiltInTouches: false,
          ),
        ),
      ),
    );
  }

  Color getColorForRole(String type) {
    switch (type) {
      case 'main_member':
        return Colors.blue;
      case 'partner':
        return Colors.orange;
      case 'child':
        return Colors.purple;
      case 'extended':
        return Colors.green;
      default:
        return Colors.green; // Default case for unexpected types
    }
  }
}
