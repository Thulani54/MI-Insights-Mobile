import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_insights/screens/Sales%20Agent/universal_premium_calculator.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/Constants.dart';
import '../../customwidgets/CustomCard.dart';
import '../../customwidgets/cssloadloader.dart';
import '../../customwidgets/custom_input.dart';
import '../../models/map_class.dart';
import '../../services/MyNoyifier.dart';
import '../../services/log.dart';
import '../../services/sales_service.dart';
import '../PaymentHistoryPage.dart';
import 'SalesAgentSalesReport.dart';
import 'conclusion.dart';
import 'field_client_signature.dart';
import 'field_premium_calculator.dart';
import 'field_sale_basic_information.dart';
// import 'field_sale_summary.dart'; // Summary section hidden as requested
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
List<CreateLeads> createLeadStepsList = [];

// Validation function to check if user can move forward from needs analysis
bool canMoveFromNeedsAnalysis() {
  // Check if we have at least one policy
  if (Constants.currentleadAvailable!.policies.isEmpty) {
    print("Validation failed: No policies found");
    return false;
  }

  print(
      "Found ${Constants.currentleadAvailable!.additionalMembers.length} members");

  // Check if at least one additional member is a main member
  for (var member in Constants.currentleadAvailable!.additionalMembers) {
    String relationship = member.relationship?.toLowerCase() ?? '';
    bool isPremiumPayer = false;

    if (relationship.contains('main') ||
        relationship == 'self' ||
        isPremiumPayer) {
      print(
          "Found main member with relationship: $relationship, isPremiumPayer: $isPremiumPayer");
      return true;
    }
  }

  // Also check the mainMembers global list as backup
  print("Checking mainMembers list: ${mainMembers.length} members");
  if (mainMembers.isNotEmpty) {
    return true;
  }

  print("Validation failed: No main members found");
  return false;
}

class Fieldsalesaffinity extends StatefulWidget {
  final String? sale_type;

  const Fieldsalesaffinity({Key? key, this.sale_type}) : super(key: key);

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
          title: Text(widget.sale_type.toString(),
              style: TextStyle(color: Colors.black)),
          elevation: 6,
          leading: InkWell(
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => StatefulBuilder(
                  builder: (context, setState) => EndCallDialog2(
                    lead: Constants.currentleadAvailable!.leadObject,
                    context2: context,
                    type: "Field",
                  ),
                ),
              );
            },
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: ListView.builder(
            // key: key1, // Removed to prevent rebuild issues
            itemCount: createLeadStepsList.length,
            itemBuilder: (context, index) {
              final step = createLeadStepsList[index];

              return InkWell(
                onTap: null, // ✅ Disable tap on the container
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.35),
                          width: (activeStep != index) ? 1 : 2,
                        )),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          // Header row with step number and title
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Row(
                              children: [
                                // The leading small circle with step number
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Constants.ctaColorLight,
                                    borderRadius: BorderRadius.circular(360),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 16),

                                // The title with the step name
                                Expanded(
                                  child: Text(
                                    step.leadStepName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: (activeStep != index)
                                          ? Colors.black54
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Content that shows when this step is active
                          if (activeStep == index) ...[
                            const Divider(thickness: 1, height: 1),
                            Column(
                              children: [
                                // Content widget
                                if (step.stepNameId == "needs_analysis")
                                  NeedAnalysis()
                                else if (step.stepNameId == "basic_information")
                                  FieldSaleBasicInformation(
                                      type: widget.sale_type!)
                                else if (step.stepNameId == "member_details")
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: FieldSalesMembersDetails(),
                                  )
                                else if (step.stepNameId ==
                                    "premium_calculator")
                                  UniversalPremiumCalculator()
                                // else if (step.stepNameId ==
                                //     "communication_preferences")
                                //   FieldSalesCommunicationPreference()
                                // else if (step.stepNameId == "call_client")
                                //   FieldSalesCallClientPage()
                                else if (step.stepNameId == "conclusion")
                                  InforcePolicyDialog2()
                                else if (step.stepNameId == "client_signature")
                                  FieldClientSignature()
                                else if (step.stepNameId == "otp_verification")
                                  Fiels_Sales_Verify_Otp()
                                // else if (step.stepNameId == "summary") // Summary section hidden as requested
                                //   FieldSaleSummary()
                                else
                                  Container(
                                    height: 80,
                                    alignment: Alignment.center,
                                    child: Text(
                                        "Widget for ${step.leadStepName} not implemented yet."),
                                  ),

                                // Navigation buttons
                                const SizedBox(height: 24),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Back button
                                      index > 0
                                          ? SizedBox(
                                              width: 120,
                                              height: 36,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  onBackStep(index);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Constants.ctaColorLight,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            36),
                                                  ),
                                                ),
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.arrow_back,
                                                        color: Colors.white,
                                                        size: 18),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      "Back",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : const SizedBox(width: 120),

                                      // Next button
                                      index < createLeadStepsList.length - 1
                                          ? SizedBox(
                                              width: 120,
                                              height: 36,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  _onNextStep(index, step);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Constants.ftaColorLight,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            36),
                                                  ),
                                                ),
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Next",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    SizedBox(width: 4),
                                                    Icon(Icons.arrow_forward,
                                                        color: Colors.white,
                                                        size: 18),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
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
    // Initialize the list directly without setState
    if (widget.sale_type.toString() == "Field Sale") {
      createLeadStepsList = [
        CreateLeads("Basic information", "basic_information"),
        CreateLeads("Needs Analysis", "needs_analysis"),
        CreateLeads("Premium Calculator", "premium_calculator"),
        CreateLeads("Member Details", "member_details"),
        // CreateLeads("Communication Preferences", "communication_preferences"), // Hidden as requested
        CreateLeads("Conclusion", "conclusion"),
      ];
    } else {
      createLeadStepsList = [
        CreateLeads("Basic information", "basic_information"),
        CreateLeads("Needs Analysis", "needs_analysis"),
        CreateLeads("Premium Calculator", "premium_calculator"),
        CreateLeads("Member Details", "member_details"),
        // CreateLeads("Communication Preferences", "communication_preferences"), // Hidden as requested
        CreateLeads("Client Signature", "client_signature"),
        CreateLeads("OTP Verification", "otp_verification"),
      ];
    }

    // Set the first step as active/expanded by default
    activeStep = 0;

    myNotifier = MyNotifier(salesFieldAffinityValue, context);

    salesFieldAffinityValue.addListener(() {
      updateFieldSections();
    });
  }

  updateFieldSections() {
    if (widget.sale_type.toString() == "Field Sale") {
      createLeadStepsList = [
        CreateLeads("Basic information", "basic_information"),
        CreateLeads("Needs Analysis", "needs_analysis"),
        CreateLeads("Premium Calculator", "premium_calculator"),
        CreateLeads("Member Details", "member_details"),
        // CreateLeads("Communication Preferences", "communication_preferences"), // Hidden as requested
        // CreateLeads("Call Client", "call_client"),
        CreateLeads("Conclusion", "conclusion"),
        // CreateLeads("Summary", "summary"), // Summary section hidden as requested
      ];
    } else {
      createLeadStepsList = [
        CreateLeads("Basic information", "basic_information"),
        CreateLeads("Needs Analysis", "needs_analysis"),
        CreateLeads("Premium Calculator", "premium_calculator"),
        CreateLeads("Member Details", "member_details"),
        // CreateLeads("Communication Preferences", "communication_preferences"), // Hidden as requested
        CreateLeads("Client Signature", "client_signature"),
        CreateLeads("OTP Verification", "otp_verification"),
        // CreateLeads("Summary", "summary"), // Summary section hidden as requested
      ];
    }
    // Use post frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void onBackStep(int currentIndex) {
    if (!mounted) return;

    // Get current step name
    String stepName = createLeadStepsList[currentIndex].leadStepName;
    String stepId = createLeadStepsList[currentIndex].stepNameId;

    print("Back step from: $stepName");

    // If we're on the Premium Calculator page and can go back within it,
    // simply decrement the premium calculator step.
    if (stepId == "premium_calculator") {
      if (universalPremiumCalculatorActiveStep > 0) {
        setState(() {
          universalPremiumCalculatorActiveStep--;
        });
        return;
      }
      // If we're on the first step of premium calculator, go to previous main step
    }

    if (stepId == "member_details") {
      if (fieldSalesActiveStep > 0) {
        setState(() {
          fieldSalesActiveStep--;
        });
        return;
      }
      // If we're on the first step of member details, go to previous main step
    }

    // Otherwise, handle the normal back step logic.
    setState(() {
      if (activeStep > 0) {
        activeStep--;
        // key1 = UniqueKey(); // Removed to prevent unnecessary rebuilds
      }
    });
  }

  void _onNextStep(int currentIndex, dynamic step) {
    if (!mounted) return;

    String stepName = step.leadStepName;
    String stepId = step.stepNameId;

    print("Next step from: $stepName");

    setState(() {
      // Update last position based on current step
      if (stepId == "needs_analysis") {
        Constants.currentleadAvailable!.leadObject.lastPosition =
            "Needs Analysis";
      } else if (stepId == "premium_calculator") {
        Constants.currentleadAvailable!.leadObject.lastPosition =
            "Premium Calculator";
      } else if (stepId == "member_details") {
        Constants.currentleadAvailable!.leadObject.lastPosition =
            "Member Details";
        // } else if (stepId == "communication_preferences") {
        //   Constants.currentleadAvailable!.leadObject.lastPosition =
        //       "Communication Preference";
        // } else if (stepId == "call_client") {
        //   Constants.currentleadAvailable!.leadObject.lastPosition = "Call Client";
      } else if (stepId == "conclusion") {
        Constants.currentleadAvailable!.leadObject.lastPosition = "Conclusion";
      }

      // Validate current step before proceeding
      if (stepId == "needs_analysis") {
        if (!validateNeedsAnalysis()) {
          return; // Stop if validation fails
        }
      } else if (stepId == "member_details") {
        // Handle internal navigation within member details
        if (fieldSalesActiveStep < fieldbottomBarList.length - 1) {
          fieldSalesActiveStep++;
          return; // Stay within member details
        }
        // If we're on the last step of member details, validate before moving to next main step
        if (!validateMemberDetails()) {
          return; // Stop if validation fails
        }
      } else if (stepId == "premium_calculator") {
        // Handle internal navigation within premium calculator
        if (universalPremiumCalculatorActiveStep <
            universalPremuimCalculatorBottomBarList.length - 1) {
          universalPremiumCalculatorActiveStep++;
          return; // Stay within premium calculator
        }
        // If we're on the last step of premium calculator, validate before moving to next main step
        if (!validatePremiumCalculator()) {
          return; // Stop if validation fails
        }
        // } else if (stepId == "communication_preferences") {
        //   if (!validateCommunicationPreferences()) {
        //     return; // Stop if validation fails
        //   }
        // } else if (stepId == "call_client") {
        //   if (!validateCallClient()) {
        //     return; // Stop if validation fails
        //   }
      }

      // If validation passes, move to next step
      if (currentIndex < createLeadStepsList.length - 1) {
        activeStep = currentIndex + 1;
        // key1 = UniqueKey(); // Removed to prevent unnecessary rebuilds
      }
    });
  }

  bool validateNeedsAnalysis() {
    var membersAvailable = Constants.currentleadAvailable!.additionalMembers;
    print("Validating members: ${membersAvailable.length} found");
    if (membersAvailable.isEmpty) {
      MotionToast.error(
          height: 45,
          description: Text(
            "Add at least one member to proceed.",
            style: TextStyle(color: Colors.white),
          )).show(context);
      return false;
    }
    return true;
  }

  bool validateMemberDetails() {
    // Employment Status validation - Check if currently employed
    String employmentStatus =
        Constants.currentleadAvailable!.employer!.employmentStatus;

    if (Constants.currentleadAvailable!.employer!.employmentStatus ==
            "Employed" &&
        Constants.isEmployerDetailsSaved == false) {
      MotionToast.error(
          height: 45,
          description: Text(
            "Please enter employee details.",
            style: TextStyle(color: Colors.white),
          )).show(context);
      return false;
    }
    // Payment Type validation
    String paymentType = Constants.currentleadAvailable!.leadObject.paymentType;
    if (paymentType.isEmpty) {
      MotionToast.error(
          height: 45,
          description: Text(
            "Please select the payment type.",
            style: TextStyle(color: Colors.white),
          )).show(context);
      return false;
    }

    // Basic info validation
    final premiumPayer =
        Constants.currentleadAvailable!.policies.first.premiumPayer!;
    String debitDay = premiumPayer.collectionday;
    if (debitDay.isEmpty) {
      MotionToast.error(
          height: 45,
          description: Text(
            "Please select the debit day.",
            style: TextStyle(color: Colors.white),
          )).show(context);
      return false;
    }

    return true;
  }

  bool validatePremiumCalculator() {
    print("Validating premium calculator...");

    // Create a list to store the references of policies with a zero premium.
    List<String> invalidPolicyRefs = [];

    // Loop through each policy and check if the premium was calculated.
    for (var policy in Constants.currentleadAvailable!.policies) {
      print("Premium check: ${policy.quote.totalAmountPayable}");
      if (policy.quote.totalAmountPayable == 0 ||
          policy.quote.totalAmountPayable == null) {
        invalidPolicyRefs.add(policy.quote.reference ?? "Unknown");
      }
    }

    // If there are any policies without a calculated premium, show an error.
    if (invalidPolicyRefs.isNotEmpty) {
      String refs = invalidPolicyRefs.join(", ");
      String errorMessage =
          "Premium was not calculated for policy reference(s)";

      MotionToast.error(
          height: 55,
          description: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          )).show(context);
      return false;
    }

    // Check commencement dates ONLY for policies with calculated premiums
    List<String> policiesWithoutDates = [];
    for (int i = 0; i < Constants.currentleadAvailable!.policies.length; i++) {
      var policy = Constants.currentleadAvailable!.policies[i];

      if ((policy.quote.totalAmountPayable ?? 0) > 0) {
        String? commencementDate = policy.premiumPayer.commencementDate;
        bool isDateMissing = commencementDate == null ||
            commencementDate.isEmpty ||
            commencementDate.trim().isEmpty;

        if (isDateMissing) {
          policiesWithoutDates.add(policy.quote.reference ?? "Policy ${i + 1}");
        }
      }
    }

    if (policiesWithoutDates.isNotEmpty) {
      String policyRefs = policiesWithoutDates.join(", ");
      String errorMessage = policiesWithoutDates.length == 1
          ? "Please select the commencement date for policy: $policyRefs"
          : "Please select commencement dates for policies: $policyRefs";

      MotionToast.error(
          height: 55,
          description: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          )).show(context);
      return false;
    }

    return true;
  }

  bool validateCommunicationPreferences() {
    String communicationPreference =
        Constants.currentleadAvailable!.leadObject.communicationPreference;
    if (communicationPreference.isEmpty) {
      MotionToast.error(
          height: 55,
          description: Text(
            "Please select the communication preference type.",
            style: TextStyle(color: Colors.white),
          )).show(context);
      return false;
    }
    return true;
  }

  bool validateCallClient() {
    if (Constants.accepteddeclationsAndWaitiongPeriods == false) {
      MotionToast.error(
          height: 55,
          description: Text(
            "Please accept the declarations and waiting periods to proceed.",
            style: TextStyle(color: Colors.white),
          )).show(context);
      return false;
    }
    return true;
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

class EndCallDialog2 extends StatefulWidget {
  final LeadObject lead;
  final BuildContext context2;
  final String type;

  const EndCallDialog2(
      {Key? key,
      required this.lead,
      required this.context2,
      required this.type})
      : super(key: key);

  @override
  State<EndCallDialog2> createState() => _EndCallDialog2State();
}

class _EndCallDialog2State extends State<EndCallDialog2> {
  /// The complete list of "End Call" reasons
  /// (Including those that have subReasons).
  final List<EndCallReason> reasons = [
    EndCallReason(
      title: "Incomplete",
      descriptions: [
        "No Documents",
        "Incomplete Form",
        "Unclear Images",
        "Invalid ID Number",
        "Incorrect Premium",
        "No Affidavit",
        "Beneficiary Details",
        "Mandate Not Attached",
        "Invisible Application Form",
        "Incorrect Application Form",
      ],
    ),
    EndCallReason(
      title: "Not Interested",
      descriptions: [
        "Wrong Number",
        "Already Covered",
        "Client Hang-up",
        "Cannot Afford",
        "Waiting Period"
      ],
      subReasons: [],
    ),
    EndCallReason(
      title: "Does Not Qualify",
      descriptions: [
        "No SA ID",
        "No Bank Account",
        "Under Age",
        "Over Age",
        "NTU",
        "Lapsed Policy",
        "Maximum Cover Reached",
      ],
    ),
    EndCallReason(
      title: "Prank Call",
      descriptions: ["Jail", "Child"],
    ),
    EndCallReason(
      title: "Transfer",
      descriptions: ["CSU", "To Pool", "Language Barrier"],
      subReasons: [
        SubReason(
          title: "CSU Type",
          options: ["maintenance", "Enquiry"],
        ),
      ],
    ),
    EndCallReason(
      title: "Call Back",
      descriptions: ["Client Request", "Network"],
    ),
  ];

  /// The currently-selected main reason's title
  String? selectedMainReason;
  String? selectedSubReason;

  /// Helper: returns the matching [EndCallReason] if the user has chosen one
  EndCallReason? get selectedReason {
    if (selectedMainReason == null) return null;
    return reasons.firstWhere(
      (r) => r.title == selectedMainReason,
      orElse: () => EndCallReason(title: '', descriptions: []),
    );
  }

  // Additional lists if you just want to append them to the reason dropdown
  // leaving them out of the main reasons array.
  // They won't show sub-descriptions though, unless you handle them similarly:
  final List<String> _extraReasons = ["Duplicate", "Mystery Shopper"];

  /// CONTROLLERS for date/time
  final TextEditingController _callBackDateController = TextEditingController();
  final TextEditingController _callBackTimeController = TextEditingController();
  final TextEditingController _underDOBController = TextEditingController();
  final TextEditingController _overDOBController = TextEditingController();

  final FocusNode _dateFocusNode = FocusNode();
  final FocusNode _timeFocusNode = FocusNode();

  @override
  void dispose() {
    _callBackDateController.dispose();
    _callBackTimeController.dispose();
    _underDOBController.dispose();
    _overDOBController.dispose();
    _dateFocusNode.dispose();
    _timeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 24.0), // Add 24px padding on left and right
      child: Dialog(
        backgroundColor: Colors.black.withOpacity(0.65),
        surfaceTintColor: Colors.black.withOpacity(0.65),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: EdgeInsets.zero, // Remove default dialog padding
        child: Container(
          width: double
              .infinity, // Fill available width (which will be screen width - 48px due to padding)
          constraints: const BoxConstraints(minHeight: 250),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
                child: Center(
                  child: Text(
                    "Important Reminder",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'YuGothic',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
                child: Text(
                  "Before ending the call, ensure the appointment date and time are confirmed with the client. Double-check these details to avoid any scheduling errors and provide a seamless experience.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'YuGothic',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainReasonDropdown(),
                    if (selectedMainReason != null) _buildReasonContent(),
                    _buildActionButtons2(widget.context2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------------------
  // WIDGET BUILDERS
  // -----------------------------------------------------------

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.14),
      ),
      height: 65,
      child: Row(
        children: [
          SizedBox(
            width: 24,
          ),
          Text(
            "End Call",
            style: TextStyle(
              color: Constants.ftaColorLight,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              fontFamily: 'YuGothic',
            ),
          ),
          Spacer(),
          InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.close,
                color: Colors.grey,
              )),
          SizedBox(
            width: 24,
          )
        ],
      ),
    );
  }

  Widget _buildMainReasonDropdown() {
    // We combine the reasons in the array + the extra reasons in _extraReasons
    final allReasonTitles = [
      ...reasons.map((r) => r.title),
      ..._extraReasons,
    ];

    return _buildDropdown(
      context: context,
      value: selectedMainReason,
      items: allReasonTitles,
      hint: "Choose Reason",
      onChanged: (value) {
        setState(() {
          selectedMainReason = value;
          // Clear any previously selected sub-description
          final sr = selectedReason;
          if (sr != null) sr.selectedDescription = null;
        });
      },
    );
  }

  Widget _buildReasonContent() {
    final reason = selectedReason;
    if (reason == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        // Sub-description dropdown
        _buildDropdown(
          context: context,
          value: reason.selectedDescription,
          items: reason.descriptions,
          hint: "--Select--",
          onChanged: (value) {
            setState(() {
              reason.selectedDescription = value;
              selectedSubReason = value;
            });
          },
        ),
        if (reason.selectedDescription != null) ...[
          // If this reason has "subReasons", build them
          ..._buildSubReasons(reason),
          // If sub-reason triggers special inputs (DOB, callback, etc.)
          ..._buildSpecialInputs(reason),
        ],
      ],
    );
  }

  List<Widget> _buildSubReasons(EndCallReason reason) {
    if (reason.subReasons == null) return [];
    return reason.subReasons!.map((subReason) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            subReason.title, // e.g. "Insurance Company" or "CSU Type"
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          _buildDropdown(
            context: context,
            value: subReason.selectedOption,
            items: subReason.options,
            hint: "--Select--",
            onChanged: (value) {
              setState(() {
                subReason.selectedOption = value;
              });
            },
          ),
        ],
      );
    }).toList();
  }

  List<Widget> _buildSpecialInputs(EndCallReason reason) {
    final widgets = <Widget>[];
    final desc = reason.selectedDescription!;

    // Example: If "Under Age" or "Over Age", ask for DOB
    if (desc == "Under Age" || desc == "Over Age") {
      widgets.add(const SizedBox(height: 16));
      widgets.add(
        _buildDateInput(
          controller:
              desc == "Under Age" ? _underDOBController : _overDOBController,
          label: "Date of Birth",
        ),
      );
    }

    // Example: If "Call Back" reason + "Client Request" or "Network"
    // then show the callback time.
    if (reason.title == "Call Back" &&
        (desc == "Client Request" || desc == "Network")) {
      widgets.add(const SizedBox(height: 16));
      widgets.add(_buildDateTimePickerSection());
    }

    return widgets;
  }

  Widget _buildDateTimePickerSection() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.14),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.14),
            ),
            height: 35,
            child: Row(
              children: [
                Flexible(
                  child: Center(
                    child: Text(
                      "Call Back Time",
                      style: TextStyle(
                        color: Constants.ftaColorLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'YuGothic',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildDateInput(
                    controller: _callBackDateController,
                    label: "Call Back Date",
                    focusNode: _dateFocusNode,
                  ),
                ),
                const SizedBox(width: 22),
                Expanded(child: _buildTimeInput()),
                const SizedBox(width: 22),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons2(context2) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton(
            "End call",
            Constants.ctaColorLight,
            () async {
              // Check if a main reason is selected.
              if (selectedMainReason == null) {
                MotionToast.error(
                  height: 40,
                  width: 380,
                  onClose: () {},
                  description: const Text(
                    "Select a reason to decline the lead",
                    style: TextStyle(color: Colors.white),
                  ),
                ).show(context);
                return;
              }
              // Check if a subreason is selected.
              if (selectedSubReason == null) {
                MotionToast.error(
                  height: 40,
                  width: 380,
                  onClose: () {},
                  description: const Text(
                    "Select a subreason to decline the lead",
                    style: TextStyle(color: Colors.white),
                  ),
                ).show(context);
                return;
              }
              // If the main reason is "Call Back", check that the date and time are provided.
              if (selectedMainReason == "Call Back") {
                if (_callBackDateController.text.isEmpty ||
                    _callBackTimeController.text.isEmpty) {
                  MotionToast.error(
                    height: 40,
                    width: 380,
                    onClose: () {},
                    description: const Text(
                      "Select call back date and time",
                      style: TextStyle(color: Colors.white),
                    ),
                  ).show(context);
                  return;
                }
              }

              // Show loading dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => CSSLoadLoader(),
              );

              // Proceed to end the call.
              print(
                  "Ending call for lead2: ${widget.lead.onololeadid} ${_callBackDateController.text}");
              Constants.currentleadAvailable!.leadObject.hangUpReason =
                  selectedReason!.title;
              Constants.currentleadAvailable!.leadObject.hangUpDesc1 =
                  selectedSubReason.toString();
              Constants.currentleadAvailable!.leadObject.callBackDate =
                  _callBackDateController.text.toString();
              Constants.currentleadAvailable!.leadObject.callBackTime =
                  _callBackTimeController.text.toString();
              //Constants.currentleadAvailable!.leadObject.callBackDate =  Constants.formatter.format(DateTime.parse());

              SalesService salesService = SalesService();
              try {
                final value = await salesService.endLeadCall(
                    lead: widget.lead, empId: Constants.cec_employeeid);

                // Close loading dialog
                Navigator.pop(context);

                print(
                    "Call ended: ${widget.lead.onololeadid} ${value.success} ${value.message}");
                if (value.success == true &&
                    value.message == 'Call ended successfully') {
                  widget.lead.hangUpReason = selectedReason!.title;
                  widget.lead.hangUpDesc1 = selectedSubReason.toString();
                  setState(() {});

                  // Close the EndCallDialog
                  Navigator.pop(widget.context2);

                  // Close the FieldSalesAffinity screen and go to SalesAgentReport
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SalesAgentReport(refreshOnInit: true)),
                    (route) => false,
                  );
                }
              } catch (e) {
                // Close loading dialog in case of error
                Navigator.pop(context);
                // Handle error - you might want to show an error dialog here
                print("Error ending call: $e");
              }
            },
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }

  // -----------------------------------------------------------
  // REUSABLE UI COMPONENTS
  // -----------------------------------------------------------

  Widget _buildDropdown({
    required BuildContext context,
    required String? value,
    required List<String> items,
    required String hint,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      // Optional: set top/bottom padding to space the dropdown
      padding: const EdgeInsets.only(top: 14.0, bottom: 4.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          alignment: AlignmentDirectional.center,
          hint: Row(
            children: [
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  hint,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'YuGothic',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'YuGothic',
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          value: value,
          onChanged: onChanged,

          // --- Button styling (container around the selected value)
          buttonStyleData: ButtonStyleData(
            height: 45,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.black26),
              color: Colors.transparent,
            ),
            elevation: 0,
          ),

          // --- Icon styling (the arrow on the right)
          iconStyleData: const IconStyleData(
            icon: Icon(Icons.arrow_forward_ios_outlined),
            iconSize: 14,
            iconEnabledColor: Colors.black,
            iconDisabledColor: Colors.transparent,
          ),

          // --- Dropdown menu styling
          dropdownStyleData: DropdownStyleData(
            elevation: 0,
            maxHeight: 200,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
            ),
            offset: const Offset(-5, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all(6),
              thumbVisibility: MaterialStateProperty.all(true),
            ),
          ),

          // --- Individual menu item styling
          menuItemStyleData: MenuItemStyleData(
            overlayColor: null,
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildDateInput({
    required TextEditingController controller,
    required String label,
    FocusNode? focusNode,
  }) {
    return InkWell(
      onTap: () {
        _selectDate(context, controller);
      },
      child: CustomInputTransparent4(
        controller: controller,
        hintText: label,
        focusNode: FocusNode(),
        isEditable: false,
        textInputAction: TextInputAction.next,
        // We'll trigger the date picker on tap rather than onChanged
        onChanged: (val) {},
        prefix: Container(
          width: 45,
          height: 45,
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              bottomLeft: Radius.circular(32),
            ),
          ),
          child: Icon(
            CupertinoIcons.calendar,
            size: 18,
            color: Colors.white,
          ),
        ),
        onSubmitted: (String) {},
        isPasswordField: false,
      ),
    );
  }

  Widget _buildTimeInput() {
    return InkWell(
      onTap: () {
        _selectTime(context, _callBackTimeController);
      },
      child: CustomInputTransparent4(
        controller: _callBackTimeController,
        hintText: "Call Back Time",
        focusNode: _timeFocusNode,
        isPasswordField: false,
        isEditable: false,
        textInputAction: TextInputAction.next,
        // We'll trigger the time picker on tap rather than onChanged
        onChanged: (val) {},
        suffix: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(36),
              bottomRight: Radius.circular(36),
            ),
          ),
          child: const Icon(CupertinoIcons.time, size: 18, color: Colors.white),
        ),
        onSubmitted: (String) {},
      ),
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        constraints: const BoxConstraints(minWidth: 200),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: color,
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 13,
                letterSpacing: 0,
                fontWeight: FontWeight.w500,
                fontFamily: 'YuGothic',
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------------------
  // DATE/TIME PICKERS
  // -----------------------------------------------------------

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.format(context);
      });
    }
  }
}

class SubReason {
  final String title; // e.g. "Insurance Company" or "CSU Type"
  final List<String> options; // e.g. ["Old Mutual", "Discovery", ...]
  String? selectedOption; // user-chosen item

  SubReason({
    required this.title,
    required this.options,
    this.selectedOption,
  });
}

class EndCallReason {
  final String title; // e.g. "Incomplete", "Not Interested"
  final List<String> descriptions; // the sub-descriptions
  final List<SubReason>? subReasons; // optional nested subreason(s)

  // user-chosen sub-description
  String? selectedDescription;

  EndCallReason({
    required this.title,
    required this.descriptions,
    this.subReasons,
    this.selectedDescription,
  });
}
