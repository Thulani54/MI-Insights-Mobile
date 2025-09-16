import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mi_insights/customwidgets/CustomCard.dart';
import 'package:mi_insights/screens/Sales%20Agent/SalesAgentNewSale.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

import '../../../../constants/Constants.dart';

import '../../../../models/map_class.dart';
import '../../customwidgets/custom_input.dart';
import '../../services/sales_service.dart';

// Example model for policy data
class Conclusion5a extends StatefulWidget {
  const Conclusion5a({
    super.key,
  });

  @override
  State<Conclusion5a> createState() => _Conclusion5aState();
}

List<String> _policyInforceStatuses = ["Inforce", "Fail"];

class _Conclusion5aState extends State<Conclusion5a> {
  final TextEditingController CADEasyPayController = TextEditingController();

  final FocusNode easyPayFocusNode = FocusNode();

  List<YesOrNoDialogue> dailogueList3 = [
    YesOrNoDialogue(stringValue: "EasyPay"),
    YesOrNoDialogue(stringValue: "Manual Deposit"),
    YesOrNoDialogue(stringValue: "Wait for debit date"),
    YesOrNoDialogue(stringValue: "POS Payment"),
    YesOrNoDialogue(stringValue: "pay@")
  ];
  List<String> genderList = ["Male", "Female", "Other"];

  List<YesOrNoDialogue> dailogueList = [
    YesOrNoDialogue(stringValue: "Yes"),
    YesOrNoDialogue(stringValue: "No")
  ];
  List<YesOrNoDialogue> dailogueList1 = [
    YesOrNoDialogue(stringValue: "Yes"),
    YesOrNoDialogue(stringValue: "No")
  ];
  List<YesOrNoDialogue> dailogueList2 = [
    YesOrNoDialogue(stringValue: "Yes"),
    YesOrNoDialogue(stringValue: "No")
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            StyledText(
              text:
                  "${Constants.currentleadAvailable!.leadObject.title} ${Constants.currentleadAvailable!.leadObject.firstName} ${Constants.currentleadAvailable!.leadObject.lastName}, please check if you have received an SMS from your bank on your cell phone",
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
                fontSize: 16.0,
                color: Colors.black,
                //  fontFamily: 'YuGothic',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 45,
              child: ListView.builder(
                  itemCount: dailogueList.length,
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Container(
                          height: 45,
                          width: 130,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                width: 1.0,
                                color: dailogueList[index].stateValue == true
                                    ? Constants.ftaColorLight
                                    : Colors.grey.withOpacity(0.35)),
                            color: Colors.transparent,
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                Transform.scale(
                                  scaleX: 1.4,
                                  scaleY: 1.4,
                                  child: Checkbox(
                                      value: dailogueList[index].stateValue,
                                      side: BorderSide(
                                        width: 1.4,
                                        color: Constants.ftaColorLight,
                                      ),
                                      activeColor: Constants.ctaColorLight,
                                      checkColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(360)),
                                      onChanged: (newValue) {
                                        dailogueList[index].stateValue =
                                            !newValue!;
                                        setState(() {
                                          for (int i = 0;
                                              i < dailogueList.length;
                                              i++) {
                                            if (i != index) {
                                              dailogueList[i].stateValue =
                                                  false;
                                              //Constants.trueOrFalseStringValue = dailogueList[i].stringValue;
                                            } else {
                                              dailogueList[i].stateValue =
                                                  newValue!;
                                              Constants
                                                      .trueOrFalseStringValueA =
                                                  dailogueList[i].stringValue;
                                              Constants.clientReceiveSms =
                                                  dailogueList[i].stringValue;
                                            }
                                          }
                                          print(
                                              "hhhhhhhh ${Constants.trueOrFalseStringValueA}");
                                        });
                                      }),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  dailogueList[index].stringValue,
                                  style: TextStyle(
                                      fontFamily: 'YuGothic',
                                      color:
                                          dailogueList[index].stateValue == true
                                              ? Constants.ftaColorLight
                                              : Colors.grey.withOpacity(0.35),
                                      fontSize: 16,
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
            const SizedBox(
              height: 32,
            ),
            Constants.trueOrFalseStringValueA == "Yes"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FadeInLeftBig(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.linearToEaseOut,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            StyledText(
                              text:
                                  "${Constants.currentleadAvailable!.leadObject.title} ${Constants.currentleadAvailable!.leadObject.firstName} ${Constants.currentleadAvailable!.leadObject.lastName}, Please accept the message while I hold on the line for you.",
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
                                fontSize: 16.0,
                                color: Colors.black,
                                //  fontFamily: 'YuGothic',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Did client accept debicheck?",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'YuGothic',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            SizedBox(
                              height: 45,
                              child: ListView.builder(
                                  itemCount: dailogueList1.length,
                                  scrollDirection: Axis.horizontal,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        Container(
                                          height: 45,
                                          width: 130,
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                                width: 1.0,
                                                color: dailogueList1[index]
                                                            .stateValue ==
                                                        true
                                                    ? Constants.ftaColorLight
                                                    : Colors.grey
                                                        .withOpacity(0.35)),
                                            color: Colors.transparent,
                                          ),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                Transform.scale(
                                                  scaleX: 1.4,
                                                  scaleY: 1.4,
                                                  child: Checkbox(
                                                      activeColor: Constants
                                                          .ctaColorLight,
                                                      value:
                                                          dailogueList1[index]
                                                              .stateValue,
                                                      side: BorderSide(
                                                        width: 1.4,
                                                        color: Constants
                                                            .ftaColorLight,
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          360)),
                                                      onChanged: (newValue) {
                                                        dailogueList1[index]
                                                                .stateValue =
                                                            !newValue!;
                                                        setState(() {
                                                          for (int i = 0;
                                                              i <
                                                                  dailogueList1
                                                                      .length;
                                                              i++) {
                                                            if (i != index) {
                                                              dailogueList1[i]
                                                                      .stateValue =
                                                                  false;
                                                              //Constants.trueOrFalseStringValue = dailogueList[i].stringValue;
                                                            } else {
                                                              dailogueList1[i]
                                                                      .stateValue =
                                                                  newValue!;
                                                              Constants
                                                                      .trueOrFalseStringValueB =
                                                                  dailogueList1[
                                                                          i]
                                                                      .stringValue;
                                                              Constants
                                                                      .clientAcceptSms =
                                                                  dailogueList1[
                                                                          i]
                                                                      .stringValue;
                                                            }
                                                          }
                                                          print(
                                                              "hhhhhhhh ${Constants.trueOrFalseStringValueB}");
                                                        });
                                                      }),
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  dailogueList1[index]
                                                      .stringValue,
                                                  style: TextStyle(
                                                      fontFamily: 'YuGothic',
                                                      color: dailogueList1[
                                                                      index]
                                                                  .stateValue ==
                                                              true
                                                          ? Constants
                                                              .ftaColorLight
                                                          : Colors.grey
                                                              .withOpacity(
                                                                  0.35),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
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
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Constants.trueOrFalseStringValueB == "Yes"
                          ? Column(
                              children: [
                                FadeInLeftBig(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.linearToEaseOut,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      StyledText(
                                        text:
                                            "${Constants.currentleadAvailable!.leadObject.title} ${Constants.currentleadAvailable!.leadObject.firstName} ${Constants.currentleadAvailable!.leadObject.lastName}, as soon as your policy is active, you will get an SMS from us that will include some of your policy information. For security reasons, to view your information you will need to click on the link in the SMS and then enter the last 4 digits of your ID number. Once you do this, we will send you a R5 airtime voucher. If you have any questions about the information you see, you can reply to the SMS and we will call you back",
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
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          //  fontFamily: 'YuGothic',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      const Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            CupertinoIcons
                                                .exclamationmark_circle_fill,
                                            size: 18,
                                            color: Colors.red,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            "Do you understand?",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'YuGothic',
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      SizedBox(
                                        height: 45,
                                        child: ListView.builder(
                                            itemCount: dailogueList2.length,
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return Row(
                                                children: [
                                                  Container(
                                                    height: 45,
                                                    width: 130,
                                                    padding: EdgeInsets.all(12),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      border: Border.all(
                                                          width: 1.0,
                                                          color: dailogueList2[
                                                                          index]
                                                                      .stateValue ==
                                                                  true
                                                              ? Constants
                                                                  .ftaColorLight
                                                              : Colors.grey
                                                                  .withOpacity(
                                                                      0.35)),
                                                      color: Colors.transparent,
                                                    ),
                                                    child: Center(
                                                      child: Row(
                                                        children: [
                                                          Transform.scale(
                                                            scaleX: 1.4,
                                                            scaleY: 1.4,
                                                            child: Checkbox(
                                                                value: dailogueList2[
                                                                        index]
                                                                    .stateValue,
                                                                side: BorderSide(
                                                                    width: 1.4,
                                                                    color: Constants
                                                                        .ftaColorLight),
                                                                activeColor:
                                                                    Constants
                                                                        .ctaColorLight,
                                                                checkColor:
                                                                    Colors
                                                                        .white,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            360)),
                                                                onChanged:
                                                                    (newValue) {
                                                                  dailogueList2[
                                                                              index]
                                                                          .stateValue =
                                                                      !newValue!;
                                                                  setState(() {
                                                                    for (int i =
                                                                            0;
                                                                        i < dailogueList2.length;
                                                                        i++) {
                                                                      if (i !=
                                                                          index) {
                                                                        dailogueList2[i].stateValue =
                                                                            false;
                                                                        //Constants.trueOrFalseStringValue = dailogueList[i].stringValue;
                                                                      } else {
                                                                        dailogueList2[i].stateValue =
                                                                            newValue!;
                                                                        Constants
                                                                            .trueOrFalseStringValueC = dailogueList2[
                                                                                i]
                                                                            .stringValue;
                                                                        Constants
                                                                            .doesCustomerUnderstand = dailogueList2[
                                                                                i]
                                                                            .stringValue;
                                                                      }
                                                                    }
                                                                    print(
                                                                        "hhhhhhhh ${Constants.trueOrFalseStringValueC}");
                                                                  });
                                                                }),
                                                          ),
                                                          SizedBox(width: 8),
                                                          Text(
                                                            dailogueList2[index]
                                                                .stringValue,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'YuGothic',
                                                                color: dailogueList2[index]
                                                                            .stateValue ==
                                                                        true
                                                                    ? Constants
                                                                        .ftaColorLight
                                                                    : Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.35),
                                                                fontSize: 16,
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
                                const SizedBox(
                                  height: 16,
                                ),
                                Constants.trueOrFalseStringValueC == "Yes"
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          StyledText(
                                            text:
                                                "Your account will be debited on the ${Constants.currentleadAvailable!.policies[0].quote.debitDay}th of every month.",
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
                                              fontSize: 16.0,
                                              color: Colors.black,
                                              //  fontFamily: 'YuGothic',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          StyledText(
                                            text:
                                                "Please remember you will be covered immediately for accidental death after we receive your 1st successful premium which can be paid via Pay@ or EasyPay (at Shoprite, Boxer, Checkers, Pep Stores, Pick n Pay and so forth) or a manual deposit at any Nedbank ATM or in the branch using the ID or policy number as a reference.",
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
                                              fontSize: 16.0,
                                              color: Colors.black,
                                              //  fontFamily: 'YuGothic',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          StyledText(
                                            text:
                                                "Which option would you prefer to use to activate your benefits without having to wait for the ${Constants.currentleadAvailable!.policies[0].quote.debitDay}th?",
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
                                              fontSize: 16.0,
                                              color: Colors.black,
                                              //  fontFamily: 'YuGothic',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          SizedBox(
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: dailogueList3.length,
                                                scrollDirection: Axis.vertical,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            height: 55,
                                                            width: 200,
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
                                                                  color: dailogueList3[index]
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
                                                                  Transform
                                                                      .scale(
                                                                    scaleX: 1.4,
                                                                    scaleY: 1.4,
                                                                    child: Checkbox(
                                                                        value: dailogueList3[index].stateValue,
                                                                        side: BorderSide(
                                                                          width:
                                                                              1.4,
                                                                          color:
                                                                              Constants.ftaColorLight,
                                                                        ),
                                                                        activeColor: Constants.ctaColorLight,
                                                                        checkColor: Colors.white,
                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(360)),
                                                                        onChanged: (newValue) {
                                                                          dailogueList3[index].stateValue =
                                                                              !newValue!;
                                                                          setState(
                                                                              () {
                                                                            for (int i = 0;
                                                                                i < dailogueList3.length;
                                                                                i++) {
                                                                              if (i != index) {
                                                                                dailogueList3[i].stateValue = false;
                                                                                //Constants.trueOrFalseStringValue = dailogueList[i].stringValue;
                                                                              } else {
                                                                                dailogueList3[i].stateValue = newValue!;
                                                                                Constants.trueOrFalseStringValueD = dailogueList3[i].stringValue;
                                                                                Constants.paymentType = dailogueList3[i].stringValue;
                                                                              }
                                                                            }
                                                                            print("hhhhhhhh ${Constants.trueOrFalseStringValueD}");
                                                                            if (Constants.trueOrFalseStringValueD ==
                                                                                "EasyPay") {
                                                                              showDialog(
                                                                                  context: context,
                                                                                  barrierDismissible: false,
                                                                                  // set to false if you want to force a rating
                                                                                  builder: (context) => StatefulBuilder(
                                                                                        builder: (context, setState) => Dialog(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(16),
                                                                                          ),
                                                                                          elevation: 0.0,
                                                                                          backgroundColor: Colors.transparent,
                                                                                          child: Container(
                                                                                              constraints: BoxConstraints(minHeight: 250.0, maxWidth: 620),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.circular(16),
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                              child: SingleChildScrollView(
                                                                                                scrollDirection: Axis.vertical,
                                                                                                child: Column(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Container(
                                                                                                      width: MediaQuery.of(context).size.width,
                                                                                                      padding: EdgeInsets.only(left: 16, top: 16),
                                                                                                      height: 45,
                                                                                                      decoration: BoxDecoration(
                                                                                                        color: Constants.ftaColorLight,
                                                                                                        borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
                                                                                                      ),
                                                                                                      child: Row(
                                                                                                        children: [
                                                                                                          Icon(CupertinoIcons.exclamationmark, size: 32, color: Colors.white),
                                                                                                          SizedBox(
                                                                                                            width: 12,
                                                                                                          ),
                                                                                                          Text(
                                                                                                            "Agent Note",
                                                                                                            style: GoogleFonts.lato(
                                                                                                              textStyle: TextStyle(fontSize: 16, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.white),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    SizedBox(
                                                                                                      height: 24,
                                                                                                    ),
                                                                                                    Padding(
                                                                                                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                                                                                      child: Column(
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                                        children: [
                                                                                                          SizedBox(
                                                                                                            height: 16,
                                                                                                          ),
                                                                                                          Row(
                                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                child: Column(
                                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                  children: [
                                                                                                                    Center(
                                                                                                                      child: Text(
                                                                                                                        'EasyPay Reference ',
                                                                                                                        style: TextStyle(fontSize: 16, fontFamily: 'YuGothic', fontWeight: FontWeight.normal, color: Colors.black),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    const SizedBox(height: 8),
                                                                                                                    Row(
                                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                      children: [
                                                                                                                        Expanded(
                                                                                                                          child: CustomInputTransparent4(
                                                                                                                            controller: CADEasyPayController,
                                                                                                                            hintText: "EasyPay Ref",
                                                                                                                            onChanged: (value) {
                                                                                                                              Constants.easyPayRef = CADEasyPayController.text;
                                                                                                                            },
                                                                                                                            onSubmitted: (value) {
                                                                                                                              Constants.easyPayRef = CADEasyPayController.text;
                                                                                                                            },
                                                                                                                            focusNode: easyPayFocusNode,
                                                                                                                            //suffix: Icon(CupertinoIcons.person_fill, size: 22, color: Color(0xFFEF601B).withOpacity(0.45),),
                                                                                                                            textInputAction: TextInputAction.next,
                                                                                                                            isPasswordField: false,
                                                                                                                          ),
                                                                                                                        ),
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
                                                                                                                child: Container(
                                                                                                                  height: 170,
                                                                                                                  child: Column(
                                                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                    children: [
                                                                                                                      Container(
                                                                                                                        height: 50,
                                                                                                                        //#00a65a
                                                                                                                        //width: 350,
                                                                                                                        padding: const EdgeInsets.only(left: 16, right: 16),
                                                                                                                        decoration: BoxDecoration(
                                                                                                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                                                                                                                          color: Constants.ftaColorLight,
                                                                                                                        ),
                                                                                                                        child: Row(
                                                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                          children: [
                                                                                                                            Text(
                                                                                                                              'SMS',
                                                                                                                              style: TextStyle(fontSize: 16, fontFamily: 'YuGothic', color: Colors.white, fontWeight: FontWeight.w600),
                                                                                                                            ),
                                                                                                                            Icon(
                                                                                                                              Icons.folder_copy_outlined,
                                                                                                                              size: 24,
                                                                                                                              color: Colors.white,
                                                                                                                            )
                                                                                                                          ],
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      Expanded(
                                                                                                                        child: Container(
                                                                                                                            //height: 180,
                                                                                                                            padding: const EdgeInsets.only(left: 16, right: 16),
                                                                                                                            decoration: BoxDecoration(
                                                                                                                              border: Border(
                                                                                                                                  left: BorderSide(
                                                                                                                                    color: Constants.ftaColorLight,
                                                                                                                                  ),
                                                                                                                                  right: BorderSide(
                                                                                                                                    color: Constants.ftaColorLight,
                                                                                                                                  ),
                                                                                                                                  bottom: BorderSide(
                                                                                                                                    color: Constants.ftaColorLight,
                                                                                                                                  )),
                                                                                                                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                                                                                                                              //color: Colors.grey
                                                                                                                            ),
                                                                                                                            child: Column(
                                                                                                                              children: [
                                                                                                                                Spacer(),
                                                                                                                                Row(children: [
                                                                                                                                  Expanded(
                                                                                                                                    child: Text("Hello ${Constants.currentleadAvailable!.leadObject.title} ${Constants.currentleadAvailable!.leadObject.firstName} ${Constants.currentleadAvailable!.leadObject.lastName}. Your EasyPay ref no is ${Constants.easyPayRef} to activate your policy at any EasyPay outlet. ${Constants.business_name}.",
                                                                                                                                        style: TextStyle(
                                                                                                                                          fontSize: 16,
                                                                                                                                          fontFamily: 'YuGothic',
                                                                                                                                          fontWeight: FontWeight.w500,
                                                                                                                                          color: Colors.black,
                                                                                                                                        )),
                                                                                                                                  ),
                                                                                                                                ]),
                                                                                                                                Spacer(),
                                                                                                                              ],
                                                                                                                            )),
                                                                                                                      ),
                                                                                                                    ],
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                          SizedBox(
                                                                                                            height: 16,
                                                                                                          ),
                                                                                                          Divider(color: Constants.ftaColorLight, thickness: 1.0),
                                                                                                          SizedBox(
                                                                                                            height: 16,
                                                                                                          ),
                                                                                                          Row(
                                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                            children: [
                                                                                                              InkWell(
                                                                                                                child: Container(
                                                                                                                  height: 40,
                                                                                                                  width: 120,
                                                                                                                  padding: EdgeInsets.only(left: 16, right: 16),
                                                                                                                  decoration: BoxDecoration(
                                                                                                                    borderRadius: BorderRadius.circular(360),
                                                                                                                    color: Constants.ftaColorLight,
                                                                                                                  ),
                                                                                                                  child: Center(
                                                                                                                    child: Text(
                                                                                                                      "Done",
                                                                                                                      style: GoogleFonts.lato(
                                                                                                                        textStyle: TextStyle(fontSize: 13, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.white),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                onTap: () {
                                                                                                                  Constants.easyPayReference = CADEasyPayController.text;
                                                                                                                  setState(() {});
                                                                                                                  Navigator.pop(context);
                                                                                                                },
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                          SizedBox(
                                                                                                            height: 16,
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              )),
                                                                                        ),
                                                                                      ));
                                                                              setState(() {});
                                                                            }

                                                                            if (Constants.trueOrFalseStringValueD ==
                                                                                "Manual Deposit") {
                                                                              showDialog(
                                                                                  context: context,
                                                                                  barrierDismissible: false,
                                                                                  // set to false if you want to force a rating
                                                                                  builder: (context) => StatefulBuilder(
                                                                                        builder: (context, setState) => Dialog(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(16),
                                                                                          ),
                                                                                          elevation: 0.0,
                                                                                          backgroundColor: Colors.transparent,
                                                                                          child: Container(
                                                                                              constraints: BoxConstraints(minHeight: 250.0, maxWidth: 620),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.circular(16),
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                              child: SingleChildScrollView(
                                                                                                scrollDirection: Axis.vertical,
                                                                                                child: Column(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Container(
                                                                                                      width: MediaQuery.of(context).size.width,
                                                                                                      padding: EdgeInsets.only(left: 16, top: 16),
                                                                                                      height: 45,
                                                                                                      decoration: BoxDecoration(
                                                                                                        color: Constants.ftaColorLight,
                                                                                                        borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
                                                                                                      ),
                                                                                                      child: Row(
                                                                                                        children: [
                                                                                                          Icon(CupertinoIcons.exclamationmark, size: 32, color: Colors.white),
                                                                                                          SizedBox(
                                                                                                            width: 12,
                                                                                                          ),
                                                                                                          Text(
                                                                                                            "Agent Note",
                                                                                                            style: GoogleFonts.lato(
                                                                                                              textStyle: TextStyle(fontSize: 16, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.white),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    SizedBox(
                                                                                                      height: 24,
                                                                                                    ),
                                                                                                    Padding(
                                                                                                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                                                                                      child: Column(
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                                        children: [
                                                                                                          SizedBox(
                                                                                                            height: 16,
                                                                                                          ),
                                                                                                          Row(children: [
                                                                                                            Expanded(
                                                                                                              child: Text("Hello ${Constants.currentleadAvailable!.leadObject.title} ${Constants.currentleadAvailable!.leadObject.firstName} ${Constants.currentleadAvailable!.leadObject.lastName}. Use ${Constants.business_name} account, to activate your policy. acc no: 123456789 and ref: POLICY NO. ${Constants.business_name} Auth FSP.",
                                                                                                                  style: TextStyle(
                                                                                                                    fontSize: 16,
                                                                                                                    fontFamily: 'YuGothic',
                                                                                                                    fontWeight: FontWeight.w500,
                                                                                                                    color: Colors.black,
                                                                                                                  )),
                                                                                                            ),
                                                                                                          ]),
                                                                                                          SizedBox(
                                                                                                            height: 16,
                                                                                                          ),
                                                                                                          Divider(color: Constants.ftaColorLight, thickness: 1.0),
                                                                                                          SizedBox(
                                                                                                            height: 16,
                                                                                                          ),
                                                                                                          Row(
                                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                            children: [
                                                                                                              InkWell(
                                                                                                                child: Container(
                                                                                                                  height: 40,
                                                                                                                  width: 120,
                                                                                                                  padding: EdgeInsets.only(left: 16, right: 16),
                                                                                                                  decoration: BoxDecoration(
                                                                                                                    borderRadius: BorderRadius.circular(360),
                                                                                                                    color: Constants.ftaColorLight,
                                                                                                                  ),
                                                                                                                  child: Center(
                                                                                                                    child: Text(
                                                                                                                      "Done",
                                                                                                                      style: GoogleFonts.lato(
                                                                                                                        textStyle: TextStyle(fontSize: 13, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.white),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                onTap: () {
                                                                                                                  Navigator.pop(context);
                                                                                                                  setState(() {});
                                                                                                                },
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                          SizedBox(
                                                                                                            height: 16,
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              )),
                                                                                        ),
                                                                                      ));
                                                                              setState(() {});
                                                                            }

                                                                            if (Constants.trueOrFalseStringValueD ==
                                                                                "Wait for debit date") {
                                                                              showDialog(
                                                                                  context: context,
                                                                                  barrierDismissible: false,
                                                                                  // set to false if you want to force a rating
                                                                                  builder: (context) => StatefulBuilder(
                                                                                        builder: (context, setState) => Dialog(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(16),
                                                                                          ),
                                                                                          elevation: 0.0,
                                                                                          backgroundColor: Colors.transparent,
                                                                                          child: Container(
                                                                                              constraints: BoxConstraints(minHeight: 250.0, maxWidth: 620),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.circular(16),
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                              child: SingleChildScrollView(
                                                                                                scrollDirection: Axis.vertical,
                                                                                                child: Column(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Container(
                                                                                                      width: MediaQuery.of(context).size.width,
                                                                                                      padding: EdgeInsets.only(left: 16, top: 16),
                                                                                                      height: 45,
                                                                                                      decoration: BoxDecoration(
                                                                                                        color: Constants.ftaColorLight,
                                                                                                        borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
                                                                                                      ),
                                                                                                      child: Row(
                                                                                                        children: [
                                                                                                          Icon(CupertinoIcons.exclamationmark, size: 32, color: Colors.white),
                                                                                                          SizedBox(
                                                                                                            width: 12,
                                                                                                          ),
                                                                                                          Text(
                                                                                                            "Agent Note",
                                                                                                            style: GoogleFonts.lato(
                                                                                                              textStyle: TextStyle(fontSize: 16, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.white),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    SizedBox(
                                                                                                      height: 24,
                                                                                                    ),
                                                                                                    Padding(
                                                                                                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                                                                                      child: Column(
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                                        children: [
                                                                                                          SizedBox(
                                                                                                            height: 16,
                                                                                                          ),
                                                                                                          Row(children: [
                                                                                                            Expanded(
                                                                                                              child: Text("You will receive a courtesy call from us or a reminder at least 7 days before your debit date.",
                                                                                                                  style: TextStyle(
                                                                                                                    fontSize: 16,
                                                                                                                    fontFamily: 'YuGothic',
                                                                                                                    fontWeight: FontWeight.w500,
                                                                                                                    color: Colors.black,
                                                                                                                  )),
                                                                                                            ),
                                                                                                          ]),
                                                                                                          SizedBox(
                                                                                                            height: 16,
                                                                                                          ),
                                                                                                          Divider(color: Constants.ftaColorLight, thickness: 1.0),
                                                                                                          SizedBox(
                                                                                                            height: 16,
                                                                                                          ),
                                                                                                          Row(
                                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                            children: [
                                                                                                              InkWell(
                                                                                                                child: Container(
                                                                                                                  height: 40,
                                                                                                                  width: 120,
                                                                                                                  padding: EdgeInsets.only(left: 16, right: 16),
                                                                                                                  decoration: BoxDecoration(
                                                                                                                    borderRadius: BorderRadius.circular(360),
                                                                                                                    color: Constants.ftaColorLight,
                                                                                                                  ),
                                                                                                                  child: Center(
                                                                                                                    child: Text(
                                                                                                                      "Done",
                                                                                                                      style: GoogleFonts.lato(
                                                                                                                        textStyle: TextStyle(fontSize: 13, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.white),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                onTap: () {
                                                                                                                  Navigator.pop(context);
                                                                                                                  setState(() {});
                                                                                                                },
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                          SizedBox(
                                                                                                            height: 16,
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              )),
                                                                                        ),
                                                                                      ));
                                                                              setState(() {});
                                                                            }
                                                                          });
                                                                        }),
                                                                  ),
                                                                  SizedBox(
                                                                      width: 8),
                                                                  Text(
                                                                    dailogueList3[
                                                                            index]
                                                                        .stringValue,
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'YuGothic',
                                                                        color: dailogueList3[index].stateValue ==
                                                                                true
                                                                            ? Constants
                                                                                .ftaColorLight
                                                                            : Colors.grey.withOpacity(
                                                                                0.35),
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          StyledText(
                                            text:
                                                "${Constants.currentleadAvailable!.leadObject.title} ${Constants.currentleadAvailable!.leadObject.firstName} ${Constants.currentleadAvailable!.leadObject.lastName},Thank you for taking a policy with us and being part of the ${Constants.business_name} family",
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
                                              fontSize: 16.0,
                                              color: Colors.black,
                                              //  fontFamily: 'YuGothic',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 24,
                                          ),
                                          Row(
                                            children: [
                                              Spacer(),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 16),
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                      minimumSize:
                                                          Size(220, 50),
                                                      backgroundColor: Constants
                                                          .ftaColorLight),
                                                  child: Text(
                                                    "Inforce Policy",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'YuGothic',
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            InforcePolicyDialog2(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 36,
                                          ),
                                        ],
                                      )
                                    : Constants.trueOrFalseStringValueC == "No"
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Once again we would like to encourage you to read the policy cover information that will be sent to you. Please remember to contact the Hollard Life number that I have given you if you have questions.",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'YuGothic',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                "Thank you very much for your time.",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'YuGothic',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                "And enjoy the rest of your day.",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'YuGothic',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                "Thank you for your time, Goodbye.",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'YuGothic',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                            ],
                                          )
                                        : Container(),
                              ],
                            )
                          : Constants.trueOrFalseStringValueB == "No"
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                      Text(
                                        "${Constants.currentleadAvailable!.leadObject.title} ${Constants.currentleadAvailable!.leadObject.firstName} ${Constants.currentleadAvailable!.leadObject.lastName}, you can also approve the debit order by using your Banking App, internet banking, cell phone.",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'YuGothic',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        "${Constants.currentleadAvailable!.leadObject.title} ${Constants.currentleadAvailable!.leadObject.firstName} ${Constants.currentleadAvailable!.leadObject.lastName}, the moment you receive the notification from your bank please check the amount and make sure that it is the same as what I have quoted you which is R before you approve the debicheck.",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'YuGothic',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        "${Constants.currentleadAvailable!.leadObject.title} ${Constants.currentleadAvailable!.leadObject.firstName} ${Constants.currentleadAvailable!.leadObject.lastName}, as soon as your policy is active, you will get an SMS from us that will include some of your policy information. For security reasons, to view your information you will need to click on the link in the SMS and then enter the last 4 digits of your ID number. Once you do this, we will send you a R5 airtime voucher. If you have any questions about the information you see, you can reply to the SMS and we will call you back",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'YuGothic',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                    ])
                              : Container(),
                    ],
                  )
                : Constants.trueOrFalseStringValueA == "No"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Constants.trueOrFalseStringValueA == "No"
                              ? FadeInLeftBig(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.linearToEaseOut,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${Constants.currentleadAvailable!.leadObject.title} ${Constants.currentleadAvailable!.leadObject.firstName} ${Constants.currentleadAvailable!.leadObject.lastName}, you can also approve the debit order by using your Banking App, internet banking, cell phone.",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'YuGothic',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        "${Constants.currentleadAvailable!.leadObject.title} ${Constants.currentleadAvailable!.leadObject.firstName} ${Constants.currentleadAvailable!.leadObject.lastName} , the moment you receive the notification from your bank please check the amount and make sure that it is the same as what I have quoted you which is R before you approve the debicheck.",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'YuGothic',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                        ],
                      )
                    : Container(),
            SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}

class PolicyData {
  String policyNumber;
  final String reference;
  bool availablilityStatus;
  String? policyInforceStatus;
  String? returnedPolicyInforceStatus;
  String failedPolicyNote;

  PolicyData({
    required this.policyNumber,
    required this.reference,
    required this.availablilityStatus,
    required this.policyInforceStatus,
    required this.returnedPolicyInforceStatus,
    required this.failedPolicyNote,
  });

  factory PolicyData.fromJson(Map<String, dynamic> json) {
    return PolicyData(
      policyNumber: json['policy_number'] ?? "",
      reference: json['reference'],
      availablilityStatus: json['availablilityStatus'] ?? false,
      policyInforceStatus: json['availablilityStatus'] ?? null,
      returnedPolicyInforceStatus: json['returnedPolicyInforceStatus'] ?? null,
      failedPolicyNote: json['failedPolicyNote'] ?? "",
    );
  }
}

class PoliciesToInforce {
  final String policy_number;
  final String inforced_by;
  final String mip_description;
  final String status;
  final String employee_email;
  final String reference;
  final String name;
  final String main_member;
  final String client_email;
  final String inforce_type;
  final String mip_changes;

  PoliciesToInforce(
    this.policy_number,
    this.inforced_by,
    this.mip_description,
    this.status,
    this.employee_email,
    this.reference,
    this.name,
    this.main_member,
    this.client_email,
    this.inforce_type,
    this.mip_changes,
  );

  factory PoliciesToInforce.fromJson(Map<String, dynamic> json) {
    return PoliciesToInforce(
      json['policy_number'] ?? '',
      json['inforced_by'] ?? '',
      json['mip_description'] ?? '',
      json['status'] ?? '',
      json['employee_email'] ?? '',
      json['reference'] ?? '',
      json['name'] ?? '',
      json['main_member'] ?? '',
      json['client_email'] ?? '',
      json['inforce_type'] ?? '',
      json['mip_changes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'policy_number': policy_number,
      'inforced_by': inforced_by,
      'mip_description': mip_description,
      'status': status,
      'employee_email': employee_email,
      'reference': reference,
      'name': name,
      'main_member': main_member,
      'client_email': client_email,
      'inforce_type': inforce_type,
      'mip_changes': mip_changes,
    };
  }
}

class InforcedResponse {
  final String responseText;
  final List<PoliciesToInforce> inforcedPolicies;
  final bool debitOrderSuccess;
  final String debitOrderMessage;

  InforcedResponse({
    required this.responseText,
    required this.inforcedPolicies,
    required this.debitOrderSuccess,
    required this.debitOrderMessage,
  });

  factory InforcedResponse.fromJson(Map<String, dynamic> json) {
    return InforcedResponse(
      responseText: json['response_text'] ?? '',
      inforcedPolicies: (json['inforced_policies'] as List<dynamic>?)
              ?.map((item) => PoliciesToInforce.fromJson(item))
              .toList() ??
          [],
      debitOrderSuccess: json['debit_order_success'] ?? false,
      debitOrderMessage: json['debit_order_message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response_text': responseText,
      'inforced_policies': inforcedPolicies,
      'debit_order_success': debitOrderSuccess,
      'debit_order_message': debitOrderMessage,
    };
  }
}

class InforcePolicyDialog extends StatefulWidget {
  const InforcePolicyDialog({Key? key}) : super(key: key);

  @override
  State<InforcePolicyDialog> createState() => _InforcePolicyDialogState();
}

class _InforcePolicyDialogState extends State<InforcePolicyDialog> {
  final TextEditingController policyNumberController =
      TextEditingController(text: "");

  /// This will hold the list of policies fetched from the server
  List<PolicyData> _policyList = [];

  /// Whether data is still being fetched
  bool _isLoading = false;

  /// Whether the policy number check returned true
  /// This will control if the "Yes" (continue) button is clickable
  bool _canContinue = false;
  int currentLeadId = 0;

  @override
  void initState() {
    super.initState();
    getLeadId();
  }

  /// Fetches a list of policies from the server
  /// If onololeadid is greater than 0,fetch the policy numbers
  getLeadId() {
    currentLeadId = Constants.currentleadAvailable!.leadObject.onololeadid;
    if (currentLeadId > 0) {
      _fetchPolicyNumbers();
    }
  }

  /// Fetches a list of policies from the server
  Future<void> _fetchPolicyNumbers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          "${Constants.insightsBackendBaseUrl}onolov6/getPolicyNumbsAndRefs?leadid=952078",
        ),
      );
      if (response.statusCode == 200) {
        final List<dynamic> decodedJson = jsonDecode(response.body);
        setState(() {
          _policyList =
              decodedJson.map((item) => PolicyData.fromJson(item)).toList();
        });
      } else {
        // Handle non-200 responses here if needed
      }
    } catch (e) {
      // Handle errors like no internet, etc.
      debugPrint("Error fetching data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Checks if a policy number exists
  Future<void> _checkPolicyExists(String policyNumber, String reference) async {
    try {
      final response = await http.get(
        Uri.parse(
          "${Constants.insightsBackendBaseUrl}fieldV6/policyNumberExists?policyNumber=$policyNumber&reference=$reference&empid=3",
        ),
      );
      if (kDebugMode) {
        print("dffghhgg ${response.body} ${response.body.runtimeType}");
      }
      if (response.statusCode == 200) {
        final result = response.body.trim(); // "True" or "False"

        if (result == "true") {
          setState(() {
            _canContinue = true; // Enable the continue button
          });
        } else {
          setState(() {
            _canContinue = false;
            MotionToast.error(
              height: 55,
              description: Text(
                "Policy number already used, please add another.",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'YuGothic',
                  color: Colors.white,
                ),
              ),
            ).show(context);
          });
        }
      } else {
        // Handle error response
      }
    } catch (e) {
      debugPrint("Error checking policy exists: $e");
      // Handle error. Possibly show a toast/snackbar.
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          constraints: const BoxConstraints(minHeight: 250.0, maxWidth: 1500),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.check, color: Colors.green),
                  const Text(
                    "Accepted Policies",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'YuGothic',
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      size: 28,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Divider(color: Colors.grey, height: 1),
              ),
              const SizedBox(height: 16),

              // -------------------------
              // LOADING INDICATOR
              // -------------------------
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                // If not loading, show the DataTable
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: DataTable(
                      headingRowColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          return Constants
                              .ftaColorLight; // or any color you want
                        },
                      ),
                      headingTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      columns: const [
                        DataColumn(label: Text("#")),
                        DataColumn(label: Text("Product")),
                        DataColumn(label: Text("Reference No")),
                        DataColumn(label: Text("Main Member")),
                        DataColumn(label: Text("Policy Number")),
                        DataColumn(label: Text("Policy No. Status")),
                      ],
                      rows: List.generate(_policyList.length, (index) {
                        final policy = _policyList[index];

                        // Safely fetch Quote & AdditionalMember if they are available
                        final quote =
                            Constants.currentleadAvailable?.policies[0].quote;

                        // Find the first AdditionalMember with relationship == "self"
                        final AdditionalMember? member = Constants
                            .currentleadAvailable?.additionalMembers
                            .firstWhere(
                          (m) => m.relationship == "self",
                          orElse: () => AdditionalMember(
                              memberType: '',
                              autoNumber: 0,
                              id: '',
                              contact: '',
                              dob: '',
                              gender: '',
                              name: '',
                              surname: '',
                              title: '',
                              onololeadid: 0,
                              altContact: '',
                              email: '',
                              percentage: 0,
                              maritalStatus: '',
                              relationship: '',
                              mipCover: '',
                              mipStatus: '',
                              updatedBy: 0,
                              memberQueryType: '',
                              memberQueryTypeOldNew: '',
                              memberQueryTypeOldAutoNumber: '',
                              membersAutoNumber: '',
                              sourceOfIncome: '',
                              sourceOfWealth: '',
                              otherUnknownIncome: '',
                              otherUnknownWealth: '',
                              timestamp: '',
                              lastUpdate:
                                  ''), // Provide a default or null-safe value
                        );

                        return DataRow(
                          cells: [
                            DataCell(Text("${index + 1}")),
                            DataCell(Text(quote?.product ?? "N/A")), // Product
                            DataCell(Text(policy.reference)), // Reference No
                            DataCell(Text(member!.title +
                                    " " +
                                    member.name +
                                    " " +
                                    member.surname ??
                                "N/A")), // Main Member
                            DataCell(
                                Text(policy.policyNumber)), // Policy Number

                            DataCell(
                              ElevatedButton(
                                onPressed: () {
                                  // Check if policy exists
                                  _checkPolicyExists(
                                    policy.policyNumber,
                                    policy.reference,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Constants.ftaColorLight,
                                ),
                                child: const Text(
                                  "Check Exists",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'YuGothic',
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // -------------------------
              // "No" and "Yes" buttons
              // -------------------------
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    /*  // NO BUTTON
                    InkWell(
                      child: Container(
                        height: 40,
                        width: 120,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(360),
                          color: Colors.redAccent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(CupertinoIcons.xmark,
                                size: 16, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              "No",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'YuGothic',
                                letterSpacing: 0,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {});
                      },
                    ),*/
                    const SizedBox(width: 12),
                    // YES BUTTON
                    InkWell(
                      child: Container(
                        height: 40,
                        width: 120,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(360),
                          color: _canContinue
                              ? Constants.ftaColorLight
                              : Colors.grey, // Disable color if can't continue
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              CupertinoIcons.check_mark,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Yes",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'YuGothic',
                                letterSpacing: 0,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: _canContinue
                          ? () {
                              // Only pop if canContinue is true
                              Navigator.pop(context);
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    policyNumberController.dispose();
    super.dispose();
  }
}

class InforcePolicyDialog2 extends StatefulWidget {
  const InforcePolicyDialog2({Key? key}) : super(key: key);

  @override
  State<InforcePolicyDialog2> createState() => _InforcePolicyDialog2State();
}

class _InforcePolicyDialog2State extends State<InforcePolicyDialog2> {
  final TextEditingController policyNumberController =
      TextEditingController(text: "");

  /// This will hold the list of policies fetched from the server
  List<PolicyData> _policyList = [];
  List<TextEditingController> _textEditingControllersList = [];
  List<FocusNode> _textEditingFocusNodeList = [];

  /// Whether data is still being fetched
  bool _isLoading = false;

  /// Whether the policy number check returned true
  /// This will control if the "Yes" (continue) button is clickable
  bool _canContinue = false;
  bool _inforcePolicyResponseResultAvailable = false;
  int currentLeadId = 0;

  @override
  void initState() {
    super.initState();
    _inforcePolicyResponseResultAvailable = false;
    setState(() {});
    getLeadId();
  }

  /// Fetches a list of policies from the server
  /// If onololeadid is greater than 0,fetch the policy numbers
  getLeadId() {
    currentLeadId = Constants.currentleadAvailable!.leadObject.onololeadid;
    if (currentLeadId > 0) {
      _fetchPolicyNumbers();
    }
  }

  /// Fetches a list of policies from the server
  Future<void> _fetchPolicyNumbers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          "${Constants.InsightsAdminbaseUrl}onolov6/getPolicyNumbsAndRefs?leadid=${Constants.currentleadAvailable!.leadObject.onololeadid}",
        ),
      );
      if (response.statusCode == 200) {
        final List<dynamic> decodedJson = jsonDecode(response.body);
        setState(() {
          _policyList =
              decodedJson.map((item) => PolicyData.fromJson(item)).toList();
          for (var i = 0; i < _policyList.length; i++) {
            _textEditingControllersList.add(TextEditingController());
            _textEditingFocusNodeList.add(FocusNode());
          }
        });
      } else {
        // Handle non-200 responses here if needed
      }
    } catch (e) {
      // Handle errors like no internet, etc.
      debugPrint("Error fetching data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Checks if a policy number exists
  Future<bool> _checkPolicyExists(
      String policyNumber, String reference, int index) async {
    String url1 =
        "${Constants.InsightsAdminbaseUrl}fieldV6/policyNumberExists?policyNumber=$policyNumber&reference=$reference&empid=${Constants.cec_employeeid}";
    print(
        "ahsahja  ${Constants.currentleadAvailable!.leadObject.onololeadid} $url1");
    try {
      final response = await http.get(
        Uri.parse(
          url1,
        ),
      );
      if (kDebugMode) {
        print("dffghhgg ${response.body} ${response.body.runtimeType}");
      }
      if (response.statusCode == 200) {
        final result = response.body.trim(); // "True" or "False"

        if (result != "true") {
          setState(() {
            _canContinue = true; // Enable the continue button
            _policyList[index].availablilityStatus = true;
          });
        } else {
          setState(() {
            _canContinue = false;
            _policyList[index].availablilityStatus = false;
          });
        }

        Constants.currentleadAvailable!.policies[index].quote.policyNumber =
            policyNumber;
        if (result == "true") {
          MotionToast.error(
            height: 45,
            description: Text("Policy already exist",
                style: TextStyle(color: Colors.white)),
          ).show(context);
        }
        return _canContinue;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Error checking policy exists: $e");
      return false;
      // Handle error. Possibly show a toast/snackbar.
    }
  }

  Future<void> _multiPolicyInforce(
      List<PoliciesToInforce> inforceDetails) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Set up request headers.
      var headers = {'Content-Type': 'application/json'};
      // Ensure Constants values are set
      assert(Constants.cec_client_id != null, "cec_client_id is null");
      assert(Constants.cec_employeeid != null, "cec_employeeid is null");

      // Print values for debugging
      if (kDebugMode) {
        print("cec_client_id: ${Constants.cec_client_id}");
        print("cec_employee_id: ${Constants.cec_employeeid}");
      }

      // Prepare the request body.
      var requestBody = json.encode({
        "cec_client_id": Constants.cec_client_id,
        "cec_employee_id": Constants.cec_employeeid,
        "onololeadid": Constants.currentleadAvailable!.leadObject.onololeadid,
        "inforce_details": inforceDetails
            .map((policy) => {
                  "policy_number": policy.policy_number,
                  "inforced_by": policy.inforced_by,
                  "mip_description": policy.mip_description,
                  "status": policy.status,
                  "employee_email": policy.employee_email,
                  "reference": policy.reference,
                  "name": policy.name,
                  "main_member": policy.main_member,
                  "client_email": policy.client_email,
                  "inforce_type": policy.inforce_type,
                  "mip_changes": policy.mip_changes,
                })
            .toList(),
        "isDebitOrder":
            Constants.currentleadAvailable!.leadObject.paymentType ==
                "Debit Order",
      });

      if (kDebugMode) {
        print("Sending request bodyghgh: $requestBody");
      }

      // Send the POST request.
      var response = await http.post(
        Uri.parse(
            '${Constants.insightsReportsBaseUrl}api/multi_policy_inforce/'),
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> decoded = json.decode(response.body);
        print("Response from endpoint: $decoded");

        if (decoded["success"] == true) {
          print("Success:");
          Map<String, dynamic> m1 =
              Map<String, dynamic>.from(decoded["inforced_response"]);

          // Parse the inforced response using our model.
          InforcedResponse inforcedResponse = InforcedResponse.fromJson(m1);
          if (kDebugMode) {
            print("Parsed inforced response: ${inforcedResponse.toJson()}");
          }
          // Only pop if canContinue is true
          for (var policy in inforcedResponse.inforcedPolicies) {
            if (policy.status == "Inforced") {
              int index = Constants.currentleadAvailable!.policies.indexWhere(
                  (policy1) =>
                      policy1.quote.policyNumber == policy.policy_number);

              SalesService salesService = new SalesService();
              salesService.updateLeadDetails(context);

              salesService.endLeadCall(
                  lead: Constants.currentleadAvailable!.leadObject,
                  empId: Constants.cec_employeeid);
              int index1 = Constants.currentleadAvailable!.policies.indexWhere(
                  (policy1) =>
                      policy1.quote.policyNumber == policy.policy_number);
              _policyList[index1].returnedPolicyInforceStatus = policy.status;
              _inforcePolicyResponseResultAvailable = true;
              setState(() {});

              salesService
                  .updatePolicy(Constants.currentleadAvailable!, context)
                  .then((val) {
                if (val == false) {
                  //  isSuccessful = val;
                }
              });
            }
          }
          _isLoading = false;
          setState(() {});
        } else {
          throw Exception('OTP verification failed: ${decoded["message"]}');
        }
      } else {
        throw Exception('Failed to verify OTP: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e.toString());
      MotionToast.error(
        height: 45,
        description: Text(e.toString(), style: TextStyle(color: Colors.white)),
      ).show(context);
    }
  }

  Widget _buildMobilePolicyCard(PolicyData policy, int index) {
    final quote = Constants.currentleadAvailable?.policies[index].quote;
    final policy1 = Constants.currentleadAvailable!.policies[index];

    // Safely get the main member map
    final mainMemberMap = policy1.members.firstWhere(
      (member) => member is Map && member["type"] == "main_member",
      orElse: () => null,
    );

    // Safely get the autonumber
    int? mainInsuredAutonumber = mainMemberMap?['additional_member_id'];

    // Safely get the AdditionalMember
    AdditionalMember? member;
    if (mainInsuredAutonumber != null) {
      member = Constants.currentleadAvailable!.additionalMembers.firstWhere(
        (am) => am.autoNumber == mainInsuredAutonumber,
        orElse: () => AdditionalMember.empty(),
      );
    }

    bool isAccepted =
        (Constants.currentleadAvailable?.policies[index].quote.acceptPolicy ??
                    "no")
                .toLowerCase() ==
            "yes";

    return CustomCard3(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      boderRadius: 12,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with policy number
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Policy #${index + 1}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Constants.ctaColorLight,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isAccepted ? Constants.ctaColorLight : Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isAccepted ? "Accepted" : "Not Accepted",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Product and Reference
            _buildInfoRow("Product", quote?.product ?? "N/A"),
            _buildInfoRow("Reference No", policy.reference),
            _buildInfoRow(
              "Main Member",
              member == null
                  ? "Main Member Not Added"
                  : "${member.title} ${member.name} ${member.surname}",
            ),

            if (isAccepted) ...[
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),

              // Policy Number Input or Display
              Text(
                "Policy Number",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),

              if ((policy.returnedPolicyInforceStatus ?? "").isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    policy.policyNumber,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              else
                CustomInputTransparent4(
                  hintText: 'Enter policy number',
                  controller: _textEditingControllersList[index],
                  onChanged: (value) {
                    policy.policyNumber = value;
                    policy.availablilityStatus = false;
                    setState(() {});
                  },
                  onSubmitted: (value) {},
                  focusNode: _textEditingFocusNodeList[index],
                  textInputAction: TextInputAction.next,
                  isPasswordField: false,
                ),

              SizedBox(height: 16),

              // Policy Status Section
              Text(
                "Policy Status",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),

              if ((policy.returnedPolicyInforceStatus ?? "").isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Text(
                        policy.returnedPolicyInforceStatus ?? "",
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                // Check exists button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      policy.availablilityStatus = await _checkPolicyExists(
                          policy.policyNumber, policy.reference, index);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: policy.availablilityStatus == true
                          ? Colors.green
                          : Constants.ftaColorLight,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: Text(
                      policy.availablilityStatus == true
                          ? "✓ All Good"
                          : "Check if Policy Exists",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                if (policy.availablilityStatus == true) ...[
                  SizedBox(height: 16),

                  // Status Dropdown
                  Text(
                    "Inforce Status",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),

                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Row(
                        children: [
                          Icon(Icons.list, size: 16, color: Colors.grey[600]),
                          SizedBox(width: 8),
                          Text(
                            'Select Status',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      items: _policyInforceStatuses
                          .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ))
                          .toList(),
                      value: _policyList[index].policyInforceStatus,
                      onChanged: (String? newValue) async {
                        if (newValue == null) return;

                        if (newValue == "Fail") {
                          final failNote = await _showFailReasonDialog();
                          if (failNote != null && failNote.isNotEmpty) {
                            setState(() {
                              _policyList[index].policyInforceStatus = "Fail";
                              _policyList[index].failedPolicyNote = failNote;
                            });
                          }
                        } else {
                          setState(() {
                            _policyList[index].policyInforceStatus = newValue;
                            if (newValue != "Fail") {
                              _policyList[index].failedPolicyNote = "";
                            }
                          });
                        }
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                          color: Colors.white,
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                  // Fail note display and edit
                  if (_policyList[index].policyInforceStatus == "Fail" &&
                      _policyList[index].failedPolicyNote.isNotEmpty) ...[
                    SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Fail Reason:",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[700],
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () async {
                                  final updatedNote =
                                      await _showFailReasonDialog(
                                    initialNote:
                                        _policyList[index].failedPolicyNote,
                                  );
                                  if (updatedNote != null &&
                                      updatedNote.isNotEmpty) {
                                    setState(() {
                                      _policyList[index].failedPolicyNote =
                                          updatedNote;
                                    });
                                  }
                                },
                                icon: Icon(Icons.edit, size: 16),
                                label: Text("Edit"),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            _policyList[index].failedPolicyNote,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "$label:",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _showFailReasonDialog({String? initialNote}) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String tempNote = initialNote ?? "";
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  initialNote != null
                      ? "Edit Fail Reason"
                      : "Policy Fail Reason",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Please provide a reason for the failed policy:",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 12),
                TextField(
                  maxLines: 4,
                  controller: TextEditingController(text: tempNote),
                  decoration: InputDecoration(
                    hintText: "Enter fail reason...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Constants.ftaColorLight),
                    ),
                  ),
                  onChanged: (val) {
                    tempNote = val;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, null);
                      },
                      child: Text("Cancel"),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (tempNote.trim().isEmpty) {
                          return;
                        }
                        Navigator.pop(context, tempNote);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.ftaColorLight,
                      ),
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.3),
        elevation: 6,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Accepted Policies",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Content
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _policyList.length,
                    itemBuilder: (context, index) {
                      return _buildMobilePolicyCard(_policyList[index], index);
                    },
                  ),
          ),

          // Action Buttons
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                top: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            child: Column(
              children: [
                if (_inforcePolicyResponseResultAvailable == false)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _canContinue ? _handleInforceAction : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _canContinue
                            ? Constants.ftaColorLight
                            : Colors.grey,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: Text(
                        _policyList.length == 1
                            ? "Inforce Policy"
                            : "Inforce Policies",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                if (_inforcePolicyResponseResultAvailable == true)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.ftaColorLight,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: Text(
                        "Done",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleInforceAction() {
    if (Constants.currentleadAvailable == null) return;

    bool atLeastOneAvailable = false;

    for (PolicyData policy in _policyList) {
      if (policy.availablilityStatus == true) {
        atLeastOneAvailable = true;

        if (policy.policyInforceStatus == "Fail" &&
            policy.failedPolicyNote.isEmpty) {
          MotionToast.error(
            height: 45,
            description: Text(
              "Policy note for ${policy.policyNumber} is empty",
              style: TextStyle(color: Colors.white),
            ),
          ).show(context);
          return;
        }
      }
    }

    if (!atLeastOneAvailable) {
      MotionToast.error(
        height: 45,
        description: Text(
          "No policy is available to inforce",
          style: TextStyle(color: Colors.white),
        ),
      ).show(context);
      return;
    }

    if (atLeastOneAvailable) {
      _policyList = _policyList
          .where((policy) =>
              (policy.availablilityStatus == true) ||
              (policy.policyInforceStatus == "Fail" &&
                  policy.failedPolicyNote.isNotEmpty))
          .toList();

      List<PoliciesToInforce> inforce_details = [];
      for (PolicyData policy in _policyList) {
        AdditionalMember additional_member = Constants
            .currentleadAvailable!.additionalMembers
            .firstWhere((element) => element.relationship == "self");

        Constants.currentleadAvailable!.policies[0].quote.acceptPolicy = "yes";
        SalesService salesService = new SalesService();
        Constants.currentleadAvailable!.leadObject.status = "Completed";
        Constants.currentleadAvailable!.leadObject.hangUpReason =
            "Completed Sale";
        Constants.currentleadAvailable!.leadObject.hangUpDesc1 =
            "Completed Sale";
        Constants.currentleadAvailable!.leadObject.hangUpDesc2 =
            "Completed Sale";

        salesService.endLeadCall(
            lead: Constants.currentleadAvailable!.leadObject,
            empId: Constants.cec_employeeid);

        inforce_details.add(PoliciesToInforce(
            policy.policyNumber,
            Constants.cec_employeeid.toString(),
            policy.failedPolicyNote,
            (policy.policyInforceStatus ?? "New")
                .replaceAll("Inforce", "Inforced")
                .replaceAll("Fail", "Failed"),
            Constants.myEmail,
            policy.reference,
            Constants.myDisplayname,
            additional_member.title +
                " " +
                additional_member.name +
                " " +
                additional_member.surname,
            Constants.currentleadAvailable!.leadObject.clientEmail,
            "manual",
            ""));
      }

      _multiPolicyInforce(inforce_details);
    }
  }

  @override
  void dispose() {
    policyNumberController.dispose();
    super.dispose();
  }
}
