import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../constants/Constants.dart';
import '../../models/PaymentHistoryItem.dart';
import '../../models/PolicyDetails.dart';

List<Map<String, dynamic>> paymentHistoryList = [];
List<Map<String, dynamic>> policyDetailsList = [];

class PaymentSuccessfulScreen extends StatefulWidget {
  const PaymentSuccessfulScreen({Key? key}) : super(key: key);

  @override
  State<PaymentSuccessfulScreen> createState() =>
      _PaymentSuccessfulScreenState();
}

class _PaymentSuccessfulScreenState extends State<PaymentSuccessfulScreen> {
  int _remainingSeconds = 60;
  Timer? _timer;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 85,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Center(
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: SvgPicture.asset(
                              "lib/assets/logo.svg",
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 12),
                child: Row(
                  children: [
                    Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: MediaQuery.of(context).size.width * 0.35,
                      decoration: BoxDecoration(
                        color: Color(0xffED7D32),
                        borderRadius: BorderRadius.circular(360),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Center(
                            child: Icon(
                          CupertinoIcons.check_mark,
                          color: Colors.white,
                          size: 70,
                        )),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  "Payment Successful",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.green),
                ),
              ),
              SizedBox(height: 16),
              /*   Padding(
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  "Please print the proof of payment for the client then return to search",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),*/
              /* Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                  onTap: () async {
                    SlipDetails policy = SlipDetails(
                      policyNumber: 'FC/000028/2020',
                      planType: 'Bronze',
                      status: 'Active',
                      monthsToPayFor: 1,
                      paymentStatus: 'Premiums',
                      paymentsBehind: 2,
                      monthlyPremium: 120.0,
                      benefitAmount: 10000.0,
                    );
                    print("fhhg");

                    (await recieptpdf().generatePDFSlip2("CLIENT"));

                    */ /*      final pdfPath =
                        (await recieptpdf().generatePDFSlip2("CLIENT")).path;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PDFViewerScreen(
                          pdfPath: pdfPath,
                        ),
                      ),
                    );*/ /*
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffED7D32),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            width: 1.2,
                            color: Color(0xffED7D32),
                          )),
                      padding: EdgeInsets.only(left: 0, right: 16),
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      child: Center(
                          child: Text(
                        "Print client Slip",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.white),
                      ))),
                ),
              ),*/
              /* Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                  onTap: () async {
                    SlipDetails policy = SlipDetails(
                      policyNumber: 'FC/000028/2020',
                      planType: 'Bronze',
                      status: 'Active',
                      monthsToPayFor: 1,
                      paymentStatus: 'Premiums',
                      paymentsBehind: 2,
                      monthlyPremium: 120.0,
                      benefitAmount: 10000.0,
                    );
                    print("fhhg");

                    final pdfPath =
                        (await recieptpdf().generatePDFSlip2("BUSINESS"));
                    */ /*       Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PDFViewerScreen(
                          pdfPath: pdfPath,
                        ),
                      ),
                    );*/ /*
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffED7D32),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            width: 1.2,
                            color: Color(0xffED7D32),
                          )),
                      padding: EdgeInsets.only(left: 0, right: 16),
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      child: Center(
                          child: Text(
                        "Print business slip",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.white),
                      ))),
                ),
              ),*/
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    /* Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentSuccessfulScreen()));*/
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            width: 1.2,
                            color: Color(0xffED7D32),
                          )),
                      padding: EdgeInsets.only(left: 0, right: 16),
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      child: Center(
                          child: Text(
                        "Go back to Search",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xffED7D32)),
                      ))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    printSlips();
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
          Navigator.pop(context); // Pop the dialog
          Navigator.pop(context);

          //  _showDialog(context);
        }
      });
    });
  }

  void _showDialog(context1) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Time's Up!"),
        content: Text("Your time has run out."),
        actions: <Widget>[
          InkWell(
            child: Container(
                decoration: BoxDecoration(
                    color: Color(0xffED7D32),
                    borderRadius: BorderRadius.circular(360),
                    border: Border.all(
                      width: 1.2,
                      color: Color(0xffED7D32),
                    )),
                width: 200,
                height: 45,
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                )),
            onTap: () {
              Navigator.pop(context1);
            },
          ),
        ],
      ),
    );
  }

  void _resetTimer() {
    setState(() {
      _remainingSeconds = 60;
      startTimer();
    });
  }

  Future<void> printSlips() async {
    print("fgffhfgh 0");
    Future.delayed(const Duration(seconds: 15));
    print("fgffhfgh 1");
    //(await recieptpdf().generatePDFSlip2("Client Slip"));
  }

  Future<void> printSlips1() async {
    print("aasd");
    getPaymentHistoryA().then((value) async {
      try {
        if (kDebugMode) {
          print("paymentHistoryList3 $paymentHistoryList");
        }
        String recieptref = DateTime.now().millisecond.toString();
        String referencef2 =
            "${DateFormat('yyyyMMdd').format(DateTime.now())}${DateFormat('HHmmssS').format(DateTime.now())}";
        const MethodChannel _channel =
            MethodChannel('com.example.intentChannel');
        /* await _channel.invokeMethod('printPDF', {
          "reference": referencef2,
          "paymentmethod": Constants.paymentmethod,
          "policies": policyDetailsList,
          "paymentHistoryList": value,
          "companyname": Constants.currentBusinessInfo.comp_name,
          "address_1": Constants.currentBusinessInfo.address_1,
          "province": Constants.currentBusinessInfo.province,
          "address_2": Constants.currentBusinessInfo.address_2,
          "city": Constants.currentBusinessInfo.city,
          "tel_no": "${Constants.currentBusinessInfo.tel_no}",
          "employee": "${Constants.cec_empname}",
          "logo": "${Constants.cec_logo}",
          "cell_number": "${Constants.cell_number}",
          "customer_id_number": "${Constants.customer_id_number}",
          "customer_name":
          "${Constants.customer_first_name[0] + "." + Constants.customer_last_name}",
          "vat_number": "${Constants.currentBusinessInfo.vat_number}",
          "fsp": "${Constants.currentBusinessInfo.client_fsp}",
          "type": "Client Slip",
          "date":
          "${DateFormat('MMM d, yyyy').format(DateTime.now())} @ ${DateFormat('hh:mm a').format(DateTime.now())}",
        });*/
      } on PlatformException catch (e) {
        if (kDebugMode) {
          print("paymentHistoryList3 $paymentHistoryList");
          print('Error printing PDF: ${e.message}');
        }
      }
    });
    //
    //(await recieptpdf().generatePDFSlip2("Client Slip"));
  }

  Future<List<Map<String, dynamic>>> getPaymentHistoryA() async {
    // Get the policies in the format needed for the method channel
    policyDetailsList =
        convertPolicyDetailsToMapList(Constants.selectedPolicydetails);
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
            status: element["payment_status"] ?? "",
            collected_premium: element["collected_premium"] ?? 0,
            acceptTerms: false,
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
}
