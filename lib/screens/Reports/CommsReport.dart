import 'dart:async';
import 'dart:ui' as ui;

import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_insights/constants/Constants.dart';
import 'package:mi_insights/customwidgets/CustomCard.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../admin/ClientSearchPage.dart';
import '../../customwidgets/custom_date_range_picker.dart';
import '../../customwidgets/custom_treemap/pages/tree_diagram.dart';
import '../../services/MyNoyifier.dart';
import '../../services/comms_report_service.dart';
import '../../services/inactivitylogoutmixin.dart';
import '../../services/window_manager.dart';

int noOfDaysThisMonth = 30;
bool isLoadingFullfilment = false;
bool isLoadingFullfilment1a = false;
bool isLoadingFullfilment2a = false;
bool isLoadingFullfilment3a = false;

int grid_index = 0;
final commsValue = ValueNotifier<int>(0);
MyNotifier? myNotifier;
DateTime datefrom = DateTime.now().subtract(Duration(days: 60));
DateTime dateto = DateTime.now();
int days_difference = 0;
Widget wdg1 = Container();
int report_index = 0;
int comms_index = 0;
String data2 = "";
int sales_index = 0;
Key kyrt = UniqueKey();
int touchedIndex = -1;
bool isShowingTacticalPoints = false;
double _sliderPosition4 = 0.0;

class CommsReport extends StatefulWidget {
  const CommsReport({Key? key}) : super(key: key);

  @override
  State<CommsReport> createState() => _CommsReportState();
}

List<Map<String, dynamic>> leads = [];
List<List<Map<String, dynamic>>> policies = [];
double _sliderPosition = 0.0;
int _selectedButton = 1;
bool isSameDaysRange = true;
int target_index = 0;
double _sliderPosition2 = 0.0;

class _CommsReportState extends State<CommsReport> with InactivityLogoutMixin {
  Color _button1Color = Colors.grey.withOpacity(0.0);
  Color _button2Color = Colors.grey.withOpacity(0.0);
  Color _button3Color = Colors.grey.withOpacity(0.0);
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

  void _animateButton4(int buttonNumber) {
    restartInactivityTimer();

    setState(() {});

    grid_index = buttonNumber;
    if (buttonNumber == 0) {
      _sliderPosition4 = 0.0;
    } else if (buttonNumber == 1) {
      _sliderPosition4 = (MediaQuery.of(context).size.width / 3) - 18;
    } else if (buttonNumber == 2) {
      _sliderPosition4 = 2 * (MediaQuery.of(context).size.width / 3) - 32;
    }
    setState(() {});
  }

  void _animateButton(int buttonNumber) {
    restartInactivityTimer();

    setState(() {});

    if (kDebugMode) {
      print("jhhh $buttonNumber");
    }

    _selectedButton = buttonNumber;
    if (buttonNumber == 1) {
      _sliderPosition = 0.0;
    } else if (buttonNumber == 2) {
      _sliderPosition = (MediaQuery.of(context).size.width / 3) - 18;
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
        isLoadingFullfilment = true;
      });

      DateTime now = DateTime.now();
      DateTime? startDate;
      DateTime? endDate;

      // Set date ranges based on button selection
      if (buttonNumber == 1) {
        // 1 Month View - current month
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime.now();
        isLoadingFullfilment1a = true;
      } else if (buttonNumber == 2) {
        // 12 Months View - last 12 months
        startDate = DateTime(now.year - 1, now.month, now.day);
        endDate = DateTime.now();
        isLoadingFullfilment2a = true;
      }

      // Format dates and calculate days difference
      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate!);
      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate!);
      days_difference = endDate.difference(startDate).inDays;

      // Update Constants
      Constants.comms_formattedStartDate = formattedStartDate;
      Constants.comms_formattedEndDate = formattedEndDate;

      // Call getCommsReport
      getCommsReport(formattedStartDate, formattedEndDate, buttonNumber,
              days_difference, context)
          .then((value) {
        if (mounted)
          setState(() {
            isLoadingFullfilment = false;
            if (buttonNumber == 1) {
              isLoadingFullfilment1a = false;
            } else if (buttonNumber == 2) {
              isLoadingFullfilment2a = false;
            }
            kyrt = UniqueKey();
          });
      }).catchError((error) {
        if (kDebugMode) {
          print("❌ Error in _animateButton getCommsReport: $error");
        }
        if (mounted)
          setState(() {
            isLoadingFullfilment = false;
            if (buttonNumber == 1) {
              isLoadingFullfilment1a = false;
            } else if (buttonNumber == 2) {
              isLoadingFullfilment2a = false;
            }
          });
      });

      setState(() {});
    } else {
      showCustomDateRangePicker(
        context,
        dismissible: false,
        minimumDate: DateTime.utc(2023, 06, 01),
        maximumDate: DateTime.now(),
        /*    endDate: endDate,
        startDate: startDate,*/
        backgroundColor: Colors.white,
        primaryColor: Constants.ctaColorLight,
        onApplyClick: (start, end) {
          setState(() {});

          days_difference = end!.difference(start).inDays;
          if (end.month == start.month) {
            isSameDaysRange = true;
          } else {
            isSameDaysRange = false;
          }
          Constants.comms_formattedStartDate =
              DateFormat('yyyy-MM-dd').format(start);
          Constants.comms_formattedEndDate =
              DateFormat('yyyy-MM-dd').format(end);
          isLoadingFullfilment = true;
          setState(() {});

          getCommsReport(Constants.comms_formattedStartDate,
                  Constants.comms_formattedEndDate, 3, days_difference, context)
              .then((value) {
            isLoadingFullfilment = false;
            kyrt = UniqueKey();
            setState(() {});
          });
          restartInactivityTimer();
        },
        onCancelClick: () {
          if (kDebugMode) {
            print("user cancelled.");
          }
          setState(() {
            _animateButton(1);
          });
          restartInactivityTimer();
        },
      );
    }
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
                      restartInactivityTimer();
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
                  "Fulfillment Report",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollStartNotification ||
                        scrollNotification is ScrollUpdateNotification) {
                      Constants.inactivityTimer =
                          Timer(const Duration(minutes: 3), () => {});
                    }
                    return true; // Return true to indicate the notification is handled
                  },
                  child: Column(children: [
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
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16.0, right: 16, top: 12),
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
                                        _animateButton(
                                          1,
                                        );
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
                                        _animateButton(
                                          2,
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
                                        _animateButton(
                                          3,
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
                                  _animateButton(
                                    3,
                                  );
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Constants
                                        .ctaColorLight, // Color of the slider
                                    borderRadius: BorderRadius.circular(12),
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
                    Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                            if (isLoadingFullfilment)
                              SizedBox(
                                height: 12,
                              ),
                            /*Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12.0, right: 4, top: 12),
                                      child: GestureDetector(
                                        onTap: () {
                                          comms_index = 0;
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: 38,
                                          decoration: BoxDecoration(
                                              color: (comms_index == 0)
                                                  ? Constants.ctaColorLight
                                                  : Colors.transparent,
                                              border: Border.all(
                                                color: (comms_index == 0)
                                                    ? Constants.ctaColorLight
                                                        .withOpacity(0.35)
                                                    : Colors.grey,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Center(
                                              child: Text(
                                            "All Messages",
                                            style: TextStyle(
                                                color: (comms_index == 0)
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
                                          left: 4.0, right: 4, top: 12),
                                      child: GestureDetector(
                                        onTap: () {
                                          comms_index = 1;
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: 38,
                                          decoration: BoxDecoration(
                                              color: (comms_index == 1)
                                                  ? Constants.ctaColorLight
                                                  : Colors.transparent,
                                              border: Border.all(
                                                color: (comms_index == 1)
                                                    ? Constants.ctaColorLight
                                                        .withOpacity(0.35)
                                                    : Colors.grey,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Center(
                                              child: Text(
                                            "Bus. as Usual",
                                            style: TextStyle(
                                                color: (comms_index == 1)
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
                                          comms_index = 2;
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: 38,
                                          decoration: BoxDecoration(
                                              color: (comms_index == 2)
                                                  ? Constants.ctaColorLight
                                                  : Colors.transparent,
                                              border: Border.all(
                                                color: (comms_index == 2)
                                                    ? Constants.ctaColorLight
                                                        .withOpacity(0.35)
                                                    : Colors.grey,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Center(
                                              child: Text(
                                            "FSCA Remedial",
                                            style: TextStyle(
                                                color: (comms_index == 2)
                                                    ? Colors.white
                                                    : Colors.grey),
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                          )),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),*/
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, top: 12, right: 2, bottom: 8),
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
                                    ? Constants.comms_sectionsList1a.length
                                    : _selectedButton == 2
                                        ? Constants.comms_sectionsList2a.length
                                        : _selectedButton == 3 &&
                                                days_difference <= 31
                                            ? Constants
                                                .comms_sectionsList3a.length
                                            : Constants
                                                .comms_sectionsList3a.length,
                                padding: EdgeInsets.all(2.0),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    height: 290,
                                    width:
                                        MediaQuery.of(context).size.width / 2.9,
                                    child: Stack(
                                      children: [
                                        Padding(
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
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16))),
                                              child: InkWell(
                                                customBorder:
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                onTap: () {
                                                  //sales_index = index;
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
                                                                  ? Colors.grey
                                                                      .withOpacity(
                                                                          0.45)
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
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 8,
                                                                  ),
                                                                  Expanded(
                                                                    child: Center(
                                                                        child: Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child: (_selectedButton == 1 && isLoadingFullfilment1a == true ||
                                                                              _selectedButton == 2 && isLoadingFullfilment2a == true ||
                                                                              _selectedButton == 3 && isLoadingFullfilment3a == true)
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
                                                                          : Text(
                                                                              formatLargeNumber((_selectedButton == 1
                                                                                      ? Constants.comms_sectionsList1a[index].amount
                                                                                      : _selectedButton == 2
                                                                                          ? Constants.comms_sectionsList2a[index].amount
                                                                                          : _selectedButton == 3 && days_difference <= 31
                                                                                              ? Constants.comms_sectionsList3a[index].amount
                                                                                              : Constants.comms_sectionsList3a[index].amount)
                                                                                  .toString()),
                                                                              style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
                                                                              textAlign: TextAlign.center,
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
                                                                      _selectedButton ==
                                                                              1
                                                                          ? Constants
                                                                              .comms_sectionsList1a[index]
                                                                              .id
                                                                          : _selectedButton == 2
                                                                              ? Constants.comms_sectionsList2a[index].id
                                                                              : _selectedButton == 3 && days_difference <= 31
                                                                                  ? Constants.comms_sectionsList3a[index].id
                                                                                  : Constants.comms_sectionsList3a[index].id,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12.5),
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
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 12),
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
                                                "Messages Delivered Successfully (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
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
                                                  "Messages Delivered Successfully (12 Months View)"),
                                            ),
                                          )
                                        ],
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0.0, bottom: 8),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0,
                                                    right: 16,
                                                    bottom: 8),
                                                child: Text(
                                                    "Messages Delivered Successfully (${Constants.comms_formattedStartDate} to ${Constants.comms_formattedEndDate})"),
                                              ),
                                            )
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
                                percent: _selectedButton == 1
                                    ? Constants.percentage_delivered1a
                                    : _selectedButton == 2
                                        ? Constants.percentage_delivered2a
                                        : _selectedButton == 3 &&
                                                days_difference <= 31
                                            ? Constants.percentage_delivered3a
                                            : Constants.percentage_delivered3a,
                                center: Text(
                                    "${((_selectedButton == 1 ? Constants.percentage_delivered1a : _selectedButton == 2 ? Constants.percentage_delivered2a : _selectedButton == 3 && days_difference <= 31 ? Constants.percentage_delivered3a : Constants.percentage_delivered3a) * 100).toStringAsFixed(1)}%"),
                                barRadius: ui.Radius.circular(12),
                                //linearStrokeCap: LinearStrokeCap.roundAll,
                                progressColor: Colors.green,
                              ),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            _selectedButton == 1
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(
                                        "Control Indicator (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                  )
                                : _selectedButton == 2
                                    ? Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0),
                                            child: Text(
                                                "Control Indicator (12 Months Rolling)"),
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
                                            "Control Indicator (${Constants.comms_formattedStartDate} to ${Constants.comms_formattedEndDate})"),
                                      ),
                            SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: CustomCard(
                                surfaceTintColor: Colors.white,
                                color: Colors.white,
                                elevation: 6,
                                child: Container(
                                  height: 280,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child:
                                        (_selectedButton == 1 &&
                                                    isLoadingFullfilment1a ==
                                                        true ||
                                                _selectedButton == 2 &&
                                                    isLoadingFullfilment2a ==
                                                        true ||
                                                _selectedButton == 3 &&
                                                    isLoadingFullfilment3a ==
                                                        true)
                                            ? Container(
                                                height: 250,
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
                                            : ((_selectedButton == 1 &&
                                                        Constants.comms_pieData1a
                                                            .isEmpty) ||
                                                    (_selectedButton == 2 &&
                                                        Constants
                                                            .comms_pieData2a
                                                            .isEmpty) ||
                                                    (_selectedButton == 3 &&
                                                        Constants
                                                            .comms_pieData3a
                                                            .isEmpty))
                                                ? Container(
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
                                                    ))
                                                : PieChart(
                                                    PieChartData(
                                                      pieTouchData:
                                                          PieTouchData(
                                                        touchCallback:
                                                            (FlTouchEvent event,
                                                                pieTouchResponse) {
                                                          setState(() {
                                                            if (!event
                                                                    .isInterestedForInteractions ||
                                                                pieTouchResponse ==
                                                                    null ||
                                                                pieTouchResponse
                                                                        .touchedSection ==
                                                                    null) {
                                                              touchedIndex = -1;
                                                              return;
                                                            }
                                                            touchedIndex =
                                                                pieTouchResponse
                                                                    .touchedSection!
                                                                    .touchedSectionIndex;
                                                          });
                                                        },
                                                      ),
                                                      borderData: FlBorderData(
                                                        show: true,
                                                        border: Border(
                                                          left: BorderSide.none,
                                                          bottom: BorderSide(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.35),
                                                            width: 1,
                                                          ),
                                                          right:
                                                              BorderSide.none,
                                                          top: BorderSide.none,
                                                        ),
                                                      ),
                                                      sectionsSpace: 0,
                                                      centerSpaceRadius: 70,
                                                      startDegreeOffset: 0,
                                                      sections: _selectedButton ==
                                                              1
                                                          ? Constants
                                                              .comms_pieData1a
                                                          : _selectedButton == 2
                                                              ? Constants
                                                                  .comms_pieData2a
                                                              : _selectedButton ==
                                                                          3 &&
                                                                      days_difference <=
                                                                          31
                                                                  ? Constants
                                                                      .comms_pieData3a
                                                                  : Constants
                                                                      .comms_pieData3a,
                                                    ),
                                                  ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 16),
                              child: CollectionTypeGrid(),
                            ),
                            SizedBox(
                              height: 16,
                            ),
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
                                                bottom: 0),
                                            child: Text(
                                                "Customer TouchPoint (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
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
                                                padding: const EdgeInsets.only(
                                                    left: 16.0,
                                                    right: 16,
                                                    bottom: 0),
                                                child: Text(
                                                    "Customer TouchPoint (12 Months View)"),
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
                                                    bottom: 0),
                                                child: Text(
                                                    "Customer TouchPoint (${Constants.comms_formattedStartDate} to ${Constants.comms_formattedEndDate})"),
                                              ),
                                            )
                                          ],
                                        )),
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
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Center(
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                _animateButton4(0);
                                              },
                                              child: Container(
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        3) -
                                                    12,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            360)),
                                                height: 35,
                                                child: Center(
                                                  child: Text(
                                                    'By Channel',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _animateButton4(1);
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
                                                        BorderRadius.circular(
                                                            360)),
                                                child: Center(
                                                  child: Text(
                                                    'By Status',
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
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        3) -
                                                    12,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            360)),
                                                child: Center(
                                                  child: Text(
                                                    'By Type',
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
                                      left: _sliderPosition4,
                                      child: InkWell(
                                        onTap: () {
                                          _animateButton4(2);
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
                                                BorderRadius.circular(12),
                                          ),
                                          child: grid_index == 0
                                              ? Center(
                                                  child: Text(
                                                    'By Channel',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              : grid_index == 1
                                                  ? Center(
                                                      child: Text(
                                                        'By Status',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )
                                                  : Center(
                                                      child: Text(
                                                        'By Type',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (grid_index == 1)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16, top: 12, bottom: 16),
                                child: CustomCard(
                                    elevation: 6,
                                    color: Colors.white,
                                    surfaceTintColor: Colors.white,
                                    child: Column(children: [
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, right: 8, bottom: 4),
                                          child: Row(
                                            children: [
                                              Spacer(),
                                              Text(
                                                "TOTAL",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                  width: 140,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey
                                                          .withOpacity(0.35),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4.0,
                                                            bottom: 4,
                                                            right: 12),
                                                    child: Container(
                                                      child: Text(
                                                        formatLargeNumber((_selectedButton ==
                                                                    1
                                                                ? Constants
                                                                    .comms_sectionsList1a[
                                                                        0]
                                                                    .amount
                                                                : _selectedButton ==
                                                                        2
                                                                    ? Constants
                                                                        .comms_sectionsList2a[
                                                                            0]
                                                                        .amount
                                                                    : _selectedButton ==
                                                                                3 &&
                                                                            days_difference <=
                                                                                31
                                                                        ? Constants
                                                                            .comms_sectionsList3a[
                                                                                0]
                                                                            .amount
                                                                        : Constants
                                                                            .comms_sectionsList3a[0]
                                                                            .amount)
                                                            .toString()),
                                                        style: TextStyle(
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
                                            const EdgeInsets.only(left: 8.0),
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
                                                              1.9)),
                                          itemCount: 6,
                                          padding: EdgeInsets.all(2.0),
                                          itemBuilder: (BuildContext context,
                                              int index) {
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
                                                          setState(() {});
                                                          if (kDebugMode) {
                                                            print("comms_index " +
                                                                index
                                                                    .toString());
                                                          }
                                                          if (index == 1) {
                                                            /*     Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => CommsReport()));*/
                                                          }
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
                                                            color: Colors.white,
                                                            elevation: 6,
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
                                                                            color: comms_index == index
                                                                                ? Colors.grey.withOpacity(0.05)
                                                                                : Colors.grey.withOpacity(0.05),
                                                                            border: Border.all(color: Colors.grey.withOpacity(0.0)),
                                                                            borderRadius: BorderRadius.circular(8)),
                                                                        child: Container(
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(14),
                                                                            ),
                                                                            width: MediaQuery.of(context).size.width,
                                                                            height: 300,
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
                                                                                        formatLargeNumber((_selectedButton == 1 && comms_index == 0 && Constants.comms_sectionsList1a_a.isNotEmpty)
                                                                                                ? Constants.comms_sectionsList1a_a[index].amount.toStringAsFixed(1)
                                                                                                : (_selectedButton == 1 && comms_index == 1 && Constants.comms_sectionsList1a_b.isNotEmpty)
                                                                                                    ? Constants.comms_sectionsList1a_b[index].amount.toStringAsFixed(1)
                                                                                                    : (_selectedButton == 1 && comms_index == 2 && Constants.comms_sectionsList1a_c.isNotEmpty)
                                                                                                        ? Constants.comms_sectionsList1a_c[index].amount.toStringAsFixed(1)
                                                                                                        : (_selectedButton == 2 && comms_index == 0 && Constants.comms_sectionsList2a_a.isNotEmpty)
                                                                                                            ? Constants.comms_sectionsList2a_a[index].amount.toStringAsFixed(1)
                                                                                                            : (_selectedButton == 2 && comms_index == 1 && Constants.comms_sectionsList2a_b.isNotEmpty)
                                                                                                                ? Constants.comms_sectionsList2a_b[index].amount.toStringAsFixed(1)
                                                                                                                : (_selectedButton == 2 && comms_index == 2 && Constants.comms_sectionsList2a_c.isNotEmpty)
                                                                                                                    ? Constants.comms_sectionsList2a_c[index].amount.toStringAsFixed(1)
                                                                                                                    : (_selectedButton == 3 && comms_index == 0 && Constants.comms_sectionsList3a_a.isNotEmpty)
                                                                                                                        ? Constants.comms_sectionsList3a_a[index].amount.toStringAsFixed(1)
                                                                                                                        : (_selectedButton == 3 && days_difference <= 31 && comms_index == 1 && Constants.comms_sectionsList3a_b.isNotEmpty)
                                                                                                                            ? Constants.comms_sectionsList3a_b[index].amount.toStringAsFixed(1)
                                                                                                                            : (_selectedButton == 3 && days_difference <= 31 && comms_index == 2 && Constants.comms_sectionsList3a_c.isNotEmpty)
                                                                                                                                ? Constants.comms_sectionsList3a_c[index].amount.toStringAsFixed(1)
                                                                                                                                : "0")
                                                                                            .toString(),
                                                                                        style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
                                                                                        textAlign: TextAlign.center,
                                                                                        maxLines: 2,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                                                                                    child: Text(
                                                                                      (_selectedButton == 1 && comms_index == 0 && Constants.comms_sectionsList1a_a.isNotEmpty)
                                                                                          ? Constants.comms_sectionsList1a_a[index].percentage.toStringAsFixed(1) + "%"
                                                                                          : (_selectedButton == 1 && comms_index == 1 && Constants.comms_sectionsList1a_b.isNotEmpty)
                                                                                              ? Constants.comms_sectionsList1a_b[index].percentage.toStringAsFixed(1) + "%"
                                                                                              : (_selectedButton == 1 && comms_index == 2 && Constants.comms_sectionsList1a_c.isNotEmpty)
                                                                                                  ? Constants.comms_sectionsList1a_c[index].percentage.toStringAsFixed(1) + "%"
                                                                                                  : (_selectedButton == 2 && comms_index == 0 && Constants.comms_sectionsList2a_a.isNotEmpty)
                                                                                                      ? Constants.comms_sectionsList2a_a[index].percentage.toStringAsFixed(1) + "%"
                                                                                                      : (_selectedButton == 2 && comms_index == 1 && Constants.comms_sectionsList2a_b.isNotEmpty)
                                                                                                          ? Constants.comms_sectionsList2a_b[index].percentage.toStringAsFixed(1) + "%"
                                                                                                          : (_selectedButton == 2 && comms_index == 2 && Constants.comms_sectionsList2a_c.isNotEmpty)
                                                                                                              ? Constants.comms_sectionsList2a_c[index].percentage.toStringAsFixed(1) + "%"
                                                                                                              : (_selectedButton == 3 && comms_index == 0 && Constants.comms_sectionsList3a_a.isNotEmpty)
                                                                                                                  ? Constants.comms_sectionsList3a_a[index].percentage.toStringAsFixed(1) + "%"
                                                                                                                  : (_selectedButton == 3 && comms_index == 1 && Constants.comms_sectionsList3a_b.isNotEmpty)
                                                                                                                      ? Constants.comms_sectionsList3a_b[index].percentage.toStringAsFixed(1) + "%"
                                                                                                                      : (_selectedButton == 3 && days_difference <= 31 && comms_index == 2 && Constants.comms_sectionsList3a_c.isNotEmpty)
                                                                                                                          ? Constants.comms_sectionsList3a_c[index].percentage.toStringAsFixed(1) + "%"
                                                                                                                          : "0%", // Fallback value
                                                                                      style: TextStyle(fontSize: 12.5),
                                                                                      textAlign: TextAlign.center,
                                                                                      maxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Text(
                                                                                      (_selectedButton == 1 && comms_index == 0 && Constants.comms_sectionsList1a_a.isNotEmpty)
                                                                                          ? Constants.comms_sectionsList1a_a[index].id
                                                                                          : (_selectedButton == 1 && comms_index == 1 && Constants.comms_sectionsList1a_b.isNotEmpty)
                                                                                              ? Constants.comms_sectionsList1a_b[index].id
                                                                                              : (_selectedButton == 1 && comms_index == 2 && Constants.comms_sectionsList1a_c.isNotEmpty)
                                                                                                  ? Constants.comms_sectionsList1a_c[index].id
                                                                                                  : (_selectedButton == 2 && comms_index == 0 && Constants.comms_sectionsList2a_a.isNotEmpty)
                                                                                                      ? Constants.comms_sectionsList2a_a[index].id
                                                                                                      : (_selectedButton == 2 && comms_index == 1 && Constants.comms_sectionsList2a_b.isNotEmpty)
                                                                                                          ? Constants.comms_sectionsList2a_b[index].id
                                                                                                          : (_selectedButton == 2 && comms_index == 2 && Constants.comms_sectionsList2a_c.isNotEmpty)
                                                                                                              ? Constants.comms_sectionsList2a_c[index].id
                                                                                                              : (_selectedButton == 3 && comms_index == 0 && Constants.comms_sectionsList3a_a.isNotEmpty)
                                                                                                                  ? Constants.comms_sectionsList3a_a[index].id
                                                                                                                  : (_selectedButton == 3 && comms_index == 1 && Constants.comms_sectionsList3a_b.isNotEmpty)
                                                                                                                      ? Constants.comms_sectionsList3a_b[index].id
                                                                                                                      : (_selectedButton == 3 && days_difference <= 31 && comms_index == 2 && Constants.comms_sectionsList3a_c.isNotEmpty)
                                                                                                                          ? Constants.comms_sectionsList3a_c[index].id
                                                                                                                          : "N/A", // Fallback value
                                                                                      style: TextStyle(fontSize: 12.5),
                                                                                      textAlign: TextAlign.center,
                                                                                      maxLines: 1,
                                                                                    ),
                                                                                  ),
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
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ));
                                          },
                                        ),
                                      ),
                                    ])),
                              ),
                            if (grid_index == 0)
                              comms_index == 0
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0,
                                          right: 16,
                                          top: 12,
                                          bottom: 16),
                                      child: CustomCard(
                                        elevation: 6,
                                        color: Colors.white,
                                        surfaceTintColor: Colors.white,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0,
                                                          right: 8,
                                                          bottom: 4),
                                                  child: Row(
                                                    children: [
                                                      Spacer(),
                                                      Text(
                                                        "TOTAL",
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
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.35),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 4.0,
                                                                    bottom: 4,
                                                                    right: 12),
                                                            child: Container(
                                                              child: ((_selectedButton == 1 && Constants.comms_sectionsList1a.isEmpty) ||
                                                                      (_selectedButton ==
                                                                              2 &&
                                                                          Constants
                                                                              .comms_sectionsList2a
                                                                              .isEmpty) ||
                                                                      (_selectedButton ==
                                                                              3 &&
                                                                          Constants
                                                                              .comms_sectionsList3a
                                                                              .isEmpty))
                                                                  ? Text("")
                                                                  : Text(
                                                                      formatLargeNumber((_selectedButton == 1
                                                                              ? Constants.comms_sectionsList1a[0].amount
                                                                              : _selectedButton == 2
                                                                                  ? Constants.comms_sectionsList2a[0].amount
                                                                                  : _selectedButton == 3 && days_difference <= 31
                                                                                      ? Constants.comms_sectionsList3a[0].amount
                                                                                      : Constants.comms_sectionsList3a[0].amount)
                                                                          .toString()),
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                    ),
                                                            ),
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: GridView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 3,
                                                          childAspectRatio: MediaQuery
                                                                      .of(
                                                                          context)
                                                                  .size
                                                                  .width /
                                                              (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  1.9)),
                                                  itemCount: _selectedButton ==
                                                          1
                                                      ? Constants
                                                          .comms_sectionsList_1_1a
                                                          .length
                                                      : _selectedButton == 2
                                                          ? Constants
                                                              .comms_sectionsList_2_1a
                                                              .length
                                                          : _selectedButton ==
                                                                      3 &&
                                                                  days_difference <=
                                                                      31
                                                              ? Constants
                                                                  .comms_sectionsList_3_1a
                                                                  .length
                                                              : Constants
                                                                  .comms_sectionsList_3_1a
                                                                  .length,
                                                  padding: EdgeInsets.all(2.0),
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return InkWell(
                                                        onTap: () {
                                                          restartInactivityTimer();
                                                        },
                                                        child: Container(
                                                          height: 320,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1.9,
                                                          child: Stack(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  restartInactivityTimer();
                                                                  setState(
                                                                      () {});
                                                                  if (kDebugMode) {
                                                                    print("comms_index " +
                                                                        index
                                                                            .toString());
                                                                  }
                                                                  if (index ==
                                                                      1) {
                                                                    /*     Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => CommsReport()));*/
                                                                  }
                                                                },
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              4.0,
                                                                          right:
                                                                              8),
                                                                  child: Card(
                                                                    surfaceTintColor:
                                                                        Colors
                                                                            .white,
                                                                    color: Colors
                                                                        .white,
                                                                    elevation:
                                                                        6,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color: Colors
                                                                              .white70,
                                                                          width:
                                                                              0),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16),
                                                                    ),
                                                                    child:
                                                                        ClipPath(
                                                                      clipper: ShapeBorderClipper(
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(border: Border(bottom: BorderSide(color: Constants.ftaColorLight, width: 6))),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Container(
                                                                                decoration: BoxDecoration(color: comms_index == index ? Colors.grey.withOpacity(0.05) : Colors.grey.withOpacity(0.05), border: Border.all(color: Colors.grey.withOpacity(0.0)), borderRadius: BorderRadius.circular(8)),
                                                                                child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(14),
                                                                                    ),
                                                                                    width: MediaQuery.of(context).size.width,
                                                                                    height: 300,
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
                                                                                              formatLargeNumber((_selectedButton == 1
                                                                                                      ? Constants.comms_sectionsList_1_1a[index].amount
                                                                                                      : _selectedButton == 2
                                                                                                          ? Constants.comms_sectionsList_2_1a[index].amount
                                                                                                          : _selectedButton == 3 && days_difference <= 31
                                                                                                              ? Constants.comms_sectionsList_3_1a[index].amount
                                                                                                              : Constants.comms_sectionsList_3_1a[index].amount)
                                                                                                  .toString()),
                                                                                              style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
                                                                                              textAlign: TextAlign.center,
                                                                                              maxLines: 2,
                                                                                            ),
                                                                                          )),
                                                                                        ),
                                                                                        Center(
                                                                                            child: Padding(
                                                                                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                                                                                          child: Text(
                                                                                            (_selectedButton == 1
                                                                                                    ? Constants.comms_sectionsList_1_1a[index].percentage.toStringAsFixed(1)
                                                                                                    : _selectedButton == 2
                                                                                                        ? Constants.comms_sectionsList_2_1a[index].percentage.toStringAsFixed(1)
                                                                                                        : _selectedButton == 3 && days_difference <= 31
                                                                                                            ? Constants.comms_sectionsList_3_1a[index].percentage.toStringAsFixed(1)
                                                                                                            : Constants.comms_sectionsList_3_1a[index].percentage.toStringAsFixed(1)) +
                                                                                                "%",
                                                                                            style: TextStyle(fontSize: 12.5),
                                                                                            textAlign: TextAlign.center,
                                                                                            maxLines: 1,
                                                                                          ),
                                                                                        )),
                                                                                        Center(
                                                                                            child: Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Text(
                                                                                            _selectedButton == 1
                                                                                                ? Constants.comms_sectionsList_1_1a[index].id
                                                                                                : _selectedButton == 2
                                                                                                    ? Constants.comms_sectionsList_2_1a[index].id
                                                                                                    : _selectedButton == 3 && days_difference <= 31
                                                                                                        ? Constants.comms_sectionsList_3_1a[index].id
                                                                                                        : Constants.comms_sectionsList_3_1a[index].id,
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
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : comms_index == 1
                                      ? Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Container(
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
                                                                  1.9)),
                                              itemCount: _selectedButton == 1
                                                  ? Constants
                                                      .comms_sectionsList_2_1a
                                                      .length
                                                  : _selectedButton == 2
                                                      ? Constants
                                                          .comms_sectionsList_1_2a
                                                          .length
                                                      : _selectedButton == 3 &&
                                                              days_difference <=
                                                                  31
                                                          ? Constants
                                                              .comms_sectionsList_1_3a
                                                              .length
                                                          : Constants
                                                              .comms_sectionsList_1_3a
                                                              .length,
                                              padding: EdgeInsets.all(2.0),
                                              itemBuilder:
                                                  (BuildContext context,
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
                                                              //  comms_index = index;
                                                              restartInactivityTimer();
                                                              setState(() {});
                                                              if (kDebugMode) {
                                                                print("comms_index " +
                                                                    index
                                                                        .toString());
                                                              }
                                                              if (index == 1) {
                                                                /*     Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => CommsReport()));*/
                                                              }
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          4.0,
                                                                      right: 8),
                                                              child: Card(
                                                                surfaceTintColor:
                                                                    Colors
                                                                        .white,
                                                                color: Colors
                                                                    .white,
                                                                elevation: 6,
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
                                                                                color: comms_index == index ? Colors.grey.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
                                                                                border: Border.all(color: Colors.grey.withOpacity(0.0)),
                                                                                borderRadius: BorderRadius.circular(8)),
                                                                            child: Container(
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(14),
                                                                                ),
                                                                                width: MediaQuery.of(context).size.width,
                                                                                height: 300,
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
                                                                                          formatLargeNumber((_selectedButton == 1
                                                                                                  ? Constants.comms_sectionsList_2_1a[index].amount
                                                                                                  : _selectedButton == 2
                                                                                                      ? Constants.comms_sectionsList_1_2a[index].amount
                                                                                                      : _selectedButton == 3 && days_difference <= 31
                                                                                                          ? Constants.comms_sectionsList_1_3a[index].amount
                                                                                                          : Constants.comms_sectionsList_1_3a[index].amount)
                                                                                              .toString()),
                                                                                          style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
                                                                                          textAlign: TextAlign.center,
                                                                                          maxLines: 2,
                                                                                        ),
                                                                                      )),
                                                                                    ),
                                                                                    Center(
                                                                                        child: Padding(
                                                                                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                                                                                      child: Text(
                                                                                        (_selectedButton == 1
                                                                                                ? Constants.comms_sectionsList_2_1a[index].percentage.toStringAsFixed(1)
                                                                                                : _selectedButton == 2
                                                                                                    ? Constants.comms_sectionsList_1_2a[index].percentage.toStringAsFixed(1)
                                                                                                    : _selectedButton == 3 && days_difference <= 31
                                                                                                        ? Constants.comms_sectionsList_1_3a[index].percentage.toStringAsFixed(1)
                                                                                                        : Constants.comms_sectionsList_1_3a[index].percentage.toStringAsFixed(1)) +
                                                                                            "%",
                                                                                        style: TextStyle(fontSize: 12.5),
                                                                                        textAlign: TextAlign.center,
                                                                                        maxLines: 1,
                                                                                      ),
                                                                                    )),
                                                                                    Center(
                                                                                        child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Text(
                                                                                        _selectedButton == 1
                                                                                            ? Constants.comms_sectionsList_2_1a[index].id
                                                                                            : _selectedButton == 2
                                                                                                ? Constants.comms_sectionsList_1_2a[index].id
                                                                                                : _selectedButton == 3 && days_difference <= 31
                                                                                                    ? Constants.comms_sectionsList_1_3a[index].id
                                                                                                    : Constants.comms_sectionsList_1_3a[index].id,
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
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(16.0),
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
                                                                1.9)),
                                            itemCount: _selectedButton == 1
                                                ? Constants
                                                    .comms_sectionsList_3_1a
                                                    .length
                                                : _selectedButton == 2
                                                    ? Constants
                                                        .comms_sectionsList_1_2a
                                                        .length
                                                    : _selectedButton == 3 &&
                                                            days_difference <=
                                                                31
                                                        ? Constants
                                                            .comms_sectionsList_1_3a
                                                            .length
                                                        : Constants
                                                            .comms_sectionsList_1_3a
                                                            .length,
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
                                                            //  comms_index = index;
                                                            restartInactivityTimer();
                                                            setState(() {});
                                                            if (kDebugMode) {
                                                              print("comms_index " +
                                                                  index
                                                                      .toString());
                                                            }
                                                            if (index == 1) {
                                                              /*     Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => CommsReport()));*/
                                                            }
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
                                                              color:
                                                                  Colors.white,
                                                              elevation: 6,
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
                                                                              color: Constants.ftaColorLight,
                                                                              width: 6))),
                                                                  child: Column(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          decoration: BoxDecoration(
                                                                              color: comms_index == index ? Colors.grey.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
                                                                              border: Border.all(color: Colors.grey.withOpacity(0.0)),
                                                                              borderRadius: BorderRadius.circular(8)),
                                                                          child: Container(
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(14),
                                                                              ),
                                                                              width: MediaQuery.of(context).size.width,
                                                                              height: 300,
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
                                                                                        formatLargeNumber((_selectedButton == 1
                                                                                                ? Constants.comms_sectionsList_3_1a[index].amount
                                                                                                : _selectedButton == 2
                                                                                                    ? Constants.comms_sectionsList_1_2a[index].amount
                                                                                                    : _selectedButton == 3 && days_difference <= 31
                                                                                                        ? Constants.comms_sectionsList_1_3a[index].amount
                                                                                                        : Constants.comms_sectionsList_1_3a[index].amount)
                                                                                            .toString()),
                                                                                        style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
                                                                                        textAlign: TextAlign.center,
                                                                                        maxLines: 2,
                                                                                      ),
                                                                                    )),
                                                                                  ),
                                                                                  Center(
                                                                                      child: Padding(
                                                                                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                                                                                    child: Text(
                                                                                      (_selectedButton == 1
                                                                                              ? Constants.comms_sectionsList_3_1a[index].percentage.toStringAsFixed(1)
                                                                                              : _selectedButton == 2
                                                                                                  ? Constants.comms_sectionsList_1_2a[index].percentage.toStringAsFixed(1)
                                                                                                  : _selectedButton == 3 && days_difference <= 31
                                                                                                      ? Constants.comms_sectionsList_1_3a[index].percentage.toStringAsFixed(1)
                                                                                                      : Constants.comms_sectionsList_1_3a[index].percentage.toStringAsFixed(1)) +
                                                                                          "%",
                                                                                      style: TextStyle(fontSize: 12.5),
                                                                                      textAlign: TextAlign.center,
                                                                                      maxLines: 1,
                                                                                    ),
                                                                                  )),
                                                                                  Center(
                                                                                      child: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Text(
                                                                                      _selectedButton == 1
                                                                                          ? Constants.comms_sectionsList_3_1a[index].id
                                                                                          : _selectedButton == 2
                                                                                              ? Constants.comms_sectionsList_1_2a[index].id
                                                                                              : _selectedButton == 3 && days_difference <= 31
                                                                                                  ? Constants.comms_sectionsList_1_3a[index].id
                                                                                                  : Constants.comms_sectionsList_1_3a[index].id,
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
                            if (grid_index == 0) SizedBox(height: 16),
                            if (grid_index == 0)
                              SizedBox(
                                height: 16,
                              ),
                            if (grid_index == 2)
                              _selectedButton == 1
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          left: 16.0, right: 16, top: 12),
                                      child: Container(
                                        height: 600,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: CustomCard(
                                          surfaceTintColor: Colors.white,
                                          color: Colors.white,
                                          elevation: 6,
                                          child: Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: CustomTreemap(
                                                  treeMapdata: Constants
                                                              .comms_jsonResponse1a[
                                                          "reorganized_by_module"] ??
                                                      {}),
                                            ),
                                          ),
                                        ),
                                      ))
                                  : _selectedButton == 2
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              left: 16.0, right: 16, top: 16),
                                          child: FadeOut(
                                            child: Container(
                                              height: 600,
                                              child: CustomCard(
                                                surfaceTintColor: Colors.white,
                                                color: Colors.white,
                                                elevation: 6,
                                                child:
                                                    Builder(builder: (context) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: CustomTreemap(
                                                        treeMapdata: Constants
                                                                .comms_jsonResponse2a[
                                                            "reorganized_by_module"]),
                                                  );
                                                }),
                                              ),
                                            ),
                                          ))
                                      : (_selectedButton == 3)
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  left: 16.0,
                                                  right: 16,
                                                  top: 12),
                                              child: FadeOut(
                                                child: Container(
                                                  key: Constants
                                                      .comms_tree_key3a,
                                                  height: 600,
                                                  child: Constants.comms_jsonResponse3a[
                                                              "reorganized_by_module"] ==
                                                          null
                                                      ? Container()
                                                      : CustomCard(
                                                          surfaceTintColor:
                                                              Colors.white,
                                                          color: Colors.white,
                                                          elevation: 6,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: CustomTreemap(
                                                                treeMapdata: Constants
                                                                        .comms_jsonResponse3a[
                                                                    "reorganized_by_module"]
                                                                //  treeMapdata: jsonResponse1["reorganized_by_module"],
                                                                ),
                                                          ),
                                                        ),
                                                ),
                                              ))
                                          : Padding(
                                              padding: EdgeInsets.only(
                                                  left: 16.0, right: 16),
                                              child: FadeOut(
                                                child: Container(
                                                  key: Constants
                                                      .comms_tree_key4a,
                                                  height: 600,
                                                  child: Constants.comms_jsonResponse3a[
                                                              "reorganized_by_module"] ==
                                                          null
                                                      ? Container()
                                                      : CustomCard(
                                                          surfaceTintColor:
                                                              Colors.white,
                                                          color: Colors.white,
                                                          elevation: 6,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: CustomTreemap(
                                                                treeMapdata: Constants
                                                                        .comms_jsonResponse3a[
                                                                    "reorganized_by_module"]
                                                                //  treeMapdata: jsonResponse1["reorganized_by_module"],
                                                                ),
                                                          ),
                                                        ),
                                                ),
                                              )),
                            SizedBox(
                              height: 24,
                            )
                          ])),
                    )
                  ]),
                ))));
  }

  @override
  void initState() {
    startInactivityTimer();
    myNotifier = MyNotifier(commsValue, context);
    commsValue.addListener(() {
      kyrt = UniqueKey();

      if (mounted) setState(() {});
      Future.delayed(Duration(seconds: 2)).then((value) {
        print("ghjfgfgfgg");
        print("ghjfgfgfgg");
        Constants.sales_tree_key3a = UniqueKey();
        if (mounted) setState(() {});

        print("ghjfgfgfgg $_selectedButton");
      });
    });
    init2();
    secureScreen();

    setState(() {});

    super.initState();

    // Load initial data for 1 month view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateButton(1);
    });
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
    Constants.comms_formattedStartDate =
        DateFormat('yyyy-MM-dd').format(startDate!);
    Constants.comms_formattedEndDate =
        DateFormat('yyyy-MM-dd').format(endDate!);
    setState(() {});

    String dateRange =
        '${Constants.comms_formattedStartDate} - ${Constants.comms_formattedEndDate}';
    print("currently loading ${dateRange}");
    DateTime startDateTime =
        DateFormat('yyyy-MM-dd').parse(Constants.comms_formattedStartDate);
    DateTime endDateTime =
        DateFormat('yyyy-MM-dd').parse(Constants.comms_formattedEndDate);

    days_difference = endDateTime.difference(startDateTime).inDays;

    if (kDebugMode) {
      print("days_difference ${days_difference}");
      print("formattedEndDate9 ${Constants.comms_formattedEndDate}");
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
                    ? Constants.comms_salesbybranch1a[index - 1].branch_name
                    : Constants.comms_salesbybranch2a[index - 1].branch_name,
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

  String getFormattedAmount() {
    if (_selectedButton == 1 && Constants.comms_sectionsList1a.isNotEmpty) {
      return formatLargeNumber(
          Constants.comms_sectionsList1a[0].amount.toString());
    } else if (_selectedButton == 2 &&
        Constants.comms_sectionsList2a.isNotEmpty) {
      return formatLargeNumber(
          Constants.comms_sectionsList2a[0].amount.toString());
    } else if (_selectedButton == 3 &&
        days_difference <= 31 &&
        Constants.comms_sectionsList3a.isNotEmpty) {
      return formatLargeNumber(
          Constants.comms_sectionsList3a[0].amount.toString());
    } else if (_selectedButton == 3 &&
        days_difference > 31 &&
        Constants.comms_sectionsList3a.isNotEmpty) {
      return formatLargeNumber(
          Constants.comms_sectionsList3a[0].amount.toString());
    } else {
      return "N/A"; // or any default value you prefer
    }
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 10,
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
                fontSize: 8.5,
                fontWeight: FontWeight.w300,
                color: textColor,
              ),
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }
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
    double yPosition =
        chartHeight - (yValue / Constants.comms_maxY) * chartHeight;

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
    return '0';
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
    return '0';
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

class CollectionTypeGrid extends StatelessWidget {
  final List<Map<String, dynamic>> collectionTypes = [
    {'type': "Deliv'd", 'color': const Color(0xff146080)},
    {'type': "Undeliv'd", 'color': Colors.orange},
    {'type': 'Expired', 'color': Colors.green},
    {'type': "Blacklist'd", 'color': Colors.black},
    {'type': "Submit'd", 'color': Colors.blue},
    {'type': "Cancel'd", 'color': Colors.red},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0, right: 0),
      child: GridView.builder(
        shrinkWrap: true,
        physics:
            const ClampingScrollPhysics(), // To handle scrolling behavior properly
        padding: const EdgeInsets.all(0), // No padding inside the GridView
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6, // Number of columns
          crossAxisSpacing: 0, // Horizontal space between cards
          mainAxisSpacing: 0, // Vertical space between cards
          childAspectRatio: 1.5, // Aspect ratio of the cards
        ),
        itemCount: collectionTypes.length,
        itemBuilder: (context, index) {
          return Indicator(
            color: collectionTypes[index]['color'],
            text: collectionTypes[index]['type'],
            isSquare: false, // Change to true if you want square shapes
          );
        },
      ),
    );
  }
}

class CommsTypeGriditem {
  final String type;
  final Color color;
  CommsTypeGriditem(this.type, this.color);
}
