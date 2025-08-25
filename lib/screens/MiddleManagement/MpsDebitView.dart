import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../constants/Constants.dart';
import '../../customwidgets/custom_date_range_picker.dart';
import '../../services/inactivitylogoutmixin.dart';

class MpsDebitView extends StatefulWidget {
  const MpsDebitView({super.key});

  @override
  State<MpsDebitView> createState() => _MpsDebitViewState();
}

double _sliderPosition = 0.0;
int _selectedButton = 1;
int target_index = 0;
DateTime? startDate = DateTime.now();
DateTime? endDate = DateTime.now();
double _sliderPosition2 = 0.0;
int days_difference = 0;
late Future<List<Policy>> futurePolicies;

class _MpsDebitViewState extends State<MpsDebitView>
    with InactivityLogoutMixin {
  Color _button1Color = Colors.grey.withOpacity(0.0);
  Color _button2Color = Colors.grey.withOpacity(0.0);
  Color _button3Color = Colors.grey.withOpacity(0.0);
  int currentLevel = 0;
  double _sliderPosition = 0.0;

  void _animateButton(int buttonNumber, BuildContext context) {
    restartInactivityTimer();

    setState(() {
      _selectedButton = buttonNumber;

      if (buttonNumber == 1) {
        startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
        endDate = DateTime.now();
        _sliderPosition = 0.0;
      } else if (buttonNumber == 2) {
        _sliderPosition = (MediaQuery.of(context).size.width / 3) - 18;
        startDate = DateTime.now().subtract(Duration(days: 365));
        endDate = DateTime.now();
      } else if (buttonNumber == 3) {
        _sliderPosition = 2 * (MediaQuery.of(context).size.width / 3) - 32;
      }

      _button1Color = buttonNumber == 1
          ? Constants.ctaColorLight
          : Colors.grey.withOpacity(0.0);
      _button2Color = buttonNumber == 2
          ? Constants.ctaColorLight
          : Colors.grey.withOpacity(0.0);
      _button3Color = buttonNumber == 3
          ? Constants.ctaColorLight
          : Colors.grey.withOpacity(0.0);
    });

    if (buttonNumber == 3) {
      showCustomDateRangePicker(
        context,
        dismissible: false,
        minimumDate: DateTime.utc(2023, 06, 01),
        maximumDate: DateTime.now(),
        backgroundColor: Colors.white,
        primaryColor: Constants.ctaColorLight,
        onApplyClick: (start, end) {
          setState(() {
            endDate = end;
            startDate = start;
          });

          restartInactivityTimer();
        },
        onCancelClick: () {
          restartInactivityTimer();
          if (kDebugMode) {
            print("user cancelled.");
          }
          setState(() {
            _animateButton(1, context);
          });
        },
      );
    }
  }

  void _animateButton2(int buttonNumber) {
    restartInactivityTimer();

    setState(() {});

    target_index = buttonNumber;
    if (buttonNumber == 0) {
      _sliderPosition2 = 0.0;
    } else if (buttonNumber == 1) {
      _sliderPosition2 = (MediaQuery.of(context).size.width / 2) - 18;
    } else if (buttonNumber == 3) {
      if (days_difference < 31) {
        _sliderPosition2 = 2 * (MediaQuery.of(context).size.width / 3) - 32;
      }
      setState(() {});
    }
  }

  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          shadowColor: Colors.grey.withOpacity(0.45),
          elevation: 6,
          backgroundColor: Colors.white,
          title: const Text(
            "MPS Settlement Report",
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              CupertinoIcons.back,
              color: Colors.black,
              size: 24,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _animateButton(1, context);
                                },
                                child: Container(
                                  width:
                                      (MediaQuery.of(context).size.width / 3) -
                                          12,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(360),
                                  ),
                                  height: 35,
                                  child: Center(
                                    child: Text(
                                      '1 Mth View',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _animateButton(2, context);
                                },
                                child: Container(
                                  width:
                                      (MediaQuery.of(context).size.width / 3) -
                                          12,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(360),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '12 Mths View',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _animateButton(3, context);
                                },
                                child: Container(
                                  width:
                                      (MediaQuery.of(context).size.width / 3) -
                                          12,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(360),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Select Dates',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        left: _sliderPosition,
                        child: InkWell(
                          onTap: () {
                            _animateButton(3, context);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Constants
                                  .ctaColorLight, // Color of the slider
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: _selectedButton == 1
                                ? Center(
                                    child: Text(
                                      '1 Mth View',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : _selectedButton == 2
                                    ? Center(
                                        child: Text(
                                          '12 Mths View',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          'Select Dates',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 12),
                child: Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.35),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16, top: 12),
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
                                    onTap: () {},
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
                                controller: _searchController,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<Policy>>(
                future: futurePolicies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Constants.ctaColorLight,
                      ),
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No policies found'));
                  } else {
                    // Filter the policies based on the search query
                    List<Policy> filteredPolicies =
                        snapshot.data!.where((policy) {
                      return policy.policyNumber
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()) ||
                          policy.policyStatus
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()) ||
                          policy.insightsPolicyPremium
                              .toString()
                              .contains(_searchQuery);
                    }).toList();

                    if (filteredPolicies.isEmpty) {
                      return Center(child: Text('No matching policies found'));
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: Divider(),
                          );
                        },
                        itemCount: filteredPolicies.length,
                        itemBuilder: (context, index) {
                          final policy = filteredPolicies[index];
                          return ListTile(
                            title: Text(policy.policyNumber),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PolicyDetailScreen(policy: policy),
                                ),
                              );
                            },
                            subtitle: Text(
                                'Premium: ${policy.insightsPolicyPremium}, Status: ${policy.policyStatus}'),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    futurePolicies = fetchPolicies("379");
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Policy>> fetchPolicies(String clientId) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl2}/files/get_custom_data_mps/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'client_id': clientId,
        "start_date": "2024-05-01",
        "end_date": "2024-05-05"
      }),
    );

    if (response.statusCode == 200) {
      List<dynamic> customersJson = jsonDecode(response.body)['customers'];
      return customersJson.map((json) => Policy.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load policies');
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year} ${date.hour}:${date.minute}";
  }

  bool isLoadingReprints = false;
}

class Policy {
  final String policyNumber;
  final String insightsMpsTransactionId;
  final String mpsTransactionId;
  final bool transactionIdsMatch;
  final double insightsPolicyPremium;
  final String mpsPolicyPremium;
  final bool premiumsMatching;
  final String policyReference;
  final String saleDatetime;
  final String policyStatus;
  final String bankName;
  final String accountNumber;
  final String accountType;
  final String collectionDay;
  final String transactionActiveInactive;
  final String mpsClientRef1;
  final String mpsClientRef2;
  final String mpsPolicyInstallment;
  final String mpsActionDate;
  final List<FutureTransaction> futureTransactions;

  Policy({
    required this.policyNumber,
    required this.insightsMpsTransactionId,
    required this.mpsTransactionId,
    required this.transactionIdsMatch,
    required this.insightsPolicyPremium,
    required this.mpsPolicyPremium,
    required this.premiumsMatching,
    required this.policyReference,
    required this.saleDatetime,
    required this.policyStatus,
    required this.bankName,
    required this.accountNumber,
    required this.accountType,
    required this.collectionDay,
    required this.transactionActiveInactive,
    required this.mpsClientRef1,
    required this.mpsClientRef2,
    required this.mpsPolicyInstallment,
    required this.mpsActionDate,
    required this.futureTransactions,
  });

  factory Policy.fromJson(Map<String, dynamic> json) {
    var futureTransactionsJson =
        json['future_transactions'] as List<dynamic>? ?? [];
    List<FutureTransaction> futureTransactionsList = futureTransactionsJson
        .map((i) => FutureTransaction.fromJson(i as Map<String, dynamic>))
        .toList();

    return Policy(
      policyNumber: json['insights_policy_number'] ?? "",
      insightsMpsTransactionId: json['insights_mps_transaction_id'] ?? "",
      mpsTransactionId: json['mps_transaction_id'] ?? "",
      transactionIdsMatch: json['transaction_ids_match'] ?? "",
      transactionActiveInactive: json['transaction_active_inactive'] ?? "",
      mpsClientRef1: json['mps_client_ref1'] ?? "",
      mpsClientRef2: json['mps_client_ref2'] ?? "",
      mpsPolicyInstallment: json['mps_policy_installment'] ?? "",
      insightsPolicyPremium:
          double.parse((json['insights_policy_premium'] ?? "0.0").toString()),
      mpsPolicyPremium: (json['mps_policy_premium'] ?? "0.0").toString(),
      mpsActionDate: json['mps_action_date'] ?? "",
      premiumsMatching: json['premiums_matching'] ?? false,
      policyReference: json['insights_policy_reference'] ?? "",
      saleDatetime: json['insights_sale_datetime'] ?? "",
      policyStatus: json['insights_policy_status'] ?? "",
      bankName: json['insights_bank_name'] ?? "",
      accountNumber: json['insights_account_number'] ?? "",
      accountType: json['insights_account_type'] ?? "",
      collectionDay: json['insights_collection_day'] ?? "",
      futureTransactions: futureTransactionsList,
    );
  }
}

class FutureTransaction {
  final String transactionId;
  final String accountNo;
  final String actionDate;
  final String amount;
  final String instalment;
  final String instalmentStatus;

  FutureTransaction({
    required this.transactionId,
    required this.accountNo,
    required this.actionDate,
    required this.amount,
    required this.instalment,
    required this.instalmentStatus,
  });

  factory FutureTransaction.fromJson(Map<String, dynamic> json) {
    return FutureTransaction(
      transactionId: json['transaction_id'] ?? "",
      accountNo: json['account_no'] ?? "",
      actionDate: json['action_date'] ?? "",
      amount: json['amount'] ?? "",
      instalment: json['Instalment'] ?? "",
      instalmentStatus: json['instalment_status'] ?? "",
    );
  }
}

class PolicyDetailScreen extends StatelessWidget {
  final Policy policy;

  PolicyDetailScreen({required this.policy});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        shadowColor: Colors.grey.withOpacity(0.45),
        elevation: 6,
        backgroundColor: Colors.white,
        title: const Text(
          "MPS Upcoming Settlements",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            CupertinoIcons.back,
            color: Colors.black,
            size: 24,
          ),
        ),
      ),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(flex: 3, child: Text('Policy Number')),
                    Expanded(flex: 1, child: Text(':')),
                    Expanded(flex: 6, child: Text(policy.policyNumber)),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(flex: 3, child: Text('MPS Transaction ID')),
                    Expanded(flex: 1, child: Text(':')),
                    Expanded(flex: 6, child: Text(policy.mpsTransactionId)),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(flex: 3, child: Text('Insights Transaction ID')),
                    Expanded(flex: 1, child: Text(':')),
                    Expanded(
                        flex: 6, child: Text(policy.insightsMpsTransactionId)),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(flex: 3, child: Text('Transaction ID Match')),
                    Expanded(flex: 1, child: Text(':')),
                    Expanded(
                        flex: 6,
                        child: Text(policy.transactionIdsMatch.toString())),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(flex: 3, child: Text('Insights Premium')),
                    Expanded(flex: 1, child: Text(':')),
                    Expanded(
                        flex: 6,
                        child: Text(policy.insightsPolicyPremium.toString())),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(flex: 3, child: Text('MPS Premium')),
                    Expanded(flex: 1, child: Text(':')),
                    Expanded(flex: 6, child: Text(policy.mpsPolicyPremium)),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(flex: 3, child: Text('Premiums Match')),
                    Expanded(flex: 1, child: Text(':')),
                    Expanded(
                        flex: 6, child: Text(policy.premiumsMatching.toString())),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(flex: 3, child: Text('Policy Reference')),
                    Expanded(flex: 1, child: Text(':')),
                    Expanded(flex: 6, child: Text(policy.policyReference)),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(flex: 3, child: Text('Sale DateTime')),
                    Expanded(flex: 1, child: Text(':')),
                    Expanded(flex: 6, child: Text(policy.saleDatetime)),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(flex: 3, child: Text('Policy Status')),
                    Expanded(flex: 1, child: Text(':')),
                    Expanded(flex: 6, child: Text(policy.policyStatus)),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(flex: 3, child: Text('Bank Name')),
                    Expanded(flex: 1, child: Text(':')),
                    Expanded(flex: 6, child: Text(policy.bankName)),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(flex: 3, child: Text('Account Number')),
                    Expanded(flex: 1, child: Text(':')),
                    Expanded(flex: 6, child: Text(policy.accountNumber)),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(flex: 3, child: Text('Account Type')),
                    Expanded(flex: 1, child: Text(':')),
                    Expanded(flex: 6, child: Text(policy.accountType)),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(flex: 3, child: Text('Collection Day')),
                    Expanded(flex: 1, child: Text(':')),
                    Expanded(flex: 6, child: Text(policy.collectionDay)),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(flex: 3, child: Text('Transaction Active/Inactive')),
                    Expanded(flex: 1, child: Text(':')),
                    Expanded(
                        flex: 6, child: Text(policy.transactionActiveInactive)),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(flex: 3, child: Text('MPS Client Ref 1')),
                    Expanded(flex: 1, child: Text(':')),
                    Expanded(flex: 6, child: Text(policy.mpsClientRef1)),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(flex: 3, child: Text('MPS Client Ref 2')),
                    Expanded(flex: 1, child: Text(':')),
                    Expanded(flex: 6, child: Text(policy.mpsClientRef2)),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(flex: 3, child: Text('MPS Policy Installment')),
                    Expanded(flex: 1, child: Text(':')),
                    Expanded(flex: 6, child: Text(policy.mpsPolicyInstallment)),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(flex: 3, child: Text('MPS Action Date')),
                    Expanded(flex: 1, child: Text(':')),
                    Expanded(flex: 6, child: Text(policy.mpsActionDate)),
                  ],
                ),
                SizedBox(height: 12),
                // Add future transactions as rows
                Text('Future Transactions:'),
                ...policy.futureTransactions.map((ft) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Expanded(flex: 3, child: Text('Transaction ID')),
                          Expanded(flex: 1, child: Text(':')),
                          Expanded(flex: 6, child: Text(ft.transactionId)),
                        ],
                      ),
                    )),
              ],
            ),
          )),
    );
  }
}
