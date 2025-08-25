import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mi_insights/services/inactivitylogoutmixin.dart';

import '../admin/ClientSearchPage.dart';
import '../constants/Constants.dart';
import '../models/PolicyDetails.dart';
import '../services/MyNoyifier.dart';
import '../services/window_manager.dart';
import 'PaymentHistoryPage.dart';

TextEditingController _searchContoller = TextEditingController();
bool _isLoading = false;
bool isLoaded = false;
String msgtx = "No Items found";
List<PolicyDetails> policydetails = [];
final myValue = ValueNotifier<int>(0);
double totalAmount = 0;
MyNotifier? myNotifier;

class PolicyInformation extends StatefulWidget {
  const PolicyInformation({super.key});
  @override
  State<PolicyInformation> createState() => _PolicyInformationState();
}

TextEditingController policy_search_controller = TextEditingController();
FocusNode policy_search_focus_node = FocusNode();

class _PolicyInformationState extends State<PolicyInformation>
    with InactivityLogoutMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
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
                                      ClientSearchPage(
                                          onClientSelected: (val) {}),
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
            shadowColor: Colors.black.withOpacity(0.3),
            elevation: 6,
            leading: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            //backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
              "Policy Information",
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w500,
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
                height: 16,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 4, bottom: 4),
                        child: Container(
                          height: 40,
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
                                      restartInactivityTimer();

                                      setState(() {});
                                      getPolicyInfo2(
                                          _searchContoller.text.toUpperCase(),
                                          "kjhjguytuyghjgjhg765764tyfu");
                                    },
                                    child: Container(
                                      height: 35,
                                      width: 70,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0.0, bottom: 0.0, right: 0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Constants.ctaColorLight,
                                              borderRadius:
                                                  BorderRadius.circular(360)),
                                          child: Center(
                                            child: Text(
                                              "Search",
                                              style: TextStyle(
                                                  color: Colors.white),
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
                                  fillColor: Colors.grey.withOpacity(0.09),
                                  contentPadding: EdgeInsets.only(left: 24),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.0)),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.0)),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                controller: _searchContoller,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              (policydetails.length > 1)
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 0.0, right: 16, top: 8, bottom: 8),
                      child: Center(
                        child: Text(
                          "${policydetails.length} Policies Found, Scroll to See More",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  : Container(),
              (policydetails.length == 1)
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 0.0, right: 16, top: 12),
                      child: Center(
                        child: Text(
                          "1 Policy Found",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  : Container(),
              Expanded(
                child: isLoaded == false
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SvgPicture.asset(
                                  "assets/icons/maintanence_report.svg",
                                  width: 120,
                                  height: 120,
                                  color: Colors.grey.withOpacity(0.35),
                                ),
                              ),
                              Text(
                                "Enter a policy number and press Search to get started",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 55,
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      )
                    : _isLoading == false
                        ? policydetails.length == 0
                            ? Center(
                                child: Text(msgtx),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: policydetails.length,
                                itemBuilder: (context, index) {
                                  PolicyDetails policydetails1 =
                                      policydetails[index];

                                  void _toggleAcceptTerms(bool? value) {
                                    setState(() {
                                      policydetails1.acceptTerms = value!;
                                      if (value == true) {
                                        totalAmount = totalAmount +
                                            policydetails1.monthlyPremium *
                                                policydetails1.monthsToPayFor;
                                        print("totalAmount $totalAmount");
                                        myValue.value++;
                                      } else {
                                        totalAmount = totalAmount -
                                            policydetails1.monthlyPremium *
                                                policydetails1.monthsToPayFor;
                                        myValue.value++;
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
                                      color: Colors.white,
                                      surfaceTintColor: Colors.white,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 12.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Policy # : ${policydetails[index].policyNumber}",
                                                    style: TextStyle(
                                                        fontSize: 19,
                                                        fontWeight:
                                                            FontWeight.w500),
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
                                                color: Colors.grey
                                                    .withOpacity(0.15)),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                  "Main Member",
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
                                                  policydetails[index]
                                                      .customer_first_name,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
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
                                                  policydetails[index].planType,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
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
                                                  "Inception Date",
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
                                                  DateFormat('EEE, dd MMM yyyy')
                                                      .format(DateTime.parse(
                                                          policydetails[index]
                                                              .inceptionDate)),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
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
                                                  "Inforce Date",
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
                                                  DateFormat('EEE, dd MMM yyyy')
                                                      .format(DateTime.parse(
                                                          policydetails[index]
                                                              .inforce_date)),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
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
                                                  policydetails[index].status,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
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
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: InkWell(
                                                      onTap: () {},
                                                      child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Constants
                                                                      .ctaColorLight,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              360),
                                                                  border: Border
                                                                      .all(
                                                                    width: 1.2,
                                                                    color: Constants
                                                                        .ctaColorLight,
                                                                  )),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 0,
                                                                  right: 16),
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: Center(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            child: Text(
                                                              "R " +
                                                                  policydetails[
                                                                          index]
                                                                      .monthlyPremium
                                                                      .toString() +
                                                                  " p.m",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .white),
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
                                          color: Color(0xffED7D32),
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
                                                  policydetails[index]
                                                      .paymentStatus,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
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
                                                  "R${policydetails[index].benefitAmount.toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PaymentHistoryPage(
                                                                    policiynumber:
                                                                        policydetails[index]
                                                                            .policyNumber,
                                                                    planType: policydetails[
                                                                            index]
                                                                        .planType,
                                                                    status: policydetails[
                                                                            index]
                                                                        .status,
                                                                  )));
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      360),
                                                          border: Border.all(
                                                            width: 1.2,
                                                            color: Constants
                                                                .ctaColorLight,
                                                          )),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Center(
                                                          child: Text(
                                                            "Payment Management",
                                                            style: TextStyle(
                                                                color: Constants
                                                                    .ctaColorLight,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                })
                        : Column(
                            children: [
                              Spacer(),
                              Center(
                                child: Container(
                                    width: 40,
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.blueGrey),
                                      backgroundColor: Constants.ctaColorLight,
                                    )),
                              ),
                              Spacer(),
                            ],
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getPolicyInfo2(String searchVal, String token) async {
    _isLoading = true;
    isLoaded = true;
    setState(() {});
    restartInactivityTimer();
    Constants.selectedPolicydetails = [];
    policydetails = [];

    String urlPath = "onoloV6/getPoliciesMain";
    String apiUrl =
        "${Constants.baseUrl2}$urlPath?searchKey=$searchVal&cec_client_id=${Constants.cec_client_id}";

    if (kDebugMode) {
      print("cec_empid ${Constants.cec_employeeid}");
      print("apiUrl $apiUrl");
    }

    var headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      'Cookie':
          'userid=expiry=2024-10-04&client_modules=1001#1002#1003#1004#1005#1006#1007#1008#1009#1010#1011#1012#1013#1014#1015#1017#1018#1020#1021#1022#1024#1025#1026#1027#1028#1029#1030#1031#1032#1033#1034#1035&clientid=379&empid=9819&empfirstname=MI Insights&emplastname=Support&email=Master@everestmpu.com&username=Master@everestmpu.com&dob=7/7/1990 12:00:00 AM&fullname=MI Insights Support&userRole=184&userImage=Master@everestmpu.com.jpg&employedAt=head office 1&role=leader&branchid=379&jobtitle=Policy Administrator / Agent&dialing_strategy=&clientname=Everest Financial Services&foldername=&client_abbr=EV&pbx_account=&device_id=Error retrieving Instance ID token.&servername=http://localhost:55661'
    };

    var request = http.Request('GET', Uri.parse(apiUrl));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      restartInactivityTimer();
      isLoaded = true;
      myValue.value++;
      setState(() {});

      try {
        var data = jsonDecode(responseBody);

        // Ensure data is a List
        if (data is List && data.isNotEmpty) {
          print(data); // Print the list of policies

          for (var element in data) {
            print(element.runtimeType);
            if (element != null && element is Map<String, dynamic>) {
              processElement2(element);
            } else {
              print(
                  "Error processing element: $element is not a valid policy object.");
            }
          }
          _isLoading = false;
          isLoaded = true;
        } else {
          // Handle case when data is not a list or is empty
          msgtx = "No policies found or invalid response format.";
          _isLoading = false;
          isLoaded = false;
          setState(() {});
        }
      } catch (e) {
        // Handle JSON parsing or other unexpected issues
        print("Error parsing response: $e");
        msgtx = "Error processing response.";
        _isLoading = false;
        isLoaded = false;
        setState(() {});
      }
    } else {
      print(response.reasonPhrase);
      _isLoading = false;
      isLoaded = false;
    }

    setState(() {});
  }

  void processElement2(dynamic element) {
    try {
      // Extract the relevant fields directly from the element
      String main_member_id = element['customer_id_number'] ?? "";
      String main_member_name = element['first_name'] ?? "";
      String main_member_surname = element['last_name'] ?? "";
      String customer_contact = element['cell_number'] ?? "";
      String policy_reference = element['reference'] ?? "";
      String policy_number = element['policy_number'] ?? "";
      String product_type = element['product_type'] ?? "";
      String paymentStatus = element['quote_status'] ??
          ""; // Assuming 'quote_status' represents the payment status

      // Print for debugging purposes
      if (kDebugMode) {
        print("Processing policy: $policy_number");
        print("Main member: $main_member_name $main_member_surname");
      }

      // Update Constants or other elements based on the data
      Constants.cec_empid = element["assigned_to"] ?? "";

      // Extract the policy details
      String plantype = element['product_type'] ?? "";
      String policynumber = element["policy_number"] ?? "";
      String status = element["quote_status"] ?? "";
      double totalAmountPayable =
          (element["totalAmountPayable"] ?? 0).toDouble();
      String inceptionDate = element["inceptionDate"] ?? "";
      String inforce_date = element["inforce_date"] ?? "";
      double sumAssuredFamilyCover =
          (element["sumAssuredFamilyCover"] ?? 0).toDouble();

      if (kDebugMode) {
        print("policy $policynumber main_member_name $main_member_name");
      }

      // Add the extracted details to policydetails
      policydetails.add(PolicyDetails(
        policyNumber: policynumber,
        planType: plantype,
        status: status,
        monthsToPayFor: 1, // You can adjust this based on your data
        paymentStatus: paymentStatus,
        paymentsBehind: 0, // Assuming no payments are behind; adjust if needed
        monthlyPremium: totalAmountPayable,
        benefitAmount: sumAssuredFamilyCover,
        inforce_date: inforce_date,
        acceptTerms: false,
        customer_id_number: main_member_id,
        customer_first_name: main_member_name,
        customer_last_name: main_member_surname,
        customer_contact: customer_contact,
        inceptionDate: inceptionDate,
      ));
    } catch (e) {
      print('Error processing element: $e');
    }
  }

  @override
  void initState() {
    restartInactivityTimer();
    secureScreen();
    policydetails = [];
    isLoaded = false;
    _isLoading == false;
    _searchContoller.text = "";
    setState(() {});
    super.initState();
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
      double sumAssuredFamilyCover = mxcf["sumAssuredFamilyCover"];
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
        inforce_date: inforce_date,
        acceptTerms: false,
        customer_id_number: main_member_id,
        customer_first_name: main_member_name,
        customer_last_name: main_member_surname,
        customer_contact: customer_contact,
        inceptionDate: inceptionDate,
      ));

      Future.delayed(Duration(milliseconds: 100)).then((value) {
        // Your code to be executed after the delay
      });
    } catch (e) {
      print('Error processing policy: $e');
    }
  }
}
