import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../constants/Constants.dart';
import '../../../../models/map_class.dart';
import '../../customwidgets/CustomCard.dart';
import 'field_call_lead_dialog.dart';

final DateFormat formatter = DateFormat('yyyy-MM-dd');

class FieldPremiumCalculator extends StatefulWidget {
  const FieldPremiumCalculator({
    super.key,
  });

  @override
  State<FieldPremiumCalculator> createState() => _FieldPremiumCalculatorState();
}

class _FieldPremiumCalculatorState extends State<FieldPremiumCalculator>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<String> partnerdateOfBirthList = [];
  List<String> coverList = [];
  int changeColorIndex = 0;
  int displayIndexedImage = 0;
  int show_border_index = 0;
  int show_border_index1 = 1;
  int card_color_index1 = 0;
  int card_color_index2 = 0;
  int btn_ch_index1 = 0;
  int bottomIndex = 0;
  int colorIndex = 0;
  String newPolicyString = "";
  String indexByString = "Need Analysis";
  double? _selectedCover;
  List<String> policiesSelectedMainInsuredDOBs = [];
  List<String> commencementDates = [];

  //List<Member> policiesSelectedPartners = [];
  List<String> policiesSelectedProducts = [];
  List<String> policiesSelectedProdTypes = [];
  List<Map> policiesSelectedPartners = [];
  List<Map> policiesSelectedChildren = [];
  List<Map> policiesSelectedExtended = [];
  List<List<double>> policiescoverAmounts = [];
  List<double> policiesSelectedCoverAmounts = [];
  double current_policy_cover_amount = 0;
  int _selectedProductIndex = 0;
  List<List<int>> _selectedRiderIds = [];

  String? _selectedPartnerDateOfBirth;
  String? _selectedCommencement;
  List<CalculatePolicyPremiumResponse> policyPremiums = [];

  double joiningFee = 0.0;
  double monthlyPremium = 0.0;
  List<QuoteRates> rates = [];
  List<InsurancePlan> insurancePlans = [];
  int? full_product_id = null;
  QuoteRates? selectedProductRate;

  List<BottomBar> bottomBarList = [
    BottomBar("Main Insured", "main_insured"),
    BottomBar("Partner", "partner"),
    BottomBar("Children", "children"),
    BottomBar("Parents/Extended Family", "extended_family"),
    BottomBar("Benefits", "benefits"),
  ];

  String yesOrNoValue = "";
  bool checkBoxValue1 = false;
  bool checkBoxValue2 = false;
  bool checkBoxValue3 = false;
  bool checkBoxValue4 = false;
  bool boolColor1 = false;
  bool boolColor2 = false;
  int isTickMarked = 0;
  bool isTickMarked1 = false;
  bool isTickMarked2 = false;
  bool isTickMarked3 = false;
  bool boolColor3 = false;
  bool boolColor4 = false;
  List<AdditionalMember> additionalMembers = [];
  List<AdditionalMember> mainMembers = [];
  int current_member_index = 0;
  List<String> productsList = [];
  LeadObject? currentLeadObject;
  String selectedProductString = "";
  String commencementDate = "";
  List<String> dateOfBirthList = [];

  @override
  void initState() {
    super.initState();
    print("fvgghhgfhdghgdh");
    getCalculateRatesBody();
    getProoductList();
    _tabController = TabController(length: bottomBarList.length, vsync: this);
    obtainMainInsuredForEachPolicy();

    calculatePolicyPremiumCal();
  }

  void getCalculateRatesBody() {
    insurancePlans.clear(); // reset before populating

    // 1) Check if a current lead is available
    if (Constants.currentleadAvailable == null) {
      print("No current lead available => no InsurancePlan added.");
      return;
    }

    // 2) Get the policies
    final List<Policy> policies =
        Constants.currentleadAvailable!.policies ?? [];
    if (policies.isEmpty) {
      print("No policies found => no InsurancePlan added.");
      return;
    }

    // 3) Loop through each policy to build an InsurancePlan
    for (var policy in policies) {
      int policyIndex = policies.indexOf(policy);
      // a) Basic product/cover info from the policy
      Quote quote = policy.quote;
      String productName = quote.product ?? "";
      if (policiesSelectedProducts.length > policyIndex) {
        if (policiesSelectedProducts[policyIndex].isNotEmpty) {
          productName = policiesSelectedProducts[policyIndex];
        }
      }

      // e.g. "Family Plans"
      String productType = quote.productType ?? ""; // e.g. "Bronze"
      if (policiesSelectedProdTypes.length > policyIndex) {
        if (policiesSelectedProdTypes[policyIndex].isNotEmpty) {
          productType = policiesSelectedProdTypes[policyIndex];
        }
      }
      final reference = quote.reference ?? ""; // e.g. "REF123"
      double? coverAmount = 0; // Default value
      if (policiesSelectedCoverAmounts.isNotEmpty &&
          policyIndex < policiesSelectedCoverAmounts.length) {
        coverAmount = policiesSelectedCoverAmounts[policyIndex];
      } else {
        // Optional: Handle the case where the index is invalid or the list is empty
        print("Invalid policyIndex or policiesSelectedCoverAmounts is empty.");
      }

      policiesSelectedProducts.add(productName);
      policiesSelectedProdTypes.add(productType);
      policiesSelectedCoverAmounts.add(quote.sumAssuredFamilyCover ?? 0);

      if (quote.sumAssuredFamilyCover != null) {
        coverAmount = (quote.sumAssuredFamilyCover as num).toDouble();
      }
      //double? coverAmount = null; // default
      if (quote.sumAssuredFamilyCover != null) {
        coverAmount = (quote.sumAssuredFamilyCover as num).toDouble();
      }

      // b) Prepare variables for main/partner/children/extended
      String? mainInsuredDob;
      String? partnerDob;
      List<String> extendedDobs = [];

      // c) Extract the members safely
      final members = policy.members ?? [];
      for (var memberData in members) {
        final relationship =
            (memberData["type"] ?? "").toString().toLowerCase();
        AdditionalMember? additionalMember =
            Constants.currentleadAvailable!.additionalMembers.firstWhere(
          (member1) => member1.autoNumber == memberData["additional_member_id"],
          orElse: () => AdditionalMember(
            memberType: "",
            autoNumber: 0,
            id: "",
            contact: "",
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
            updatedBy: "",
            memberQueryType: "",
            memberQueryTypeOldNew: "",
            memberQueryTypeOldAutoNumber: "",
            membersAutoNumber: "",
            sourceOfIncome: "",
            sourceOfWealth: "",
            otherUnknownIncome: "",
            otherUnknownWealth: "",
            timestamp: "",
            lastUpdate: "",
          ), // Return null if no match is found
        );
        if (additionalMember.autoNumber == -1) {
          print(
              "No matching AdditionalMember found for autoNumber: ${memberData["additional_member_id"]}");
          // Skip further processing
        } else {
          // Optionally parse the age if needed
          try {
            final age = calculateAge(DateTime.parse(additionalMember.dob));
            print("Policy member => relationship=$relationship, age=$age");
          } catch (e) {
            // If the dobString is invalid, skip
            print("Invalid DOB:");
            continue;
          }

          // Decide where to put the DOB
          if (relationship == "self" || relationship == "main_member") {
            mainInsuredDob = additionalMember.dob.split("T").first;
            policiesSelectedMainInsuredDOBs.add(mainInsuredDob);
          } else if (relationship == "partner" || relationship == "spouse") {
            partnerDob = additionalMember.dob.split("T").first;
            int index = policiesSelectedPartners.indexWhere(
                (partnerMap) => partnerMap.containsKey(policy.reference));

            if (index != -1) {
              // Replace the existing AdditionalMember for this policy reference
              policiesSelectedPartners[index] = {
                policy.reference: additionalMember,
              };
            } else {
              // Add the new policy reference and AdditionalMember if not found
              policiesSelectedPartners.add({
                policy.reference: additionalMember,
              });
            }

            print(policiesSelectedPartners);

            print("Partner DOB: $partnerDob");
          }
          if (relationship == "child" || relationship == "children") {
            // Extract and process DOB
            extendedDobs.add(additionalMember.dob.split("T").first);

            // Check if the policy reference exists in the list
            int index = policiesSelectedChildren.indexWhere(
                (policyMap) => policyMap.containsKey(policy.reference));

            if (index != -1) {
              // Policy reference exists, replace or update the AdditionalMember for this policy
              List<dynamic> existingChildren = policiesSelectedChildren[index]
                  [policy.reference] as List<dynamic>;

              // Check if the additionalMember already exists in the list (by unique criteria like ID)
              int childIndex = existingChildren.indexWhere((child) =>
                  child.id == additionalMember.id); // Ensure 'id' exists

              if (childIndex != -1) {
                // Replace the existing AdditionalMember
                existingChildren[childIndex] = additionalMember;
              } else {
                // Add new AdditionalMember if not already in the list
                existingChildren.add(additionalMember);
              }
            } else {
              // Policy reference does not exist; add a new entry
              policiesSelectedChildren.add({
                policy.reference: [additionalMember],
              });
            }

            // Debugging output to verify the list's state
            print(policiesSelectedChildren);
          } else {
            // treat everything else as extended
            extendedDobs.add(additionalMember.dob.split("T").first);
            // Extract and process DOB
            extendedDobs.add(additionalMember.dob.split("T").first);

            // Check if the policy reference exists in the list
            int index = policiesSelectedExtended.indexWhere(
                (policyMap) => policyMap.containsKey(policy.reference));

            if (index != -1) {
              // Policy reference exists, replace or update the AdditionalMember for this policy
              List<dynamic> existingChildren = policiesSelectedExtended[index]
                  [policy.reference] as List<dynamic>;

              // Check if the additionalMember already exists in the list (by unique criteria like ID)
              int childIndex = existingChildren.indexWhere((child) =>
                  child.id == additionalMember.id); // Ensure 'id' exists

              if (childIndex != -1) {
                // Replace the existing AdditionalMember
                existingChildren[childIndex] = additionalMember;
              } else {
                // Add new AdditionalMember if not already in the list
                existingChildren.add(additionalMember);
              }
            } else {
              // Policy reference does not exist; add a new entry
              policiesSelectedExtended.add({
                policy.reference: [additionalMember],
              });
            }

            // Debugging output to verify the list's state
            print(policiesSelectedChildren);
          }
        }

        // d) Build the InsurancePlan for this policy
        final plan = InsurancePlan(
          cecClientId: 1,
          // or some cecClientId logic
          reference: reference,
          product: productName,
          prodType: productType,
          coverAmount: coverAmount,
          mainInsuredDob: mainInsuredDob,
          partnerDob: partnerDob,
          childrensDobs: extendedDobs,
          extendedMembersDobs: extendedDobs,
          selectedRiders: [],
          // or logic for riders
          fullProductId: null, // or logic for fullProductId
        );

        // e) Add to the global insurancePlans list
        insurancePlans.add(plan);
      }

      // In many scenarios you might parse a "timestamp" or "dob"
    }

    print("InsurancePlans => ${insurancePlans.length} plans added.");
  }

  void obtainMainInsuredForEachPolicy() {
    // Check if the current lead exists
    if (Constants.currentleadAvailable != null) {
      final List<Policy> policies =
          Constants.currentleadAvailable!.policies ?? [];

      // Clear any existing data to avoid duplicates
      mainMembers.clear();
      dateOfBirthList = [];

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
          );

          if (additionalMember != null) {
            String thisMonth = formatter
                .format(DateTime(DateTime.now().year, DateTime.now().month, 1));
            commencementDates.add(thisMonth);
            mainMembers.add(additionalMember);
            print("Main Member Added: ${additionalMember.autoNumber}");

            // Extract and add DOB if available
            if (mainMemberData["dob"] != null &&
                mainMemberData["dob"].toString().isNotEmpty) {
              policiesSelectedMainInsuredDOBs
                  .add(mainMemberData["dob"].toString().split("T").first);
            }
          }
        } else {
          print("No main member found for Policy: ${policy.reference}");
        }
      }

      print("Total Main Members Found: ${mainMembers.length}");

      // Single UI update after processing
      setState(() {});
    } else {
      print("No current lead available.");
    }
  }

  void getProoductList() {
    if (Constants.currentleadAvailable == null) return;

    // All policies
    final policies = Constants.currentleadAvailable!.policies;
    if (policies.isEmpty) return; // no policies, nothing to do

    // Guarantee policiesSelectedProducts is at least as big as the # of policies
    // or at least big enough for current_member_index
    while (policiesSelectedProducts.length <= current_member_index) {
      policiesSelectedProducts.add("");
    }

    // Now it is safe to write to policiesSelectedProducts[current_member_index]
    final product = policies[0].quote?.product ?? "";
    final productType = policies[0].quote?.productType ?? "";

    // If current_member_index is out of range, clamp it or handle gracefully
    if (current_member_index < 0 ||
        current_member_index >= policiesSelectedProducts.length) {
      current_member_index = 0;
    }

    selectedProductString = "$product $productType";
    policiesSelectedProducts[current_member_index] = product;
    _selectedProdType = productType;

    print("selectedProductString => $selectedProductString");
    print("policiesSelectedProducts => $policiesSelectedProducts");
    print("_selectedProdType => $_selectedProdType");
  }

  getCoverAmounts(member_index) {
    print(
        "_selectedProduct => $policiesSelectedProducts _selectedProdType => $_selectedProdType");
    policiescoverAmounts[member_index] = rates
        .where((rate) =>
            (rate.product == policiesSelectedProducts[member_index] &&
                rate.prodType == _selectedProdType))
        .map((e) => e.amount)
        .toList()
        .toSet()
        .toList();

    print("coverAmounts => $policiescoverAmounts");
    setState(() {});
  }

  bool checkLeadContainsMembers() {
    if (Constants.currentleadAvailable != null) {
      if (Constants.currentleadAvailable!.additionalMembers.isNotEmpty) {
        print("Current lead contains members: "
            "${Constants.currentleadAvailable!.additionalMembers.length}");
        return true;
      } else {
        print("Current lead does not contain members.");
        return false;
      }
    }
    return false;
  }

// 1) Helper function to calculate an integer age from a DateTime
  int calculateAge(DateTime dob) {
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

// 2) Example method to gather policies, loop each policy's members & riders,
//    build array of requests, POST, then parse into List<CalculatePolicyPremiumResponse>.
  Future<List<CalculatePolicyPremiumResponse>>
      calculatePolicyPremiumCal() async {
    // 1) Make sure we have the up-to-date insurancePlans
    getCalculateRatesBody(); // This populates `insurancePlans`

    // 2) If nothing populated, return empty
    if (insurancePlans.isEmpty) {
      print("No insurance plans => returning empty list");
      return [];
    }

    // 3) Convert each InsurancePlan to JSON
    final List<Map<String, dynamic>> requestBodies =
        insurancePlans.map((plan) => plan.toJson()).toList();

    print("Sending array of requests to server => $requestBodies");

    final url = Uri.parse(
      'https://miinsightsapps.net/parlour_config/parlour-config/calculate-rates/',
    );

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBodies),
      );

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        print("Received response => $responseJson");

        // Expecting a List of JSON objects
        if (responseJson is! List) {
          print("Error: response is not a List => $responseJson");
          return [];
        }

        final List<CalculatePolicyPremiumResponse> results = [];

        // Clear before populating or ensure you start fresh
        policiescoverAmounts.clear();
        policyPremiums.clear();

        // Parse each item => each item corresponds to one policy's response
        for (int index = 0; index < responseJson.length; index++) {
          final item = responseJson[index];
          final parsed = CalculatePolicyPremiumResponse.fromJson(item);
          results.add(parsed);

          // Make sure policiescoverAmounts has a slot for this index
          while (policiescoverAmounts.length <= index) {
            policiescoverAmounts.add([]); // add an empty list
          }

          // For clarity, store the parsed in policyPremiums if needed
          policyPremiums.add(parsed);
          if (policyPremiums.isNotEmpty) {
            // optional
            Constants.allRidersOrBeneficiaries = policyPremiums[0].allRiders;
          }

          // Gather all rates for this policy
          final List<QuoteRates> theseRates = parsed.allMainRates;
          String currentProduct = policiesSelectedProducts[index];
          String currentProductType = policiesSelectedProdTypes[index];
          List<QuoteRates> prodTypeFilteredRates = theseRates
              .where((r) =>
                  r.product == currentProduct &&
                  r.prodType == currentProductType)
              .toList();

          final Set<double> allAmounts = {};

          for (var r in prodTypeFilteredRates) {
            allAmounts.add(r.amount);
          }

          // Sort them
          final sortedAmounts = allAmounts.toList()..sort();

          // Save to policiescoverAmounts
          policiescoverAmounts[index] = sortedAmounts;
        }

        // Optionally call setState() if you’re in a StatefulWidget
        setState(() {});
        if (results[current_member_index].errors.isNotEmpty) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              return StatefulBuilder(
                builder: (BuildContext dialogContext, StateSetter setState) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.white,
                    title: const Text('Warning'),
                    content: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: 550), // Apply the constraints here
                      child: Container(
                        height: 120,
                        width: 500,
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount:
                                results[current_member_index].errors.length,
                            itemBuilder: (context, index) {
                              return Text(
                                results[current_member_index]
                                    .errors[index]
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 16), // Optional styling
                              );
                            }),
                      ),
                    ),
                    actions: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Constants.ctaColorLight,
                                borderRadius: BorderRadius.circular(360),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 5,
                              ),
                              child: const Text(
                                'Continue',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          );
        }

        // Example debug prints:
        print("policiescoverAmounts => $policiescoverAmounts");
        // e.g. [ [1000,2000,5000], [10000,50000], ...]

        return results;
      } else {
        print("Error: HTTP ${response.statusCode}, body => ${response.body}");
        return [];
      }
    } catch (e) {
      print("Exception in calculatePolicyPremiumCal(): $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    String bottomString = bottomBarList[bottomIndex].bottomString_id;
    AdditionalMember main_insured;

    // Initialize partner date of birth list

    // Cover list

    // Date of birth list with error handling

/*
    try {
      if (Constants.currentleadAvailable!.policies.isNotEmpty &&
          Constants.currentleadAvailable!.policies[0].quote?.mainIsuredDob !=
              null) {
        dateOfBirthList.add(
          formatter.format(
            Constants.currentleadAvailable!.policies[0].quote!.mainIsuredDob!,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error parsing date: $e');
    }
*/
    List<String> productList = [];

    // Product list
    /* List<String> productList = (Constants
                .currentleadAvailable!.policies.isNotEmpty &&
            Constants.currentleadAvailable!.policies[0].quote?.productType !=
                null)
        ? ["${Constants.currentleadAvailable!.policies[0].quote!.productType}"]
        : [];*/

    // Calculate current and next months
    int currentYear = DateTime.now().year;
    int currentMonth = DateTime.now().month;
    int nextMonth =
        (currentMonth == 12) ? 1 : currentMonth + 1; // Handle year change
    int nextYear = (currentMonth == 12) ? currentYear + 1 : currentYear;

    // Format dates for commencement list
    String thisMonth = formatter.format(DateTime(currentYear, currentMonth, 1));
    String nextMonthFormatted =
        formatter.format(DateTime(nextYear, nextMonth, 1));

    // Commencement list
    List<String> commencementList = [thisMonth, nextMonthFormatted];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 24, right: 24),
            child: DefaultTabController(
              length: bottomBarList.length,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Allow horizontal scrolling
                child: TabBar(
                  controller: _tabController,
                  labelColor: Constants.ctaColorLight,
                  isScrollable: true, // Makes the TabBar scrollable
                  indicatorColor: Constants.ctaColorLight,
                  indicatorPadding: const EdgeInsets.only(top: 8),
                  overlayColor: WidgetStateProperty.all(Colors.white),
                  tabs: bottomBarList
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            item.bottomStringName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'YuGothic',
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Spacer(),
              Column(
                children: [
                  Text(
                    "MONTHLY PREMIUM",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'YuGothic',
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  policyPremiums.isEmpty
                      ? Text(
                          "R0.00",
                          style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        )
                      : policyPremiums[current_member_index]
                              .memberPremiums
                              .isEmpty
                          ? Text(
                              "R0.00",
                              style: TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            )
                          : Text(
                              "R${policyPremiums[current_member_index].totalPremium!.toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            )
                ],
              ),
              Expanded(flex: 2, child: Container()),
              Column(
                children: [
                  Text(
                    "POLICY FEE",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'YuGothic',
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  policyPremiums.isEmpty
                      ? Text(
                          "R0.00",
                          style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        )
                      : policyPremiums[current_member_index]
                              .memberPremiums
                              .isEmpty
                          ? Text(
                              "R0.00",
                              style: TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            )
                          : Text(
                              "R${policyPremiums[current_member_index].joiningFee!.toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 18,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                ],
              ),
              Expanded(flex: 2, child: Container()),
              Column(
                children: [
                  Text(
                    "FIRST PREMIUM",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'YuGothic',
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  policyPremiums.isEmpty
                      ? Text(
                          "R0.00",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 15,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w500,
                                color: Colors.red),
                          ),
                        )
                      : policyPremiums[current_member_index]
                              .memberPremiums
                              .isEmpty
                          ? Text(
                              "R0.00",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'YuGothic',
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red),
                            )
                          : Text(
                              "R${(policyPremiums[current_member_index]!.totalPremium! + policyPremiums[current_member_index].joiningFee!).toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.red),
                            )
                ],
              ),
              Spacer(),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Container(
              height: 165,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: mainMembers.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 0, right: 12),
                      child: Column(
                        children: [
                          Container(
                            height: 160,
                            width: MediaQuery.of(context).size.width - 64,
                            child: AdvancedMemberCard(
                              id: mainMembers[index].id,
                              dob: mainMembers[index].dob,
                              surname: mainMembers[index].surname,
                              contact: mainMembers[index].contact,
                              sourceOfWealth: mainMembers[index].sourceOfWealth,
                              dateOfBirth: mainMembers[index].dob,
                              sourceOfIncome: mainMembers[index].sourceOfIncome,
                              title: mainMembers[index].title,
                              name: mainMembers[index].name,
                              relationship: mainMembers[index].relationship,
                              gender: mainMembers[index].gender,
                              autoNumber: mainMembers[index].autoNumber,
                              isSelected: current_member_index == index,
                              noOfMembers:
                                  Constants.currentleadAvailable == null
                                      ? 0
                                      : Constants
                                          .currentleadAvailable!
                                          .policies[current_member_index]
                                          .members
                                          .length,
                              onSingleTap: () {
                                current_member_index = index;
                                print("dgfgfgf $current_member_index");
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
          Container(
            // width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(left: 24, right: 24),
            constraints: BoxConstraints(minHeight: 100),
            child: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        width: 900,
                        //height: 200,
                        child: GridView.builder(
                            itemCount: Constants.leadAvailable.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    //childAspectRatio: 16/1
                                    mainAxisExtent: 120,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15),
                            itemBuilder: (context, i) {
                              return InkWell(
                                child: Card(
                                  elevation: card_color_index1 == i ? 30 : 0,
                                  surfaceTintColor: Colors.white,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 45, //#00a65a
                                        //width: 350,
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8)),
                                          color: card_color_index1 == i
                                              ? Constants.ctaColorLight
                                              : Color(0XFF00a65a),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                child: Tooltip(
                                              margin: EdgeInsets.all(8),
                                              padding: EdgeInsets.all(12),
                                              message: Constants
                                                  .currentleadAvailable!
                                                  .policies[0]
                                                  .quote
                                                  .product,
                                              decoration: BoxDecoration(
                                                  //border: Border.all(width: 1.2, color: Color(0XFFff6a00)),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.black),
                                              child: Text(
                                                "${Constants.currentleadAvailable?.leadObject.title} ${Constants.currentleadAvailable?.leadObject.firstName} ${Constants.currentleadAvailable?.leadObject.lastName}",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'YuGothic',
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 66,
                                        //width: 350,
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        decoration: BoxDecoration(
                                          border: Border(
                                              left: BorderSide(
                                                  color:
                                                      Constants.ctaColorLight),
                                              right: BorderSide(
                                                  color:
                                                      Constants.ctaColorLight),
                                              bottom: BorderSide(
                                                  color:
                                                      Constants.ctaColorLight)),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(8),
                                              bottomRight: Radius.circular(8)),
                                          //color: Colors.grey
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "R ${Constants.currentleadAvailable?.policies[0].quote.totalPremium}",
                                              style: TextStyle(
                                                  fontSize: 14.5,
                                                  fontFamily: 'YuGothic',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Container(
                                              height: 45,
                                              width: 45,
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(360),
                                                color: card_color_index1 == i
                                                    ? Constants.ctaColorLight
                                                    : Color(0XFF00a65a),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  Constants.member.length
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'YuGothic',
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  card_color_index1 = i;
                                  setState(() {});
                                },
                              );
                            }),
                      ),
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
                            height: 24,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    const SizedBox(height: 0),
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
                                                          const EdgeInsets.only(
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
                                                                FontWeight.w500,
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
                                                            context);
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
                            height: 16,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    const SizedBox(height: 0),
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
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        360),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        360)),
                                                        border: Border(
                                                            right: BorderSide(
                                                                color: Colors
                                                                    .grey
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
                                                              'Select a commencement date',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'YuGothic',
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                            isExpanded: true,
                                                            value: commencementDates
                                                                        .length <
                                                                    current_member_index
                                                                ? null
                                                                : commencementDates[
                                                                    current_member_index],
                                                            items:
                                                                commencementList
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
                                                                                fontSize: 13.5,
                                                                                fontFamily: 'YuGothic',
                                                                                fontWeight: FontWeight.w500,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ))
                                                                    .toList(),
                                                            onChanged: (newValue) {
                                                              setState(() {
                                                                _selectedCommencement =
                                                                    newValue!
                                                                        .toString();
                                                              });
                                                            }),
                                                      ),
                                                    ),
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
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    const SizedBox(height: 0),

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
                                                                      left: 8.0,
                                                                      top: 14),
                                                              child: const Text(
                                                                  "No cover amounts found"),
                                                            )
                                                          : DropdownButtonHideUnderline(
                                                              child:
                                                                  DropdownButton<
                                                                      double>(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
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
                                                                // NOTE: 'padding' is supported in Flutter 3.7+;
                                                                // if using an older version, wrap DropdownButton in a Padding widget instead.
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  left: 24,
                                                                  right: 24,
                                                                  top: 5,
                                                                  bottom: 5,
                                                                ),

                                                                // 1) The currently selected value
                                                                value: (policiesSelectedCoverAmounts[
                                                                            current_member_index] !=
                                                                        0)
                                                                    ? policiesSelectedCoverAmounts[
                                                                        current_member_index]
                                                                    : null,

                                                                // 2) If no selection yet, show hint
                                                                hint: Text(
                                                                  policiesSelectedCoverAmounts[
                                                                              current_member_index] ==
                                                                          0
                                                                      ? 'Select Cover Amount'
                                                                      : policiesSelectedCoverAmounts[
                                                                              current_member_index]
                                                                          .toString(),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        'YuGothic',
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                isExpanded:
                                                                    true,

                                                                // 3) Build dropdown items from the possible cover amounts
                                                                items: policiescoverAmounts[
                                                                        current_member_index]
                                                                    .map((double
                                                                        coverAmount) {
                                                                  return DropdownMenuItem<
                                                                      double>(
                                                                    value:
                                                                        coverAmount,
                                                                    child: Text(
                                                                      coverAmount
                                                                          .toString(),
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            13.5,
                                                                        fontFamily:
                                                                            'YuGothic',
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  );
                                                                }).toList(),

                                                                // 4) Update the selected amount in setState
                                                                onChanged:
                                                                    (newValue) {
                                                                  setState(() {
                                                                    policiesSelectedCoverAmounts[
                                                                            current_member_index] =
                                                                        newValue ??
                                                                            0.0;
                                                                    Constants
                                                                        .currentleadAvailable!
                                                                        .policies[
                                                                            current_member_index]
                                                                        .quote
                                                                        .sumAssuredFamilyCover;
                                                                    calculatePolicyPremiumCal();
                                                                  });
                                                                },
                                                              ),
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
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Date Of Birth ',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'YuGothic',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                    const SizedBox(height: 0),
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
                                                                topLeft: Radius
                                                                    .circular(
                                                                        360),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        360)),
                                                        border: Border(
                                                            right: BorderSide(
                                                                color: Colors
                                                                    .grey
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
                                                    child: Container(
                                                      height: 48,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Corrected the condition to avoid out-of-range errors
                                                          (policiesSelectedMainInsuredDOBs
                                                                      .isEmpty ||
                                                                  current_member_index >=
                                                                      policiesSelectedMainInsuredDOBs
                                                                          .length)
                                                              ? Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              12.0),
                                                                  child:
                                                                      const Text(
                                                                    "Select Date Of Birth",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'YuGothic',
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          14,
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
                                                                    formatter
                                                                        .format(
                                                                      DateTime.parse(
                                                                          policiesSelectedMainInsuredDOBs[current_member_index]
                                                                              .toString()),
                                                                    ),
                                                                    style:
                                                                        const TextStyle(
                                                                      fontFamily:
                                                                          'YuGothic',
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ),
                                                        ],
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
                                                                  topRight: Radius
                                                                      .circular(
                                                                          360),
                                                                  bottomRight:
                                                                      Radius.circular(
                                                                          360)),
                                                          border: Border(
                                                              right: BorderSide(
                                                                  color: Colors
                                                                      .white))),
                                                      child: Center(
                                                        child: Icon(
                                                          Iconsax.filter_edit,
                                                          size: 24,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      showDoubleTapDialog3(
                                                          context);
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
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 24,
                          ),
                        ],
                      ),
                    ],
                  ),
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
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'YuGothic',
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        //SizedBox(width: 16),
                                        Container(
                                          child: Transform.scale(
                                            scaleX: 1.7,
                                            scaleY: 1.7,
                                            child: Checkbox(
                                                value: checkBoxValue2,
                                                side: BorderSide(
                                                    width: 1.4,
                                                    color: Constants
                                                        .ftaColorLight),
                                                activeColor:
                                                    Constants.ctaColorLight,
                                                checkColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            360.0)),
                                                onChanged: (bool? newValue) {
                                                  setState(() {
                                                    checkBoxValue2 = newValue!;
                                                    if (checkBoxValue2 ==
                                                        true) {
                                                      checkBoxValue1 = false;
                                                    }
                                                    for (int i = 0;
                                                        i <=
                                                            (Constants
                                                                    .additionalMember
                                                                    .length) -
                                                                1;
                                                        i++) {
                                                      if (Constants
                                                              .additionalMember[
                                                                  i]
                                                              .relationship ==
                                                          "Partner") {
                                                        Constants.partnerName =
                                                            "${Constants.additionalMember[i].title} ${Constants.additionalMember[i].name} ${Constants.additionalMember[i].surname}";
                                                        Constants.partnerCover =
                                                            "${Constants.currentleadAvailable?.policies[0].quote.partnerFuneralSumAssured}";
                                                        Constants
                                                                .partnerPremium =
                                                            "${Constants.currentleadAvailable?.policies[0].quote.partnerPremium}";
                                                        Constants.partnerDob =
                                                            "${Constants.additionalMember[i].dob}";
                                                        setState(() {});
                                                      } else {
                                                        print(
                                                            'dololo....${Constants.additionalMember[i].relationship == "Partner"}  ${Constants.additionalMember[i].relationship}');
                                                      }
                                                    }
                                                  });
                                                }),
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Text(
                                          'Partner Covered?',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'YuGothic',
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 0),
                              checkBoxValue2 == false
                                  ? Container()
                                  : Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Date Of Birth ',
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
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                              .withOpacity(
                                                                  0.55)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              360),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: 48,
                                                          width: 48,
                                                          //padding: EdgeInsets.only(left: 8),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          360),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          360)),
                                                              border: Border(
                                                                  right: BorderSide(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.55)))),
                                                          child: Center(
                                                            child: Icon(
                                                              CupertinoIcons
                                                                  .calendar,
                                                              size: 24,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 12.0),
                                                            child: Text(
                                                              (() {
                                                                try {
                                                                  // Get the current reference for the member
                                                                  final currentReference = Constants
                                                                      .currentleadAvailable!
                                                                      .policies[
                                                                          current_member_index]
                                                                      .reference;

                                                                  // Find the policy pair matching the current reference
                                                                  final policyPair =
                                                                      policiesSelectedPartners
                                                                          .firstWhere(
                                                                    (pair) => pair
                                                                        .containsKey(
                                                                            currentReference),
                                                                    orElse:
                                                                        () =>
                                                                            {},
                                                                  );

                                                                  // Retrieve the AdditionalMember from the policy pair
                                                                  final additionalMember =
                                                                      policyPair[
                                                                              currentReference]
                                                                          as AdditionalMember?;

                                                                  // Safely access the `cover` property
                                                                  return Constants
                                                                          .formatter
                                                                          .format(DateTime.parse(additionalMember?.dob ??
                                                                              ""))
                                                                          .toString() ??
                                                                      "Choose a partner";
                                                                } catch (e) {
                                                                  // Return a default message if something goes wrong
                                                                  return "Choose a partner";
                                                                }
                                                              })(),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'YuGothic',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black,
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
                                                                borderRadius: BorderRadius.only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            360),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            360)),
                                                                color: Constants
                                                                    .ftaColorLight,
                                                                border: Border(
                                                                    right: BorderSide(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.55)))),
                                                            child: Center(
                                                              child: Icon(
                                                                Iconsax
                                                                    .filter_edit,
                                                                size: 24,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            setState(() {});
                                                            showDoubleTapDialog4(
                                                                context,
                                                                current_member_index);
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
                                    ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          checkBoxValue2 == false
                              ? Container()
                              : Container(
                                  height: 1,
                                  color: Colors.grey.withOpacity(0.55)),
                          SizedBox(
                            height: 24,
                          ),
                          checkBoxValue2 == false
                              ? Container()
                              : policiesSelectedPartners.isEmpty
                                  ? Text("")
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'NAME',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'YuGothic',
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              // ───────────────────────────────────────────────────────────────────
                                              //  NAME (TITLE + NAME + SURNAME)
                                              // ───────────────────────────────────────────────────────────────────
                                              Text(
                                                (() {
                                                  try {
                                                    // 1) Current reference
                                                    final currentReference = Constants
                                                        .currentleadAvailable!
                                                        .policies[
                                                            current_member_index]
                                                        .reference;

                                                    // 2) Filter the list for policy pairs containing currentReference
                                                    final filteredList =
                                                        policiesSelectedPartners
                                                            .where((policyPair) =>
                                                                policyPair
                                                                    .containsKey(
                                                                        currentReference))
                                                            .toList();

                                                    // If there's nothing in filteredList, fallback
                                                    if (filteredList.isEmpty) {
                                                      return "No partner";
                                                    }

                                                    // 3) Extract the 'title', 'name', 'surname' values
                                                    //    Convert to a List, then safely pick .last if not empty

                                                    // Titles
                                                    final titleList = filteredList
                                                        .map((policyPair) =>
                                                            policyPair[
                                                                    currentReference]
                                                                ?.title ??
                                                            "")
                                                        .toList();

                                                    final partnerTitle =
                                                        titleList.isNotEmpty
                                                            ? titleList.last
                                                            : "No partner";

                                                    // Names
                                                    final nameList = filteredList
                                                        .map((policyPair) =>
                                                            policyPair[
                                                                    currentReference]
                                                                ?.name ??
                                                            "")
                                                        .toList();

                                                    final partnerName =
                                                        nameList.isNotEmpty
                                                            ? nameList.last
                                                            : "No partner";

                                                    // Surnames
                                                    final surnameList = filteredList
                                                        .map((policyPair) =>
                                                            policyPair[
                                                                    currentReference]
                                                                ?.surname ??
                                                            "")
                                                        .toList();

                                                    final partnerSurname =
                                                        surnameList.isNotEmpty
                                                            ? surnameList.last
                                                            : "No partner";

                                                    // Concatenate
                                                    return "$partnerTitle $partnerName $partnerSurname"
                                                        .trim();
                                                  } catch (e) {
                                                    return "No partner";
                                                  }
                                                })(),
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'YuGothic',
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 32),

                                        // ─────────────────────────────────────────────────────────────────────────
                                        //  COVER AMOUNT
                                        // ─────────────────────────────────────────────────────────────────────────
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'COVER AMOUNT',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'YuGothic',
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                (() {
                                                  try {
                                                    // Current policy reference
                                                    final currentReference = Constants
                                                        .currentleadAvailable!
                                                        .policies[
                                                            current_member_index]
                                                        .reference;

                                                    // Find the corresponding Member
                                                    final members = Constants
                                                        .currentleadAvailable!
                                                        .policies[
                                                            current_member_index]
                                                        .members;

                                                    // If 'members' is a List<Member>, do this:
                                                    final m2 =
                                                        members.firstWhere(
                                                      (mem) =>
                                                          mem["type"] ==
                                                          "partner",
                                                      orElse: () => null,
                                                    );

                                                    if (m2 == null) {
                                                      return "R0.00";
                                                    }

                                                    // Return the cover as fixed decimal
                                                    return "R" +
                                                            (m2["cover"] ?? 0)
                                                                ?.toStringAsFixed(
                                                                    2) ??
                                                        "R0.00";
                                                  } catch (e) {
                                                    if (kDebugMode) {
                                                      print(
                                                          "sasjhjas ${e.toString()}");
                                                    }
                                                    return "R0.00";
                                                  }
                                                })(),
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'YuGothic',
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              /* Text(
                                                (() {
                                                  try {
                                                    // Current policy reference
                                                    final currentReference = Constants
                                                        .currentleadAvailable!
                                                        .policies[
                                                            current_member_index]
                                                        .reference;

                                                    // Filter for pairs containing currentReference
                                                    final filteredList =
                                                        policiesSelectedPartners
                                                            .where((policyPair) =>
                                                                policyPair
                                                                    .containsKey(
                                                                        currentReference))
                                                            .toList();

                                                    if (filteredList.isEmpty) {
                                                      return "No Cover";
                                                    }

                                                    // AdditionalMember from the last matched map
                                                    final additionalMember =
                                                        filteredList.last[
                                                                currentReference]
                                                            as AdditionalMember?;

                                                    if (additionalMember ==
                                                        null) {
                                                      return "No Cover";
                                                    }

                                                    // Find the corresponding Member
                                                    final members = Constants
                                                        .currentleadAvailable!
                                                        .policies[
                                                            current_member_index]
                                                        .members;

                                                    // If 'members' is a List<Member>, do this:
                                                    final m2 =
                                                        members.firstWhere(
                                                      (mem) =>
                                                          mem.additional_member_id ==
                                                          additionalMember
                                                              .autoNumber,
                                                      orElse: () => null,
                                                    );

                                                    if (m2 == null) {
                                                      return "No Cover";
                                                    }

                                                    // Return the cover as fixed decimal
                                                    return m2.cover
                                                            ?.toStringAsFixed(
                                                                2) ??
                                                        "No Cover";
                                                  } catch (e) {
                                                    return "No Cover";
                                                  }
                                                })(),
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'YuGothic',
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),*/
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 32),

                                        // ─────────────────────────────────────────────────────────────────────────
                                        //  PREMIUM
                                        // ─────────────────────────────────────────────────────────────────────────
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'PREMIUM',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'YuGothic',
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                (() {
                                                  try {
                                                    // Current policy reference
                                                    final currentReference = Constants
                                                        .currentleadAvailable!
                                                        .policies[
                                                            current_member_index]
                                                        .reference;

                                                    // Find the corresponding Member
                                                    final members = Constants
                                                        .currentleadAvailable!
                                                        .policies[
                                                            current_member_index]
                                                        .members;

                                                    // If 'members' is a List<Member>, do this:
                                                    final m2 =
                                                        members.firstWhere(
                                                      (mem) =>
                                                          mem["type"] ==
                                                          "partner",
                                                      orElse: () => null,
                                                    );

                                                    if (m2 == null) {
                                                      return "R0.00";
                                                    }

                                                    // Return the cover as fixed decimal
                                                    return "R" +
                                                            (m2["premium"] ?? 0)
                                                                ?.toStringAsFixed(
                                                                    2) ??
                                                        "R0.00";
                                                  } catch (e) {
                                                    print(
                                                        "sasjhjas ${e.toString()}");
                                                    return "R0.00";
                                                  }
                                                })(),
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'YuGothic',
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                          SizedBox(
                            height: 24,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        width: 900,
                        //height: 200,
                        child: GridView.builder(
                            itemCount: Constants.leadAvailable.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    //childAspectRatio: 16/1
                                    mainAxisExtent: 120,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15),
                            itemBuilder: (context, i) {
                              Quote quote = Constants
                                  .currentleadAvailable!.policies[0].quote;
                              return InkWell(
                                child: Card(
                                  elevation: card_color_index1 == i ? 30 : 0,
                                  surfaceTintColor: Colors.white,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 45, //#00a65a
                                        //width: 350,
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8)),
                                          color: card_color_index1 == i
                                              ? Constants.ctaColorLight
                                              : Color(0XFF00a65a),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                child: Tooltip(
                                              margin: EdgeInsets.all(8),
                                              padding: EdgeInsets.all(12),
                                              message: quote.product,
                                              decoration: BoxDecoration(
                                                  //border: Border.all(width: 1.2, color: Color(0XFFff6a00)),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.black),
                                              child: Text(
                                                "${Constants.currentleadAvailable!.leadObject.title} ${Constants.currentleadAvailable!.leadObject.firstName} ${Constants.currentleadAvailable!.leadObject.lastName}",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'YuGothic',
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 66,
                                        //width: 350,
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        decoration: BoxDecoration(
                                          border: Border(
                                              left: BorderSide(
                                                  color:
                                                      Constants.ftaColorLight),
                                              right: BorderSide(
                                                  color:
                                                      Constants.ftaColorLight),
                                              bottom: BorderSide(
                                                  color:
                                                      Constants.ftaColorLight)),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(8),
                                              bottomRight: Radius.circular(8)),
                                          //color: Colors.grey
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              Constants
                                                  .currentleadAvailable!
                                                  .policies[0]
                                                  .quote
                                                  .totalPremium
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 14.5,
                                                  fontFamily: 'YuGothic',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Container(
                                              height: 45,
                                              width: 45,
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(360),
                                                color: card_color_index1 == i
                                                    ? Constants.ftaColorLight
                                                    : Color(0XFF00a65a),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  Constants.leadAvailable.length
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'YuGothic',
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  card_color_index1 = i;
                                  setState(() {});
                                },
                              );
                            }),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                          height: 1, color: Colors.grey.withOpacity(0.35)),
                      SizedBox(
                        height: 24,
                      ),
                      //  SelectableText(policiesSelectedChildren.toString()),
                      buildChildrenList(),
                      SizedBox(
                        height: 24,
                      ),
                      Center(
                        child: InkWell(
                          child: Container(
                            height: 45,
                            width: 160,
                            padding: EdgeInsets.only(left: 16, right: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Constants.ftaColorLight,
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
                            showAddChildrenDialog(
                                context, current_member_index);
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        width: 900,
                        //height: 200,
                        child: GridView.builder(
                            itemCount: Constants.leadAvailable.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    //childAspectRatio: 16/1
                                    mainAxisExtent: 120,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15),
                            itemBuilder: (context, i) {
                              return InkWell(
                                child: Card(
                                  elevation: card_color_index1 == i ? 30 : 0,
                                  surfaceTintColor: Colors.white,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 45, //#00a65a
                                        //width: 350,
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8)),
                                          color: card_color_index1 == i
                                              ? Constants.ctaColorLight
                                              : Color(0XFF00a65a),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                child: Tooltip(
                                              margin: EdgeInsets.all(8),
                                              padding: EdgeInsets.all(12),
                                              message: Constants
                                                  .currentleadAvailable!
                                                  .policies[0]
                                                  .quote
                                                  .product,
                                              decoration: BoxDecoration(
                                                  //border: Border.all(width: 1.2, color: Color(0XFFff6a00)),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.black),
                                              child: Text(
                                                "${Constants.currentleadAvailable!.leadObject.title} ${Constants.currentleadAvailable!.leadObject.firstName} ${Constants.currentleadAvailable!.leadObject.lastName}",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'YuGothic',
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 66,
                                        //width: 350,
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        decoration: BoxDecoration(
                                          border: Border(
                                              left: BorderSide(
                                                  color:
                                                      Constants.ctaColorLight),
                                              right: BorderSide(
                                                  color:
                                                      Constants.ctaColorLight),
                                              bottom: BorderSide(
                                                  color:
                                                      Constants.ctaColorLight)),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(8),
                                              bottomRight: Radius.circular(8)),
                                          //color: Colors.grey
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              Constants
                                                  .currentleadAvailable!
                                                  .policies[0]
                                                  .quote
                                                  .totalPremium
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 14.5,
                                                  fontFamily: 'YuGothic',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Container(
                                              height: 45,
                                              width: 45,
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(360),
                                                color: card_color_index1 == i
                                                    ? Constants.ctaColorLight
                                                    : Color(0XFF00a65a),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "1",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'YuGothic',
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  card_color_index1 = i;
                                  setState(() {});
                                },
                              );
                            }),
                      ),
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
                      Center(
                        child: InkWell(
                          child: Container(
                            height: 45,
                            width: 260,
                            padding: EdgeInsets.only(left: 16, right: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Constants.ftaColorLight,
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
                            showAddExtendedDialog(
                                context, current_member_index);
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        width: 900,
                        //height: 200,
                        child: GridView.builder(
                            itemCount: Constants.leadAvailable.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    //childAspectRatio: 16/1
                                    mainAxisExtent: 120,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15),
                            itemBuilder: (context, i) {
                              return InkWell(
                                child: Card(
                                  elevation: card_color_index1 == i ? 30 : 0,
                                  surfaceTintColor: Colors.white,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 45, //#00a65a
                                        //width: 350,
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8)),
                                          color: card_color_index1 == i
                                              ? Constants.ctaColorLight
                                              : Color(0XFF00a65a),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                child: Tooltip(
                                              margin: EdgeInsets.all(8),
                                              padding: EdgeInsets.all(12),
                                              message: Constants
                                                  .currentleadAvailable!
                                                  .policies[0]
                                                  .quote
                                                  .product,
                                              decoration: BoxDecoration(
                                                  //border: Border.all(width: 1.2, color: Color(0XFFff6a00)),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.black),
                                              child: Text(
                                                "${Constants.currentleadAvailable!.leadObject.title} ${Constants.currentleadAvailable!.leadObject.firstName} ${Constants.currentleadAvailable!.leadObject.lastName}",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'YuGothic',
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 66,
                                        //width: 350,
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        decoration: BoxDecoration(
                                          border: Border(
                                              left: BorderSide(
                                                  color:
                                                      Constants.ctaColorLight),
                                              right: BorderSide(
                                                  color:
                                                      Constants.ctaColorLight),
                                              bottom: BorderSide(
                                                  color:
                                                      Constants.ctaColorLight)),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(8),
                                              bottomRight: Radius.circular(8)),
                                          //color: Colors.grey
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              Constants
                                                  .currentleadAvailable!
                                                  .policies[0]
                                                  .quote
                                                  .totalPremium
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 14.5,
                                                  fontFamily: 'YuGothic',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Container(
                                              height: 45,
                                              width: 45,
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(360),
                                                color: card_color_index1 == i
                                                    ? Constants.ctaColorLight
                                                    : Color(0XFF00a65a),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "1",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'YuGothic',
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  card_color_index1 = i;
                                  setState(() {});
                                },
                              );
                            }),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                          height: 1, color: Colors.grey.withOpacity(0.35)),
                      SizedBox(
                        height: 24,
                      ),
                      if (policyPremiums.isNotEmpty)
                        Center(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: policyPremiums[current_member_index]
                                .applicableMRiders
                                .length,
                            itemBuilder: (context, index) {
                              final rider = policyPremiums[current_member_index]
                                  .applicableMRiders[index];
                              final isSelected =
                                  _selectedRiderIds[current_member_index]
                                      .contains(rider.id);

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: RiderCard(
                                  rider: rider,
                                  isSelected: isSelected,
                                  onCheck: () {
                                    setState(() {
                                      // Toggle selection
                                      if (isSelected) {
                                        _selectedRiderIds[current_member_index]
                                            .remove(rider.id);
                                      } else {
                                        _selectedRiderIds[current_member_index]
                                            .add(rider.id);
                                      }
                                    });
                                  },
                                  onAddBenefit: () {
                                    // Example: show a dialog, or navigate somewhere
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Added benefit for ${rider.riderName}!',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        )
                    ],
                  )
                ]),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  List<QuoteRates> allRates = [];
  List<String> distinctProducts = [];
  List<String> distinctProdTypes = [];
  List<double> distinctCoverAmounts = [];

  String? _selectedProdType;
  double? _selectedCoverAmount;

  void onProductChanged(String? newValue) {
    setState(() {
      policiesSelectedProducts[current_member_index] = newValue!;
      _selectedProdType = null;
      _selectedCoverAmount = null;

      // Filter allRates by the chosen product
      final productFilteredRates = policyPremiums[current_member_index]
          .allMainRates
          .where((r) => r.product == newValue);
      print("productFilteredRates5 $productFilteredRates");

      // Extract distinct product types from that subset
      distinctProdTypes =
          productFilteredRates.map((r) => r.prodType).toSet().toList()..sort();
      print("distinctProdTypes5 $distinctProdTypes");

      // Clear any old amounts
      distinctCoverAmounts = [];
      if (distinctProdTypes.isNotEmpty)
        _selectedProdType = distinctProdTypes.first;
      setState(() {});
    });
  }

  void onProdTypeChanged(String? newValue) {
    setState(() {
      policiesSelectedProdTypes[current_member_index] = newValue!;
      _selectedCoverAmount = null;

      // Filter allRates by product + prodType
      final prodTypeFilteredRates = policyPremiums[current_member_index]
          .allMainRates
          .where((r) =>
              r.product == policiesSelectedProducts[current_member_index] &&
              r.prodType == _selectedProdType);

      // Extract distinct amounts
      distinctCoverAmounts =
          prodTypeFilteredRates.map((r) => r.amount).toSet().toList()..sort();
      if (distinctCoverAmounts.isNotEmpty)
        _selectedCoverAmount = distinctCoverAmounts.first;
    });
  }

  void onCoverAmountChanged(double? newValue) {
    setState(() {
      List<QuoteRates> prodTypeFilteredRates =
          policyPremiums[current_member_index]
              .allMainRates
              .where((r) =>
                  r.product == policiesSelectedProducts[current_member_index] &&
                  r.prodType == policiesSelectedProdTypes[current_member_index])
              .toList();

      final Set<double> allAmounts = {};

      for (var r in prodTypeFilteredRates) {
        allAmounts.add(r.amount);
      }

      // Sort them
      final sortedAmounts = allAmounts.toList()..sort();

      // Save to policiescoverAmounts
      policiescoverAmounts[current_member_index] = sortedAmounts;
      policiesSelectedCoverAmounts[current_member_index] = newValue!;
      _selectedCoverAmount = newValue;
      calculatePolicyPremiumCal();
      // Possibly do something next, e.g. showing the final premium
    });
  }

  void showDoubleTapDialog(BuildContext context) {
    // Extract distinct product names from allRates
    distinctProducts = policyPremiums[current_member_index]
        .allMainRates
        .map((r) => r.product)
        .toSet()
        .toList();
    print("distinctProducts $distinctProducts");
    distinctProducts.sort(); // optional, to keep them alphabetical
    //coverAmounts = [];
    showDialog(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: Colors.transparent, // Set to transparent
              elevation: 0.0,
              child: MovingLineDialog(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 500,
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
                        SizedBox(height: 32),
                        Center(
                          child: Text(
                            "Change Product Details",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                              color: Constants.ftaColorLight,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Center(
                          child: Text(
                            "Please select a product below to contine ",
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
                                                      color: Colors.black),
                                                ),
                                                isExpanded: true,
                                                value: policiesSelectedProducts[
                                                    current_member_index],
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
                                                  setState2(() =>
                                                      onProductChanged(
                                                          newValue.toString()));
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
                                                value: _selectedProdType,
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
                                                value: _selectedCoverAmount,
                                                items: distinctCoverAmounts
                                                    .map((double coverAmount) =>
                                                        DropdownMenuItem<
                                                            double>(
                                                          value: coverAmount,
                                                          child: Text(
                                                            coverAmount
                                                                .toString(),
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
                                                  setState(() =>
                                                      onCoverAmountChanged(
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
                        SizedBox(height: 32),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
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
                                /*  setState(() {
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
                              );*/
                              },
                            ),
                            SizedBox(width: 12),
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
                                    "Change",
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
                                selectedProductRate =
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
                                        .first;
                                full_product_id =
                                    selectedProductRate!.fullProductId;
                                selectedProductString =
                                    policiesSelectedProducts[
                                            current_member_index]! +
                                        " " +
                                        policiesSelectedProdTypes[
                                            current_member_index]!;
                                setState(() {});

                                print("fggffggf $full_product_id");
                                showDoubleTapDialog2(context);
                              },
                            ),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  void showDoubleTapDialog2(BuildContext context) {
    List<String> productList = [];
    showDialog(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: Colors.transparent, // Set to transparent
              elevation: 0.0,
              child: MovingLineDialog(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(16),
                  constraints: BoxConstraints(maxWidth: 500, maxHeight: 630),
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background color here
                    borderRadius: BorderRadius.circular(36),
                  ),
                  child: StatefulBuilder(
                    builder: (context, setState) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 32),
                        Center(
                          child: Text(
                            "Select the Main Insured",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                              color: Constants.ftaColorLight,
                            ),
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
                          ),
                        ),
                        SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: Constants
                              .currentleadAvailable!.additionalMembers.length,
                          itemBuilder: (context, index) {
                            AdditionalMember member = Constants
                                .currentleadAvailable!.additionalMembers[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Constants.ftaColorLight.withOpacity(0.9),
                                      Constants.ftaColorLight
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
                                      radius: 25,
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
                                          // Date of Birth
                                          Text(
                                            'Date of Birth: ${(DateFormat('EEE, dd MMM yyyy').format(DateTime.parse(member.dob)).toString())}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 4.0),

                                          // Member Name
                                          Text(
                                            member.title +
                                                " " +
                                                member.name +
                                                " " +
                                                member.surname,
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

                                    // Edit Button
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  void showDoubleTapDialog3(BuildContext context) {
    List<String> productList = [];
    showDialog(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: Colors.transparent, // Set to transparent
              elevation: 0.0,
              child: MovingLineDialog(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(16),
                  constraints: BoxConstraints(maxWidth: 500, maxHeight: 630),
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background color here
                    borderRadius: BorderRadius.circular(36),
                  ),
                  child: StatefulBuilder(
                    builder: (context, setState1) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 32),
                        Center(
                          child: Text(
                            "Select the Main Insured",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                              color: Constants.ftaColorLight,
                            ),
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
                          ),
                        ),
                        SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: Constants
                              .currentleadAvailable!.additionalMembers.length,
                          itemBuilder: (context, index) {
                            AdditionalMember member = Constants
                                .currentleadAvailable!.additionalMembers[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                policiesSelectedMainInsuredDOBs[
                                    current_member_index] = member.dob;
                                setState(() {});
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Constants.ftaColorLight.withOpacity(0.9),
                                      Constants.ftaColorLight
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
                                      radius: 25,
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
                                          // Date of Birth
                                          Text(
                                            'Date of Birth: ${(DateFormat('EEE, dd MMM yyyy').format(DateTime.parse(member.dob)).toString())}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 4.0),

                                          // Member Name
                                          Text(
                                            member.title +
                                                " " +
                                                member.name +
                                                " " +
                                                member.surname,
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

                                    // Edit Button
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  // Some global or higher-level variable

  void showDoubleTapDialog4(BuildContext context, int current_member_index) {
    List<AdditionalMember> allPartnersList = [];

    // Filter any AdditionalMember > 18 years old
    if (Constants.currentleadAvailable != null) {
      allPartnersList = Constants.currentleadAvailable!.additionalMembers
          .where((m) => calculateAge(DateTime.parse(m.dob)) > 18)
          .toList();
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
                        "Select A Partner",
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
                        "Click on a member below to select them as partner",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'YuGothic',
                          color: Colors.grey,
                        ),
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
                              0,
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
                            policiesSelectedPartners[current_member_index] = {
                              currentReference: member
                            };

                            // Recalculate premium
                            calculatePolicyPremiumCal();

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
                                  radius: 25,
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
                                        'Date of Birth: ${DateFormat('EEE, dd MMM yyyy').format(DateTime.parse(member.dob))}',
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showAddChildrenDialog(BuildContext context, int current_member_index) {
    List<AdditionalMember> allChildrenList = [];

    // Filter any AdditionalMember > 18 years old
    if (Constants.currentleadAvailable != null) {
      allChildrenList = Constants.currentleadAvailable!.additionalMembers
          .where((m) => calculateAge(DateTime.parse(m.dob)) < 18)
          .toList();

      List<int> childrenAutoNumbers = [];
      childrenAutoNumbers = Constants.currentleadAvailable!.additionalMembers
          .where((m) => calculateAge(DateTime.parse(m.dob)) < 18)
          .toList()
          .map((m) => m.autoNumber)
          .toList();
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
                        "Select A Child",
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
                      ),
                    ),
                    const SizedBox(height: 16),

                    // -------------------- List of potential children --------------------
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: allChildrenList.length,
                      itemBuilder: (context, index) {
                        final member = allChildrenList[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();

                            // 1) Get the current policy + reference
                            final policy = Constants.currentleadAvailable!
                                .policies[current_member_index];
                            final String? currentReference = policy.reference;

                            // 2) Create a new policy child
                            final newPolicyMember = Member(
                              null,
                              // cId
                              null,
                              // pId
                              null,
                              // polId
                              currentReference,
                              // reference
                              member.autoNumber,
                              // additional_member_id
                              null,
                              // mainMemberDOB
                              0,
                              // premium
                              "child",
                              // type
                              0,
                              // percentage
                              null,
                              // coverMembersCol
                              "child",
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

                            // 3) Remove any existing 'child' members from the policy
                            final List<dynamic> membersList =
                                policy.members ?? [];
                            final List<dynamic> membersToRemove = [];

                            for (var m in membersList) {
                              final relationship = (m is Map<String, dynamic>)
                                  ? (m["type"] ?? "").toString().toLowerCase()
                                  : (m is Member)
                                      ? (m.type ?? "").toLowerCase()
                                      : "unknown";

                              if (relationship == "child") {
                                membersToRemove.add(m);
                              }
                            }

                            for (var m in membersToRemove) {
                              membersList.remove(m);
                            }

                            // 4) Add the new child to the policy
                            membersList.add(newPolicyMember.toJson());
                            policy.members = membersList;

                            // 5) Remove this child from allChildrenList
                            setState(() {
                              allChildrenList.removeAt(index);
                            });

                            // 6) Update `policiesSelectedChildren` if desired
                            //    e.g. remove the old entry if present, then add the new one
                            int childIndex =
                                policiesSelectedChildren.indexWhere(
                              (map) => map['autoNumber'] == member.autoNumber,
                            );
                            if (childIndex != -1) {
                              // remove the old record
                              policiesSelectedChildren.removeAt(childIndex);
                            }
                            // add the new child's JSON
                            policiesSelectedChildren
                                .add(newPolicyMember.toJson());

                            // 7) Recalculate premium
                            calculatePolicyPremiumCal();

                            // 8) Rebuild UI
                            setState(() {});
                          },

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
                                // Profile Avatar
                                CircleAvatar(
                                  radius: 25,
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
                                        'Date of Birth: '
                                        '${DateFormat('EEE, dd MMM yyyy').format(DateTime.parse(member.dob))}',
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showAddExtendedDialog(BuildContext context, int current_member_index) {
    List<AdditionalMember> allChildrenList = [];

    // Filter any AdditionalMember > 18 years old
    if (Constants.currentleadAvailable != null) {
      allChildrenList = Constants.currentleadAvailable!.additionalMembers
          .where((m) => calculateAge(DateTime.parse(m.dob)) > 18)
          .toList();

      List<int> childrenAutoNumbers = [];
      childrenAutoNumbers = Constants.currentleadAvailable!.additionalMembers
          .where((m) => calculateAge(DateTime.parse(m.dob)) > 18)
          .toList()
          .map((m) => m.autoNumber)
          .toList();
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
                        "Add An Extended Member",
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
                        "Click on a member below to select them as a extended member",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'YuGothic',
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // -------------------- List of potential children --------------------
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: allChildrenList.length,
                      itemBuilder: (context, index) {
                        final member = allChildrenList[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();

                            // 1) Get the current policy + reference
                            final policy = Constants.currentleadAvailable!
                                .policies[current_member_index];
                            final String? currentReference = policy.reference;

                            // 2) Create a new policy child
                            final newPolicyMember = Member(
                              null,
                              // cId
                              null,
                              // pId
                              null,
                              // polId
                              currentReference,
                              // reference
                              member.autoNumber,
                              // additional_member_id
                              null,
                              // mainMemberDOB
                              0,
                              // premium
                              "extended",
                              // type
                              0,
                              // percentage
                              null,
                              // coverMembersCol
                              "extended",
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

                            // 3) Remove any existing 'child' members from the policy
                            final List<dynamic> membersList =
                                policy.members ?? [];
                            final List<dynamic> membersToRemove = [];

                            for (var m in membersList) {
                              final relationship = (m is Map<String, dynamic>)
                                  ? (m["type"] ?? "").toString().toLowerCase()
                                  : (m is Member)
                                      ? (m.type ?? "").toLowerCase()
                                      : "unknown";

                              if (relationship == "extended") {
                                membersToRemove.add(m);
                              }
                            }

                            for (var m in membersToRemove) {
                              membersList.remove(m);
                            }

                            // 4) Add the new child to the policy
                            membersList.add(newPolicyMember.toJson());
                            policy.members = membersList;

                            // 5) Remove this child from allChildrenList
                            setState(() {
                              allChildrenList.removeAt(index);
                            });

                            // 6) Update `policiesSelectedChildren` if desired
                            //    e.g. remove the old entry if present, then add the new one
                            int childIndex =
                                policiesSelectedExtended.indexWhere(
                              (map) => map['autoNumber'] == member.autoNumber,
                            );
                            if (childIndex != -1) {
                              // remove the old record
                              policiesSelectedExtended.removeAt(childIndex);
                            }
                            // add the new child's JSON
                            policiesSelectedExtended
                                .add(newPolicyMember.toJson());

                            // 7) Recalculate premium
                            calculatePolicyPremiumCal();

                            // 8) Rebuild UI
                            setState(() {});
                          },

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
                                // Profile Avatar
                                CircleAvatar(
                                  radius: 25,
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
                                        'Date of Birth: '
                                        '${DateFormat('EEE, dd MMM yyyy').format(DateTime.parse(member.dob))}',
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildChildrenList() {
    // 1) If there are no items, show a fallback message
    if (policiesSelectedChildren.isEmpty) {
      return const Center(
        child: Text(
          "No children available for this policy.",
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    // 2) Otherwise build a list from 'policiesSelectedChildren'
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      // Keeps the grid non-scrollable
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of columns
        crossAxisSpacing: 16.0, // Space between columns
        mainAxisSpacing: 16.0, // Space between rows
        childAspectRatio: 3.2, // Adjusted to work with fixed height
      ),
      itemCount: policiesSelectedChildren.length,
      itemBuilder: (context, index) {
        // Each 'childData' is a Map<String, dynamic>
        final childData = policiesSelectedChildren[index];

        // Safely extract fields from the map
        final additionalMemberId = childData["additionalMemberId"] ?? 0;
        print("sahjssa $additionalMemberId");
        final reference = childData["reference"]?.toString() ?? "";
        final type = childData["type"]?.toString() ?? "child";
        final cover = childData["cover"]?.toString() ?? "0.0";
        AdditionalMember? member = Constants
            .currentleadAvailable!.additionalMembers
            .where((member) => member.autoNumber == additionalMemberId)
            .toList()
            .firstOrNull;
        print("ashashj $member");

        return Container(
          height: 120,
          width: 450,
          child: AdvancedMemberCard(
            id: member!.id,
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
            noOfMembers: 0,
            onSingleTap: () {},
          ),
        );
      },
    );
  }

  Widget buildExtendedList() {
    // 1) If there are no items, show a fallback message
    if (policiesSelectedExtended.isEmpty) {
      return const Center(
        child: Text(
          "No extended members available for this policy.",
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    // 2) Otherwise build a list from 'policiesSelectedChildren'
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      // Keeps the grid non-scrollable
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of columns
        crossAxisSpacing: 16.0, // Space between columns
        mainAxisSpacing: 16.0, // Space between rows
        childAspectRatio: 3.2, // Adjusted to work with fixed height
      ),
      itemCount: policiesSelectedExtended.length,
      itemBuilder: (context, index) {
        // Each 'childData' is a Map<String, dynamic>
        final childData = policiesSelectedExtended[index];

        // Safely extract fields from the map
        final additionalMemberId = childData["additionalMemberId"] ?? 0;
        print("sahjssa0 $additionalMemberId");

        AdditionalMember? member = Constants
            .currentleadAvailable!.additionalMembers
            .where((member) => member.autoNumber == additionalMemberId)
            .toList()
            .firstOrNull;
        print("ashashj $member");

        return Container(
          height: 120,
          width: 450,
          child: AdvancedMemberCard(
            id: member!.id,
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
            noOfMembers: 0,
            onSingleTap: () {},
          ),
        );
      },
    );
  }
}

class BottomBar {
  String bottomStringName;
  String bottomString_id;

  BottomBar(this.bottomStringName, this.bottomString_id);
}

class CalculatePolicyPremiumResponse {
  final int cecClientId;
  final String? reference;
  final String? mainInsuredDob;
  final String? partnerDob;
  final List<String> childrensDobs;
  final List<String> extendedMembersDobs;
  final int? fullProductId;
  final List<MemberPremium> memberPremiums;
  final double? totalPremium;
  final double? joiningFee;
  final List<dynamic> selectedRidersIds;
  final double? selectedRidersTotal;
  final List<dynamic> selectedRidersDetail;
  final double? totalDue;
  final List<Rider> allRiders;
  final List<QuoteRates> allMainRates;
  final List<dynamic> applicableMainRates;
  final List<Rider> applicableMRiders;
  final List<String> errors;

  CalculatePolicyPremiumResponse({
    required this.cecClientId,
    required this.reference,
    this.mainInsuredDob,
    this.partnerDob,
    required this.childrensDobs,
    required this.extendedMembersDobs,
    this.fullProductId,
    required this.memberPremiums,
    this.totalPremium,
    this.joiningFee,
    required this.selectedRidersIds,
    this.selectedRidersTotal,
    required this.selectedRidersDetail,
    this.totalDue,
    required this.allRiders,
    required this.allMainRates,
    required this.applicableMainRates,
    required this.applicableMRiders,
    required this.errors,
  });

  factory CalculatePolicyPremiumResponse.fromJson(Map<String, dynamic> json) {
    return CalculatePolicyPremiumResponse(
      cecClientId: json['cec_client_id'] ?? 0,
      reference: json['reference'] ?? "",
      mainInsuredDob: json['main_insured_dob'],
      partnerDob: json['partner_dob'],
      childrensDobs: (json['childrens_dobs'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      extendedMembersDobs: (json['extended_members_dobs'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      fullProductId: json['full_product_id'],
      memberPremiums: (json['member_premiums'] as List<dynamic>?)
              ?.map((e) => MemberPremium.fromJson(e))
              .toList() ??
          [],
      totalPremium: (json['total_premium'] != null)
          ? (json['total_premium'] as num).toDouble()
          : null,
      joiningFee: (json['joining_fee'] != null)
          ? (json['joining_fee'] as num).toDouble()
          : null,
      selectedRidersIds: json['selected_riders_ids'] ?? [],
      selectedRidersTotal: (json['selected_riders_total'] != null)
          ? (json['selected_riders_total'] as num).toDouble()
          : null,
      selectedRidersDetail: json['selected_riders_detail'] ?? [],
      totalDue: (json['total_due'] != null)
          ? (json['total_due'] as num).toDouble()
          : null,
      allRiders: ((json['all_riders'] ?? []) as List<dynamic>?)
              ?.map((e) => Rider.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      allMainRates: ((json['all_main_rates'] ?? []) as List<dynamic>?)
              ?.map((e) => QuoteRates.fromJson(e))
              .toList() ??
          [],
      applicableMRiders: ((json['applicable_riders'] ?? []) as List<dynamic>?)
              ?.map((e) => Rider.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      applicableMainRates: json['applicable_main_rates'] ?? [],
      errors: List<String>.from(json['errors'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "cec_client_id": cecClientId,
      "reference": reference,
      "main_insured_dob": mainInsuredDob,
      "partner_dob": partnerDob,
      "childrens_dobs": childrensDobs,
      "extended_members_dobs": extendedMembersDobs,
      "full_product_id": fullProductId,
      "member_premiums": memberPremiums.map((mp) => mp.toJson()).toList(),
      "total_premium": totalPremium,
      "joining_fee": joiningFee,
      "selected_riders_ids": selectedRidersIds,
      "selected_riders_total": selectedRidersTotal,
      "selected_riders_detail": selectedRidersDetail,
      "total_due": totalDue,
      "all_riders": allRiders,
      "all_main_rates": allMainRates,
      "applicable_riders": applicableMRiders.map((mp) => mp.toJson()).toList(),
      "applicable_main_rates": applicableMainRates,
    };
  }
}

class Rider {
  final int id;
  final int clientId;
  final String clientName;
  final String linkedProduct;
  final String riderName;
  final String relationship;
  final bool isIndividual;
  final double value;
  final int minAge;
  final int maxAge;
  final double price;
  final double percentage;
  final bool isPercentage;
  final String summary;
  final String timestamp;
  final String lastUpdate;

  Rider({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.linkedProduct,
    required this.riderName,
    required this.relationship,
    required this.isIndividual,
    required this.value,
    required this.minAge,
    required this.maxAge,
    required this.price,
    required this.percentage,
    required this.isPercentage,
    required this.summary,
    required this.timestamp,
    required this.lastUpdate,
  });

  /// Factory constructor to create a Rider object from JSON
  factory Rider.fromJson(Map<String, dynamic> json) {
    return Rider(
      id: json['id'] as int,
      clientId: json['client_id'] as int,
      clientName: json['client_name'] as String,
      linkedProduct: json['linked_product'] as String,
      riderName: json['rider_name'] as String,
      relationship: json['relationship'] as String,
      isIndividual: json['is_individual'] as bool,
      value: (json['value'] as num).toDouble(),
      minAge: json['min_age'] as int,
      maxAge: json['max_age'] as int,
      price: (json['price'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
      isPercentage: json['is_percentage'] as bool,
      summary: json['summary'] as String,
      timestamp: json['timestamp'] as String,
      lastUpdate: json['last_update'] as String,
    );
  }

  /// Method to convert a Rider object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'client_name': clientName,
      'linked_product': linkedProduct,
      'rider_name': riderName,
      'relationship': relationship,
      'is_individual': isIndividual,
      'value': value,
      'min_age': minAge,
      'max_age': maxAge,
      'price': price,
      'percentage': percentage,
      'is_percentage': isPercentage,
      'summary': summary,
      'timestamp': timestamp,
      'last_update': lastUpdate,
    };
  }
}

/// Example sub-model for the `member_premiums` array:
class MemberPremium {
  final String role;
  final int age;
  final int rateId;
  final double premium;
  final double coverAmount;
  final String comment;

  MemberPremium({
    required this.role,
    required this.age,
    required this.rateId,
    required this.premium,
    required this.coverAmount,
    required this.comment,
  });

  factory MemberPremium.fromJson(Map<String, dynamic> json) {
    return MemberPremium(
      role: json['role'] ?? "",
      age: json['age'] ?? 0,
      rateId: json['rate_id'] ?? 0,
      premium:
          json['premium'] == null ? 0.0 : (json['premium'] as num).toDouble(),
      coverAmount: json['cover_amount'] == null
          ? 0.0
          : (json['cover_amount'] as num).toDouble(),
      comment: json['comment'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "role": role,
      "age": age,
      "rate_id": rateId,
      "premium": premium,
      "cover_amount": coverAmount,
      "comment": comment,
    };
  }
}

class AdvancedMemberCard extends StatefulWidget {
  final String dateOfBirth;
  final String id;
  final String name;
  final String title;
  final String relationship;
  final String gender;
  final String dob;
  final String surname;
  final String contact;
  final String sourceOfIncome;
  final String sourceOfWealth;
  final int autoNumber;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onSingleTap;
  final int? noOfMembers;
  final bool? isSelected;

  const AdvancedMemberCard({
    Key? key,
    required this.dateOfBirth,
    required this.id,
    required this.name,
    required this.title,
    required this.relationship,
    required this.gender,
    required this.dob,
    required this.surname,
    required this.contact,
    required this.sourceOfIncome,
    required this.sourceOfWealth,
    required this.autoNumber,
    this.onDoubleTap,
    this.onSingleTap,
    this.noOfMembers,
    this.isSelected,
  }) : super(key: key);

  @override
  State<AdvancedMemberCard> createState() => _AdvancedMemberCardState();
}

class _AdvancedMemberCardState extends State<AdvancedMemberCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onDoubleTap: widget.onDoubleTap,
        onTap: widget.onSingleTap,
        child: AnimatedScale(
            scale: isHovered ? 1.02 : 1.0, // Smooth scaling on hover
            duration: const Duration(milliseconds: 200),
            child: CustomCard(
              elevation: 8,
              color: Colors.white,
              shape: RoundedRectangleBorder(),
              boderRadius: null,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: widget.isSelected == true
                            ? Constants.ftaColorLight.withOpacity(0.95)
                            : Colors.transparent)),
                margin:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                padding: const EdgeInsets.all(0.0),
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
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                                color: widget.isSelected == true
                                    ? Constants.ftaColorLight.withOpacity(0.95)
                                    : Constants.ftaColorLight
                                        .withOpacity(0.15)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundColor: widget.isSelected == true
                                      ? Colors.grey.withOpacity(0.65)
                                      : Constants.ftaColorLight,
                                  child: Icon(
                                    widget.gender.toLowerCase() == "female"
                                        ? Icons.female
                                        : Icons.male,
                                    size: 27,
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
                            // Date of Birth
                            Text(
                              'Date of Birth: ${(DateFormat('EEE, dd MMM yyyy').format(DateTime.parse(widget.dob)).toString())}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'YuGothic',
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 8.0),

                            // Member Name
                            Text(
                              widget.title +
                                  " " +
                                  widget.name +
                                  " " +
                                  widget.surname,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.2,
                              ),
                            ),

                            const SizedBox(height: 8.0),

                            // Relationship
                            Row(
                              children: [
                                const Icon(
                                  Icons.people_alt,
                                  color: Colors.black,
                                  size: 16,
                                ),
                                const SizedBox(width: 4.0),
                                Text(
                                  '${widget.relationship}',
                                  style: const TextStyle(
                                    fontSize: 14,
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

                    // Edit Button
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, bottom: 16, right: 16),
                      child: Column(
                        children: [
                          InkWell(
                            child: Container(
                              padding: const EdgeInsets.all(0.0),
                              decoration: BoxDecoration(
                                color:
                                    Constants.ftaColorLight.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(360.0),
                                border: Border.all(
                                    color: Constants.ftaColorLight, width: 1.5),
                              ),
                              child:
                                  //add a edit and delete icon
                                  Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Container(
                                    width: 30,
                                    height: 30,
                                    child: Center(
                                        child: Text((widget.noOfMembers ?? 0)
                                            .toString()))),
                              )

                              /*Icon(
                                            Icons.edit,
                                            color: Colors.orangeAccent,
                                            size: 20,
                                          )*/
                              ,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

class CoverOptionsAndMembersDialog extends StatefulWidget {
  const CoverOptionsAndMembersDialog({super.key});

  @override
  State<CoverOptionsAndMembersDialog> createState() =>
      _CoverOptionsAndMembersDialogState();
}

class _CoverOptionsAndMembersDialogState
    extends State<CoverOptionsAndMembersDialog> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class QuoteRates {
  final int id;
  final int fullProductId;
  final String product;
  final String prodType;
  final double amount;
  final double premium;
  final int minAge;
  final int maxAge;
  final int clientId;
  final int spouse;
  final int children;
  final int parents;
  final int extended;
  final int parentsAndExtended;
  final int extraMembersAllowed;
  final int maximumMembers;
  final String uwRatesRef;
  final DateTime timestamp;
  final int createdBy;
  final DateTime lastUpdate;
  final int updatedBy;
  final bool isActive;

  QuoteRates({
    required this.id,
    required this.fullProductId,
    required this.product,
    required this.prodType,
    required this.amount,
    required this.premium,
    required this.minAge,
    required this.maxAge,
    required this.clientId,
    required this.spouse,
    required this.children,
    required this.parents,
    required this.extended,
    required this.parentsAndExtended,
    required this.extraMembersAllowed,
    required this.maximumMembers,
    required this.uwRatesRef,
    required this.timestamp,
    required this.createdBy,
    required this.lastUpdate,
    required this.updatedBy,
    required this.isActive,
  });

  /// Factory constructor to create a MainRate object from JSON
  factory QuoteRates.fromJson(Map<String, dynamic> json) {
    return QuoteRates(
      id: json['id'] ?? 0,
      fullProductId: json['fullproduct_id'] ?? 0,
      product: json['product'],
      prodType: json['prod_type'],
      amount: (json['amount'] as num).toDouble(),
      premium: (json['premium'] as num).toDouble(),
      minAge: json['min_age'],
      maxAge: json['max_age'],
      clientId: json['client_id'],
      spouse: json['spouse'],
      children: json['children'],
      parents: json['parents'],
      extended: json['extended'],
      parentsAndExtended: json['parents_and_extended'],
      extraMembersAllowed: json['extra_members_allowed'],
      maximumMembers: json['maximum_members'],
      uwRatesRef: json['uw_rates_ref'] ?? "",
      timestamp: DateTime.parse(json['timestamp']),
      createdBy: json['created_by'],
      lastUpdate: DateTime.parse(json['last_update']),
      updatedBy: json['updated_by'],
      isActive: json['is_active'],
    );
  }

  /// Convert the MainRate object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullproduct_id': fullProductId,
      'product': product,
      'prod_type': prodType,
      'amount': amount,
      'premium': premium,
      'min_age': minAge,
      'max_age': maxAge,
      'client_id': clientId,
      'spouse': spouse,
      'children': children,
      'parents': parents,
      'extended': extended,
      'parents_and_extended': parentsAndExtended,
      'extra_members_allowed': extraMembersAllowed,
      'maximum_members': maximumMembers,
      'uw_rates_ref': uwRatesRef,
      'timestamp': timestamp.toIso8601String(),
      'created_by': createdBy,
      'last_update': lastUpdate.toIso8601String(),
      'updated_by': updatedBy,
      'is_active': isActive,
    };
  }
}

/// Helper function to parse a list of MainRates from JSON
List<QuoteRates> parseMainRates(List<dynamic> jsonList) {
  return jsonList.map((json) => QuoteRates.fromJson(json)).toList();
}

/// Helper function to convert a list of MainRates to JSON
List<Map<String, dynamic>> mainRatesToJson(List<QuoteRates> rates) {
  return rates.map((rate) => rate.toJson()).toList();
}

class InsurancePlan {
  int? cecClientId;
  String? mainInsuredDob;
  String? reference;
  String? partnerDob;
  List<String>? childrensDobs;
  List<String>? extendedMembersDobs;
  List<int>? selectedRiders;
  String? product;
  String? prodType;
  String? fullProductId;
  double? coverAmount;

  InsurancePlan({
    this.cecClientId,
    this.reference,
    this.mainInsuredDob,
    this.partnerDob,
    this.childrensDobs,
    this.extendedMembersDobs,
    this.selectedRiders,
    this.product,
    this.prodType,
    this.fullProductId,
    this.coverAmount,
  });

  /// Factory method to create an InsurancePlan object from JSON
  factory InsurancePlan.fromJson(Map<String, dynamic> json) {
    return InsurancePlan(
      cecClientId: json['cec_client_id'],
      reference: json['reference'],
      mainInsuredDob: json['main_insured_dob'],
      partnerDob: json['partner_dob'],
      childrensDobs: List<String>.from(json['childrens_dobs'] ?? []),
      extendedMembersDobs:
          List<String>.from(json['extended_members_dobs'] ?? []),
      selectedRiders: List<int>.from(json['selected_riders'] ?? []),
      product: json['product'],
      prodType: json['prod_type'],
      fullProductId: json['full_product_id'],
      coverAmount: (json['cover_amount'] != null)
          ? json['cover_amount'].toDouble()
          : null,
    );
  }

  /// Method to convert InsurancePlan object to JSON
  Map<String, dynamic> toJson() {
    return {
      'cec_client_id': cecClientId,
      'reference': reference,
      'main_insured_dob': mainInsuredDob,
      'partner_dob': partnerDob,
      'childrens_dobs': childrensDobs ?? [],
      'extended_members_dobs': extendedMembersDobs ?? [],
      'selected_riders': selectedRiders ?? [],
      'product': product,
      'prod_type': prodType,
      'full_product_id': fullProductId,
      'cover_amount': coverAmount,
    };
  }
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
        onTap: widget.onCheck, // Single tap => "check" or select
        child: AnimatedScale(
          scale: isHovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: widget.isSelected
                    ? Colors.teal.withOpacity(0.7)
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: widget.isSelected
                    ? Colors.teal.withOpacity(0.05)
                    : Colors.white,
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Circle avatar or icon for the rider
                  CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        widget.isSelected ? Colors.teal : Colors.grey.shade300,
                    child: const Icon(
                      Icons.health_and_safety,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Rider details in a column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Price: R${widget.rider.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          'Age Range: ${widget.rider.minAge} - ${widget.rider.maxAge}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // "Add Benefit" button on the far right
                  TextButton.icon(
                    onPressed: widget.onAddBenefit,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Benefit'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.teal,
                    ),
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
