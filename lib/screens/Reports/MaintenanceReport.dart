import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mi_insights/constants/Constants.dart';
import 'package:mi_insights/models/MaintanaceCategory.dart';
import 'package:mi_insights/services/inactivitylogoutmixin.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../admin/ClientSearchPage.dart';
import '../../customwidgets/CustomCard.dart';
import '../../customwidgets/custom_date_range_picker.dart';
import '../../customwidgets/two_arrows_widget.dart';
import '../../services/MyNoyifier.dart';
import '../../services/maintenance_report_service.dart';
import '../../services/window_manager.dart';

int noOfDaysThisMonth = 30;
bool isLoading = false;
final maint4 = ValueNotifier<int>(0);
final maintenanceValue = ValueNotifier<int>(0);
double totalAmount = 0;
Key key_rut1 = UniqueKey();
MyNotifier? myNotifier;
DateTime datefrom = DateTime.now().subtract(Duration(days: 60));
DateTime dateto = DateTime.now();
int days_difference = 0;
bool isSameDaysRange = true;
int report_index = 0;
int maintenance_index = 0;
String data2 = "";
int grid_index_6 = 0;
int target_index = 0;
Key maint4a_chartKey2a = UniqueKey();
int touchedIndex = -1;
double _sliderPosition2 = 0.0;
double _sliderPosition6 = 0.0;

class MaintenanceReport extends StatefulWidget {
  const MaintenanceReport({Key? key}) : super(key: key);

  @override
  State<MaintenanceReport> createState() => _MaintenanceReportState();
}

List<Map<String, dynamic>> leads = [];
List<List<Map<String, dynamic>>> policies = [];
double _sliderPosition = 0.0;
int _selectedButton = 1;
UniqueKey uq1 = UniqueKey();

class _MaintenanceReportState extends State<MaintenanceReport>
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
      Constants.maintenance_formattedStartDate = formattedStartDate;
      Constants.maintenance_formattedEndDate = formattedEndDate;

      // Call getMaintenanceReport
      getMaintenanceReport(
              formattedStartDate, formattedEndDate, buttonNumber, context)
          .then((value) {
        if (mounted)
          setState(() {
            isLoading = false;
          });
      }).catchError((error) {
        if (kDebugMode) {
          print("❌ Error in _animateButton getMaintenanceReport: $error");
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
          restartInactivityTimer();
          setState(() {
            endDate = end;
            startDate = start;
          });

          Constants.maintenance_formattedStartDate =
              DateFormat('yyyy-MM-dd').format(startDate!);
          Constants.maintenance_formattedEndDate =
              DateFormat('yyyy-MM-dd').format(endDate!);
          setState(() {});

          String dateRange =
              '${Constants.maintenance_formattedStartDate} - ${Constants.maintenance_formattedEndDate}';
          //print("currently loading ${dateRange}");
          DateTime startDateTime = DateFormat('yyyy-MM-dd')
              .parse(Constants.maintenance_formattedStartDate);
          DateTime endDateTime = DateFormat('yyyy-MM-dd')
              .parse(Constants.maintenance_formattedEndDate);

          days_difference = endDateTime.difference(startDateTime).inDays;
          if (_selectedButton == 3 && days_difference > 31) {
            maint4.value++;
            maint4a_chartKey2a = UniqueKey();

            //  _animateButton(3);
          }
          if (endDateTime.month == startDateTime.month) {
            isSameDaysRange = true;
          } else {
            isSameDaysRange = false;
          }
          if (kDebugMode) {
            /*print("days_difference ${days_difference}");
            print(
                "formattedEndDate9fgfg ${Constants.maintenance_formattedEndDate}");*/
          }
          getMaintenanceReport(Constants.maintenance_formattedStartDate,
              Constants.maintenance_formattedEndDate, 3, context);
          isLoading = true;
          setState(() {});
        },
        onCancelClick: () {
          restartInactivityTimer();
          if (kDebugMode) {
            // print("user cancelled.");
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

  void _animateButton6(int buttonNumber) {
    uq1 = UniqueKey();
    setState(() {});

    if (buttonNumber == 0) {
      _sliderPosition6 = 0.0;
    } else if (buttonNumber == 1) {
      _sliderPosition6 = (MediaQuery.of(context).size.width / 4.1) - 18;
    } else if (buttonNumber == 2) {
      _sliderPosition6 = 2 * (MediaQuery.of(context).size.width / 4.1) - 32;
    } else if (buttonNumber == 3) {
      _sliderPosition6 = 3 * (MediaQuery.of(context).size.width / 4.1) - 26;
    }
    grid_index_6 = buttonNumber;
    setState(() {});
    restartInactivityTimer();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shadowColor: Colors.black.withOpacity(0.3),
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
            centerTitle: true,
            title: const Text(
              "Maintenance Report",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            )),
        backgroundColor: Colors.white,
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
                                      : InkWell(
                                          onTap: () {
                                            _animateButton(3);
                                          },
                                          child: Center(
                                            child: Text(
                                              'Select Dates',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
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
                      if (isLoading)
                        SizedBox(
                          height: 12,
                        ),

                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width /
                                          (MediaQuery.of(context).size.height /
                                              2.3)),
                          itemCount: _selectedButton == 1
                              ? Constants.maintenance_sectionsList1a.length
                              : _selectedButton == 2
                                  ? Constants.maintenance_sectionsList2a.length
                                  : _selectedButton == 3 &&
                                          days_difference <= 31
                                      ? Constants
                                          .maintenance_sectionsList3a.length
                                      : Constants
                                          .maintenance_sectionsList3b.length,
                          padding: EdgeInsets.all(2.0),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 300,
                                  width:
                                      MediaQuery.of(context).size.width / 2.9,
                                  child: Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // maintenance_index = index;
                                          setState(() {});
                                          if (kDebugMode) {
                                            /* print("maintenance_index " +
                                                index.toString());*/
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
                                                            color: Colors.grey
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
                                                            height: 280,
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
                                                                            7.0),
                                                                    child: Text(
                                                                      formatLargeNumber3((_selectedButton == 1
                                                                              ? Constants.maintenance_sectionsList1a[index].amount
                                                                              : _selectedButton == 2
                                                                                  ? Constants.maintenance_sectionsList2a[index].amount
                                                                                  : _selectedButton == 3 && days_difference <= 31
                                                                                      ? Constants.maintenance_sectionsList3a[index].amount
                                                                                      : Constants.maintenance_sectionsList3b[index].amount)
                                                                          .toString()),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18.5,
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
                                                                          .all(
                                                                          8.0),
                                                                  child: Text(
                                                                    _selectedButton ==
                                                                            1
                                                                        ? Constants
                                                                            .maintenance_sectionsList1a[
                                                                                index]
                                                                            .id
                                                                        : _selectedButton ==
                                                                                2
                                                                            ? Constants.maintenance_sectionsList2a[index].id
                                                                            : _selectedButton == 3 && days_difference <= 31
                                                                                ? Constants.maintenance_sectionsList3a[index].id
                                                                                : Constants.maintenance_sectionsList3b[index].id,
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
                                          "A - Rate (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
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
                                            left: 16.0, right: 16, bottom: 8),
                                        child:
                                            Text("A - Rate (12 Months View)"),
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
                                              left: 16.0, right: 16, bottom: 8),
                                          child: Text(
                                              "A - Rate (${Constants.sales_formattedStartDate} to ${Constants.sales_formattedEndDate})"),
                                        ),
                                      )
                                    ],
                                  )),
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0, right: 6),
                        child: LinearPercentIndicator(
                          width: MediaQuery.of(context).size.width - 16,
                          animation: true,
                          lineHeight: 20.0,
                          animationDuration: 500,
                          percent: 0.0,
                          center: Text("${0.toStringAsFixed(1)}%"),
                          barRadius: ui.Radius.circular(12),
                          //linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: Colors.green,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),

                      _selectedButton == 1
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, top: 8, bottom: 2),
                              child: Text(
                                  "Maintenance Overview (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                            )
                          : _selectedButton == 2
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 8, bottom: 2),
                                  child: Text(
                                      "Maintenance Overview (12 Months View)"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 8, bottom: 2),
                                  child: Text(
                                      "Maintenance Overview (${Constants.maintenance_formattedStartDate} to ${Constants.maintenance_formattedEndDate})"),
                                ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 4, bottom: 8),
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
                                          child: const Center(
                                            child: Text(
                                              'Upgrades & Downgrades',
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
                                              'Amendments',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13.5),
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
                                                'Upgrades & Downgrades',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          : target_index == 1
                                              ? Center(
                                                  child: Text(
                                                    'Amendments',
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
                      if (target_index == 1)
                        if (_selectedButton == 1)
                          Container(
                              height: 281,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 16, top: 8, bottom: 8),
                                child: CustomCard(
                                    elevation: 6,
                                    color: Colors.white,
                                    surfaceTintColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: maintenance_index == 0
                                          ? (_selectedButton == 1 &&
                                                  Constants.maintenance_spots1a
                                                          .length ==
                                                      0)
                                              ? Center(
                                                  child: Text(
                                                    "No data available for the range selected",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                )
                                              : Column(
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Container(
                                                          height: 120,
                                                          child: LineChart(
                                                            key: Constants
                                                                .maintenance_chartKey1a,
                                                            LineChartData(
                                                              lineBarsData: [
                                                                LineChartBarData(
                                                                  spots: Constants
                                                                      .maintenance_spots1a,
                                                                  isCurved:
                                                                      true,
                                                                  barWidth: 3,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400,
                                                                  dotData:
                                                                      FlDotData(
                                                                    show: true,
                                                                    getDotPainter: (spot,
                                                                        percent,
                                                                        barData,
                                                                        index) {
                                                                      // Show custom dot and text for specific x-values

                                                                      return FlDotCirclePainter(
                                                                          radius:
                                                                              2,
                                                                          color: Colors
                                                                              .red,
                                                                          strokeColor:
                                                                              Colors.green);
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
                                                                            2.0),
                                                                        child:
                                                                            Text(
                                                                          value
                                                                              .toInt()
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(fontSize: 7),
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
                                                                      if (value <
                                                                          0) {
                                                                        return Container();
                                                                      } else
                                                                        return Text(
                                                                          formatLargeNumber2(value
                                                                              .toInt()
                                                                              .toString()),
                                                                          style:
                                                                              TextStyle(fontSize: 7.5),
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
                                                              minY: -20,
                                                              minX: 1,
                                                              maxX: noOfDaysThisMonth
                                                                  .toDouble(),
                                                              maxY: _selectedButton ==
                                                                      1
                                                                  ? Constants
                                                                      .maintenance_maxY
                                                                      .toDouble()
                                                                  : Constants
                                                                      .maintenance_maxY2
                                                                      .toDouble(),
                                                              borderData:
                                                                  FlBorderData(
                                                                show: true,
                                                                border: Border(
                                                                  left:
                                                                      BorderSide
                                                                          .none,
                                                                  bottom:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.35),
                                                                    width: 1,
                                                                  ),
                                                                  right:
                                                                      BorderSide
                                                                          .none,
                                                                  top:
                                                                      BorderSide
                                                                          .none,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                          : maintenance_index == 1
                                              ? Column(
                                                  children: [
                                                    Expanded(
                                                      child: LineChart(
                                                        key: Constants
                                                            .maintenance_chartKey1b,
                                                        LineChartData(
                                                          lineBarsData: [
                                                            LineChartBarData(
                                                              spots: Constants
                                                                  .maintenance_spots1b,
                                                              isCurved: true,
                                                              barWidth: 3,
                                                              color: Colors.grey
                                                                  .shade400,
                                                              dotData:
                                                                  FlDotData(
                                                                show: true,
                                                                getDotPainter:
                                                                    (spot,
                                                                        percent,
                                                                        barData,
                                                                        index) {
                                                                  // Show custom dot and text for specific x-values

                                                                  return FlDotCirclePainter(
                                                                      radius: 2,
                                                                      color: Colors
                                                                          .red,
                                                                      strokeColor:
                                                                          Colors
                                                                              .green);
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
                                                          minX: 1,
                                                          maxX:
                                                              noOfDaysThisMonth
                                                                  .toDouble(),
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
                                                                            2.0),
                                                                    child: Text(
                                                                      value
                                                                          .toInt()
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              7),
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
                                                          maxY: _selectedButton ==
                                                                  1
                                                              ? Constants
                                                                  .maintenance_maxY
                                                                  .toDouble()
                                                              : Constants
                                                                  .maintenance_maxY2
                                                                  .toDouble(),
                                                          borderData:
                                                              FlBorderData(
                                                            show: true,
                                                            border: Border(
                                                              left: BorderSide
                                                                  .none,
                                                              bottom:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.35),
                                                                width: 1,
                                                              ),
                                                              right: BorderSide
                                                                  .none,
                                                              top: BorderSide
                                                                  .none,
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
                                                      style: TextStyle(
                                                          fontSize: 9),
                                                    )
                                                  ],
                                                )
                                              : Column(
                                                  children: [
                                                    Expanded(
                                                      child: LineChart(
                                                        key: Constants
                                                            .maintenance_chartKey1c,
                                                        LineChartData(
                                                          lineBarsData: [
                                                            LineChartBarData(
                                                              spots: Constants
                                                                  .maintenance_spots1c,
                                                              isCurved: true,
                                                              barWidth: 3,
                                                              color: Colors.grey
                                                                  .shade400,
                                                              dotData:
                                                                  FlDotData(
                                                                show: true,
                                                                getDotPainter:
                                                                    (spot,
                                                                        percent,
                                                                        barData,
                                                                        index) {
                                                                  // Show custom dot and text for specific x-values

                                                                  return FlDotCirclePainter(
                                                                      radius: 2,
                                                                      color: Colors
                                                                          .red,
                                                                      strokeColor:
                                                                          Colors
                                                                              .green);
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
                                                          minX: 1,
                                                          maxX:
                                                              noOfDaysThisMonth
                                                                  .toDouble(),
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
                                                                            2.0),
                                                                    child: Text(
                                                                      value
                                                                          .toInt()
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              7),
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
                                                          maxY: _selectedButton ==
                                                                  1
                                                              ? Constants
                                                                  .maintenance_maxY
                                                                  .toDouble()
                                                              : Constants
                                                                  .maintenance_maxY2
                                                                  .toDouble(),
                                                          borderData:
                                                              FlBorderData(
                                                            show: true,
                                                            border: Border(
                                                              left: BorderSide
                                                                  .none,
                                                              bottom:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.35),
                                                                width: 1,
                                                              ),
                                                              right: BorderSide
                                                                  .none,
                                                              top: BorderSide
                                                                  .none,
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
                                                      style: TextStyle(
                                                          fontSize: 9),
                                                    )
                                                  ],
                                                ),
                                    )),
                              ))
                        else if (_selectedButton == 2)
                          MaintanenceGraph2()
                        else if (_selectedButton == 3 &&
                            days_difference <= 32 &&
                            isSameDaysRange == true)
                          Container(
                              height: 250,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                      surfaceTintColor: Colors.white,
                                      color: Colors.white,
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Padding(
                                          padding: const EdgeInsets.all(14.0),
                                          child: LineChart(
                                            key: Constants
                                                .maintenance_chartKey3a,
                                            LineChartData(
                                              lineBarsData: [
                                                LineChartBarData(
                                                  spots: Constants
                                                      .maintenance_spots3a,
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
                                              maxX: 30,
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
                                                      /*       DateTime end = DateTime
                                                              .parse(Constants
                                                                  .sales_formattedEndDate);
                                                          // Calculate the start date by subtracting 29 days from the end date
                                                          DateTime start =
                                                              end.subtract(Duration(
                                                                  days: 29));

                                                          // Calculate the specific date for the given value within the last 30 days
                                                          DateTime currentDate =
                                                              start.add(Duration(
                                                                  days: value
                                                                      .toInt()));
              */
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: Text(
                                                          value
                                                              .toInt()
                                                              .toString(), // Show the day of the month
                                                          style: TextStyle(
                                                              fontSize: 7),
                                                        ),
                                                      );
                                                    },
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
                                                        formatLargeNumber3(value
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
                                              minX: 1,
                                              maxY: Constants.maintenance_maxY3
                                                  .toDouble(),
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
                                          )))))
                        else if (_selectedButton == 3 &&
                            days_difference <= 31 &&
                            isSameDaysRange == false)
                          MaintanenceGraph3(),
                      if (_selectedButton == 3 && days_difference > 32)
                        MaintanenceGraph4(
                          key: maint4a_chartKey2a,
                        ),
                      if (_selectedButton == 3 &&
                          days_difference <= 31 &&
                          isSameDaysRange == false)
                        Row(
                          children: [
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 20.0, top: 0, bottom: 8),
                              child: Text(
                                "Weekend Admin is Added to / Accounted For On The Next Monday",
                                style: TextStyle(fontSize: 9),
                              ),
                            ),
                          ],
                        ),
                      if (target_index == 0)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, top: 8, right: 16, bottom: 12),
                          child: SizedBox(
                            height: 275,
                            child: CustomCard(
                              elevation: 6,
                              color: Colors.white,
                              surfaceTintColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 3.0, bottom: 10),
                                        child: ArrowWithText(
                                            text: (_selectedButton == 1 &&
                                                        Constants.maintenance_most_frequent_upgrades1a_count ==
                                                            1 ||
                                                    _selectedButton == 2 &&
                                                        Constants.maintenance_most_frequent_upgrades2a_count ==
                                                            1 ||
                                                    _selectedButton == 3 &&
                                                        Constants.maintenance_most_frequent_upgrades3a_count ==
                                                            1 &&
                                                        days_difference <= 31 ||
                                                    _selectedButton == 3 &&
                                                        Constants.maintenance_most_frequent_upgrades3b_count ==
                                                            1 &&
                                                        days_difference >= 31)
                                                ? 'UPGRADE'
                                                : 'UPGRADES',
                                            secondary_text: (_selectedButton ==
                                                            1 &&
                                                        Constants.maintenance_most_frequent_upgrades1a_count ==
                                                            0 ||
                                                    _selectedButton == 2 &&
                                                        Constants.maintenance_most_frequent_upgrades2a_count ==
                                                            0 ||
                                                    _selectedButton == 3 &&
                                                        Constants.maintenance_most_frequent_upgrades3a_count ==
                                                            0 &&
                                                        days_difference <= 31 ||
                                                    _selectedButton == 3 &&
                                                        Constants.maintenance_most_frequent_upgrades3b_count ==
                                                            0 &&
                                                        days_difference >= 31)
                                                ? "\nNo Upgrades Reported For The Period Selected"
                                                : 'From Total Upgrades,\n The Popular Benefit Selected is \nR ${formatLargeNumber(
                                                    _selectedButton == 1
                                                        ? Constants
                                                            .maintenance_most_frequent_upgrades1a
                                                            .toString()
                                                        : _selectedButton == 2
                                                            ? Constants
                                                                .maintenance_most_frequent_upgrades2a
                                                                .toString()
                                                            : _selectedButton ==
                                                                        3 &&
                                                                    days_difference <=
                                                                        31
                                                                ? Constants
                                                                    .maintenance_most_frequent_upgrades3a
                                                                    .toString()
                                                                : Constants
                                                                    .maintenance_most_frequent_upgrades3b
                                                                    .toString(),
                                                  )}',
                                            isUpArrow: true,
                                            circleText: (_selectedButton == 1
                                                    ? Constants
                                                        .maintenance_most_frequent_upgrades1a_count
                                                    : _selectedButton == 2
                                                        ? Constants
                                                            .maintenance_most_frequent_upgrades2a_count
                                                        : _selectedButton == 3 &&
                                                                days_difference <= 31
                                                            ? Constants.maintenance_most_frequent_upgrades3a_count
                                                            : Constants.maintenance_most_frequent_upgrades3b_count)
                                                .toString(),
                                            circleVerticalOffset: 55),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.5,
                                            top: 10),
                                        child: ArrowWithText(
                                            text: (_selectedButton == 1 &&
                                                        Constants.maintenance_most_frequent_downgrades1a_count ==
                                                            1 ||
                                                    _selectedButton == 2 &&
                                                        Constants.maintenance_most_frequent_downgrades2a_count ==
                                                            1 ||
                                                    _selectedButton == 3 &&
                                                        Constants.maintenance_most_frequent_downgrades3a_count ==
                                                            1 &&
                                                        days_difference <= 31 ||
                                                    _selectedButton == 3 &&
                                                        Constants.maintenance_most_frequent_downgrades3b_count ==
                                                            1 &&
                                                        days_difference >= 31)
                                                ? 'DOWNGRADE'
                                                : 'DOWNGRADES',
                                            secondary_text: (_selectedButton ==
                                                            1 &&
                                                        Constants.maintenance_most_frequent_downgrades1a_count ==
                                                            0 ||
                                                    _selectedButton == 2 &&
                                                        Constants.maintenance_most_frequent_downgrades2a_count ==
                                                            0 ||
                                                    _selectedButton == 3 &&
                                                        Constants.maintenance_most_frequent_downgrades3a_count ==
                                                            0 &&
                                                        days_difference <= 31 ||
                                                    _selectedButton == 3 &&
                                                        Constants.maintenance_most_frequent_downgrades3b_count ==
                                                            0 &&
                                                        days_difference >= 31)
                                                ? "\nNo Upgrades Reported For The Period Selected"
                                                : 'From Total Downgrades,\n The Popular Benefit Exited is \nR ${formatLargeNumber(
                                                    _selectedButton == 1
                                                        ? Constants
                                                            .maintenance_most_frequent_downgrades1a
                                                            .toString()
                                                        : _selectedButton == 2
                                                            ? Constants
                                                                .maintenance_most_frequent_downgrades2a
                                                                .toString()
                                                            : _selectedButton ==
                                                                        3 &&
                                                                    days_difference <=
                                                                        31
                                                                ? Constants
                                                                    .maintenance_most_frequent_downgrades3a
                                                                    .toString()
                                                                : Constants
                                                                    .maintenance_most_frequent_downgrades3b
                                                                    .toString(),
                                                  )}',
                                            isUpArrow: false,
                                            circleText: (_selectedButton == 1
                                                    ? Constants
                                                        .maintenance_most_frequent_downgrades1a_count
                                                    : _selectedButton == 2
                                                        ? Constants
                                                            .maintenance_most_frequent_downgrades2a_count
                                                        : _selectedButton == 3 &&
                                                                days_difference <= 31
                                                            ? Constants.maintenance_most_frequent_downgrades3a_count
                                                            : Constants.maintenance_most_frequent_downgrades3b_count)
                                                .toString(),
                                            circleVerticalOffset: 65),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      /*          _selectedButton == 1
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  child: AspectRatio(
                                    aspectRatio: 1.66,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          final double barsSpace =
                                              1.0 * constraints.maxWidth / 200;

                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: BarChart(
                                              BarChartData(
                                                alignment: BarChartAlignment.center,
                                                barTouchData:
                                                    BarTouchData(enabled: false),
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
                                                      getTitlesWidget:
                                                          (value, meta) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                  0.0),
                                                          child: Text(
                                                            value
                                                                .toInt()
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 6.5),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    axisNameWidget: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 0.0),
                                                      child: Text(
                                                        'Days of the month',
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
                                                          formatLargeNumber2B(value
                                                              .toInt()
                                                              .toString()),
                                                          style: TextStyle(
                                                              fontSize: 7.5),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                borderData:
                                                    FlBorderData(show: false),
                                                groupsSpace: barsSpace,
                                                barGroups: Constants
                                                    .maintenance_barChartData1,
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
                                          borderRadius: BorderRadius.circular(16)),
                                      child: AspectRatio(
                                        aspectRatio: 1.66,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 16),
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              final double barsSpace =
                                                  1.2 * constraints.maxWidth / 200;

                                              return Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: BarChart(
                                                  BarChartData(
                                                    alignment:
                                                        BarChartAlignment.center,
                                                    barTouchData: BarTouchData(
                                                        enabled: false),
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
                                                                      .all(0.0),
                                                              child: Text(
                                                                getMonthAbbreviation(
                                                                        value
                                                                            .toInt())
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize: 9.5),
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
                                                              formatLargeNumber2B(
                                                                  value
                                                                      .toInt()
                                                                      .toString()),
                                                              style: TextStyle(
                                                                  fontSize: 7.5),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    borderData:
                                                        FlBorderData(show: false),
                                                    groupsSpace: barsSpace,
                                                    barGroups: Constants
                                                        .maintenance_barChartData2,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : _selectedButton == 3 && days_difference <= 31
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
                                                        alignment: BarChartAlignment
                                                            .center,
                                                        barTouchData: BarTouchData(
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
                                                          bottomTitles: AxisTitles(
                                                            sideTitles: SideTitles(
                                                              showTitles: true,
                                                              interval: 1,
                                                              getTitlesWidget:
                                                                  (value, meta) {
                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(0.0),
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
                                                            axisNameWidget: Padding(
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
                                                                  formatLargeNumber2B(
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
                                                        barGroups: Constants
                                                            .maintenance_barChartData3,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : _selectedButton == 3 && days_difference > 31
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
                                                      final double barsSpace = 1.0 *
                                                          constraints.maxWidth /
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
                                                                    enabled: false),
                                                            gridData: FlGridData(
                                                              show: true,
                                                              drawVerticalLine:
                                                                  false,
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
                                                                  showTitles: true,
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
                                                                          top: 0.0),
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
                                                              topTitles: AxisTitles(
                                                                sideTitles:
                                                                    SideTitles(
                                                                  showTitles: false,
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
                                                                  showTitles: false,
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
                                                                  showTitles: true,
                                                                  reservedSize: 20,
                                                                  getTitlesWidget:
                                                                      (value,
                                                                          meta) {
                                                                    return Text(
                                                                      formatLargeNumber2B(value
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
                                                            groupsSpace: barsSpace,
                                                            barGroups: Constants
                                                                .maintenance_barChartData2,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),*/
                      SizedBox(
                        height: 16,
                      ),
                      _selectedButton == 1
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, top: 0, bottom: 8),
                              child: Text(
                                  "Maintenance By Type (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                            )
                          : _selectedButton == 2
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 0, bottom: 8),
                                  child: Text(
                                      "Maintenance By Type (12 Months View)"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 0, bottom: 8),
                                  child: Text(
                                      "Maintenance By Type (${Constants.maintenance_formattedStartDate} to ${Constants.maintenance_formattedEndDate})"),
                                ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 0),
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
                                                  BorderRadius.circular(360)),
                                          height: 35,
                                          child: Center(
                                            child: Text(
                                              'Principal',
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
                                                  BorderRadius.circular(360)),
                                          child: Center(
                                            child: Text(
                                              'Insured',
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
                                                  BorderRadius.circular(360)),
                                          child: Center(
                                            child: Text(
                                              'Beneficiary',
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
                                                  BorderRadius.circular(360)),
                                          child: Center(
                                            child: Text(
                                              'Other',
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
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Constants
                                          .ctaColorLight, // Color of the slider
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: grid_index_6 == 0
                                        ? Center(
                                            child: Text(
                                              'Principal',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : grid_index_6 == 1
                                            ? Center(
                                                child: Text(
                                                  'Insured',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            : grid_index_6 == 2
                                                ? Center(
                                                    child: Text(
                                                      'Beneficiary',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  )
                                                : Center(
                                                    child: Text(
                                                      'Other',
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
                      if (grid_index_6 == 0)
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 12, top: 12.0, right: 12, bottom: 8),
                            child: CustomCard(
                              elevation: 6,
                              surfaceTintColor: Colors.white,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              child:
                                  ((_selectedButton == 1 &&
                                              Constants
                                                  .maintenance_droupedChartData1
                                                  .isEmpty) ||
                                          (_selectedButton == 2 &&
                                              Constants
                                                  .maintenance_droupedChartData2
                                                  .isEmpty) ||
                                          (_selectedButton == 3 &&
                                                  days_difference <= 31 &&
                                                  Constants
                                                      .maintenance_droupedChartData3
                                                      .isEmpty) &&
                                              (_selectedButton == 3 &&
                                                  days_difference <= 31 &&
                                                  Constants
                                                      .maintenance_droupedChartData3
                                                      .isEmpty))
                                      ? Container(
                                          height: 250,
                                          width:
                                              MediaQuery.of(context).size.width,
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
                                          ))
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.only(
                                              top: 0, bottom: 0),
                                          key: key_rut1,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: _selectedButton == 1
                                              ? Constants
                                                  .maintenance_droupedChartData1
                                                  .length
                                              : _selectedButton == 2
                                                  ? Constants
                                                      .maintenance_droupedChartData2
                                                      .length
                                                  : _selectedButton == 3 &&
                                                          days_difference <= 31
                                                      ? Constants
                                                          .maintenance_droupedChartData3
                                                          .length
                                                      : Constants
                                                          .maintenance_droupedChartData4
                                                          .length,
                                          itemBuilder: (context, index) {
                                            MaintanaceCategory category =
                                                MaintanaceCategory(
                                                    name: '', items: []);
                                            if (_selectedButton == 1) {
                                              category = Constants
                                                      .maintenance_droupedChartData1[
                                                  index];
                                              print("yuuyyu1 ${category.name}");
                                            } else if (_selectedButton == 2) {
                                              category = Constants
                                                      .maintenance_droupedChartData2[
                                                  index];
                                              // print("yuuyyu2 ${category}");
                                            } else if (_selectedButton == 3 &&
                                                days_difference <= 31) {
                                              category = Constants
                                                      .maintenance_droupedChartData3[
                                                  index];
                                              //  print("yuuyyu ${category}");
                                            } else {
                                              category = Constants
                                                      .maintenance_droupedChartData4[
                                                  index];
                                              // print("yuuyyu4 ${category}");
                                            }

                                            final totalCategoryCount =
                                                category.getTotalCount();
                                            if (category.name == "Self") {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0.0,
                                                    left: 0,
                                                    right: 0,
                                                    bottom: 4),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              17),
                                                      border: Border(
                                                          top:
                                                              BorderSide.none)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.5),
                                                    child: ListTileTheme(
                                                      dense: true,
                                                      minVerticalPadding: 0,
                                                      child: ExpansionTile(
                                                        childrenPadding:
                                                            EdgeInsets.only(
                                                                top: 0,
                                                                bottom: 0),
                                                        tilePadding:
                                                            EdgeInsets.only(
                                                                top: 0,
                                                                bottom: 0,
                                                                left: 8,
                                                                right: 8),
                                                        initiallyExpanded: true,
                                                        backgroundColor: Colors
                                                            .grey
                                                            .withOpacity(0.35),
                                                        collapsedBackgroundColor:
                                                            Colors.grey
                                                                .withOpacity(
                                                                    0.35),
                                                        trailing: Container(
                                                          width: 80,
                                                          child: Stack(
                                                            children: [
                                                              Container(
                                                                height: 16,
                                                                child:
                                                                    LinearProgressIndicator(
                                                                  value: 1,
                                                                  backgroundColor: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.3),
                                                                  valueColor: AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Colors
                                                                          .blue),
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
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              Colors.white),
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
                                                                    BorderRadius
                                                                        .circular(
                                                                            16)),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16)),
                                                        title: Text(
                                                          category.name.replaceAll(
                                                              "Self",
                                                              "Principal Member"),
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                        ),
                                                        children: category.items
                                                            .map((item) {
                                                          double percentage = item
                                                                  .count /
                                                              totalCategoryCount;
                                                          return Container(
                                                            color: Colors.white,
                                                            child: ListTile(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16)),
                                                              dense: true,
                                                              visualDensity:
                                                                  VisualDensity(
                                                                      horizontal:
                                                                          0,
                                                                      vertical:
                                                                          -4),
                                                              minLeadingWidth:
                                                                  0,
                                                              horizontalTitleGap:
                                                                  0,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              8,
                                                                          right:
                                                                              8),
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
                                                              title: Text(
                                                                item.title,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                              trailing:
                                                                  SizedBox(
                                                                width: 80,
                                                                height: 16,
                                                                child: Stack(
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                          16,
                                                                      child:
                                                                          LinearProgressIndicator(
                                                                        value:
                                                                            percentage,
                                                                        backgroundColor: Colors
                                                                            .grey
                                                                            .withOpacity(0.3),
                                                                        valueColor:
                                                                            AlwaysStoppedAnimation<Color>(Colors.blue),
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
                                                                            formatLargeNumber3(item.count.toString()),
                                                                            style:
                                                                                TextStyle(fontSize: 11, color: percentage < 0.50 ? Colors.black : Colors.white),
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
                                            }
                                          },
                                        ),
                            ),
                          ),
                        ),
                      if (grid_index_6 == 1)
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 12, top: 8.0, right: 12, bottom: 8),
                            child: Card(
                              elevation: 6,
                              surfaceTintColor: Colors.white,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.only(top: 0, bottom: 0),
                                key: key_rut1,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _selectedButton == 1
                                    ? Constants
                                        .maintenance_droupedChartData1.length
                                    : _selectedButton == 2
                                        ? Constants
                                            .maintenance_droupedChartData2
                                            .length
                                        : _selectedButton == 3 &&
                                                days_difference <= 31
                                            ? Constants
                                                .maintenance_droupedChartData3
                                                .length
                                            : Constants
                                                .maintenance_droupedChartData4
                                                .length,
                                itemBuilder: (context, index) {
                                  MaintanaceCategory category =
                                      MaintanaceCategory(name: '', items: []);
                                  if (_selectedButton == 1) {
                                    category = Constants
                                        .maintenance_droupedChartData1[index];
                                    print("yuuyyu1 ${category.name}");
                                  } else if (_selectedButton == 2) {
                                    category = Constants
                                        .maintenance_droupedChartData2[index];
                                    // print("yuuyyu2 ${category}");
                                  } else if (_selectedButton == 3 &&
                                      days_difference <= 31) {
                                    category = Constants
                                        .maintenance_droupedChartData3[index];
                                    //  print("yuuyyu ${category}");
                                  } else {
                                    category = Constants
                                        .maintenance_droupedChartData4[index];
                                    // print("yuuyyu4 ${category}");
                                  }

                                  final totalCategoryCount =
                                      category.getTotalCount();
                                  if (category.name == "Dependant") {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0.0,
                                          left: 0,
                                          right: 0,
                                          bottom: 4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(17),
                                            border:
                                                Border(top: BorderSide.none)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16.5),
                                          child: ListTileTheme(
                                            dense: true,
                                            minVerticalPadding: 0,
                                            child: ExpansionTile(
                                              childrenPadding: EdgeInsets.only(
                                                  top: 0, bottom: 0),
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
                                                      child:
                                                          LinearProgressIndicator(
                                                        value: 1,
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
                                                                totalCategoryCount
                                                                    .toString()),
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Colors
                                                                    .white),
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
                                                          BorderRadius.circular(
                                                              16)),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16)),
                                              title: Text(
                                                category.name.replaceAll(
                                                    "Dependant", "Insured"),
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              children:
                                                  category.items.map((item) {
                                                double percentage = item.count /
                                                    totalCategoryCount;
                                                return Container(
                                                  color: Colors.white,
                                                  child: ListTile(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16)),
                                                    dense: true,
                                                    visualDensity:
                                                        VisualDensity(
                                                            horizontal: 0,
                                                            vertical: -4),
                                                    minLeadingWidth: 0,
                                                    horizontalTitleGap: 0,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            left: 8, right: 8),
                                                    minVerticalPadding: 0,
                                                    selectedColor: Colors.white,
                                                    selectedTileColor:
                                                        Colors.white,
                                                    tileColor: Colors.white,
                                                    splashColor: Colors.white,
                                                    title: Text(
                                                      item.title,
                                                      style: TextStyle(
                                                          fontSize: 14),
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
                                                              backgroundColor:
                                                                  Colors.grey
                                                                      .withOpacity(
                                                                          0.3),
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Colors
                                                                          .blue),
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 16,
                                                            child: Row(
                                                              children: [
                                                                Spacer(),
                                                                Text(
                                                                  formatLargeNumber3(item
                                                                      .count
                                                                      .toString()),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11,
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
                                  } else
                                    return Container();
                                },
                              ),
                            ),
                          ),
                        ),

                      if (grid_index_6 == 2)
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 12, top: 8.0, right: 12, bottom: 8),
                            child: Card(
                              elevation: 6,
                              surfaceTintColor: Colors.white,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.only(top: 0, bottom: 0),
                                key: key_rut1,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _selectedButton == 1
                                    ? Constants
                                        .maintenance_droupedChartData1.length
                                    : _selectedButton == 2
                                        ? Constants
                                            .maintenance_droupedChartData2
                                            .length
                                        : _selectedButton == 3 &&
                                                days_difference <= 31
                                            ? Constants
                                                .maintenance_droupedChartData3
                                                .length
                                            : Constants
                                                .maintenance_droupedChartData4
                                                .length,
                                itemBuilder: (context, index) {
                                  MaintanaceCategory category =
                                      MaintanaceCategory(name: '', items: []);
                                  if (_selectedButton == 1) {
                                    category = Constants
                                        .maintenance_droupedChartData1[index];
                                    print("yuuyyu1 ${category.name}");
                                  } else if (_selectedButton == 2) {
                                    category = Constants
                                        .maintenance_droupedChartData2[index];
                                    // print("yuuyyu2 ${category}");
                                  } else if (_selectedButton == 3 &&
                                      days_difference <= 31) {
                                    category = Constants
                                        .maintenance_droupedChartData3[index];
                                    //  print("yuuyyu ${category}");
                                  } else {
                                    category = Constants
                                        .maintenance_droupedChartData4[index];
                                    // print("yuuyyu4 ${category}");
                                  }

                                  final totalCategoryCount =
                                      category.getTotalCount();
                                  if (category.name == "Beneficiary") {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0.0,
                                          left: 0,
                                          right: 0,
                                          bottom: 4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(17),
                                            border:
                                                Border(top: BorderSide.none)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16.5),
                                          child: ListTileTheme(
                                            dense: true,
                                            minVerticalPadding: 0,
                                            child: ExpansionTile(
                                              childrenPadding: EdgeInsets.only(
                                                  top: 0, bottom: 0),
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
                                                      child:
                                                          LinearProgressIndicator(
                                                        value: 1,
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
                                                                totalCategoryCount
                                                                    .toString()),
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Colors
                                                                    .white),
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
                                                          BorderRadius.circular(
                                                              16)),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16)),
                                              title: Text(
                                                category.name.replaceAll(
                                                    "Self", "Main Member"),
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              children:
                                                  category.items.map((item) {
                                                double percentage = item.count /
                                                    totalCategoryCount;
                                                return Container(
                                                  color: Colors.white,
                                                  child: ListTile(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16)),
                                                    dense: true,
                                                    visualDensity:
                                                        VisualDensity(
                                                            horizontal: 0,
                                                            vertical: -4),
                                                    minLeadingWidth: 0,
                                                    horizontalTitleGap: 0,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            left: 8, right: 8),
                                                    minVerticalPadding: 0,
                                                    selectedColor: Colors.white,
                                                    selectedTileColor:
                                                        Colors.white,
                                                    tileColor: Colors.white,
                                                    splashColor: Colors.white,
                                                    title: Text(
                                                      item.title,
                                                      style: TextStyle(
                                                          fontSize: 14),
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
                                                              backgroundColor:
                                                                  Colors.grey
                                                                      .withOpacity(
                                                                          0.3),
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Colors
                                                                          .blue),
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 16,
                                                            child: Row(
                                                              children: [
                                                                Spacer(),
                                                                Text(
                                                                  formatLargeNumber3(item
                                                                      .count
                                                                      .toString()),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11,
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
                                  } else
                                    return Container();
                                },
                              ),
                            ),
                          ),
                        ),
                      if (grid_index_6 == 3)
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 12, top: 8.0, right: 12, bottom: 8),
                            child: Card(
                              elevation: 6,
                              surfaceTintColor: Colors.white,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.only(top: 0, bottom: 0),
                                key: key_rut1,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _selectedButton == 1
                                    ? Constants
                                        .maintenance_droupedChartData1.length
                                    : _selectedButton == 2
                                        ? Constants
                                            .maintenance_droupedChartData2
                                            .length
                                        : _selectedButton == 3 &&
                                                days_difference <= 31
                                            ? Constants
                                                .maintenance_droupedChartData3
                                                .length
                                            : Constants
                                                .maintenance_droupedChartData4
                                                .length,
                                itemBuilder: (context, index) {
                                  MaintanaceCategory category =
                                      MaintanaceCategory(name: '', items: []);
                                  if (_selectedButton == 1) {
                                    category = Constants
                                        .maintenance_droupedChartData1[index];
                                    print("yuuyyu1 ${category.name}");
                                  } else if (_selectedButton == 2) {
                                    category = Constants
                                        .maintenance_droupedChartData2[index];
                                    // print("yuuyyu2 ${category}");
                                  } else if (_selectedButton == 3 &&
                                      days_difference <= 31) {
                                    category = Constants
                                        .maintenance_droupedChartData3[index];
                                    //  print("yuuyyu ${category}");
                                  } else {
                                    category = Constants
                                        .maintenance_droupedChartData4[index];
                                    // print("yuuyyu4 ${category}");
                                  }

                                  final totalCategoryCount =
                                      category.getTotalCount();
                                  if (category.name == "Other") {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0.0,
                                          left: 0,
                                          right: 0,
                                          bottom: 4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(17),
                                            border:
                                                Border(top: BorderSide.none)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16.5),
                                          child: ListTileTheme(
                                            dense: true,
                                            minVerticalPadding: 0,
                                            child: ExpansionTile(
                                              childrenPadding: EdgeInsets.only(
                                                  top: 0, bottom: 0),
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
                                                      child:
                                                          LinearProgressIndicator(
                                                        value: 1,
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
                                                                totalCategoryCount
                                                                    .toString()),
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Colors
                                                                    .white),
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
                                                          BorderRadius.circular(
                                                              16)),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16)),
                                              title: Text(
                                                category.name.replaceAll(
                                                    "Self", "Main Member"),
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              children:
                                                  category.items.map((item) {
                                                double percentage = item.count /
                                                    totalCategoryCount;
                                                return Container(
                                                  color: Colors.white,
                                                  child: ListTile(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16)),
                                                    dense: true,
                                                    visualDensity:
                                                        VisualDensity(
                                                            horizontal: 0,
                                                            vertical: -4),
                                                    minLeadingWidth: 0,
                                                    horizontalTitleGap: 0,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            left: 8, right: 8),
                                                    minVerticalPadding: 0,
                                                    selectedColor: Colors.white,
                                                    selectedTileColor:
                                                        Colors.white,
                                                    tileColor: Colors.white,
                                                    splashColor: Colors.white,
                                                    title: Text(
                                                      item.title,
                                                      style: TextStyle(
                                                          fontSize: 14),
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
                                                              backgroundColor:
                                                                  Colors.grey
                                                                      .withOpacity(
                                                                          0.3),
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Colors
                                                                          .blue),
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 16,
                                                            child: Row(
                                                              children: [
                                                                Spacer(),
                                                                Text(
                                                                  formatLargeNumber3(item
                                                                      .count
                                                                      .toString()),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11,
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
                                  } else
                                    return Container();
                                },
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 16),
                      _selectedButton == 1
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, top: 0, bottom: 0),
                              child: Text(
                                  "Top 10 Maintenance By Agent (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                            )
                          : _selectedButton == 2
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 0, bottom: 0),
                                  child: Text(
                                      "Top 10 Maintenance By Agent (12 Months View)"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 0, bottom: 0),
                                  child: Text(
                                      "Top 10 Maintenance By Agent (${Constants.maintenance_formattedStartDate} to ${Constants.maintenance_formattedEndDate})"),
                                ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12, top: 4.0, right: 12, bottom: 8),
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
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 24.0),
                                            child: Text("Agent Name"),
                                          )),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0.0),
                                                  child: Text(
                                                    "Qty",
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
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: ListView.builder(
                                    padding: EdgeInsets.only(top: 0, bottom: 0),
                                    itemCount: (_selectedButton == 1)
                                        ? Constants.maintenance_salesbyagent1a
                                                    .length >
                                                10
                                            ? 10
                                            : Constants
                                                .maintenance_salesbyagent1a
                                                .length
                                        : (_selectedButton == 2)
                                            ? Constants.maintenance_salesbyagent2a
                                                        .length >
                                                    10
                                                ? 10
                                                : Constants
                                                    .maintenance_salesbyagent2a
                                                    .length
                                            : (_selectedButton == 3 &&
                                                    days_difference <= 31)
                                                ? Constants.maintenance_salesbyagent3a
                                                            .length >
                                                        10
                                                    ? 10
                                                    : Constants
                                                        .maintenance_salesbyagent3a
                                                        .length
                                                : Constants.maintenance_salesbyagent2a
                                                            .length >
                                                        10
                                                    ? 10
                                                    : Constants
                                                        .maintenance_salesbyagent2a
                                                        .length,
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
                                                    child:
                                                        Text("${index + 1} "),
                                                  ),
                                                  Expanded(
                                                      flex: 4,
                                                      child: Text((_selectedButton ==
                                                              1)
                                                          ? Constants
                                                              .maintenance_salesbyagent1a[
                                                                  index]
                                                              .agent_name
                                                          : (_selectedButton ==
                                                                  2)
                                                              ? Constants
                                                                  .maintenance_salesbyagent2a[
                                                                      index]
                                                                  .agent_name
                                                              : (_selectedButton ==
                                                                          3 &&
                                                                      days_difference <=
                                                                          31)
                                                                  ? Constants
                                                                      .maintenance_salesbyagent3a[
                                                                          index]
                                                                      .agent_name
                                                                  : Constants
                                                                      .maintenance_salesbyagent3b[
                                                                          index]
                                                                      .agent_name)),
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            child: Text(
                                                              "${formatLargeNumber3((_selectedButton == 1) ? Constants.maintenance_salesbyagent1a[index].sales.toString() : (_selectedButton == 2) ? Constants.maintenance_salesbyagent2a[index].sales.toString() : (_selectedButton == 3 && days_difference <= 31) ? Constants.maintenance_salesbyagent3a[index].sales.toString() : Constants.maintenance_salesbyagent3b[index].sales.toString())}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
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
                              ),
                            ],
                          )),
                        ),
                      ),
                      /*  _selectedButton == 1
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, top: 4, bottom: 16),
                              child: Text(
                                  "Maintenance By Type (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                            )
                          : _selectedButton == 2
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 4, bottom: 16),
                                  child: Text(
                                      "Maintenance By Type (12 Months View)"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 4, bottom: 16),
                                  child: Text(
                                      "Maintenance By Type (${Constants.maintenance_formattedStartDate} to ${Constants.maintenance_formattedEndDate})"),
                                ),

                      Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 0, bottom: 0),
                          key: key_rut1,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _selectedButton == 1
                              ? Constants.maintenance_droupedChartData1.length
                              : _selectedButton == 2
                                  ? Constants
                                      .maintenance_droupedChartData2.length
                                  : _selectedButton == 3 &&
                                          days_difference <= 31
                                      ? Constants
                                          .maintenance_droupedChartData3.length
                                      : Constants
                                          .maintenance_droupedChartData4.length,
                          itemBuilder: (context, index) {
                            MaintanaceCategory category =
                                MaintanaceCategory(name: '', items: []);
                            if (_selectedButton == 1) {
                              category = Constants
                                  .maintenance_droupedChartData1[index];
                              //  print("yuuyyu1 ${category}");
                            } else if (_selectedButton == 2) {
                              category = Constants
                                  .maintenance_droupedChartData2[index];
                              // print("yuuyyu2 ${category}");
                            } else if (_selectedButton == 3 &&
                                days_difference <= 31) {
                              category = Constants
                                  .maintenance_droupedChartData3[index];
                              //  print("yuuyyu ${category}");
                            } else {
                              category = Constants
                                  .maintenance_droupedChartData4[index];
                              // print("yuuyyu4 ${category}");
                            }

                            final totalCategoryCount = category.getTotalCount();

                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, left: 12, right: 12, bottom: 4),
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
                                          top: 0, bottom: 0, left: 8, right: 8),
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
                                        category.name
                                            .replaceAll("Self", "Main Member"),
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      children: category.items.map((item) {
                                        double percentage =
                                            item.count / totalCategoryCount;
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
                                              item.title,
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
                                                                  ? Colors.black
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
                      ),*/

                      //Text("$Constants.maxY"),
                      // Container(
                      //   height: (_selectedButton == 1
                      //           ? Constants.maintenance_salesbybranch1a.length
                      //           : _selectedButton == 2
                      //               ? Constants
                      //                   .maintenance_salesbybranch2a.length
                      //               : (_selectedButton == 3 &&
                      //                       days_difference < 32)
                      //                   ? Constants
                      //                       .maintenance_salesbybranch3a.length
                      //                   : Constants.maintenance_salesbybranch3b
                      //                       .length) *
                      //       25,
                      //   width: MediaQuery.of(context).size.width,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Card(
                      //       elevation: 6,
                      //       surfaceTintColor: Colors.white,
                      //       color: Colors.white,
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(20)),
                      //       child: Padding(
                      //         padding: const EdgeInsets.all(4.0),
                      //         child: charts.BarChart(
                      //           _selectedButton == 1
                      //               ? Constants.maintenance_bardata5a
                      //               : _selectedButton == 2
                      //                   ? Constants.maintenance_bardata5b
                      //                   : _selectedButton == 3 &&
                      //                           days_difference < 32
                      //                       ? Constants.maintenance_bardata5c
                      //                       : Constants.maintenance_bardata5d,
                      //           animate: true,
                      //           vertical: false,
                      //           // Set a bar label decorator.
                      //           // Example configuring different styles for inside/outside:
                      //           //       barRendererDecorator: new charts.BarLabelDecorator(
                      //           //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
                      //           //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
                      //           barRendererDecorator:
                      //               new charts.BarLabelDecorator<String>(),
                      //           // Hide domain axis.
                      //           /*          domainAxis: new charts.OrdinalAxisSpec(
                      //                 renderSpec: new charts.NoneRenderSpec()),*/
                      //           primaryMeasureAxis: new charts.NumericAxisSpec(
                      //             renderSpec: new charts.NoneRenderSpec(),
                      //             viewport: new charts.NumericExtents(
                      //                 0,
                      //                 _selectedButton == 1
                      //                     ? Constants.maintenance_maxY5a
                      //                     : _selectedButton == 2
                      //                         ? Constants.maintenance_maxY5b
                      //                         : _selectedButton == 3 &&
                      //                                 days_difference < 32
                      //                             ? Constants.maintenance_maxY5c
                      //                             : Constants
                      //                                 .maintenance_maxY5c),
                      //           ),
                      //           domainAxis: new charts.OrdinalAxisSpec(
                      //             renderSpec: new charts.SmallTickRendererSpec(
                      //               labelStyle: new charts.TextStyleSpec(
                      //                 fontSize: 10,
                      //                 color: charts.MaterialPalette.black,
                      //               ),
                      //               lineStyle: new charts.LineStyleSpec(
                      //                 color: charts.MaterialPalette.black,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      /*Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: charts.BarChart(
                            bardata5,
                            animate: false,
                            vertical: false,
                            barRendererDecorator: new charts.BarLabelDecorator<String>(),
                            domainAxis: new charts.OrdinalAxisSpec(
                              renderSpec: new charts.SmallTickRendererSpec(
                                labelStyle: new charts.TextStyleSpec(
                                  fontSize: 10,
                                  color: charts.MaterialPalette.black, // color for the text
                                ),
                                lineStyle: new charts.LineStyleSpec(
                                  color: charts.MaterialPalette.black, // color for the line
                                ),
                              ),
                            ),
                            // ... Other chart configurations
                          ),
                        ),*/
                      /*ListView.builder(
                          itemCount: salesbybranch.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var element = salesbybranch[index];
                            double barWidth = (element.sales.toDouble() / Constants.maxY) *
                                MediaQuery.of(context)
                                    .size
                                    .width; // Calculate bar width as a fraction of maxSales

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: barWidth, // Width of the bar
                                    height: 20, // Fixed height of the bar
                                    color: Colors.blue, // Color of the bar
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                          element.sales.toString()), // Display the value
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),*/

                      /*  Container(
                          height: barData.length * 40,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Container(
                                    height: barData.length * 30,
                                    child: RotatedBox(
                                      quarterTurns: -3,
                                      child: BarChart(
                                        BarChartData(
                                          gridData: FlGridData(
                                            show: true,
                                            drawVerticalLine: true,
                                            drawHorizontalLine: false,
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
                                          borderData: FlBorderData(
                                            show: false,
                                          ),
                                          titlesData: getTitlesData(bottomTitles1),
                                          barGroups: barData,
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        ),*/
                      /*         _selectedButton == 1
                            ? Padding(
                                padding: const EdgeInsets.only(left: 16.0, top: 12),
                                child: Text("Top 5 Sales By Branch (MTD)"),
                              )
                            : _selectedButton == 2
                                ? Padding(
                                    padding:
                                        const EdgeInsets.only(left: 16.0, top: 12),
                                    child: Text("Top 5 Sales By Branch (YTD)"),
                                  )
                                : Padding(
                                    padding:
                                        const EdgeInsets.only(left: 16.0, top: 12),
                                    child: Text(
                                        "Top 5 Sales By Branch (${formattedEndDate} to ${formattedEndDate})"),
                                  ),*/
                      /*AspectRatio(
                          aspectRatio: 1.3,
                          child: Row(
                            children: <Widget>[
                              const SizedBox(
                                height: 18,
                              ),
                              Expanded(
                                flex: 3,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: PieChart(
                                    PieChartData(
                                      pieTouchData: PieTouchData(
                                        touchCallback:
                                            (FlTouchEvent event, pieTouchResponse) {
                                          setState(() {
                                            if (!event
                                                    .isInterestedForInteractions ||
                                                pieTouchResponse == null ||
                                                pieTouchResponse.touchedSection ==
                                                    null) {
                                              touchedIndex = -1;
                                              return;
                                            }
                                            touchedIndex = pieTouchResponse
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
                                            color: Colors.grey.withOpacity(0.35),
                                            width: 1,
                                          ),
                                          right: BorderSide.none,
                                          top: BorderSide.none,
                                        ),
                                      ),
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 40,
                                      sections: pieData,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                    itemCount: salesbybranch.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      if (index < 5) {
                                        return Indicator(
                                          color: samplecolors[index],
                                          text: salesbybranch[index]
                                              .branch_name
                                              .toString(),
                                          isSquare: true,
                                        );
                                      } else
                                        Container();
                                    }),
                              ),
                              const SizedBox(
                                width: 28,
                              ),
                            ],
                          ),
                        ),*/
                      //PieChart(data)

                      /*(leads.isNotEmpty)
                            ? DataTable(
                                columns: const [
                                  DataColumn(label: Text('No.')),
                                  DataColumn(label: Text('Date & Time')),
                                  DataColumn(label: Text('Employee')),
                                  DataColumn(label: Text('Cell Number')),
                                  DataColumn(label: Text('Customer Name')),
                                  DataColumn(label: Text('Branch Type')),
                                  DataColumn(label: Text('Branch')),
                                  DataColumn(label: Text('Status')),
                                  DataColumn(label: Text('View')),
                                ],
                                rows: List<DataRow>.generate(
                                  leads.length,
                                  (index) {
                                    final lead = leads[index];

                                    return DataRow(
                                      cells: [
                                        DataCell(Text((index + 1).toString())),
                                        DataCell(Text(
                                          '${DateFormat('MMM d, yyyy').format(DateTime.parse(lead["sale_datetime"]))}',
                                        )), // Replace with date and time data
                                        DataCell(Text(getEmployeeById(
                                            int.parse(lead["assigned_to"].toString()) ??
                                                0))), // Replace with employee data
                                        DataCell(Text(lead["cell_number"] ?? '')),
                                        DataCell(Text(lead["first_name"] +
                                            " " +
                                            lead[
                                                "last_name"])), // Replace with customer name data
                                        DataCell(
                                            Text('...')), // Replace with branch type data
                                        DataCell(Text('...')), // Replace with branch data
                                        DataCell(Text('...')), // Replace with status data
                                        DataCell(
                                          IconButton(
                                            icon: Icon(Icons.visibility),
                                            onPressed: () {
                                              // handle view button pressed
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: Container(
                                height: 80,
                                width: 80,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1,
                                  valueColor:
                                      new AlwaysStoppedAnimation<Color>(Color(0xff121212)),
                                ),
                              )),*/
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

  getMood(String date) async {
    var request = http.Request(
        'GET',
        Uri.parse(
            '${Constants.insightsBaseUrl}Communication_Engine/GetStatusStats?StartDate=2023-12-11&EndDate=2023-12-11&EventId=0'));

    //request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  getMood1(String date) async {
    try {
      var headers = {
        "Accept": "application/json, text/javascript, */*; q=0.01",
        "X-Requested-With": "XMLHttpRequest",
        'Cookie':
            "userid=expiry=2023-12-28&client_modules=1001#1002#1003#1004#1005#1006#1007#1008#1009#1010#1011#1012#1013#1014#1015#1017#1018#1020#1021#1022#1024#1025#1026#1027#1028#1029#1030#1031#1032#1033#1034#1035&clientid=379&empid=9819&empfirstname=Everest&emplastname=Everest&email=Master@everestmpu.com&username=Master@everestmpu.com&dob=7/7/1990 12:00:00 AM&fullname=Everest Everest&userRole=184&userImage=Master@everestmpu.com.jpg&employedAt=head office 1&role=leader&branchid=379&jobtitle=Policy Administrator / Agent&dialing_strategy=&clientname=Everest Financial Services&foldername=&client_abbr=EV&pbx_account=&device_id=&servername=http://localhost:55661"
      };
      var request = http.get(
          Uri.parse(
              '${Constants.insightsBackendBaseUrl}hr/countUsersMoods?clientId=379&dateToday=2023-12-11'),
          headers: headers);
      request.then((response) {
        // print(request);

        if (response.statusCode == 200) {
          String responseBody = response.body.toString();

          Map<dynamic, dynamic> responseMap = jsonDecode(responseBody);

          int marker_id = 1;

          responseMap["user_moods"].forEach((value1) {
            //Map m1 = value as Map;
            List<dynamic> m1 = value1 as List<dynamic>;
            // print(m1);
          });

          setState(() {});
        } else {
          // print("fgh " + response.reasonPhrase.toString());
        }
      });
    } on Exception catch (e) {
      //print("fggg " + e.toString());
    }
  }

  @override
  void initState() {
    secureScreen();
    myNotifier = MyNotifier(maintenanceValue, context);
    maintenanceValue.addListener(() {
      key_rut1 = UniqueKey();
      // print("dfgg");
      setState(() {});
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
    Constants.maintenance_formattedStartDate =
        DateFormat('yyyy-MM-dd').format(startDate!);
    Constants.maintenance_formattedEndDate =
        DateFormat('yyyy-MM-dd').format(endDate!);
    setState(() {});

    String dateRange =
        '${Constants.maintenance_formattedStartDate} - ${Constants.maintenance_formattedEndDate}';
    //print("currently loading ${dateRange}");
    DateTime startDateTime = DateFormat('yyyy-MM-dd')
        .parse(Constants.maintenance_formattedStartDate);
    DateTime endDateTime =
        DateFormat('yyyy-MM-dd').parse(Constants.maintenance_formattedEndDate);

    days_difference = endDateTime.difference(startDateTime).inDays;
    if (kDebugMode) {
      //print("days_difference ${days_difference}");
      //print("formattedEndDate9 ${Constants.maintenance_formattedEndDate}");
    }
    restartInactivityTimer();

    setState(() {});
    // getSalesReport(context, formattedStartDate, formattedEndDate);

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
                    ? Constants
                        .maintenance_salesbybranch1a[index - 1].branch_name
                    : Constants
                        .maintenance_salesbybranch2a[index - 1].branch_name,
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
        chartHeight - (yValue / Constants.maintenance_maxY) * chartHeight;

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

class MaintanenceGraph1 extends StatefulWidget {
  const MaintanenceGraph1({super.key});

  @override
  State<MaintanenceGraph1> createState() => _MaintanenceGraph1State();
}

class _MaintanenceGraph1State extends State<MaintanenceGraph1> {
  List<FlSpot> sales_spots2a = [];
  List<FlSpot> sales_spots2b = [];
  List<FlSpot> sales_spots2c = [];
  Key sales_chartKey2a = UniqueKey();
  Key sales_chartKey2b = UniqueKey();
  Key sales_chartKey2c = UniqueKey();
  int sales_maxY2 = 0;
  bool _months12RollingswitchValue = true;
  @override
  void initState() {
    sales_spots2a = [];
    sales_spots2b = [];
    sales_spots2c = [];
    sales_chartKey2a = UniqueKey();
    sales_chartKey2b = UniqueKey();
    sales_chartKey2c = UniqueKey();
    sales_maxY2 = 0;
    getMaintanenceGraphData(
        Constants.jsonMonthlyMaintanenceData1["totals_daily"]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
              surfaceTintColor: Colors.white,
              color: Colors.white,
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: maintenance_index == 0
                      ? LineChart(
                          key: sales_chartKey2a,
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: sales_spots2a,
                                isCurved: true,
                                barWidth: 3,
                                color: Colors.grey.shade400,
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter:
                                      (spot, percent, barData, index) {
                                    // Show custom dot and text for specific x-values

                                    return FlDotCirclePainter(
                                        radius: 2,
                                        color: Colors.red,
                                        strokeColor: Colors.green);
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
                                    // Calculate the date from the day integer
                                    int daysAgo = value.toInt();
                                    DateTime thirtyDaysAgo = DateTime.now()
                                        .subtract(const Duration(days: 30));
                                    DateTime date = thirtyDaysAgo
                                        .add(Duration(days: daysAgo));

                                    // Format the date for display
                                    /*String formattedDate = DateFormat('MM/dd')
                                        .format(date); // Format as "MM/dd"*/

                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        date.day
                                            .toString(), // Displaying the formatted date
                                        style: TextStyle(fontSize: 8),
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
                                  reservedSize: 20,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      formatLargeNumber3(
                                          value.toInt().toString()),
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
                            maxY: sales_maxY2.toDouble(),
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
                        )
                      : maintenance_index == 1
                          ? LineChart(
                              key: sales_chartKey2b,
                              LineChartData(
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: sales_spots2b,
                                    isCurved: true,
                                    barWidth: 3,
                                    color: Colors.grey.shade400,
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter:
                                          (spot, percent, barData, index) {
                                        // Show custom dot and text for specific x-values

                                        return FlDotCirclePainter(
                                            radius: 2,
                                            color: Colors.red,
                                            strokeColor: Colors.green);
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
                                minX: 1,
                                maxX: 12,
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
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            getMonthAbbreviation(value.toInt()),
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
                                      reservedSize: 20,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          formatLargeNumber3(
                                              value.toInt().toString()),
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
                                maxY: sales_maxY2.toDouble(),
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
                            )
                          : LineChart(
                              key: sales_chartKey2c,
                              LineChartData(
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: sales_spots2c,
                                    isCurved: true,
                                    barWidth: 3,
                                    color: Colors.grey.shade400,
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter:
                                          (spot, percent, barData, index) {
                                        // Show custom dot and text for specific x-values

                                        return FlDotCirclePainter(
                                            radius: 2,
                                            color: Colors.red,
                                            strokeColor: Colors.green);
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
                                        return Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            getMonthAbbreviation(value.toInt()),
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
                                      reservedSize: 20,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          formatLargeNumber3(
                                              value.toInt().toString()),
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
                                maxY: sales_maxY2.toDouble(),
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
                            ))),
        ));
  }

  Future<void> getMaintanenceGraphData(jsonResponse) async {
    try {
      if (jsonResponse is! List) return;
      List<Map<String, dynamic>> sales =
          List<Map<String, dynamic>>.from(jsonResponse);

      DateTime now = DateTime.now();
      DateTime thirtyDaysAgo = now.subtract(const Duration(days: 30));

      Map<String, int> dailySalesCount = {}; // "YYYY-MM-DD": count

      for (var sale in sales) {
        DateTime saleDate = DateTime.parse(sale['sale_datetime']);
        if (saleDate.weekday == DateTime.saturday) {
          // print("date is a saturday ${sale['sale_datetime']}");
          saleDate = saleDate.add(Duration(days: 2)); // Move to Monday
        } else if (saleDate.weekday == DateTime.sunday) {
          if (kDebugMode) {
            //  print("date is a sunday ${sale['sale_datetime']}");
          }
          saleDate = saleDate.add(Duration(days: 1)); // Move to Monday
        }
        if (saleDate.isAfter(thirtyDaysAgo)) {
          String dateKey =
              "${saleDate.year}-${saleDate.month.toString().padLeft(2, '0')}-${saleDate.day.toString().padLeft(2, '0')}";

          dailySalesCount.update(dateKey, (v) => v + 1, ifAbsent: () => 1);
        }
      }

      // Convert to spots
      List<FlSpot> salesSpots = [];
      dailySalesCount.forEach((key, count) {
        DateTime date = DateTime.parse(key);

        int daysAgo = thirtyDaysAgo.difference(date).inDays.abs();
        salesSpots.add(FlSpot(daysAgo.toDouble(), count.toDouble()));
        if (count > sales_maxY2) {
          sales_maxY2 = count;
        }
      });

      // Sort the spots in reverse order (so it starts 30 days ago)
      salesSpots.sort((a, b) => b.x.compareTo(a.x));

      // Ensure we have the last 30 days
      if (salesSpots.length > 30) {
        salesSpots = salesSpots.take(30).toList();
      }

      setState(() {
        sales_spots2a = salesSpots;
        // Update maxY accordingly
      });
    } catch (exception) {
      // Handle exception
    }
  }
}

class MaintanenceGraph2 extends StatefulWidget {
  const MaintanenceGraph2({super.key});

  @override
  State<MaintanenceGraph2> createState() => _MaintanenceGraph2State();
}

class _MaintanenceGraph2State extends State<MaintanenceGraph2> {
  List<FlSpot> sales_spots2a = [];
  List<FlSpot> sales_spots2b = [];
  List<FlSpot> sales_spots2c = [];
  Key sales_chartKey2a = UniqueKey();
  Key sales_chartKey2b = UniqueKey();
  Key sales_chartKey2c = UniqueKey();
  int sales_maxY2 = 0;
  @override
  void initState() {
    sales_spots2a = [];
    sales_spots2b = [];
    sales_spots2c = [];
    sales_chartKey2a = UniqueKey();
    sales_chartKey2b = UniqueKey();
    sales_chartKey2c = UniqueKey();
    sales_maxY2 = 0;

    getMaintanenceGraphData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
              surfaceTintColor: Colors.white,
              color: Colors.white,
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: maintenance_index == 0
                      ? LineChart(
                          key: sales_chartKey2a,
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: sales_spots2a,
                                isCurved: true,
                                barWidth: 3,
                                color: Colors.grey.shade400,
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter:
                                      (spot, percent, barData, index) {
                                    // Show custom dot and text for specific x-values

                                    return FlDotCirclePainter(
                                        radius: 2,
                                        color: Colors.red,
                                        strokeColor: Colors.green);
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
                                  reservedSize: 20,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      formatLargeNumber3(
                                          value.toInt().toString()),
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
                            maxY: sales_maxY2.toDouble(),
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
                        )
                      : maintenance_index == 1
                          ? LineChart(
                              key: sales_chartKey2b,
                              LineChartData(
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: sales_spots2b,
                                    isCurved: true,
                                    barWidth: 3,
                                    color: Colors.grey.shade400,
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter:
                                          (spot, percent, barData, index) {
                                        // Show custom dot and text for specific x-values

                                        return FlDotCirclePainter(
                                            radius: 2,
                                            color: Colors.red,
                                            strokeColor: Colors.green);
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
                                minX: 1,
                                maxX: 12,
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
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            getMonthAbbreviation(value.toInt()),
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
                                      reservedSize: 20,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          formatLargeNumber3(
                                              value.toInt().toString()),
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
                                maxY: sales_maxY2.toDouble(),
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
                            )
                          : LineChart(
                              key: sales_chartKey2c,
                              LineChartData(
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: sales_spots2c,
                                    isCurved: true,
                                    barWidth: 3,
                                    color: Colors.grey.shade400,
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter:
                                          (spot, percent, barData, index) {
                                        // Show custom dot and text for specific x-values

                                        return FlDotCirclePainter(
                                            radius: 2,
                                            color: Colors.red,
                                            strokeColor: Colors.green);
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
                                        return Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            getMonthAbbreviation(value.toInt()),
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
                                      reservedSize: 20,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          formatLargeNumber3(
                                              value.toInt().toString()),
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
                                maxY: sales_maxY2.toDouble(),
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
                            ))),
        ));
  }

  Future<void> getMaintanenceGraphData() async {
    try {
      List<FlSpot> salesSpots = [];
      Map m1 = Constants.jsonMonthlyMaintanenceData2["totals_monthly"];
      //print("gffgfddf ${m1}");

      m1.forEach((key, value) {
        //print("ekey ${key}");
        //print("evalue ${value}");
        DateTime dt1 = DateTime.parse(key + "-01");
        int year = dt1.year;
        int month = dt1.month;

        if (value > sales_maxY2) {
          sales_maxY2 = value + 50;
        }
        salesSpots
            .add(FlSpot((year * 12 + month).toDouble(), value.toDouble()));
      });

      salesSpots.sort((a, b) => a.x.compareTo(b.x));
      if (salesSpots.length > 12) {
        salesSpots = salesSpots.sublist(salesSpots.length - 12);
      }
      setState(() {
        sales_spots2a = salesSpots;
        // print(sales_spots2a);
      });
    } catch (exception) {
      // Handle exception
    }
  }
}

class MaintanenceGraph3 extends StatefulWidget {
  const MaintanenceGraph3({super.key});

  @override
  State<MaintanenceGraph3> createState() => _MaintanenceGraph3State();
}

class _MaintanenceGraph3State extends State<MaintanenceGraph3> {
  List<FlSpot> sales_spots2a = [];
  List<FlSpot> sales_spots2b = [];
  List<FlSpot> sales_spots2c = [];
  Key sales_chartKey2a = UniqueKey();
  Key sales_chartKey2b = UniqueKey();
  Key sales_chartKey2c = UniqueKey();
  int maintenance_maxY2 = 0;
  @override
  void initState() {
    sales_spots2a = [];
    sales_spots2b = [];
    sales_spots2c = [];
    sales_chartKey2a = UniqueKey();
    sales_chartKey2b = UniqueKey();
    sales_chartKey2c = UniqueKey();
    maintenance_maxY2 = 0;
    getMaintenanceGraphData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return sales_spots2a.isEmpty
        ? Container(
            height: 250,
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
          )
        : Container(
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  surfaceTintColor: Colors.white,
                  color: Colors.white,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: maintenance_index == 0
                          ? LineChart(
                              key: sales_chartKey2a,
                              LineChartData(
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: sales_spots2a,
                                    isCurved: true,
                                    barWidth: 3,
                                    color: Colors.grey.shade400,
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter:
                                          (spot, percent, barData, index) {
                                        // Show custom dot and text for specific x-values

                                        return FlDotCirclePainter(
                                            radius: 2,
                                            color: Colors.red,
                                            strokeColor: Colors.green);
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
                                        // Calculate the date from the x-value
                                        int daysSinceStart = value.toInt();
                                        DateTime startDate = DateFormat(
                                                'yyyy-MM-dd')
                                            .parse(Constants
                                                .maintenance_formattedStartDate);
                                        DateTime date = startDate.add(
                                            Duration(days: daysSinceStart));

                                        // Format the date for display
                                        String formattedDate =
                                            DateFormat('MM/dd').format(
                                                date); // Format as "MM/dd"

                                        return Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            date.day
                                                .toString(), // Displaying the formatted date
                                            style: TextStyle(fontSize: 8),
                                          ),
                                        );
                                      },
                                    ),
                                    axisNameWidget: Padding(
                                      padding: const EdgeInsets.only(top: 0.0),
                                      child: Text(
                                        'Date',
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
                                      reservedSize: 20,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          formatLargeNumber3(
                                              value.toInt().toString()),
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
                                maxY: maintenance_maxY2.toDouble(),
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
                            )
                          : maintenance_index == 1
                              ? LineChart(
                                  key: sales_chartKey2b,
                                  LineChartData(
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: sales_spots2b,
                                        isCurved: true,
                                        barWidth: 3,
                                        color: Colors.grey.shade400,
                                        dotData: FlDotData(
                                          show: true,
                                          getDotPainter:
                                              (spot, percent, barData, index) {
                                            // Show custom dot and text for specific x-values

                                            return FlDotCirclePainter(
                                                radius: 2,
                                                color: Colors.red,
                                                strokeColor: Colors.green);
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
                                    minX: 1,
                                    maxX: 12,
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
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(
                                                getMonthAbbreviation(
                                                    value.toInt()),
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            );
                                          },
                                        ),
                                        axisNameWidget: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0.0),
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
                                            return Text(
                                                value.toInt().toString());
                                          },
                                        ),
                                      ),
                                      rightTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                          getTitlesWidget: (value, meta) {
                                            return Text(
                                                value.toInt().toString());
                                          },
                                        ),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 20,
                                          getTitlesWidget: (value, meta) {
                                            return Text(
                                              formatLargeNumber3(
                                                  value.toInt().toString()),
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
                                    maxY: maintenance_maxY2.toDouble(),
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
                                )
                              : LineChart(
                                  key: sales_chartKey2c,
                                  LineChartData(
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: sales_spots2c,
                                        isCurved: true,
                                        barWidth: 3,
                                        color: Colors.grey.shade400,
                                        dotData: FlDotData(
                                          show: true,
                                          getDotPainter:
                                              (spot, percent, barData, index) {
                                            // Show custom dot and text for specific x-values

                                            return FlDotCirclePainter(
                                                radius: 2,
                                                color: Colors.red,
                                                strokeColor: Colors.green);
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
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(
                                                getMonthAbbreviation(
                                                    value.toInt()),
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            );
                                          },
                                        ),
                                        axisNameWidget: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0.0),
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
                                            return Text(
                                                value.toInt().toString());
                                          },
                                        ),
                                      ),
                                      rightTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                          getTitlesWidget: (value, meta) {
                                            return Text(
                                                value.toInt().toString());
                                          },
                                        ),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 20,
                                          getTitlesWidget: (value, meta) {
                                            return Text(
                                              formatLargeNumber3(
                                                  value.toInt().toString()),
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
                                    maxY: maintenance_maxY2.toDouble(),
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
                                ))),
            ));
  }

  Future<void> getMaintenanceGraphData() async {
    // print("gffvalue");
    try {
      String baseUrl =
          "${Constants.insightsBackendBaseUrl}files/get_maintenance_data/";
      Map<String, String>? payload = {
        "client_id": Constants.cec_client_id.toString(),
        "start_date": Constants.maintenance_formattedStartDate,
        "end_date": Constants.maintenance_formattedEndDate
      };

      await http.post(Uri.parse(baseUrl), body: payload, headers: {
        // Your headers
      }).then((value) {
        //print("gffvalue${value}");
        http.Response response = value;
        var jsonResponse = jsonDecode(response.body);

        List<FlSpot> maintenanceSpots = [];
        Map m1 = jsonResponse["totals_daily"];
        //print("gffgfddf ${m1}");

        // Determine the start date from the maintenance data
        DateTime startDate = DateFormat('yyyy-MM-dd')
            .parse(Constants.maintenance_formattedStartDate);

        m1.forEach((key, value) {
          DateTime date = DateTime.parse(key);
          int daysSinceStart = startDate.difference(date).inDays.abs();
          maintenanceSpots
              .add(FlSpot(daysSinceStart.toDouble(), value.toDouble()));
          if (value > maintenance_maxY2) {
            maintenance_maxY2 = value;
          }
        });

        // Sort the spots by x-value (days since start)
        maintenanceSpots.sort((a, b) => a.x.compareTo(b.x));

        setState(() {
          sales_spots2a = maintenanceSpots;
          // Update maxY accordingly
        });
      });
    } catch (exception) {
      // Handle exception
      print("Error in getMaintenanceGraphData: $exception");
    }
  }
}

class MaintanenceGraph4 extends StatefulWidget {
  const MaintanenceGraph4({super.key});

  @override
  State<MaintanenceGraph4> createState() => _MaintanenceGraph4State();
}

class _MaintanenceGraph4State extends State<MaintanenceGraph4> {
  List<FlSpot> sales_spots2a = [];
  List<FlSpot> sales_spots2b = [];
  List<FlSpot> sales_spots2c = [];
  Key sales_chartKey2a = UniqueKey();
  Key sales_chartKey2b = UniqueKey();
  Key sales_chartKey2c = UniqueKey();
  int sales_maxY2 = 0;
  @override
  void initState() {
    sales_spots2a = [];
    sales_spots2b = [];
    sales_spots2c = [];
    sales_chartKey2a = UniqueKey();
    sales_chartKey2b = UniqueKey();
    sales_chartKey2c = UniqueKey();
    sales_maxY2 = 0;
    myNotifier = MyNotifier(maint4, context);
    maint4.addListener(() {
      setState(() {});
      Future.delayed(Duration(seconds: 2)).then((value) {
        //  print("ghjg");
        setState(() {});
      });
    });
    getMaintanenceGraphData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
              surfaceTintColor: Colors.white,
              color: Colors.white,
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: maintenance_index == 0
                      ? LineChart(
                          key: sales_chartKey2a,
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: sales_spots2a,
                                isCurved: true,
                                barWidth: 3,
                                color: Colors.grey.shade400,
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter:
                                      (spot, percent, barData, index) {
                                    // Show custom dot and text for specific x-values

                                    return FlDotCirclePainter(
                                        radius: 2,
                                        color: Colors.red,
                                        strokeColor: Colors.green);
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
                                    'Days of the month',
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
                                  reservedSize: 20,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      formatLargeNumber3(
                                          value.toInt().toString()),
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
                            maxY: sales_maxY2.toDouble(),
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
                        )
                      : maintenance_index == 1
                          ? LineChart(
                              key: sales_chartKey2b,
                              LineChartData(
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: sales_spots2b,
                                    isCurved: true,
                                    barWidth: 3,
                                    color: Colors.grey.shade400,
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter:
                                          (spot, percent, barData, index) {
                                        // Show custom dot and text for specific x-values

                                        return FlDotCirclePainter(
                                            radius: 2,
                                            color: Colors.red,
                                            strokeColor: Colors.green);
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
                                minX: 1,
                                maxX: 12,
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
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            getMonthAbbreviation(value.toInt()),
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
                                      reservedSize: 20,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          formatLargeNumber3(
                                              value.toInt().toString()),
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
                                maxY: sales_maxY2.toDouble(),
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
                            )
                          : LineChart(
                              key: sales_chartKey2c,
                              LineChartData(
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: sales_spots2c,
                                    isCurved: true,
                                    barWidth: 3,
                                    color: Colors.grey.shade400,
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter:
                                          (spot, percent, barData, index) {
                                        // Show custom dot and text for specific x-values

                                        return FlDotCirclePainter(
                                            radius: 2,
                                            color: Colors.red,
                                            strokeColor: Colors.green);
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
                                        return Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            getMonthAbbreviation(value.toInt()),
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
                                      reservedSize: 20,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          formatLargeNumber3(
                                              value.toInt().toString()),
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
                                maxY: sales_maxY2.toDouble(),
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
                            ))),
        ));
  }

  Future<void> getMaintanenceGraphData() async {
    try {
      String baseUrl =
          "${Constants.insightsBackendBaseUrl}files/get_maintenance_data/";
      Map<String, String>? payload = {
        "client_id": Constants.cec_client_id.toString(),
        "start_date": Constants.maintenance_formattedStartDate,
        "end_date": Constants.maintenance_formattedEndDate
      };
      await http
          .post(
        Uri.parse(
          baseUrl,
        ),
        body: payload,
      )
          .then((value) {
        //print("gffvalue${value}");
        http.Response response = value;
        var jsonResponse = jsonDecode(response.body);

        List<FlSpot> salesSpots = [];
        Map m1 = jsonResponse["totals_monthly"];
        //print("gffgfddf ${m1}");

        m1.forEach((key, value) {
          //print("ekeyhhgg ${key}");
          //print("evaluehghg ${value}");
          DateTime dt1 = DateTime.parse(key + "-01");
          int year = dt1.year;
          int month = dt1.month;

          if (value > sales_maxY2) {
            sales_maxY2 = value + 50;
          }
          salesSpots
              .add(FlSpot((year * 12 + month).toDouble(), value.toDouble()));
        });

        salesSpots.sort((a, b) => a.x.compareTo(b.x));
        if (salesSpots.length > 12) {
          salesSpots = salesSpots.sublist(salesSpots.length - 12);
        }
        setState(() {
          sales_spots2a = salesSpots;
          //print(sales_spots2a);
        });
      });
    } catch (exception) {
      // Handle exception
    }
  }
}
