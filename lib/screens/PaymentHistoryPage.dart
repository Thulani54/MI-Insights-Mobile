import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constants/Constants.dart';
import '../customwidgets/CustomCard.dart';
import '../models/PaymentHistoryItem.dart';

List<PaymentHistoryItem> paymentList = [];
bool showOptions = false;
bool isLoading = false;
bool containsPayments = false;

class PaymentHistoryPage extends StatefulWidget {
  final String policiynumber;
  final String planType;
  final String status;
  const PaymentHistoryPage(
      {Key? key,
      required this.policiynumber,
      required this.planType,
      required this.status})
      : super(key: key);

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

List<bool> selectedOptions =
    List.generate(paymentList.length, (index) => false);
int selectedIndex = -1;
final ScrollController _controller1 = ScrollController();

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shadowColor: Colors.black.withOpacity(0.6),
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                CupertinoIcons.back,
                color: Colors.black,
              ),
            ),
            title: Text(
              "Payment Management",
              style: TextStyle(color: Colors.black),
            ),
            actions: [],
            bottom: const TabBar(
              tabs: [
                Tab(
                    child: Text(
                  "Payment History",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  textAlign: TextAlign.center,
                )),
                Tab(
                    child: Text(
                  "Payment Allocation",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  textAlign: TextAlign.center,
                )),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              isLoading == true
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                          child: Container(
                              height: 45,
                              width: 45,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Color(0xffED7D32),
                              ))))
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 200,
                      child: Container(
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 12.0, bottom: 0),
                                child: CustomCard(
                                  elevation: 6,
                                  color: Colors.white,
                                  surfaceTintColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0.0),
                                          child: Center(
                                            child: Text(
                                              "Policy # : ${widget.policiynumber}",
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                            top: 6.0,
                                            left: 0,
                                            right: 0,
                                          ),
                                          height: 1,
                                          color: Colors.grey.withOpacity(0.15),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 0.0,
                                              right: 0,
                                              top: 12,
                                              bottom: 12),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text(
                                                      "Date",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Text(
                                                    "Amount Paid",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        containsPayments == false
                                            ? Container(
                                                height: 300,
                                                child: Center(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16.0),
                                                  child: Text(
                                                    "No Payments Available For This Policy",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                )),
                                              )
                                            : Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 16.0),
                                                  child: Container(
                                                    height: MediaQuery.of(
                                                            context)
                                                        .size
                                                        .width, // Set a height to allow scrolling within this container
                                                    child: Scrollbar(
                                                      thickness: 8,
                                                      controller: _controller1,
                                                      trackVisibility: true,
                                                      thumbVisibility: true,
                                                      radius:
                                                          Radius.circular(20.0),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 0.0),
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              AlwaysScrollableScrollPhysics(),
                                                          itemCount: paymentList
                                                              .length,
                                                          controller:
                                                              _controller1,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final payment =
                                                                paymentList[
                                                                    index];
                                                            final isSelected =
                                                                selectedIndex ==
                                                                    index;
                                                            final isPaidAndCollected =
                                                                payment.status ==
                                                                        "paid" &&
                                                                    payment.collected_premium !=
                                                                        0;

                                                            return InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  selectedIndex =
                                                                      isSelected
                                                                          ? -1
                                                                          : index;
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        6.0),
                                                                child: Column(
                                                                  children: [
                                                                    if (isPaidAndCollected)
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              DateFormat('MMM d, yyyy').format(DateTime.parse(payment.payment_date)),
                                                                              style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 13,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              "R ${payment.collected_premium.toStringAsFixed(2)}",
                                                                              style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 13,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    if (isSelected)
                                                                      const SizedBox(
                                                                          height:
                                                                              8),
                                                                  ],
                                                                ),
                                                              ),
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              isLoading == true
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                          child: Container(
                              height: 55,
                              width: 55,
                              child: const CircularProgressIndicator(
                                strokeWidth: 1,
                                color: Color(0xffED7D32),
                              ))))
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16, top: 12, bottom: 12),
                              child: CustomCard(
                                elevation: 6,
                                color: Colors.white,
                                surfaceTintColor: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 0.0),
                                        child: Center(
                                          child: Text(
                                            "Policy # : ${widget.policiynumber}",
                                            style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 6.0, left: 0, right: 0),
                                        height: 1,
                                        color: Colors.grey.withOpacity(0.15),
                                      ),
                                      SizedBox(height: 12),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 32.0, right: 16),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Plan Type",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0, right: 16),
                                              child: Text(
                                                ":",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                widget.planType,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 32.0, right: 16),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Status",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0, right: 16),
                                              child: Text(
                                                ":",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                widget.status,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20, top: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Text(
                                          "Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        "Amount",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        "Status",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: CustomCard(
                                  elevation: 6,
                                  color: Colors.white,
                                  surfaceTintColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.6, // Adjust this height as necessary
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 24.0),
                                      child: Scrollbar(
                                        thickness: 8,
                                        trackVisibility: true,
                                        thumbVisibility: true,
                                        radius: Radius.circular(20.0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: paymentList.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  // Handle item tap here
                                                  setState(() {
                                                    if (selectedIndex ==
                                                        index) {
                                                      // If the same item is tapped again, deselect it
                                                      selectedIndex = -1;
                                                    } else {
                                                      // If a different item is tapped, select it
                                                      selectedIndex = index;
                                                    }
                                                  });
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              DateFormat(
                                                                      'MMM d, yyyy')
                                                                  .format(DateTime.parse(
                                                                      paymentList[
                                                                              index]
                                                                          .collection_date))
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              "R ${double.parse(paymentList[index].amount).toStringAsFixed(2)}",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              paymentList[index]
                                                                  .status
                                                                  .replaceFirst(
                                                                      "paid",
                                                                      "Paid")
                                                                  .replaceFirst(
                                                                      "unPaid",
                                                                      "Unpaid"),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      if (selectedIndex ==
                                                          index)
                                                        SizedBox(height: 8),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    paymentList = [];
    Constants.selectedPolicydetails1 = [];
    Constants.selectedPolicydetails = [];
    Constants.paymentHistoryList = [];
    setState(() {});
    isLoading = true;
    getPaymentHistory();
    super.initState();
  }

  // Add a new print request
  Future<bool> addPrintRequest(Map<String, dynamic> requestData) async {
    String baseUrl = "https://miinsightsapps.net/files";
    final response = await http.post(
      Uri.parse('$baseUrl/add-print-request'),
      body: jsonEncode(requestData),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success']) {
        return true;
      }
    }
    return false;
  }

  // Update a print request
  Future<bool> updatePrintRequest(
      String policyNumber, Map<String, dynamic> updateData) async {
    String baseUrl = "https://miinsightsapps.net/files";
    final response = await http.put(
      Uri.parse('$baseUrl/update-print-request/$policyNumber'),
      body: jsonEncode(updateData),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success']) {
        return true;
      }
    }
    return false;
  }

  // Delete a print request
  Future<bool> deletePrintRequest(String policyNumber) async {
    String baseUrl = "https://miinsightsapps.net/files";
    final response = await http.delete(
      Uri.parse('$baseUrl/delete-print-request/$policyNumber'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success']) {
        return true;
      }
    }
    return false;
  }

  getPaymentHistory() async {
    if (kDebugMode) {
      print(Constants.user_reference);
      print(Constants.cec_client_id);
    }

    String urlPath = "/collection/payment_history/";
    String apiUrl = Constants.baseUrl + urlPath;
    DateTime now = DateTime.now();

    // Construct the request body
    Map<String, dynamic> requestBody = {
      "token": "kjhjguytuyghjgjhg765764tyfu",
      "policy_number": widget.policiynumber,
      "cec_client_id": Constants.cec_client_id,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(requestBody),
        headers: {
          "Content-Type": "application/json",
        },
      );
      // Simulating transaction processing with a delay

      // Navigator.of(context).pop();
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<dynamic> dataList = data;

        for (var element in dataList) {
          paymentList.add(PaymentHistoryItem(
            collection_date: element["collection_date"] ?? "",
            payment_date: element["payment_date"] ?? "",
            policy_number: element["policy_number"] ?? "",
            pos_transaction_id: element["pos_transaction_id"] ?? "",
            amount: element["premium"].toString() ?? "0",
            collected_premium: element["collected_premium"] ?? 0,
            status: element["payment_status"] ?? "",
            acceptTerms: true,
            emp_id: element["emp_id"] ?? 0,
            employee_name: element["employee_name"] ?? "",
            employee_surname: element["employee_surname"] ?? "",
            employee_number: element["employee_number"] ?? "",
          ));

          if (kDebugMode) {
            print("datax $element");
          }
          // if (element["collected_premium"] ?? 0.0 > 0) {
          //
          // }
          containsPayments = true;
          if (mounted) setState(() {});
        }

        isLoading = false;
        setState(() {});
        //print("datax ${c.runtimeType}");
      } else {
        var data = jsonDecode(response.body);
        if (kDebugMode) {
          print("data $data");
        }
        isLoading = false;
        setState(() {});

        print("Request failed with status: ${response.statusCode}");
      }

      // Perform your transaction logic here

      // Close the dialog
    } catch (error) {
      print("Error: $error");
    }
  }

/*
  void _toggleAcceptTerms1(bool? value, index) {
    setState(() {
      paymentHistoryList[index].acceptTerms = value!;
      //policydetails[index].monthsToPayFor = selectedMonth;

      if (policydetails[index].acceptTerms) {
        if (!Constants.selectedPolicydetails.contains(policydetails[index])) {
          Constants.selectedPolicydetails.add(policydetails[index]);
        }
      } else {
        Constants.selectedPolicydetails.remove(policydetails[index]);
      }

      totalAmount = 0;
      for (var element in Constants.selectedPolicydetails) {
        if (element.acceptTerms == true) {
          totalAmount += element.monthlyPremium * element.monthsToPayFor;
          myValue.value++;
        }
      }
    });
  }
*/

  _toggleAcceptTerms() {}
}
