import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/Constants.dart';
import '../../models/PaymentHistoryItem.dart';
import '../../models/PolicyDetails.dart';

List<ReprintItem> reprintList = [];
List<PaymentHistoryItem> paymentList = [];
List<PolicyDetails> policydetails = [];
bool showOptions = false;
bool isLoading = false;
List<Map<String, dynamic>> paymentHistoryList = [];
List<Map<String, dynamic>> policyDetailsList = [];

class ReprintAwaitingAction extends StatefulWidget {
  final String policiynumber;
  const ReprintAwaitingAction({
    Key? key,
    required this.policiynumber,
  }) : super(key: key);

  @override
  State<ReprintAwaitingAction> createState() => _ReprintAwaitingActionState();
}

List<bool> selectedOptions =
    List.generate(reprintList.length, (index) => false);

class _ReprintAwaitingActionState extends State<ReprintAwaitingAction> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: isLoading == true
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                    child: Container(
                        height: 55,
                        width: 55,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xffED7D32),
                        ))))
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 12.0,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Reprint requests for the past 7 days",
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 12.0,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "All reprints are only available for 48 hours after the request have been approved.",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
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
                                    color: Colors.grey.withOpacity(0.15)),
                                SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        "Authorized reprints",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      )),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8),
                                        child: Text(
                                          ":",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Expanded(
                                          child: Text(
                                        "${reprintList.length}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GroupedListView<ReprintItem, String>(
                        shrinkWrap: true,
                        elements: reprintList,
                        order: GroupedListOrder.DESC,
                        groupBy: (element) => DateFormat('MMM d, yyyy')
                            .format(DateTime.parse(element.payment_date))
                            .toString(),
                        groupSeparatorBuilder: (String groupByValue) => Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: 160,
                                decoration: BoxDecoration(
                                    color: Color(0x66ED7D32),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 12, top: 8, bottom: 8),
                                  child: Center(
                                      child: Text(
                                    groupByValue,
                                    style: TextStyle(color: Colors.black),
                                  )),
                                )),
                          ],
                        ),
                        itemBuilder: (context, ReprintItem element) {
                          bool isLastitem = false;
                          bool isPrintable = false;
                          int index = reprintList.indexOf(element);
                          if (index + 1 == reprintList.length) {
                            isLastitem = true;
                          }
                          String dateString1 = reprintList[index].payment_date;

                          DateTime date1 = DateTime.parse(dateString1);
                          DateTime date2 = DateTime.now();

                          Duration difference = date2.difference(date1);

                          //print('Difference in days: ${difference.inDays}');
                          if (kDebugMode) {
                            print('Difference in hours: ${difference.inHours}');
                          }
                          bool isPrintedBefore = false;

                          if (difference.inHours < 48 &&
                              reprintList[index].status == "Approved" &&
                              reprintList[index].is_printed == false) {
                            isPrintable = true;
                            if (kDebugMode) {
                              print("should print this slip");
                            }
                          } else {
                            print("${reprintList[index].status}");
                            print("${reprintList[index].is_printed}");
                          }
                          /*checkTransactionIdExists(
                                  reprintList[index].pos_transaction_id)
                              .then((value) {
                            if (value == true) {
                              isPrintable = false;
                              setState(() {});
                            }
                          });*/
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                      elevation: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0, right: 12),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                  "Policy number",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0,
                                                          right: 16),
                                                  child: Text(
                                                    ":",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  element.policy_number,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0, right: 12),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                  "Payment made on",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0,
                                                          right: 16),
                                                  child: Text(
                                                    ":",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  element.payment_date,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0, right: 12),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                  "Branch",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0,
                                                          right: 16),
                                                  child: Text(
                                                    ":",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  element.branch,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0, right: 12),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                  "Amount",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0,
                                                          right: 16),
                                                  child: Text(
                                                    ":",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  "R ${double.parse(element.amount).toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0, right: 12),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                  "Approval Status",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0,
                                                          right: 16),
                                                  child: Text(
                                                    ":",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  (element.is_printed == true)
                                                      ? "Printed"
                                                      : element.status,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          /* Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0, right: 12),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                  "Print Status",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0,
                                                          right: 16),
                                                  child: Text(
                                                    ":",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  (element.is_printed == false)
                                                      ? "Not printed"
                                                      : "Printed",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                              ],
                                            ),
                                          ),*/
                                          SizedBox(
                                            height: 12,
                                          ),
                                          //if (paymen)

                                          SizedBox(
                                            height: 12,
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          );
                        },
                        itemComparator: (item1, item2) => item1.collection_date
                            .compareTo(item2.collection_date),
                        useStickyGroupSeparators: true,
                        floatingHeader: true,
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
    reprintList = [];
    Constants.selectedPolicydetails1 = [];
    Constants.selectedPolicydetails = [];
    Constants.paymentHistoryList = [];
    isLoading = true;

    getPaymentHistory1(widget.policiynumber);
    Future.delayed(Duration(seconds: 2)).then((value) {
      getReprintHistory(widget.policiynumber);
    });
    //updatePrintRequest("ATH12342", "32328790967221");

    super.initState();
  }

  getPaymentHistory1(policynumber) async {
    if (kDebugMode) {
      print("AAAA " + Constants.user_reference);
      print("AAAA " + Constants.cec_client_id.toString());
    }
    String urlPath = "/collection/payment_history/";
    String apiUrl = Constants.baseUrl + urlPath;
    print("apiUrl $apiUrl");
    DateTime now = DateTime.now();

    // Construct the request body
    Map<String, dynamic> requestBody = {
      "token": "kjhjguytuyghjgjhg765764tyfu",
      "policy_number": policynumber,
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
        // print("datay $policynumber $data");
        for (var element in dataList) {
          //print("dataz $policynumber $element");
          Constants.paymentHistoryList.add(PaymentHistoryItem(
            collection_date: element["collection_date"],
            payment_date: element["payment_date"],
            policy_number: element["policy_number"],
            pos_transaction_id: element["pos_transaction_id"],
            amount: element["premium"].toString() ?? "0",
            collected_premium: element["collected_premium"] ?? 0,
            status: element["payment_status"] ?? "",
            acceptTerms: true,
            emp_id: element["emp_id"] ?? 0,
            employee_name: element["employee_name"] ?? "",
            employee_surname: element["employee_surname"] ?? "",
            employee_number: element["employee_number"] ?? "",
          ));
          //Constants.paymentHistoryList.sort((a,b)=>a.collection_date);
        }
        // print("dataxf ${c.runtimeType}");
      } else {
        var data = jsonDecode(response.body);
        print("error_data $data");
        //setState(() {});

        print("Request failed with status: ${response.statusCode}");
      }

      // Perform your transaction logic here

      // Close the dialog
    } catch (error) {
      print("Error: $error");
    }
  }

  // Add a new print request
  Future<void> updatePrintRequest(
      String policyNumber, String transactionId) async {
    var headers = {'Content-Type': 'application/json'};

    var body = json.encode({
      "policy_number": policyNumber,
      "transaction_id": transactionId,
      "is_printed": 1,
    });
    var response = await http.post(
      Uri.parse(
          "${Constants.insightsBackendBaseUrl}files/update_reprint_request/"),
      body: body,
      headers: {
        "Content-Type": "application/json",
      },
    );
    print(response.statusCode);
    print(response.body);
  }

// Delete a print request
  Future<bool> deletePrintRequest(String policyNumber) async {
    String baseUrl = "${Constants.insightsBackendBaseUrl}files";
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

  getReprintHistory(policy_number) async {
    if (kDebugMode) {
      print(Constants.user_reference);
      print(Constants.cec_client_id);
    }
    String baseUrl = "${Constants.insightsBackendBaseUrl}files";
    String urlPath = "/get_requests_accepted/";
    String apiUrl = baseUrl + urlPath;
    DateTime now = DateTime.now();

    // Construct the request body
    Map<String, dynamic> requestBody = {
      "policy_number": policy_number,
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
      print(response.body);
      // Simulating transaction processing with a delay

      // Navigator.of(context).pop();
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<dynamic> dataList = data;
        print("dataygfg $data");
        for (var element in dataList) {
          //print("dataz $policy_number $element");

          if (element["policy_number"] == widget.policiynumber) {
            reprintList.add(ReprintItem(
              collection_date: element["timestamp"],
              payment_date: element["transaction_date"],
              policy_number: element["policy_number"],
              pos_transaction_id: element["transaction_id"] ?? "",
              amount: element["collected_amount"].toString() ?? "0",
              status: element["status"] ?? "",
              branch: element["branch"] ?? "",
              is_printed: element["is_printed"] ?? true,
            ));
            if (mounted) setState(() {});
          }
        }
        isLoading = false;
        setState(() {});

        // print("dataxf ${c.runtimeType}");
      } else {
        isLoading = false;
        setState(() {});
        var data = jsonDecode(response.body);
        // print("data $data");
        //setState(() {});

        print("Request failed with status: ${response.statusCode}");
      }

      // Perform your transaction logic here

      // Close the dialog
    } catch (error) {
      print("Error: $error");
    }
  }
}

class ReprintItem {
  final String payment_date;
  final String collection_date;
  final String amount;
  final String status;
  final String policy_number;
  final String branch;
  bool is_printed;
  final String pos_transaction_id;
  ReprintItem({
    required this.payment_date,
    required this.amount,
    required this.status,
    required this.collection_date,
    required this.policy_number,
    required this.branch,
    required this.is_printed,
    required this.pos_transaction_id,
  });
  toJson() {
    return {
      "payment_date": payment_date,
      "amount": amount,
      "is_printed": is_printed,
      "status": status,
      "pos_transaction_id": pos_transaction_id,
      "collection_date": collection_date,
      "policy_number": policy_number,
    };
  }
}

Future<void> saveTransactionId(String posTransactionId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String>? transactionIds = prefs.getStringList('transactionIds') ?? [];
  // Check if the id already exists in the list to avoid duplicates
  if (!transactionIds.contains(posTransactionId)) {
    transactionIds.add(posTransactionId);
    await prefs.setStringList('transactionIds', transactionIds);
  }
}

Future<bool> checkTransactionIdExists(String posTransactionId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String>? transactionIds = prefs.getStringList('transactionIds') ?? [];
  return transactionIds.contains(posTransactionId);
}

Future<List<Map<String, dynamic>>> getPaymentHistoryA() async {
  // Get the policies in the format needed for the method channel
  policyDetailsList =
      convertPolicyDetailsToMapList(Constants.selectedPolicydetails1);
  paymentHistoryList =
      convertpaymentHistoryMapList(Constants.paymentHistoryList);

  print("---" + paymentHistoryList.toString());
  return paymentHistoryList;
}

List<Map<String, dynamic>> convertPolicyDetailsToMapList(
    List<PolicyDetails1> policies) {
  policies.forEach((element) async {
    await Future.wait(
        policies.map((element) => getPaymentHistory1(element.policyNumber)));
  });
  return policies
      .map((policy) => policy.toJson() as Map<String, dynamic>)
      .toList();
}

List<Map<String, dynamic>> convertpaymentHistoryMapList(
    List<PaymentHistoryItem> paymentsList1) {
  return paymentsList1
      .map((paymentItem) => paymentItem.toJson() as Map<String, dynamic>)
      .toList();
}

getPaymentHistory1(policynumber) async {
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
    "policy_number": policynumber,
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
      // print("datay $policynumber $data");
      for (var element in dataList) {
        print("dataz $policynumber $element");
        Constants.paymentHistoryList.add(PaymentHistoryItem(
          collection_date: element["collection_date"],
          payment_date: element["payment_date"],
          policy_number: element["policy_number"],
          pos_transaction_id: element["pos_transaction_id"],
          amount: element["premium"].toString() ?? "0",
          collected_premium: element["collected_premium"] ?? 0,
          status: element["payment_status"] ?? "",
          acceptTerms: true,
          emp_id: element["emp_id"] ?? 0,
          employee_name: element["employee_name"] ?? "",
          employee_surname: element["employee_surname"] ?? "",
          employee_number: element["employee_number"] ?? "",
        ));
      }
      // print("dataxf ${c.runtimeType}");
    } else {
      var data = jsonDecode(response.body);
      // print("data $data");
      //setState(() {});

      print("Request failed with status: ${response.statusCode}");
    }

    // Perform your transaction logic here

    // Close the dialog
  } catch (error) {
    print("Error: $error");
  }
}
