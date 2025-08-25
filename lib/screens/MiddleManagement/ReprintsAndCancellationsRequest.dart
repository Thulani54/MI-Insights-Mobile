import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mi_insights/customwidgets/CustomCard.dart';

import '../../constants/Constants.dart';
import '../../customwidgets/custom_date_range_picker.dart';
import '../../models/POSPaymentSlipReprintRequest.dart';
import '../../services/inactivitylogoutmixin.dart';

class ReprintsandcancellationsrequestMid extends StatefulWidget {
  const ReprintsandcancellationsrequestMid({super.key});

  @override
  State<ReprintsandcancellationsrequestMid> createState() =>
      _ReprintsandcancellationsrequestMidState();
}

double _sliderPosition = 0.0;
int _selectedButton = 1;
int target_index = 0;
DateTime? startDate = DateTime.now();
DateTime? endDate = DateTime.now();
double _sliderPosition2 = 0.0;
int days_difference = 0;
List<POSPaymentSlipReprintRequest> allReprints = [];

class _ReprintsandcancellationsrequestMidState
    extends State<ReprintsandcancellationsrequestMid>
    with InactivityLogoutMixin {
  Color _button1Color = Colors.grey.withOpacity(0.0);
  Color _button2Color = Colors.grey.withOpacity(0.0);
  Color _button3Color = Colors.grey.withOpacity(0.0);
  int currentLevel = 0;
  double _sliderPosition = 0.0;

  void _animateButton(int buttonNumber, BuildContext context) {
    restartInactivityTimer();

    setState(() {
      _selectedButton = buttonNumber;

      if (buttonNumber == 1) {
        startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
        endDate = DateTime.now();
        _sliderPosition = 0.0;
      } else if (buttonNumber == 2) {
        _sliderPosition = (MediaQuery.of(context).size.width / 3) - 18;
        startDate = DateTime.now().subtract(Duration(days: 365));
        endDate = DateTime.now();
      } else if (buttonNumber == 3) {
        _sliderPosition = 2 * (MediaQuery.of(context).size.width / 3) - 32;
      }

      _button1Color = buttonNumber == 1
          ? Constants.ctaColorLight
          : Colors.grey.withOpacity(0.0);
      _button2Color = buttonNumber == 2
          ? Constants.ctaColorLight
          : Colors.grey.withOpacity(0.0);
      _button3Color = buttonNumber == 3
          ? Constants.ctaColorLight
          : Colors.grey.withOpacity(0.0);
    });

    if (buttonNumber == 3) {
      showCustomDateRangePicker(
        context,
        dismissible: false,
        minimumDate: DateTime.utc(2023, 06, 01),
        maximumDate: DateTime.now(),
        backgroundColor: Colors.white,
        primaryColor: Constants.ctaColorLight,
        onApplyClick: (start, end) {
          setState(() {
            endDate = end;
            startDate = start;
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          shadowColor: Colors.grey.withOpacity(0.45),
          elevation: 6,
          backgroundColor: Colors.white,
          title: const Text(
            "Reprint And Cancellation Requests",
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              CupertinoIcons.back,
              color: Colors.black,
              size: 24,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
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
                              GestureDetector(
                                onTap: () {
                                  _animateButton(1, context);
                                },
                                child: Container(
                                  width:
                                      (MediaQuery.of(context).size.width / 3) -
                                          12,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(360),
                                  ),
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
                                  width:
                                      (MediaQuery.of(context).size.width / 3) -
                                          12,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(360),
                                  ),
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
                                  width:
                                      (MediaQuery.of(context).size.width / 3) -
                                          12,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(360),
                                  ),
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
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          'Select Dates',
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
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 12),
                child: Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.35),
                ),
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
                                      (MediaQuery.of(context).size.width / 2) -
                                          16,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(360)),
                                  height: 35,
                                  child: Center(
                                    child: Text(
                                      'Reprint Requests',
                                      style: TextStyle(color: Colors.black),
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
                                      (MediaQuery.of(context).size.width / 2) -
                                          16,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(360)),
                                  child: Center(
                                    child: Text(
                                      'Cancellation Requests',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
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
                                  (MediaQuery.of(context).size.width / 2) - 16,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Constants
                                    .ctaColorLight, // Color of the slider
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: target_index == 0
                                  ? Center(
                                      child: Text(
                                        'Reprint Requests',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : target_index == 1
                                      ? Center(
                                          child: Text(
                                            'Cancellation Requests',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      : Container()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              isLoadingReprints
                  ? Center(child: CircularProgressIndicator())
                  : allReprints.isEmpty
                      ? Center(
                          child: Text(
                              "List doesn't contain reprints ${allReprints.length}"))
                      : ListView.builder(
                          itemCount: allReprints.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final reprint = allReprints[index];
                            print(reprint);
                            return Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16, top: 12),
                                child: CustomCard(
                                  elevation: 6,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Policy Number: ${reprint.policyNumber}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        _buildInfoRow(
                                            "Transaction Date:",
                                            _formatDate(
                                                reprint.transactionDate)),
                                        if (reprint.clientName.isNotEmpty)
                                          _buildInfoRow(
                                              "Client Name:",
                                              reprint.clientName.isEmpty
                                                  ? 'N/A'
                                                  : reprint.clientName),
                                        _buildInfoRow("Collected Amount:",
                                            "R${reprint.collectedAmount.toStringAsFixed(2)}"),
                                        _buildInfoRow("Processed By:",
                                            reprint.processedBy),
                                        if (reprint.employeeName.isNotEmpty)
                                          _buildInfoRow(
                                              "Employee Name:",
                                              reprint.employeeName.isEmpty
                                                  ? 'N/A'
                                                  : reprint.employeeName),
                                        if (reprint.branch != "-")
                                          _buildInfoRow(
                                              "Branch:", reprint.branch),
                                        _buildInfoRow("Is Printed:",
                                            reprint.isPrinted ? 'Yes' : 'No'),
                                        _buildInfoRow("Reason for Request:",
                                            reprint.reasonForRequest),
                                        if (reprint.declineReason != null &&
                                            reprint.declineReason!.isNotEmpty)
                                          if (reprint.declineReason!.isNotEmpty)
                                            _buildInfoRow("Decline Reason:",
                                                reprint.declineReason!),
                                        _buildInfoRow(
                                            "Status:", reprint.status),
                                        _buildInfoRow("Timestamp:",
                                            _formatDate(reprint.timestamp)),
                                        if (reprint.status == "Awaiting Action")
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    // Approve action
                                                    print(
                                                        "Approve pressed for ${reprint.policyNumber}");
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.white,
                                                    backgroundColor:
                                                        Colors.green,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  child: Text("Approve"),
                                                ),
                                                SizedBox(width: 8),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    // Decline action
                                                    print(
                                                        "Decline pressed for ${reprint.policyNumber}");
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.white,
                                                    backgroundColor: Colors.red,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  child: Text("Decline"),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ));
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    getReprints();
    super.initState();
  }

  String _formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year} ${date.hour}:${date.minute}";
  }

  bool isLoadingReprints = false;

  Future<void> getReprints() async {
    setState(() {
      isLoadingReprints = true;
    });
    String baseUrl = "${Constants.baseUrl2}/files/get_requests_by_client/";
    print(baseUrl);

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse(baseUrl),
      );
      request.body = json.encode({"cec_client_id": 1});
      request.headers.addAll(headers);

      http.StreamedResponse streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        String responseString = await streamedResponse.stream.bytesToString();
        List<dynamic> reprints = jsonDecode(responseString);
        if (kDebugMode) {
          print(responseString);
        }

        setState(() {
          for (var reprint in reprints) {
            allReprints.add(POSPaymentSlipReprintRequest.fromJson(reprint));
          }
        });
        print(allReprints.length);
      } else {
        if (kDebugMode) {
          print('Error: ${streamedResponse.reasonPhrase}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred: $e');
      }
    } finally {
      setState(() {
        isLoadingReprints = false;
      });
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
