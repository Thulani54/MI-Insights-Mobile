import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mi_insights/customwidgets/CustomCard.dart';
import 'package:mi_insights/screens/Sales%20Agent/universal_premium_calculator.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

import '../../../../constants/Constants.dart';
import '../../../../models/map_class.dart';
import '../../../models/Parlour.dart';
import '../../services/MyNoyifier.dart';
import 'field_premium_calculator.dart' show MemberPremium;

int activeQuoteStep = 0;
MyNotifier? myNotifier1;
final myConfirmPremiumClearValues = ValueNotifier<int>(0);
List<YesOrNoDialogue> dailogueList3 = [
  YesOrNoDialogue(stringValue: "Yes"),
  YesOrNoDialogue(stringValue: "No")
];

class ConfirmPremium extends StatefulWidget {
  const ConfirmPremium({
    super.key,
  });

  @override
  State<ConfirmPremium> createState() => _ConfirmPremiumState();
}

double TotalPayableAmount = 0.00;
double TotalBenefitAmountAmount = 0.00;
double TotalCoverAmount = 0.00;
bool isAtleastOnePolicyAccepted = false;

final List<Policy> policies = Constants.currentleadAvailable!.policies ?? [];

List<YesOrNoDialogue> dailogueList4 = [
  YesOrNoDialogue(stringValue: "Yes"),
  YesOrNoDialogue(stringValue: "No")
];

class _ConfirmPremiumState extends State<ConfirmPremium> {
  bool checkBoxValue3 = false;
  int expandedIndex = 0;
  int isTickMarked = 0;
  int hoverColor = -1;
  bool isTickMarked3 = false;
  bool checkBoxValue2 = false;
  bool checkBoxValue1 = false;
  bool checkBoxValue4 = false;
  bool checkBoxValue5 = false;
  bool boolColor2 = false;
  bool boolColor1 = false;
  bool boolColor3 = false;
  bool boolColor4 = false;
  bool isHover = false; //ParentsFuneral

  List<ConfirmPrem> testPremList = [
    ConfirmPrem(
        productName: "Individual Funeral",
        sumAssured: "R 0.00",
        premium: "R 0.00",
        isExpanded: false),
    ConfirmPrem(
        productName: "Family Funeral Rider",
        sumAssured: "R 0.00",
        premium: "R 0.00",
        isExpanded: false),
    ConfirmPrem(
        productName: "Additional Children Funeral (0)",
        sumAssured: "R 0.00",
        premium: "R 0.00",
        isExpanded: false),
    ConfirmPrem(
        productName: "Parents Funeral (0)",
        sumAssured: "R 0.00",
        premium: "R 0.00",
        isExpanded: false),
    ConfirmPrem(
        productName: "Extended Family Funeral (0)",
        sumAssured: "R 0.00",
        premium: "R 0.00",
        isExpanded: false),
    ConfirmPrem(
        productName: "Riders (0)",
        sumAssured: "R 0.00",
        premium: "R 0.00",
        isExpanded: false),
  ];
  List<ConfirmPrem> premList = [];

  // In your State class:
  Map<String, bool> expandedStates =
      {}; // Keyed by policy.reference or policy.id
  void refreshSelectionOptions() {
    bool nextStep = false;
    Constants.trueOrFalseStringValueJ = "";

    Constants.trueOrFalseStringValueL = "";
    dailogueList3[0].stateValue = false;
    dailogueList3[1].stateValue = false;

    dailogueList4[0].stateValue = false;
    dailogueList4[1].stateValue = false;

    // Properly initialize your loop variable i = 0
    for (int i = 0; i < Constants.currentleadAvailable!.policies.length; i++) {
      if (Constants.currentleadAvailable!.policies[i].quote.acceptPolicy ==
          "yes") {
        nextStep = true;
        break;
      }
    }
    isAtleastOnePolicyAccepted = nextStep;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text("Confirm Premium"),
            surfaceTintColor: Colors.white,
            shadowColor: Colors.black.withOpacity(0.65),

            //Back Button
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Material(
                      elevation: 12,
                      animationDuration: Duration(seconds: 5),
                      shadowColor: Colors.black.withOpacity(0.35),
                      surfaceTintColor: Colors.white,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Total Payable Amount : " +
                                  "R${(TotalPayableAmount + TotalBenefitAmountAmount).toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            Expanded(child: Container()),
                            SizedBox(
                              width: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      "You have taken cover at a total premium of " +
                          "R${(TotalPayableAmount + TotalBenefitAmountAmount).toStringAsFixed(2)}",
                      style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  // Policy Cards - Mobile Layout
                  for (var policy
                      in Constants.currentleadAvailable!.policies) ...[
                    // Policy Card
                    CustomCard(
                      elevation: 4,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Policy Header
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product Type Badge
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Constants.ftaColorLight,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    policiesSelectedProdTypes[Constants
                                        .currentleadAvailable!.policies
                                        .indexOf(policy)],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                                // Main Life Assured Name
                                Text(
                                  "${mainMembers[Constants.currentleadAvailable!.policies.indexOf(policy)].title} "
                                  "${mainMembers[Constants.currentleadAvailable!.policies.indexOf(policy)].name} "
                                  "${mainMembers[Constants.currentleadAvailable!.policies.indexOf(policy)].surname}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Constants.ftaColorLight,
                                  ),
                                ),
                                SizedBox(height: 8),
                                // Product Info
                                Text(
                                  "${policiesSelectedProducts[Constants.currentleadAvailable!.policies.indexOf(policy)]} (R${(policy.quote.sumAssuredFamilyCover ?? 0).toStringAsFixed(2)})",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Premium Details
                          Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                // Premium breakdown rows
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Additional Benefits:",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "R${TotalBenefitAmountAmount.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Constants.ftaColorLight,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Premium:",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "R${TotalPayableAmount.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Constants.ftaColorLight,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(height: 24, thickness: 1),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Monthly Premium:",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "R${(TotalPayableAmount + TotalBenefitAmountAmount).toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Constants.ftaColorLight,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                // Accept/Expand buttons row
                                Row(
                                  children: [
                                    // Accept Quote Button
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Constants.ctaColorLight,
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Accept Quote",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Transform.scale(
                                              scale: 1.2,
                                              child: Checkbox(
                                                fillColor:
                                                    MaterialStateProperty.all(
                                                        Colors.white),
                                                value: Constants
                                                        .currentleadAvailable!
                                                        .policies[Constants
                                                            .currentleadAvailable!
                                                            .policies
                                                            .indexOf(policy)]
                                                        .quote
                                                        .acceptPolicy ==
                                                    "yes",
                                                side: BorderSide(
                                                    color: Colors.white),
                                                activeColor:
                                                    Constants.ftaColorLight,
                                                checkColor:
                                                    Constants.ctaColorLight,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                onChanged: (bool? newValue) {
                                                  setState(() {
                                                    isTickMarked = 1;
                                                    final index = Constants
                                                        .currentleadAvailable!
                                                        .policies
                                                        .indexWhere((element) =>
                                                            element == policy);
                                                    checkBoxValue3 =
                                                        newValue ?? false;
                                                    if (checkBoxValue3) {
                                                      Constants
                                                          .currentleadAvailable!
                                                          .policies[index]
                                                          .quote
                                                          .acceptPolicy = "yes";
                                                    } else {
                                                      Constants
                                                          .currentleadAvailable!
                                                          .policies[index]
                                                          .quote
                                                          .acceptPolicy = "no";
                                                    }
                                                    refreshSelectionOptions();
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    // Expand button
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                            color: Constants.ctaColorLight),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            final ref = policy.reference;
                                            expandedStates[ref] =
                                                !(expandedStates[ref] ?? false);
                                          });
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              (expandedStates[
                                                          policy.reference] ??
                                                      false)
                                                  ? "Collapse"
                                                  : "Expand",
                                              style: TextStyle(
                                                color: Constants.ctaColorLight,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Icon(
                                              (expandedStates[
                                                          policy.reference] ??
                                                      false)
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: Constants.ctaColorLight,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Members Details Section (Expandable)
                          // Replace the placeholder section in your expandable area with this code:
                          if (expandedStates[policy.reference] ?? false)
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Lives Covered in Your Policy",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 16),

                                  // Main Life Assured
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    margin: EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: Constants.ftaColorLight
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Constants.ftaColorLight
                                              .withOpacity(0.3)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Constants.ftaColorLight,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                "Main Life Assured",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "${mainMembers[Constants.currentleadAvailable!.policies.indexOf(policy)].title} "
                                          "${mainMembers[Constants.currentleadAvailable!.policies.indexOf(policy)].name} "
                                          "${mainMembers[Constants.currentleadAvailable!.policies.indexOf(policy)].surname}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              "Cover Amount: ",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Text(
                                              "R${(policy.quote.sumAssuredFamilyCover ?? 0).toStringAsFixed(2)}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Constants.ftaColorLight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Spouse/Partner (if exists)
                                  if (policy.quote.partnerCovered == true)
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      margin: EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color:
                                                Colors.blue.withOpacity(0.3)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  "Partner",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            // You'll need to access spouse/partner details from your data structure
                                            "Spouse/Partner Details", // Replace with actual spouse/partner name
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                "Cover Amount: ",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              Text(
                                                "R${(policy.quote.partnerFuneralSumAssured ?? 0).toStringAsFixed(2)}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                  // Children (if any)
                                  if ((policy.quote.childrenCount ?? 0) > 0)
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      margin: EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color:
                                                Colors.green.withOpacity(0.3)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  "Children",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "${policy.quote.childrenCount} Children Covered",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                "Cover Amount (each): ",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              Text(
                                                "R${(policy.quote.childrenSumAssured ?? 0).toStringAsFixed(2)}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                  // Parents (if included)
                                  if (policy.quote.parentsInsured == true)
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      margin: EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.purple.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color:
                                                Colors.purple.withOpacity(0.3)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.purple,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  "Parents",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "Parent(s) Covered",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                "Cover Amount (each): ",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              Text(
                                                "R${(policy.quote.mainIsuredCover ?? 0).toStringAsFixed(2)}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.purple,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                  // Extended Family (if any)
                                  if (policy.quote.extendedFamilysInsured ==
                                      true)
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      margin: EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color:
                                                Colors.orange.withOpacity(0.3)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.orange,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  "Extended Family",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "Extended Family Member(s)",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                "Cover Amount (each): ",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              Text(
                                                "R${(policy.quote.mainIsuredCover ?? 0).toStringAsFixed(2)}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                  // Additional Riders (if any)
                                  if (policyPremiums[Constants
                                              .currentleadAvailable!.policies
                                              .indexOf(policy)]
                                          .selectedRidersDetail
                                          ?.isNotEmpty ==
                                      true)
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Colors.red.withOpacity(0.3)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  "Additional Riders",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          // Loop through selected riders
                                          ...policyPremiums[Constants
                                                  .currentleadAvailable!
                                                  .policies
                                                  .indexOf(policy)]
                                              .selectedRidersDetail!
                                              .map((rider) => Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 4),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            rider.riderName ??
                                                                "Additional Benefit",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          "R${(rider.premium ?? 0).toStringAsFixed(2)}",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ))
                                              .toList(),
                                        ],
                                      ),
                                    ),

                                  SizedBox(height: 12),

                                  // Total Summary
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Constants.ftaColorLight
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Constants.ftaColorLight),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Total Lives Covered:",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          "${1 + (policy.quote.partnerCovered == true ? 1 : 0) + (policy.quote.childrenCount ?? 0)}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Constants.ftaColorLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                  SizedBox(height: 16),
                  if (isAtleastOnePolicyAccepted == true)
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: StyledText(
                        text: "Is this affordable for you?",
                        tags: {
                          'bold': StyledTextTag(
                            style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              color: Colors.green,
                              //   fontFamily: 'YuGothic',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          'green': StyledTextTag(
                            style: TextStyle(
                              //   fontFamily: 'YuGothic',
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
                            ),
                          ),
                        },
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          //  fontFamily: 'YuGothic',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (isAtleastOnePolicyAccepted == true)
                    SizedBox(
                      height: 8,
                    ),
                  if (isAtleastOnePolicyAccepted == true)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Container(
                        height: 60,
                        child: ListView.builder(
                            itemCount: dailogueList3.length,
                            scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Container(
                                    height: 60,
                                    width: 120,
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                          width: 1.0,
                                          color: dailogueList3[index]
                                                      .stateValue ==
                                                  true
                                              ? Constants.ftaColorLight
                                              : Colors.grey.withOpacity(0.35)),
                                      color: Colors.transparent,
                                    ),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Transform.scale(
                                            scaleX: 1.7,
                                            scaleY: 1.7,
                                            child: Checkbox(
                                                value: dailogueList3[index]
                                                    .stateValue,
                                                side: BorderSide(
                                                  width: 1.4,
                                                  color:
                                                      Constants.ftaColorLight,
                                                ),
                                                activeColor:
                                                    Constants.ctaColorLight,
                                                checkColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            360)),
                                                onChanged: (newValue) {
                                                  dailogueList3[index]
                                                      .stateValue = newValue!;
                                                  setState(() {
                                                    for (int i = 0;
                                                        i <
                                                            dailogueList3
                                                                .length;
                                                        i++) {
                                                      if (i != index) {
                                                        dailogueList3[i]
                                                            .stateValue = false;
                                                        //Constants.trueOrFalseStringValue = dailogueList[i].stringValue;
                                                      } else {
                                                        dailogueList3[i]
                                                                .stateValue =
                                                            newValue!;
                                                        Constants
                                                                .trueOrFalseStringValueJ =
                                                            dailogueList3[i]
                                                                .stringValue;
                                                        Constants.isAffordable =
                                                            dailogueList3[i]
                                                                .stringValue;
                                                      }
                                                    }
                                                    print(
                                                        "hhhhhhhh ${Constants.trueOrFalseStringValue}");
                                                  });
                                                }),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            dailogueList3[index].stringValue,
                                            style: TextStyle(
                                                color: dailogueList3[index]
                                                            .stateValue ==
                                                        true
                                                    ? Constants.ftaColorLight
                                                    : Colors.grey
                                                        .withOpacity(0.35),
                                                fontSize: 18,
                                                fontFamily: 'YuGothic',
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  )
                                ],
                              );
                            }),
                      ),
                    ),
                  if (isAtleastOnePolicyAccepted == true)
                    SizedBox(
                      height: 32,
                    ),
                  (isAtleastOnePolicyAccepted == true &&
                          Constants.trueOrFalseStringValueJ.toLowerCase() ==
                              "yes")
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Constants.trueOrFalseStringValueJ == "Yes"
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, right: 16),
                                      child: FadeInLeftBig(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.linearToEaseOut,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            StyledText(
                                              text:
                                                  "Can I proceed in arranging this product(s) for you?",
                                              tags: {
                                                'bold': StyledTextTag(
                                                  style: TextStyle(
                                                    //fontWeight: FontWeight.bold,
                                                    color: Colors.green,
                                                    //   fontFamily: 'YuGothic',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                'green': StyledTextTag(
                                                  style: TextStyle(
                                                    //   fontFamily: 'YuGothic',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              },
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black,
                                                //  fontFamily: 'YuGothic',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            Container(
                                              height: 60,
                                              child: ListView.builder(
                                                  itemCount:
                                                      dailogueList4.length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Row(
                                                      children: [
                                                        Container(
                                                          height: 60,
                                                          width: 120,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16),
                                                            border: Border.all(
                                                                width: 1.0,
                                                                color: dailogueList4[index]
                                                                            .stateValue ==
                                                                        true
                                                                    ? Constants
                                                                        .ftaColorLight
                                                                    : Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.35)),
                                                            color: Colors
                                                                .transparent,
                                                          ),
                                                          child: Center(
                                                            child: Row(
                                                              children: [
                                                                Transform.scale(
                                                                  scaleX: 1.7,
                                                                  scaleY: 1.7,
                                                                  child: Checkbox(
                                                                      value: dailogueList4[index].stateValue,
                                                                      side: BorderSide(
                                                                        width:
                                                                            1.4,
                                                                        color: Constants
                                                                            .ftaColorLight,
                                                                      ),
                                                                      activeColor: Constants.ctaColorLight,
                                                                      checkColor: Colors.white,
                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(360)),
                                                                      onChanged: (newValue) {
                                                                        dailogueList4[index].stateValue =
                                                                            newValue!;
                                                                        setState(
                                                                            () {
                                                                          for (int i = 0;
                                                                              i < dailogueList4.length;
                                                                              i++) {
                                                                            if (i !=
                                                                                index) {
                                                                              dailogueList4[i].stateValue = false;
                                                                              //Constants.trueOrFalseStringValue = dailogueList[i].stringValue;
                                                                            } else {
                                                                              dailogueList4[i].stateValue = newValue!;
                                                                              Constants.trueOrFalseStringValueL = dailogueList4[i].stringValue;
                                                                              Constants.proceedProduct = dailogueList4[i].stringValue;
                                                                            }
                                                                          }
                                                                          print(
                                                                              "hhhhhhhh ${Constants.trueOrFalseStringValueL}");
                                                                        });
                                                                      }),
                                                                ),
                                                                SizedBox(
                                                                    width: 8),
                                                                Text(
                                                                  dailogueList4[
                                                                          index]
                                                                      .stringValue,
                                                                  style: TextStyle(
                                                                      color: dailogueList3[index]
                                                                                  .stateValue ==
                                                                              true
                                                                          ? Constants
                                                                              .ftaColorLight
                                                                          : Colors.grey.withOpacity(
                                                                              0.35),
                                                                      fontSize:
                                                                          18,
                                                                      fontFamily:
                                                                          'YuGothic',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 16,
                                                        )
                                                      ],
                                                    );
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 32,
                              ),
                              Constants.trueOrFalseStringValueL == "Yes"
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, right: 16),
                                      child: FadeInLeftBig(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.linearToEaseOut,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            StyledText(
                                              text: "Your total premium is " +
                                                  "R${(TotalPayableAmount + TotalBenefitAmountAmount).toStringAsFixed(2)}",
                                              tags: {
                                                'bold': StyledTextTag(
                                                  style: TextStyle(
                                                    //fontWeight: FontWeight.bold,
                                                    color: Colors.green,
                                                    //   fontFamily: 'YuGothic',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                'green': StyledTextTag(
                                                  style: TextStyle(
                                                    //   fontFamily: 'YuGothic',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              },
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                color: Constants.ctaColorLight,
                                                //  fontFamily: 'YuGothic',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                              Constants.trueOrFalseStringValueL == "No"
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                      ),
                                      child: Container(
                                        constraints:
                                            BoxConstraints(maxWidth: 700),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    border: Border.all(
                                                        color: Colors.grey)),
                                                height: 180,

                                                //width: 1000,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      height: 40,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 0,
                                                              right: 16),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        16),
                                                                topRight: Radius
                                                                    .circular(
                                                                        8)),
                                                        color: Colors.grey
                                                            .withOpacity(0.35),
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          12.0),
                                                              child: Text(
                                                                'Note!',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontFamily:
                                                                        'YuGothic',
                                                                    color: Constants
                                                                        .ftaColorLight,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        //height: 180,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 16,
                                                          right: 16,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          16),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          16)),
                                                          //color: Colors.grey
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              height: 16,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            16,
                                                                        right:
                                                                            16,
                                                                        bottom:
                                                                            16),
                                                                    child:
                                                                        StyledText(
                                                                      text:
                                                                          'Proceed to Handle Objections',
                                                                      tags: {
                                                                        'bold':
                                                                            StyledTextTag(
                                                                          style:
                                                                              TextStyle(
                                                                            //fontWeight: FontWeight.bold,
                                                                            color:
                                                                                Colors.green,
                                                                            //   fontFamily: 'YuGothic',
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                        'green':
                                                                            StyledTextTag(
                                                                          style:
                                                                              TextStyle(
                                                                            //   fontFamily: 'YuGothic',
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                Colors.green,
                                                                          ),
                                                                        ),
                                                                      },
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            18.0,
                                                                        color: Colors
                                                                            .black,
                                                                        //  fontFamily: 'YuGothic',
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 16,
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 24,
                                                                      right:
                                                                          24),
                                                              child: InkWell(
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  width: 190,
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              16,
                                                                          right:
                                                                              16),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            360),
                                                                    color: Constants
                                                                        .ftaColorLight,
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Handle Objections",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          fontFamily:
                                                                              'YuGothic',
                                                                          letterSpacing:
                                                                              0,
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  activeQuoteStep =
                                                                      1;
                                                                  setState(
                                                                      () {});
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        )
                      : Container(),
                  Constants.trueOrFalseStringValueJ == "No"
                      ? Container(
                          child: Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: Colors.grey)),
                                    height: 180,

                                    //width: 1000,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 40,
                                          padding: const EdgeInsets.only(
                                              left: 0, right: 16),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(16),
                                                    topRight:
                                                        Radius.circular(8)),
                                            color:
                                                Colors.grey.withOpacity(0.35),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12.0),
                                                  child: Text(
                                                    'Note!',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontFamily: 'YuGothic',
                                                        color: Constants
                                                            .ftaColorLight,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            //height: 180,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.only(
                                              left: 16,
                                              right: 16,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(16),
                                                  bottomRight:
                                                      Radius.circular(16)),
                                              //color: Colors.grey
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 16,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 16,
                                                                right: 16,
                                                                bottom: 16),
                                                        child: StyledText(
                                                          text:
                                                              'Proceed to Handle Objections',
                                                          tags: {
                                                            'bold':
                                                                StyledTextTag(
                                                              style: TextStyle(
                                                                //fontWeight: FontWeight.bold,
                                                                color: Colors
                                                                    .green,
                                                                //   fontFamily: 'YuGothic',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            'green':
                                                                StyledTextTag(
                                                              style: TextStyle(
                                                                //   fontFamily: 'YuGothic',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                          },
                                                          style: TextStyle(
                                                            fontSize: 18.0,
                                                            color: Colors.black,
                                                            //  fontFamily: 'YuGothic',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 16,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 24, right: 24),
                                                  child: InkWell(
                                                    child: Container(
                                                      height: 40,
                                                      width: 190,
                                                      padding: EdgeInsets.only(
                                                          left: 16, right: 16),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(360),
                                                        color: Constants
                                                            .ftaColorLight,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "Handle Objections",
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontFamily:
                                                                  'YuGothic',
                                                              letterSpacing: 0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      activeQuoteStep = 1;
                                                      setState(() {});
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),

                  // Confirm Premium Button
                  if (isAtleastOnePolicyAccepted == true &&
                      Constants.trueOrFalseStringValueJ == "Yes" &&
                      Constants.trueOrFalseStringValueL == "Yes")
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            // Add your confirm premium logic here
                            // This is where you'd typically navigate to the next step
                            // or submit the premium confirmation

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Premium Confirmed Successfully!'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );

                            // Example: Navigate back or to next screen
                            // Navigator.pop(context);
                            // or Navigator.pushNamed(context, '/next-screen');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.ftaColorLight,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle, size: 24),
                              SizedBox(width: 12),
                              Text(
                                'Confirm Premium',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  SizedBox(
                    height: 32,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    getPremiumsList();
    myNotifier1 = MyNotifier(myConfirmPremiumClearValues, context);
    /*myConfirmPremiumClearValues.addListener(() {
      if (Constants.currentleadAvailable != null) {
        for (final pol in Constants.currentleadAvailable!.policies) {
          expandedStates[pol.reference] = false; // start collapsed
          int index = Constants.currentleadAvailable!.policies.indexOf(pol);
          Constants.currentleadAvailable!.policies[index].quote.acceptPolicy =
              "no";

          print(
              "shgshjs1 $index ${Constants.currentleadAvailable!.policies[index].quote.acceptPolicy}");

          setState(() {});
        }
      }
      isAtleastOnePolicyAccepted = false;

      Constants.trueOrFalseStringValueJ = "";
      Constants.trueOrFalseStringValueL = "";
      dailogueList3[0].stateValue = false;
      dailogueList3[1].stateValue = false;

      dailogueList4[0].stateValue = false;
      dailogueList4[1].stateValue = false;
      setState(() {});
    });*/
  }

  getPremiumsList() {
    TotalPayableAmount = 0;
    TotalBenefitAmountAmount = 0;
    TotalCoverAmount = 0;
    premList = [];
    if (policyPremiums.isEmpty) {
      policyPremiums = List.generate(
          Constants.currentleadAvailable!.policies.length,
          (index) => CalculatePolicyPremiumResponse(
                cecClientId: Constants.cec_client_id,
                totalPremium: 0,
                joiningFee: 0.0,
                partnersDobs: [],
                memberPremiums: [
                  MemberPremium(
                      role: "",
                      age: 0,
                      rateId: 0,
                      premium: 0,
                      coverAmount: 0,
                      comment: "")
                ],
                reference: '',
                childrensDobs: [],
                extendedMembersDobs: [],
                selectedRidersIds: [],
                selectedRidersDetail: [],
                allRiders: [],
                allMainRates: [],
                applicableMainRates: [],
                applicableMRiders: [],
                errors: [],
                mainInsuredDob: '',
              ));
    }
    for (int i = 0; i < Constants.currentleadAvailable!.policies.length; i++) {
      TotalBenefitAmountAmount = policyPremiums[i].selectedRidersTotal ?? 0;
      premList.add(ConfirmPrem(
          productName:
              Constants.currentleadAvailable!.policies[i].quote.product,
          sumAssured: Constants
              .currentleadAvailable!.policies[i].quote.sumAssuredFamilyCover
              .toString(),
          premium: Constants
              .currentleadAvailable!.policies[i].quote.totalAmountPayable
              .toString(),
          isExpanded: false));
      if (Constants.currentleadAvailable!.policies[i].quote.totalAmountPayable
              .toString() !=
          "null") {
        TotalPayableAmount += Constants
            .currentleadAvailable!.policies[i].quote.totalAmountPayable!;
        TotalCoverAmount += Constants
            .currentleadAvailable!.policies[i].quote.sumAssuredFamilyCover!;
      }
    }

    setState(() {});
  }
}

class ConfirmPrem {
  String productName;
  String sumAssured;
  String premium;
  bool isExpanded;

  ConfirmPrem(
      {required this.productName,
      required this.sumAssured,
      required this.premium,
      required this.isExpanded});
}

class ParentsFuneral {
  int id;
  double sumAssured;
  String dateOfBirth;
  int age;
  double premium;

  ParentsFuneral(
      this.id, this.sumAssured, this.dateOfBirth, this.age, this.premium);
}

class Raiders {
  int id;
  String riderType;
  String memberType;
  String cover;
  double premium;

  Raiders(this.id, this.riderType, this.memberType, this.cover, this.premium);
}

const footnote =
    "A child means an unmarried, financially dependent biological Child of the Main Life Assured "
    "or Spouse who has not yet attained the age of 21 and will include a posthumous Child, a stepchild, "
    "a legally fostered Child and an adopted Child. All ages referred to in this Policy are Age Next Birthday. "
    "Cover will cease at the age of 23 years.";

class _TableHeaderCell extends StatelessWidget {
  final String text;

  const _TableHeaderCell({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ));
  }
}

class _TableDataCell extends StatelessWidget {
  final String text;

  const _TableDataCell({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
          ),
        ));
  }
}
