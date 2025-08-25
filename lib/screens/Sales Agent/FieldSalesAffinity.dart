import 'dart:math';

import 'package:flutter/material.dart';

import '../../constants/Constants.dart';
import '../../customwidgets/CustomCard.dart';
import '../../services/MyNoyifier.dart';
import '../../services/log.dart';
import '../PaymentHistoryPage.dart';
import 'conclusion.dart';
import 'field_client_signature.dart';
import 'field_premium_calculator.dart';
import 'field_sale_basic_information.dart';
import 'field_sale_summary.dart';
import 'field_sales_call_client.dart';
import 'field_sales_communication_preferences.dart';
import 'field_sales_members_details.dart';
import 'field_sales_verify_otp.dart';
import 'need_analysis.dart';

final salesFieldAffinityValue = ValueNotifier<int>(0);
MyNotifier? myNotifier;
int selectedIndex = -1;
double totalAmount = 0;
List<PolicyDetails1> policydetails = [];
UniqueKey key1 = UniqueKey();
int activeStep = -1; // We'll store the currently-expanded index here
List<CreateLeads> createLeadStepsList = [
  CreateLeads("Basic information", "basic_information"),
  CreateLeads("Needs Analysis", "needs_analysis"),
  CreateLeads("Premium Calculator", "premium_calculator"),
  CreateLeads("Member Details", "member_details"),
  CreateLeads("Communication Preferences", "communication_preferences"),
  CreateLeads("Call Client", "call_client"),
  CreateLeads("Conclusion", "conclusion"),
  CreateLeads("OTP Verification", "otp_verification"),
  CreateLeads("Client Signature", "client_signature"),
  CreateLeads("Summary", "summary"),
];

class Fieldsalesaffinity extends StatefulWidget {
  const Fieldsalesaffinity({Key? key}) : super(key: key);

  @override
  State<Fieldsalesaffinity> createState() => _FieldsalesaffinityState();
}

class _FieldsalesaffinityState extends State<Fieldsalesaffinity> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black.withOpacity(0.6),
          title:
              const Text("Field Sales", style: TextStyle(color: Colors.black)),
          elevation: 6,
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: ListView.builder(
            key: key1,
            itemCount: createLeadStepsList.length,
            itemBuilder: (context, index) {
              final step = createLeadStepsList[index];

              return InkWell(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: index == selectedIndex
                        ? Constants.ftaColorLight
                        : Colors.grey.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      /* BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),*/
                    ],
                  ),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      // The leading small circle with step number
                      leading: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Constants.ctaColorLight,
                          borderRadius: BorderRadius.circular(360),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      // The title with the step name
                      title: Text(
                        step.leadStepName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: (activeStep != index)
                              ? Colors.black54
                              : Colors.black,
                        ),
                      ),

                      // If `activeStep == index`, show as expanded
                      initiallyExpanded: activeStep == index,

                      // Callback when user taps to expand/collapse
                      onExpansionChanged: (bool expanded) {
                        setState(() {
                          // If expanded, set activeStep to this index, otherwise set to -1
                          activeStep = expanded ? index : -1;
                        });
                      },

                      // The children: place the widget you want to show when expanded
                      children: [
                        // Switch your logic based on step.stepName_id
                        if (step.stepNameId == "needs_analysis")
                          NeedAnalysis()
                        else if (step.stepNameId == "basic_information")
                          FieldSaleBasicInformation()
                        else if (step.stepNameId == "member_details")
                          FieldSalesMembersDetails()
                        else if (step.stepNameId == "premium_calculator")
                          FieldPremiumCalculator()
                        else if (step.stepNameId == "communication_preferences")
                          FieldSalesCommunicationPreference()
                        else if (step.stepNameId == "call_client")
                          FieldSalesCallClientPage()
                        else if (step.stepNameId == "conclusion")
                          Conclusion5a()
                        else if (step.stepNameId == "client_signature")
                          FieldClientSignature()
                        else if (step.stepNameId == "otp_verification")
                          Fiels_Sales_Verify_Otp()
                        else if (step.stepNameId == "summary")
                          FieldSaleSummary()
                        else
                          Container(
                            height: 80,
                            alignment: Alignment.center,
                            child: Text(
                                "Widget for ${step.leadStepName} not implemented yet."),
                          )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    myNotifier = MyNotifier(salesFieldAffinityValue, context);

    salesFieldAffinityValue.addListener(() {
      updateFieldSections();
    });
  }

  updateFieldSections() {
    if (Constants.fieldSaleType == "Field Sale") {
      createLeadStepsList = [
        CreateLeads("Basic information", "basic_information"),
        CreateLeads("Needs Analysis", "needs_analysis"),
        CreateLeads("Premium Calculator", "premium_calculator"),
        CreateLeads("Member Details", "member_details"),
        CreateLeads("Communication Preferences", "communication_preferences"),
        CreateLeads("Call Client", "call_client"),
        CreateLeads("Conclusion", "conclusion"),
        CreateLeads("Summary", "summary"),
      ];
      setState(() {});
    } else {
      createLeadStepsList = [
        CreateLeads("Basic information", "basic_information"),
        CreateLeads("Needs Analysis", "needs_analysis"),
        CreateLeads("Premium Calculator", "premium_calculator"),
        CreateLeads("Member Details", "member_details"),
        CreateLeads("Communication Preferences", "communication_preferences"),
        CreateLeads("Client Signature", "client_signature"),
        CreateLeads("OTP Verification", "otp_verification"),
        CreateLeads("Summary", "summary"),
      ];
      setState(() {});
    }
  }
}

class CreateLeads {
  String leadStepName;
  String stepNameId;

  CreateLeads(this.leadStepName, this.stepNameId);
}

class PolicyCard extends StatefulWidget {
  final int index;
  const PolicyCard({super.key, required this.index});

  @override
  State<PolicyCard> createState() => _PolicyCardState();
}

class _PolicyCardState extends State<PolicyCard> {
  int _selectedMonth = 1;
  late PolicyDetails1 policydetails1;
  int minPaymentMonths = 1;
  List<int> paymentMonths = [1];

  @override
  void initState() {
    super.initState();
    print("---- reloading ${widget.index} $policydetails");

    // Initialize policy details
    policydetails1 = policydetails[widget.index];

    // Set the selected month
    _selectedMonth = policydetails1.monthsToPayFor;

    // Generate initial list of 12 months
    paymentMonths = generateListOfTwelve();

    // Calculate minimum payments required
    getMinPayments();
    Constants.session_id = generateRandomDigits(15);

    setState(() {});
  }

  List<int> generateListOfTwelve() {
    return List<int>.generate(12, (index) => index + 1);
  }

  void getMinPayments() {
    if (policydetails1.canReinstate == true) {
      double minCount = policydetails1.minimumReinstatementPremiums;
      print("dfdfg $minCount");
      print(policydetails1);
      _selectedMonth = policydetails1.minimumReinstatementPremiums.round();
      policydetails1.monthsToPayFor =
          policydetails1.minimumReinstatementPremiums.round();

      // Update paymentMonths to only include months that satisfy the minimum amount
      paymentMonths =
          generateListOfTwelve().where((month) => month >= minCount).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    void _toggleAcceptTerms1(bool? value) {
      setState(() {
        policydetails1.acceptTerms = value!;
        logAction(
          cecClientId: Constants.cec_client_id,
          employeeId: Constants.cec_empid,
          employeeName: Constants.cec_empname,
          action:
              'Selected policy for payment ${policydetails[widget.index].policyNumber}',
          details: 'Toggled click to pay to ${value}',
          policyOrReference: policydetails[widget.index].policyNumber,
          deviceId:
              "${Constants.device_id}###${Constants.device_model}###${Constants.device_os_version}",
          ipAddress: '',
          isPayment: false,
          payload: "",
          responseText: "",
          statusCode: 200,
        );

        // Recalculate the total amount based on selected policies
        totalAmount = 0;
        for (var element in Constants.selectedPolicydetails) {}
      });
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: CustomCard(
        elevation: 5,
        surfaceTintColor: Colors.white,
        color: Colors.white,
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
                      "${widget.index + 1}) Policy # : ${policydetails[widget.index].policyNumber}",
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
                    policydetails[widget.index].customerFirstName,
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
                                borderRadius: BorderRadius.circular(8),
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
                    ),
                  ),
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
                        onChanged: (int? newValue) {},
                        items: paymentMonths
                            .map<DropdownMenuItem<int>>((int month) {
                          return DropdownMenuItem<int>(
                            value: month,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(month.toString()),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              if (policydetails[widget.index].canReinstate == true)
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${policydetails[widget.index].msgReinstate}",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )),
                  ],
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
                                  borderRadius: BorderRadius.circular(16),
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
                              "inforced" &&
                          policydetails[widget.index].canReinstate == false)
                      ? Container()
                      : Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Text((policydetails[widget.index].canReinstate ==
                                      true)
                                  ? "Click to Reinstate"
                                  : "Click Here to Pay"),
                              Transform.scale(
                                scale: 1.9,
                                child: Checkbox(
                                  activeColor: Constants.ctaColorLight,
                                  checkColor: Colors.white,
                                  value: policydetails1.acceptTerms,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          (policydetails[widget.index]
                                                      .canReinstate ==
                                                  true)
                                              ? 4
                                              : 36.0),
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
}

class PolicyDetails1 {
  final String encryptedKey;
  final int cecClientId;
  final int cecEmpId;
  final String cecLogo;
  final String cecEmpName;
  final String policyNumber;
  final String planType;
  final String status;
  int monthsToPayFor;
  final String paymentStatus;
  final int paymentsBehind;
  final double monthlyPremium;
  final double benefitAmount;
  bool acceptTerms;
  final String customerIdNumber;
  final String customerFirstName;
  final String customerLastName;
  final String customerContact;
  final String inceptionDate;
  final String inforceDate;
  final BusinessInfo businessInfo;
  final List<Payment> payments;
  final bool canReinstate;
  final String? msgReinstate;
  final bool canRestart;
  final String? msgRestart;
  final double minimumRestartPremiums;
  final double minimumReinstatementPremiums;
  final TransactionData transactionData;

  PolicyDetails1({
    required this.encryptedKey,
    required this.cecClientId,
    required this.cecEmpId,
    required this.cecLogo,
    required this.cecEmpName,
    required this.policyNumber,
    required this.planType,
    required this.status,
    required this.monthsToPayFor,
    required this.paymentStatus,
    required this.paymentsBehind,
    required this.monthlyPremium,
    required this.benefitAmount,
    required this.acceptTerms,
    required this.customerIdNumber,
    required this.customerFirstName,
    required this.customerLastName,
    required this.customerContact,
    required this.inceptionDate,
    required this.inforceDate,
    required this.businessInfo,
    required this.payments,
    required this.canReinstate,
    this.msgReinstate,
    required this.canRestart,
    this.msgRestart,
    required this.minimumRestartPremiums,
    required this.minimumReinstatementPremiums,
    required this.transactionData,
  });

  factory PolicyDetails1.fromJson(Map<String, dynamic> json) {
    var paymentsList = (json['payments'] as List<dynamic>? ?? [])
        .map((paymentJson) =>
            Payment.fromJson(paymentJson as Map<String, dynamic>))
        .toList();
    print("jhjhh ${json['transaction_data'] ?? ""}");

    return PolicyDetails1(
      encryptedKey: json['encrypted_key'] ?? "",
      cecClientId: json['cec_client_id'] ?? 0,
      cecEmpId: json['cec_empid'] ?? 0,
      cecLogo: json['cec_logo'] ?? "",
      cecEmpName: json['cec_empname'] ?? "",
      policyNumber: json['policyNumber'] ?? "",
      planType: json['planType'] ?? "",
      status: json['status'] ?? "",
      monthsToPayFor: json['monthsToPayFor'] ?? 0,
      paymentStatus: json['paymentStatus'] ?? "",
      paymentsBehind: json['paymentsBehind'] ?? 0,
      monthlyPremium: (json['monthlyPremium'] as num?)?.toDouble() ?? 0.0,
      benefitAmount: (json['benefitAmount'] as num?)?.toDouble() ?? 0.0,
      acceptTerms: json['acceptTerms'] ?? false,
      customerIdNumber: json['customer_id_number'] ?? "",
      customerFirstName: json['customer_first_name'] ?? "",
      customerLastName: json['customer_last_name'] ?? "",
      customerContact: json['customer_contact'] ?? "",
      inceptionDate: json['inceptionDate'] ?? "",
      inforceDate: json['inforce_date'] ?? "",
      businessInfo: BusinessInfo.fromJson(json['business_info'] ?? {}),
      payments: paymentsList,
      canReinstate: json['canResinstate'] ?? false,
      msgReinstate: json['msgReinstate'] ?? "",
      canRestart: json['canRestart'] ?? false,
      msgRestart: json['msgRestart'] ?? "",
      minimumRestartPremiums:
          (json['minimumRestartPremiums'] ?? 0)?.toDouble() ?? 0.0,
      minimumReinstatementPremiums:
          (json['minimumReinstatementPremiums'] ?? 0)?.toDouble() ?? 0.0,
      transactionData:
          TransactionData.fromJson((json['transaction_data'] ?? {})),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'encrypted_key': encryptedKey,
      'cec_client_id': cecClientId,
      'cec_empid': cecEmpId,
      'cec_logo': cecLogo,
      'cec_empname': cecEmpName,
      'policyNumber': policyNumber,
      'planType': planType,
      'status': status,
      'monthsToPayFor': monthsToPayFor,
      'paymentStatus': paymentStatus,
      'paymentsBehind': paymentsBehind,
      'monthlyPremium': monthlyPremium,
      'benefitAmount': benefitAmount,
      'acceptTerms': acceptTerms,
      'customer_id_number': customerIdNumber,
      'customer_first_name': customerFirstName,
      'customer_last_name': customerLastName,
      'customer_contact': customerContact,
      'inceptionDate': inceptionDate,
      'inforce_date': inforceDate,
      'business_info': businessInfo.toJson(),
      'payments': payments.map((payment) => payment.toJson()).toList(),
      'canResinstate': canReinstate,
      'msgReinstate': msgReinstate,
      'canRestart': canRestart,
      'msgRestart': msgRestart,
      'minimum_restart_premiums': minimumRestartPremiums,
      'minimum_reinstatement_premiums': minimumReinstatementPremiums,
      'transactionData': transactionData!.toJson(),
    };
  }
}

class BusinessInfo {
  final String address_1;
  final String address_2;
  final String city;
  final String province;
  final String country;
  final String area_code;
  final String postal_address_1;
  final String postal_address_2;
  final String postal_city;
  final String postal_province;
  final String postal_country;
  final String postal_code;
  final String tel_no;
  final String cell_no;
  final String comp_name;
  final String vat_number;
  final String client_fsp;
  final String logo;
  BusinessInfo({
    required this.address_1,
    required this.address_2,
    required this.city,
    required this.province,
    required this.country,
    required this.area_code,
    required this.postal_address_1,
    required this.postal_address_2,
    required this.postal_city,
    required this.postal_province,
    required this.postal_country,
    required this.postal_code,
    required this.tel_no,
    required this.cell_no,
    required this.comp_name,
    required this.vat_number,
    required this.client_fsp,
    required this.logo,
  });
  Map<String, dynamic> toJson() {
    return {
      'address_1': address_1,
      'address_2': address_2,
      'city': city,
      'province': province,
      'country': country,
      'area_code': area_code,
      'postal_address_1': postal_address_1,
      'postal_address_2': postal_address_2,
      'postal_city': postal_city,
      'postal_province': postal_province,
      'postal_country': postal_country,
      'postal_code': postal_code,
      'tel_no': tel_no,
      'cell_no': cell_no,
      'comp_name': comp_name,
      'vat_number': vat_number,
      'client_fsp': client_fsp,
      'logo': logo,
    };
  }

  factory BusinessInfo.fromJson(Map<dynamic, dynamic> json) {
    return BusinessInfo(
      address_1: json['address_1'] ?? "",
      address_2: json['address_2'] ?? "",
      city: json['city'] ?? "",
      province: json['province'] ?? "",
      country: json['country'] ?? "",
      area_code: json['area_code'] ?? "",
      postal_address_1: json['postal_address_1'] ?? "",
      postal_address_2: json['postal_address_2'] ?? "",
      postal_city: json['postal_city'] ?? "",
      postal_province: json['postal_province'] ?? "",
      postal_country: json['postal_country'] ?? "",
      postal_code: json['postal_code'] ?? "",
      tel_no: json['tel_no'] ?? "",
      cell_no: json['cell_no'] ?? "",
      comp_name: json['comp_name'] ?? "",
      vat_number: json['vat_number'] ?? "",
      client_fsp: json['client_fsp'] ?? "",
      logo: json['logo'] ?? "",
    );
  }
}

class Payment {
  final String collectionDate;
  final double collectedPremium;

  Payment({required this.collectionDate, required this.collectedPremium});

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      collectionDate: json['collection_date'],
      collectedPremium: json['collected_premium'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'collection_date': collectionDate,
      'collected_premium': collectedPremium,
    };
  }
}

class TransactionData {
  final int cecClientId;
  final String businessOrderNo;
  final String paymentScenario;
  final String amount;
  final String transData;
  final String appId;
  final String transType;
  final String createdAt;
  final String updatedAt;

  TransactionData({
    required this.cecClientId,
    required this.businessOrderNo,
    required this.paymentScenario,
    required this.amount,
    required this.transData,
    required this.appId,
    required this.transType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionData.fromJson(Map<dynamic, dynamic> json) {
    return TransactionData(
      cecClientId: json['cec_client_id'] ?? 0,
      businessOrderNo: json['business_order_no'] ?? "",
      paymentScenario: json['payment_scenario'] ?? "",
      amount: json['amount'] ?? "",
      transData: json['trans_data'] ?? "",
      appId: json['app_id'] ?? "",
      transType: json['trans_type'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cec_client_id': cecClientId,
      'business_order_no': businessOrderNo,
      'payment_scenario': paymentScenario,
      'amount': amount,
      'trans_data': transData,
      'app_id': appId,
      'trans_type': transType,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
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
