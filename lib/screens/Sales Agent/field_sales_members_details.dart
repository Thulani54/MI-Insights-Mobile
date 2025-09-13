import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mi_insights/screens/Sales%20Agent/universal_premium_calculator.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:screenshot/screenshot.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/Constants.dart';

import '../../customwidgets/CustomCard.dart';
import '../../customwidgets/custom_input.dart';
import '../../models/BottomBar.dart';
import '../../models/Parlour.dart';
import '../../models/map_class.dart';

import '../../services/MyNoyifier.dart';
import '../../services/sales_service.dart';
import 'field_call_lead_dialog.dart';
import 'field_premium_calculator.dart' as ff;
import 'field_sales_communication_preferences.dart';
import 'need_analysis.dart';
import 'newmemberdialog.dart';

class FieldSalesMembersDetails extends StatefulWidget {
  const FieldSalesMembersDetails({super.key});

  @override
  State<FieldSalesMembersDetails> createState() =>
      _FieldSalesMembersDetailsState();
}

int current_member_index = 0;
int fieldSalesActiveStep = 0;
List<BottomBar> fieldbottomBarList = [
  BottomBar("View Main Members", "main_members"),
  BottomBar("View Members", "Members"),
  BottomBar("View Beneficiaries", "beneficiaries"),
  BottomBar("Add Premium Payer/Policy Holder", "premium_payer"),
  BottomBar("Add Employers Details", "employers_details"),
  BottomBar("Select Communication Preference", "communication_preference"),
];
AdditionalMember premiumPayerMember = AdditionalMember.empty();

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

class _FieldSalesMembersDetailsState extends State<FieldSalesMembersDetails>
    with SingleTickerProviderStateMixin {
  UniqueKey unique_key1 = UniqueKey();

  final needsAnalysisValueNotifier2 = ValueNotifier<int>(0);
  final myMemberDetailsValue1Sync = ValueNotifier<int>(0);
  List<String> commencementDates = [];
  TextEditingController employerNameController = TextEditingController();
  FocusNode employerNameFocusNode = FocusNode();
  TextEditingController occupationController = TextEditingController();
  FocusNode occupationFocusNode = FocusNode();
  TextEditingController employeeNumberController = TextEditingController();
  FocusNode employeeNumberFocusNode = FocusNode();
  TextEditingController contactController = TextEditingController();
  FocusNode contactFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  TextEditingController coverTypeController = TextEditingController();
  FocusNode coverTypeFocusNode = FocusNode();
  TextEditingController InsurersNameController = TextEditingController();
  FocusNode insurersNameFocusNode = FocusNode();
  TextEditingController coverDurationController = TextEditingController();
  FocusNode coverDurationFocusNode = FocusNode();

  //__-_____-_---_--_--_--_-----_---_---Premium Payer or Policy Holder---_------_---_-____----_-___-__--__-__-__//
  TextEditingController branchCodeController = TextEditingController();
  FocusNode branchCodeFocusNode = FocusNode();
  TextEditingController bankInstitutionController = TextEditingController();
  FocusNode bankInstitutionFocusNode = FocusNode();
  TextEditingController accountNumberController = TextEditingController();
  FocusNode accountNumberFocusNode = FocusNode();
  TextEditingController branchNameController = TextEditingController();
  FocusNode branchNameFocusNode = FocusNode();
  TextEditingController accountTypeController = TextEditingController();
  FocusNode accountTypeFocusNode = FocusNode();
  TextEditingController accountHolderController = TextEditingController();
  FocusNode accountHolderFocusNode = FocusNode();
  TextEditingController debitDayController = TextEditingController();
  FocusNode debitDayFocusNode = FocusNode();
  TextEditingController combinePremiumController = TextEditingController();
  FocusNode combinePremiumFocusNode = FocusNode();
  String? _selectedPaymentType;
  String? _selectedBankTypes;
  String? _selectedAccountType;
  String? _physicalAddressProvince;
  String? _postalAddressProvince;
  String? _beneficiaryAddressProvince;
  bool isBankingDetailsEditable = false;
  String? _selectedDebitDay;
  List<String> paymentType = [
    "Cash Payment",
    "Debit Order",
    "persal",
    "Salary Deduction"
  ];

  List<String> provinceList = [
    "Kwazulu Natal",
    "Gauteng",
    "Mpumalanga",
    "North West",
    "Northern Cape",
    "Western Cape",
    "Free State",
    "Limpopo",
    "Eastern Cape"
  ];

  TextEditingController addressController = TextEditingController();
  FocusNode addressFocusNode = FocusNode();
  TextEditingController suburbController = TextEditingController();
  FocusNode suburbFocusNode = FocusNode();
  TextEditingController cityController = TextEditingController();
  FocusNode cityFocusNode = FocusNode();
  TextEditingController provinceController = TextEditingController();
  FocusNode provinceFocusNode = FocusNode();
  TextEditingController codeController = TextEditingController();
  FocusNode codeFocusNode = FocusNode();

  TextEditingController addressPostalController = TextEditingController();
  FocusNode addressPostalFocusNode = FocusNode();
  TextEditingController suburbPostalController = TextEditingController();
  FocusNode suburbPostalFocusNode = FocusNode();
  TextEditingController cityPostalController = TextEditingController();
  FocusNode cityPostalFocusNode = FocusNode();
  TextEditingController provincePostalController = TextEditingController();
  FocusNode provincePostalFocusNode = FocusNode();
  TextEditingController codePostalController = TextEditingController();
  FocusNode codePostalFocusNode = FocusNode();

  TextEditingController addressBeneficialController = TextEditingController();
  FocusNode addressBeneficialFocusNode = FocusNode();
  TextEditingController suburbBeneficialController = TextEditingController();
  FocusNode suburbBeneficialFocusNode = FocusNode();
  TextEditingController cityBeneficialController = TextEditingController();
  FocusNode cityBeneficialFocusNode = FocusNode();
  TextEditingController provinceBeneficialController = TextEditingController();
  FocusNode provinceBeneficialFocusNode = FocusNode();
  TextEditingController codeBeneficialController = TextEditingController();
  FocusNode codeBeneficialFocusNode = FocusNode();

  bool sameAsPhysicalAddress = false;
  bool beneficialSameAsPhysicalAddress2 = false;

  //List<double> policiesSelectedPremiums = [];

  bool allow_editing = false;

  MyNotifier? myNotifier1;

  String? selectedSalaryRange;
  List<String> salaryRange = [
    "0-5000",
    "5001-10000",
    "10001-20000",
    "20001-30000",
    "30001-40000",
    "40001+"
  ];
  String? selectedSalaryFrequency;
  List<String> salaryFrequency = [
    "Weekly",
    "Fortnight",
    "Monthly",
  ];
  String? selectedPayDay;
  String? _selectedCombinePremium;
  List<String> payDay = List<String>.generate(
    31,
    (pay) => (pay + 1).toString().padLeft(2, '0'),
  );

  // Example usage with formatting during display

  TabController? _tabController;
  List<String> policiesSelectedMainInsuredDOBs = [];

  List<String> dateOfBirthList = [];
  List<QuoteRates> allRates = [];
  List<String> distinctProducts = [];
  List<dynamic> membersPerPolicy = [];
  List<String> distinctProdTypes = [];
  List<double> distinctCoverAmounts = [];

  //List<CalculatePolicyPremiumResponse> policyPremiums = [];
  LeadObject? currentLeadObj;
  String selectedProductString = "";
  String? _selectedProdType;
  List<List<double>> policiescoverAmounts = [];
  List<Map> policiesSelectedPartners = [];
  List<Map> policiesSelectedChildren = [];
  List<Map> policiesSelectedExtended = [];
  List<Map> policiesSelectedBeneficiaries = [];

  List<Map<String, String>> steplist = [
    {'task': '1', 'content': "View Main Members"},
    {'task': '3', 'content': "View/Add Beneficiaries"},
    {'task': '2', 'content': "View Members"},
    {'task': '4', 'content': "Add Premium Payer/Policy Holder"},
    {'task': '5', 'content': "Add Employer Details"},
    {'task': '6', 'content': "Select Communication Preference"},
  ];
  List<AdditionalMember> additionalMembers = [];
  List<AdditionalMember> policyMembers = [];
  int policy_member_index = 0;
  String current_policy_ref = "";
  List<InsurancePlan> insurancePlans = [];

  //Employer? employer;
  //BeneficiaryAddress? beneficiaryAddress;
  //Addresses

  @override
  void initState() {
    super.initState();
    //obtainMainInsuredForEachPolicy();
    obtainPremiumPayer();
    fieldSalesActiveStep = 0;
    setState(() {});
    if (Constants.currentleadAvailable!.policies.length == 1) {
      _selectedCombinePremium = "Yes";
    }
    Constants.currentlyEmployed = false;
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
                  ff.MemberPremium(
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

    payDay.forEach((day) {
      print(day.toString().padLeft(2, '0')); // Outputs "01", "02", ..., "31"
    });
    print("fvgghhgfhdghgdh");
    // obtainMainInsuredForEachPolicy();
    updateEmployersDetails();
    updatePhysicalAndPostalAddress();
    getPremiumPayerDetails();
    // getProoductList();

    //calculatePolicyPremiumCal();

    /*   myNotifier1 = MyNotifier(mySalesPremiumCalculatorValue, context);
    mySalesPremiumCalculatorValue.addListener(() {
      obtainMainInsuredForEachPolicy();

      print("gffgfg1");
      setState(() {});
    });*/

    _tabController =
        TabController(length: fieldbottomBarList.length, vsync: this);
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
        String defaultProdType = firstRate.prodType;
        // <-- Change as needed.

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

  obtainPremiumPayer() {
    premiumPayerMember = Constants.currentleadAvailable!.additionalMembers
        .where((member) => member.relationship == "self")
        .first;
    print("dshgsjh ${premiumPayerMember.name}");
  }

  void obtainMainInsuredForEachPolicy() {
    if (Constants.currentleadAvailable != null) {
      final List<Policy> policies =
          Constants.currentleadAvailable!.policies ?? [];

      // Clear any existing data to avoid duplicates
      //mainMembers.clear();

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

          // Updated main code with inception date logic
          if (additionalMember != null) {
            // Calculate inception date options based on 7-day rule
            List<String> inceptionOptions = calculateInceptionDateOptions();

            // Add both options to commencementDates
            commencementDates.addAll(inceptionOptions);

            // Add the main member for each inception date option
            for (String inceptionDate in inceptionOptions) {
              mainMembers.add(additionalMember);
              print(
                  "Main Member Added: ${additionalMember.autoNumber} for inception date: $inceptionDate");
            }

            // Extract and add DOB if available (for each inception option)
            if (mainMemberData["dob"] != null &&
                mainMemberData["dob"].toString().isNotEmpty) {
              String dobFormatted =
                  mainMemberData["dob"].toString().split("T").first;

              // Add DOB for each inception date option
              for (int i = 0; i < inceptionOptions.length; i++) {
                policiesSelectedMainInsuredDOBs.add(dobFormatted);
              }

              print(
                  "Added DOB: $dobFormatted for ${inceptionOptions.length} inception options");
            }
          }
        } else {
          print("No main member found for Policy: ${policy.reference}");
          AdditionalMember? additionalMember =
              Constants.currentleadAvailable!.additionalMembers.first;
          //   mainMembers.add(additionalMember);
          if (Constants.currentleadAvailable != null) {}
        }
      }

      print("Total Main Members Found: ${mainMembers.length}");

      // Single UI update after processing
      setState(() {});
    } else {
      print("No current lead available.");
    }
    // onPolicyUpdated();
  }

/*  onPolicyUpdated() async {
    print("onPolicyUpdated called");

    // Clear all lists so we can repopulate them.
    policyPremiums = [];
    policiesSelectedProducts = [];
    policiesSelectedProdTypes = [];
    // commencementDates = [];
    policiesSelectedCoverAmounts = [];
    distinctCoverAmounts = [];
    policiescoverAmounts = []; // Assuming List<List<double>> or similar.
    policiesSelectedMainInsuredDOBs =
        []; // This list will hold the main insured DOBs.

    // Loop over each main member (assuming the number of policies equals mainMembers.length)
    for (int i = 0; i < mainMembers.length; i++) {
      // Get the corresponding policy.
      final policy = Constants.currentleadAvailable!.policies[i];

      // Only process if totalAmountPayable exists and > 0.
      if (policy.quote.totalAmountPayable != null &&
          policy.quote.totalAmountPayable! > 0) {
        // If no entry exists at this index yet, create a new one.
        if (i >= policyPremiums.length) {
          policyPremiums.add(CalculatePolicyPremiumResponse(
            cecClientId: Constants.cec_client_id,
            totalPremium: policy.quote.totalAmountPayable,
            joiningFee: 0.0,
            memberPremiums: [],
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

          // Update parallel lists.
          policiesSelectedProducts.add(policy.quote.product);
          policiesSelectedProdTypes.add(policy.quote.productType);

          // Process members to see if a main member exists.
          bool mainMemberFound = false;
          String? mainInsuredDob; // Temporary storage for main insured DOB.
          final members = policy.members ?? [];
          for (var memberData in members) {
            final member = Member.fromJson(memberData);
            if (member.type == "main_member") {
              mainMemberFound = true;
              // Format the member's DOB as "yyyy-MM-dd"
              String formattedDob = "";

              // (Optional) Additional processing with AdditionalMember if needed.
              AdditionalMember additionalMember =
                  Constants.currentleadAvailable!.additionalMembers.firstWhere(
                (member1) =>
                    member1.autoNumber == memberData["additional_member_id"],
                orElse: () => AdditionalMember(
                  memberType: "",
                  autoNumber: -1,
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
                  lastUpdate: "",
                ),
              );
              if (additionalMember.autoNumber == -1) {
                print(
                    "No matching AdditionalMember found for autoNumber: ${memberData["additional_member_id"]}");
              } else {
                try {
                  final age =
                      calculateAge(DateTime.parse(additionalMember.dob));
                  policiesSelectedMainInsuredDOBs
                      .add(additionalMember.dob.toString().split("T").first);
                  print("Policy member (main) age: $age");
                } catch (e) {
                  print("Invalid DOB for main member: $e");
                  continue;
                }
              }
            }
          }
          // If no main member was found, try to fetch a default/main insured DOB.
          if (!mainMemberFound) {
            String formattedDob = "";
            if (Constants.currentleadAvailable!.additionalMembers.isNotEmpty) {
              AdditionalMember additionalMember =
                  Constants.currentleadAvailable!.additionalMembers.first;
              try {
                final DateTime dobDate = DateTime.parse(additionalMember.dob);
                formattedDob = DateFormat('yyyy-MM-dd').format(dobDate);
              } catch (e) {
                //  formattedDob = "1998-05-12"; // Fallback default.
              }
            } else {
              // formattedDob = "1998-05-12";
            }
            mainInsuredDob = formattedDob;
          }

          // Add commencement date (or empty string if not available).
          if (policy.premiumPayer.commencementDate != null) {
            commencementDates.add(policy.premiumPayer.commencementDate!);
          } else {
            commencementDates.add('');
          }

          // Add cover amount.
          policiesSelectedCoverAmounts
              .add(policy.quote.sumAssuredFamilyCover ?? 0);
          distinctCoverAmounts.add(policy.quote.sumAssuredFamilyCover ?? 0);

          // --- Rate Filtering Section ---
          String currentProduct = policy.quote.product;
          String currentProductType = policy.quote.productType;

          // Filter main rates based on product & type.
          List<MainRate> filteredMainRates = Constants
              .currentParlourConfig!.mainRates
              .where((r) =>
                  r.product == currentProduct &&
                  r.prodType == currentProductType)
              .toList();

          // Extract cover amounts from filteredMainRates.
          final Set<double> allAmounts = {};
          for (var r in filteredMainRates) {
            allAmounts.add(r.amount);
          }
          final List<double> sortedAmounts = allAmounts.toList()..sort();

          // Update policiescoverAmounts at index i.
          if (policiescoverAmounts.length <= i) {
            policiescoverAmounts.add(sortedAmounts);
          } else {
            policiescoverAmounts[i] = sortedAmounts;
          }
        } else {
          // If an entry already exists for this index, update its total premium.
          policyPremiums[i].totalPremium = policy.quote.totalAmountPayable;
        }
        print(
            "Updated premium for policy index3 $i: ${policy.quote.totalAmountPayable}");
      }
    }
    // Trigger a UI rebuild.
    setState(() {});
  }*/

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
      '${Constants.parlourConfigBaseUrl}parlour-config/calculate-rates/',
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
        // onPolicyUpdated();

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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                'Submit',
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

  void getProoductList() {
    // If no current lead is available, exit.
    if (Constants.currentleadAvailable == null) return;

    // Get all policies.
    final policies = Constants.currentleadAvailable!.policies;
    if (policies.isEmpty) return; // No policies, nothing to do.

    // Ensure our lists are long enough to store one entry per policy.
    for (int i = 0; i < policies.length; i++) {
      if (i >= policiesSelectedProducts.length) {
        policiesSelectedProducts.add("");
      }
      if (i >= policiesSelectedProdTypes.length) {
        policiesSelectedProdTypes.add("");
      }
      if (i >= policiesSelectedMainInsuredDOBs.length) {
        policiesSelectedMainInsuredDOBs.add("");
      }
    }

    // Loop over every policy to update our lists.
    for (int i = 0; i < policies.length; i++) {
      // Get the product and product type for the current policy.
      final product = policies[i].quote.product ?? "";
      final productType = policies[i].quote.productType ?? "";

      // Update the product lists.
      policiesSelectedProducts[i] = product;
      policiesSelectedProdTypes[i] = productType;

      // If this policy corresponds to the current member,
      // update the global selected product string and _selectedProdType.
      if (i == current_member_index) {
        selectedProductString = "$product $productType";
        _selectedProdType = productType;
      }

      // Update the main insured DOB for this policy.
      // (Assuming that the main insured info is available in your mainMembers list.)
      if (i < mainMembers.length) {
        policiesSelectedMainInsuredDOBs[i] = mainMembers[i].dob.isNotEmpty
            ? mainMembers[i].dob.split("T").first
            : "";
      } else {
        policiesSelectedMainInsuredDOBs[i] = "";
      }

      // Update the premium for this policy using the quote's total premium.
      //policiesSelectedPremiums[i] = policies[i].quote.totalAmountPayable ?? 0.0;

      // Debug print for each policy.
      /*    print("Policy $i: Product: $product, Type: $productType, "
          "Main Insured DOB: ${policiesSelectedMainInsuredDOBs[i]}, "
          "Premium: ${policiesSelectedPremiums[i]}");*/
    }

    // Validate current_member_index.
    if (current_member_index < 0 ||
        current_member_index >= policiesSelectedProducts.length) {
      current_member_index = 0;
    }

    // print("selectedProductString => $selectedProductString");
    // print("policiesSelectedProducts => $policiesSelectedProducts");
    // print("_selectedProdType => $_selectedProdType");
    //print( "policiesSelectedMainInsuredDOBs => $policiesSelectedMainInsuredDOBs");
    //print("policiesSelectedPremiums => $policiesSelectedPremiums");
  }

  int calculateAge(DateTime dob) {
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  void updateEmployersDetails() {
    if (Constants.currentleadAvailable != null) {
      if (Constants.currentleadAvailable?.employer != null) {
        Employer? employer = Constants.currentleadAvailable?.employer;
        // if (employer != null) print("dfgghgh ${employer!.toJson()}");
        if (Constants.currentleadAvailable!.employer!.employmentStatus ==
            "Employed") {
          Constants.currentlyEmployed = true;
        }

        employerNameController.text = employer!.employerName;
        occupationController.text = employer.occupation;
        employeeNumberController.text = employer.employeeNumber;
        selectedSalaryRange = employer.salaryRange;
        selectedSalaryFrequency = employer.salaryFrequency;
        selectedPayDay = employer.salaryDay;
      }
    }
  }

  void updatePhysicalAndPostalAddress() {
    if (Constants.currentleadAvailable != null) {
      // Update physical and postal addresses from the Addresses model.

      if (Constants.currentleadAvailable!.addresses != null) {
        //print("sdjkdslkd ${Constants.currentleadAvailable!.addresses!.toJson()}");
        final addresses = Constants.currentleadAvailable!.addresses!;

        // Physical Address: Combine addressAutoNumber (if available) and physaddressLine1.
        if (addresses.addressAutoNumber.isNotEmpty ||
            addresses.physaddressLine1.isNotEmpty) {
          addressController.text = (addresses.addressAutoNumber.isNotEmpty
                  ? addresses.addressAutoNumber + " "
                  : "") +
              addresses.physaddressLine1;
        }
        if (addresses.physaddressLine2.isNotEmpty) {
          suburbController.text = addresses.physaddressLine2;
        }
        if (addresses.physaddressLine3.isNotEmpty) {
          cityController.text = addresses.physaddressLine3;
        }
        if (addresses.physaddressCode.isNotEmpty) {
          codeController.text = addresses.physaddressCode;
        }
        if (addresses.physaddressProvince.isNotEmpty) {
          _physicalAddressProvince = addresses.physaddressProvince;
        }

        if (addresses.postaddressLine3.isNotEmpty) {
          suburbPostalController.text = addresses.postaddressLine3;
        }
        if (addresses.postaddressLine1.isNotEmpty) {
          addressPostalController.text = addresses.postaddressLine1;
        }
        // For city, try postaddressLine1; if empty, use physical city.
        if (addresses.postaddressLine1.isNotEmpty) {
          cityPostalController.text = addresses.postaddressLine1;
        } else {
          cityPostalController.text = cityController.text;
        }
        if (addresses.postaddressProvince.isNotEmpty) {
          provincePostalController.text = addresses.postaddressProvince;
          _postalAddressProvince = addresses.postaddressProvince;
        }
        if (addresses.postaddressCode.isNotEmpty) {
          codePostalController.text = addresses.postaddressCode;
        }
      }

      // Update beneficiary address fields from the BeneficiaryAddress model.
      if (Constants.currentleadAvailable!.beneficiaryAddress != null) {
        final beneficiary = Constants.currentleadAvailable!.beneficiaryAddress!;

        // Update the beneficiary fields only if the data is available.
        if (beneficiary.physaddressLine1.isNotEmpty) {
          addressBeneficialController.text = beneficiary.physaddressLine1;
        }
        if (beneficiary.physaddressLine2.isNotEmpty) {
          suburbBeneficialController.text = beneficiary.physaddressLine2;
        }
        if (beneficiary.physaddressLine3.isNotEmpty) {
          cityBeneficialController.text = beneficiary.physaddressLine3;
        }
        if (beneficiary.physaddressCode.isNotEmpty) {
          codeBeneficialController.text = beneficiary.physaddressCode;
        }
        if (beneficiary.physaddressProvince.isNotEmpty) {
          _beneficiaryAddressProvince = beneficiary.physaddressProvince;
        }
      }

      setState(() {});
    }
  }

  void updatePayerDetails({
    required BuildContext context,
  }) async {
    String url = "${Constants.insightsBackendUrl}parlour/updatePayer";

    // Ensure debit_date is not empty (use a default value if needed)

    int debitDate = 1;

    int onololeadid = Constants
        .currentleadAvailable!.policies[current_member_index].quote.onololeadid;
    //print("shaGHJA ${onololeadid}");
    String current_reference = Constants
        .currentleadAvailable!.policies[current_member_index].quote.reference;

    // Required field validations
    if (_selectedPaymentType == null) {
      MotionToast.error(
        height: 40,
        width: 300,
        onClose: () {},
        description: Text(
          "Select a payment method",
          style: TextStyle(color: Colors.white),
        ),
      ).show(context);
      return;
    }
    if (_selectedAccountType == null && _selectedPaymentType == "Debit Order") {
      MotionToast.error(
        height: 40,
        width: 300,
        onClose: () {},
        description: Text(
          "Select a an account type",
          style: TextStyle(color: Colors.white),
        ),
      ).show(context);
      return;
    }
    //print("sdshjshj $_selectedDebitDay");
    if (_selectedDebitDay == null && _selectedPaymentType == "Debit Order") {
      MotionToast.error(
        height: 40,
        width: 300,
        onClose: () {},
        description: Text(
          "Select a debit day",
          style: TextStyle(color: Colors.white),
        ),
      ).show(context);
      return;
    }
    if (_selectedCombinePremium == null) {
      MotionToast.error(
        height: 40,
        width: 300,
        onClose: () {},
        description: Text(
          "Combine Premium not selected",
          style: TextStyle(color: Colors.white),
        ),
      ).show(context);
      return;
    }
    if (_postalAddressProvince == null) {
      MotionToast.error(
        height: 40,
        width: 300,
        onClose: () {},
        description: Text(
          "Postal address province not selected",
          style: TextStyle(color: Colors.white),
        ),
      ).show(context);
      return;
    }
    if (_physicalAddressProvince == null) {
      MotionToast.error(
        height: 40,
        width: 300,
        onClose: () {},
        description: Text(
          "Physical address province not selected",
          style: TextStyle(color: Colors.white),
        ),
      ).show(context);
      return;
    }
    if (_beneficiaryAddressProvince == null) {
      MotionToast.error(
        height: 40,
        width: 300,
        onClose: () {},
        description: Text(
          "Beneficiary address province not selected",
          style: TextStyle(color: Colors.white),
        ),
      ).show(context);
      return;
    }

    if (suburbController.text.isEmpty) {
      MotionToast.error(
        height: 40,
        width: 300,
        onClose: () {},
        description: Text(
          "Suburb is required",
          style: TextStyle(color: Colors.white),
        ),
      ).show(context);
      return;
    }
    if (cityController.text.isEmpty) {
      MotionToast.error(
        height: 40,
        width: 300,
        onClose: () {},
        description: Text(
          "City is required",
          style: TextStyle(color: Colors.white),
        ),
      ).show(context);
      return;
    }
    if (codeController.text.isEmpty) {
      MotionToast.error(
        height: 40,
        width: 300,
        onClose: () {},
        description: Text(
          "Code is required",
          style: TextStyle(color: Colors.white),
        ),
      ).show(context);
      return;
    }
    if (_physicalAddressProvince == null) {
      MotionToast.error(
        height: 40,
        width: 300,
        onClose: () {},
        description: Text(
          "Province is required",
          style: TextStyle(color: Colors.white),
        ),
      ).show(context);
      return;
    }
    if (_selectedDebitDay == null) {
      MotionToast.error(
        height: 40,
        width: 300,
        onClose: () {},
        description: Text(
          "Select a debit day",
          style: TextStyle(color: Colors.white),
        ),
      ).show(context);
      return;
    }
    debitDate = int.parse(_selectedDebitDay!);

    // Build the addresses data as a Map
    final addressesMap = {
      "auto_number": Constants
          .currentleadAvailable!.policies.first.premiumPayer.autoNumber,
      "onololeadid": onololeadid,
      "postaddress_line1": addressPostalController.text,
      "postaddress_line2": suburbPostalController.text,
      "postaddress_line3": cityPostalController.text,
      "postaddress_code": codePostalController.text,
      "postaddress_province": _postalAddressProvince!,
      "physaddress_line1": addressController.text,
      "physaddress_line2": suburbController.text,
      "physaddress_line3": cityController.text,
      "physaddress_code": codeController.text,
      "physaddress_province": _physicalAddressProvince,
      "latitude": "",
      "longitude": "",
      "validated": null,
      "updated_by": Constants.cec_employeeid,
    };
    // Addresses addresses = Addresses.fromJson(addressesMap);

    // Build the premiumPayers data as a List of Maps.
    final premiumPayersList = [
      {
        "auto_number": Constants
            .currentleadAvailable!.policies.first.premiumPayer.autoNumber,
        "bankname": _selectedBankTypes,
        "branchname": branchNameController.text,
        "branchcode": branchCodeController.text,
        "accno": accountNumberController.text,
        "accounttype": _selectedAccountType ?? "",
        "salarydate": "",
        "collectionday": debitDate.toString(),
        "reference": current_reference,
        "onololeadid": onololeadid,
        "acount_holder": Constants.currentleadAvailable!.leadObject.title +
            " " +
            Constants.currentleadAvailable!.leadObject.firstName +
            " " +
            Constants.currentleadAvailable!.leadObject.lastName,
        "combine_premium": _selectedCombinePremium ?? "yes",
        "updated_by": Constants.cec_employeeid,
      },
    ];
    // print(premiumPayersList);
/*  List<PremiumPayer> premiumPayers =
        premiumPayersList.map((e) => PremiumPayer.fromJson(e)).toList();*/

    // Build the beneficiary_Address data as a Map
    final beneficiaryAddressMap = {
      "onololeadid": onololeadid,
      "physaddress_line1": addressBeneficialController.text,
      "physaddress_line2": suburbBeneficialController.text,
      "physaddress_line3": cityBeneficialController.text,
      "physaddress_code": codeBeneficialController.text,
      "physaddress_province": _beneficiaryAddressProvince,
    };
    //Addresses beneficiaryAddress = Addresses.fromJson(beneficiaryAddressMap);
    List<PremiumPayer> premiumPayers =
        premiumPayersList.map((e) => PremiumPayer.fromJson(e)).toList();
    Addresses addresses1 = Addresses.fromJson(addressesMap);
    BeneficiaryAddress beneficiaryAddress1 =
        BeneficiaryAddress.fromJson(beneficiaryAddressMap);

    // Prepare the final payload as a JSON object.
    final Map<String, dynamic> payload = {
      'premiumPayers': premiumPayers.map((e) => e.toJson()).toList(),
      'addresses': addresses1.toJson(),
      'debit_day': debitDate,
      'beneficiary_Address': beneficiaryAddressMap,
      'reference': Constants
          .currentleadAvailable!.policies[current_member_index].quote.reference,
    };

    /*  final Map<String, dynamic> payload = {
      'premiumPayers': premiumPayersList,
      'addresses': addressesMap,
      'debit_date': debitDate,
      'beneficiary_Address': beneficiaryAddressMap,
      'reference': Constants
          .currentleadAvailable!.policies[current_member_index].quote.reference,
    };*/
    try {
      print("Sending payload: $payload");
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );
      print("Response: ${response.body}");
      print("Url: $url");

      // Try to decode the response; if it fails, use the raw response body.
      dynamic decodedResponse;
      try {
        decodedResponse = jsonDecode(response.body);
      } catch (e) {
        decodedResponse = response.body;
      }

      // Determine if the update was successful.
      // For example, if your server returns a number > 0 on success.
      int? resultValue;
      if (decodedResponse is int) {
        resultValue = decodedResponse;
      } else if (decodedResponse is String) {
        resultValue = int.tryParse(decodedResponse);
      } else if (decodedResponse is Map<String, dynamic> &&
          decodedResponse.containsKey("result")) {
        resultValue = decodedResponse["result"];
      }

      if (resultValue != null && resultValue >= 0) {
        Constants.isPremiumPayerSaved = true;
        Constants.currentleadAvailable!.leadObject.paymentType =
            _selectedPaymentType!;
        SalesService salesService = SalesService();
        /*salesService.updateCallCenterLeadObjectDetails(
            Constants.currentleadAvailable!.leadObject);*/
        Constants.currentleadAvailable!.policies[0].premiumPayer =
            PremiumPayer.fromJson(premiumPayersList[0]);
        Constants.currentleadAvailable!.addresses =
            Addresses.fromJson(addressesMap);
        Constants.currentleadAvailable!.beneficiaryAddress =
            BeneficiaryAddress.fromJson(beneficiaryAddressMap);
        fieldSalesActiveStep++;
        setState(() {});

        MotionToast.success(
          description: Text(
            "Payer details updated successfully",
            style: TextStyle(color: Colors.white),
          ),
          height: 45,
        ).show(context);
      } else if (decodedResponse is Map<String, dynamic> &&
          decodedResponse.containsKey("message")) {
        String message = decodedResponse['message'] ?? 'Unknown error';
        // print("Update failed: $message");
        MotionToast.error(
          description: Text(
            "Update failed: $message",
            style: TextStyle(color: Colors.white),
          ),
          height: 45,
        ).show(context);
      } else if (decodedResponse is String) {
        //print("Server error: $decodedResponse");
        MotionToast.error(
          description: Text(
            "Update failed: $decodedResponse",
            style: TextStyle(color: Colors.white),
          ),
          height: 45,
        ).show(context);
      } else {
        print("Unexpected response format: $decodedResponse");
        MotionToast.error(
          description: Text(
            "Update failed: Unexpected response format",
            style: TextStyle(color: Colors.white),
          ),
          height: 45,
        ).show(context);
      }
    } catch (e) {
      print("Error occurred: $e");
      MotionToast.error(
        description: Text(
          "Error occurred: $e",
          style: TextStyle(color: Colors.white),
        ),
        height: 45,
      ).show(context);
    }
  }

  void updatePremiumPayerDetails(PremiumPayer premium_payer) {
    PremiumPayer premiumPayer = PremiumPayer(
        autoNumber: premium_payer.autoNumber,
        bankname: premium_payer.bankname,
        branchname: premium_payer.branchname,
        branchcode: premium_payer.branchcode,
        accno: premium_payer.accno,
        accounttype: premium_payer.accounttype,
        salarydate: premium_payer.salarydate,
        collectionday: premium_payer.collectionday,
        naedosexplained: premium_payer.naedosexplained,
        commencementDate: premium_payer.commencementDate,
        naedosconset: premium_payer.naedosconset,
        timestamp: premium_payer.timestamp,
        lastUpdate: premium_payer.lastUpdate,
        reference: premium_payer.reference,
        onololeadid: premium_payer.onololeadid,
        acountHolder: premium_payer.acountHolder,
        combinePremium: premium_payer.combinePremium,
        validated: premium_payer.validated,
        errorMessage: premium_payer.errorMessage,
        updatedBy: premium_payer.updatedBy,
        payerQueryTypeOldNew: premium_payer.payerQueryTypeOldNew,
        payerQueryType: premium_payer.payerQueryType,
        payerQueryTypeOldAutoNumber: premium_payer.payerQueryTypeOldAutoNumber,
        payerAutoNumberOld: premium_payer.payerAutoNumberOld,
        isSpecialDebit: premium_payer.isSpecialDebit,
        specialDebitDate: premium_payer.specialDebitDate);
    bankInstitutionController.text = premiumPayer.bankname;
    branchNameController.text = premiumPayer.branchname;
    branchCodeController.text = premiumPayer.branchcode;
    accountNumberController.text = premiumPayer.accno;
    accountTypeController.text = premiumPayer.accounttype;
    accountHolderController.text = premiumPayer.acountHolder;
    debitDayController.text = premiumPayer.collectionday;
    debitDayController.text = premiumPayer.combinePremium;
  }

  void getPremiumPayerDetails() {
    if (Constants.currentleadAvailable!.policies.length == 1) {
      Constants.currentleadAvailable!.policies.first.premiumPayer!
          .combinePremium = "Yes";
    }
    if (Constants.currentleadAvailable!.policies.length > 0) {
      if (Constants.currentleadAvailable!.leadObject.paymentType.isNotEmpty)
        _selectedPaymentType =
            Constants.currentleadAvailable!.leadObject.paymentType;
      PremiumPayer premiumPayer =
          Constants.currentleadAvailable!.policies[0].premiumPayer;
      // print("dfgffgfg ${premiumPayer.toJson()}");
      if (premiumPayer.bankname.isNotEmpty)
        _selectedBankTypes = premiumPayer.bankname;
      if (premiumPayer.collectionday.isNotEmpty)
        _selectedDebitDay = premiumPayer.collectionday;
      if (premiumPayer.combinePremium.isNotEmpty) {
        _selectedCombinePremium =
            premiumPayer.combinePremium[0].toString().toUpperCase() +
                premiumPayer.combinePremium.substring(1).toLowerCase();
      }
      ;
      branchNameController.text = premiumPayer.branchname;
      if (premiumPayer.branchcode.isNotEmpty)
        branchCodeController.text = premiumPayer.branchcode;
      if (premiumPayer.accno.isNotEmpty)
        accountNumberController.text = premiumPayer.accno;
      if (premiumPayer.accounttype.isNotEmpty)
        _selectedAccountType = premiumPayer.accounttype;
      accountHolderController.text = premiumPayer.acountHolder;
      debitDayController.text = premiumPayer.collectionday;
      debitDayController.text = premiumPayer.combinePremium;

      if (Constants.currentleadAvailable!.leadObject.paymentType.isNotEmpty) {
        _selectedPaymentType =
            Constants.currentleadAvailable!.leadObject.paymentType;
      }
      if (Constants.currentleadAvailable!.policies[current_member_index].quote
                  .debitDay !=
              null &&
          Constants.currentleadAvailable!.policies[current_member_index].quote
                  .debitDay !=
              0) {
        // print("dffggf ${Constants.currentleadAvailable!.policies[current_member_index].quote.debitDay}");
        _selectedDebitDay = Constants
            .currentleadAvailable!.policies[current_member_index].quote.debitDay
            .toString();
      }
    }
    //print("ffhgghgjh ${Constants.currentleadAvailable!.policies[0].premiumPayer.toJson()}");
  }

  Widget buildAllMembersGrid() {
    // Get the current policy.
    final policy =
        Constants.currentleadAvailable!.policies[current_member_index];

    // If no members exist, return a fallback widget.
    if (policy.members.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: Text(
            "No members added to the current policy",
            style: TextStyle(fontSize: 14, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

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
          mainAxisExtent: 145,
        ),
        itemCount: policy.members.length,
        itemBuilder: (context, index) {
          // Get the member map from the policy.
          Map memberData = policy.members[index];

          // Skip any member whose type is exactly "relationship".
          if ((memberData["type"]?.toString().toLowerCase() ?? "") ==
              "relationship") {
            return SizedBox.shrink();
          }

          // Parse cover and premium values from the member data.
          double cover = 0.0;
          double premium = 0.0;
          if (memberData.containsKey("cover") && memberData["cover"] != null) {
            cover = double.tryParse(memberData["cover"].toString()) ?? 0.0;
          }

          if (memberData.containsKey("premium") &&
              memberData["premium"] != null) {
            premium = double.tryParse(memberData["premium"].toString()) ?? 0.0;
          }

          // If this member is "self", try to update premium and cover
          // using the values from the main_member if needed.
          if ((memberData["type"]?.toString().toLowerCase() ?? "") == "self") {
            if (premium == 0.0 && cover == 0.0) {
              // Look for a member with type "main_member" in the same policy.
              var mainMemberData = policy.members.firstWhere(
                (m) =>
                    (m["type"]?.toString().toLowerCase() ?? "") ==
                    "main_member",
                orElse: () => null,
              );
              if (mainMemberData != null) {
                premium = double.tryParse(
                        mainMemberData["premium"]?.toString() ?? "") ??
                    premium;
                cover = double.tryParse(
                        mainMemberData["cover"]?.toString() ?? "") ??
                    cover;
              }
              // If still 0, then fall back to external arrays if available.
              // (Assuming these are defined and are lists of double.)
            }
          }

          // Lookup additional member details.
          AdditionalMember additionalMember =
              Constants.currentleadAvailable!.additionalMembers.firstWhere(
            (am) => am.autoNumber == memberData["additional_member_id"],
            orElse: () => AdditionalMember.empty(),
          );

          // Build the card using a custom card widget.
          return CustomCard2(
            elevation: 8,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            boderRadius: 12,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Constants.ftaColorLight.withOpacity(0.95),
                ),
              ),
              margin:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
              padding: const EdgeInsets.all(0.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left: CircleAvatar with gender icon.
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
                          additionalMember.gender.toLowerCase() == "female"
                              ? Icons.female
                              : Icons.male,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  // Middle: Member details.
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (additionalMember.dob.isNotEmpty)
                            Text(
                              'DoB: ${DateFormat('dd MMM yyyy').format(DateTime.parse(additionalMember.dob))}',
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
                            '${additionalMember.title} ${additionalMember.name} ${additionalMember.surname}',
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
                              const Icon(Icons.people_alt,
                                  color: Colors.black, size: 16),
                              const SizedBox(width: 4.0),
                              Expanded(
                                child: Text(
                                  'Relationship: ${additionalMember.relationship[0].toUpperCase() + additionalMember.relationship.substring(1)}',
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
                              const Spacer(),
                              Text(
                                'Cover: R${formatLargeNumber((cover ?? 0).toString())}',
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
                        ],
                      ),
                    ),
                  ),
                  // (Optional: add an edit button column here if desired)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height,
        child: Padding(
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
                          children: List.generate(fieldbottomBarList.length, (index) {
                            final isActive = fieldSalesActiveStep == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  fieldSalesActiveStep = index;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                height: 45,
                                // Fixed width instead of expanding
                                constraints: BoxConstraints(
                                  minWidth: 180, // Minimum width for each tab
                                  maxWidth: 280, // Maximum width for each tab
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                alignment: Alignment.center,
                                // Active background highlight - covers full tab width
                                decoration: BoxDecoration(
                                  color: isActive 
                                      ? Constants.ftaColorLight 
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.only(
                                    topLeft: isActive && index == 0
                                        ? const Radius.circular(12)
                                        : Radius.zero,
                                    topRight: isActive && index == fieldbottomBarList.length - 1
                                        ? const Radius.circular(12)
                                        : Radius.zero,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      fieldbottomBarList[index].bottomStringName,
                                      style: TextStyle(
                                        fontSize: 14.5,
                                        color: isActive
                                            ? Colors.white
                                            : Constants.ftaColorLight,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    if (isActive) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        height: 24,
                                        width: 24,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Text(
                                            (index + 1).toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
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
                    SizedBox(
                      height: 24,
                    ),
                    /*Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: SizedBox(
                height: 50, // Adjust height to match your UI
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: fieldbottomBarList.map((item) {
                      int idx = fieldbottomBarList.indexOf(item);
                      bool isSelected =
                          fieldSalesActiveStep == idx; // Track selected index

                      return Padding(
                        padding: EdgeInsets.only(
                          right: idx < fieldbottomBarList.length - 1 ? 16.0 : 0.0,
                        ),
                        child: Container(
                          width: 280,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                fieldSalesActiveStep = idx;
                              });
                            },
                            style: TextButton.styleFrom(
                              minimumSize: const Size(220, 45),
                              backgroundColor: isSelected
                                  ? Constants.ftaColorLight
                                  : Colors.grey[300],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  item.bottomStringName,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'YuGothic',
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Constants.ctaColorLight,
                                    borderRadius: BorderRadius.circular(360),
                                  ),
                                  child: Center(
                                    child: Text(
                                      (idx + 1).toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),*/
                    /* Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: SizedBox(
                height: 50, // Adjust height to match your UI
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: fieldbottomBarList.map((item) {
                      int idx = fieldbottomBarList.indexOf(item);
                      bool isSelected =
                          fieldSalesActiveStep == idx; // Track selected index

                      return Padding(
                        padding: EdgeInsets.only(
                          right: idx < fieldbottomBarList.length - 1 ? 16.0 : 0.0,
                        ),
                        child: Container(
                          width: 260,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                fieldSalesActiveStep = idx;
                              });
                            },
                            style: TextButton.styleFrom(
                              minimumSize: const Size(220, 45),
                              backgroundColor: isSelected
                                  ? Constants.ftaColorLight
                                  : Colors.grey[300],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  item.bottomStringName,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'YuGothic',
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Constants.ctaColorLight,
                                    borderRadius: BorderRadius.circular(360),
                                  ),
                                  child: Center(
                                    child: Text(
                                      (idx + 1).toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),*/
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24),
                      child: Divider(color: Colors.grey.withOpacity(0.35)),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if (mainMembers.length == 0)
                      Padding(
                        padding: EdgeInsets.only(left: 24.0),
                        child: Container(
                          height: 135,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 130,
                                width: 450,
                                child: ff.AdvancedMemberCard(
                                  id: "",
                                  dob: "",
                                  surname: Constants.currentleadAvailable!
                                      .additionalMembers.first.surname,
                                  contact: Constants.currentleadAvailable!
                                      .additionalMembers.first.contact,
                                  sourceOfWealth: "",
                                  otherUnknownWealth: "",
                                  otherUnknownIncome: "",
                                  dateOfBirth: "",
                                  sourceOfIncome: "",
                                  title: Constants.currentleadAvailable!
                                      .additionalMembers.first.title,
                                  name: Constants.currentleadAvailable!
                                      .additionalMembers.first.name,
                                  relationship: "self",
                                  gender: "",
                                  autoNumber: Constants.currentleadAvailable!
                                      .additionalMembers.first.autoNumber,
                                  isSelected: false,
                                  isEditing: false,
                                  is_self_or_payer: true,
                                  current_member_index: current_member_index,
                                  noOfMembers: 0,
                                  onSingleTap: () {
                                    //current_member_index = index;
                                    // print("dgfgfgf $current_member_index");
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (mainMembers.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Container(
                          height: 130,
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:
                                  mainMembers.asMap().entries.map((entry) {
                                int index = entry.key;
                                var member = entry.value;
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(top: 0, right: 16),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Container(
                                            width: 450,
                                            height: 130,
                                            child: InkWell(
                                              onTap: () {
                                                current_member_index = index;
                                                //print("Selected member index: $current_member_index $index");
                                                setState(() {});
                                              },
                                              child: AdvancedPolicyCard(
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
                                                    : ((policyPremiums[index]
                                                                .totalPremium ??
                                                            0) +
                                                        (policyPremiums[index]
                                                                .selectedRidersTotal ??
                                                            0)),
                                                selected_product: Constants
                                                    .currentleadAvailable!
                                                    .policies[index]
                                                    .quote
                                                    .product,
                                                selected_cover:
                                                    policiesSelectedCoverAmounts[
                                                        index],
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(
                      //current_member_index
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24),
                      child: Divider(color: Colors.grey.withOpacity(0.35)),
                    ),
                    if (fieldSalesActiveStep == 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              //current_member_index
                              height: 16,
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
                                                                left: 16.0),
                                                        child: Text(
                                                          (policiesSelectedProducts
                                                                      .isEmpty ||
                                                                  current_member_index >=
                                                                      policiesSelectedProducts
                                                                          .length ||
                                                                  current_member_index >=
                                                                      policiesSelectedProdTypes
                                                                          .length)
                                                              ? "-"
                                                              : "${policiesSelectedProducts[current_member_index]} ${policiesSelectedProdTypes[current_member_index]}",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'YuGothic',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.black,
                                                          ),
                                                        ),
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
                                SizedBox(
                                  width: 32,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Premium Amount',
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
                                                          CupertinoIcons
                                                              .money_dollar_circle,
                                                          size: 24,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        height: 48,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 12,
                                                                  left: 12),
                                                          child: Builder(
                                                            builder: (context) {
                                                              // Check if policyPremiums is empty or index is out of range
                                                              if (policyPremiums
                                                                      .isEmpty ||
                                                                  current_member_index >=
                                                                      policyPremiums
                                                                          .length) {
                                                                return Text(
                                                                  "R0.00",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    letterSpacing:
                                                                        0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                );
                                                              }

                                                              final premium =
                                                                  policyPremiums[
                                                                      current_member_index];

                                                              // Safely get totalPremium, default to 0.0 if null
                                                              final totalPremium =
                                                                  premium.totalPremium ??
                                                                      0.0;

                                                              // Safely get selectedRidersTotal, default to 0.0 if null
                                                              final ridersTotal =
                                                                  premium.selectedRidersTotal ??
                                                                      0.0;

                                                              // Calculate total amount
                                                              final totalAmount =
                                                                  totalPremium +
                                                                      ridersTotal;

                                                              // Check if total is 0 or very close to 0
                                                              if (totalAmount <=
                                                                  0.0) {
                                                                return Text(
                                                                  "R0.00",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    letterSpacing:
                                                                        0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                );
                                                              }

                                                              return Text(
                                                                "R${totalAmount.toStringAsFixed(2)}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  letterSpacing:
                                                                      0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              );
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
                              //current_member_index
                              height: 16,
                            ),
                          ],
                        ),
                      ),
                    if (fieldSalesActiveStep == 1)
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 24,
                            ),
                            /* Text(Constants.currentleadAvailable!
                        .policies[current_member_index].members
                        .toString()),*/
                            buildBeneficiariesList(),
                            const SizedBox(height: 16),
                            if (getTotalBeneficiaryPercentage(
                                    current_member_index) <
                                100)
                              Center(
                                child: InkWell(
                                  child: Container(
                                    height: 45,
                                    width: 220,
                                    padding:
                                        EdgeInsets.only(left: 16, right: 16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(36),
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
                                            "Add a Beneficiary",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'YuGothic',
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    showAddBeneficiariesDialog(
                                        context, current_member_index);
                                  },
                                ),
                              ),
                            SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                    if (fieldSalesActiveStep == 2)
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 24,
                            ),
                            buildAllMembersGrid(),
                            /*  Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Container(
                        height: 155,
                        width: MediaQuery.of(context).size.width,
                        child: Constants.currentleadAvailable!.policies.isEmpty
                            ? Container()
                            : Constants
                                    .currentleadAvailable!
                                    .policies[current_member_index]
                                    .members
                                    .isEmpty
                                ? Center()
                                : ListView.builder(
                                    key: unique_key1,
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: Constants
                                        .currentleadAvailable!
                                        .policies[current_member_index]
                                        .members
                                        .length,
                                    itemBuilder: (context, index) {
                                      Member member = Member.fromJson(Constants
                                          .currentleadAvailable!
                                          .policies[current_member_index]
                                          .members[index]);
                                      AdditionalMember? additionalMember =
                                          Constants.currentleadAvailable!
                                              .additionalMembers
                                              .where((member1) =>
                                                  member1.autoNumber ==
                                                  member.additionalMemberId)
                                              .firstOrNull;
                                      if (additionalMember == null) {
                                        return Container();
                                      }
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16, right: 16),
                                            child: Container(
                                              height: 90,
                                              width: 450,
                                              child: AdvancedMemberCard2(
                                                id: additionalMember.id,
                                                dob: additionalMember.dob,
                                                surname:
                                                    additionalMember.surname,
                                                contact:
                                                    additionalMember.contact,
                                                sourceOfWealth: additionalMember
                                                    .sourceOfWealth,
                                                dateOfBirth:
                                                    additionalMember.dob,
                                                sourceOfIncome: additionalMember
                                                    .sourceOfIncome,
                                                title: additionalMember.title,
                                                name: additionalMember.name,
                                                relationship: additionalMember
                                                    .relationship,
                                                gender: additionalMember.gender,
                                                autoNumber:
                                                    additionalMember.autoNumber,
                                                onSingleTap: () {
                                                  current_member_index = index;
                                                  // print("dgfgfgf $current_member_index");
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                      ),
                    ),*/
                            SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                    if (fieldSalesActiveStep == 4)
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 24,
                            ),
                            const SizedBox(height: 8),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Yes Option
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Constants.currentlyEmployed = true;

                                      Constants.currentleadAvailable!.employer!
                                          .employmentStatus = "Employed";

                                      Constants.isEmployerDetailsSaved = false;

                                      //  print("fgfghhggh ${Constants.currentlyEmployed}");
                                    });
                                  },
                                  child: Container(
                                    height: 60,
                                    width: 150,
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        width: 1.0,
                                        color:
                                            Constants.currentlyEmployed ?? false
                                                ? Constants.ftaColorLight
                                                : Colors.grey.withOpacity(0.35),
                                      ),
                                      color: Colors.transparent,
                                    ),
                                    child: Row(
                                      children: [
                                        Transform.scale(
                                          scaleX: 1.7,
                                          scaleY: 1.7,
                                          child: Checkbox(
                                            value:
                                                Constants.currentlyEmployed ??
                                                    false,
                                            side: BorderSide(
                                                width: 1.4,
                                                color: Constants.ftaColorLight),
                                            activeColor:
                                                Constants.ctaColorLight,
                                            checkColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(360)),
                                            onChanged: (value) {
                                              setState(() {
                                                Constants.currentlyEmployed =
                                                    true;

                                                Constants
                                                        .currentleadAvailable!
                                                        .employer!
                                                        .employmentStatus =
                                                    "Employed";
                                                Constants
                                                        .isEmployerDetailsSaved =
                                                    false;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "Yes",
                                          style: TextStyle(
                                            fontFamily: 'YuGothic',
                                            color: Constants
                                                        .currentlyEmployed ??
                                                    false
                                                ? Constants.ftaColorLight
                                                : Colors.grey.withOpacity(0.35),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                // No Option
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Constants.currentlyEmployed = false;
                                      Constants.currentleadAvailable!.employer!
                                          .employmentStatus = "Unemployed";
                                      Constants.isEmployerDetailsSaved = false;
                                    });
                                  },
                                  child: Container(
                                    height: 60,
                                    width: 150,
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        width: 1.0,
                                        color: !(Constants.currentlyEmployed ??
                                                true)
                                            ? Constants.ftaColorLight
                                            : Colors.grey.withOpacity(0.35),
                                      ),
                                      color: Colors.transparent,
                                    ),
                                    child: Row(
                                      children: [
                                        Transform.scale(
                                          scaleX: 1.7,
                                          scaleY: 1.7,
                                          child: Checkbox(
                                            value:
                                                !(Constants.currentlyEmployed ??
                                                    true),
                                            side: BorderSide(
                                                width: 1.4,
                                                color: Constants.ftaColorLight),
                                            activeColor:
                                                Constants.ctaColorLight,
                                            checkColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(360)),
                                            onChanged: (value) {
                                              setState(() {
                                                Constants.currentlyEmployed =
                                                    false;
                                                Constants
                                                        .currentleadAvailable!
                                                        .employer!
                                                        .employmentStatus =
                                                    "Unemployed";
                                                Constants
                                                        .isEmployerDetailsSaved =
                                                    false;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "No",
                                          style: TextStyle(
                                            fontFamily: 'YuGothic',
                                            color: !(Constants
                                                        .currentlyEmployed ??
                                                    true)
                                                ? Constants.ftaColorLight
                                                : Colors.grey.withOpacity(0.35),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomCard(
                                  elevation: 5,
                                  surfaceTintColor: Colors.white,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.15),
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(12),
                                            topLeft: Radius.circular(12),
                                          ),
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
                                                    const EdgeInsets.all(12.0),
                                                child: Center(
                                                  child: Text(
                                                    "Employer Details",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'YuGothic',
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 24, right: 24),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Employer Name",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'YuGothic',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  CustomInputTransparent4(
                                                    controller:
                                                        employerNameController,
                                                    hintText: 'Employer Name',
                                                    onChanged: (val) {
                                                      Constants
                                                              .isEmployerDetailsSaved =
                                                          false;
                                                      Constants
                                                          .currentleadAvailable!
                                                          .employer!
                                                          .employerName = val;
                                                      setState(() {});
                                                    },
                                                    onSubmitted: (val) {},
                                                    focusNode:
                                                        employerNameFocusNode,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    isPasswordField: false,
                                                  ),
                                                  const SizedBox(height: 24),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 22,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Occupation",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'YuGothic',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  CustomInputTransparent4(
                                                    controller:
                                                        occupationController,
                                                    hintText: 'Occupation',
                                                    onChanged: (val) {
                                                      Constants
                                                              .isEmployerDetailsSaved =
                                                          false;
                                                      setState(() {});
                                                      Constants
                                                          .currentleadAvailable!
                                                          .employer!
                                                          .occupation = val;
                                                    },
                                                    onSubmitted: (val) {
                                                      Constants
                                                              .isEmployerDetailsSaved =
                                                          false;
                                                      setState(() {});
                                                    },
                                                    focusNode:
                                                        occupationFocusNode,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    isPasswordField: false,
                                                  ),
                                                  const SizedBox(height: 24),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 22,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Employee Number",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'YuGothic',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  CustomInputTransparent4(
                                                    controller:
                                                        employeeNumberController,
                                                    hintText: 'Employee Number',
                                                    onChanged: (val) {
                                                      Constants
                                                              .isEmployerDetailsSaved =
                                                          false;
                                                      Constants
                                                          .currentleadAvailable!
                                                          .employer!
                                                          .employeeNumber = val;
                                                      setState(() {});
                                                    },
                                                    onSubmitted: (val) {
                                                      Constants
                                                              .isEmployerDetailsSaved =
                                                          false;
                                                      setState(() {});
                                                    },
                                                    focusNode:
                                                        employeeNumberFocusNode,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    isPasswordField: false,
                                                  ),
                                                  const SizedBox(height: 24),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 24, right: 24),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Salary Range',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'YuGothic',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 12.0,
                                                                  bottom: 4.0),
                                                          child:
                                                              DropdownButtonHideUnderline(
                                                            child:
                                                                DropdownButton2<
                                                                    String>(
                                                              isExpanded: true,
                                                              alignment:
                                                                  AlignmentDirectional
                                                                      .center,
                                                              hint: const Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      ' Select salary range',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontFamily:
                                                                            'YuGothic',
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              items: salaryRange
                                                                  .map((String
                                                                          item) =>
                                                                      DropdownMenuItem<
                                                                          String>(
                                                                        value:
                                                                            item,
                                                                        child:
                                                                            Text(
                                                                          item,
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontFamily:
                                                                                'YuGothic',
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ))
                                                                  .toList(),
                                                              value: selectedSalaryRange ==
                                                                      ""
                                                                  ? null
                                                                  : selectedSalaryRange,
                                                              onChanged:
                                                                  (String?
                                                                      value) {
                                                                setState(() {
                                                                  selectedSalaryRange =
                                                                      value;
                                                                  Constants
                                                                      .currentleadAvailable!
                                                                      .employer!
                                                                      .salaryRange = value!;
                                                                });
                                                              },
                                                              buttonStyleData:
                                                                  ButtonStyleData(
                                                                height: 50,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            14,
                                                                        right:
                                                                            14),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              360),
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .black26,
                                                                  ),
                                                                  color: Colors
                                                                      .transparent,
                                                                ),
                                                                elevation: 0,
                                                              ),
                                                              iconStyleData:
                                                                  const IconStyleData(
                                                                icon: Icon(
                                                                  Icons
                                                                      .arrow_forward_ios_outlined,
                                                                ),
                                                                iconSize: 14,
                                                                iconEnabledColor:
                                                                    Colors
                                                                        .black,
                                                                iconDisabledColor:
                                                                    Colors
                                                                        .transparent,
                                                              ),
                                                              dropdownStyleData:
                                                                  DropdownStyleData(
                                                                elevation: 0,
                                                                maxHeight: 200,
                                                                width: 200,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16),
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                offset:
                                                                    const Offset(
                                                                        -5, 0),
                                                                scrollbarTheme:
                                                                    ScrollbarThemeData(
                                                                  radius: const Radius
                                                                      .circular(
                                                                      40),
                                                                  thickness:
                                                                      WidgetStateProperty
                                                                          .all<double>(
                                                                              6),
                                                                  thumbVisibility:
                                                                      WidgetStateProperty.all<
                                                                              bool>(
                                                                          true),
                                                                ),
                                                              ),
                                                              menuItemStyleData:
                                                                  const MenuItemStyleData(
                                                                overlayColor:
                                                                    null,
                                                                height: 40,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            14,
                                                                        right:
                                                                            14),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 24),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 22,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Salary Day',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'YuGothic',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 12.0,
                                                                  bottom: 4.0),
                                                          child:
                                                              DropdownButtonHideUnderline(
                                                            child:
                                                                DropdownButton2<
                                                                    String>(
                                                              isExpanded: true,
                                                              hint: const Text(
                                                                'Select salary day',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      'YuGothic',
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              items: payDay
                                                                  .map((String
                                                                          item) =>
                                                                      DropdownMenuItem<
                                                                          String>(
                                                                        value:
                                                                            item,
                                                                        // Use the correct item value
                                                                        child:
                                                                            Text(
                                                                          item.toString(),
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontFamily:
                                                                                'YuGothic',
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ))
                                                                  .toList(),
                                                              value: (selectedPayDay ==
                                                                          null ||
                                                                      selectedPayDay!
                                                                          .isEmpty)
                                                                  ? null
                                                                  : selectedPayDay,
                                                              // Ensure null for an empty value
                                                              onChanged:
                                                                  (String?
                                                                      value) {
                                                                Constants
                                                                        .isEmployerDetailsSaved =
                                                                    false;
                                                                setState(() {});
                                                                setState(() {
                                                                  selectedPayDay =
                                                                      value;
                                                                  Constants
                                                                      .currentleadAvailable!
                                                                      .employer!
                                                                      .salaryDay = value!;
                                                                });
                                                              },
                                                              buttonStyleData:
                                                                  ButtonStyleData(
                                                                height: 50,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            14,
                                                                        right:
                                                                            14),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              360),
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .black26),
                                                                  color: Colors
                                                                      .transparent,
                                                                ),
                                                                elevation: 0,
                                                              ),
                                                              iconStyleData:
                                                                  const IconStyleData(
                                                                icon: Icon(Icons
                                                                    .arrow_forward_ios_outlined),
                                                                iconSize: 14,
                                                                iconEnabledColor:
                                                                    Colors
                                                                        .black,
                                                                iconDisabledColor:
                                                                    Colors
                                                                        .transparent,
                                                              ),
                                                              dropdownStyleData:
                                                                  DropdownStyleData(
                                                                elevation: 0,
                                                                maxHeight: 200,
                                                                width: 200,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16),
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                offset:
                                                                    const Offset(
                                                                        -5, 0),
                                                                scrollbarTheme:
                                                                    ScrollbarThemeData(
                                                                  radius: const Radius
                                                                      .circular(
                                                                      40),
                                                                  thickness:
                                                                      WidgetStateProperty
                                                                          .all<double>(
                                                                              6),
                                                                  thumbVisibility:
                                                                      WidgetStateProperty.all<
                                                                              bool>(
                                                                          true),
                                                                ),
                                                              ),
                                                              menuItemStyleData:
                                                                  const MenuItemStyleData(
                                                                overlayColor:
                                                                    null,
                                                                height: 40,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            14,
                                                                        right:
                                                                            14),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 24),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 22,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Salary Frequency',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'YuGothic',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 12.0,
                                                                  bottom: 4.0),
                                                          child:
                                                              DropdownButtonHideUnderline(
                                                            child:
                                                                DropdownButton2<
                                                                    String>(
                                                              isExpanded: true,
                                                              alignment:
                                                                  AlignmentDirectional
                                                                      .center,
                                                              hint: const Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      ' Select salary frequency',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontFamily:
                                                                            'YuGothic',
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              items:
                                                                  salaryFrequency
                                                                      .map((String
                                                                              item) =>
                                                                          DropdownMenuItem<
                                                                              String>(
                                                                            value:
                                                                                item,
                                                                            child:
                                                                                Text(
                                                                              item,
                                                                              style: const TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontFamily: 'YuGothic',
                                                                                color: Colors.black,
                                                                              ),
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ))
                                                                      .toList(),
                                                              value: selectedSalaryFrequency ==
                                                                      ""
                                                                  ? null
                                                                  : selectedSalaryFrequency,
                                                              onChanged:
                                                                  (String?
                                                                      value) {
                                                                setState(() {
                                                                  selectedSalaryFrequency =
                                                                      value;
                                                                  Constants
                                                                      .currentleadAvailable!
                                                                      .employer!
                                                                      .salaryFrequency = value!;
                                                                });
                                                              },
                                                              buttonStyleData:
                                                                  ButtonStyleData(
                                                                height: 50,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            14,
                                                                        right:
                                                                            14),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              360),
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .black26,
                                                                  ),
                                                                  color: Colors
                                                                      .transparent,
                                                                ),
                                                                elevation: 0,
                                                              ),
                                                              iconStyleData:
                                                                  const IconStyleData(
                                                                icon: Icon(
                                                                  Icons
                                                                      .arrow_forward_ios_outlined,
                                                                ),
                                                                iconSize: 14,
                                                                iconEnabledColor:
                                                                    Colors
                                                                        .black,
                                                                iconDisabledColor:
                                                                    Colors
                                                                        .transparent,
                                                              ),
                                                              dropdownStyleData:
                                                                  DropdownStyleData(
                                                                elevation: 0,
                                                                maxHeight: 200,
                                                                width: 200,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16),
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                offset:
                                                                    const Offset(
                                                                        -5, 0),
                                                                scrollbarTheme:
                                                                    ScrollbarThemeData(
                                                                  radius: const Radius
                                                                      .circular(
                                                                      40),
                                                                  thickness:
                                                                      WidgetStateProperty
                                                                          .all<double>(
                                                                              6),
                                                                  thumbVisibility:
                                                                      WidgetStateProperty.all<
                                                                              bool>(
                                                                          true),
                                                                ),
                                                              ),
                                                              menuItemStyleData:
                                                                  const MenuItemStyleData(
                                                                overlayColor:
                                                                    null,
                                                                height: 40,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            14,
                                                                        right:
                                                                            14),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 24),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Spacer(),
                                          TextButton(
                                            onPressed: () {
                                              String employmentstatus =
                                                  Constants
                                                      .currentleadAvailable!
                                                      .employer!
                                                      .employmentStatus;
                                              // 1) Validate employerNameController
                                              if (employerNameController
                                                  .text.isEmpty) {
                                                if (employmentstatus !=
                                                    "Employed") {
                                                  return;
                                                }

                                                MotionToast.error(
                                                  height: 40,
                                                  width: 380,
                                                  description: const Text(
                                                    "Please enter the employer name.",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ).show(context);
                                                return;
                                              }

                                              // 2) Validate occupationController
                                              if (occupationController
                                                  .text.isEmpty) {
                                                if (employmentstatus !=
                                                    "Employed") {
                                                  return;
                                                }
                                                MotionToast.error(
                                                  height: 40,
                                                  width: 380,
                                                  description: const Text(
                                                    "Please enter the occupation.",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ).show(context);
                                                return;
                                              }

                                              // 3) Validate employeeNumberController
                                              if (employeeNumberController
                                                  .text.isEmpty) {
                                                if (employmentstatus !=
                                                    "Employed") {
                                                  return;
                                                }
                                                MotionToast.error(
                                                  height: 40,
                                                  width: 380,
                                                  description: const Text(
                                                    "Please enter the employee number.",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ).show(context);
                                                return;
                                              }

                                              // 4) Validate selectedSalaryRange
                                              if (selectedSalaryRange == null ||
                                                  selectedSalaryRange!
                                                      .isEmpty) {
                                                if (employmentstatus !=
                                                    "Employed") {
                                                  return;
                                                }
                                                MotionToast.error(
                                                  height: 40,
                                                  width: 380,
                                                  description: const Text(
                                                    "Please select a salary range.",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ).show(context);
                                                return;
                                              }

                                              // 5) Validate selectedSalaryFrequency
                                              if (selectedSalaryFrequency ==
                                                      null ||
                                                  selectedSalaryFrequency!
                                                      .isEmpty) {
                                                if (employmentstatus !=
                                                    "Employed") {
                                                  return;
                                                }
                                                MotionToast.error(
                                                  height: 40,
                                                  width: 380,
                                                  description: const Text(
                                                    "Please select a salary frequency.",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ).show(context);
                                                return;
                                              }

                                              // 6) Validate selectedPayDay
                                              if (selectedPayDay == null ||
                                                  selectedPayDay!.isEmpty) {
                                                if (employmentstatus !=
                                                    "Employed") {
                                                  return;
                                                }
                                                MotionToast.error(
                                                  height: 40,
                                                  width: 380,
                                                  description: const Text(
                                                    "Please select a pay day.",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ).show(context);
                                                return;
                                              }
                                              updateEmployersRequest(
                                                employerId: '0',
                                                leadId: Constants
                                                    .currentleadAvailable!
                                                    .leadObject
                                                    .onololeadid!
                                                    .toString(),
                                                employerNameController:
                                                    employerNameController,
                                                occupationController:
                                                    occupationController,
                                                employeeNumberController:
                                                    employeeNumberController,
                                                selectedSalaryRange:
                                                    selectedSalaryRange!,
                                                selectedSalaryFrequency:
                                                    selectedSalaryFrequency!,
                                                selectedPayDay: selectedPayDay!,
                                                employmentStatus: Constants
                                                    .currentleadAvailable!
                                                    .employer!
                                                    .employmentStatus!,
                                              );

                                              setState(() {});
                                            },
                                            style: TextButton.styleFrom(
                                                minimumSize: Size(180, 48),
                                                backgroundColor: Constants
                                                            .isEmployerDetailsSaved ==
                                                        false
                                                    ? Constants.ctaColorLight
                                                    : Colors.grey),
                                            child: const Text(
                                              "Validate and Save",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'YuGothic',
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                      SizedBox(height: 24)
                                    ],
                                  )),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                    if (fieldSalesActiveStep == 3)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 24,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CustomCard(
                                elevation: 5,
                                surfaceTintColor: Colors.white,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: SingleChildScrollView(
                                  physics: NeverScrollableScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.15),
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(12),
                                            topLeft: Radius.circular(12),
                                          ),
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
                                                    const EdgeInsets.all(12.0),
                                                child: Center(
                                                  child: Text(
                                                    "Premium Payer (Banking and Address)",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'YuGothic',
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 24, right: 24, top: 16),
                                        child: Container(
                                          width: 700,
                                          height: 150,
                                          child: premiumPayerMember !=
                                                  AdditionalMember.empty()
                                              ? Row(
                                                  children: [
                                                    Container(
                                                      width: 450,
                                                      height: 135,
                                                      child:
                                                          AdvancedPremiumPayerMemberCard(
                                                        id: premiumPayerMember
                                                            .id,
                                                        dob: premiumPayerMember
                                                            .dob,
                                                        surname:
                                                            premiumPayerMember
                                                                .surname,
                                                        contact:
                                                            premiumPayerMember
                                                                .contact,
                                                        sourceOfWealth:
                                                            premiumPayerMember
                                                                .sourceOfWealth,
                                                        otherUnknownWealth:
                                                            premiumPayerMember
                                                                .otherUnknownWealth,
                                                        otherUnknownIncome:
                                                            premiumPayerMember
                                                                .otherUnknownIncome,
                                                        dateOfBirth:
                                                            premiumPayerMember
                                                                .dob,
                                                        sourceOfIncome:
                                                            premiumPayerMember
                                                                .sourceOfIncome,
                                                        title:
                                                            premiumPayerMember
                                                                .title,
                                                        name: premiumPayerMember
                                                            .name,
                                                        relationship:
                                                            premiumPayerMember
                                                                .relationship,
                                                        gender:
                                                            premiumPayerMember
                                                                .gender,
                                                        autoNumber:
                                                            premiumPayerMember
                                                                .autoNumber,
                                                        isSelected: true,
                                                        isEditing: true,
                                                        current_member_index:
                                                            current_member_index,
                                                        is_self_or_payer: true,
                                                        noOfMembers: 0,
                                                        cover: (policiesSelectedCoverAmounts !=
                                                                    null &&
                                                                current_member_index >=
                                                                    0 &&
                                                                current_member_index <
                                                                    policiesSelectedCoverAmounts
                                                                        .length &&
                                                                policiesSelectedCoverAmounts[
                                                                        current_member_index] !=
                                                                    null)
                                                            ? policiesSelectedCoverAmounts[
                                                                current_member_index]
                                                            : 0.0,
                                                        premium: policyPremiums
                                                                .isEmpty
                                                            ? 0
                                                            : policyPremiums[
                                                                        current_member_index]
                                                                    .memberPremiums
                                                                    .isEmpty
                                                                ? 0
                                                                : policyPremiums[
                                                                        current_member_index]
                                                                    .memberPremiums
                                                                    .first
                                                                    .premium,
                                                        onSingleTap: () {},
                                                        onDoubleTap: () {
                                                          if (Constants
                                                                  .currentleadAvailable ==
                                                              null) {
                                                            return null;
                                                          }
                                                          final List<
                                                                  AdditionalMember>
                                                              allAdditionalMembers =
                                                              Constants
                                                                  .currentleadAvailable!
                                                                  .additionalMembers
                                                                  .where((m) {
                                                            // Ensure dob is not empty
                                                            if (m.relationship ==
                                                                "self")
                                                              return false;

                                                            if (m.dob.isEmpty)
                                                              return false;

                                                            // Parse date and check if age is greater than 18
                                                            return calculateAge(
                                                                    DateTime.parse(
                                                                        m.dob)) >
                                                                18;
                                                          }).toList();

                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    Dialog(
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              elevation: 0.0,
                                                              child:
                                                                  MovingLineDialog(
                                                                child:
                                                                    Container(
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          16),
                                                                  constraints: const BoxConstraints(
                                                                      maxWidth:
                                                                          500,
                                                                      maxHeight:
                                                                          630),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            36),
                                                                  ),
                                                                  child:
                                                                      StatefulBuilder(
                                                                    builder: (context,
                                                                            setState1) =>
                                                                        SingleChildScrollView(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          SizedBox(
                                                                              height: 16),
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
                                                                          SizedBox(
                                                                              height: 8),
                                                                          Center(
                                                                            child:
                                                                                Text(
                                                                              "Change the Premium Payer",
                                                                              style: TextStyle(
                                                                                fontSize: 20,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: Constants.ftaColorLight,
                                                                              ),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 12),
                                                                          const Center(
                                                                            child:
                                                                                Text(
                                                                              "Click on a member below to select them as an premium payer",
                                                                              style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontFamily: 'YuGothic',
                                                                                color: Colors.grey,
                                                                              ),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 16),

                                                                          // -------------------- List of potential additional members --------------------
                                                                          ListView
                                                                              .builder(
                                                                            shrinkWrap:
                                                                                true,
                                                                            itemCount:
                                                                                allAdditionalMembers.length,
                                                                            itemBuilder:
                                                                                (context, index) {
                                                                              final member = allAdditionalMembers[index];

                                                                              return GestureDetector(
                                                                                // -------------------- The additional members UI Card --------------------
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
                                                                                          member.gender.toLowerCase() == "female" ? Icons.female : Icons.male,
                                                                                          size: 24,
                                                                                          color: member.gender.toLowerCase() == "female" ? Colors.pinkAccent : Colors.blueAccent,
                                                                                        ),
                                                                                      ),
                                                                                      const SizedBox(width: 16.0),

                                                                                      // Info
                                                                                      Expanded(
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text(
                                                                                              member.dob.isEmpty ? 'DoB: - ' : '${DateFormat('dd MMM yyyy').format(DateTime.parse(member.dob))}',
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
                                                                                                    onPressed: () async {
                                                                                                      try {
                                                                                                        // Get the current premium payer
                                                                                                        AdditionalMember currentPremiumPayer = premiumPayerMember;

                                                                                                        // Get the selected new premium payer
                                                                                                        AdditionalMember newPremiumPayer = member; // This is the selected member

                                                                                                        print("Changing premium payer from ${currentPremiumPayer.name} to ${newPremiumPayer.name}");

                                                                                                        // Step 1: Determine the old premium payer's new relationship based on the new payer's relationship
                                                                                                        String oldPremiumPayerNewRelationship = getOldPayerRelationship(newPremiumPayer.relationship.toLowerCase(), currentPremiumPayer.relationship.toLowerCase(), currentPremiumPayer);

                                                                                                        // Step 2: Find and update the current premium payer in additionalMembers
                                                                                                        int currentPayerIndex = Constants.currentleadAvailable!.additionalMembers.indexWhere((m) => m.autoNumber == currentPremiumPayer.autoNumber);
                                                                                                        AdditionalMember updatedCurrentPayer = AdditionalMember.empty();
                                                                                                        AdditionalMember updatedNewPayer = AdditionalMember.empty();
                                                                                                        if (currentPayerIndex != -1) {
                                                                                                          // Create updated version of current premium payer with new relationship
                                                                                                          updatedCurrentPayer = AdditionalMember(
                                                                                                            memberType: currentPremiumPayer.memberType,
                                                                                                            autoNumber: currentPremiumPayer.autoNumber,
                                                                                                            id: currentPremiumPayer.id,
                                                                                                            contact: currentPremiumPayer.contact,
                                                                                                            dob: currentPremiumPayer.dob,
                                                                                                            gender: currentPremiumPayer.gender,
                                                                                                            name: currentPremiumPayer.name,
                                                                                                            surname: currentPremiumPayer.surname,
                                                                                                            title: currentPremiumPayer.title,
                                                                                                            onololeadid: currentPremiumPayer.onololeadid,
                                                                                                            altContact: currentPremiumPayer.altContact,
                                                                                                            email: currentPremiumPayer.email,
                                                                                                            percentage: currentPremiumPayer.percentage,
                                                                                                            maritalStatus: currentPremiumPayer.maritalStatus,
                                                                                                            relationship: oldPremiumPayerNewRelationship, // Updated relationship
                                                                                                            mipCover: currentPremiumPayer.mipCover,
                                                                                                            mipStatus: currentPremiumPayer.mipStatus,
                                                                                                            updatedBy: currentPremiumPayer.updatedBy,
                                                                                                            memberQueryType: currentPremiumPayer.memberQueryType,
                                                                                                            memberQueryTypeOldNew: currentPremiumPayer.memberQueryTypeOldNew,
                                                                                                            memberQueryTypeOldAutoNumber: currentPremiumPayer.memberQueryTypeOldAutoNumber,
                                                                                                            membersAutoNumber: currentPremiumPayer.membersAutoNumber,
                                                                                                            sourceOfIncome: currentPremiumPayer.sourceOfIncome,
                                                                                                            sourceOfWealth: currentPremiumPayer.sourceOfWealth,
                                                                                                            otherUnknownIncome: currentPremiumPayer.otherUnknownIncome,
                                                                                                            otherUnknownWealth: currentPremiumPayer.otherUnknownWealth,
                                                                                                            timestamp: currentPremiumPayer.timestamp,
                                                                                                            lastUpdate: DateTime.now().toIso8601String(),
                                                                                                          );

                                                                                                          // Update in the list
                                                                                                          Constants.currentleadAvailable!.additionalMembers[currentPayerIndex] = updatedCurrentPayer;
                                                                                                        }

                                                                                                        // Step 3: Find and update the new premium payer in additionalMembers
                                                                                                        int newPayerIndex = Constants.currentleadAvailable!.additionalMembers.indexWhere((m) => m.autoNumber == newPremiumPayer.autoNumber);

                                                                                                        if (newPayerIndex != -1) {
                                                                                                          // Create updated version of new premium payer with "self" relationship
                                                                                                          updatedNewPayer = AdditionalMember(
                                                                                                            memberType: newPremiumPayer.memberType,
                                                                                                            autoNumber: newPremiumPayer.autoNumber,
                                                                                                            id: newPremiumPayer.id,
                                                                                                            contact: newPremiumPayer.contact,
                                                                                                            dob: newPremiumPayer.dob,
                                                                                                            gender: newPremiumPayer.gender,
                                                                                                            name: newPremiumPayer.name,
                                                                                                            surname: newPremiumPayer.surname,
                                                                                                            title: newPremiumPayer.title,
                                                                                                            onololeadid: newPremiumPayer.onololeadid,
                                                                                                            altContact: newPremiumPayer.altContact,
                                                                                                            email: newPremiumPayer.email,
                                                                                                            percentage: newPremiumPayer.percentage,
                                                                                                            maritalStatus: newPremiumPayer.maritalStatus,
                                                                                                            relationship: "self", // New premium payer becomes "self"
                                                                                                            mipCover: newPremiumPayer.mipCover,
                                                                                                            mipStatus: newPremiumPayer.mipStatus,
                                                                                                            updatedBy: newPremiumPayer.updatedBy,
                                                                                                            memberQueryType: newPremiumPayer.memberQueryType,
                                                                                                            memberQueryTypeOldNew: newPremiumPayer.memberQueryTypeOldNew,
                                                                                                            memberQueryTypeOldAutoNumber: newPremiumPayer.memberQueryTypeOldAutoNumber,
                                                                                                            membersAutoNumber: newPremiumPayer.membersAutoNumber,
                                                                                                            sourceOfIncome: newPremiumPayer.sourceOfIncome,
                                                                                                            sourceOfWealth: newPremiumPayer.sourceOfWealth,
                                                                                                            otherUnknownIncome: newPremiumPayer.otherUnknownIncome,
                                                                                                            otherUnknownWealth: newPremiumPayer.otherUnknownWealth,
                                                                                                            timestamp: newPremiumPayer.timestamp,
                                                                                                            lastUpdate: DateTime.now().toIso8601String(),
                                                                                                          );

                                                                                                          // Update in the list
                                                                                                          Constants.currentleadAvailable!.additionalMembers[newPayerIndex] = updatedNewPayer;

                                                                                                          // Update the premium payer reference
                                                                                                          premiumPayerMember = updatedNewPayer;
                                                                                                        }

                                                                                                        // Step 4: Update mainMembers if needed
                                                                                                        int mainMemberIndex = mainMembers.indexWhere(
                                                                                                          (member) => member.autoNumber == currentPremiumPayer.autoNumber,
                                                                                                        );
                                                                                                        if (mainMemberIndex != -1) {
                                                                                                          mainMembers[mainMemberIndex] = Constants.currentleadAvailable!.additionalMembers[currentPayerIndex];
                                                                                                        }

                                                                                                        // Update new premium payer in mainMembers
                                                                                                        int newMainMemberIndex = mainMembers.indexWhere(
                                                                                                          (member) => member.autoNumber == newPremiumPayer.autoNumber,
                                                                                                        );
                                                                                                        if (newMainMemberIndex != -1) {
                                                                                                          mainMembers[newMainMemberIndex] = Constants.currentleadAvailable!.additionalMembers[newPayerIndex];
                                                                                                        }

                                                                                                        // Step 5: Call updateMember for both members to sync with backend
                                                                                                        if (updatedCurrentPayer != AdditionalMember.empty()) await updateMemberBackend(context, currentPremiumPayer.autoNumber, updatedCurrentPayer);
                                                                                                        if (updatedNewPayer != AdditionalMember.empty()) await updateMemberBackend(context, newPremiumPayer.autoNumber, updatedNewPayer);

                                                                                                        // Step 6: Notify UI to refresh
                                                                                                        needsAnalysisValueNotifier2.value++;
                                                                                                        //mySalesPremiumCalculatorValue.value++;

                                                                                                        print("Premium payer changed successfully");

                                                                                                        // Close the dialog
                                                                                                        Navigator.of(context).pop();
                                                                                                      } catch (e) {
                                                                                                        print("Error changing premium payer: $e");
                                                                                                        // Show error message to user if needed
                                                                                                      }
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
                                                                                                      foregroundColor: Constants.ctaColorLight,
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
                                                                          const SizedBox(
                                                                              height: 16),
                                                                          // Optionally, a button to add a new partner manually.
                                                                          Center(
                                                                            child:
                                                                                TextButton.icon(
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
                                                                                                maxWidth: (Constants.currentleadAvailable!.leadObject.documentsIndexed.isEmpty) ? 750 : 1200,
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
                                                                                              child: NewMemberDialog2(
                                                                                                isEditMode: false,
                                                                                                autoNumber: 0,
                                                                                                relationship: "Partner",
                                                                                                title: "",
                                                                                                name: "",
                                                                                                surname: "",
                                                                                                dob: "",
                                                                                                gender: "",
                                                                                                current_member_index: current_member_index,
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
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                              style: TextButton.styleFrom(
                                                                                foregroundColor: Colors.teal,
                                                                                backgroundColor: Constants.ctaColorLight,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 16),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(width: 16),
                                                    InkWell(
                                                      onTap: () {
                                                        if (Constants
                                                                .currentleadAvailable ==
                                                            null) {
                                                          return null;
                                                        }
                                                        final List<
                                                                AdditionalMember>
                                                            allAdditionalMembers =
                                                            Constants
                                                                .currentleadAvailable!
                                                                .additionalMembers
                                                                .where((m) {
                                                          // Ensure dob is not empty
                                                          if (m.relationship ==
                                                              "self")
                                                            return false;

                                                          if (m.dob.isEmpty)
                                                            return false;

                                                          // Parse date and check if age is greater than 18
                                                          return calculateAge(
                                                                  DateTime.parse(
                                                                      m.dob)) >
                                                              18;
                                                        }).toList();

                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              Dialog(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            elevation: 0.0,
                                                            child:
                                                                MovingLineDialog(
                                                              child: Container(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        16),
                                                                constraints:
                                                                    const BoxConstraints(
                                                                        maxWidth:
                                                                            500,
                                                                        maxHeight:
                                                                            630),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              36),
                                                                ),
                                                                child:
                                                                    StatefulBuilder(
                                                                  builder: (context,
                                                                          setState1) =>
                                                                      SingleChildScrollView(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        SizedBox(
                                                                            height:
                                                                                16),
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
                                                                        SizedBox(
                                                                            height:
                                                                                8),
                                                                        Center(
                                                                          child:
                                                                              Text(
                                                                            "Change the Premium Payer",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Constants.ftaColorLight,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                12),
                                                                        const Center(
                                                                          child:
                                                                              Text(
                                                                            "Click on a member below to select them as an premium payer",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontFamily: 'YuGothic',
                                                                              color: Colors.grey,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                16),

                                                                        // -------------------- List of potential additional members --------------------
                                                                        ListView
                                                                            .builder(
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemCount:
                                                                              allAdditionalMembers.length,
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            final member =
                                                                                allAdditionalMembers[index];

                                                                            return GestureDetector(
                                                                              // -------------------- The additional members UI Card --------------------
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
                                                                                        member.gender.toLowerCase() == "female" ? Icons.female : Icons.male,
                                                                                        size: 24,
                                                                                        color: member.gender.toLowerCase() == "female" ? Colors.pinkAccent : Colors.blueAccent,
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(width: 16.0),

                                                                                    // Info
                                                                                    Expanded(
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(
                                                                                            member.dob.isEmpty ? 'DoB: - ' : '${DateFormat('dd MMM yyyy').format(DateTime.parse(member.dob))}',
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
                                                                                                  onPressed: () async {
                                                                                                    try {
                                                                                                      // Get the current premium payer
                                                                                                      AdditionalMember currentPremiumPayer = premiumPayerMember;

                                                                                                      // Get the selected new premium payer
                                                                                                      AdditionalMember newPremiumPayer = member; // This is the selected member

                                                                                                      print("Changing premium payer from ${currentPremiumPayer.name} to ${newPremiumPayer.name}");

                                                                                                      // Step 1: Determine the old premium payer's new relationship based on the new payer's relationship
                                                                                                      String oldPremiumPayerNewRelationship = getOldPayerRelationship(newPremiumPayer.relationship.toLowerCase(), currentPremiumPayer.relationship.toLowerCase(), currentPremiumPayer);

                                                                                                      // Step 2: Find and update the current premium payer in additionalMembers
                                                                                                      int currentPayerIndex = Constants.currentleadAvailable!.additionalMembers.indexWhere((m) => m.autoNumber == currentPremiumPayer.autoNumber);
                                                                                                      AdditionalMember updatedCurrentPayer = AdditionalMember.empty();
                                                                                                      AdditionalMember updatedNewPayer = AdditionalMember.empty();
                                                                                                      if (currentPayerIndex != -1) {
                                                                                                        // Create updated version of current premium payer with new relationship
                                                                                                        updatedCurrentPayer = AdditionalMember(
                                                                                                          memberType: currentPremiumPayer.memberType,
                                                                                                          autoNumber: currentPremiumPayer.autoNumber,
                                                                                                          id: currentPremiumPayer.id,
                                                                                                          contact: currentPremiumPayer.contact,
                                                                                                          dob: currentPremiumPayer.dob,
                                                                                                          gender: currentPremiumPayer.gender,
                                                                                                          name: currentPremiumPayer.name,
                                                                                                          surname: currentPremiumPayer.surname,
                                                                                                          title: currentPremiumPayer.title,
                                                                                                          onololeadid: currentPremiumPayer.onololeadid,
                                                                                                          altContact: currentPremiumPayer.altContact,
                                                                                                          email: currentPremiumPayer.email,
                                                                                                          percentage: currentPremiumPayer.percentage,
                                                                                                          maritalStatus: currentPremiumPayer.maritalStatus,
                                                                                                          relationship: oldPremiumPayerNewRelationship, // Updated relationship
                                                                                                          mipCover: currentPremiumPayer.mipCover,
                                                                                                          mipStatus: currentPremiumPayer.mipStatus,
                                                                                                          updatedBy: currentPremiumPayer.updatedBy,
                                                                                                          memberQueryType: currentPremiumPayer.memberQueryType,
                                                                                                          memberQueryTypeOldNew: currentPremiumPayer.memberQueryTypeOldNew,
                                                                                                          memberQueryTypeOldAutoNumber: currentPremiumPayer.memberQueryTypeOldAutoNumber,
                                                                                                          membersAutoNumber: currentPremiumPayer.membersAutoNumber,
                                                                                                          sourceOfIncome: currentPremiumPayer.sourceOfIncome,
                                                                                                          sourceOfWealth: currentPremiumPayer.sourceOfWealth,
                                                                                                          otherUnknownIncome: currentPremiumPayer.otherUnknownIncome,
                                                                                                          otherUnknownWealth: currentPremiumPayer.otherUnknownWealth,
                                                                                                          timestamp: currentPremiumPayer.timestamp,
                                                                                                          lastUpdate: DateTime.now().toIso8601String(),
                                                                                                        );

                                                                                                        // Update in the list
                                                                                                        Constants.currentleadAvailable!.additionalMembers[currentPayerIndex] = updatedCurrentPayer;
                                                                                                      }

                                                                                                      // Step 3: Find and update the new premium payer in additionalMembers
                                                                                                      int newPayerIndex = Constants.currentleadAvailable!.additionalMembers.indexWhere((m) => m.autoNumber == newPremiumPayer.autoNumber);

                                                                                                      if (newPayerIndex != -1) {
                                                                                                        // Create updated version of new premium payer with "self" relationship
                                                                                                        updatedNewPayer = AdditionalMember(
                                                                                                          memberType: newPremiumPayer.memberType,
                                                                                                          autoNumber: newPremiumPayer.autoNumber,
                                                                                                          id: newPremiumPayer.id,
                                                                                                          contact: newPremiumPayer.contact,
                                                                                                          dob: newPremiumPayer.dob,
                                                                                                          gender: newPremiumPayer.gender,
                                                                                                          name: newPremiumPayer.name,
                                                                                                          surname: newPremiumPayer.surname,
                                                                                                          title: newPremiumPayer.title,
                                                                                                          onololeadid: newPremiumPayer.onololeadid,
                                                                                                          altContact: newPremiumPayer.altContact,
                                                                                                          email: newPremiumPayer.email,
                                                                                                          percentage: newPremiumPayer.percentage,
                                                                                                          maritalStatus: newPremiumPayer.maritalStatus,
                                                                                                          relationship: "self", // New premium payer becomes "self"
                                                                                                          mipCover: newPremiumPayer.mipCover,
                                                                                                          mipStatus: newPremiumPayer.mipStatus,
                                                                                                          updatedBy: newPremiumPayer.updatedBy,
                                                                                                          memberQueryType: newPremiumPayer.memberQueryType,
                                                                                                          memberQueryTypeOldNew: newPremiumPayer.memberQueryTypeOldNew,
                                                                                                          memberQueryTypeOldAutoNumber: newPremiumPayer.memberQueryTypeOldAutoNumber,
                                                                                                          membersAutoNumber: newPremiumPayer.membersAutoNumber,
                                                                                                          sourceOfIncome: newPremiumPayer.sourceOfIncome,
                                                                                                          sourceOfWealth: newPremiumPayer.sourceOfWealth,
                                                                                                          otherUnknownIncome: newPremiumPayer.otherUnknownIncome,
                                                                                                          otherUnknownWealth: newPremiumPayer.otherUnknownWealth,
                                                                                                          timestamp: newPremiumPayer.timestamp,
                                                                                                          lastUpdate: DateTime.now().toIso8601String(),
                                                                                                        );

                                                                                                        // Update in the list
                                                                                                        Constants.currentleadAvailable!.additionalMembers[newPayerIndex] = updatedNewPayer;

                                                                                                        // Update the premium payer reference
                                                                                                        premiumPayerMember = updatedNewPayer;
                                                                                                      }

                                                                                                      // Step 4: Update mainMembers if needed
                                                                                                      int mainMemberIndex = mainMembers.indexWhere(
                                                                                                        (member) => member.autoNumber == currentPremiumPayer.autoNumber,
                                                                                                      );
                                                                                                      if (mainMemberIndex != -1) {
                                                                                                        mainMembers[mainMemberIndex] = Constants.currentleadAvailable!.additionalMembers[currentPayerIndex];
                                                                                                      }

                                                                                                      // Update new premium payer in mainMembers
                                                                                                      int newMainMemberIndex = mainMembers.indexWhere(
                                                                                                        (member) => member.autoNumber == newPremiumPayer.autoNumber,
                                                                                                      );
                                                                                                      if (newMainMemberIndex != -1) {
                                                                                                        mainMembers[newMainMemberIndex] = Constants.currentleadAvailable!.additionalMembers[newPayerIndex];
                                                                                                      }

                                                                                                      // Step 5: Call updateMember for both members to sync with backend
                                                                                                      if (updatedCurrentPayer != AdditionalMember.empty()) await updateMemberBackend(context, currentPremiumPayer.autoNumber, updatedCurrentPayer);
                                                                                                      if (updatedNewPayer != AdditionalMember.empty()) await updateMemberBackend(context, newPremiumPayer.autoNumber, updatedNewPayer);

                                                                                                      // Step 6: Notify UI to refresh
                                                                                                      needsAnalysisValueNotifier2.value++;
                                                                                                      //mySalesPremiumCalculatorValue.value++;

                                                                                                      print("Premium payer changed successfully");

                                                                                                      // Close the dialog
                                                                                                      Navigator.of(context).pop();
                                                                                                    } catch (e) {
                                                                                                      print("Error changing premium payer: $e");
                                                                                                      // Show error message to user if needed
                                                                                                    }
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
                                                                                                    foregroundColor: Constants.ctaColorLight,
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
                                                                        const SizedBox(
                                                                            height:
                                                                                16),
                                                                        // Optionally, a button to add a new partner manually.
                                                                        Center(
                                                                          child:
                                                                              TextButton.icon(
                                                                            onPressed:
                                                                                () {
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
                                                                                              maxWidth: (Constants.currentleadAvailable!.leadObject.documentsIndexed.isEmpty) ? 750 : 1200,
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
                                                                                            child: NewMemberDialog2(
                                                                                              isEditMode: false,
                                                                                              autoNumber: 0,
                                                                                              relationship: "Partner",
                                                                                              title: "",
                                                                                              name: "",
                                                                                              surname: "",
                                                                                              dob: "",
                                                                                              gender: "",
                                                                                              current_member_index: current_member_index,
                                                                                              canAddMember: false,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ));
                                                                            },
                                                                            icon:
                                                                                const Icon(
                                                                              Icons.add,
                                                                              color: Colors.white,
                                                                            ),
                                                                            label:
                                                                                const Text(
                                                                              'Add New Member',
                                                                              style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontFamily: 'YuGothic',
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                            style:
                                                                                TextButton.styleFrom(
                                                                              foregroundColor: Colors.teal,
                                                                              backgroundColor: Constants.ctaColorLight,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                16),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        width: 190,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 16,
                                                                right: 16),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      360),
                                                          color: Constants
                                                              .ftaColorLight,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "Change Premium Payer",
                                                            style: GoogleFonts
                                                                .lato(
                                                              textStyle: TextStyle(
                                                                  fontSize: 13,
                                                                  fontFamily:
                                                                      'YuGothic',
                                                                  letterSpacing:
                                                                      0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      /*onTap: () {
                                                                         if (activeClientServicingStepFieldAffinity == createLeadStepsList.length - 1) {
                                                                           return;
                                                                         }
                                                                         SalesService salesService = SalesService();
                                                                         salesService.updateLeadDetails(context);
                                                                         print("ddfdfdfg ${activeClientServicingStepFieldAffinity}");
                                                                         if (activeClientServicingStepFieldAffinity == 2) {
                                                                           SalesService salesservice = new SalesService();
                                                                           salesservice.updatePolicy(
                                                                               Constants.currentleadAvailable!, context);
                                                                         }

                                                                         setState(() {
                                                                           if (activeClientServicingStepFieldAffinity < createLeadStepsList.length) {
                                                                             activeClientServicingStepFieldAffinity++;
                                                                             client_servicing_module_index =
                                                                                 createLeadStepsList[activeClientServicingStepFieldAffinity].item_id;
                                                                             stepName = createLeadStepsList[activeClientServicingStepFieldAffinity].itemName;
                                                                           } else {
                                                                             activeClientServicingStepFieldAffinity = 0;
                                                                             client_servicing_module_index = createLeadStepsList[0].item_id;
                                                                             stepName = createLeadStepsList[0].itemName;
                                                                           }
                                                                         });
                                                                       },*/
                                                    ),
                                                  ],
                                                )
                                              : AdvancedPremiumPayerMemberCard(
                                                  id: mainMembers[
                                                          current_member_index]
                                                      .id,
                                                  dob: mainMembers[
                                                          current_member_index]
                                                      .dob,
                                                  surname: mainMembers[
                                                          current_member_index]
                                                      .surname,
                                                  contact: mainMembers[
                                                          current_member_index]
                                                      .contact,
                                                  sourceOfWealth: mainMembers[
                                                          current_member_index]
                                                      .sourceOfWealth,
                                                  otherUnknownWealth: mainMembers[
                                                          current_member_index]
                                                      .otherUnknownWealth,
                                                  otherUnknownIncome: mainMembers[
                                                          current_member_index]
                                                      .otherUnknownIncome,
                                                  dateOfBirth: mainMembers[
                                                          current_member_index]
                                                      .dob,
                                                  sourceOfIncome: mainMembers[
                                                          current_member_index]
                                                      .sourceOfIncome,
                                                  title: mainMembers[
                                                          current_member_index]
                                                      .title,
                                                  name: mainMembers[
                                                          current_member_index]
                                                      .name,
                                                  relationship: mainMembers[
                                                          current_member_index]
                                                      .relationship,
                                                  gender: mainMembers[
                                                          current_member_index]
                                                      .gender,
                                                  autoNumber: mainMembers[
                                                          current_member_index]
                                                      .autoNumber,
                                                  isSelected: true,
                                                  isEditing: true,
                                                  current_member_index:
                                                      current_member_index,
                                                  is_self_or_payer: true,
                                                  noOfMembers: 0,
                                                  cover:
                                                      policiesSelectedCoverAmounts[
                                                          current_member_index],
                                                  premium: policyPremiums
                                                          .isEmpty
                                                      ? 0
                                                      : policyPremiums[
                                                                  current_member_index]
                                                              .memberPremiums
                                                              .isEmpty
                                                          ? 0
                                                          : policyPremiums[
                                                                  current_member_index]
                                                              .memberPremiums
                                                              .first
                                                              .premium,
                                                  onSingleTap: () {},
                                                  onDoubleTap: () {},
                                                ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 24, right: 24),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: const Text(
                                                      'Payment Type',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'YuGothic',
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 0),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 8.0,
                                                                  bottom: 4.0),
                                                          child:
                                                              DropdownButtonHideUnderline(
                                                            child:
                                                                DropdownButton2<
                                                                    String>(
                                                              isExpanded: true,
                                                              alignment:
                                                                  AlignmentDirectional
                                                                      .center,
                                                              hint: const Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      ' Select payment type',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontFamily:
                                                                            'YuGothic',
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              items: paymentType
                                                                  .map((String
                                                                          item) =>
                                                                      DropdownMenuItem<
                                                                          String>(
                                                                        value:
                                                                            item,
                                                                        child:
                                                                            Text(
                                                                          item.toTitleCase(),
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontFamily:
                                                                                'YuGothic',
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ))
                                                                  .toList(),
                                                              value:
                                                                  _selectedPaymentType,
                                                              onChanged:
                                                                  (String?
                                                                      value) {
                                                                setState(() {
                                                                  _selectedPaymentType =
                                                                      value;
                                                                });
                                                                Constants
                                                                    .currentleadAvailable!
                                                                    .leadObject
                                                                    .paymentType = value!;

                                                                // Auto-fill account holder name when Debit Order is selected
                                                                if (value.toLowerCase() ==
                                                                        "Debit Order"
                                                                            .toLowerCase() &&
                                                                    accountHolderController
                                                                        .text
                                                                        .toString()
                                                                        .isEmpty) {
                                                                  accountHolderController
                                                                      .text = (Constants
                                                                              .currentleadAvailable
                                                                              ?.additionalMembers
                                                                              .first
                                                                              .title ??
                                                                          "") +
                                                                      " " +
                                                                      (Constants
                                                                              .currentleadAvailable!
                                                                              .additionalMembers
                                                                              .first
                                                                              .name ??
                                                                          "") +
                                                                      " " +
                                                                      (Constants
                                                                              .currentleadAvailable!
                                                                              .additionalMembers
                                                                              .first
                                                                              .surname ??
                                                                          "");
                                                                  setState(
                                                                      () {});
                                                                }
                                                              },
                                                              buttonStyleData:
                                                                  ButtonStyleData(
                                                                height: 50,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            14,
                                                                        right:
                                                                            14),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              360),
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .black26,
                                                                  ),
                                                                  color: Colors
                                                                      .transparent,
                                                                ),
                                                                elevation: 0,
                                                              ),
                                                              iconStyleData:
                                                                  const IconStyleData(
                                                                icon: Icon(
                                                                  Icons
                                                                      .arrow_forward_ios_outlined,
                                                                ),
                                                                iconSize: 14,
                                                                iconEnabledColor:
                                                                    Colors
                                                                        .black,
                                                                iconDisabledColor:
                                                                    Colors
                                                                        .transparent,
                                                              ),
                                                              dropdownStyleData:
                                                                  DropdownStyleData(
                                                                elevation: 0,
                                                                maxHeight: 200,
                                                                width: 200,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16),
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                offset:
                                                                    const Offset(
                                                                        -5, 0),
                                                                scrollbarTheme:
                                                                    ScrollbarThemeData(
                                                                  radius: const Radius
                                                                      .circular(
                                                                      40),
                                                                  thickness:
                                                                      WidgetStateProperty
                                                                          .all<double>(
                                                                              6),
                                                                  thumbVisibility:
                                                                      WidgetStateProperty.all<
                                                                              bool>(
                                                                          true),
                                                                ),
                                                              ),
                                                              menuItemStyleData:
                                                                  const MenuItemStyleData(
                                                                overlayColor:
                                                                    null,
                                                                height: 40,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            14,
                                                                        right:
                                                                            14),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 16),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 22,
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0, top: 8),
                                                    child: Text(
                                                      "Debit Day",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'YuGothic',
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 0),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 8.0,
                                                                  bottom: 4.0),
                                                          child:
                                                              DropdownButtonHideUnderline(
                                                            child:
                                                                DropdownButton2<
                                                                    String>(
                                                              isExpanded: true,
                                                              alignment:
                                                                  AlignmentDirectional
                                                                      .center,
                                                              hint: const Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      ' Debit Day',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontFamily:
                                                                            'YuGothic',
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              items: Constants
                                                                  .debitDays
                                                                  .map((String
                                                                          item) =>
                                                                      DropdownMenuItem<
                                                                          String>(
                                                                        value:
                                                                            item,
                                                                        child:
                                                                            Text(
                                                                          item,
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontFamily:
                                                                                'YuGothic',
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ))
                                                                  .toList(),
                                                              value:
                                                                  _selectedDebitDay,
                                                              onChanged:
                                                                  (String?
                                                                      value) {
                                                                if (value !=
                                                                    null) {
                                                                  // Validation logic converted from JavaScript
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          Constants
                                                                              .currentleadAvailable!
                                                                              .policies
                                                                              .length;
                                                                      i++) {
                                                                    var policy =
                                                                        Constants
                                                                            .currentleadAvailable!
                                                                            .policies[i];
                                                                    var incDate =
                                                                        DateTime.parse((policy.quote.inceptionDate ??
                                                                                "")
                                                                            .toString());
                                                                    var todayDate =
                                                                        DateTime
                                                                            .now();
                                                                    var lastDay = DateTime(
                                                                        todayDate
                                                                            .year,
                                                                        todayDate.month +
                                                                            1,
                                                                        0);

                                                                    if (policy
                                                                            .quote
                                                                            .acceptPolicy ==
                                                                        'yes') {
                                                                      // Check if debit day is invalid for current month inception
                                                                      if (int.parse(value) <=
                                                                              todayDate
                                                                                  .day &&
                                                                          incDate.month ==
                                                                              todayDate.month) {
                                                                        showErrorMessage(
                                                                            'Invalid Debit Day, Please change a commencement date for Policy : ${policy.quote.reference} (${policy.quote.productType})');
                                                                        setState(
                                                                            () {
                                                                          _selectedDebitDay =
                                                                              null;
                                                                        });
                                                                        return;
                                                                      }

                                                                      // Check for next month inception with late debit day
                                                                      if (todayDate.day <=
                                                                              10 &&
                                                                          incDate.month >
                                                                              todayDate
                                                                                  .month &&
                                                                          int.parse(value) >
                                                                              20) {
                                                                        showErrorMessage(
                                                                            'Please note that Policy Inception date of next month is far out. Encourage the client to Incept this month and enjoy full cover upon receipt of the first premium.<br> Policy : ${policy.quote.reference} (${policy.quote.productType})');
                                                                        setState(
                                                                            () {
                                                                          _selectedDebitDay =
                                                                              null;
                                                                        });
                                                                        return;
                                                                      }

                                                                      // Commented out validation (as in original JavaScript)
                                                                      // if (int.parse(value) <= (todayDate.day + 7) && incDate.month == todayDate.month) {
                                                                      //   // Show special date modal logic would go here
                                                                      //   // tempDay = value;
                                                                      //   // setState(() {
                                                                      //   //   _selectedDebitDay = null;
                                                                      //   // });
                                                                      //   // return;
                                                                      // }
                                                                    }
                                                                  }

                                                                  // If validation passes, update the values
                                                                  setState(() {
                                                                    Constants
                                                                        .currentleadAvailable!
                                                                        .policies
                                                                        .first
                                                                        .premiumPayer!
                                                                        .collectionday = value;
                                                                    _selectedDebitDay =
                                                                        value;
                                                                  });
                                                                }
                                                              },
                                                              buttonStyleData:
                                                                  ButtonStyleData(
                                                                height: 50,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            14,
                                                                        right:
                                                                            14),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              360),
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .black26,
                                                                  ),
                                                                  color: Colors
                                                                      .transparent,
                                                                ),
                                                                elevation: 0,
                                                              ),
                                                              iconStyleData:
                                                                  const IconStyleData(
                                                                icon: Icon(
                                                                  Icons
                                                                      .arrow_forward_ios_outlined,
                                                                ),
                                                                iconSize: 14,
                                                                iconEnabledColor:
                                                                    Colors
                                                                        .black,
                                                                iconDisabledColor:
                                                                    Colors
                                                                        .transparent,
                                                              ),
                                                              dropdownStyleData:
                                                                  DropdownStyleData(
                                                                elevation: 0,
                                                                maxHeight: 200,
                                                                width: 200,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16),
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                offset:
                                                                    const Offset(
                                                                        -5, 0),
                                                                scrollbarTheme:
                                                                    ScrollbarThemeData(
                                                                  radius: const Radius
                                                                      .circular(
                                                                      40),
                                                                  thickness:
                                                                      WidgetStateProperty
                                                                          .all<double>(
                                                                              6),
                                                                  thumbVisibility:
                                                                      WidgetStateProperty.all<
                                                                              bool>(
                                                                          true),
                                                                ),
                                                              ),
                                                              menuItemStyleData:
                                                                  const MenuItemStyleData(
                                                                overlayColor:
                                                                    null,
                                                                height: 40,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            14,
                                                                        right:
                                                                            14),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 24),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 22,
                                            ),
                                            Constants.currentleadAvailable!
                                                        .policies.length ==
                                                    1
                                                ? Container()
                                                : Expanded(
                                                    flex: 2,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0,
                                                                  top: 8),
                                                          child: Text(
                                                            "Combine Premium",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'YuGothic',
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 0),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            8.0,
                                                                        bottom:
                                                                            4.0),
                                                                child:
                                                                    DropdownButtonHideUnderline(
                                                                  child:
                                                                      DropdownButton2<
                                                                          String>(
                                                                    isExpanded:
                                                                        true,
                                                                    alignment:
                                                                        AlignmentDirectional
                                                                            .center,
                                                                    hint:
                                                                        const Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              4,
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            ' Combine Premium',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontFamily: 'YuGothic',
                                                                            ),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    items: Constants
                                                                        .yesNoOptionsList
                                                                        .map((String
                                                                                item) =>
                                                                            DropdownMenuItem<String>(
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
                                                                            ))
                                                                        .toList(),
                                                                    value:
                                                                        _selectedCombinePremium,
                                                                    onChanged: Constants.currentleadAvailable!.policies.length ==
                                                                            1
                                                                        ? null
                                                                        : (String?
                                                                            value) {
                                                                            setState(() {
                                                                              _selectedCombinePremium = value;
                                                                              Constants.currentleadAvailable!.policies.first.premiumPayer.combinePremium = value!;
                                                                            });
                                                                          },
                                                                    buttonStyleData:
                                                                        ButtonStyleData(
                                                                      height:
                                                                          50,
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              14,
                                                                          right:
                                                                              14),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(360),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              Colors.black26,
                                                                        ),
                                                                        color: Colors
                                                                            .transparent,
                                                                      ),
                                                                      elevation:
                                                                          0,
                                                                    ),
                                                                    iconStyleData:
                                                                        const IconStyleData(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .arrow_forward_ios_outlined,
                                                                      ),
                                                                      iconSize:
                                                                          14,
                                                                      iconEnabledColor:
                                                                          Colors
                                                                              .black,
                                                                      iconDisabledColor:
                                                                          Colors
                                                                              .transparent,
                                                                    ),
                                                                    dropdownStyleData:
                                                                        DropdownStyleData(
                                                                      elevation:
                                                                          0,
                                                                      maxHeight:
                                                                          200,
                                                                      width:
                                                                          200,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(16),
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      offset:
                                                                          const Offset(
                                                                              -5,
                                                                              0),
                                                                      scrollbarTheme:
                                                                          ScrollbarThemeData(
                                                                        radius: const Radius
                                                                            .circular(
                                                                            40),
                                                                        thickness:
                                                                            WidgetStateProperty.all<double>(6),
                                                                        thumbVisibility:
                                                                            WidgetStateProperty.all<bool>(true),
                                                                      ),
                                                                    ),
                                                                    menuItemStyleData:
                                                                        const MenuItemStyleData(
                                                                      overlayColor:
                                                                          null,
                                                                      height:
                                                                          40,
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              14,
                                                                          right:
                                                                              14),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 24),
                                                      ],
                                                    ),
                                                  ),
                                            SizedBox(
                                              width: 22,
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      if (_selectedPaymentType == "Debit Order")
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 24, right: 24),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Text(
                                                        "Bank Institution",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic',
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 0),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 8.0,
                                                                    bottom:
                                                                        4.0),
                                                            child:
                                                                DropdownButtonHideUnderline(
                                                              child:
                                                                  DropdownButton2<
                                                                      String>(
                                                                isExpanded:
                                                                    true,
                                                                alignment:
                                                                    AlignmentDirectional
                                                                        .center,
                                                                hint: const Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 4,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        ' Bank types',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontFamily:
                                                                              'YuGothic',
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                items: Constants
                                                                    .banksList
                                                                    .map((String
                                                                            item) =>
                                                                        DropdownMenuItem<
                                                                            String>(
                                                                          value:
                                                                              item,
                                                                          child:
                                                                              Text(
                                                                            item,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontFamily: 'YuGothic',
                                                                              color: Colors.black,
                                                                            ),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ))
                                                                    .toList(),
                                                                value:
                                                                    _selectedBankTypes,
                                                                onChanged: _selectedPaymentType !=
                                                                        "Debit Order"
                                                                    ? null
                                                                    : (String?
                                                                        value) {
                                                                        setState(
                                                                            () {
                                                                          _selectedBankTypes =
                                                                              value;
                                                                          // Find the bank map where the "name" matches the selected value.
                                                                          var selectedBank = Constants
                                                                              .banksListWithCountryCodes
                                                                              .firstWhere(
                                                                            (bank) =>
                                                                                bank["name"] ==
                                                                                value,
                                                                            orElse: () =>
                                                                                {},
                                                                          );
                                                                          // Set the branch code controller text to the bank's "id"
                                                                          branchCodeController.text =
                                                                              selectedBank["id"] ?? "";
                                                                          branchNameController.text =
                                                                              "UNIVERSAL";
                                                                        });
                                                                      },
                                                                buttonStyleData:
                                                                    ButtonStyleData(
                                                                  height: 50,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              14,
                                                                          right:
                                                                              14),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            360),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .black26,
                                                                    ),
                                                                    color: Colors
                                                                        .transparent,
                                                                  ),
                                                                  elevation: 0,
                                                                ),
                                                                iconStyleData:
                                                                    const IconStyleData(
                                                                  icon: Icon(
                                                                    Icons
                                                                        .arrow_forward_ios_outlined,
                                                                  ),
                                                                  iconSize: 14,
                                                                  iconEnabledColor:
                                                                      Colors
                                                                          .black,
                                                                  iconDisabledColor:
                                                                      Colors
                                                                          .transparent,
                                                                ),
                                                                dropdownStyleData:
                                                                    DropdownStyleData(
                                                                  elevation: 0,
                                                                  maxHeight:
                                                                      200,
                                                                  width: 200,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16),
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  offset:
                                                                      const Offset(
                                                                          -5,
                                                                          0),
                                                                  scrollbarTheme:
                                                                      ScrollbarThemeData(
                                                                    radius: const Radius
                                                                        .circular(
                                                                        40),
                                                                    thickness:
                                                                        WidgetStateProperty.all<
                                                                            double>(6),
                                                                    thumbVisibility:
                                                                        WidgetStateProperty.all<bool>(
                                                                            true),
                                                                  ),
                                                                ),
                                                                menuItemStyleData:
                                                                    const MenuItemStyleData(
                                                                  overlayColor:
                                                                      null,
                                                                  height: 40,
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              14,
                                                                          right:
                                                                              14),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 24),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 22,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Text(
                                                        "Account Type",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic',
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 0),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 8.0,
                                                                    bottom:
                                                                        4.0),
                                                            child:
                                                                DropdownButtonHideUnderline(
                                                              child:
                                                                  DropdownButton2<
                                                                      String>(
                                                                isExpanded:
                                                                    true,
                                                                alignment:
                                                                    AlignmentDirectional
                                                                        .center,
                                                                hint: const Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 4,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        ' Account Types',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontFamily:
                                                                              'YuGothic',
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                items: Constants
                                                                    .accountTypes
                                                                    .map((String
                                                                            item) =>
                                                                        DropdownMenuItem<
                                                                            String>(
                                                                          value:
                                                                              item,
                                                                          child:
                                                                              Text(
                                                                            item.toReadable(),
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontFamily: 'YuGothic',
                                                                              color: Colors.black,
                                                                            ),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ))
                                                                    .toList(),
                                                                value:
                                                                    _selectedAccountType,
                                                                onChanged: _selectedPaymentType !=
                                                                        "Debit Order"
                                                                    ? null
                                                                    : (String?
                                                                        value) {
                                                                        setState(
                                                                            () {
                                                                          _selectedAccountType =
                                                                              value;
                                                                        });
                                                                      },
                                                                buttonStyleData:
                                                                    ButtonStyleData(
                                                                  height: 50,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              14,
                                                                          right:
                                                                              14),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            360),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .black26,
                                                                    ),
                                                                    color: Colors
                                                                        .transparent,
                                                                  ),
                                                                  elevation: 0,
                                                                ),
                                                                iconStyleData:
                                                                    const IconStyleData(
                                                                  icon: Icon(
                                                                    Icons
                                                                        .arrow_forward_ios_outlined,
                                                                  ),
                                                                  iconSize: 14,
                                                                  iconEnabledColor:
                                                                      Colors
                                                                          .black,
                                                                  iconDisabledColor:
                                                                      Colors
                                                                          .transparent,
                                                                ),
                                                                dropdownStyleData:
                                                                    DropdownStyleData(
                                                                  elevation: 0,
                                                                  maxHeight:
                                                                      200,
                                                                  width: 200,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16),
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  offset:
                                                                      const Offset(
                                                                          -5,
                                                                          0),
                                                                  scrollbarTheme:
                                                                      ScrollbarThemeData(
                                                                    radius: const Radius
                                                                        .circular(
                                                                        40),
                                                                    thickness:
                                                                        WidgetStateProperty.all<
                                                                            double>(6),
                                                                    thumbVisibility:
                                                                        WidgetStateProperty.all<bool>(
                                                                            true),
                                                                  ),
                                                                ),
                                                                menuItemStyleData:
                                                                    const MenuItemStyleData(
                                                                  overlayColor:
                                                                      null,
                                                                  height: 40,
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              14,
                                                                          right:
                                                                              14),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 24),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 22,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Text(
                                                        "Account Holder Name",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic',
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 0),
                                                    CustomInputTransparent4(
                                                      controller:
                                                          accountHolderController,
                                                      hintText:
                                                          'Account Holder Name',
                                                      onChanged: (String) {},
                                                      onSubmitted: (String) {},
                                                      focusNode:
                                                          accountHolderFocusNode,
                                                      isEditable:
                                                          _selectedPaymentType !=
                                                                  "Debit Order"
                                                              ? false
                                                              : true,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      isPasswordField: false,
                                                    ),
                                                    const SizedBox(height: 24),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 22,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Text(
                                                        "Account Number",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic',
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 0),
                                                    CustomInputTransparent3(
                                                      controller:
                                                          accountNumberController,
                                                      hintText:
                                                          'Account Number',
                                                      onChanged: (String) {},
                                                      onSubmitted: (String) {},
                                                      focusNode:
                                                          accountNumberFocusNode,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      integersOnly: true,
                                                      isPasswordField: false,
                                                      maxInputs: 14,
                                                      allow_editing:
                                                          _selectedPaymentType !=
                                                                  "Debit Order"
                                                              ? false
                                                              : true,
                                                    ),
                                                    const SizedBox(height: 24),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (_selectedPaymentType == "Debit Order")
                                        SizedBox(
                                          height: 16,
                                        ),
                                      if (_selectedPaymentType == "Debit Order")
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 24, right: 24),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Text(
                                                        "Branch Code",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic',
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 0),
                                                    CustomInputTransparent4(
                                                      controller:
                                                          branchCodeController,
                                                      hintText: 'Branch Code',
                                                      isEditable: false,
                                                      onChanged: (String) {},
                                                      onSubmitted: (String) {},
                                                      focusNode:
                                                          branchCodeFocusNode,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      isPasswordField: false,
                                                    ),
                                                    const SizedBox(height: 24),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 22,
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Text(
                                                        "Branch Name",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic',
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 0),
                                                    CustomInputTransparent4(
                                                      controller:
                                                          branchNameController,
                                                      hintText: 'Branch Name',
                                                      onChanged: (String) {},
                                                      onSubmitted: (String) {},
                                                      focusNode:
                                                          branchNameFocusNode,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      isEditable: false,
                                                      isPasswordField: false,
                                                    ),
                                                    const SizedBox(height: 24),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 22,
                                              ),
                                              Expanded(
                                                  flex: 4, child: Container())
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: CustomCard(
                                    elevation: 5,
                                    surfaceTintColor: Colors.white,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // Header
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.grey.withOpacity(0.15),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(12),
                                              topLeft: Radius.circular(12),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Center(
                                                    child: Text(
                                                      "Physical Address",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'YuGothic',
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),

                                        // Row: Address & Suburb
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 24, right: 24),
                                          child: Row(
                                            children: [
                                              // Address
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.0),
                                                      child: Text(
                                                        "Address",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic',
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 0),
                                                    CustomInputTransparent4(
                                                      controller:
                                                          addressController,
                                                      hintText: 'Address',
                                                      onChanged: (val) {
                                                        setState(() {
                                                          // Update the lead's address
                                                          Constants
                                                              .currentleadAvailable!
                                                              .addresses!
                                                              .physaddressLine1 = val;
                                                        });
                                                      },
                                                      onSubmitted: (val) {},
                                                      focusNode:
                                                          addressFocusNode,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      isPasswordField: false,
                                                    ),
                                                    const SizedBox(height: 24),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 22),
                                              // Suburb
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.0),
                                                      child: Text(
                                                        "Suburb",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic',
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 0),
                                                    CustomInputTransparent4(
                                                      controller:
                                                          suburbController,
                                                      hintText: 'Suburb',
                                                      onChanged: (val) {
                                                        setState(() {
                                                          Constants
                                                              .currentleadAvailable!
                                                              .addresses!
                                                              .physaddressLine2 = val;
                                                        });
                                                      },
                                                      onSubmitted: (val) {},
                                                      focusNode:
                                                          suburbFocusNode,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      isPasswordField: false,
                                                    ),
                                                    const SizedBox(height: 24),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),

                                        // Row: City & Province
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 24, right: 24),
                                          child: Row(
                                            children: [
                                              // City
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.0),
                                                      child: Text(
                                                        "City",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic',
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 0),
                                                    CustomInputTransparent4(
                                                      controller:
                                                          cityController,
                                                      hintText: 'City',
                                                      onChanged: (val) {
                                                        setState(() {
                                                          Constants
                                                              .currentleadAvailable!
                                                              .addresses!
                                                              .physaddressLine3 = val;
                                                        });
                                                      },
                                                      onSubmitted: (val) {},
                                                      focusNode: cityFocusNode,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      isPasswordField: false,
                                                    ),
                                                    const SizedBox(height: 24),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 22),
                                              // Province dropdown
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.0),
                                                      child: Text(
                                                        "Province",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic',
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 0),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 12.0,
                                                                    bottom:
                                                                        4.0),
                                                            child:
                                                                DropdownButtonHideUnderline(
                                                              child:
                                                                  DropdownButton2<
                                                                      String>(
                                                                isExpanded:
                                                                    true,
                                                                alignment:
                                                                    AlignmentDirectional
                                                                        .center,
                                                                hint: const Row(
                                                                  children: [
                                                                    SizedBox(
                                                                        width:
                                                                            4),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        'Select a province',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontFamily:
                                                                              'YuGothic',
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                items: provinceList
                                                                    .map((String
                                                                        item) {
                                                                  return DropdownMenuItem<
                                                                      String>(
                                                                    value: item,
                                                                    child: Text(
                                                                      item,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontFamily:
                                                                            'YuGothic',
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                                value:
                                                                    _physicalAddressProvince,
                                                                onChanged:
                                                                    (String?
                                                                        value) {
                                                                  setState(() {
                                                                    _physicalAddressProvince =
                                                                        value;
                                                                    // Also update the lead's address
                                                                    Constants
                                                                            .currentleadAvailable!
                                                                            .addresses!
                                                                            .physaddressProvince =
                                                                        value ??
                                                                            "";
                                                                  });
                                                                },
                                                                buttonStyleData:
                                                                    ButtonStyleData(
                                                                  height: 50,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    left: 14,
                                                                    right: 14,
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            360),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .black26,
                                                                    ),
                                                                    color: Colors
                                                                        .transparent,
                                                                  ),
                                                                  elevation: 0,
                                                                ),
                                                                iconStyleData:
                                                                    const IconStyleData(
                                                                  icon: Icon(
                                                                    Icons
                                                                        .arrow_forward_ios_outlined,
                                                                  ),
                                                                  iconSize: 14,
                                                                  iconEnabledColor:
                                                                      Colors
                                                                          .black,
                                                                  iconDisabledColor:
                                                                      Colors
                                                                          .transparent,
                                                                ),
                                                                dropdownStyleData:
                                                                    DropdownStyleData(
                                                                  elevation: 0,
                                                                  maxHeight:
                                                                      200,
                                                                  width: 200,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16),
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  offset:
                                                                      const Offset(
                                                                          -5,
                                                                          0),
                                                                  scrollbarTheme:
                                                                      ScrollbarThemeData(
                                                                    radius: const Radius
                                                                        .circular(
                                                                        40),
                                                                    thickness:
                                                                        WidgetStateProperty.all<
                                                                            double>(6),
                                                                    thumbVisibility:
                                                                        WidgetStateProperty.all<bool>(
                                                                            true),
                                                                  ),
                                                                ),
                                                                menuItemStyleData:
                                                                    const MenuItemStyleData(
                                                                  overlayColor:
                                                                      null,
                                                                  height: 40,
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              14,
                                                                          right:
                                                                              14),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 24),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Row: Code
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 24, right: 24),
                                          child: Row(
                                            children: [
                                              // Code
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.0),
                                                      child: Text(
                                                        "Code",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic',
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 0),
                                                    CustomInputTransparent3(
                                                      controller:
                                                          codeController,
                                                      hintText: 'Code',
                                                      integersOnly: true,
                                                      maxInputs: 4,
                                                      onChanged: (val) {
                                                        setState(() {
                                                          Constants
                                                              .currentleadAvailable!
                                                              .addresses!
                                                              .physaddressCode = val;
                                                        });
                                                      },
                                                      onSubmitted: (val) {},
                                                      focusNode: codeFocusNode,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      isPasswordField: false,
                                                    ),
                                                    const SizedBox(height: 24),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 22),
                                              // empty expanded for spacing
                                              Expanded(child: Container()),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 120,
                                  height: 35,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        addressPostalController.text =
                                            addressController.text;
                                        suburbPostalController.text =
                                            suburbController.text;
                                        cityPostalController.text =
                                            cityController.text;
                                        codePostalController.text =
                                            codeController.text;
                                        provincePostalController.text =
                                            provinceController.text;
                                        _postalAddressProvince =
                                            _physicalAddressProvince;
                                        Constants.currentleadAvailable!
                                                .addresses!.postaddressLine1 =
                                            addressController.text;
                                        Constants.currentleadAvailable!
                                                .addresses!.postaddressLine2 =
                                            suburbController.text;
                                        Constants.currentleadAvailable!
                                                .addresses!.postaddressLine3 =
                                            cityController.text;
                                        Constants.currentleadAvailable!
                                                .addresses!.postaddressCode =
                                            codeController.text;
                                        Constants
                                                .currentleadAvailable!
                                                .addresses!
                                                .postaddressProvince =
                                            _physicalAddressProvince ?? "";
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                      minimumSize: Size(
                                        MediaQuery.of(context).size.width,
                                        40,
                                      ),
                                      backgroundColor:
                                          Colors.grey.withOpacity(0.35),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(width: 8),
                                        Text(
                                          "Copy",
                                          style: TextStyle(
                                            color: Constants.ctaColorLight,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'YuGothic',
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          Icons.swap_horiz,
                                          color: Constants.ctaColorLight,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: CustomCard(
                                    elevation: 5,
                                    surfaceTintColor: Colors.white,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // Header
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.grey.withOpacity(0.15),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(12),
                                              topLeft: Radius.circular(12),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Center(
                                                    child: Text(
                                                      "Postal Address",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'YuGothic',
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),

                                        // Row: Address & Suburb
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 24, right: 24),
                                          child: Row(
                                            children: [
                                              // Address
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.0),
                                                      child: Text(
                                                        "Address",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic',
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 0),
                                                    CustomInputTransparent4(
                                                      controller:
                                                          addressPostalController,
                                                      hintText: 'Address',
                                                      onChanged: (val) {
                                                        setState(() {
                                                          // Store in the lead's postal address field
                                                          Constants
                                                              .currentleadAvailable!
                                                              .addresses!
                                                              .postaddressLine1 = val;
                                                        });
                                                      },
                                                      onSubmitted: (val) {},
                                                      focusNode:
                                                          addressPostalFocusNode,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      isPasswordField: false,
                                                    ),
                                                    const SizedBox(height: 24),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 22),
                                              // Suburb
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Suburb",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'YuGothic',
                                                      ),
                                                    ),
                                                    const SizedBox(height: 0),
                                                    CustomInputTransparent4(
                                                      controller:
                                                          suburbPostalController,
                                                      hintText: 'Suburb',
                                                      onChanged: (val) {
                                                        setState(() {
                                                          Constants
                                                              .currentleadAvailable!
                                                              .addresses!
                                                              .postaddressLine2 = val;
                                                        });
                                                      },
                                                      onSubmitted: (val) {},
                                                      focusNode:
                                                          suburbPostalFocusNode,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      isPasswordField: false,
                                                    ),
                                                    const SizedBox(height: 24),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),

                                        // Row: City & Province
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 24, right: 24),
                                          child: Row(
                                            children: [
                                              // City
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.0),
                                                      child: Text(
                                                        "City",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic',
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 0),
                                                    CustomInputTransparent4(
                                                      controller:
                                                          cityPostalController,
                                                      hintText: 'City',
                                                      onChanged: (val) {
                                                        setState(() {
                                                          Constants
                                                              .currentleadAvailable!
                                                              .addresses!
                                                              .postaddressLine3 = val;
                                                        });
                                                      },
                                                      onSubmitted: (val) {},
                                                      focusNode:
                                                          cityPostalFocusNode,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      isPasswordField: false,
                                                    ),
                                                    const SizedBox(height: 24),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 22),
                                              // Province
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.0),
                                                      child: Text(
                                                        "Province",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic',
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 0),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 12.0,
                                                                    bottom:
                                                                        4.0),
                                                            child:
                                                                DropdownButtonHideUnderline(
                                                              child:
                                                                  DropdownButton2<
                                                                      String>(
                                                                isExpanded:
                                                                    true,
                                                                alignment:
                                                                    AlignmentDirectional
                                                                        .center,
                                                                hint: const Row(
                                                                  children: [
                                                                    SizedBox(
                                                                        width:
                                                                            4),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        'Select a province',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontFamily:
                                                                              'YuGothic',
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                items: provinceList
                                                                    .map((String
                                                                        item) {
                                                                  return DropdownMenuItem<
                                                                      String>(
                                                                    value: item,
                                                                    child: Text(
                                                                      item,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontFamily:
                                                                            'YuGothic',
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                                value:
                                                                    _postalAddressProvince,
                                                                onChanged:
                                                                    (String?
                                                                        value) {
                                                                  setState(() {
                                                                    _postalAddressProvince =
                                                                        value;
                                                                    // Also update the lead's postal province
                                                                    Constants
                                                                            .currentleadAvailable!
                                                                            .addresses!
                                                                            .postaddressProvince =
                                                                        value ??
                                                                            "";
                                                                  });
                                                                },
                                                                buttonStyleData:
                                                                    ButtonStyleData(
                                                                  height: 50,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              14,
                                                                          right:
                                                                              14),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            360),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .black26,
                                                                    ),
                                                                    color: Colors
                                                                        .transparent,
                                                                  ),
                                                                  elevation: 0,
                                                                ),
                                                                iconStyleData:
                                                                    const IconStyleData(
                                                                  icon: Icon(
                                                                    Icons
                                                                        .arrow_forward_ios_outlined,
                                                                  ),
                                                                  iconSize: 14,
                                                                  iconEnabledColor:
                                                                      Colors
                                                                          .black,
                                                                  iconDisabledColor:
                                                                      Colors
                                                                          .transparent,
                                                                ),
                                                                dropdownStyleData:
                                                                    DropdownStyleData(
                                                                  elevation: 0,
                                                                  maxHeight:
                                                                      200,
                                                                  width: 200,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16),
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  offset:
                                                                      const Offset(
                                                                          -5,
                                                                          0),
                                                                  scrollbarTheme:
                                                                      ScrollbarThemeData(
                                                                    radius: const Radius
                                                                        .circular(
                                                                        40),
                                                                    thickness:
                                                                        WidgetStateProperty.all<
                                                                            double>(6),
                                                                    thumbVisibility:
                                                                        WidgetStateProperty.all<bool>(
                                                                            true),
                                                                  ),
                                                                ),
                                                                menuItemStyleData:
                                                                    const MenuItemStyleData(
                                                                  overlayColor:
                                                                      null,
                                                                  height: 40,
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              14,
                                                                          right:
                                                                              14),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 24),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 22),
                                            ],
                                          ),
                                        ),

                                        // Row: Code
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 24, right: 24),
                                          child: Row(
                                            children: [
                                              // Code
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.0),
                                                      child: Text(
                                                        "Code",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic',
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 0),
                                                    CustomInputTransparent3(
                                                      controller:
                                                          codePostalController,
                                                      hintText: 'Code',
                                                      onChanged: (val) {
                                                        setState(() {
                                                          Constants
                                                              .currentleadAvailable!
                                                              .addresses!
                                                              .postaddressCode = val;
                                                        });
                                                      },
                                                      onSubmitted: (val) {},
                                                      focusNode:
                                                          codePostalFocusNode,
                                                      maxInputs: 4,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      isPasswordField: false,
                                                    ),
                                                    const SizedBox(height: 24),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 22),
                                              Expanded(child: Container()),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          /*  Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 16),

                                      // Yes Option
                                      */ /*
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 6.0),
                                                  child: Text(
                                                    //      "Postal Same as physical address",
                                                    "Copy Physical Address to Postal Address",
                                                    style: TextStyle(
                                                      fontFamily: 'YuGothic',
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8),*/ /*
                                      Spacer(),

                                      Container(
                                        width: 120,
                                        height: 35,
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              addressPostalController.text =
                                                  addressController.text;
                                              suburbPostalController.text =
                                                  suburbController.text;
                                              cityPostalController.text =
                                                  cityController.text;
                                              codePostalController.text =
                                                  codeController.text;
                                              provincePostalController.text =
                                                  provinceController.text;
                                              _postalAddressProvince =
                                                  _physicalAddressProvince;
                                              Constants
                                                      .currentleadAvailable!
                                                      .addresses!
                                                      .postaddressLine1 =
                                                  addressController.text;
                                              Constants
                                                      .currentleadAvailable!
                                                      .addresses!
                                                      .postaddressLine2 =
                                                  suburbController.text;
                                              Constants
                                                      .currentleadAvailable!
                                                      .addresses!
                                                      .postaddressLine3 =
                                                  cityController.text;
                                              Constants
                                                      .currentleadAvailable!
                                                      .addresses!
                                                      .postaddressCode =
                                                  codeController.text;
                                              Constants
                                                      .currentleadAvailable!
                                                      .addresses!
                                                      .postaddressProvince =
                                                  _physicalAddressProvince ??
                                                      "";
                                            });
                                          },
                                          style: TextButton.styleFrom(
                                              minimumSize: Size(
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  40),
                                              backgroundColor: Colors.grey
                                                  .withOpacity(0.35)),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(width: 8),
                                              Text(
                                                "Copy",
                                                style: TextStyle(
                                                  color:
                                                      Constants.ctaColorLight,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Icon(
                                                Iconsax.refresh_left_square,
                                                color: Constants.ctaColorLight,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),*/
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CustomCard(
                                elevation: 5,
                                surfaceTintColor: Colors.white,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Header
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.15),
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(12),
                                          topLeft: Radius.circular(12),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Center(
                                                child: Text(
                                                  "Beneficiary Address",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'YuGothic',
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Spacer(),
                                          Container(
                                            width: 240,
                                            height: 35,
                                            child: TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  // 1) Copy text from physical address controllers to beneficiary address controllers
                                                  addressBeneficialController
                                                          .text =
                                                      addressController.text;
                                                  suburbBeneficialController
                                                          .text =
                                                      suburbController.text;
                                                  cityBeneficialController
                                                          .text =
                                                      cityController.text;
                                                  codeBeneficialController
                                                          .text =
                                                      codeController.text;
                                                  provinceBeneficialController
                                                          .text =
                                                      provinceController.text;
                                                  _beneficiaryAddressProvince =
                                                      _physicalAddressProvince;

                                                  // 2) Update the beneficiary address object in your lead
                                                  //    Make sure beneficiaryAddress! is not null
                                                  Constants
                                                          .currentleadAvailable!
                                                          .beneficiaryAddress!
                                                          .physaddressLine1 =
                                                      addressController.text;
                                                  Constants
                                                          .currentleadAvailable!
                                                          .beneficiaryAddress!
                                                          .physaddressLine2 =
                                                      suburbController.text;
                                                  Constants
                                                          .currentleadAvailable!
                                                          .beneficiaryAddress!
                                                          .physaddressLine3 =
                                                      cityController.text;
                                                  Constants
                                                          .currentleadAvailable!
                                                          .beneficiaryAddress!
                                                          .physaddressCode =
                                                      codeController.text;
                                                  Constants
                                                          .currentleadAvailable!
                                                          .beneficiaryAddress!
                                                          .physaddressProvince =
                                                      _physicalAddressProvince ??
                                                          "";
                                                });
                                              },
                                              style: TextButton.styleFrom(
                                                minimumSize: Size(
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    40),
                                                backgroundColor: Colors.grey
                                                    .withOpacity(0.35),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    "Same as payer address",
                                                    style: TextStyle(
                                                      color: Constants
                                                          .ctaColorLight,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'YuGothic',
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Icon(
                                                    Icons.swap_horiz,
                                                    color:
                                                        Constants.ctaColorLight,
                                                  ),
                                                  /*   Icon(
                                                    Iconsax.refresh_left_square,
                                                    color:
                                                        Constants.ctaColorLight,
                                                  ),*/
                                                ],
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),

                                    // Row: Address, Suburb, City
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 24, right: 24),
                                      child: Row(
                                        children: [
                                          // Address
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8.0),
                                                  child: Text(
                                                    "Address",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'YuGothic',
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 0),
                                                CustomInputTransparent4(
                                                  controller:
                                                      addressBeneficialController,
                                                  hintText: 'Address',
                                                  onChanged: (val) {
                                                    setState(() {
                                                      // Store in beneficiaryAddress physaddressLine1
                                                      Constants
                                                          .currentleadAvailable!
                                                          .beneficiaryAddress!
                                                          .physaddressLine1 = val;
                                                    });
                                                  },
                                                  onSubmitted: (val) {},
                                                  focusNode:
                                                      addressBeneficialFocusNode,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  isPasswordField: false,
                                                ),
                                                const SizedBox(height: 24),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 22),
                                          // Suburb
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8.0),
                                                  child: Text(
                                                    "Suburb",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'YuGothic',
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 0),
                                                CustomInputTransparent4(
                                                  controller:
                                                      suburbBeneficialController,
                                                  hintText: 'Suburb',
                                                  onChanged: (val) {
                                                    setState(() {
                                                      Constants
                                                          .currentleadAvailable!
                                                          .beneficiaryAddress!
                                                          .physaddressLine2 = val;
                                                    });
                                                  },
                                                  onSubmitted: (val) {},
                                                  focusNode:
                                                      suburbBeneficialFocusNode,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  isPasswordField: false,
                                                ),
                                                const SizedBox(height: 24),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 22),
                                          // City
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8.0),
                                                  child: Text(
                                                    "City",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'YuGothic',
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 0),
                                                CustomInputTransparent4(
                                                  controller:
                                                      cityBeneficialController,
                                                  hintText: 'City',
                                                  onChanged: (val) {
                                                    setState(() {
                                                      Constants
                                                          .currentleadAvailable!
                                                          .beneficiaryAddress!
                                                          .physaddressLine3 = val;
                                                    });
                                                  },
                                                  onSubmitted: (val) {},
                                                  focusNode:
                                                      cityBeneficialFocusNode,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  isPasswordField: false,
                                                ),
                                                const SizedBox(height: 24),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Row: Province, Code
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 24, right: 24),
                                      child: Row(
                                        children: [
                                          // Province dropdown
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8.0),
                                                  child: Text(
                                                    "Province",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'YuGothic',
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 0),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 8.0,
                                                                bottom: 4.0),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child:
                                                              DropdownButton2<
                                                                  String>(
                                                            isExpanded: true,
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .center,
                                                            hint: const Row(
                                                              children: [
                                                                SizedBox(
                                                                    width: 4),
                                                                Expanded(
                                                                  child: Text(
                                                                    'Select a province',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontFamily:
                                                                          'YuGothic',
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            items: provinceList
                                                                .map((String
                                                                    item) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: item,
                                                                child: Text(
                                                                  item,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontFamily:
                                                                        'YuGothic',
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              );
                                                            }).toList(),
                                                            value:
                                                                _beneficiaryAddressProvince,
                                                            onChanged: (String?
                                                                value) {
                                                              setState(() {
                                                                _beneficiaryAddressProvince =
                                                                    value;
                                                                // Also update the beneficiary address
                                                                Constants
                                                                        .currentleadAvailable!
                                                                        .beneficiaryAddress!
                                                                        .physaddressProvince =
                                                                    value ?? "";
                                                              });
                                                            },
                                                            buttonStyleData:
                                                                ButtonStyleData(
                                                              height: 50,
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 14,
                                                                      right:
                                                                          14),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            360),
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .black26,
                                                                ),
                                                                color: Colors
                                                                    .transparent,
                                                              ),
                                                              elevation: 0,
                                                            ),
                                                            iconStyleData:
                                                                const IconStyleData(
                                                              icon: Icon(Icons
                                                                  .arrow_forward_ios_outlined),
                                                              iconSize: 14,
                                                              iconEnabledColor:
                                                                  Colors.black,
                                                              iconDisabledColor:
                                                                  Colors
                                                                      .transparent,
                                                            ),
                                                            dropdownStyleData:
                                                                DropdownStyleData(
                                                              elevation: 0,
                                                              maxHeight: 200,
                                                              width: 200,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16),
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              offset:
                                                                  const Offset(
                                                                      -5, 0),
                                                              scrollbarTheme:
                                                                  ScrollbarThemeData(
                                                                radius:
                                                                    const Radius
                                                                        .circular(
                                                                        40),
                                                                thickness:
                                                                    WidgetStateProperty
                                                                        .all<double>(
                                                                            6),
                                                                thumbVisibility:
                                                                    WidgetStateProperty
                                                                        .all<bool>(
                                                                            true),
                                                              ),
                                                            ),
                                                            menuItemStyleData:
                                                                const MenuItemStyleData(
                                                              overlayColor:
                                                                  null,
                                                              height: 40,
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 14,
                                                                      right:
                                                                          14),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 24),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 22),

                                          // Code
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8.0),
                                                  child: Text(
                                                    "Code",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'YuGothic',
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 0),
                                                CustomInputTransparent3(
                                                  controller:
                                                      codeBeneficialController,
                                                  hintText: 'Code',
                                                  maxInputs: 4,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      Constants
                                                          .currentleadAvailable!
                                                          .beneficiaryAddress!
                                                          .physaddressCode = val;
                                                    });
                                                  },
                                                  onSubmitted: (val) {},
                                                  focusNode:
                                                      codeBeneficialFocusNode,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  integersOnly: true,
                                                  isPasswordField: false,
                                                ),
                                                const SizedBox(height: 24),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 22),
                                          Expanded(child: Container()),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              Container(
                                width: 160,
                                height: 35,
                                child: TextButton(
                                  onPressed: () {
                                    updatePayerDetails(context: context);
                                  },
                                  style: TextButton.styleFrom(
                                      minimumSize: Size(
                                          MediaQuery.of(context).size.width,
                                          40),
                                      backgroundColor:
                                          Constants.isPremiumPayerSaved == false
                                              ? Constants.ctaColorLight
                                              : Colors.grey),
                                  child: const Text(
                                    "Save and Submit",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'YuGothic',
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    if (fieldSalesActiveStep == 5)
                      FieldSalesCommunicationPreference()
                  ],
                ))));
  }

  void showAddBeneficiariesDialog(
      BuildContext context, int current_member_index) {
    // 1) Build a list of AdditionalMembers that can be beneficiaries.
    // Exclude those with a relationship of "self".
    List<AdditionalMember> allBeneficiariesList = [];
    if (Constants.currentleadAvailable != null) {
      allBeneficiariesList = Constants.currentleadAvailable!.additionalMembers
          .where((am) => am.relationship.toLowerCase() != "self")
          .toList();
    }

    // 2) Get the current policy and its reference.
    final policy =
        Constants.currentleadAvailable!.policies[current_member_index];
    final String? currentReference = policy.reference;
    final List<dynamic> membersList = policy.members ?? [];

    // 3) Identify which beneficiaries are already in the policy.
    // We check for members with type 'beneficiary' and matching reference.
    final Set<int> existingBeneficiaryAutoNumbers = membersList.where((m) {
      if (m is Map<String, dynamic>) {
        return (m['type'] as String?)?.toLowerCase() == 'beneficiary' &&
            m['reference'] == currentReference;
      } else if (m is Member) {
        return (m.type ?? '').toLowerCase() == 'beneficiary' &&
            m.reference == currentReference;
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

    // 4) Remove beneficiaries that are already added.
    allBeneficiariesList.removeWhere(
        (am) => existingBeneficiaryAutoNumbers.contains(am.autoNumber));

    /*  // Optional: If there are no available beneficiaries, you can show a message.
    if (allBeneficiariesList.isEmpty) {
      MotionToast.success(
        height: 45,
        description: const Text(
          "Add a new member to add a beneficiary.",
          style: TextStyle(color: Colors.white),
        ),
        animationDuration: const Duration(milliseconds: 500),
      ).show(context);
      return;
    }
*/
    // 5) Show the dialog with the filtered list.
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
                        "Add a Beneficiary",
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
                        "Click on a member below to select them as a beneficiary",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'YuGothic',
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // -------------------- List of potential beneficiaries --------------------
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: allBeneficiariesList.length,
                      itemBuilder: (context, index) {
                        final member = allBeneficiariesList[index];
                        return GestureDetector(
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
                                        member.dob.isEmpty
                                            ? 'DoB: -'
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
                                      Row(
                                        children: [
                                          Spacer(),
                                          Container(
                                            height: 30,
                                            child: TextButton(
                                              onPressed: () async {
                                                // Close this dialog first...
                                                Navigator.of(context).pop();
                                                // ...then open the dialog for adding beneficiary info.
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AddBeneficiaryMember(
                                                          selectedMember:
                                                              member,
                                                          currentReference:
                                                              currentReference,
                                                          current_member_index:
                                                              current_member_index),
                                                );
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
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10.0,
                                        offset: Offset(0.0, 10.0),
                                      ),
                                    ],
                                  ),
                                  child: NewMemberDialog2(
                                    isEditMode: false,
                                    autoNumber: 0,
                                    relationship: "",
                                    title: "",
                                    name: "",
                                    surname: "",
                                    dob: "",
                                    gender: "",
                                    current_member_index: current_member_index,
                                    canAddMember: false,
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
                          'Add A New Member',
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

  Widget buildBeneficiariesList1() {
    if (Constants.currentleadAvailable == null) return Container();
    // A) Identify current policy & reference
    if (Constants.currentleadAvailable!.policies.isNotEmpty) {
      final policy =
          Constants.currentleadAvailable!.policies[current_member_index];
      final currentReference = policy.reference;
      // print("Current reference: $currentReference");

      // ----------------------------------------------------------------
      // 1) GATHER BENEFICIARIES FROM policy.members
      // ----------------------------------------------------------------
      final List<dynamic> membersList = policy.members ?? [];
      // print("fgghhjjhhj1 ${membersList}");

      // Filter by 'type == beneficiary' and matching reference
      List<int> beneficiaryAutoNumbersFromPolicy = membersList
          .where((m) {
            if (m is Map<String, dynamic>) {
              final type = (m['type'] as String?)?.toLowerCase();
              final reference = m['reference'];
              return type == 'beneficiary' && reference == currentReference;
            } else if (m is Member) {
              return (m.type ?? '').toLowerCase() == 'beneficiary' &&
                  m.reference == currentReference;
            }
            return false;
          })
          // Extract the autoNumber
          .map<int>((m) {
            if (m is Map<String, dynamic>) {
              // Normalize key access for both 'auto_number' and 'autoNumber'
              final autoNumber = m.containsKey('auto_number')
                  ? m['auto_number']
                  : m.containsKey('autoNumber')
                      ? m['autoNumber']
                      : -1;
              return autoNumber as int;
            } else if (m is Member) {
              return m.autoNumber ?? -1;
            }
            return -1;
          })
          .where((num) => num != -1) // Filter out invalid autoNumbers
          .toList();

      // print("fgghhjjhhj2 ${beneficiaryAutoNumbersFromPolicy}");

      // Convert those autoNumbers into AdditionalMember objects
      final List<AdditionalMember> beneficiaryMembersFromPolicy = [];
      for (int autoNum in beneficiaryAutoNumbersFromPolicy) {
        AdditionalMember? foundAM = Constants
            .currentleadAvailable!.additionalMembers
            .where((am) => am.autoNumber == autoNum)
            .firstOrNull;
        if (foundAM != null) {
          beneficiaryMembersFromPolicy.add(foundAM);
        }
      }

      // ----------------------------------------------------------------
      // 2) GATHER BENEFICIARIES FROM policiesSelectedBeneficiaries
      //    (List<Map<String, dynamic>> that contain reference, autoNumber, etc.)
      // ----------------------------------------------------------------
      // Filter items where 'reference' == currentReference AND 'type' == 'beneficiary'
      final List<Map<dynamic, dynamic>> beneficiaryEntriesFromSelected =
          policiesSelectedBeneficiaries.where((entry) {
        final ref = entry['reference'];
        final type = (entry['type'] ?? '').toLowerCase();
        return ref == currentReference && type == 'beneficiary';
      }).toList();

      // Convert these entries to AdditionalMember objects
      final List<AdditionalMember> beneficiaryMembersFromSelected = [];
      for (final entry in beneficiaryEntriesFromSelected) {
        final autoNum = entry['autoNumber'] ?? -1;
        if (autoNum is int && autoNum != -1) {
          // Find a matching AdditionalMember in our global additionalMembers
          final foundAM = Constants.currentleadAvailable!.additionalMembers
              .firstWhere((am) => am.autoNumber == autoNum);
          if (foundAM != null) {
            beneficiaryMembersFromSelected.add(foundAM);
          } else {
            print(
                "No matching AdditionalMember found for autoNumber: $autoNum");
          }
        }
      }

      // ----------------------------------------------------------------
      // 3) COMBINE & DE-DUPE
      // ----------------------------------------------------------------
      final Map<int, AdditionalMember> dedupeMap = {};

      // Insert from policy
      for (final am in beneficiaryMembersFromPolicy) {
        dedupeMap[am.autoNumber] = am;
      }

      // Insert from selected
      for (final am in beneficiaryMembersFromSelected) {
        dedupeMap[am.autoNumber] = am;
      }

      // Final combined list
      final combinedBeneficiaries = dedupeMap.values.toList();

      // ----------------------------------------------------------------
      // 4) FALLBACK IF EMPTY
      // ----------------------------------------------------------------
      if (combinedBeneficiaries.isEmpty) {
        return const Center(
          child: Text(
            "No beneficiaries available for this policy.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        );
      }

      // ----------------------------------------------------------------
      // 5) BUILD GRIDVIEW
      // ----------------------------------------------------------------
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns
          crossAxisSpacing: 16.0, // Space between columns
          mainAxisSpacing: 16.0, // Space between rows
          mainAxisExtent: 130, // Fixed height per item
        ),
        itemCount: combinedBeneficiaries.length,
        itemBuilder: (context, index) {
          final member = combinedBeneficiaries[index];
          print(
              "Processing beneficiary: autoNumber=${member.autoNumber}, name=${member.name}");

          return GestureDetector(
            onDoubleTap: () {},
            child: AnimatedScale(
                scale: 1.0, // Smooth scaling on hover
                duration: const Duration(milliseconds: 200),
                child: CustomCard2(
                  elevation: 8,
                  boderRadius: 12,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.transparent)),
                    margin: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 0.0),
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
                                    color: Constants.ftaColorLight
                                        .withOpacity(0.15)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor:
                                          Colors.grey.withOpacity(0.65),
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
                                // Date of Birth
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        (member.dob.isEmpty)
                                            ? 'DoB: -'
                                            : 'DoB: ${(DateFormat('dd MMM yyyy').format(DateTime.parse(member.dob)).toString())}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'YuGothic',
                                            color: Colors.black),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          // 1) Remove from policy.members
                                          policy.members.removeWhere((m) {
                                            if (m is Map<String, dynamic>) {
                                              return (m['autoNumber'] ==
                                                      member.autoNumber) &&
                                                  ((m['type'] as String?)
                                                          ?.toLowerCase() ==
                                                      'beneficiary') &&
                                                  (m['reference'] ==
                                                      currentReference);
                                            } else if (m is Member) {
                                              return (m.autoNumber ==
                                                      member.autoNumber) &&
                                                  ((m.type ?? '')
                                                          .toLowerCase() ==
                                                      'beneficiary') &&
                                                  (m.reference ==
                                                      currentReference);
                                            }
                                            return false;
                                          });

                                          // 2) Also remove from your tracking list
                                          //    if you store them as maps keyed by reference:
                                          policiesSelectedBeneficiaries
                                              .removeWhere((mapEntry) {
                                            final AdditionalMember? addMem =
                                                mapEntry[currentReference];
                                            return addMem != null &&
                                                addMem.autoNumber ==
                                                    member.autoNumber;
                                          });

                                          // 3) Finally remove from the local combined list:
                                          combinedBeneficiaries.removeAt(index);

                                          // 4) Recalculate premium or do any additional logic:
                                          calculatePolicyPremiumCal();
                                        });
                                      },
                                      child: const Icon(Icons.close),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 8.0),

                                // Member Name
                                Text(
                                  member.title +
                                      " " +
                                      member.name +
                                      " " +
                                      member.surname,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  member.percentage.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Edit Button
                      ],
                    ),
                  ),
                )),
          );
        },
      );
    }
    return const Center(
      child: Text(
        "No beneficiaries available for this policy.",
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
    );
  }

  Widget buildBeneficiariesList() {
    // If there's no lead or no policies, show a fallback widget
    if (Constants.currentleadAvailable == null ||
        Constants.currentleadAvailable!.policies.isEmpty) {
      return const Center(
        child: Text(
          "No beneficiaries available for this policy.",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      );
    }

    // 1) Identify the current policy and its reference
    final policy =
        Constants.currentleadAvailable!.policies[current_member_index];
    final String currentReference = policy.reference;

    // ----------------------------------------------------------------
    // 2) Gather beneficiaries from `policy.members`
    //    (where `type == 'beneficiary'` and `reference` matches)
    // ----------------------------------------------------------------
    final List<dynamic> membersList = policy.members ?? [];

    final List<int> beneficiaryAutoNumbersFromPolicy = membersList
        .where((m) {
          if (m is Map<String, dynamic>) {
            return (m['type'] as String?)?.toLowerCase() == 'beneficiary' &&
                m['reference'] == currentReference;
          } else if (m is Member) {
            return (m.type ?? '').toLowerCase() == 'beneficiary' &&
                m.reference == currentReference;
          }
          return false;
        })
        .map<int>((m) {
          if (m is Map<String, dynamic>) {
            // The key might be 'auto_number' or 'autoNumber'
            final autoNum = m.containsKey('additional_member_id')
                ? m['additional_member_id']
                : m.containsKey('additional_member_id')
                    ? m['additional_member_id']
                    : -1;
            return autoNum as int;
          } else if (m is Member) {
            return m.autoNumber ?? -1;
          }
          return -1;
        })
        .where((num) => num != -1)
        .toList();
    print("sdgshj ${beneficiaryAutoNumbersFromPolicy}");

    // Convert these autoNumbers to AdditionalMember objects
    final List<AdditionalMember> beneficiaryMembersFromPolicy = [];
    for (int autoNum in beneficiaryAutoNumbersFromPolicy) {
      final foundAM = Constants.currentleadAvailable!.additionalMembers
          .firstWhere((am) => am.autoNumber == autoNum);
      if (foundAM != null) {
        beneficiaryMembersFromPolicy.add(foundAM);
      }
    }

    // ----------------------------------------------------------------
    // 3) Gather from `policiesSelectedBeneficiaries` (if you store them)
    //    and also filter by `reference == currentReference` & `type == 'beneficiary'`
    // ----------------------------------------------------------------
    final List<Map> beneficiaryEntriesFromSelected =
        policiesSelectedBeneficiaries.where((entry) {
      final ref = entry['reference'];
      final type = (entry['type'] ?? '').toLowerCase();
      return ref == currentReference && type == 'beneficiary';
    }).toList();

    final List<AdditionalMember> beneficiaryMembersFromSelected = [];
    for (final entry in beneficiaryEntriesFromSelected) {
      final autoNum = entry['additional_member_id'] ?? -1;
      if (autoNum is int && autoNum != -1) {
        final foundAM = Constants.currentleadAvailable!.additionalMembers
            .firstWhere((am) => am.autoNumber == autoNum);
        if (foundAM != null) {
          beneficiaryMembersFromSelected.add(foundAM);
        }
      }
    }

    // ----------------------------------------------------------------
    // 4) Combine & deduplicate them by autoNumber
    // ----------------------------------------------------------------
    final Map<int, AdditionalMember> dedupeMap = {};
    for (final am in beneficiaryMembersFromPolicy) {
      dedupeMap[am.autoNumber] = am;
    }
    for (final am in beneficiaryMembersFromSelected) {
      dedupeMap[am.autoNumber] = am;
    }

    final combinedBeneficiaries = dedupeMap.values.toList();

    // If empty after combining, fallback
    if (combinedBeneficiaries.isEmpty) {
      return const Center(
        child: Text(
          "No beneficiaries available for this policy.",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      );
    }

    // ----------------------------------------------------------------
    // 5) Build a GridView for the beneficiaries
    // ----------------------------------------------------------------
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 columns
        crossAxisSpacing: 16.0, // space between columns
        mainAxisSpacing: 16.0, // space between rows
        mainAxisExtent: 130, // fixed height for each grid cell
      ),
      itemCount: combinedBeneficiaries.length,
      itemBuilder: (context, index) {
        final member = combinedBeneficiaries[index];
        int beneficiary_percentage = Constants
            .currentleadAvailable!.policies[current_member_index].members
            .where((m2) => (m2["additional_member_id"] == member.autoNumber &&
                m2["type"] == "beneficiary"))
            .toList()
            .first["percentage"];

        return GestureDetector(
          onDoubleTap: () {
            // Optional: handle double-tap on beneficiary
          },
          child: AnimatedScale(
            scale: 1.0,
            duration: const Duration(milliseconds: 200),
            child: CustomCard2(
              elevation: 8,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              boderRadius: 12,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.transparent),
                ),
                padding: EdgeInsets.zero,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left side: an avatar in a colored container
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
                              color: Constants.ftaColorLight.withOpacity(0.15),
                            ),
                            child: Center(
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey.withOpacity(0.65),
                                child: Icon(
                                  member.gender.toLowerCase() == "female"
                                      ? Icons.female
                                      : Icons.male,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 16.0),

                    // Right side: beneficiary info + remove icon
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row: DoB + remove icon
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    member.dob.isEmpty
                                        ? 'DoB: -'
                                        : 'DoB: '
                                            '${DateFormat('dd MMM yyyy').format(DateTime.parse(member.dob))}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'YuGothic',
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Map<String, dynamic> m3 = Constants
                                        .currentleadAvailable!
                                        .policies[current_member_index]
                                        .members
                                        .where((memberMap) =>
                                            memberMap["additional_member_id"] ==
                                            member.autoNumber)
                                        .first;

                                    Member removedMember = Member.fromJson(m3);
                                    removeBeneficiaryMember(
                                        removedMember, currentReference);
                                    setState(() {
                                      print("gfghgg ${policy.members}");
                                      // (1) Remove from policy.members
                                      policy.members.removeWhere((m) {
                                        if (m is Map<String, dynamic>) {
                                          final isBeneficiary =
                                              (m['type'] as String?)
                                                      ?.toLowerCase() ==
                                                  'beneficiary';
                                          final isSameRef = m['reference'] ==
                                              currentReference;
                                          final isSameAutoNumber =
                                              (m['additional_member_id'] ??
                                                      -1) ==
                                                  member.autoNumber;
                                          return isBeneficiary &&
                                              isSameRef &&
                                              isSameAutoNumber;
                                        } else if (m is Member) {
                                          final isBeneficiary =
                                              (m.type ?? '').toLowerCase() ==
                                                  'beneficiary';
                                          final isSameRef =
                                              m.reference == currentReference;
                                          final isSameAutoNumber =
                                              (m.autoNumber ?? -1) ==
                                                  member.autoNumber;
                                          return isBeneficiary &&
                                              isSameRef &&
                                              isSameAutoNumber;
                                        }
                                        return false;
                                      });

                                      // (2) Remove from policiesSelectedBeneficiaries
                                      //     if you're storing them in that list
                                      policiesSelectedBeneficiaries
                                          .removeWhere((entry) {
                                        final ref = entry['reference'];
                                        final type =
                                            (entry['type'] ?? '').toLowerCase();
                                        final autoNum =
                                            entry['autoNumber'] ?? -1;
                                        return ref == currentReference &&
                                            type == 'beneficiary' &&
                                            autoNum == member.autoNumber;
                                      });
                                      Constants
                                          .currentleadAvailable!
                                          .policies[current_member_index]
                                          .members
                                          .removeWhere((m2) =>
                                              m2["additional_member_id"] ==
                                                  member.autoNumber &&
                                              m2["type"] == "beneficiary");

                                      // (3) Remove from combinedBeneficiaries
                                      combinedBeneficiaries.removeAt(index);

                                      // (4) Recalculate or refresh your premium logic
                                      calculatePolicyPremiumCal();
                                    });
                                  },
                                  child: const Icon(Icons.close),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8.0),

                            // Name
                            Text(
                              '${member.title} ${member.name} ${member.surname}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4.0),

                            // Percentage
                            Text(
                              '${beneficiary_percentage.toStringAsFixed(2)}%',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.2,
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
          ),
        );
      },
    );
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
          partnersDobs: [],
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

  void updateEmployersRequest({
    required String employerId,
    required String leadId,
    required TextEditingController employerNameController,
    required TextEditingController occupationController,
    required TextEditingController employeeNumberController,
    required String selectedSalaryRange,
    required String selectedSalaryFrequency,
    required String selectedPayDay,
    required String employmentStatus,
  }) async {
    String url = "${Constants.InsightsAdminbaseUrl}fieldV6/updateEmployer";

    // Prepare the form data
    final Map<String, String> formData = {
      'onolo_employerid': employerId,
      'onololeadid': leadId,
      'employer_name': employerNameController.text,
      'occupation': occupationController.text,
      'employee_number': employeeNumberController.text,
      'salary_range': selectedSalaryRange,
      'salary_frequency': selectedSalaryFrequency,
      'salary_day': selectedPayDay,
      'updated_by': Constants.cec_employeeid.toString(),
      'employer_query_type': '',
      'employer_query_type_old_new': '',
      'employer_query_type_old_auto_number': '',
      'employer_timestamp': '',
      'employer_last_update': '',
      'employmentStatus': employmentStatus,
      'income_source': '',
      'specify_source': '',
    };
    print("sdffgf1 $url $formData");

    try {
      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        body: formData,
      );

      // Check the response status
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print("sdffgf2 $responseBody ${responseBody.runtimeType}");
        Constants.currentleadAvailable!.employer = Employer.fromJson(formData);

        // Assuming the response body contains { "status": 1 } or { "status": 0 }
        if (responseBody == "1") {
          Constants.isEmployerDetailsSaved = true;
          if (Constants.fieldSaleType == "Field Sale") {
            fieldSalesActiveStep++;

            setState(() {});
          } else if (Constants.fieldSaleType == "Paperless Sale") {
            if (Constants.currentleadAvailable!.additionalMembers.isNotEmpty) {
              fieldSalesActiveStep++;

              setState(() {});
            } else {
              MotionToast.error(
                description: Text(
                  "Add atleast one member to proceed!",
                  style: TextStyle(color: Colors.white),
                ),
              ).show(context);
            }
          }
          MotionToast.success(
            height: 40,
            width: 300,
            onClose: () {},
            description: Text(
              "Update Successful",
              style: TextStyle(color: Colors.white),
            ),
          ).show(context);
        } else {
          // Handle the case where the update failed silently
          print("Update failed: Response status is 0.");
        }
      } else {
        print("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  double getTotalBeneficiaryPercentage(int current_member_index) {
    final policy =
        Constants.currentleadAvailable!.policies[current_member_index];
    final String currentReference = policy.reference;
    final List<dynamic> membersList = policy.members ?? [];
    double total = 0.0;
    for (var m in membersList) {
      if (m is Map<String, dynamic>) {
        if ((m['type'] as String?)?.toLowerCase() == 'beneficiary' &&
            m['reference'] == currentReference) {
          total += (m['percentage'] ?? 0.0) is int
              ? (m['percentage'] as int).toDouble()
              : (m['percentage'] as double);
        }
      } else if (m is Member) {
        if ((m.type ?? '').toLowerCase() == 'beneficiary' &&
            m.reference == currentReference) {
          total += (m.percentage ?? 0.0);
        }
      }
    }
    return total;
  }

  Future<bool> removeBeneficiaryMember(
      Member member, String currentReference) async {
    // Build the URL for the removeBeneficiary endpoint.
    final String url =
        "${Constants.InsightsAdminbaseUrl}parlour/removeBeneficiary";

    print("Payload: ${member.toJson()}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(member.toJson()),
      );
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        String result = response.body;
        print("Remove beneficiary Response: $result");

        // If the delete command returns "0", no rows were deleted.
        if (result == "0") {
          MotionToast.error(
            description: Text(
              "Beneficiary removal failed: no record found.",
              style: TextStyle(color: Colors.white),
            ),
            animationDuration: Duration(milliseconds: 500),
          ).show(context);
          return false;
        }

        setState(() {});
        MotionToast.success(
          height: 45,
          description: const Text(
            "Beneficiary removed successfully.",
            style: TextStyle(color: Colors.white),
          ),
          animationDuration: Duration(milliseconds: 500),
        ).show(context);

        return true;
      } else {
        MotionToast.error(
          description: Text(
            "HTTP error: ${response.statusCode}",
            style: TextStyle(color: Colors.white),
          ),
          animationDuration: Duration(milliseconds: 500),
        ).show(context);
        return false;
      }
    } catch (e) {
      MotionToast.error(
        description: Text(
          "Exception: $e",
          style: TextStyle(color: Colors.white),
        ),
        animationDuration: Duration(milliseconds: 500),
      ).show(context);
      return false;
    }
  }

  String formatLargeNumber(String valueStr) {
    const List<String> suffixes = [
      "",
      "k",
      "m",
      "b",
      "t"
    ]; // Add more suffixes as needed

    // Convert string to double and handle invalid inputs
    double value;
    try {
      value = double.parse(valueStr);
    } catch (e) {
      return 'Invalid Number';
    }

    // If the value is less than 1000, return it as a string with commas
    if (value < 1000) {
      return formatWithCommas(value);
    }

    // Determine the correct suffix and scale the number accordingly
    int suffixIndex = 0;
    while (value >= 1000 && suffixIndex < suffixes.length - 1) {
      value /= 1000;
      suffixIndex++;
    }

    // Format the number with 1 decimal place if it's not a whole number
    final formattedValue =
        (value % 1 == 0) ? value.toInt().toString() : value.toStringAsFixed(1);

    return '$formattedValue${suffixes[suffixIndex]}';
  }

  // Helper function to determine gender from South African ID number
  String getGenderFromId(String idNumber) {
    if (idNumber.length >= 10) {
      // In South African ID: positions 6-9 represent gender (0000-4999 = female, 5000-9999 = male)
      int genderDigits = int.tryParse(idNumber.substring(6, 10)) ?? 0;
      return genderDigits >= 5000 ? "male" : "female";
    }
    return "unknown"; // If ID format is invalid
  }

  // Helper function to determine the old payer's new relationship
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

  // Helper function to update member on backend
  Future<void> updateMemberBackend(BuildContext context, int autoNumber,
      AdditionalMember updatedMember) async {
    String baseUrl = "${Constants.insightsBackendBaseUrl}fieldV6/updateMember/";
    int onoloadId = Constants.currentleadAvailable!.leadObject.onololeadid;

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

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Iconsax.warning_2,
                color: Colors.red,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Error',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'YuGothic',
                  color: Colors.red,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              message.replaceAll('<br>', '\n'), // Convert HTML <br> to newlines
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'YuGothic',
                color: Colors.black87,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Constants.ftaColorLight,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 42, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: const Text(
                'Close',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'YuGothic',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

String formatWithCommas(double value) {
  final format = NumberFormat("#,##0", "en_US");
  return format.format(value);
}

class AddBeneficiaryMember extends StatefulWidget {
  final AdditionalMember selectedMember;
  final String? currentReference;
  final int current_member_index;

  const AddBeneficiaryMember({
    Key? key,
    required this.selectedMember,
    required this.currentReference,
    required this.current_member_index,
  }) : super(key: key);

  @override
  State<AddBeneficiaryMember> createState() => _AddBeneficiaryMemberState();
}

class _AddBeneficiaryMemberState extends State<AddBeneficiaryMember> {
  // Controller for the percentage input.
  final TextEditingController percentageTxt = TextEditingController();

  // Define relationship options.
  final List<String> relationshipOptions = [
    "Partner",
    "Parent",
    "Child",
    "Sister",
    "Brother",
    "Aunt",
    "Niece",
    "Nephew",
    "Adult child",
    "Grandmother",
    "Grandfather",
    "Cousin",
    "Uncle",
    "Brother in Law",
    "Sister in Law",
    "Daughter in Law",
    "Son in Law",
    "Father in Law",
    "Mother in Law",
    "Additional Partner",
    "Benefactor to Children",
    "Broker",
    "Charity",
    "Dependant",
    "Employee",
    "Employer",
    "Estate",
    "Family Trust",
    "Fiance",
    "Friend",
    "Grandparent",
    "Guardian",
    "Housekeeper",
    "Intermediary",
    "Third Party Insurer",
    "Other"
  ];
  String? _selectedRelationship;

  @override
  void initState() {
    super.initState();

    percentageTxt.text =
        getRemainingBeneficiaryPercentage(widget.current_member_index)
            .round()
            .toString();

    // Convert relationship options to lowercase for comparison.
    final lowerCaseOptions =
        relationshipOptions.map((option) => option.toLowerCase()).toList();
    final selectedRelationshipLower =
        widget.selectedMember.relationship.toLowerCase();

    if (lowerCaseOptions.contains(selectedRelationshipLower)) {
      int indexOfSelectedRelationship =
          lowerCaseOptions.indexOf(selectedRelationshipLower);
      _selectedRelationship = relationshipOptions[indexOfSelectedRelationship];
    }
  }

  double getRemainingBeneficiaryPercentage(int current_member_index) {
    final policy =
        Constants.currentleadAvailable!.policies[current_member_index];
    final String currentReference = policy.reference;
    final List<dynamic> membersList = policy.members ?? [];
    double total = 0.0;

    for (var m in membersList) {
      if (m is Map<String, dynamic>) {
        if ((m['type'] as String?)?.toLowerCase() == 'beneficiary' &&
            m['reference'] == currentReference) {
          if (m['percentage'] is int) {
            total += (m['percentage'] as int).toDouble();
          } else if (m['percentage'] is double) {
            total += m['percentage'] as double;
          }
        }
      } else if (m is Member) {
        if ((m.type ?? '').toLowerCase() == 'beneficiary' &&
            m.reference == currentReference) {
          total += (m.percentage ?? 0.0);
        }
      }
    }

    double remaining = 100.0 - total;
    return remaining < 0 ? 0 : remaining;
  }

  // A helper to build the action button.
  Widget _buildActionButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'YuGothic',
        ),
      ),
    );
  }

  Future<void> addBeneficiaryMember(BuildContext context) async {
    if (_selectedRelationship == null) {
      MotionToast.error(
        description: Text(
          "Please select a relationship",
          style: TextStyle(color: Colors.white),
        ),
        animationDuration: const Duration(seconds: 2),
      ).show(context);
      return;
    }

    // A) Identify current policy & reference.
    if (Constants.currentleadAvailable!.policies.isNotEmpty) {
      final policy =
          Constants.currentleadAvailable!.policies[current_member_index];
      final List<dynamic> rawList = policy.members ?? [];
      final int newPercentage = int.tryParse(percentageTxt.text) ?? 0;

      // We'll build a new list with unique items by `auto_number` (or any unique key).
      final List<dynamic> dedupedMembers = [];
      final Set<String> seenAutoNumbers = {};

      for (var item in rawList) {
        String? autoNumberStr;

        if (item is Map<String, dynamic>) {
          // Extract the 'auto_number' as a string
          final rawAutoNum = item['auto_number'] ?? item['autoNumber'];
          autoNumberStr = rawAutoNum?.toString();
        } else if (item is Member) {
          // In your `Member` class, you presumably have `autoNumber` as an int?
          autoNumberStr = item.autoNumber?.toString();
        } else {
          // Unknown type => skip or handle differently
          continue;
        }

        // If there's no auto_number, skip or treat it as "0"
        autoNumberStr ??= '0';

        // Only add this item if we haven't seen this auto_number yet
        if (!seenAutoNumbers.contains(autoNumberStr)) {
          seenAutoNumbers.add(autoNumberStr);
          dedupedMembers.add(item);
        }
      }

      // Now loop over `dedupedMembers` instead of rawList
      int currentBeneficiariesTotal = 0;
      for (var member in dedupedMembers) {
        print("Debug => $member");

        if (member is Map<String, dynamic>) {
          if ((member['type']?.toString().toLowerCase() == 'beneficiary') &&
              (member['reference'] == widget.currentReference)) {
            if (member['autoNumber'] != widget.selectedMember.autoNumber) {
              currentBeneficiariesTotal +=
                  int.tryParse(member['percentage']?.toString() ?? "0") ?? 0;
            }
          }
        } else if (member is Member) {
          if ((member.type?.toLowerCase() == 'beneficiary') &&
              (member.reference == widget.currentReference)) {
            if (member.autoNumber != widget.selectedMember.autoNumber) {
              currentBeneficiariesTotal += member.percentage ?? 0;
            }
          }
        }
      }

      final int updatedTotal = currentBeneficiariesTotal + newPercentage;
      if (updatedTotal > 100) {
        MotionToast.error(
          description: Text(
            "Total beneficiary percentage cannot exceed 100%. Currently allocated: $currentBeneficiariesTotal%.\nAdding $newPercentage% would result in $updatedTotal%.",
            style: TextStyle(color: Colors.white),
          ),
          animationDuration: const Duration(seconds: 2),
        ).show(context);
        return;
      }
      if (Constants.currentleadAvailable!.policies.isNotEmpty) {
        final policy =
            Constants.currentleadAvailable!.policies[current_member_index];
        final currentReference = policy.reference;

        // Get the members list (if null, use an empty list).
        final List<dynamic> membersList = policy.members ?? [];

        // Replace with your actual endpoint URL.
        final String url =
            "${Constants.InsightsAdminbaseUrl}parlour/addBeneficiary";

        // Build the JSON payload using the selected member and chosen relationship/percentage.
        Map<String, dynamic> payload = {
          "auto_number": "", // Generated server-side.
          "timestamp": DateTime.now().toIso8601String(),
          "last_update": DateTime.now().toIso8601String(),
          "reference": widget.currentReference,
          "additional_member_id": widget.selectedMember.autoNumber,
          "premium": "", // Adjust as needed.
          "percentage": int.tryParse(percentageTxt.text) ?? 0,
          "cover": 0,
          "type": "beneficiary",
          "ben_relationship": _selectedRelationship,
          "isMaintenance": false,
          "empid": Constants.cec_employeeid,
          "cec_client_id": Constants.cec_client_id,
        };
        print("gffggfgh ${payload}");

        try {
          final response = await http.post(
            Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(payload),
          );

          if (response.statusCode == 200) {
            Map<String, dynamic> jsonResponse = jsonDecode(response.body);
            print("Responsefgghghjjh: $jsonResponse");

            // Create an AdditionalMember beneficiary from the response.
            Member beneficiary = Member.fromJson(jsonResponse);

            // C) Update policy.members: add or replace the beneficiary.
            final existingIndex = membersList.indexWhere((m) {
              if (m is Map<String, dynamic>) {
                // print("dfgfghghjjh ${m}");
                return (m['additional_member_id'] ==
                    widget.selectedMember.autoNumber);
              } else if (m is Member) {
                return (m.autoNumber == widget.selectedMember.autoNumber);
              }
              return false;
            });
            print("Responsefgf2gf : ${policy.members}");

            if (existingIndex != -1) {
              // Replace the existing beneficiary.
              membersList[existingIndex] = beneficiary.toJson();
            } else {
              // Otherwise, add the new beneficiary.
              membersList.add(beneficiary.toJson());
            }

            // Update the policy's members object.
            policy.members = membersList;
            print("Responsefgf : ${policy.members}");

            // (Optional) Recalculate premium here if necessary.
            // calculatePolicyPremiumCal();

            setState(() {});

            MotionToast.success(
              height: 45,
              description: const Text(
                "Beneficiary added successfully.",
                style: TextStyle(color: Colors.white),
              ),
              animationDuration: const Duration(milliseconds: 500),
            ).show(context);

            Navigator.of(context).pop(); // Close this dialog.
          } else {
            MotionToast.error(
              description: Text(
                "HTTP error: ${response.statusCode}",
                style: TextStyle(color: Colors.white),
              ),
              animationDuration: const Duration(milliseconds: 500),
            ).show(context);
          }
        } catch (e) {
          MotionToast.error(
            description: Text(
              "Exception: $e",
              style: TextStyle(color: Colors.white),
            ),
            animationDuration: const Duration(milliseconds: 500),
          ).show(context);
        }
      }

      @override
      Widget build(BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 350),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              // Wrapping content in SingleChildScrollView so that if content overflows vertically it scrolls.
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      // Header row: Title and close icon.
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Edit Member Info',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'YuGothic',
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(Icons.close, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Percentage label and input.
                      Row(
                        children: const [
                          Text(
                            "Percentage",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      CustomInputTransparent4(
                        controller: percentageTxt,
                        hintText: "Enter percentage",
                        integersOnly: true,
                        onChanged: (val) {},
                        onSubmitted: (val) {},
                        focusNode: FocusNode(),
                        textInputAction: TextInputAction.next,
                        isPasswordField: false,
                        isEditable: true,
                      ),
                      const SizedBox(height: 16),
                      // Relationship label and dropdown.
                      Row(
                        children: const [
                          Text(
                            "Relationship",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              borderRadius: BorderRadius.circular(8),
                              dropdownColor: Colors.white,
                              style: const TextStyle(
                                fontFamily: 'YuGothic',
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              isExpanded: true,
                              // Add the hint property so that when value is null, this shows.
                              hint: const Text(
                                "Select a relationship",
                                style: TextStyle(color: Colors.grey),
                              ),
                              // Ensure _selectedRelationship is null initially
                              value: _selectedRelationship,
                              items: relationshipOptions.map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedRelationship = newValue;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      // Action button.
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40,
                              child: _buildActionButton(
                                text: 'Save',
                                color: Constants.ftaColorLight,
                                onPressed: () async {
                                  await addBeneficiaryMember(context)
                                      .then((value) {
                                    setState(() {});
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
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
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 350),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          // Wrap in a SingleChildScrollView so that content scrolls if it overflows.
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Header row: Title and close icon.
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Edit Member Info',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'YuGothic',
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(Icons.close, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Percentage label and input.
                  Row(
                    children: const [
                      Text(
                        "Percentage",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CustomInputTransparent4(
                    controller: percentageTxt,
                    hintText: "Enter percentage",
                    integersOnly: true,
                    onChanged: (val) {},
                    onSubmitted: (val) {},
                    focusNode: FocusNode(),
                    textInputAction: TextInputAction.next,
                    isPasswordField: false,
                    isEditable: true,
                  ),
                  const SizedBox(height: 16),
                  // Relationship label and dropdown.
                  Row(
                    children: const [
                      Text(
                        "Relationship",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          borderRadius: BorderRadius.circular(8),
                          dropdownColor: Colors.white,
                          style: const TextStyle(
                            fontFamily: 'YuGothic',
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          isExpanded: true,
                          value: _selectedRelationship,
                          items: relationshipOptions.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedRelationship = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Action button.
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: _buildActionButton(
                            text: 'Update',
                            color: Constants.ftaColorLight,
                            onPressed: () async {
                              await addBeneficiaryMember(context);
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ],
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
}

extension ReadableCamel on String {
  String toReadable() =>
      replaceAllMapped(RegExp(r'(?<!^)(?=[A-Z])'), (_) => ' ');
  String toTitleCase() => split(' ')
      .map((word) => word.isEmpty
          ? word
          : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
      .join(' ');
}

class AdvancedPremiumPayerMemberCard extends StatefulWidget {
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
  final String otherUnknownIncome;
  final String otherUnknownWealth;
  final int autoNumber;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onSingleTap;
  final int? noOfMembers;
  final int? current_member_index;
  final bool? isSelected;
  final bool? isEditing;
  final bool? is_self_or_payer;
  final double? cover;
  final double? premium;
  final double? riderAmount;
  final bool? allowScaling;

  const AdvancedPremiumPayerMemberCard({
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
    required this.otherUnknownIncome,
    required this.otherUnknownWealth,
    required this.autoNumber,
    this.onDoubleTap,
    this.onSingleTap,
    this.noOfMembers,
    this.isSelected,
    this.isEditing,
    this.riderAmount,
    this.current_member_index,
    this.is_self_or_payer,
    this.cover,
    this.premium,
    this.allowScaling,
  }) : super(key: key);

  @override
  State<AdvancedPremiumPayerMemberCard> createState() =>
      _AdvancedPremiumPayerMemberMemberCardState();
}

class _AdvancedPremiumPayerMemberMemberCardState
    extends State<AdvancedPremiumPayerMemberCard> {
  bool isHovered = false;
  int number_of_members = 0;

  @override
  void initState() {
    super.initState();
    recalculateMembersCount();

    myNotifier = MyNotifier(appBarMemberCardNotifier, context);
    appBarMemberCardNotifier.addListener(() {
      recalculateMembersCount();
      setState(() {});
      print("Number of members jhh : $number_of_members");
    });
  }

  void recalculateMembersCount() {
    if (Constants.currentleadAvailable != null &&
        Constants.currentleadAvailable!.policies.isNotEmpty) {
      // Get the member count; if it's less than 1, default to 1.
      int memberCount = Constants.currentleadAvailable!
          .policies[widget.current_member_index!].members.length;
      number_of_members = memberCount < 1 ? 1 : memberCount;
    } else {
      number_of_members = 1;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onDoubleTap: widget.onDoubleTap,
        onTap: widget.onSingleTap,
        child: AnimatedScale(
          scale: (widget.allowScaling != null || widget.allowScaling == false)
              ? 1.0
              : isHovered
                  ? 1.02
                  : 1.0,
          duration: const Duration(milliseconds: 200),
          child: CustomCard2(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
            color: Colors.white,
            boderRadius: 12,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.isSelected == true
                      ? Constants.ftaColorLight.withOpacity(0.95)
                      : Colors.transparent,
                ),
              ),
              margin:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
              padding: const EdgeInsets.all(0.0),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch, // Stretch to tallest child
                children: [
                  // Left container with CircleAvatar
                  Container(
                    width: 145,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      color: widget.isSelected == true
                          ? Constants.ftaColorLight.withOpacity(0.95)
                          : Constants.ftaColorLight.withOpacity(0.15),
                    ),
                    child: Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: widget.isSelected == true
                            ? Colors.grey.withOpacity(0.65)
                            : Constants.ftaColorLight,
                        child: Icon(
                          widget.gender.toLowerCase() == "female"
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
                          right: 16.0, left: 16, top: 16, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min, // Minimize height
                        children: [
                          if (widget.dob.isNotEmpty)
                            Text(
                              'DoB: ${DateFormat('dd MMM yyyy').format(DateTime.parse(widget.dob))}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'YuGothic',
                                color: Colors.black,
                              ),
                              overflow:
                                  TextOverflow.ellipsis, // Prevent overflow
                            ),
                          const SizedBox(height: 8.0),
                          Text(
                            '${widget.title} ${widget.name} ${widget.surname}',
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
                                  'Relationship: ${widget.relationship[0].toUpperCase() + widget.relationship.substring(1)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow:
                                      TextOverflow.ellipsis, // Prevent overflow
                                ),
                              ),
                            ],
                          ),
                          //const SizedBox(height: 8.0),
                          const SizedBox(height: 4.0),
                          if (widget.riderAmount != null)
                            Row(
                              children: [
                                Text(
                                  'Total Rider Amount: R${(widget.riderAmount ?? 0).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow:
                                      TextOverflow.ellipsis, // Prevent overflow
                                ),
                                Spacer(),
                              ],
                            ),
                          const SizedBox(height: 8.0),
                        ],
                      ),
                    ),
                  ),
                  // Edit button column
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, bottom: 16, right: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
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
                                    child: NewMemberDialog2(
                                        isEditMode: widget.isEditing!,
                                        autoNumber: widget.autoNumber,
                                        relationship: "Self/Payer",
                                        title: widget.title,
                                        name: widget.name,
                                        surname: widget.surname,
                                        dob: widget.dob,
                                        phone: widget.contact,
                                        sourceOfIncome: widget.sourceOfIncome,
                                        sourceOfWealth: widget.sourceOfWealth,
                                        idNumber: widget.id,
                                        is_self_or_payer:
                                            widget.is_self_or_payer,
                                        canAddMember: true,
                                        gender: widget.gender,
                                        current_member_index: 0),
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
        ),
      ),
    );
  }

  Future<void> _showDeleteMemberDialog(
      int, member_id, String member_name) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return DeleteMemberDialog(
            member_id: member_id, member_name: member_name);
      },
    );

    // If user confirmed, download the file
    if (confirmed == true) {}
  }
}
