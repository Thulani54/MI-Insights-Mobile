import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:mi_insights/constants/Constants.dart';

import '../models/reprintitem.dart';
import '../services/reprintsandcancellations.dart';

List<ReprintItem> reprintList = [];

class ReprintsCancellations extends StatefulWidget {
  const ReprintsCancellations({super.key});
  @override
  State<ReprintsCancellations> createState() => _ReprintsCancellationsState();
}

class _ReprintsCancellationsState extends State<ReprintsCancellations> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
              "Reprints and cancellations",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            bottom: const TabBar(
              tabs: [
                Tab(
                    child: Text(
                  "Reprints",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  textAlign: TextAlign.center,
                )),
                Tab(
                    child: Text(
                  "Cancellations",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  textAlign: TextAlign.center,
                )),
              ],
            ),
          ),
          body: TabBarView(children: [
            isReprintListLoading == true
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                        child: Container(
                            height: 55,
                            width: 55,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xffED7D32),
                            ))))
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 12.0,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Reprint requests for the past 30 days",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 12.0,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "All reprints are only available for 48 hours after the request have been approved.",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    /* Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12.0, right: 12),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            "Authorized reprints",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          )),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8),
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Expanded(
                                              child: Text(
                                            "${reprintList.length}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),*/
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GroupedListView<ReprintItem, String>(
                            shrinkWrap: true,
                            elements: reprintList,
                            order: GroupedListOrder.DESC,
                            groupBy: (element) => DateFormat('MMM d, yyyy')
                                .format(DateTime.parse(element.timestamp))
                                .toString(),
                            groupSeparatorBuilder: (String groupByValue) => Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: 160,
                                    decoration: BoxDecoration(
                                        color: Constants.ctaColorLight
                                            .withOpacity(0.35),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12.0,
                                          right: 12,
                                          top: 8,
                                          bottom: 8),
                                      child: Center(
                                          child: Text(
                                        groupByValue,
                                        style: TextStyle(color: Colors.black),
                                      )),
                                    )),
                              ],
                            ),
                            itemBuilder: (context, ReprintItem element) {
                              bool isLastitem = false;
                              bool isPrintable = false;
                              int index = reprintList.indexOf(element);
                              if (index + 1 == reprintList.length) {
                                isLastitem = true;
                              }
                              String dateString1 =
                                  reprintList[index].transaction_date;

                              DateTime date1 = DateTime.parse(dateString1);
                              DateTime date2 = DateTime.now();

                              Duration difference = date2.difference(date1);

                              //print('Difference in days: ${difference.inDays}');
                              if (kDebugMode) {
                                print(
                                    'Difference in hours: ${difference.inHours}');
                              }
                              bool isPrintedBefore = false;

                              if (difference.inHours < 48 &&
                                  reprintList[index].status ==
                                      "Awaiting Action" &&
                                  reprintList[index].is_printed == false) {
                                isPrintable = true;
                                if (kDebugMode) {
                                  print("should print this slip");
                                }
                              } else {
                                print("${reprintList[index].status}");
                                print("${reprintList[index].is_printed}");
                              }
                              /*checkTransactionIdExists(
                                  reprintList[index].pos_transaction_id)
                              .then((value) {
                            if (value == true) {
                              isPrintable = false;
                              setState(() {});
                            }
                          });*/
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12.0, right: 12),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                      "Policy number",
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
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                      element.policy_number,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12.0, right: 12),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                      "Payment made on",
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
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                      element.transaction_date,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12.0, right: 12),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                      "Branch",
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
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                      element.branch,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12.0, right: 12),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                      "Amount",
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
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                      "R ${double.parse(element.collected_amount).toStringAsFixed(2)}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12.0, right: 12),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                      "Approval Status",
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
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                      (element.is_printed ==
                                                              true)
                                                          ? "Printed"
                                                          : element.status,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              isPrintable == true
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                          8.0),
                                                              child: InkWell(
                                                                onTap:
                                                                    () async {},
                                                                child:
                                                                    Container(
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.transparent,
                                                                            border: Border.all(color: Constants.ctaColorLight),
                                                                            borderRadius: BorderRadius.circular(360)),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 0.0,
                                                                              right: 0,
                                                                              top: 8,
                                                                              bottom: 8),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              "Decline",
                                                                              style: TextStyle(color: Constants.ctaColorLight),
                                                                            ),
                                                                          ),
                                                                        )),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                          8.0),
                                                              child: InkWell(
                                                                onTap:
                                                                    () async {},
                                                                child:
                                                                    Container(
                                                                        decoration: BoxDecoration(
                                                                            color: Constants
                                                                                .ctaColorLight,
                                                                            borderRadius: BorderRadius.circular(
                                                                                360)),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 0.0,
                                                                              right: 0,
                                                                              top: 8,
                                                                              bottom: 8),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              "Approve Reprint",
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        )),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              /* Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0, right: 12),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                  "Print Status",
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
                                                  (element.is_printed == false)
                                                      ? "Not printed"
                                                      : "Printed",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                              ],
                                            ),
                                          ),*/
                                              SizedBox(
                                                height: 12,
                                              ),
                                              //if (paymen)

                                              SizedBox(
                                                height: 12,
                                              ),
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              );
                            },
                            itemComparator: (item1, item2) =>
                                item1.timestamp.compareTo(item2.timestamp),
                            useStickyGroupSeparators: true,
                            floatingHeader: true,
                          ),
                        ],
                      ),
                    ),
                  ),
            Container(),
          ]),
        ),
      ),
    );
  }

  @override
  void initState() {
    isReprintListLoading = true;
    setState(() {});
    reprintList = [];
    getAllReprints();
    isReprintListLoading = false;
    setState(() {});

    super.initState();
  }

  getAllReprints() async {
    reprintList = await getReprintHistory();
    if (kDebugMode) {
      print(reprintList);
    }
    setState(() {});
  }
}
