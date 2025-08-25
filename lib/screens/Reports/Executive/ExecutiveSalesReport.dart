import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:animate_do/animate_do.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mi_insights/admin/ClientSearchPage.dart';
import 'package:mi_insights/constants/Constants.dart';
import 'package:mi_insights/screens/Test/OnboardingWelcomePage.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../customwidgets/CustomCard.dart';
import '../../../customwidgets/RdialGauge.dart';
import '../../../customwidgets/custom_date_range_picker.dart';
import '../../../customwidgets/custom_treemap/pages/tree_diagram.dart';
import '../../../models/AveragePremiumData.dart';
import '../../../models/SalesDataResponse.dart';
import '../../../services/Executive/executive_sales_report_service.dart';
import '../../../services/comms_report_service.dart';
import '../../../services/MyNoyifier.dart';
import '../../../services/inactivitylogoutmixin.dart';
import '../../../services/window_manager.dart';
import '../../../utils/login_utils.dart';

int grid_index = 0;

// Utility function to remove FlSpots with zero values (only for daily data)
List<FlSpot> _removeZeroValuesFromDaily(
    List<FlSpot> data, int selectedButton, int daysDifference) {
  if (data.isEmpty) return data;

  // Only filter zeros for daily data (selectedButton == 1 or short-term custom ranges)
  bool isDailyData =
      selectedButton == 1 || (selectedButton == 3 && daysDifference <= 31);

  if (isDailyData) {
    return data.where((spot) => spot.y != 0).toList();
  } else {
    // For monthly and other data types, return as-is
    return data;
  }
}

// Utility function to convert BranchSales to chart data
List<charts.Series<BranchChartDataGlobal, String>>
    _convertBranchSalesToChartData(List<BranchSales> branchData) {
  return [
    charts.Series<BranchChartDataGlobal, String>(
      id: 'BranchSales',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (BranchChartDataGlobal data, _) => data.branchName,
      measureFn: (BranchChartDataGlobal data, _) => data.sales,
      data: branchData
          .map((branch) => BranchChartDataGlobal(
                branchName: branch.branchName,
                sales: branch.totalSales,
              ))
          .toList(),
      labelAccessorFn: (BranchChartDataGlobal data, _) => '${data.sales}',
    ),
  ];
}

// Global data model for chart
class BranchChartDataGlobal {
  final String branchName;
  final int sales;

  BranchChartDataGlobal({
    required this.branchName,
    required this.sales,
  });
}

int grid_index_2 = 0;
int target_index = 0;
int target_index8 = 0;

int type_index = 0;
int time_index = 0;
int target_index_2 = 0;
int noOfDaysThisMonth = 30;
bool isSalesDataLoading1a = false;
bool isSalesDataLoading2a = false;
bool isSalesDataLoading3a = false;

Map<String, dynamic> sales_jsonResponse1a = {};
Map<String, dynamic> sales_jsonResponse2a = {};
Map<String, dynamic> sales_jsonResponse3a = {};
Map<String, dynamic> sales_jsonResponse4a = {};

List<BarChartGroupData> sales_barChartData1 = [];
List<BarChartGroupData> sales_barChartData2 = [];
List<BarChartGroupData> sales_barChartData3 = [];
List<BarChartGroupData> sales_barChartData4 = [];
final salesValue = ValueNotifier<int>(0);

MyNotifier? myNotifier;
DateTime datefrom = DateTime.now().subtract(Duration(days: 60));
DateTime dateto = DateTime.now();
int days_difference = 0;
Widget wdg1 = Container();
int report_index = 0;
int sales_index = 0;
int target_index9 = 0;
int ntu_lapse_index = 0;
String data2 = "";
Key kyrt = UniqueKey();
int touchedIndex = -1;

class ExecutivesSalesReport extends StatefulWidget {
  const ExecutivesSalesReport({Key? key}) : super(key: key);

  @override
  State<ExecutivesSalesReport> createState() => _ExecutivesSalesReportState();
}

List<Map<String, dynamic>> leads = [];
List<List<Map<String, dynamic>>> policies = [];
double _sliderPosition = 0.0;
int _selectedButton = 1;
double _sliderPosition2 = 0.0;
double _sliderPosition3 = 0.0;
double _sliderPosition4 = 0.0;
double _sliderPosition5 = 0.0;
double _sliderPosition7 = 0.0;
double _sliderPosition8 = 0.0;
double _sliderPosition9 = 0.0;
double _sliderPosition10 = 0.0;

bool isSameDaysRange = true;

class _ExecutivesSalesReportState extends State<ExecutivesSalesReport>
    with InactivityLogoutMixin {
  Color _button1Color = Colors.grey.withOpacity(0.0);
  Color _button2Color = Colors.grey.withOpacity(0.0);
  Color _button3Color = Colors.grey.withOpacity(0.0);
  int currentLevel = 0;

  void _animateButton(int buttonNumber, BuildContext context) {
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
      // Set loading state for button 1
      setState(() {
        isSalesDataLoading1a = true;
      });
    } else if (buttonNumber == 2) {
      _sliderPosition = (MediaQuery.of(context).size.width / 3) - 18;
      // Set loading state for button 2
      setState(() {
        isSalesDataLoading2a = true;
      });
    } else if (buttonNumber == 3) {
      if (days_difference < 31) {
        Constants.salesInfo3a = {
          'actual': 1,
          'target': 1200,
          'averageDaily': 1.0,
          'workingDays': 1,
          'previousDaySales': 1,
          'salesRemaining': 1,
          'actualAverageDailySales': 1.0
        };
        if (Constants.sales_sectionsList3a.length > 0)
          Constants.sales_sectionsList3a[1].amount = 0;
        setState(() {});
        isSalesDataLoading3a = true;
      } else {
        isSalesDataLoading3a = true;
      }
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

      // Set date ranges based on button selection
      DateTime? startDate;
      DateTime? endDate;

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

      // Call getExecutiveSalesReport
      getExecutiveSalesReport(
              formattedStartDate,
              formattedEndDate,
              Constants.cec_client_id,
              _selectedButton,
              days_difference,
              context)
          .then((value) {
        kyrt = UniqueKey();
        if (mounted)
          setState(() {
            // Reset loading states when data is loaded
            if (buttonNumber == 1) {
              isSalesDataLoading1a = false;
            } else if (buttonNumber == 2) {
              isSalesDataLoading2a = false;
            }
          });
      }).catchError((error) {
        if (kDebugMode) {
          print("❌ Error in _animateButton getExecutiveSalesReport: $error");
        }
        // Reset loading states on error
        if (mounted)
          setState(() {
            if (buttonNumber == 1) {
              isSalesDataLoading1a = false;
            } else if (buttonNumber == 2) {
              isSalesDataLoading2a = false;
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
          setState(() {
            endDate = end;
            startDate = start;
          });

          days_difference = end!.difference(start).inDays;
          if (days_difference <= 31) {
            isSalesDataLoading3a = true;
          } else {
            isSalesDataLoading3a = true;
          }
          salesValue.value++;

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
          getExecutiveSalesReport(
                  Constants.sales_formattedStartDate,
                  Constants.sales_formattedEndDate,
                  Constants.cec_client_id,
                  _selectedButton,
                  days_difference,
                  context)
              .then((value) {
            kyrt = UniqueKey();
            if (mounted)
              setState(() {
                isSalesDataLoading3a = false;
              });
          }).catchError((error) {
            if (kDebugMode) {
              print("❌ Error in date picker getExecutiveSalesReport: $error");
            }
            if (mounted)
              setState(() {
                isSalesDataLoading3a = false;
              });
          });

          restartInactivityTimer();
        },
        onCancelClick: () {
          restartInactivityTimer();
          if (kDebugMode) {
            print("user cancelled.");
          }
          setState(() {
            _animateButton(1, context);
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

  void _animateButton7(int buttonNumber) {
    restartInactivityTimer();

    setState(() {});

    type_index = buttonNumber;
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

  void _animateButton8(int buttonNumber) {
    restartInactivityTimer();

    setState(() {});

    target_index8 = buttonNumber;
    if (buttonNumber == 0) {
      _sliderPosition8 = 0.0;
    } else if (buttonNumber == 1) {
      _sliderPosition8 = (MediaQuery.of(context).size.width / 2) - 18;
    } else if (buttonNumber == 3) {
      if (days_difference < 31) {
        _sliderPosition8 = 2 * (MediaQuery.of(context).size.width / 3) - 32;
      }
      setState(() {});
    }
  }

  void _animateButton9(int buttonNumber) {
    restartInactivityTimer();

    setState(() {});

    target_index9 = buttonNumber;
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

  void _animateButton3(int buttonNumber) {
    restartInactivityTimer();

    setState(() {});

    ntu_lapse_index = buttonNumber;
    if (buttonNumber == 0) {
      _sliderPosition3 = 0.0;
    } else if (buttonNumber == 1) {
      _sliderPosition3 = (MediaQuery.of(context).size.width / 2) - 18;
    } else if (buttonNumber == 3) {
      if (days_difference < 31) {
        _sliderPosition3 = 2 * (MediaQuery.of(context).size.width / 3) - 32;
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
          elevation: 6,
          leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black.withOpacity(0.3),
          centerTitle: true,
          title: const Text(
            "Sales Report",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
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
                                      getExecutiveSalesReport(
                                              Constants
                                                  .sales_formattedStartDate,
                                              Constants.sales_formattedEndDate,
                                              Constants.cec_client_id,
                                              _selectedButton,
                                              days_difference,
                                              context)
                                          .then((value) {
                                        kyrt = UniqueKey();
                                        if (mounted) setState(() {});
                                      }).catchError((error) {
                                        if (kDebugMode) {
                                          print(
                                              "❌ Error in initState getExecutiveSalesReport: $error");
                                        }
                                      });
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
              return true;
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
                                    _animateButton(1, context);
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
                                    _animateButton(2, context);
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
                                    _animateButton(3, context);
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
                              _animateButton(3, context);
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
                      if (hasTemporaryTesterRole(Constants.myUserRoles))
                        SizedBox(
                          height: 12,
                        ),
                      if (hasTemporaryTesterRole(Constants.myUserRoles))
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/backGround.jpg"),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              children: [
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OnboardingWelcomePage()));
                                  },
                                  child: Container(
                                      height: 36,
                                      decoration: BoxDecoration(
                                          color: Constants.ctaColorLight,
                                          borderRadius:
                                              BorderRadius.circular(32)),
                                      child: Center(
                                          child: Text(
                                        "Join the Club",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white),
                                      ))),
                                ),
                              ],
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 12,
                      ),
                      // SalesDataWidget(),
                      _selectedButton == 1 && isSalesDataLoading1a == true
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
                      _selectedButton == 2 && isSalesDataLoading2a == true
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
                              isSalesDataLoading3a == true
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
                              isSalesDataLoading3a == true
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
                        padding: const EdgeInsets.only(
                            left: 12.0, top: 12, right: 2, bottom: 8),
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
                          itemCount:
                              3, // Fixed to show 3 items: Total Sales, Inforced, Not Inforced
                          padding: EdgeInsets.all(2.0),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 290,
                              width: MediaQuery.of(context).size.width / 2.9,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 4.0, right: 8),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      surfaceTintColor: Colors.white,
                                      elevation: 6,
                                      color: Colors.white,
                                      child: ClipPath(
                                        clipper: ShapeBorderClipper(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16))),
                                        child: InkWell(
                                          customBorder: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
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
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.0)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(14),
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
                                                        margin: EdgeInsets.only(
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
                                                                        8.0),
                                                                child: Text(
                                                                  formatLargeNumber((index ==
                                                                              0
                                                                          ? Constants
                                                                              .currentSalesDataResponse
                                                                              .totalSaleCounts
                                                                          : index == 1
                                                                              ? Constants.currentSalesDataResponse.totalInforcedCounts
                                                                              : Constants.currentSalesDataResponse.totalNotInforcedCounts)
                                                                      .toString()),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16.5,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  maxLines: 2,
                                                                ),
                                                              )),
                                                            ),
                                                            Center(
                                                                child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                index == 0
                                                                    ? "Total Sales"
                                                                    : index == 1
                                                                        ? "Inforced"
                                                                        : "Not Inforced",
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
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 8),
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
                                          "Insurer's Approval Rate (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
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
                                        child: Text(
                                            "Insurer's Approval Rate (12 Months View)"),
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
                                              "Insurer's Approval Rate (${Constants.sales_formattedStartDate} to ${Constants.sales_formattedEndDate})"),
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
                        padding: const EdgeInsets.only(left: 6.0, right: 6),
                        child: LinearPercentIndicator(
                          width: MediaQuery.of(context).size.width - 12,
                          animation: true,
                          lineHeight: 20.0,
                          animationDuration: 500,
                          percent: (Constants.currentSalesDataResponse
                                          .percentageWithExtPolicy >
                                      0
                                  ? Constants.currentSalesDataResponse
                                          .percentageWithExtPolicy /
                                      100
                                  : 0.0)
                              .clamp(0.0, 1.0), // Clamp between 0.0 and 1.0
                          center: Text(
                              "${Constants.currentSalesDataResponse.percentageWithExtPolicy.toStringAsFixed(1)}%"),
                          barRadius: ui.Radius.circular(12),
                          progressColor: Colors.green,
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
                                          "Inforce Target vs Actual (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
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
                                              left: 16.0, right: 16, bottom: 8),
                                          child: Text(
                                              "Inforce Target vs Actual (12 Months View)"),
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
                                              left: 16.0, right: 16, bottom: 8),
                                          child: Text(
                                              "Inforce Target vs Actual (${Constants.sales_formattedStartDate} to ${Constants.sales_formattedEndDate})"),
                                        ),
                                      )
                                    ],
                                  )),

                      _selectedButton == 1
                          ? Padding(
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
                                                    'Month To Date Target',
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
                                                    'Full Month Target',
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
                                                      'Month To Date Target',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  )
                                                : target_index == 1
                                                    ? Center(
                                                        child: Text(
                                                          'Full Month Target',
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
                            )
                          : _selectedButton == 2
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 16, top: 0),
                                          child: GestureDetector(
                                            onTap: () {
                                              target_index_2 = 0;
                                              setState(() {});
                                            },
                                            child: Container(
                                              height: 38,
                                              decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Center(
                                                  child: Text(
                                                "Target - Rolling 12 Months View",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              )),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : _selectedButton == 3 && days_difference < 31
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12.0, right: 4, top: 0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  target_index = 0;
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  height: 38,
                                                  decoration: BoxDecoration(
                                                      color: (target_index == 0)
                                                          ? Constants
                                                              .ctaColorLight
                                                          : Colors.transparent,
                                                      border: Border.all(
                                                        color: (target_index ==
                                                                0)
                                                            ? Constants
                                                                .ctaColorLight
                                                                .withOpacity(
                                                                    0.35)
                                                            : Colors.grey,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Center(
                                                      child: Text(
                                                    "Date Selection Target",
                                                    style: TextStyle(
                                                        color:
                                                            (target_index == 0)
                                                                ? Colors.white
                                                                : Colors.grey),
                                                  )),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0,
                                                  right: 16,
                                                  top: 0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  target_index_2 = 0;
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Center(
                                                      child: Text(
                                                    "Date Range Selection Target",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                      //Text(Constants.salesInfo3a.toString()),

                      (((_selectedButton == 1 &&
                                  isSalesDataLoading1a == true) ||
                              (_selectedButton == 2 &&
                                  isSalesDataLoading2a == true) ||
                              (_selectedButton == 3 &&
                                  isSalesDataLoading3a == true)))
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, top: 16, right: 16, bottom: 12),
                              child: CustomCard(
                                elevation: 6,
                                color: Colors.white,
                                surfaceTintColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                child: Container(
                                  height: 250,
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
                                  ),
                                ),
                              ),
                            )
                          : _selectedButton == 1
                              ? target_index == 0
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0,
                                          top: 16,
                                          right: 16,
                                          bottom: 12),
                                      child: CustomCard(
                                        elevation: 6,
                                        color: Colors.white,
                                        surfaceTintColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: isSalesDataLoading1a == true
                                            ? Container(
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
                                                ))
                                            : (Constants
                                                            .currentSalesDataResponse
                                                            .salesInfo
                                                            .averageDaily ==
                                                        0 ||
                                                    Constants
                                                            .currentSalesDataResponse
                                                            .salesInfo
                                                            .actual ==
                                                        0)
                                                ? Container(
                                                    height: 280,
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
                                                : Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 16.0,
                                                                top: 12),
                                                        child: Text(
                                                          "MTD Target = ${formatLargeNumber(Constants.currentSalesDataResponse.salesInfo.target.round().toString())}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 13),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 16.0,
                                                                top: 0),
                                                        child: Text(
                                                          "MTD Actual = ${formatLargeNumber((Constants.currentSalesDataResponse.salesInfo.actual ?? 0).toString())}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 13),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 16.0,
                                                                top: 0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "MTD Var. = ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 13),
                                                            ),
                                                            Text(
                                                              "${formatLargeNumber(((Constants.currentSalesDataResponse.salesInfo.target.round() - Constants.currentSalesDataResponse.salesInfo.actual).abs()).toString())}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 13),
                                                            ),
                                                            (Constants
                                                                        .currentSalesDataResponse
                                                                        .salesInfo
                                                                        .actual >
                                                                    Constants
                                                                        .currentSalesDataResponse
                                                                        .salesInfo
                                                                        .averageDaily
                                                                        .round())
                                                                ? Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            2.0),
                                                                    child:
                                                                        RotatedBox(
                                                                      quarterTurns:
                                                                          2,
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        "assets/icons/down-arrow-svgrepo-com.svg",
                                                                        width:
                                                                            20,
                                                                        height:
                                                                            20,
                                                                        color: Colors
                                                                            .green,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Constants
                                                                            .currentSalesDataResponse
                                                                            .salesInfo
                                                                            .actual <
                                                                        Constants
                                                                            .currentSalesDataResponse
                                                                            .salesInfo
                                                                            .averageDaily
                                                                            .round()
                                                                    ? Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                2.0),
                                                                        child: SvgPicture
                                                                            .asset(
                                                                          "assets/icons/down-arrow-svgrepo-com.svg",
                                                                          width:
                                                                              20,
                                                                          height:
                                                                              20,
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                      )
                                                                    : Container(),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 5.3),
                                                      Container(
                                                        height: 250,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0.0),
                                                            child:
                                                                CustomGaugeWithLabel(
                                                              height:
                                                                  250, // Explicitly set height
                                                              maxValue: Constants
                                                                  .currentSalesDataResponse
                                                                  .salesInfo
                                                                  .averageDaily,
                                                              actualValue: (Constants
                                                                          .currentSalesDataResponse
                                                                          .salesInfo
                                                                          .actual ??
                                                                      0)
                                                                  .toDouble(),

                                                              targetValue: Constants
                                                                  .currentSalesDataResponse
                                                                  .salesInfo
                                                                  .target
                                                                  .toDouble(),
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                      ),
                                    )
                                  : target_index == 1
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0,
                                              top: 16,
                                              right: 16,
                                              bottom: 12),
                                          child: CustomCard(
                                            elevation: 6,
                                            color: Colors.white,
                                            surfaceTintColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: isSalesDataLoading1a == true
                                                ? Container(
                                                    height: 280,
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
                                                    ))
                                                : (Constants.currentSalesDataResponse
                                                                .salesInfo.target ==
                                                            0 ||
                                                        Constants
                                                                .currentSalesDataResponse
                                                                .salesInfo
                                                                .actual ==
                                                            0)
                                                    ? Container(
                                                        height: 280,
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
                                                        ))
                                                    : Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                  child:
                                                                      Container()),
                                                              Expanded(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              8.0),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            0.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 0.0, top: 12),
                                                                              child: Text(
                                                                                "Mthly Target = ${formatLargeNumber(Constants.currentSalesDataResponse.salesInfo.targetSet.toString())}",
                                                                                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
                                                                              ),
                                                                            ),
                                                                            Spacer(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 0.0, top: 0),
                                                                            child:
                                                                                Text(
                                                                              "MTD Actual = ${formatLargeNumber((Constants.currentSalesDataResponse.salesInfo.actual ?? 0).toString())}",
                                                                              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
                                                                            ),
                                                                          ),
                                                                          Spacer(),
                                                                        ],
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                0.0,
                                                                            top:
                                                                                0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Text(
                                                                              "Mthly Var. = ",
                                                                              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
                                                                            ),
                                                                            Text(
                                                                              "${formatLargeNumber(((Constants.currentSalesDataResponse.salesInfo.targetSet - (Constants.currentSalesDataResponse.salesInfo.actual ?? 0)).abs()).toString())}",
                                                                              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
                                                                            ),
                                                                            (Constants.currentSalesDataResponse.salesInfo.targetSet >= Constants.currentSalesDataResponse.salesInfo.target)
                                                                                ? Padding(
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
                                                                                  )
                                                                                : Padding(
                                                                                    padding: const EdgeInsets.only(left: 2.0),
                                                                                    child: SvgPicture.asset(
                                                                                      "assets/icons/down-arrow-svgrepo-com.svg",
                                                                                      width: 20,
                                                                                      height: 20,
                                                                                      color: Colors.red,
                                                                                    ),
                                                                                  ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          if (Constants
                                                                  .currentSalesDataResponse
                                                                  .salesInfo
                                                                  .targetSet !=
                                                              0)
                                                            Container(
                                                                height: 250,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                child: Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            0.0),
                                                                    child:
                                                                        CustomGaugeWithLabel2(
                                                                      height:
                                                                          250, // Explicitly set height
                                                                      maxValue: Constants
                                                                              .currentSalesDataResponse
                                                                              .salesInfo
                                                                              .targetSet *
                                                                          1.2,
                                                                      actualValue:
                                                                          (Constants.currentSalesDataResponse.salesInfo.actual ?? 0)
                                                                              .toDouble(),
                                                                      targetValue: Constants
                                                                          .currentSalesDataResponse
                                                                          .salesInfo
                                                                          .targetSet
                                                                          .toDouble(),
                                                                    ))),
                                                          SizedBox(height: 5),
                                                        ],
                                                      ),
                                          ),
                                        )
                                      : Container()
                              : _selectedButton == 3 && days_difference < 31
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0,
                                          top: 16,
                                          right: 16,
                                          bottom: 12),
                                      child: CustomCard3(
                                        elevation: 6,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        surfaceTintColor: Colors.white,
                                        color: Colors.white,
                                        boderRadius: 20,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0, top: 12),
                                              child: Text(
                                                "MTD Target = ${formatLargeNumber((((Constants.currentSalesDataResponse.salesInfo.target ?? 0)).round()).toString())}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 13),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0, top: 0),
                                              child: Text(
                                                "MTD Actual = ${formatLargeNumber((Constants.currentSalesDataResponse.salesInfo.actual ?? 0).toString())}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 13),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0, top: 0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "MTD Var. = ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 13),
                                                  ),
                                                  Text(
                                                    "${formatLargeNumber(((Constants.currentSalesDataResponse.salesInfo.averageDaily.round() - (Constants.currentSalesDataResponse.salesInfo.actual ?? 0)).abs()).toString())}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 13),
                                                  ),
                                                  (Constants.currentSalesDataResponse
                                                              .salesInfo.actual >
                                                          Constants
                                                              .currentSalesDataResponse
                                                              .salesInfo
                                                              .averageDaily
                                                              .round())
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 2.0),
                                                          child: RotatedBox(
                                                            quarterTurns: 2,
                                                            child: SvgPicture
                                                                .asset(
                                                              "assets/icons/down-arrow-svgrepo-com.svg",
                                                              width: 20,
                                                              height: 20,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                          ),
                                                        )
                                                      : Constants
                                                                  .currentSalesDataResponse
                                                                  .salesInfo
                                                                  .actual <
                                                              Constants
                                                                  .currentSalesDataResponse
                                                                  .salesInfo
                                                                  .averageDaily
                                                                  .round()
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          2.0),
                                                              child: SvgPicture
                                                                  .asset(
                                                                "assets/icons/down-arrow-svgrepo-com.svg",
                                                                width: 20,
                                                                height: 20,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            )
                                                          : Container(),
                                                ],
                                              ),
                                            ),
                                            Container(
                                                height: 200,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: Constants
                                                                .currentSalesDataResponse
                                                                .salesInfo
                                                                .averageDaily ==
                                                            0
                                                        ? Container()
                                                        : CustomGaugeWithLabel4(
                                                            maxValue: Constants
                                                                .currentSalesDataResponse
                                                                .salesInfo
                                                                .averageDaily,
                                                            actualValue: (Constants
                                                                        .currentSalesDataResponse
                                                                        .salesInfo
                                                                        .actual ??
                                                                    0)
                                                                .toDouble(),
                                                            targetValue: Constants
                                                                .currentSalesDataResponse
                                                                .salesInfo
                                                                .targetSet
                                                                .toDouble()))),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),

                      (_selectedButton == 2)
                          ? SizedBox(
                              height: 12,
                            )
                          : SizedBox(
                              height: 20,
                            ),

                      _selectedButton == 1
                          ? Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                  "Sales Overview (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                            )
                          : _selectedButton == 2
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 12),
                                  child:
                                      Text("Sales Overview (12 Months View)"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 12),
                                  child:
                                      Text("Sales Overview (12 Months View)"),
                                ),
                      SalesOverviewChart(
                        isLoading: false, // Set based on your loading state
                        selectedButton: _selectedButton,
                        daysDifference: days_difference,
                        salesIndex: sales_index,
                        noOfDaysThisMonth: noOfDaysThisMonth,
                      ),
                      _selectedButton == 1
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, top: 12),
                              child: Text("Persistency (12 Months View)"),
                            )
                          : _selectedButton == 2
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 12),
                                  child: Text("Persistency (12 Months View)"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 12),
                                  child: Text("Persistency (12 Months View)"),
                                ),

                      ChartWidget(
                        selectedButton: _selectedButton,
                        days: days_difference,
                        salesDataResponse: Constants.currentSalesDataResponse,
                      ),

                      SizedBox(
                        height: 16,
                      ),
                      _selectedButton == 1
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, top: 12),
                              child: Text(
                                  "Top 10 Sales Agents (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                            )
                          : _selectedButton == 2
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 12),
                                  child: Text(
                                      "Top 10 Sales By Agent (12 Months View)"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 12),
                                  child: Text(
                                      "Top 10 Sales By Agent (${Constants.sales_formattedStartDate} to ${Constants.sales_formattedEndDate})"),
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
                                                  BorderRadius.circular(360)),
                                          height: 35,
                                          child: Center(
                                            child: Text(
                                              'Sales',
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
                                                  BorderRadius.circular(360)),
                                          child: Center(
                                            child: Text(
                                              'Persistency',
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
                                                  BorderRadius.circular(360)),
                                          child: Center(
                                            child: Text(
                                              'Collections',
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
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Constants
                                          .ctaColorLight, // Color of the slider
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: grid_index == 0
                                        ? Center(
                                            child: Text(
                                              'Sales',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : grid_index == 1
                                            ? Center(
                                                child: Text(
                                                  'Persistency',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            : Center(
                                                child: Text(
                                                  'Collections',
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
                      AgentDataWidget(
                        selectedButton: _selectedButton,
                        daysDifference: days_difference,
                        gridIndex: grid_index,
                        salesIndex: sales_index,
                        salesDataResponse: Constants.currentSalesDataResponse,
                        isLoading: false,
                      ),

                      _selectedButton == 1
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, top: 16),
                              child: Text(
                                  "Bottom 10 Sales Agents (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                            )
                          : _selectedButton == 2
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 16),
                                  child: Text(
                                      "Bottom 10 Sales By Agent (12 Months View)"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 16),
                                  child: Text(
                                      "Bottom 10 Sales By Agent (${Constants.sales_formattedStartDate} to ${Constants.sales_formattedEndDate})"),
                                ),

                      BottomPerformersWidget(
                        selectedButton: _selectedButton,
                        daysDifference: days_difference,
                        salesIndex: sales_index, // 0, 1, or 2
                        salesDataResponse: Constants.currentSalesDataResponse,
                        isLoading: false,
                      ),

                      /*      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Container(
                              child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.35),
                                    borderRadius: BorderRadius.circular(12)),
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
                                            style: TextStyle(color: Colors.white),
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
                                                const EdgeInsets.only(left: 12.0),
                                            child: Text("Agent Name"),
                                          )),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 24.0),
                                          child: Text(
                                            "Sales",
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: ListView.builder(
                                    reverse: true,
                                    itemCount: (_selectedButton == 1)
                                        ? Constants.sales_salesbyagent5a.length >
                                                10
                                            ? 10
                                            : Constants
                                                .sales_salesbyagent5a.length
                                        : (_selectedButton == 2)
                                            ? Constants.sales_salesbyagent5a
                                                        .length >
                                                    10
                                                ? 10
                                                : Constants
                                                    .sales_salesbyagent3a.length
                                            : (_selectedButton == 3 &&
                                                    days_difference <= 31)
                                                ? Constants.sales_salesbyagent3a
                                                            .length >
                                                        10
                                                    ? 10
                                                    : Constants
                                                        .sales_salesbyagent3b
                                                        .length
                                                : Constants.sales_salesbyagent3b
                                                            .length >
                                                        10
                                                    ? 10
                                                    : Constants
                                                        .sales_salesbyagent3b
                                                        .length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 45,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4.0),
                                                      child: Text(
                                                          "${((index - 9).abs()) + 1} "),
                                                    ),
                                                  ),
                                                  Expanded(
                                                      flex: 4,
                                                      child: Text(
                                                          "${(_selectedButton == 1) ? Constants.sales_salesbyagent4a[index].agent_name.trimLeft(): (_selectedButton == 2) ? Constants.sales_salesbyagent5a[index].agent_name.trimLeft(): (_selectedButton == 3 && days_difference <= 31) ? Constants.sales_salesbyagent3a[index].agent_name.trimLeft(): Constants.sales_salesbyagent3b[index].agent_name}")),
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 8.0),
                                                              child: Text(
                                                                "${(_selectedButton == 1) ? Constants.sales_salesbyagent4a[index].sales.toInt() : (_selectedButton == 2) ? Constants.sales_salesbyagent5a[index].sales.toInt() : (_selectedButton == 3 && days_difference <= 31) ? Constants.sales_salesbyagent3a[index].sales.toInt() : Constants.sales_salesbyagent3b[index].sales.toInt()}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
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
                      ),*/
                      SizedBox(height: 12),

                      _selectedButton == 1
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, top: 12),
                              child: Text(
                                  "MixPulse On Products Sold (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                            )
                          : _selectedButton == 2
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 12),
                                  child: Text(
                                      "MixPulse On Products Sold (12 Months View)"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 12),
                                  child: Text(
                                      "MixPulse On Products Sold (${Constants.sales_formattedStartDate} to ${Constants.sales_formattedEndDate})"),
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
                                                  BorderRadius.circular(360)),
                                          height: 35,
                                          child: Center(
                                            child: Text(
                                              'Prod. Mix',
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
                                                  BorderRadius.circular(360)),
                                          child: Center(
                                            child: Text(
                                              'Branch Mix',
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
                                                  BorderRadius.circular(360)),
                                          child: Center(
                                            child: Text(
                                              'Average Prem.',
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
                                              'Prod. Mix',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : grid_index_2 == 1
                                            ? Center(
                                                child: Text(
                                                  'Branch Mix',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            : Center(
                                                child: Text(
                                                  'Average Prem',
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

                      if (grid_index_2 == 0)
                        SizedBox(
                          height: 12,
                        ),

                      if (grid_index_2 == 0)
                        _selectedButton == 1
                            ? Padding(
                                padding: EdgeInsets.only(
                                    left: 16.0, right: 16, top: 8),
                                child: Container(
                                  height: 700,
                                  key: Constants.sales_tree_key1a,
                                  width: MediaQuery.of(context).size.width,
                                  child: CustomCard(
                                    elevation: 6,
                                    surfaceTintColor: Colors.white,
                                    color: Colors.white,
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: isSalesDataLoading1a
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
                                            : CustomTreemap(
                                                treeMapdata: Constants
                                                    .currentSalesDataResponse
                                                    .productsGroup),
                                      ),
                                    ),
                                  ),
                                ))
                            : _selectedButton == 2
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left: 16.0, right: 16, top: 8),
                                    child: FadeOut(
                                      child: Container(
                                        height: 700,
                                        key: Constants.sales_tree_key2a,
                                        child: CustomCard(
                                          elevation: 6,
                                          surfaceTintColor: Colors.white,
                                          color: Colors.white,
                                          child: Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: CustomTreemap(
                                                  treeMapdata: Constants
                                                      .currentSalesDataResponse
                                                      .productsGroup),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ))
                                : _selectedButton == 3 && days_difference <= 31
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            left: 16.0, right: 16, top: 8),
                                        child: Container(
                                          key: Constants.sales_tree_key3a,
                                          height: 700,
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
                                                child: isSalesDataLoading2a
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
                                                    : CustomTreemap(
                                                        treeMapdata: Constants
                                                            .currentSalesDataResponse
                                                            .productsGroup

                                                        //  treeMapdata: jsonResponse1["reorganized_by_module"],

                                                        ),
                                              ),
                                            ),
                                          ),
                                        ))
                                    : Padding(
                                        padding: EdgeInsets.only(
                                            left: 16.0, right: 16, top: 8),
                                        child: Container(
                                          key: Constants.sales_tree_key4a,
                                          height: 700,
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
                                                child: isSalesDataLoading3a
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
                                                    : CustomTreemap(
                                                        treeMapdata: Constants
                                                            .currentSalesDataResponse
                                                            .productsGroup

                                                        //  treeMapdata: jsonResponse1["reorganized_by_module"],

                                                        ),
                                              ),
                                            ),
                                          ),
                                        )),

                      if (grid_index_2 == 1)
                        SizedBox(
                          height: 4,
                        ),

                      if (grid_index_2 == 1)
                        BranchSalesChartWidget(
                          selectedButton: _selectedButton,
                          daysDifference: days_difference,
                          gridIndex2: grid_index_2,
                          salesIndex: sales_index,
                          salesDataResponse: Constants.currentSalesDataResponse,
                          isLoading: isSalesDataLoading1a,
                        ),

                      /*   if (grid_index_2 == 1)
                        _selectedButton == 2
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 16.0, top: 12),
                                child: Text(
                                    "Average Premium On Inforce Sales (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                              )
                            : _selectedButton == 2
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 12),
                                    child: Text(
                                        "Average Premium On Inforce Sales (12 Months View)"),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 12),
                                    child: Text(
                                        "Average Premium On Inforce Sales (${Constants.sales_formattedStartDate} to ${Constants.sales_formattedEndDate})"),
                                  ),*/

                      if (grid_index_2 == 2)
                        AveragePremiumChartWidget(
                          selectedButton: _selectedButton,
                          daysDifference: days_difference,
                          gridIndex2: grid_index_2,
                          salesDataResponse: Constants.currentSalesDataResponse,
                          isLoading: isSalesDataLoading1a,
                        ),

                      SizedBox(
                        height: 36,
                      )

                      //POS Collections By Branch By Person

                      /*   _selectedButton == 1
                          ? Padding(
                              padding: const EdgeInsets.only(left: 16.0, top: 12),
                              child: Text("All Sales By Product Type"),
                            )
                          : _selectedButton == 2
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(left: 16.0, top: 12),
                                  child: Text("All Sales By Product Type"),
                                )
                              : Padding(
                                  padding:
                                      const EdgeInsets.only(left: 16.0, top: 12),
                                  child: Text("All Sales By Product Type"),
                                ),*/
                      /*     (_selectedButton == 1 &&
                              Constants.salesProductsGrouped1a.length > 1)
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SfTreemap(
                                key: Constants.sales_product_type_key,
                                dataCount:
                                    Constants.salesProductsGrouped1a.length,
                                levels: _buildFirstLevel(),
                                weightValueMapper: (int index) {
                                  return Constants
                                      .salesProductsGrouped1a[index].count
                                      .toDouble();
                                },
                              ),
                            )
                          : Container(),*/

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

  @override
  void initState() {
    secureScreen();
    DateTime now = DateTime.now();
    DateTime firstDayNextMonth;

    if (now.month == 12) {
      firstDayNextMonth = DateTime(now.year + 1, 1, 1);
    } else {
      firstDayNextMonth = DateTime(now.year, now.month + 1, 1);
    }

    DateTime lastDayThisMonth = firstDayNextMonth.subtract(Duration(days: 1));

    noOfDaysThisMonth = lastDayThisMonth.day;
    _animateButton(1, context);

    // Call getEcutiveSalesReport with initial 1 month view
    DateTime startDate = DateTime(now.year, now.month, 1);
    DateTime endDate = DateTime.now();
    String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
    String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
    int daysDifference = endDate.difference(startDate).inDays;

    // Update Constants
    Constants.sales_formattedStartDate = formattedStartDate;
    Constants.sales_formattedEndDate = formattedEndDate;

    getExecutiveSalesReport(formattedStartDate, formattedEndDate,
            Constants.cec_client_id, _selectedButton, days_difference, context)
        .then((value) {
      kyrt = UniqueKey();
      if (mounted) setState(() {});
    }).catchError((error) {
      if (kDebugMode) {
        print("❌ Error in initState getExecutiveSalesReport: $error");
      }
    });

    setState(() {});
    myNotifier = MyNotifier(salesValue, context);

    salesValue.addListener(() {
      kyrt = UniqueKey();

      if (mounted) setState(() {});
      Future.delayed(Duration(seconds: 2)).then((value) {
        //print("noOfDaysThisMonth $noOfDaysThisMonth");
        Constants.sales_tree_key3a = UniqueKey();
        if (mounted) setState(() {});

        if (kDebugMode) {
          print("ghjfgfgfgg $_selectedButton");
        }
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

    _animateButton(1, context);
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

  double _calculateMaxYForMonthlyData() {
    double maxY = 0;

    // Check sales spots monthly data
    if (Constants.currentSalesDataResponse.salesSpotsMonthly.isNotEmpty) {
      for (var spot in Constants.currentSalesDataResponse.salesSpotsMonthly) {
        if (spot.y > maxY) maxY = spot.y;
      }
    }

    // Check target spots monthly data
    if (Constants.currentSalesDataResponse.targetSpotsMonthly.isNotEmpty) {
      for (var spot in Constants.currentSalesDataResponse.targetSpotsMonthly) {
        if (spot.y > maxY) maxY = spot.y;
      }
    }

    // Add 10% padding to maxY, with a minimum of 100
    return maxY > 0 ? maxY * 1.1 : 100;
  }

  double _calculateMaxYForMonthlyData4() {
    double maxY = 0;

    // Check sales spots 4a data
    if (Constants.sales_spots4a.isNotEmpty) {
      for (var spot in Constants.sales_spots4a) {
        if (spot.y > maxY) maxY = spot.y;
      }
    }

    // Check sales spots 4_1 data (secondary line)
    if (Constants.sales_spots4_1.isNotEmpty) {
      for (var spot in Constants.sales_spots4_1) {
        if (spot.y > maxY) maxY = spot.y;
      }
    }

    // Add 10% padding to maxY, with a minimum of 100
    return maxY > 0 ? maxY * 1.1 : 100;
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
  final format = NumberFormat("#,##0", "en_US");
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
        backgroundColor: Colors.transparent,
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

class SalesCollectionTypeGrid extends StatelessWidget {
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
                color: color, borderRadius: BorderRadius.circular(12)),
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

class CustomDotPainter2 extends FlDotPainter {
  final Color dotColor; // Color of the dot
  final double dotSize; // Size of the dot

  CustomDotPainter2({
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

class CustomDotPainter2_right extends FlDotPainter {
  final Color dotColor; // Color of the dot
  final double dotSize; // Size of the dot

  CustomDotPainter2_right({
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
      (offsetInCanvas.dx - tp.width / 2) + 12,
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

int getWorkingDays2(DateTime startDate, DateTime endDate) {
  int workingDays = 0;
  DateTime currentDate = startDate;

  while (currentDate.isBefore(endDate.add(Duration(days: 1)))) {
    if (!_isWeekend(currentDate) && !_isHoliday(currentDate)) {
      workingDays++;
    }
    currentDate = currentDate.add(Duration(days: 1));
  }

  // print("Working Days: $workingDays");
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

class LapseLineTypeGrid extends StatelessWidget {
  final List<MemberTypGridItem> spotsTypes = [
    MemberTypGridItem('Actual', Colors.grey),
    MemberTypGridItem('Pricing', Colors.green),
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
                  Stack(
                    children: [
                      Container(
                        height: 8,
                        width: 20,
                        child: Center(
                          child: Container(
                            height: 4,
                            width: 20,
                            decoration: BoxDecoration(
                                color: item.color,
                                borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                      ),
                      if (item.color == Colors.grey)
                        Container(
                          height: 8,
                          width: 20,
                          child: Center(
                            child: Container(
                              height: 6,
                              width: 6,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                          ),
                        ),
                    ],
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

class SalesOverviewTypeGrid extends StatelessWidget {
  final List<MemberTypGridItem> spotsTypes = [
    MemberTypGridItem('Actual', Colors.grey),
    MemberTypGridItem('Target', Colors.green),
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
                  Stack(
                    children: [
                      Container(
                        height: 8,
                        width: 20,
                        child: Center(
                          child: Container(
                            height: 4,
                            width: 20,
                            decoration: BoxDecoration(
                                color: item.color,
                                borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                      ),
                      if (item.color == Colors.grey)
                        Container(
                          height: 8,
                          width: 20,
                          child: Center(
                            child: Container(
                              height: 6,
                              width: 6,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                          ),
                        ),
                    ],
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

class MemberTypGridItem {
  final String type;
  final Color color;

  MemberTypGridItem(this.type, this.color);
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
          childAspectRatio: 1.5,
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

class CollectionsTypeGrid extends StatelessWidget {
  final List<CustomersTypGridItem> collectionTypes = [
    CustomersTypGridItem('Cash', Colors.blue),
    CustomersTypGridItem('D/0.', Colors.orange),
    CustomersTypGridItem('Persal', Colors.grey),
    CustomersTypGridItem('Sal. Ded.', Colors.yellow),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4),
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

class CustomersTypGridItem {
  final String type;
  final Color color;

  CustomersTypGridItem(this.type, this.color);
}

class AveragePremiumChartWidget extends StatelessWidget {
  final int selectedButton;
  final int daysDifference;
  final int gridIndex2;
  final SalesDataResponse? salesDataResponse;
  final bool isLoading;

  const AveragePremiumChartWidget({
    Key? key,
    required this.selectedButton,
    required this.daysDifference,
    required this.gridIndex2,
    this.salesDataResponse,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('🔍 AveragePremiumChartWidget Debug:');
    print('  - gridIndex2: $gridIndex2 (needs to be 2 to show)');
    print('  - isLoading: $isLoading');
    print('  - selectedButton: $selectedButton');
    print('  - salesDataResponse exists: ${salesDataResponse != null}');
    print(
        '  - premiumResultList count: ${salesDataResponse?.premiumResultList?.length ?? 0}');

    if (salesDataResponse?.premiumResultList != null &&
        salesDataResponse!.premiumResultList!.isNotEmpty) {
      print(
          '  - First premium data: x=${salesDataResponse!.premiumResultList![0].x}, averagePremium=${salesDataResponse!.premiumResultList![0].averagePremium}');
    }

    if (gridIndex2 != 2) {
      print('  ❌ Widget not showing because gridIndex2 != 2');
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.withOpacity(0.00),
        ),
        height: 280, // Reduced height for better fitting
        width: MediaQuery.of(context).size.width,
        child: isLoading ? _buildLoadingIndicator() : _buildChart(context),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Container(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          color: Constants.ctaColorLight,
          strokeWidth: 1.8,
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    print('  📊 Building chart for button: $selectedButton');

    switch (selectedButton) {
      case 1:
        print('  - Building Button 1 Chart (1 Month View)');
        return _buildButton1Chart(context);
      case 2:
        print('  - Building Button 2 Chart (12 Months View)');
        return _buildButton2Chart(context);
      case 3:
        // Always show 31 days if less than 30 days difference
        if (daysDifference < 30) {
          print('  - Building Button 3 Daily Chart (days < 30)');
          return _buildButton3DailyChart(context);
        } else {
          print('  - Building Button 3 Monthly Chart (days >= 30)');
          return _buildButton3MonthlyChart(context);
        }
      default:
        print('  ⚠️ Default case - showing no data message');
        return _buildNoDataMessage();
    }
  }

  // Helper method to calculate maxY based on highest bar value from premium data
  double _getMaxYValue() {
    // Always calculate from the actual premium result list data
    if (salesDataResponse?.premiumResultList == null ||
        salesDataResponse!.premiumResultList!.isEmpty) {
      return 150; // Default fallback value
    }

    double maxValue = salesDataResponse!.premiumResultList!
        .map((premium) => premium.averagePremium)
        .reduce((a, b) => a > b ? a : b);

    // Ensure minimum reasonable value
    if (maxValue <= 0) {
      return 150; // Minimum scale for zero or negative values
    }

    // Add 50% padding above the highest value for better visualization
    // This prevents bars from touching the top of the chart
    return maxValue * 1.1;
  }

  // Helper method to calculate maxY specifically for monthly data
  double _getMaxYValueForMonthly() {
    // Always calculate from the actual premium result list data
    if (salesDataResponse?.premiumResultList == null ||
        salesDataResponse!.premiumResultList!.isEmpty) {
      return 150; // Default fallback value
    }

    // Find the actual maximum value from the chart data
    double maxValue = salesDataResponse!.premiumResultList!
        .map((premium) => premium.averagePremium)
        .reduce((a, b) => a > b ? a : b);

    // Ensure minimum reasonable value
    if (maxValue <= 0) {
      return 150;
    }

    // Add padding above the highest value for better visualization
    return maxValue * 0.75;
  }

  // Button 1: FL Chart with daily data - Updated with dynamic maxY and proper day labels
  Widget _buildButton1Chart(BuildContext context) {
    List<BarChartGroupData> barData = _getButton1BarData();

    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8, top: 16),
      child: CustomCard(
        elevation: 6,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          height: 220, // Fixed height for better control
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (barData.isEmpty) {
                  return _buildNoDataMessage();
                }

                double barsSpace = 0;
                if (selectedButton == 1 ||
                    (selectedButton == 3 && daysDifference < 30)) {
                  barsSpace = (1.0 * constraints.maxWidth - 64) / 31;
                } else {
                  barsSpace = (1.0 * constraints.maxWidth - 64) / 12;
                }

                return Padding(
                  padding: const EdgeInsets.all(12.0), // Reduced padding
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.center,
                      barTouchData: BarTouchData(enabled: false),
                      gridData: _buildGridData(),
                      borderData: _buildBorderData(),
                      titlesData: _buildButton1TitlesData(),
                      groupsSpace: barsSpace,
                      barGroups: barData,
                      maxY: _getMaxYValue(), // Set dynamic maxY
                      minY: 0,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Button 2: charts_flutter grouped bar chart - Fixed with proper label positioning and maxY
  Widget _buildButton2Chart(BuildContext context) {
    List<charts.Series<AveragePremiumData, String>> seriesData =
        _getButton2SeriesData();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: CustomCard3(
        elevation: 6,
        color: Colors.white,
        boderRadius: 20,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          height: 180, // Reduced height for better fitting
          child: Padding(
            padding: const EdgeInsets.all(8.0), // Reduced padding
            child: charts.BarChart(
              seriesData,
              animate: true,
              defaultInteractions: false,
              barGroupingType: charts.BarGroupingType.grouped,
              barRendererDecorator: charts.BarLabelDecorator(
                // Move labels outside the bars (on top)
                labelPosition: charts.BarLabelPosition.outside,
                outsideLabelStyleSpec: charts.TextStyleSpec(
                  fontSize: 8,
                  fontWeight: "bold",
                  color: charts.MaterialPalette.black,
                ),
              ),
              domainAxis: const charts.OrdinalAxisSpec(
                renderSpec: charts.SmallTickRendererSpec(
                  labelStyle: charts.TextStyleSpec(
                    fontSize: 7,
                    color: charts.MaterialPalette.black,
                    fontWeight: "bold",
                  ),
                ),
              ),
              primaryMeasureAxis: charts.NumericAxisSpec(
                tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
                  (num? value) => 'R${value?.round() ?? 0}',
                ),
                renderSpec: charts.NoneRenderSpec(),
                viewport: charts.NumericExtents(0, _getMaxYValueForMonthly()),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Button 3 Daily: FL Chart with 31-day view - Fixed with proper padding and date range handling
  Widget _buildButton3DailyChart(BuildContext context) {
    List<BarChartGroupData> barData = _getButton3DailyBarData();

    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8, top: 16),
      child: CustomCard(
        elevation: 6,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          height: 220, // Fixed height for better control
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (barData.isEmpty) {
                  return _buildNoDataMessage();
                }

                final double barsSpace = 0.5; // Fixed spacing between bars
                double maxYValue = _getMaxYValue();

                return Padding(
                  padding: const EdgeInsets.all(12.0), // Reduced padding
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.center,
                      barTouchData: BarTouchData(enabled: false),
                      gridData: _buildGridData(),
                      titlesData: _buildButton3DailyTitlesData(),
                      borderData: _buildBorderData(),
                      groupsSpace: barsSpace,
                      barGroups: barData,
                      maxY: maxYValue, // Set dynamic maxY
                      minY: 0,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Button 3 Monthly: charts_flutter grouped bar chart - Fixed with proper label positioning and maxY
  Widget _buildButton3MonthlyChart(BuildContext context) {
    List<charts.Series<AveragePremiumData, String>> seriesData =
        _getButton3MonthlySeriesData();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: CustomCard3(
        elevation: 6,
        color: Colors.white,
        boderRadius: 20,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          height: 180, // Reduced height for better fitting
          child: Padding(
            padding: const EdgeInsets.all(8.0), // Reduced padding
            child: charts.BarChart(
              seriesData,
              animate: true,
              defaultInteractions: false,
              barGroupingType: charts.BarGroupingType.grouped,
              barRendererDecorator: charts.BarLabelDecorator(
                // Move labels outside the bars (on top)
                labelPosition: charts.BarLabelPosition.outside,
                outsideLabelStyleSpec: charts.TextStyleSpec(
                  fontSize: 8,
                  fontWeight: "bold",
                  color: charts.MaterialPalette.black,
                ),
              ),
              domainAxis: const charts.OrdinalAxisSpec(
                renderSpec: charts.SmallTickRendererSpec(
                  labelStyle: charts.TextStyleSpec(
                    fontSize: 7,
                    color: charts.MaterialPalette.black,
                    fontWeight: "bold",
                  ),
                ),
              ),
              primaryMeasureAxis: charts.NumericAxisSpec(
                tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
                  (num? value) => 'R${value?.round() ?? 0}',
                ),
                renderSpec: charts.NoneRenderSpec(),
                viewport: charts.NumericExtents(0, _getMaxYValueForMonthly()),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoDataMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Text(
          "No premium data available for the selected range",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  // Data processing methods - Fixed for Button 1 to show days of the current month
  List<BarChartGroupData> _getButton1BarData() {
    print('  🔍 Getting Button 1 Bar Data:');

    if (salesDataResponse?.premiumResultList == null ||
        salesDataResponse!.premiumResultList!.isEmpty) {
      print('    ❌ No premium data available - returning empty list');
      return [];
    }

    print(
        '    ✅ Premium data found: ${salesDataResponse!.premiumResultList!.length} items');

    // Create a map for quick lookup of premium data by day of month
    Map<int, double> premiumDataMap = {};

    // Get the actual days from the date range for Button 1 (current month)
    if (Constants.sales_formattedStartDate != null &&
        Constants.sales_formattedEndDate != null) {
      DateTime startDate = DateTime.parse(Constants.sales_formattedStartDate);
      DateTime endDate = DateTime.parse(Constants.sales_formattedEndDate);

      // Map premium data by actual day of month
      for (var premium in salesDataResponse!.premiumResultList!) {
        try {
          DateTime premiumDate = DateTime.parse(premium.date);
          int dayOfMonth = premiumDate.day;
          premiumDataMap[dayOfMonth] = premium.averagePremium;
          print('    - Day $dayOfMonth: ${premium.averagePremium}');
        } catch (e) {
          // Fallback to x value if date parsing fails
          premiumDataMap[premium.x + 1] = premium.averagePremium;
        }
      }
    } else {
      // Fallback: use x values as days
      for (var premium in salesDataResponse!.premiumResultList!) {
        int dayOfMonth = premium.x + 1; // Convert 0-based to 1-based
        premiumDataMap[dayOfMonth] = premium.averagePremium;
        print('    - Day $dayOfMonth: ${premium.averagePremium}');
      }
    }

    // Create bars for all days of the month (1-31)
    List<BarChartGroupData> barData = [];

    // Determine how many days to show (based on the month)
    int daysInMonth =
        31; // Default to 31, could be made dynamic based on actual month
    if (Constants.sales_formattedStartDate != null) {
      DateTime date = DateTime.parse(Constants.sales_formattedStartDate);
      daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    }

    for (int day = 1; day <= daysInMonth; day++) {
      double premiumValue = premiumDataMap[day] ?? 0.0;

      barData.add(BarChartGroupData(
        x: day, // Use actual day numbers (1-based)
        barRods: [
          BarChartRodData(
            toY: premiumValue,
            color:
                premiumValue > 0 ? Colors.blue : Colors.grey.withOpacity(0.3),
            width: 6, // Reduced width for better fit
            borderRadius: BorderRadius.circular(0),
          ),
        ],
      ));
    }

    return barData;
  }

  List<charts.Series<AveragePremiumData, String>> _getButton2SeriesData() {
    if (salesDataResponse?.premiumResultList == null ||
        salesDataResponse!.premiumResultList!.isEmpty) return [];

    return [
      charts.Series<AveragePremiumData, String>(
        id: 'AveragePremium',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (AveragePremiumData data, _) => data.period,
        measureFn: (AveragePremiumData data, _) => data.averagePremium,
        data: _processDataForAveragePremiumMonthly(),
        labelAccessorFn: (AveragePremiumData data, _) =>
            'R${data.averagePremium.round()}',
      ),
    ];
  }

  // Fixed Button 3 Daily with proper padding and date range handling
  List<BarChartGroupData> _getButton3DailyBarData() {
    if (salesDataResponse?.premiumResultList == null ||
        salesDataResponse!.premiumResultList!.isEmpty) return [];

    List<BarChartGroupData> barData = [];

    // Check if we have exactly a month or less than 31 days
    bool isExactMonth = _isExactlyOneMonth();

    if (isExactMonth) {
      // For exactly one month, show the actual date range
      if (Constants.sales_formattedStartDate != null &&
          Constants.sales_formattedEndDate != null) {
        DateTime startDate = DateTime.parse(Constants.sales_formattedStartDate);
        DateTime endDate = DateTime.parse(Constants.sales_formattedEndDate);
        int totalDays = endDate.difference(startDate).inDays + 1;

        // Create a map for quick lookup
        Map<String, double> premiumDataMap = {};
        for (var premium in salesDataResponse!.premiumResultList!) {
          premiumDataMap[premium.date] = premium.averagePremium;
        }

        // Create bars for each day in the range
        for (int i = 0; i < totalDays; i++) {
          DateTime currentDate = startDate.add(Duration(days: i));
          String dateStr =
              "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
          double premiumValue = premiumDataMap[dateStr] ?? 0.0;

          barData.add(BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: premiumValue,
                color: premiumValue > 0
                    ? Colors.blue
                    : Colors.grey.withOpacity(0.3),
                width: 8,
                borderRadius: BorderRadius.circular(0),
              ),
            ],
          ));
        }
      }
    } else {
      // For less than 31 days, pad to 31 days with data right-aligned
      Map<int, double> premiumDataMap = {};
      for (var premium in salesDataResponse!.premiumResultList!) {
        premiumDataMap[premium.x] = premium.averagePremium;
      }

      // Calculate actual data count
      int dataCount = premiumDataMap.isNotEmpty
          ? premiumDataMap.keys.reduce((a, b) => a > b ? a : b) + 1
          : 0;

      // Calculate left padding to right-align the data
      int leftPadding = dataCount < 31 ? 31 - dataCount : 0;

      // Generate all 31 bars
      for (int i = 0; i < 31; i++) {
        double premiumValue = 0.0;

        // Only add actual data after the padding
        if (i >= leftPadding && premiumDataMap.containsKey(i - leftPadding)) {
          premiumValue = premiumDataMap[i - leftPadding]!;
        }

        barData.add(BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: premiumValue,
              color: premiumValue > 0 ? Colors.blue : Colors.transparent,
              width: 8,
              borderRadius: BorderRadius.circular(0),
            ),
          ],
        ));
      }
    }

    return barData;
  }

  // Helper method to check if date range is exactly one month
  bool _isExactlyOneMonth() {
    if (Constants.sales_formattedStartDate == null ||
        Constants.sales_formattedEndDate == null) {
      return false;
    }

    DateTime startDate = DateTime.parse(Constants.sales_formattedStartDate);
    DateTime endDate = DateTime.parse(Constants.sales_formattedEndDate);

    // Check if it's the first day of a month to the last day of the same month
    return startDate.day == 1 &&
        startDate.month == endDate.month &&
        startDate.year == endDate.year &&
        endDate.day == DateTime(endDate.year, endDate.month + 1, 0).day;
  }

  List<charts.Series<AveragePremiumData, String>>
      _getButton3MonthlySeriesData() {
    if (salesDataResponse?.premiumResultList == null ||
        salesDataResponse!.premiumResultList!.isEmpty) return [];

    return [
      charts.Series<AveragePremiumData, String>(
        id: 'MonthlyAveragePremium',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (AveragePremiumData data, _) => data.period,
        measureFn: (AveragePremiumData data, _) => data.averagePremium,
        data: _processDataForAveragePremiumMonthly(),
        labelAccessorFn: (AveragePremiumData data, _) =>
            'R${data.averagePremium.round()}',
      ),
    ];
  }

  List<AveragePremiumData> _processDataForAveragePremiumMonthly() {
    if (salesDataResponse?.premiumResultList == null ||
        salesDataResponse!.premiumResultList!.isEmpty) return [];
    print("Processing data for monthly average premium...");

    return salesDataResponse!.saleSummary!.map((premium) {
      print("Raw premium date: ${premium.dateOrMonth}");
      print("Raw average premium: ${premium.averagePremium}");
      // Handle both daily (YYYY-MM-DD) and monthly (YYYY-MM) formats
      DateTime date;
      try {
        if (premium.dateOrMonth.length == 7) {
          // Monthly format: "2024-07"
          date = DateTime.parse(premium.dateOrMonth + "-01");
        } else {
          // Daily format: "2024-07-15"
          date = DateTime.parse(premium.dateOrMonth);
        }
      } catch (e) {
        // Fallback if parsing fails
        print("Error parsing date: $e");
        date = DateTime.now();
      }

      String monthAbbreviation = _getMonthAbbreviation(date.month);

      return AveragePremiumData(
        period: monthAbbreviation,
        averagePremium: premium.averagePremium,
        count: premium.count,
        totalAmount: premium.totalAmount,
      );
    }).toList();
  }

  // Chart configuration methods
  FlGridData _buildGridData() {
    return FlGridData(
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
    );
  }

  FlBorderData _buildBorderData() {
    return FlBorderData(
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
    );
  }

  // Fixed Button 1 titles to show actual days of the month
  FlTitlesData _buildButton1TitlesData() {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: (value, meta) {
            int dayNumber = value.toInt(); // Already 1-based from the data

            // Show all day labels from 1 to 31
            return Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text(
                dayNumber.toString(),
                style: TextStyle(fontSize: 6), // Smaller font to fit all labels
              ),
            );
          },
        ),
        axisNameWidget: Padding(
          padding: const EdgeInsets.only(top: 0.0, bottom: 2),
          child: Text(
            _getButton1DateRangeLabel(),
            style: TextStyle(
              fontSize: 10, // Reduced font size
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        axisNameSize: 20, // Reduced axis name size
      ),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40, // Increased for better number display
          getTitlesWidget: (value, meta) {
            return Text(
              "R" + formatLargeNumber4(value.toInt().toString()),
              style: TextStyle(fontSize: 7),
            );
          },
        ),
      ),
    );
  }

  // Helper method for Button 1 date range label
  String _getButton1DateRangeLabel() {
    if (Constants.sales_formattedStartDate != null &&
        Constants.sales_formattedEndDate != null) {
      DateTime startDate = DateTime.parse(Constants.sales_formattedStartDate);
      String monthName = _getMonthAbbreviation(startDate.month);
      return 'Days of $monthName ${startDate.year}';
    }
    return 'Days of the Month';
  }

  String _getDateRangeLabel() {
    if (Constants.sales_formattedStartDate != null &&
        Constants.sales_formattedEndDate != null) {
      DateTime startDate = DateTime.parse(Constants.sales_formattedStartDate);
      DateTime endDate = DateTime.parse(Constants.sales_formattedEndDate);

      // Check if exactly one month
      if (_isExactlyOneMonth()) {
        String monthName = _getMonthAbbreviation(startDate.month);
        return '$monthName ${startDate.day} - ${endDate.day}';
      } else {
        // For other ranges, show the full date range
        String startMonth = _getMonthAbbreviation(startDate.month);
        String endMonth = _getMonthAbbreviation(endDate.month);

        if (startDate.month == endDate.month &&
            startDate.year == endDate.year) {
          return '$startMonth ${startDate.day} - ${endDate.day}';
        } else {
          return '$startMonth ${startDate.day} - $endMonth ${endDate.day}';
        }
      }
    }
    return 'Date Range';
  }

  // Fixed Button 3 Daily titles with proper date handling
  FlTitlesData _buildButton3DailyTitlesData() {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: (value, meta) {
            int position = value.toInt();

            // Check if exactly one month
            if (_isExactlyOneMonth()) {
              // For exactly one month, show actual dates
              if (Constants.sales_formattedStartDate != null) {
                DateTime startDate =
                    DateTime.parse(Constants.sales_formattedStartDate);
                DateTime currentDate = startDate.add(Duration(days: position));

                // Show labels at regular intervals
                if (position == 0 || // First day
                    (position + 1) % 7 == 0 || // Every 7th day
                    position == meta.max.toInt()) {
                  // Last day
                  return Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                      '${currentDate.day}',
                      style: TextStyle(fontSize: 8),
                    ),
                  );
                }
              }
            } else {
              // For padded 31-day view, calculate based on actual data position
              if (Constants.sales_formattedStartDate != null &&
                  Constants.sales_formattedEndDate != null) {
                DateTime startDate =
                    DateTime.parse(Constants.sales_formattedStartDate);
                DateTime endDate =
                    DateTime.parse(Constants.sales_formattedEndDate);
                int totalDays = endDate.difference(startDate).inDays + 1;
                int leftPadding = totalDays < 31 ? 31 - totalDays : 0;

                // Only show dates for actual data positions
                if (position >= leftPadding) {
                  DateTime actualDate =
                      startDate.add(Duration(days: position - leftPadding));

                  // Show labels at regular intervals
                  if (position == leftPadding || // First day with data
                      (position - leftPadding + 1) % 7 ==
                          0 || // Every 7th day of actual data
                      position == 30) {
                    // Last position
                    return Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text(
                        '${actualDate.day}',
                        style: TextStyle(fontSize: 8),
                      ),
                    );
                  }
                }
              }
            }

            return Container(); // Empty container for other positions
          },
        ),
        axisNameWidget: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
            _getDateRangeLabel(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        axisNameSize: 20, // Reduced axis name size
      ),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 35, // Increased for better number display
          getTitlesWidget: (value, meta) {
            return Text(
              "R" + formatLargeNumber2(value.toInt().toString()),
              style: TextStyle(fontSize: 7),
            );
          },
        ),
      ),
    );
  }

  // Helper methods
  String _getMonthAbbreviation(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month];
  }

  int _getMonthNumber(String monthAbbr) {
    const months = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12
    };
    return months[monthAbbr] ?? 1;
  }

  String formatLargeNumber4(String number) {
    // Implement your number formatting logic
    return number;
  }

  String formatLargeNumber2(String number) {
    // Implement your number formatting logic
    return number;
  }
}

class PremiumResult {
  final String date;
  final double averagePremium;
  final double totalAmount;
  final int count;
  final int x;

  PremiumResult({
    required this.date,
    required this.averagePremium,
    required this.totalAmount,
    required this.count,
    required this.x,
  });

  factory PremiumResult.fromJson(Map<String, dynamic> json) {
    return PremiumResult(
      date: json['date'] ?? '',
      averagePremium: (json['average_premium'] ?? 0.0).toDouble(),
      totalAmount: (json['total_amount'] ?? 0.0).toDouble(),
      count: json['count'] ?? 0,
      x: json['x'] ?? 0,
    );
  }
}

// Update your SalesDataResponse class to include:
// List<PremiumResult>? premiumResultList;
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
      titleStyle: employee.percentageDebitOrderClients >= minPercentageForLabel
          ? const TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)
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
      title: employee.percentageSalaryDeductionClients >= minPercentageForLabel
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
      value: employee.percentagePersalClients, // Use actual percentage as value
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
      .where((data) => data.percentage > 0) // Only include non-zero percentages
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
      title: employee.percentageSalaryDeductionClients >= minPercentageForLabel
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

class SalesDataWidget extends StatelessWidget {
  const SalesDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SalesDataResponse data = Constants.currentSalesDataResponse;
    int allSales = data.totalSaleCounts;
    final inforced = data.totalInforcedCounts;
    final notAccepted = data.totalNotInforcedCounts;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: _buildMetricCard(
              title: "All Sales",
              value: formatLargeNumber(allSales.toString()),
              icon: Icons.monetization_on,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildMetricCard(
              title: "Inforced",
              value: formatLargeNumber(inforced.toString()),
              icon: Icons.check_circle,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildMetricCard(
              title: "Not Accepted",
              value: formatLargeNumber(notAccepted.toString()),
              icon: Icons.cancel,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class SalesChartWidget2 extends StatelessWidget {
  final int selectedButton;
  final int salesIndex;
  final int noOfDaysThisMonth;
  final int daysDifference;
  final bool isSalesDataLoading1a;
  final bool isSalesDataLoading2a;
  final bool isSalesDataLoading3a;
  final bool? isSalesDataLoading4a;

  const SalesChartWidget2({
    Key? key,
    required this.selectedButton,
    required this.salesIndex,
    required this.noOfDaysThisMonth,
    required this.daysDifference,
    required this.isSalesDataLoading1a,
    required this.isSalesDataLoading2a,
    required this.isSalesDataLoading3a,
    this.isSalesDataLoading4a,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (selectedButton == 1 ||
        selectedButton == 2 ||
        (selectedButton == 3 && daysDifference <= 31) ||
        selectedButton == 4) {
      return _buildChartWidget();
    }
    return Container(); // Fallback for other cases
  }

  // Helper function to get chart data based on selected button and sales index
  List<FlSpot> _getChartData() {
    switch (selectedButton) {
      case 1:
      case 3:
        // MTD and Custom Range use same graph structure
        switch (salesIndex) {
          case 0:
            return Constants.currentSalesDataResponse?.resultLista
                    ?.map((data) => data.toFlSpot())
                    .toList() ??
                [];
          case 1:
            return Constants.currentSalesDataResponse?.resultListb
                    ?.map((data) => data.toFlSpot())
                    .toList() ??
                [];
          case 2:
            return Constants.currentSalesDataResponse?.resultListc
                    ?.map((data) => data.toFlSpot())
                    .toList() ??
                [];
          default:
            return [];
        }
      case 2:
      case 4:
        // 12 Months and Range Selection use same graph structure
        switch (salesIndex) {
          case 0:
            return Constants.currentSalesDataResponse?.resultLista
                    ?.map((data) => data.toFlSpot())
                    .toList() ??
                [];
          case 1:
            return Constants.currentSalesDataResponse?.resultListb
                    ?.map((data) => data.toFlSpot())
                    .toList() ??
                [];
          case 2:
            return Constants.currentSalesDataResponse?.resultListc
                    ?.map((data) => data.toFlSpot())
                    .toList() ??
                [];
          default:
            return [];
        }
      default:
        return [];
    }
  }

  // Helper function to get chart bounds
  Map<String, double> _getChartBounds() {
    final data = _getChartData();
    if (data.isEmpty) {
      return {'minX': 0, 'maxX': 0, 'maxY': 100};
    }

    final maxY =
        data.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) * 1.1;

    if (selectedButton == 1 || selectedButton == 3) {
      // MTD and Custom Range
      return {
        'minX': data.first.x,
        'maxX':
            (selectedButton == 1) ? noOfDaysThisMonth.toDouble() : data.last.x,
        'maxY': maxY,
      };
    } else {
      // 12 Months and Range Selection
      return {
        'minX': data.first.x,
        'maxX': data.last.x,
        'maxY': maxY,
      };
    }
  }

  // Helper function to create bottom titles widget
  Widget _getBottomTitlesWidget(double value, TitleMeta meta) {
    if (selectedButton == 1 || selectedButton == 3) {
      // MTD and Custom Range - show day numbers
      if (selectedButton == 3) {
        DateTime baseDate = DateTime.parse(Constants.sales_formattedStartDate);
        DateTime date = baseDate.add(Duration(days: value.toInt()));
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            date.day.toString(),
            style: TextStyle(fontSize: 7),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            value.toInt().toString(),
            style: TextStyle(fontSize: 7),
          ),
        );
      }
    } else {
      // 12 Months and Range Selection - show month abbreviations
      int totalMonths = value.toInt();
      int year = totalMonths ~/ 12;
      int month = totalMonths % 12;
      month = month == 0 ? 12 : month;
      year = month == 12 ? year - 1 : year;
      String monthAbbreviation = getMonthAbbreviation(month);

      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          monthAbbreviation,
          style: TextStyle(fontSize: 10),
        ),
      );
    }
  }

  // Helper function to get target data
  List<FlSpot> _getTargetData() {
    if (selectedButton == 1 || selectedButton == 3) {
      // Daily targets for MTD and Custom Range
      return _removeZeroValuesFromDaily(
          Constants.currentSalesDataResponse?.targetSpotsDaily ?? [],
          selectedButton,
          daysDifference);
    } else if (selectedButton == 2 || selectedButton == 4) {
      // Monthly targets for 12 Months and Range Selection
      return Constants.currentSalesDataResponse?.targetSpotsMonthly ?? [];
    }
    return [];
  }

  // Helper function to create line chart bars
  List<LineChartBarData> _getLineChartBars() {
    final spots = _getChartData();
    final targetSpots = _getTargetData();

    return [
      // Main data line
      LineChartBarData(
        spots: spots,
        isCurved: true,
        barWidth: 3,
        color: Colors.grey.shade400,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) {
            return CustomDotPainter(
              dotColor: Constants.ctaColorLight,
              dotSize: 6,
            );
          },
        ),
      ),
      // Target line
      if (targetSpots.isNotEmpty)
        LineChartBarData(
          spots: targetSpots,
          isCurved: (selectedButton == 2 || selectedButton == 4) ? false : true,
          barWidth: 3,
          color: Colors.green,
          dotData: FlDotData(
            show: false,
            getDotPainter: (spot, percent, barData, index) {
              return CustomDotPainter(
                dotColor: Colors.transparent,
                dotSize: 6,
              );
            },
          ),
        ),
    ];
  }

  // Helper function to create chart touch data
  LineTouchData _getLineTouchData() {
    return LineTouchData(
      enabled: true,
      touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
        // TODO: Utilize touch event here to perform any operation
      },
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (value) => Colors.blueGrey,
        tooltipRoundedRadius: 20.0,
        showOnTopOfTheChartBoxArea: false,
        fitInsideHorizontally: true,
        tooltipMargin: 0,
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((LineBarSpot touchedSpot) {
            const textStyle = TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white70,
            );
            return LineTooltipItem(
              touchedSpot.y.round().toString(),
              textStyle,
            );
          }).toList();
        },
      ),
      getTouchedSpotIndicator:
          (LineChartBarData barData, List<int> indicators) {
        return indicators.map((int index) {
          final line = FlLine(
            color: Colors.grey,
            strokeWidth: 1,
            dashArray: [2, 4],
          );
          return TouchedSpotIndicatorData(line, FlDotData(show: false));
        }).toList();
      },
      getTouchLineEnd: (_, __) => double.infinity,
    );
  }

  // Helper function to create a complete line chart
  Widget _buildLineChart(GlobalKey key) {
    final bounds = _getChartBounds();

    return LineChart(
      key: key,
      LineChartData(
        lineBarsData: _getLineChartBars(),
        lineTouchData: _getLineTouchData(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.10),
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: _getBottomTitlesWidget,
            ),
            axisNameWidget: SalesOverviewTypeGrid(),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 20,
              getTitlesWidget: (value, meta) {
                return Text(
                  formatLargeNumber3(value.toInt().toString()),
                  style: TextStyle(
                      fontSize: (selectedButton == 2 || selectedButton == 4)
                          ? 8
                          : 7.5),
                );
              },
            ),
          ),
        ),
        minY: 0,
        maxY: bounds['maxY']!,
        minX: bounds['minX']!,
        maxX: bounds['maxX']!,
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
    );
  }

  // Helper function to get the appropriate chart key
  GlobalKey _getChartKey() {
    switch (selectedButton) {
      case 1:
        switch (salesIndex) {
          case 0:
            return Constants.sales_chartKey1a;
          case 1:
            return Constants.sales_chartKey1b;
          case 2:
            return Constants.sales_chartKey1c;
          default:
            return Constants.sales_chartKey1a;
        }
      case 2:
        switch (salesIndex) {
          case 0:
            return Constants.sales_chartKey2a;
          case 1:
            return Constants.sales_chartKey2b;
          case 2:
            return Constants.sales_chartKey2c;
          default:
            return Constants.sales_chartKey2a;
        }
      case 3:
        switch (salesIndex) {
          case 0:
            return Constants.sales_chartKey3a;
          case 1:
            return Constants.sales_chartKey3b;
          case 2:
            return Constants.sales_chartKey3c;
          default:
            return Constants.sales_chartKey3a;
        }
      case 4:
        switch (salesIndex) {
          case 0:
            return Constants.sales_chartKey4a;
          case 1:
            return Constants.sales_chartKey4b;
          case 2:
            return Constants.sales_chartKey4c;
          default:
            return Constants.sales_chartKey4a;
        }
      default:
        return Constants.sales_chartKey1a;
    }
  }

  // Helper function to check if loading
  bool _isLoading() {
    switch (selectedButton) {
      case 1:
        return isSalesDataLoading1a;
      case 2:
        return isSalesDataLoading2a;
      case 3:
        return isSalesDataLoading3a;
      case 4:
        return isSalesDataLoading4a ?? false;
      default:
        return false;
    }
  }

  // Main chart widget
  Widget _buildChartWidget() {
    return Container(
      height: 280,
      child: Padding(
        padding: EdgeInsets.only(
          top: (selectedButton == 1) ? 8.0 : 0.0,
          bottom: (selectedButton == 1) ? 8.0 : 0.0,
          left: 16.0,
          right: 16.0,
        ),
        child: (selectedButton == 4)
            ? Row(
                children: [
                  Expanded(
                    child: CustomCard(
                      elevation: 6,
                      color: Colors.white,
                      surfaceTintColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: _buildChartContent(),
                      ),
                    ),
                  ),
                ],
              )
            : CustomCard(
                elevation: 6,
                color: Colors.white,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 14.0,
                    right: 14.0,
                    top: (selectedButton == 1) ? 20.0 : 14.0,
                    bottom: (selectedButton == 1) ? 14.0 : 0.0,
                  ),
                  child: _buildChartContent(),
                ),
              ),
      ),
    );
  }

  // Helper function to build chart content
  Widget _buildChartContent() {
    if (_isLoading()) {
      return Container(
        height: 250,
        child: Center(
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

    if (_getChartData().isEmpty) {
      return Container(
        height: 250,
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

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              top: (selectedButton == 1)
                  ? 12.0
                  : (selectedButton == 4)
                      ? 4.0
                      : 0.0,
            ),
            child: _buildLineChart(_getChartKey()),
          ),
        ),
        if (selectedButton == 1 || selectedButton == 3) ...[
          SizedBox(height: 6),
          Text(
            "Weekend Sales are Added to / Accounted For On The Next Monday",
            style: TextStyle(fontSize: 9),
          ),
          SizedBox(
            height: 12,
          )
        ],
        if (selectedButton == 2) SizedBox(height: 8),
        if (selectedButton == 4) SizedBox(height: 12),
      ],
    );
  }
}

class ChartWidget extends StatefulWidget {
  final int selectedButton;
  final int days;
  final SalesDataResponse? salesDataResponse;

  const ChartWidget({
    Key? key,
    required this.selectedButton,
    required this.days,
    this.salesDataResponse,
  }) : super(key: key);

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  int ntu_lapse_index = 0;
  double _sliderPosition3 = 0;
  bool isSalesDataLoading2a = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTabSelector(),
        _buildChartTitle(),
        _buildChart(),
      ],
    );
  }

  // Tab selector widget
  Widget _buildTabSelector() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Row(
                  children: [
                    _buildTabButton('NTU Rate', 0),
                    _buildTabButton('Lapse Rate', 1),
                  ],
                ),
              ),
            ),
            _buildAnimatedSlider(),
          ],
        ),
      ),
    );
  }

  // Individual tab button
  Widget _buildTabButton(String title, int index) {
    return GestureDetector(
      onTap: () => _animateButton3(index),
      child: Container(
        width: (MediaQuery.of(context).size.width / 2) - 16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(360),
        ),
        height: 35,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  // Animated slider for tab selection
  Widget _buildAnimatedSlider() {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      left: _sliderPosition3,
      child: InkWell(
        onTap: () {},
        child: Container(
          width: (MediaQuery.of(context).size.width / 2) - 16,
          height: 35,
          decoration: BoxDecoration(
            color: Constants.ctaColorLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              ntu_lapse_index == 0 ? 'NTU Rate' : 'Lapse Rate',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  // Chart title based on selected tab - always shows 12 months
  Widget _buildChartTitle() {
    if (ntu_lapse_index == -1) return Container();

    String chartType = ntu_lapse_index == 0 ? 'NTU Rate' : 'Lapse Rate';

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 12),
      child: Text("$chartType (Past 12 Months)"),
    );
  }

  // Main chart container
  Widget _buildChart() {
    return Container(
      height: 280,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          bottom: 0,
          left: 16.0,
          right: 16,
        ),
        child: CustomCard(
          elevation: 6,
          color: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: _buildChartContent(),
          ),
        ),
      ),
    );
  }

  // Chart content with loading and data states
  Widget _buildChartContent() {
    if (isSalesDataLoading2a) {
      return _buildLoadingIndicator();
    }

    List<FlSpot> chartData = _getChartData();

    if (chartData.isEmpty) {
      return _buildNoDataState();
    }

    return _buildLineChart(chartData);
  }

  // Loading indicator
  Widget _buildLoadingIndicator() {
    return Center(
      child: Container(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          color: Constants.ctaColorLight,
          strokeWidth: 1.8,
        ),
      ),
    );
  }

  // No data state
  Widget _buildNoDataState() {
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No data available for the past 12 months",
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
          ),
        ],
      ),
    );
  }

  // Line chart widget
  Widget _buildLineChart(List<FlSpot> chartData) {
    return Column(
      children: [
        Expanded(
          child: LineChart(
            key: Constants.sales_lapsechartKey2a,
            LineChartData(
              lineTouchData: _buildLineTouchData(),
              lineBarsData: _buildLineBarsData(chartData),
              gridData: _buildGridData(),
              titlesData: _buildTitlesData(),
              minY: 0,
              maxY: _getMaxY(),
              minX: _getMinX(),
              maxX: _getMaxX(),
              borderData: _buildBorderData(),
            ),
          ),
        ),
        SizedBox(height: 0),
      ],
    );
  }

  // Line touch data configuration
  LineTouchData _buildLineTouchData() {
    return LineTouchData(
      enabled: true,
      touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
        // Handle touch events
      },
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (value) => Colors.blueGrey,
        tooltipRoundedRadius: 20.0,
        showOnTopOfTheChartBoxArea: false,
        fitInsideHorizontally: true,
        tooltipMargin: 0,
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((LineBarSpot touchedSpot) {
            const textStyle = TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white70,
            );
            return LineTooltipItem(
              '${touchedSpot.y.round()}%',
              textStyle,
            );
          }).toList();
        },
      ),
      getTouchedSpotIndicator:
          (LineChartBarData barData, List<int> indicators) {
        return indicators.map((int index) {
          final line = FlLine(
            color: Colors.grey,
            strokeWidth: 1,
            dashArray: [2, 4],
          );
          return TouchedSpotIndicatorData(
            line,
            FlDotData(show: false),
          );
        }).toList();
      },
      getTouchLineEnd: (_, __) => double.infinity,
    );
  }

  // Line bars data configuration
  List<LineChartBarData> _buildLineBarsData(List<FlSpot> chartData) {
    List<FlSpot> targetData = _getTargetData();

    return [
      LineChartBarData(
        spots: chartData,
        isCurved: true,
        barWidth: 3,
        color: Colors.grey.shade400,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) {
            return CustomDotPainter2(
              dotColor: Constants.ftaColorLight,
              dotSize: 6,
            );
          },
        ),
      ),
      if (targetData.isNotEmpty)
        LineChartBarData(
          spots: targetData,
          isCurved: true,
          barWidth: 1.5,
          color: Colors.green,
          dotData: FlDotData(show: false),
        ),
    ];
  }

  // Grid data configuration
  FlGridData _buildGridData() {
    return FlGridData(
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
    );
  }

  // Titles data configuration
  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: (value, meta) {
            return _getBottomTitleWidget(value);
          },
        ),
        axisNameWidget: LapseLineTypeGrid(),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 10,
          getTitlesWidget: (value, meta) {
            return Container();
          },
        ),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 25,
          getTitlesWidget: (value, meta) {
            return Container();
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: _getYAxisInterval(),
          getTitlesWidget: (value, meta) {
            return _getLeftTitleWidget(value);
          },
        ),
      ),
    );
  }

  // Bottom title widget - shows month abbreviations for past 12 months
  Widget _getBottomTitleWidget(double value) {
    List<FlSpot> data = _getChartData();
    if (data.isEmpty) return Container();

    // Find the data point that matches this x value
    FlSpot? matchingSpot;
    try {
      matchingSpot = data.firstWhere((spot) => spot.x == value);
    } catch (e) {
      return Container();
    }

    // Get the corresponding date from the original data
    String monthAbbreviation = _getMonthAbbreviationFromX(value);

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Text(
        monthAbbreviation,
        style: TextStyle(fontSize: 10),
      ),
    );
  }

  // Get month abbreviation from x value
  String _getMonthAbbreviationFromX(double x) {
    // Get the 12-month data source
    List<MonthlyRateData> sourceData = ntu_lapse_index == 0
        ? (widget.salesDataResponse?.ntuResultList12Months ?? [])
        : (widget.salesDataResponse?.lapseResultList12Months ?? []);

    try {
      // Use array index to find the matching month
      int index = x.toInt();
      if (index >= 0 && index < sourceData.length) {
        String dateStr = sourceData[index].date;
        if (dateStr.isNotEmpty) {
          // Parse month from format like "2024-07"
          if (dateStr.contains('-')) {
            List<String> parts = dateStr.split('-');
            if (parts.length >= 2) {
              int month = int.tryParse(parts[1]) ?? 1;
              return getMonthAbbreviation(month);
            }
          }
        }
      }
    } catch (e) {
      // Fallback
    }

    // Final fallback: calculate from x value
    int totalMonths = x.toInt();
    int month = (totalMonths % 12) + 1;
    return getMonthAbbreviation(month);
  }

  // Left title widget (Y-axis labels)
  Widget _getLeftTitleWidget(double value) {
    // Show percentage labels at regular intervals
    if (value % _getYAxisInterval() == 0) {
      return Text(
        '${value.toInt()}%',
        style: TextStyle(fontSize: 8, color: Colors.grey[600]),
      );
    }
    return Container();
  }

  // Get appropriate Y-axis interval based on data range
  double _getYAxisInterval() {
    // Since maxY is always 100, use a fixed interval of 20
    // This will show: 0%, 20%, 40%, 60%, 80%, 100%
    return 20;
  }

  // Border data configuration
  FlBorderData _buildBorderData() {
    return FlBorderData(
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
    );
  }

  // Data retrieval methods - use 12 months data directly
  List<FlSpot> _getChartData() {
    List<MonthlyRateData> sourceData =
        ntu_lapse_index == 0 ? _get12MonthsNTUData() : _get12MonthsLapseData();

    return _convertMonthlyRateToFlSpot(sourceData);
  }

  List<FlSpot> _getTargetData() {
    // Get chart data to match the x-coordinates
    List<FlSpot> chartData = _getChartData();
    if (chartData.isEmpty) return [];

    // Define target values: NTU = 30%, Lapse = 40%
    double targetValue = ntu_lapse_index == 0 ? 30.0 : 40.0;

    // Create a straight line across all x points
    return chartData.map((spot) => FlSpot(spot.x, targetValue)).toList();
  }

  // Get 12 months of NTU data from the dedicated field
  List<MonthlyRateData> _get12MonthsNTUData() {
    return widget.salesDataResponse?.ntuResultList12Months ?? [];
  }

  // Get 12 months of Lapse data from the dedicated field
  List<MonthlyRateData> _get12MonthsLapseData() {
    return widget.salesDataResponse?.lapseResultList12Months ?? [];
  }

  // Helper method to convert MonthlyRateData to FlSpot
  List<FlSpot> _convertMonthlyRateToFlSpot(
      List<MonthlyRateData> monthlyRateList) {
    // Only take the last 12 months if there are more than 12 entries
    List<MonthlyRateData> last12Months = monthlyRateList.length > 12
        ? monthlyRateList.sublist(monthlyRateList.length - 12)
        : monthlyRateList;

    return last12Months.asMap().entries.map((entry) {
      int index = entry.key;
      MonthlyRateData monthlyRate = entry.value;
      // Use index as x-coordinate for consistent spacing (0-11 for 12 months)
      return FlSpot(index.toDouble(), monthlyRate.rate);
    }).toList();
  }

  // Chart bounds methods
  double _getMinX() {
    List<FlSpot> data = _getChartData();
    return data.isEmpty ? 0 : 0; // Always start from 0 for consistent view
  }

  double _getMaxX() {
    List<FlSpot> data = _getChartData();
    return data.isEmpty
        ? 11
        : (data.length - 1).toDouble(); // 0-11 for 12 months
  }

  // Get maximum Y value for chart scaling
  double _getMaxY() {
    // Always return 100 to ensure the graph ends at 100%
    return 100;
  }

  // Animation method
  void _animateButton3(int index) {
    setState(() {
      ntu_lapse_index = index;
      _sliderPosition3 = index * ((MediaQuery.of(context).size.width / 2) - 16);
    });
  }
}

// Helper function to get month abbreviation (implement this if not already available)
String getMonthAbbreviation2(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return months[month - 1];
}

// Helper function to format large numbers (implement this if not already available)
String formatLargeNumber3c(String number) {
  // Implement your number formatting logic here
  return number;
}

// Extension methods for utility functions
extension ChartUtils on _ChartWidgetState {
  String getMonthAbbreviation(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month];
  }

  String formatLargeNumber3(String number) {
    // Implement your number formatting logic
    return number;
  }
}

// Usage example:
class ParentWidget extends StatefulWidget {
  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  int selectedButton = 1;
  int days = 30;
  SalesDataResponse? salesDataResponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChartWidget(
        selectedButton: selectedButton,
        days: days,
        salesDataResponse: salesDataResponse,
      ),
    );
  }
}

class AgentDataWidget extends StatefulWidget {
  final int selectedButton;
  final int daysDifference;
  final int gridIndex;
  final int salesIndex;
  final SalesDataResponse? salesDataResponse;
  final bool isLoading;

  const AgentDataWidget({
    Key? key,
    required this.selectedButton,
    required this.daysDifference,
    required this.gridIndex,
    required this.salesIndex,
    this.salesDataResponse,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<AgentDataWidget> createState() => _AgentDataWidgetState();
}

class _AgentDataWidgetState extends State<AgentDataWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.gridIndex == 0) {
      return _buildSalesGrid();
    } else if (widget.gridIndex == 1) {
      return _buildNTULapseGrid();
    } else if (widget.gridIndex == 2) {
      return _buildAmountGrid();
    }
    return Container();
  }

  // Sales Grid (grid_index == 0)
  Widget _buildSalesGrid() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 8, left: 16, right: 16),
      child: CustomCard3(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        boderRadius: 20,
        child: Column(
          children: [
            _buildSalesHeader(),
            _buildSalesContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.35),
        borderRadius: BorderRadius.circular(24),
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
                borderRadius: BorderRadius.circular(360),
              ),
              child: Center(
                child: Text("#", style: TextStyle(color: Colors.black)),
              ),
            ),
            SizedBox(width: 12),
            Expanded(flex: 4, child: Text("Agent Name")),
            Container(
              width: 70,
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text("Sales", textAlign: TextAlign.right),
              ),
            ),
            SizedBox(width: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesContent() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12, top: 12),
      child: widget.isLoading ? _buildLoadingIndicator() : _buildSalesList(),
    );
  }

  Widget _buildSalesList() {
    List<Employee> employees = _getSalesEmployeeList();

    if (employees.isEmpty) {
      return _buildNoDataMessage();
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 0, bottom: 16),
      itemCount: min(employees.length, 10),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => _buildSalesItem(employees[index], index),
    );
  }

  Widget _buildSalesItem(Employee employee, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
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
                child:
                    Text(extractFirstAndLastName(employee.employee.trimLeft())),
              ),
              Container(
                width: 70,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(
                    "${employee.totalSales}",
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              SizedBox(width: 28),
            ],
          ),
          SizedBox(height: 3),
          _buildDivider(),
        ],
      ),
    );
  }

  // NTU/Lapse Grid (grid_index == 1)
  Widget _buildNTULapseGrid() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 12, bottom: 8, right: 16),
      child: CustomCard3(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        elevation: 6,
        boderRadius: 20,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            _buildNTULapseHeader(),
            _buildNTULapseContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildNTULapseHeader() {
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
                borderRadius: BorderRadius.circular(360),
              ),
              child: Center(
                child: Text("#", style: TextStyle(color: Colors.black)),
              ),
            ),
            SizedBox(width: 12),
            Expanded(flex: 4, child: Text("Agent Name")),
            Container(
              width: 70,
              child: Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Text("NTU", textAlign: TextAlign.right),
              ),
            ),
            Container(
              width: 70,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text("Lapse", textAlign: TextAlign.right),
              ),
            ),
            SizedBox(width: 12)
          ],
        ),
      ),
    );
  }

  Widget _buildNTULapseContent() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12, top: 12),
      child: widget.isLoading ? _buildLoadingIndicator() : _buildNTULapseList(),
    );
  }

  Widget _buildNTULapseList() {
    List<EmployeeRate> employees = _getNTULapseEmployeeList();

    if (employees.isEmpty) {
      return _buildNoDataMessage();
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 0, bottom: 16),
      itemCount: min(employees.length, 10),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) =>
          _buildNTULapseItem(employees[index], index),
    );
  }

  Widget _buildNTULapseItem(EmployeeRate employee, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
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
                child: Text(
                    extractFirstAndLastName(employee.employeeName.trimLeft())),
              ),
              Container(
                width: 70,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "${employee.ntuRate.toStringAsFixed(1)}%",
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              Container(
                width: 70,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "${employee.lapseRate.toStringAsFixed(1)}%",
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              SizedBox(width: 12)
            ],
          ),
          SizedBox(height: 3),
          _buildDivider(),
        ],
      ),
    );
  }

  // Amount Grid (grid_index == 2)
  Widget _buildAmountGrid() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 12, bottom: 8, right: 16),
      child: CustomCard3(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        elevation: 6,
        boderRadius: 20,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            _buildAmountHeader(),
            _buildAmountContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountHeader() {
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
                borderRadius: BorderRadius.circular(360),
              ),
              child: Center(
                child: Text("#", style: TextStyle(color: Colors.black)),
              ),
            ),
            SizedBox(width: 12),
            Expanded(flex: 4, child: Text("Agent Name")),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text("Amount", textAlign: TextAlign.left),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountContent() {
    return widget.isLoading
        ? _buildLoadingIndicator()
        : Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12, top: 12),
            child: _buildAmountList(),
          );
  }

  Widget _buildAmountList() {
    List<EmployeeRate> employees = _getAmountEmployeeList();

    if (employees.isEmpty) {
      return _buildNoDataMessage();
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 0, bottom: 16),
      itemCount: min(employees.length, 10),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) =>
          _buildAmountItem(employees[index], index),
    );
  }

  Widget _buildAmountItem(EmployeeRate employee, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0),
      child: Column(
        children: [
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
                flex: 5,
                child: Text(
                    extractFirstAndLastName(employee.employeeName.trimLeft())),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "R${formatLargeNumber3(employee.totalCollected.toStringAsFixed(1))}",
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(360),
                ),
                child: InkWell(
                  onTap: () => _showCollectionMixDialog(employee),
                  child: Center(
                    child: Icon(Icons.remove_red_eye_outlined,
                        size: 18, color: Constants.ctaColorLight),
                  ),
                ),
              ),
              SizedBox(width: 4)
            ],
          ),
          _buildDivider(),
        ],
      ),
    );
  }

  // Data retrieval methods
  List<Employee> _getSalesEmployeeList() {
    if (widget.salesDataResponse == null) return [];

    if (widget.selectedButton == 1) {
      switch (widget.salesIndex) {
        case 0:
          return widget.salesDataResponse!.topEmployeesa;
        case 1:
          return widget.salesDataResponse!.topEmployeesb;
        case 2:
          return widget.salesDataResponse!.topEmployeesc;
        default:
          return widget.salesDataResponse!.topEmployeesa;
      }
    } else if (widget.selectedButton == 2) {
      switch (widget.salesIndex) {
        case 0:
          return widget.salesDataResponse!.topEmployeesa;
        case 1:
          return widget.salesDataResponse!.topEmployeesb;
        case 2:
          return widget.salesDataResponse!.topEmployeesc;
        default:
          return widget.salesDataResponse!.topEmployeesa;
      }
    } else if (widget.selectedButton == 3 && widget.daysDifference <= 31) {
      switch (widget.salesIndex) {
        case 0:
          return widget.salesDataResponse!.topEmployeesa;
        case 1:
          return widget.salesDataResponse!.topEmployeesb;
        case 2:
          return widget.salesDataResponse!.topEmployeesc;
        default:
          return widget.salesDataResponse!.topEmployeesa;
      }
    } else {
      switch (widget.salesIndex) {
        case 0:
          return widget.salesDataResponse!.topEmployeesa;
        case 1:
          return widget.salesDataResponse!.topEmployeesb;
        case 2:
          return widget.salesDataResponse!.topEmployeesc;
        default:
          return widget.salesDataResponse!.topEmployeesa;
      }
    }
  }

  List<EmployeeRate> _getNTULapseEmployeeList() {
    if (widget.salesDataResponse == null) return [];

    // For NTU/Lapse grid, we use topEmployeeRates which contains rate information
    return widget.salesDataResponse!.topEmployeeRates;
  }

  List<EmployeeRate> _getAmountEmployeeList() {
    if (widget.salesDataResponse == null) return [];

    // For Amount grid, we also use topEmployeeRates which contains collection amounts
    return widget.salesDataResponse!.topEmployeeRates;
  }

  // Helper widgets
  Widget _buildLoadingIndicator() {
    return Container(
      height: 200,
      child: Center(
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
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        height: 1,
        color: Colors.grey.withOpacity(0.10),
      ),
    );
  }

  // Collection Mix Dialog
  void _showCollectionMixDialog(EmployeeRate employee) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.symmetric(horizontal: 16.0),
          contentPadding: EdgeInsets.only(bottom: 16.0, left: 12, right: 12),
          iconPadding: EdgeInsets.symmetric(horizontal: 0.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Center(
            child: Row(
              children: [
                SizedBox(width: 8),
                Spacer(),
                const Text('Collections Mix'),
                Spacer(),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(CupertinoIcons.clear_circled,
                      color: Constants.ctaColorLight),
                ),
                SizedBox(width: 8),
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                _buildEmployeeInfoCard(employee),
                SizedBox(height: 24),
                _buildCollectionPieChart(employee),
                SizedBox(height: 32),
                Container(
                  height: 35,
                  width: MediaQuery.of(context).size.width,
                  child: CollectionsTypeGrid(),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmployeeInfoCard(EmployeeRate employee) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      surfaceTintColor: Colors.white,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 4),
              child: Text(employee.employeeName),
            ),
            SizedBox(height: 6),
            Text(' • Total Sales: ${employee.totalSales}',
                style: TextStyle(fontSize: 11)),
            Text(
                ' • Total Collected: R ${formatLargeNumber(employee.totalCollected.toStringAsFixed(1))}',
                style: TextStyle(fontSize: 11)),
            Text(' • NTU Rate: ${employee.ntuRate.toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 11)),
            Text(' • Lapse Rate: ${employee.lapseRate.toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 11)),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionPieChart(EmployeeRate employee) {
    return Container(
      height: 240,
      width: MediaQuery.of(context).size.width,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 0,
          sections: _buildPieChartSections(employee),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(EmployeeRate employee) {
    List<PieChartSectionData> sections = [];

    if (employee.percentageDebitOrderClients > 0) {
      sections.add(PieChartSectionData(
        color: Colors.orange,
        value: employee.percentageDebitOrderClients,
        title: '${employee.percentageDebitOrderClients.toStringAsFixed(1)}%',
        radius: (MediaQuery.of(context).size.width / 2) - 92,
        titleStyle: TextStyle(
            fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
      ));
    }

    if (employee.percentageCashClients > 0) {
      sections.add(PieChartSectionData(
        color: Colors.blue,
        value: employee.percentageCashClients,
        title: '${employee.percentageCashClients.toStringAsFixed(1)}%',
        radius: (MediaQuery.of(context).size.width / 2) - 92,
        titleStyle: TextStyle(
            fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
      ));
    }

    if (employee.percentageSalaryDeductionClients > 0) {
      sections.add(PieChartSectionData(
        color: Colors.yellow,
        value: employee.percentageSalaryDeductionClients,
        title:
            '${employee.percentageSalaryDeductionClients.toStringAsFixed(1)}%',
        radius: (MediaQuery.of(context).size.width / 2) - 92,
        titleStyle: TextStyle(
            fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
      ));
    }

    if (employee.percentagePersalClients > 0) {
      sections.add(PieChartSectionData(
        color: Colors.grey,
        value: employee.percentagePersalClients,
        title: '${employee.percentagePersalClients.toStringAsFixed(1)}%',
        radius: (MediaQuery.of(context).size.width / 2) - 92,
        titleStyle: TextStyle(
            fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
      ));
    }

    return sections;
  }

  // Utility methods (you'll need to implement these)
  String extractFirstAndLastName(String fullName) {
    // Implement your name extraction logic
    List<String> parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first} ${parts.last}';
    }
    return fullName;
  }

  String formatLargeNumber(String number) {
    // Implement your number formatting logic
    return number;
  }

  String formatLargeNumber2(String number) {
    // Implement your number formatting logic
    return number;
  }
}

// Usage example:
class ParentAgentWidget extends StatefulWidget {
  @override
  _ParentAgentWidgetState createState() => _ParentAgentWidgetState();
}

class _ParentAgentWidgetState extends State<ParentAgentWidget> {
  int selectedButton = 1;
  int daysDifference = 30;
  int gridIndex = 0;
  int salesIndex = 0;
  SalesDataResponse? salesDataResponse;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AgentDataWidget(
        selectedButton: selectedButton,
        daysDifference: daysDifference,
        gridIndex: gridIndex,
        salesIndex: salesIndex,
        salesDataResponse: salesDataResponse,
        isLoading: isLoading,
      ),
    );
  }
}

class BottomPerformersWidget extends StatelessWidget {
  final int selectedButton;
  final int daysDifference;
  final int salesIndex;
  final SalesDataResponse? salesDataResponse;
  final bool isLoading;

  const BottomPerformersWidget({
    Key? key,
    required this.selectedButton,
    required this.daysDifference,
    required this.salesIndex,
    this.salesDataResponse,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 0, left: 16, right: 16),
      child: CustomCard3(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        boderRadius: 20,
        child: Column(
          children: [
            _buildHeader(),
            _buildContent(context),
          ],
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
                color: Colors.red,
                borderRadius: BorderRadius.circular(360),
              ),
              child: Center(
                child: Text(
                  "#",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Text("Agent Name"),
              ),
            ),
            Container(
              width: 70,
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text(
                  "Sales",
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            SizedBox(width: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return _buildLoadingIndicator();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12, top: 12),
      child: _buildPerformersList(),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: 200,
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
      ),
    );
  }

  Widget _buildPerformersList() {
    List<Employee> employees = _getBottomPerformersData();

    if (employees.isEmpty) {
      return _buildNoDataMessage();
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 0, bottom: 16),
      reverse: true, // Keep reverse order for bottom performers
      itemCount: min(employees.length, 10),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) =>
          _buildPerformerItem(employees[index], index),
    );
  }

  Widget _buildNoDataMessage() {
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
  }

  Widget _buildPerformerItem(Employee employee, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 35,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child:
                      Text("${((index - 9).abs()) + 1} "), // Reverse numbering
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  extractFirstAndLastName(employee.employee.trimLeft()),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "${employee.totalSales}",
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
          _buildDivider(),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        height: 1,
        color: Colors.grey.withOpacity(0.10),
      ),
    );
  }

  // Data retrieval method
  List<Employee> _getBottomPerformersData() {
    if (salesDataResponse == null) return [];

    // Determine which data source to use based on business logic
    if (selectedButton == 1) {
      switch (salesIndex) {
        case 0:
          return salesDataResponse!.bottomEmployeesa;
        case 1:
          return salesDataResponse!.bottomEmployeesb;
        case 2:
          return salesDataResponse!.bottomEmployeesc;
        default:
          return salesDataResponse!.bottomEmployeesa;
      }
    } else if (selectedButton == 2) {
      switch (salesIndex) {
        case 0:
          return salesDataResponse!.bottomEmployeesa;
        case 1:
          return salesDataResponse!.bottomEmployeesb;
        case 2:
          return salesDataResponse!.bottomEmployeesc;
        default:
          return salesDataResponse!.bottomEmployeesa;
      }
    } else if (selectedButton == 3 && daysDifference <= 31) {
      switch (salesIndex) {
        case 0:
          return salesDataResponse!.bottomEmployeesa;
        case 1:
          return salesDataResponse!.bottomEmployeesb;
        case 2:
          return salesDataResponse!.bottomEmployeesc;
        default:
          return salesDataResponse!.bottomEmployeesa;
      }
    } else {
      // For selectedButton == 3 && daysDifference > 31
      switch (salesIndex) {
        case 0:
          return salesDataResponse!.bottomEmployeesa;
        case 1:
          return salesDataResponse!.bottomEmployeesb;
        case 2:
          return salesDataResponse!.bottomEmployeesc;
        default:
          return salesDataResponse!.bottomEmployeesa;
      }
    }
  }

  // Helper method for name extraction
  String extractFirstAndLastName(String fullName) {
    List<String> parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first} ${parts.last}';
    }
    return fullName;
  }
}

// Alternative implementation if you need separate data sources for different time periods
class BottomPerformersWidgetAdvanced extends StatelessWidget {
  final int selectedButton;
  final int daysDifference;
  final int salesIndex;
  final SalesDataResponse? salesDataResponse;
  final bool isLoading;

  const BottomPerformersWidgetAdvanced({
    Key? key,
    required this.selectedButton,
    required this.daysDifference,
    required this.salesIndex,
    this.salesDataResponse,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 0, left: 16, right: 16),
      child: CustomCard3(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        boderRadius: 20,
        child: Column(
          children: [
            _buildHeader(),
            _buildContent(context),
          ],
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
                color: Colors.red,
                borderRadius: BorderRadius.circular(360),
              ),
              child: Center(
                child: Text(
                  "#",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              flex: 4,
              child: Text("Agent Name"),
            ),
            Container(
              width: 70,
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text(
                  "Sales",
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            SizedBox(width: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return _buildLoadingIndicator();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12, top: 12),
      child: _buildPerformersList(),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: 200,
      child: Center(
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

  Widget _buildPerformersList() {
    List<Employee> employees = _getBottomPerformersData();

    // Handle multiple no-data conditions
    if (_shouldShowNoData(employees)) {
      return _buildNoDataMessage();
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 0, bottom: 16),
      reverse: true,
      itemCount: min(employees.length, 10),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) =>
          _buildPerformerItem(employees[index], index),
    );
  }

  bool _shouldShowNoData(List<Employee> employees) {
    if (employees.isEmpty) return true;

    // Additional checks based on specific conditions from original code
    if (selectedButton == 1) {
      if (salesIndex == 0 && employees.isEmpty) return true;
      if (salesIndex == 1 && employees.isEmpty) return true;
      if (salesIndex == 2 && employees.isEmpty) return true;
    }

    return false;
  }

  Widget _buildNoDataMessage() {
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
  }

  Widget _buildPerformerItem(Employee employee, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 35,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text("${((index - 9).abs()) + 1} "),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  extractFirstAndLastName(employee.employee.trimLeft()),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "${employee.totalSales}",
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ],
                ),
              )
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
    );
  }

  List<Employee> _getBottomPerformersData() {
    if (salesDataResponse == null) return [];

    // Map the original logic to SalesDataResponse fields
    if (selectedButton == 1) {
      switch (salesIndex) {
        case 0:
          return salesDataResponse!.bottomEmployeesa;
        case 1:
          return salesDataResponse!.bottomEmployeesb;
        case 2:
          return salesDataResponse!.bottomEmployeesc;
        default:
          return salesDataResponse!.bottomEmployeesa;
      }
    } else if (selectedButton == 2) {
      switch (salesIndex) {
        case 0:
          return salesDataResponse!.bottomEmployeesa;
        case 1:
          return salesDataResponse!.bottomEmployeesb;
        case 2:
          return salesDataResponse!.bottomEmployeesc;
        default:
          return salesDataResponse!.bottomEmployeesa;
      }
    } else if (selectedButton == 3 && daysDifference <= 31) {
      switch (salesIndex) {
        case 0:
          return salesDataResponse!.bottomEmployeesa;
        case 1:
          return salesDataResponse!.bottomEmployeesb;
        case 2:
          return salesDataResponse!.bottomEmployeesc;
        default:
          return salesDataResponse!.bottomEmployeesa;
      }
    } else {
      // selectedButton == 3 && daysDifference > 31
      switch (salesIndex) {
        case 0:
          return salesDataResponse!.bottomEmployeesa;
        case 1:
          return salesDataResponse!.bottomEmployeesb;
        case 2:
          return salesDataResponse!.bottomEmployeesc;
        default:
          return salesDataResponse!.bottomEmployeesa;
      }
    }
  }

  String extractFirstAndLastName(String fullName) {
    List<String> parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first} ${parts.last}';
    }
    return fullName;
  }
}

// Usage example:
class BottomPerformersExample extends StatefulWidget {
  @override
  _BottomPerformersExampleState createState() =>
      _BottomPerformersExampleState();
}

class _BottomPerformersExampleState extends State<BottomPerformersExample> {
  int selectedButton = 1;
  int daysDifference = 30;
  int salesIndex = 0;
  SalesDataResponse? salesDataResponse;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomPerformersWidget(
        selectedButton: selectedButton,
        daysDifference: daysDifference,
        salesIndex: salesIndex,
        salesDataResponse: salesDataResponse,
        isLoading: isLoading,
      ),
    );
  }
}

class BranchSalesChartWidget extends StatelessWidget {
  final int selectedButton;
  final int daysDifference;
  final int gridIndex2;
  final int salesIndex;
  final SalesDataResponse? salesDataResponse;
  final bool isLoading;

  const BranchSalesChartWidget({
    Key? key,
    required this.selectedButton,
    required this.daysDifference,
    required this.gridIndex2,
    required this.salesIndex,
    this.salesDataResponse,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (gridIndex2 != 1) return Container();

    return _buildChartContainer(context);
  }

  Widget _buildChartContainer(BuildContext context) {
    List<BranchSales> branchData = _getBranchSalesData();

    // Check if data is available
    if (_shouldShowNoData(branchData)) {
      return _buildNoDataCard(context);
    }

    return _buildBarChart(context, branchData);
  }

  Widget _buildNoDataCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16, top: 16),
      child: CustomCard(
        elevation: 6,
        surfaceTintColor: Colors.white,
        color: Colors.white,
        child: Container(
          height: 700,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart(BuildContext context, List<BranchSales> branchData) {
    return Container(
      key: _getChartKey(),
      height: _calculateChartHeight(branchData),
      constraints: BoxConstraints(minHeight: 120),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16, top: 8),
        child: CustomCard(
          elevation: 6,
          surfaceTintColor: Colors.white,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: isLoading ? _buildLoadingIndicator() : _buildChart(branchData),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: 200,
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
      ),
    );
  }

  Widget _buildChart(List<BranchSales> branchData) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: charts.BarChart(
        _convertToChartData(branchData),
        animate: true,
        animationDuration: const Duration(milliseconds: 500),
        vertical: false,
        barRendererDecorator: charts.BarLabelDecorator<String>(),
        primaryMeasureAxis: charts.NumericAxisSpec(
          renderSpec: charts.NoneRenderSpec(),
          viewport: charts.NumericExtents(0, _getMaxYValue()),
        ),
        domainAxis: charts.OrdinalAxisSpec(
          renderSpec: charts.SmallTickRendererSpec(
            labelStyle: charts.TextStyleSpec(
              fontSize: 10,
              color: charts.MaterialPalette.black,
            ),
            lineStyle: charts.LineStyleSpec(
              color: charts.MaterialPalette.black,
            ),
          ),
        ),
      ),
    );
  }

  // Data retrieval methods
  List<BranchSales> _getBranchSalesData() {
    if (salesDataResponse == null) return [];

    if (selectedButton == 1) {
      switch (salesIndex) {
        case 0:
          return salesDataResponse!.branchSalesa;
        case 1:
          return salesDataResponse!.branchSalesb;
        case 2:
          return salesDataResponse!.branchSalesc;
        default:
          return salesDataResponse!.branchSalesa;
      }
    } else if (selectedButton == 2) {
      switch (salesIndex) {
        case 0:
          return salesDataResponse!.branchSalesa;
        case 1:
          return salesDataResponse!.branchSalesb;
        case 2:
          return salesDataResponse!.branchSalesc;
        default:
          return salesDataResponse!.branchSalesa;
      }
    } else if (selectedButton == 3 && daysDifference <= 31) {
      switch (salesIndex) {
        case 0:
          return salesDataResponse!.branchSalesa;
        case 1:
          return salesDataResponse!.branchSalesb;
        case 2:
          return salesDataResponse!.branchSalesc;
        default:
          return salesDataResponse!.branchSalesa;
      }
    } else {
      // selectedButton == 3 && daysDifference > 31
      switch (salesIndex) {
        case 0:
          return salesDataResponse!.branchSalesa;
        case 1:
          return salesDataResponse!.branchSalesb;
        case 2:
          return salesDataResponse!.branchSalesc;
        default:
          return salesDataResponse!.branchSalesa;
      }
    }
  }

  bool _shouldShowNoData(List<BranchSales> branchData) {
    return branchData.isEmpty;
  }

  double _calculateChartHeight(List<BranchSales> branchData) {
    if (selectedButton == 1) {
      return branchData.length * (salesIndex == 0 ? 50.0 : 45.0);
    } else if (selectedButton == 2) {
      return branchData.length * 35.0;
    } else if (selectedButton == 3 && daysDifference <= 31) {
      return branchData.length * 45.0;
    } else {
      return branchData.length * (salesIndex == 1 ? 35.0 : 45.0);
    }
  }

  Key? _getChartKey() {
    // Return appropriate key based on selection
    String keyString = 'branch_chart_${selectedButton}_${salesIndex}';
    return Key(keyString);
  }

  int _getMaxYValue() {
    if (salesDataResponse == null) return 100;

    if (selectedButton == 1) {
      switch (salesIndex) {
        case 0:
          return salesDataResponse!.branchMaxYa;
        case 1:
          return salesDataResponse!.branchMaxYb;
        case 2:
          return salesDataResponse!.branchMaxYc;
        default:
          return salesDataResponse!.branchMaxYa;
      }
    } else if (selectedButton == 2) {
      switch (salesIndex) {
        case 0:
          return salesDataResponse!.branchMaxYa;
        case 1:
          return salesDataResponse!.branchMaxYb;
        case 2:
          return salesDataResponse!.branchMaxYc;
        default:
          return salesDataResponse!.branchMaxYa;
      }
    } else if (selectedButton == 3 && daysDifference <= 31) {
      switch (salesIndex) {
        case 0:
          return salesDataResponse!.branchMaxYa;
        case 1:
          return salesDataResponse!.branchMaxYb;
        case 2:
          return salesDataResponse!.branchMaxYc;
        default:
          return salesDataResponse!.branchMaxYa;
      }
    } else {
      switch (salesIndex) {
        case 0:
          return salesDataResponse!.branchMaxYa;
        case 1:
          return salesDataResponse!.branchMaxYb;
        case 2:
          return salesDataResponse!.branchMaxYc;
        default:
          return salesDataResponse!.branchMaxYa;
      }
    }
  }

  List<charts.Series<BranchChartData, String>> _convertToChartData(
      List<BranchSales> branchData) {
    return [
      charts.Series<BranchChartData, String>(
        id: 'BranchSales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (BranchChartData data, _) => data.branchName,
        measureFn: (BranchChartData data, _) => data.sales,
        data: branchData
            .map((branch) => BranchChartData(
                  branchName: branch.branchName,
                  sales: branch.totalSales,
                ))
            .toList(),
        labelAccessorFn: (BranchChartData data, _) => '${data.sales}',
      ),
    ];
  }
}

// Data model for chart
class BranchChartData {
  final String branchName;
  final int sales;

  BranchChartData({
    required this.branchName,
    required this.sales,
  });
}

// Enhanced version with more customization options
class BranchSalesChartWidgetAdvanced extends StatelessWidget {
  final int selectedButton;
  final int daysDifference;
  final int gridIndex2;
  final int salesIndex;
  final SalesDataResponse? salesDataResponse;
  final bool isLoading;
  final Color? chartColor;
  final double? minHeight;

  const BranchSalesChartWidgetAdvanced({
    Key? key,
    required this.selectedButton,
    required this.daysDifference,
    required this.gridIndex2,
    required this.salesIndex,
    this.salesDataResponse,
    this.isLoading = false,
    this.chartColor,
    this.minHeight = 120,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (gridIndex2 != 1) return Container();

    return _buildChartContainer(context);
  }

  Widget _buildChartContainer(BuildContext context) {
    List<BranchSales> branchData = _getBranchSalesData();

    if (_shouldShowNoData(branchData)) {
      return _buildNoDataCard(context);
    }

    return _buildBarChart(context, branchData);
  }

  Widget _buildNoDataCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16, top: 16),
      child: CustomCard(
        elevation: 6,
        surfaceTintColor: Colors.white,
        color: Colors.white,
        child: Container(
          height: 700,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart(BuildContext context, List<BranchSales> branchData) {
    return Container(
      key: _getChartKey(),
      height: _calculateChartHeight(branchData),
      constraints: BoxConstraints(minHeight: minHeight!),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16, top: 8),
        child: CustomCard(
          elevation: 6,
          surfaceTintColor: Colors.white,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_getBorderRadius()),
          ),
          child: isLoading ? _buildLoadingIndicator() : _buildChart(branchData),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: 200,
      child: Center(
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

  Widget _buildChart(List<BranchSales> branchData) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: charts.BarChart(
        _convertToChartData(branchData),
        animate: true,
        animationDuration: const Duration(milliseconds: 500),
        vertical: false,
        barRendererDecorator: charts.BarLabelDecorator<String>(),
        primaryMeasureAxis: charts.NumericAxisSpec(
          renderSpec: charts.NoneRenderSpec(),
          viewport: charts.NumericExtents(0, _getMaxYValue()),
        ),
        domainAxis: charts.OrdinalAxisSpec(
          renderSpec: charts.SmallTickRendererSpec(
            labelStyle: charts.TextStyleSpec(
              fontSize: 10,
              color: charts.MaterialPalette.black,
            ),
            lineStyle: charts.LineStyleSpec(
              color: charts.MaterialPalette.black,
            ),
          ),
        ),
      ),
    );
  }

  double _getBorderRadius() {
    if (selectedButton == 1) {
      return 12.0;
    } else {
      return 20.0;
    }
  }

  List<BranchSales> _getBranchSalesData() {
    if (salesDataResponse == null) return [];

    if (selectedButton == 1) {
      switch (salesIndex) {
        case 0:
          return salesDataResponse!.branchSalesa;
        case 1:
          return salesDataResponse!.branchSalesb;
        case 2:
          return salesDataResponse!.branchSalesc;
        default:
          return salesDataResponse!.branchSalesa;
      }
    } else if (selectedButton == 2) {
      switch (salesIndex) {
        case 0:
          return salesDataResponse!.branchSalesa;
        case 1:
          return salesDataResponse!.branchSalesb;
        case 2:
          return salesDataResponse!.branchSalesc;
        default:
          return salesDataResponse!.branchSalesa;
      }
    } else if (selectedButton == 3 && daysDifference <= 31) {
      switch (salesIndex) {
        case 0:
          return salesDataResponse!.branchSalesa;
        case 1:
          return salesDataResponse!.branchSalesb;
        case 2:
          return salesDataResponse!.branchSalesc;
        default:
          return salesDataResponse!.branchSalesa;
      }
    } else {
      switch (salesIndex) {
        case 0:
          return salesDataResponse!.branchSalesa;
        case 1:
          return salesDataResponse!.branchSalesb;
        case 2:
          return salesDataResponse!.branchSalesc;
        default:
          return salesDataResponse!.branchSalesa;
      }
    }
  }

  bool _shouldShowNoData(List<BranchSales> branchData) {
    return branchData.isEmpty;
  }

  double _calculateChartHeight(List<BranchSales> branchData) {
    if (selectedButton == 1) {
      return branchData.length * (salesIndex == 0 ? 50.0 : 45.0);
    } else if (selectedButton == 2) {
      return branchData.length * 35.0;
    } else if (selectedButton == 3 && daysDifference <= 31) {
      return branchData.length * 45.0;
    } else {
      return branchData.length * (salesIndex == 1 ? 35.0 : 45.0);
    }
  }

  Key? _getChartKey() {
    String keyString = 'branch_chart_${selectedButton}_${salesIndex}';
    return Key(keyString);
  }

  int _getMaxYValue() {
    if (salesDataResponse == null) return 100;

    if (selectedButton == 1) {
      switch (salesIndex) {
        case 0:
          return salesDataResponse!.branchMaxYa;
        case 1:
          return salesDataResponse!.branchMaxYb;
        case 2:
          return salesDataResponse!.branchMaxYc;
        default:
          return salesDataResponse!.branchMaxYa;
      }
    } else if (selectedButton == 2) {
      switch (salesIndex) {
        case 0:
          return salesDataResponse!.branchMaxYa;
        case 1:
          return salesDataResponse!.branchMaxYb;
        case 2:
          return salesDataResponse!.branchMaxYc;
        default:
          return salesDataResponse!.branchMaxYa;
      }
    } else if (selectedButton == 3 && daysDifference <= 31) {
      switch (salesIndex) {
        case 0:
          return salesDataResponse!.branchMaxYa;
        case 1:
          return salesDataResponse!.branchMaxYb;
        case 2:
          return salesDataResponse!.branchMaxYc;
        default:
          return salesDataResponse!.branchMaxYa;
      }
    } else {
      switch (salesIndex) {
        case 0:
          return salesDataResponse!.branchMaxYa;
        case 1:
          return salesDataResponse!.branchMaxYb;
        case 2:
          return salesDataResponse!.branchMaxYc;
        default:
          return salesDataResponse!.branchMaxYa;
      }
    }
  }

  List<charts.Series<BranchChartData, String>> _convertToChartData(
      List<BranchSales> branchData) {
    charts.Color barColor = chartColor != null
        ? charts.Color.fromHex(code: chartColor!.value.toRadixString(16))
        : charts.MaterialPalette.blue.shadeDefault;

    return [
      charts.Series<BranchChartData, String>(
        id: 'BranchSales',
        colorFn: (_, __) => barColor,
        domainFn: (BranchChartData data, _) => data.branchName,
        measureFn: (BranchChartData data, _) => data.sales,
        data: branchData
            .map((branch) => BranchChartData(
                  branchName: branch.branchName,
                  sales: branch.totalSales,
                ))
            .toList(),
        labelAccessorFn: (BranchChartData data, _) => '${data.sales}',
      ),
    ];
  }
}

// Usage example:
class BranchSalesExample extends StatefulWidget {
  @override
  _BranchSalesExampleState createState() => _BranchSalesExampleState();
}

class _BranchSalesExampleState extends State<BranchSalesExample> {
  int selectedButton = 1;
  int daysDifference = 30;
  int gridIndex2 = 1;
  int salesIndex = 0;
  SalesDataResponse? salesDataResponse;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BranchSalesChartWidget(
            selectedButton: selectedButton,
            daysDifference: daysDifference,
            gridIndex2: gridIndex2,
            salesIndex: salesIndex,
            salesDataResponse: salesDataResponse,
            isLoading: isLoading,
          ),
          // Or use the advanced version with more customization
        ],
      ),
    );
  }
}

// Data models
class AveragePremiumData {
  final String period;
  final double averagePremium;
  final int count;
  final double totalAmount;

  AveragePremiumData({
    required this.period,
    required this.averagePremium,
    required this.count,
    required this.totalAmount,
  });
}

class SalesOverviewChart extends StatelessWidget {
  final bool isLoading;
  final int selectedButton;
  final int daysDifference;
  final int salesIndex; // 0, 1, or 2 for different chart types
  final int noOfDaysThisMonth;

  const SalesOverviewChart({
    Key? key,
    required this.isLoading,
    required this.selectedButton,
    required this.daysDifference,
    required this.salesIndex,
    required this.noOfDaysThisMonth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16.0, top: 16, right: 16, bottom: 12),
        child: CustomCard(
          elevation: 6,
          color: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 14.0,
              right: 14,
              top: 20,
              bottom: 14,
            ),
            child: isLoading ? _buildLoadingIndicator() : _buildChart(),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          color: Colors.blue, // Replace with Constants.ctaColorLight
          strokeWidth: 1.8,
        ),
      ),
    );
  }

  Widget _buildChart() {
    // Check if we have data
    if (_getSalesSpots().isEmpty) {
      return const Center(
        child: Text(
          "No data available for the selected range",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: LineChart(
              LineChartData(
                lineBarsData: _buildLineBars(),
                lineTouchData: _buildTouchData(),
                gridData: _buildGridData(),
                titlesData: _buildTitlesData(),
                minY: 0,
                maxY: _calculateMaxY(),
                minX: _calculateMinX(),
                maxX: _calculateMaxX(),
                borderData: _buildBorderData(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "Weekend Sales are Added to / Accounted For On The Next Monday",
          style: TextStyle(fontSize: 9),
        )
      ],
    );
  }

  List<LineChartBarData> _buildLineBars() {
    List<LineChartBarData> bars = [];

    // Sales data line
    bars.add(
      LineChartBarData(
        spots: _getSalesSpots(),
        isCurved: true,
        preventCurveOverShooting: true,
        barWidth: 3,
        color: Colors.grey.shade400,
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
    );

    // Target data line (if available)
    if (_getTargetSpots().isNotEmpty) {
      bars.add(
        LineChartBarData(
          spots: _getTargetSpots(),
          isCurved: false, // Straight line for target
          barWidth: 3,
          color: Colors.green,
          dotData: FlDotData(
            show: false,
            getDotPainter: (spot, percent, barData, index) {
              return CustomDotPainter(
                dotColor: Constants.ftaColorLight,
                dotSize: 6,
              );
            },
          ),
        ),
      );
    }

    return bars;
  }

  LineTouchData _buildTouchData() {
    return LineTouchData(
      enabled: true,
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (value) => Colors.blueGrey,
        tooltipRoundedRadius: 20.0,
        showOnTopOfTheChartBoxArea: false,
        fitInsideHorizontally: true,
        tooltipMargin: 0,
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((LineBarSpot touchedSpot) {
            const textStyle = TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white70,
            );
            return LineTooltipItem(
              touchedSpot.y.round().toString(),
              textStyle,
            );
          }).toList();
        },
      ),
      getTouchedSpotIndicator: (barData, indicators) {
        return indicators.map((index) {
          final line = FlLine(
            color: Colors.grey,
            strokeWidth: 1,
            dashArray: [2, 4],
          );
          return TouchedSpotIndicatorData(
            line,
            const FlDotData(show: false),
          );
        }).toList();
      },
      getTouchLineEnd: (_, __) => double.infinity,
    );
  }

  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.grey.withOpacity(0.10),
          strokeWidth: 1,
        );
      },
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: (value, meta) => _buildBottomTitle(value),
        ),
        axisNameWidget: SalesOverviewTypeGrid(),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
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
              _formatLargeNumber(value.toInt()),
              style: const TextStyle(fontSize: 7.5),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomTitle(double value) {
    if (_isMonthlyView()) {
      // Monthly view - show month abbreviations
      int monthIndex = value.toInt();
      // Ensure month is within 1-12 range for display
      int month = (monthIndex - 1) % 12 + 1;
      String monthAbbreviation = _getMonthAbbreviation(month);

      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          monthAbbreviation,
          style: const TextStyle(fontSize: 10),
        ),
      );
    } else {
      if (selectedButton == 3 && daysDifference <= 31) {
        // For custom date ranges, show the actual date
        String dateLabel = _getDateLabelForCustomRange(value.toInt());

        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            dateLabel,
            style: const TextStyle(fontSize: 7),
          ),
        );
      }

      // Daily view - show day numbers
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          value.toInt().toString(),
          style: const TextStyle(fontSize: 7),
        ),
      );
    }
  }

  FlBorderData _buildBorderData() {
    return FlBorderData(
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
    );
  }

  // Data access methods
  List<FlSpot> _getSalesSpots() {
    if (_isMonthlyView()) {
      if (selectedButton == 3 && daysDifference > 31) {
        // For custom ranges > 31 days (monthly view):
        // 1. Trim leading zeros to find the first month with sales.
        List<FlSpot> leadingTrimmedSpots = _trimLeadingZeros(
            Constants.currentSalesDataResponse.salesSpotsMonthly);
        // 2. Then, trim trailing zeros from that result to find the last month with sales.
        return _trimTrailingZeros(leadingTrimmedSpots);
      }
      return Constants.currentSalesDataResponse.salesSpotsMonthly;
    } else {
      if (selectedButton == 3) {
        return _transformSalesSpotsForCustomRange(
          Constants.currentSalesDataResponse.salesSpotsDaily,
        );
      } else {
        return _removeZeroValuesFromDaily(
          Constants.currentSalesDataResponse.salesSpotsDaily,
          selectedButton,
          daysDifference,
        );
      }
    }
  }

  List<FlSpot> _getTargetSpots() {
    if (_isMonthlyView()) {
      if (selectedButton == 3 && daysDifference > 31) {
        // Align target data with the fully trimmed sales data
        List<FlSpot> trimmedSalesSpots =
            _getSalesSpots(); // Use the already processed spots
        return _alignTargetWithSales(
            Constants.currentSalesDataResponse.targetSpotsMonthly,
            trimmedSalesSpots);
      }
      return Constants.currentSalesDataResponse.targetSpotsMonthly;
    } else {
      if (selectedButton == 3) {
        return _transformTargetSpotsForCustomRange(
          Constants.currentSalesDataResponse.targetSpotsDaily,
        );
      } else {
        return _removeZeroValuesFromDaily(
          Constants.currentSalesDataResponse.targetSpotsDaily,
          selectedButton,
          daysDifference,
        );
      }
    }
  }

  bool _isMonthlyView() {
    return selectedButton == 2 || (selectedButton == 3 && daysDifference > 31);
  }

  double _calculateMinX() {
    if (_isMonthlyView()) {
      final spots = _getSalesSpots();
      if (spots.isEmpty) {
        return 1.0; // Default to 1 if no data
      }
      // Calculate the end of the axis
      final endX = spots.last.x;
      // Set the start of the axis to create a 12-month window
      // e.g., if data ends at month 12, axis starts at 1. If ends at month 8, axis starts at -3, so we cap at 1.
      final calculatedMin = endX - 11.0;
      return calculatedMin > 1.0 ? calculatedMin : 1.0;
    } else {
      // Daily view always starts from day 1
      return 1;
    }
  }

  double _calculateMaxX() {
    if (_isMonthlyView()) {
      final spots = _getSalesSpots();
      if (spots.isEmpty) {
        return 12.0; // Default to 12 if no data
      }
      // The axis ends at the last month with data
      return spots.last.x;
    } else {
      // Daily view (custom range <= 31 days) uses a fixed 31-day window
      return 31.0;
    }
  }

  double _calculateMaxY() {
    final salesSpots = _getSalesSpots();
    final targetSpots = _getTargetSpots();

    double maxSales = salesSpots.isEmpty
        ? 0
        : salesSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    double maxTarget = targetSpots.isEmpty
        ? 0
        : targetSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b);

    double maxY = maxSales > maxTarget ? maxSales : maxTarget;
    return maxY == 0
        ? 100
        : (_selectedButton == 2 ||
                (_selectedButton == 3 && daysDifference > 31))
            ? maxY * 1.2
            : maxY * 1.1; // Add padding, handle all-zero case
  }

  // Helper methods
  List<FlSpot> _removeZeroValuesFromDaily(
      List<FlSpot> spots, int selectedButton, int daysDifference) {
    return spots.where((spot) => spot.y > 0).toList();
  }

  // ✨ NEW HELPER to remove leading spots with a y-value of 0
  List<FlSpot> _trimLeadingZeros(List<FlSpot> originalSpots) {
    if (originalSpots.isEmpty) return [];

    final firstNonZeroIndex = originalSpots.indexWhere((spot) => spot.y > 0);

    // If all spots are zero, return an empty list.
    if (firstNonZeroIndex == -1) {
      return [];
    }

    // Return the sublist starting from the first non-zero spot.
    return originalSpots.sublist(firstNonZeroIndex);
  }

  // (This function remains unchanged but is now used on data that has already had leading zeros trimmed)
  List<FlSpot> _trimTrailingZeros(List<FlSpot> originalSpots) {
    if (originalSpots.isEmpty) return [];

    int lastNonZeroIndex = -1;
    for (int i = originalSpots.length - 1; i >= 0; i--) {
      if (originalSpots[i].y > 0) {
        lastNonZeroIndex = i;
        break;
      }
    }

    if (lastNonZeroIndex == -1) {
      return [];
    }

    return originalSpots.sublist(0, lastNonZeroIndex + 1);
  }

  List<FlSpot> _alignTargetWithSales(
      List<FlSpot> originalTargetSpots, List<FlSpot> trimmedSalesSpots) {
    if (originalTargetSpots.isEmpty || trimmedSalesSpots.isEmpty) return [];

    double firstSalesX = trimmedSalesSpots.first.x;
    double lastSalesX = trimmedSalesSpots.last.x;

    List<FlSpot> alignedTargetSpots = originalTargetSpots
        .where((spot) => spot.x >= firstSalesX && spot.x <= lastSalesX)
        .toList();

    int lastNonZeroTargetIndex = -1;
    for (int i = alignedTargetSpots.length - 1; i >= 0; i--) {
      if (alignedTargetSpots[i].y > 0) {
        lastNonZeroTargetIndex = i;
        break;
      }
    }

    if (lastNonZeroTargetIndex != -1) {
      alignedTargetSpots =
          alignedTargetSpots.sublist(0, lastNonZeroTargetIndex + 1);
    }

    return alignedTargetSpots;
  }

  List<FlSpot> _transformSalesSpotsForCustomRange(List<FlSpot> originalSpots) {
    if (originalSpots.isEmpty) return [];

    DateTime startDate = DateTime.parse(Constants.sales_formattedStartDate);
    DateTime endDate = DateTime.parse(Constants.sales_formattedEndDate);

    List<FlSpot> nonZeroSpots =
        originalSpots.where((spot) => spot.y > 0).toList();
    if (nonZeroSpots.isEmpty) return [];
    nonZeroSpots.sort((a, b) => a.x.compareTo(b.x));

    List<FlSpot> transformedSpots = [];
    int totalDays = endDate.difference(startDate).inDays + 1;
    int startPosition = totalDays <= 31 ? (32 - totalDays) : 1;

    for (var spot in nonZeroSpots) {
      DateTime actualDate = startDate.add(Duration(days: spot.x.toInt()));
      int dayOffset = actualDate.difference(startDate).inDays;
      double chartPosition = startPosition + dayOffset.toDouble();
      if (chartPosition >= 1 && chartPosition <= 31) {
        transformedSpots.add(FlSpot(chartPosition, spot.y));
      }
    }
    return transformedSpots;
  }

  List<FlSpot> _transformTargetSpotsForCustomRange(List<FlSpot> originalSpots) {
    if (originalSpots.isEmpty) return [];

    List<FlSpot> nonZeroSpots =
        originalSpots.where((spot) => spot.y > 0).toList();
    if (nonZeroSpots.isEmpty) return [];

    List<FlSpot> salesSpots = _getSalesSpots();
    if (salesSpots.isEmpty) return [];

    List<FlSpot> transformedTargetSpots = [];
    double targetValue = nonZeroSpots.first.y;

    for (var salesSpot in salesSpots) {
      transformedTargetSpots.add(FlSpot(salesSpot.x, targetValue));
    }
    return transformedTargetSpots;
  }

  String _getDateLabelForCustomRange(int dayPosition) {
    try {
      DateTime startDate = DateTime.parse(Constants.sales_formattedStartDate);
      DateTime endDate = DateTime.parse(Constants.sales_formattedEndDate);
      int totalDays = endDate.difference(startDate).inDays + 1;
      int startPosition = totalDays <= 31 ? (32 - totalDays) : 1;
      int dayOffset = dayPosition - startPosition;
      DateTime displayDate = startDate.add(Duration(days: dayOffset));
      return displayDate.day.toString();
    } catch (e) {
      return dayPosition.toString();
    }
  }

  String _formatLargeNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return month >= 1 && month <= 12 ? months[month] : '';
  }
}
