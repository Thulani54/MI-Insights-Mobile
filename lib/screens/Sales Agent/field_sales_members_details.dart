import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:screenshot/screenshot.dart';

import '../../constants/Constants.dart';

import '../../customwidgets/CustomCard.dart';
import '../../customwidgets/custom_input.dart';
import '../../models/map_class.dart';

import 'field_call_lead_dialog.dart';
import 'field_premium_calculator.dart';
import 'need_analysis.dart';

class FieldSalesMembersDetails extends StatefulWidget {
  const FieldSalesMembersDetails({super.key});

  @override
  State<FieldSalesMembersDetails> createState() =>
      _FieldSalesMembersDetailsState();
}

class _FieldSalesMembersDetailsState extends State<FieldSalesMembersDetails>
    with SingleTickerProviderStateMixin {
  UniqueKey unique_key1 = UniqueKey();
  final needsAnalysisValueNotifier2 = ValueNotifier<int>(0);

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
  String? _physicalAddressProvince;
  String? _postalAddressProvince;
  String? _beneficiaryAddressProvince;
  List<String> paymentType = [
    "Cash",
    "Debit Order",
    "Persal",
    "Salary Deduction",
  ];
  List<String> provinceList = [
    "KwaZulu-Natal",
    "Gauteng",
    "Mpumalanga",
    "North West",
    "Northern Cape",
    "Western Cape",
    "Free State",
    "Limpopo"
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
  List<double> policiesSelectedCoverAmounts = [];

  bool allow_editing = false;

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
  List<String> payDay = List<String>.generate(
    31,
    (pay) => (pay + 1).toString().padLeft(2, '0'),
  );

  // Example usage with formatting during display

  TabController? _tabController;
  List<String> policiesSelectedMainInsuredDOBs = [];
  int current_member_index = 0;
  List<String> dateOfBirthList = [];
  List<QuoteRates> allRates = [];
  List<String> distinctProducts = [];
  List<dynamic> membersPerPolicy = [];
  List<String> distinctProdTypes = [];
  List<double> distinctCoverAmounts = [];
  List<CalculatePolicyPremiumResponse> policyPremiums = [];
  LeadObject? currentLeadObj;
  List<String> policiesSelectedProducts = [];
  List<String> policiesSelectedProdTypes = [];
  String selectedProductString = "";
  String? _selectedProdType;
  List<List<double>> policiescoverAmounts = [];
  List<Map> policiesSelectedPartners = [];
  List<Map> policiesSelectedChildren = [];
  List<Map> policiesSelectedExtended = [];
  List<Map> policiesSelectedBeneficiaries = [];

  List<BottomBar> bottomBarList = [
    BottomBar("Main Members", "main_members"),
    BottomBar("Beneficiaries", "beneficiaries"),
    BottomBar("Members", "Members"),
    BottomBar("Employers Details", "employers_details"),
    BottomBar("Premium Payer/Policy Holder", "premium_payer"),
  ];
  List<AdditionalMember> additionalMembers = [];
  List<AdditionalMember> mainMembers = [];
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
    payDay.forEach((day) {
      print(day.toString().padLeft(2, '0')); // Outputs "01", "02", ..., "31"
    });
    print("fvgghhgfhdghgdh");
    obtainMainInsuredForEachPolicy();
    updateEmployersDetails();
    updatePhysicalAndPostalAddress();
    getPremiumPayerDetails();
    getProoductList();
    calculatePolicyPremiumCal();

    _tabController = TabController(length: bottomBarList.length, vsync: this);
  }

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
        var employer = Constants.currentleadAvailable?.employer;

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
      if (Constants.currentleadAvailable?.addresses != null) {
        addressController.text = Constants
                .currentleadAvailable!.addresses!.addressAutoNumber
                .toString() +
            Constants.currentleadAvailable!.addresses!.physaddressLine1;
        suburbController.text =
            Constants.currentleadAvailable!.addresses!.physaddressLine2;
        cityController.text =
            Constants.currentleadAvailable!.addresses!.physaddressLine3;
        codeController.text =
            Constants.currentleadAvailable!.addresses!.physaddressCode;
        provinceController.text =
            Constants.currentleadAvailable!.addresses!.physaddressProvince;
        if (sameAsPhysicalAddress == true) {
          addressPostalController.text = addressController.text;
          suburbPostalController.text = suburbController.text;
          cityPostalController.text = cityController.text;
          codePostalController.text = codeController.text;
          provincePostalController.text = provinceController.text;
        }
        if (beneficialSameAsPhysicalAddress2 == true) {
          addressBeneficialController.text = addressController.text;
          suburbBeneficialController.text = suburbController.text;
          cityBeneficialController.text = cityController.text;
          codeBeneficialController.text = codeController.text;
          provinceBeneficialController.text = provinceController.text;
        }
        if (beneficialSameAsPhysicalAddress2 == false) {
          addressBeneficialController.text = Constants
              .currentleadAvailable!.beneficiaryAddress!.physaddressLine1;
          suburbBeneficialController.text = Constants
              .currentleadAvailable!.beneficiaryAddress!.physaddressLine2;
          cityBeneficialController.text = Constants
              .currentleadAvailable!.beneficiaryAddress!.physaddressLine3;
          codeBeneficialController.text = Constants
              .currentleadAvailable!.beneficiaryAddress!.physaddressCode;
          provinceBeneficialController.text = Constants
              .currentleadAvailable!.beneficiaryAddress!.physaddressProvince;
        }
        if (sameAsPhysicalAddress == false) {
          addressPostalController.text = Constants
                  .currentleadAvailable!.addresses!.addressAutoNumber
                  .toString() +
              Constants.currentleadAvailable!.addresses!.physaddressLine1;
          suburbPostalController.text =
              Constants.currentleadAvailable!.addresses!.postaddressLine2;
          cityPostalController.text =
              Constants.currentleadAvailable!.addresses!.postaddressLine3;
          codePostalController.text =
              Constants.currentleadAvailable!.addresses!.physaddressCode;
          provincePostalController.text =
              Constants.currentleadAvailable!.addresses!.physaddressProvince;
        }
      }
      setState(() {});
    }
  }

  void updatePayerDetails({
    required BuildContext context,
  }) async {
    const String url =
        "https://miinsightsapps.net/backend_api/api/parlour/updatePayer";

    String debitDate = debitDayController.text;
    int onololeadid = Constants
        .currentleadAvailable!.policies[current_member_index].quote.onololeadid;
    String current_reference = Constants
        .currentleadAvailable!.policies[current_member_index].quote.reference;
    // Check if any required field is empty
    if (addressController.text.isEmpty) {
      MotionToast.error(
        height: 40,
        width: 300,
        onClose: () {},
        description: Text("Address is required"),
      ).show(context);

      return;
    }
    if (suburbController.text.isEmpty) {
      MotionToast.error(
        height: 40,
        width: 300,
        onClose: () {},
        description: Text("Suburb is required"),
      ).show(context);

      return;
    }
    if (cityController.text.isEmpty) {
      MotionToast.error(
        height: 40,
        width: 300,
        onClose: () {},
        description: Text("City is required"),
      ).show(context);

      return;
    }
    if (codeController.text.isEmpty) {
      MotionToast.error(
        height: 40,
        width: 300,
        onClose: () {},
        description: Text("Code is required"),
      ).show(context);

      return;
    }
    if (provinceController.text.isEmpty) {
      MotionToast.error(
        height: 40,
        width: 300,
        onClose: () {},
        description: Text("Province is required"),
      ).show(context);

      return;
    }
    if (debitDayController.text.isEmpty) {
      MotionToast.error(
        height: 40,
        width: 300,
        onClose: () {},
        description: Text("Debit day is required"),
      ).show(context);

      return;
    }
    final addressesJson = jsonEncode({
      "auto_number": 943961,
      "onololeadid": onololeadid,
      "postaddress_line1": addressPostalController.text,
      "postaddress_line2": suburbPostalController.text,
      "postaddress_line3": cityPostalController.text,
      "postaddress_code": codePostalController.text,
      "postaddress_province": provincePostalController.text,
      "physaddress_line1": addressController.text,
      "physaddress_line2": suburbController.text,
      "physaddress_line3": cityController.text,
      "physaddress_code": codeController.text,
      "physaddress_province": provinceController.text,
      "latitude": "",
      "longitude": "",
      "validated": null,
      "updated_by": "3",
    });

    final premiumPayersJson = [
      {
        "auto_number": 1072836,
        "bankname": bankInstitutionController.text,
        "branchname": branchNameController.text,
        "branchcode": branchCodeController.text,
        "accno": accountNumberController.text,
        "accounttype": accountTypeController.text,
        "salarydate": "",
        "collectionday": "30",
        "reference": current_reference,
        "onololeadid": onololeadid,
        "acount_holder": "Mr Family Sur",
        "combine_premium": "yes",
        "updated_by": "3",
      },
      // Add more payers as needed
    ];

    final beneficiaryAddressJson = jsonEncode({
      "id": 0,
      "onololeadid": onololeadid,
      "physaddress_line1": addressBeneficialController.text,
      "physaddress_line2": suburbBeneficialController.text,
      "physaddress_line3": cityBeneficialController.text,
      "physaddress_code": codeBeneficialController.text,
      "physaddress_province": provinceBeneficialController.text,
    });

    // Prepare the form data
    final Map<String, dynamic> formData = {
      'addresses': addressesJson,
      'premiumPayers': jsonEncode(premiumPayersJson),
      'debit_date': debitDate,
      'beneficiary_Address': beneficiaryAddressJson,
    };

    try {
      // Make the HTTP POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(formData),
      );

      // Check the response
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        // Assuming the response body contains { "status": 1 } or { "status": 0 }
        if (responseBody['status'] == 1) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Payer details updated successfully")),
          );
        } else {
          // Log failure for debugging
          print("Update failed: ${responseBody['message'] ?? 'Unknown error'}");
        }
      } else {
        print("Server error: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Error occurred: $e");
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
    PremiumPayer premiumPayer =
        Constants.currentleadAvailable!.policies[0].premiumPayer;
    bankInstitutionController.text = premiumPayer.bankname;
    branchNameController.text = premiumPayer.branchname;
    branchCodeController.text = premiumPayer.branchcode;
    accountNumberController.text = premiumPayer.accno;
    accountTypeController.text = premiumPayer.accounttype;
    accountHolderController.text = premiumPayer.acountHolder;
    debitDayController.text = premiumPayer.collectionday;
    debitDayController.text = premiumPayer.combinePremium;
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

      // print("Total Main Members Found: ${mainMembers.length}");

      // Single UI update after processing
      setState(() {});
    } else {
      print("No current lead available.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 24, right: 24),
                child: DefaultTabController(
                  length: bottomBarList.length,
                  child: SingleChildScrollView(
                    scrollDirection:
                        Axis.horizontal, // Allow horizontal scrolling
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Container(
                  height: 155,
                  width: MediaQuery.of(context).size.width,
                  child: mainMembers.isEmpty
                      ? Center()
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: mainMembers.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, right: 16),
                              child: Column(
                                children: [
                                  Container(
                                    height: 120,
                                    width: 450,
                                    child: AdvancedMemberCard(
                                      id: mainMembers[index].id,
                                      dob: mainMembers[index].dob,
                                      surname: mainMembers[index].surname,
                                      contact: mainMembers[index].contact,
                                      sourceOfWealth:
                                          mainMembers[index].sourceOfWealth,
                                      dateOfBirth: mainMembers[index].dob,
                                      sourceOfIncome:
                                          mainMembers[index].sourceOfIncome,
                                      title: mainMembers[index].title,
                                      name: mainMembers[index].name,
                                      relationship:
                                          mainMembers[index].relationship,
                                      gender: mainMembers[index].gender,
                                      autoNumber: mainMembers[index].autoNumber,
                                      isSelected: current_member_index == index,
                                      noOfMembers: Constants
                                                  .currentleadAvailable ==
                                              null
                                          ? 0
                                          : Constants
                                              .currentleadAvailable!
                                              .policies[current_member_index]
                                              .members
                                              .length,
                                      onSingleTap: () {
                                        current_member_index = index;
                                        policy_member_index = index;

                                        print("dgfgfgf $current_member_index");
                                        print(
                                            "policy switch index____ $policy_member_index");
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
              SizedBox(
                //current_member_index
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24),
                child: Divider(color: Colors.grey.withOpacity(0.35)),
              ),
              Container(
                // width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height + 900,
                padding: const EdgeInsets.only(left: 8, right: 0),
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
                          //current_member_index
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                                    BorderRadius.circular(360)),
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
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'YuGothic',
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
                          ],
                        ),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                                    BorderRadius.circular(360)),
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
                                                              color: Colors.grey
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
                                                      padding: EdgeInsets.only(
                                                          top: 12, left: 12),
                                                      child: Text(
                                                        (policiesSelectedProducts
                                                                        .length ==
                                                                    0 ||
                                                                current_member_index <
                                                                    policiesSelectedProducts
                                                                        .length)
                                                            ? "R0.00"
                                                            : "R${policyPremiums[current_member_index].totalPremium!.toStringAsFixed(2)}",
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24,
                        ),
                        buildBeneficiariesList(),
                        const SizedBox(height: 16),
                        Center(
                          child: InkWell(
                            child: Container(
                              height: 45,
                              width: 200,
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
                                      "Add A Beneficiary",
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0),
                          child: Container(
                            height: 155,
                            width: MediaQuery.of(context).size.width,
                            child: Constants
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
                                              child: AdvancedMemberCard(
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
                        ),
                        SizedBox(
                          height: 24,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                  Container(
                                    width: MediaQuery.of(context).size.width,
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
                                            padding: const EdgeInsets.all(12.0),
                                            child: Center(
                                              child: Text(
                                                "Employer Details",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
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
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              CustomInputTransparent4(
                                                controller:
                                                    employerNameController,
                                                hintText: 'Employer Name',
                                                onChanged: (String) {},
                                                onSubmitted: (String) {},
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
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              CustomInputTransparent4(
                                                controller:
                                                    occupationController,
                                                hintText: 'Occupation',
                                                onChanged: (String) {},
                                                onSubmitted: (String) {},
                                                focusNode: occupationFocusNode,
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
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              CustomInputTransparent4(
                                                controller:
                                                    employeeNumberController,
                                                hintText: 'Employee Number',
                                                onChanged: (String) {},
                                                onSubmitted: (String) {},
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
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(selectedSalaryRange
                                                  .toString()),
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
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(selectedPayDay ?? ""),
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
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                ),
                                              ),
                                              const SizedBox(height: 2),
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
                                                '',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              TextButton(
                                                onPressed: () {
                                                  updateEmployersRequest(
                                                    employerId: '895029',
                                                    leadId: '952080',
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
                                                    selectedPayDay:
                                                        selectedPayDay!,
                                                  );

                                                  setState(() {});
                                                },
                                                style: TextButton.styleFrom(
                                                    minimumSize: Size(
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                        48),
                                                    backgroundColor: Constants
                                                        .ftaColorLight),
                                                child: const Text(
                                                  "Submit",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'YuGothic',
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 24),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(
                          height: 24,
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
                        Padding(
                          padding: const EdgeInsets.all(4.0),
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
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.15),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        topLeft: Radius.circular(12),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Center(
                                        child: Text(
                                          "Banking Details",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'YuGothic',
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  // Payment Type Row
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Payment Type',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'YuGothic',
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton2<String>(
                                            isExpanded: true,
                                            hint: Text(
                                              'Select payment type',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'YuGothic',
                                              ),
                                            ),
                                            items: paymentType
                                                .map((String item) =>
                                                    DropdownMenuItem<String>(
                                                      value: item,
                                                      child: Text(
                                                        item,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic',
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                            value: _selectedPaymentType,
                                            onChanged: (String? value) {
                                              setState(() {
                                                _selectedPaymentType = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  // Bank Institution Row
                                  buildInputField(
                                    title: "Bank Institution",
                                    controller: bankInstitutionController,
                                    focusNode: bankInstitutionFocusNode,
                                  ),
                                  // Branch Name Row
                                  buildInputField(
                                    title: "Branch Name",
                                    controller: branchNameController,
                                    focusNode: branchNameFocusNode,
                                  ),
                                  // Branch Code Row
                                  buildInputField(
                                    title: "Branch Code",
                                    controller: branchCodeController,
                                    focusNode: branchCodeFocusNode,
                                  ),
                                  // Account Type Row
                                  buildInputField(
                                    title: "Account Type",
                                    controller: accountTypeController,
                                    focusNode: accountTypeFocusNode,
                                  ),
                                  // Account Holder Row
                                  buildInputField(
                                    title: "Account Holder",
                                    controller: accountHolderController,
                                    focusNode: accountHolderFocusNode,
                                  ),
                                  // Debit Day Row
                                  buildInputField(
                                    title: "Debit Day",
                                    controller: debitDayController,
                                    focusNode: debitDayFocusNode,
                                  ),
                                  // Combine Premium Row
                                  buildInputField(
                                    title: "Combine Premium",
                                    controller: combinePremiumController,
                                    focusNode: combinePremiumFocusNode,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
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
                                ),
                                SizedBox(width: 8),
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
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width,
                                            40),
                                        backgroundColor:
                                            Constants.ftaColorLight),
                                    child: const Text(
                                      "Copy",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'YuGothic',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomCard(
                                      elevation: 5,
                                      surfaceTintColor: Colors.white,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(0.15),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(12),
                                                topLeft: Radius.circular(12),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Center(
                                                child: Text(
                                                  "Physical Address",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'YuGothic',
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          // Address Row
                                          buildInputField(
                                            title: "Address",
                                            controller: addressController,
                                            focusNode: addressFocusNode,
                                          ),
                                          // Suburb Row
                                          buildInputField(
                                            title: "Suburb",
                                            controller: suburbController,
                                            focusNode: suburbFocusNode,
                                          ),
                                          // City Row
                                          buildInputField(
                                            title: "City",
                                            controller: cityController,
                                            focusNode: cityFocusNode,
                                          ),
                                          // Province Row
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Province",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'YuGothic',
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                DropdownButtonHideUnderline(
                                                  child:
                                                      DropdownButton2<String>(
                                                    isExpanded: true,
                                                    hint: Text(
                                                      'Select a province',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'YuGothic',
                                                      ),
                                                    ),
                                                    items: provinceList
                                                        .map((String item) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                              value: item,
                                                              child: Text(
                                                                item,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      'YuGothic',
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                    value:
                                                        _physicalAddressProvince,
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        _physicalAddressProvince =
                                                            value;
                                                      });
                                                    },
                                                    buttonStyleData:
                                                        ButtonStyleData(
                                                      height: 50,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 14),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(360),
                                                        border: Border.all(
                                                            color:
                                                                Colors.black26),
                                                        color:
                                                            Colors.transparent,
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
                                                          Colors.transparent,
                                                    ),
                                                    dropdownStyleData:
                                                        DropdownStyleData(
                                                      elevation: 0,
                                                      maxHeight: 200,
                                                      width: 200,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Code Row
                                          buildInputField(
                                            title: "Code",
                                            controller: codeController,
                                            focusNode: codeFocusNode,
                                          ),
                                        ],
                                      ))),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomCard(
                                    elevation: 5,
                                    surfaceTintColor: Colors.white,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.grey.withOpacity(0.15),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(12),
                                              topLeft: Radius.circular(12),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Center(
                                              child: Text(
                                                "Postal Address",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        // Address Row
                                        buildInputField(
                                          title: "Address",
                                          controller: addressPostalController,
                                          focusNode: addressPostalFocusNode,
                                        ),
                                        // Suburb Row
                                        buildInputField(
                                          title: "Suburb",
                                          controller: suburbPostalController,
                                          focusNode: suburbPostalFocusNode,
                                        ),
                                        // City Row
                                        buildInputField(
                                          title: "City",
                                          controller: cityPostalController,
                                          focusNode: cityPostalFocusNode,
                                        ),
                                        // Province Row
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Province",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              DropdownButtonHideUnderline(
                                                child: DropdownButton2<String>(
                                                  isExpanded: true,
                                                  hint: Text(
                                                    'Select a province',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'YuGothic',
                                                    ),
                                                  ),
                                                  items: provinceList
                                                      .map((String item) =>
                                                          DropdownMenuItem<
                                                              String>(
                                                            value: item,
                                                            child: Text(
                                                              item,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    'YuGothic',
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ))
                                                      .toList(),
                                                  value: _postalAddressProvince,
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      _postalAddressProvince =
                                                          value;
                                                    });
                                                  },
                                                  buttonStyleData:
                                                      ButtonStyleData(
                                                    height: 50,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 14),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              360),
                                                      border: Border.all(
                                                          color:
                                                              Colors.black26),
                                                      color: Colors.transparent,
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
                                                        Colors.transparent,
                                                  ),
                                                  dropdownStyleData:
                                                      DropdownStyleData(
                                                    elevation: 0,
                                                    maxHeight: 200,
                                                    width: 200,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Code Row
                                        buildInputField(
                                          title: "Code",
                                          controller: codePostalController,
                                          focusNode: codePostalFocusNode,
                                        ),
                                      ],
                                    )),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 16),

                                    // Yes Option

                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Text(
                                        //      "Postal Same as physical address",
                                        "Copy Physical Address to Beneficiary Address",
                                        style: TextStyle(
                                          fontFamily: 'YuGothic',
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Container(
                                      width: 120,
                                      height: 35,
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            addressBeneficialController.text =
                                                addressController.text;
                                            suburbBeneficialController.text =
                                                suburbController.text;
                                            cityBeneficialController.text =
                                                cityController.text;
                                            codeBeneficialController.text =
                                                codeController.text;
                                            provinceBeneficialController.text =
                                                provinceController.text;
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                            minimumSize: Size(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                40),
                                            backgroundColor:
                                                Constants.ftaColorLight),
                                        child: const Text(
                                          "Copy",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'YuGothic',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomCard(
                              elevation: 5,
                              surfaceTintColor: Colors.white,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Header
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.15),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        topLeft: Radius.circular(12),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
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
                                  SizedBox(height: 16),

                                  // Address Row
                                  buildInputField(
                                    title: "Address",
                                    controller: addressBeneficialController,
                                    focusNode: addressBeneficialFocusNode,
                                  ),

                                  // Suburb Row
                                  buildInputField(
                                    title: "Suburb",
                                    controller: suburbBeneficialController,
                                    focusNode: suburbBeneficialFocusNode,
                                  ),

                                  // City Row
                                  buildInputField(
                                    title: "City",
                                    controller: cityBeneficialController,
                                    focusNode: cityBeneficialFocusNode,
                                  ),

                                  // Province Row
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Province",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'YuGothic',
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton2<String>(
                                            isExpanded: true,
                                            hint: Text(
                                              'Select a province',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'YuGothic',
                                              ),
                                            ),
                                            items: provinceList
                                                .map((String item) =>
                                                    DropdownMenuItem<String>(
                                                      value: item,
                                                      child: Text(
                                                        item,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic',
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                            value: _beneficiaryAddressProvince,
                                            onChanged: (String? value) {
                                              setState(() {
                                                _beneficiaryAddressProvince =
                                                    value;
                                              });
                                            },
                                            buttonStyleData: ButtonStyleData(
                                              height: 50,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 14),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(360),
                                                border: Border.all(
                                                    color: Colors.black26),
                                                color: Colors.transparent,
                                              ),
                                              elevation: 0,
                                            ),
                                            iconStyleData: const IconStyleData(
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
                                                    BorderRadius.circular(16),
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Code Row
                                  buildInputField(
                                    title: "Code",
                                    controller: codeBeneficialController,
                                    focusNode: codeBeneficialFocusNode,
                                  ),
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
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
                                        MediaQuery.of(context).size.width, 40),
                                    backgroundColor: Constants.ftaColorLight),
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
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void showAddBeneficiariesDialog(
      BuildContext context, int current_member_index) {
    // 1) Build a list of AdditionalMembers (any age, or special logic if needed)
    //    Example: all AdditionalMembers are potential beneficiaries
    List<AdditionalMember> allBeneficiariesList = [];
    if (Constants.currentleadAvailable != null) {
      allBeneficiariesList = Constants.currentleadAvailable!.additionalMembers;
    }

    // 2) Identify which beneficiaries are already in the policy
    final policy =
        Constants.currentleadAvailable!.policies[current_member_index];
    final String? currentReference = policy.reference;
    final List<dynamic> membersList = policy.members ?? [];

    // We find any 'type' == 'beneficiary' with the same reference
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
        // If your JSON key is something else (like 'auto_number'), adjust it here
        return (m['additional_member_id'] ?? -1) as int;
      } else if (m is Member) {
        // If 'autoNumber' can be null, fallback to 0 or -1
        return m.autoNumber ?? -1;
      }
      return -1;
    }).toSet();

    // 3) Remove those that are already in the policy from display
    allBeneficiariesList.removeWhere(
      (am) => existingBeneficiaryAutoNumbers.contains(am.autoNumber),
    );

    // 4) Show dialog
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        child: MovingLineDialog(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8),
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
                        "Add A Beneficiary",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Constants.ftaColorLight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Click on a member below to select them as a beneficiary",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'YuGothic',
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // -------------------- List of potential beneficiaries --------------------
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: allBeneficiariesList.length,
                      itemBuilder: (context, index) {
                        final member = allBeneficiariesList[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();

                            // 1) Create a new policy Member object (type = 'beneficiary')
                            final newPolicyMember = Member(
                              member.autoNumber,
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
                              "beneficiary",
                              // type
                              0,
                              // percentage
                              null,
                              // coverMembersCol
                              "beneficiary",
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

                            // 2) Update policy.members: add or replace
                            final existingIndex = membersList.indexWhere((m) {
                              if (m is Map<String, dynamic>) {
                                return (m['autoNumber'] == member.autoNumber) &&
                                    (m['type'] as String?)?.toLowerCase() ==
                                        'beneficiary' &&
                                    m['reference'] == currentReference;
                              } else if (m is Member) {
                                return (m.autoNumber == member.autoNumber) &&
                                    (m.type ?? '').toLowerCase() ==
                                        'beneficiary' &&
                                    m.reference == currentReference;
                              }
                              return false;
                            });

                            if (existingIndex != -1) {
                              // Replace existing beneficiary
                              membersList[existingIndex] =
                                  newPolicyMember.toJson();
                            } else {
                              // Add new beneficiary
                              membersList.add(newPolicyMember.toJson());
                            }

                            // Update the policy's members
                            policy.members = membersList;

                            // 3) Recalculate premium
                            calculatePolicyPremiumCal();

                            // 4) Rebuild UI
                            setState(() {});
                          },

                          // -------------------- The Beneficiary UI Card --------------------
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
                                    color: (member.gender.toLowerCase() ==
                                            "female")
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

  Widget buildBeneficiariesList() {
    // A) Identify current policy & reference
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
          print("No matching AdditionalMember found for autoNumber: $autoNum");
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
    return Container(
      height: combinedBeneficiaries.length * 180,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: combinedBeneficiaries.length,
        itemBuilder: (context, index) {
          final member = combinedBeneficiaries[index];
          print(
              "Processing beneficiary: autoNumber=${member.autoNumber}, name=${member.name}");

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 160,
              width: MediaQuery.of(context).size.width - 40,
              child: AdvancedMemberCard2(member: member),
            ),
          );
        },
      ),
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
            updatedBy: "0",
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

  void updateEmployersRequest({
    required String employerId,
    required String leadId,
    required TextEditingController employerNameController,
    required TextEditingController occupationController,
    required TextEditingController employeeNumberController,
    required String selectedSalaryRange,
    required String selectedSalaryFrequency,
    required String selectedPayDay,
  }) async {
    String url =
        "https://miinsightsapps.net/backend_api/api/fieldV6/updateEmployer";

    print("sdffgf1 $url");

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
      'updated_by': '3', // Hardcoded as per the requirement
      'employer_query_type': '',
      'employer_query_type_old_new': '',
      'employer_query_type_old_auto_number': '',
      'employer_timestamp': '',
      'employer_last_update': '',
      'employmentStatus': '',
      'income_source': '',
      'specify_source': '',
    };

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

        // Assuming the response body contains { "status": 1 } or { "status": 0 }
        if (responseBody == "1") {
          // Show a success message

          MotionToast.success(
            height: 40,
            width: 300,
            onClose: () {},
            description: Text("Update Successful"),
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

  Widget buildInputField({
    required String title,
    required TextEditingController controller,
    required FocusNode focusNode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'YuGothic',
            ),
          ),
          SizedBox(height: 8),
          CustomInputTransparent4(
            controller: controller,
            hintText: title,
            onChanged: (String) {},
            onSubmitted: (String) {},
            focusNode: focusNode,
            textInputAction: TextInputAction.next,
            isPasswordField: false,
          ),
        ],
      ),
    );
  }
}
