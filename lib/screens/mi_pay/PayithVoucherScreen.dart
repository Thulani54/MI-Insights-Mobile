import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../constants/Constants.dart';
import '../../models/BusinessInfo.dart';
import 'PaymentSuccessfulScreen.dart';

class PayithVoucherScreen extends StatefulWidget {
  final String employeeuid;
  final String policynumber;
  final double totalAmountToPay;
  const PayithVoucherScreen(
      {Key? key,
      required this.employeeuid,
      required this.policynumber,
      required this.totalAmountToPay})
      : super(key: key);

  @override
  State<PayithVoucherScreen> createState() => _PayithVoucherScreenState();
}

class _PayithVoucherScreenState extends State<PayithVoucherScreen> {
  double userBalance = 0.0;
  TextEditingController voucherController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          shadowColor: Colors.grey.withOpacity(0.55),
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              CupertinoIcons.back,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          title: Text(
            "Pay with voucher",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  /* Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Icon(
                      Icons.skip_previous_outlined,
                      size: 38,
                    ),
                  ),*/
                  /*  Expanded(
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
                  ),*/
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Text(
                            "MI Wallet",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Total Amount to Pay",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            )),
                            Text(
                              " : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                "R${widget.totalAmountToPay.toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              "User Balance",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            )),
                            Text(
                              " : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                "R${userBalance.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  //  color: Color(0xffED7D32),
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        widget.totalAmountToPay <= userBalance
                            ? Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Text(
                                  "Sufficient to pay Premium",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Text(
                                  "Top-up to cover full premium",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red),
                                ),
                              ),
                        SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 0, bottom: 0),
                          child: Text(
                            "Top up wallet",
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          color: Color(0x00FFFFFF),
                          padding: EdgeInsets.only(left: 4, right: 4),
                          width: MediaQuery.of(context).size.width,
                          height: 55,
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(360)),
                                    elevation: 5,
                                    child: TextFormField(
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        enabledBorder: null,
                                        contentPadding: EdgeInsets.only(
                                          left: 16,
                                        ),
                                        border: InputBorder.none,
                                        hintText: 'Enter voucher number ',
                                        hintStyle: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                              fontSize: 13.5,
                                              color: Colors.grey,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        focusedBorder: null,
                                        filled: false,
                                        fillColor:
                                            Colors.black.withOpacity(0.25),
                                      ),
                                      controller: voucherController,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: InkWell(
                                onTap: () async {
                                  if (kDebugMode) {
                                    print(Constants.user_reference);
                                    print(Constants.cec_client_id);
                                  }
                                  showDialog(
                                    context: context,
                                    barrierDismissible:
                                        false, // Prevent dialog from closing when tapping outside
                                    builder: (BuildContext context) {
                                      // Return a Dialog widget with a CircularProgressIndicator
                                      return Dialog(
                                        backgroundColor: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CircularProgressIndicator(
                                                backgroundColor:
                                                    Color(0xffED7D32),
                                                valueColor:
                                                    new AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
                                              SizedBox(width: 16.0),
                                              Text('Processing transaction...'),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                  String baseUrl =
                                      "${Constants.baseUrl}/voucher/";
                                  String urlPath = "topup/";
                                  String apiUrl = baseUrl + urlPath;
                                  DateTime now = DateTime.now();
                                  DateFormat formatter =
                                      DateFormat('yyyy-MM-dd');
                                  String formattedDate = formatter.format(now);

                                  Map<String, dynamic> paymentPayload = {
                                    "voucher_number": voucherController.text,
                                    "policy_ref": Constants.user_reference,
                                    "cec_client_id": Constants.cec_client_id,
                                  };
                                  // Construct the payment payload

                                  // Construct the request body
                                  Map<String, dynamic> requestBody = {
                                    "token": "kjhjguytuyghjgjhg765764tyfu",
                                    "voucher_payload": paymentPayload
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
                                      Navigator.pop(context);
                                      Fluttertoast.showToast(
                                          msg: data["message"],
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.grey,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      /*     setState(() {});
                                      var data = jsonDecode(response.body);
                                      print("dataY $data");
                                      if (data["balance"] != null) {
                                        userBalance = data["balance"];
                                        setState(() {});
                                      } else {}*/
                                    } else {
                                      var data = jsonDecode(response.body);
                                      print("data $data");
                                      //setState(() {});
                                      Navigator.of(context).pop();
                                      Fluttertoast.showToast(
                                          msg: "Error,please try again later.",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.grey,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      print(
                                          "Request failed with status: ${response.statusCode}");
                                    }

                                    // Perform your transaction logic here

                                    // Close the dialog
                                  } catch (error) {
                                    print("Error: $error");
                                    Fluttertoast.showToast(
                                        msg:
                                            "Error.please try again later.$error",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.grey,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                  getUserBalance(context);
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xffED7D32),
                                        borderRadius: BorderRadius.circular(32),
                                        border: Border.all(
                                          width: 1.2,
                                          color: Color(0xffED7D32),
                                        )),
                                    padding:
                                        EdgeInsets.only(left: 0, right: 16),
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: 45,
                                    child: Center(
                                        child: Text(
                                      "Top Up",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ))),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              if (widget.totalAmountToPay <= userBalance)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: InkWell(
                          onTap: () async {
                            /*if (userBalance > widget.totalAmountToPay) {
                              //print("hgggj");
                              for (var element
                                  in Constants.selectedPolicydetails) {
                                if (kDebugMode) {
                                  print(element.monthsToPayFor);

                                  print(element.monthlyPremium);
                                  print(element.policyNumber);
                                  print(element.status);
                                }
                                String baseUrl =
                                    "${Constants.baseUrl}/parlour/";
                                String urlPath = "makepayment/";
                                String apiUrl = baseUrl + urlPath;
                                DateTime now = DateTime.now();
                                DateFormat formatter = DateFormat('yyyy-MM-dd');
                                String formattedDate = formatter.format(now);

                                Map<String, dynamic> paymentPayload = {
                                  "status": element.status,
                                  "policy_number": element.policyNumber,
                                  "amount": element.monthlyPremium,
                                  "cec_client_id": Constants.cec_client_id,
                                  "cec_empid": Constants.cec_empid,
                                  "payment_date": formattedDate,
                                  "payment_type": "EFT",
                                  "payments": element.monthsToPayFor
                                };
                                // Construct the payment payload

                                // Construct the request body
                                Map<String, dynamic> requestBody = {
                                  "token": "kjhjguytuyghjgjhg765764tyfu",
                                  "payment_payload": paymentPayload
                                };

                                try {
                                  var response = await http.post(
                                    Uri.parse(apiUrl),
                                    body: jsonEncode(requestBody),
                                    headers: {
                                      "Content-Type": "application/json",
                                    },
                                  );

                                  if (response.statusCode == 200) {
                                    setState(() {});
                                    var data = jsonDecode(response.body);
                                    print("data $data");
                                    if (data.toString() ==
                                        "Policy Updated Successfully!") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PaymentSuccessfulScreen()));
                                    } else {}
                                  } else {
                                    var data = jsonDecode(response.body);
                                    print("data $data");
                                    //setState(() {});
                                    Navigator.of(context).pop();
                                    Fluttertoast.showToast(
                                        msg: "Error,please try again later.",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.grey,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    print(
                                        "Request failed with status: ${response.statusCode}");
                                  }
                                } catch (error) {
                                  print("Error: $error");
                                  Fluttertoast.showToast(
                                      msg:
                                          "Error.please try again later.$error",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.grey,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Insufficient balance.Please top up.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }*/
                            getUserBalance(context);
                            if (kDebugMode) {
                              print(Constants.user_reference);
                              print(Constants.cec_client_id);
                            }
                            showDialog(
                              context: context,
                              barrierDismissible:
                                  false, // Prevent dialog from closing when tapping outside
                              builder: (BuildContext context) {
                                // Return a Dialog widget with a CircularProgressIndicator
                                return Dialog(
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircularProgressIndicator(
                                          backgroundColor: Color(0xffED7D32),
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                        SizedBox(width: 16.0),
                                        Text('Processing transaction...'),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            String baseUrl = "${Constants.baseUrl}/voucher/";
                            String urlPath = "voucher_payment/";
                            String apiUrl = baseUrl + urlPath;
                            DateTime now = DateTime.now();
                            DateFormat formatter = DateFormat('yyyy-MM-dd');
                            String formattedDate = formatter.format(now);

                            Map<String, dynamic> paymentPayload = {
                              "amount": widget.totalAmountToPay,
                              "policy_ref": Constants.user_reference,
                              "cec_client_id": Constants.cec_client_id,
                            };
                            // Construct the payment payload

                            // Construct the request body
                            Map<String, dynamic> requestBody = {
                              "token": "kjhjguytuyghjgjhg765764tyfu",
                              "v_payment_payload": paymentPayload
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
                                if (mounted) setState(() {});
                                Navigator.of(context).pop();
                                //Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                makepayment();

                                Fluttertoast.showToast(
                                    msg: "Payment was successful",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                var data = jsonDecode(response.body);

                                print("dataY $data");
                                if (data["balance"] != null) {
                                  // userBalance = data["balance"];
                                  if (mounted) setState(() {});
                                }
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PaymentSuccessfulScreen()));
                              } else {
                                //var data = jsonDecode(response.body);
                                //print("data $data");
                                //setState(() {});
                                Navigator.of(context).pop();
                                Fluttertoast.showToast(
                                    msg: "Error,please try again later.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                print(
                                    "Request failed with status: ${response.statusCode}");
                              }
                              getUserBalance(context);

                              // Perform your transaction logic here

                              // Close the dialog
                            } catch (error) {
                              print("Error: $error");
                              Fluttertoast.showToast(
                                  msg: "Error.please try again later.$error",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xffED7D32),
                                  borderRadius: BorderRadius.circular(360),
                                  border: Border.all(
                                    width: 0,
                                    color: Color(0xffED7D32),
                                    // color: Colors.blueGrey[900]!,
                                  )),
                              padding: EdgeInsets.only(left: 0, right: 16),
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 45,
                              child: Center(
                                  child: Text(
                                "Submit to pay",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ))),
                        ),
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    getUserBalance(context);
    getBusinessDetails();

    super.initState();
  }

  getBusinessDetails() async {
    /*  showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dialog from closing when tapping outside
      builder: (BuildContext context) {
        // Return a Dialog widget with a CircularProgressIndicator
        return Dialog(
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  backgroundColor: Color(0xffED7D32),
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                SizedBox(width: 16.0),
                Text('Processing transaction...'),
              ],
            ),
          ),
        );
      },
    );*/

    if (kDebugMode) {
      print(Constants.user_reference);
      print(Constants.cec_client_id);
    }
    String urlPath = "/parlour/company_info/";
    String apiUrl = Constants.baseUrl + urlPath;
    DateTime now = DateTime.now();

    // Construct the request body
    Map<String, dynamic> requestBody = {
      "token": "kjhjguytuyghjgjhg765764tyfu",
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
        print("datax $data");
        //print("datax ${c.runtimeType}");

        Constants.currentBusinessInfo = BusinessInfo(
          address_1: data["address_1"] ?? "",
          address_2: data["address_2"] ?? "",
          city: data["city"] ?? "",
          province: data["province"] ?? "",
          country: data["country"] ?? "",
          area_code: data["area_code"] ?? "",
          postal_address_1: data["postal_address_1"] ?? "",
          postal_address_2: data["postal_address_2"] ?? "",
          postal_city: data["postal_city"] ?? "",
          postal_province: data["postal_province"] ?? "",
          postal_country: data["postal_country"] ?? "",
          postal_code: data["postal_code"] ?? "",
          tel_no: data["tel_no"] ?? "",
          cell_no: data["cell_no"] ?? "",
          comp_name: data["comp_name"] ?? "",
          vat_number: data["vat_number"] ?? "",
          client_fsp: data["client_fsp"] ?? "",
          logo: '',
        );
      } else {
        var data = jsonDecode(response.body);
        print("data $data");
        //setState(() {});

        print("Request failed with status: ${response.statusCode}");
      }

      // Perform your transaction logic here

      // Close the dialog
    } catch (error) {
      print("Error: $error");
    }
  }

  getUserBalance(context) async {
    /*  showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dialog from closing when tapping outside
      builder: (BuildContext context) {
        // Return a Dialog widget with a CircularProgressIndicator
        return Dialog(
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  backgroundColor: Color(0xffED7D32),
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                SizedBox(width: 16.0),
                Text('Processing transaction...'),
              ],
            ),
          ),
        );
      },
    );*/

    if (kDebugMode) {
      print(Constants.user_reference);
      print(Constants.cec_client_id);
    }
    String baseUrl = "${Constants.baseUrl}/voucher/";
    String urlPath = "user_balance/";
    String apiUrl = baseUrl + urlPath;
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    Map<String, dynamic> paymentPayload = {
      "policy_ref": Constants.user_reference,
      "cec_client_id": Constants.cec_client_id,
    };
    // Construct the payment payload

    // Construct the request body
    Map<String, dynamic> requestBody = {
      "token": "kjhjguytuyghjgjhg765764tyfu",
      "check_balance_payload": paymentPayload
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
        if (mounted) setState(() {});
        var data = jsonDecode(response.body);
        print("datax $data");
        if (data["balance"] != null) {
          userBalance = data["balance"];
          if (mounted) setState(() {});
        } else {}
      } else {
        var data = jsonDecode(response.body);
        print("data $data");
        //setState(() {});
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: "Error,please try again later.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        print("Request failed with status: ${response.statusCode}");
      }

      // Perform your transaction logic here

      // Close the dialog
    } catch (error) {
      print("Error: $error");
      Fluttertoast.showToast(
          msg: "Error.please try again later.$error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}

Future<void> makepayment() async {
  for (var element in Constants.selectedPolicydetails) {
    if (kDebugMode) {
      print(element.monthsToPayFor);

      print(element.monthlyPremium);
      print(element.policyNumber);
      print(element.status);
    }
    String baseUrl = "${Constants.baseUrl}/parlour/";
    String urlPath = "makepayment/";
    String apiUrl = baseUrl + urlPath;
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    Map<String, dynamic> paymentPayload = {
      "status": element.status,
      "policy_number": element.policyNumber,
      "amount": element.monthlyPremium,
      "cec_client_id": Constants.cec_client_id,
      "cec_empid": Constants.cec_empid,
      "payment_date": formattedDate,
      "payment_type": "Voucher",
      "payments": element.monthsToPayFor
    };
    // Construct the payment payload

    // Construct the request body
    Map<String, dynamic> requestBody = {
      "token": "kjhjguytuyghjgjhg765764tyfu",
      "payment_payload": paymentPayload
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
      Future.delayed(Duration(seconds: 2), () {
        if (response.statusCode == 200) {
          //Constants.selectedPolicydetails = [];

          var data = jsonDecode(response.body);
          print("data $data");
          if (data.toString() == "Policy Updated Successfully!") {
          } else {}
        } else {
          var data = jsonDecode(response.body);
          print("data $data");
          //setState(() {});

          Fluttertoast.showToast(
              msg: "Error,please try again later.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
          print("Request failed with status: ${response.statusCode}");
        }
      });
      // Perform your transaction logic here

      // Close the dialog
    } catch (error) {
      print("Error: $error");
      Fluttertoast.showToast(
          msg: "Error.please try again later.$error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
