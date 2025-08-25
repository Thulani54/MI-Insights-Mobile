import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_insights/services/inactivitylogoutmixin.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../constants/Constants.dart';

int _selectedButton = 1;
int compliance_index = 0;
int days_difference = 0;
int sales_index = 0;
double _sliderPosition = 0.0;
double _sliderPosition2 = 0.0;
double _sliderPosition3 = 0.0;
double _sliderPosition4 = 0.0;
double _sliderPosition5 = 0.0;
int grid_index = 0;
int grid_index_2 = 0;
int target_index = 0;
int target_index_2 = 0;
int noOfDaysThisMonth = 30;
bool isSalesDataLoading1a = false;
bool isSalesDataLoading2a = false;
bool isSalesDataLoading3a = false;
bool isSameDaysRange = true;
List<compiancegridmodel> leads_sectionsList1a = [
  compiancegridmodel("Completed", 0),
  compiancegridmodel("Passed", 0),
  compiancegridmodel("Failed", 0),
];
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

class ExecutiveComplianceReport extends StatefulWidget {
  const ExecutiveComplianceReport({super.key});

  @override
  State<ExecutiveComplianceReport> createState() =>
      _ExecutiveComplianceReportState();
}

class _ExecutiveComplianceReportState extends State<ExecutiveComplianceReport>
    with InactivityLogoutMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                // restartInactivityTimer();
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Asessment Results",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          elevation: 6,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black.withOpacity(0.6),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 11.0, right: 3, top: 12, bottom: 12),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 2.3)),
                  itemCount: _selectedButton == 1
                      ? Constants.leads_sectionsList1a.length
                      : _selectedButton == 2
                          ? Constants.leads_sectionsList2a.length
                          : _selectedButton == 3 && days_difference <= 31
                              ? Constants.leads_sectionsList3a.length
                              : Constants.leads_sectionsList3b.length,
                  padding: EdgeInsets.all(2.0),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                        onTap: () {},
                        child: Container(
                          height: 290,
                          width: MediaQuery.of(context).size.width / 2.9,
                          child: Stack(
                            children: [
                              InkWell(
                                onTap: () {
                                  compliance_index = index;
                                  setState(() {});
                                  if (kDebugMode) {
                                    print(
                                        "sales_indexjkjjk " + index.toString());
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
                                  padding: const EdgeInsets.only(
                                      bottom: 4.0, right: 8),
                                  child: Card(
                                    surfaceTintColor: Colors.white,
                                    elevation: 6,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.white70, width: 0),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: ClipPath(
                                      clipper: ShapeBorderClipper(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16))),
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
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: compliance_index ==
                                                            index
                                                        ? Colors.grey
                                                            .withOpacity(0.05)
                                                        : Colors.grey
                                                            .withOpacity(0.05),
                                                    border: Border.all(
                                                        color: Colors.grey
                                                            .withOpacity(0.0)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14),
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
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
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              formatLargeNumber((_selectedButton ==
                                                                          1
                                                                      ? Constants
                                                                          .leads_sectionsList1a[
                                                                              index]
                                                                          .amount
                                                                      : _selectedButton ==
                                                                              2
                                                                          ? Constants
                                                                              .leads_sectionsList2a[index]
                                                                              .amount
                                                                          : _selectedButton == 3 && days_difference <= 31
                                                                              ? Constants.leads_sectionsList3a[index].amount
                                                                              : Constants.leads_sectionsList3b[index].amount)
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
                                                            _selectedButton == 1
                                                                ? Constants
                                                                    .leads_sectionsList1a[
                                                                        index]
                                                                    .id
                                                                : _selectedButton ==
                                                                        2
                                                                    ? Constants
                                                                        .leads_sectionsList2a[
                                                                            index]
                                                                        .id
                                                                    : _selectedButton ==
                                                                                3 &&
                                                                            days_difference <=
                                                                                31
                                                                        ? Constants
                                                                            .leads_sectionsList3a[
                                                                                index]
                                                                            .id
                                                                        : Constants
                                                                            .leads_sectionsList3b[index]
                                                                            .id,
                                                            style: TextStyle(
                                                                fontSize: 12.5),
                                                            textAlign: TextAlign
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
                                  "Pass Rate (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
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
                                child: Text("Pass Rate (12 Months View)"),
                              ),
                            )
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 0.0, bottom: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16, bottom: 8),
                                  child: Text(
                                      "Pass Rate (${Constants.sales_formattedStartDate} to ${Constants.sales_formattedEndDate})"),
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
                  percent:
                      _selectedButton == 1 && Constants.micro_learn_line_1a > 0
                          ? Constants.micro_learn_line_1a / 100
                          : _selectedButton == 2 &&
                                  Constants.micro_learn_line_2a > 0
                              ? Constants.micro_learn_line_2a / 100
                              : _selectedButton == 3 &&
                                      days_difference <= 31 &&
                                      Constants.micro_learn_line_3a > 0
                                  ? Constants.micro_learn_line_3a / 100
                                  : _selectedButton == 3 &&
                                          days_difference > 31 &&
                                          Constants.micro_learn_line_3b > 0
                                      ? Constants.micro_learn_line_3b / 100
                                      : 0.0,
                  center: Text(
                      "${_selectedButton == 1 ? Constants.micro_learn_line_1a.toStringAsFixed(1) : _selectedButton == 2 ? Constants.micro_learn_line_2a.toStringAsFixed(1) : _selectedButton == 3 && days_difference <= 31 ? Constants.micro_learn_line_3a.toStringAsFixed(1) : Constants.micro_learn_line_3b.toStringAsFixed(1)}%"),
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
                      padding: const EdgeInsets.only(left: 16.0, top: 12),
                      child: Text(
                          "Recent Assessments (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                    )
                  : _selectedButton == 2
                      ? Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 12),
                          child: Text("Recent Assessments (12 Months View)"),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 12),
                          child: Text(
                              "Recent Assessments (${Constants.sales_formattedStartDate} to ${Constants.sales_formattedEndDate})"),
                        ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8, left: 12, right: 12),
                child: Card(
                  surfaceTintColor: Colors.white,
                  color: Colors.white,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Container(
                      child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(24)),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(360)),
                                child: Center(
                                  child: Text(
                                    "#",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 0.0),
                                    child: Text("Assessment"),
                                  )),
                              Container(
                                width: 70,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Text(
                                    "Score",
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                              SizedBox(width: 28),
                            ],
                          ),
                        ),
                      ),
                      //    Text(Constants.micro_learn4b.length.toString()),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12, top: 12),
                        child: ((_selectedButton == 1 && isSalesDataLoading1a) ||
                                (_selectedButton == 2 &&
                                    isSalesDataLoading2a) ||
                                (_selectedButton == 3 && isSalesDataLoading3a))
                            ? Container(
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
                              )
                            : (_selectedButton == 1 &&
                                    sales_index == 0 &&
                                    Constants.micro_learn1a.length == 0)
                                ? Center(
                                    child: Text(
                                      "No data available for the selected range",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                : (_selectedButton == 2 &&
                                        sales_index == 1 &&
                                        Constants.micro_learn1a.length == 0)
                                    ? Center(
                                        child: Text(
                                          "No data available for the selected range",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        padding:
                                            EdgeInsets.only(top: 0, bottom: 16),
                                        itemCount: (_selectedButton == 1)
                                            ? (sales_index == 0
                                                ? min(
                                                    Constants
                                                        .micro_learn1a.length,
                                                    10)
                                                : sales_index == 1
                                                    ? min(
                                                        Constants.micro_learn1b
                                                            .length,
                                                        10)
                                                    : min(
                                                        Constants.micro_learn1c
                                                            .length,
                                                        10))
                                            : (_selectedButton == 2)
                                                ? (sales_index == 0
                                                    ? min(
                                                        Constants.micro_learn2a
                                                            .length,
                                                        10)
                                                    : sales_index == 1
                                                        ? min(
                                                            Constants
                                                                .micro_learn2b
                                                                .length,
                                                            10)
                                                        : min(
                                                            Constants
                                                                .micro_learn2c
                                                                .length,
                                                            10))
                                                : (_selectedButton == 3 &&
                                                        days_difference <= 31)
                                                    ? (sales_index == 0
                                                        ? min(
                                                            Constants
                                                                .micro_learn3a
                                                                .length,
                                                            10)
                                                        : sales_index == 1
                                                            ? min(
                                                                Constants
                                                                    .micro_learn3b
                                                                    .length,
                                                                10)
                                                            : min(
                                                                Constants.micro_learn3c.length, 10))
                                                    : (sales_index == 0
                                                        ? min(Constants.micro_learn4a.length, 10)
                                                        : sales_index == 1
                                                            ? min(Constants.micro_learn4a.length, 10)
                                                            : min(Constants.micro_learn4a.length, 10)),
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (BuildContext context, int index) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 35,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 4.0),
                                                          child: Text(
                                                              "${index + 1} "),
                                                        ),
                                                      ),
                                                      Expanded(
                                                          flex: 4,
                                                          child: Text(
                                                              "${extractFirstAndLastName((_selectedButton == 1) ? (sales_index == 0 ? Constants.micro_learn1a[index].employee_name : sales_index == 1 ? Constants.micro_learn1b[index].employee_name.trimLeft() : Constants.micro_learn1c[index].employee_name) : (_selectedButton == 2) ? (sales_index == 0 ? Constants.micro_learn2a[index].employee_name.trimLeft() : sales_index == 1 ? Constants.micro_learn2b[index].employee_name.trimLeft() : Constants.micro_learn2c[index].employee_name) : (_selectedButton == 3 && days_difference <= 31) ? (sales_index == 0 ? Constants.micro_learn3a[index].employee_name.trimLeft() : sales_index == 1 ? Constants.micro_learn3b[index].employee_name.trimLeft() : Constants.micro_learn3c[index].employee_name) : (sales_index == 0 ? Constants.micro_learn4a[index].employee_name.trimLeft() : sales_index == 1 ? Constants.micro_learn4b[index].employee_name.trimLeft() : Constants.micro_learn4c[index].employee_name))}")),
                                                      Container(
                                                        width: 70,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 12.0),
                                                          child: Text(
                                                            "${(_selectedButton == 1) ? (sales_index == 0 ? Constants.micro_learn1a[index].total_sales : sales_index == 1 ? Constants.micro_learn1b[index].total_sales.toInt() : Constants.micro_learn1c[index].total_sales.toInt()) : (_selectedButton == 2) ? (sales_index == 0 ? Constants.micro_learn2a[index].total_sales.toInt() : sales_index == 1 ? Constants.micro_learn2b[index].total_sales.toInt() : Constants.micro_learn2c[index].total_sales.toInt()) : (_selectedButton == 3 && days_difference <= 31) ? (sales_index == 0 ? Constants.micro_learn3a[index].total_sales.toInt() : sales_index == 1 ? Constants.micro_learn3b[index].total_sales.toInt() : Constants.micro_learn3c[index].total_sales.toInt()) : (sales_index == 0 ? Constants.micro_learn4a[index].total_sales.toInt() : sales_index == 1 ? Constants.micro_learn4b[index].total_sales.toInt() : Constants.micro_learn4c[index].total_sales.toInt())}",
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 28),
                                                    ],
                                                  ),
                                                  SizedBox(height: 3),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
              SizedBox(
                height: 4,
              ),
              _selectedButton == 1
                  ? Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 12),
                      child: Text(
                          "All Assessments (MTD - ${getMonthAbbreviation(DateTime.now().month)})"),
                    )
                  : _selectedButton == 2
                      ? Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 12),
                          child: Text("All Assessments (12 Months View)"),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 12),
                          child: Text(
                              "All Assessments (${Constants.sales_formattedStartDate} to ${Constants.sales_formattedEndDate})"),
                        ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8, left: 12, right: 12),
                child: Card(
                  surfaceTintColor: Colors.white,
                  color: Colors.white,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Container(
                      child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(24)),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(360)),
                                child: Center(
                                  child: Text(
                                    "#",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 0.0),
                                    child: Text("Assessment"),
                                  )),
                              Container(
                                width: 70,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Text(
                                    "Score",
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                              SizedBox(width: 28),
                            ],
                          ),
                        ),
                      ),
                      //    Text(Constants.micro_learn4b.length.toString()),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12, top: 12),
                        child: ((_selectedButton == 1 && isSalesDataLoading1a) ||
                                (_selectedButton == 2 &&
                                    isSalesDataLoading2a) ||
                                (_selectedButton == 3 && isSalesDataLoading3a))
                            ? Container(
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
                              )
                            : (_selectedButton == 1 &&
                                    sales_index == 0 &&
                                    Constants.micro_learn1a.length == 0)
                                ? Center(
                                    child: Text(
                                      "No data available for the selected range",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                : (_selectedButton == 2 &&
                                        sales_index == 1 &&
                                        Constants.micro_learn2a.length == 0)
                                    ? Center(
                                        child: Text(
                                          "No data available for the selected range",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        padding:
                                            EdgeInsets.only(top: 0, bottom: 16),
                                        itemCount: (_selectedButton == 1)
                                            ? (sales_index == 0
                                                ? min(
                                                    Constants
                                                        .micro_learn1a.length,
                                                    10)
                                                : sales_index == 1
                                                    ? min(
                                                        Constants.micro_learn1b
                                                            .length,
                                                        10)
                                                    : min(
                                                        Constants.micro_learn1c
                                                            .length,
                                                        10))
                                            : (_selectedButton == 2)
                                                ? (sales_index == 0
                                                    ? min(
                                                        Constants.micro_learn2a
                                                            .length,
                                                        10)
                                                    : sales_index == 1
                                                        ? min(
                                                            Constants
                                                                .micro_learn2b
                                                                .length,
                                                            10)
                                                        : min(
                                                            Constants
                                                                .micro_learn2c
                                                                .length,
                                                            10))
                                                : (_selectedButton == 3 &&
                                                        days_difference <= 31)
                                                    ? (sales_index == 0
                                                        ? min(
                                                            Constants
                                                                .micro_learn3a
                                                                .length,
                                                            10)
                                                        : sales_index == 1
                                                            ? min(
                                                                Constants
                                                                    .micro_learn3b
                                                                    .length,
                                                                10)
                                                            : min(
                                                                Constants.micro_learn3c.length, 10))
                                                    : (sales_index == 0
                                                        ? min(Constants.micro_learn4a.length, 10)
                                                        : sales_index == 1
                                                            ? min(Constants.micro_learn4a.length, 10)
                                                            : min(Constants.micro_learn4a.length, 10)),
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (BuildContext context, int index) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 35,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 4.0),
                                                          child: Text(
                                                              "${index + 1} "),
                                                        ),
                                                      ),
                                                      Expanded(
                                                          flex: 4,
                                                          child: Text(
                                                              "${extractFirstAndLastName((_selectedButton == 1) ? (sales_index == 0 ? Constants.micro_learn1a[index].employee_name : sales_index == 1 ? Constants.micro_learn1b[index].employee_name.trimLeft() : Constants.micro_learn1c[index].employee_name) : (_selectedButton == 2) ? (sales_index == 0 ? Constants.micro_learn2a[index].employee_name.trimLeft() : sales_index == 1 ? Constants.micro_learn2b[index].employee_name.trimLeft() : Constants.micro_learn2c[index].employee_name) : (_selectedButton == 3 && days_difference <= 31) ? (sales_index == 0 ? Constants.micro_learn3a[index].employee_name.trimLeft() : sales_index == 1 ? Constants.micro_learn3b[index].employee_name.trimLeft() : Constants.micro_learn3c[index].employee_name) : (sales_index == 0 ? Constants.micro_learn4a[index].employee_name.trimLeft() : sales_index == 1 ? Constants.micro_learn4b[index].employee_name.trimLeft() : Constants.micro_learn4c[index].employee_name))}")),
                                                      Container(
                                                        width: 70,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 12.0),
                                                          child: Text(
                                                            "${(_selectedButton == 1) ? (sales_index == 0 ? Constants.micro_learn1a[index].total_sales : sales_index == 1 ? Constants.micro_learn1b[index].total_sales.toInt() : Constants.micro_learn1c[index].total_sales.toInt()) : (_selectedButton == 2) ? (sales_index == 0 ? Constants.micro_learn2a[index].total_sales.toInt() : sales_index == 1 ? Constants.micro_learn2b[index].total_sales.toInt() : Constants.micro_learn2c[index].total_sales.toInt()) : (_selectedButton == 3 && days_difference <= 31) ? (sales_index == 0 ? Constants.micro_learn3a[index].total_sales.toInt() : sales_index == 1 ? Constants.micro_learn3b[index].total_sales.toInt() : Constants.micro_learn3c[index].total_sales.toInt()) : (sales_index == 0 ? Constants.micro_learn4a[index].total_sales.toInt() : sales_index == 1 ? Constants.micro_learn4b[index].total_sales.toInt() : Constants.micro_learn4c[index].total_sales.toInt())}",
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 28),
                                                    ],
                                                  ),
                                                  SizedBox(height: 3),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
            ],
          ),
        ),
      ),
    );
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
}

class compiancegridmodel {
  String id;
  int amount;
  compiancegridmodel(
    this.id,
    this.amount,
  );
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

String extractFirstAndLastName(String fullName) {
  RegExp regex = RegExp(r'^(\S+)\s+([^\s]+)\s+(\S+)+(\S+)$');
  Match? match = regex.firstMatch(fullName);
  if (match != null) {
    return '${match.group(1)} ${match.group(3)}';
  } else {
    return fullName;
  }
}
