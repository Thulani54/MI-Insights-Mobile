import 'package:flutter/material.dart';

import '../../constants/Constants.dart';
import '../../customwidgets/CustomCard.dart';
import '../../models/PolicyDetails.dart';

class FieldSaleSummary extends StatefulWidget {
  const FieldSaleSummary({super.key});

  @override
  State<FieldSaleSummary> createState() => _FieldSaleSummaryState();
}

class _FieldSaleSummaryState extends State<FieldSaleSummary> {
  List<PolicyDetails1> allPolicies = [];

  @override
  void initState() {
    super.initState();
    allPolicies.add(PolicyDetails1(
      policyNumber: 'AMAM001',
      planType: 'Single Member - Rhino/Ubenjane',
      status: 'Inforced',
      monthsToPayFor: 1,
      paymentStatus: 'paid',
      paymentsBehind: 0,
      monthlyPremium: 25.55,
      benefitAmount: 10000,
      customer_id_number: '96505225646081',
      customer_first_name: 'Ajkbva',
      customer_last_name: 'Avhba',
      customer_contact: '0683289404',
      acceptTerms: true,
      inceptionDate: '01-02-2025',
      paymentDate: '03-02-2025',
      payment_method: 'Cash',
      collection_date: '03-02-2025',
      pos_transaction_id: '12344',
    ));
  }

  getAllPolicies() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        allPolicies.length == 0
            ? Container(
                height: 60,
                child: Text(
                  "No inforced Policies data",
                  style: TextStyle(color: Colors.grey),
                ))
            : Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: allPolicies.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                        "${index + 1}) Policy # : ${allPolicies[index].policyNumber}",
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w500),
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Expanded(
                                        child: Text(
                                      allPolicies[index].customer_first_name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
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
                                          fontWeight: FontWeight.w500),
                                    )),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Expanded(
                                        child: Text(
                                      allPolicies[index].planType,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
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
                                          fontWeight: FontWeight.w500),
                                    )),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Expanded(
                                        child: Text(
                                      allPolicies[index].status,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
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
                                          fontWeight: FontWeight.w500),
                                    )),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: InkWell(
                                          onTap: () {},
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      Constants.ctaColorLight,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    width: 1.2,
                                                    color:
                                                        Constants.ctaColorLight,
                                                  )),
                                              padding: EdgeInsets.only(
                                                  left: 0, right: 16),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Center(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Text(
                                                  "R " +
                                                      allPolicies[index]
                                                          .monthlyPremium
                                                          .toString() +
                                                      " p.m",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Expanded(
                                        child: Text(
                                      allPolicies[index].paymentStatus,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
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
                                          fontWeight: FontWeight.w500),
                                    )),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Expanded(
                                        child: Text(
                                      "R${allPolicies[index].benefitAmount.toStringAsFixed(2)}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )),
                                  ],
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              )
      ],
    );
  }
}
