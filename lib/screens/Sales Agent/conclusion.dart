import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

import '../../../../constants/Constants.dart';

import '../../../../models/map_class.dart';
import '../../customwidgets/custom_input.dart';

// Example model for policy data
class Conclusion5a extends StatefulWidget {
  const Conclusion5a({
    super.key,
  });

  @override
  State<Conclusion5a> createState() => _Conclusion5aState();
}

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
                                                    showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        // set to false if you want to force a rating
                                                        builder:
                                                            (context) =>
                                                                StatefulBuilder(
                                                                  builder: (context,
                                                                          setState) =>
                                                                      Dialog(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(16),
                                                                          ),
                                                                          elevation:
                                                                              0.0,
                                                                          backgroundColor: Colors
                                                                              .white,
                                                                          child:
                                                                              Container(child: InforcePolicyDialog())),
                                                                ));
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
  final String policyNumber;
  final String reference;

  PolicyData({required this.policyNumber, required this.reference});

  factory PolicyData.fromJson(Map<String, dynamic> json) {
    return PolicyData(
      policyNumber: json['policy_number'],
      reference: json['reference'],
    );
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
