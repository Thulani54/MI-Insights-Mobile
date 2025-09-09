import 'dart:async';
import 'dart:ui' as ui;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_insights/services/reprints_and_cancellations_service.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../admin/ClientSearchPage.dart';
import '../../constants/Constants.dart';
import '../../customwidgets/CustomCard.dart';
import '../../customwidgets/custom_date_range_picker.dart';
import '../../services/MyNoyifier.dart';
import '../../services/inactivitylogoutmixin.dart';
import '../../services/window_manager.dart';

class ReprintsAndCancellationsReport extends StatefulWidget {
  const ReprintsAndCancellationsReport({super.key});

  @override
  State<ReprintsAndCancellationsReport> createState() =>
      _ReprintsAndCancellationsReportState();
}

int noOfDaysThisMonth = 30;
bool isLoading = false;
final reprintsValue = ValueNotifier<int>(0);
List<BarChartGroupData> reprints_barChartData1 = [];
List<BarChartGroupData> reprints_barChartData1_1 = [];
List<BarChartGroupData> reprints_barChartData2 = [];
List<BarChartGroupData> reprints_barChartData2_1 = [];
List<BarChartGroupData> reprints_barChartData3 = [];
List<BarChartGroupData> reprints_barChartData3_1 = [];
List<BarChartGroupData> reprints_barChartData4 = [];
List<BarChartGroupData> reprints_barChartData4_1 = [];
MyNotifier? myNotifier;
double _sliderPosition2 = 0.0;
DateTime datefrom = DateTime.now().subtract(Duration(days: 60));
DateTime dateto = DateTime.now();
int days_difference = 0;
Widget wdg1 = Container();
int report_index = 0;
int reprints_index = 0;
String data2 = "";
Key kyrt = UniqueKey();
int touchedIndex = -1;
int target_index = 0;

class _ReprintsAndCancellationsReportState
    extends State<ReprintsAndCancellationsReport> with InactivityLogoutMixin {
  double _sliderPosition = 0.0;
  int _selectedButton = 1;
  bool isSameDaysRange = true;
  Color _button1Color = Colors.grey.withOpacity(0.0);
  Color _button2Color = Colors.grey.withOpacity(0.0);
  Color _button3Color = Colors.grey.withOpacity(0.0);
  void _animateButton(int buttonNumber) {
    DateTime? startDate = DateTime.now();
    DateTime? endDate = DateTime.now();

    _selectedButton = buttonNumber;
    if (buttonNumber == 1) {
      _sliderPosition = 0.0;
      Constants.reprintbyagent = Constants.reprintbyagent1a;
    } else if (buttonNumber == 2) {
      _sliderPosition = (MediaQuery.of(context).size.width / 3) - 18;
      Constants.reprintbyagent = Constants.reprintbyagent2a;
    } else if (buttonNumber == 3)
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
        isLoading = true;
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
      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate!);
      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate!);
      days_difference = endDate.difference(startDate).inDays;

      // Update Constants
      Constants.reprints_formattedStartDate = formattedStartDate;
      Constants.reprints_formattedEndDate = formattedEndDate;

      // Call getReprintsData
      getReprintsData(
              formattedStartDate, formattedEndDate, buttonNumber, context)
          .then((value) {
        if (mounted)
          setState(() {
            isLoading = false;
          });
      }).catchError((error) {
        if (kDebugMode) {
          print("❌ Error in _animateButton getReprintsData: $error");
        }
        if (mounted)
          setState(() {
            isLoading = false;
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
          setState(() {
            endDate = end;
            startDate = start;
          });
          if (kDebugMode) {
            //  print("dfdggf $start $end");
          }

          days_difference = end!.difference(start).inDays;
          if (end.month == start.month) {
            isSameDaysRange = true;
          } else {
            isSameDaysRange = false;
          }
          Constants.reprints_formattedStartDate =
              DateFormat('yyyy-MM-dd').format(start);
          Constants.reprints_formattedEndDate =
              DateFormat('yyyy-MM-dd').format(end);
          isLoading = true;
          setState(() {});

          getReprintsData(Constants.reprints_formattedStartDate,
                  Constants.reprints_formattedEndDate, 3, context)
              .then((value) {
            isLoading = false;
            /* print(
                "dfdggf2 ${Constants.reprints_formattedStartDate} ${Constants.reprints_formattedEndDate}");
*/
            setState(() {});
          });
        },
        onCancelClick: () {
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
          backgroundColor: Colors.white,
          centerTitle: true,
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
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black.withOpacity(0.6),
          title: const Text(
            "Cancellations and Reprints Report",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          elevation: 6,
        ),
        body: Container(
          color: Colors.white,
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
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : _selectedButton == 2
                                      ? Center(
                                          child: Text(
                                            '12 Mths View',
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
                    child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                      SizedBox(
                        height: 16,
                      ),
                      /*Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, bottom: 0, top: 20),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(360),
                                color: Colors.grey.withOpacity(0.1)),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                "Payment Cancellation Requests",
                                style: TextStyle(
                                    color: Constants.ctaColorLight,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),*/
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
                                              'Payment Cancellation',
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
                                              'Payment Reprint',
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
                                                'Payment Cancellation',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          : target_index == 1
                                              ? Center(
                                                  child: Text(
                                                    'Payment Reprint',
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
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 4.0, top: 8, bottom: 8),
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
                                            2.15)),
                            itemCount: _selectedButton == 1
                                ? Constants.cancellations_sectionsList1a.length
                                : _selectedButton == 2
                                    ? Constants
                                        .cancellations_sectionsList2a.length
                                    : _selectedButton == 3 &&
                                            days_difference <= 31
                                        ? Constants
                                            .cancellations_sectionsList3a.length
                                        : Constants.cancellations_sectionsList3b
                                            .length,
                            padding: EdgeInsets.all(2.0),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                  customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  onTap: () {
                                    restartInactivityTimer();
                                  },
                                  child: Container(
                                    height: 290,
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: Stack(
                                      children: [
                                        InkWell(
                                          customBorder: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          onTap: () {
                                            reprints_index = index;
                                            restartInactivityTimer();
                                            setState(() {});
                                            if (kDebugMode) {
                                              print("reprints_index " +
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
                                                                  .ftaColorLight,
                                                              width: 6))),
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: reprints_index ==
                                                                      index
                                                                  ? Colors.grey
                                                                      .withOpacity(
                                                                          0.05)
                                                                  : Colors.grey
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
                                                              width:
                                                                  MediaQuery.of(
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
                                                                      right: 0,
                                                                      left: 0,
                                                                      bottom:
                                                                          4),
                                                              child: isLoading
                                                                  ? Center(
                                                                      child: CircularProgressIndicator(
                                                                        color: Constants.ftaColorLight,
                                                                        strokeWidth: 2,
                                                                      ),
                                                                    )
                                                                  : Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height: 16,
                                                                        ),
                                                                        Center(
                                                                            child:
                                                                                Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left:
                                                                                  8.0,
                                                                              right:
                                                                                  8),
                                                                          child: Text(
                                                                            "R" +
                                                                                formatLargeNumber((_selectedButton == 1
                                                                                        ? Constants.cancellations_sectionsList1a[index].amount
                                                                                        : _selectedButton == 2
                                                                                            ? Constants.cancellations_sectionsList2a[index].amount
                                                                                            : _selectedButton == 3 && days_difference <= 31
                                                                                                ? Constants.cancellations_sectionsList3a[index].amount
                                                                                                : Constants.cancellations_sectionsList3b[index].amount)
                                                                                    .toString()),
                                                                            style: TextStyle(
                                                                                fontSize:
                                                                                    16.5,
                                                                                fontWeight:
                                                                                    FontWeight.w600),
                                                                            textAlign:
                                                                                TextAlign
                                                                                    .center,
                                                                            maxLines:
                                                                                2,
                                                                          ),
                                                                        )),
                                                                        Center(
                                                                          child: Padding(
                                                                              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                                                                              child: Text(
                                                                                formatLargeNumber((_selectedButton == 1
                                                                                        ? Constants.cancellations_sectionsList1a[index].count
                                                                                        : _selectedButton == 2
                                                                                            ? Constants.cancellations_sectionsList2a[index].count
                                                                                            : _selectedButton == 3 && days_difference <= 31
                                                                                                ? Constants.cancellations_sectionsList3a[index].count
                                                                                                : Constants.cancellations_sectionsList3b[index].count)
                                                                                    .toString()),
                                                                          style: TextStyle(
                                                                              fontSize: 12.5,
                                                                              fontWeight: FontWeight.normal),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          maxLines:
                                                                              2,
                                                                        )),
                                                                  ),
                                                                  Center(
                                                                      child:
                                                                          Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left: 8,
                                                                        right:
                                                                            8,
                                                                        top: 8,
                                                                        bottom:
                                                                            6),
                                                                    child: Text(
                                                                      _selectedButton ==
                                                                              1
                                                                          ? Constants
                                                                              .cancellations_sectionsList1a[index]
                                                                              .id
                                                                          : _selectedButton == 2
                                                                              ? Constants.cancellations_sectionsList2a[index].id
                                                                              : _selectedButton == 3 && days_difference <= 31
                                                                                  ? Constants.cancellations_sectionsList3a[index].id
                                                                                  : Constants.cancellations_sectionsList3b[index].id,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12.5,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
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
                      if (target_index == 0)
                        Container(
                          height: 12,
                        ),
                      if (target_index == 0)
                        _selectedButton == 1
                            ? Padding(
                                padding: EdgeInsets.only(
                                    left: 0.0, bottom: 4, top: 0),
                                child: Center(
                                    child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, right: 16, bottom: 8),
                                        child: Text(
                                            "Approval Rate (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                      ),
                                    )
                                  ],
                                )),
                              )
                            : _selectedButton == 2
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left: 0.0, bottom: 4, top: 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0,
                                                right: 16,
                                                bottom: 8),
                                            child: Text(
                                                "Approval Rate (12 Months View)"),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, bottom: 4, top: 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0,
                                                right: 16,
                                                bottom: 8),
                                            child: Text(
                                                "Approval Rate (${Constants.reprints_formattedStartDate} to ${Constants.reprints_formattedEndDate})"),
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
                      if (target_index == 0)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 6.0,
                            right: 6,
                          ),
                          child: LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width - 12,
                            animation: false,
                            lineHeight: 20.0,
                            animationDuration: 500,
                            percent: _selectedButton == 1
                                ? Constants
                                    .cancellations_request_approval_rate1a
                                : _selectedButton == 2
                                    ? Constants
                                        .cancellations_request_approval_rate2a
                                    : _selectedButton == 3 &&
                                            days_difference <= 31
                                        ? Constants
                                            .cancellations_request_approval_rate3a
                                        : Constants
                                            .cancellations_request_approval_rate3b,

                            center: Text(
                                "${((_selectedButton == 1 ? Constants.cancellations_request_approval_rate1a : _selectedButton == 2 ? Constants.cancellations_request_approval_rate2a : _selectedButton == 3 && days_difference <= 31 ? Constants.cancellations_request_approval_rate3a : Constants.cancellations_request_approval_rate3b) * 100).toStringAsFixed(1)}%"),
                            barRadius: ui.Radius.circular(12),
                            //linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: Colors.green,
                          ),
                        ),

                      SizedBox(height: 8),
                      if (target_index == 0)
                        _selectedButton == 1
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 16.0, top: 8),
                                child: Text(
                                    "Payment Cancellation Requests (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                              )
                            : _selectedButton == 2
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 8),
                                    child: Text(
                                        "Payment Cancellation Requests (12 Months View)"),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 8),
                                    child: Text(
                                        "Payment Cancellation Requests (${Constants.reprints_formattedStartDate} to ${Constants.reprints_formattedEndDate})"),
                                  ),
                      if (target_index == 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey.withOpacity(0.00)),
                              height: 250,
                              child: isLoading == false
                                  ? _selectedButton == 1
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, left: 8, right: 10),
                                          child: CustomCard(
                                            elevation: 6,
                                            surfaceTintColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            color: Colors.white,
                                            child: AspectRatio(
                                              aspectRatio: 1.66,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16),
                                                child: LayoutBuilder(
                                                  builder:
                                                      (context, constraints) {
                                                    if (reprints_barChartData1
                                                        .isEmpty) {
                                                      return Center(
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
                                                      );
                                                    } else {
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
                                                                      15,
                                                                  getTitlesWidget:
                                                                      (value,
                                                                          meta) {
                                                                    double
                                                                        inValue =
                                                                        value
                                                                            .roundToDouble();

                                                                    print(
                                                                        "dsdghds ${inValue}");
                                                                    if (inValue !=
                                                                        value) {
                                                                      return Text(
                                                                          "");
                                                                    } else
                                                                      return Text(
                                                                        formatLargeNumber4(
                                                                            value.toString()),
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
                                                                reprints_barChartData1,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : _selectedButton == 2
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0, left: 8, right: 10),
                                              child: CustomCard(
                                                color: Colors.white,
                                                elevation: 6,
                                                surfaceTintColor: Colors.white,
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
                                                        if (reprints_barChartData2
                                                            .isEmpty) {
                                                          return Center(
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
                                                          );
                                                        } else {
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
                                                                        double
                                                                            inValue =
                                                                            value.roundToDouble();

                                                                        print(
                                                                            "dsdghds ${inValue}");
                                                                        if (inValue !=
                                                                            value) {
                                                                          return Text(
                                                                              "");
                                                                        } else
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
                                                                          15,
                                                                      getTitlesWidget:
                                                                          (value,
                                                                              meta) {
                                                                        double
                                                                            inValue =
                                                                            value.roundToDouble();

                                                                        print(
                                                                            "dsdghds ${inValue}");
                                                                        if (inValue !=
                                                                            value) {
                                                                          return Text(
                                                                              "");
                                                                        } else
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
                                                                    reprints_barChartData2,
                                                              ),
                                                            ),
                                                          );
                                                        }
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
                                                          top: 8.0,
                                                          left: 8,
                                                          right: 10),
                                                  child: CustomCard(
                                                    color: Colors.white,
                                                    elevation: 6,
                                                    surfaceTintColor:
                                                        Colors.white,
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
                                                            if (reprints_barChartData3
                                                                .isEmpty) {
                                                              return Center(
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
                                                              );
                                                            } else {
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
                                                                              15,
                                                                          getTitlesWidget:
                                                                              (value, meta) {
                                                                            double
                                                                                inValue =
                                                                                value.roundToDouble();

                                                                            print("dsdghds ${inValue}");
                                                                            if (inValue !=
                                                                                value) {
                                                                              return Text("");
                                                                            } else
                                                                              return Text(
                                                                                formatLargeNumber2(value.toInt().toString()),
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
                                                                        reprints_barChartData3,
                                                                  ),
                                                                ),
                                                              );
                                                            }
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
                                                          const EdgeInsets.only(
                                                              top: 8.0,
                                                              left: 8,
                                                              right: 10),
                                                      child: CustomCard(
                                                        color: Colors.white,
                                                        elevation: 6,
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
                                                                if (reprints_barChartData4
                                                                    .isEmpty) {
                                                                  return Center(
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
                                                                  );
                                                                } else {
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
                                                                                    // value.toString(),
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
                                                                              showTitles: false,
                                                                              getTitlesWidget: (value, meta) {
                                                                                return Text(value.toInt().toString());
                                                                              },
                                                                            ),
                                                                          ),
                                                                          leftTitles:
                                                                              AxisTitles(
                                                                            sideTitles:
                                                                                SideTitles(
                                                                              showTitles: true,
                                                                              reservedSize: 15,
                                                                              getTitlesWidget: (value, meta) {
                                                                                double inValue = value.roundToDouble();

                                                                                print("dsdghds ${inValue}");
                                                                                if (inValue != value) {
                                                                                  return Text("");
                                                                                } else
                                                                                  return Text(
                                                                                    formatLargeNumber2(value.toInt().toString()),
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
                                                                            reprints_barChartData4,
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container()
                                  : Container(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, left: 8, right: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.grey.withOpacity(0.00)),
                                      height: 250,
                                      child: CustomCard(
                                          elevation: 6,
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
                                          )))),
                        ),
                      if (target_index == 0)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 8, bottom: 4, top: 20),
                          child: SalesOverviewTypeGrid(),
                        ),
                      if (target_index == 0)
                        _selectedButton == 1
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, top: 20, bottom: 4),
                                child: Text(
                                    "Cancellations - Top 10 Requesters (MTD- ${getMonthAbbreviation(DateTime.now().month)})"),
                              )
                            : _selectedButton == 2
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 20, bottom: 4),
                                    child: Text(
                                        "Cancellations - Top 10 Requesters (12 Months View)"),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 20, bottom: 4),
                                    child: Text(
                                        "Cancellations - Top 10 Requesters (${Constants.reprints_formattedStartDate} to ${Constants.reprints_formattedEndDate})"),
                                  ),
                      if (target_index == 0)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12.0, right: 14, bottom: 8, top: 0),
                          child: Card(
                            color: Colors.white,
                            elevation: 6,
                            surfaceTintColor: Colors.white,
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
                                    padding: const EdgeInsets.all(6.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 27,
                                          height: 28,
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(360)),
                                          child: Center(
                                            child: Text(
                                              "#",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 10,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Text("Requester's Name"),
                                            )),
                                        Expanded(
                                          flex: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0),
                                            child: Text(
                                              "Count",
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0, right: 8),
                                  child: isLoading
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
                                          padding: EdgeInsets.only(
                                              left: 12, right: 12, top: 12),
                                          child: ListView.builder(
                                              padding: EdgeInsets.only(
                                                  top: 0, bottom: 0),
                                              itemCount: _selectedButton == 1
                                                  ? Constants.cancellations_agents1a
                                                              .length >
                                                          10
                                                      ? 10
                                                      : Constants
                                                          .cancellations_agents1a
                                                          .length
                                                  : _selectedButton == 2
                                                      ? Constants.cancellations_agents2a
                                                                  .length >
                                                              10
                                                          ? 10
                                                          : Constants
                                                              .cancellations_agents2a
                                                              .length
                                                      : _selectedButton == 3 &&
                                                              days_difference <=
                                                                  31
                                                          ? Constants.cancellations_agents3a
                                                                      .length >
                                                                  10
                                                              ? 10
                                                              : Constants
                                                                  .cancellations_agents3a
                                                                  .length
                                                          : Constants.cancellations_agents3b
                                                                      .length >
                                                                  10
                                                              ? 10
                                                              : Constants
                                                                  .cancellations_agents3b
                                                                  .length,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Container(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 23,
                                                              child: Text(
                                                                  "${index + 1} "),
                                                            ),
                                                            Expanded(
                                                                flex: 10,
                                                                child: Text(
                                                                    "${_selectedButton == 1 ? Constants.cancellations_agents1a[index].agent_name : _selectedButton == 2 ? Constants.cancellations_agents2a[index].agent_name : _selectedButton == 3 && days_difference <= 31 ? Constants.cancellations_agents3a[index].agent_name : Constants.cancellations_agents3b[index].agent_name}")),
                                                            Expanded(
                                                              flex: 4,
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(
                                                                          left:
                                                                              8,
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "${_selectedButton == 1 ? formatLargeNumber2(Constants.cancellations_agents1a[index].sales.toStringAsFixed(0)) : _selectedButton == 2 ? formatLargeNumber2(Constants.cancellations_agents2a[index].sales.toStringAsFixed(0)) : _selectedButton == 3 && days_difference <= 31 ? formatLargeNumber2(Constants.cancellations_agents3a[index].sales.toStringAsFixed(0)) : formatLargeNumber2(Constants.cancellations_agents3b[index].sales.toStringAsFixed(0))}",
                                                                          style:
                                                                              TextStyle(fontSize: 13),
                                                                          textAlign:
                                                                              TextAlign.left,
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
                                                                  top: 8.0),
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
                                ),
                              ],
                            )),
                          ),
                        ),
                      /*  if (target_index == 0)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 6,
                            surfaceTintColor: Colors.white,
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
                                    padding: const EdgeInsets.all(6.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(360)),
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
                                  padding: EdgeInsets.only(left: 8.0, right: 8),
                                  child: isLoading
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
                                          padding: EdgeInsets.all(12),
                                          child: ListView.builder(
                                              padding: EdgeInsets.only(
                                                  top: 0, bottom: 0),
                                              itemCount: _selectedButton == 1
                                                  ? Constants.bottomscancellations_agents1a
                                                              .length >
                                                          10
                                                      ? 10
                                                      : Constants
                                                          .bottomscancellations_agents1a
                                                          .length
                                                  : _selectedButton == 2
                                                      ? Constants.bottomscancellations_agents2a
                                                                  .length >
                                                              10
                                                          ? 10
                                                          : Constants
                                                              .bottomscancellations_agents2a
                                                              .length
                                                      : _selectedButton == 3 &&
                                                              days_difference <=
                                                                  31
                                                          ? Constants.bottomscancellations_agents3a
                                                                      .length >
                                                                  10
                                                              ? 10
                                                              : Constants
                                                                  .bottomscancellations_agents3a
                                                                  .length
                                                          : Constants.bottomscancellations_agents3b
                                                                      .length >
                                                                  10
                                                              ? 10
                                                              : Constants
                                                                  .bottomscancellations_agents3b
                                                                  .length,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                                flex: 10,
                                                                child: Text(
                                                                    "${_selectedButton == 1 ? Constants.bottomscancellations_agents1a[index].agent_name : _selectedButton == 2 ? Constants.bottomscancellations_agents2a[index].agent_name : _selectedButton == 3 && days_difference <= 31 ? Constants.bottomscancellations_agents3a[index].agent_name : Constants.bottomscancellations_agents3b[index].agent_name}")),
                                                            Expanded(
                                                              flex: 4,
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(
                                                                          left:
                                                                              8,
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "${_selectedButton == 1 ? formatLargeNumber2(Constants.bottomscancellations_agents1a[index].sales.toStringAsFixed(0)) : _selectedButton == 2 ? formatLargeNumber2(Constants.bottomscancellations_agents2a[index].sales.toStringAsFixed(0)) : _selectedButton == 3 && days_difference <= 31 ? formatLargeNumber2(Constants.bottomscancellations_agents3a[index].sales.toStringAsFixed(0)) : formatLargeNumber2(Constants.bottomscancellations_agents3b[index].sales.toStringAsFixed(0))}",
                                                                          style:
                                                                              TextStyle(fontSize: 13),
                                                                          textAlign:
                                                                              TextAlign.left,
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
                                                                  top: 8.0),
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
                                ),
                              ],
                            )),
                          ),
                        ),*/
                      /* Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, bottom: 16, top: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(360),
                                color: Colors.grey.withOpacity(0.1)),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                "Payment Reprint Requests",
                                style: TextStyle(
                                    color: Constants.ctaColorLight,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),*/
                      if (target_index == 1)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 4.0, top: 0, bottom: 8),
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
                                            2.15)),
                            itemCount: _selectedButton == 1
                                ? Constants.reprints_sectionsList1a.length
                                : _selectedButton == 2
                                    ? Constants.reprints_sectionsList2a.length
                                    : _selectedButton == 3 &&
                                            days_difference <= 31
                                        ? Constants
                                            .reprints_sectionsList3a.length
                                        : Constants
                                            .reprints_sectionsList3b.length,
                            padding: EdgeInsets.all(2.0),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                  onTap: () {
                                    restartInactivityTimer();
                                  },
                                  child: Container(
                                    height: 290,
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: Stack(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            reprints_index = index;
                                            restartInactivityTimer();
                                            setState(() {});
                                            if (kDebugMode) {
                                              print("reprints_index " +
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
                                              color: Colors.white,
                                              elevation: 6,
                                              surfaceTintColor: Colors.white,
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
                                                              color: reprints_index ==
                                                                      index
                                                                  ? Colors.grey
                                                                      .withOpacity(
                                                                          0.05)
                                                                  : Colors.grey
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
                                                              width:
                                                                  MediaQuery.of(
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
                                                                      right: 0,
                                                                      left: 0,
                                                                      bottom:
                                                                          4),
                                                              child: isLoading
                                                                  ? Center(
                                                                      child: CircularProgressIndicator(
                                                                        color: Constants.ftaColorLight,
                                                                        strokeWidth: 2,
                                                                      ),
                                                                    )
                                                                  : Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height: 16,
                                                                        ),
                                                                        Center(
                                                                            child:
                                                                                Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left:
                                                                                  8.0,
                                                                              right:
                                                                                  8),
                                                                          child: Text(
                                                                            "R" +
                                                                                formatLargeNumber((_selectedButton == 1
                                                                                        ? Constants.reprints_sectionsList1a[index].amount
                                                                                        : _selectedButton == 2
                                                                                            ? Constants.reprints_sectionsList2a[index].amount
                                                                                            : _selectedButton == 3 && days_difference <= 31
                                                                                                ? Constants.reprints_sectionsList3a[index].amount
                                                                                                : Constants.reprints_sectionsList3b[index].amount)
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
                                                                        Center(
                                                                          child: Padding(
                                                                              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                                                                              child: Text(
                                                                                formatLargeNumber((_selectedButton == 1
                                                                                        ? Constants.reprints_sectionsList1a[index].count
                                                                                        : _selectedButton == 2
                                                                                            ? Constants.reprints_sectionsList2a[index].count
                                                                                            : _selectedButton == 3 && days_difference <= 31
                                                                                                ? Constants.reprints_sectionsList3a[index].count
                                                                                                : Constants.reprints_sectionsList3b[index].count)
                                                                                    .toString()),
                                                                                style: TextStyle(
                                                                                    fontSize: 12.5,
                                                                                    fontWeight: FontWeight.normal),
                                                                                textAlign:
                                                                                    TextAlign.center,
                                                                                maxLines:
                                                                                    2,
                                                                              )),
                                                                        ),
                                                                  Center(
                                                                      child:
                                                                          Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left: 8,
                                                                        right:
                                                                            8,
                                                                        top: 8,
                                                                        bottom:
                                                                            6),
                                                                    child: Text(
                                                                      _selectedButton ==
                                                                              1
                                                                          ? Constants
                                                                              .reprints_sectionsList1a[index]
                                                                              .id
                                                                          : _selectedButton == 2
                                                                              ? Constants.reprints_sectionsList2a[index].id
                                                                              : _selectedButton == 3 && days_difference <= 31
                                                                                  ? Constants.reprints_sectionsList3a[index].id
                                                                                  : Constants.reprints_sectionsList3b[index].id,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12.5,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
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
                      if (target_index == 1)
                        SizedBox(
                          height: 12,
                        ),
                      if (target_index == 1)
                        _selectedButton == 1
                            ? Padding(
                                padding: EdgeInsets.only(left: 0.0, bottom: 0),
                                child: Center(
                                    child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, right: 16, bottom: 0),
                                        child: Text(
                                            "Approval Rate (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
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
                                              left: 16.0, right: 16, bottom: 0),
                                          child: Text(
                                              "Approval Rate (12 Months View)"),
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
                                                bottom: 0),
                                            child: Text(
                                                "Approval Rate (${Constants.reprints_formattedStartDate} to ${Constants.sales_formattedEndDate})"),
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
                      if (target_index == 1)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 6.0, right: 6, top: 12),
                          child: LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width - 12,
                            animation: false,
                            lineHeight: 20.0,
                            animationDuration: 500,
                            percent: _selectedButton == 1
                                ? Constants.reprints_request_approval_rate1a
                                : _selectedButton == 2
                                    ? Constants.reprints_request_approval_rate2a
                                    : _selectedButton == 3 &&
                                            days_difference <= 31
                                        ? Constants
                                            .reprints_request_approval_rate3a
                                        : Constants
                                            .reprints_request_approval_rate3b,

                            center: Text(
                                "${((_selectedButton == 1 ? Constants.reprints_request_approval_rate1a : _selectedButton == 2 ? Constants.reprints_request_approval_rate2a : _selectedButton == 3 && days_difference <= 31 ? Constants.reprints_request_approval_rate3a : Constants.reprints_request_approval_rate3b) * 100).toStringAsFixed(1)}%"),
                            barRadius: ui.Radius.circular(12),
                            //linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: Colors.green,
                          ),
                        ),
                      if (target_index == 1)
                        _selectedButton == 1
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 16.0, top: 16),
                                child: Text(
                                    "Slip Reprint Requests (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                              )
                            : _selectedButton == 2
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 16),
                                    child: Text(
                                        "Slip Reprint Requests (12 Months View)"),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 16),
                                    child: Text(
                                        "Slip Reprint Requests (${Constants.reprints_formattedStartDate} to ${Constants.reprints_formattedEndDate})"),
                                  ),
                      if (target_index == 1)
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey.withOpacity(0.00)),
                              height: 250,
                              child: isLoading == false
                                  ? _selectedButton == 1
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0,
                                              left: 8,
                                              right: 10,
                                              bottom: 0),
                                          child: CustomCard(
                                            color: Colors.white,
                                            elevation: 6,
                                            surfaceTintColor: Colors.white,
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
                                                    if (reprints_barChartData1_1
                                                        .isEmpty) {
                                                      return Center(
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
                                                      );
                                                    } else {
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
                                                                      15,
                                                                  getTitlesWidget:
                                                                      (value,
                                                                          meta) {
                                                                    double
                                                                        inValue =
                                                                        value
                                                                            .roundToDouble();

                                                                    print(
                                                                        "dsdghds ${inValue}");
                                                                    if (inValue !=
                                                                        value) {
                                                                      return Text(
                                                                          "");
                                                                    } else
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
                                                                reprints_barChartData1_1,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : _selectedButton == 2
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                  left: 8,
                                                  right: 10,
                                                  bottom: 0),
                                              child: CustomCard(
                                                color: Colors.white,
                                                elevation: 6,
                                                surfaceTintColor: Colors.white,
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
                                                        if (reprints_barChartData2_1
                                                            .isEmpty) {
                                                          return Center(
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
                                                          );
                                                        } else {
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
                                                                          15,
                                                                      getTitlesWidget:
                                                                          (value,
                                                                              meta) {
                                                                        double
                                                                            inValue =
                                                                            value.roundToDouble();

                                                                        print(
                                                                            "dsdghds ${inValue}");
                                                                        if (inValue !=
                                                                            value) {
                                                                          return Text(
                                                                              "");
                                                                        } else
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
                                                                    reprints_barChartData2_1,
                                                              ),
                                                            ),
                                                          );
                                                        }
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
                                                          top: 8.0,
                                                          left: 8,
                                                          right: 8),
                                                  child: CustomCard(
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
                                                    child: AspectRatio(
                                                      aspectRatio: 1.66,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 16),
                                                        child: LayoutBuilder(
                                                          builder: (context,
                                                              constraints) {
                                                            if (reprints_barChartData3_1
                                                                .isEmpty) {
                                                              return Center(
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
                                                              );
                                                            } else {
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
                                                                              15,
                                                                          getTitlesWidget:
                                                                              (value, meta) {
                                                                            double
                                                                                inValue =
                                                                                value.roundToDouble();

                                                                            print("dsdghds ${inValue}");
                                                                            if (inValue !=
                                                                                value) {
                                                                              return Text("");
                                                                            } else
                                                                              return Text(
                                                                                formatLargeNumber2(value.toInt().toString()),
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
                                                                        reprints_barChartData3_1,
                                                                  ),
                                                                ),
                                                              );
                                                            }
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
                                                          const EdgeInsets.only(
                                                              top: 8.0,
                                                              left: 8,
                                                              right: 8),
                                                      child: CustomCard(
                                                        elevation: 6,
                                                        surfaceTintColor:
                                                            Colors.white,
                                                        color: Colors.white,
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
                                                                if (reprints_barChartData4_1
                                                                    .isEmpty) {
                                                                  return Center(
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
                                                                  );
                                                                } else {
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
                                                                                    // value.toString(),
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
                                                                              showTitles: false,
                                                                              getTitlesWidget: (value, meta) {
                                                                                return Text(value.toInt().toString());
                                                                              },
                                                                            ),
                                                                          ),
                                                                          leftTitles:
                                                                              AxisTitles(
                                                                            sideTitles:
                                                                                SideTitles(
                                                                              showTitles: true,
                                                                              reservedSize: 15,
                                                                              getTitlesWidget: (value, meta) {
                                                                                double inValue = value.roundToDouble();

                                                                                print("dsdghds ${inValue}");
                                                                                if (inValue != value) {
                                                                                  return Text("");
                                                                                } else
                                                                                  return Text(
                                                                                    formatLargeNumber2(value.toInt().toString()),
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
                                                                            reprints_barChartData4_1,
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container()
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
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
                      if (target_index == 1)
                        SizedBox(
                          height: 12,
                        ),
                      if (target_index == 1)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 8, top: 8),
                          child: SalesOverviewTypeGrid(),
                        ),
                      if (target_index == 1)
                        _selectedButton == 1
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, top: 24, bottom: 6),
                                child: Text(
                                    "Reprints - Top 10 Requesters (MTD- ${getMonthAbbreviation(DateTime.now().month)})"),
                              )
                            : _selectedButton == 2
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 24, bottom: 6),
                                    child: Text(
                                        "Reprints - Top 10 Requesters (12 Months View)"),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 24, bottom: 6),
                                    child: Text(
                                        "Reprints - Top 10 Requesters (${Constants.reprints_formattedStartDate} to ${Constants.reprints_formattedEndDate})"),
                                  ),
                      if (target_index == 1)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12.0, right: 14, bottom: 8, top: 0),
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
                                      borderRadius: BorderRadius.circular(36)),
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
                                                  BorderRadius.circular(360)),
                                          child: Center(
                                            child: Text(
                                              "#",
                                              style: TextStyle(
                                                  color: Colors.black),
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
                                              "Count",
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0, right: 8),
                                  child: isLoading
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
                                      : ((_selectedButton == 1 &&
                                                  Constants.reprints_agents1a
                                                          .length ==
                                                      0) ||
                                              (_selectedButton == 2 &&
                                                  Constants.reprints_agents2a
                                                          .length ==
                                                      0) ||
                                              (_selectedButton == 3 &&
                                                  Constants.reprints_agents3a
                                                          .length ==
                                                      0))
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
                                              padding: EdgeInsets.all(12),
                                              child: ListView.builder(
                                                  padding: EdgeInsets.only(
                                                      top: 0, bottom: 0),
                                                  itemCount: _selectedButton ==
                                                          1
                                                      ? Constants.reprints_agents1a
                                                                  .length >
                                                              10
                                                          ? 10
                                                          : Constants
                                                              .reprints_agents1a
                                                              .length
                                                      : _selectedButton == 2
                                                          ? Constants.reprints_agents2a
                                                                      .length >
                                                                  10
                                                              ? 10
                                                              : Constants
                                                                  .reprints_agents2a
                                                                  .length
                                                          : _selectedButton == 3 &&
                                                                  days_difference <=
                                                                      31
                                                              ? Constants.reprints_agents3a.length >
                                                                      10
                                                                  ? 10
                                                                  : Constants
                                                                      .reprints_agents3a
                                                                      .length
                                                              : Constants.reprints_agents3b.length >
                                                                      10
                                                                  ? 10
                                                                  : Constants
                                                                      .reprints_agents3b
                                                                      .length,
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Container(
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  width: 23,
                                                                  child: Text(
                                                                      "${index + 1} "),
                                                                ),
                                                                Expanded(
                                                                    flex: 10,
                                                                    child: Text(
                                                                        "${_selectedButton == 1 ? Constants.reprints_agents1a[index].agent_name : _selectedButton == 2 ? Constants.reprints_agents2a[index].agent_name : _selectedButton == 3 && days_difference <= 31 ? Constants.reprints_agents3a[index].agent_name : Constants.reprints_agents3b[index].agent_name}")),
                                                                Expanded(
                                                                  flex: 4,
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(
                                                                              left: 8,
                                                                            ),
                                                                            child:
                                                                                Text(
                                                                              "${_selectedButton == 1 ? formatLargeNumber2(Constants.reprints_agents1a[index].sales.toStringAsFixed(0)) : _selectedButton == 2 ? formatLargeNumber2(Constants.reprints_agents2a[index].sales.toStringAsFixed(0)) : _selectedButton == 3 && days_difference <= 31 ? formatLargeNumber2(Constants.reprints_agents3a[index].sales.toStringAsFixed(0)) : formatLargeNumber2(Constants.reprints_agents3b[index].sales.toStringAsFixed(0))}",
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
                                                                      top: 8.0),
                                                              child: Container(
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
                      // if (target_index == 1)
                      //   _selectedButton == 1
                      //       ? Padding(
                      //           padding:
                      //               const EdgeInsets.only(left: 16.0, top: 12),
                      //           child: Text(
                      //               "Reprints - Bottom 10 Sales Agents (MTD- ${getMonthAbbreviation(DateTime.now().month)})"),
                      //         )
                      //       : _selectedButton == 2
                      //           ? Padding(
                      //               padding: const EdgeInsets.only(
                      //                   left: 16.0, top: 12),
                      //               child: Text(
                      //                   "Reprints - Bottom 10 Sales Agents (12 Months View)"),
                      //             )
                      //           : Padding(
                      //               padding: const EdgeInsets.only(
                      //                   left: 16.0, top: 12),
                      //               child: Text(
                      //                   "Reprints - Bottom 10 Sales Agents (${Constants.reprints_formattedStartDate} to ${Constants.reprints_formattedEndDate})"),
                      //             ),
                      /*  if (target_index == 1)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 6,
                            surfaceTintColor: Colors.white,
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
                                    padding: const EdgeInsets.all(6.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(360)),
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
                                  padding: EdgeInsets.only(left: 8.0, right: 8),
                                  child: isLoading
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
                                          padding: EdgeInsets.all(12),
                                          child: ListView.builder(
                                              padding: EdgeInsets.only(
                                                  top: 0, bottom: 0),
                                              itemCount: _selectedButton == 1
                                                  ? Constants.bottomsreprints_agents1a
                                                              .length >
                                                          10
                                                      ? 10
                                                      : Constants
                                                          .bottomsreprints_agents1a
                                                          .length
                                                  : _selectedButton == 2
                                                      ? Constants.bottomsreprints_agents2a
                                                                  .length >
                                                              10
                                                          ? 10
                                                          : Constants
                                                              .bottomsreprints_agents2a
                                                              .length
                                                      : _selectedButton == 3 &&
                                                              days_difference <=
                                                                  31
                                                          ? Constants.bottomsreprints_agents3a
                                                                      .length >
                                                                  10
                                                              ? 10
                                                              : Constants
                                                                  .bottomsreprints_agents3a
                                                                  .length
                                                          : Constants.bottomsreprints_agents3b
                                                                      .length >
                                                                  10
                                                              ? 10
                                                              : Constants
                                                                  .bottomsreprints_agents3b
                                                                  .length,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                                flex: 10,
                                                                child: Text(
                                                                    "${_selectedButton == 1 ? Constants.bottomsreprints_agents1a[index].agent_name : _selectedButton == 2 ? Constants.bottomsreprints_agents2a[index].agent_name : _selectedButton == 3 && days_difference <= 31 ? Constants.bottomsreprints_agents3a[index].agent_name : Constants.bottomsreprints_agents3b[index].agent_name}")),
                                                            Expanded(
                                                              flex: 4,
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(
                                                                          left:
                                                                              8,
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "${_selectedButton == 1 ? formatLargeNumber2(Constants.bottomsreprints_agents1a[index].sales.toStringAsFixed(0)) : _selectedButton == 2 ? formatLargeNumber2(Constants.bottomsreprints_agents2a[index].sales.toStringAsFixed(0)) : _selectedButton == 3 && days_difference <= 31 ? formatLargeNumber2(Constants.bottomsreprints_agents3a[index].sales.toStringAsFixed(0)) : formatLargeNumber2(Constants.bottomsreprints_agents3b[index].sales.toStringAsFixed(0))}",
                                                                          style:
                                                                              TextStyle(fontSize: 13),
                                                                          textAlign:
                                                                              TextAlign.left,
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
                                                                  top: 8.0),
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
                                ),
                              ],
                            )),
                          ),
                        ),*/
                    ]))),
                SizedBox(
                  height: 16,
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
    Constants.pageLevel = 2;
    startInactivityTimer();
    myNotifier = MyNotifier(reprintsValue, context);
    reprintsValue.addListener(() {
      kyrt = UniqueKey();

      if (mounted) setState(() {});
      Future.delayed(Duration(seconds: 2)).then((value) {
        print("ghjfgfgfgg");
        Constants.sales_tree_key3a = UniqueKey();
        if (mounted) setState(() {});

        print("ghjfgfgfgg $_selectedButton");
      });
    });
    super.initState();

    // Load initial data for 1 month view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateButton(1);
    });
  }
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

  // Return the corresponding month abbreviation
  return months[monthNumber - 1];
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

class MemberTypGridItem {
  final String type;
  final Color color;

  MemberTypGridItem(this.type, this.color);
}

class SalesOverviewTypeGrid extends StatelessWidget {
  final List<MemberTypGridItem> spotsTypes = [
    MemberTypGridItem('Approved', Colors.green),
    MemberTypGridItem('Pending', Colors.orange),
    MemberTypGridItem('Expired & Declined', Colors.blue),
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
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        color: item.color,
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  SizedBox(width: 8),
                  Text(item.type, style: TextStyle(fontSize: 12)),
                  SizedBox(width: 16),
                ],
              ),
            )
        ],
      ),
    );
  }
}

class ReprintTypeGrid extends StatelessWidget {
  final List<ReprintTypeGriditem> reprintTypes = [
    ReprintTypeGriditem('Approved', Colors.blue),
    ReprintTypeGriditem('Pending', Colors.orange),
    ReprintTypeGriditem('Expired & Declined', Colors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          childAspectRatio: 2.8,
        ),
        itemCount: reprintTypes.length,
        itemBuilder: (context, index) {
          return Row(
            children: <Widget>[
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(360),
                  //shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
                  color: reprintTypes[index].color,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  reprintTypes[index].type,
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
              ),
              if (index == 1)
                const SizedBox(
                  width: 16,
                ),
            ],
          );
        },
      ),
    );
  }
}

class ReprintTypeGriditem {
  final String type;
  final Color color;
  ReprintTypeGriditem(this.type, this.color);
}
