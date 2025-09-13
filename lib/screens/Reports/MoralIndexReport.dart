import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mi_insights/constants/Constants.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../admin/ClientSearchPage.dart';
import '../../customwidgets/CustomCard.dart';
import '../../customwidgets/custom_date_range_picker.dart';
import '../../models/MoraleIndexCategory.dart';
import '../../services/MyNoyifier.dart';
import '../../services/inactivitylogoutmixin.dart';
import '../../services/moral_index_service.dart';
import '../../services/window_manager.dart';

int noOfDaysThisMonth = 30;
bool isLoading = false;
final moraleValue = ValueNotifier<int>(0);
double totalAmount = 0;
MyNotifier? myNotifier;
DateTime datefrom = DateTime.now().subtract(Duration(days: 60));
DateTime dateto = DateTime.now();
int days_difference = 0;

int report_index = 0;
int target_index = 0;
int moral_index_index = 0;
String data2 = "";
List<MoraleIndexCategory> morale_list = [];
int touchedIndex = -1;
UniqueKey keytttr = UniqueKey();

class MoraleIndexReport extends StatefulWidget {
  const MoraleIndexReport({Key? key}) : super(key: key);

  @override
  State<MoraleIndexReport> createState() => _MoraleIndexReportState();
}

List<Map<String, dynamic>> leads = [];
List<List<Map<String, dynamic>>> policies = [];
double _sliderPosition = 0.0;
int _selectedButton = 1;
double _sliderPosition2 = 1;

class _MoraleIndexReportState extends State<MoraleIndexReport>
    with InactivityLogoutMixin {
  Color _button1Color = Colors.grey.withOpacity(0.0);
  Color _button2Color = Colors.grey.withOpacity(0.0);
  Color _button3Color = Colors.grey.withOpacity(0.0);
  bool _searchingPolicy = false;
  TextEditingController _searchContoller = TextEditingController();

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
      Constants.moral_index_formattedStartDate = formattedStartDate;
      Constants.moral_index_formattedEndDate = formattedEndDate;

      // Call getMoralIndexReport
      getMoralIndexReport(
              formattedStartDate, formattedEndDate, buttonNumber, context)
          .then((value) {
        if (mounted)
          setState(() {
            isLoading = false;
          });
      }).catchError((error) {
        if (kDebugMode) {
          print("❌ Error in _animateButton getMoralIndexReport: $error");
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

          Constants.moral_index_formattedStartDate =
              DateFormat('yyyy-MM-dd').format(startDate!);
          Constants.moral_index_formattedEndDate =
              DateFormat('yyyy-MM-dd').format(endDate!);
          setState(() {});

          String dateRange =
              '${Constants.moral_index_formattedStartDate} - ${Constants.moral_index_formattedEndDate}';
          print("currently loading ${dateRange}");
          DateTime startDateTime = DateFormat('yyyy-MM-dd')
              .parse(Constants.moral_index_formattedStartDate);
          DateTime endDateTime = DateFormat('yyyy-MM-dd')
              .parse(Constants.moral_index_formattedEndDate);

          days_difference = endDateTime.difference(startDateTime).inDays;
          if (kDebugMode) {
            print("days_difference ${days_difference}");
            print(
                "formattedEndDate9fgfg ${Constants.moral_index_formattedEndDate}");
          }
          restartInactivityTimer();
          getMoralIndexReport(Constants.moral_index_formattedStartDate,
              Constants.moral_index_formattedEndDate, 3, context);
          isLoading = true;
          setState(() {});
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
              backgroundColor: Colors.white,
              centerTitle: true,
              surfaceTintColor: Colors.white,
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
                                          _animateButton(1);
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
              shadowColor: Colors.black.withOpacity(0.6),
              title: const Text(
                "Current Mood Index",
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
                                          style: TextStyle(color: Colors.black),
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
                        child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification is ScrollStartNotification ||
                            scrollNotification is ScrollUpdateNotification) {
                          Constants.inactivityTimer =
                              Timer(const Duration(minutes: 3), () => {});
                        }
                        return true; // Return true to indicate the notification is handled
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /* SizedBox(
                            height: 12,
                          ),*/
                          /*   Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 8.0, bottom: 0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color(0xff44556a)),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "Privacy and Comfort",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "This view is availed exclusively to Senior Executives as it is important that employee’s privacy when they share their mood is kept confidential to encourage authentic inputs.",
                                        style: TextStyle(
                                            fontSize: 12.5,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),*/

                          /*   if (!isLoading)
                            SizedBox(
                              height: 12,
                            ),
*/
                          SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
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
                              itemCount: _selectedButton == 1
                                  ? Constants.moral_index_sectionsList1a.length
                                  : _selectedButton == 2
                                      ? Constants
                                          .moral_index_sectionsList2a.length
                                      : _selectedButton == 3 &&
                                              days_difference <= 31
                                          ? Constants
                                              .moral_index_sectionsList3a.length
                                          : Constants.moral_index_sectionsList3b
                                              .length,
                              padding: EdgeInsets.all(2.0),
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                    onTap: () {},
                                    child: Container(
                                      height: 290,
                                      width: MediaQuery.of(context).size.width /
                                          2.9,
                                      child: Stack(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              restartInactivityTimer();
                                              // moral_index_index = index;
                                              setState(() {});
                                              if (kDebugMode) {
                                                print("moral_index_index " +
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
                                                                        child:
                                                                            Text(
                                                                          formatLargeNumber3((_selectedButton == 1
                                                                                  ? Constants.moral_index_sectionsList1a[index].amount
                                                                                  : _selectedButton == 2
                                                                                      ? Constants.moral_index_sectionsList2a[index].amount
                                                                                      : _selectedButton == 3 && days_difference <= 31
                                                                                          ? Constants.moral_index_sectionsList3a[index].amount
                                                                                          : Constants.moral_index_sectionsList3b[index].amount)
                                                                              .toString()),
                                                                          style: TextStyle(
                                                                              fontSize: 18.5,
                                                                              fontWeight: FontWeight.w500),
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
                                                                        _selectedButton ==
                                                                                1
                                                                            ? Constants.moral_index_sectionsList1a[index].id
                                                                            : _selectedButton == 2
                                                                                ? Constants.moral_index_sectionsList2a[index].id
                                                                                : _selectedButton == 3 && days_difference <= 31
                                                                                    ? Constants.moral_index_sectionsList3a[index].id
                                                                                    : Constants.moral_index_sectionsList3b[index].id,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12.5),
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
                          SizedBox(
                            height: 8,
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
                                              left: 16.0, right: 16, bottom: 8),
                                          child: Text(
                                              "Attrition Rate (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
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
                                                "Attrition Rate (12 Months View)"),
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
                                                  "Attrition Rate (${Constants.sales_formattedStartDate} to ${Constants.sales_formattedEndDate})"),
                                            ),
                                          )
                                        ],
                                      )),

                          Padding(
                            padding: const EdgeInsets.only(left: 6.0, right: 6),
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

                          //Text(morale_list.length.toString()),
                          if (morale_list.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              key: keytttr,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: morale_list.length,
                              itemBuilder: (context, index) {
                                MoraleIndexCategory category =
                                    MoraleIndexCategory(name: '', items: []);
                                category = morale_list[index];

                                final totalCategoryCount =
                                    category.getTotalCount();

                                return Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(17),
                                        border: Border.all(
                                            color:
                                                Colors.grey.withOpacity(0.1))),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16.5),
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
                                                                    .toString()) +
                                                            "%",
                                                        style: TextStyle(
                                                            fontSize: 11,
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
                                                      BorderRadius.circular(
                                                          16)),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          title: Text(
                                            category.name.replaceAll(
                                                "Self", "Main Member"),
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
                                                    horizontal: 0,
                                                    vertical: -4),
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
                                                  style:
                                                      TextStyle(fontSize: 14),
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
                                                                  Colors.blue),
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
                                                                      .toString()) +
                                                                  "%",
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
                          SizedBox(
                            height: 0,
                          ),
                          SizedBox(
                            height: 4,
                          ),

                          _selectedButton == 1
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 24),
                                  child: Text(
                                      "Morale Index By Mood Type (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                )
                              : _selectedButton == 2
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, top: 24),
                                      child: Text(
                                          "Morale Index By Mood Type (YTD - ${DateTime.now().year})"),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, top: 24),
                                      child: Text(
                                          "Morale Index By Mood Type (${Constants.moral_index_formattedStartDate} to ${Constants.moral_index_formattedEndDate})"),
                                    ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16),
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
                                                      BorderRadius.circular(
                                                          360)),
                                              height: 35,
                                              child: Center(
                                                child: Text(
                                                  'Overview',
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
                                                      BorderRadius.circular(
                                                          360)),
                                              child: Center(
                                                child: Text(
                                                  '${_selectedButton == 1 ? "Daily View" : _selectedButton == 2 ? "Monthly View" : "Date Range"}',
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
                                                BorderRadius.circular(12),
                                          ),
                                          child: target_index == 0
                                              ? Center(
                                                  child: Text(
                                                    'Overview',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              : target_index == 1
                                                  ? Center(
                                                      child: Text(
                                                        '${_selectedButton == 1 ? "Daily View" : _selectedButton == 2 ? "Monthly View" : "Date Range"}',
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
                          SizedBox(
                            height: 8,
                          ),
                          if (target_index == 0)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16, top: 12, bottom: 8),
                              child: CustomCard(
                                  elevation: 6,
                                  surfaceTintColor: Colors.white,
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 12),
                                      Container(
                                        key: Constants.moral_index_chartKey3a,
                                        height: 250,
                                        child: Row(children: <Widget>[
                                          const SizedBox(
                                            height: 18,
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: PieChart(
                                              PieChartData(
                                                pieTouchData: PieTouchData(
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
                                                          .withOpacity(0.35),
                                                      width: 1,
                                                    ),
                                                    right: BorderSide.none,
                                                    top: BorderSide.none,
                                                  ),
                                                ),
                                                sectionsSpace: 0,
                                                centerSpaceRadius: 70,
                                                sections: _selectedButton == 1
                                                    ? Constants
                                                        .moral_index_pieData_1
                                                    : _selectedButton == 2
                                                        ? Constants
                                                            .moral_index_pieData_2
                                                        : _selectedButton ==
                                                                    3 &&
                                                                days_difference <=
                                                                    31
                                                            ? Constants
                                                                .moral_index_pieData_3
                                                            : Constants
                                                                .moral_index_pieData_4,
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                      Row(
                                        children: [
                                          Spacer(),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(360),
                                              color: Colors.green,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Text("Happy",
                                              style: TextStyle(fontSize: 11)),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(360),
                                              color: Colors.blue,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Text("Unsure",
                                              style: TextStyle(fontSize: 11)),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(360),
                                              color: Colors.red,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Text("Sad"),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8, top: 8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            // color: Color(0xff44556a)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0,
                                                right: 12,
                                                bottom: 24,
                                                top: 4),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0,
                                                          right: 16,
                                                          top: 0,
                                                          bottom: 12),
                                                  child: Container(
                                                    height: 1,
                                                    color: Colors.grey
                                                        .withOpacity(0.35),
                                                  ),
                                                ),
                                                Text(
                                                  "Positive Mood and Cognitive Abilities",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8,
                                                          bottom: 0,
                                                          top: 12),
                                                  child: Text(
                                                    "Positive mood has been associated with enhanced cognitive abilities such as creativity, problem-solving, & decision-making.",
                                                    style: TextStyle(
                                                        fontSize: 12.5,
                                                        color: Colors.black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          if (target_index == 0)
                            SizedBox(
                              height: 24,
                            ),

                          if (target_index == 1)
                            _selectedButton == 1
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(
                                        "Morale Index Overview (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                  )
                                : _selectedButton == 2
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Text(
                                            "Morale Index Overview (YTD - 12 Months View)"),
                                      )
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Text(
                                            "Morale Index Overview (${Constants.moral_index_formattedStartDate} to ${Constants.moral_index_formattedEndDate})"),
                                      ),

                          if (target_index == 1)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16, top: 8, bottom: 8),
                              child: CustomCard(
                                  elevation: 6,
                                  surfaceTintColor: Colors.white,
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      isLoading == false
                                          ? _selectedButton == 1
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
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
                                                              barsSpace = 1.0 *
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
                                                                            value.toInt().toString(),
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
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Text(
                                                                            'Days of the month',
                                                                            style: TextStyle(
                                                                                fontSize: 11,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ],
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
                                                                          25,
                                                                      getTitlesWidget:
                                                                          (value,
                                                                              meta) {
                                                                        return Text(
                                                                          formatLargeNumber2(value.toInt().toString()) +
                                                                              "%",
                                                                          style:
                                                                              TextStyle(fontSize: 6.5),
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
                                                )
                                              : _selectedButton == 2
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
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
                                                                  1.2 *
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
                                                                            int actualMonth =
                                                                                (DateTime.now().month + value.toInt() - 1) % 12 + 1;
                                                                            return Padding(
                                                                              padding: const EdgeInsets.all(0.0),
                                                                              child: Text(
                                                                                getMonthAbbreviation(actualMonth).toString(),
                                                                                style: TextStyle(fontSize: 9.5),
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
                                                                              25,
                                                                          getTitlesWidget:
                                                                              (value, meta) {
                                                                            return Text(
                                                                              formatLargeNumber2(value.toInt().toString()) + "%",
                                                                              style: TextStyle(fontSize: 6.5),
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
                                                    )
                                                  : _selectedButton == 3 &&
                                                          days_difference <= 31
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Container(
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
                                                                        2.5 *
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
                                                                                getTitlesWidget: (value, meta) {
                                                                                  return Padding(
                                                                                    padding: const EdgeInsets.all(2.0),
                                                                                    child: Text(
                                                                                      "${value.round()}",
                                                                                      style: TextStyle(fontSize: 7.5),
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
                                                                                showTitles: false,
                                                                                getTitlesWidget: (value, meta) {
                                                                                  return Text(value.toInt().toString());
                                                                                },
                                                                              ),
                                                                            ),
                                                                            leftTitles:
                                                                                AxisTitles(
                                                                              sideTitles: SideTitles(
                                                                                showTitles: true,
                                                                                reservedSize: 25,
                                                                                getTitlesWidget: (value, meta) {
                                                                                  return Text(
                                                                                    formatLargeNumber2(value.toInt().toString()) + "%",
                                                                                    style: TextStyle(fontSize: 6.5),
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
                                                      : _selectedButton == 3 &&
                                                              days_difference >
                                                                  31
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  AspectRatio(
                                                                aspectRatio:
                                                                    1.7,
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
                                                                                    int actualMonth = (DateTime.parse(Constants.moral_index_formattedStartDate).month + value.toInt() - 1) % 12 + 1;
                                                                                    return Padding(
                                                                                      padding: const EdgeInsets.all(0.0),
                                                                                      child: Text(
                                                                                        getMonthAbbreviation(actualMonth).toString(),
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
                                                                                  reservedSize: 25,
                                                                                  getTitlesWidget: (value, meta) {
                                                                                    return Text(
                                                                                      formatLargeNumber2(value.toInt().toString()) + "%",
                                                                                      style: TextStyle(fontSize: 6.5),
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
                                                                                barChartData4,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : Container()
                                          : Center(
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
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8),
                                        child: Row(
                                          children: [
                                            Spacer(),
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(360),
                                                color: Colors.green,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Text(
                                              "Happy",
                                              style: TextStyle(fontSize: 11),
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(360),
                                                color: Colors.blue,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Text("Unsure",
                                                style: TextStyle(fontSize: 11)),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(360),
                                                color: Colors.red,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Text("Sad"),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            // color: Color(0xff44556a)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Collaboration and Team Dynamics",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 8.0,
                                                  ),
                                                  child: Text(
                                                    "Positive mood can contribute to a positive work environment, fostering better collaboration and teamwork. When team members are in a good mood, communication tends to be more effective, and collaboration can be more successful.",
                                                    style: TextStyle(
                                                        fontSize: 12.5,
                                                        color: Colors.black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),

                          _selectedButton == 1
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 12, bottom: 4),
                                  child: Text(
                                      "Morale Index By Employee (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                )
                              : _selectedButton == 2
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, top: 12, bottom: 4),
                                      child: Text(
                                          "Morale Index By Mood Type (YTD - 12 Months View)"),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, top: 12, bottom: 4),
                                      child: Text(
                                          "Morale Index By Employee (${Constants.moral_index_formattedStartDate} to ${Constants.moral_index_formattedEndDate})"),
                                    ),

                          Padding(
                            padding: EdgeInsets.only(left: 16.0, right: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 0, right: 8, top: 4, bottom: 4),
                                    child: Container(
                                      height: 40,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(360),
                                        child: Material(
                                          elevation: 10,
                                          child: TextFormField(
                                            autofocus: false,
                                            onChanged: (val) {
                                              searchEmployee(
                                                val,
                                              );
                                            },
                                            decoration: InputDecoration(
                                              suffixIcon: InkWell(
                                                onTap: () {
                                                  // _searchingPolicy = true;
                                                  restartInactivityTimer();
                                                  //  isLoading = true;
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  height: 35,
                                                  width: 70,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 0.0,
                                                            bottom: 0.0,
                                                            right: 0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Constants
                                                              .ctaColorLight,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      360)),
                                                      child: Center(
                                                        child: Text(
                                                          "Search",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              hintText:
                                                  'Search morale by employee',
                                              hintStyle: GoogleFonts.inter(
                                                textStyle: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                    letterSpacing: 0,
                                                    fontWeight:
                                                        FontWeight.normal),
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

                          SizedBox(
                            height: 24,
                          ),
                          /* _selectedButton == 1
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(
                                      "Morale Index By Department (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                                )
                              : _selectedButton == 2
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Text(
                                          "Morale Index By Department (YTD - ${DateTime.now().year})"),
                                    )
                                  : Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Text(
                                          "Morale Index By Department (${Constants.moral_index_formattedStartDate} to ${Constants.moral_index_formattedEndDate})"),
                                    ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                                elevation: 6,
                                surfaceTintColor: Colors.white,
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    isLoading == false
                                        ? _selectedButton == 1
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
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
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Text(
                                                                          'Days of the month',
                                                                          style: TextStyle(
                                                                              fontSize: 11,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ],
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
                                                                        25,
                                                                    getTitlesWidget:
                                                                        (value,
                                                                            meta) {
                                                                      return Text(
                                                                        formatLargeNumber2(value.toInt().toString()) +
                                                                            "%",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                6.5),
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
                                              )
                                            : _selectedButton == 2
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
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
                                                                1.2 *
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
                                                  )
                                                : _selectedButton == 3 &&
                                                        days_difference <= 31
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Container(
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
                                                                      2.5 *
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
                                                                              getTitlesWidget: (value, meta) {
                                                                                // Convert the day difference back to a date
                                                                                DateTime date = DateTime.parse(Constants.moral_index_formattedStartDate).add(Duration(days: value.toInt()));
                                                                                String monthAbbreviation = getMonthAbbreviation(date.month);
                                                                                String year = date.year.toString();

                                                                                return Padding(
                                                                                  padding: const EdgeInsets.all(2.0),
                                                                                  child: Text(
                                                                                    "${date.day}", // Displaying month and year
                                                                                    style: TextStyle(fontSize: 7.5),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                            axisNameWidget:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(top: 0.0),
                                                                              child: Text(
                                                                                'Days of the month1',
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
                                                                              reservedSize: 20,
                                                                              getTitlesWidget: (value, meta) {
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
                                                                    .all(8.0),
                                                            child: AspectRatio(
                                                              aspectRatio: 1.7,
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
                                                                                showTitles: false,
                                                                                getTitlesWidget: (value, meta) {
                                                                                  return Text(value.toInt().toString());
                                                                                },
                                                                              ),
                                                                            ),
                                                                            leftTitles:
                                                                                AxisTitles(
                                                                              sideTitles: SideTitles(
                                                                                showTitles: true,
                                                                                reservedSize: 20,
                                                                                getTitlesWidget: (value, meta) {
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
                                                                              barChartData2,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Container()
                                        : Center(
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
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8),
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(360),
                                              color: Colors.green,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Text(
                                            "Happy",
                                            style: TextStyle(fontSize: 11),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(360),
                                              color: Colors.blue,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Text("Unsure",
                                              style: TextStyle(fontSize: 11)),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(360),
                                              color: Colors.red,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Text("Sad"),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          // color: Color(0xff44556a)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Collaboration and Team Dynamics",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                ),
                                                child: Text(
                                                  "Positive mood can contribute to a positive work environment, fostering better collaboration and teamwork. When team members are in a good mood, communication tends to be more effective, and collaboration can be more successful.",
                                                  style: TextStyle(
                                                      fontSize: 12.5,
                                                      color: Colors.black),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),*/

                          /* Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _selectedButton == 1
                                  ? Constants
                                      .moral_index_groupedChartData1.length
                                  : _selectedButton == 2
                                      ? Constants
                                          .moral_index_droupedChartData2.length
                                      : _selectedButton == 3 &&
                                              days_difference <= 3
                                          ? Constants
                                              .moral_index_droupedChartData3
                                              .length
                                          : Constants
                                              .moral_index_droupedChartData4
                                              .length,
                              itemBuilder: (context, index) {
                                MoraleIndexCategory category =
                                    MoraleIndexCategory(name: '', items: []);
                                if (_selectedButton == 1) {
                                  category = Constants
                                      .moral_index_groupedChartData1[index];
                                } else if (_selectedButton == 2) {
                                  category = Constants
                                      .moral_index_droupedChartData2[index];
                                } else if (_selectedButton == 3 &&
                                    days_difference <= 31) {
                                  category = Constants
                                      .moral_index_droupedChartData3[index];
                                } else {
                                  category = Constants
                                      .moral_index_droupedChartData4[index];
                                }

                                final totalCategoryCount =
                                    category.getTotalCount();

                                return Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(17),
                                        border: Border.all(
                                            color:
                                                Colors.grey.withOpacity(0.1))),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16.5),
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
                                                      BorderRadius.circular(
                                                          16)),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          title: Text(
                                            category.name.replaceAll(
                                                "Self", "Main Member"),
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
                                                    horizontal: 0,
                                                    vertical: -4),
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
                                                  style:
                                                      TextStyle(fontSize: 14),
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
                          ),*/

                          SizedBox(height: 24),
                        ],
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  getMood(String date) async {
    var headers = {
      'Cookie':
          'userid=expiry=2023-12-28&client_modules=1001#1002#1003#1004#1005#1006#1007#1008#1009#1010#1011#1012#1013#1014#1015#1017#1018#1020#1021#1022#1024#1025#1026#1027#1028#1029#1030#1031#1032#1033#1034#1035&clientid=379&empid=9819&empfirstname=Everest&emplastname=Everest&email=Master@everestmpu.com&username=Master@everestmpu.com&dob=7/7/1990 12:00:00 AM&fullname=Everest Everest&userRole=184&userImage=Master@everestmpu.com.jpg&employedAt=head office 1&role=leader&branchid=379&jobtitle=Policy Administrator / Agent&dialing_strategy=&clientname=Everest Financial Services&foldername=&client_abbr=EV&pbx_account=&device_id=&servername=http://localhost:55661'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${Constants.insightsBackendBaseUrl}Communication_Engine/GetStatusStats?StartDate=2023-12-11&EndDate=2023-12-11&EventId=0'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
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
        print(request);

        if (response.statusCode == 200) {
          String responseBody = response.body.toString();

          Map<dynamic, dynamic> responseMap = jsonDecode(responseBody);

          int marker_id = 1;

          responseMap["user_moods"].forEach((value1) {
            //Map m1 = value as Map;
            List<dynamic> m1 = value1 as List<dynamic>;
            print(m1);
          });

          setState(() {});
        } else {
          print("fgh " + response.reasonPhrase.toString());
        }
      });
    } on Exception catch (e) {
      print("fggg " + e.toString());
    }
  }

  @override
  void initState() {
    secureScreen();
    startInactivityTimer();
    morale_list = [];
    myNotifier = MyNotifier(moraleValue, context);
    moraleValue.addListener(() {
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
    Constants.moral_index_formattedStartDate =
        DateFormat('yyyy-MM-dd').format(startDate!);
    Constants.moral_index_formattedEndDate =
        DateFormat('yyyy-MM-dd').format(endDate!);
    setState(() {});

    String dateRange =
        '${Constants.moral_index_formattedStartDate} - ${Constants.moral_index_formattedEndDate}';
    print("currently loading ${dateRange}");
    DateTime startDateTime = DateFormat('yyyy-MM-dd')
        .parse(Constants.moral_index_formattedStartDate);
    DateTime endDateTime =
        DateFormat('yyyy-MM-dd').parse(Constants.moral_index_formattedEndDate);

    days_difference = endDateTime.difference(startDateTime).inDays;
    if (kDebugMode) {
      print("days_difference ${days_difference}");
      print("formattedEndDate9 ${Constants.moral_index_formattedEndDate}");
    }

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
                        .moral_index_salesbybranch1a[index - 1].branch_name
                    : Constants
                        .moral_index_salesbybranch2a[index - 1].branch_name,
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

  void searchEmployee(String searchValue) {
    List<MoraleIndexCategory> searchItems = [];
    if (searchValue.isEmpty) {
      morale_list = [];
      setState(() {});
    } else {
      morale_list = [];
      setState(() {});

      if (_selectedButton == 1) {
        searchItems = Constants.moral_index_groupedChartData1;
      } else if (_selectedButton == 2) {
        searchItems =
            Constants.moral_index_droupedChartData2; // Fixed typo here
      } else if (_selectedButton == 3 && days_difference <= 31) {
        searchItems = Constants.moral_index_droupedChartData3;
      } else {
        searchItems = Constants.moral_index_droupedChartData3;
      }
      searchItems.forEach((element) {
        print("searchItem0 ${searchValue} ${element.name}");
      });
      var filteredItems = searchItems
          .where((item) =>
              item.name.toLowerCase().contains(searchValue.toLowerCase()))
          .toList();
      morale_list = filteredItems;

      // for (var category in searchItems) {
      //
      //
      //
      //   if (filteredItems.isNotEmpty) {
      //     if (kDebugMode) {
      //       print("searchItems ${filteredItems.length}");
      //     }
      //     morale_list.add(
      //         MoraleIndexCategory(name: category.name, items: filteredItems));
      //   }
      // }

      // Assuming you're using a StatefulWidget and want to refresh the UI
      setState(() {});
    }
    print("Filtered items count: ${morale_list.length}");

    keytttr = UniqueKey();
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
        chartHeight - (yValue / Constants.moral_index_maxY) * chartHeight;

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

class MoraleTypeGrid extends StatelessWidget {
  final List<Map<String, dynamic>> collectionTypes = [
    {'type': 'Cash', 'color': Colors.blue},
    {'type': 'EFT', 'color': Colors.purple},
    {'type': 'Easypay', 'color': Colors.green},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16),
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
          itemCount: 3,
          itemBuilder: (context, index) {
            return;
          },
        ),
      ),
    );
  }
}
