import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mi_insights/constants/Constants.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../admin/ClientSearchPage.dart';
import '../../customwidgets/CustomCard.dart';
import '../../customwidgets/RdialGauge.dart';
import '../../customwidgets/custom_date_range_picker.dart';
import '../../models/ClaimStageCategory.dart';
import '../../services/MyNoyifier.dart';
import '../../services/claims_service.dart';
import '../../services/inactivitylogoutmixin.dart';
import '../../services/window_manager.dart';

int noOfDaysThisMonth = 30;
bool isLoadingClaimsData = false;
bool isLoadingClaimsData2 = false;
bool isShowingType = false;
bool isShowingPaidClaims = false;
bool isShowingNotPaidClaims = false;
bool isShowingRepudiatedPaidClaims = false;
final claimsValue = ValueNotifier<int>(0);
bool isSalesDataLoading1a = false;
bool isSalesDataLoading2a = false;
bool isSalesDataLoading3a = false;
double totalAmount = 0;
MyNotifier? myNotifier;
DateTime datefrom = DateTime.now().subtract(Duration(days: 60));
DateTime dateto = DateTime.now();
int days_difference = 0;
int grid_index = 0;
int grid_index_6 = 0;
int target_index = 0;
List<String> grid_strings = ["Paid", "In Progress", "Decld. & Repdtd."];
int report_index = 0;
int claims_index = 0;
int claims_inrogress = 0;
double _sliderPosition5 = 0.0;
String data2 = "";
Key key_mnut1 = UniqueKey();
int touchedIndex = -1;
double actual_collected_premium = 0;
double expected_sum_of_premiums = 0;
int expected_count_of_premiums = 0;
double variance_sum_of_premiums = 0;
double sum_of_premiums = 0;
int variance_count_of_premiums = 0;
Map<String, double> claims_by_category1a_processed = {};
double _sliderPosition6 = 0.0;
double _sliderPosition2 = 0.0;
Key key_rut1 = UniqueKey();

class ClaimsReport extends StatefulWidget {
  const ClaimsReport({Key? key}) : super(key: key);

  @override
  State<ClaimsReport> createState() => _ClaimsReportState();
}

List<Map<String, dynamic>> leads = [];
List<List<Map<String, dynamic>>> policies = [];
double _sliderPosition = 0.0;
int _selectedButton = 1;
UniqueKey uq1 = UniqueKey();

class _ClaimsReportState extends State<ClaimsReport>
    with InactivityLogoutMixin {
  Color _button1Color = Colors.grey.withOpacity(0.0);
  Color _button2Color = Colors.grey.withOpacity(0.0);
  Color _button3Color = Colors.grey.withOpacity(0.0);

  void _animateButton(int buttonNumber) {
    DateTime? startDate = DateTime.now();
    DateTime? endDate = DateTime.now();
    leads = [];
    restartInactivityTimer();

    setState(() {});

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
        isLoadingClaimsData = true;
      });
      DateTime now = DateTime.now();

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
      Constants.claims_formattedStartDate =
          DateFormat('yyyy-MM-dd').format(startDate!);
      Constants.claims_formattedEndDate =
          DateFormat('yyyy-MM-dd').format(endDate!);
      days_difference = endDate.difference(startDate).inDays;

      // Call getClaimsReport
      getClaimsReport(Constants.claims_formattedStartDate,
              Constants.claims_formattedEndDate, buttonNumber, context)
          .then((value) {
        if (mounted)
          setState(() {
            isLoadingClaimsData = false;
          });
      }).catchError((error) {
        if (kDebugMode) {
          print("❌ Error in _animateButton getClaimsReport: $error");
        }
        if (mounted)
          setState(() {
            isLoadingClaimsData = false;
          });
      });

      setState(() {});
    } else {
      showCustomDateRangePicker(
        context,
        dismissible: true,
        minimumDate: DateTime.utc(2023, 06, 01),
        maximumDate: DateTime.now().add(Duration(days: 360)),
        /*    endDate: endDate,
        startDate: startDate,*/
        backgroundColor: Colors.white,
        primaryColor: Constants.ctaColorLight,
        onApplyClick: (start, end) {
          restartInactivityTimer();
          setState(() {
            endDate = end;
            startDate = start;
          });

          Constants.claims_formattedStartDate =
              DateFormat('yyyy-MM-dd').format(startDate!);
          Constants.claims_formattedEndDate =
              DateFormat('yyyy-MM-dd').format(endDate!);
          setState(() {});

          String dateRange =
              '${Constants.claims_formattedStartDate} - ${Constants.claims_formattedEndDate}';
          print("currently loading ${dateRange}");
          DateTime startDateTime = DateFormat('yyyy-MM-dd')
              .parse(Constants.claims_formattedStartDate);
          DateTime endDateTime =
              DateFormat('yyyy-MM-dd').parse(Constants.claims_formattedEndDate);

          days_difference = endDateTime.difference(startDateTime).inDays;
          if (kDebugMode) {
            print("days_difference ${days_difference}");
            print("formattedEndDate9fgfg ${Constants.claims_formattedEndDate}");
          }
          getClaimsReport(Constants.claims_formattedStartDate,
              Constants.claims_formattedEndDate, 3, context);
          isLoadingClaimsData = true;
          setState(() {});
        },
        onCancelClick: () {
          restartInactivityTimer();
          setState(() {
            // endDate = null;
            //  startDate = null;
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

  void _animateButton5(int buttonNumber) {
    restartInactivityTimer();

    setState(() {});

    grid_index = buttonNumber;
    if (buttonNumber == 0) {
      _sliderPosition5 = 0.0;
    } else if (buttonNumber == 1) {
      _sliderPosition5 = (MediaQuery.of(context).size.width / 3) - 18;
    } else if (buttonNumber == 2) {
      _sliderPosition5 = 2 * (MediaQuery.of(context).size.width / 3) - 32;
    }
    setState(() {});
  }

  void _animateButton6(int buttonNumber) {
    uq1 = UniqueKey();
    setState(() {});

    if (buttonNumber == 0) {
      _sliderPosition6 = 0.0;
    } else if (buttonNumber == 1) {
      _sliderPosition6 = (MediaQuery.of(context).size.width / 3) - 18;
    } else if (buttonNumber == 2) {
      _sliderPosition6 = 2 * (MediaQuery.of(context).size.width / 3) - 32;
    }
    setState(() {});
    grid_index_6 = buttonNumber;
    setState(() {});
    restartInactivityTimer();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              elevation: 12,
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
              surfaceTintColor: Colors.white,
              shadowColor: Colors.black.withOpacity(0.6),
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
              centerTitle: true,
              title: const Text(
                "Claims Report",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
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
                  child: Column(children: [
                    SizedBox(
                      height: 12,
                    ),
                    isLoadingClaimsData
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
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _animateButton(3);
                                        /*     Fluttertoast.showToast(
                                        msg: "Currently Unavailable",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);*/
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
                                  restartInactivityTimer();
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
                    SizedBox(
                      height: 8,
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
                                            'Intermediary Stages',
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
                                            'Underwriter Stages',
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
                                              'Intermediary Stages',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : target_index == 1
                                            ? Center(
                                                child: Text(
                                                  'Underwriter Stages',
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
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            /*  Padding(
                        padding: const EdgeInsets.only(
                            left: 0.0, top: 12, bottom: 0),
                        child: Center(
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(360)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16, top: 8, bottom: 8),
                                child: Text("Claims Processing Stages"),
                              )),
                        ),
                      ),*/

                            Container(
                              child: SingleChildScrollView(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (target_index == 0)
                                    Row(
                                      children: [
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Container(
                                            height: 120,
                                            child: InkWell(
                                                onTap: () {
                                                  restartInactivityTimer();
                                                },
                                                child: Container(
                                                  height: 120,
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
                                                                                Constants.ftaColorLight,
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
                                                                                      "R ${formatLargeNumber3(((_selectedButton == 1 ? Constants.claims_sum_by_category1a["Lodging"] ?? 0 : _selectedButton == 2 ? Constants.claims_sum_by_category2a["Lodging"] ?? 0 : _selectedButton == 3 && days_difference <= 31 ? Constants.claims_sum_by_category3a["Lodging"] ?? 0 : Constants.claims_sum_by_category3b["Lodging"] ?? 0).toString()))}",
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
                                                                                    (_selectedButton == 1
                                                                                            ? Constants.claims_by_category1a["Lodging"] ?? 0
                                                                                            : _selectedButton == 2
                                                                                                ? Constants.claims_by_category2a["Lodging"] ?? 0
                                                                                                : _selectedButton == 3 && days_difference <= 31
                                                                                                    ? Constants.claims_by_category3a["Lodging"] ?? 0
                                                                                                    : Constants.claims_by_category3b["Lodging"] ?? 0)
                                                                                        .toStringAsFixed(0),
                                                                                    style: TextStyle(fontSize: 12.5),
                                                                                    textAlign: TextAlign.center,
                                                                                    maxLines: 1,
                                                                                  ),
                                                                                )),
                                                                                const Center(
                                                                                    child: Padding(
                                                                                  padding: EdgeInsets.all(6.0),
                                                                                  child: Text(
                                                                                    "Lodging",
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
                                                                                Constants.ftaColorLight,
                                                                            width: 6))),
                                                                child: Column(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.grey.withOpacity(0.0),
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
                                                                                      "R ${formatLargeNumber3(((_selectedButton == 1 ? Constants.claims_sum_by_category1a["Processing"] ?? 0 : _selectedButton == 2 ? Constants.claims_sum_by_category2a["Processing"] ?? 0 : _selectedButton == 3 && days_difference <= 31 ? Constants.claims_sum_by_category3a["Processing"] ?? 0 : Constants.claims_sum_by_category3b["Processing"] ?? 0).toString()))}",
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
                                                                                    (_selectedButton == 1
                                                                                            ? Constants.claims_by_category1a["Processing"] ?? 0
                                                                                            : _selectedButton == 2
                                                                                                ? Constants.claims_by_category2a["Processing"] ?? 0
                                                                                                : _selectedButton == 3 && days_difference <= 31
                                                                                                    ? Constants.claims_by_category3a["Processing"] ?? 0
                                                                                                    : Constants.claims_by_category3b["Processing"] ?? 0)
                                                                                        .toStringAsFixed(0),
                                                                                    style: TextStyle(fontSize: 12.5),
                                                                                    textAlign: TextAlign.center,
                                                                                    maxLines: 1,
                                                                                  ),
                                                                                )),
                                                                                Center(
                                                                                    child: Padding(
                                                                                  padding: const EdgeInsets.all(6.0),
                                                                                  child: Text(
                                                                                    "Processing",
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
                                                                                Constants.ftaColorLight,
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
                                                                                      "R ${formatLargeNumber3(((_selectedButton == 1 ? Constants.claims_sum_by_category1a["Closed"] ?? 0 : _selectedButton == 2 ? Constants.claims_sum_by_category2a["Closed"] ?? 0 : _selectedButton == 3 && days_difference <= 31 ? Constants.claims_sum_by_category3a["Closed"] ?? 0 : Constants.claims_sum_by_category3b["Closed"] ?? 0).toString()))}",
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
                                                                                    (_selectedButton == 1
                                                                                            ? Constants.claims_by_category1a["Closed"] ?? 0
                                                                                            : _selectedButton == 2
                                                                                                ? Constants.claims_by_category2a["Closed"] ?? 0
                                                                                                : _selectedButton == 3 && days_difference <= 31
                                                                                                    ? Constants.claims_by_category3a["Closed"] ?? 0
                                                                                                    : Constants.claims_by_category3b["Closed"] ?? 0)
                                                                                        .toStringAsFixed(0),
                                                                                    style: TextStyle(fontSize: 12.5),
                                                                                    textAlign: TextAlign.center,
                                                                                    maxLines: 1,
                                                                                  ),
                                                                                )),
                                                                                Center(
                                                                                    child: Padding(
                                                                                  padding: const EdgeInsets.all(6.0),
                                                                                  child: Text(
                                                                                    "Failed",
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
                                      ],
                                    ),

                                  if (target_index == 1)
                                    Row(
                                      children: [
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Container(
                                            height: 120,
                                            child: InkWell(
                                                onTap: () {
                                                  restartInactivityTimer();
                                                },
                                                child: Container(
                                                  height: 120,
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
                                                                                Constants.ftaColorLight,
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
                                                                                      "R ${formatLargeNumber3(((_selectedButton == 1 ? Constants.claims_sum_by_category1a["In Progress"] ?? 0 : _selectedButton == 2 ? Constants.claims_sum_by_category2a["In Progress"] ?? 0 : _selectedButton == 3 && days_difference <= 31 ? Constants.claims_sum_by_category3a["In Progress"] ?? 0 : Constants.claims_sum_by_category3b["In Progress"] ?? 0).toString()))}",
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
                                                                                    (_selectedButton == 1
                                                                                            ? Constants.claims_by_category1a["In Progress"] ?? 0
                                                                                            : _selectedButton == 2
                                                                                                ? Constants.claims_by_category2a["In Progress"] ?? 0
                                                                                                : _selectedButton == 3 && days_difference <= 31
                                                                                                    ? Constants.claims_by_category3a["In Progress"] ?? 0
                                                                                                    : Constants.claims_by_category3b["In Progress"] ?? 0)
                                                                                        .toStringAsFixed(0),
                                                                                    style: TextStyle(fontSize: 12.5),
                                                                                    textAlign: TextAlign.center,
                                                                                    maxLines: 1,
                                                                                  ),
                                                                                )),
                                                                                Center(
                                                                                    child: Padding(
                                                                                  padding: const EdgeInsets.all(6.0),
                                                                                  child: Text(
                                                                                    "Assessment",
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
                                                                                Constants.ftaColorLight,
                                                                            width: 6))),
                                                                child: Column(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.grey.withOpacity(0.0),
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
                                                                                      "R ${formatLargeNumber3(((_selectedButton == 1 ? Constants.claims_sum_by_category1a["Paid"] ?? 0 : _selectedButton == 2 ? Constants.claims_sum_by_category2a["Paid"] ?? 0 : _selectedButton == 3 && days_difference <= 31 ? Constants.claims_sum_by_category3a["Paid"] ?? 0 : Constants.claims_sum_by_category3b["Paid"] ?? 0).toString()))}",
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
                                                                                    (_selectedButton == 1
                                                                                            ? Constants.claims_by_category1a["Paid"] ?? 0
                                                                                            : _selectedButton == 2
                                                                                                ? Constants.claims_by_category2a["Paid"] ?? 0
                                                                                                : _selectedButton == 3 && days_difference <= 31
                                                                                                    ? Constants.claims_by_category3a["Paid"] ?? 0
                                                                                                    : Constants.claims_by_category3b["Paid"] ?? 0)
                                                                                        .toStringAsFixed(0),
                                                                                    style: TextStyle(fontSize: 12.5),
                                                                                    textAlign: TextAlign.center,
                                                                                    maxLines: 1,
                                                                                  ),
                                                                                )),
                                                                                Center(
                                                                                    child: Padding(
                                                                                  padding: const EdgeInsets.all(6.0),
                                                                                  child: Text(
                                                                                    "Paid",
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
                                                                                Constants.ftaColorLight,
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
                                                                                      "R ${formatLargeNumber3(((_selectedButton == 1 ? Constants.claims_sum_by_category1a["Declined And Repudiated"] ?? 0 : _selectedButton == 2 ? Constants.claims_sum_by_category2a["Declined And Repudiated"] ?? 0 : _selectedButton == 3 && days_difference <= 31 ? Constants.claims_sum_by_category3a["Declined And Repudiated"] ?? 0 : Constants.claims_sum_by_category3b["Declined And Repudiated"] ?? 0).toString()))}",
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
                                                                                    (_selectedButton == 1
                                                                                            ? Constants.claims_by_category1a["Declined And Repudiated"] ?? 0
                                                                                            : _selectedButton == 2
                                                                                                ? Constants.claims_by_category2a["Declined And Repudiated"] ?? 0
                                                                                                : _selectedButton == 3 && days_difference <= 31
                                                                                                    ? Constants.claims_by_category3a["Declined And Repudiated"] ?? 0
                                                                                                    : Constants.claims_by_category3b["Declined And Repudiated"] ?? 0)
                                                                                        .toStringAsFixed(0),
                                                                                    style: TextStyle(fontSize: 12.5),
                                                                                    textAlign: TextAlign.center,
                                                                                    maxLines: 1,
                                                                                  ),
                                                                                )),
                                                                                Center(
                                                                                    child: Padding(
                                                                                  padding: const EdgeInsets.all(6.0),
                                                                                  child: Text(
                                                                                    "Decl. & Rep'd*",
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
                                      ],
                                    ),
                                  if (target_index == 1)
                                    Row(
                                      children: [
                                        Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 2.0, top: 0),
                                          child: Text(
                                            "*",
                                            style: TextStyle(fontSize: 9),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 20.0, bottom: 4),
                                          child: Text(
                                            "Declined & Repudiated",
                                            style: TextStyle(fontSize: 8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  SizedBox(height: 8),
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
                                                      "Claims Ratio (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
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
                                                            left: 16.0,
                                                            right: 16,
                                                            bottom: 8),
                                                    child: Text(
                                                        "Claims Ratio  (12 Months View)"),
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
                                                              left: 16.0,
                                                              right: 16,
                                                              bottom: 8),
                                                      child: Text(
                                                          "Claims Ratio  (${Constants.claims_formattedStartDate} to ${Constants.claims_formattedEndDate})"),
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
                                    padding: const EdgeInsets.only(
                                        left: 6.0, right: 6),
                                    child: LinearPercentIndicator(
                                      width: MediaQuery.of(context).size.width -
                                          12,
                                      animation: true,
                                      lineHeight: 20.0,
                                      animationDuration: 500,
                                      percent: _selectedButton == 1
                                          ? (Constants.claims_ratio1a / 100)
                                          : _selectedButton == 2
                                              ? (Constants.claims_ratio2a / 100)
                                              : _selectedButton == 3 &&
                                                      days_difference <= 31
                                                  ? (Constants.claims_ratio3a /
                                                      100)
                                                  : (Constants.claims_ratio3b /
                                                      100),
                                      center: Text(
                                          "${_selectedButton == 1 ? (Constants.claims_ratio1a).toStringAsFixed(1) : _selectedButton == 2 ? (Constants.claims_ratio2a).toStringAsFixed(1) : _selectedButton == 3 && days_difference <= 31 ? (Constants.claims_ratio3a).toStringAsFixed(1) : (Constants.claims_ratio3b).toStringAsFixed(1)}%"),
                                      barRadius: ui.Radius.circular(12),
                                      //linearStrokeCap: LinearStrokeCap.roundAll,
                                      progressColor: Colors.green,
                                    ),
                                  ),

                                  _selectedButton == 1
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0, top: 20),
                                          child: Text(
                                              "Claims Ratio With Amounts (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                        )
                                      : _selectedButton == 2
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0, top: 20),
                                              child: Text(
                                                  "Claims Ratio With Amounts (Month on Month)"),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0, top: 20),
                                              child: Text(
                                                  "Claims Ratio With Amounts (${Constants.claims_formattedStartDate} to ${Constants.claims_formattedEndDate})"),
                                            ),
                                  SizedBox(
                                    height: 0,
                                  ),
                                  (isLoadingClaimsData == true ||
                                          (_selectedButton == 2 &&
                                              isLoadingClaimsData2 == true) ||
                                          (_selectedButton == 1 &&
                                              isLoadingClaimsData2 == true))
                                      ? Container(
                                          height: 250,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0, right: 12, top: 12),
                                            child: CustomCard(
                                                elevation: 6,
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
                                                )),
                                          ))
                                      : _selectedButton == 1
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  top: 8,
                                                  right: 16,
                                                  bottom: 16),
                                              child: CustomCard(
                                                elevation: 6,
                                                surfaceTintColor: Colors.white,
                                                color: Colors.white,
                                                child: isLoadingClaimsData ==
                                                        true
                                                    ? Container(
                                                        height: 250,
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
                                                    : isSalesDataLoading1a ==
                                                            true
                                                        ? Container(
                                                            height: 250,
                                                            child: CustomCard(
                                                              surfaceTintColor:
                                                                  Colors.white,
                                                              color:
                                                                  Colors.white,
                                                              elevation: 6,
                                                              child: Center(
                                                                child: Padding(
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
                                                                    )),
                                                              ),
                                                            ))
                                                        : Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            16.0,
                                                                        top:
                                                                            12),
                                                                child: Text(
                                                                  "MTD Allocated Premium = R ${formatLargeNumber((Constants.jsonMonthlyClaimsPremiumData1?[DateFormat('yyyy-MM').format(DateTime.now())] ?? 0).toString())}",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          13),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            16.0,
                                                                        top: 0),
                                                                child: Text(
                                                                  "MTD Paid Claims = R ${formatLargeNumber((Constants.claims_sum_paid1a).toString())}",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          13),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            16.0,
                                                                        top: 0),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      "MTD Difference = ",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          fontSize:
                                                                              13),
                                                                    ),
                                                                    Text(
                                                                      "R " +
                                                                          formatLargeNumber(((Constants.jsonMonthlyClaimsPremiumData1?[DateFormat('yyyy-MM').format(DateTime.now())] ?? 0) // Default to 0 if the value is null
                                                                                          -
                                                                                          (Constants.claims_sum_paid1a))
                                                                                      .toString() // Default to 0 if the value is null
                                                                                  )
                                                                              .toString(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          fontSize:
                                                                              13),
                                                                    ),
                                                                    Constants.jsonMonthlyClaimsPremiumData1?.isEmpty ??
                                                                            true
                                                                        ? Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 2.0),
                                                                            child:
                                                                                RotatedBox(
                                                                              quarterTurns: 2,
                                                                              child: SvgPicture.asset(
                                                                                "assets/icons/down-arrow-svgrepo-com.svg",
                                                                                width: 20,
                                                                                height: 20,
                                                                                color: Colors.green,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : ((Constants.jsonMonthlyClaimsPremiumData1?[DateFormat('yyyy-MM').format(DateTime.now())] ?? 0) // Default to 0 if the value is null
                                                                                    -
                                                                                    (Constants.claims_sum_paid1a)) <
                                                                                0
                                                                            ? Padding(
                                                                                padding: const EdgeInsets.only(left: 2.0),
                                                                                child: SvgPicture.asset(
                                                                                  "assets/icons/down-arrow-svgrepo-com.svg",
                                                                                  width: 20,
                                                                                  height: 20,
                                                                                  color: Colors.red,
                                                                                ),
                                                                              )
                                                                            : Padding(
                                                                                padding: const EdgeInsets.only(left: 2.0),
                                                                                child: RotatedBox(
                                                                                  quarterTurns: 2,
                                                                                  child: SvgPicture.asset(
                                                                                    "assets/icons/down-arrow-svgrepo-com.svg",
                                                                                    width: 20,
                                                                                    height: 20,
                                                                                    color: Colors.green,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 4),
                                                              Container(
                                                                  height: 200,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            0.0),
                                                                    child: CustomGaugeWithLabel3(
                                                                        maxValue:
                                                                            100,
                                                                        actualValue:
                                                                            Constants
                                                                                .claims_ratio1a,
                                                                        targetValue: Constants
                                                                            .claims_ratio1a
                                                                            .toDouble()),
                                                                  )),
                                                            ],
                                                          ),
                                              ),
                                            )
                                          : _selectedButton == 2
                                              ? Container(
                                                  height: 300,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4.0,
                                                            right: 4),
                                                    child: ClaimsReportGraph2(),
                                                  ))
                                              : _selectedButton == 3 &&
                                                      days_difference <= 31
                                                  ? Container(
                                                      height: 300,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 4.0,
                                                                right: 4),
                                                        child:
                                                            ClaimsReportGraph2(),
                                                      ))
                                                  : Container(
                                                      height: 300,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 4.0,
                                                                right: 4),
                                                        child:
                                                            ClaimsReportGraph2(),
                                                      )),
                                  SizedBox(height: 10),
                                  _selectedButton == 1
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0, top: 4),
                                          child: Text(
                                              "${target_index == 0 ? "Claims Intimation Stages" : "Claims Processing Stages"} (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                        )
                                      : _selectedButton == 2
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0, top: 4),
                                              child: Text(
                                                  "${target_index == 0 ? "Claims Intimation Stages" : "Claims Processing Stages"}(12 Months View)"),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0, top: 4),
                                              child: Text(
                                                  "${target_index == 0 ? "Claims Intimation Stages" : "Claims Processing Stages"} (${Constants.claims_formattedStartDate} to ${Constants.claims_formattedEndDate})"),
                                            ),
                                  if (target_index == 0)
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
                                                        _animateButton6(0);
                                                      },
                                                      child: Container(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                3) -
                                                            12,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        360)),
                                                        height: 35,
                                                        child: Center(
                                                          child: Text(
                                                            'Lodging',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        _animateButton6(1);
                                                      },
                                                      child: Container(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                3) -
                                                            12,
                                                        height: 35,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        360)),
                                                        child: Center(
                                                          child: Text(
                                                            'Processing',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
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
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                3) -
                                                            12,
                                                        height: 35,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        360)),
                                                        child: Center(
                                                          child: Text(
                                                            'Failed',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
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
                                              left: _sliderPosition6,
                                              child: InkWell(
                                                onTap: () {
                                                  _animateButton6(2);
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    color: Constants
                                                        .ctaColorLight, // Color of the slider
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: grid_index_6 == 0
                                                      ? Center(
                                                          child: Text(
                                                            'Lodging',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                      : grid_index_6 == 1
                                                          ? Center(
                                                              child: Text(
                                                                'Processing',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )
                                                          : Center(
                                                              child: Text(
                                                                'Failed',
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
                                  if (target_index == 1)
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
                                                        _animateButton5(0);
                                                      },
                                                      child: Container(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                3) -
                                                            12,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        360)),
                                                        height: 35,
                                                        child: Center(
                                                          child: Text(
                                                            'In Progress',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        _animateButton5(1);
                                                      },
                                                      child: Container(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                3) -
                                                            12,
                                                        height: 35,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        360)),
                                                        child: Center(
                                                          child: Text(
                                                            'Paid',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
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
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                3) -
                                                            12,
                                                        height: 35,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        360)),
                                                        child: Center(
                                                          child: Text(
                                                            "Decl. & Rep'd",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
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
                                              left: _sliderPosition5,
                                              child: InkWell(
                                                onTap: () {
                                                  _animateButton5(2);
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    color: Constants
                                                        .ctaColorLight, // Color of the slider
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: grid_index == 0
                                                      ? Center(
                                                          child: Text(
                                                            'In Progress',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                      : grid_index == 1
                                                          ? Center(
                                                              child: Text(
                                                                'Paid',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )
                                                          : Center(
                                                              child: Text(
                                                                "Decl. & Rep'd",
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

                                  if (target_index == 0 && grid_index_6 == 0)
                                    Container(
                                      child:
                                          ((_selectedButton == 1 &&
                                                      Constants
                                                          .claims_droupedChartData1
                                                          .isEmpty) ||
                                                  (_selectedButton == 2 &&
                                                      Constants
                                                          .claims_droupedChartData2
                                                          .isEmpty) ||
                                                  (_selectedButton == 3 &&
                                                      days_difference <= 31 &&
                                                      Constants
                                                          .claims_droupedChartData3
                                                          .isEmpty) ||
                                                  (_selectedButton == 3 &&
                                                      days_difference > 31 &&
                                                      Constants
                                                          .claims_droupedChartData4
                                                          .isEmpty))
                                              ? Container(height: 12)
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12,
                                                          top: 8.0,
                                                          right: 12,
                                                          bottom: 8),
                                                  child: Card(
                                                    elevation: 6,
                                                    surfaceTintColor:
                                                        Colors.white,
                                                    color: Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16)),
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      padding: EdgeInsets.only(
                                                          top: 0, bottom: 0),
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemCount: _selectedButton ==
                                                              1
                                                          ? Constants
                                                              .claims_droupedChartData1
                                                              .length
                                                          : _selectedButton == 2
                                                              ? Constants
                                                                  .claims_droupedChartData2
                                                                  .length
                                                              : _selectedButton ==
                                                                          3 &&
                                                                      days_difference <=
                                                                          31
                                                                  ? Constants
                                                                      .claims_droupedChartData3
                                                                      .length
                                                                  : Constants
                                                                      .claims_droupedChartData4
                                                                      .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        ClaimStageCategory
                                                            category =
                                                            ClaimStageCategory(
                                                                name: '',
                                                                items: []);
                                                        if (_selectedButton == 1 &&
                                                            Constants
                                                                    .claims_droupedChartData1
                                                                    .length >
                                                                0) {
                                                          category = Constants
                                                                  .claims_droupedChartData1[
                                                              index];
                                                          print(
                                                              "yuuyyu1 ${category.name}");
                                                        } else if (_selectedButton ==
                                                                2 &&
                                                            Constants
                                                                    .claims_droupedChartData2
                                                                    .length >
                                                                0) {
                                                          category = Constants
                                                                  .claims_droupedChartData2[
                                                              index];
                                                          // print("yuuyyu2 ${category}");
                                                        } else if (_selectedButton ==
                                                                3 &&
                                                            days_difference <=
                                                                31 &&
                                                            Constants
                                                                    .claims_droupedChartData3
                                                                    .length >
                                                                0) {
                                                          category = Constants
                                                                  .claims_droupedChartData3[
                                                              index];
                                                          //  print("yuuyyu ${category}");
                                                        } else if (_selectedButton ==
                                                                3 &&
                                                            days_difference >
                                                                31 &&
                                                            Constants
                                                                    .claims_droupedChartData4
                                                                    .length >
                                                                0) {
                                                          category = Constants
                                                                  .claims_droupedChartData4[
                                                              index];
                                                          //  print("yuuyyu ${category}");
                                                        } else {
                                                          /* category = Constants
                                                        .claims_droupedChartData4[
                                                    index];*/
                                                          // print("yuuyyu4 ${category}");
                                                        }

                                                        final totalCategoryCount =
                                                            category
                                                                .getTotalCount();
                                                        if (category.name ==
                                                            "Lodging") {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 0.0,
                                                                    left: 0,
                                                                    right: 0,
                                                                    bottom: 4),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              17),
                                                                  border: Border(
                                                                      top: BorderSide
                                                                          .none)),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16.5),
                                                                child:
                                                                    ListTileTheme(
                                                                  dense: true,
                                                                  minVerticalPadding:
                                                                      0,
                                                                  child:
                                                                      ExpansionTile(
                                                                    childrenPadding:
                                                                        EdgeInsets.only(
                                                                            top:
                                                                                0,
                                                                            bottom:
                                                                                0),
                                                                    tilePadding: EdgeInsets.only(
                                                                        top: 0,
                                                                        bottom:
                                                                            0,
                                                                        left: 8,
                                                                        right:
                                                                            8),
                                                                    initiallyExpanded:
                                                                        true,
                                                                    backgroundColor: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.35),
                                                                    collapsedBackgroundColor: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.35),
                                                                    trailing:
                                                                        Container(
                                                                      width: 80,
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          Container(
                                                                            height:
                                                                                16,
                                                                            child:
                                                                                LinearProgressIndicator(
                                                                              value: 1,
                                                                              backgroundColor: Colors.grey.withOpacity(0.3),
                                                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            height:
                                                                                16,
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Spacer(),
                                                                                Text(
                                                                                  formatLargeNumber3(totalCategoryCount.toString()),
                                                                                  style: TextStyle(fontSize: 11, color: Colors.white),
                                                                                ),
                                                                                Spacer(),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    collapsedShape:
                                                                        RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(16)),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(16)),
                                                                    title: Text(
                                                                      category
                                                                          .name
                                                                          .replaceAll(
                                                                              "Dependant",
                                                                              "Insured"),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                    children: category
                                                                        .items
                                                                        .map(
                                                                            (item) {
                                                                      double
                                                                          percentage =
                                                                          0;
                                                                      if (totalCategoryCount >
                                                                          0) {
                                                                        item.count /
                                                                            totalCategoryCount;
                                                                      }
                                                                      return Container(
                                                                        color: Colors
                                                                            .white,
                                                                        child:
                                                                            ListTile(
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                                          dense:
                                                                              true,
                                                                          visualDensity: VisualDensity(
                                                                              horizontal: 0,
                                                                              vertical: -4),
                                                                          minLeadingWidth:
                                                                              0,
                                                                          horizontalTitleGap:
                                                                              0,
                                                                          contentPadding: EdgeInsets.only(
                                                                              left: 8,
                                                                              right: 8),
                                                                          minVerticalPadding:
                                                                              0,
                                                                          selectedColor:
                                                                              Colors.white,
                                                                          selectedTileColor:
                                                                              Colors.white,
                                                                          tileColor:
                                                                              Colors.white,
                                                                          splashColor:
                                                                              Colors.white,
                                                                          title:
                                                                              Text(
                                                                            item.title,
                                                                            style:
                                                                                TextStyle(fontSize: 14),
                                                                          ),
                                                                          trailing:
                                                                              SizedBox(
                                                                            width:
                                                                                80,
                                                                            height:
                                                                                16,
                                                                            child:
                                                                                Stack(
                                                                              children: [
                                                                                Container(
                                                                                  height: 16,
                                                                                  child: LinearProgressIndicator(
                                                                                    value: percentage,
                                                                                    backgroundColor: Colors.grey.withOpacity(0.3),
                                                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  height: 16,
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Spacer(),
                                                                                      Text(
                                                                                        formatLargeNumber3(item.count.toString()),
                                                                                        style: TextStyle(fontSize: 11, color: percentage < 0.50 ? Colors.black : Colors.white),
                                                                                      ),
                                                                                      Spacer(),
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        } else
                                                          return Container();
                                                      },
                                                    ),
                                                  ),
                                                ),
                                    ),
                                  if (target_index == 0 && grid_index_6 == 1)
                                    Container(
                                      child:
                                          ((_selectedButton == 1 &&
                                                      Constants
                                                          .claims_droupedChartData1
                                                          .isEmpty) ||
                                                  (_selectedButton == 2 &&
                                                      Constants
                                                          .claims_droupedChartData2
                                                          .isEmpty) ||
                                                  (_selectedButton == 3 &&
                                                      days_difference <= 31 &&
                                                      Constants
                                                          .claims_droupedChartData3
                                                          .isEmpty) ||
                                                  (_selectedButton == 3 &&
                                                      days_difference > 31 &&
                                                      Constants
                                                          .claims_droupedChartData4
                                                          .isEmpty))
                                              ? Container(height: 12)
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12,
                                                          top: 8.0,
                                                          right: 12,
                                                          bottom: 0),
                                                  child: Card(
                                                    elevation: 6,
                                                    surfaceTintColor:
                                                        Colors.white,
                                                    color: Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16)),
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      padding: EdgeInsets.only(
                                                          top: 0, bottom: 0),
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemCount: _selectedButton ==
                                                              1
                                                          ? Constants
                                                              .claims_droupedChartData1
                                                              .length
                                                          : _selectedButton == 2
                                                              ? Constants
                                                                  .claims_droupedChartData2
                                                                  .length
                                                              : _selectedButton ==
                                                                          3 &&
                                                                      days_difference <=
                                                                          31
                                                                  ? Constants
                                                                      .claims_droupedChartData3
                                                                      .length
                                                                  : Constants
                                                                      .claims_droupedChartData4
                                                                      .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        ClaimStageCategory
                                                            category =
                                                            ClaimStageCategory(
                                                                name: '',
                                                                items: []);
                                                        if (_selectedButton == 1 &&
                                                            Constants
                                                                    .claims_droupedChartData1
                                                                    .length >
                                                                0) {
                                                          category = Constants
                                                                  .claims_droupedChartData1[
                                                              index];
                                                          print(
                                                              "yuuyyu1 ${category.name}");
                                                        } else if (_selectedButton ==
                                                                2 &&
                                                            Constants
                                                                    .claims_droupedChartData2
                                                                    .length >
                                                                0) {
                                                          category = Constants
                                                                  .claims_droupedChartData2[
                                                              index];
                                                          // print("yuuyyu2 ${category}");
                                                        } else if (_selectedButton ==
                                                                3 &&
                                                            days_difference <=
                                                                31 &&
                                                            Constants
                                                                    .claims_droupedChartData3
                                                                    .length >
                                                                0) {
                                                          category = Constants
                                                                  .claims_droupedChartData3[
                                                              index];
                                                          //  print("yuuyyu ${category}");
                                                        } else if (_selectedButton ==
                                                                3 &&
                                                            days_difference >
                                                                31 &&
                                                            Constants
                                                                    .claims_droupedChartData4
                                                                    .length >
                                                                0) {
                                                          category = Constants
                                                                  .claims_droupedChartData4[
                                                              index];
                                                          //  print("yuuyyu ${category}");
                                                        } else {
                                                          /*category = Constants
                                                        .claims_droupedChartData4[
                                                    index];*/
                                                          // print("yuuyyu4 ${category}");
                                                        }

                                                        final totalCategoryCount =
                                                            category
                                                                .getTotalCount();
                                                        if (category.name ==
                                                            "Processing") {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 0.0,
                                                                    left: 0,
                                                                    right: 0,
                                                                    bottom: 4),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              17),
                                                                  border: Border(
                                                                      top: BorderSide
                                                                          .none)),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16.5),
                                                                child:
                                                                    ListTileTheme(
                                                                  dense: true,
                                                                  minVerticalPadding:
                                                                      0,
                                                                  child:
                                                                      ExpansionTile(
                                                                    childrenPadding:
                                                                        EdgeInsets.only(
                                                                            top:
                                                                                0,
                                                                            bottom:
                                                                                0),
                                                                    tilePadding: EdgeInsets.only(
                                                                        top: 0,
                                                                        bottom:
                                                                            0,
                                                                        left: 8,
                                                                        right:
                                                                            8),
                                                                    initiallyExpanded:
                                                                        true,
                                                                    backgroundColor: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.35),
                                                                    collapsedBackgroundColor: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.35),
                                                                    trailing:
                                                                        Container(
                                                                      width: 80,
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          Container(
                                                                            height:
                                                                                16,
                                                                            child:
                                                                                LinearProgressIndicator(
                                                                              value: 1,
                                                                              backgroundColor: Colors.grey.withOpacity(0.3),
                                                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            height:
                                                                                16,
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Spacer(),
                                                                                Text(
                                                                                  formatLargeNumber3(totalCategoryCount.toString()),
                                                                                  style: TextStyle(fontSize: 11, color: Colors.white),
                                                                                ),
                                                                                Spacer(),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    collapsedShape:
                                                                        RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(13)),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(13)),
                                                                    title: Text(
                                                                      category
                                                                          .name
                                                                          .replaceAll(
                                                                              "Self",
                                                                              "Principal Member"),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                    children: category
                                                                        .items
                                                                        .map(
                                                                            (item) {
                                                                      double
                                                                          percentage =
                                                                          0;
                                                                      if (totalCategoryCount >
                                                                          0) {
                                                                        item.count /
                                                                            totalCategoryCount;
                                                                      }
                                                                      return Container(
                                                                        color: Colors
                                                                            .white,
                                                                        child:
                                                                            ListTile(
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                                          dense:
                                                                              true,
                                                                          visualDensity: VisualDensity(
                                                                              horizontal: 0,
                                                                              vertical: -4),
                                                                          minLeadingWidth:
                                                                              0,
                                                                          horizontalTitleGap:
                                                                              0,
                                                                          contentPadding: EdgeInsets.only(
                                                                              left: 8,
                                                                              right: 8),
                                                                          minVerticalPadding:
                                                                              0,
                                                                          selectedColor:
                                                                              Colors.white,
                                                                          selectedTileColor:
                                                                              Colors.white,
                                                                          tileColor:
                                                                              Colors.white,
                                                                          splashColor:
                                                                              Colors.white,
                                                                          title:
                                                                              Text(
                                                                            item.title.replaceAll("Processing", "Processing In Progress").replaceAll("Failed Processing In Progress",
                                                                                "Failed Processing"),
                                                                            style:
                                                                                TextStyle(fontSize: 14),
                                                                          ),
                                                                          trailing:
                                                                              SizedBox(
                                                                            width:
                                                                                80,
                                                                            height:
                                                                                16,
                                                                            child:
                                                                                Stack(
                                                                              children: [
                                                                                Container(
                                                                                  height: 16,
                                                                                  child: LinearProgressIndicator(
                                                                                    value: percentage,
                                                                                    backgroundColor: Colors.grey.withOpacity(0.3),
                                                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  height: 16,
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Spacer(),
                                                                                      Text(
                                                                                        formatLargeNumber3(item.count.toString()),
                                                                                        style: TextStyle(fontSize: 11, color: percentage < 0.50 ? Colors.black : Colors.white),
                                                                                      ),
                                                                                      Spacer(),
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        } else {
                                                          return Container();
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                    ),
                                  if (target_index == 0 && grid_index_6 == 2)
                                    Container(
                                      child:
                                          ((_selectedButton == 1 &&
                                                      Constants
                                                          .claims_droupedChartData1
                                                          .isEmpty) ||
                                                  (_selectedButton == 2 &&
                                                      Constants
                                                          .claims_droupedChartData2
                                                          .isEmpty) ||
                                                  (_selectedButton == 3 &&
                                                      days_difference <= 31 &&
                                                      Constants
                                                          .claims_droupedChartData3
                                                          .isEmpty) ||
                                                  (_selectedButton == 3 &&
                                                      days_difference > 31 &&
                                                      Constants
                                                          .claims_droupedChartData4
                                                          .isEmpty))
                                              ? Container(height: 12)
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12,
                                                          top: 8.0,
                                                          right: 12),
                                                  child: Card(
                                                    elevation: 6,
                                                    surfaceTintColor:
                                                        Colors.white,
                                                    color: Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16)),
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      padding: EdgeInsets.only(
                                                          top: 0, bottom: 0),
                                                      key: UniqueKey(),
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemCount: _selectedButton ==
                                                              1
                                                          ? Constants
                                                              .claims_droupedChartData1
                                                              .length
                                                          : _selectedButton == 2
                                                              ? Constants
                                                                  .claims_droupedChartData2
                                                                  .length
                                                              : _selectedButton ==
                                                                          3 &&
                                                                      days_difference <=
                                                                          31
                                                                  ? Constants
                                                                      .claims_droupedChartData3
                                                                      .length
                                                                  : Constants
                                                                      .claims_droupedChartData4
                                                                      .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        ClaimStageCategory
                                                            category =
                                                            ClaimStageCategory(
                                                                name: '',
                                                                items: []);
                                                        if (_selectedButton ==
                                                            1) {
                                                          print(
                                                              "yuuyyu1 ${category.name}");
                                                          category = Constants
                                                                  .claims_droupedChartData1[
                                                              index];
                                                        } else if (_selectedButton ==
                                                            2) {
                                                          category = Constants
                                                                  .claims_droupedChartData2[
                                                              index];
                                                          // print("yuuyyu2 ${category}");
                                                        } else if (_selectedButton ==
                                                                3 &&
                                                            days_difference <=
                                                                31) {
                                                          category = Constants
                                                                  .claims_droupedChartData3[
                                                              index];
                                                          //  print("yuuyyu ${category}");
                                                        } else {
                                                          category = Constants
                                                                  .claims_droupedChartData4[
                                                              index];
                                                          // print("yuuyyu4 ${category}");
                                                        }

                                                        final totalCategoryCount =
                                                            category
                                                                .getTotalCount();
                                                        if (category.name ==
                                                            "Closed") {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 0.0,
                                                                    left: 0,
                                                                    right: 0,
                                                                    bottom: 4),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              17),
                                                                  border: Border(
                                                                      top: BorderSide
                                                                          .none)),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16.5),
                                                                child:
                                                                    ListTileTheme(
                                                                  dense: true,
                                                                  minVerticalPadding:
                                                                      0,
                                                                  child:
                                                                      ExpansionTile(
                                                                    childrenPadding:
                                                                        EdgeInsets.only(
                                                                            top:
                                                                                0,
                                                                            bottom:
                                                                                0),
                                                                    tilePadding: EdgeInsets.only(
                                                                        top: 0,
                                                                        bottom:
                                                                            0,
                                                                        left: 8,
                                                                        right:
                                                                            8),
                                                                    initiallyExpanded:
                                                                        true,
                                                                    backgroundColor: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.35),
                                                                    collapsedBackgroundColor: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.35),
                                                                    trailing:
                                                                        Container(
                                                                      width: 80,
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          Container(
                                                                            height:
                                                                                16,
                                                                            child:
                                                                                LinearProgressIndicator(
                                                                              value: 1,
                                                                              backgroundColor: Colors.grey.withOpacity(0.3),
                                                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            height:
                                                                                16,
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Spacer(),
                                                                                Text(
                                                                                  formatLargeNumber3(totalCategoryCount.toString()),
                                                                                  style: TextStyle(fontSize: 11, color: Colors.white),
                                                                                ),
                                                                                Spacer(),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    collapsedShape:
                                                                        RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(13)),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(13)),
                                                                    title: Text(
                                                                      category
                                                                          .name,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                    children: category
                                                                        .items
                                                                        .map(
                                                                            (item) {
                                                                      double
                                                                          percentage =
                                                                          0;
                                                                      if (totalCategoryCount >
                                                                          0) {
                                                                        item.count /
                                                                            totalCategoryCount;
                                                                      }
                                                                      return Container(
                                                                        color: Colors
                                                                            .white,
                                                                        child:
                                                                            ListTile(
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                                          dense:
                                                                              true,
                                                                          visualDensity: VisualDensity(
                                                                              horizontal: 0,
                                                                              vertical: -4),
                                                                          minLeadingWidth:
                                                                              0,
                                                                          horizontalTitleGap:
                                                                              0,
                                                                          contentPadding: EdgeInsets.only(
                                                                              left: 8,
                                                                              right: 8),
                                                                          minVerticalPadding:
                                                                              0,
                                                                          selectedColor:
                                                                              Colors.white,
                                                                          selectedTileColor:
                                                                              Colors.white,
                                                                          tileColor:
                                                                              Colors.white,
                                                                          splashColor:
                                                                              Colors.white,
                                                                          title:
                                                                              Text(
                                                                            item.title.replaceAll("Failed_synopsis", "Failed Synopsis").replaceAll("Deceased Collection",
                                                                                "Deceased Collected (Cash Service)"),
                                                                            style:
                                                                                TextStyle(fontSize: 14),
                                                                          ),
                                                                          trailing:
                                                                              SizedBox(
                                                                            width:
                                                                                80,
                                                                            height:
                                                                                16,
                                                                            child:
                                                                                Stack(
                                                                              children: [
                                                                                Container(
                                                                                  height: 16,
                                                                                  child: LinearProgressIndicator(
                                                                                    value: percentage,
                                                                                    backgroundColor: Colors.grey.withOpacity(0.3),
                                                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  height: 16,
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Spacer(),
                                                                                      Text(
                                                                                        formatLargeNumber3(item.count.toString()),
                                                                                        style: TextStyle(fontSize: 11, color: percentage < 0.50 ? Colors.black : Colors.white),
                                                                                      ),
                                                                                      Spacer(),
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        } else
                                                          return Container();
                                                      },
                                                    ),
                                                  ),
                                                ),
                                    ),

                                  if (target_index == 0 && grid_index_6 == 0)
                                    Padding(
                                      key: UniqueKey(),
                                      padding: const EdgeInsets.only(
                                          left: 16, top: 0.0, right: 16),
                                      child: CustomCard3(
                                        surfaceTintColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        color: Colors.white,
                                        elevation: 6,
                                        boderRadius: 20,
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: isLoadingClaimsData == true
                                              ? Container(
                                                  height: 200,
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
                                                )
                                              : (((_selectedButton == 1 &&
                                                          (Constants.claims_section_list1a[
                                                                  "claims_sum_by_category"] ==
                                                              null)) ||
                                                      (_selectedButton == 2 &&
                                                          (Constants.claims_section_list2a[
                                                                  "claims_sum_by_category"] ==
                                                              null)) ||
                                                      (_selectedButton == 3 &&
                                                          days_difference <=
                                                              31 &&
                                                          (Constants.claims_section_list3a[
                                                                  "claims_sum_by_category"] ==
                                                              null)) ||
                                                      (_selectedButton == 3 &&
                                                          days_difference >
                                                              31 &&
                                                          (Constants.claims_section_list3a[
                                                                  "claims_sum_by_category"] ==
                                                              null)))
                                                  ? Container(
                                                      height: 200,
                                                      child: Center(
                                                        child: Text(
                                                          "No data available for the selected range",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ))
                                                  : Column(
                                                      children: [
                                                        Container(
                                                          height: 36,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 8.0,
                                                                    right: 8),
                                                            child: Row(
                                                              children: [
                                                                Spacer(),
                                                                Text(
                                                                  "LODGING",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                SizedBox(
                                                                    width: 10),
                                                                Container(
                                                                  width: 140,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.35),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            4.0,
                                                                        bottom:
                                                                            4,
                                                                        right:
                                                                            12),
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Text(
                                                                        "R " +
                                                                            formatLargeNumber(
                                                                              _getLodgingAmount().toStringAsFixed(2),
                                                                            ),
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                        textAlign:
                                                                            TextAlign.right,
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
                                                              const EdgeInsets
                                                                  .all(0.0),
                                                          child: Container(
                                                            child:
                                                                ClaimsGridView(
                                                              category:
                                                                  "Lodging",
                                                              selectedButton:
                                                                  _selectedButton,
                                                              daysDifference:
                                                                  days_difference,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                        ),
                                      ),
                                    ),

                                  if (target_index == 0 && grid_index_6 == 1)
                                    Padding(
                                      key: UniqueKey(),
                                      padding: const EdgeInsets.only(
                                          left: 16, top: 8.0, right: 16),
                                      child: CustomCard3(
                                        boderRadius: 20,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        surfaceTintColor: Colors.white,
                                        color: Colors.white,
                                        elevation: 6,
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: isLoadingClaimsData == true
                                              ? Container(
                                                  height: 200,
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
                                                )
                                              : (_selectedButton == 1 &&
                                                          (Constants.claims_section_list1a[
                                                                  "claims_sum_by_category"] ==
                                                              null)) ||
                                                      (_selectedButton == 2 &&
                                                          (Constants.claims_section_list2a[
                                                                  "claims_sum_by_category"] ==
                                                              null)) ||
                                                      (_selectedButton == 3 &&
                                                          days_difference <=
                                                              31 &&
                                                          (Constants.claims_section_list3a[
                                                                  "claims_sum_by_category"] ==
                                                              null)) ||
                                                      (_selectedButton == 3 &&
                                                          days_difference >
                                                              31 &&
                                                          (Constants.claims_section_list3a[
                                                                  "claims_sum_by_category"] ==
                                                              null))
                                                  ? Container(
                                                      height: 200,
                                                      child: Center(
                                                        child: Text(
                                                          "No data available for the selected range",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ))
                                                  : Column(
                                                      children: [
                                                        Container(
                                                          height: 36,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 8.0,
                                                                    right: 8),
                                                            child: Row(
                                                              children: [
                                                                Spacer(),
                                                                Text(
                                                                  "PROCESSING ",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Container(
                                                                    width: 140,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(
                                                                                0.35),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                8)),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              4.0,
                                                                          bottom:
                                                                              4,
                                                                          right:
                                                                              12),
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Text(
                                                                          "R " +
                                                                              formatLargeNumber(_getProcessingAmount("Processing").toStringAsFixed(2)),
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                        ),
                                                                      ),
                                                                    ))
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0.0),
                                                          child: Container(
                                                            child:
                                                                ClaimsGridView(
                                                              category:
                                                                  "Processing",
                                                              selectedButton:
                                                                  _selectedButton,
                                                              daysDifference:
                                                                  days_difference,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                        ),
                                      ),
                                    ),
                                  if (target_index == 0 && grid_index_6 == 2)
                                    Padding(
                                      key: UniqueKey(),
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16, top: 8),
                                      child: CustomCard3(
                                        surfaceTintColor: Colors.white,
                                        color: Colors.white,
                                        elevation: 6,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        boderRadius: 20,
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: isLoadingClaimsData == true
                                              ? Container(
                                                  height: 200,
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
                                                )
                                              : (_selectedButton == 1 &&
                                                          (Constants.claims_section_list1a[
                                                                  "claims_sum_by_category"] ==
                                                              null)) ||
                                                      (_selectedButton == 2 &&
                                                          (Constants.claims_section_list2a[
                                                                  "claims_sum_by_category"] ==
                                                              null)) ||
                                                      (_selectedButton == 3 &&
                                                          days_difference <=
                                                              31 &&
                                                          (Constants.claims_section_list3a[
                                                                  "claims_sum_by_category"] ==
                                                              null)) ||
                                                      (_selectedButton == 3 &&
                                                          days_difference >
                                                              31 &&
                                                          (Constants.claims_section_list3a[
                                                                  "claims_sum_by_category"] ==
                                                              null))
                                                  ? Container(
                                                      height: 200,
                                                      child: Center(
                                                        child: Text(
                                                          "No data available for the selected range",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ))
                                                  : Column(
                                                      children: [
                                                        Container(
                                                          height: 36,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 8.0,
                                                                    right: 8),
                                                            child: Row(
                                                              children: [
                                                                Spacer(),
                                                                Text(
                                                                  "CLOSED",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Container(
                                                                    width: 140,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(
                                                                                0.35),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                8)),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              4.0,
                                                                          bottom:
                                                                              4,
                                                                          right:
                                                                              12),
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Text(
                                                                          "R " +
                                                                              formatLargeNumber(_getProcessingAmount("Closed").toStringAsFixed(2)),
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                        ),
                                                                      ),
                                                                    ))
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0.0),
                                                          child: Container(
                                                            child:
                                                                ClaimsGridView(
                                                              category:
                                                                  "Closed",
                                                              selectedButton:
                                                                  _selectedButton,
                                                              daysDifference:
                                                                  days_difference,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                        ),
                                      ),
                                    ),

                                  if (target_index == 1 && grid_index == 0)
                                    Padding(
                                      key: UniqueKey(),
                                      padding: const EdgeInsets.only(
                                          left: 16, top: 12.0, right: 16),
                                      child: CustomCard(
                                        surfaceTintColor: Colors.white,
                                        color: Colors.white,
                                        elevation: 6,
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: isLoadingClaimsData == true
                                              ? Container(
                                                  height: 200,
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
                                                )
                                              : (_selectedButton == 1 &&
                                                          (Constants.claims_section_list1a[
                                                                  "claims_sum_by_category"] ==
                                                              null)) ||
                                                      (_selectedButton == 2 &&
                                                          (Constants.claims_section_list2a[
                                                                  "claims_sum_by_category"] ==
                                                              null)) ||
                                                      (_selectedButton == 3 &&
                                                          days_difference <=
                                                              31 &&
                                                          (Constants.claims_section_list3a[
                                                                  "claims_sum_by_category"] ==
                                                              null)) ||
                                                      (_selectedButton == 3 &&
                                                          days_difference >
                                                              31 &&
                                                          (Constants.claims_section_list3a[
                                                                  "claims_sum_by_category"] ==
                                                              null))
                                                  ? Container(
                                                      height: 200,
                                                      child: Center(
                                                        child: Text(
                                                          "No data available for the selected range",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ))
                                                  : Column(
                                                      children: [
                                                        Container(
                                                          height: 36,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 8.0,
                                                                    right: 8),
                                                            child: Row(
                                                              children: [
                                                                Spacer(),
                                                                Text(
                                                                  "IN PROGRESS ",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Container(
                                                                    width: 140,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(
                                                                                0.35),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                8)),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              4.0,
                                                                          bottom:
                                                                              4,
                                                                          right:
                                                                              12),
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Text(
                                                                          "R " +
                                                                              formatLargeNumber(_getProcessingAmount("In Progress").toStringAsFixed(2)),
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                        ),
                                                                      ),
                                                                    ))
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0.0),
                                                          child: Container(
                                                            child:
                                                                ClaimsGridView(
                                                              category:
                                                                  "In Progress",
                                                              selectedButton:
                                                                  _selectedButton,
                                                              daysDifference:
                                                                  days_difference,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                        ),
                                      ),
                                    ),

                                  if (target_index == 1 && grid_index == 1)
                                    Padding(
                                      key: UniqueKey(),
                                      padding: const EdgeInsets.only(
                                          left: 16, top: 12.0, right: 16),
                                      child: CustomCard(
                                        surfaceTintColor: Colors.white,
                                        color: Colors.white,
                                        elevation: 6,
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: isLoadingClaimsData == true
                                              ? Container(
                                                  height: 200,
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
                                                )
                                              : (_selectedButton == 1 &&
                                                          (Constants.claims_section_list1a[
                                                                  "claims_sum_by_category"] ==
                                                              null)) ||
                                                      (_selectedButton == 2 &&
                                                          (Constants.claims_section_list2a[
                                                                  "claims_sum_by_category"] ==
                                                              null)) ||
                                                      (_selectedButton == 3 &&
                                                          days_difference <=
                                                              31 &&
                                                          (Constants.claims_section_list3a[
                                                                  "claims_sum_by_category"] ==
                                                              null)) ||
                                                      (_selectedButton == 3 &&
                                                          days_difference >
                                                              31 &&
                                                          (Constants.claims_section_list3a[
                                                                  "claims_sum_by_category"] ==
                                                              null))
                                                  ? Container(
                                                      height: 200,
                                                      child: Center(
                                                        child: Text(
                                                          "No data available for the selected range",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ))
                                                  : Column(
                                                      children: [
                                                        Container(
                                                          height: 36,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 8.0,
                                                                    right: 8),
                                                            child: Row(
                                                              children: [
                                                                Spacer(),
                                                                Text(
                                                                  "PAID ",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Container(
                                                                    width: 140,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(
                                                                                0.35),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                8)),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              4.0,
                                                                          bottom:
                                                                              4,
                                                                          right:
                                                                              12),
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Text(
                                                                          "R " +
                                                                              formatLargeNumber(_selectedButton == 1
                                                                                  ? (Constants.claims_section_list1a["claims_sum_by_category"]["Paid"] ?? 0).toStringAsFixed(2)
                                                                                  : _selectedButton == 2
                                                                                      ? (Constants.claims_section_list2a["claims_sum_by_category"]["Paid"] ?? 0).toStringAsFixed(2)
                                                                                      : (_selectedButton == 3 && days_difference <= 31)
                                                                                          ? (Constants.claims_section_list3a["claims_sum_by_category"]["Paid"] ?? 0).toStringAsFixed(2)
                                                                                          : (Constants.claims_section_list3a["claims_sum_by_category"]["Paid"] ?? 0).toStringAsFixed(2)),
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                        ),
                                                                      ),
                                                                    ))
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0.0),
                                                          child: Container(
                                                            child:
                                                                ClaimsGridView(
                                                              category: "Paid",
                                                              selectedButton:
                                                                  _selectedButton,
                                                              daysDifference:
                                                                  days_difference,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                        ),
                                      ),
                                    ),
                                  if (target_index == 1 && grid_index == 2)
                                    Padding(
                                      key: UniqueKey(),
                                      padding: const EdgeInsets.only(
                                          left: 16, top: 12.0, right: 16),
                                      child: CustomCard(
                                        surfaceTintColor: Colors.white,
                                        color: Colors.white,
                                        elevation: 6,
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: isLoadingClaimsData == true
                                              ? Container(
                                                  height: 200,
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
                                                )
                                              : (_selectedButton == 1 &&
                                                          (Constants.claims_section_list1a[
                                                                  "claims_sum_by_category"] ==
                                                              null)) ||
                                                      (_selectedButton == 2 &&
                                                          (Constants.claims_section_list2a[
                                                                  "claims_sum_by_category"] ==
                                                              null)) ||
                                                      (_selectedButton == 3 &&
                                                          days_difference <=
                                                              31 &&
                                                          (Constants.claims_section_list3a[
                                                                  "claims_sum_by_category"] ==
                                                              null)) ||
                                                      (_selectedButton == 3 &&
                                                          days_difference >
                                                              31 &&
                                                          (Constants.claims_section_list3a[
                                                                  "claims_sum_by_category"] ==
                                                              null))
                                                  ? Container(
                                                      height: 200,
                                                      child: Center(
                                                        child: Text(
                                                          "No data available for the selected range",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ))
                                                  : Column(
                                                      children: [
                                                        Container(
                                                          height: 36,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 8.0,
                                                                    right: 8),
                                                            child: Row(
                                                              children: [
                                                                Spacer(),
                                                                Text(
                                                                  "DECL. & REPUDIATED ",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Container(
                                                                    width: 140,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(
                                                                                0.35),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                8)),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              4.0,
                                                                          bottom:
                                                                              4,
                                                                          right:
                                                                              12),
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Text(
                                                                          "R " +
                                                                              formatLargeNumber(_selectedButton == 1
                                                                                  ? (Constants.claims_section_list1a["claims_sum_by_category"]["Declined And Repudiated"] ?? 0).toStringAsFixed(2)
                                                                                  : _selectedButton == 2
                                                                                      ? (Constants.claims_section_list2a["claims_sum_by_category"]["Declined And Repudiated"] ?? 0).toStringAsFixed(2)
                                                                                      : (_selectedButton == 3 && days_difference <= 31)
                                                                                          ? (Constants.claims_section_list3a["claims_sum_by_category"]["Declined And Repudiated"] ?? 0).toStringAsFixed(2)
                                                                                          : (Constants.claims_section_list3a["claims_sum_by_category"]["Declined And Repudiated"] ?? 0).toStringAsFixed(2)),
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                        ),
                                                                      ),
                                                                    ))
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0.0),
                                                          child: Container(
                                                            child:
                                                                ClaimsGridView(
                                                              category:
                                                                  "Declined And Repudiated",
                                                              selectedButton:
                                                                  _selectedButton,
                                                              daysDifference:
                                                                  days_difference,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                        ),
                                      ),
                                    ),

                                  SizedBox(
                                    height: 16,
                                  ),
                                  _selectedButton == 1
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0, top: 12),
                                          child: Text(
                                              "Most Recent Claims (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                        )
                                      : _selectedButton == 2
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0, top: 12),
                                              child: Text(
                                                  "Most Recent Claims (12 Months View)"),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0, top: 12),
                                              child: Text(
                                                  "Most Recent Claims (${Constants.claims_formattedStartDate} to ${Constants.claims_formattedEndDate})"),
                                            ),
                                  Padding(
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
                                              BorderRadius.circular(20)),
                                      child: Container(
                                          child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.35),
                                                borderRadius:
                                                    BorderRadius.circular(24)),
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
                                                                .circular(360)),
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
                                                      flex: 4,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 0.0),
                                                        child: Text(
                                                            "Policy Number"),
                                                      )),
                                                  Container(
                                                    width: 70,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 12.0),
                                                      child: Text(
                                                        "Amount",
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 28),
                                                ],
                                              ),
                                            ),
                                          ),
                                          /*     Text(Constants
                                              .claims_details3a[0].policy_number
                                              .toString()),*/
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0, right: 12, top: 12),
                                            child: isLoadingClaimsData
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
                                                            strokeWidth: 1.8,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : (_selectedButton == 1 &&
                                                            Constants.claims_details1a.length ==
                                                                0 ||
                                                        _selectedButton == 2 &&
                                                            Constants
                                                                    .claims_details2a
                                                                    .length ==
                                                                0 ||
                                                        _selectedButton == 3 &&
                                                            Constants
                                                                    .claims_details3a
                                                                    .length ==
                                                                0)
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 24.0),
                                                        child: Center(
                                                          child: Text(
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
                                                        ),
                                                      )
                                                    : ListView.builder(
                                                        padding: EdgeInsets.only(
                                                            top: 0, bottom: 16),
                                                        itemCount: (_selectedButton ==
                                                                1)
                                                            ? min(
                                                                Constants
                                                                    .claims_details1a
                                                                    .length,
                                                                10)
                                                            : (_selectedButton ==
                                                                    2)
                                                                ? min(
                                                                    Constants
                                                                        .claims_details2a
                                                                        .length,
                                                                    10)
                                                                : (_selectedButton == 3 && days_difference <= 31)
                                                                    ? min(Constants.claims_details3a.length, 10)
                                                                    : min(Constants.claims_details3a.length, 10),
                                                        shrinkWrap: true,
                                                        physics: NeverScrollableScrollPhysics(),
                                                        itemBuilder: (BuildContext context, int index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 8.0),
                                                            child: InkWell(
                                                              onTap: () {},
                                                              child: Container(
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(
                                                                        height:
                                                                            2),
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              35,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 4.0),
                                                                            child:
                                                                                Text("${index + 1} "),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                            flex:
                                                                                4,
                                                                            child:
                                                                                Text("${extractFirstAndLastName(_selectedButton == 1 ? Constants.claims_details1a[index].policy_number : _selectedButton == 2 ? Constants.claims_details2a[index].policy_number.trimLeft() : Constants.claims_details3a[index].policy_number.trimLeft())}")),
                                                                        Container(
                                                                          width:
                                                                              120,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(right: 12.0),
                                                                            child:
                                                                                Text(
                                                                              "R${formatLargeNumber((_selectedButton == 1 ? Constants.claims_details1a[index].amount.toInt() : _selectedButton == 2 ? Constants.claims_details2a[index].amount.toInt() : (_selectedButton == 3) ? Constants.claims_details3a[index].amount.toInt() : Constants.claims_details3a[index].amount.toInt()).toString())}",
                                                                              textAlign: TextAlign.right,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                28),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            3),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              8.0),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            1,
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.10),
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
                                  //             borderRadius: BorderRadius.circular(360),
                                  //             color:
                                  //                 Constants.ctaColorLight.withOpacity(0.1)),
                                  //         child: Padding(
                                  //           padding: const EdgeInsets.only(
                                  //               left: 100, top: 8, right: 100, bottom: 8),
                                  //           child: Text(
                                  //             isShowingType == false
                                  //                 ? "Show Details"
                                  //                 : "Hide Details",
                                  //             style: TextStyle(
                                  //                 color: Constants.ctaColorLight,
                                  //                 fontWeight: FontWeight.bold),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),

                                  SizedBox(height: 24),
                                  /*   if (isShowingType)
                        Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            key: key_mnut1,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _selectedButton == 1
                                ? Constants.claims_droupedChartData1.length
                                : _selectedButton == 2
                                    ? Constants.claims_droupedChartData2.length
                                    : _selectedButton == 3 &&
                                            days_difference <= 31
                                        ? Constants
                                            .claims_droupedChartData3.length
                                        : Constants
                                            .claims_droupedChartData4.length,
                            itemBuilder: (context, index) {
                              ClaimStageCategory category =
                                  ClaimStageCategory(name: '', items: []);
                              if (_selectedButton == 1) {
                                category =
                                    Constants.claims_droupedChartData1[index];
                                // print("yuuyyu1 ${category}");
                              } else if (_selectedButton == 2) {
                                category =
                                    Constants.claims_droupedChartData2[index];
                                // print("yuuyyu2 ${category}");
                              } else if (_selectedButton == 3 &&
                                  days_difference <= 31) {
                                category =
                                    Constants.claims_droupedChartData3[index];
                                //  print("yuuyyu ${category}");
                                //} else {
                                category =
                                    Constants.claims_droupedChartData4[index];
                                // print("yuuyyu4 ${category}");
                              }

                              final totalCategoryCount =
                                  category.getTotalCount();

                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(17),
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.1))),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.5),
                                    child: ListTileTheme(
                                      dense: true,
                                      minVerticalPadding: 0,
                                      child: ExpansionTile(
                                        childrenPadding:
                                            EdgeInsets.only(top: 0, bottom: 0),
                                        tilePadding: EdgeInsets.only(
                                            top: 0,
                                            bottom: 0,
                                            left: 8,
                                            right: 8),
                                        initiallyExpanded: true,
                                        backgroundColor:
                                            Colors.grey.withOpacity(0.35),
                                        collapsedBackgroundColor:
                                            Colors.grey.withOpacity(0.35),
                                        trailing: Container(
                                          width: 80,
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: 16,
                                                child: LinearProgressIndicator(
                                                  value: 1,
                                                  backgroundColor: Colors.grey
                                                      .withOpacity(0.3),
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.blue),
                                                ),
                                              ),
                                              Container(
                                                height: 16,
                                                child: Row(
                                                  children: [
                                                    Spacer(),
                                                    Text(
                                                      formatLargeNumber3(
                                                          totalCategoryCount
                                                              .toString()),
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.white),
                                                    ),
                                                    Spacer(),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        collapsedShape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        title: Text(
                                          category.name.replaceAll(
                                              "Self", "Main Member"),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        children: category.items.map((item) {
                                          double percentage = 0;
                                          if (percentage <= 0) {
                                            item.count / totalCategoryCount;
                                          }
                                          return Container(
                                            color: Colors.white,
                                            child: ListTile(
                                              dense: true,
                                              visualDensity: VisualDensity(
                                                  horizontal: 0, vertical: -4),
                                              minLeadingWidth: 0,
                                              horizontalTitleGap: 0,
                                              contentPadding: EdgeInsets.only(
                                                  left: 8, right: 8),
                                              minVerticalPadding: 0,
                                              selectedColor: Colors.white,
                                              selectedTileColor: Colors.white,
                                              tileColor: Colors.white,
                                              splashColor: Colors.white,
                                              title: Text(
                                                capitalize(item.title),
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              trailing: SizedBox(
                                                width: 80,
                                                height: 16,
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      height: 16,
                                                      child:
                                                          LinearProgressIndicator(
                                                        value: percentage,
                                                        backgroundColor: Colors
                                                            .grey
                                                            .withOpacity(0.3),
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                Colors.blue),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 16,
                                                      child: Row(
                                                        children: [
                                                          Spacer(),
                                                          Text(
                                                            formatLargeNumber3(
                                                                item.count
                                                                    .toString()),
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: percentage <
                                                                        0.50
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .white),
                                                          ),
                                                          Spacer(),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      _selectedButton == 1
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, top: 20),
                              child: Text("Claims Ratio (Rolling Average)"),
                            )
                          : _selectedButton == 2
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 20),
                                  child: Text("Claims Ratio (M on M)"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 20),
                                  child: Text(
                                      "Claims Ratio (${Constants.claims_formattedStartDate} to ${Constants.claims_formattedEndDate})"),
                                ),*/
                                  // SizedBox(
                                  //   height: 20,
                                  // ),
                                  /*   _selectedButton == 1
                          ? Center(
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    surfaceTintColor: Colors.white,
                                    color: Colors.white,
                                    elevation: 6,
                                    child: Center(
                                      child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Center(
                                            child: RadialGauge(
                                              radiusFactor: 1,
                                              track: RadialTrack(
                                                color: Colors.grey.shade300,
                                                startAngle: 0,
                                                endAngle: 180,
                                                start: 0,
                                                end: 100,
                                                trackStyle: TrackStyle(
                                                    labelStyle: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black),
                                                    primaryRulersHeight: 25,
                                                    primaryRulerColor:
                                                        Colors.black54,
                                                    secondaryRulerColor:
                                                        Colors.grey,
                                                    inverseRulers: false,
                                                    secondaryRulersHeight: 15,
                                                    primaryRulersWidth: 1.0,
                                                    secondaryRulerPerInterval:
                                                        4.0),
                                              ),
                                              needlePointer: const [
                                                NeedlePointer(
                                                  value: 0,
                                                  color: Colors.red,
                                                  tailColor: Colors.black,
                                                  tailRadius: 0,
                                                  needleWidth: 3,
                                                  needleStyle:
                                                      NeedleStyle.gaugeNeedle,
                                                ),
                                              ],
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : _selectedButton == 2
                              ? Container(
                                  height: 310, child: ClaimsReportGraph2())
                              : _selectedButton == 3 && days_difference <= 31
                                  ? Row(
                                      children: [
                                        Spacer(),
                                        AnimatedCircularChart(
                                          key: UniqueKey(),
                                          size: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7),
                                          initialChartData: <CircularStackEntry>[
                                            CircularStackEntry(
                                              <CircularSegmentEntry>[
                                                CircularSegmentEntry(
                                                  double.parse(Constants
                                                      .claims_ratio3a
                                                      .toStringAsFixed(2)),
                                                  Colors.indigo,
                                                  rankKey: 'completed',
                                                ),
                                                CircularSegmentEntry(
                                                  100.0 -
                                                      double.parse(Constants
                                                          .claims_ratio3a
                                                          .toStringAsFixed(2)),
                                                  Colors.blue.withOpacity(0.3),
                                                  rankKey: 'remaining',
                                                ),
                                              ],
                                              rankKey: 'progress',
                                            ),
                                          ],
                                          chartType: CircularChartType.Radial,
                                          edgeStyle: SegmentEdgeStyle.round,
                                          startAngle: 3,
                                          holeRadius: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.18,
                                          percentageValues: true,
                                          holeLabel:
                                              '${double.parse(Constants.claims_ratio3a.toStringAsFixed(2))}%',
                                          labelStyle: new TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0,
                                          ),
                                        ),
                                        Spacer(),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Spacer(),
                                        AnimatedCircularChart(
                                          key: UniqueKey(),
                                          size: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7),
                                          initialChartData: <CircularStackEntry>[
                                            CircularStackEntry(
                                              <CircularSegmentEntry>[
                                                CircularSegmentEntry(
                                                  Constants.claims_ratio3b,
                                                  Colors.indigo,
                                                  rankKey: 'completed',
                                                ),
                                                CircularSegmentEntry(
                                                  100.0 -
                                                      Constants.claims_ratio3b,
                                                  Colors.blue.withOpacity(0.3),
                                                  rankKey: 'remaining',
                                                ),
                                              ],
                                              rankKey: 'progress',
                                            ),
                                          ],
                                          chartType: CircularChartType.Radial,
                                          edgeStyle: SegmentEdgeStyle.round,
                                          startAngle: 3,
                                          holeRadius: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.18,
                                          percentageValues: true,
                                          holeLabel:
                                              '${double.parse(Constants.claims_ratio3b.toStringAsFixed(2))}%',
                                          labelStyle: new TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0,
                                          ),
                                        ),
                                        Spacer(),
                                      ],
                                    ),*/
                                  /* _selectedButton == 1
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, top: 12),
                              child: Text(
                                  "Claims Stages (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                            )
                          : _selectedButton == 2
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 12),
                                  child: Text(
                                      "Claims Stages (YTD - ${DateTime.now().year})"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 12),
                                  child: Text(
                                      "Claims Stages (${Constants.claims_formattedStartDate} to ${Constants.claims_formattedEndDate})"),
                                ),
                      _selectedButton == 1
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                surfaceTintColor: Colors.white,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Container(
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    child: BarChart(
                                      BarChartData(
                                        titlesData: FlTitlesData(
                                          show: true,
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              reservedSize:
                                                  32, // Adjust the reserved size as needed
                                              showTitles: true,
                                              getTitlesWidget: (double value,
                                                  TitleMeta meta) {
                                                final index = value.toInt();
                                                if (index >= 0 &&
                                                    index <
                                                        claims_by_category1a_processed
                                                            .keys.length) {
                                                  final key =
                                                      claims_by_category1a_processed
                                                          .keys
                                                          .elementAt(index);
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .only(
                                                        top:
                                                            6.0), // Add some padding to position the text below the axis
                                                    child: Text(
                                                      key,
                                                      maxLines: 2,
                                                      textAlign: TextAlign
                                                          .center, // Center align text
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  return Text('');
                                                }
                                              },
                                            ),
                                          ),
                                          leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              getTitlesWidget: (double value,
                                                  TitleMeta meta) {
                                                if (value < 1) {
                                                  return Text("");
                                                } else
                                                  return SideTitleWidget(
                                                    axisSide: meta.axisSide,
                                                    space: 6.0,
                                                    child: Text(
                                                      value.round().toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10),
                                                    ),
                                                  );
                                              },
                                            ),
                                          ),
                                          topTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: false)),
                                          rightTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: false)),
                                        ),
                                        borderData: FlBorderData(
                                          show:
                                              true, // Enable the showing of borders
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors
                                                  .grey, // Specify the color of the X-axis line
                                              width:
                                                  1, // Specify the width of the X-axis line
                                            ),
                                            // If you don't want to show other borders, set them to BorderSide.none
                                            left: BorderSide.none,
                                            right: BorderSide.none,
                                            top: BorderSide.none,
                                          ),
                                        ),
                                        barGroups:
                                            Constants.claims_barChartData1,
                                        gridData: FlGridData(show: false),
                                        barTouchData: BarTouchData(
                                          touchTooltipData: BarTouchTooltipData(
                                            tooltipBgColor: Colors.blueGrey,
                                            getTooltipItem: (group, groupIndex,
                                                rod, rodIndex) {
                                              final category =
                                                  claims_by_category1a.keys
                                                      .elementAt(
                                                          group.x.toInt());
                                              return BarTooltipItem(
                                                category +
                                                    '\n' +
                                                    (rod.toY - 1).toString(),
                                                TextStyle(color: Colors.yellow),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : _selectedButton == 2
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    surfaceTintColor: Colors.white,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Container(
                                        height: 200,
                                        child: BarChart(
                                          BarChartData(
                                            titlesData: FlTitlesData(
                                              show: true,
                                              bottomTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  reservedSize:
                                                      32, // Adjust the reserved size as needed
                                                  showTitles: true,
                                                  getTitlesWidget:
                                                      (double value,
                                                          TitleMeta meta) {
                                                    final index = value.toInt();
                                                    if (index >= 0 &&
                                                        index <
                                                            claims_by_category1a_processed
                                                                .keys.length) {
                                                      final key =
                                                          claims_by_category1a_processed
                                                              .keys
                                                              .elementAt(index);
                                                      return Padding(
                                                        padding: const EdgeInsets
                                                            .only(
                                                            top:
                                                                6.0), // Add some padding to position the text below the axis
                                                        child: Text(
                                                          key,
                                                          maxLines: 2,
                                                          textAlign: TextAlign
                                                              .center, // Center align text
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      return Text('');
                                                    }
                                                  },
                                                ),
                                              ),
                                              leftTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: true,
                                                  getTitlesWidget:
                                                      (double value,
                                                          TitleMeta meta) {
                                                    if (value < 1) {
                                                      return Text("");
                                                    } else
                                                      return SideTitleWidget(
                                                        axisSide: meta.axisSide,
                                                        space: 6.0,
                                                        child: Text(
                                                          value
                                                              .round()
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 10),
                                                        ),
                                                      );
                                                  },
                                                ),
                                              ),
                                              topTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                      showTitles: false)),
                                              rightTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                      showTitles: false)),
                                            ),
                                            borderData: FlBorderData(
                                              show:
                                                  true, // Enable the showing of borders
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors
                                                      .grey, // Specify the color of the X-axis line
                                                  width:
                                                      1, // Specify the width of the X-axis line
                                                ),
                                                // If you don't want to show other borders, set them to BorderSide.none
                                                left: BorderSide.none,
                                                right: BorderSide.none,
                                                top: BorderSide.none,
                                              ),
                                            ),
                                            barGroups:
                                                Constants.claims_barChartData2,
                                            gridData: FlGridData(show: false),
                                            barTouchData: BarTouchData(
                                              touchTooltipData:
                                                  BarTouchTooltipData(
                                                tooltipBgColor: Colors.blueGrey,
                                                getTooltipItem: (group,
                                                    groupIndex, rod, rodIndex) {
                                                  final category =
                                                      claims_by_category1a.keys
                                                          .elementAt(
                                                              group.x.toInt());
                                                  return BarTooltipItem(
                                                    category +
                                                        '\n' +
                                                        (rod.toY - 1)
                                                            .toString(),
                                                    TextStyle(
                                                        color: Colors.yellow),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : _selectedButton == 3 && days_difference <= 31
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        surfaceTintColor: Colors.white,
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Container(
                                            height: 200,
                                            child: BarChart(
                                              BarChartData(
                                                titlesData: FlTitlesData(
                                                  show: true,
                                                  bottomTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      reservedSize:
                                                          32, // Adjust the reserved size as needed
                                                      showTitles: true,
                                                      getTitlesWidget:
                                                          (double value,
                                                              TitleMeta meta) {
                                                        final index =
                                                            value.toInt();
                                                        if (index >= 0 &&
                                                            index <
                                                                claims_by_category1a_processed
                                                                    .keys
                                                                    .length) {
                                                          final key =
                                                              claims_by_category1a_processed
                                                                  .keys
                                                                  .elementAt(
                                                                      index);
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top:
                                                                        6.0), // Add some padding to position the text below the axis
                                                            child: Text(
                                                              key,
                                                              maxLines: 2,
                                                              textAlign: TextAlign
                                                                  .center, // Center align text
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          );
                                                        } else {
                                                          return Text('');
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  leftTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: true,
                                                      getTitlesWidget:
                                                          (double value,
                                                              TitleMeta meta) {
                                                        if (value < 1) {
                                                          return Text("");
                                                        } else
                                                          return SideTitleWidget(
                                                            axisSide:
                                                                meta.axisSide,
                                                            space: 6.0,
                                                            child: Text(
                                                              value
                                                                  .round()
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 10),
                                                            ),
                                                          );
                                                      },
                                                    ),
                                                  ),
                                                  topTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                          showTitles: false)),
                                                  rightTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                          showTitles: false)),
                                                ),
                                                borderData: FlBorderData(
                                                  show:
                                                      true, // Enable the showing of borders
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: Colors
                                                          .grey, // Specify the color of the X-axis line
                                                      width:
                                                          1, // Specify the width of the X-axis line
                                                    ),
                                                    // If you don't want to show other borders, set them to BorderSide.none
                                                    left: BorderSide.none,
                                                    right: BorderSide.none,
                                                    top: BorderSide.none,
                                                  ),
                                                ),
                                                barGroups: Constants
                                                    .claims_barChartData3,
                                                gridData:
                                                    FlGridData(show: false),
                                                barTouchData: BarTouchData(
                                                  touchTooltipData:
                                                      BarTouchTooltipData(
                                                    tooltipBgColor:
                                                        Colors.blueGrey,
                                                    getTooltipItem: (group,
                                                        groupIndex,
                                                        rod,
                                                        rodIndex) {
                                                      final category =
                                                          claims_by_category1a
                                                              .keys
                                                              .elementAt(group.x
                                                                  .toInt());
                                                      return BarTooltipItem(
                                                        category +
                                                            '\n' +
                                                            (rod.toY - 1)
                                                                .toString(),
                                                        TextStyle(
                                                            color:
                                                                Colors.yellow),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        surfaceTintColor: Colors.white,
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Container(
                                            height: 200,
                                            child: BarChart(
                                              BarChartData(
                                                titlesData: FlTitlesData(
                                                  show: true,
                                                  bottomTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      reservedSize:
                                                          32, // Adjust the reserved size as needed
                                                      showTitles: true,
                                                      getTitlesWidget:
                                                          (double value,
                                                              TitleMeta meta) {
                                                        final index =
                                                            value.toInt();
                                                        if (index >= 0 &&
                                                            index <
                                                                claims_by_category1a_processed
                                                                    .keys
                                                                    .length) {
                                                          final key =
                                                              claims_by_category1a_processed
                                                                  .keys
                                                                  .elementAt(
                                                                      index);
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top:
                                                                        6.0), // Add some padding to position the text below the axis
                                                            child: Text(
                                                              key,
                                                              maxLines: 2,
                                                              textAlign: TextAlign
                                                                  .center, // Center align text
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          );
                                                        } else {
                                                          return Text('');
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  leftTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: true,
                                                      getTitlesWidget:
                                                          (double value,
                                                              TitleMeta meta) {
                                                        if (value < 1) {
                                                          return Text("");
                                                        } else
                                                          return SideTitleWidget(
                                                            axisSide:
                                                                meta.axisSide,
                                                            space: 6.0,
                                                            child: Text(
                                                              value
                                                                  .round()
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 10),
                                                            ),
                                                          );
                                                      },
                                                    ),
                                                  ),
                                                  topTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                          showTitles: false)),
                                                  rightTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                          showTitles: false)),
                                                ),
                                                borderData: FlBorderData(
                                                  show:
                                                      true, // Enable the showing of borders
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: Colors
                                                          .grey, // Specify the color of the X-axis line
                                                      width:
                                                          1, // Specify the width of the X-axis line
                                                    ),
                                                  left: BorderSide.none,
                                                    right: BorderSide.none,
                                                    top: BorderSide.none,
                                                  ),
                                                ),
                                                barGroups: Constants
                                                    .claims_barChartData4,
                                                gridData:
                                                    FlGridData(show: false),
                                                barTouchData: BarTouchData(
                                                  touchTooltipData:
                                                      BarTouchTooltipData(
                                                    tooltipBgColor:
                                                        Colors.blueGrey,
                                                    getTooltipItem: (group,
                                                        groupIndex,
                                                        rod,
                                                        rodIndex) {
                                                      final category =
                                                          claims_by_category1a
                                                              .keys
                                                              .elementAt(group.x
                                                                  .toInt());
                                                      return BarTooltipItem(
                                                        category +
                                                            '\n' +
                                                            (rod.toY - 1)
                                                                .toString(),
                                                        TextStyle(
                                                            color:
                                                                Colors.yellow),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),*/
                                  /* _selectedButton == 1
                          ? Padding(
                              padding: const EdgeInsets.only(left: 0.0, top: 0),
                              child: Text(
                                "Claims Status (MTD - ${getMonthAbbreviation(DateTime.now().month)})",
                                style: TextStyle(
                                    color: Colors.transparent, fontSize: 1),
                              ),
                            )
                          : _selectedButton == 2
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 12),
                                  child: Text(
                                    "Claims Status (12 Months View)",
                                    style: TextStyle(
                                        color: Colors.transparent, fontSize: 1),
                                  ),
                                )
                              : Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0.0, top: 0),
                                  child: Text(
                                    "Claims Status (${Constants.claims_formattedStartDate} to ${Constants.claims_formattedEndDate})",
                                    style: TextStyle(
                                        color: Colors.transparent, fontSize: 1),
                                  ),
                                ),*/

                                  /*     _selectedButton == 1
                          ? Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                  "Paid Claims (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                            )
                          : _selectedButton == 2
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(
                                      "Paid Claims (YTD - ${DateTime.now().year})"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(
                                      "Paid Claims (${Constants.claims_formattedStartDate} to ${Constants.claims_formattedEndDate})"),
                                ),*/
                                ],
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]))),
        ));
  }

  @override
  void initState() {
    secureScreen();
    myNotifier = MyNotifier(claimsValue, context);
    claimsValue.addListener(() {
      if (mounted) setState(() {});
    });
    //getMood1("");
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
    Constants.claims_formattedStartDate =
        DateFormat('yyyy-MM-dd').format(startDate!);
    Constants.claims_formattedEndDate =
        DateFormat('yyyy-MM-dd').format(endDate!);
    setState(() {});

    String dateRange =
        '${Constants.claims_formattedStartDate} - ${Constants.claims_formattedEndDate}';

    DateTime startDateTime =
        DateFormat('yyyy-MM-dd').parse(Constants.claims_formattedStartDate);
    DateTime endDateTime =
        DateFormat('yyyy-MM-dd').parse(Constants.claims_formattedEndDate);

    days_difference = endDateTime.difference(startDateTime).inDays;
    if (kDebugMode) {
      print("days_difference ${days_difference}");
      print("formattedEndDate9 ${Constants.claims_formattedEndDate}");
    }

    setState(() {});
    startInactivityTimer();
    // getSalesReport(context, formattedStartDate, formattedEndDate);
    myNotifier = MyNotifier(claimsValue, context);

    claimsValue.addListener(() {
      if (mounted) setState(() {});
      Future.delayed(Duration(seconds: 2)).then((value) {
        //print("noOfDaysThisMonth $noOfDaysThisMonth");
        Constants.sales_tree_key3a = UniqueKey();
        if (mounted) setState(() {});

        if (kDebugMode) {
          //  print("ghjfgfgfgg $_selectedButton");
        }
      });
    });
    super.initState();
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
                    ? Constants.claims_salesbybranch1a[index - 1].branch_name
                    : Constants.claims_salesbybranch2a[index - 1].branch_name,
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

  String capitalize(String input) {
    return input.replaceAllMapped(RegExp(r"(^|[\s-])\w"), (match) {
      return match.group(0)!.toUpperCase();
    });
  }

  double _getProcessingAmount(String name) {
    if (kDebugMode) {
      print("Selected Button: $_selectedButton");
    }
    if (_selectedButton == 1) {
      return _getAmountFromList(Constants.claims_section_list1a, name);
    } else if (_selectedButton == 2) {
      return _getAmountFromList(Constants.claims_section_list2a, name);
    } else if (_selectedButton == 3 && days_difference <= 31) {
      return _getAmountFromList(Constants.claims_section_list3a, name);
    } else {
      return _getAmountFromList(Constants.claims_section_list3a, name);
    }
  }

  double _getAmountFromList(Map<dynamic, dynamic>? list, dynamic name) {
    if (list == null) {
      if (kDebugMode) {
        print("The list is null");
      }
      return 0.0;
    }
    if (list["claims_sum_by_category"] == null) {
      if (kDebugMode) {
        print("claims_sum_by_category is null");
      }
      return 0.0;
    }
    if (list["claims_sum_by_category"][name] == null) {
      if (kDebugMode) {
        print("Processing category is null");
      }
      return 0.0;
    }

    // Convert the value to double to ensure the correct return type.
    return (list["claims_sum_by_category"][name] as num).toDouble();
  }

  double _getLodgingAmount() {
    Map<dynamic, dynamic>? claimsSumByCategory;

    // Determine the correct claims section list based on the selected button
    if (_selectedButton == 1) {
      claimsSumByCategory =
          Constants.claims_section_list1a["claims_sum_by_category"];
    } else if (_selectedButton == 2) {
      claimsSumByCategory =
          Constants.claims_section_list2a["claims_sum_by_category"];
    } else if (_selectedButton == 3 && days_difference <= 31) {
      claimsSumByCategory =
          Constants.claims_section_list3a["claims_sum_by_category"];
    } else {
      claimsSumByCategory =
          Constants.claims_section_list3a["claims_sum_by_category"];
    }

    // Ensure the value returned is always a double
    return (claimsSumByCategory?["Lodging"] as num?)?.toDouble() ?? 0.0;
  }
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
        dotSize: ui.lerpDouble(a.dotSize, b.dotSize, t)!,
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

String formatWithCommasB(double value) {
  final format = NumberFormat("#,##0", "en_US"); // Updated pattern
  return format.format(value);
}

String formatLargeNumberB(String valueStr) {
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
    return '0';
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
    return "-";
  }

  // Return the corresponding month abbreviation
  return months[monthNumber - 1];
}

class CategoryItem {
  String title;
  int count;

  CategoryItem({required this.title, required this.count});
}

class Category {
  String name;
  List<CategoryItem> items;

  Category({required this.name, required this.items});
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
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      getClaimsGraphData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 280,
        child: Padding(
            padding: const EdgeInsets.only(
                left: 12.0, top: 8, right: 16, bottom: 16),
            child: CustomCard(
                surfaceTintColor: Colors.white,
                color: Colors.white,
                elevation: 12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, top: 20, right: 24, bottom: 12),
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
                      maxY: claims_maxY2.toDouble(),
                      minX: claims_spots2.length < 1
                          ? 0
                          : claims_spots2[0].x.toDouble(),
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
        //print("e_dshvalue ${key} ${value}");

        DateTime dt1 = DateTime.parse(key);
        int year = dt1.year;
        int month = dt1.month;
        double new_value = double.parse(value.toString()) * 100;

        claims_spots2.add(FlSpot((year * 12 + month).toDouble(), new_value));
        if (new_value != 0)
          salesSpots.add(FlSpot((year * 12 + month).toDouble(), new_value));
        claims_maxY2 = max(new_value.round(), 100);
        claimsValue.value++;
        // print("spot added");
      });

      setState(() {
        claims_spots2a = salesSpots;
        print(claims_spots2a);
      });
    } catch (exception) {
      //print("Error: $exception");
      // print("Stack Trace: $exception");
    }
  }
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
  } else {
    return value.toStringAsFixed(0);
  }
}

class _BarChartLabelPainter extends CustomPainter {
  final List<BarChartGroupData> barData;
  final double chartContainerHeight;

  _BarChartLabelPainter(
      {required this.barData, required this.chartContainerHeight});

  @override
  void paint(Canvas canvas, Size size) {
    // Custom painting logic to draw text labels on top of each bar
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ClaimsGridView extends StatefulWidget {
  final String category;
  final int selectedButton;
  final int daysDifference;

  ClaimsGridView({
    required this.category,
    required this.selectedButton,
    required this.daysDifference,
  });

  @override
  _ClaimsGridViewState createState() => _ClaimsGridViewState();
}

class _ClaimsGridViewState extends State<ClaimsGridView> {
  late Map<String, dynamic> categoryData;

  @override
  void initState() {
    super.initState();
    categoryData = getCategoryData();
    if (categoryData.isEmpty) {
      categoryData = {
        'percentages': {
          'Within 5 Hours': 0.0,
          'Within 12 Hours': 0.0,
          'Within 24 Hours': 0.0,
          'Within 48 Hours': 0.0,
          'After 48 Hours': 0.0,
          'After 5 Days': 0.0,
        },
        'counts': {
          'Within 5 Hours': 0,
          'Within 12 Hours': 0,
          'Within 24 Hours': 0,
          'Within 48 Hours': 0,
          'After 48 Hours': 0,
          'After 5 Days': 0,
        },
        'amounts': {
          'Within 5 Hours': 0.0,
          'Within 12 Hours': 0.0,
          'Within 24 Hours': 0.0,
          'Within 48 Hours': 0.0,
          'After 48 Hours': 0.0,
          'After 5 Days': 0.0,
        },
      };
    }
    //print("categoryData $categoryData");
  }

  Map<String, dynamic> getCategoryData() {
    switch (widget.selectedButton) {
      case 1:
        print(
            "ddsdsdsd ${widget.selectedButton} ${Constants.claims_section_list1a?["claims_percentages"]?[widget.category]}");
        return (Constants.claims_section_list1a != null &&
                Constants.claims_section_list1a!["claims_percentages"] !=
                    null &&
                Constants.claims_section_list1a!["claims_percentages"]![
                        widget.category] !=
                    null)
            ? Constants
                .claims_section_list1a!["claims_percentages"]![widget.category]
            : {};
      case 2:
        return (Constants.claims_section_list2a != null &&
                Constants.claims_section_list2a!["claims_percentages"] !=
                    null &&
                Constants.claims_section_list2a!["claims_percentages"]![
                        widget.category] !=
                    null)
            ? Constants
                .claims_section_list2a!["claims_percentages"]![widget.category]
            : {};
      case 3:
        if (widget.daysDifference <= 31) {
          return (Constants.claims_section_list3a != null &&
                  Constants.claims_section_list3a!["claims_percentages"] !=
                      null &&
                  Constants.claims_section_list3a!["claims_percentages"]![
                          widget.category] !=
                      null)
              ? Constants.claims_section_list3a!["claims_percentages"]![
                  widget.category]
              : {};
        } else {
          return (Constants.claims_section_list3a != null &&
                  Constants.claims_section_list3a!["claims_percentages"] !=
                      null &&
                  Constants.claims_section_list3a!["claims_percentages"]![
                          widget.category] !=
                      null)
              ? Constants.claims_section_list3a!["claims_percentages"]![
                  widget.category]
              : {};
        }
      default:
        return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    var percentages = categoryData['counts'] ?? {};
    var amounts = categoryData['amounts'] ?? {};

    int itemCount = percentages.length < amounts.length
        ? percentages.length
        : amounts.length;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 2, top: 8, bottom: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 2),
        ),
        itemCount: itemCount,
        padding: EdgeInsets.all(0.0),
        itemBuilder: (BuildContext context, int index) {
          String key = percentages.keys.elementAt(index);
          return _buildClaimSectionCard(
              context, key, percentages[key], amounts[key], index);
        },
      ),
    );
  }

  Widget _buildClaimSectionCard(BuildContext context, String timeCategory,
      dynamic percentage, dynamic amount, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0, right: 8),
      child: Card(
        surfaceTintColor: Colors.white,
        elevation: 12,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipPath(
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16))),
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: index < 3
                            ? Colors.green
                            : Colors.orangeAccent[400]!,
                        width: 6))),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.05),
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
                              height: 18,
                            ),
                            Center(
                                child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                "R" + formatLargeNumber(amount.toString()),
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                              ),
                            )),
                            Center(
                                child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8, top: 0),
                              child: Text(
                                percentage.toStringAsFixed(0) +
                                    (percentage > 1 ? " Claims" : " Claim"),
                                style: TextStyle(
                                    fontSize: 9, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                              ),
                            )),
                            SizedBox(
                              height: 8,
                            ),
                            Center(
                                child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Text(
                                timeCategory.toString(),
                                style: TextStyle(fontSize: 11.5),
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
    );
  }
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
