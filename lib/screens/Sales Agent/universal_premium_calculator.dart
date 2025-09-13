import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';

import '../../constants/Constants.dart';

import '../../customwidgets/CustomCard.dart';
import '../../models/Parlour.dart' hide BottomBar;
import '../../models/BottomBar.dart';
import '../../models/map_class.dart';
import '../../services/MyNoyifier.dart';
import '../../services/sales_service.dart';
import 'field_call_lead_dialog.dart';
import 'field_premium_calculator.dart'
    hide
        CalculatePolicyPremiumResponse,
        QuoteRates,
        InsurancePlan,
        BottomBar,
        Rider;
import 'newmemberdialog.dart';

int current_member_index = 0;
MyNotifier? myNotifier1;
final mySalesPremiumCalculatorValue = ValueNotifier<int>(0);
final mySalesPremiumCalculatorValue2 = ValueNotifier<int>(0);
final mySalesPremiumCalculatorValue3 = ValueNotifier<int>(0);
final mySalesPremiumCalculatorValue4 = ValueNotifier<int>(0);
final mySalesPremiumCalculatorValue5 = ValueNotifier<int>(0);
UniqueKey advancedMemberCardKey1 = UniqueKey();
UniqueKey advancedMemberCardKey2 = UniqueKey();
UniqueKey advancedMemberCardKey3 = UniqueKey();
UniqueKey advancedMemberCardKey4 = UniqueKey();
final myConfirmPremiumClearValues = ValueNotifier<int>(0);
final appBarMemberCardNotifier = ValueNotifier<int>(0);
MyNotifier? myNotifier2;
MyNotifier? myNotifier3;
MyNotifier? myNotifier4;
Map<int, String> _selectedCoverAmounts = {};
List<AdditionalMember> additionalMembers = [];
List<AdditionalMember> mainMembers = [];
List<String?> commencementDates = [];
List<List<int>> selectedRiderIds = [];
String? _selectedCommencement;
List<List<double>> policiescoverAmounts = [];
List<double> policiesSelectedCoverAmounts = [];
List<String> policiesSelectedProducts = [];
List<String> policiesSelectedProdTypes = [];
List<QuoteRates> allRates = [];
List<String> distinctProducts = [];
List<String> distinctProdTypes = [];
List<double> distinctCoverAmounts = [];
String? _selectedProdType;
double? _selectedCoverAmount;

int universalPremiumCalculatorActiveStep = 0;
List<QuoteRates> rates = [];
List<InsurancePlan> insurancePlans = [];
int? full_product_id = null;
QuoteRates? selectedProductRate;
bool isPolicyInforced = false;
List<String> policiesSelectedMainInsuredDOBs = [];
List<CalculatePolicyPremiumResponse> policyPremiums = [];
List<BottomBar> universalPremuimCalculatorBottomBarList = [
  BottomBar("Main Insured", "main_insured"),
  BottomBar("Partner", "partner"),
  BottomBar("Children", "children"),
  BottomBar("Parents/Extended Family", "extended_family"),
  //BottomBar("Cover", "cover"),
  BottomBar("Value Added Benefits", "benefits"),
];
List<Map<String, String>> steplist = [
  {'task': '1', 'content': "Main Insured"},
  {'task': '2', 'content': "Partner"},
  {'task': '3', 'content': "Children"},
  {'task': '4', 'content': "Parents/Extended Family"},
  {'task': '5', 'content': "Value Added Benefits"},
];
bool checkBoxValue1 = false;
bool checkBoxValue2 = false;
int changeColorIndex = 0;
int activeStep1 = -1;
String riders_filter = "main_member";
int riders_filter_member_id = 0;
final updateSalesStepsValueNotifier3 = ValueNotifier<int>(0);
String? selectedProduct = null;
String? selectedProductType = null;
double? selectedProductCoverAmount = null;

class UniversalPremiumCalculator extends StatefulWidget {
  const UniversalPremiumCalculator({super.key});

  @override
  State<UniversalPremiumCalculator> createState() =>
      _UniversalPremiumCalculatorState();
}

List<String> commencementList = [];

class _UniversalPremiumCalculatorState
    extends State<UniversalPremiumCalculator> {
  @override
  initState() {
    isPolicyInforced = false;
    if (Constants.currentleadAvailable != null &&
        Constants.currentleadAvailable!.policies.isNotEmpty &&
        Constants.currentleadAvailable!.policies.first.quote != null &&
        Constants.currentleadAvailable!.policies.first.quote.status != null &&
        Constants.currentleadAvailable!.policies.first.quote.status!
                .toLowerCase() ==
            "inforced") {
      isPolicyInforced = true;
      print("Policy is inforced: $isPolicyInforced");
    }

    if (policyPremiums.isEmpty) {
      policyPremiums = List.generate(
          Constants.currentleadAvailable!.policies.length,
          (index) => CalculatePolicyPremiumResponse(
                cecClientId: Constants.cec_client_id,
                totalPremium: 0,
                joiningFee: 0.0,
                mainInsuredDob: "",
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
              ));
    }
    if (policyPremiums.isEmpty) {
      policyPremiums.add(CalculatePolicyPremiumResponse(
        cecClientId: Constants.cec_client_id,
        mainInsuredDob: "",
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
      ));
    }
    getCommencementDates();
    updatePoliciesFromCurrentLead();
    obtainMainInsuredForEachPolicy();
    _buttonKeys = List.generate(
        universalPremuimCalculatorBottomBarList.length, (index) => GlobalKey());
    //onPolicyUpdated2(context, false);
    myNotifier1 = MyNotifier(mySalesPremiumCalculatorValue, context);
    mySalesPremiumCalculatorValue.addListener(() {
      print("gffgfg1");
      //updatePoliciesFromCurrentLead();
      //obtainMainInsuredForEachPolicy();

      if (mounted) onPolicyUpdated2(context, true);
      if (mounted) setState(() {});
    });
    myNotifier4 = MyNotifier(mySalesPremiumCalculatorValue4, context);
    mySalesPremiumCalculatorValue4.addListener(() {
      print("gffgfg4");
      //updatePoliciesFromCurrentLead();
      //obtainMainInsuredForEachPolicy();

      showNewPolicyDialogDialog(
          context, Constants.currentleadAvailable!.policies.length + 1);
      ;
    });
    // myNotifier2 = MyNotifier(mySalesPremiumCalculatorValue2, context);
    mySalesPremiumCalculatorValue2.addListener(() {
      if (mounted) setState(() {});
    });
    /*    myNotifier3 = MyNotifier(mySalesPremiumCalculatorValue3, context);
    mySalesPremiumCalculatorValue3.addListener(() {
      print("gffgfg1");
      //updatePoliciesFromCurrentLead();
      //obtainMainInsuredForEachPolicy();
      if (universalPremiumCalculatorActiveStep <
          universalPremuimCalculatorBottomBarList.length - 1)
        universalPremiumCalculatorActiveStep++;
    });*/

    fetchCommencementDates();
    super.initState();
  }

  void updatePoliciesFromCurrentLead() {
    // If no lead is loaded, do nothing.
    if (Constants.currentleadAvailable == null) return;

    // Clear out any previous values.
    policiesSelectedCoverAmounts.clear();
    commencementDates.clear();
    policiesSelectedProducts.clear();
    policiesSelectedProdTypes.clear();
    policiescoverAmounts.clear();
    policiesSelectedMainInsuredDOBs.clear();
    mainMembers.clear();

    // Get all policies from the current lead.
    final List<Policy> policies = Constants.currentleadAvailable!.policies;
    if (policies.isEmpty) return;

    // Loop through each policy.
    for (int i = 0; i < policies.length; i++) {
      final Policy policy = policies[i];
      final Quote quote = policy.quote;

      // === Update cover amount ===
      // (Adjust the field name as needed; here we use sumAssuredFamilyCover.)
      double coverAmount = quote.sumAssuredFamilyCover ?? 0.0;
      policiesSelectedCoverAmounts.add(coverAmount);

      // === Update commencement date ===
      // Use the premium payer’s commencementDate if available.
      String? commencement = (policy.quote.inceptionDate != null)
          ? Constants.formatter.format(policy.quote.inceptionDate!)
          : null;
      commencementDates.add(commencement);
      if (commencementList.length >= current_member_index) {
        if (commencementList[current_member_index].isEmpty) {
          commencementList[current_member_index] = commencement!;
        }
      }

      // === Update product and product type ===
      String product = quote.product ?? "";
      String prodType = quote.productType ?? "";
      policiesSelectedProducts.add(product);
      policiesSelectedProdTypes.add(prodType);
      print("dffggf ${quote.totalAmountPayable}");
      policyPremiums[i].totalPremium = quote.totalAmountPayable;
      //policyPremiums[i].totalPremium = quote.totalAmountPayable;
      setState(() {});

      // === Update cover amounts for dropdown ===
      // Filter the available main rates from the current parlour config.
      List<MainRate> filteredRates = Constants.currentParlourConfig!.mainRates
          .where((r) => r.product == product && r.prodType == prodType)
          .toList();
      // Gather distinct amounts and sort them.
      final Set<double> amountsSet = {};
      for (var rate in filteredRates) {
        amountsSet.add(rate.amount);
      }
      List<double> sortedAmounts = amountsSet.toList()..sort();
      policiescoverAmounts.add(sortedAmounts);

      // === Determine the Main Insured (and update mainMembers and DOB list) ===
      // Try to find a member whose type is 'main_member'.
      AdditionalMember? mainMember;
      String? mainInsuredDob;
      final List<dynamic> members = policy.members ?? [];

      for (var memberData in members) {
        // Parse memberData into a Member object.
        Member member = Member.fromJson(memberData);
        if (member.type?.toLowerCase() == "main_member") {
          // Look up the corresponding AdditionalMember using the additional_member_id.
          try {
            mainMember =
                Constants.currentleadAvailable!.additionalMembers.firstWhere(
              (am) => am.autoNumber == member.additionalMemberId,
            );
          } catch (e) {
            // If not found, you can choose to log or ignore.
            print(
                "No AdditionalMember found for main_member with additional_member_id ${member.additionalMemberId}");
          }
          if (mainMember != null && mainMember.dob.isNotEmpty) {
            try {
              // Format the DOB.
              DateTime dobDate = DateTime.parse(mainMember.dob);
              mainInsuredDob = DateFormat('yyyy-MM-dd').format(dobDate);
            } catch (e) {
              mainInsuredDob = mainMember.dob; // Fallback to raw string.
            }
          }
          break; // We only need the first main_member.
        }
      }
      // If a main member was found, add it; otherwise, use a default (for example, the first additional member).
      if (mainMember != null) {
        mainMembers.add(mainMember);
        policiesSelectedMainInsuredDOBs.add(mainInsuredDob ?? "");
      } else {
        if (Constants.currentleadAvailable!.additionalMembers.isNotEmpty) {
          AdditionalMember fallback =
              Constants.currentleadAvailable!.additionalMembers.first;
          mainMembers.add(fallback);
          policiesSelectedMainInsuredDOBs.add(fallback.dob.isNotEmpty
              ? DateFormat('yyyy-MM-dd').format(DateTime.parse(fallback.dob))
              : "");
        } else {
          // Otherwise, add empty placeholders.
          // mainMembers.add(null);
          policiesSelectedMainInsuredDOBs.add("");
        }
      }

      // Debug prints
      if (kDebugMode) {
        print("Updated cover amounts: $policiesSelectedCoverAmounts");
        print("Updated commencement dates: $commencementDates");
        print("Updated products: $policiesSelectedProducts");
        print("Updated product types: $policiesSelectedProdTypes");
        print("Updated main insured DOBs: $policiesSelectedMainInsuredDOBs");
      }

      // Trigger a UI update.
      setState(() {});
    }
  }

  void getCalculateRatesBody() {
    insurancePlans.clear();

    if (Constants.currentleadAvailable == null) {
      print("No current lead available => no InsurancePlan added.");
      return;
    }

    final List<Policy> policies =
        Constants.currentleadAvailable!.policies ?? [];
    if (policies.isEmpty) {
      print("No policies found => no InsurancePlan added.");
      return;
    }

    // Helper function to format DOB to YYYY-MM-DD format
    String formatDob(String? dob) {
      if (dob == null || dob.isEmpty) return "";

      // If it contains 'T', split and take the date part
      if (dob.contains("T")) {
        return dob.split("T").first;
      }

      // If it's already in YYYY-MM-DD format, return as is
      if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dob)) {
        return dob;
      }

      // Handle other date formats if needed
      try {
        DateTime parsedDate = DateTime.parse(dob);
        return "${parsedDate.year.toString().padLeft(4, '0')}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
      } catch (e) {
        print("Error parsing date: $dob");
        return dob; // Return original if parsing fails
      }
    }

    // Helper function: given a member entry of type Member, look up its AdditionalMember record.
    AdditionalMember? getAdditionalMemberForMember(Member m) {
      int autoNumber = m.autoNumber ?? -1;
      if (autoNumber == -1) return null;
      try {
        return Constants.currentleadAvailable!.additionalMembers
            .firstWhere((am) => am.autoNumber == autoNumber);
      } catch (e) {
        print("AdditionalMember not found for autoNumber: $autoNumber");
        return null;
      }
    }

    for (int i = 0; i < policies.length; i++) {
      final policy = policies[i];
      int policyIndex = i;
      Quote quote = policy.quote;

      String productName = quote.product ?? "";
      if (policiesSelectedProducts.length > policyIndex &&
          policiesSelectedProducts[policyIndex].isNotEmpty) {
        productName = policiesSelectedProducts[policyIndex];
      }

      String productType = quote.productType ?? "";
      if (policiesSelectedProdTypes.length > policyIndex &&
          policiesSelectedProdTypes[policyIndex].isNotEmpty) {
        productType = policiesSelectedProdTypes[policyIndex];
      }

      final String reference = quote.reference ?? "";
      double coverAmount = (policiesSelectedCoverAmounts.length > policyIndex)
          ? policiesSelectedCoverAmounts[policyIndex]
          : (quote.sumAssuredFamilyCover ?? 0.0);

      // Format main insured DOB properly
      String? mainInsuredDob =
          (policiesSelectedMainInsuredDOBs.length > policyIndex)
              ? formatDob(policiesSelectedMainInsuredDOBs[policyIndex])
              : null;
      for (var member
          in Constants.currentleadAvailable!.policies[policyIndex].members) {
        print("gfgghgh ${member}");
      }

      //AdditionalMember am = Constants.currentleadAvailable!.additionalMembers.firstWhere((am) => am.autoNumber == mainInsuredAutonumber);

      // Format the date from AdditionalMember properly
      mainInsuredDob = formatDob(mainInsuredDob);

      //print("fddgfghgh ${mainInsuredDob}");

      // -------------------------------------------------------------
      // Process Partners: DOBs and Cover Amounts
      // -------------------------------------------------------------
      List<String> partnerDobs = [];
      List<double> partnerCoverAmounts = [];
      {
        final List<dynamic> membersList = policy.members ?? [];
        List<Map<String, dynamic>> partnerMembersData = [];

        // Gather partner member data from the members list.
        for (var m in membersList) {
          if (m is Map<String, dynamic>) {
            bool isPartner =
                (m['type'] as String?)?.toLowerCase() == 'partner' &&
                    m['reference'] == reference;
            // Use the proper key for partner autoNumber
            int autoNumber = (m['additional_member_id'] as int?) ?? -1;
            if (isPartner && autoNumber != -1) {
              // Optionally, attach DOB from AdditionalMember
              try {
                AdditionalMember am = Constants
                    .currentleadAvailable!.additionalMembers
                    .firstWhere((am) => am.autoNumber == autoNumber);
                m["dob"] = am.dob;
              } catch (e) {
                print(
                    "Partner AdditionalMember not found for autoNumber: $autoNumber");
              }
              partnerMembersData.add(m);
            }
          }
        }

        // Deduplicate by autoNumber.
        Map<int, Map<String, dynamic>> partnerDedupeMap = {};
        for (var entry in partnerMembersData) {
          int autoNum =
              entry['additional_member_id'] ?? entry['autoNumber'] ?? -1;
          if (autoNum != -1) {
            partnerDedupeMap[autoNum] = entry;
          }
        }
        List<Map<String, dynamic>> finalPartnerData =
            partnerDedupeMap.values.toList();

        // Extract partner DOBs with proper formatting.
        partnerDobs = finalPartnerData
            .map((m) {
              String dob = m['dob'] as String? ?? "";
              return formatDob(dob);
            })
            .where((dob) => dob.isNotEmpty)
            .toList();

        // Extract partner cover amounts.
        partnerCoverAmounts = finalPartnerData.map((m) {
          return (m['cover'] as num?)?.toDouble() ?? 0.0;
        }).toList();
      }

      // -------------------------------------------------------------
      // Process Children: DOBs and Cover Amounts
      // -------------------------------------------------------------
      List<String> childrenDobs = [];
      List<double> childrenCoverAmounts = [];
      {
        final List<dynamic> membersList = policy.members ?? [];
        List<Map<String, dynamic>> childMembersData = [];

        // Gather child member data.
        for (var m in membersList) {
          if (m is Map<String, dynamic>) {
            bool isChild = (m['type'] as String?)?.toLowerCase() == 'child' &&
                m['reference'] == reference;

            int autoNumber = (m['additional_member_id'] as int?) ?? -1;
            if (isChild && autoNumber != -1) {
              AdditionalMember am = Constants
                  .currentleadAvailable!.additionalMembers
                  .firstWhere((am) => am.autoNumber == autoNumber);
              if (am != null) {
                childMembersData.add({
                  'dob': am.dob,
                  'cover_amount': m["cover"],
                  'autoNumber': am.autoNumber,
                });
              }

              print("dgffgfg ${isChild} ${childMembersData}");
            }
          } else if (m is Member) {
            bool isChild = (m.type ?? '').toLowerCase() == 'child' &&
                m.reference == reference;
            int autoNumber = m.autoNumber ?? -1;
            if (isChild && autoNumber != -1) {
              AdditionalMember? am = getAdditionalMemberForMember(m);
              if (am != null) {
                childMembersData.add({
                  'dob': am.dob,
                  'cover_amount': m.cover,
                  'autoNumber': am.autoNumber,
                });
              }
            }
          }
        }
        // Deduplicate child entries by autoNumber.
        Map<int, Map<String, dynamic>> childDedupeMap = {};
        for (var entry in childMembersData) {
          int autoNum = entry['autoNumber'] ?? -1;
          if (autoNum != -1) {
            childDedupeMap[autoNum] = entry;
          }
        }
        List<Map<String, dynamic>> finalChildData =
            childDedupeMap.values.toList();

        // Extract children DOBs with proper formatting.
        childrenDobs = finalChildData
            .map((m) {
              String dob = m['dob'] as String? ?? "";
              return formatDob(dob);
            })
            .where((dob) => dob.isNotEmpty)
            .toList();

        // Extract children cover amounts.
        childrenCoverAmounts = finalChildData.map((m) {
          return (m['cover_amount'] as num?)?.toDouble() ?? 0.0;
        }).toList();

        // Add user-selected children cover amounts.
        childrenCoverAmounts = childrenCoverAmounts.toSet().toList();
      }

      // -------------------------------------------------------------
      // Process Extended: DOBs and Cover Amounts
      // -------------------------------------------------------------
      List<String> extendedDobs = [];
      List<double> extendedCoverAmounts = [];
      {
        final List<dynamic> membersList = policy.members ?? [];
        List<Map<String, dynamic>> extendedMembersData = [];

        // Gather extended member data.
        for (var m in membersList) {
          if (m is Map<String, dynamic>) {
            bool isExtended =
                (m['type'] as String?)?.toLowerCase() == 'extended' &&
                    m['reference'] == reference;
            int autoNumber = (m['additional_member_id'] as int?) ?? -1;
            if (isExtended && autoNumber != -1) {
              // Optionally, attach DOB from AdditionalMember.
              try {
                AdditionalMember am = Constants
                    .currentleadAvailable!.additionalMembers
                    .firstWhere((am) => am.autoNumber == autoNumber);
                m["dob"] = am.dob;
              } catch (e) {
                print(
                    "Extended AdditionalMember not found for autoNumber: $autoNumber");
              }
              extendedMembersData.add(m);
            }
          } else if (m is Member) {
            bool isExtended = (m.type ?? '').toLowerCase() == 'extended' &&
                m.reference == reference;
            int autoNumber = m.autoNumber ?? -1;
            if (isExtended && autoNumber != -1) {
              AdditionalMember? am = getAdditionalMemberForMember(m);
              if (am != null) {
                extendedMembersData.add({
                  'dob': am.dob,
                  'cover_amount': m.cover,
                  'autoNumber': am.autoNumber,
                });
              }
            }
          }
        }
        // Deduplicate extended entries by autoNumber.
        Map<int, Map<String, dynamic>> extendedDedupeMap = {};
        for (var entry in extendedMembersData) {
          int autoNum =
              entry['additional_member_id'] ?? entry['autoNumber'] ?? -1;
          if (autoNum != -1) {
            extendedDedupeMap[autoNum] = entry;
          }
        }
        List<Map<String, dynamic>> finalExtendedData =
            extendedDedupeMap.values.toList();

        // Extract extended member DOBs with proper formatting.
        extendedDobs = finalExtendedData
            .map((m) {
              String dob = m['dob'] as String? ?? "";
              return formatDob(dob);
            })
            .where((dob) => dob.isNotEmpty)
            .toList();

        // Extract extended member cover amounts.
        extendedCoverAmounts = finalExtendedData.map((m) {
          return (m['cover'] as num?)?.toDouble() ?? 0.0;
        }).toList();
      }
      // Clear the selectedRiderIds list first.
      selectedRiderIds = [];

      // Ensure that selectedRiderIds has a sublist at index policyIndex.
      while (selectedRiderIds.length <= policyIndex) {
        selectedRiderIds.add([]);
      }

      for (var rider in policy.riders!) {
        print("Rider yiukj ${rider['id']}");
        if (rider['id'] != null) {
          selectedRiderIds[policyIndex].add(rider['id']);
        }
      }

      print("fghhj ${selectedRiderIds}");

      // -------------------------------------------------------------
      // Construct the InsurancePlan
      // -------------------------------------------------------------
      final plan = InsurancePlan(
        cecClientId: Constants.cec_client_id,
        reference: reference,
        product: productName,
        prodType: productType,
        coverAmount: coverAmount,
        mainInsuredDob: mainInsuredDob,
        partnersDobs: partnerDobs,
        partnersCoverAmounts: partnerCoverAmounts,
        childrensDobs: childrenDobs,
        childrensCoverAmounts: childrenCoverAmounts,
        extendedMembersDobs: extendedDobs,
        extendedMembersCoverAmounts: extendedCoverAmounts,
        selectedRiders: policyIndex < selectedRiderIds.length
            ? selectedRiderIds[policyIndex]
            : [],
        fullProductId: null,
      );
      insurancePlans.add(plan);

      // -------------------------------------------------------------
      // Rate Filtering Section (unchanged)
      // -------------------------------------------------------------
      String currentProduct = quote.product ?? "";
      String currentProductType = quote.productType ?? "";
      List<MainRate> filteredMainRates = Constants
          .currentParlourConfig!.mainRates
          .where((r) =>
              r.product == currentProduct && r.prodType == currentProductType)
          .toList();

      final Set<double> amountsSet = {};
      for (var r in filteredMainRates) {
        amountsSet.add(r.amount);
      }
      final List<double> sortedAmounts = amountsSet.toList()..sort();

      if (policiescoverAmounts.length <= policyIndex) {
        policiescoverAmounts.add(sortedAmounts);
      } else {
        policiescoverAmounts[policyIndex] = sortedAmounts;
      }

      print(
          "Policy index $policyIndex: Updated premium from quote: ${quote.totalAmountPayable}");
    }

    print("InsurancePlans => ${insurancePlans.length} plans added.");
    if (insurancePlans.isNotEmpty) {
      //if (insurancePlans.length > 0)
      // print("First plan: ${jsonDecode(insurancePlans[0].toJson().toString())}");
    }
  }

  void obtainMainInsuredForEachPolicy() {
    if (Constants.currentleadAvailable != null) {
      final List<Policy> policies =
          Constants.currentleadAvailable!.policies ?? [];

      // Clear any existing data to avoid duplicates
      mainMembers.clear();

      // Loop through each policy
      for (var policy in policies) {
        final members = policy.members ?? [];
        print("Found members: ${members.length} $members");

        // Find the main member for this policy
        final mainMemberData = members.firstWhere(
          (m) => m["type"]?.toLowerCase() == "main_member",
          orElse: () => null,
        );

        if (mainMemberData != null) {
          Member mainMember = Member.fromJson(mainMemberData);

          // Match with the corresponding AdditionalMember, if exists
          AdditionalMember? additionalMember =
              Constants.currentleadAvailable!.additionalMembers.firstWhere(
            (am) => am.autoNumber == mainMember.additionalMemberId,
            orElse: () => AdditionalMember(
                memberType: "self",
                autoNumber: 0,
                id: "",
                contact: "-",
                dob: "",
                gender: "",
                name: "",
                surname: "",
                title: "",
                onololeadid: 0,
                altContact: "",
                email: "",
                percentage: 0,
                maritalStatus: "",
                relationship: "",
                mipCover: "",
                mipStatus: "",
                updatedBy: 0,
                memberQueryType: "",
                memberQueryTypeOldNew: "",
                memberQueryTypeOldAutoNumber: "",
                membersAutoNumber: "",
                sourceOfIncome: "",
                sourceOfWealth: "",
                otherUnknownIncome: "",
                otherUnknownWealth: "",
                timestamp: "",
                lastUpdate: ""),
          );

          String thisMonth = Constants.formatter
              .format(DateTime(DateTime.now().year, DateTime.now().month, 1));
          commencementDates.add(null);
          selectedRiderIds.add([]);
          mainMembers.add(additionalMember);
          policiesSelectedMainInsuredDOBs.add(additionalMember.dob);
          print("Main Member Added: ${additionalMember.autoNumber}");

          // Extract and add DOB if available
          if (mainMemberData["dob"] != null &&
              mainMemberData["dob"].toString().isNotEmpty) {
            policiesSelectedMainInsuredDOBs
                .add(mainMemberData["dob"].toString().split("T").first);
          }
        } else {
          print("No main member found for Policy: ${policy.reference}");

          mainMembers
              .add(Constants.currentleadAvailable!.additionalMembers.first);
          if (Constants.currentleadAvailable != null) {}
        }
      }

      print("Total Main Members Found: ${mainMembers.length}");

      // Single UI update after processing
      setState(() {});
    } else {
      print("No current lead available.");
    }
    //  onPolicyUpdated();
  }

  Future<void> onPolicyUpdated2(context, showError) async {
    //  getCalculateRatesBody();

    List<CalculatePolicyPremiumResponse> premiumResponses =
        await calculatePolicyPremiumCal(showError);

    print("gfghhg2 ${premiumResponses.length}");
    SalesService salesService = SalesService();
    if (Constants.currentleadAvailable != null) {
      setState(() {});
      salesService.updateLeadPoliciesWithPremiumResponse(
          Constants.currentleadAvailable!,
          premiumResponses,
          insurancePlans,
          false,
          context);
    }

    onPolicyUpdated();
  }

  Future<List<CalculatePolicyPremiumResponse>> calculatePolicyPremiumCal(
      bool showError) async {
    policyPremiums.clear();
    policiescoverAmounts.clear();
    // 1) Make sure we have the up-to-date insurancePlans
    getCalculateRatesBody(); // This populates `insurancePlans`

    // 2) If nothing populated, return empty
    if (insurancePlans.isEmpty) {
      print("No insurance plans => returning empty list");
      return [];
    }

    //final url = Uri.parse('${Constants.parlourConfigBaseUrl}parlour-config/calculate_parlour_rates/',);
    final url = Uri.parse(
      '${Constants.parlourConfigBaseUrl}parlour-config/calculate_parlour_rates/',
    );

    final List<CalculatePolicyPremiumResponse> results = [];

    // Process each insurance plan individually.
    for (int index = 0; index < insurancePlans.length; index++) {
      final plan = insurancePlans[index];

      final Map<String, dynamic> requestBody = plan.toJson();
      print("Sending request for plan2a $url $index: $requestBody");

      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(requestBody),
        );
        print("gfghhg1 ${response.body}");

        if (response.statusCode == 200 || response.statusCode == 400) {
          final responseJson = json.decode(response.body);

          // Expecting a Map response for a single plan
          CalculatePolicyPremiumResponse parsed =
              CalculatePolicyPremiumResponse.fromJson(responseJson);

          results.add(parsed);

          // Check if there are errors for this policy
          bool hasErrors = parsed.errors.isNotEmpty;

          if (hasErrors) {
            print("🚨 Errors found for policy $index: ${parsed.errors}");
            // Reset all members' premium and cover to 0 for this policy
            //  _resetMembersForPolicy(index);
          }

          if (policyPremiums.length > index) {
            policyPremiums[index] = parsed;
            policyPremiums[index].selectedRidersTotal =
                0.0; // Ensure it's a double

            // FIX: Use 'index' instead of 'current_member_index' to access the correct policy
            if (Constants.currentleadAvailable!.policies.length > index &&
                Constants.currentleadAvailable!.policies[index].riders !=
                    null) {
              // Iterate over all riders in the current policy (using correct index)
              for (var rider
                  in Constants.currentleadAvailable!.policies[index].riders!) {
                var riderPremium = rider["premium"];
                if (riderPremium != null) {
                  // Convert riderPremium to double if necessary.
                  double premiumValue;
                  if (riderPremium is num) {
                    premiumValue = riderPremium.toDouble();
                  } else {
                    premiumValue =
                        double.tryParse(riderPremium.toString()) ?? 0.0;
                  }
                  policyPremiums[index].selectedRidersTotal =
                      (policyPremiums[index].selectedRidersTotal ?? 0.0) +
                          premiumValue;
                }
              }
            }
            print("ghhg ${policyPremiums[index].selectedRidersTotal}");

            // Only process member premiums if there are no errors
            if (!hasErrors) {
              // Process member premiums for the current policy index
              final parsedResponse =
                  parsed; // The newly calculated data for this policy
              print(
                  "Parsed response for plan3 $index: ${parsed.memberPremiums.toString()}");

              // FIX: Use 'index' instead of 'policyIndex' loop variable to access the correct policy
              final membersList =
                  Constants.currentleadAvailable!.policies[index].members ?? [];

              // Helper function to get the main member's cover value.
              double getMainCover() {
                for (var m in parsed.memberPremiums) {
                  if ((m.role ?? '').toLowerCase() == 'main_insured') {
                    return m.coverAmount;
                  }
                }
                return 0.0;
              }

              print("=== DEBUGGING MEMBERS LIST FOR POLICY $index ===");
              for (int i = 0; i < membersList.length; i++) {
                var m = membersList[i];
                if (m is Map<String, dynamic>) {
                  print(
                      "Member $i (Map): type=${m['type']}, premium=${m['premium']}, cover=${m['cover']}, reference=${m['reference']}");
                } else if (m is Member) {
                  print(
                      "Member $i (Object): type=${m.type}, premium=${m.premium}, cover=${m.cover}, reference=${m.reference}");
                }
              }
              print("===============================");

              // Loop over each MemberPremium in the new data.
              for (final newPrem in parsedResponse.memberPremiums) {
                final rawRole = newPrem.role.toLowerCase();
                double newPremiumValue = newPrem.premium ?? 0.0;
                double newCoverValue = newPrem.coverAmount;

                print("=== Processing Premium Assignment ===");
                print("Role: $rawRole");
                print("Premium: $newPremiumValue");
                print("Cover: $newCoverValue");
                print("Age: ${newPrem.age}");
                print("Comment: ${newPrem.comment}");

                if (newCoverValue == 0) {
                  newCoverValue = getMainCover();
                }
                if (parsed.totalPremium == 0) {
                  newPremiumValue = 0;
                }

                // Parse baseRole & suffix (if any)
                String baseRole = rawRole;
                int suffixIndex = 1;

                if (rawRole.contains('_')) {
                  final parts = rawRole.split('_');
                  baseRole = parts[0];
                  suffixIndex = int.tryParse(parts[1]) ?? 1;
                }

                print("BaseRole: $baseRole, SuffixIndex: $suffixIndex");

                bool memberUpdated = false;

                if (baseRole == 'main_insured' || baseRole == 'main') {
                  print("🔍 Looking for main_member...");

                  for (var m in membersList) {
                    String memberType;
                    if (m is Map<String, dynamic>) {
                      memberType = (m['type'] ?? '').toString().toLowerCase();
                    } else if (m is Member) {
                      memberType = (m.type ?? '').toLowerCase();
                    } else {
                      continue;
                    }

                    if (memberType == 'main_member') {
                      print(
                          "✅ Found main_member! Updating premium from ${m is Map ? m['premium'] : (m as Member).premium} to $newPremiumValue");

                      if (m is Map<String, dynamic>) {
                        m['premium'] = newPremiumValue;
                        m['cover'] = newCoverValue;
                        if (m['percentage'] == null) {
                          m['percentage'] = 0;
                        }

                        try {
                          SalesService salesService = SalesService();
                          await salesService.updateMember2(context, m);
                          memberUpdated = true;
                          print(
                              "✅ Successfully updated main_member in database");
                        } catch (e) {
                          print("❌ Error updating main_member in database: $e");
                        }
                      } else if (m is Member) {
                        m.premium = newPremiumValue;
                        m.cover = newCoverValue;
                        memberUpdated = true;
                        print("✅ Successfully updated main_member object");
                      }
                      break; // Exit loop once found
                    }
                  }
                } else if (baseRole == 'partner') {
                  print("🔍 Looking for partner members...");

                  // Gather all "partner" members
                  final partnerList = <dynamic>[];
                  for (var m in membersList) {
                    String memberType;
                    if (m is Map<String, dynamic>) {
                      memberType = (m['type'] ?? '').toString().toLowerCase();
                    } else if (m is Member) {
                      memberType = (m.type ?? '').toLowerCase();
                    } else {
                      continue;
                    }
                    if (memberType == 'partner') {
                      partnerList.add(m);
                    }
                  }

                  print("Found ${partnerList.length} partner(s)");

                  // Convert to 0-based index
                  final zeroBased = suffixIndex - 1;

                  if (zeroBased >= 0 && zeroBased < partnerList.length) {
                    final target = partnerList[zeroBased];
                    double coverToSet = newCoverValue;
                    if (coverToSet == 0 || coverToSet == 0.0) {
                      coverToSet = getMainCover();
                    }

                    print(
                        "✅ Updating partner $zeroBased with premium: $newPremiumValue");

                    if (target is Map<String, dynamic>) {
                      print("Previous premium: ${target['premium']}");
                      target['premium'] = newPremiumValue;
                      target['cover'] = coverToSet;
                      if (target['percentage'] == null) {
                        target['percentage'] = 0;
                      }

                      try {
                        SalesService salesService = SalesService();
                        await salesService.updateMember2(context, target);
                        memberUpdated = true;
                        print("✅ Successfully updated partner in database");
                      } catch (e) {
                        print("❌ Error updating partner in database: $e");
                      }
                    } else if (target is Member) {
                      print("Previous premium: ${target.premium}");
                      target.premium = newPremiumValue;
                      target.cover = coverToSet;
                      memberUpdated = true;
                      print("✅ Successfully updated partner object");
                    }
                  } else {
                    print(
                        "❌ Partner index $zeroBased out of range (0-${partnerList.length - 1})");
                  }
                } else if (baseRole == 'child') {
                  print("🔍 Looking for child members...");

                  // Gather all "child" members
                  final childList = <dynamic>[];
                  for (var m in membersList) {
                    String memberType;
                    if (m is Map<String, dynamic>) {
                      memberType = (m['type'] ?? '').toString().toLowerCase();
                    } else if (m is Member) {
                      memberType = (m.type ?? '').toLowerCase();
                    } else {
                      continue;
                    }
                    if (memberType == 'child') {
                      childList.add(m);
                    }
                  }

                  print("Found ${childList.length} child(ren)");

                  final zeroBased = suffixIndex - 1;
                  if (zeroBased >= 0 && zeroBased < childList.length) {
                    final target = childList[zeroBased];
                    double coverToSet = newCoverValue;
                    if (coverToSet == 0 || coverToSet == 0.0) {
                      coverToSet = getMainCover();
                    }

                    print(
                        "✅ Updating child $zeroBased with premium: $newPremiumValue");

                    if (target is Map<String, dynamic>) {
                      print("Previous premium: ${target['premium']}");
                      target['premium'] = newPremiumValue;
                      target['cover'] = coverToSet;
                      if (target['percentage'] == null) {
                        target['percentage'] = 0;
                      }

                      try {
                        SalesService salesService = SalesService();
                        await salesService.updateMember2(context, target);
                        memberUpdated = true;
                        print("✅ Successfully updated child in database");
                      } catch (e) {
                        print("❌ Error updating child in database: $e");
                      }
                    } else if (target is Member) {
                      print("Previous premium: ${target.premium}");
                      target.premium = newPremiumValue;
                      target.cover = coverToSet;
                      memberUpdated = true;
                      print("✅ Successfully updated child object");
                    }
                  } else {
                    print(
                        "❌ Child index $zeroBased out of range (0-${childList.length - 1})");
                  }
                } else if (baseRole == 'extended') {
                  print("🔍 Looking for extended members...");

                  // Gather all "extended" members
                  final extendedList = <dynamic>[];
                  for (var m in membersList) {
                    String memberType;
                    if (m is Map<String, dynamic>) {
                      memberType = (m['type'] ?? '').toString().toLowerCase();
                    } else if (m is Member) {
                      memberType = (m.type ?? '').toLowerCase();
                    } else {
                      continue;
                    }
                    if (memberType == 'extended') {
                      extendedList.add(m);
                    }
                  }

                  print("Found ${extendedList.length} extended member(s)");

                  final zeroBased = suffixIndex - 1;
                  if (zeroBased >= 0 && zeroBased < extendedList.length) {
                    final target = extendedList[zeroBased];
                    double coverToSet = newCoverValue;
                    if (coverToSet == 0 || coverToSet == 0.0) {
                      coverToSet = getMainCover();
                    }

                    print(
                        "✅ Updating extended member $zeroBased with premium: $newPremiumValue");

                    if (target is Map<String, dynamic>) {
                      print("Previous premium: ${target['premium']}");
                      target['premium'] = newPremiumValue;
                      target['cover'] = coverToSet;
                      if (target['percentage'] == null) {
                        target['percentage'] = 0;
                      }

                      try {
                        SalesService salesService = SalesService();
                        await salesService.updateMember2(context, target);
                        memberUpdated = true;
                        print(
                            "✅ Successfully updated extended member in database");
                      } catch (e) {
                        print(
                            "❌ Error updating extended member in database: $e");
                      }
                    } else if (target is Member) {
                      print("Previous premium: ${target.premium}");
                      target.premium = newPremiumValue;
                      target.cover = coverToSet;
                      memberUpdated = true;
                      print("✅ Successfully updated extended member object");
                    }
                  } else {
                    print(
                        "❌ Extended member index $zeroBased out of range (0-${extendedList.length - 1})");
                  }
                }

                if (!memberUpdated) {
                  print("❌ WARNING: No member updated for role: $rawRole");
                  print("Available member types:");
                  for (var m in membersList) {
                    if (m is Map<String, dynamic>) {
                      print("  - Map member: type=${m['type']}");
                    } else if (m is Member) {
                      print("  - Member object: type=${m.type}");
                    }
                  }
                }
                print("=== End Processing $rawRole ===\n");
              } // end: for each newPrem in parsedResponse.memberPremiums

              print("=== FINAL MEMBERS STATE FOR POLICY $index ===");
              for (int i = 0; i < membersList.length; i++) {
                var m = membersList[i];
                if (m is Map<String, dynamic>) {
                  print(
                      "Final Member $i (Map): type=${m['type']}, premium=${m['premium']}, cover=${m['cover']}");
                } else if (m is Member) {
                  print(
                      "Final Member $i (Object): type=${m.type}, premium=${m.premium}, cover=${m.cover}");
                }
              }
              print("===============================");
            } else {
              print(
                  "⚠️ Skipping member premium processing for policy $index due to errors");
            }
          } else {
            policyPremiums.add(parsed);
            policyPremiums[index].selectedRidersTotal =
                0.0; // Ensure it's a double

            // FIX: Use 'index' instead of 'current_member_index' to access the correct policy
            if (Constants.currentleadAvailable!.policies.length > index &&
                Constants.currentleadAvailable!.policies[index].riders !=
                    null) {
              // Iterate over all riders in the current policy (using correct index)
              for (var rider
                  in Constants.currentleadAvailable!.policies[index].riders!) {
                var riderPremium = rider["premium"];
                if (riderPremium != null) {
                  // Convert riderPremium to double if necessary.
                  double premiumValue;
                  if (riderPremium is num) {
                    premiumValue = riderPremium.toDouble();
                  } else {
                    premiumValue =
                        double.tryParse(riderPremium.toString()) ?? 0.0;
                  }
                  policyPremiums[index].selectedRidersTotal =
                      (policyPremiums[index].selectedRidersTotal ?? 0.0) +
                          premiumValue;
                }
              }
            }
            print("ghhg ${policyPremiums[index].selectedRidersTotal}");

            // Only process member premiums if there are no errors
            if (!hasErrors) {
              // Process member premiums for the current policy index when adding new policy
              final parsedResponse = parsed;
              final membersList =
                  Constants.currentleadAvailable!.policies[index].members ?? [];

              // Helper function to get the main member's cover value.
              double getMainCover() {
                for (var m in parsed.memberPremiums) {
                  if ((m.role ?? '').toLowerCase() == 'main_insured') {
                    return m.coverAmount;
                  }
                }
                return 0.0;
              }

              // Process member premiums for newly added policies too
              for (final newPrem in parsedResponse.memberPremiums) {
                final rawRole = newPrem.role.toLowerCase();
                double newPremiumValue = newPrem.premium ?? 0.0;
                double newCoverValue = newPrem.coverAmount;

                if (newCoverValue == 0) {
                  newCoverValue = getMainCover();
                }
                if (parsed.totalPremium == 0) {
                  newPremiumValue = 0;
                }

                String baseRole = rawRole;
                int suffixIndex = 1;

                if (rawRole.contains('_')) {
                  final parts = rawRole.split('_');
                  baseRole = parts[0];
                  suffixIndex = int.tryParse(parts[1]) ?? 1;
                }

                if (baseRole == 'main_insured' || baseRole == 'main') {
                  for (var m in membersList) {
                    String memberType;
                    if (m is Map<String, dynamic>) {
                      memberType = (m['type'] ?? '').toString().toLowerCase();
                    } else if (m is Member) {
                      memberType = (m.type ?? '').toLowerCase();
                    } else {
                      continue;
                    }

                    if (memberType == 'main_member') {
                      if (m is Map<String, dynamic>) {
                        m['premium'] = newPremiumValue;
                        m['cover'] = newCoverValue;
                        if (m['percentage'] == null) {
                          m['percentage'] = 0;
                        }

                        try {
                          SalesService salesService = SalesService();
                          await salesService.updateMember2(context, m);
                        } catch (e) {
                          print("Error updating main_member: $e");
                        }
                      } else if (m is Member) {
                        m.premium = newPremiumValue;
                        m.cover = newCoverValue;
                      }
                      break;
                    }
                  }
                } else if (baseRole == 'partner') {
                  final partnerList = <dynamic>[];
                  for (var m in membersList) {
                    String memberType;
                    if (m is Map<String, dynamic>) {
                      memberType = (m['type'] ?? '').toString().toLowerCase();
                    } else if (m is Member) {
                      memberType = (m.type ?? '').toLowerCase();
                    } else {
                      continue;
                    }
                    if (memberType == 'partner') {
                      partnerList.add(m);
                    }
                  }

                  final zeroBased = suffixIndex - 1;
                  if (zeroBased >= 0 && zeroBased < partnerList.length) {
                    final target = partnerList[zeroBased];
                    double coverToSet = newCoverValue;
                    if (coverToSet == 0 || coverToSet == 0.0) {
                      coverToSet = getMainCover();
                    }

                    if (target is Map<String, dynamic>) {
                      target['premium'] = newPremiumValue;
                      target['cover'] = coverToSet;
                      if (target['percentage'] == null) {
                        target['percentage'] = 0;
                      }
                      try {
                        SalesService salesService = SalesService();
                        await salesService.updateMember2(context, target);
                      } catch (e) {
                        print("Error updating partner: $e");
                      }
                    } else if (target is Member) {
                      target.premium = newPremiumValue;
                      target.cover = coverToSet;
                    }
                  }
                } else if (baseRole == 'child') {
                  final childList = <dynamic>[];
                  for (var m in membersList) {
                    String memberType;
                    if (m is Map<String, dynamic>) {
                      memberType = (m['type'] ?? '').toString().toLowerCase();
                    } else if (m is Member) {
                      memberType = (m.type ?? '').toLowerCase();
                    } else {
                      continue;
                    }
                    if (memberType == 'child') {
                      childList.add(m);
                    }
                  }

                  final zeroBased = suffixIndex - 1;
                  if (zeroBased >= 0 && zeroBased < childList.length) {
                    final target = childList[zeroBased];
                    double coverToSet = newCoverValue;
                    if (coverToSet == 0 || coverToSet == 0.0) {
                      coverToSet = getMainCover();
                    }

                    if (target is Map<String, dynamic>) {
                      target['premium'] = newPremiumValue;
                      target['cover'] = coverToSet;
                      if (target['percentage'] == null) {
                        target['percentage'] = 0;
                      }
                      try {
                        SalesService salesService = SalesService();
                        await salesService.updateMember2(context, target);
                      } catch (e) {
                        print("Error updating child: $e");
                      }
                    } else if (target is Member) {
                      target.premium = newPremiumValue;
                      target.cover = coverToSet;
                    }
                  }
                } else if (baseRole == 'extended') {
                  final extendedList = <dynamic>[];
                  for (var m in membersList) {
                    String memberType;
                    if (m is Map<String, dynamic>) {
                      memberType = (m['type'] ?? '').toString().toLowerCase();
                    } else if (m is Member) {
                      memberType = (m.type ?? '').toLowerCase();
                    } else {
                      continue;
                    }
                    if (memberType == 'extended') {
                      extendedList.add(m);
                    }
                  }

                  final zeroBased = suffixIndex - 1;
                  if (zeroBased >= 0 && zeroBased < extendedList.length) {
                    final target = extendedList[zeroBased];
                    double coverToSet = newCoverValue;
                    if (coverToSet == 0 || coverToSet == 0.0) {
                      coverToSet = getMainCover();
                    }

                    if (target is Map<String, dynamic>) {
                      target['premium'] = newPremiumValue;
                      target['cover'] = coverToSet;
                      if (target['percentage'] == null) {
                        target['percentage'] = 0;
                      }
                      try {
                        SalesService salesService = SalesService();
                        await salesService.updateMember2(context, target);
                      } catch (e) {
                        print("Error updating extended member: $e");
                      }
                    } else if (target is Member) {
                      target.premium = newPremiumValue;
                      target.cover = coverToSet;
                    }
                  }
                }
              }
            } else {
              print(
                  "⚠️ Skipping member premium processing for newly added policy $index due to errors");
            }
          }

          // Ensure policiescoverAmounts has a slot for this index.
          while (policiescoverAmounts.length <= index) {
            policiescoverAmounts.add([]);
          }

          // Gather and filter rates for this policy.
          final List<QuoteRates> theseRates = parsed.allMainRates;

          // FIX: Add bounds checking before accessing policiesSelectedProducts
          String currentProduct = "";
          String currentProductType = "";

          if (policiesSelectedProducts.length > index) {
            currentProduct = policiesSelectedProducts[index];
          }
          if (policiesSelectedProdTypes.length > index) {
            currentProductType = policiesSelectedProdTypes[index];
          }

          List<QuoteRates> prodTypeFilteredRates = theseRates
              .where((r) =>
                  r.product == currentProduct &&
                  r.prodType == currentProductType)
              .toList();

          // Collect and sort unique amounts.
          final Set<double> allAmounts = {};
          for (var r in prodTypeFilteredRates) {
            allAmounts.add(r.amount);
          }
          final sortedAmounts = allAmounts.toList()..sort();
          policiescoverAmounts[index] = sortedAmounts;
        } else {
          print(
              "Error: HTTP ${response.statusCode} for plan $index, body: ${response.body}");
        }
      } catch (e) {
        print("Exception for plan $index: $e");
      }
    }

    // Callback after processing all policies.
    onPolicyUpdated();

    // Force UI update after all premiums are assigned
    setState(() {});

    // Show an error dialog if there are errors in the current policy.
    if (kDebugMode) {
      print("fgghgh  ${mainMembers.length} $current_member_index");
      if (policyPremiums.length > current_member_index) {
        print("Errors: ${policyPremiums[current_member_index].errors}");
      }
    }

    if (policyPremiums.isNotEmpty && // Add check: policyPremiums might be empty
        current_member_index <
            policyPremiums.length && // Add check: index might be out of bounds
        policyPremiums[current_member_index].errors.isNotEmpty &&
        mainMembers.isNotEmpty) {
      // Get the list of errors
      List<String> errorMessages =
          policyPremiums[current_member_index].errors.toSet().toList();
      if (mainMembers[current_member_index].id.isEmpty) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              title: Text(
                'Warning', // Or maybe "Errors Found"?
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.red), // Make title more prominent
              ),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 450,
                  maxHeight:
                      300, // Add maxHeight to prevent overly tall dialogs
                ),
                // Use SingleChildScrollView + Column for multiple error messages
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min, // Take only needed vertical space
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align text left
                    children: errorMessages.map((errorMsg) {
                      // Create a Text widget for each error
                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8.0), // Add spacing between errors
                        child: Text(
                          '• Capture Main Member ID to calculate premium for policy ${current_member_index + 1}', // Add a bullet point for clarity
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87), // Slightly adjust style
                          textAlign: TextAlign
                              .left, // Align left is usually better for lists
                        ),
                      );
                    }).toList(), // Convert the mapped iterable to a list of widgets
                  ),
                ),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Constants.ctaColorLight, // Use your constant
                          borderRadius: BorderRadius.circular(360),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8, // Slightly increase vertical padding
                        ),
                        child: const Text(
                          'Noted',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
          // Removed the StatefulBuilder as it wasn't needed for just displaying static errors
        );
        return [];
      }
      //   _resetMembersForPolicy(current_member_index);
      policyPremiums[current_member_index].memberPremiums = [];
      policyPremiums[current_member_index].totalPremium = 0;
      policyPremiums[current_member_index].selectedRidersTotal = 0;
      _resetMembersForPolicy(current_member_index);
      final policy =
          Constants.currentleadAvailable!.policies[current_member_index];
      if (policy.riders != null) {
        policy.riders!.clear();
      }
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: Text(
              'Warning', // Or maybe "Errors Found"?
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.red), // Make title more prominent
            ),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 450,
                maxHeight: 300, // Add maxHeight to prevent overly tall dialogs
              ),
              // Use SingleChildScrollView + Column for multiple error messages
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Take only needed vertical space
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text left
                  children: errorMessages.map((errorMsg) {
                    // Create a Text widget for each error
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8.0), // Add spacing between errors
                      child: Text(
                        '• $errorMsg', // Add a bullet point for clarity
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87), // Slightly adjust style
                        textAlign: TextAlign
                            .left, // Align left is usually better for lists
                      ),
                    );
                  }).toList(), // Convert the mapped iterable to a list of widgets
                ),
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Constants.ctaColorLight, // Use your constant
                        borderRadius: BorderRadius.circular(360),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8, // Slightly increase vertical padding
                      ),
                      child: const Text(
                        'Noted',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        },
        // Removed the StatefulBuilder as it wasn't needed for just displaying static errors
      );
    }

    print("policiescoverAmounts => $policiescoverAmounts");
    calculateAndUpdateTotalPremium();
    return results;
  }

  void _resetMembersForPolicy(int policyIndex) {
    print("🔄 Resetting members for policy $policyIndex due to errors");

    if (Constants.currentleadAvailable!.policies.length <= policyIndex) {
      print("❌ Policy index $policyIndex out of range");
      return;
    }

    final policy = Constants.currentleadAvailable!.policies[policyIndex];
    final membersList = policy.members ?? [];

    // Reset policy's total premium and selected riders total
    if (policyPremiums.length > policyIndex) {
      policyPremiums[policyIndex].totalPremium = 0.0;
      policyPremiums[policyIndex].selectedRidersTotal = 0.0;
      // Also clear any selected riders for this policy
      if (policy.riders != null) {
        policy.riders!.clear();
      }
      if (selectedRiderIds.length > policyIndex) {
        selectedRiderIds[policyIndex].clear();
      }
    }

    // Reset each member's cover and premium to 0
    for (var member in membersList) {
      if (member is Map<String, dynamic>) {
        print(
            "Resetting Map member: ${member['type']} - premium: ${member['premium']} -> 0, cover: ${member['cover']} -> 0");
        member['premium'] = 0.0;
        member['cover'] = 0.0;

        // Update in database
        try {
          SalesService salesService = SalesService();
          salesService.updateMember2(context, member).catchError((e) {
            print("❌ Error resetting member in database: $e");
          });
        } catch (e) {
          print("❌ Error resetting member in database: $e");
        }
      } else if (member is Member) {
        print(
            "Resetting Member object: ${member.type} - premium: ${member.premium} -> 0, cover: ${member.cover} -> 0");
        member.premium = 0.0;
        member.cover = 0.0;
      }
    }

    // Remove all riders from Constants.currentleadAvailable for this policy
    // Assuming policy.riders directly reflects the riders for this policy in currentleadAvailable
    if (policy.riders != null) {
      policy.riders!.clear();
    }

    print("✅ Completed resetting members and riders for policy $policyIndex");
  }

  onPolicyUpdated() async {
    print("onPolicyUpdated called");

    // Loop over each main member (assuming the number of policies equals mainMembers.length)
    for (int i = 0; i < Constants.currentleadAvailable!.policies.length; i++) {
      // Get the corresponding policy.
      final policy = Constants.currentleadAvailable!.policies[i];

      //policyPremiums.clear();
      // Only process if totalAmountPayable exists and > 0.
      if (policy.quote.totalAmountPayable != null &&
          policy.quote.totalAmountPayable! > 0) {
        // If no entry exists at this index yet, create a new one.
        if (i >= policyPremiums.length) {
          policyPremiums.add(CalculatePolicyPremiumResponse(
            cecClientId: Constants.cec_client_id,
            totalPremium: (policy.quote.totalAmountPayable ?? 0),
            joiningFee: 0.0,
            mainInsuredDob: "",
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
          ));
          MainRate firstRate = Constants.currentParlourConfig!.mainRates.first;
          String defaultProduct = firstRate.product;
          String defaultProdType = firstRate.prodType; // <-- Change as needed.
          List<MainRate> filteredRates = Constants
              .currentParlourConfig!.mainRates
              .where((r) =>
                  r.product == defaultProduct && r.prodType == defaultProdType)
              .toList();

          // Extract distinct cover amounts.
          Set<double> amountsSet = {};
          for (var rate in filteredRates) {
            amountsSet.add(rate.amount);
          }

          // Convert to a sorted list.
          List<double> sortedAmounts = amountsSet.toList()..sort();

          // Determine a default cover amount (if available).
          double coverAmount =
              sortedAmounts.isNotEmpty ? sortedAmounts.first : 0;

          policiesSelectedCoverAmounts.add(coverAmount);

          policiescoverAmounts.add(sortedAmounts);
        } else {
          // If an entry already exists for this index, update its total premium.
          // policyPremiums[i].totalPremium = policy.quote.totalAmountPayable;
          // policyPremiums[i].totalPremium = policy.quote.totalAmountPayable;
        }
        print(
            "Updated premium for policy index4 $i: ${policy.quote.totalAmountPayable}");
      }
    }
    updatePoliciesWithDefaultProducts();
    // Trigger a UI rebuild.
    setState(() {});
  }

  void updatePoliciesWithDefaultProducts() {
    // Ensure a current lead is available.
    if (Constants.currentleadAvailable == null) return;

    // Get the policies.
    final List<Policy> policies = Constants.currentleadAvailable!.policies;

    // Loop through each policy.
    for (int i = 0; i < policies.length; i++) {
      // Check if this policy already has a selected product.
      // (You can adjust the condition if your list might contain nulls or empty strings.)
      if (i >= policiesSelectedProducts.length ||
          policiesSelectedProducts[i] == null ||
          policiesSelectedProducts[i].trim().isEmpty) {
        // Define default values.
        MainRate firstRate = Constants.currentParlourConfig!.mainRates.first;
        String defaultProduct = firstRate.product;
        String defaultProdType = firstRate.prodType; // <-- Change as needed.

        // Update policiesSelectedProducts:
        if (i >= policiesSelectedProducts.length) {
          policiesSelectedProducts.add(defaultProduct);
        } else {
          policiesSelectedProducts[i] = defaultProduct;
        }

        // Update policiesSelectedProdTypes:
        if (i >= policiesSelectedProdTypes.length ||
            policiesSelectedProdTypes[i] == null ||
            policiesSelectedProdTypes[i].trim().isEmpty) {
          if (i >= policiesSelectedProdTypes.length) {
            policiesSelectedProdTypes.add(defaultProdType);
          } else {
            policiesSelectedProdTypes[i] = defaultProdType;
          }
        }

        // Now filter the main rates for the default product and default product type.
        List<MainRate> filteredRates = Constants.currentParlourConfig!.mainRates
            .where((r) =>
                r.product == defaultProduct && r.prodType == defaultProdType)
            .toList();

        // Extract distinct cover amounts.
        Set<double> amountsSet = {};
        for (var rate in filteredRates) {
          amountsSet.add(rate.amount);
        }

        // Convert to a sorted list.
        List<double> sortedAmounts = amountsSet.toList()..sort();

        // Determine a default cover amount (if available).
        double coverAmount = sortedAmounts.isNotEmpty ? sortedAmounts.first : 0;

        // Update policiesSelectedCoverAmounts.
        if (i >= policiesSelectedCoverAmounts.length) {
          policiesSelectedCoverAmounts.add(coverAmount);
        } else {
          policiesSelectedCoverAmounts[i] = coverAmount;
        }

        // Update policiescoverAmounts with the sorted list.
        if (i >= policiescoverAmounts.length) {
          policiescoverAmounts.add(sortedAmounts);
        } else {
          policiescoverAmounts[i] = sortedAmounts;
        }
      }
    }

    // Trigger UI update.
    setState(() {});
  }

// Helper function to calculate inception date options based on 7-day rule
  List<String> calculateInceptionDateOptions() {
    DateTime today = DateTime.now();
    List<String> options = [];

    // Calculate first day of current month
    DateTime firstThisMonth = DateTime(today.year, today.month, 1);

    // Calculate first day of next month
    DateTime firstNextMonth;
    if (today.month == 12) {
      firstNextMonth = DateTime(today.year + 1, 1, 1);
    } else {
      firstNextMonth = DateTime(today.year, today.month + 1, 1);
    }

    // Calculate first day of month after next
    DateTime firstMonthAfterNext;
    if (today.month == 11) {
      // November -> January (skip December)
      firstMonthAfterNext = DateTime(today.year + 1, 1, 1);
    } else if (today.month == 12) {
      // December -> February (skip January)
      firstMonthAfterNext = DateTime(today.year + 1, 2, 1);
    } else {
      // All other months
      firstMonthAfterNext = DateTime(today.year, today.month + 2, 1);
    }

    // Calculate days remaining in current month
    int daysInCurrentMonth = DateTime(today.year, today.month + 1, 0).day;
    int daysRemaining = daysInCurrentMonth - today.day;

    if (daysRemaining >= 7) {
      // Standard case: current month + next month
      String thisMonthFormatted = Constants.formatter.format(firstThisMonth);
      String nextMonthFormatted = Constants.formatter.format(firstNextMonth);

      options.add(thisMonthFormatted);
      options.add(nextMonthFormatted);

      print(
          "Standard inception dates: $thisMonthFormatted and $nextMonthFormatted");
    } else {
      // Shifted case: next month + month after next
      String nextMonthFormatted = Constants.formatter.format(firstNextMonth);
      String monthAfterNextFormatted =
          Constants.formatter.format(firstMonthAfterNext);

      options.add(nextMonthFormatted);
      options.add(monthAfterNextFormatted);

      print(
          "Shifted inception dates (< 7 days remaining): $nextMonthFormatted and $monthAfterNextFormatted");
    }

    return options;
  }

  getCommencementDates() {
    // Commencement list
    commencementList = calculateInceptionDateOptions();
  }

  void fetchCommencementDates() {
    commencementDates.clear();

    for (int i = 0; i < Constants.currentleadAvailable!.policies.length; i++) {
      var policy = Constants.currentleadAvailable!.policies[i];

      String? commencement = (policy.quote.inceptionDate != null)
          ? Constants.formatter.format(policy.quote.inceptionDate!)
          : null;

      // Check if the commencement date exists in the available list
      // If not, set it to null to show the dropdown as invalid
      if (commencement != null && commencementList.contains(commencement)) {
        commencementDates.add(commencement);
      } else {
        // Date is not in the list or is null, so add null to make it invalid
        commencementDates.add(null);
      }
    }

    // Ensure the commencementDates list has enough elements
    while (commencementDates.length <= current_member_index) {
      commencementDates.add(null);
    }

    // Don't auto-set a default value - force user to select manually
    // This ensures the dropdown shows as invalid (red border) when no valid selection exists
  }

  fetchCommencementDatesOld() {
    commencementDates.clear();

    for (int i = 0; i < Constants.currentleadAvailable!.policies.length; i++) {
      var policy = Constants.currentleadAvailable!.policies[i];

      String? commencement = (policy.quote.inceptionDate != null)
          ? Constants.formatter.format(policy.quote.inceptionDate!)
          : null;

      commencementDates.add(commencement);

      // Fix: Check if the current index exists and handle null values properly
      if (i == current_member_index) {
        // If the commencement date is null or empty, try to set a default
        if (commencement == null || commencement.isEmpty) {
          // You can set a default date or leave it null
          // For example, set to the first available commencement date:
          if (commencementList.isNotEmpty) {
            commencementDates[current_member_index] = commencementList.first;
          }
        }
      }
    }

    // Additional safety check: ensure the current_member_index exists in the list
    while (commencementDates.length <= current_member_index) {
      // Add null entries for missing indices
      commencementDates.add(null);
    }

    // If the current member's commencement date is still null/empty, set a default
    if (current_member_index < commencementDates.length) {
      final currentCommencement = commencementDates[current_member_index];
      if (currentCommencement == null || currentCommencement.isEmpty) {
        if (commencementList.isNotEmpty) {
          commencementDates[current_member_index] = commencementList.first;
        }
      }
    }
  }

  final ScrollController _scrollController = ScrollController();
  late List<GlobalKey> _buttonKeys;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 24,
        ),

        /*  SizedBox(
          height: 24,
        ),*/

        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.15)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(steplist.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              // Set the active step to the tapped index
                              universalPremiumCalculatorActiveStep = index;
                              advancedMemberCardKey2 = UniqueKey();
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            height:
                                45, // Full height to make entire area clickable
                            // Fixed width instead of expanding
                            constraints: BoxConstraints(
                              minWidth: 120, // Minimum width for each tab
                              maxWidth: 200, // Maximum width for each tab
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            alignment: Alignment.center,
                            // Active background highlight - covers full tab width
                            decoration: BoxDecoration(
                              color:
                                  universalPremiumCalculatorActiveStep == index
                                      ? Constants.ftaColorLight
                                      : Colors.transparent,
                              borderRadius: BorderRadius.only(
                                topLeft: universalPremiumCalculatorActiveStep ==
                                            index &&
                                        index == 0
                                    ? const Radius.circular(12)
                                    : Radius.zero,
                                topRight:
                                    universalPremiumCalculatorActiveStep ==
                                                index &&
                                            index == steplist.length - 1
                                        ? const Radius.circular(12)
                                        : Radius.zero,
                              ),
                            ),
                            child: Text(
                              steplist[index]['content']!,
                              style: TextStyle(
                                fontSize: 14.5,
                                color: universalPremiumCalculatorActiveStep ==
                                        index
                                    ? Colors.white
                                    : Constants.ftaColorLight,
                                fontWeight: FontWeight.normal,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),

                SizedBox(
                  height: 24,
                ),
                // Text(policyPremiums.length.toString()),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "MONTHLY PREMIUM",
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'YuGothic',
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Builder(
                              builder: (context) {
                                if (policyPremiums.isEmpty ||
                                    current_member_index >=
                                        policyPremiums.length) {
                                  return Text(
                                    "R0.00",
                                    style: TextStyle(
                                      fontSize: 15,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  );
                                }

                                final premium =
                                    policyPremiums[current_member_index];
                                double monthlyPremium =
                                    (premium.totalPremium ?? 0) +
                                        (premium.selectedRidersTotal ?? 0);

                                if (monthlyPremium == 0) {
                                  return Text(
                                    "R0.00",
                                    style: TextStyle(
                                      fontSize: 15,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  );
                                }

                                return Text(
                                  "R${monthlyPremium.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      // Policy Fee Column
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "POLICY FEE",
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'YuGothic',
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Builder(
                              builder: (context) {
                                if (policyPremiums.isEmpty ||
                                    current_member_index >=
                                        policyPremiums.length) {
                                  return Text(
                                    "R0.00",
                                    style: TextStyle(
                                      fontSize: 15,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  );
                                }
                                final premium =
                                    policyPremiums[current_member_index];
                                if (premium.joiningFee == 0) {
                                  return Text(
                                    "R0.00",
                                    style: TextStyle(
                                      fontSize: 15,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  );
                                }
                                return Text(
                                  "R${(premium.joiningFee ?? 0).toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Divider(color: Colors.grey.withOpacity(0.35)),

                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // First Premium Column
                      Column(
                        children: [
                          Text(
                            "FIRST PREMIUM",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 14,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Builder(
                            builder: (context) {
                              if (policyPremiums.isEmpty ||
                                  current_member_index >=
                                      policyPremiums.length) {
                                return Text(
                                  "R0.00",
                                  style: TextStyle(
                                    fontSize: 17,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red,
                                  ),
                                );
                              }

                              final premium =
                                  policyPremiums[current_member_index];
                              double firstPremium =
                                  (premium.totalPremium ?? 0) +
                                      (premium.selectedRidersTotal ?? 0) +
                                      (premium.joiningFee ?? 0);

                              if (firstPremium == 0) {
                                return Text(
                                  "R0.00",
                                  style: TextStyle(
                                    fontSize: 17,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red,
                                  ),
                                );
                              }

                              return Text(
                                "R${firstPremium.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),
                //Text(mainMembers.length.toString()),

                if (mainMembers.length == 0 &&
                    Constants
                        .currentleadAvailable!.additionalMembers.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(left: 0.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Remove the fixed height from this Container so that it sizes based on its child.
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    width: 400,
                                    child: AdvancedMemberCard(
                                      key: advancedMemberCardKey1,
                                      id: "",
                                      dob: "",
                                      surname: Constants.currentleadAvailable!
                                          .additionalMembers.first.surname,
                                      contact: Constants.currentleadAvailable!
                                          .additionalMembers.first.contact,
                                      sourceOfWealth: "",
                                      dateOfBirth: "",
                                      sourceOfIncome: "",
                                      otherUnknownIncome: "",
                                      otherUnknownWealth: "",
                                      title: Constants.currentleadAvailable!
                                          .additionalMembers.first.title,
                                      name: Constants.currentleadAvailable!
                                          .additionalMembers.first.name,
                                      relationship: "self",
                                      gender: "",
                                      autoNumber: Constants
                                          .currentleadAvailable!
                                          .additionalMembers
                                          .first
                                          .autoNumber,
                                      isSelected: false,
                                      isEditing: false,
                                      is_self_or_payer: false,
                                      current_member_index:
                                          current_member_index,
                                      noOfMembers: 0,
                                      onSingleTap: () {
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (mainMembers.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Container(
                      height: 154,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0, top: 8),
                          child: Row(
                            children: mainMembers.asMap().entries.map((entry) {
                              int index = entry.key;
                              var member = entry.value;
                              return Padding(
                                padding:
                                    const EdgeInsets.only(top: 0, right: 16),
                                child: Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  72,
                                              height: 145,
                                              child: InkWell(
                                                onTap: () {
                                                  current_member_index = index;
                                                  print(
                                                      "Selected member index: $current_member_index $index");
                                                  setState(() {});
                                                },
                                                onDoubleTap: () {
                                                  showDoubleTapDialog(
                                                      context, true);
                                                },
                                                child: AdvancedPolicyCard(
                                                  key: advancedMemberCardKey2,
                                                  policy_index: index,
                                                  is_selected:
                                                      current_member_index ==
                                                          index,
                                                  main_insured:
                                                      "${member.title} ${member.name} ${member.surname}",
                                                  policy_status: Constants
                                                          .currentleadAvailable!
                                                          .policies[index]
                                                          .quote
                                                          .status ??
                                                      "New",
                                                  total_premium: index >=
                                                          policyPremiums.length
                                                      ? 0.0
                                                      : (policyPremiums[index]
                                                              .totalPremium ??
                                                          0 +
                                                              (policyPremiums[
                                                                          index]
                                                                      .selectedRidersTotal ??
                                                                  0)),
                                                  selected_product:
                                                      policiesSelectedProducts[
                                                          index],
                                                  selected_cover:
                                                      policiesSelectedCoverAmounts[
                                                          index],
                                                ),
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),

                /* if (mainMembers.length > 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Container(
                          height: 120,
                          width: MediaQuery.of(context).size.width,
                          // Remove the fixed height so that the height is determined by the content.
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: mainMembers.map((member) {
                                int index = mainMembers.indexOf(member);
                                return Padding(
                                  padding: const EdgeInsets.only(top: 0, right: 16),
                                  child: Container(
                                    height: 120,
                                    child: Column(
                                      children: [
                                        // Remove the fixed height from the card container.
                                        Container(
                                          width: 450,
                                          height: 120,
                                          child: AdvancedMemberCard(
                                            id: member.id,
                                            dob: member.dob,
                                            surname: member.surname,
                                            contact: member.contact,
                                            sourceOfWealth: member.sourceOfWealth,
                                            dateOfBirth: member.dob,
                                            sourceOfIncome: member.sourceOfIncome,
                                            title: member.title,
                                            name: member.name,
                                            relationship: member.relationship,
                                            gender: member.gender,
                                            autoNumber: member.autoNumber,
                                            isSelected: current_member_index == index,
                                            current_member_index: current_member_index,
                                            is_self_or_payer: true,
                                            noOfMembers: 0,
                                            onSingleTap: () {
                                              current_member_index = index;
                                              print(
                                                  "Selected member index: $current_member_index");
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),*/
                SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Column(
                    children: [
                      if (universalPremiumCalculatorActiveStep == 3)
                        Center(
                          child: InkWell(
                            child: Container(
                              height: 35,
                              width: 260,
                              padding: EdgeInsets.only(left: 16, right: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36),
                                color: Constants.ctaColorLight,
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.add,
                                        size: 18, color: Colors.white),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      "Add Extended Family Member",
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'YuGothic',
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              String message = checkCanAddMembers("extended");

                              // 2) If there's a message, show the dialog. Otherwise, proceed to add.
                              if (message.isNotEmpty) {
                                // Show a warning dialog
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (dialogContext) {
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      surfaceTintColor: Colors.white,
                                      title: const Text(
                                        'Warning',
                                        textAlign: TextAlign.center,
                                      ),
                                      content: ConstrainedBox(
                                        constraints:
                                            const BoxConstraints(maxWidth: 450),
                                        child: Text(
                                          message,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        Center(
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.of(dialogContext)
                                                  .pop(); // Close the dialog
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Constants.ctaColorLight,
                                                borderRadius:
                                                    BorderRadius.circular(360),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 24,
                                                vertical: 5,
                                              ),
                                              child: const Text(
                                                'Noted',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                showAddExtendedDialog(
                                    context, current_member_index, true);
                              }
                            },
                          ),
                        ),
                      if (universalPremiumCalculatorActiveStep == 2)
                        Center(
                          child: InkWell(
                            child: Container(
                              height: 35,
                              width: 160,
                              padding: EdgeInsets.only(left: 16, right: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(360),
                                color: Constants.ctaColorLight,
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.add,
                                        size: 18, color: Colors.white),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      "Add Child",
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'YuGothic',
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              String message = checkCanAddMembers("child");

                              // 2) If there's a message, show the dialog. Otherwise, proceed to add.
                              if (message.isNotEmpty) {
                                // Show a warning dialog
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (dialogContext) {
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      surfaceTintColor: Colors.white,
                                      title: const Text(
                                        'Warning',
                                        textAlign: TextAlign.center,
                                      ),
                                      content: ConstrainedBox(
                                        constraints:
                                            const BoxConstraints(maxWidth: 450),
                                        child: Text(
                                          message,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        Center(
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.of(dialogContext)
                                                  .pop(); // Close the dialog
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Constants.ctaColorLight,
                                                borderRadius:
                                                    BorderRadius.circular(360),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 24,
                                                vertical: 5,
                                              ),
                                              child: const Text(
                                                'Noted',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                showAddChildrenDialog(
                                  context,
                                  current_member_index,
                                  true,
                                );
                              }
                              setState(() {});
                            },
                          ),
                        ),
                      if (universalPremiumCalculatorActiveStep == 1)
                        Center(
                          child: InkWell(
                            child: Container(
                              height: 35,
                              width: 160,
                              padding: EdgeInsets.only(left: 16, right: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36),
                                color: Constants.ctaColorLight,
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.add,
                                        size: 18, color: Colors.white),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      "Add a Partner",
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'YuGothic',
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              String message = checkCanAddMembers("partner");

                              // 2) If there's a message, show the dialog. Otherwise, proceed to add.
                              if (message.isNotEmpty) {
                                // Show a warning dialog
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (dialogContext) {
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      surfaceTintColor: Colors.white,
                                      title: const Text(
                                        'Warning',
                                        textAlign: TextAlign.center,
                                      ),
                                      content: ConstrainedBox(
                                        constraints:
                                            const BoxConstraints(maxWidth: 450),
                                        child: Text(
                                          message,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        Center(
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.of(dialogContext)
                                                  .pop(); // Close the dialog
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Constants.ctaColorLight,
                                                borderRadius:
                                                    BorderRadius.circular(360),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 24,
                                                vertical: 5,
                                              ),
                                              child: const Text(
                                                'Noted',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                showAddPartnerDialog(
                                    context, current_member_index, true);
                                setState(() {});
                              }
                            },
                          ),
                        ),
                      if (universalPremiumCalculatorActiveStep == 0)
                        TextButton.icon(
                          onPressed: () {
                            showDoubleTapDialog3(context, true);
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Add/Replace Main Member',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'YuGothic',
                                color: Colors.white),
                          ),
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.teal,
                              backgroundColor: Constants.ctaColorLight),
                        ),
                      SizedBox(
                        height: 8,
                      ),
                      TextButton.icon(
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              // set to false if you want to force a rating
                              builder: (context) => StatefulBuilder(
                                    builder: (context, setState) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(64),
                                      ),
                                      elevation: 0.0,
                                      backgroundColor: Colors.transparent,
                                      content: Container(
                                        // width: MediaQuery.of(context).size.width,

                                        constraints: BoxConstraints(
                                          maxWidth: (Constants
                                                  .currentleadAvailable!
                                                  .leadObject
                                                  .documentsIndexed
                                                  .isEmpty)
                                              ? 750
                                              : 1200,
                                        ),
                                        margin: const EdgeInsets.only(top: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 10.0,
                                              offset: Offset(0.0, 10.0),
                                            ),
                                          ],
                                        ),
                                        child: NewMemberDialog(
                                          isEditMode: false,
                                          autoNumber: 0,
                                          relationship: "",
                                          title: "",
                                          name: "",
                                          surname: "",
                                          dob: "",
                                          gender: "",
                                          current_member_index:
                                              current_member_index,
                                          canAddMember: false,
                                        ),
                                      ),
                                    ),
                                  ));
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Add New Member',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'YuGothic',
                              color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.teal,
                            backgroundColor: Constants.ftaColorLight),
                      ),
                      /*SizedBox(
                        width: 32,
                      ),*/
                      /*TextButton.icon(
                        onPressed: () {
                          showNewPolicyDialogDialog(
                              context,
                              Constants.currentleadAvailable!.policies.length +
                                  1);
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'New Policy',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'YuGothic',
                              color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.teal,
                            backgroundColor: Constants.ftaColorLight),
                      ),
                      SizedBox(
                        width: 16,
                      ),*/
                    ],
                  ),
                ),
                if (universalPremiumCalculatorActiveStep == 0)
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24,
                        ),
                        Container(
                            height: 1, color: Colors.grey.withOpacity(0.35)),
                        SizedBox(
                          height: 24,
                        ),
                        //  Text(mainMembers[0].toJson().toString()),
                        Container(
                          width: MediaQuery.of(context).size.width - 40,
                          height: 170,
                          child: (mainMembers.isEmpty ||
                                  current_member_index < 0 ||
                                  current_member_index >= mainMembers.length)
                              ? Center(child: Text('No member data available'))
                              : AdvancedMemberCard(
                                  id: mainMembers[current_member_index].id,
                                  dob: mainMembers[current_member_index].dob,
                                  surname:
                                      mainMembers[current_member_index].surname,
                                  contact:
                                      mainMembers[current_member_index].contact,
                                  sourceOfWealth:
                                      mainMembers[current_member_index]
                                          .sourceOfWealth,
                                  otherUnknownIncome:
                                      mainMembers[current_member_index]
                                          .otherUnknownIncome,
                                  otherUnknownWealth:
                                      mainMembers[current_member_index]
                                          .otherUnknownWealth,
                                  dateOfBirth:
                                      mainMembers[current_member_index].dob,
                                  sourceOfIncome:
                                      mainMembers[current_member_index]
                                          .sourceOfIncome,
                                  title:
                                      mainMembers[current_member_index].title,
                                  name: mainMembers[current_member_index].name,
                                  relationship:
                                      mainMembers[current_member_index]
                                          .relationship,
                                  gender:
                                      mainMembers[current_member_index].gender,
                                  autoNumber: mainMembers[current_member_index]
                                      .autoNumber,
                                  isSelected: true,
                                  isEditing: true,
                                  current_member_index: current_member_index,
                                  is_self_or_payer: true,
                                  noOfMembers: 0,
                                  cover: (policiesSelectedCoverAmounts
                                              .isNotEmpty &&
                                          current_member_index <
                                              policiesSelectedCoverAmounts
                                                  .length)
                                      ? policiesSelectedCoverAmounts[
                                          current_member_index]
                                      : 0,
                                  premium: (policyPremiums.isNotEmpty &&
                                          current_member_index <
                                              policyPremiums.length &&
                                          policyPremiums[current_member_index]
                                              .memberPremiums
                                              .isNotEmpty)
                                      ? policyPremiums[current_member_index]
                                          .memberPremiums
                                          .first
                                          .premium
                                      : 0,
                                  onSingleTap: () {},
                                ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Product',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'YuGothic',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: Container(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 2,
                                                  right: 2,
                                                  top: 8,
                                                  bottom: 8),
                                              child: Container(
                                                height: 48,
                                                decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    border: Border.all(
                                                        width: 1.0,
                                                        color: Colors.grey
                                                            .withOpacity(0.55)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            360)),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 48,
                                                      width: 48,
                                                      //padding: EdgeInsets.only(left: 8),
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              right: BorderSide(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.55)))),
                                                      child: Center(
                                                        child: Icon(
                                                          Iconsax.icon,
                                                          size: 24,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 16.0,
                                                                left: 16),
                                                        child: Text(
                                                          (policiesSelectedProducts
                                                                      .length ==
                                                                  0)
                                                              ? "Select Product"
                                                              : policiesSelectedProducts[
                                                                      current_member_index] +
                                                                  " " +
                                                                  policiesSelectedProdTypes[
                                                                      current_member_index],
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'YuGothic',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 16.0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          showDoubleTapDialog(
                                                              context, true);
                                                        },
                                                        child: Text("Change",
                                                            style: TextStyle(
                                                                color: Constants
                                                                    .ctaColorLight,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                      ),
                                                    ),
                                                    /*    Expanded(
                                                                                        child: Container(
                                                                                          height: 48,
                                                                                          child:
                                                                                              DropdownButtonHideUnderline(
                                                                                            child: DropdownButton(
                                                                                                borderRadius:
                                                                                                    BorderRadius
                                                                                                        .circular(
                                                                                                            8),
                                                                                                dropdownColor:
                                                                                                    Colors.white,
                                                                                                style: const TextStyle(
                                                                                                    fontFamily:
                                                                                                        'YuGothic',
                                                                                                    color: Colors
                                                                                                        .black),
                                                                                                padding:
                                                                                                    const EdgeInsets
                                                                                                        .only(
                                                                                                        left: 24,
                                                                                                        right: 24,
                                                                                                        top: 5,
                                                                                                        bottom: 5),
                                                                                                hint: const Text(
                                                                                                  'Product Athandwe1',
                                                                                                  style: TextStyle(
                                                                                                      fontFamily:
                                                                                                          'YuGothic',
                                                                                                      color: Colors
                                                                                                          .black),
                                                                                                ),
                                                                                                isExpanded: true,
                                                                                                value:
                                                                                                    _selectedProduct,
                                                                                                items: productList
                                                                                                    .map((String
                                                                                                            classType) =>
                                                                                                        DropdownMenuItem<
                                                                                                            String>(
                                                                                                          value:
                                                                                                              classType,
                                                                                                          child:
                                                                                                              Text(
                                                                                                            classType,
                                                                                                            style: TextStyle(
                                                                                                                fontSize:
                                                                                                                    13.5,
                                                                                                                fontFamily:
                                                                                                                    'YuGothic',
                                                                                                                fontWeight:
                                                                                                                    FontWeight.w500,
                                                                                                                color: Colors.black),
                                                                                                          ),
                                                                                                        ))
                                                                                                    .toList(),
                                                                                                onChanged:
                                                                                                    (newValue) {
                                                                                                  setState(() {
                                                                                                    _selectedProduct =
                                                                                                        newValue!
                                                                                                            .toString();
                                                                                                  });
                                                                                                }),
                                                                                          ),
                                                                                        ),
                                                                                      ),*/
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )),
                                          const SizedBox(width: 8),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Commencement date',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'YuGothic',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 2,
                                                    right: 2,
                                                    top: 8,
                                                    bottom: 8),
                                                child: Container(
                                                  height: 48,
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    border: Border.all(
                                                      width: 1.0,
                                                      color:
                                                          _isCommencementDateValid()
                                                              ? Colors.grey
                                                                  .withOpacity(
                                                                      0.55)
                                                              : Colors.red,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            360),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 48,
                                                        width: 48,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    360),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    360),
                                                          ),
                                                          border: Border(
                                                            right: BorderSide(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.55)),
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Icon(
                                                            CupertinoIcons
                                                                .calendar,
                                                            size: 24,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          height: 48,
                                                          child:
                                                              DropdownButtonHideUnderline(
                                                            child:
                                                                DropdownButton<
                                                                    String>(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              dropdownColor:
                                                                  Colors.white,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'YuGothic',
                                                                color: _isCommencementDateValid()
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .red,
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 16,
                                                                      right: 24,
                                                                      top: 5,
                                                                      bottom:
                                                                          5),
                                                              hint: Text(
                                                                _getCommencementHintText(),
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'YuGothic',
                                                                  color: _isCommencementDateValid()
                                                                      ? Colors
                                                                          .grey
                                                                      : Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                              isExpanded: true,
                                                              value:
                                                                  _getCurrentCommencementValue(),
                                                              items:
                                                                  _buildUniqueCommencementItems(),
                                                              onChanged:
                                                                  isPolicyInforced ==
                                                                          true
                                                                      ? null
                                                                      : (newValue) {
                                                                          if (newValue !=
                                                                              null) {
                                                                            setState(() {
                                                                              // Ensure the list is large enough
                                                                              while (commencementDates.length <= current_member_index) {
                                                                                commencementDates.add(null);
                                                                              }

                                                                              commencementDates[current_member_index] = newValue;
                                                                              _selectedCommencement = newValue;
                                                                              Constants.currentleadAvailable!.policies[current_member_index].premiumPayer.commencementDate = newValue;

                                                                              DateTime? parsedDate = DateTime.tryParse(newValue);
                                                                              if (parsedDate != null) {
                                                                                Constants.currentleadAvailable!.policies[current_member_index].quote.inceptionDate = parsedDate;
                                                                              }
                                                                            });
                                                                            print("fghggh $newValue");

                                                                            SalesService
                                                                                salesServivce =
                                                                                SalesService();
                                                                            salesServivce.updatePolicy(Constants.currentleadAvailable!,
                                                                                context);
                                                                            onPolicyUpdated2(context,
                                                                                false);
                                                                          }
                                                                          myConfirmPremiumClearValues
                                                                              .value++;
                                                                        },
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
                                          const SizedBox(width: 8),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Cover',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'YuGothic',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(height: 8),

                                      //   Text("$_selectedCover ${coverAmounts}"),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: Container(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 2,
                                                  right: 2,
                                                  top: 8,
                                                  bottom: 8),
                                              child: Container(
                                                height: 48,
                                                decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    border: Border.all(
                                                        width: 1.0,
                                                        color: Colors.grey
                                                            .withOpacity(0.55)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            360)),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 48,
                                                      width: 48,
                                                      //padding: EdgeInsets.only(left: 8),
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              right: BorderSide(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.55)))),
                                                      child: Center(
                                                        child: Icon(
                                                          Iconsax.icon,
                                                          size: 24,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    /* Expanded(
                                                                                        child: Padding(
                                                                                          padding:
                                                                                              const EdgeInsets.only(
                                                                                                  right: 16.0,
                                                                                                  left: 16),
                                                                                          child: Text(
                                                                                            "R" +
                                                                                                current_policy_cover_amount
                                                                                                    .toStringAsFixed(
                                                                                                        2),
                                                                                            style: TextStyle(
                                                                                                fontSize: 14,
                                                                                                fontFamily:
                                                                                                    'YuGothic',
                                                                                                fontWeight:
                                                                                                    FontWeight.w500,
                                                                                                color:
                                                                                                    Colors.black),
                                                                                          ),
                                                                                        ),
                                                                                      ),*/

                                                    Expanded(
                                                      child: Container(
                                                        height: 48,
                                                        child: (policiescoverAmounts
                                                                    .isEmpty ||
                                                                current_member_index >=
                                                                    policiescoverAmounts
                                                                        .length)
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0,
                                                                        top:
                                                                            14),
                                                                child: const Text(
                                                                    "No cover amounts found"),
                                                              )
                                                            : Builder(
                                                                builder:
                                                                    (context) {
                                                                  // Get unique cover amounts and sort them
                                                                  final uniqueCoverAmounts =
                                                                      policiescoverAmounts[
                                                                              current_member_index]
                                                                          .toSet()
                                                                          .toList()
                                                                        ..sort();

                                                                  // Get the currently selected value
                                                                  double? currentSelectedValue = (policiesSelectedCoverAmounts.length >
                                                                              current_member_index &&
                                                                          policiesSelectedCoverAmounts[current_member_index] !=
                                                                              0)
                                                                      ? policiesSelectedCoverAmounts[
                                                                          current_member_index]
                                                                      : null;

                                                                  // Validate that the selected value exists in the available options
                                                                  if (currentSelectedValue !=
                                                                          null &&
                                                                      !uniqueCoverAmounts
                                                                          .contains(
                                                                              currentSelectedValue)) {
                                                                    currentSelectedValue =
                                                                        null; // Reset if not found in options
                                                                  }

                                                                  return DropdownButtonHideUnderline(
                                                                    child: DropdownButton<
                                                                        double>(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                      dropdownColor:
                                                                          Colors
                                                                              .white,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontFamily:
                                                                            'YuGothic',
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .only(
                                                                        left:
                                                                            24,
                                                                        right:
                                                                            24,
                                                                        top: 5,
                                                                        bottom:
                                                                            5,
                                                                      ),

                                                                      // Use the validated selected value
                                                                      value:
                                                                          currentSelectedValue,

                                                                      // Hint text
                                                                      hint:
                                                                          Text(
                                                                        currentSelectedValue ==
                                                                                null
                                                                            ? 'Select Cover Amount'
                                                                            : currentSelectedValue.toString(),
                                                                        style:
                                                                            const TextStyle(
                                                                          fontFamily:
                                                                              'YuGothic',
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                      isExpanded:
                                                                          true,

                                                                      // Build dropdown items from unique cover amounts
                                                                      items: uniqueCoverAmounts.map(
                                                                          (double
                                                                              coverAmount) {
                                                                        return DropdownMenuItem<
                                                                            double>(
                                                                          value:
                                                                              coverAmount,
                                                                          child:
                                                                              Text(
                                                                            coverAmount.toString(),
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 13.5,
                                                                              fontFamily: 'YuGothic',
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }).toList(),

                                                                      // Handle selection change
                                                                      onChanged: isPolicyInforced ==
                                                                              true
                                                                          ? null
                                                                          : (newValue) {
                                                                              if (newValue == null)
                                                                                return;

                                                                              setState(() {
                                                                                // Ensure the array is large enough
                                                                                while (policiesSelectedCoverAmounts.length <= current_member_index) {
                                                                                  policiesSelectedCoverAmounts.add(0.0);
                                                                                }

                                                                                try {
                                                                                  String? currentReference = Constants.currentleadAvailable?.policies[current_member_index]?.reference;

                                                                                  final membersList = Constants.currentleadAvailable?.policies[current_member_index]?.members ?? [];

                                                                                  if (currentReference != null) {
                                                                                    updateGlobalCoverAmounts(membersList, currentReference, current_member_index, newValue);
                                                                                  }

                                                                                  policiesSelectedCoverAmounts[current_member_index] = newValue;

                                                                                  // Update quote if available
                                                                                  Constants.currentleadAvailable?.policies[current_member_index]?.quote?.sumAssuredFamilyCover;
                                                                                } catch (e) {
                                                                                  print('Error updating cover amount: $e');
                                                                                  // Handle error gracefully - maybe show a snackbar
                                                                                }
                                                                              });

                                                                              // Update value notifiers
                                                                              mySalesPremiumCalculatorValue.value++;
                                                                              myConfirmPremiumClearValues.value++;
                                                                            },
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )),
                                          const SizedBox(width: 8),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                /* Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Add/Replace Main Member ',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'YuGothic',
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  child: Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 2, right: 2, top: 8, bottom: 8),
                                                  child: Container(
                                                    height: 48,
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      border: Border.all(
                                                          width: 1.0,
                                                          color: Colors.grey
                                                              .withOpacity(0.55)),
                                                      borderRadius:
                                                          BorderRadius.circular(360),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: 48,
                                                          width: 48,
                                                          //padding: EdgeInsets.only(left: 8),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.only(
                                                                      topLeft:
                                                                          Radius.circular(
                                                                              360),
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              360)),
                                                              border: Border(
                                                                  right: BorderSide(
                                                                      color: Colors.grey
                                                                          .withOpacity(
                                                                              0.55)))),
                                                          child: Center(
                                                            child: Icon(
                                                              CupertinoIcons.calendar,
                                                              size: 24,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: InkWell(
                                                            onTap: () {
                                                              showDoubleTapDialog3(context);
                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                              height: 48,
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment.start,
                                                                children: [
                                                                  // Corrected the condition to avoid out-of-range errors
                                                                  (mainMembers.isEmpty ||
                                                                          mainMembers[
                                                                                  current_member_index]
                                                                              .dob
                                                                              .isEmpty)
                                                                      ? Padding(
                                                                          padding:
                                                                              const EdgeInsets
                                                                                  .only(
                                                                                  left:
                                                                                      12.0),
                                                                          child: const Text(
                                                                            "Add/Replace Main Member ",
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily:
                                                                                  'YuGothic',
                                                                              color: Colors
                                                                                  .black,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Padding(
                                                                          padding:
                                                                              const EdgeInsets
                                                                                  .only(
                                                                                  left:
                                                                                      12.0),
                                                                          child: Text(
                                                                            Constants
                                                                                .formatter
                                                                                .format(
                                                                              DateTime.parse(
                                                                                  mainMembers[
                                                                                          current_member_index]
                                                                                      .dob
                                                                                      .toString()),
                                                                            ),
                                                                            style:
                                                                                const TextStyle(
                                                                              fontFamily:
                                                                                  'YuGothic',
                                                                              color: Colors
                                                                                  .black,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          child: Container(
                                                            height: 48,
                                                            width: 48,
                                                            //padding: EdgeInsets.only(left: 8),
                                                            decoration: BoxDecoration(
                                                                color: Constants
                                                                    .ftaColorLight,
                                                                borderRadius:
                                                                    BorderRadius.only(
                                                                        topRight:
                                                                            Radius.circular(
                                                                                360),
                                                                        bottomRight: Radius
                                                                            .circular(360)),
                                                                border: Border(
                                                                    right: BorderSide(
                                                                        color:
                                                                            Colors.white))),
                                                            child: Center(
                                                              child: Icon(
                                                                Iconsax.filter_edit,
                                                                size: 24,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            showDoubleTapDialog3(context);
                                                            setState(() {});
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )),
                                              const SizedBox(width: 8),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),*/
                              ],
                            ),
                            SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                if (universalPremiumCalculatorActiveStep == 1)
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24,
                        ),
                        Container(
                            height: 1, color: Colors.grey.withOpacity(0.35)),
                        SizedBox(
                          height: 24,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            buildPartnersGrid(),
                            SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                if (universalPremiumCalculatorActiveStep == 2)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 24.0, right: 24, top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24,
                        ),
                        Container(
                            height: 1, color: Colors.grey.withOpacity(0.35)),
                        SizedBox(
                          height: 24,
                        ),
                        //  SelectableText(policiesSelectedChildren.toString()),
                        buildChildrenGrid(),
                        SizedBox(
                          height: 24,
                        ),

                        SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                  ),
                if (universalPremiumCalculatorActiveStep == 3)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 24.0, right: 24, top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24,
                        ),
                        Container(
                            height: 1, color: Colors.grey.withOpacity(0.35)),
                        SizedBox(
                          height: 24,
                        ),
                        buildExtendedList(),
                        SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                  ),
                //  Text(policyPremiums[current_member_index].allRiders.toString()),
                if (universalPremiumCalculatorActiveStep == 4)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                          height: 1, color: Colors.grey.withOpacity(0.35)),
                      SizedBox(
                        height: 24,
                      ),

                      /*Container(
                        height: 140,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 4, bottom: 4),
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: Constants
                                  .currentleadAvailable!
                                  .policies[current_member_index]
                                  .members
                                  .length,
                              itemBuilder: (context, index) {
                                Member member1 = Member.fromJson({});
                                if (Constants
                                    .currentleadAvailable!
                                    .policies[current_member_index]
                                    .members[index]
                                    .runtimeType
                                    .toString() ==
                                    "Map<String, dynamic>" ||
                                    Constants
                                        .currentleadAvailable!
                                        .policies[current_member_index]
                                        .members[index]
                                        .runtimeType
                                        .toString() ==
                                        "_Map<String, dynamic>") {
                                  member1 = Member.fromJson(Constants
                                      .currentleadAvailable!
                                      .policies[current_member_index]
                                      .members[index]);
                                } else {
                                  member1 = Constants
                                      .currentleadAvailable!
                                      .policies[current_member_index]
                                      .members[index];
                                }
                                print(
                                    "ggghghh ${Constants.currentleadAvailable!
                                        .policies[current_member_index]
                                        .members}");

                                for (var member in Constants
                                    .currentleadAvailable!.additionalMembers) {
                                  print(
                                      "fddf ${member.name} ${member
                                          .relationship} ${member
                                          .autoNumber} ${member1
                                          .additionalMemberId} ${member1
                                          .type}");
                                }
                                AdditionalMember? member2 = Constants
                                    .currentleadAvailable!.additionalMembers
                                    .firstWhere(
                                      (member) =>
                                  member.autoNumber ==
                                      member1.additionalMemberId,
                                  orElse: () =>
                                      AdditionalMember(
                                          memberType: "self",
                                          autoNumber: 0,
                                          id: "",
                                          contact: "-",
                                          dob: "",
                                          gender: "",
                                          name: "",
                                          surname: "",
                                          title: "",
                                          onololeadid: 0,
                                          altContact: "",
                                          email: "",
                                          percentage: 0,
                                          maritalStatus: "",
                                          relationship: "-",
                                          mipCover: "",
                                          mipStatus: "",
                                          updatedBy: 0,
                                          memberQueryType: "",
                                          memberQueryTypeOldNew: "",
                                          memberQueryTypeOldAutoNumber: "",
                                          membersAutoNumber: "",
                                          sourceOfIncome: "",
                                          sourceOfWealth: "",
                                          otherUnknownIncome: "",
                                          otherUnknownWealth: "",
                                          timestamp: "",
                                          lastUpdate: ""),
                                );

                                return Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Container(
                                    width: 450,
                                    height: 120,
                                    child: AdvancedMemberCard(
                                      id: member2.id,
                                      dob: member2.dob,
                                      surname: member2.surname,
                                      contact: member2.contact,
                                      sourceOfWealth: member2.sourceOfWealth,
                                      dateOfBirth: member2.dob,
                                      sourceOfIncome: member2.sourceOfIncome,
                                      title: member2.title,
                                      name: member2.name,
                                      relationship:
                                      (member2.relationship.isNotEmpty &&
                                          member2.relationship != '-')
                                          ? member2.relationship
                                          : '-',
                                      gender: member2.gender,
                                      autoNumber: member2.autoNumber,
                                      isSelected: true,
                                      current_member_index:
                                      current_member_index,
                                      is_self_or_payer: true,
                                      noOfMembers: 0,
                                      onSingleTap: () {
                                        riders_filter = member1.type!;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),*/
                      getAllMembers(),
                      SizedBox(
                        height: 24,
                      ),
                      buildRidersGrid(),
                      SizedBox(
                        height: 24,
                      ),
                    ],
                  )
                /*Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 24,
                          ),
                          Container(height: 1, color: Colors.grey.withOpacity(0.35)),
                          SizedBox(
                            height: 24,
                          ),
                          if (current_member_index >= policyPremiums.length)
                            if (policyPremiums[current_member_index]
                                .applicableMRiders
                                .isEmpty)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "No Additional Benefits Available",
                                    style: TextStyle(fontSize: 14, color: Colors.black54),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          if (current_member_index < policyPremiums.length)
                            if (policyPremiums[current_member_index]
                                .applicableMRiders
                                .isEmpty)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "No Additional Benefits Available",
                                    style: TextStyle(fontSize: 14, color: Colors.black54),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          if (current_member_index < policyPremiums.length)
                            if (policyPremiums[current_member_index]
                                .applicableMRiders
                                .isNotEmpty)
                              Center(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(0),
                                  itemCount: policyPremiums[current_member_index]
                                      .applicableMRiders
                                      .length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final rider = policyPremiums[current_member_index]
                                        .applicableMRiders[index];

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 16),
                                      child: RiderCard(
                                        rider: rider,
                                        isSelected: selectedRiderIds.length >
                                                current_member_index &&
                                            selectedRiderIds[current_member_index]
                                                .contains(rider.id),
                                        onCheck: () {
                                          setState(() {
                                            while (selectedRiderIds.length <=
                                                current_member_index) {
                                              selectedRiderIds.add([]);
                                            }

                                            if (selectedRiderIds[current_member_index]
                                                .contains(rider.id)) {
                                              selectedRiderIds[current_member_index]
                                                  .remove(rider.id);
                                            } else {
                                              selectedRiderIds[current_member_index]
                                                  .add(rider.id);
                                            }

                                            onPolicyUpdated2(context);
                                          });
                                        },
                                        onAddBenefit: () {
                                          setState(() {
                                            while (selectedRiderIds.length <=
                                                current_member_index) {
                                              selectedRiderIds.add([]);
                                            }

                                            if (!selectedRiderIds[current_member_index]
                                                .contains(rider.id)) {
                                              selectedRiderIds[current_member_index]
                                                  .add(rider.id);
                                            }

                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Added benefit for ${rider.riderName}!',
                                                ),
                                              ),
                                            );

                                            onPolicyUpdated2(context);
                                          });
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                          SizedBox(
                            height: 24,
                          ),
                        ],
                      )*/
              ],
            ),
          ),
        ),
      ],
    );
  }

  void commonOnTap() {
    bool isLastStep =
        (universalPremiumCalculatorActiveStep == getSteps().length - 1);
    if (isLastStep) {
      print("Completed all steps");
    } else {
      setState(() {
        universalPremiumCalculatorActiveStep += 1;
      });
    }
  }

  List<Step> getSteps() {
    return steplist.asMap().entries.map<Step>((e) {
      var i = e.key;
      var item = e.value;
      return Step(
        state: universalPremiumCalculatorActiveStep > i
            ? StepState.complete
            : StepState.indexed,
        isActive: universalPremiumCalculatorActiveStep >= i,
        title: const SizedBox.shrink(),
        label: Text(
          item['content'] ?? "",
          style: TextStyle(
            fontSize: 12,
            color:
                universalPremiumCalculatorActiveStep >= i ? Colors.blue : null,
            fontWeight: FontWeight.w500,
            fontFamily: 'YuGothic',
          ),
        ),
        content: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(0.0),
          child: Container(),
        ),
      );
    }).toList();
  }

  void showNewPolicyDialogDialog(
      BuildContext context, int current_member_index) {
    List<AdditionalMember> allExtendedList = [];

    if (Constants.currentleadAvailable != null) {
      allExtendedList =
          Constants.currentleadAvailable!.additionalMembers.where((m) {
        if (m.relationship == "self") return false;

        if (m.dob.isEmpty) return false;

        // Parse date and check if age is greater than 18
        return calculateAge(DateTime.parse(m.dob)) > 18;
      }).toList();
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        child: MovingLineDialog(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 630),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36),
            ),
            child: StatefulBuilder(
              builder: (context, setState1) => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 16),
                    Row(
                      children: [
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
                          width: 16,
                        ) // Reduced width
                      ],
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: Text(
                        "Add A New Policy",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: Constants.ftaColorLight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Center(
                      child: Text(
                        "Click on a member below to select them as an extended member",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'YuGothic',
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // -------------------- List of potential extended members --------------------
                    allExtendedList.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(child: Text("No members available")),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: allExtendedList.length,
                            itemBuilder: (context, index) {
                              final member = allExtendedList[index];

                              return Container(
                                // -------------------- The Extended UI Card --------------------
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                    horizontal: 16.0,
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Constants.ftaColorLight
                                            .withOpacity(0.9),
                                        Constants.ftaColorLight,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Profile Avatar
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          member.gender.toLowerCase() ==
                                                  "female"
                                              ? Icons.female
                                              : Icons.male,
                                          size: 24,
                                          color: member.gender.toLowerCase() ==
                                                  "female"
                                              ? Colors.pinkAccent
                                              : Colors.blueAccent,
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),

                                      // Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'DoB: '
                                              '${DateFormat('dd MMM yyyy').format(DateTime.parse(member.dob))}',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(height: 4.0),
                                            Text(
                                              '${member.title} ${member.name} ${member.surname}',
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                            const SizedBox(height: 4.0),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.people_alt,
                                                  color: Colors.white70,
                                                  size: 15,
                                                ),
                                                const SizedBox(width: 4.0),
                                                Text(
                                                  'Relationship: ${member.relationship}',
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white70,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4.0),
                                            Row(
                                              children: [
                                                Spacer(),
                                                Container(
                                                  height: 30,
                                                  child: TextButton(
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      SalesService
                                                          salesService =
                                                          SalesService();
                                                      String product = "";
                                                      String prod_type = "";
                                                      double cover_amount = 0;
                                                      // print("gfhghg ${Constants.currentParlorConfig}");
                                                      if (Constants
                                                              .currentParlourConfig ==
                                                          null) {
                                                        SalesService
                                                            salesService =
                                                            SalesService();
                                                        await salesService
                                                            .fetchAndStoreParlourRates();
                                                        if (Constants
                                                                    .currentParlourConfig !=
                                                                null &&
                                                            Constants
                                                                .currentParlourConfig!
                                                                .mainRates
                                                                .isNotEmpty) {
                                                          // Use the first rate’s product as the default.
                                                          product = Constants
                                                              .currentParlourConfig!
                                                              .mainRates
                                                              .first
                                                              .product;

                                                          // Filter all rates for this product.
                                                          List<MainRate>
                                                              ratesForProduct =
                                                              Constants
                                                                  .currentParlourConfig!
                                                                  .mainRates
                                                                  .where((rate) =>
                                                                      rate.product ==
                                                                      product)
                                                                  .toList();

                                                          if (ratesForProduct
                                                              .isNotEmpty) {
                                                            // Use the first matching rate's product type.
                                                            prod_type =
                                                                ratesForProduct
                                                                    .first
                                                                    .prodType;

                                                            // Now filter again for rates that match both product and product type.
                                                            List<MainRate>
                                                                ratesForProdType =
                                                                ratesForProduct
                                                                    .where((rate) =>
                                                                        rate.prodType ==
                                                                        prod_type)
                                                                    .toList();

                                                            if (ratesForProdType
                                                                .isNotEmpty) {
                                                              // Set the cover amount from the first matching rate.
                                                              cover_amount =
                                                                  ratesForProdType
                                                                      .first
                                                                      .amount;
                                                            }
                                                          }
                                                        }
                                                      }

                                                      if (Constants
                                                              .currentParlourConfig !=
                                                          null) {
                                                        if (Constants
                                                            .currentParlourConfig!
                                                            .mainRates
                                                            .isNotEmpty) {
                                                          product = Constants
                                                              .currentParlourConfig!
                                                              .mainRates
                                                              .first
                                                              .product;
                                                          prod_type = Constants
                                                              .currentParlourConfig!
                                                              .mainRates
                                                              .first
                                                              .prodType;
                                                        }
                                                      }
                                                      bool success =
                                                          await salesService
                                                              .createNewPolicy(
                                                        leadId: Constants
                                                            .currentleadAvailable!
                                                            .leadObject
                                                            .onololeadid,
                                                        additionalMemberId:
                                                            member.autoNumber,
                                                        productType: prod_type,
                                                        reference: "none",
                                                        productFamily: product,
                                                        clientId: Constants
                                                            .cec_client_id,
                                                      );

                                                      if (success) {
                                                        SalesService
                                                            salesService =
                                                            SalesService();
                                                        salesService
                                                            .getLeadById(Constants
                                                                .currentleadAvailable!
                                                                .leadObject
                                                                .onololeadid
                                                                .toString())
                                                            .then((val) {
                                                          activeStep1 = 2;

                                                          //Navigator.of(context).pop();

                                                          obtainMainInsuredForEachPolicy();

                                                          policyPremiums.add(
                                                              CalculatePolicyPremiumResponse(
                                                            cecClientId: Constants
                                                                .cec_client_id,
                                                            mainInsuredDob: "",
                                                            partnersDobs: [],
                                                            totalPremium: 0,
                                                            joiningFee: 0.0,
                                                            memberPremiums: [
                                                              MemberPremium(
                                                                  rateId: 0,
                                                                  role: '',
                                                                  age: 0,
                                                                  premium: 0,
                                                                  coverAmount:
                                                                      0,
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
                                                          ));
                                                          policiesSelectedProducts
                                                              .add(product);
                                                          policiesSelectedProdTypes
                                                              .add(prod_type);
                                                          policiesSelectedCoverAmounts
                                                              .add(
                                                                  cover_amount);
                                                          calculatePolicyPremiumCal(
                                                              false);

                                                          /*  Navigator.pushReplacement(
                                                                               context,
                                                                               MaterialPageRoute(
                                                                                   builder: (context) =>
                                                                                       FieldSalesPaperlessSales()),
                                                                             );*/
                                                        });
                                                        /*  mySalesPremiumCalculatorValue.value++;
                                                                         activeStep1--;
                                                                         updateSalesStepsValueNotifier3.value++;
                                                                         activeStep1++;
                                                                         updateSalesStepsValueNotifier3.value++;*/
                                                        print(
                                                            "Policy successfully created!");
                                                        // calculatePolicyPremiumCal(false);
                                                      } else {
                                                        print(
                                                            "Policy creation failed.");
                                                      }
                                                      // 3) Recalculate premium
                                                      if (mounted)
                                                        onPolicyUpdated2(
                                                            context, false);

                                                      // 4) Rebuild UI
                                                      if (mounted)
                                                        setState(() {});
                                                      advancedMemberCardKey2 =
                                                          UniqueKey();
                                                      if (mounted)
                                                        setState(() {});
                                                      appBarMemberCardNotifier
                                                          .value++;
                                                    },
                                                    child: Text(
                                                      'Select',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'YuGothic',
                                                        color: Constants
                                                            .ctaColorLight,
                                                      ),
                                                    ),
                                                    style: TextButton.styleFrom(
                                                        foregroundColor:
                                                            Constants
                                                                .ctaColorLight,
                                                        backgroundColor:
                                                            Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          activeStep1 = 2;
                          updateSalesStepsValueNotifier3.value++;
                          Navigator.of(context).pop();

                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              // set to false if you want to force a rating
                              builder: (context) => StatefulBuilder(
                                    builder: (context, setState) => Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(64),
                                      ),
                                      elevation: 0.0,
                                      backgroundColor: Colors.transparent,
                                      child: Container(
                                        // width: MediaQuery.of(context).size.width,

                                        constraints: BoxConstraints(
                                          maxWidth: (Constants
                                                  .currentleadAvailable!
                                                  .leadObject
                                                  .documentsIndexed
                                                  .isEmpty)
                                              ? 750
                                              : 1200,
                                        ),
                                        margin: const EdgeInsets.only(top: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 10.0,
                                              offset: Offset(0.0, 10.0),
                                            ),
                                          ],
                                        ),
                                        child: NewMemberDialog(
                                          isEditMode: false,
                                          autoNumber: 0,
                                          relationship: "",
                                          title: "",
                                          name: "",
                                          surname: "",
                                          dob: "",
                                          gender: "",
                                          current_member_index:
                                              current_member_index,
                                          canAddMember: false,
                                        ),
                                      ),
                                    ),
                                  ));
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Add New Member',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'YuGothic',
                              color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.teal,
                            backgroundColor: Constants.ctaColorLight),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildChildrenList(canAddMember) {
    // If no policies are available, show a fallback.
    if (Constants.currentleadAvailable!.policies.isEmpty) {
      return const Center(
        child: Text(
          "No children available for this policy.",
          style: TextStyle(fontSize: 14, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      );
    }

    // 1) Get the current policy and its reference.
    final policy =
        Constants.currentleadAvailable!.policies[current_member_index];
    final String currentReference = policy.reference;

    // -----------------------------
    // A) Gather children from policy.members
    // -----------------------------
    final List<dynamic> membersList = policy.members ?? [];

    // Filter out members that have type "child" and match the current reference.
    final childAutoNumbersFromPolicy = membersList
        .where((m) {
          if (m is Map<String, dynamic>) {
            return (m['type'] as String?)?.toLowerCase() == 'child' &&
                m['reference'] == currentReference;
          } else if (m is Member) {
            return (m.type ?? '').toLowerCase() == 'child' &&
                m.reference == currentReference;
          }
          return false;
        })
        .map<int>((m) {
          if (m is Map<String, dynamic>) {
            return (m['additional_member_id'] ?? -1) as int;
          } else if (m is Member) {
            return m.autoNumber ?? -1;
          }
          return -1;
        })
        .where((num) => num != -1)
        .toList();

    // Convert those auto numbers to AdditionalMember objects.
    final List<AdditionalMember> childMembersFromPolicy = [];
    for (int autoNum in childAutoNumbersFromPolicy) {
      try {
        final foundAM = Constants.currentleadAvailable!.additionalMembers
            .firstWhere((am) => am.autoNumber == autoNum);
        childMembersFromPolicy.add(foundAM);
      } catch (e) {
        // Log or handle not found case if needed
        debugPrint("Child not found for autoNumber=$autoNum => $e");
      }
    }

    // 4) Build the grid of child cards using a layout similar to your partner example
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of columns
        crossAxisSpacing: 16.0, // Space between columns
        mainAxisSpacing: 16.0, // Space between rows
        mainAxisExtent: 225, // Height per grid item
      ),
      itemCount: childMembersFromPolicy.length,
      itemBuilder: (context, index) {
        final AdditionalMember child = childMembersFromPolicy[index];

        double premium = 0.0;

        // Construct the role string, e.g. "partner_1", "partner_2", ...
        final partnerRole = 'child_${index + 1}';
        List<dynamic> extendedMemberRates =
            Constants.currentParlourConfig!.extendedMemberRates;
        final int memberKey = child.autoNumber ?? index;
        double cover1 = 0.0;

        // Safely look up the matching MemberPremium in policyPremiums
        if (policyPremiums.length > current_member_index) {
          final calcResponse = policyPremiums[current_member_index];

          // Attempt to find a matching role
          final matchedPremium = calcResponse.memberPremiums.firstWhere(
              (mp) => mp.role == partnerRole,
              orElse: () => MemberPremium(
                  rateId: 0,
                  role: '',
                  age: 0,
                  premium: 0,
                  coverAmount: 0,
                  comment: ""));

          // If found, and cover_amount is not null, use it
          if (matchedPremium != null && matchedPremium.coverAmount != null) {
            cover1 = matchedPremium.coverAmount!;
            premium = matchedPremium.premium!;
            if (cover1 == 0) {
              final mainInsuredPremium = calcResponse.memberPremiums.firstWhere(
                (mp) => mp.role == "main_insured",
                orElse: () => MemberPremium(
                    rateId: 0,
                    role: '',
                    age: 0,
                    premium: 0,
                    coverAmount: 0,
                    comment: ""),
              );

              cover1 = mainInsuredPremium.coverAmount;
            }
          }
        }

        return CustomCard2(
          elevation: 8,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          boderRadius: 12,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Constants.ftaColorLight.withOpacity(0.95),
              ),
            ),
            margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
            padding: const EdgeInsets.all(0.0),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Stretch to tallest child
              children: [
                // Left container with CircleAvatar
                Container(
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    color: Constants.ftaColorLight.withOpacity(0.95),
                  ),
                  child: Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.withOpacity(0.65),
                      child: Icon(
                        child.gender.toLowerCase() == "female"
                            ? Icons.female
                            : Icons.male,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                // Member information (flexible middle section)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 16.0,
                      left: 16,
                      top: 16,
                      bottom: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min, // Minimize height
                      children: [
                        if (child.dob.isNotEmpty)
                          Text(
                            'DoB: ${DateFormat('dd MMM yyyy').format(DateTime.parse(child.dob))}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'YuGothic',
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis, // Prevent overflow
                          ),
                        const SizedBox(height: 8.0),
                        Text(
                          '${child.title} ${child.name} ${child.surname}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                          ),
                          overflow: TextOverflow.ellipsis, // Prevent overflow
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Icon(Icons.people_alt,
                                color: Colors.black, size: 16),
                            const SizedBox(width: 4.0),
                            Expanded(
                              child: Text(
                                'Relationship: ${child.relationship[0].toUpperCase() + child.relationship.substring(1)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        if (cover1 != null)
                          Row(
                            children: [
                              Text(
                                'Premium: R${premium.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow:
                                    TextOverflow.ellipsis, // Prevent overflow
                              ),
                            ],
                          ),
                        const SizedBox(height: 8.0),
                        Builder(
                          builder: (context) {
                            final List<String> coverAmountItems =
                                (extendedMemberRates.isNotEmpty)
                                    ? extendedMemberRates
                                        .map<String>(
                                            (rate) => rate.amount.toString())
                                        .toSet()
                                        .toList()
                                    : [cover1.toStringAsFixed(2)];

                            // Get the currently selected cover value for this member.
                            String? selectedCover =
                                _selectedCoverAmounts[memberKey];
                            if (selectedCover == null &&
                                coverAmountItems.isNotEmpty) {
                              selectedCover = coverAmountItems[0];
                              _selectedCoverAmounts[memberKey] = selectedCover;
                            }

                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Cover: R${selectedCover}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                    isExpanded: true,
                                    alignment: AlignmentDirectional.center,
                                    hint: Row(
                                      children: [
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            "Select Cover Amount",
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
                                    items: coverAmountItems.map((String item) {
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
                                    value: selectedCover,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        if (newValue == null) return;
                                        // Parse the new cover value.
                                        double newCover =
                                            double.tryParse(newValue) ?? cover1;
                                        cover1 = newCover;
                                        _selectedCoverAmounts[memberKey] =
                                            newValue;
                                        print(
                                            "Selected cover for member $memberKey: $newValue");

                                        // Update the extended member's cover in the policy.members list.
                                        final int indexInMembers =
                                            membersList.indexWhere((m) {
                                          if (m is Map<String, dynamic>) {
                                            final int? autoNum =
                                                m['additional_member_id'] ??
                                                    m['additional_member_id'];

                                            final String? typeStr =
                                                m['type'] as String?;
                                            print(
                                                "Selected additional_member_id $autoNum: $typeStr");
                                            return autoNum == memberKey &&
                                                (typeStr?.toLowerCase() ==
                                                    'extended');
                                          } else if (m is Member) {
                                            return m.autoNumber == memberKey &&
                                                (m.type ?? '').toLowerCase() ==
                                                    'extended';
                                          }
                                          return false;
                                        });
                                        if (indexInMembers != -1) {
                                          if (membersList[indexInMembers]
                                              is Map<String, dynamic>) {
                                            (membersList[indexInMembers] as Map<
                                                String,
                                                dynamic>)['cover'] = newCover;
                                          } else if (membersList[indexInMembers]
                                              is Member) {
                                            (membersList[indexInMembers]
                                                    as Member)
                                                .cover = newCover;
                                          }
                                          policy.members = membersList;
                                        }
                                        cover1 = newCover;
                                        // Rebuild the list of cover amounts for all extended members in the current policy.
                                        List<double> updatedCovers =
                                            membersList.where((m) {
                                          if (m is Map<String, dynamic>) {
                                            final typeStr =
                                                m['type'] as String?;
                                            return (typeStr?.toLowerCase() ==
                                                    'extended') &&
                                                (m['reference'] ==
                                                    currentReference);
                                          } else if (m is Member) {
                                            return (m.type ?? '')
                                                        .toLowerCase() ==
                                                    'extended' &&
                                                m.reference == currentReference;
                                          }
                                          return false;
                                        }).map<double>((m) {
                                          if (m is Map<String, dynamic>) {
                                            return (m['cover'] as num?)
                                                    ?.toDouble() ??
                                                0.0;
                                          } else if (m is Member) {
                                            return m.cover ?? 0.0;
                                          }
                                          return 0.0;
                                        }).toList();
                                      });
                                    },
                                    buttonStyleData: ButtonStyleData(
                                      height: 45,
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(32),
                                        border:
                                            Border.all(color: Colors.black26),
                                        color: Colors.transparent,
                                      ),
                                      elevation: 0,
                                    ),
                                    iconStyleData: const IconStyleData(
                                      icon: Icon(
                                          Icons.arrow_forward_ios_outlined),
                                      iconSize: 14,
                                      iconEnabledColor: Colors.black,
                                      iconDisabledColor: Colors.transparent,
                                    ),
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
                                        thumbVisibility:
                                            MaterialStateProperty.all(true),
                                      ),
                                    ),
                                    menuItemStyleData: MenuItemStyleData(
                                      overlayColor: null,
                                      height: 40,
                                      padding: const EdgeInsets.only(
                                          left: 14, right: 14),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                ),
                // Right column with icons (delete/edit)
                Padding(
                  padding:
                      const EdgeInsets.only(top: 16.0, bottom: 16, right: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          removeChild(child, currentReference);
                          appBarMemberCardNotifier.value++;
                          advancedMemberCardKey2 = UniqueKey();
                        },
                        child: const Icon(CupertinoIcons.delete),
                      ),
                      InkWell(
                        onTap: () {
                          // Show dialog for editing the child
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => StatefulBuilder(
                              builder: (context, setState) => Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(64),
                                ),
                                elevation: 0.0,
                                backgroundColor: Colors.transparent,
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth: (Constants
                                            .currentleadAvailable!
                                            .leadObject
                                            .documentsIndexed
                                            .isEmpty)
                                        ? 750
                                        : 1200,
                                  ),
                                  margin: const EdgeInsets.only(top: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10.0,
                                        offset: Offset(0.0, 10.0),
                                      ),
                                    ],
                                  ),
                                  child: NewMemberDialog(
                                    isEditMode: true,
                                    autoNumber: child.autoNumber,
                                    relationship: "Child",
                                    title: child.title,
                                    name: child.name,
                                    surname: child.surname,
                                    dob: child.dob,
                                    phone: child.contact,
                                    idNumber: child.id,
                                    is_self_or_payer: false,
                                    gender: child.gender,
                                    canAddMember: true,
                                    current_member_index: current_member_index,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.edit,
                          color: Constants.ftaColorLight,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void removeChild(AdditionalMember child, String currentReference) {
    final policy =
        Constants.currentleadAvailable!.policies[current_member_index];
    final membersList = policy.members ?? [];
    // Remove from the policy's members
    membersList.removeWhere((m) {
      String memberType = "";
      int autoNumber = -1;
      if (m is Map<String, dynamic>) {
        memberType = (m['type'] ?? "").toLowerCase();
        autoNumber = m['additional_member_id'] as int? ?? -1;
      } else if (m is Member) {
        memberType = (m.type ?? "").toLowerCase();
        autoNumber = m.autoNumber ?? -1;
      }
      return memberType == "child" && autoNumber == child.autoNumber;
    });
    policy.members = membersList;

    // Optionally remove from policiesSelectedChildren, etc.
    // Then recalc premium, setState, etc.
    mySalesPremiumCalculatorValue.value++;
    setState(() {});
  }

  void showDoubleTapDialog(
    BuildContext context,
    canAddMember,
  ) {
    // --- TEMPORARY DIALOG VALUES (NOT GLOBAL) ---
    String? tempSelectedProduct;
    String? tempSelectedProductType;
    double? tempSelectedCoverAmount;
    List<String> tempDistinctProducts = [];
    List<String> tempDistinctProdTypes = [];
    List<double> tempDistinctCoverAmounts = [];
    // --- End Temporary Values ---

    // Extract distinct product names from mainRates, trimming whitespace.
    tempDistinctProducts = (Constants.currentParlourConfig?.mainRates ?? [])
        .map((r) => r.product.trim())
        .toSet()
        .toList()
      ..sort();

    if (kDebugMode) {
      print(
          "Dialog opened. Initial tempDistinctProducts: $tempDistinctProducts");
    }

    if (tempDistinctProducts.isEmpty) {
      tempDistinctProducts = ["No products available"];
    }

    showDialog(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: Container(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.all(16),
                  constraints: BoxConstraints(maxWidth: 500, maxHeight: 630),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: StatefulBuilder(
                    builder: (context, setState2) => SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Spacer(),
                              InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                  )),
                              SizedBox(width: 16)
                            ],
                          ),
                          SizedBox(height: 8),
                          Center(
                            child: Text(
                              "Change Product Details",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Constants.ftaColorLight,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 12),
                          Center(
                            child: Text(
                              "Please select a product below to continue ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'YuGothic',
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 24),

                          // --- Product Dropdown ---
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Product",
                              style: TextStyle(
                                fontFamily: 'YuGothic',
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          _buildDropdownContainer(
                            hint: 'Select a Product',
                            value: tempSelectedProduct,
                            items: tempDistinctProducts,
                            onChanged: (newValue) {
                              if (newValue == null) return;
                              setState2(() {
                                tempSelectedProduct = newValue.toString();
                                // Clear dependent selections
                                tempSelectedProductType = null;
                                tempSelectedCoverAmount = null;

                                // Filter rates by the chosen product
                                final productFilteredRates = Constants
                                    .currentParlourConfig!.mainRates
                                    .where((r) => r.product == newValue);
                                print(
                                    "productFilteredRates5 $productFilteredRates");

                                // Extract distinct product types from that subset
                                tempDistinctProdTypes = productFilteredRates
                                    .map((r) => r.prodType)
                                    .toSet()
                                    .toList()
                                  ..sort();
                                print(
                                    "distinctProdTypes5 $tempDistinctProdTypes");

                                // Clear cover amounts
                                tempDistinctCoverAmounts = [];
                              });
                            },
                          ),

                          // --- Product Type Dropdown ---
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 8),
                            child: Text(
                              "Product Type",
                              style: TextStyle(
                                fontFamily: 'YuGothic',
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          _buildDropdownContainer(
                            hint: 'Select a Product Type',
                            value: tempSelectedProductType,
                            items: tempDistinctProdTypes,
                            enabled: tempSelectedProduct != null &&
                                tempDistinctProdTypes.isNotEmpty,
                            onChanged: (newValue) {
                              if (newValue == null) return;
                              setState2(() {
                                tempSelectedProductType = newValue.toString();
                                // Clear cover amount selection
                                tempSelectedCoverAmount = null;

                                // Filter rates by product + prodType
                                final prodTypeFilteredRates = Constants
                                    .currentParlourConfig!.mainRates
                                    .where((r) =>
                                        r.product == tempSelectedProduct &&
                                        r.prodType == tempSelectedProductType);

                                // Extract distinct amounts
                                tempDistinctCoverAmounts = prodTypeFilteredRates
                                    .map((r) => r.amount)
                                    .toSet()
                                    .toList()
                                  ..sort();
                                print("ghggh $tempDistinctCoverAmounts");

                                // Remove zero values
                                tempDistinctCoverAmounts
                                    .removeWhere((cover) => cover == 0);
                              });
                            },
                          ),

                          // --- Cover Amount Dropdown ---
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 8),
                            child: Text(
                              "Cover Amount",
                              style: TextStyle(
                                fontFamily: 'YuGothic',
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          _buildDropdownContainer<double>(
                            hint: 'Select a cover amount',
                            value: tempSelectedCoverAmount,
                            items: tempDistinctCoverAmounts,
                            enabled: tempSelectedProductType != null &&
                                tempDistinctCoverAmounts.isNotEmpty,
                            onChanged: (newValue) {
                              if (newValue == null) return;
                              setState2(() {
                                tempSelectedCoverAmount = newValue;
                                print(
                                    "Selected cover amount: $tempSelectedCoverAmount");
                              });
                            },
                            itemToString: (double amount) =>
                                amount.toStringAsFixed(2),
                          ),

                          SizedBox(height: 32),
                          // --- Done Button ---
                          Center(
                            child: InkWell(
                              child: Container(
                                height: 40,
                                width: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(360),
                                  color: Constants.ctaColorLight,
                                ),
                                child: Center(
                                  child: Text(
                                    "Done",
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'YuGothic',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                // Validate selections
                                if (tempSelectedProduct != null &&
                                    tempSelectedProductType != null &&
                                    tempSelectedCoverAmount != null) {
                                  // Check if there are changes
                                  bool hasProductChanged = false;
                                  bool hasProductTypeChanged = false;
                                  bool hasCoverAmountChanged = false;

                                  // Check for changes
                                  if (policiesSelectedProducts.length >
                                      current_member_index) {
                                    hasProductChanged =
                                        policiesSelectedProducts[
                                                current_member_index] !=
                                            tempSelectedProduct;
                                  } else {
                                    hasProductChanged = true; // New entry
                                  }

                                  if (policiesSelectedProdTypes.length >
                                      current_member_index) {
                                    hasProductTypeChanged =
                                        policiesSelectedProdTypes[
                                                current_member_index] !=
                                            tempSelectedProductType;
                                  } else {
                                    hasProductTypeChanged = true; // New entry
                                  }

                                  if (policiesSelectedCoverAmounts.length >
                                      current_member_index) {
                                    hasCoverAmountChanged =
                                        policiesSelectedCoverAmounts[
                                                current_member_index] !=
                                            tempSelectedCoverAmount;
                                  } else {
                                    hasCoverAmountChanged = true; // New entry
                                  }

                                  // If there are changes, clear riders and reset member data
                                  if (hasProductChanged ||
                                      hasProductTypeChanged ||
                                      hasCoverAmountChanged) {
                                    print(
                                        "=== Product Details Changed - Clearing Members and Riders ===");

                                    final policy = Constants
                                        .currentleadAvailable!
                                        .policies[current_member_index];

                                    // === CLEAR ALL RIDERS ===
                                    if (policy.riders != null) {
                                      print(
                                          "Clearing ${policy.riders!.length} riders");
                                      policy.riders!.clear();
                                    }
                                    selectedRiderIds = [];

                                    // Reset selected riders total
                                    if (policyPremiums.length >
                                        current_member_index) {
                                      policyPremiums[current_member_index]
                                          .selectedRidersTotal = 0.0;
                                    }

                                    // === CLEAR ALL NON-MAIN MEMBERS ===
                                    final membersList = policy.members ?? [];
                                    List<dynamic> membersToRemove = [];

                                    // Collect all non-main members for removal
                                    for (var member in membersList) {
                                      String memberType = "";
                                      if (member is Map<String, dynamic>) {
                                        memberType = (member['type'] ?? "")
                                            .toString()
                                            .toLowerCase();
                                      } else if (member is Member) {
                                        memberType =
                                            (member.type ?? "").toLowerCase();
                                      }

                                      // Remove all members except main_member
                                      if (memberType != "main_member" &&
                                          memberType != "premium_payer") {
                                        membersToRemove.add(member);
                                      }
                                    }

                                    // Remove collected members
                                    for (var memberToRemove
                                        in membersToRemove) {
                                      membersList.remove(memberToRemove);
                                      print(
                                          "Removed member with type: ${memberToRemove is Map ? memberToRemove['type'] : (memberToRemove as Member).type}");
                                    }

                                    // Update policy members
                                    policy.members = membersList;

                                    // === UPDATE MAIN MEMBER COVER AND RESET PREMIUM ===
                                    for (var member in membersList) {
                                      if (member is Map<String, dynamic>) {
                                        String memberType =
                                            (member['type'] ?? "")
                                                .toString()
                                                .toLowerCase();
                                        if (memberType == "main_member" ||
                                            memberType == "premium_payer") {
                                          // Update cover amount to the new selected amount
                                          member['cover'] =
                                              tempSelectedCoverAmount;
                                          member['premium'] =
                                              0; // Reset premium since product changed

                                          print(
                                              "Updated main member - cover: ${member['cover']}, premium: ${member['premium']}");

                                          // Update in database
                                          try {
                                            SalesService salesService =
                                                SalesService();
                                            salesService
                                                .updateMember2(context, member)
                                                .catchError((e) {
                                              print(
                                                  "❌ Error updating main member in database: $e");
                                            });
                                          } catch (e) {
                                            print(
                                                "❌ Error updating main member in database: $e");
                                          }
                                        }
                                      } else if (member is Member) {
                                        String memberType =
                                            (member.type ?? "").toLowerCase();
                                        if (memberType == "main_member" ||
                                            memberType == "premium_payer") {
                                          // Update cover amount to the new selected amount
                                          member.cover =
                                              tempSelectedCoverAmount!
                                                  .toDouble();
                                          member.premium =
                                              0.0; // Reset premium since product changed

                                          print(
                                              "Updated main member object - cover: ${member.cover}, premium: ${member.premium}");
                                        }
                                      }
                                    }

                                    print(
                                        "=== Completed Member and Rider Cleanup ===");
                                  }

                                  // NOW UPDATE THE GLOBAL LISTS
                                  setState(() {
                                    // Ensure lists are large enough
                                    while (policiesSelectedProducts.length <=
                                        current_member_index) {
                                      policiesSelectedProducts.add('');
                                    }
                                    while (policiesSelectedProdTypes.length <=
                                        current_member_index) {
                                      policiesSelectedProdTypes.add('');
                                    }
                                    while (
                                        policiesSelectedCoverAmounts.length <=
                                            current_member_index) {
                                      policiesSelectedCoverAmounts.add(0.0);
                                    }
                                    while (policiescoverAmounts.length <=
                                        current_member_index) {
                                      policiescoverAmounts.add([]);
                                    }

                                    // Update global values
                                    policiesSelectedProducts[
                                            current_member_index] =
                                        tempSelectedProduct!;
                                    policiesSelectedProdTypes[
                                            current_member_index] =
                                        tempSelectedProductType!;
                                    policiesSelectedCoverAmounts[
                                            current_member_index] =
                                        tempSelectedCoverAmount!;
                                    policiescoverAmounts[current_member_index] =
                                        tempDistinctCoverAmounts;

                                    // Update global dropdown lists for future use
                                    selectedProduct = tempSelectedProduct;
                                    selectedProductType =
                                        tempSelectedProductType;
                                    selectedProductCoverAmount =
                                        tempSelectedCoverAmount;
                                    distinctProducts = tempDistinctProducts;
                                    distinctProdTypes = tempDistinctProdTypes;
                                    distinctCoverAmounts =
                                        tempDistinctCoverAmounts;

                                    // Update the policy quote
                                    Constants
                                            .currentleadAvailable!
                                            .policies[current_member_index]
                                            .quote
                                            .sumAssuredFamilyCover =
                                        tempSelectedCoverAmount!;
                                  });

                                  // Clear riders and trigger updates
                                  selectedRiderIds = [];
                                  mySalesPremiumCalculatorValue.value++;
                                  myConfirmPremiumClearValues.value++;

                                  // Update the UI key to force rebuild
                                  advancedMemberCardKey2 = UniqueKey();
                                  appBarMemberCardNotifier.value++;

                                  Navigator.of(context).pop();
                                } else {
                                  // Show error message
                                  MotionToast.warning(
                                    description: Center(
                                        child: Text(
                                            "Please complete all selections.",
                                            style: TextStyle(
                                                color: Colors.white))),
                                    animationType: AnimationType.fromTop,
                                    width: 350,
                                    height: 55,
                                  ).show(context);
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }

  void showDoubleTapDialogOld(
    BuildContext context,
    canAddMember,
  ) {
    // --- TEMPORARY DIALOG VALUES (NOT GLOBAL) ---
    String? tempSelectedProduct;
    String? tempSelectedProductType;
    double? tempSelectedCoverAmount;
    List<String> tempDistinctProducts = [];
    List<String> tempDistinctProdTypes = [];
    List<double> tempDistinctCoverAmounts = [];
    // --- End Temporary Values ---

    // Extract distinct product names from mainRates, trimming whitespace.
    tempDistinctProducts = (Constants.currentParlourConfig?.mainRates ?? [])
        .map((r) => r.product.trim())
        .toSet()
        .toList()
      ..sort();

    if (kDebugMode) {
      print(
          "Dialog opened. Initial tempDistinctProducts: $tempDistinctProducts");
    }

    if (tempDistinctProducts.isEmpty) {
      tempDistinctProducts = ["No products available"];
    }

    showDialog(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: Container(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.all(16),
                  constraints: BoxConstraints(maxWidth: 500, maxHeight: 630),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: StatefulBuilder(
                    builder: (context, setState2) => SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Spacer(),
                              InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                  )),
                              SizedBox(width: 16)
                            ],
                          ),
                          SizedBox(height: 8),
                          Center(
                            child: Text(
                              "Change Product Details",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Constants.ftaColorLight,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 12),
                          Center(
                            child: Text(
                              "Please select a product below to continue ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'YuGothic',
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 24),

                          // --- Product Dropdown ---
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Product",
                              style: TextStyle(
                                fontFamily: 'YuGothic',
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          _buildDropdownContainer(
                            hint: 'Select a Product',
                            value: tempSelectedProduct,
                            items: tempDistinctProducts,
                            onChanged: (newValue) {
                              if (newValue == null) return;
                              setState2(() {
                                tempSelectedProduct = newValue.toString();
                                // Clear dependent selections
                                tempSelectedProductType = null;
                                tempSelectedCoverAmount = null;

                                // Filter rates by the chosen product
                                final productFilteredRates = Constants
                                    .currentParlourConfig!.mainRates
                                    .where((r) => r.product == newValue);
                                print(
                                    "productFilteredRates5 $productFilteredRates");

                                // Extract distinct product types from that subset
                                tempDistinctProdTypes = productFilteredRates
                                    .map((r) => r.prodType)
                                    .toSet()
                                    .toList()
                                  ..sort();
                                print(
                                    "distinctProdTypes5 $tempDistinctProdTypes");

                                // Clear cover amounts
                                tempDistinctCoverAmounts = [];
                              });
                            },
                          ),

                          // --- Product Type Dropdown ---
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 8),
                            child: Text(
                              "Product Type",
                              style: TextStyle(
                                fontFamily: 'YuGothic',
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          _buildDropdownContainer(
                            hint: 'Select a Product Type',
                            value: tempSelectedProductType,
                            items: tempDistinctProdTypes,
                            enabled: tempSelectedProduct != null &&
                                tempDistinctProdTypes.isNotEmpty,
                            onChanged: (newValue) {
                              if (newValue == null) return;
                              setState2(() {
                                tempSelectedProductType = newValue.toString();
                                // Clear cover amount selection
                                tempSelectedCoverAmount = null;

                                // Filter rates by product + prodType
                                final prodTypeFilteredRates = Constants
                                    .currentParlourConfig!.mainRates
                                    .where((r) =>
                                        r.product == tempSelectedProduct &&
                                        r.prodType == tempSelectedProductType);

                                // Extract distinct amounts
                                tempDistinctCoverAmounts = prodTypeFilteredRates
                                    .map((r) => r.amount)
                                    .toSet()
                                    .toList()
                                  ..sort();
                                print("ghggh $tempDistinctCoverAmounts");

                                // Remove zero values
                                tempDistinctCoverAmounts
                                    .removeWhere((cover) => cover == 0);
                              });
                            },
                          ),

                          // --- Cover Amount Dropdown ---
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 8),
                            child: Text(
                              "Cover Amount",
                              style: TextStyle(
                                fontFamily: 'YuGothic',
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          _buildDropdownContainer<double>(
                            hint: 'Select a cover amount',
                            value: tempSelectedCoverAmount,
                            items: tempDistinctCoverAmounts,
                            enabled: tempSelectedProductType != null &&
                                tempDistinctCoverAmounts.isNotEmpty,
                            onChanged: (newValue) {
                              if (newValue == null) return;
                              setState2(() {
                                tempSelectedCoverAmount = newValue;
                                print(
                                    "Selected cover amount: $tempSelectedCoverAmount");
                              });
                            },
                            itemToString: (double amount) =>
                                amount.toStringAsFixed(2),
                          ),

                          SizedBox(height: 32),
                          // --- Done Button ---
                          Center(
                            child: InkWell(
                              child: Container(
                                height: 40,
                                width: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(360),
                                  color: Constants.ctaColorLight,
                                ),
                                child: Center(
                                  child: Text(
                                    "Done",
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'YuGothic',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                // Validate selections
                                if (tempSelectedProduct != null &&
                                    tempSelectedProductType != null &&
                                    tempSelectedCoverAmount != null) {
                                  // Check if there are changes
                                  bool hasProductChanged = false;
                                  bool hasProductTypeChanged = false;
                                  bool hasCoverAmountChanged = false;

                                  // Check for changes
                                  if (policiesSelectedProducts.length >
                                      current_member_index) {
                                    hasProductChanged =
                                        policiesSelectedProducts[
                                                current_member_index] !=
                                            tempSelectedProduct;
                                  } else {
                                    hasProductChanged = true; // New entry
                                  }

                                  if (policiesSelectedProdTypes.length >
                                      current_member_index) {
                                    hasProductTypeChanged =
                                        policiesSelectedProdTypes[
                                                current_member_index] !=
                                            tempSelectedProductType;
                                  } else {
                                    hasProductTypeChanged = true; // New entry
                                  }

                                  if (policiesSelectedCoverAmounts.length >
                                      current_member_index) {
                                    hasCoverAmountChanged =
                                        policiesSelectedCoverAmounts[
                                                current_member_index] !=
                                            tempSelectedCoverAmount;
                                  } else {
                                    hasCoverAmountChanged = true; // New entry
                                  }

                                  // Clear riders and update member cover amounts if there are changes
                                  if (hasProductChanged ||
                                      hasProductTypeChanged ||
                                      hasCoverAmountChanged) {
                                    final policy = Constants
                                        .currentleadAvailable!
                                        .policies[current_member_index];
                                    if (policy.riders != null) {
                                      policy.riders!.clear();
                                      selectedRiderIds = [];
                                    }

                                    // Update all members' cover amounts and reset premiums
                                    final membersList = policy.members ?? [];
                                    for (var member in membersList) {
                                      if (member is Map<String, dynamic>) {
                                        // Update cover amount to the new selected amount
                                        member['cover'] =
                                            tempSelectedCoverAmount;
                                        member['premium'] =
                                            0; // Reset premium since product/type/cover changed

                                        if (kDebugMode) {
                                          print(
                                              "Updated Map member: ${member['type']} - cover: ${member['cover']}, premium: ${member['premium']}");
                                        }

                                        // Update in database
                                        try {
                                          SalesService salesService =
                                              SalesService();
                                          salesService
                                              .updateMember2(context, member)
                                              .catchError((e) {
                                            print(
                                                "❌ Error updating member in database: $e");
                                          });
                                        } catch (e) {
                                          print(
                                              "❌ Error updating member in database: $e");
                                        }
                                      } else if (member is Member) {
                                        // Update cover amount to the new selected amount
                                        member.cover =
                                            tempSelectedCoverAmount!.toDouble();
                                        member.premium =
                                            0.0; // Reset premium since product/type/cover changed

                                        if (kDebugMode) {
                                          print(
                                              "Updated Member object: ${member.type} - cover: ${member.cover}, premium: ${member.premium}");
                                        }

                                        // If you have a method to update Member objects in database, call it here
                                        // Example: salesService.updateMemberObject(context, member);
                                      }
                                    }
                                  }

                                  // NOW UPDATE THE GLOBAL LISTS
                                  setState(() {
                                    // Ensure lists are large enough
                                    while (policiesSelectedProducts.length <=
                                        current_member_index) {
                                      policiesSelectedProducts.add('');
                                    }
                                    while (policiesSelectedProdTypes.length <=
                                        current_member_index) {
                                      policiesSelectedProdTypes.add('');
                                    }
                                    while (
                                        policiesSelectedCoverAmounts.length <=
                                            current_member_index) {
                                      policiesSelectedCoverAmounts.add(0.0);
                                    }
                                    while (policiescoverAmounts.length <=
                                        current_member_index) {
                                      policiescoverAmounts.add([]);
                                    }

                                    // Update global values
                                    policiesSelectedProducts[
                                            current_member_index] =
                                        tempSelectedProduct!;
                                    policiesSelectedProdTypes[
                                            current_member_index] =
                                        tempSelectedProductType!;
                                    policiesSelectedCoverAmounts[
                                            current_member_index] =
                                        tempSelectedCoverAmount!;
                                    policiescoverAmounts[current_member_index] =
                                        tempDistinctCoverAmounts;

                                    // Update global dropdown lists for future use
                                    selectedProduct = tempSelectedProduct;
                                    selectedProductType =
                                        tempSelectedProductType;
                                    selectedProductCoverAmount =
                                        tempSelectedCoverAmount;
                                    distinctProducts = tempDistinctProducts;
                                    distinctProdTypes = tempDistinctProdTypes;
                                    distinctCoverAmounts =
                                        tempDistinctCoverAmounts;

                                    // Update the policy quote
                                    Constants
                                            .currentleadAvailable!
                                            .policies[current_member_index]
                                            .quote
                                            .sumAssuredFamilyCover =
                                        tempSelectedCoverAmount!;
                                  });

                                  // Clear riders and trigger updates
                                  selectedRiderIds = [];
                                  mySalesPremiumCalculatorValue.value++;
                                  myConfirmPremiumClearValues.value++;

                                  Navigator.of(context).pop();
                                } else {
                                  // Show error message
                                  MotionToast.warning(
                                    description: Center(
                                        child: Text(
                                            "Please complete all selections.",
                                            style: TextStyle(
                                                color: Colors.white))),
                                    animationType: AnimationType.fromTop,
                                    width: 350,
                                    height: 55,
                                  ).show(context);
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }

  // Helper widget to reduce repetition for dropdown containers
  Widget _buildDropdownContainer<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    bool enabled = true, // Default to enabled
    String Function(T)? itemToString, // Optional function to format item text
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
            color: enabled
                ? Colors.transparent
                : Colors.grey.shade200, // Indicate disabled state
            border:
                Border.all(width: 1.0, color: Colors.grey.withOpacity(0.55)),
            borderRadius: BorderRadius.circular(360)),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(color: Colors.grey.withOpacity(0.55)))),
              child: Center(
                child: Icon(
                  Iconsax.icon, // Replace with a relevant icon if possible
                  size: 24,
                  color: enabled ? Colors.black : Colors.grey,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 48,
                // Wrap DropdownButton with ButtonTheme to align hint text
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<T>(
                      borderRadius: BorderRadius.circular(8),
                      dropdownColor: Colors.white,
                      style: const TextStyle(
                          fontFamily: 'YuGothic', color: Colors.black),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      // Adjusted padding
                      hint: Text(
                        hint,
                        style: TextStyle(
                            fontFamily: 'YuGothic', color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                      isExpanded: true,
                      value: value,
                      items: items
                          .map((T item) => DropdownMenuItem<T>(
                                value: item,
                                child: Text(
                                  itemToString != null
                                      ? itemToString(item)
                                      : item
                                          .toString(), // Use formatter if provided
                                  style: TextStyle(
                                      fontSize: 13.5,
                                      fontFamily: 'YuGothic',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      onChanged: enabled
                          ? onChanged
                          : null, // Disable onChanged if not enabled
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showDoubleTapDialog1(BuildContext context, canAddMember) {
    // Extract distinct product names from allRates
    // Extract distinct product names from mainRates, trimming whitespace.
    distinctProducts = Constants.currentParlourConfig!.mainRates
        .map((r) => r.product)
        .toSet() // This ensures uniqueness.
        .toList();
    // selectedProductType = null;
    if (kDebugMode) {
      print(
          "distinctProducts1: ${policiesSelectedProducts[current_member_index]} $distinctProducts");
    }

    // If no products available, provide a default.
    if (distinctProducts.isEmpty) {
      distinctProducts = ["No products available"];
    }

    // Get the currently selected product and trim it.
    String currentProduct = policiesSelectedProducts[current_member_index];
    String currentProdType = policiesSelectedProdTypes[current_member_index];
    selectedProductType = policiesSelectedProdTypes[current_member_index];
    //selectedC = policiesSelectedProdTypes[current_member_index];

    if (!distinctProducts.contains(currentProduct)) {
      print("Adding product1: $currentProduct");
      distinctProducts.add(currentProduct);
      // Reapply uniqueness and sort.
      distinctProducts = distinctProducts.toSet().toList()..sort();
    }
    if (!distinctProdTypes.contains(currentProdType)) {
      print("Adding prodtype2: $currentProduct");
      print("Adding prodtype2: $selectedProduct");
      // Filter allRates by the chosen product
      final productFilteredRates = Constants.currentParlourConfig!.mainRates
          .where((r) => r.product == currentProduct);
      print("productFilteredRates6 $productFilteredRates");

      // Extract distinct product types from that subset
      distinctProdTypes =
          productFilteredRates.map((r) => r.prodType).toSet().toList()..sort();
      print("distinctProdTypes6 $distinctProdTypes");

      // Clear any old amounts
      //distinctCoverAmounts = [];
      if (distinctProdTypes.isNotEmpty)
        policiesSelectedProdTypes[current_member_index] =
            distinctProdTypes.first;

      setState(() {});
    }

    //coverAmounts = [];
    showDialog(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: Colors.transparent, // Set to transparent
              elevation: 0.0,
              child: MovingLineDialog(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 550,
                  padding: EdgeInsets.all(16),
                  constraints: BoxConstraints(maxWidth: 500, maxHeight: 630),
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background color here
                    borderRadius: BorderRadius.circular(36),
                  ),
                  child: StatefulBuilder(
                    builder: (context, setState2) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 16),
                        Row(
                          children: [
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
                        SizedBox(height: 8),
                        Center(
                          child: Text(
                            "Change Product Details",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Constants.ftaColorLight,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 12),
                        Center(
                          child: Text(
                            "Please select a product below to continue ",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'YuGothic',
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Product",
                            style: TextStyle(
                              fontFamily: 'YuGothic',
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 2, right: 2, top: 8, bottom: 8),
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                          width: 1.0,
                                          color: Colors.grey.withOpacity(0.55)),
                                      borderRadius: BorderRadius.circular(360)),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 48,
                                        width: 48,
                                        //padding: EdgeInsets.only(left: 8),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                right: BorderSide(
                                                    color: Colors.grey
                                                        .withOpacity(0.55)))),
                                        child: Center(
                                          child: Icon(
                                            Iconsax.icon,
                                            size: 24,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 48,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                dropdownColor: Colors.white,
                                                style: const TextStyle(
                                                    fontFamily: 'YuGothic',
                                                    color: Colors.black),
                                                padding: const EdgeInsets.only(
                                                    left: 24,
                                                    right: 24,
                                                    top: 5,
                                                    bottom: 5),
                                                hint: const Text(
                                                  'Select a Product',
                                                  style: TextStyle(
                                                      fontFamily: 'YuGothic',
                                                      color: Colors.grey),
                                                ),
                                                isExpanded: true,
                                                value: selectedProduct,
                                                items: distinctProducts
                                                    .map((String classType) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                          value: classType,
                                                          child: Text(
                                                            classType,
                                                            style: TextStyle(
                                                                fontSize: 13.5,
                                                                fontFamily:
                                                                    'YuGothic',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ))
                                                    .toList(),
                                                onChanged: (newValue) {
                                                  selectedProduct =
                                                      newValue.toString();
                                                  setState2(() =>
                                                      onProductChanged(
                                                          newValue.toString()));
                                                  selectedProductType = null;
                                                  selectedProductCoverAmount =
                                                      null;
                                                  distinctCoverAmounts = [];
                                                }),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8),
                          child: Text(
                            "Product Type",
                            style: TextStyle(
                              fontFamily: 'YuGothic',
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 2, right: 2, top: 8, bottom: 8),
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                          width: 1.0,
                                          color: Colors.grey.withOpacity(0.55)),
                                      borderRadius: BorderRadius.circular(360)),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 48,
                                        width: 48,
                                        //padding: EdgeInsets.only(left: 8),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                right: BorderSide(
                                                    color: Colors.grey
                                                        .withOpacity(0.55)))),
                                        child: Center(
                                          child: Icon(
                                            Iconsax.icon,
                                            size: 24,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 48,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                dropdownColor: Colors.white,
                                                style: const TextStyle(
                                                    fontFamily: 'YuGothic',
                                                    color: Colors.black),
                                                padding: const EdgeInsets.only(
                                                    left: 24,
                                                    right: 24,
                                                    top: 5,
                                                    bottom: 5),
                                                hint: const Text(
                                                  'Select a Product Type',
                                                  style: TextStyle(
                                                      fontFamily: 'YuGothic',
                                                      color: Colors.grey),
                                                ),
                                                isExpanded: true,
                                                value: selectedProductType,
                                                items: distinctProdTypes
                                                    .map((String classType) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                          value: classType,
                                                          child: Text(
                                                            classType,
                                                            style: TextStyle(
                                                                fontSize: 13.5,
                                                                fontFamily:
                                                                    'YuGothic',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ))
                                                    .toList(),
                                                onChanged: (newValue) {
                                                  selectedProductType =
                                                      newValue.toString();
                                                  selectedProductCoverAmount =
                                                      null;
                                                  setState2(() =>
                                                      onProdTypeChanged(
                                                          newValue));
                                                }),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8),
                          child: Text(
                            "Cover Amount",
                            style: TextStyle(
                              fontFamily: 'YuGothic',
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        /*         Text(policiesSelectedCoverAmounts[current_member_index]
                            .toString()),
                        Text(distinctCoverAmounts.toString()),*/
                        /* Text(
                                policiesSelectedCoverAmounts[current_member_index]
                                    .toString()),
                            Text(distinctCoverAmounts.toString()),*/
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 2, right: 2, top: 8, bottom: 8),
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                          width: 1.0,
                                          color: Colors.grey.withOpacity(0.55)),
                                      borderRadius: BorderRadius.circular(360)),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 48,
                                        width: 48,
                                        //padding: EdgeInsets.only(left: 8),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                right: BorderSide(
                                                    color: Colors.grey
                                                        .withOpacity(0.55)))),
                                        child: Center(
                                          child: Icon(
                                            Iconsax.icon,
                                            size: 24,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 48,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                dropdownColor: Colors.white,
                                                style: const TextStyle(
                                                    fontFamily: 'YuGothic',
                                                    color: Colors.black),
                                                padding: const EdgeInsets.only(
                                                    left: 24,
                                                    right: 24,
                                                    top: 5,
                                                    bottom: 5),
                                                hint: const Text(
                                                  'Select a cover amount',
                                                  style: TextStyle(
                                                      fontFamily: 'YuGothic',
                                                      color: Colors.grey),
                                                ),
                                                isExpanded: true,
                                                value:
                                                    selectedProductCoverAmount,

                                                // Set null if value is not in the dropdown list.

                                                items: current_member_index >=
                                                        policiescoverAmounts
                                                            .length
                                                    ? null
                                                    : policiescoverAmounts[
                                                            current_member_index]
                                                        .map((double
                                                                coverAmount) =>
                                                            DropdownMenuItem<
                                                                double>(
                                                              value:
                                                                  coverAmount,
                                                              child: Text(
                                                                coverAmount
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13.5,
                                                                    fontFamily:
                                                                        'YuGothic',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ))
                                                        .toList(),
                                                onChanged: (newValue) {
                                                  if (selectedProductType ==
                                                      null) {
                                                    MotionToast.error(
                                                      //   title: Text("Error"),
                                                      description: Center(
                                                        child: Text(
                                                          "Select a product first",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                'YuGothic',
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),

                                                      animationType:
                                                          AnimationType.fromTop,
                                                      width: 350,
                                                      height: 55,
                                                      animationDuration:
                                                          const Duration(
                                                        milliseconds: 2500,
                                                      ),
                                                    ).show(context);
                                                    return;
                                                  }
                                                  selectedProductCoverAmount =
                                                      newValue;
                                                  setState(() =>
                                                      onCoverAmountChanged(
                                                          newValue, setState2));
                                                }),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                          ],
                        ),
                        SizedBox(height: 32),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /* InkWell(
                            child: Container(
                              height: 40,
                              width: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(250),
                                border: Border.all(
                                  width: changeColorIndex == 1 ? 0.0 : 1.0,
                                  color: Constants.ctaColorLight,
                                ),
                                color: changeColorIndex == 1
                                    ? Constants.ctaColorLight
                                    : Colors.transparent,
                              ),
                              child: Center(
                                child: Text(
                                  "Close",
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'YuGothic',
                                      color: changeColorIndex == 1
                                          ? Colors.white
                                          : Constants.ctaColorLight,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              */ /*  setState(() {
                                changeColorIndex = 1;
                              });
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(360),
                                  ),
                                  elevation: 0.0,
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    constraints:
                                        const BoxConstraints(minHeight: 250.0),
                                    child:
                                        EndCallDialog2(), // Replace with your actual widget
                                  ),
                                ),
                              );*/ /*
                            },
                          ),
                          SizedBox(width: 12),*/
                            InkWell(
                              child: Container(
                                height: 40,
                                width: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(360),
                                  border: Border.all(
                                    width: changeColorIndex == 2 ? 0.0 : 1.0,
                                    color: Constants.ctaColorLight,
                                  ),
                                  color: Constants.ctaColorLight,
                                ),
                                child: Center(
                                  child: Text(
                                    "Done",
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'YuGothic',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                selectedRiderIds = [];

                                // onPolicyUpdated2(context, true);

                                mySalesPremiumCalculatorValue.value++;
                                myConfirmPremiumClearValues.value++;

                                /* selectedProductRate =
                                    policyPremiums[current_member_index]
                                        .allMainRates
                                        .where((element) =>
                                            element.product ==
                                                policiesSelectedProducts[
                                                    current_member_index] &&
                                            element.prodType ==
                                                policiesSelectedProdTypes[
                                                    current_member_index] &&
                                            element.amount ==
                                                policiesSelectedCoverAmounts[
                                                    current_member_index])
                                        .first;*/
                                //full_product_id =selectedProductRate!.fullProductId;
                                /*  full_product_id = 0;
                                selectedProductString =
                                    policiesSelectedProducts[
                                            current_member_index]! +
                                        " " +
                                        policiesSelectedProdTypes[
                                            current_member_index]!;*/
                                setState(() {});

                                //  print("fggffggf $full_product_id");
                                //   showDoubleTapDialog2(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  void showDoubleTapDialog2(BuildContext context, canAddMember) {
    // Filter additional members; adjust your filtering as needed.
    List<AdditionalMember> aalldditionalmembers = Constants
        .currentleadAvailable!.additionalMembers
        .where((m) =>
            ((m.dob.isNotEmpty && m.relationship.toLowerCase() != "self") ||
                m.autoNumber != mainMembers[current_member_index].autoNumber))
        .toList();

    print("Total additional members2: ${aalldditionalmembers.length}");

    showDialog(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: Colors.transparent, // Set to transparent
              elevation: 0.0,
              child: MovingLineDialog(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(16),
                  constraints:
                      const BoxConstraints(maxWidth: 500, maxHeight: 630),
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color for the dialog
                    borderRadius: BorderRadius.circular(36),
                  ),
                  child: StatefulBuilder(
                    builder: (context, setState1) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 16),
                        Row(
                          children: [
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

                        SizedBox(height: 8),
                        const Center(
                          child: Text(
                            "Select the Main Insured",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              // Use your desired color here:
                              // For example, Constants.ftaColorLight,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Center(
                          child: Text(
                            "Click on a member below to select a main insured",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'YuGothic',
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: aalldditionalmembers.length,
                          itemBuilder: (context, index) {
                            AdditionalMember member =
                                aalldditionalmembers[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();

                                // Format the member's DOB as "yyyy-MM-dd"
                                String formattedDob = member.dob.contains("T")
                                    ? member.dob.split("T").first
                                    : member.dob;
                                print("Formatted DOB: $formattedDob");

                                // Debug prints
                                print(
                                    "Current member index: $current_member_index");
                                print(
                                    "Before update, policiesSelectedMainInsuredDOBs: $policiesSelectedMainInsuredDOBs");

                                // Update policiesSelectedMainInsuredDOBs
                                if (current_member_index <
                                    policiesSelectedMainInsuredDOBs.length) {
                                  // Replace the existing DOB at current_member_index.
                                  policiesSelectedMainInsuredDOBs[
                                      current_member_index] = formattedDob;
                                  print(
                                      "Replaced existing DOB at index $current_member_index");
                                } else {
                                  // Add the new DOB if the list isn't long enough.
                                  policiesSelectedMainInsuredDOBs
                                      .add(formattedDob);
                                  print("Added new DOB: $formattedDob");
                                }

                                // If mainMembers is empty, add the member.
                                if (mainMembers.isEmpty) {
                                  mainMembers.add(member);
                                  print(
                                      "Added member to mainMembers: ${member.name}");
                                }

                                // Optionally, call your function to update main insured values.
                                obtainMainInsuredForEachPolicy();

                                print(
                                    "After update, policiesSelectedMainInsuredDOBs: $policiesSelectedMainInsuredDOBs");

                                setState(() {});
                                mySalesPremiumCalculatorValue.value++;
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Constants.ftaColorLight.withOpacity(0.9),
                                      Constants.ftaColorLight,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Profile Avatar
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        member.gender.toLowerCase() == "female"
                                            ? Icons.female
                                            : Icons.male,
                                        size: 24,
                                        color: member.gender.toLowerCase() ==
                                                "female"
                                            ? Colors.pinkAccent
                                            : Colors.blueAccent,
                                      ),
                                    ),
                                    const SizedBox(width: 16.0),
                                    // Member Information
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // DoB
                                          if (member.dob.isNotEmpty)
                                            Text(
                                              'DoB: ${DateFormat('dd MMM yyyy').format(DateTime.parse(member.dob))}',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          const SizedBox(height: 4.0),
                                          // Member Name
                                          Text(
                                            '${member.title} ${member.name} ${member.surname}',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          const SizedBox(height: 4.0),
                                          // Relationship
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.people_alt,
                                                color: Colors.white70,
                                                size: 15,
                                              ),
                                              const SizedBox(width: 4.0),
                                              Text(
                                                'Relationship: ${member.relationship}',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white70,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        // Optionally, a button to add a new partner manually.
                        Center(
                          child: TextButton.icon(
                            onPressed: () {
                              // activeStep = 2;
                              activeStep1 = 2;
                              updateSalesStepsValueNotifier3.value++;
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  // set to false if you want to force a rating
                                  builder: (context) => StatefulBuilder(
                                        builder: (context, setState) => Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(64),
                                          ),
                                          elevation: 0.0,
                                          backgroundColor: Colors.transparent,
                                          child: Container(
                                            // width: MediaQuery.of(context).size.width,

                                            constraints: BoxConstraints(
                                              maxWidth: (Constants
                                                      .currentleadAvailable!
                                                      .leadObject
                                                      .documentsIndexed
                                                      .isEmpty)
                                                  ? 750
                                                  : 1200,
                                            ),
                                            margin:
                                                const EdgeInsets.only(top: 16),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 10.0,
                                                  offset: Offset(0.0, 10.0),
                                                ),
                                              ],
                                            ),
                                            child: NewMemberDialog(
                                              isEditMode: false,
                                              autoNumber: 0,
                                              relationship: "Partner",
                                              title: "",
                                              name: "",
                                              surname: "",
                                              dob: "",
                                              gender: "",
                                              current_member_index:
                                                  current_member_index,
                                              canAddMember: canAddMember,
                                            ),
                                          ),
                                        ),
                                      ));
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Add A Partner',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'YuGothic',
                                color: Colors.white,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.teal,
                              backgroundColor: Constants.ctaColorLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  void onProductChanged(String? newValue) {
    setState(() {
      policiesSelectedProducts[current_member_index] = newValue!;

      _selectedProdType = null;
      _selectedCoverAmount = null;

      // Filter allRates by the chosen product
      final productFilteredRates = Constants.currentParlourConfig!.mainRates
          .where((r) => r.product == newValue);
      print("productFilteredRates5 $productFilteredRates");

      // Extract distinct product types from that subset
      distinctProdTypes =
          productFilteredRates.map((r) => r.prodType).toSet().toList()..sort();
      print("distinctProdTypes5 $distinctProdTypes");

      // Clear any old amounts
      distinctCoverAmounts = [];
      if (distinctProdTypes.isNotEmpty) {
        // Ensure `policiesSelectedProdTypes` is large enough for `current_member_index`
        while (policiesSelectedProdTypes.length <= current_member_index) {
          // Add a placeholder (e.g. an empty string)
          policiesSelectedProdTypes.add('');
        }

        // Now it’s safe to set the item at [current_member_index].
        policiesSelectedProdTypes[current_member_index] =
            distinctProdTypes.first;
      }

      _selectedProdType = distinctProdTypes.first;
      setState(() {});
    });
  }

  void onProdTypeChanged(String? newValue) {
    setState(() {
      policiesSelectedProdTypes[current_member_index] = newValue!;
      _selectedCoverAmount = null;

      // Filter allRates by product + prodType
      final prodTypeFilteredRates = Constants.currentParlourConfig!.mainRates
          .where((r) =>
              r.product == selectedProduct &&
              r.prodType == selectedProductType);

      // Extract distinct amounts
      distinctCoverAmounts =
          prodTypeFilteredRates.map((r) => r.amount).toSet().toList()..sort();
      print("ghggh $distinctCoverAmounts");

      // Remove zero values
      distinctCoverAmounts.removeWhere((cover) => cover == 0);

      // Ensure _selectedCoverAmount is valid
      if (distinctCoverAmounts.isNotEmpty) {
        List<MainRate> prodTypeFilteredRates = Constants
            .currentParlourConfig!.mainRates
            .where((r) => (r.product == selectedProduct &&
                r.prodType == selectedProductType))
            .toList();
        while (policiescoverAmounts.length <= current_member_index) {
          // If you store a list of doubles in each slot:
          policiescoverAmounts.add([]);
        }

        // Update policiescoverAmounts with the new distinct cover amounts
        policiescoverAmounts[current_member_index] = distinctCoverAmounts;

        //policiesSelectedCoverAmounts[current_member_index] =prodTypeFilteredRates.first.amount;
        Constants.currentleadAvailable!.policies[current_member_index].quote
            .sumAssuredFamilyCover = prodTypeFilteredRates.first.amount;
      } else {
        _selectedCoverAmount = null;
        // Clear the cover amounts when no product type is selected
        if (policiescoverAmounts.length > current_member_index) {
          policiescoverAmounts[current_member_index] = [];
        }
      }
    });
  }

  void onCoverAmountChanged(
      double? newValue, void Function(VoidCallback) setState1) {
    if (mounted)
      setState1(() {
        // Update the dialog UI properly
        // Filter rates using the updated product and product type values.
        List<MainRate> prodTypeFilteredRates = Constants
            .currentParlourConfig!.mainRates
            .where((r) =>
                r.product == policiesSelectedProducts[current_member_index] &&
                r.prodType == policiesSelectedProdTypes[current_member_index])
            .toList();

        print(
            "Total rates: ${Constants.currentParlourConfig!.mainRates.length}, Filtered: ${prodTypeFilteredRates.length}");

        // Build a sorted list of distinct amounts
        final Set<double> allAmounts = {};
        for (var r in prodTypeFilteredRates) {
          allAmounts.add(r.amount);
        }
        final sortedAmounts = allAmounts.toList()..sort();

        // Update policiescoverAmounts and the selected cover amount for the current member
        if (policiescoverAmounts.length <= current_member_index) {
          policiescoverAmounts.add(sortedAmounts);
        } else {
          policiescoverAmounts[current_member_index] = sortedAmounts;
        }

        if (policiesSelectedCoverAmounts.length <= current_member_index) {
          policiesSelectedCoverAmounts.add(newValue!);
        } else {
          policiesSelectedCoverAmounts[current_member_index] = newValue!;
        }

        Constants.currentleadAvailable!.policies[current_member_index].quote
            .sumAssuredFamilyCover = newValue!;

        _selectedCoverAmount = newValue;
        policiesSelectedCoverAmounts[current_member_index] = newValue;

        print("Selected cover amount: ${_selectedCoverAmount}");
        print("Selected cover amount: ${policiesSelectedCoverAmounts}");
        //  onPolicyUpdated2(context, true);
      });
  }

  void showDoubleTapDialog3(BuildContext context, canAddMember) {
    List<String> productList = [];
    List<AdditionalMember> aalldditionalmembers = Constants
        .currentleadAvailable!.additionalMembers
        .where((m) => ((m.relationship.toLowerCase() != "child") &&
            m.autoNumber != mainMembers[current_member_index].autoNumber))
        .toList();

    print("Available members: ${aalldditionalmembers.length}");
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        child: MovingLineDialog(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(16),
            constraints: BoxConstraints(maxWidth: 500, maxHeight: 630),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36),
            ),
            child: StatefulBuilder(
              builder: (context, setState1) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16),
                  Row(
                    children: [
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
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      "Select the Main Member",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Constants.ftaColorLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 12),
                  Center(
                    child: Text(
                      "Click on a member below to select a member",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'YuGothic',
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 400,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: aalldditionalmembers.length,
                      itemBuilder: (context, index) {
                        AdditionalMember member = aalldditionalmembers[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 16.0,
                          ),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                if (member.dob.isNotEmpty)
                                  Constants.ftaColorLight.withOpacity(0.9),
                                if (member.dob.isNotEmpty)
                                  Constants.ftaColorLight,
                                if (member.dob.isEmpty)
                                  Colors.red.withOpacity(0.9),
                                if (member.dob.isEmpty) Colors.red,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Profile Avatar
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  member.gender.toLowerCase() == "female"
                                      ? Icons.female
                                      : Icons.male,
                                  size: 24,
                                  color: member.gender.toLowerCase() == "female"
                                      ? Colors.pinkAccent
                                      : Colors.blueAccent,
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              // Member Information
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (member.dob.isNotEmpty)
                                      Text(
                                        'DoB: ${(DateFormat('dd MMM yyyy').format(DateTime.parse(member.dob)))}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      '${member.title} ${member.name} ${member.surname}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.people_alt,
                                          color: Colors.white70,
                                          size: 15,
                                        ),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          'Relationship: ${member.relationship}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Spacer(),
                                        Container(
                                          height: 30,
                                          child: TextButton(
                                            onPressed: () async {
                                              Navigator.of(context).pop();

                                              // Store the old premium payer BEFORE any updates
                                              final AdditionalMember
                                                  oldPremiumPayer = mainMembers[
                                                      current_member_index];
                                              final AdditionalMember
                                                  newPremiumPayer = member;

                                              print(
                                                  "=== MEMBER SELECTION DEBUG ===");
                                              print(
                                                  "Current member index: $current_member_index");
                                              print(
                                                  "Old premium payer: ${oldPremiumPayer.name} (${oldPremiumPayer.autoNumber})");
                                              print(
                                                  "New premium payer: ${newPremiumPayer.name} (${newPremiumPayer.autoNumber})");

                                              // Format the member's DOB as "yyyy-MM-dd"
                                              final String formattedDob = member
                                                      .dob
                                                      .contains("T")
                                                  ? member.dob.split("T").first
                                                  : member.dob;
                                              print(
                                                  "Formatted DOB: $formattedDob");

                                              // Update policiesSelectedMainInsuredDOBs
                                              if (current_member_index <
                                                  policiesSelectedMainInsuredDOBs
                                                      .length) {
                                                policiesSelectedMainInsuredDOBs[
                                                        current_member_index] =
                                                    formattedDob;
                                                print(
                                                    "Replaced existing DOB at index $current_member_index with $formattedDob");
                                              } else {
                                                policiesSelectedMainInsuredDOBs
                                                    .add(formattedDob);
                                                print(
                                                    "Added new DOB: $formattedDob");
                                              }

                                              // === Premium Payer Change Logic ===
                                              if (Constants
                                                      .currentleadAvailable !=
                                                  null) {
                                                print(
                                                    "=== STARTING PREMIUM PAYER CHANGE ===");

                                                AdditionalMember?
                                                    updatedOldPayer;
                                                AdditionalMember?
                                                    updatedNewPayer;

                                                // --- Step 1: Update the OLD premium payer ---
                                                final int oldPayerIndex =
                                                    Constants
                                                        .currentleadAvailable!
                                                        .additionalMembers
                                                        .indexWhere((m) =>
                                                            m.autoNumber ==
                                                            oldPremiumPayer
                                                                .autoNumber);

                                                if (oldPayerIndex != -1) {
                                                  final String
                                                      oldPayerNewRelationship =
                                                      getOldPayerRelationship(
                                                    newPremiumPayer.relationship
                                                        .toLowerCase(),
                                                    oldPremiumPayer.relationship
                                                        .toLowerCase(),
                                                    oldPremiumPayer,
                                                  );

                                                  print(
                                                      "Old payer new relationship: $oldPayerNewRelationship");

                                                  updatedOldPayer =
                                                      AdditionalMember(
                                                    memberType: oldPremiumPayer
                                                        .memberType,
                                                    autoNumber: oldPremiumPayer
                                                        .autoNumber,
                                                    id: oldPremiumPayer.id,
                                                    contact:
                                                        oldPremiumPayer.contact,
                                                    dob: oldPremiumPayer.dob,
                                                    gender:
                                                        oldPremiumPayer.gender,
                                                    name: oldPremiumPayer.name,
                                                    surname:
                                                        oldPremiumPayer.surname,
                                                    title:
                                                        oldPremiumPayer.title,
                                                    onololeadid: oldPremiumPayer
                                                        .onololeadid,
                                                    altContact: oldPremiumPayer
                                                        .altContact,
                                                    email:
                                                        oldPremiumPayer.email,
                                                    percentage: oldPremiumPayer
                                                        .percentage,
                                                    maritalStatus:
                                                        oldPremiumPayer
                                                            .maritalStatus,
                                                    relationship:
                                                        oldPayerNewRelationship, // Updated relationship
                                                    mipCover: oldPremiumPayer
                                                        .mipCover,
                                                    mipStatus: oldPremiumPayer
                                                        .mipStatus,
                                                    updatedBy: oldPremiumPayer
                                                        .updatedBy,
                                                    memberQueryType:
                                                        oldPremiumPayer
                                                            .memberQueryType,
                                                    memberQueryTypeOldNew:
                                                        oldPremiumPayer
                                                            .memberQueryTypeOldNew,
                                                    memberQueryTypeOldAutoNumber:
                                                        oldPremiumPayer
                                                            .memberQueryTypeOldAutoNumber,
                                                    membersAutoNumber:
                                                        oldPremiumPayer
                                                            .membersAutoNumber,
                                                    sourceOfIncome:
                                                        oldPremiumPayer
                                                            .sourceOfIncome,
                                                    sourceOfWealth:
                                                        oldPremiumPayer
                                                            .sourceOfWealth,
                                                    otherUnknownIncome:
                                                        oldPremiumPayer
                                                            .otherUnknownIncome,
                                                    otherUnknownWealth:
                                                        oldPremiumPayer
                                                            .otherUnknownWealth,
                                                    timestamp: oldPremiumPayer
                                                        .timestamp,
                                                    lastUpdate: DateTime.now()
                                                        .toIso8601String(),
                                                  );

                                                  // Update in global list
                                                  Constants.currentleadAvailable!
                                                              .additionalMembers[
                                                          oldPayerIndex] =
                                                      updatedOldPayer;
                                                  print(
                                                      "Updated old payer in global list");
                                                } else {
                                                  print(
                                                      "Warning: Could not find old premium payer in additionalMembers list.");
                                                }

                                                // --- Step 2: Update the NEW premium payer ---
                                                final int newPayerIndex =
                                                    Constants
                                                        .currentleadAvailable!
                                                        .additionalMembers
                                                        .indexWhere((m) =>
                                                            m.autoNumber ==
                                                            newPremiumPayer
                                                                .autoNumber);

                                                if (newPayerIndex != -1) {
                                                  updatedNewPayer =
                                                      AdditionalMember(
                                                    memberType: newPremiumPayer
                                                        .memberType,
                                                    autoNumber: newPremiumPayer
                                                        .autoNumber,
                                                    id: newPremiumPayer.id,
                                                    contact:
                                                        newPremiumPayer.contact,
                                                    dob: newPremiumPayer.dob,
                                                    gender:
                                                        newPremiumPayer.gender,
                                                    name: newPremiumPayer.name,
                                                    surname:
                                                        newPremiumPayer.surname,
                                                    title:
                                                        newPremiumPayer.title,
                                                    onololeadid: newPremiumPayer
                                                        .onololeadid,
                                                    altContact: newPremiumPayer
                                                        .altContact,
                                                    email:
                                                        newPremiumPayer.email,
                                                    percentage: newPremiumPayer
                                                        .percentage,
                                                    maritalStatus:
                                                        newPremiumPayer
                                                            .maritalStatus,
                                                    relationship:
                                                        "self", // New premium payer becomes "self"
                                                    mipCover: newPremiumPayer
                                                        .mipCover,
                                                    mipStatus: newPremiumPayer
                                                        .mipStatus,
                                                    updatedBy: newPremiumPayer
                                                        .updatedBy,
                                                    memberQueryType:
                                                        newPremiumPayer
                                                            .memberQueryType,
                                                    memberQueryTypeOldNew:
                                                        newPremiumPayer
                                                            .memberQueryTypeOldNew,
                                                    memberQueryTypeOldAutoNumber:
                                                        newPremiumPayer
                                                            .memberQueryTypeOldAutoNumber,
                                                    membersAutoNumber:
                                                        newPremiumPayer
                                                            .membersAutoNumber,
                                                    sourceOfIncome:
                                                        newPremiumPayer
                                                            .sourceOfIncome,
                                                    sourceOfWealth:
                                                        newPremiumPayer
                                                            .sourceOfWealth,
                                                    otherUnknownIncome:
                                                        newPremiumPayer
                                                            .otherUnknownIncome,
                                                    otherUnknownWealth:
                                                        newPremiumPayer
                                                            .otherUnknownWealth,
                                                    timestamp: newPremiumPayer
                                                        .timestamp,
                                                    lastUpdate: DateTime.now()
                                                        .toIso8601String(),
                                                  );

                                                  // Update in global list
                                                  Constants.currentleadAvailable!
                                                              .additionalMembers[
                                                          newPayerIndex] =
                                                      updatedNewPayer;
                                                  print(
                                                      "Updated new payer in global list with relationship: self");

                                                  // === CRITICAL FIX: Update mainMembers with the NEW payer ===
                                                  // This is the key fix - we need to set the selected member as the main member
                                                  if (current_member_index <
                                                      mainMembers.length) {
                                                    mainMembers[
                                                            current_member_index] =
                                                        updatedNewPayer;
                                                    print(
                                                        "✅ FIXED: Set mainMembers[$current_member_index] = ${updatedNewPayer.name}");
                                                  } else {
                                                    mainMembers
                                                        .add(updatedNewPayer);
                                                    print(
                                                        "✅ FIXED: Added ${updatedNewPayer.name} to mainMembers");
                                                  }

                                                  // Update policy members relationships
                                                  try {
                                                    if (current_member_index <
                                                        Constants
                                                            .currentleadAvailable!
                                                            .policies
                                                            .length) {
                                                      final policy = Constants
                                                              .currentleadAvailable!
                                                              .policies[
                                                          current_member_index];

                                                      // Update old payer's type in policy members (convert from main_member to their actual relationship)
                                                      final oldPayerMember =
                                                          policy.members
                                                              .firstWhere(
                                                        (member) =>
                                                            member[
                                                                "additional_member_id"] ==
                                                            oldPremiumPayer
                                                                .autoNumber,
                                                        orElse: () =>
                                                            <String, dynamic>{},
                                                      );
                                                      if (oldPayerMember
                                                              .isNotEmpty &&
                                                          updatedOldPayer !=
                                                              null) {
                                                        oldPayerMember["type"] =
                                                            updatedOldPayer
                                                                .relationship; // e.g., "spouse", "parent", etc.
                                                        print(
                                                            "Updated old payer policy type to: ${updatedOldPayer.relationship}");
                                                      }

                                                      // Update new payer's type in policy members (becomes main_member)
                                                      final newPayerMember =
                                                          policy.members
                                                              .firstWhere(
                                                        (member) =>
                                                            member[
                                                                "additional_member_id"] ==
                                                            newPremiumPayer
                                                                .autoNumber,
                                                        orElse: () =>
                                                            <String, dynamic>{},
                                                      );
                                                      if (newPayerMember
                                                          .isNotEmpty) {
                                                        newPayerMember["type"] =
                                                            "main_member"; // Policy type is main_member
                                                        print(
                                                            "Updated new payer policy type to: main_member");
                                                      }
                                                    }
                                                  } catch (e) {
                                                    print(
                                                        "Error updating policy members: $e");
                                                  }
                                                } else {
                                                  print(
                                                      "Warning: Could not find new premium payer in additionalMembers list.");
                                                }

                                                // --- Step 3: Synchronize with backend ---
                                                try {
                                                  if (updatedOldPayer != null) {
                                                    await updateMemberBackend(
                                                        context,
                                                        updatedOldPayer
                                                            .autoNumber,
                                                        updatedOldPayer);
                                                    print(
                                                        "Backend updated for old payer");
                                                  }
                                                  if (updatedNewPayer != null) {
                                                    await updateMemberBackend(
                                                        context,
                                                        updatedNewPayer
                                                            .autoNumber,
                                                        updatedNewPayer);
                                                    print(
                                                        "Backend updated for new payer");
                                                  }
                                                } catch (e) {
                                                  print(
                                                      "Error during backend update for premium payer change: $e");
                                                }
                                              }

                                              // Call functions to recalculate values and update UI
                                              obtainMainInsuredForEachPolicy();

                                              print(
                                                  "After update, policiesSelectedMainInsuredDOBs: $policiesSelectedMainInsuredDOBs");
                                              print(
                                                  "Final mainMembers[${current_member_index}]: ${mainMembers[current_member_index].name}");

                                              mySalesPremiumCalculatorValue
                                                  .value++;
                                              advancedMemberCardKey2 =
                                                  UniqueKey();
                                              setState(() {});
                                            },
                                            child: Text(
                                              'Select',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'YuGothic',
                                                color: Constants.ctaColorLight,
                                              ),
                                            ),
                                            style: TextButton.styleFrom(
                                              foregroundColor:
                                                  Constants.ctaColorLight,
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Add new member button
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        activeStep1 = 2;
                        updateSalesStepsValueNotifier3.value++;
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => StatefulBuilder(
                                  builder: (context, setState) => Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(64),
                                    ),
                                    elevation: 0.0,
                                    backgroundColor: Colors.transparent,
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth: (Constants
                                                .currentleadAvailable!
                                                .leadObject
                                                .documentsIndexed
                                                .isEmpty)
                                            ? 750
                                            : 1200,
                                      ),
                                      margin: const EdgeInsets.only(top: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 10.0,
                                            offset: Offset(0.0, 10.0),
                                          ),
                                        ],
                                      ),
                                      child: NewMemberDialog(
                                        isEditMode: false,
                                        autoNumber: 0,
                                        relationship: "self",
                                        title: "",
                                        name: "",
                                        surname: "",
                                        dob: "",
                                        gender: "",
                                        canAddMember: canAddMember,
                                        current_member_index:
                                            current_member_index,
                                      ),
                                    ),
                                  ),
                                ));
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Add A Main Member',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'YuGothic',
                          color: Colors.white,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.teal,
                        backgroundColor: Constants.ctaColorLight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildExtendedList() {
    // If no policies are available, return a fallback.
    if (Constants.currentleadAvailable!.policies.isEmpty) {
      return Center(
        child: Text(
          "No extended members available for this policy.",
          style: TextStyle(fontSize: 14, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      );
    }

    // 1) Get the current policy and its reference.
    final policy =
        Constants.currentleadAvailable!.policies[current_member_index];
    final String currentReference = policy.reference;

    // -----------------------------
    // A) Gather extended members from policy.members.
    // -----------------------------
    final List<dynamic> membersList = policy.members ?? [];
    final extendedAutoNumbersFromPolicy = membersList
        .where((m) {
          if (m is Map<String, dynamic>) {
            return (m['type'] as String?)?.toLowerCase() == 'extended' &&
                m['reference'] == currentReference;
          } else if (m is Member) {
            return (m.type ?? '').toLowerCase() == 'extended' &&
                m.reference == currentReference;
          }
          return false;
        })
        .map<int>((m) {
          if (m is Map<String, dynamic>) {
            return (m['additional_member_id'] ?? -1) as int;
          } else if (m is Member) {
            return m.autoNumber ?? -1;
          }
          return -1;
        })
        .where((num) => num != -1)
        .toList();

    final List<AdditionalMember> extendedMembersFromPolicy = [];
    for (int autoNum in extendedAutoNumbersFromPolicy) {
      try {
        final foundAM = Constants.currentleadAvailable!.additionalMembers
            .firstWhere((am) => am.autoNumber == autoNum);
        extendedMembersFromPolicy.add(foundAM);
      } catch (e) {
        debugPrint("Extended member not found for autoNumber: $autoNum => $e");
      }
    }

    // -----------------------------
    // D) Fallback if no extended members found.
    // -----------------------------
    if (extendedMembersFromPolicy.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "No extended members available for this policy.",
            style: TextStyle(fontSize: 14, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // -----------------------------
    // E) Build a grid of extended-member cards with a remove/edit function
    // -----------------------------
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of columns
        crossAxisSpacing: 16.0, // Space between columns
        mainAxisSpacing: 16.0, // Space between rows
        mainAxisExtent: 220, // Height for each grid item
      ),
      itemCount: extendedMembersFromPolicy.length,
      itemBuilder: (context, index) {
        final AdditionalMember member = extendedMembersFromPolicy[index];
        final int memberKey = member.autoNumber ?? index;
        List<dynamic> extendedMemberRates = [];
        if (member.relationship.toLowerCase() == "parent") {
          extendedMemberRates = Constants
              .currentParlourConfig!.extendedMemberRates
              .where((extended_rate) => (extended_rate.product ==
                      policiesSelectedProducts[current_member_index] &&
                  extended_rate.prodType ==
                      policiesSelectedProdTypes[current_member_index] &&
                  extended_rate.relationship.toLowerCase() == "parent" &&
                  extended_rate.minAge <=
                      calculateAge(DateTime.parse(member.dob)) &&
                  extended_rate.maxAge >=
                      calculateAge(DateTime.parse(member.dob))))
              .toList();
        } else {
          extendedMemberRates = Constants
              .currentParlourConfig!.extendedMemberRates
              .where((extended_rate) => (extended_rate.product ==
                      policiesSelectedProducts[current_member_index] &&
                  extended_rate.prodType ==
                      policiesSelectedProdTypes[current_member_index] &&
                  extended_rate.relationship.toLowerCase() == "extended" &&
                  extended_rate.minAge <=
                      calculateAge(DateTime.parse(member.dob)) &&
                  extended_rate.maxAge >=
                      calculateAge(DateTime.parse(member.dob))))
              .toList();
        }

        // Calculate default cover value from policyPremiums
        double cover1 = 0.0;
        double premium = 0.0;
        final partnerRole = 'extended_${index + 1}';
        if (policyPremiums.length > current_member_index) {
          final calcResponse = policyPremiums[current_member_index];
          final matchedPremium = calcResponse.memberPremiums.firstWhere(
            (mp) => mp.role == partnerRole,
            orElse: () => MemberPremium(
                rateId: 0,
                role: '',
                age: 0,
                premium: 0,
                coverAmount: 0,
                comment: ""),
          );
          if (matchedPremium.coverAmount != null &&
              matchedPremium.coverAmount != 0) {
            cover1 = matchedPremium.coverAmount!;
            premium = matchedPremium.premium!;
          } else {
            final mainInsuredPremium = calcResponse.memberPremiums.firstWhere(
              (mp) => mp.role == "main_insured",
              orElse: () => MemberPremium(
                  rateId: 0,
                  role: '',
                  age: 0,
                  premium: 0,
                  coverAmount: 0,
                  comment: ""),
            );
            cover1 = mainInsuredPremium.coverAmount;
          }
        }

        return CustomCard2(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          boderRadius: 12,
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Constants.ftaColorLight.withOpacity(0.95),
              ),
            ),
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left container with CircleAvatar
                Container(
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    color: Constants.ftaColorLight.withOpacity(0.95),
                  ),
                  child: Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.withOpacity(0.65),
                      child: Icon(
                        member.gender.toLowerCase() == "female"
                            ? Icons.female
                            : Icons.male,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                // Member information and dropdown
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 16.0, left: 16, top: 16, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (member.dob.isNotEmpty)
                          Text(
                            'DoB: ${DateFormat('dd MMM yyyy').format(DateTime.parse(member.dob))}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'YuGothic',
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: 8.0),
                        Text(
                          '${member.title} ${member.name} ${member.surname}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.people_alt,
                              color: Colors.black,
                              size: 16,
                            ),
                            const SizedBox(width: 4.0),
                            Expanded(
                              child: Text(
                                'Relationship: ${member.relationship[0].toUpperCase() + member.relationship.substring(1)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        if (cover1 != null)
                          Row(
                            children: [
                              Text(
                                'Premium: R${premium.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        const SizedBox(height: 8.0),

                        // Cover Amount Dropdown
                        Builder(
                          builder: (context) {
                            final List<String> coverAmountItems =
                                (extendedMemberRates.isNotEmpty)
                                    ? extendedMemberRates
                                        .map<String>(
                                            (rate) => rate.amount.toString())
                                        .toSet()
                                        .toList()
                                    : [cover1.toStringAsFixed(2)];

                            // Get the currently selected cover value for this member.
                            String? selectedCover =
                                _selectedCoverAmounts[memberKey];
                            if (selectedCover == null &&
                                coverAmountItems.isNotEmpty) {
                              selectedCover = coverAmountItems[0];
                              _selectedCoverAmounts[memberKey] = selectedCover;
                            }

                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Cover: R${selectedCover}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                    isExpanded: true,
                                    alignment: AlignmentDirectional.center,
                                    hint: Row(
                                      children: [
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            "Select Cover Amount",
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
                                    items: coverAmountItems.map((String item) {
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
                                    value: selectedCover,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        if (newValue == null) return;
                                        // Parse the new cover value.
                                        double newCover =
                                            double.tryParse(newValue) ?? cover1;
                                        cover1 = newCover;
                                        _selectedCoverAmounts[memberKey] =
                                            newValue;
                                        print(
                                            "Selected cover for member $memberKey: $newValue");

                                        // Update the extended member's cover in the policy.members list.
                                        final int indexInMembers =
                                            membersList.indexWhere((m) {
                                          if (m is Map<String, dynamic>) {
                                            final int? autoNum =
                                                m['additional_member_id'] ??
                                                    m['additional_member_id'];

                                            final String? typeStr =
                                                m['type'] as String?;
                                            print(
                                                "Selected additional_member_id $autoNum: $typeStr");
                                            return autoNum == memberKey &&
                                                (typeStr?.toLowerCase() ==
                                                    'extended');
                                          } else if (m is Member) {
                                            return m.autoNumber == memberKey &&
                                                (m.type ?? '').toLowerCase() ==
                                                    'extended';
                                          }
                                          return false;
                                        });
                                        if (indexInMembers != -1) {
                                          if (membersList[indexInMembers]
                                              is Map<String, dynamic>) {
                                            (membersList[indexInMembers] as Map<
                                                String,
                                                dynamic>)['cover'] = newCover;
                                          } else if (membersList[indexInMembers]
                                              is Member) {
                                            (membersList[indexInMembers]
                                                    as Member)
                                                .cover = newCover;
                                          }
                                          policy.members = membersList;
                                        }
                                        cover1 = newCover;
                                        // Rebuild the list of cover amounts for all extended members in the current policy.
                                        List<double> updatedCovers =
                                            membersList.where((m) {
                                          if (m is Map<String, dynamic>) {
                                            final typeStr =
                                                m['type'] as String?;
                                            return (typeStr?.toLowerCase() ==
                                                    'extended') &&
                                                (m['reference'] ==
                                                    currentReference);
                                          } else if (m is Member) {
                                            return (m.type ?? '')
                                                        .toLowerCase() ==
                                                    'extended' &&
                                                m.reference == currentReference;
                                          }
                                          return false;
                                        }).map<double>((m) {
                                          if (m is Map<String, dynamic>) {
                                            return (m['cover'] as num?)
                                                    ?.toDouble() ??
                                                0.0;
                                          } else if (m is Member) {
                                            return m.cover ?? 0.0;
                                          }
                                          return 0.0;
                                        }).toList();
                                      });
                                      onPolicyUpdated2(context, true);
                                    },
                                    buttonStyleData: ButtonStyleData(
                                      height: 45,
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(32),
                                        border:
                                            Border.all(color: Colors.black26),
                                        color: Colors.transparent,
                                      ),
                                      elevation: 0,
                                    ),
                                    iconStyleData: const IconStyleData(
                                      icon: Icon(
                                          Icons.arrow_forward_ios_outlined),
                                      iconSize: 14,
                                      iconEnabledColor: Colors.black,
                                      iconDisabledColor: Colors.transparent,
                                    ),
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
                                        thumbVisibility:
                                            MaterialStateProperty.all(true),
                                      ),
                                    ),
                                    menuItemStyleData: MenuItemStyleData(
                                      overlayColor: null,
                                      height: 40,
                                      padding: const EdgeInsets.only(
                                          left: 14, right: 14),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Right column (delete/edit icons)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    bottom: 16,
                    right: 16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          removeExtendedMember(member, currentReference);
                          appBarMemberCardNotifier.value++;
                          advancedMemberCardKey2 = UniqueKey();
                          setState(() {});
                        },
                        child: const Icon(CupertinoIcons.delete,
                            color: Colors.black),
                      ),
                      InkWell(
                        onTap: () {
                          // Show an edit dialog
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => StatefulBuilder(
                              builder: (context, setState) => Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(64),
                                ),
                                elevation: 0.0,
                                backgroundColor: Colors.transparent,
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth: (Constants
                                            .currentleadAvailable!
                                            .leadObject
                                            .documentsIndexed
                                            .isEmpty)
                                        ? 750
                                        : 1200,
                                  ),
                                  margin: const EdgeInsets.only(top: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10.0,
                                        offset: Offset(0.0, 10.0),
                                      ),
                                    ],
                                  ),
                                  child: NewMemberDialog(
                                    isEditMode: true,
                                    autoNumber: member.autoNumber,
                                    relationship: "Extended",
                                    title: member.title,
                                    name: member.name,
                                    surname: member.surname,
                                    dob: member.dob,
                                    phone: member.contact,
                                    idNumber: member.id,
                                    is_self_or_payer: false,
                                    gender: member.gender,
                                    current_member_index: current_member_index,
                                    canAddMember: true,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.edit,
                          color: Constants.ftaColorLight,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void removeExtendedMember(AdditionalMember member, String currentReference) {
    final policy =
        Constants.currentleadAvailable!.policies[current_member_index];
    final membersList = policy.members ?? [];
    // Remove from the policy's members
    membersList.removeWhere((m) {
      String memberType = "";
      int autoNumber = -1;
      if (m is Map<String, dynamic>) {
        memberType = (m['type'] ?? "").toLowerCase();
        autoNumber = m['additional_member_id'] as int? ?? -1;
      } else if (m is Member) {
        memberType = (m.type ?? "").toLowerCase();
        autoNumber = m.autoNumber ?? -1;
      }
      return memberType == "extended" && autoNumber == member.autoNumber;
    });
    policy.members = membersList;

    // If you also track them in policiesSelectedExtended, remove them there, too:
    // ...

    // Recalc premium or refresh UI:
    calculatePolicyPremiumCal(false);
    setState(() {});
  }

  Widget buildExtendedListOld() {
    // If no policies are available, return a fallback.
    if (Constants.currentleadAvailable!.policies.isEmpty) {
      return const Center(
        child: Text(
          "No children available for this policy.",
          style: TextStyle(fontSize: 14, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      );
    }

    // 1) Get the current policy and its reference.
    final policy =
        Constants.currentleadAvailable!.policies[current_member_index];
    final currentReference = policy.reference;
    print("Current reference: $currentReference");

    // -----------------------------
    // A) Gather extended members from policy.members.
    // -----------------------------
    final List<dynamic> membersList = policy.members ?? [];
    final extendedAutoNumbersFromPolicy = membersList
        .where((m) {
          if (m is Map<String, dynamic>) {
            return (m['type'] as String?)?.toLowerCase() == 'extended' &&
                m['reference'] == currentReference;
          } else if (m is Member) {
            return (m.type ?? '').toLowerCase() == 'extended' &&
                m.reference == currentReference;
          }
          return false;
        })
        .map<int>((m) {
          if (m is Map<String, dynamic>) {
            return (m['autoNumber'] ?? -1) as int;
          } else if (m is Member) {
            return m.autoNumber ?? -1;
          }
          return -1;
        })
        .where((num) => num != -1)
        .toList();

    final List<AdditionalMember> extendedMembersFromPolicy = [];
    for (int autoNum in extendedAutoNumbersFromPolicy) {
      try {
        final foundAM = Constants.currentleadAvailable!.additionalMembers
            .firstWhere((am) => am.autoNumber == autoNum);
        extendedMembersFromPolicy.add(foundAM);
      } catch (e) {
        // Log or handle not found case if needed.
        print("Extended member not found for autoNumber: $autoNum");
      }
    }

    // -----------------------------
    // D) Fallback if no extended members found.
    // -----------------------------
    if (extendedMembersFromPolicy.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "No extended members available for this policy.",
            style: TextStyle(fontSize: 14, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // -----------------------------
    // E) Build a scrollable list of extended members.
    // -----------------------------
    return Container(
      width: MediaQuery.of(context).size.width,
      // You can wrap the ListView in an Expanded if used inside a Column.
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns
          crossAxisSpacing: 16.0, // Space between columns
          mainAxisSpacing: 16.0, // Space between rows
          mainAxisExtent: 120, // Height for each grid item
        ),
        itemCount: extendedMembersFromPolicy.length,
        itemBuilder: (context, index) {
          final member = extendedMembersFromPolicy[index];
          print(
              "Processing extended member: ${member.autoNumber} - ${member.name}");

          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              height: 130,
              width: MediaQuery.of(context).size.width,
              child: CustomCard2(
                elevation: 8,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                boderRadius: 12,

                //  boderRadius: 12,
                child: Container(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Avatar
                      Column(
                        children: [
                          Expanded(
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                                color:
                                    Constants.ftaColorLight.withOpacity(0.15),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Constants.ftaColorLight,
                                    child: Icon(
                                      member.gender.toLowerCase() == "female"
                                          ? Icons.female
                                          : Icons.male,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16.0),
                      // Member Information
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // DoB
                              Text(
                                'DoB: ${DateFormat('dd MMM yyyy').format(DateTime.parse(member.dob))}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'YuGothic',
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              // Member Name
                              Expanded(
                                child: Text(
                                  '${member.title} ${member.name} ${member.surname}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              // Relationship
                              Row(
                                children: [
                                  const Icon(
                                    Icons.people_alt,
                                    color: Colors.black,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    '${member.relationship[0].toUpperCase()}${member.relationship.substring(1)}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Delete Button
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, bottom: 16, right: 16),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              // Remove the extended member from the policy.
                              policy.members.removeWhere((m) {
                                if (m is Map<String, dynamic>) {
                                  return (m['autoNumber'] ==
                                          member.autoNumber) &&
                                      ((m['type'] as String?)?.toLowerCase() ==
                                          'extended') &&
                                      (m['reference'] == currentReference);
                                } else if (m is Member) {
                                  return (m.autoNumber == member.autoNumber) &&
                                      ((m.type ?? '').toLowerCase() ==
                                          'extended') &&
                                      (m.reference == currentReference);
                                }
                                return false;
                              });
                              // Optionally recalc premium.
                              calculatePolicyPremiumCal(false);
                              appBarMemberCardNotifier.value++;
                              advancedMemberCardKey2 = UniqueKey();
                              setState(() {});
                            });
                          },
                          child: Icon(
                            CupertinoIcons.delete,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Removes the given [member] from the current policy identified by [policyReference].
  /// Also removes that partner from `policiesSelectedPartners`.
  void removeMemberFromPolicy2(AdditionalMember member, String policyReference,
      BuildContext context, String relationship) async {
    // 1. Retrieve the policy using the reference.
    final policy = Constants.currentleadAvailable!.policies.firstWhere(
      (p) => p.reference == policyReference,
    );
    if (policy == null) return;

    // 2. Remove the partner from policy.members.
    if (policy.members != null) {
      policy.members = policy.members.where((m) {
        if (m is Map<String, dynamic>) {
          final mAuto = m['additional_member_id'] ?? -1;
          final mType = (m['type'] ?? '').toString().toLowerCase();
          return !(mAuto == member.autoNumber && mType == relationship);
        } else if (m is Member) {
          final mAuto = m.autoNumber ?? -1;
          final mType = (m.type ?? '').toLowerCase();
          return !(mAuto == member.autoNumber && mType == relationship);
        }
        return true;
      }).toList();
    }

    // 4. Optionally, remove the member via SalesService if found on server.
    SalesService salesService = SalesService();
    // Look for matching members from policy.members.
    final matchingMembers = policy.members.where((m) {
      if (m is Map<String, dynamic>) {
        return (m['additional_member_id'] ?? -1) == member.autoNumber &&
            (m['type'] ?? '').toString().toLowerCase() == 'partner';
      } else if (m is Member) {
        return (m.autoNumber ?? -1) == member.autoNumber &&
            (m.type ?? '').toLowerCase() == 'partner';
      }
      return false;
    }).toList();

    if (matchingMembers.isNotEmpty) {
      Map mpartner = matchingMembers.first is Map<String, dynamic>
          ? matchingMembers.first
          : (matchingMembers.first as Member).toJson();
      bool success = await salesService.removeMemberToPolicy(
        Member.fromJson(Map<String, dynamic>.from(mpartner)),
        policyReference,
        context,
      );
      if (success) {
        print("Beneficiary removed successfully on server.");
      } else {
        print("Failed to remove beneficiary on server.");
      }
    } else {
      print(
          "No matching partner found in policy.members for autoNumber ${member.autoNumber}.");
      // Optionally, you can choose to call the removal API with a dummy member
      // or simply update local state.
    }

    // 5. Update premium calculation and UI.
    mySalesPremiumCalculatorValue.value++;
    setState(() {});
  }

  Map<int, bool> _allowEditingPartners = {};
  Map<int, bool> _allowEditingChildren = {};
  Map<int, bool> _allowEditingExtended = {};

  Widget buildPartnersGrid() {
    // Get the current policy and its reference.
    final policy =
        Constants.currentleadAvailable!.policies[current_member_index];
    final currentReference = policy.reference;
    final List<dynamic> membersList = policy.members ?? [];

    // Filter members that are partners for the current policy.
    final List<dynamic> partnerMembers = membersList.where((member) {
      if (member is Map<String, dynamic>) {
        return ((member['type'] as String?)?.toLowerCase() ?? '') ==
                'partner' &&
            member['reference'] == currentReference;
      }

      return false;
    }).toList();

    MainRate? matchingRate = Constants.currentParlourConfig!.mainRates
        .firstWhereOrNull((rate) =>
            rate.product == policiesSelectedProducts[current_member_index] &&
            rate.prodType == policiesSelectedProdTypes[current_member_index] &&
            rate.amount == policiesSelectedCoverAmounts[current_member_index] &&
            rate.minAge <=
                calculateAge(DateTime.parse(Constants.currentleadAvailable!
                    .additionalMembers[current_member_index].dob)) &&
            calculateAge(DateTime.parse(Constants.currentleadAvailable!
                    .additionalMembers[current_member_index].dob)) <=
                rate.maxAge);
    int maximumSpouses = 0;
    if (matchingRate != null) {
      maximumSpouses = matchingRate.spouse;
      print("sddfdf ${matchingRate.runtimeType} ${maximumSpouses}");
    }

    // If no partners exist, show a fallback message.
    if (partnerMembers.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: Text(
            "No partner added to the current policy",
            style: TextStyle(fontSize: 14, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Build the grid view of partner cards.
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 32),
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: partnerMembers.length,
        itemBuilder: (context, index) {
          Map<int, String> _selectedPartnerCoverAmounts = {};
          final member_partner = partnerMembers[index];
          final int memberKey = member_partner["additional_member_id"] ?? index;
          bool itemEditing = _allowEditingPartners[memberKey] ?? false;
          // Default cover amount and premium.
          double coverAmount = 0.0;
          double premium = 0.0;
          String? selectedCover = null;

          // Build dropdown items for cover amount.
          List<String> coverAmountItems = [];
          // Use partner.autoNumber as a key; if missing, fallback to index.

          AdditionalMember partner = Constants
              .currentleadAvailable!.additionalMembers
              .where((current_member) => current_member.autoNumber == memberKey)
              .toList()
              .first;

          // For available cover options, using extendedMemberRates (adjust if needed).

          List<dynamic> partnerRates = Constants
              .currentParlourConfig!.extendedMemberRates
              .where((extended_rate) => (extended_rate.product ==
                      policiesSelectedProducts[current_member_index] &&
                  extended_rate.prodType ==
                      policiesSelectedProdTypes[current_member_index] &&
                  extended_rate.relationship.toLowerCase() == "partner" &&
                  extended_rate.minAge <=
                      calculateAge(DateTime.parse(partner.dob)) &&
                  extended_rate.maxAge >=
                      calculateAge(DateTime.parse(partner.dob))))
              .toList();

          // Fixed logic for populating coverAmountItems
          if (partnerRates.isEmpty) {
            // If no partner rates found, use the current member's cover amount
            selectedCover = (member_partner["cover"] ?? 0).toString();
            coverAmountItems = [(member_partner["cover"] ?? 0).toString()];
          } else {
            // If partner rates are found, populate from rates
            coverAmountItems = partnerRates
                .map<String>((rate) => rate.amount.toString())
                .toSet() // Remove duplicates
                .toList();

            // Set selectedCover to current member's cover if it exists in the options
            String currentCover = (member_partner["cover"] ?? 0).toString();
            if (coverAmountItems.contains(currentCover)) {
              selectedCover = currentCover;
            } else {
              // If current cover not in options, use first available option
              selectedCover =
                  coverAmountItems.isNotEmpty ? coverAmountItems.first : "0";
            }
          }

          // Additional safety check - ensure we always have at least one option
          if (coverAmountItems.isEmpty) {
            coverAmountItems = [(member_partner["cover"] ?? 0).toString()];
            selectedCover = coverAmountItems.first;
          }

          // Construct a partner role string (e.g. "partner_1", "partner_2", ...)
          final String partnerRole = 'partner_${index + 1}';

          // Look up any calculated premium for this partner if available.
          if (policyPremiums.length > current_member_index) {
            final calcResponse = policyPremiums[current_member_index];
            final matchedPremium = calcResponse.memberPremiums.firstWhere(
              (mp) => mp.role == partnerRole,
              orElse: () => MemberPremium(
                  rateId: 0,
                  role: '',
                  age: 0,
                  premium: 0,
                  coverAmount: 0,
                  comment: ""),
            );
            if (matchedPremium.coverAmount != null &&
                matchedPremium.coverAmount != 0) {
              coverAmount = matchedPremium.coverAmount!;
              premium = matchedPremium.premium!;
            } else {
              // Fallback: use main insured's cover if partner's cover is zero.
              final mainInsuredPremium = calcResponse.memberPremiums.firstWhere(
                (mp) => mp.role == "main_insured",
                orElse: () => MemberPremium(
                    rateId: 0,
                    role: '',
                    age: 0,
                    premium: 0,
                    coverAmount: 0,
                    comment: ""),
              );
              coverAmount = mainInsuredPremium.coverAmount;
            }
          }

          print("dffghg $itemEditing");
          if (selectedCover == null && coverAmountItems.isNotEmpty) {
            selectedCover = coverAmountItems[0];
            _selectedPartnerCoverAmounts[memberKey] = selectedCover;
          }
          if (double.parse((selectedCover ?? 0).toString()) == 0) {
            selectedCover =
                (policiesSelectedCoverAmounts[current_member_index]).toString();
            coverAmountItems = [
              (policiesSelectedCoverAmounts[current_member_index]).toString()
            ];
          }
          print("ghghjhj " + coverAmountItems.length.toString());

          // Build the partner card.
          return Container(
            height: 200,
            child: Stack(
              children: [
                CustomCard2(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  boderRadius: 12,
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Constants.ftaColorLight.withOpacity(0.95)),
                    ),
                    margin: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 0.0),
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Left container with avatar.
                        Container(
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                            color: Constants.ftaColorLight.withOpacity(0.95),
                          ),
                          child: Center(
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey.withOpacity(0.65),
                              child: Icon(
                                partner.gender.toLowerCase() == "female"
                                    ? Icons.female
                                    : Icons.male,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        // Main partner information.
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 16.0, left: 16, top: 16, bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (partner.dob.isNotEmpty)
                                  Text(
                                    'DoB: ${DateFormat('dd MMM yyyy').format(DateTime.parse(partner.dob))}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'YuGothic',
                                        color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                const SizedBox(height: 8.0),
                                Text(
                                  '${partner.title} ${partner.name} ${partner.surname}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.2),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    const Icon(Icons.people_alt,
                                        color: Colors.black, size: 16),
                                    const SizedBox(width: 4.0),
                                    Expanded(
                                      child: Text(
                                        'Relationship: ${partner.relationship[0].toUpperCase()}${partner.relationship.substring(1)}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Text(
                                      'Premium: R${premium.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Builder(
                                  builder: (context) {
                                    return Row(
                                      children: [
                                        Text(
                                          'Cover: ',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton2<String>(
                                              isExpanded: true,
                                              alignment:
                                                  AlignmentDirectional.center,
                                              hint: Row(
                                                children: [
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      "Select Cover Amount",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'YuGothic',
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              items: coverAmountItems
                                                  .map((String item) {
                                                return DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'YuGothic',
                                                      color: Colors.black,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                );
                                              }).toList(),
                                              value: selectedCover,
                                              // Replace the DropdownButton2 onChanged logic in buildPartnersGrid:

                                              onChanged: (String? newValue) {
                                                // Remove the incorrect condition: (index) >= maximumSpouses
                                                // Allow all partners to change their cover amounts
                                                setState(() {
                                                  if (newValue == null) return;

                                                  double newCover =
                                                      double.tryParse(
                                                              newValue) ??
                                                          coverAmount;
                                                  coverAmount = newCover;
                                                  _selectedPartnerCoverAmounts[
                                                      memberKey] = newValue;

                                                  print(
                                                      "Selected cover for member $memberKey: $newValue");

                                                  // Update the cover amount for this partner in the policy.members list.
                                                  final int indexInMembers =
                                                      membersList
                                                          .indexWhere((m) {
                                                    if (m is Map<String,
                                                        dynamic>) {
                                                      final int? autoNum = m[
                                                          'additional_member_id'];
                                                      final String? typeStr =
                                                          m['type'] as String?;
                                                      return autoNum ==
                                                              partner
                                                                  .autoNumber &&
                                                          (typeStr?.toLowerCase() ==
                                                              'partner');
                                                    } else if (m is Member) {
                                                      return m.autoNumber ==
                                                              partner
                                                                  .autoNumber &&
                                                          (m.type ?? '')
                                                                  .toLowerCase() ==
                                                              'partner';
                                                    }
                                                    return false;
                                                  });

                                                  if (indexInMembers != -1) {
                                                    if (membersList[
                                                            indexInMembers]
                                                        is Map<String,
                                                            dynamic>) {
                                                      (membersList[
                                                                  indexInMembers]
                                                              as Map<String,
                                                                  dynamic>)[
                                                          'cover'] = newCover;
                                                    } else if (membersList[
                                                            indexInMembers]
                                                        is Member) {
                                                      (membersList[
                                                                  indexInMembers]
                                                              as Member)
                                                          .cover = newCover;
                                                    }
                                                    policy.members =
                                                        membersList;
                                                  }

                                                  onPolicyUpdated2(
                                                      context, true);
                                                });
                                              },

                                              buttonStyleData: ButtonStyleData(
                                                height: 45,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(32),
                                                  border: Border.all(
                                                      color: Colors.black26),
                                                  color: Colors.transparent,
                                                ),
                                                elevation: 0,
                                              ),
                                              iconStyleData:
                                                  const IconStyleData(
                                                icon: Icon(Icons
                                                    .arrow_forward_ios_outlined),
                                                iconSize: 14,
                                                iconEnabledColor: Colors.black,
                                                iconDisabledColor:
                                                    Colors.transparent,
                                              ),
                                              dropdownStyleData:
                                                  DropdownStyleData(
                                                elevation: 0,
                                                maxHeight: 200,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  color: Colors.white,
                                                ),
                                                offset: const Offset(-5, 0),
                                                scrollbarTheme:
                                                    ScrollbarThemeData(
                                                  radius:
                                                      const Radius.circular(40),
                                                  thickness:
                                                      MaterialStateProperty.all(
                                                          6),
                                                  thumbVisibility:
                                                      MaterialStateProperty.all(
                                                          true),
                                                ),
                                              ),
                                              menuItemStyleData:
                                                  MenuItemStyleData(
                                                overlayColor: null,
                                                height: 40,
                                                padding: const EdgeInsets.only(
                                                    left: 14, right: 14),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 8.0),
                              ],
                            ),
                          ),
                        ),
                        // Edit/Delete button column
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, bottom: 16, right: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  removeMemberFromPolicy2(partner,
                                      currentReference, context, "partner");
                                  appBarMemberCardNotifier.value++;
                                  advancedMemberCardKey2 = UniqueKey();
                                  setState(() {});
                                },
                                child: Icon(CupertinoIcons.delete),
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => StatefulBuilder(
                                      builder: (context, setState) => Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(64),
                                        ),
                                        elevation: 0.0,
                                        backgroundColor: Colors.transparent,
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: (Constants
                                                    .currentleadAvailable!
                                                    .leadObject
                                                    .documentsIndexed
                                                    .isEmpty)
                                                ? 750
                                                : 1200,
                                          ),
                                          margin:
                                              const EdgeInsets.only(top: 16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 10.0,
                                                offset: Offset(0.0, 10.0),
                                              ),
                                            ],
                                          ),
                                          child: NewMemberDialog(
                                            isEditMode: true,
                                            autoNumber: partner.autoNumber,
                                            relationship: "Partner",
                                            title: partner.title,
                                            name: partner.name,
                                            surname: partner.surname,
                                            dob: partner.dob,
                                            phone: partner.contact,
                                            idNumber: partner.id,
                                            is_self_or_payer: false,
                                            gender: partner.gender,
                                            canAddMember: true,
                                            current_member_index:
                                                current_member_index,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Constants.ftaColorLight,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Overlay for editing restriction
                if (!(_allowEditingPartners[memberKey] ?? false))
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.40),
                        borderRadius: BorderRadius.circular(12)),
                    height: 220,
                    child: Center(
                      child: InkWell(
                          onTap: () {
                            _allowEditingPartners[memberKey] = true;

                            setState(() {
                              print(
                                  "Editing enabled for member $memberKey: ${_allowEditingPartners[memberKey]}");
                            });
                          },
                          child: Icon(Iconsax.edit)),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Ensure this map is declared at the State class level:
  Map<int, String> _selectedCoverChildrenAmounts = {};

  Widget buildChildrenGrid() {
    // Get the current policy and its reference.
    final policy =
        Constants.currentleadAvailable!.policies[current_member_index];
    final currentReference = policy.reference;
    final List<dynamic> membersList = policy.members ?? [];

    // Filter members that are children for the current policy.
    final List<dynamic> childMembers = membersList.where((member) {
      if (member is Map<String, dynamic>) {
        return ((member['type'] as String?)?.toLowerCase() ?? '') == 'child' &&
            member['reference'] == currentReference;
      }
      return false;
    }).toList();

    MainRate? matchingRate =
        Constants.currentParlourConfig!.mainRates.firstWhereOrNull(
      (rate) =>
          rate.product == policiesSelectedProducts[current_member_index] &&
          rate.prodType == policiesSelectedProdTypes[current_member_index] &&
          rate.relationship.toLowerCase() == "child" &&
          rate.amount == policiesSelectedCoverAmounts[current_member_index],
    );

    int maximumChildren = 0;
    if (matchingRate != null) {
      maximumChildren = matchingRate.children;
      if (kDebugMode) {
        print("sddfdf ${matchingRate.runtimeType} ${maximumChildren}");
      }
    }

    // If no children exist, show a fallback message.
    if (childMembers.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: Text(
            "No children added to the current policy",
            style: TextStyle(fontSize: 14, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Build the grid view of child cards.
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 32),
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          mainAxisExtent: 200,
        ),
        itemCount: childMembers.length,
        itemBuilder: (context, index) {
          Map<int, String> _selectedChildCoverAmounts = {};
          final member_child = childMembers[index];
          final int memberKey = member_child["additional_member_id"] ?? index;
          bool itemEditing = _allowEditingChildren[memberKey] ?? false;

          // Default cover amount and premium.
          double coverAmount = 0.0;
          double premium = 0.0;
          String? selectedCover = null;

          // Build dropdown items for cover amount.
          List<String> coverAmountItems = [];

          AdditionalMember child = Constants
              .currentleadAvailable!.additionalMembers
              .where((current_member) => current_member.autoNumber == memberKey)
              .toList()
              .first;

          // Filter child rates based on product, prod_type, age, and relationship
          List<dynamic> childRates = Constants
              .currentParlourConfig!.extendedMemberRates
              .where((extended_rate) => (extended_rate.product ==
                      policiesSelectedProducts[current_member_index] &&
                  extended_rate.prodType ==
                      policiesSelectedProdTypes[current_member_index] &&
                  extended_rate.relationship.toLowerCase() == "child" &&
                  extended_rate.minAge <=
                      calculateAge(DateTime.parse(child.dob)) &&
                  extended_rate.maxAge >=
                      calculateAge(DateTime.parse(child.dob))))
              .toList();

          print(
              "Found ${childRates.length} child rates for age ${calculateAge(DateTime.parse(child.dob))}");

          // FIXED: Auto-assign main insured cover if child has no cover or zero cover
          double currentChildCover = (member_child["cover"] ?? 0).toDouble();
          double mainInsuredCover =
              policiesSelectedCoverAmounts[current_member_index].toDouble();

          // If child has no cover assigned or has zero cover, assign main insured cover
          if (currentChildCover == 0) {
            currentChildCover = mainInsuredCover;

            // Update the child's cover in the policy
            final int indexInMembers = membersList.indexWhere((m) {
              if (m is Map<String, dynamic>) {
                final int? autoNum = m['additional_member_id'];
                final String? typeStr = m['type'] as String?;
                return autoNum == child.autoNumber &&
                    (typeStr?.toLowerCase() == 'child');
              } else if (m is Member) {
                return m.autoNumber == child.autoNumber &&
                    (m.type ?? '').toLowerCase() == 'child';
              }
              return false;
            });

            if (indexInMembers != -1) {
              if (membersList[indexInMembers] is Map<String, dynamic>) {
                (membersList[indexInMembers] as Map<String, dynamic>)['cover'] =
                    currentChildCover;
              } else if (membersList[indexInMembers] is Member) {
                (membersList[indexInMembers] as Member).cover =
                    currentChildCover;
              }
              policy.members = membersList;

              print(
                  "Auto-assigned main insured cover ($mainInsuredCover) to child ${child.name}");
            }
          }

          // Fixed logic for populating coverAmountItems
          if (childRates.isEmpty) {
            // If no child rates found, use the current child's cover amount
            selectedCover = currentChildCover.toString();
            coverAmountItems = [currentChildCover.toString()];
            print("No child rates found, using child cover: $selectedCover");
          } else {
            // If child rates are found, populate from rates
            coverAmountItems = childRates
                .map<String>((rate) => rate.amount.toString())
                .toSet() // Remove duplicates
                .toList();

            // Always include the main insured cover amount as an option
            String mainCoverStr = mainInsuredCover.toString();
            if (!coverAmountItems.contains(mainCoverStr)) {
              //coverAmountItems.add(mainCoverStr);
            }

            // Set selectedCover to current child's cover if it exists in the options
            String currentCover = currentChildCover.toString();
            if (coverAmountItems.contains(currentCover)) {
              selectedCover = currentCover;
            } else {
              // If current cover not in options, use main insured cover if available, otherwise first option
              if (coverAmountItems.contains(mainCoverStr)) {
                selectedCover = mainCoverStr;
              } else {
                selectedCover =
                    coverAmountItems.isNotEmpty ? coverAmountItems.first : "0";
              }
            }
          }

          // Additional safety check - ensure we always have at least one option
          if (coverAmountItems.isEmpty) {
            coverAmountItems = [currentChildCover.toString()];
            selectedCover = coverAmountItems.first;
          }

          // Sort cover amounts numerically for better UX (highest to lowest)

          // Construct a child role string (e.g. "child_1", "child_2", ...)
          final String childRole = 'child_${index + 1}';

          // Look up any calculated premium for this child if available.
          if (policyPremiums.length > current_member_index) {
            final calcResponse = policyPremiums[current_member_index];
            final matchedPremium = calcResponse.memberPremiums.firstWhere(
              (mp) => mp.role == childRole,
              orElse: () => MemberPremium(
                  rateId: 0,
                  role: '',
                  age: 0,
                  premium: 0,
                  coverAmount: 0,
                  comment: ""),
            );
            if (matchedPremium.coverAmount != null &&
                matchedPremium.coverAmount != 0) {
              coverAmount = matchedPremium.coverAmount!;
              premium = matchedPremium.premium!;
            } else {
              // Fallback: use main insured's cover if child's cover is zero.
              final mainInsuredPremium = calcResponse.memberPremiums.firstWhere(
                (mp) => mp.role == "main_insured",
                orElse: () => MemberPremium(
                    rateId: 0,
                    role: '',
                    age: 0,
                    premium: 0,
                    coverAmount: 0,
                    comment: ""),
              );
              coverAmount = mainInsuredPremium.coverAmount;
            }
          }

          print("dffghg $itemEditing");
          if (selectedCover == null && coverAmountItems.isNotEmpty) {
            selectedCover = coverAmountItems[0];
            _selectedChildCoverAmounts[memberKey] = selectedCover;
          }

          // Ensure selectedCover is never "0" - if it is, use main insured cover
          if (double.parse((selectedCover ?? "0").toString()) == 0) {
            selectedCover = mainInsuredCover.toString();
            if (!coverAmountItems.contains(selectedCover)) {
              coverAmountItems = [selectedCover];
            }
          }

          print(
              "Available cover options for child: ${coverAmountItems.length} options - $coverAmountItems");
          coverAmountItems
              .sort((a, b) => double.parse(a).compareTo(double.parse(b)));

          // Build the child card.
          return Container(
            height: 200,
            child: Stack(
              children: [
                CustomCard2(
                  elevation: 8,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  boderRadius: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Constants.ftaColorLight.withOpacity(0.95)),
                    ),
                    margin: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 0.0),
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Left container with avatar.
                        Container(
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                            color: Constants.ftaColorLight.withOpacity(0.95),
                          ),
                          child: Center(
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey.withOpacity(0.65),
                              child: Icon(
                                child.gender.toLowerCase() == "female"
                                    ? Icons.female
                                    : Icons.male,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        // Main child information.
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 16.0, left: 16, top: 16, bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (child.dob.isNotEmpty)
                                  Text(
                                    'DoB: ${DateFormat('dd MMM yyyy').format(DateTime.parse(child.dob))}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'YuGothic',
                                        color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                const SizedBox(height: 8.0),
                                Text(
                                  '${child.title} ${child.name} ${child.surname}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.2),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    const Icon(Icons.people_alt,
                                        color: Colors.black, size: 16),
                                    const SizedBox(width: 4.0),
                                    Expanded(
                                      child: Text(
                                        'Relationship: ${child.relationship[0].toUpperCase()}${child.relationship.substring(1)}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Text(
                                      'Premium: R${premium.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Builder(
                                  builder: (context) {
                                    return Row(
                                      children: [
                                        Text(
                                          'Cover: ',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton2<String>(
                                              isExpanded: true,
                                              alignment:
                                                  AlignmentDirectional.center,
                                              hint: Row(
                                                children: [
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      "Select Cover Amount",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'YuGothic',
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              items: coverAmountItems
                                                  .map((String item) {
                                                return DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(
                                                    'R${double.parse(item).toStringAsFixed(0)}', // Format as currency
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'YuGothic',
                                                      color: Colors.black,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                );
                                              }).toList(),
                                              value: selectedCover,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  if (newValue == null) return;

                                                  double newCover =
                                                      double.tryParse(
                                                              newValue) ??
                                                          coverAmount;
                                                  coverAmount = newCover;
                                                  _selectedChildCoverAmounts[
                                                      memberKey] = newValue;

                                                  print(
                                                      "Selected cover for child member $memberKey: $newValue");

                                                  // Update the cover amount for this child in the policy.members list.
                                                  final int indexInMembers =
                                                      membersList
                                                          .indexWhere((m) {
                                                    if (m is Map<String,
                                                        dynamic>) {
                                                      final int? autoNum = m[
                                                          'additional_member_id'];
                                                      final String? typeStr =
                                                          m['type'] as String?;
                                                      return autoNum ==
                                                              child
                                                                  .autoNumber &&
                                                          (typeStr?.toLowerCase() ==
                                                              'child');
                                                    } else if (m is Member) {
                                                      return m.autoNumber ==
                                                              child
                                                                  .autoNumber &&
                                                          (m.type ?? '')
                                                                  .toLowerCase() ==
                                                              'child';
                                                    }
                                                    return false;
                                                  });

                                                  if (indexInMembers != -1) {
                                                    if (membersList[
                                                            indexInMembers]
                                                        is Map<String,
                                                            dynamic>) {
                                                      (membersList[
                                                                  indexInMembers]
                                                              as Map<String,
                                                                  dynamic>)[
                                                          'cover'] = newCover;
                                                    } else if (membersList[
                                                            indexInMembers]
                                                        is Member) {
                                                      (membersList[
                                                                  indexInMembers]
                                                              as Member)
                                                          .cover = newCover;
                                                    }
                                                    policy.members =
                                                        membersList;
                                                  }

                                                  onPolicyUpdated2(
                                                      context, true);
                                                });
                                              },
                                              buttonStyleData: ButtonStyleData(
                                                height: 45,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(32),
                                                  border: Border.all(
                                                      color: Colors.black26),
                                                  color: Colors.transparent,
                                                ),
                                                elevation: 0,
                                              ),
                                              iconStyleData:
                                                  const IconStyleData(
                                                icon: Icon(Icons
                                                    .arrow_forward_ios_outlined),
                                                iconSize: 14,
                                                iconEnabledColor: Colors.black,
                                                iconDisabledColor:
                                                    Colors.transparent,
                                              ),
                                              dropdownStyleData:
                                                  DropdownStyleData(
                                                elevation: 0,
                                                maxHeight: 200,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  color: Colors.white,
                                                ),
                                                offset: const Offset(-5, 0),
                                                scrollbarTheme:
                                                    ScrollbarThemeData(
                                                  radius:
                                                      const Radius.circular(40),
                                                  thickness:
                                                      MaterialStateProperty.all(
                                                          6),
                                                  thumbVisibility:
                                                      MaterialStateProperty.all(
                                                          true),
                                                ),
                                              ),
                                              menuItemStyleData:
                                                  MenuItemStyleData(
                                                overlayColor: null,
                                                height: 40,
                                                padding: const EdgeInsets.only(
                                                    left: 14, right: 14),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 8.0),
                              ],
                            ),
                          ),
                        ),
                        // Edit/Delete button column
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, bottom: 16, right: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  removeMemberFromPolicy2(child,
                                      currentReference, context, "child");
                                  appBarMemberCardNotifier.value++;
                                  advancedMemberCardKey2 = UniqueKey();
                                  setState(() {});
                                },
                                child: Icon(CupertinoIcons.delete),
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => StatefulBuilder(
                                      builder: (context, setState) => Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(64),
                                        ),
                                        elevation: 0.0,
                                        backgroundColor: Colors.transparent,
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: (Constants
                                                    .currentleadAvailable!
                                                    .leadObject
                                                    .documentsIndexed
                                                    .isEmpty)
                                                ? 750
                                                : 1200,
                                          ),
                                          margin:
                                              const EdgeInsets.only(top: 16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 10.0,
                                                offset: Offset(0.0, 10.0),
                                              ),
                                            ],
                                          ),
                                          child: NewMemberDialog(
                                            isEditMode: true,
                                            autoNumber: child.autoNumber,
                                            relationship: "Child",
                                            title: child.title,
                                            name: child.name,
                                            surname: child.surname,
                                            dob: child.dob,
                                            phone: child.contact,
                                            idNumber: child.id,
                                            is_self_or_payer: false,
                                            gender: child.gender,
                                            canAddMember: true,
                                            current_member_index:
                                                current_member_index,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Constants.ftaColorLight,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Overlay for editing restriction
                if (!(_allowEditingChildren[memberKey] ?? false))
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.40),
                        borderRadius: BorderRadius.circular(12)),
                    height: 220,
                    child: Center(
                      child: InkWell(
                          onTap: () {
                            _allowEditingChildren[memberKey] = true;
                            setState(() {
                              print(
                                  "Editing enabled for child member $memberKey: ${_allowEditingChildren[memberKey]}");
                            });
                          },
                          child: Icon(Iconsax.edit)),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildExtendedGrid() {
    // Get the current policy and its reference.
    final policy =
        Constants.currentleadAvailable!.policies[current_member_index];
    final currentReference = policy.reference;
    final List<dynamic> membersList = policy.members ?? [];

    // Filter members that are extended family for the current policy.
    final List<dynamic> extendedMembers = membersList.where((member) {
      if (member is Map<String, dynamic>) {
        return ((member['type'] as String?)?.toLowerCase() ?? '') ==
                'extended' &&
            member['reference'] == currentReference;
      }
      return false;
    }).toList();

    MainRate? matchingRate =
        Constants.currentParlourConfig!.mainRates.firstWhereOrNull(
      (rate) =>
          rate.product == policiesSelectedProducts[current_member_index] &&
          rate.prodType == policiesSelectedProdTypes[current_member_index] &&
          rate.amount == policiesSelectedCoverAmounts[current_member_index],
    );

    int maximumSpouses = 0;
    if (matchingRate != null) {
      maximumSpouses = matchingRate.spouse;
      if (kDebugMode) {
        print("soff ${matchingRate.runtimeType} $maximumSpouses");
      }
    }

    // If no extended members exist, show a fallback message.
    if (extendedMembers.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: Text(
            "No parent or extended added to the current policy",
            style: TextStyle(fontSize: 14, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Build the grid view of extended member cards.
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 32),
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          mainAxisExtent: 200,
        ),
        itemCount: extendedMembers.length,
        itemBuilder: (context, index) {
          Map<int, String> _selectedExtendedCoverAmounts = {};
          final member_extended = extendedMembers[index];
          final int memberKey =
              member_extended["additional_member_id"] ?? index;
          bool itemEditing = _allowEditingExtended[memberKey] ?? false;

          // Default cover amount and premium.
          double coverAmount = 0.0;
          double premium = 0.0;
          String? selectedCover = null;

          // Build dropdown items for cover amount.
          List<String> coverAmountItems = [];

          AdditionalMember extended = Constants
              .currentleadAvailable!.additionalMembers
              .where((current_member) => current_member.autoNumber == memberKey)
              .toList()
              .first;

          // FIXED: Filter rates based on the actual member's relationship
          String memberRelationship = extended.relationship.toLowerCase();
          String rateRelationshipFilter;
          List<dynamic> extendedRates = [];

          // Map member relationships to rate relationship categories
          if (memberRelationship == "parent" ||
              memberRelationship == "father" ||
              memberRelationship == "mother") {
            rateRelationshipFilter = "parent";
            // Filter rates for parent relationship
            extendedRates = Constants.currentParlourConfig!.extendedMemberRates
                .where((extended_rate) => (extended_rate.product ==
                        policiesSelectedProducts[current_member_index] &&
                    extended_rate.prodType ==
                        policiesSelectedProdTypes[current_member_index] &&
                    extended_rate.relationship.toLowerCase() == "parent" &&
                    extended_rate.minAge <=
                        calculateAge(DateTime.parse(extended.dob)) &&
                    extended_rate.maxAge >=
                        calculateAge(DateTime.parse(extended.dob))))
                .toList();
          } else {
            // For all other extended family members (uncle, aunt, cousin, etc.)
            rateRelationshipFilter = "extended";
            // Filter rates for extended relationship
            extendedRates = Constants.currentParlourConfig!.extendedMemberRates
                .where((extended_rate) => (extended_rate.product ==
                        policiesSelectedProducts[current_member_index] &&
                    extended_rate.prodType ==
                        policiesSelectedProdTypes[current_member_index] &&
                    extended_rate.relationship.toLowerCase() == "extended" &&
                    extended_rate.minAge <=
                        calculateAge(DateTime.parse(extended.dob)) &&
                    extended_rate.maxAge >=
                        calculateAge(DateTime.parse(extended.dob))))
                .toList();
          }

          if (kDebugMode) {
            //print("Member relationship: $memberRelationship, Filtering by: $rateRelationshipFilter, Found ${extendedRates.length} rates");
          }

          // FIXED: Auto-assign main insured cover if member has no cover or zero cover
          double currentMemberCover =
              (member_extended["cover"] ?? 0).toDouble();
          double mainInsuredCover =
              policiesSelectedCoverAmounts[current_member_index].toDouble();

          // If member has no cover assigned or has zero cover, assign main insured cover
          if (currentMemberCover == 0) {
            currentMemberCover = mainInsuredCover;

            // Update the member's cover in the policy
            final int indexInMembers = membersList.indexWhere((m) {
              if (m is Map<String, dynamic>) {
                final int? autoNum = m['additional_member_id'];
                final String? typeStr = m['type'] as String?;
                return autoNum == extended.autoNumber &&
                    (typeStr?.toLowerCase() == 'extended');
              } else if (m is Member) {
                return m.autoNumber == extended.autoNumber &&
                    (m.type ?? '').toLowerCase() == 'extended';
              }
              return false;
            });

            if (indexInMembers != -1) {
              if (membersList[indexInMembers] is Map<String, dynamic>) {
                (membersList[indexInMembers] as Map<String, dynamic>)['cover'] =
                    currentMemberCover;
              } else if (membersList[indexInMembers] is Member) {
                (membersList[indexInMembers] as Member).cover =
                    currentMemberCover;
              }
              policy.members = membersList;

              if (kDebugMode) {
                print(
                    "Auto-assigned main insured cover ($mainInsuredCover) to extended member ${extended.name}");
              }
            }
          }

          // Fixed logic for populating coverAmountItems
          if (extendedRates.isEmpty) {
            // If no rates found for the specific relationship, use the current member's cover amount
            selectedCover = currentMemberCover.toString();
            coverAmountItems = [currentMemberCover.toString()];
            print(
                "No rates found for $rateRelationshipFilter relationship, using member cover: $selectedCover");
          } else {
            // If rates are found, populate from rates
            coverAmountItems = extendedRates
                .map<String>((rate) => rate.amount.toString())
                .toSet() // Remove duplicates
                .toList();

            // Always include the main insured cover amount as an option
            String mainCoverStr = mainInsuredCover.toString();
            if (!coverAmountItems.contains(mainCoverStr)) {
              //  coverAmountItems.add(mainCoverStr);
            }

            // Set selectedCover to current member's cover if it exists in the options
            String currentCover = currentMemberCover.toString();
            if (coverAmountItems.contains(currentCover)) {
              selectedCover = currentCover;
            } else {
              // If current cover not in options, use main insured cover if available, otherwise first option
              if (coverAmountItems.contains(mainCoverStr)) {
                selectedCover = mainCoverStr;
              } else {
                selectedCover =
                    coverAmountItems.isNotEmpty ? coverAmountItems.first : "0";
              }
            }
          }

          // Additional safety check - ensure we always have at least one option
          if (coverAmountItems.isEmpty) {
            coverAmountItems = [currentMemberCover.toString()];
            selectedCover = coverAmountItems.first;
          }

          // Ensure selectedCover is never "0" - if it is, use main insured cover
          if (double.parse((selectedCover ?? "0").toString()) == 0) {
            selectedCover = mainInsuredCover.toString();
            if (!coverAmountItems.contains(selectedCover)) {
              coverAmountItems = [selectedCover];
            }
          }

          // FIXED: Sort cover amounts numerically from LOWEST to HIGHEST (after all additions)
          coverAmountItems
              .sort((a, b) => double.parse(a).compareTo(double.parse(b)));

          // Construct an extended role string (e.g. "extended_1", "extended_2", ...)
          final String extendedRole = 'extended_${index + 1}';

          // Look up any calculated premium for this extended member if available.
          if (policyPremiums.length > current_member_index) {
            final calcResponse = policyPremiums[current_member_index];
            final matchedPremium = calcResponse.memberPremiums.firstWhere(
              (mp) => mp.role == extendedRole,
              orElse: () => MemberPremium(
                  rateId: 0,
                  role: '',
                  age: 0,
                  premium: 0,
                  coverAmount: 0,
                  comment: ""),
            );
            if (matchedPremium.coverAmount != null &&
                matchedPremium.coverAmount != 0) {
              coverAmount = matchedPremium.coverAmount!;
              premium = matchedPremium.premium!;
            } else {
              // Fallback: use main insured's cover if extended member's cover is zero.
              final mainInsuredPremium = calcResponse.memberPremiums.firstWhere(
                (mp) => mp.role == "main_insured",
                orElse: () => MemberPremium(
                    rateId: 0,
                    role: '',
                    age: 0,
                    premium: 0,
                    coverAmount: 0,
                    comment: ""),
              );
              coverAmount = mainInsuredPremium.coverAmount;
            }
          }

          print("dffghg $itemEditing");
          if (selectedCover == null && coverAmountItems.isNotEmpty) {
            selectedCover = coverAmountItems[0];
            _selectedExtendedCoverAmounts[memberKey] = selectedCover;
          }

          print(
              "Available cover options for ${extended.relationship}: ${coverAmountItems.length} options - $coverAmountItems");

          // Build the extended member card.
          return Container(
            height: 200,
            child: Stack(
              children: [
                CustomCard2(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  boderRadius: 12,
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Constants.ftaColorLight.withOpacity(0.95)),
                    ),
                    margin: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 0.0),
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Left container with avatar.
                        Container(
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                            color: Constants.ftaColorLight.withOpacity(0.95),
                          ),
                          child: Center(
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey.withOpacity(0.65),
                              child: Icon(
                                extended.gender.toLowerCase() == "female"
                                    ? Icons.female
                                    : Icons.male,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        // Main extended member information.
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 16.0, left: 16, top: 16, bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (extended.dob.isNotEmpty)
                                  Text(
                                    'DoB: ${DateFormat('dd MMM yyyy').format(DateTime.parse(extended.dob))}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'YuGothic',
                                        color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                const SizedBox(height: 8.0),
                                Text(
                                  '${extended.title} ${extended.name} ${extended.surname}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.2),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    const Icon(Icons.people_alt,
                                        color: Colors.black, size: 16),
                                    const SizedBox(width: 4.0),
                                    Expanded(
                                      child: Text(
                                        'Relationship: ${extended.relationship[0].toUpperCase()}${extended.relationship.substring(1)}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Text(
                                      'Premium: R${premium.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Builder(
                                  builder: (context) {
                                    return Row(
                                      children: [
                                        Text(
                                          'Cover: ',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton2<String>(
                                              isExpanded: true,
                                              alignment:
                                                  AlignmentDirectional.center,
                                              hint: Row(
                                                children: [
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      "Select Cover Amount",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'YuGothic',
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              items: coverAmountItems
                                                  .map((String item) {
                                                return DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(
                                                    'R${double.parse(item).toStringAsFixed(0)}', // Format as currency
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'YuGothic',
                                                      color: Colors.black,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                );
                                              }).toList(),
                                              value: selectedCover,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  if (newValue == null) return;

                                                  double newCover =
                                                      double.tryParse(
                                                              newValue) ??
                                                          coverAmount;
                                                  coverAmount = newCover;
                                                  _selectedExtendedCoverAmounts[
                                                      memberKey] = newValue;

                                                  print(
                                                      "Selected cover for extended member $memberKey: $newValue");

                                                  // Update the cover amount for this extended member in the policy.members list.
                                                  final int indexInMembers =
                                                      membersList
                                                          .indexWhere((m) {
                                                    if (m is Map<String,
                                                        dynamic>) {
                                                      final int? autoNum = m[
                                                          'additional_member_id'];
                                                      final String? typeStr =
                                                          m['type'] as String?;
                                                      return autoNum ==
                                                              extended
                                                                  .autoNumber &&
                                                          (typeStr?.toLowerCase() ==
                                                              'extended');
                                                    } else if (m is Member) {
                                                      return m.autoNumber ==
                                                              extended
                                                                  .autoNumber &&
                                                          (m.type ?? '')
                                                                  .toLowerCase() ==
                                                              'extended';
                                                    }
                                                    return false;
                                                  });

                                                  if (indexInMembers != -1) {
                                                    if (membersList[
                                                            indexInMembers]
                                                        is Map<String,
                                                            dynamic>) {
                                                      (membersList[
                                                                  indexInMembers]
                                                              as Map<String,
                                                                  dynamic>)[
                                                          'cover'] = newCover;
                                                    } else if (membersList[
                                                            indexInMembers]
                                                        is Member) {
                                                      (membersList[
                                                                  indexInMembers]
                                                              as Member)
                                                          .cover = newCover;
                                                    }
                                                    policy.members =
                                                        membersList;
                                                  }

                                                  onPolicyUpdated2(
                                                      context, true);
                                                });
                                              },
                                              buttonStyleData: ButtonStyleData(
                                                height: 45,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(32),
                                                  border: Border.all(
                                                      color: Colors.black26),
                                                  color: Colors.transparent,
                                                ),
                                                elevation: 0,
                                              ),
                                              iconStyleData:
                                                  const IconStyleData(
                                                icon: Icon(Icons
                                                    .arrow_forward_ios_outlined),
                                                iconSize: 14,
                                                iconEnabledColor: Colors.black,
                                                iconDisabledColor:
                                                    Colors.transparent,
                                              ),
                                              dropdownStyleData:
                                                  DropdownStyleData(
                                                elevation: 0,
                                                maxHeight: 200,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  color: Colors.white,
                                                ),
                                                offset: const Offset(-5, 0),
                                                scrollbarTheme:
                                                    ScrollbarThemeData(
                                                  radius:
                                                      const Radius.circular(40),
                                                  thickness:
                                                      MaterialStateProperty.all(
                                                          6),
                                                  thumbVisibility:
                                                      MaterialStateProperty.all(
                                                          true),
                                                ),
                                              ),
                                              menuItemStyleData:
                                                  MenuItemStyleData(
                                                overlayColor: null,
                                                height: 40,
                                                padding: const EdgeInsets.only(
                                                    left: 14, right: 14),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 8.0),
                              ],
                            ),
                          ),
                        ),
                        // Edit/Delete button column
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, bottom: 16, right: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  removeMemberFromPolicy2(extended,
                                      currentReference, context, "extended");
                                  appBarMemberCardNotifier.value++;
                                  advancedMemberCardKey2 = UniqueKey();
                                  setState(() {});
                                },
                                child: Icon(CupertinoIcons.delete),
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => StatefulBuilder(
                                      builder: (context, setState) => Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(64),
                                        ),
                                        elevation: 0.0,
                                        backgroundColor: Colors.transparent,
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: (Constants
                                                    .currentleadAvailable!
                                                    .leadObject
                                                    .documentsIndexed
                                                    .isEmpty)
                                                ? 750
                                                : 1200,
                                          ),
                                          margin:
                                              const EdgeInsets.only(top: 16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 10.0,
                                                offset: Offset(0.0, 10.0),
                                              ),
                                            ],
                                          ),
                                          child: NewMemberDialog(
                                            isEditMode: true,
                                            autoNumber: extended.autoNumber,
                                            relationship: "Extended",
                                            title: extended.title,
                                            name: extended.name,
                                            surname: extended.surname,
                                            dob: extended.dob,
                                            phone: extended.contact,
                                            idNumber: extended.id,
                                            is_self_or_payer: false,
                                            gender: extended.gender,
                                            canAddMember: true,
                                            current_member_index:
                                                current_member_index,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Constants.ftaColorLight,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Overlay for editing restriction
                if (!(_allowEditingExtended[memberKey] ?? false))
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.40),
                        borderRadius: BorderRadius.circular(12)),
                    height: 220,
                    child: Center(
                      child: InkWell(
                          onTap: () {
                            _allowEditingExtended[memberKey] = true;
                            setState(() {
                              print(
                                  "Editing enabled for extended member $memberKey: ${_allowEditingExtended[memberKey]}");
                            });
                          },
                          child: Icon(Iconsax.edit)),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Map<int, String> _selectedCoverExtendedAmounts = {};

  void showAddChildrenDialog(
      BuildContext context, int current_member_index, bool canAddMember) {
    // 1) Filter <18 year old AdditionalMembers for display
    List<AdditionalMember> allChildrenList = [];
    if (Constants.currentleadAvailable != null) {
      allChildrenList =
          Constants.currentleadAvailable!.additionalMembers.where((m) {
        // If dob is empty, assume age is 0
        int age = m.dob.isEmpty ? 0 : calculateAge(DateTime.parse(m.dob));
        return age <= 24;
      }).toList();
    }

    if (Constants.currentleadAvailable != null) {
      allChildrenList =
          Constants.currentleadAvailable!.additionalMembers.where((m) {
        // If dob is empty, assume age is 0
        int age = m.dob.isEmpty ? 0 : calculateAge(DateTime.parse(m.dob));

        // Exclude members with the relationship "self" and only keep children under 18
        //return age <= 24 && m.relationship.toLowerCase() == "child";
        return (age <= 24 && m.relationship.toLowerCase() == "child");
      }).toList();
    }
    print("sahjs1 ${allChildrenList}");

    // 2) Determine which children are already on this policy (type = 'child')
    final policy =
        Constants.currentleadAvailable!.policies[current_member_index];
    final String? currentReference = policy.reference;
    final List<dynamic> membersList = policy.members ?? [];

    // Collect autoNumbers of existing child-members
    final Set<int> existingChildAutoNumbers = membersList.where((m) {
      if (m is Map<String, dynamic>) {
        return (m['type'] as String?)?.toLowerCase() == 'child' &&
            m['reference'] == currentReference;
      } else if (m is Member) {
        return (m.type ?? '').toLowerCase() == 'child' &&
            m.reference == currentReference;
      }
      return false;
    }).map<int>((m) {
      if (m is Map<String, dynamic>) {
        // Adjust if your JSON key is 'auto_number' or 'autoNumber'
        return m['additional_member_id'] as int;
      } else if (m is Member) {
        return m.autoNumber ?? 0;
      }
      return -1; // fallback
    }).toSet();
    print("sahjs1sahjs1 ${allChildrenList}");

    // 3) Remove those that are already in the policy from display
    allChildrenList.removeWhere(
      (child) => existingChildAutoNumbers.contains(child.autoNumber),
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        child: MovingLineDialog(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 630),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36),
            ),
            child: StatefulBuilder(
              builder: (context, setState1) => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 16),
                    Row(
                      children: [
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
                    SizedBox(height: 8),
                    Center(
                      child: Text(
                        "Select a Child",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Constants.ftaColorLight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Center(
                      child: Text(
                        "Click on a member below to select them as a child",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'YuGothic',
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // -------------------- List of potential children --------------------
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: allChildrenList.length,
                      itemBuilder: (context, index) {
                        final member = allChildrenList[index];
                        return Container(
                          // -------------------- The Child UI Card --------------------
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 16.0,
                            ),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Constants.ftaColorLight.withOpacity(0.9),
                                  Constants.ftaColorLight,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Profile Avatar.
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    member.gender.toLowerCase() == "female"
                                        ? Icons.female
                                        : Icons.male,
                                    size: 24,
                                    color:
                                        member.gender.toLowerCase() == "female"
                                            ? Colors.pinkAccent
                                            : Colors.blueAccent,
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                // Member information.
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Updated text label to reflect that this is for a child.
                                      Text(
                                        member.dob.isEmpty
                                            ? 'Child DoB: -'
                                            : 'Child DoB: ${DateFormat('dd MMM yyyy').format(DateTime.parse(member.dob))}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        '${member.title} ${member.name} ${member.surname}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.people_alt,
                                            color: Colors.white70,
                                            size: 15,
                                          ),
                                          const SizedBox(width: 4.0),
                                          Text(
                                            'Relationship: ${member.relationship}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.white70,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Spacer(),
                                          Container(
                                            height: 30,
                                            child: TextButton(
                                              onPressed: () {
                                                // Close the dialog.
                                                Navigator.of(context).pop();

                                                // 1) Create a new policy 'child' Member object.
                                                final newPolicyMember = Member(
                                                  member.autoNumber,
                                                  // Use the AdditionalMember's autoNumber.
                                                  null,
                                                  // pId (if not needed)
                                                  null,
                                                  // polId (if not needed)
                                                  currentReference,
                                                  // Policy reference.
                                                  member.autoNumber,
                                                  // additional_member_id.
                                                  null,
                                                  // mainMemberDOB (if not needed)
                                                  policiesSelectedCoverAmounts[
                                                      current_member_index],
                                                  // premium (set to 0 or adjust accordingly)
                                                  "child",
                                                  // A marker value (could be a string or a code for child)
                                                  0,
                                                  // type (you can define a code for child here, e.g. 0)
                                                  null,
                                                  // percentage (if not used for child)
                                                  "child",
                                                  // coverMembersCol (marker for child)
                                                  null,
                                                  // benRelationship
                                                  null,
                                                  // memberStatus
                                                  Constants.cec_employeeid,
                                                  // terminationDate (example value; adjust as needed)
                                                  null,
                                                  // updatedBy
                                                  null,
                                                  // memberQueryType
                                                  null,
                                                  // memberQueryTypeOldNew
                                                  Constants.cec_client_id,
                                                  // memberQueryTypeOldAutoNumber
                                                  Constants
                                                      .cec_employeeid, // cecClientId (or empId, adjust as needed)
                                                );

                                                // 2) Update policy.members to include (or replace) this child.
                                                final existingIndex =
                                                    membersList.indexWhere((m) {
                                                  if (m
                                                      is Map<String, dynamic>) {
                                                    return (m['autoNumber'] ==
                                                            member
                                                                .autoNumber) &&
                                                        (((m['type'] as String?)
                                                                    ?.toLowerCase()) ??
                                                                '') ==
                                                            'child' &&
                                                        m['reference'] ==
                                                            currentReference;
                                                  } else if (m is Member) {
                                                    return (m.autoNumber ==
                                                            member
                                                                .autoNumber) &&
                                                        ((m.type ?? '')
                                                                .toLowerCase()) ==
                                                            'child' &&
                                                        m.reference ==
                                                            currentReference;
                                                  }
                                                  return false;
                                                });

                                                if (existingIndex != -1) {
                                                  // Replace the existing child.
                                                  membersList[existingIndex] =
                                                      newPolicyMember.toJson();
                                                } else {
                                                  // Otherwise, add the new child.
                                                  membersList.add(
                                                      newPolicyMember.toJson());
                                                }

                                                // Update the policy's members list.
                                                policy.members = membersList;

                                                // 3) Recalculate the premium and update the UI.
                                                mySalesPremiumCalculatorValue
                                                    .value++;
                                                appBarMemberCardNotifier
                                                    .value++;
                                                advancedMemberCardKey2 =
                                                    UniqueKey();
                                                setState(() {});
                                              },
                                              child: Text(
                                                'Select',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                  color:
                                                      Constants.ctaColorLight,
                                                ),
                                              ),
                                              style: TextButton.styleFrom(
                                                  foregroundColor:
                                                      Constants.ctaColorLight,
                                                  backgroundColor:
                                                      Colors.white),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          activeStep1 = 2;
                          updateSalesStepsValueNotifier3.value++;
                          Navigator.of(context).pop();

                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              // set to false if you want to force a rating
                              builder: (context) => StatefulBuilder(
                                    builder: (context, setState) => Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(64),
                                      ),
                                      elevation: 0.0,
                                      backgroundColor: Colors.transparent,
                                      child: Container(
                                        // width: MediaQuery.of(context).size.width,

                                        constraints: BoxConstraints(
                                          maxWidth: (Constants
                                                  .currentleadAvailable!
                                                  .leadObject
                                                  .documentsIndexed
                                                  .isEmpty)
                                              ? 750
                                              : 1200,
                                        ),
                                        margin: const EdgeInsets.only(top: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 10.0,
                                              offset: Offset(0.0, 10.0),
                                            ),
                                          ],
                                        ),
                                        child: NewMemberDialog(
                                          isEditMode: false,
                                          autoNumber: 0,
                                          relationship: "Child",
                                          title: "",
                                          name: "",
                                          surname: "",
                                          dob: "",
                                          gender: "",
                                          current_member_index:
                                              current_member_index,
                                          canAddMember: canAddMember,
                                        ),
                                      ),
                                    ),
                                  ));
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Add New Member',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'YuGothic',
                              color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.teal,
                            backgroundColor: Constants.ctaColorLight),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showAddExtendedDialog(
      BuildContext context, int current_member_index, canAddMember) {
    // 1) Filter >18 year old AdditionalMembers for display
    List<AdditionalMember> allExtendedList = [];

    if (Constants.currentleadAvailable != null) {
      // Remove all members with "self" relationship
      allExtendedList =
          Constants.currentleadAvailable!.additionalMembers.where((m) {
        // If dob is empty, assume age is 19
        int age = m.dob.isEmpty ? 0 : calculateAge(DateTime.parse(m.dob));

        // Exclude members with the relationship "self" and keep only those > 18
        return age > 0 &&
            (m.relationship.toLowerCase() != "self" &&
                m.relationship.toLowerCase() != "partner" &&
                m.relationship.toLowerCase() != "child");
      }).toList();

      // 2) Determine which extended members are already on this policy
      final policy =
          Constants.currentleadAvailable!.policies[current_member_index];
      final String? currentReference = policy.reference;
      final List<dynamic> membersList = policy.members ?? [];

      // Collect autoNumbers of existing extended-members
      final Set<int> existingExtendedAutoNumbers = membersList.where((m) {
        if (m is Map<String, dynamic>) {
          return (m['reference'] == currentReference);
        } else if (m is Member) {
          return (m.reference == currentReference);
        }
        return false;
      }).map<int>((m) {
        if (m is Map<String, dynamic>) {
          return (m['additional_member_id'] ?? -1) as int;
        } else if (m is Member) {
          return m.autoNumber ?? -1;
        }
        return -1;
      }).toSet();

      // 3) Remove those that are already in the policy from display
      allExtendedList.removeWhere(
        (extended) => existingExtendedAutoNumbers.contains(extended.autoNumber),
      );
    }
    final policy =
        Constants.currentleadAvailable!.policies[current_member_index];
    final String? currentReference = policy.reference;
    final List<dynamic> membersList = policy.members ?? [];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        child: MovingLineDialog(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 630),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36),
            ),
            child: StatefulBuilder(
              builder: (context, setState1) => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 16),
                    Row(
                      children: [
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
                    SizedBox(height: 8),
                    Center(
                      child: Text(
                        "Add An Extended Member",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Constants.ftaColorLight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Center(
                      child: Text(
                        "Click on a member below to select them as an extended member",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'YuGothic',
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // -------------------- List of potential extended members --------------------
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: allExtendedList.length,
                      itemBuilder: (context, index) {
                        final member = allExtendedList[index];

                        return GestureDetector(
                          // -------------------- The Extended UI Card --------------------
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 16.0,
                            ),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Constants.ftaColorLight.withOpacity(0.9),
                                  Constants.ftaColorLight,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Profile Avatar
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    member.gender.toLowerCase() == "female"
                                        ? Icons.female
                                        : Icons.male,
                                    size: 24,
                                    color:
                                        member.gender.toLowerCase() == "female"
                                            ? Colors.pinkAccent
                                            : Colors.blueAccent,
                                  ),
                                ),
                                const SizedBox(width: 16.0),

                                // Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        member.dob.isEmpty
                                            ? 'DoB: - '
                                            : '${DateFormat('dd MMM yyyy').format(DateTime.parse(member.dob))}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        '${member.title} ${member.name} ${member.surname}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.people_alt,
                                            color: Colors.white70,
                                            size: 15,
                                          ),
                                          const SizedBox(width: 4.0),
                                          Text(
                                            'Relationship: ${member.relationship}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.white70,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Spacer(),
                                          Container(
                                            height: 30,
                                            child: TextButton(
                                              onPressed: () {
                                                // Close the dialog.
                                                Navigator.of(context).pop();

                                                // 1) Create a new extended Member object.
                                                final newPolicyMember = Member(
                                                  member.autoNumber,
                                                  // autoNumber
                                                  null,
                                                  // cId (if not needed)
                                                  null,
                                                  // pId (if not needed)
                                                  currentReference,
                                                  // policy reference
                                                  member.autoNumber,
                                                  // additional_member_id (if applicable)
                                                  null,
                                                  // mainMemberDOB (if applicable)
                                                  policiesSelectedCoverAmounts[
                                                      current_member_index],
                                                  // premium (default value)
                                                  "extended",
                                                  // type
                                                  0,
                                                  // percentage (if applicable)
                                                  null,
                                                  // coverMembersCol (if applicable)
                                                  "extended",
                                                  // benRelationship (if applicable)
                                                  null,
                                                  // memberStatus
                                                  null,
                                                  // terminationDate
                                                  Constants.cec_empid,
                                                  // updatedBy (example value)
                                                  null,
                                                  // memberQueryType
                                                  null,
                                                  // memberQueryTypeOldNew
                                                  null,
                                                  // memberQueryTypeOldAutoNumber
                                                  Constants.cec_client_id,
                                                  // cecClientId (example value)
                                                  Constants
                                                      .cec_empid, // empId (example value)
                                                );

                                                // 2) Update policy.members: check if an extended member already exists.
                                                final int existingIndex =
                                                    membersList.indexWhere((m) {
                                                  if (m
                                                      is Map<String, dynamic>) {
                                                    return (m['autoNumber'] ==
                                                            member
                                                                .autoNumber) &&
                                                        (((m['type'] as String?)
                                                                    ?.toLowerCase() ??
                                                                '') ==
                                                            'extended') &&
                                                        (m['reference'] ==
                                                            currentReference);
                                                  } else if (m is Member) {
                                                    return (m.autoNumber ==
                                                            member
                                                                .autoNumber) &&
                                                        ((m.type ?? '')
                                                                .toLowerCase() ==
                                                            'extended') &&
                                                        (m.reference ==
                                                            currentReference);
                                                  }
                                                  return false;
                                                });

                                                if (existingIndex != -1) {
                                                  // Replace the existing extended member.
                                                  membersList[existingIndex] =
                                                      newPolicyMember.toJson();
                                                } else {
                                                  // Add new extended member.
                                                  membersList.add(
                                                      newPolicyMember.toJson());
                                                }
                                                // Update the current policy's members list.
                                                policy.members = membersList;

                                                // 3) Recalculate premium and update UI.
                                                mySalesPremiumCalculatorValue
                                                    .value++;
                                                appBarMemberCardNotifier
                                                    .value++;
                                                advancedMemberCardKey2 =
                                                    UniqueKey();
                                                setState(() {});
                                              },
                                              child: Text(
                                                'Select',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                  color:
                                                      Constants.ctaColorLight,
                                                ),
                                              ),
                                              style: TextButton.styleFrom(
                                                foregroundColor:
                                                    Constants.ctaColorLight,
                                                backgroundColor: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Optionally, a button to add a new partner manually.
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          // activeStep = 2;
                          activeStep1 = 2;
                          updateSalesStepsValueNotifier3.value++;
                          Navigator.of(context).pop();

                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              // set to false if you want to force a rating
                              builder: (context) => StatefulBuilder(
                                    builder: (context, setState) => Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(64),
                                      ),
                                      elevation: 0.0,
                                      backgroundColor: Colors.transparent,
                                      child: Container(
                                        // width: MediaQuery.of(context).size.width,

                                        constraints: BoxConstraints(
                                          maxWidth: (Constants
                                                  .currentleadAvailable!
                                                  .leadObject
                                                  .documentsIndexed
                                                  .isEmpty)
                                              ? 750
                                              : 1200,
                                        ),
                                        margin: const EdgeInsets.only(top: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 10.0,
                                              offset: Offset(0.0, 10.0),
                                            ),
                                          ],
                                        ),
                                        child: NewMemberDialog(
                                          isEditMode: false,
                                          autoNumber: 0,
                                          relationship: "",
                                          title: "",
                                          name: "",
                                          surname: "",
                                          dob: "",
                                          gender: "",
                                          current_member_index:
                                              current_member_index,
                                          canAddMember: canAddMember,
                                          is_self_or_payer: false,
                                        ),
                                      ),
                                    ),
                                  ));
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Add New Member',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'YuGothic',
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.teal,
                          backgroundColor: Constants.ctaColorLight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showDoubleTapDialog4(BuildContext context2, int current_member_index) {
    List<AdditionalMember> allPartnersList = [];

    if (Constants.currentleadAvailable != null) {
      // 1. Get all additional members that are not "self"
      List<AdditionalMember> potentialPartners = Constants
          .currentleadAvailable!.additionalMembers
          .where((m) => m.relationship.toLowerCase() == "partner")
          .toList();

      if (kDebugMode) {
        //print("dffggf ${potentialPartners[0].name}");
      }

      // 2. Keep only those with age > 15 (if dob is empty, assume age 19)
      potentialPartners = potentialPartners.where((m) {
        int age = m.dob.isEmpty ? 19 : calculateAge(DateTime.parse(m.dob));
        return age >= 15;
      }).toList();

      // 3. Remove duplicate entries using autoNumber as key.
      Map<int, AdditionalMember> uniquePartners = {};
      for (var member in potentialPartners) {
        uniquePartners[member.autoNumber] = member;
      }
      allPartnersList = uniquePartners.values.toList();
    }

    showDialog(
        context: context,
        builder: (context1) => Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: MovingLineDialog(
                child: Container(
                  width: MediaQuery.of(context1).size.width,
                  padding: const EdgeInsets.all(16),
                  constraints:
                      const BoxConstraints(maxWidth: 500, maxHeight: 630),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(36),
                  ),
                  child: StatefulBuilder(
                    builder: (context, setState1) => SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 16),
                          Row(
                            children: [
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
                          SizedBox(height: 8),
                          Center(
                            child: Text(
                              "Select a Partner",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Constants.ftaColorLight,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Center(
                            child: Text(
                              "Click on a member below to select them as partner",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'YuGothic',
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Build the list of partner cards.
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: allPartnersList.length,
                            itemBuilder: (context, index) {
                              final member = allPartnersList[index];
                              return Container(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 16.0),
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Constants.ftaColorLight
                                            .withOpacity(0.9),
                                        Constants.ftaColorLight,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Profile Avatar
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          member.gender.toLowerCase() ==
                                                  "female"
                                              ? Icons.female
                                              : Icons.male,
                                          size: 24,
                                          color: member.gender.toLowerCase() ==
                                                  "female"
                                              ? Colors.pinkAccent
                                              : Colors.blueAccent,
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      // Member Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              member.dob.isEmpty
                                                  ? "DoB: -"
                                                  : 'DoB: ${DateFormat('dd MMM yyyy').format(DateTime.parse(member.dob))}',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(height: 4.0),
                                            Text(
                                              '${member.title} ${member.name} ${member.surname}',
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                            const SizedBox(height: 4.0),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.people_alt,
                                                  color: Colors.white70,
                                                  size: 15,
                                                ),
                                                const SizedBox(width: 4.0),
                                                Text(
                                                  'Relationship: ${member.relationship}',
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white70,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                Spacer(),
                                                Container(
                                                  height: 30,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();

                                                      // 1. Get the current policy and its reference.
                                                      final policy = Constants
                                                              .currentleadAvailable!
                                                              .policies[
                                                          current_member_index];
                                                      final String
                                                          currentReference =
                                                          policy.reference;
                                                      print(
                                                          "gfgggh1 ${member.autoNumber}");

                                                      // 2. Create a new partner Member.
                                                      // (Adjust the constructor parameters as required by your Member class.)
                                                      final newPolicyMember =
                                                          Member(
                                                        null,
                                                        null,

                                                        null,
                                                        // polId
                                                        currentReference,
                                                        member.autoNumber,
                                                        null,
                                                        // additional_member_id (if not needed)
                                                        policiesSelectedCoverAmounts[
                                                            current_member_index],
                                                        // premium (default 0)
                                                        "partner",
                                                        // type
                                                        0,
                                                        // percentage (or null if not used here)
                                                        null,
                                                        // any additional percentage field
                                                        "",
                                                        // coverMembersCol (if that’s your marker)
                                                        null,
                                                        // ben_relationship (if handled separately)
                                                        "",
                                                        // terminationDate? (example value)
                                                        null,
                                                        // updatedBy
                                                        null,
                                                        // memberQueryType
                                                        null,
                                                        // memberQueryTypeOldNew
                                                        "",
                                                        // memberQueryTypeOldAutoNumber
                                                        Constants.cec_client_id,
                                                        // cecClientId or empId (adjust accordingly)
                                                        Constants
                                                            .cec_employeeid, // cecClientId or empId (adjust accordingly)
                                                      );

                                                      // 3. Remove any existing partner from this policy.
                                                      if (policy.members !=
                                                          null) {
                                                        policy.members
                                                            .removeWhere((m) {
                                                          String memberType =
                                                              "";
                                                          int autoNumber = -1;
                                                          if (m is Map<String,
                                                              dynamic>) {
                                                            memberType = (m[
                                                                        'type'] ??
                                                                    "")
                                                                .toString()
                                                                .toLowerCase();
                                                            autoNumber =
                                                                m['additional_member_id']
                                                                        as int? ??
                                                                    -1;
                                                          } else if (m
                                                              is Member) {
                                                            memberType = (m
                                                                        .type ??
                                                                    "")
                                                                .toLowerCase();
                                                            autoNumber =
                                                                m.autoNumber ??
                                                                    -1;
                                                          }
                                                          return memberType ==
                                                                  "partner" &&
                                                              autoNumber ==
                                                                  member
                                                                      .autoNumber;
                                                        });
                                                      }

                                                      // 4. Add the new partner only to this policy’s members.
                                                      policy.members.add(
                                                          newPolicyMember
                                                              .toJson());

                                                      SalesService
                                                          salesservice =
                                                          SalesService();
                                                      salesservice.updatePolicy(
                                                        Constants
                                                            .currentleadAvailable!,
                                                        context,
                                                      );

                                                      // 6. Recalculate premium and update UI.
                                                      mySalesPremiumCalculatorValue
                                                          .value++;
                                                      print(
                                                          "Updated membersList: ${policy.members}");
                                                      appBarMemberCardNotifier
                                                          .value++;
                                                      advancedMemberCardKey2 =
                                                          UniqueKey();
                                                      setState(() {});
                                                    },
                                                    child: Text(
                                                      'Select',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'YuGothic',
                                                        color: Constants
                                                            .ctaColorLight,
                                                      ),
                                                    ),
                                                    style: TextButton.styleFrom(
                                                        foregroundColor:
                                                            Constants
                                                                .ctaColorLight,
                                                        backgroundColor:
                                                            Colors.white),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          // Optionally, a button to add a new partner manually.
                          Center(
                            child: TextButton.icon(
                              onPressed: () {
                                // activeStep = 2;
                                activeStep1 = 2;
                                updateSalesStepsValueNotifier3.value++;
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    // set to false if you want to force a rating
                                    builder: (context) => StatefulBuilder(
                                          builder: (context, setState) =>
                                              Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(64),
                                            ),
                                            elevation: 0.0,
                                            backgroundColor: Colors.transparent,
                                            child: Container(
                                              // width: MediaQuery.of(context).size.width,

                                              constraints: BoxConstraints(
                                                maxWidth: (Constants
                                                        .currentleadAvailable!
                                                        .leadObject
                                                        .documentsIndexed
                                                        .isEmpty)
                                                    ? 750
                                                    : 1200,
                                              ),
                                              margin: const EdgeInsets.only(
                                                  top: 16),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 10.0,
                                                    offset: Offset(0.0, 10.0),
                                                  ),
                                                ],
                                              ),
                                              child: NewMemberDialog(
                                                isEditMode: false,
                                                autoNumber: 0,
                                                relationship: "Partner",
                                                title: "",
                                                name: "",
                                                surname: "",
                                                dob: "",
                                                gender: "",
                                                current_member_index:
                                                    current_member_index,
                                                canAddMember: true,
                                              ),
                                            ),
                                          ),
                                        ));
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Add A Partner',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'YuGothic',
                                  color: Colors.white,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.teal,
                                backgroundColor: Constants.ctaColorLight,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }

  void showAddPartnerDialog(
      BuildContext context, int current_member_index, canAddMember) {
    List<AdditionalMember> allPartnerList = [];

    // --- Pre-computation: Get existing member IDs for the current policy ---
    Set<int> existingMemberAutoNumbersInPolicy =
        {}; // Use a more general name initially
    if (Constants.currentleadAvailable != null &&
        current_member_index <
            Constants.currentleadAvailable!.policies.length) {
      final policy =
          Constants.currentleadAvailable!.policies[current_member_index];
      final String? currentReference =
          policy.reference; // Needed if filtering by ref matters here too
      final List<dynamic> membersList = policy.members ?? [];

      existingMemberAutoNumbersInPolicy = membersList
          .map<int>((m) {
            if (m is Map<String, dynamic>) {
              // Use 'additional_member_id' as it seems to be the linking key based on other code parts
              return (m['additional_member_id'] as int?) ?? -1;
            } else if (m is Member) {
              // If using Member objects directly
              return m.additionalMemberId ??
                  -1; // Assuming Member class has additionalMemberId
            }
            return -1; // Default for unexpected types
          })
          .where((id) => id != -1) // Filter out invalid IDs
          .toSet(); // Use a Set for efficient `contains` check
    }
    // --- End Pre-computation ---

    if (Constants.currentleadAvailable != null) {
      // 1) Gather all AdditionalMembers who ARE partners AND are NOT already in the current policy
      allPartnerList =
          Constants.currentleadAvailable!.additionalMembers.where((m) {
        // Check relationship AND if the member's autoNumber is NOT in the set of existing IDs
        return m.relationship.toLowerCase() == "partner" &&
            !existingMemberAutoNumbersInPolicy.contains(m.autoNumber);
      }).toList();

      // 2) Optional: filter out members below a certain age (e.g. < 15)
      allPartnerList = allPartnerList.where((m) {
        // Handle potential parsing errors for dob
        DateTime? dobDate = DateTime.tryParse(m.dob ?? "");
        int age = (dobDate == null)
            ? 19
            : calculateAge(dobDate); // Default age if dob invalid
        return age >= 15;
      }).toList();
    }

    showDialog(
        context: context,
        builder: (context1) => Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: MovingLineDialog(
                child: Container(
                  width: MediaQuery.of(context1).size.width,
                  padding: const EdgeInsets.all(16),
                  constraints:
                      const BoxConstraints(maxWidth: 500, maxHeight: 630),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(36),
                  ),
                  child: StatefulBuilder(
                    builder: (context, setState1) => SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 24),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              "Add A Partner",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Constants.ftaColorLight,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Center(
                            child: Text(
                              "Click on a member below to add them as partner",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'YuGothic',
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // -------------------- List of potential partner members --------------------
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: allPartnerList.length,
                            itemBuilder: (context, index) {
                              final member = allPartnerList[index];

                              return GestureDetector(
                                // or InkWell
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                    horizontal: 16.0,
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Constants.ftaColorLight
                                            .withOpacity(0.9),
                                        Constants.ftaColorLight,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Profile Avatar
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          member.gender.toLowerCase() ==
                                                  "female"
                                              ? Icons.female
                                              : Icons.male,
                                          size: 24,
                                          color: member.gender.toLowerCase() ==
                                                  "female"
                                              ? Colors.pinkAccent
                                              : Colors.blueAccent,
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),

                                      // Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              member.dob.isEmpty
                                                  ? 'DoB: - '
                                                  : '${DateFormat('dd MMM yyyy').format(DateTime.parse(member.dob))}',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(height: 4.0),
                                            Text(
                                              '${member.title} ${member.name} ${member.surname}',
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                            const SizedBox(height: 4.0),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.people_alt,
                                                  color: Colors.white70,
                                                  size: 15,
                                                ),
                                                const SizedBox(width: 4.0),
                                                Text(
                                                  'Relationship: ${member.relationship}',
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white70,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                const Spacer(),
                                                SizedBox(
                                                  height: 30,
                                                  child: TextButton(
                                                    // When the user taps the "Select" button:
                                                    onPressed: () async {
                                                      // 1) Get the policy for the current member index and its reference.
                                                      final policy = Constants
                                                              .currentleadAvailable!
                                                              .policies[
                                                          current_member_index];
                                                      final String?
                                                          currentReference =
                                                          policy.reference;
                                                      final List<dynamic>
                                                          membersList =
                                                          policy.members ?? [];

                                                      // 2) Build a new partner Member object from the selected member data.
                                                      final newPolicyMember =
                                                          Member(
                                                        null,
                                                        // id if not needed
                                                        null,
                                                        // pId
                                                        null,
                                                        // polId
                                                        currentReference,
                                                        // reference
                                                        member.autoNumber,
                                                        null,
                                                        policiesSelectedCoverAmounts[
                                                            current_member_index],
                                                        // additional_member_id (if not needed, set to 0)
                                                        "partner",
                                                        // type indicator
                                                        0,
                                                        // premium (default 0)
                                                        null,
                                                        // percentage if not used
                                                        "",
                                                        null,
                                                        "",
                                                        null,
                                                        null,
                                                        null,
                                                        "",
                                                        Constants.cec_client_id,
                                                        Constants
                                                            .cec_employeeid,
                                                      );

                                                      SalesService
                                                          salesService =
                                                          SalesService();

                                                      // 3) Check if a partner already exists in the policy (by autoNumber, type, and reference)
                                                      final existingIndex =
                                                          membersList
                                                              .indexWhere((m) {
                                                        if (m is Map<String,
                                                            dynamic>) {
                                                          return (m[
                                                                  'additional_member_id'] ==
                                                              member
                                                                  .autoNumber);
                                                        } else if (m
                                                            is Member) {
                                                          return (m.autoNumber ==
                                                                  member
                                                                      .autoNumber) &&
                                                              ((m.type ?? '')
                                                                      .toLowerCase()) ==
                                                                  'partner' &&
                                                              m.reference ==
                                                                  currentReference;
                                                        }
                                                        return false;
                                                      });
                                                      print(
                                                          "fgghgh1 $existingIndex ${member.autoNumber}");
                                                      // 4) If the member doesn't exist, add it using the API and update the members list.
                                                      if (existingIndex == -1) {
                                                        bool added = await salesService
                                                            .addMemberToPolicy(
                                                                newPolicyMember
                                                                    .toJson(),
                                                                context);

                                                        if (added) {
                                                          membersList.add(
                                                              newPolicyMember
                                                                  .toJson());
                                                        } else {
                                                          // Optionally handle failure (e.g., show an error toast) and exit.
                                                          return;
                                                        }
                                                      } else {
                                                        // Member exists, update existing record.
                                                        membersList[
                                                                existingIndex] =
                                                            newPolicyMember
                                                                .toJson();
                                                      }

                                                      // 5) Update the policy's members list.
                                                      Constants
                                                          .currentleadAvailable!
                                                          .policies[
                                                              current_member_index]
                                                          .members = membersList;

                                                      // 7) Trigger premium recalculation and refresh the UI.
                                                      mySalesPremiumCalculatorValue
                                                          .value++; // Force UI update.
                                                      setState1(() {});

                                                      // 8) Optionally, close the dialog.
                                                      Navigator.of(context)
                                                          .pop();
                                                      appBarMemberCardNotifier
                                                          .value++;
                                                      advancedMemberCardKey2 =
                                                          UniqueKey();
                                                    },

                                                    child: Text(
                                                      'Select',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'YuGothic',
                                                        color: Constants
                                                            .ctaColorLight,
                                                      ),
                                                    ),
                                                    style: TextButton.styleFrom(
                                                      foregroundColor: Constants
                                                          .ctaColorLight,
                                                      backgroundColor:
                                                          Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          // -------------------- Add a new partner manually --------------------
                          Center(
                            child: TextButton.icon(
                              onPressed: () {
                                // If you want to close the current dialog first:
                                Navigator.of(context).pop();

                                // Then show your "NewMemberDialog" for a new partner
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => StatefulBuilder(
                                    builder: (context, setState) => Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(64),
                                      ),
                                      elevation: 0.0,
                                      backgroundColor: Colors.transparent,
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth: (Constants
                                                  .currentleadAvailable!
                                                  .leadObject
                                                  .documentsIndexed
                                                  .isEmpty)
                                              ? 750
                                              : 1200,
                                        ),
                                        margin: const EdgeInsets.only(top: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 10.0,
                                              offset: Offset(0.0, 10.0),
                                            ),
                                          ],
                                        ),
                                        child: NewMemberDialog(
                                          isEditMode: false,
                                          autoNumber: 0,
                                          relationship: "Partner",
                                          title: "",
                                          name: "",
                                          surname: "",
                                          dob: "",
                                          gender: "",
                                          current_member_index:
                                              current_member_index,
                                          canAddMember: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Add New Partner',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'YuGothic',
                                  color: Colors.white,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.teal,
                                backgroundColor: Constants.ctaColorLight,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }

  void showDoubleTapDialog4Old(BuildContext context, int current_member_index) {
    List<AdditionalMember> allPartnersList = [];

    if (Constants.currentleadAvailable != null) {
      // 1. Get all additional members that are not 'self'
      List<AdditionalMember> potentialPartners = Constants
          .currentleadAvailable!.additionalMembers
          .where((m) => m.relationship.toLowerCase() != "self")
          .toList();

      // 2. Keep only those with age > 15 (if dob is empty, assume age 19)
      potentialPartners = potentialPartners.where((m) {
        int age = m.dob.isEmpty ? 19 : calculateAge(DateTime.parse(m.dob));
        return age > 15;
      }).toList();

      // 3. Remove duplicate entries (if any) by keying on autoNumber.
      Map<int, AdditionalMember> uniquePartners = {};
      for (var member in potentialPartners) {
        uniquePartners[member.autoNumber] = member;
      }
      allPartnersList = uniquePartners.values.toList();
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        child: MovingLineDialog(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 630),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36),
            ),
            child: StatefulBuilder(
              builder: (context, setState1) => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 32),
                    Center(
                      child: Text(
                        "Select a Partner",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Constants.ftaColorLight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Center(
                      child: Text(
                        "Click on a member below to select them as partner",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'YuGothic',
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Partner List
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: allPartnersList.length,
                      itemBuilder: (context, index) {
                        final member = allPartnersList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();

                            // 1) Get the current policy reference
                            String? currentReference = Constants
                                .currentleadAvailable!
                                .policies[current_member_index]
                                .reference;

                            // 2) Convert AdditionalMember -> Member
                            final newPolicyMember = Member(
                              null,
                              null,
                              null,
                              currentReference,
                              member.autoNumber,
                              null,
                              // premium
                              policiesSelectedCoverAmounts[
                                  current_member_index],
                              // cover
                              "partner",
                              // type
                              0,
                              // percentage
                              null,
                              // coverMembersCol
                              "partner",
                              // benRelationship
                              null,
                              // memberStatus
                              null,
                              // terminationDate
                              3,
                              // updatedBy
                              null,
                              // memberQueryType
                              null,
                              // memberQueryTypeOldNew
                              null,
                              // memberQueryTypeOldAutoNumber
                              -1,
                              // cecClientId
                              3, // empId
                            );

                            // Get the list of members for the current policy
                            final membersList = Constants.currentleadAvailable!
                                .policies[current_member_index].members;
                            print("membthhghjhj $membersList");

                            // Collect members to remove
                            List<dynamic> membersToRemove = [];

                            for (var member in membersList) {
                              // Debug prints
                              print("j0ghhjhj0 ${member.toString()}");

                              // Check if the member is a Map or a Member object
                              if (member is Map<String, dynamic>) {
                                final relationship = (member["type"] ?? "")
                                    .toString()
                                    .toLowerCase();
                                print("Relationship345: $relationship");

                                if (relationship == "partner") {
                                  membersToRemove.add(member);
                                }
                              } else if (member is Member) {
                                final relationship = (member.type ?? "")
                                    .toString()
                                    .toLowerCase();
                                print("Relationship: $relationship");

                                if (relationship == "partner") {
                                  membersToRemove.add(member);
                                }
                              } else {
                                print(
                                    "Unknown member type: ${member.runtimeType}");
                              }
                            }

                            // Remove the collected members
                            membersToRemove.forEach((member) {
                              Constants.currentleadAvailable!
                                  .policies[current_member_index].members
                                  .remove(member);
                            });

                            // Add the new partner member
                            Constants.currentleadAvailable!
                                .policies[current_member_index].members
                                .add(newPolicyMember.toJson());

                            // Recalculate premium
                            mySalesPremiumCalculatorValue.value++;

                            // Debug print final state of membersList
                            print("Updated membersList: $membersList");

                            // 3) Remove any existing partner

                            // 6) Rebuild UI
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 16.0,
                            ),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Constants.ftaColorLight.withOpacity(0.9),
                                  Constants.ftaColorLight,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Profile Avatar
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    member.gender.toLowerCase() == "female"
                                        ? Icons.female
                                        : Icons.male,
                                    size: 24,
                                    color:
                                        member.gender.toLowerCase() == "female"
                                            ? Colors.pinkAccent
                                            : Colors.blueAccent,
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                // Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        member.dob.isEmpty
                                            ? "DoB: -"
                                            : 'DoB: ${DateFormat('dd MMM yyyy').format(DateTime.parse(member.dob))}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        '${member.title} ${member.name} ${member.surname}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.people_alt,
                                            color: Colors.white70,
                                            size: 15,
                                          ),
                                          const SizedBox(width: 4.0),
                                          Text(
                                            'Relationship: ${member.relationship}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.white70,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              // set to false if you want to force a rating
                              builder: (context) => StatefulBuilder(
                                    builder: (context, setState) => Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(64),
                                      ),
                                      elevation: 0.0,
                                      backgroundColor: Colors.transparent,
                                      child: Container(
                                        // width: MediaQuery.of(context).size.width,

                                        constraints: BoxConstraints(
                                          maxWidth: (Constants
                                                  .currentleadAvailable!
                                                  .leadObject
                                                  .documentsIndexed
                                                  .isEmpty)
                                              ? 750
                                              : 1200,
                                        ),
                                        margin: const EdgeInsets.only(top: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 10.0,
                                              offset: Offset(0.0, 10.0),
                                            ),
                                          ],
                                        ),
                                        child: NewMemberDialog(
                                          isEditMode: false,
                                          autoNumber: 0,
                                          relationship: "Partner",
                                          title: "",
                                          name: "",
                                          surname: "",
                                          dob: "",
                                          gender: "",
                                          current_member_index:
                                              current_member_index,
                                          canAddMember: true,
                                        ),
                                      ),
                                    ),
                                  ));
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Add New Member',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'YuGothic',
                              color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.teal,
                            backgroundColor: Constants.ctaColorLight),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _scrollToSelected(int index) {
    // Use a post-frame callback to ensure the widget positions are updated.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final keyContext = _buttonKeys[index].currentContext;
      if (keyContext != null) {
        // Get the RenderBox of the button.
        final box = keyContext.findRenderObject() as RenderBox;
        // Get its position relative to the scrollable container.
        final position = box.localToGlobal(Offset.zero,
            ancestor: context.findRenderObject());
        // Calculate the new offset: current offset + the button's x position.
        double offset = _scrollController.offset + position.dx - 16;
        // Animate the scroll so that the selected button is at the left edge.
        _scrollController.animateTo(
          offset,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Widget getAllMembers() {
    // Ensure currentleadAvailable and the policy/members exist
    if (Constants.currentleadAvailable == null ||
        Constants.currentleadAvailable!.policies.isEmpty ||
        current_member_index >=
            Constants.currentleadAvailable!.policies.length ||
        Constants
                .currentleadAvailable!.policies[current_member_index].members ==
            null) {
      return Container(
        height: 140,
        child: Center(child: Text("Member data not available.")),
      );
    }

    final List<dynamic> policyMembers =
        Constants.currentleadAvailable!.policies[current_member_index].members!;
    final List<AdditionalMember> allAdditionalMembers =
        Constants.currentleadAvailable!.additionalMembers ?? [];

    return Container(
      height: 176,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16.0, right: 16, top: 4, bottom: 4),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: policyMembers.length,
          itemBuilder: (context, index) {
            // 1. Get Policy Member Data & Create Member Object
            Member member1;
            var memberData = policyMembers[index];
            try {
              if (memberData is Map<String, dynamic>) {
                member1 = Member.fromJson(memberData);
              } else if (memberData is Member) {
                member1 = memberData;
              } else {
                print(
                    "Warning: Unexpected member data type at index $index: ${memberData?.runtimeType}");
                member1 = Member.empty();
              }
            } catch (e) {
              print("Error creating Member object at index $index: $e");
              member1 = Member.empty();
            }

            // 2. Find Corresponding AdditionalMember
            AdditionalMember member2;
            int? additionalMemberId = member1.additionalMemberId;
            if (additionalMemberId != null && additionalMemberId != -1) {
              try {
                member2 = allAdditionalMembers.firstWhere(
                  (am) => am.autoNumber == additionalMemberId,
                );
              } catch (e) {
                print(
                    "Warning: AdditionalMember with ID $additionalMemberId not found for policy member index $index. $e");
                member2 = AdditionalMember.empty();
              }
            } else {
              print(
                  "Warning: Invalid or missing additionalMemberId for policy member index $index.");
              member2 = AdditionalMember.empty();
            }

            // 3. Determine Card State:
            // Card is selected if its type matches riders_filter and its additionalMemberId matches.
            bool isSelected = (member1.type != null &&
                member1.type == riders_filter &&
                member1.additionalMemberId == riders_filter_member_id);
            bool isSelfOrPayer = member1.type == 'main_member' ||
                member1.type == 'premium_payer';

            // 4. Calculate total rider premium for this member.
            double riderAmount = 0.0;
            var policy =
                Constants.currentleadAvailable!.policies[current_member_index];
            if (policy.riders != null) {
              for (var rider in policy.riders!) {
                // Compare rider's member_id with current member's additionalMemberId.
                if (rider["member_id"] == member1.additionalMemberId) {
                  // Safely parse the premium value.
                  riderAmount += (rider["premium"] is num)
                      ? (rider["premium"] as num).toDouble()
                      : 0.0;
                }
              }
            }

            // 5. Build the card.
            return Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                width: 450,
                height: 160,
                child: AdvancedMemberCard(
                  // AdditionalMember details
                  id: member2.id ?? "",
                  key: advancedMemberCardKey3,
                  dob: member2.dob ?? "",
                  surname: member2.surname ?? "",
                  contact: member2.contact ?? "",
                  sourceOfWealth: member2.sourceOfWealth ?? "",
                  dateOfBirth: member2.dob ?? "",
                  sourceOfIncome: member2.sourceOfIncome ?? "",
                  otherUnknownIncome: member2.otherUnknownIncome ?? "",
                  otherUnknownWealth: member2.otherUnknownWealth ?? "",
                  title: member2.title ?? "",
                  name: member2.name ?? "",
                  relationship: (member2.relationship != null &&
                          member2.relationship!.isNotEmpty &&
                          member2.relationship != '-')
                      ? member2.relationship!
                      : (member1.type ?? '-'),
                  gender: member2.gender ?? "",
                  autoNumber: member2.autoNumber ?? -1,
                  // Policy-specific details
                  premium: member1.premium ?? 0.0,
                  cover: member1.cover ?? 0.0,
                  // New: Pass the computed total rider premium
                  riderAmount: riderAmount,
                  isSelected: isSelected,
                  allowScaling: false,
                  isEditing: isSelected,
                  current_member_index: current_member_index,
                  is_self_or_payer: isSelfOrPayer,
                  noOfMembers: 0,
                  onSingleTap: () {
                    // When tapped, set the riders filter and current member id.
                    if (member1.type != null &&
                        member1.additionalMemberId != null) {
                      setState(() {
                        riders_filter = member1.type!;
                        riders_filter_member_id = member1.additionalMemberId!;
                        print(
                            "Rider filter set to: $riders_filter, member id: $riders_filter_member_id");
                      });
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildRidersGrid() {
    int onololeadid = Constants.currentleadAvailable!.leadObject.onololeadid;

    // 1. Filter mainRates by the chosen product.
    final productFilteredRates = Constants.currentParlourConfig!.mainRates
        .where(
            (r) => r.product == policiesSelectedProducts[current_member_index]);

    // 2. Extract distinct product types.
    final distinctProdTypes =
        productFilteredRates.map((r) => r.prodType).toSet().toList()..sort();

    if (current_member_index >= policyPremiums.length) {
      return const SizedBox();
    }

    // 3. Filter riders for this policy based on product type and relationship.
    final filteredRiders =
        policyPremiums[current_member_index].allRiders.where((rider) {
      bool matchesProduct = distinctProdTypes.contains(rider.linkedProduct);
      bool matchesRelationship =
          (rider.relationship == riders_filter || rider.relationship == "all");
      return matchesProduct && matchesRelationship;
    }).toList();

    if (filteredRiders.isEmpty ||
        mainMembers.isEmpty ||
        Constants.currentleadAvailable!.policies[current_member_index].members
                .length ==
            0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "No Additional Benefits Available",
            style: TextStyle(fontSize: 14, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final policy =
        Constants.currentleadAvailable!.policies[current_member_index];

    print("onololeadid: $onololeadid");

    // Helper function to get the correct member ID
    int getCurrentMemberAdditionalId() {
      // Get the current member's additional_member_id
      if (mainMembers.isNotEmpty && current_member_index < mainMembers.length) {
        // If you have a way to get the current member's additional_member_id from mainMembers
        // you should use that. For now, let's get it from the policy members

        // Find the main_member in the current policy
        final policyMembers = policy.members ?? [];
        for (var member in policyMembers) {
          if (member["type"] == "main_member") {
            return member["additional_member_id"] ?? 0;
          }
        }
      }

      // Fallback: if you have riders_filter_member_id set correctly elsewhere
      return riders_filter_member_id;
    }

    // Helper function to calculate selected riders total
    void calculateSelectedRidersTotal() {
      policyPremiums[current_member_index].selectedRidersTotal = 0.0;

      // Iterate over all riders in the current policy
      if (policy.riders != null) {
        for (var rider in policy.riders!) {
          var riderPremium = rider["premium"];
          if (riderPremium != null) {
            // Convert riderPremium to double if necessary.
            double premiumValue;
            if (riderPremium is num) {
              premiumValue = riderPremium.toDouble();
            } else {
              premiumValue = double.tryParse(riderPremium.toString()) ?? 0.0;
            }
            policyPremiums[current_member_index].selectedRidersTotal =
                (policyPremiums[current_member_index].selectedRidersTotal ??
                        0.0) +
                    premiumValue;
          }
        }
      }
      print(
          "Updated selectedRidersTotal: ${policyPremiums[current_member_index].selectedRidersTotal}");
    }

    // Helper function to handle rider add/remove logic
    void handleRiderToggle(Rider rider, bool isSelected, int correctMemberId) {
      // Get the correct member ID
      //int correctMemberId = getCurrentMemberAdditionalId();

      print("=== Rider Toggle Debug ===");
      print("Rider ID: ${rider.id}");
      print("Current riders_filter_member_id: $riders_filter_member_id");
      print("Correct member ID to use: $correctMemberId");
      print("Is Selected: $isSelected");

      if (isSelected) {
        // Remove the rider from the policy's riders list.
        int removedCount = policy.riders!.length;
        policy.riders!.removeWhere(
            (r) => r["id"] == rider.id && r["member_id"] == correctMemberId);
        int afterRemoval = policy.riders!.length;
        print("Removed ${removedCount - afterRemoval} riders");
      } else {
        // Build a new map for the rider with required keys.
        Map<String, dynamic> original =
            Map<String, dynamic>.from(rider.toJson());
        Map<String, dynamic> transformed = {
          "auto_number": original["id"],
          "id": original["id"],
          "premium": original["price"],
          "cover": original["rider_name"],
          "riderType": original["value"],
          "memberType": original["relationship"],
          "timestamp": original["timestamp"],
          "last_update": original["last_update"],
          // Use the reference and onololeadid from the first member of the policy
          "reference": policy.members![0]["reference"],
          "onololeadid": policy.members![0]["onololeadid"],
          "updated_by": Constants.cec_employeeid,
          "rider_query_type": "New Business",
          "rider_query_type_old_new": "new",
          "rider_query_type_old_auto_number": null,
          "member_id": correctMemberId, // Use the correct member ID here
        };

        print("Adding rider with transformed data:");
        print("member_id: ${transformed["member_id"]}");
        print("id: ${transformed["id"]}");
        print("premium: ${transformed["premium"]}");

        policy.riders ??= [];
        policy.riders!.add(transformed);
      }

      // Update policy in database
      SalesService().updatePolicy(Constants.currentleadAvailable!, context);

      // Recalculate selected riders total
      calculateSelectedRidersTotal();

      print("=== End Rider Toggle ===");
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 columns
            crossAxisSpacing: 16.0, // horizontal spacing
            mainAxisSpacing: 16.0, // vertical spacing
            mainAxisExtent: 290, // height per grid item
          ),
          itemCount: filteredRiders.length,
          itemBuilder: (context, index) {
            final rider = filteredRiders[index];

            // Get the correct member ID for checking if rider is selected
            int correctMemberId = riders_filter_member_id;

            // Check if this rider is already added for the selected member.
            bool isSelected = policy.riders != null &&
                policy.riders!.any((r) =>
                    r["id"] == rider.id && r["member_id"] == correctMemberId);

            print(
                "Rider ${rider.id} isSelected: $isSelected (checking against member_id: $correctMemberId)");

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: RiderCard(
                rider: rider,
                isSelected: isSelected,
                onCheck: () {
                  setState(() {
                    handleRiderToggle(rider, isSelected, correctMemberId);
                    // Increment the value notifier to trigger UI updates
                    mySalesPremiumCalculatorValue.value++;
                    onPolicyUpdated2(context, false);
                  });
                },
                onAddBenefit: () {
                  setState(() {
                    handleRiderToggle(rider, isSelected, correctMemberId);
                    // Increment both value notifiers to trigger UI updates
                    mySalesPremiumCalculatorValue2.value++;
                    onPolicyUpdated2(context, false);
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void updateGlobalCoverAmounts(List<dynamic> membersList,
      String currentReference, int currentMemberIndex, double coverAmount) {
    // Iterate through each member and update its cover field if it qualifies.
    for (int i = 0; i < membersList.length; i++) {
      final m = membersList[i];
      String memberType = "";
      String reference = "";

      if (m is Map<String, dynamic>) {
        memberType = (m['type'] as String?)?.toLowerCase() ?? "";
        reference = m['reference'] ?? "";
        if ((memberType == 'extended' ||
                memberType == 'partner' ||
                memberType == 'child') &&
            reference == currentReference) {
          m['cover'] = coverAmount;
        }
      } else if (m is Member) {
        memberType = (m.type ?? '').toLowerCase();
        reference = m.reference!;
        if ((memberType == 'extended' ||
                memberType == 'partner' ||
                memberType == 'child') &&
            reference == currentReference) {
          m.cover = coverAmount;
        }
      }
    }

    // Update the policy's members list.
    Constants.currentleadAvailable!.policies[currentMemberIndex].members =
        membersList;
    print("fdfgdgffg $membersList");
  }

  String getOldPayerRelationship(String newPayerRelationship,
      String oldPayerRelationship, AdditionalMember oldPayer) {
    switch (newPayerRelationship.toLowerCase()) {
      case "partner":
        // If new payer is partner, old payer becomes partner (spouse relationship)
        return "partner";

      case "child":
      case "adult child":
        // If new payer is child/adult child, old payer becomes parent
        return "parent";

      case "parent":
        // If new payer is parent, old payer becomes child (or adult child based on age)
        return "adult child"; // Assuming adult child since they were a payer

      case "sister":
        // If new payer is sister, old payer becomes brother or sister based on their gender
        String oldPayerGender = getGenderFromId(oldPayer.id);
        return oldPayerGender == "male" ? "brother" : "sister";

      case "brother":
        // If new payer is brother, old payer becomes sister or brother based on their gender
        String oldPayerGender = getGenderFromId(oldPayer.id);
        return oldPayerGender == "male" ? "brother" : "sister";

      case "aunt":
        // If new payer is aunt, old payer becomes niece or nephew based on their gender
        String oldPayerGender = getGenderFromId(oldPayer.id);
        return oldPayerGender == "male" ? "nephew" : "niece";

      case "uncle":
        // If new payer is uncle, old payer becomes niece or nephew based on their gender
        String oldPayerGender = getGenderFromId(oldPayer.id);
        return oldPayerGender == "male" ? "nephew" : "niece";

      case "niece":
        // If new payer is niece, old payer becomes aunt or uncle based on their gender
        String oldPayerGender = getGenderFromId(oldPayer.id);
        return oldPayerGender == "male" ? "uncle" : "aunt";

      case "nephew":
        // If new payer is nephew, old payer becomes aunt or uncle based on their gender
        String oldPayerGender = getGenderFromId(oldPayer.id);
        return oldPayerGender == "male" ? "uncle" : "aunt";

      case "grandfather":
        // If new payer is grandfather, old payer becomes grandchild (represented as child)
        return "adult child";

      case "grandmother":
        // If new payer is grandmother, old payer becomes grandchild (represented as child)
        return "adult child";

      case "cousin":
        // If new payer is cousin, old payer becomes cousin
        return "cousin";

      default:
        // Default case - make old payer a partner (most common scenario)
        return "partner";
    }
  }

  String getGenderFromId(String idNumber) {
    if (idNumber.length >= 10) {
      // In South African ID: positions 6-9 represent gender (0000-4999 = female, 5000-9999 = male)
      int genderDigits = int.tryParse(idNumber.substring(6, 10)) ?? 0;
      return genderDigits >= 5000 ? "male" : "female";
    }
    return "unknown"; // If ID format is invalid
  }

  Future<void> updateMemberBackend(BuildContext context, int autoNumber,
      AdditionalMember updatedMember) async {
    String baseUrl = "${Constants.insightsBackendBaseUrl}fieldV6/updateMember/";
    int onoloadId = Constants.currentleadAvailable!.leadObject.onololeadid;
    print("dffgghhg ${onoloadId} ${autoNumber} ${updatedMember.relationship}");

    try {
      var headers = {'Content-Type': 'application/json'};

      Map<String, dynamic> payload = {
        "auto_number": autoNumber,
        "title": updatedMember.title,
        "name": updatedMember.name,
        "surname": updatedMember.surname,
        "gender": updatedMember.gender,
        "dob": updatedMember.dob,
        "age": (DateTime.now().year - DateTime.parse(updatedMember.dob).year)
            .toString(),
        "relationship": updatedMember.relationship,
        "id": updatedMember.id,
        "contact": updatedMember.contact,
        "onololeadid": onoloadId.toString(),
        "source_of_income": updatedMember.sourceOfIncome,
        "source_of_wealth": updatedMember.sourceOfWealth,
        "other_unknown_income": updatedMember.otherUnknownIncome,
        "other_unknown_wealth": updatedMember.otherUnknownWealth,
      };

      var request = http.Request('POST', Uri.parse(baseUrl));
      request.body = json.encode(payload);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var responseData = jsonDecode(responseBody);
        if (responseData == 1 ||
            responseData == "1" ||
            responseData.toString() == "1") {
          print("Successfully updated member ${autoNumber} on backend");
        } else {
          print(
              "Backend update failed for member ${autoNumber}: $responseData");
        }
      } else {
        print(
            "HTTP error updating member ${autoNumber}: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception updating member ${autoNumber}: $e");
    }
  }

  void calculateAndUpdateTotalPremium() {
    if (policyPremiums.length <= current_member_index) return;

    double totalMemberPremiums = 0.0;
    double totalRiderPremiums = 0.0;

    // Calculate total from all member premiums
    final calcResponse = policyPremiums[current_member_index];
    for (var memberPremium in calcResponse.memberPremiums) {
      totalMemberPremiums += memberPremium.premium ?? 0.0;
      print(
          "Member ${memberPremium.role}: R${(memberPremium.premium ?? 0.0).toStringAsFixed(2)}");
    }

    // Calculate total rider premiums
    final policy =
        Constants.currentleadAvailable!.policies[current_member_index];
    if (policy.riders != null) {
      for (var rider in policy.riders!) {
        var riderPremium = rider["premium"];
        if (riderPremium != null) {
          double premiumValue;
          if (riderPremium is num) {
            premiumValue = riderPremium.toDouble();
          } else {
            premiumValue = double.tryParse(riderPremium.toString()) ?? 0.0;
          }
          totalRiderPremiums += premiumValue;
        }
      }
    }

    // Update the total premium
    policyPremiums[current_member_index].totalPremium = totalMemberPremiums;
    policyPremiums[current_member_index].selectedRidersTotal =
        totalRiderPremiums;

    // Also update the quote's total amount payable
    Constants.currentleadAvailable!.policies[current_member_index].quote
            .totalAmountPayable =
        totalMemberPremiums +
            totalRiderPremiums +
            (policyPremiums[current_member_index].joiningFee ?? 0.0);

    print("=== Premium Calculation Summary ===");
    print("Total Member Premiums: R${totalMemberPremiums.toStringAsFixed(2)}");
    print("Total Rider Premiums: R${totalRiderPremiums.toStringAsFixed(2)}");
    print(
        "Joining Fee: R${(policyPremiums[current_member_index].joiningFee ?? 0.0).toStringAsFixed(2)}");
    print(
        "Grand Total: R${(totalMemberPremiums + totalRiderPremiums + (policyPremiums[current_member_index].joiningFee ?? 0.0)).toStringAsFixed(2)}");
    print("================================");
  }

  //Helper methods
  bool _isCommencementDateValid() {
    if (commencementDates.isEmpty ||
        current_member_index >= commencementDates.length) {
      return false;
    }

    final currentValue = commencementDates[current_member_index];
    return currentValue != null &&
        currentValue.isNotEmpty &&
        commencementList.contains(currentValue);
  }

  String? _getCurrentCommencementValue() {
    if (commencementDates.isEmpty ||
        current_member_index >= commencementDates.length) {
      return null;
    }

    final currentValue = commencementDates[current_member_index];

    // Only return the value if it exists in the available options
    if (currentValue != null &&
        currentValue.isNotEmpty &&
        commencementList.contains(currentValue)) {
      return currentValue;
    }

    return null; // Return null to show hint text and red border
  }

  String _getCommencementHintText() {
    if (commencementDates.isEmpty ||
        current_member_index >= commencementDates.length) {
      return 'Select a commencement date';
    }

    final currentValue = commencementDates[current_member_index];

    // If there's a value but it's not in the list, show error message
    if (currentValue != null &&
        currentValue.isNotEmpty &&
        !commencementList.contains(currentValue)) {
      return 'Date not available - please select new date';
    }

    return 'Select a commencement date';
  }

  List<DropdownMenuItem<String>> _buildUniqueCommencementItems() {
    // Remove duplicates from commencementList to prevent the dropdown error
    final uniqueCommencementList = commencementList.toSet().toList();

    return uniqueCommencementList.map((String classType) {
      return DropdownMenuItem<String>(
        value: classType,
        child: Text(
          classType,
          style: const TextStyle(
            fontSize: 13.5,
            fontFamily: 'YuGothic',
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      );
    }).toList();
  }

  // Additional validation method to check if user needs to select a new date
  bool needsNewCommencementSelection() {
    if (commencementDates.isEmpty ||
        current_member_index >= commencementDates.length) {
      return true;
    }

    final currentValue = commencementDates[current_member_index];

    // Returns true if the current value is not in the available list
    return currentValue == null ||
        currentValue.isEmpty ||
        !commencementList.contains(currentValue);
  }
}

int calculateAge(DateTime dob) {
  final now = DateTime.now();
  int age = now.year - dob.year;
  if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
    age--;
  }
  return age;
}

class RiderCard extends StatefulWidget {
  final Rider rider;
  final bool isSelected;
  final VoidCallback? onCheck;
  final VoidCallback? onAddBenefit;

  const RiderCard({
    Key? key,
    required this.rider,
    required this.isSelected,
    this.onCheck,
    this.onAddBenefit,
  }) : super(key: key);

  @override
  State<RiderCard> createState() => _RiderCardState();
}

class _RiderCardState extends State<RiderCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () {}, // Single tap => "check" or select
        child: AnimatedScale(
          scale: isHovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: CustomCard(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: widget.isSelected
                    ? Constants.ftaColorLight.withOpacity(0.7)
                    : Colors.transparent,
                width: 2,
              ),
            ),
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  // Circle avatar or icon for the rider
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: widget.isSelected
                        ? Constants.ftaColorLight
                        : Colors.grey.shade300,
                    child: const Icon(
                      Icons.health_and_safety,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Rider details in a column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.rider.riderName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Linked Product: ${widget.rider.linkedProduct}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Price: R${widget.rider.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Age Range: ${widget.rider.minAge} - ${widget.rider.maxAge}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Type: ${widget.rider.relationship}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // "Add Benefit" button area
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.isSelected
                          ? TextButton.icon(
                              onPressed: () {
                                // "Remove" logic
                                // Ensure that `policyPremiums` and `policiesSelectedCoverAmounts` are valid for the current policy index
                                if (current_member_index >=
                                        policyPremiums.length ||
                                    policyPremiums[current_member_index]
                                            .totalPremium ==
                                        0 ||
                                    current_member_index >=
                                        policiesSelectedCoverAmounts.length ||
                                    policiesSelectedCoverAmounts[
                                            current_member_index] ==
                                        0) {
                                  MotionToast.error(
                                    description: const Center(
                                      child: Text(
                                        "Please calculate the premium first.",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'YuGothic',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    animationType: AnimationType.fromTop,
                                    width: 350,
                                    height: 55,
                                    animationDuration: const Duration(
                                      milliseconds: 2500,
                                    ),
                                  ).show(context);
                                  return;
                                } else {
                                  if (widget.onCheck != null) {
                                    print("onCheck clicked");
                                    widget.onCheck!(); // The same toggle method
                                  }
                                }
                              },
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                              label: const Text(
                                'Remove Benefit',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.redAccent),
                            )
                          : TextButton.icon(
                              onPressed: () {
                                // "Add" logic
                                // Check if a cover amount has been selected for the current policy
                                if (current_member_index >=
                                        policiesSelectedCoverAmounts.length ||
                                    policiesSelectedCoverAmounts[
                                            current_member_index] ==
                                        0) {
                                  MotionToast.error(
                                    description: const Center(
                                      child: Text(
                                        "Please select a cover amount first before adding benefits.",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'YuGothic',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    animationType: AnimationType.fromTop,
                                    width: 350,
                                    height: 55,
                                    animationDuration: const Duration(
                                      milliseconds: 2500,
                                    ),
                                  ).show(context);
                                  return;
                                }

                                if (widget.onAddBenefit != null) {
                                  widget.onAddBenefit!();
                                }
                              },
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: const Text('Add Benefit',
                                  style: TextStyle(color: Colors.white)),
                              style: TextButton.styleFrom(
                                  backgroundColor: Constants.ftaColorLight),
                            )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AdvancedPolicyCard extends StatefulWidget {
  final int policy_index;
  final bool is_selected;
  final String main_insured;
  final String policy_status;
  final double total_premium;
  final String selected_product;
  final double selected_cover;

  const AdvancedPolicyCard({
    super.key,
    required this.policy_index,
    required this.is_selected,
    required this.main_insured,
    required this.policy_status,
    required this.total_premium,
    required this.selected_product,
    required this.selected_cover,
  });

  @override
  State<AdvancedPolicyCard> createState() => _AdvancedPolicyCardState();
}

class _AdvancedPolicyCardState extends State<AdvancedPolicyCard> {
  bool isHovered = false;
  int number_of_members = 1;

  @override
  void initState() {
    super.initState();

    if (Constants.currentleadAvailable != null &&
        Constants.currentleadAvailable!.policies.isNotEmpty) {
      int memberCount = Constants
          .currentleadAvailable!.policies[widget.policy_index!].members.length;
      number_of_members = memberCount < 1 ? 1 : memberCount;
    } else {
      number_of_members = 1;
    }
    print("Number of members: $number_of_members");
  }

  Map<String, dynamic> ClientCenterPremimCalculatorQuestions = {};

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: AnimatedScale(
            scale: isHovered ? 1.02 : 1.0, // Smooth scaling on hover
            duration: const Duration(milliseconds: 200),
            child: Container(
              height: 145,
              width: 400,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: widget.is_selected == true
                          ? Colors.green
                          : Colors.grey.withOpacity(0.55))),
              child: Column(
                children: [
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                        color: widget.is_selected == true
                            ? Colors.green
                            : Colors.grey,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(widget.main_insured,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500)),
                        ),
                        InkWell(
                          child: Container(
                            padding: const EdgeInsets.all(0.0),
                            decoration: BoxDecoration(
                              color: widget.is_selected == true
                                  ? Colors.green.withOpacity(0.15)
                                  : Colors.grey.withOpacity(0.15),
                              //  color: Constants.ftaColorLight.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(360.0),
                              border: Border.all(
                                color: widget.is_selected == true
                                    ? Colors.green
                                    : Colors.grey,
                                width: 1.5,
                              ),
                            ),
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: Center(
                                child: Text(number_of_members.toString()),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        Container(
                            height: 32,
                            decoration: BoxDecoration(
                                color: widget.is_selected == true
                                    ? Colors.green
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(32)),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, right: 12, top: 0, bottom: 0),
                              child: Text(
                                widget.policy_status,
                                style: TextStyle(color: Colors.white),
                              ),
                            )))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.policy_index < policyPremiums.length
                                ? (
                                    // If memberPremiums is empty, show "No Premium for Selected Cover"
                                    policyPremiums[widget.policy_index]
                                            .memberPremiums
                                            .isEmpty
                                        ? "No Premium for Selected Cover"
                                        : (
                                            // Otherwise, check if the first member's comment is not empty and total premium is 0.
                                            policyPremiums[widget.policy_index]
                                                        .memberPremiums
                                                        .first
                                                        .comment
                                                        .isNotEmpty &&
                                                    widget.total_premium == 0
                                                ? "No Premium for Selected Cover"
                                                : "R" +
                                                    widget.total_premium
                                                        .toStringAsFixed(2)))
                                : "R" + widget.total_premium.toStringAsFixed(2),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: (widget.policy_index <
                                          policyPremiums.length &&
                                      policyPremiums[widget.policy_index]
                                          .memberPremiums
                                          .isNotEmpty &&
                                      policyPremiums[widget.policy_index]
                                          .memberPremiums
                                          .first
                                          .comment
                                          .isNotEmpty)
                                  ? 16
                                  : 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0, right: 12),
                          child: Text(
                            widget.selected_product,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 12),
                        child: Text(
                          (widget.selected_cover != 0
                              ? "R${widget.selected_cover.toStringAsFixed(2)}"
                              : ""),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                ],
              ),
            )));
  }

  String formatLargeNumber3(String valueStr) {
    const List<String> suffixes = [
      "",
      "k",
      "m",
      "b",
      "t"
    ]; // Add more suffixes if needed

    // Convert string to double and handle invalid inputs
    double value;
    try {
      value = double.parse(valueStr);
    } catch (e) {
      return 'Invalid Number';
    }

    int index = 0;
    double newValue = value;

    while (newValue >= 1000 && index < suffixes.length - 1) {
      newValue /= 1000;
      index++;
    }

    // If value is 1000 or more, format using the calculated newValue
    if (value >= 1000) {
      // If the newValue is a whole number, don't include any decimals or "R" prefix.
      if (newValue == newValue.floorToDouble()) {
        return '${newValue.toInt()}${suffixes[index]}';
      } else {
        // Otherwise, include one decimal place and prefix with "R"
        return 'R${newValue.toStringAsFixed(1)}${suffixes[index]}';
      }
    } else {
      // For numbers below 1000, just return the value as an integer string
      return value.toStringAsFixed(0);
    }
  }
}

/// Returns true if you can still add a child member.
bool canAddChild({
  required dynamic policy,
  required dynamic matchingRate,
}) {
  if (matchingRate == null) return false;

  // 1) Check overall limit
  final totalExistingMembers = policy.members.length;
  if (totalExistingMembers >= matchingRate.maximumMembers) {
    return false;
  }

  // 2) Check child limit
  final numberOfExistingChildren =
      policy.members.where((m) => m['type'] == 'child').length;
  return numberOfExistingChildren < matchingRate.children;
}

/// Returns true if you can still add a partner/spouse.
bool canAddPartner({
  required dynamic policy,
  required dynamic matchingRate,
}) {
  if (matchingRate == null) return false;

  // 1) Check overall limit
  final totalExistingMembers = policy.members.length;
  if (totalExistingMembers >= matchingRate.maximumMembers) {
    return false;
  }

  // 2) Check partner limit
  final numberOfExistingPartners =
      policy.members.where((m) => m['type'] == 'partner').length;
  return numberOfExistingPartners < matchingRate.spouse;
}

/// Returns true if you can still add an extended member.
bool canAddExtended({
  required dynamic policy,
  required dynamic matchingRate,
}) {
  if (matchingRate == null) return false;

  // 1) Check overall limit
  final totalExistingMembers = policy.members.length;
  if (totalExistingMembers >= matchingRate.maximumMembers) {
    return false;
  }

  // 2) Check extended limit
  final numberOfExistingExtended =
      policy.members.where((m) => m['type'] == 'extended').length;
  return numberOfExistingExtended < matchingRate.extended;
}

void checkCanAddMembersOld(String? relationship) {
  final policy = Constants.currentleadAvailable!.policies[current_member_index];

  // 1) Get the matching rate
  final matchingRate = Constants.currentParlourConfig!.mainRates.firstWhere(
    (rate) =>
        rate.product == policiesSelectedProducts[current_member_index] &&
        rate.prodType == policiesSelectedProdTypes[current_member_index] &&
        rate.amount == policiesSelectedCoverAmounts[current_member_index],
  );

  // 2) Use our new helper functions
  final bool childAllowed = canAddChild(
    policy: policy,
    matchingRate: matchingRate,
  );

  final bool partnerAllowed = canAddPartner(
    policy: policy,
    matchingRate: matchingRate,
  );

  final bool extendedAllowed = canAddExtended(
    policy: policy,
    matchingRate: matchingRate,
  );

  print("Can add child? $childAllowed");
  print("Can add partner? $partnerAllowed");
  print("Can add extended? $extendedAllowed");
}

/// Checks if you can add a given relationship type ("child", "partner", or "extended")
/// and returns a message if you cannot. If the message is empty, you can add safely.
String checkCanAddMembers(String relationship) {
  if (policiesSelectedCoverAmounts[current_member_index] == 0) return "";
  final policy = Constants.currentleadAvailable!.policies[current_member_index];
  print(
      "relationshipg1h ${policiesSelectedProducts[current_member_index]} ${policiesSelectedProdTypes[current_member_index]} ${policiesSelectedCoverAmounts[current_member_index]}");
  if (Constants.currentParlourConfig == null) {
    return "";
  }
  if (current_member_index < policiesSelectedCoverAmounts.length) {
    return "";
  }
  // Get the matching rate from your config
  final matchingRate = Constants.currentParlourConfig!.mainRates.firstWhere(
    (rate) =>
        rate.product == policiesSelectedProducts[current_member_index] &&
        rate.prodType == policiesSelectedProdTypes[current_member_index] &&
        rate.amount == policiesSelectedCoverAmounts[current_member_index],
  );

  if (matchingRate == null) {
    // If for some reason we couldn't find a matching rate, we can’t add.
    return "Unable to determine plan limits; cannot add more members.";
  }

  // We’ll use these to decide if we can add more of each type.
  final childCount = policy.members.where((m) => m['type'] == 'child').length;
  final partnerCount =
      policy.members.where((m) => m['type'] == 'partner').length;
  final extendedCount =
      policy.members.where((m) => m['type'] == 'extended').length;

  final maxChildren = matchingRate.children; // e.g. 0 means no children allowed
  final maxPartners =
      matchingRate.spouse; // e.g. 1 means only 1 partner allowed
  final maxExtended = matchingRate.extended; // e.g. 2 means 2 extended allowed

  // Check the relationship
  switch (relationship.toLowerCase()) {
    case "child":
      // If plan says 0 children allowed:
      if (maxChildren == 0) {
        return "Cannot add children to the selected plan and cover amount.";
      }
      // If the limit is reached or exceeded:
      if (childCount >= maxChildren) {
        return "Cannot add more children to the selected plan and cover amount. "
            "The maximum is $maxChildren.";
      }
      // Otherwise, we can add safely
      return "";

    case "partner":
      if (maxPartners == 0) {
        return "Cannot add a partner to the selected plan and cover amount.";
      }
      if (partnerCount >= maxPartners) {
        return "Cannot add more partners to the selected plan and cover amount. "
            "The maximum is $maxPartners.";
      }
      return "";

    case "extended":
      if (maxExtended == 0) {
        return "Cannot add extended members to the selected plan and cover amount.";
      }
      if (extendedCount >= maxExtended) {
        return "Cannot add more extended members to the selected plan and cover amount. "
            "The maximum is $maxExtended.";
      }
      return "";

    default:
      // If the relationship is unrecognized, just return an error or empty.
      return "Unknown relationship type: $relationship.";
  }
}
