import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../constants/Constants.dart';
import '../../models/BusinessInfo.dart';
import '../../models/PaymentHistoryItem.dart';
import '../../models/PolicyDetails.dart';
import '../../services/MyNoyifier.dart';
import '../PaymentHistoryPage.dart';
import 'PayithVoucherScreen.dart';

String msgtx = "No Items found";
double totalAmount = 0;
List<PolicyDetails> policydetails = [];
TextEditingController employeeidController = TextEditingController();
TextEditingController policynumberController = TextEditingController();
final myValue = ValueNotifier<int>(0);
MyNotifier? myNotifier;

class policyresults extends StatefulWidget {
  final String employeeuid;
  final String policynumber;
  const policyresults(
      {Key? key, required this.employeeuid, required this.policynumber})
      : super(key: key);

  @override
  State<policyresults> createState() => _policyresultsState();
}

class _policyresultsState extends State<policyresults> {
  bool isLoaded = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
            "Premiums",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            /*      Row(
              children: [
                */ /*Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Icon(
                    Icons.skip_previous_outlined,
                    size: 38,
                  ),
                ),*/ /*
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
            ),*/

            (policydetails.length > 1)
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16, top: 8, bottom: 8),
                    child: Text(
                      "${policydetails.length} Policies Found, Scroll to See More",
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  )
                : Container(),
            (policydetails.length == 1)
                ? Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 16, top: 12),
                    child: Row(
                      children: [
                        Text(
                          "1 Policy Found",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                : Container(),
            Expanded(
              child: isLoaded == true
                  ? policydetails.length == 0
                      ? Center(
                          child: Text(msgtx),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: policydetails.length,
                          itemBuilder: (context, index) {
                            return PolicyCard(index: index);
                          })
                  : Column(
                      children: [
                        Spacer(),
                        Center(
                          child: Container(
                              width: 40,
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.blueGrey),
                                backgroundColor: Constants.ctaColorLight,
                              )),
                        ),
                        Spacer(),
                      ],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          "Total Amount : R${totalAmount.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      /*if (totalAmount > 0)
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Text(
                            "(choose payment method)",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),*/
                      if (totalAmount > 0)
                        SizedBox(
                          height: 8,
                        ),
                      if (totalAmount > 0)
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Constants.paymentmethod = "Voucher";
                                    if (totalAmount <= 0) {
                                      Fluttertoast.showToast(
                                          msg: "Please select a policy",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.grey,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PayithVoucherScreen(
                                                    employeeuid:
                                                        employeeidController
                                                            .text
                                                            .toUpperCase(),
                                                    policynumber:
                                                        policynumberController
                                                            .text
                                                            .toUpperCase(),
                                                    totalAmountToPay:
                                                        totalAmount,
                                                  )));
                                    }
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Constants.ctaColorLight,
                                          borderRadius:
                                              BorderRadius.circular(360),
                                          border: Border.all(
                                            width: 1.2,
                                            color: Constants.ctaColorLight,
                                          )),
                                      padding:
                                          EdgeInsets.only(left: 0, right: 0),
                                      width: MediaQuery.of(context).size.width,
                                      height: 35,
                                      child: Center(
                                          child: Text(
                                        "VOUCHER",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ))),
                                ),
                              ),
                            ),
                            /*Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () async {
                                    Constants.paymentmethod = "Card";
                                    */ /*    SlipDetails policy = SlipDetails(
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

                                  final pdfPath = (await recieptpdf()
                                          .generatePDFSlip2(policy))
                                      .path;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PDFViewerScreen(
                                        pdfPath: pdfPath,
                                      ),
                                    ),
                                  );*/ /*
                                    //launchIntent(context);
                                    getBusinessDetails();
                                    //openIntent2(context);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Constants.ctaColorLight,
                                          borderRadius:
                                              BorderRadius.circular(360),
                                          border: Border.all(
                                            width: 1.2,
                                            color: Constants.ctaColorLight,
                                          )),
                                      padding:
                                          EdgeInsets.only(left: 0, right: 0),
                                      width: MediaQuery.of(context).size.width,
                                      height: 35,
                                      child: Center(
                                          child: Text(
                                        "CARD",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ))),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () async {
                                    String paymentStatus = "";
                                    Constants.paymentmethod = "Cash";
                                    Constants.transaction_id =
                                        generateRandomDigits(14);

                                    // Show initial dialog to verify cash payment
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context1) {
                                        return CashPaymentDialog(
                                          title: "Cash Payment",
                                          message:
                                              "Please verify that the client has paid a cash amount of R${totalAmount.toStringAsFixed(2)} to proceed, if not please click Cancel.",
                                          buttonColor: Constants.ctaColorLight,
                                          selectedPolicydetails:
                                              Constants.selectedPolicydetails,
                                          onVerified: () async {
                                            // Show processing dialog
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  backgroundColor: Colors.white,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        CircularProgressIndicator(
                                                          backgroundColor:
                                                              Constants
                                                                  .ctaColorLight,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  Colors.white),
                                                        ),
                                                        SizedBox(width: 16.0),
                                                        Text(
                                                            'Processing transaction...'),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );

                                            // Check and set CEC client ID
                                            dynamic cecClientId =
                                                await HelperFunctions
                                                    .getPreference(
                                                        "cec_client_id_key");
                                            if (cecClientId != null &&
                                                Constants.cec_client_id ==
                                                    int.parse(cecClientId)) {
                                              print(
                                                  "CEC Client ID: $cecClientId");
                                            } else {
                                              print(
                                                  "CEC Client ID is not set.");
                                              HelperFunctions.savePreference(
                                                  "cec_client_id_key",
                                                  Constants.cec_client_id);
                                            }

                                            // Process each policy
                                            bool isTransactionsSuccessful =
                                                true; // Assume success unless an error occurs
                                            int totalSelectedPolicies =
                                                Constants.selectedPolicydetails
                                                    .length;

                                            for (int i = 0;
                                                i < totalSelectedPolicies;
                                                i++) {
                                              var element = Constants
                                                  .selectedPolicydetails[i];
                                              print(
                                                  "Processing policy ${i + 1}/${totalSelectedPolicies}: ${element.policyNumber}");

                                              String baseUrl =
                                                  "${Constants.baseUrl}/parlour/";
                                              String urlPath =
                                                  "pos_makepayment/";
                                              String apiUrl = baseUrl + urlPath;
                                              DateTime now = DateTime.now();
                                              DateFormat formatter =
                                                  DateFormat('yyyy-MM-dd');
                                              String formattedDate =
                                                  formatter.format(now);

                                              Map<String, dynamic>
                                                  paymentPayload = {
                                                "status": element.status,
                                                "policy_number":
                                                    element.policyNumber,
                                                "amount":
                                                    element.monthlyPremium,
                                                "cec_client_id":
                                                    Constants.cec_client_id,
                                                "cec_empid":
                                                    Constants.cec_empid,
                                                "payment_date": formattedDate,
                                                "payment_type": "Cash",
                                                "pos_transaction_id":
                                                    Constants.transaction_id,
                                                "pos_device_id":
                                                    Constants.device_id,
                                                "payments":
                                                    element.monthsToPayFor
                                              };

                                              Map<String, dynamic> requestBody =
                                                  {
                                                "token":
                                                    "kjhjguytuyghjgjhg765764tyfu",
                                                "payment_payload":
                                                    paymentPayload
                                              };

                                              try {
                                                var response = await http.post(
                                                  Uri.parse(apiUrl),
                                                  body: jsonEncode(requestBody),
                                                  headers: {
                                                    "Content-Type":
                                                        "application/json",
                                                  },
                                                );
                                                print(
                                                    "processing policy ${baseUrl} ${element.policyNumber}: ${response.body}");

                                                if (response.statusCode ==
                                                    200) {
                                                  var jsonResponse =
                                                      jsonDecode(response.body);
                                                  Constants
                                                      .monthsPaidForList = List<
                                                          Map<String,
                                                              dynamic>>.from(
                                                      jsonResponse[
                                                          "months_paid_for"]);

                                                  if (jsonResponse[
                                                          "response"] !=
                                                      "Policy Updated Successfully!") {
                                                    isTransactionsSuccessful =
                                                        false;
                                                  }
                                                } else {
                                                  isTransactionsSuccessful =
                                                      false; // Mark transaction as unsuccessful if response code is not 200
                                                  print(
                                                      "response ${response.body}");
                                                }
                                              } catch (error) {
                                                isTransactionsSuccessful =
                                                    false; // Mark transaction as unsuccessful if an error occurs
                                              }
                                            }

                                            // Navigate based on the payment status
                                            Navigator.of(context)
                                                .pop(); // Close processing dialog
                                            if (isTransactionsSuccessful) {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PaymentSuccessfulScreen()),
                                              );
                                            } else {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PaymentErrorScreen()),
                                              );
                                            }
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Constants.ctaColorLight,
                                      borderRadius: BorderRadius.circular(360),
                                      border: Border.all(
                                        width: 1.2,
                                        color: Constants.ctaColorLight,
                                      ),
                                    ),
                                    padding: EdgeInsets.only(left: 0, right: 0),
                                    width: MediaQuery.of(context).size.width,
                                    height: 35,
                                    child: Center(
                                      child: Text(
                                        "CASH",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),*/
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    policydetails = [];
    totalAmount = 0;

    // getPolicyInfo2("ATH10003", "8706165365085", "kjhjguytuyghjgjhg765764tyfu");
/*    if (kDebugMode) {
      Constants.baseUrl = "https://miinsightsapps.net/apibus/api";
      getPolicyInfo2("ATH10003", "ATS252", "kjhjguytuyghjgjhg765764tyfu");
      print(
          "employeeidController.text.toUpperCase() ${employeeidController.text.toUpperCase()}");

      print("live policynumber ${policynumberController.text.toUpperCase()}");
    } else {*/
    getPolicyInfo2(
        employeeidController.text.toUpperCase(),
        policynumberController.text.toUpperCase(),
        "kjhjguytuyghjgjhg765764tyfu");
    // }
    myValue.addListener(() {
      if (kDebugMode) {
        print("listening to ghjjhjhj");
      }
      if (mounted) {
        setState(() {});
      }
    });
    employeeidController.text = "";
    policynumberController.text = "";
    if (mounted) {
      setState(() {});
    }

    super.initState();
  }

  void getPolicyInfo(String empNum, String searchVal, String token) async {
    Constants.selectedPolicydetails = [];
    String urlPath = "/parlour/getpolicyinfo/";
    String apiUrl = Constants.baseUrl + urlPath;

    Map<String, dynamic> requestBody = {
      "empNum": empNum,
      "searchVal": searchVal,
      "token": token,
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
        isLoaded = true;
        myValue.value++;
        setState(() {});
        var data = jsonDecode(response.body);

        if (data["success"] == false) {
          msgtx = data["message"];
          setState(() {});
        } else {
          List dataList = data["message"];

          dataList.forEach((element) {
            List<dynamic> additional_members =
                element["Lead"][0]["additional_members"];
            for (var element1 in additional_members) {
              if (element1["member_type"] == "main_member") {
                Constants.customer_id_number = element1["id"];
                Constants.customer_first_name = element1["name"];
                Constants.customer_last_name = element1["surname"];
              }
            }

            String paymentStatus = element["paymentStatus"];
            print("paymentStatus $paymentStatus");
            Constants.cec_empid = element["querying_emp_id"];
            Constants.user_reference =
                element["Lead"][0]["policy"][0]["reference"].toString();
            print("user_reference1 ${Constants.user_reference}");
            Constants.cec_client_id =
                element["Lead"][0]["lead"]["cec_client_id"];

            Constants.cell_number = element["Lead"][0]["lead"]["cell_number"];
            List<dynamic> lst2 = element["Lead"];
            lst2.forEach((element) {
              Map mxcf = element as Map;
              String plantype = mxcf["policy"][0]["qoute"]["product_type"];
              String policynumber = mxcf["policy"][0]["qoute"]["policy_number"];
              String status = mxcf["policy"][0]["qoute"]["status"];
              double totalAmountPayable =
                  mxcf["policy"][0]["qoute"]["totalAmountPayable"];
              String inceptionDate =
                  mxcf["policy"][0]["qoute"]["inceptionDate"];
              String inforce_date = mxcf["policy"][0]["qoute"]["inforce_date"];
              double sumAssuredFamilyCover =
                  mxcf["policy"][0]["qoute"]["sumAssuredFamilyCover"];
              Constants.cec_empname = data["message"][0]["querying_emp_name"];
              Constants.cec_logo = data["message"][0]["logo"];
              if (kDebugMode) {
                print(paymentStatus);

                print("plantype $plantype");
                print("cec_client_id ${Constants.cec_client_id}");
                print("cell_number ${Constants.cell_number}");
                print("customer_id_number ${Constants.customer_id_number}");
                print(
                    "cec_empid ${data["message"][0]["querying_emp_id"].runtimeType} ${data["message"][0]["querying_emp_id"]}");

                print(
                    "cec_emp_name ${data["message"][0]["querying_emp_name"].runtimeType} ${data["message"][0]["querying_emp_name"]}");
                print(
                    "cec_logo ${data["message"][0]["logo"].runtimeType} ${data["message"][0]["logo"]}");
                print("policynumber $policynumber");
                print("status $status");
                print("totalAmountPayable $totalAmountPayable");
                print("inceptionDate $inceptionDate");
                print("inforce_date $inforce_date");
                print("sumAssuredFamilyCover $sumAssuredFamilyCover");
                print(data);
                print(data["message"][0]["Lead"][0]["policy"][0]["qoute"]);
              }
              /*policydetails.add(PolicyDetails(
                  policyNumber: policynumber,/./
                  status: status,
                  monthsToPayFor: 1,
                  paymentStatus: paymentStatus,
                  paymentsBehind: 2,
                  monthlyPremium: totalAmountPayable,
                  benefitAmount: sumAssuredFamilyCover,
                  inceptionDate: inceptionDate,
                  acceptTerms: false));*/
              /* policydetails.add(PolicyDetails(
                policyNumber: policynumber,
                planType: plantype,
                status: status,
                monthsToPayFor: 1,
                paymentStatus: paymentStatus,
                paymentsBehind: 2,
                monthlyPremium: totalAmountPayable,
                benefitAmount: sumAssuredFamilyCover,
                acceptTerms: false));*/
              Future.delayed(Duration(milliseconds: 100)).then((value) {
                myValue.value++;
              });
              setState(() {});
            });
          });
        }
        //Constants.client_previous_transactions = data;
        String paymentStatus = data["message"][0]["paymentStatus"];
        Constants.cec_empid = data["message"][0]["querying_emp_id"];
        Constants.user_reference =
            data["message"][0]["Lead"][0]["policy"][0]["reference"].toString();
        print("user_reference ${Constants.user_reference}");
        Constants.cec_client_id =
            data["message"][0]["Lead"][0]["lead"]["cec_client_id"];
      } else {
        isLoaded = true;
        myValue.value++;
        setState(() {});
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  Future<void> getPolicyInfo2(
      String empNum, String searchVal, String token) async {
    Constants.selectedPolicydetails = [];
    String urlPath = "/parlour/getpolicyinfo/";
    String apiUrl = Constants.baseUrl + urlPath;
    Constants.queryingEmployee = empNum;

    Map<String, dynamic> requestBody = {
      // "empNum": empNum,
      "empNum": "ATH10003",
      "searchVal": "MCG0006",
      //"searchVal": searchVal,
      "token": token,
    };
    var response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode(requestBody),
      headers: {
        "Content-Type": "application/json",
      },
    );
    print(response.statusCode);
    print(Constants.baseUrl);
    print(requestBody);
    if (response.statusCode == 200) {
      isLoaded = true;
      myValue.value++;
      setState(() {});
      var data = jsonDecode(response.body);

      if (data["success"] == false) {
        msgtx = data["message"];

        setState(() {});
      } else {
        List dataList = data['message'];
        print(dataList);
        Constants.cec_empname = data["message"][0]["querying_emp_name"];
        Constants.cec_logo = data["message"][0]["logo"];
        if (kDebugMode) {
          print("cec_empname ${Constants.cec_empname}");
          print("cec_logo ${Constants.cec_logo}");
        }
        //940806 4258086
        for (var element in dataList) {
          processElement(element);
        }
      }
    }
  }

  void processElement(dynamic element) {
    try {
      print("leadff $element");
      List<dynamic> leads = element['Lead'] ?? [];
      print("leads $leads");
      Constants.cec_client_id =
          element["Lead"][0]["lead"]["cec_client_id"] ?? 0;

      for (var lead in leads) {
        print("lead $lead");
        List<dynamic> policies = lead['policy'];
        print("policies $policies");

        for (var policy in policies) {
          print("policy $policy");
          String main_member_id = "";
          String main_member_name = "";
          String main_member_surname = "";
          String customer_contact = "";
          List<dynamic> additional_members = lead['additional_members'];
          print("additional_members $additional_members");
          for (var member in additional_members) {
            if (member['member_type'] == 'main_member') {
              if (kDebugMode) {
                print("member0 " + member.toString());
                print("reference0 " + policy["reference"].toString());
              }

              main_member_id = (member["id"]).toString();
              main_member_name = (member["name"]).toString();
              customer_contact = (member["contact"]).toString();

              main_member_surname = member["surname"];
            }
          }

          Constants.cec_empid = element["querying_emp_id"] ?? 0;
          print("empid2 " + (element["querying_emp_id"]).toString());

          processPolicy(policy, element['paymentStatus'] ?? "", main_member_id,
              main_member_name, main_member_surname, customer_contact);

          /*    if (employeeidController.text.toUpperCase() ==
              main_member_id.toUpperCase()) {
            processPolicy(policy, element['paymentStatus'], main_member_id,
                main_member_name, main_member_surname);
          }
          else if (employeeidController.text.toUpperCase() ==
              policy["reference"]) {

          }*/
        }
      }
    } catch (e) {
      print('Error processing element: $e');
    }
  }

  void processPolicy(
    dynamic policy,
    String paymentStatus,
    String main_member_id,
    String main_member_name,
    String main_member_surname,
    String customer_contact,
  ) {
    try {
      Map mxcf = policy['qoute'];

      String plantype = mxcf['product_type'];
      String policynumber = mxcf["policy_number"];
      String status = mxcf["status"];
      double totalAmountPayable = mxcf["totalAmountPayable"];
      String inceptionDate = mxcf["inceptionDate"];
      String inforce_date = mxcf["inforce_date"];
      double sumAssuredFamilyCover = mxcf["sumAssuredFamilyCover"] ?? 0;
      if (kDebugMode) {
        print("policy $policynumber main_member_name $main_member_name");
      }
      policydetails.add(PolicyDetails(
        policyNumber: policynumber,
        planType: plantype,
        status: status,
        monthsToPayFor: 1,
        paymentStatus: paymentStatus,
        paymentsBehind: 0,
        monthlyPremium: totalAmountPayable,
        benefitAmount: sumAssuredFamilyCover,
        acceptTerms: false,
        customer_id_number: main_member_id,
        customer_first_name: main_member_name,
        customer_last_name: main_member_surname,
        customer_contact: customer_contact,
        inceptionDate: inceptionDate,
        inforce_date: '',
      ));

      Future.delayed(Duration(milliseconds: 100)).then((value) {
        // Your code to be executed after the delay
      });
    } catch (e) {
      print('Error processing policy: $e');
    }
  }

  void onMonthSelected(int index, int selectedMonth) {
    setState(() {
      policydetails[index].monthsToPayFor = selectedMonth;

      if (policydetails[index].acceptTerms) {
        if (!Constants.selectedPolicydetails.contains(policydetails[index])) {
          //  Constants.selectedPolicydetails.add(policydetails[index]);
        }
      } else {
        Constants.selectedPolicydetails.remove(policydetails[index]);
      }

      totalAmount = 0;
      for (var element in Constants.selectedPolicydetails) {
        totalAmount += element.monthlyPremium * element.monthsToPayFor;
      }
    });
  }

  List<Map<String, dynamic>> convertpaymentHistoryMapList(
      List<PaymentHistoryItem> paymentsList1) {
    return paymentsList1
        .map((paymentItem) => paymentItem.toJson() as Map<String, dynamic>)
        .toList();
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
                  backgroundColor: Constants.ctaColorLight,
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

    print(Constants.cec_client_id);

    String baseUrl = "${Constants.baseUrl}";
    String urlPath = "/parlour/company_info/";
    String apiUrl = baseUrl + urlPath;
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
        print("dataxgjj $data");
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
}

class PolicyCard extends StatefulWidget {
  final int index;
  const PolicyCard({super.key, required this.index});

  @override
  State<PolicyCard> createState() => _PolicyCardState();
}

class _PolicyCardState extends State<PolicyCard> {
  int _selectedMonth = 1;
  late PolicyDetails policydetails1;
  @override
  Widget build(BuildContext context) {
    void _toggleAcceptTerms(bool? value) {
      setState(() {
        policydetails1.acceptTerms = value!;
        if (value == true) {
          totalAmount = totalAmount +
              policydetails1.monthlyPremium * policydetails1.monthsToPayFor;
          print("totalAmount $totalAmount");
          myValue.value++;
        } else {
          totalAmount = totalAmount -
              policydetails1.monthlyPremium * policydetails1.monthsToPayFor;
          myValue.value++;
        }
      });
    }

    void _toggleAcceptTerms1(bool? value) {
      setState(() {
        policydetails1.acceptTerms = value!;
        //policydetails[index].monthsToPayFor = selectedMonth;

        if (policydetails[widget.index].acceptTerms) {
          if (!Constants.selectedPolicydetails
              .contains(policydetails[widget.index])) {
            //  Constants.selectedPolicydetails.add(policydetails[widget.index]);
          }
        } else {
          Constants.selectedPolicydetails.remove(policydetails[widget.index]);
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

    /*   totalAmount = 0;
                      for (var element in policydetails) {
                        if (element.acceptTerms == true) {
                          totalAmount = totalAmount + element.monthlyPremium;
                          print("totalAmount $totalAmount");
                          myValue.value++;
                        } else {
                          totalAmount = totalAmount - element.monthlyPremium;
                          myValue.value++;
                        }
                      }*/

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        elevation: 5,
        surfaceTintColor: Colors.white,
        color: Colors.white,
        /*decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                width: 1.2,
                                color: Colors.grey.withOpacity(0.55),
                              ),

                          ),*/
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  children: [
                    Text(
                      "Policy # : ${policydetails[widget.index].policyNumber}",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(
                    top: 4.0,
                    left: 0,
                    right: 0,
                  ),
                  height: 1,
                  color: Colors.grey.withOpacity(0.15)),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Main Member",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Text(
                      ":",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    policydetails[widget.index].customer_first_name,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Plan Type",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Text(
                      ":",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    policydetails[widget.index].planType,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Status",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Text(
                      ":",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    policydetails[widget.index].status,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Premium Amount",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Text(
                      ":",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                            decoration: BoxDecoration(
                                color: Constants.ctaColorLight,
                                borderRadius: BorderRadius.circular(360),
                                border: Border.all(
                                  width: 1.2,
                                  color: Constants.ctaColorLight,
                                )),
                            padding: EdgeInsets.only(left: 0, right: 16),
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                "R " +
                                    policydetails[widget.index]
                                        .monthlyPremium
                                        .toString() +
                                    " p.m",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ))),
                      ),
                    ),
                  ),
                  /*Expanded(
                                        child: Text(
                                      "R${policydetails[index].monthlyPremium.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Constants.ctaColorLight,
                                      ),
                                    )),*/
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Payment Status",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Text(
                      ":",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    policydetails[widget.index].paymentStatus,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Benefit Amount",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Text(
                      ":",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    "R${policydetails[widget.index].benefitAmount.toStringAsFixed(2)}",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "# of Payments ",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Text(
                      ":",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(left: 0),
                    height: 35,
                    decoration: BoxDecoration(
                      color: Constants.ctaColorLight,
                      borderRadius: BorderRadius.circular(360.0),
                    ),
                    child: DropdownButton<int>(
                      value: _selectedMonth,
                      icon: Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      underline: Container(),
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedMonth = newValue!;
                          // onMonthSelected(index,);
                        });
                        policydetails[widget.index].monthsToPayFor = newValue!;

                        if (policydetails[widget.index].acceptTerms) {
                          if (!Constants.selectedPolicydetails
                              .contains(policydetails[widget.index])) {
                            /* Constants.selectedPolicydetails
                                .add(policydetails[widget.index]);*/
                          }
                        } else {
                          Constants.selectedPolicydetails
                              .remove(policydetails[widget.index]);
                        }

                        totalAmount = 0;
                        for (var element in Constants.selectedPolicydetails) {
                          if (element.acceptTerms == true) {
                            totalAmount +=
                                element.monthlyPremium * element.monthsToPayFor;
                            myValue.value++;
                          }
                        }
                      },
                      items: List<DropdownMenuItem<int>>.generate(12, (index) {
                        return DropdownMenuItem<int>(
                          value: index + 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text((index + 1).toString()),
                          ),
                        );
                      }),
                    ),
                  )),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaymentHistoryPage(
                                            policiynumber:
                                                policydetails[widget.index]
                                                    .policyNumber,
                                            planType:
                                                policydetails[widget.index]
                                                    .planType,
                                            status: policydetails[widget.index]
                                                .status,
                                          )));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(360),
                                  border: Border.all(
                                    width: 1.2,
                                    color: Constants.ctaColorLight,
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  "Payments",
                                  style: TextStyle(
                                      color: Constants.ctaColorLight,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  (policydetails[widget.index].status.toLowerCase() !=
                          "inforced")
                      ? Container()
                      : Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Text("Click Here to Pay"),
                              Transform.scale(
                                scale: 1.6,
                                child: Checkbox(
                                  activeColor: Constants.ctaColorLight,
                                  checkColor: Colors.white,
                                  value: policydetails1.acceptTerms,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(36.0),
                                    ),
                                  ),
                                  onChanged: _toggleAcceptTerms1,
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  initState() {
    print("---- reloding ${widget.index}");
    super.initState();
    policydetails1 = policydetails[widget.index];
    _selectedMonth = policydetails1.monthsToPayFor;
    setState(() {});
  }
}

String generateRandomDigits(int length) {
  Random random = Random();
  String result = '';

  for (int i = 0; i < length; i++) {
    result += random.nextInt(10).toString();
  }

  return result;
}
