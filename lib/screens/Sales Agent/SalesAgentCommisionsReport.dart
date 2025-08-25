import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mi_insights/customwidgets/Collections/top_sales_agent.dart';

import '../../../constants/Constants.dart';
import '../../../services/MyNoyifier.dart';
import '../../../services/Sales Agent/sales_agent_commisions_service.dart';
import '../../../services/inactivitylogoutmixin.dart';

class SalesAgentCommisionsReport extends StatefulWidget {
  const SalesAgentCommisionsReport({super.key});

  @override
  State<SalesAgentCommisionsReport> createState() =>
      _SalesAgentCommisionsReportState();
}

int noOfDaysThisMonth = 30;
bool isLoadingCommisionData = false;
List<BarChartGroupData> commission_barChartData1 = [];
List<BarChartGroupData> commission_barChartData2 = [];
List<BarChartGroupData> commission_barChartData3 = [];
List<BarChartGroupData> commission_barChartData4 = [];
List<Map<String, dynamic>> commision_data_policies = [];
List<commission_gridmodel> sectionsList2 = [];

double current_month_commission = 0.0;
int current_number_of_sales = 0;
int current_month_receiving_commision = 0;
final commissionsValue = ValueNotifier<int>(0);
MyNotifier? myNotifier;
DateTime datefrom = DateTime.now().subtract(Duration(days: 60));
DateTime dateto = DateTime.now();
int days_difference = 0;
Widget wdg1 = Container();
int report_index = 0;
int commission_index = 0;
String data2 = "";
Key kyrt = UniqueKey();
int touchedIndex = -1;
String _selectedEmployee = "All Employees";
bool _isLoading = false;
TextEditingController _searchContoller = TextEditingController();
Map selected_policy_commision_item = {};
final List<String> policyKeys = [
  "cec_employeeid",
  "branch_id",
  "policy_number",
  "sale_datetime",
  "inceptionDate",
];

class _SalesAgentCommisionsReportState extends State<SalesAgentCommisionsReport>
    with InactivityLogoutMixin {
  double _sliderPosition = 0.0;
  int _selectedButton = 1;
  bool isSameDaysRange = true;
  Color _button1Color = Colors.grey.withOpacity(0.0);
  Color _button2Color = Colors.grey.withOpacity(0.0);
  Color _button3Color = Colors.grey.withOpacity(0.0);

  void _animateButton(int buttonNumber) {
    restartInactivityTimer();
    DateTime? startDate = DateTime.now();
    DateTime? endDate = DateTime.now();

    _selectedButton = buttonNumber;
    if (buttonNumber == 1) {
      _sliderPosition = 0.0;
    } else if (buttonNumber == 2) {
      _sliderPosition = (MediaQuery.of(context).size.width / 2) - 18;
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

      setState(() {});
    }
  }

  String? _selectedMonth;
  List<String> _last12Months = [];
  Map<String, Map<String, DateTime>> _monthDateRanges = {};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
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
                title: const Text(
                  "Potential Commission",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                )),
            body: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollStartNotification ||
                      scrollNotification is ScrollUpdateNotification) {
                    restartInactivityTimer();
                  }
                  return true; // Return true to indicate the notification is handled
                },
                child: SingleChildScrollView(
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
                      Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(36)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                            color: Constants.ctaColorLight,
                                            borderRadius:
                                                BorderRadius.circular(360)),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 24.0, top: 0),
                                            child: DropdownButton<String>(
                                              isExpanded: true,
                                              value: _selectedMonth,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  _selectedMonth = newValue!;
                                                  _getCommissionData(
                                                      _selectedMonth!);
                                                });
                                              },
                                              selectedItemBuilder:
                                                  (BuildContext ctxt) {
                                                return _last12Months
                                                    .map<Widget>((item) {
                                                  return DropdownMenuItem(
                                                      child: Text("${item}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      value: item);
                                                }).toList();
                                              },
                                              items: _last12Months.map<
                                                      DropdownMenuItem<String>>(
                                                  (String monthName) {
                                                return DropdownMenuItem<String>(
                                                  value: monthName,
                                                  child: Text(
                                                    monthName,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: false,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 14,
                                                      color: Colors
                                                          .black, // Dropdown items text color
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              underline:
                                                  Container(), // Removes underline if not needed
                                              dropdownColor: Colors
                                                  .white, // Dropdown background color
                                              style: TextStyle(
                                                color: Colors
                                                    .white, // This sets the selected item text color
                                              ),
                                              iconEnabledColor: Colors
                                                  .white, // Changes the dropdown icon color
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 0.0, right: 0, bottom: 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 0,
                                                right: 0,
                                                top: 0,
                                                bottom: 0),
                                            child: Container(
                                              height: 45,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(360),
                                                child: Material(
                                                  elevation: 10,
                                                  child: TextFormField(
                                                    autofocus: false,
                                                    decoration: InputDecoration(
                                                      suffixIcon: InkWell(
                                                        onTap: () {
                                                          _isLoading = true;

                                                          setState(() {});
                                                          print("ghghghhjgjh");
                                                          getPolicyCommission(
                                                            _searchContoller
                                                                .text,
                                                          );
                                                        },
                                                        child: Container(
                                                          height: 35,
                                                          width: 30,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
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
                                                                child: Icon(
                                                                  Icons.search,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 24,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      hintText:
                                                          'Search a policy',
                                                      hintStyle:
                                                          GoogleFonts.inter(
                                                        textStyle: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.grey,
                                                            letterSpacing: 0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                      filled: true,
                                                      fillColor: Colors.grey
                                                          .withOpacity(0.09),
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              left: 2),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.0)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.0)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                    ),
                                                    controller:
                                                        _searchContoller,
                                                    onChanged: (val) {
                                                      getPolicyCommission(
                                                        val,
                                                      );
                                                    },
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
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xff44556a)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Text(
                                  "IMPORTANT NOTE",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Please note that the commission figures below are indicative aimed at helping you to forecast your earnings. They are subject to verification by the finance team (e.g. checking for payment reversals, cancellations, etc).",
                                    style: TextStyle(
                                        fontSize: 13.5, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "The final amounts will be determined and signed off by management after the cut-off date with potential adjustments based.",
                                    style: TextStyle(
                                        fontSize: 13.5, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "The formal sign-off process is put in place to ensure accuracy. We appreciate your understanding and commitment to our shared success.",
                                    style: TextStyle(
                                        fontSize: 13.5, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(360),
                          color: Colors.green,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Spacer(),
                              Text(
                                "R ${formatLargeNumber3(current_month_commission.toString())}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                "Current Month",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                "${getMonthAbbreviation(DateTime.now().month)} ${DateTime.now().year}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 12),
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
                          itemCount: sectionsList2.length,
                          padding: EdgeInsets.all(2.0),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                                onTap: () {},
                                child: Container(
                                  height: 320,
                                  width:
                                      MediaQuery.of(context).size.width / 1.9,
                                  child: Stack(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          report_index = index;
                                          setState(() {});
                                          if (kDebugMode) {
                                            print("commission_index " +
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
                                                child: isLoadingCommisionData
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
                                                              strokeWidth: 1.8,
                                                            ),
                                                          ),
                                                        ),
                                                      ))
                                                    : Column(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                      /*  color: report_index ==
                                                                        index
                                                                    ? Colors.grey
                                                                        .withOpacity(
                                                                            0.2)
                                                                    : Colors.grey
                                                                        .withOpacity(
                                                                            0.05),*/
                                                                      border: Border.all(
                                                                          color: Colors.grey.withOpacity(
                                                                              0.0)),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
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
                                                                              .only(
                                                                              top: 10.0),
                                                                          child:
                                                                              Text(
                                                                            "R" +
                                                                                formatLargeNumber(sectionsList2[index].count.toString()),
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
                                                                            .only(
                                                                            top:
                                                                                0.0),
                                                                        child:
                                                                            Text(
                                                                          sectionsList2[index].amount.toString() +
                                                                              "%",
                                                                          style:
                                                                              TextStyle(fontSize: 12.5),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          maxLines:
                                                                              1,
                                                                        ),
                                                                      )),
                                                                      Center(
                                                                          child:
                                                                              Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            6.0),
                                                                        child:
                                                                            Text(
                                                                          sectionsList2[index]
                                                                              .id,
                                                                          style: TextStyle(
                                                                              fontSize: 12.5,
                                                                              fontWeight: FontWeight.w500),
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
                        height: 16,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 8),
                            child: Text("Commission By Month"),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Card(
                          elevation: 6,
                          surfaceTintColor: Colors.white,
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
                                          alignment: BarChartAlignment.center,
                                          barTouchData:
                                              BarTouchData(enabled: false),
                                          gridData: FlGridData(
                                            show: true,
                                            drawVerticalLine: false,
                                            getDrawingHorizontalLine: (value) {
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
                                                getTitlesWidget: (value, meta) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: Text(
                                                      getMonthAbbreviation(
                                                              value.toInt())
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 9.5),
                                                    ),
                                                  );
                                                },
                                              ),
                                              axisNameWidget: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0.0),
                                                child: Text(
                                                  'Months of the Year',
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
                                                reservedSize: 32,
                                                getTitlesWidget: (value, meta) {
                                                  return Text(
                                                    formatLargeNumber4(value
                                                        .toInt()
                                                        .toString()),
                                                    style: TextStyle(
                                                        fontSize: 7.5),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          borderData: FlBorderData(show: false),
                                          groupsSpace: barsSpace,
                                          barGroups: commission_barChartData1),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      /*      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Container(
                                height: 120,
                                child: InkWell(
                                    onTap: () {
                                      restartInactivityTimer();
                                    },
                                    child: Container(
                                      height: 120,
                                      width: MediaQuery.of(context).size.width /
                                          2.9,
                                      child: Stack(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              restartInactivityTimer();
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
                                                    child:
                                                        isLoadingCommisionData
                                                            ? Center(
                                                                child: Center(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child:
                                                                      Container(
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
                                                            : Column(
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
                                                                          */
                      /*     decoration: BoxDecoration(
                                                                        color:Colors.white,
                                                                        borderRadius:
                                                                        BorderRadius.circular(
                                                                            8),
                                                                        border: Border.all(
                                                                            width: 1,
                                                                            color: Colors
                                                                                .grey.withOpacity(0.2))),*/
                      /*
                                                                          margin: EdgeInsets.only(right: 0, left: 0, bottom: 4),
                                                                          child: current_month_commission == 0
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
                                                                                          "R" + formatLargeNumber3(current_month_commission.toString()),
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
                                                                                        current_number_of_sales.toString() + " sales",
                                                                                        style: TextStyle(fontSize: 12.5),
                                                                                        textAlign: TextAlign.center,
                                                                                        maxLines: 1,
                                                                                      ),
                                                                                    )),
                                                                                    Center(
                                                                                        child: Padding(
                                                                                      padding: const EdgeInsets.all(6.0),
                                                                                      child: Text(
                                                                                        "Current Mth",
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
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                height: 120,
                                child: InkWell(
                                    onTap: () {
                                      restartInactivityTimer();
                                    },
                                    child: Container(
                                      height: 120,
                                      width: MediaQuery.of(context).size.width /
                                          2.9,
                                      child: Stack(
                                        children: [
                                          InkWell(
                                            onTap: () {},
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
                                                    child:
                                                        current_month_commission ==
                                                                0
                                                            ? Center(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child:
                                                                      Container(
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
                                                              )
                                                            : Column(
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
                                                                          */
                      /*     decoration: BoxDecoration(
                                                                        color:Colors.white,
                                                                        borderRadius:
                                                                        BorderRadius.circular(
                                                                            8),
                                                                        border: Border.all(
                                                                            width: 1,
                                                                            color: Colors
                                                                                .grey.withOpacity(0.2))),*/
                      /*
                                                                          margin: EdgeInsets.only(right: 0, left: 0, bottom: 4),
                                                                          child: isLoadingCommisionData
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
                                                                                          current_month_receiving_commision.toString(),
                                                                                          style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
                                                                                          textAlign: TextAlign.center,
                                                                                          maxLines: 2,
                                                                                        ),
                                                                                      )),
                                                                                    ),
                                                                                    Center(
                                                                                        child: Padding(
                                                                                      padding: const EdgeInsets.all(6.0),
                                                                                      child: Text(
                                                                                        "# Of Agents Earning",
                                                                                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
                                                                                        textAlign: TextAlign.center,
                                                                                        maxLines: 2,
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
                          ),
                        ],
                      ),*/

                      SizedBox(
                        height: 16,
                      ),
                      /* Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 0),
                    child: CollectionTypeGrid(),
                  ),
                  SizedBox(
                    height: 24,
                  ),*/
                      /*  Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 8),
                            child: Text("Policy Level View"),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 0.0, right: 16, bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 8, right: 8, top: 0, bottom: 4),
                                child: Container(
                                  height: 45,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(360),
                                    child: Material(
                                      elevation: 10,
                                      child: TextFormField(
                                        autofocus: false,
                                        decoration: InputDecoration(
                                          suffixIcon: InkWell(
                                            onTap: () {
                                              _isLoading = true;

                                              setState(() {});
                                              print("ghghghhjgjh");
                                              getPolicyCommission(
                                                _searchContoller.text,
                                              );
                                            },
                                            child: Container(
                                              height: 35,
                                              width: 30,
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
                                                    child: Icon(
                                                      Icons.search,
                                                      color: Colors.white,
                                                      size: 24,
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
                                        onChanged: (val) {
                                          getPolicyCommission(
                                            val,
                                          );
                                        },
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
                      ),*/
                    ]),
                  ),
                ))));
  }

  @override
  void initState() {
    super.initState();
    _animateButton(1);
    _generateLast12Months();
    startInactivityTimer();
    myNotifier = MyNotifier(commissionsValue, context);
    commissionsValue.addListener(() {
      kyrt = UniqueKey();
      setState(() {});
      Future.delayed(Duration(seconds: 3)).then((value) {
        setState(() {});
      });
    });
  }

  void _generateLast12Months() {
    final DateFormat formatter = DateFormat('MMMM yyyy');
    final DateTime now = DateTime.now();

    for (int i = 11; i >= 0; i--) {
      DateTime month = DateTime(now.year, now.month - i, 1);
      String monthName = formatter.format(month);
      _last12Months.add(monthName);

      DateTime startOfMonth = DateTime(month.year, month.month, 1);
      DateTime endOfMonth = DateTime(month.year, month.month + 1, 0);
      _monthDateRanges[monthName] = {
        'start': startOfMonth,
        'end': endOfMonth,
      };
    }
    _selectedMonth = _last12Months.last;
    _last12Months = _last12Months.reversed.toList();
    _last12Months.insert(0, "All");
    setState(() {});
  }

  void _getCommissionData(String monthName) {
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now();
    DateTime now = DateTime.now();

    String empoyees = "";
    if (_selectedMonth == "All") {
      startDate = DateTime(now.year, now.month - 11, 1);
      Constants.comms_formattedStartDate =
          DateFormat('yyyy-MM-dd').format(startDate);
      endDate = now;
      Constants.comms_formattedEndDate =
          DateFormat('yyyy-MM-dd').format(endDate);
    } else {
      startDate = _monthDateRanges[monthName]!['start']!;
      endDate = _monthDateRanges[monthName]!['end']!;
      Constants.comms_formattedStartDate =
          DateFormat('yyyy-MM-dd').format(startDate);
      Constants.comms_formattedEndDate =
          DateFormat('yyyy-MM-dd').format(endDate);
    }

    empoyees = _selectedEmployee;

    getSalesAgentCommissionReport(
        Constants.comms_formattedStartDate,
        Constants.comms_formattedEndDate,
        1,
        "single_empoyee",
        getEmployeeById(Constants.cec_employeeid),
        context);
    print(
        'Getting commission data for: $monthName, Start: ${Constants.comms_formattedStartDate}, End: ${Constants.comms_formattedEndDate}');
  }

  Map<String, dynamic>? getPolicyCommission(String policyNumber) {
    selected_policy_commision_item = {};
    setState(() {});
    print("ggfhghg ${commision_data_policies.length}");
    for (var item in commision_data_policies) {
      print(item);
      if (item["policy_number"] == policyNumber) {
        print(item);
        selected_policy_commision_item = item;
        setState(() {});
        return item;
      }
    }
    // selected_policy_commision_item = {};
    return {};
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

String formatWithCommas3(double value, [bool forceDecimal = false]) {
  bool isNegative = value < 0;
  double absValue = value.abs();

  final format = absValue < 1000000 && !forceDecimal
      ? NumberFormat("#,##0", "en_US")
      : NumberFormat("#,##0.00", "en_US");

  // Format the number and add back the negative sign if necessary
  return isNegative ? "-${format.format(absValue)}" : format.format(absValue);
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

class CollectionTypeGrid extends StatelessWidget {
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
            return Indicator(
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

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;

  const Indicator({
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

class commission_gridmodel {
  String id;
  int count;
  double amount;
  commission_gridmodel(
    this.id,
    this.count,
    this.amount,
  );
}

class CommissionPolicyInfo extends StatefulWidget {
  const CommissionPolicyInfo({super.key});

  @override
  State<CommissionPolicyInfo> createState() => _CommissionPolicyInfoState();
}

class _CommissionPolicyInfoState extends State<CommissionPolicyInfo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 12,
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
                      child: Text(
                          selected_policy_commision_item["policy_number"] ??
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
              padding: const EdgeInsets.only(left: 16.0, right: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text("Sale date",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                      child: Text(selected_policy_commision_item[
                                      "sale_datetime"] ==
                                  null ||
                              selected_policy_commision_item["sale_datetime"] ==
                                  ""
                          ? ""
                          : DateFormat('EEE, d MMMM yyyy').format(
                              DateTime.parse(selected_policy_commision_item[
                                  "sale_datetime"])))),
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
              padding: const EdgeInsets.only(left: 16.0, right: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text("Inception Date",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                      child: Text(selected_policy_commision_item[
                                      "inceptionDate"] ==
                                  null ||
                              selected_policy_commision_item["inceptionDate"] ==
                                  ""
                          ? ""
                          : DateFormat('EEE, d MMMM yyyy').format(
                              DateTime.parse(selected_policy_commision_item[
                                  "inceptionDate"])))),
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
              padding: const EdgeInsets.only(left: 16.0, right: 8, bottom: 8),
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
                    child: Text(
                        selected_policy_commision_item["totalAmountPayable"] ==
                                    null ||
                                selected_policy_commision_item[
                                        "totalAmountPayable"] ==
                                    ""
                            ? ""
                            : "R" +
                                (double.tryParse(selected_policy_commision_item[
                                                "totalAmountPayable"]
                                            .toString()) ??
                                        0)
                                    .toStringAsFixed(2)),
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
            /* SizedBox(
                              height: 12,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8, bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Text("Client Name",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Expanded(
                                      child: Text(selected_policy_commision_item[
                                              "client_name"] ??
                                          "")),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8),
                              child: Container(
                                height: 1,
                                color: Colors.grey.withOpacity(0.1),
                              ),
                            ),*/
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text("Sales agent",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                      child: Text(
                          selected_policy_commision_item["employee"] ?? "")),
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
              padding: const EdgeInsets.only(left: 16.0, right: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text("Branch",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                      child: Text(
                          selected_policy_commision_item["branch_name"] ?? "")),
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
              padding: const EdgeInsets.only(left: 16.0, right: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    child: Text("Coll. Method",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                      child: Text(
                          selected_policy_commision_item["payment_type"] ??
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
            /* SizedBox(
                              height: 12,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 8, bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  const Expanded(
                                    child: Text("Client Age",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Expanded(
                                      child: Text(
                                          selected_policy_commision_item["age"]
                                                  .toString() ??
                                              "")),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 8),
                              child: Container(
                                height: 1,
                                color: Colors.grey.withOpacity(0.1),
                              ),
                            ),*/
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    child: Text("Total Commision",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                      child: Text(selected_policy_commision_item[
                                      "commission"] ==
                                  null ||
                              selected_policy_commision_item["commission"] == ""
                          ? ""
                          : "R" +
                                  (selected_policy_commision_item["commission"]
                                          .toStringAsFixed(2))
                                      .toString() ??
                              "")),
                ],
              ),
            ),
            /*  Padding(
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
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 8, bottom: 8),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    const Expanded(
                                      child: Text("Comm. Mth 1",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                        child: Text(
                                      selected_policy_commision_item[
                                                      "commission"] ==
                                                  null ||
                                              selected_policy_commision_item[
                                                      "commission"] ==
                                                  ""
                                          ? ""
                                          : "R" +
                                              ((0.5 *
                                                      (double.tryParse(
                                                              selected_policy_commision_item[
                                                                          "commission"]
                                                                      ?.toString() ??
                                                                  "0") ??
                                                          0))
                                                  .toStringAsFixed(2)),
                                    )),
                                  ]),
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
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8, bottom: 8),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    const Expanded(
                                      child: Text("Comm. Mth 2",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                        child: Text(
                                      selected_policy_commision_item[
                                                      "commission"] ==
                                                  null ||
                                              selected_policy_commision_item[
                                                      "commission"] ==
                                                  ""
                                          ? ""
                                          : "R" +
                                              ((0.20 *
                                                      (double.tryParse(
                                                              selected_policy_commision_item[
                                                                          "commission"]
                                                                      ?.toString() ??
                                                                  "0") ??
                                                          0))
                                                  .toStringAsFixed(2)),
                                    )),
                                  ]),
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
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8, bottom: 8),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    const Expanded(
                                      child: Text("Comm. Mth 3",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                        child: Text(
                                      selected_policy_commision_item[
                                                      "commission"] ==
                                                  null ||
                                              selected_policy_commision_item[
                                                      "commission"] ==
                                                  ""
                                          ? ""
                                          : selected_policy_commision_item[
                                                          "commission"] ==
                                                      null ||
                                                  selected_policy_commision_item[
                                                          "commission"] ==
                                                      ""
                                              ? ""
                                              : "R" +
                                                  ((0.15 *
                                                          (double.tryParse(
                                                                  selected_policy_commision_item[
                                                                              "commission"]
                                                                          ?.toString() ??
                                                                      "0") ??
                                                              0))
                                                      .toStringAsFixed(2)),
                                    )),
                                  ]),
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
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8, bottom: 8),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    const Expanded(
                                      child: Text("Comm. Mth 4",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                        child: Text(
                                      selected_policy_commision_item[
                                                      "commission"] ==
                                                  null ||
                                              selected_policy_commision_item[
                                                      "commission"] ==
                                                  ""
                                          ? ""
                                          : "R" +
                                              ((0.15 *
                                                      (double.tryParse(
                                                              selected_policy_commision_item[
                                                                          "commission"]
                                                                      ?.toString() ??
                                                                  "0") ??
                                                          0))
                                                  .toStringAsFixed(2)),
                                    )),
                                  ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8),
                              child: Container(
                                height: 1,
                                color: Colors.grey.withOpacity(0.1),
                              ),
                            ),*/
            SizedBox(
              height: 12,
            ),
          ]),
        ));
  }
}
