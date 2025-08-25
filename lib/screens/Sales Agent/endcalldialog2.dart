import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../constants/Constants.dart';
import '../../../../models/map_class.dart';
import '../../customwidgets/custom_input.dart';

import 'FieldSalesAffinity.dart';

class EndCallDialog2 extends StatefulWidget {
  const EndCallDialog2({super.key});

  @override
  State<EndCallDialog2> createState() => _EndCallDialog2State();
}

class _EndCallDialog2State extends State<EndCallDialog2> {
  String? _selectedWhyEnding;
  String? _selectedEndingCall1;
  String? _selectedEndingCall2;
  String? _selectedEndingCall3;
  String? _selectedEndingCall4;
  String? _selectedEndingCall5;
  String? _selectedEndingCall6;
  String? _selectedEndingCall7;
  String? _selectedCSUType;
  String? _selectedOverAge;
  String? _selectedEndingCall9;
  List<String> whyEndingCallList = [
    "Incomplete",
    "Not Interested",
    "Does Not Qualify",
    "Prank Call",
    "Duplicate",
    "Mystery Shopper",
    "Transfer",
    "Call Back"
  ];
  List<String> endingCallDescList1 = [
    "Wrong Number",
    "Already Covered",
    "Client Hang-up",
    "Cannot Afford",
    "Waiting Period"
  ];
  List<String> endingCallDescList3 = [
    "No Documents",
    "Incomplete Form",
    "Unclear Images",
    "Invalid ID Number",
    "Incorrect Premium",
    "No Affidavit",
    "Beneficiary Details",
    "Mandate Not Attached",
    "Invisible Application Form",
    "Incorrect Application Form"
  ];
  List<String> endingCallDescList2 = [
    "Old Mutual",
    "Discovery",
    "Other",
    "Clientele"
  ];
  List<String> endingCallDoesNotList4 = [
    "No SA ID",
    "No Bank Account",
    "Under Age",
    "Over Age",
    "NTU",
    "Lapsed Policy",
    "Maximum Cover Reached"
  ];
  List<String> endingCallPrankList5 = [
    "Jail",
    "Child",
  ];
  List<String> endingCallDescList6 = [
    "Old Mutual",
    "Discovery",
    "Other",
    "Clientele"
  ];
  List<String> endingCallTransferList7 = ["CSU", "To Pool", "Language Barrier"];
  List<String> endingCallBackDescList8 = ["Client Request", "Network"];
  List<String> csuTypeList = ["maintenance", "Enquiry"];

  bool animateValue1 = false;
  bool animateValue2 = false;
  int cardElevation = 0;

  List<double> animateValueHeight = [250.0, 450.0, 895.0];

  @override
  Widget build(BuildContext context) {
    final TextEditingController CADCallBackDateController =
        TextEditingController();
    final TextEditingController CADCallBackTimeController =
        TextEditingController();
    final TextEditingController CADOverDOBController = TextEditingController();
    final TextEditingController CADUnderDOBController = TextEditingController();
    final TextEditingController CADNTUTerminationController =
        TextEditingController();
    final TextEditingController CADProvideTerminationController =
        TextEditingController();
    final TextEditingController CADSearchController = TextEditingController();

    final FocusNode callBackDateFocusNode = FocusNode();
    final FocusNode searchFocusNode = FocusNode();
    final FocusNode underDOBFocusNode = FocusNode();
    final FocusNode provideTerminationFocusNode = FocusNode();
    final FocusNode terminationNTUFocusNode = FocusNode();
    final FocusNode overDOBFocusNode = FocusNode();
    final FocusNode callBackTimeFocusNode = FocusNode();

    return StatefulBuilder(
        builder: (context, setState) => Dialog(
              backgroundColor: Colors.black.withOpacity(0.65),
              surfaceTintColor: Colors.black.withOpacity(0.65),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0.0,
              child: Container(
                //height: animateValue1 ==true?animateValueHeight[1]:animateValue2 ==true?animateValueHeight[2]:animateValueHeight[0],
                width: MediaQuery.of(context).size.width * 0.5,
                //height:MediaQuery.of(context).size.height,
                constraints: BoxConstraints(maxWidth: 800, minHeight: 250.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 16, top: 16),
                      height: 60,
                      decoration: BoxDecoration(
                        color: Constants.ftaColorLight,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            topLeft: Radius.circular(16)),
                      ),
                      child: Text(
                        "Ending Call",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 18,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'YuGothic',
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                    SizedBox(
                                      height: 24,
                                    ),
                                    const Text(
                                      'Please provide a reason for ending the call.',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'YuGothic',
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
                                                  border: Border.all(
                                                      width: 1.0,
                                                      color: Colors.grey
                                                          .withOpacity(0.55)),
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                    dropdownColor: Colors.white,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                        fontFamily: 'YuGothic'),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 24,
                                                            right: 24,
                                                            top: 5,
                                                            bottom: 5),
                                                    hint: const Text(
                                                      'Choose Reason',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic'),
                                                    ),
                                                    isExpanded: true,
                                                    value: _selectedWhyEnding,
                                                    items: whyEndingCallList
                                                        .map((String
                                                                classType) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                              value: classType,
                                                              child: Text(
                                                                classType,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13.5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontFamily:
                                                                        'YuGothic',
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ))
                                                        .toList(),
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        animateValue1 = true;
                                                        _selectedWhyEnding =
                                                            newValue!
                                                                .toString();
                                                      });
                                                    }),
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
                          if (_selectedWhyEnding == "Not Interested") ...[
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
                                      SizedBox(
                                        height: 16,
                                      ),
                                      const Text(
                                        'Description',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: 'YuGothic',
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
                                                    border: Border.all(
                                                        width: 1.0,
                                                        color: Colors.grey
                                                            .withOpacity(0.55)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                      dropdownColor:
                                                          Colors.white,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic'),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 24,
                                                              right: 24,
                                                              top: 5,
                                                              bottom: 5),
                                                      hint: const Text(
                                                        '--Select--',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                'YuGothic'),
                                                      ),
                                                      isExpanded: true,
                                                      value:
                                                          _selectedEndingCall1,
                                                      items: endingCallDescList1
                                                          .map((String
                                                                  classType) =>
                                                              DropdownMenuItem<
                                                                  String>(
                                                                value:
                                                                    classType,
                                                                child: Text(
                                                                  classType,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13.5,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontFamily:
                                                                          'YuGothic',
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ))
                                                          .toList(),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          animateValue2 = true;
                                                          _selectedEndingCall1 =
                                                              newValue!
                                                                  .toString();
                                                        });
                                                      }),
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
                            if (_selectedEndingCall1 == "Already Covered") ...[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Insurance Company',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal,
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
                                                      border: Border.all(
                                                          width: 1.0,
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.55)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4)),
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child: DropdownButton(
                                                        dropdownColor:
                                                            Colors.white,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 24,
                                                                right: 24,
                                                                top: 5,
                                                                bottom: 5),
                                                        hint: const Text(
                                                          '--Select--',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        isExpanded: true,
                                                        value:
                                                            _selectedEndingCall2,
                                                        items:
                                                            endingCallDescList2
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
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ))
                                                                .toList(),
                                                        onChanged: (newValue) {
                                                          animateValue2 = true;
                                                          setState(() {
                                                            _selectedEndingCall2 =
                                                                newValue!
                                                                    .toString();
                                                          });
                                                        }),
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
                              )
                            ]
                          ],
                          if (_selectedWhyEnding == "Incomplete") ...[
                            SizedBox(
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
                                        'Description',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'YuGothic',
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
                                                    border: Border.all(
                                                        width: 1.0,
                                                        color: Colors.grey
                                                            .withOpacity(0.55)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                      dropdownColor:
                                                          Colors.white,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic'),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 24,
                                                              right: 24,
                                                              top: 5,
                                                              bottom: 5),
                                                      hint: const Text(
                                                        '--Select--',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                'YuGothic'),
                                                      ),
                                                      isExpanded: true,
                                                      value:
                                                          _selectedEndingCall3,
                                                      items: endingCallDescList3
                                                          .map((String
                                                                  classType) =>
                                                              DropdownMenuItem<
                                                                  String>(
                                                                value:
                                                                    classType,
                                                                child: Text(
                                                                  classType,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13.5,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontFamily:
                                                                          'YuGothic',
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ))
                                                          .toList(),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          animateValue1 = true;
                                                          _selectedEndingCall3 =
                                                              newValue!
                                                                  .toString();
                                                        });
                                                      }),
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
                            )
                          ],
                          if (_selectedWhyEnding == "Does Not Qualify") ...[
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
                                        'Description',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'YuGothic',
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
                                                    border: Border.all(
                                                        width: 1.0,
                                                        color: Colors.grey
                                                            .withOpacity(0.55)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                      dropdownColor:
                                                          Colors.white,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'YuGothic',
                                                      ),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 24,
                                                              right: 24,
                                                              top: 5,
                                                              bottom: 5),
                                                      hint: const Text(
                                                        '--Select--',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic',
                                                        ),
                                                      ),
                                                      isExpanded: true,
                                                      value:
                                                          _selectedEndingCall4,
                                                      items:
                                                          endingCallDoesNotList4
                                                              .map((String
                                                                      classType) =>
                                                                  DropdownMenuItem<
                                                                      String>(
                                                                    value:
                                                                        classType,
                                                                    child: Text(
                                                                      classType,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13.5,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              'YuGothic',
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ))
                                                              .toList(),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          animateValue1 = true;
                                                          _selectedEndingCall4 =
                                                              newValue!
                                                                  .toString();
                                                        });
                                                      }),
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
                            if (_selectedEndingCall4 == "Under Age") ...[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Enter Date of Birth ',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'YuGothic',
                                              color: Colors.black),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: CustomInput2(
                                                controller:
                                                    CADUnderDOBController,
                                                hintText: "Date of birth",
                                                onChanged: (value) {
                                                  _selectDate(context,
                                                      CADUnderDOBController);
                                                },
                                                onSubmitted: (value) {
                                                  _selectDate(context,
                                                      CADUnderDOBController);
                                                },
                                                focusNode: underDOBFocusNode,
                                                //suffix: Icon(CupertinoIcons.person_fill, size: 22, color: Color(0xFFEF601B).withOpacity(0.45),),
                                                textInputAction:
                                                    TextInputAction.next,
                                                isPasswordField: false,
                                                prefix: Container(
                                                  width: 45,
                                                  height: 65,
                                                  decoration: BoxDecoration(
                                                      color: Constants
                                                          .ftaColorLight,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(4),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      4))),
                                                  child: Center(
                                                    child: Icon(
                                                      CupertinoIcons.calendar,
                                                      size: 18,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ] else if (_selectedEndingCall4 == "Over Age") ...[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Enter Date of Birth ',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'YuGothic',
                                              color: Colors.black),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: CustomInput2(
                                                controller:
                                                    CADOverDOBController,
                                                hintText: "Date of Birth",
                                                onChanged: (value) {
                                                  _selectDate(context,
                                                      CADOverDOBController);
                                                },
                                                onSubmitted: (value) {
                                                  _selectDate(context,
                                                      CADOverDOBController);
                                                },
                                                focusNode: overDOBFocusNode,
                                                //suffix: Icon(CupertinoIcons.person_fill, size: 22, color: Color(0xFFEF601B).withOpacity(0.45),),
                                                textInputAction:
                                                    TextInputAction.next,
                                                isPasswordField: false,
                                                prefix: Container(
                                                  width: 45,
                                                  height: 65,
                                                  decoration: BoxDecoration(
                                                      color: Constants
                                                          .ftaColorLight,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(4),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      4))),
                                                  child: Center(
                                                    child: Icon(
                                                      CupertinoIcons.calendar,
                                                      size: 18,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ] else if (_selectedEndingCall4 == "NTU") ...[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Enter Termination Date',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'YuGothic',
                                              color: Colors.black),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: CustomInput2(
                                                controller:
                                                    CADNTUTerminationController,
                                                hintText:
                                                    "Enter Termination Date",
                                                onChanged: (value) {
                                                  _selectDate(context,
                                                      CADNTUTerminationController);
                                                },
                                                onSubmitted: (value) {
                                                  _selectDate(context,
                                                      CADNTUTerminationController);
                                                },
                                                focusNode:
                                                    terminationNTUFocusNode,
                                                //suffix: Icon(CupertinoIcons.person_fill, size: 22, color: Color(0xFFEF601B).withOpacity(0.45),),
                                                textInputAction:
                                                    TextInputAction.next,
                                                isPasswordField: false,
                                                prefix: Container(
                                                  width: 45,
                                                  height: 65,
                                                  decoration: BoxDecoration(
                                                      color: Constants
                                                          .ftaColorLight,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(4),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      4))),
                                                  child: Center(
                                                    child: Icon(
                                                      CupertinoIcons.calendar,
                                                      size: 18,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ] else if (_selectedEndingCall4 ==
                                "Lapsed Policy") ...[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Provide Termination Date ',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'YuGothic',
                                              color: Colors.black),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: CustomInput2(
                                                controller:
                                                    CADProvideTerminationController,
                                                hintText:
                                                    "Provide Termination Date",
                                                onChanged: (value) {
                                                  _selectDate(context,
                                                      CADProvideTerminationController);
                                                },
                                                onSubmitted: (value) {
                                                  _selectDate(context,
                                                      CADProvideTerminationController);
                                                },
                                                focusNode:
                                                    provideTerminationFocusNode,
                                                //suffix: Icon(CupertinoIcons.person_fill, size: 22, color: Color(0xFFEF601B).withOpacity(0.45),),
                                                textInputAction:
                                                    TextInputAction.next,
                                                isPasswordField: false,
                                                prefix: Container(
                                                  width: 45,
                                                  height: 65,
                                                  decoration: BoxDecoration(
                                                      color: Constants
                                                          .ftaColorLight,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(4),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      4))),
                                                  child: Center(
                                                    child: Icon(
                                                      CupertinoIcons.calendar,
                                                      size: 18,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ]
                          ],
                          if (_selectedWhyEnding == "Prank Call") ...[
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
                                        'Description',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'YuGothic',
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
                                                    border: Border.all(
                                                        width: 1.0,
                                                        color: Colors.grey
                                                            .withOpacity(0.55)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                      dropdownColor:
                                                          Colors.white,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'YuGothic',
                                                      ),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 24,
                                                              right: 24,
                                                              top: 5,
                                                              bottom: 5),
                                                      hint: const Text(
                                                        '--Select--',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic',
                                                        ),
                                                      ),
                                                      isExpanded: true,
                                                      value:
                                                          _selectedEndingCall5,
                                                      items:
                                                          endingCallPrankList5
                                                              .map((String
                                                                      classType) =>
                                                                  DropdownMenuItem<
                                                                      String>(
                                                                    value:
                                                                        classType,
                                                                    child: Text(
                                                                      classType,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13.5,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              'YuGothic',
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ))
                                                              .toList(),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          animateValue1 = true;
                                                          _selectedEndingCall5 =
                                                              newValue!
                                                                  .toString();
                                                        });
                                                      }),
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
                          ],
                          if (_selectedWhyEnding == "Transfer") ...[
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
                                        'Description',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'YuGothic',
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
                                                    border: Border.all(
                                                        width: 1.0,
                                                        color: Colors.grey
                                                            .withOpacity(0.55)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                      dropdownColor:
                                                          Colors.white,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'YuGothic',
                                                      ),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 24,
                                                              right: 24,
                                                              top: 5,
                                                              bottom: 5),
                                                      hint: const Text(
                                                        '--Select--',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic',
                                                        ),
                                                      ),
                                                      isExpanded: true,
                                                      value:
                                                          _selectedEndingCall6,
                                                      items:
                                                          endingCallTransferList7
                                                              .map((String
                                                                      classType) =>
                                                                  DropdownMenuItem<
                                                                      String>(
                                                                    value:
                                                                        classType,
                                                                    child: Text(
                                                                      classType,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13.5,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              'YuGothic',
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ))
                                                              .toList(),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          animateValue1 = true;
                                                          _selectedEndingCall6 =
                                                              newValue!
                                                                  .toString();
                                                          if (_selectedEndingCall6 ==
                                                              "Language Barrier") {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    false,
                                                                // set to false if you want to force a rating
                                                                builder:
                                                                    (context) =>
                                                                        StatefulBuilder(
                                                                          builder: (context, setState) =>
                                                                              Dialog(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(16),
                                                                            ),
                                                                            elevation:
                                                                                0.0,
                                                                            backgroundColor:
                                                                                Colors.transparent,
                                                                            child: Container(
                                                                                constraints: BoxConstraints(minHeight: 250.0, maxWidth: 1000),
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
                                                                                        height: 60,
                                                                                        decoration: BoxDecoration(
                                                                                          color: Constants.ftaColorLight,
                                                                                          borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
                                                                                        ),
                                                                                        child: Row(
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            Text(
                                                                                              "Branch Consultants",
                                                                                              style: GoogleFonts.lato(
                                                                                                textStyle: TextStyle(fontSize: 18, letterSpacing: 0, fontWeight: FontWeight.w500, fontFamily: 'YuGothic', color: Colors.white),
                                                                                              ),
                                                                                            ),
                                                                                            InkWell(
                                                                                              child: CircleAvatar(
                                                                                                  backgroundColor: Constants.ftaColorLight,
                                                                                                  radius: 22,
                                                                                                  child: Center(
                                                                                                      child: Icon(
                                                                                                    CupertinoIcons.xmark,
                                                                                                    size: 24,
                                                                                                    color: Colors.black,
                                                                                                  ))),
                                                                                              onTap: () {
                                                                                                Navigator.pop(context);
                                                                                                setState(() {});
                                                                                              },
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 24,
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 16, right: 16),
                                                                                        child: Row(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            Expanded(
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                children: [
                                                                                                  const Text(
                                                                                                    'Search:',
                                                                                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, fontFamily: 'YuGothic', color: Colors.black),
                                                                                                  ),
                                                                                                  const SizedBox(height: 8),
                                                                                                  Row(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Expanded(
                                                                                                        child: CustomInput2(
                                                                                                          controller: CADSearchController,
                                                                                                          hintText: "Search: type keywords e.g name or surname",
                                                                                                          onChanged: (String) {},
                                                                                                          onSubmitted: (String) {},
                                                                                                          focusNode: searchFocusNode,
                                                                                                          //suffix: Icon(CupertinoIcons.person_fill, size: 22, color: Color(0xFFEF601B).withOpacity(0.45),),
                                                                                                          textInputAction: TextInputAction.next,
                                                                                                          isPasswordField: false,
                                                                                                        ),
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                        width: 22,
                                                                                                      ),
                                                                                                      InkWell(
                                                                                                        child: Container(
                                                                                                          height: 45,
                                                                                                          width: 100,
                                                                                                          padding: EdgeInsets.all(8),
                                                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Constants.ftaColorLight),
                                                                                                          child: const Row(
                                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                                            children: [
                                                                                                              Icon(
                                                                                                                Icons.refresh,
                                                                                                                size: 18,
                                                                                                                color: Colors.white,
                                                                                                              ),
                                                                                                              SizedBox(
                                                                                                                width: 8,
                                                                                                              ),
                                                                                                              Text(
                                                                                                                "Search",
                                                                                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, fontFamily: 'YuGothic', color: Colors.black),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                        onTap: () {},
                                                                                                      )
                                                                                                    ],
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 16,
                                                                                      ),
                                                                                      Divider(
                                                                                        color: Colors.grey.withOpacity(0.55),
                                                                                        thickness: 1.0,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 16,
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 16, right: 16),
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Expanded(
                                                                                              child: GridView.builder(
                                                                                                  itemCount: Constants.agentList.length,
                                                                                                  shrinkWrap: true,
                                                                                                  physics: NeverScrollableScrollPhysics(),
                                                                                                  //scrollDirection: Axis.horizontal,
                                                                                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                                                    crossAxisCount: 4,
                                                                                                    crossAxisSpacing: 15,
                                                                                                    mainAxisSpacing: 15,
                                                                                                    //childAspectRatio: 16/9,
                                                                                                  ),
                                                                                                  itemBuilder: (context, index) {
                                                                                                    return InkWell(
                                                                                                      child: Material(
                                                                                                        surfaceTintColor: Colors.white,
                                                                                                        elevation: cardElevation == index ? 10 : 2,
                                                                                                        shadowColor: Constants.ftaColorLight,
                                                                                                        shape: RoundedRectangleBorder(
                                                                                                          borderRadius: BorderRadius.circular(12),
                                                                                                        ),
                                                                                                        color: Colors.white,
                                                                                                        child: Container(
                                                                                                          padding: EdgeInsets.all(16),
                                                                                                          decoration: BoxDecoration(
                                                                                                            borderRadius: BorderRadius.circular(12),
                                                                                                            color: Colors.white,
                                                                                                          ),
                                                                                                          child: Column(
                                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                                            children: [
                                                                                                              Icon(
                                                                                                                CupertinoIcons.person_alt_circle_fill,
                                                                                                                size: 100,
                                                                                                                color: Colors.grey.withOpacity(0.8),
                                                                                                              ),
                                                                                                              SizedBox(
                                                                                                                height: 8,
                                                                                                              ),
                                                                                                              Text(
                                                                                                                "${Constants.agentList[index].employeeTitle} ${Constants.agentList[index].employeeName} ${Constants.agentList[index].employeeSurname}",
                                                                                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, fontFamily: 'YuGothic', color: Colors.black),
                                                                                                              ),
                                                                                                              SizedBox(
                                                                                                                height: 8,
                                                                                                              ),
                                                                                                              Container(
                                                                                                                height: 40,
                                                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Constants.ftaColorLight),
                                                                                                                child: Center(
                                                                                                                    child: Text(
                                                                                                                  Constants.agentList[index].employeeEmail,
                                                                                                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, fontFamily: 'YuGothic', color: Colors.white),
                                                                                                                )),
                                                                                                              )
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                      onTap: () {
                                                                                                        cardElevation = index;
                                                                                                        setState(() {});
                                                                                                      },
                                                                                                    );
                                                                                                  }),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 24,
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
                            if (_selectedEndingCall6 == "CSU") ...[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'CSU Type',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'YuGothic',
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
                                                      border: Border.all(
                                                          width: 1.0,
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.55)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4)),
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child: DropdownButton(
                                                        dropdownColor:
                                                            Colors.white,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic',
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 24,
                                                                right: 24,
                                                                top: 5,
                                                                bottom: 5),
                                                        hint: const Text(
                                                          'Enquiry',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                'YuGothic',
                                                          ),
                                                        ),
                                                        isExpanded: true,
                                                        value: _selectedCSUType,
                                                        items: csuTypeList
                                                            .map((String
                                                                    classType) =>
                                                                DropdownMenuItem<
                                                                    String>(
                                                                  value:
                                                                      classType,
                                                                  child: Text(
                                                                    classType,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13.5,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontFamily:
                                                                            'YuGothic',
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ))
                                                            .toList(),
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            animateValue1 =
                                                                true;
                                                            _selectedCSUType =
                                                                newValue!
                                                                    .toString();
                                                          });
                                                        }),
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
                            ]
                          ],
                          if (_selectedWhyEnding == "Call Back") ...[
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
                                        'Description',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'YuGothic',
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
                                                    border: Border.all(
                                                        width: 1.0,
                                                        color: Colors.grey
                                                            .withOpacity(0.55)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                      dropdownColor:
                                                          Colors.white,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'YuGothic',
                                                      ),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 24,
                                                              right: 24,
                                                              top: 5,
                                                              bottom: 5),
                                                      hint: const Text(
                                                        '--Select--',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic',
                                                        ),
                                                      ),
                                                      isExpanded: true,
                                                      value:
                                                          _selectedEndingCall7,
                                                      items:
                                                          endingCallBackDescList8
                                                              .map((String
                                                                      classType) =>
                                                                  DropdownMenuItem<
                                                                      String>(
                                                                    value:
                                                                        classType,
                                                                    child: Text(
                                                                      classType,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13.5,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              'YuGothic',
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ))
                                                              .toList(),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          animateValue1 = true;
                                                          _selectedEndingCall7 =
                                                              newValue!
                                                                  .toString();
                                                        });
                                                      }),
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
                            if (_selectedEndingCall7 == "Client Request" ||
                                _selectedEndingCall7 == "Network") ...[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "Thank You ${Constants.currentleadAvailable!.leadObject.title} ${Constants.currentleadAvailable!.leadObject..firstName} ${Constants.currentleadAvailable!.leadObject..lastName}. When is a better time to call you back?",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'YuGothic',
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Constants.ftaColorLight,
                                        )),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 0, right: 0),
                                          child: Container(
                                            height: 45,
                                            padding: EdgeInsets.only(
                                                left: 16, right: 16),
                                            decoration: BoxDecoration(
                                              color: Constants.ftaColorLight,
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(12),
                                                  topLeft: Radius.circular(12)),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  CupertinoIcons
                                                      .phone_badge_plus,
                                                  size: 26,
                                                  color: Colors.black,
                                                ),
                                                SizedBox(
                                                  width: 12,
                                                ),
                                                Text(
                                                  "Call back time",
                                                  style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        fontSize: 18,
                                                        letterSpacing: 0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'YuGothic',
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: CustomInput2(
                                                  controller:
                                                      CADCallBackDateController,
                                                  hintText: "Call Back Date",
                                                  onChanged: (value) {
                                                    _selectDate(context,
                                                        CADCallBackDateController);
                                                  },
                                                  onSubmitted: (value) {
                                                    _selectDate(context,
                                                        CADCallBackDateController);
                                                  },
                                                  focusNode:
                                                      callBackDateFocusNode,
                                                  //suffix: Icon(CupertinoIcons.person_fill, size: 22, color: Color(0xFFEF601B).withOpacity(0.45),),
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  isPasswordField: false,
                                                  prefix: Container(
                                                    width: 45,
                                                    height: 65,
                                                    decoration: BoxDecoration(
                                                        color: Constants
                                                            .ftaColorLight,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        4),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        4))),
                                                    child: Center(
                                                      child: Icon(
                                                        CupertinoIcons.calendar,
                                                        size: 18,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 22),
                                              Expanded(
                                                child: CustomInput2(
                                                  controller:
                                                      CADCallBackTimeController,
                                                  hintText: "Call Back Time",
                                                  onChanged: (value) {
                                                    _selectTime(context,
                                                        CADCallBackTimeController);
                                                    setState(() {});
                                                  },
                                                  onSubmitted: (value) {
                                                    _selectTime(context,
                                                        CADCallBackTimeController);
                                                    setState(() {});
                                                  },
                                                  focusNode:
                                                      callBackTimeFocusNode,
                                                  //suffix: Icon(CupertinoIcons.person_fill, size: 22, color: Color(0xFFEF601B).withOpacity(0.45),),
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  isPasswordField: false,
                                                  suffix: Container(
                                                    width: 45,
                                                    height: 65,
                                                    decoration: BoxDecoration(
                                                        color: Constants
                                                            .ftaColorLight,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        4),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        4))),
                                                    child: Center(
                                                      child: Icon(
                                                        CupertinoIcons.time,
                                                        size: 18,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 22),
                                              InkWell(
                                                child: Container(
                                                  height: 50,
                                                  width: 80,
                                                  padding: EdgeInsets.only(
                                                      left: 16, right: 16),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: Constants
                                                          .ftaColorLight),
                                                  child: Center(
                                                    child: Text(
                                                      "Save",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          letterSpacing: 0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'YuGothic',
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  setState(() {});
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ]
                          ],
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                child: Container(
                                  height: 40,
                                  constraints:
                                      const BoxConstraints(minWidth: 200),
                                  //width: 120,
                                  padding: EdgeInsets.only(left: 32, right: 32),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(32),
                                      color: Colors.grey.withOpacity(0.35)),
                                  child: Center(
                                    child: Text(
                                      "End call",
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                            fontSize: 13,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'YuGothic',
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const Fieldsalesaffinity()),
                                  );
                                  /*Navigator.push(
                                                                 context,
                                                                 MaterialPageRoute(
                                                                     builder: (context) =>
                                                                         const Fieldsalesaffinity()),
                                                               );*/
                                  setState(() {});
                                },
                              ),
                              SizedBox(
                                width: 32,
                              ),
                              InkWell(
                                child: Container(
                                  height: 40,
                                  constraints:
                                      const BoxConstraints(minWidth: 200),
                                  //width: 120,
                                  padding: EdgeInsets.only(left: 32, right: 32),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(32),
                                      color: Constants.ftaColorLight),
                                  child: Center(
                                    child: Text(
                                      "Continue with Call",
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                            fontSize: 13,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'YuGothic',
                                            color: Colors.white),
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  @override
  initState() {
    super.initState();
    getAllEmployees(context, Constants.cec_employeeid, Constants.cec_client_id);
  }

  getAllEmployees(BuildContext context, int empId, int clientId) async {
    String baseUrl =
        "${Constants.insightsbaseUrl}chat/getAllUserDetails?empId=$empId&client_id=$clientId";
    var headers = {
      'Cookie':
          'userid=expiry=2024-01-19&client_modules=1001#1002#1003#1004#1005#1006#1007#1008#1009#1010#1011#1012#1013#1014#1015#1017#1018#1020#1021#1022#1024#1025#1026#1027#1028#1029#1030#1031#1032#1033#1034#1035&clientid=1&empid=3&empfirstname=Mncedisi&emplastname=Khumalo&email=mncedisi@athandwe.co.za&username=mncedisi@athandwe.co.za&dob=8/28/1985 12:00:00 AM&fullname=Mncedisi Khumalo&userRole=5&userImage=mncedisi@athandwe.co.za.jpg&employedAt=branch&role=leader&branchid=6&branchname=Boulders&jobtitle=Administrative Assistant&dialing_strategy=Group Stages&clientname=Test 1 Funeral Parlour&foldername=maafrica&client_abbr=AS&pbx_account=pbx1051ef0a&soft_phone_ip=&agent_type=branch&mip_username=mnces@mip.co.za&agent_email=Mr Mncedisi Khumalo&ViciDial_phone_login=&ViciDial_phone_password=&ViciDial_agent_user=99&ViciDial_agent_password=&device_id=&servername=http://localhost:55661'
    };
    Map<String, dynamic> payload = {
      "empId": "$empId",
      "client_id": "$clientId"
    };

    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));

      request.headers.addAll(headers);
      request.fields.addAll(Map<String, String>.from(payload));

      var streamedResponse = await request.send();

// Read the response as a string
      var response = await http.Response.fromStream(streamedResponse);
      print("kiweio8347646467yuewhd ${response.statusCode}");
      var responsedata = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("kiweio8347646467yuewhd ${response.body}");
        // List m1 = responsedata as List;
        responsedata.forEach((m1) {
          Constants.agentList.add(EmployeeDetails(
            employeeTitle: (m1["employee_title"] ?? "").toString(),
            employeeName: (m1["employee_name"] ?? "").toString(),
            employeeSurname: (m1["employee_surname"] ?? "").toString(),
            employeeEmail: (m1["employee_email"] ?? "").toString(),
            userImage: (m1["userImage"] ?? "").toString(),
            cecEmployeeId: (m1["cec_employeeid"] ?? "").toString(),
            mipUsername: (m1["mip_username"] ?? "").toString(),
            agentEmail: (m1["agent_email"] ?? "").toString(),
          ));
        });
      } else {
        print(response.reasonPhrase);
      }
    } catch (exception) {
      print("employeeeeeeeee ${exception.toString()}");
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    TimeOfDay? selectedTime = TimeOfDay.now();
    final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.dial);
    if (selectedTime != null) {
      setState(() {
        selectedTime = timeOfDay;
        controller.text = (selectedTime).toString();
        print("hfrbfcjecbgj ${(selectedTime).toString()}");
      });
    }
  }
}
