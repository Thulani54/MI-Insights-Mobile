//import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/Constants.dart';
import '../../customwidgets/custom_date_range_picker.dart';
import '../../services/MyNoyifier.dart';
import '../../services/attendance_report_sevice.dart';
import '../../services/inactivitylogoutmixin.dart';
import '../../services/window_manager.dart';

class AttendanceReport extends StatefulWidget {
  const AttendanceReport({super.key});

  @override
  State<AttendanceReport> createState() => _AttendanceReportState();
}

int noOfDaysThisMonth = 30;
bool isLoading = false;
final attendanceValue = ValueNotifier<int>(0);
List<BarChartGroupData> attendance_barChartData1 = [];
List<BarChartGroupData> attendance_barChartData2 = [];
List<BarChartGroupData> attendance_barChartData3 = [];
List<BarChartGroupData> attendance_barChartData4 = [];

MyNotifier? myNotifier;
DateTime datefrom = DateTime.now().subtract(Duration(days: 60));
DateTime dateto = DateTime.now();
int days_difference = 0;
Widget wdg1 = Container();
int report_index = 0;
int attendance_index = 0;
String data2 = "";
Key kyrt = UniqueKey();
int touchedIndex = -1;

class _AttendanceReportState extends State<AttendanceReport>
    with InactivityLogoutMixin {
  double _sliderPosition = 0.0;
  int _selectedButton = 1;
  bool isSameDaysRange = true;
  Color _button1Color = Colors.grey.withOpacity(0.0);
  Color _button2Color = Colors.grey.withOpacity(0.0);
  Color _button3Color = Colors.grey.withOpacity(0.0);
  void _animateButton(int buttonNumber) {
    DateTime? startDate = DateTime.now();
    DateTime? endDate = DateTime.now();
    attendanceValue.value++;
    restartInactivityTimer();

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
      });
      DateTime now = DateTime.now();
      attendanceValue.value++;

      // Set loading state to true
      setState(() {
        isLoading = true;
      });

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
      Constants.attendance_formattedStartDate = formattedStartDate;
      Constants.attendance_formattedEndDate = formattedEndDate;

      // Call getAttendanceReportData
      getAttendanceReportData(formattedStartDate, formattedEndDate, buttonNumber, context)
          .then((value) {
        if (mounted) setState(() {
          isLoading = false;
        });
      }).catchError((error) {
        if (kDebugMode) {
          print("❌ Error in _animateButton getAttendanceReportData: $error");
        }
        if (mounted) setState(() {
          isLoading = false;
        });
      });

      setState(() {});
    } else {
      showCustomDateRangePicker(
        context,
        dismissible: true,
        minimumDate: DateTime.now().subtract(const Duration(days: 360)),
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
            // print("dfdggf $start $end");
          }

          days_difference = end!.difference(start).inDays;
          if (end.month == start.month) {
            isSameDaysRange = true;
          } else {
            isSameDaysRange = false;
          }
          Constants.attendance_formattedStartDate =
              DateFormat('yyyy-MM-dd').format(start);
          Constants.attendance_formattedEndDate =
              DateFormat('yyyy-MM-dd').format(end);
          isLoading = true;
          setState(() {});

          getAttendanceReportData(Constants.attendance_formattedStartDate,
                  Constants.attendance_formattedEndDate, 3, context)
              .then((value) {
            isLoading = false;
            /*print(
                "dfdggf2 ${Constants.attendance_formattedStartDate} ${Constants.attendance_formattedEndDate}");
*/
            setState(() {});
          });
          restartInactivityTimer();
        },
        onCancelClick: () {
          restartInactivityTimer();
          attendanceValue.value++;
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
              "Attendance Report",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )),
        body: Container(
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
                      _selectedButton == 1
                          ? Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                  "Absenteeism Summary (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                            )
                          : _selectedButton == 2
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(
                                      "Absenteeism Summary (12 Months View)"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(
                                      "Absenteeism Summary (${Constants.attendance_formattedStartDate} to ${Constants.attendance_formattedEndDate})"),
                                ),
                      SizedBox(
                        height: 4,
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
                                              1.9)),
                          itemCount: _selectedButton == 1
                              ? Constants.attendance_sectionsList1a.length
                              : _selectedButton == 2
                                  ? Constants.attendance_sectionsList2a.length
                                  : _selectedButton == 3 &&
                                          days_difference <= 31
                                      ? Constants
                                          .attendance_sectionsList3a.length
                                      : Constants
                                          .attendance_sectionsList3b.length,
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
                                          restartInactivityTimer();
                                          attendance_index = index;
                                          setState(() {});
                                          if (kDebugMode) {
                                            print("attendance_index " +
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
                                                            color: attendance_index ==
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
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 0,
                                                                    left: 0,
                                                                    bottom: 4),
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 12,
                                                                ),
                                                                Center(
                                                                    child:
                                                                        Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              8.0,
                                                                          right:
                                                                              8),
                                                                  child: Text(
                                                                    formatLargeNumber((_selectedButton ==
                                                                                1
                                                                            ? Constants.attendance_sectionsList1a[index].count
                                                                            : _selectedButton == 2
                                                                                ? Constants.attendance_sectionsList2a[index].count
                                                                                : _selectedButton == 3 && days_difference <= 31
                                                                                    ? Constants.attendance_sectionsList3a[index].count
                                                                                    : Constants.attendance_sectionsList3b[index].count)
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
                                                                Center(
                                                                  child:
                                                                      Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 8.0,
                                                                              right: 8,
                                                                              top: 8),
                                                                          child: Text(
                                                                            (_selectedButton == 1
                                                                                        ? Constants.attendance_sectionsList1a[index].percentage
                                                                                        : _selectedButton == 2
                                                                                            ? Constants.attendance_sectionsList2a[index].percentage
                                                                                            : _selectedButton == 3 && days_difference <= 31
                                                                                                ? Constants.attendance_sectionsList3a[index].percentage
                                                                                                : Constants.attendance_sectionsList3b[index].percentage)
                                                                                    .toStringAsFixed(2) +
                                                                                "%",
                                                                            style:
                                                                                TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            maxLines:
                                                                                2,
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
                                                                            .attendance_sectionsList1a[
                                                                                index]
                                                                            .id
                                                                        : _selectedButton ==
                                                                                2
                                                                            ? Constants.attendance_sectionsList2a[index].id
                                                                            : _selectedButton == 3 && days_difference <= 31
                                                                                ? Constants.attendance_sectionsList3a[index].id
                                                                                : Constants.attendance_sectionsList3b[index].id,
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
                      SizedBox(
                        height: 8,
                      ),
                      _selectedButton == 1
                          ? Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                  "Absenteeism Rate (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                            )
                          : _selectedButton == 2
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child:
                                      Text("Absenteeism Rate (12 Months View)"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(
                                      "Absenteeism Rate (${Constants.attendance_formattedStartDate} to ${Constants.attendance_formattedEndDate})"),
                                ),
                      SizedBox(
                        height: 0,
                      ),
                      /*_selectedButton == 1
                          ? Row(
                              children: [
                                Spacer(),
                                AnimatedCircularChart(
                                  key: UniqueKey(),
                                  size: Size(
                                      MediaQuery.of(context).size.width * 0.7,
                                      MediaQuery.of(context).size.width * 0.7),
                                  initialChartData: <CircularStackEntry>[
                                    CircularStackEntry(
                                      <CircularSegmentEntry>[
                                        CircularSegmentEntry(
                                          Constants.absenteeism_ratio1a,
                                          Colors.indigo,
                                          rankKey: 'completed',
                                        ),
                                        CircularSegmentEntry(
                                          100.0 - Constants.absenteeism_ratio1a,
                                          Colors.blue.withOpacity(0.3),
                                          rankKey: 'remaining',
                                        ),
                                      ],
                                      rankKey: 'progress',
                                    ),
                                  ],
                                  chartType: CircularChartType.Radial,
                                  edgeStyle: SegmentEdgeStyle.flat,
                                  startAngle: 3,
                                  holeRadius:
                                      MediaQuery.of(context).size.width * 0.18,
                                  percentageValues: true,
                                  holeLabel:
                                      '${Constants.absenteeism_ratio1a}%',
                                  labelStyle: new TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0,
                                  ),
                                ),
                                Spacer(),
                              ],
                            )
                          : _selectedButton == 2
                              ? Row(
                                  children: [
                                    Spacer(),
                                    AnimatedCircularChart(
                                      key: UniqueKey(),
                                      size: Size(
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                          MediaQuery.of(context).size.width *
                                              0.7),
                                      initialChartData: <CircularStackEntry>[
                                        CircularStackEntry(
                                          <CircularSegmentEntry>[
                                            CircularSegmentEntry(
                                              Constants.absenteeism_ratio2a,
                                              Colors.indigo,
                                              rankKey: 'completed',
                                            ),
                                            CircularSegmentEntry(
                                              100.0 -
                                                  Constants.absenteeism_ratio2a,
                                              Colors.blue.withOpacity(0.3),
                                              rankKey: 'remaining',
                                            ),
                                          ],
                                          rankKey: 'progress',
                                        ),
                                      ],
                                      chartType: CircularChartType.Radial,
                                      edgeStyle: SegmentEdgeStyle.flat,
                                      startAngle: 3,
                                      holeRadius:
                                          MediaQuery.of(context).size.width *
                                              0.18,
                                      percentageValues: true,
                                      holeLabel:
                                          '${Constants.absenteeism_ratio2a}%',
                                      labelStyle: new TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0,
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                )
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
                                                      .absenteeism_ratio2a
                                                      .toStringAsFixed(2)),
                                                  Colors.indigo,
                                                  rankKey: 'completed',
                                                ),
                                                CircularSegmentEntry(
                                                  100.0 -
                                                      double.parse(Constants
                                                          .absenteeism_ratio2a
                                                          .toStringAsFixed(2)),
                                                  Colors.blue.withOpacity(0.3),
                                                  rankKey: 'remaining',
                                                ),
                                              ],
                                              rankKey: 'progress',
                                            ),
                                          ],
                                          chartType: CircularChartType.Radial,
                                          edgeStyle: SegmentEdgeStyle.flat,
                                          startAngle: 3,
                                          holeRadius: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.18,
                                          percentageValues: true,
                                          holeLabel:
                                              '${double.parse(Constants.absenteeism_ratio2a.toStringAsFixed(2))}%',
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
                                                  Constants.absenteeism_ratio1a,
                                                  Colors.indigo,
                                                  rankKey: 'completed',
                                                ),
                                                CircularSegmentEntry(
                                                  100.0 -
                                                      Constants
                                                          .absenteeism_ratio1a,
                                                  Colors.blue.withOpacity(0.3),
                                                  rankKey: 'remaining',
                                                ),
                                              ],
                                              rankKey: 'progress',
                                            ),
                                          ],
                                          chartType: CircularChartType.Radial,
                                          edgeStyle: SegmentEdgeStyle.flat,
                                          startAngle: 3,
                                          holeRadius: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.18,
                                          percentageValues: true,
                                          holeLabel:
                                              '${Constants.absenteeism_ratio1a}%',
                                          labelStyle: new TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0,
                                          ),
                                        ),
                                        Spacer(),
                                      ],
                                    ),*/
                      Container(
                        height: 4,
                      ),
                      /*          _selectedButton == 1
                          ? Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                  "Attendance Type (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                            )
                          : _selectedButton == 2
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text("Attendance Type (12 Months View)"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(
                                      "Attendance Type (${Constants.attendance_formattedStartDate} to ${Constants.attendance_formattedEndDate})"),
                                ),
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
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Card(
                                          elevation: 6,
                                          surfaceTintColor: Colors.white,
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
                                                  if (attendance_barChartData1
                                                      .isEmpty) {
                                                    return Center(
                                                      child: Text(
                                                        "No data available",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
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
                                                          groupsSpace: barsSpace,
                                                          barGroups:
                                                              attendance_barChartData1,
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
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Card(
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
                                                      if (attendance_barChartData2
                                                          .isEmpty) {
                                                        return Center(
                                                          child: Text(
                                                            "No data available",
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
                                                                          getMonthAbbreviation(value.toInt())
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
                                                                      show:
                                                                          false),
                                                              groupsSpace:
                                                                  barsSpace,
                                                              barGroups:
                                                                  attendance_barChartData2,
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
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Card(
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
                                                          if (attendance_barChartData3
                                                              .isEmpty) {
                                                            return Center(
                                                              child: Text(
                                                                "No data available",
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
                                                                            Text(
                                                                          'Days of the month',
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
                                                                            20,
                                                                        getTitlesWidget:
                                                                            (value,
                                                                                meta) {
                                                                          return Text(
                                                                            formatLargeNumber2(value
                                                                                .toInt()
                                                                                .toString()),
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
                                                                      attendance_barChartData3,
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
                                                            top: 8.0),
                                                    child: Card(
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
                                                              if (attendance_barChartData4
                                                                  .isEmpty) {
                                                                return Center(
                                                                  child: Text(
                                                                    "No data available",
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
                                                                                  // value.toString(),
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
                                                                                20,
                                                                            getTitlesWidget:
                                                                                (value, meta) {
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
                                                                          attendance_barChartData4,
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
                      ),*/
                      SizedBox(
                        height: 8,
                      ),
                      /* Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: AttendanceReportGrid(),
                      ),*/
                      _selectedButton == 1
                          ? Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                  "Attendance (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                            )
                          : _selectedButton == 2
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text("Attendance (12 Months View)"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(
                                      "Attendance Rate (${Constants.attendance_formattedStartDate} to ${Constants.attendance_formattedEndDate})"),
                                ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 3 / 1.2,
                          ),
                          itemCount: _selectedButton == 1
                              ? Constants.attendanceTypes1a.length
                              : _selectedButton == 2
                                  ? Constants.attendanceTypes2a.length
                                  : _selectedButton == 3 && days_difference < 31
                                      ? Constants.attendanceTypes3a.length
                                      : Constants.attendanceTypes3b.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    10), // Adjust the radius as needed
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    color: Colors.grey.withOpacity(0.35),
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            20,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          color: _selectedButton == 1
                                              ? Constants
                                                  .attendanceTypes1a[index]
                                                  .color
                                              : _selectedButton == 2
                                                  ? Constants
                                                      .attendanceTypes2a[index]
                                                      .color
                                                  : _selectedButton == 3 &&
                                                          days_difference < 31
                                                      ? Constants
                                                          .attendanceTypes3a[
                                                              index]
                                                          .color
                                                      : Constants
                                                          .attendanceTypes3b[
                                                              index]
                                                          .color,
                                          child: Center(
                                            child: Icon(
                                                _selectedButton == 1
                                                    ? Constants
                                                        .attendanceTypes1a[
                                                            index]
                                                        .icon
                                                    : _selectedButton == 2
                                                        ? Constants
                                                            .attendanceTypes2a[
                                                                index]
                                                            .icon
                                                        : _selectedButton ==
                                                                    3 &&
                                                                days_difference <=
                                                                    31
                                                            ? Constants
                                                                .attendanceTypes3a[
                                                                    index]
                                                                .icon
                                                            : Constants
                                                                .attendanceTypes3b[
                                                                    index]
                                                                .icon,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, top: 6.0),
                                              child: Text(
                                                _selectedButton == 1
                                                    ? Constants
                                                        .attendanceTypes1a[
                                                            index]
                                                        .type
                                                    : _selectedButton == 2
                                                        ? Constants
                                                            .attendanceTypes2a[
                                                                index]
                                                            .type
                                                        : _selectedButton ==
                                                                    3 &&
                                                                days_difference <=
                                                                    31
                                                            ? Constants
                                                                .attendanceTypes3a[
                                                                    index]
                                                                .type
                                                            : Constants
                                                                .attendanceTypes3b[
                                                                    index]
                                                                .type,
                                                style: TextStyle(
                                                  fontSize: 11.5,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, top: 6.0),
                                              child: Text(
                                                _selectedButton == 1
                                                    ? Constants
                                                        .attendanceTypes1a[
                                                            index]
                                                        .count
                                                        .round()
                                                        .toString()
                                                    : _selectedButton == 2
                                                        ? Constants
                                                            .attendanceTypes2a[
                                                                index]
                                                            .count
                                                            .round()
                                                            .toString()
                                                        : _selectedButton ==
                                                                    3 &&
                                                                days_difference <=
                                                                    31
                                                            ? Constants
                                                                .attendanceTypes3a[
                                                                    index]
                                                                .count
                                                                .round()
                                                                .toString()
                                                            : Constants
                                                                .attendanceTypes3b[
                                                                    index]
                                                                .count
                                                                .round()
                                                                .toString(),
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ]))),
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
    myNotifier = MyNotifier(attendanceValue, context);
    attendanceValue.addListener(() {
      kyrt = UniqueKey();
      setState(() {});
      Future.delayed(Duration(seconds: 3)).then((value) {
        setState(() {});
        print("dgffgf");
        //  if(mounted) setState(() {});
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

class AttendanceReportGrid extends StatefulWidget {
  @override
  _AttendanceReportGridState createState() => _AttendanceReportGridState();
}

final List<ReprintTypeGriditem> attendanceTypes = [
  ReprintTypeGriditem('Present', Colors.green),
  ReprintTypeGriditem('Not Marked', Colors.grey),
  ReprintTypeGriditem('Sick Leave', Colors.brown),
  ReprintTypeGriditem('Day Off', Colors.orange),
  ReprintTypeGriditem('Annual Leave', Colors.blue),
  ReprintTypeGriditem('Late Coming', Colors.red),
  ReprintTypeGriditem('Maternity Leave', Colors.purple),
  ReprintTypeGriditem('Paternity Leave', Colors.yellow),
  ReprintTypeGriditem('Training', Colors.pink),
  ReprintTypeGriditem('Suspended', Colors.teal),
  ReprintTypeGriditem('Resigned', Colors.indigo),
  ReprintTypeGriditem('Family Responsibility Leave', Colors.cyan),
];

class _AttendanceReportGridState extends State<AttendanceReportGrid> {
  bool _showMore = false;

  @override
  Widget build(BuildContext context) {
    int itemCount =
        _showMore ? attendanceTypes.length : 4; // Show only 4 initially

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GridView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2,
            ),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return Row(
                children: <Widget>[
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(360),
                      color: attendanceTypes[index].color,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      attendanceTypes[index].type,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _showMore = !_showMore; // Toggle the state
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36),
              color: Constants.ctaColorLight.withOpacity(0.15),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 8.0, bottom: 8),
              child: Text(
                _showMore ? 'Show Less' : 'Click to View More',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Constants.ctaColorLight,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AttendanceReportGrid2 extends StatelessWidget {
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
          childAspectRatio: 2,
        ),
        itemCount: attendanceTypes.length,
        itemBuilder: (context, index) {
          return Row(
            children: <Widget>[
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(360),
                  color: attendanceTypes[index].color,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Text(
                  attendanceTypes[index].type,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
              )
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

class attendance_gridmodel {
  String id;
  double percentage;
  int count;
  attendance_gridmodel(
    this.id,
    this.percentage,
    this.count,
  );
}

class AttendanceTypeGridItem {
  final String type;
  final Color color;
  final IconData icon;
  int count;

  AttendanceTypeGridItem(this.type, this.color, this.icon, this.count);
}
