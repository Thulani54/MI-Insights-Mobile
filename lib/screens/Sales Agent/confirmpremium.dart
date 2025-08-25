import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

import '../../../../constants/Constants.dart';
import '../../../../models/map_class.dart';

class ConfirmPremium extends StatefulWidget {
  const ConfirmPremium({
    super.key,
  });

  @override
  State<ConfirmPremium> createState() => _ConfirmPremiumState();
}

List<ParentsFuneral> parentsFuneralList = [
  ParentsFuneral(1, 0.00, "2024-03-29", 56, 0.00),
];
List<Raiders> raidersList = [
  Raiders(1, "Raider 1", "Main Member", "Athandwe1", 0.00),
];

List<YesOrNoDialogue> dailogueList3 = [
  YesOrNoDialogue(stringValue: "Yes"),
  YesOrNoDialogue(stringValue: "No")
];
List<YesOrNoDialogue> dailogueList4 = [
  YesOrNoDialogue(stringValue: "Yes"),
  YesOrNoDialogue(stringValue: "No")
];

class _ConfirmPremiumState extends State<ConfirmPremium> {
  bool checkBoxValue3 = false;
  int expandedIndex = 0;
  int isTickMarked = 0;
  int hoverColor = -1;
  bool isTickMarked3 = false;
  bool checkBoxValue2 = false;
  bool checkBoxValue1 = false;
  bool checkBoxValue4 = false;
  bool checkBoxValue5 = false;
  bool boolColor2 = false;
  bool boolColor1 = false;
  bool boolColor3 = false;
  bool boolColor4 = false;
  bool isHover = false; //ParentsFuneral

  List<ConfirmPrem> premList = [
    ConfirmPrem(
        productName: "Individual Funeral",
        sumAssured: "R 0.00",
        premium: "R 0.00",
        isExpanded: false),
    ConfirmPrem(
        productName: "Family Funeral Rider",
        sumAssured: "R 0.00",
        premium: "R 0.00",
        isExpanded: false),
    ConfirmPrem(
        productName: "Additional Children Funeral (0)",
        sumAssured: "R 0.00",
        premium: "R 0.00",
        isExpanded: false),
    ConfirmPrem(
        productName: "Parents Funeral (0)",
        sumAssured: "R 0.00",
        premium: "R 0.00",
        isExpanded: false),
    ConfirmPrem(
        productName: "Extended Family Funeral (0)",
        sumAssured: "R 0.00",
        premium: "R 0.00",
        isExpanded: false),
    ConfirmPrem(
        productName: "Riders (0)",
        sumAssured: "R 0.00",
        premium: "R 0.00",
        isExpanded: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      constraints: BoxConstraints(maxWidth: 1400),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 70,
              width: MediaQuery.of(context).size.width,
              child: Material(
                elevation: 12,
                animationDuration: Duration(seconds: 5),
                shadowColor: Colors.black.withOpacity(0.35),
                surfaceTintColor: Colors.white,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0)),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Total Payable Amount : ${Constants.currentleadAvailable!.policies[0].quote.totalAmountPayable}",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'YuGothic',
                            letterSpacing: 0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54),
                      ),
                      Expanded(child: Container()),
                      InkWell(
                        child: Container(
                          height: 35,
                          width: 120,
                          padding: EdgeInsets.only(left: 16, right: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(360),
                              color: Constants.ctaColorLight),
                          child: Center(
                            child: Text(
                              "Close",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'YuGothic',
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {});
                        },
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Constants.trueOrFalseStringValueL == "Yes"
                          ? InkWell(
                              child: Container(
                                height: 35,
                                width: 120,
                                padding: EdgeInsets.only(left: 16, right: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(360),
                                  color: Constants.ftaColorLight,
                                ),
                                child: Center(
                                  child: Text(
                                    "Accept",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'YuGothic',
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {});
                              },
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text(
                "You have taken cover at a total premium of ${Constants.currentleadAvailable!.policies[0].quote.totalPremium}",
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'YuGothic',
                    letterSpacing: 0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Container(
                width: MediaQuery.of(context).size.width,
                //height: 60,
                padding:
                    EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: checkBoxValue3 == true
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12))
                        : BorderRadius.circular(12),
                    border: checkBoxValue3 == true
                        ? Border(
                            bottom: BorderSide(
                            width: 2.6,
                            color: Constants.ftaColorLight,
                          ))
                        : Border(
                            top: BorderSide.none,
                            bottom: BorderSide.none,
                            left: BorderSide.none,
                            right: BorderSide.none)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Material(
                      elevation: 7,
                      surfaceTintColor: Constants.ctaColorLight,
                      color: Constants.ftaColorLight,
                      shadowColor: Colors.black54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        height: 45,
                        padding: EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Constants.ftaColorLight,
                        ),
                        child: Center(
                          child: Text(
                            Constants.currentleadAvailable!.policies[0].quote
                                .productType,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'YuGothic',
                                letterSpacing: 0,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "${Constants.currentleadAvailable!.leadObject.title} ${Constants.currentleadAvailable!.leadObject.firstName} ${Constants.currentleadAvailable!.leadObject.lastName}",
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 0,
                                fontFamily: 'YuGothic',
                                fontWeight: FontWeight.w400,
                                color: Constants.ftaColorLight,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: Text(
                              "FUNERAL COVER ${Constants.currentleadAvailable!.policies[0].quote.productType.toUpperCase()}",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'YuGothic',
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 22,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              Constants.currentleadAvailable!.policies[0].quote
                                  .totalBenefitPremium
                                  .toString(),
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 0,
                                fontFamily: 'YuGothic',
                                fontWeight: FontWeight.w400,
                                color: Constants.ftaColorLight,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: Text(
                              "TOTAL BENEFIT PREMIUM",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'YuGothic',
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 22,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              Constants.currentleadAvailable!.policies[0].quote
                                  .totalPremium
                                  .toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'YuGothic',
                                letterSpacing: 0,
                                fontWeight: FontWeight.w400,
                                color: Constants.ftaColorLight,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: Text(
                              "TOTAL MONTHLY AMOUNT",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'YuGothic',
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 22,
                    ),
                    Transform.scale(
                      scaleX: 1.7,
                      scaleY: 1.7,
                      child: Checkbox(
                          splashRadius: 0.0,
                          value: checkBoxValue3,
                          side: BorderSide(
                            width: 1.0,
                            color: Constants.ftaColorLight,
                          ),
                          activeColor: Constants.ctaColorLight,
                          checkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(360)),
                          onChanged: (bool? newValue) {
                            isTickMarked = 1;
                            checkBoxValue3 = newValue!;
                            setState(() {
                              checkBoxValue3 != newValue!;
                            });
                          }),
                    ),
                    Spacer()
                  ],
                ),
              ),
            ),
            checkBoxValue3 == true
                ? Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Material(
                          elevation: 7,
                          surfaceTintColor: Colors.white,
                          color: Colors.white,
                          shadowColor: Colors.black,
                          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white,
                            padding: EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: const Text(
                                    "Product",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'YuGothic',
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                ),
                                Expanded(
                                  child: const Text(
                                    "Sum Assured",
                                    style: TextStyle(
                                        fontSize: 13,
                                        letterSpacing: 0,
                                        fontFamily: 'YuGothic',
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                ),
                                Expanded(
                                  child: const Text(
                                    "Premium",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'YuGothic',
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                ),
                                SizedBox(
                                  width: 22,
                                ),
                                const Text(
                                  "Details",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'YuGothic',
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                // height: 50,
                                //width: MediaQuery.of(context).size.width,
                                color: Colors.grey.withOpacity(0.1),
                                padding: EdgeInsets.all(8),
                                child: ExpansionPanelList(
                                  dividerColor: Constants.ftaColorLight,
                                  materialGapSize: 0.0,
                                  expansionCallback:
                                      (int index, bool isExpanded) {
                                    setState(() {
                                      premList[index].isExpanded = !isExpanded;
                                      // Close other panels if they are open
                                      for (int i = 0;
                                          i < premList.length;
                                          i++) {
                                        if (i != index) {
                                          premList[i].isExpanded = false;
                                        } else {
                                          premList[i].isExpanded = isExpanded;
                                        }
                                      }
                                    });
                                  },
                                  children: premList
                                      .map<ExpansionPanel>((ConfirmPrem prem) {
                                    int index = premList.indexOf(prem);
                                    expandedIndex = index;
                                    return ExpansionPanel(
                                      canTapOnHeader: true,
                                      backgroundColor: Colors.white,
                                      headerBuilder: (BuildContext context,
                                          bool isExpanded) {
                                        return Container(
                                          // height: 50,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: Colors.grey.withOpacity(0.04),
                                          padding: EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      prem.productName,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontFamily:
                                                              'YuGothic',
                                                          letterSpacing: 0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: hoverColor ==
                                                                  expandedIndex
                                                              ? Constants
                                                                  .ftaColorLight
                                                              : Colors.black),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      prem.sumAssured,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontFamily:
                                                              'YuGothic',
                                                          letterSpacing: 0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: hoverColor ==
                                                                  expandedIndex
                                                              ? Constants
                                                                  .ftaColorLight
                                                              : Colors.black),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      prem.premium,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontFamily:
                                                              'YuGothic',
                                                          letterSpacing: 0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: hoverColor ==
                                                                  expandedIndex
                                                              ? Constants
                                                                  .ftaColorLight
                                                              : Colors.black),
                                                    ),
                                                  ),
                                                  /*Expanded(
                                                  child: Icon(hoverColor == prem?Icons.keyboard_arrow_up_outlined :Icons.keyboard_arrow_down, size: 32,color:hoverColor == prem?Colors.redAccent: Colors.black,),
                                                ),*/
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      body: expandedIndex == 0 &&
                                              prem.isExpanded == true
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, bottom: 8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Center(
                                                              child: Text(
                                                                Constants
                                                                    .mainDOB,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontFamily:
                                                                        'YuGothic',
                                                                    letterSpacing:
                                                                        0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 8,
                                                            ),
                                                            Center(
                                                              child: Text(
                                                                "DATE OF BIRTH",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontFamily:
                                                                        'YuGothic',
                                                                    letterSpacing:
                                                                        0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 22,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Center(
                                                              child: Text(
                                                                Constants
                                                                    .mainAGE
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontFamily:
                                                                        'YuGothic',
                                                                    letterSpacing:
                                                                        0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 8,
                                                            ),
                                                            Center(
                                                              child: Text(
                                                                "MAIN INSURED AGE",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontFamily:
                                                                        'YuGothic',
                                                                    letterSpacing:
                                                                        0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 22,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Center(
                                                              child: Text(
                                                                "No",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontFamily:
                                                                        'YuGothic',
                                                                    letterSpacing:
                                                                        0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Constants
                                                                        .ftaColorLight),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 8,
                                                            ),
                                                            Center(
                                                              child: Text(
                                                                "POLICY HOLDER = MAIN INSURED?",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontFamily:
                                                                        'YuGothic',
                                                                    letterSpacing:
                                                                        0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 22,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Center(
                                                              child: Text(
                                                                Constants
                                                                    .currentleadAvailable!
                                                                    .policies[0]
                                                                    .quote
                                                                    .inceptionDate
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontFamily:
                                                                        'YuGothic',
                                                                    letterSpacing:
                                                                        0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 8,
                                                            ),
                                                            Center(
                                                              child: Text(
                                                                "INCEPTION DATE",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontFamily:
                                                                        'YuGothic',
                                                                    letterSpacing:
                                                                        0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Constants
                                                                        .ftaColorLight),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          : expandedIndex == 1 &&
                                                  prem.isExpanded == true
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8, bottom: 8),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Center(
                                                                  child: Text(
                                                                    Constants
                                                                        .partnerDOB,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontFamily:
                                                                            'YuGothic',
                                                                        letterSpacing:
                                                                            0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Center(
                                                                  child: Text(
                                                                    "PARTNER DATE OF BIRTH",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontFamily:
                                                                            'YuGothic',
                                                                        letterSpacing:
                                                                            0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 22,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Center(
                                                                  child: Text(
                                                                    Constants
                                                                        .partnerAGE
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontFamily:
                                                                            'YuGothic',
                                                                        letterSpacing:
                                                                            0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Constants
                                                                            .ctaColorLight),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Center(
                                                                  child: Text(
                                                                    "PARTNER AGE",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontFamily:
                                                                            'YuGothic',
                                                                        letterSpacing:
                                                                            0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 22,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Center(
                                                                  child: Text(
                                                                    Constants
                                                                        .currentleadAvailable!
                                                                        .policies[
                                                                            0]
                                                                        .quote
                                                                        .partnerFuneralSumAssured
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontFamily:
                                                                            'YuGothic',
                                                                        letterSpacing:
                                                                            0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Constants
                                                                            .ftaColorLight),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Center(
                                                                  child: Text(
                                                                    "PARTNER SUM ASSURED",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontFamily:
                                                                            'YuGothic',
                                                                        letterSpacing:
                                                                            0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 22,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Center(
                                                                  child: Text(
                                                                    Constants
                                                                        .currentleadAvailable!
                                                                        .policies[
                                                                            0]
                                                                        .quote
                                                                        .childrenSumAssured
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontFamily:
                                                                            'YuGothic',
                                                                        letterSpacing:
                                                                            0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Constants
                                                                            .ftaColorLight),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Center(
                                                                  child: Text(
                                                                    "CHILDREN SUM ASSURED",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontFamily:
                                                                            'YuGothic',
                                                                        letterSpacing:
                                                                            0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : expandedIndex == 2 &&
                                                      prem.isExpanded == true
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8,
                                                              bottom: 8),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Center(
                                                                      child:
                                                                          Text(
                                                                        "0",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            fontFamily:
                                                                                'YuGothic',
                                                                            letterSpacing:
                                                                                0,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    Center(
                                                                      child:
                                                                          Text(
                                                                        "ADDITIONAL CHILDREN COVERED",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          letterSpacing:
                                                                              0,
                                                                          fontFamily:
                                                                              'YuGothic',
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              Constants.ftaColorLight,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 22,
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Center(
                                                                      child:
                                                                          Text(
                                                                        "0",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            letterSpacing:
                                                                                0,
                                                                            fontFamily:
                                                                                'YuGothic',
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Constants.ctaColorLight),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    Center(
                                                                      child:
                                                                          Text(
                                                                        "CHILDREN SUM ASSURED",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            letterSpacing:
                                                                                0,
                                                                            fontFamily:
                                                                                'YuGothic',
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 22,
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Center(
                                                                      child:
                                                                          Text(
                                                                        "R NaN",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            letterSpacing:
                                                                                0,
                                                                            fontFamily:
                                                                                'YuGothic',
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Constants.ftaColorLight),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    Center(
                                                                      child:
                                                                          Text(
                                                                        "CHILDREN PREMIUM",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            fontFamily:
                                                                                'YuGothic',
                                                                            letterSpacing:
                                                                                0,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : expandedIndex == 3 &&
                                                          prem.isExpanded ==
                                                              true
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 8,
                                                                  bottom: 8),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                height: 40,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(8),
                                                                decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                      width:
                                                                          1.0,
                                                                      color: Constants
                                                                          .ftaColorLight,
                                                                    ))),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        "#",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            fontFamily:
                                                                                'YuGothic',
                                                                            letterSpacing:
                                                                                0,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        "Sum Assured",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            letterSpacing:
                                                                                0,
                                                                            fontFamily:
                                                                                'YuGothic',
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        "Date of Birth",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            fontFamily:
                                                                                'YuGothic',
                                                                            letterSpacing:
                                                                                0,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        "Age",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            fontFamily:
                                                                                'YuGothic',
                                                                            letterSpacing:
                                                                                0,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        "Premium",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            fontFamily:
                                                                                'YuGothic',
                                                                            letterSpacing:
                                                                                0,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              ListView.builder(
                                                                  itemCount:
                                                                      parentsFuneralList
                                                                          .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return Container(
                                                                      //height: 40,
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      color: Colors
                                                                          .white,
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8),
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              parentsFuneralList[index].id.toString(),
                                                                              style: TextStyle(fontSize: 13, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              parentsFuneralList[index].sumAssured.toString(),
                                                                              style: TextStyle(fontSize: 13, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              parentsFuneralList[index].dateOfBirth,
                                                                              style: TextStyle(fontSize: 13, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              parentsFuneralList[index].age.toString(),
                                                                              style: TextStyle(fontSize: 13, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              parentsFuneralList[index].premium.toString(),
                                                                              style: TextStyle(fontSize: 13, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  })
                                                            ],
                                                          ),
                                                        )
                                                      : expandedIndex == 4 &&
                                                              prem.isExpanded ==
                                                                  true
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 8,
                                                                      bottom:
                                                                          8),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    height: 40,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(8),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.white,
                                                                        border: Border(
                                                                            bottom: BorderSide(
                                                                          width:
                                                                              1.0,
                                                                          color:
                                                                              Constants.ftaColorLight,
                                                                        ))),
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            "#",
                                                                            style: TextStyle(
                                                                                fontSize: 13,
                                                                                fontFamily: 'YuGothic',
                                                                                letterSpacing: 0,
                                                                                fontWeight: FontWeight.w600,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            "Sum Assured",
                                                                            style: TextStyle(
                                                                                fontSize: 13,
                                                                                fontFamily: 'YuGothic',
                                                                                letterSpacing: 0,
                                                                                fontWeight: FontWeight.w600,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            "Date of Birth",
                                                                            style: TextStyle(
                                                                                fontSize: 13,
                                                                                fontFamily: 'YuGothic',
                                                                                letterSpacing: 0,
                                                                                fontWeight: FontWeight.w600,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            "Age",
                                                                            style: TextStyle(
                                                                                fontSize: 13,
                                                                                fontFamily: 'YuGothic',
                                                                                letterSpacing: 0,
                                                                                fontWeight: FontWeight.w600,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            "Premium",
                                                                            style: TextStyle(
                                                                                fontSize: 13,
                                                                                fontFamily: 'YuGothic',
                                                                                letterSpacing: 0,
                                                                                fontWeight: FontWeight.w600,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  ListView.builder(
                                                                      itemCount: parentsFuneralList.length,
                                                                      shrinkWrap: true,
                                                                      itemBuilder: (context, index) {
                                                                        return Container(
                                                                          //height: 40,
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          color:
                                                                              Colors.white,
                                                                          padding:
                                                                              EdgeInsets.all(8),
                                                                          child:
                                                                              Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Text(
                                                                                  parentsFuneralList[index].id.toString(),
                                                                                  style: TextStyle(fontSize: 13, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Text(
                                                                                  parentsFuneralList[index].sumAssured.toString(),
                                                                                  style: TextStyle(fontSize: 13, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Text(
                                                                                  parentsFuneralList[index].dateOfBirth,
                                                                                  style: TextStyle(fontSize: 13, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Text(
                                                                                  parentsFuneralList[index].age.toString(),
                                                                                  style: TextStyle(fontSize: 13, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Text(
                                                                                  parentsFuneralList[index].premium.toString(),
                                                                                  style: TextStyle(fontSize: 13, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      })
                                                                ],
                                                              ),
                                                            )
                                                          : expandedIndex ==
                                                                      5 &&
                                                                  prem.isExpanded ==
                                                                      true
                                                              ? Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              8,
                                                                          bottom:
                                                                              8),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            40,
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        padding:
                                                                            EdgeInsets.all(8),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            border: Border(bottom: BorderSide(width: 1.0, color: Colors.blue))),
                                                                        child:
                                                                            Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text(
                                                                                "#",
                                                                                style: TextStyle(fontSize: 13, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w600, color: Colors.black),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: Text(
                                                                                "Rider Type",
                                                                                style: TextStyle(fontSize: 13, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w600, color: Colors.black),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: Text(
                                                                                "Member Type",
                                                                                style: TextStyle(fontSize: 13, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w600, color: Colors.black),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: Text(
                                                                                "Cover",
                                                                                style: TextStyle(fontSize: 13, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w600, color: Colors.black),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: Text(
                                                                                "Premium",
                                                                                style: TextStyle(fontSize: 13, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w600, color: Colors.black),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      ListView.builder(
                                                                          itemCount: raidersList.length,
                                                                          shrinkWrap: true,
                                                                          itemBuilder: (context, index) {
                                                                            return Container(
                                                                              //height: 40,
                                                                              width: MediaQuery.of(context).size.width,
                                                                              color: Colors.white,
                                                                              padding: EdgeInsets.all(8),
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      raidersList[index].id.toString(),
                                                                                      style: TextStyle(fontSize: 13, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.black),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      raidersList[index].riderType,
                                                                                      style: TextStyle(fontSize: 13, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.black),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      raidersList[index].memberType,
                                                                                      style: TextStyle(fontSize: 13, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.black),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      raidersList[index].cover,
                                                                                      style: TextStyle(fontSize: 13, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.black),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      raidersList[index].premium.toString(),
                                                                                      style: TextStyle(fontSize: 13, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.black),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          })
                                                                    ],
                                                                  ),
                                                                )
                                                              : Container(),
                                      isExpanded: premList[index].isExpanded,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Container(),
            SizedBox(
              height: 24,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: StyledText(
                text: "Is this affordable to you?",
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
                  fontSize: 18.0,
                  color: Colors.black,
                  //  fontFamily: 'YuGothic',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Container(
                height: 60,
                child: ListView.builder(
                    itemCount: dailogueList3.length,
                    scrollDirection: Axis.horizontal,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Container(
                            height: 60,
                            width: 99,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  width: 1.0,
                                  color: dailogueList3[index].stateValue == true
                                      ? Constants.ftaColorLight
                                      : Colors.grey.withOpacity(0.35)),
                              color: Colors.transparent,
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  Transform.scale(
                                    scaleX: 1.7,
                                    scaleY: 1.7,
                                    child: Checkbox(
                                        value: dailogueList3[index].stateValue,
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
                                          dailogueList3[index].stateValue =
                                              newValue!;
                                          setState(() {
                                            for (int i = 0;
                                                i < dailogueList3.length;
                                                i++) {
                                              if (i != index) {
                                                dailogueList3[i].stateValue =
                                                    false;
                                                //Constants.trueOrFalseStringValue = dailogueList[i].stringValue;
                                              } else {
                                                dailogueList3[i].stateValue =
                                                    newValue!;
                                                Constants
                                                        .trueOrFalseStringValueJ =
                                                    dailogueList3[i]
                                                        .stringValue;
                                                Constants.isAffordable =
                                                    dailogueList3[i]
                                                        .stringValue;
                                              }
                                            }
                                            print(
                                                "hhhhhhhh ${Constants.trueOrFalseStringValue}");
                                          });
                                        }),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    dailogueList3[index].stringValue,
                                    style: TextStyle(
                                        color:
                                            dailogueList3[index].stateValue ==
                                                    true
                                                ? Constants.ftaColorLight
                                                : Colors.grey.withOpacity(0.35),
                                        fontSize: 18,
                                        fontFamily: 'YuGothic',
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
            ),
            SizedBox(
              height: 32,
            ),
            Constants.trueOrFalseStringValueJ == "Yes"
                ? Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: FadeInLeftBig(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.linearToEaseOut,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          StyledText(
                            text:
                                "Can I proceed in arranging this product(s) for you?",
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
                              fontSize: 18.0,
                              color: Colors.black,
                              //  fontFamily: 'YuGothic',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 60,
                            child: ListView.builder(
                                itemCount: dailogueList4.length,
                                scrollDirection: Axis.horizontal,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 99,
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                              width: 1.0,
                                              color: dailogueList4[index]
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
                                                scaleX: 1.7,
                                                scaleY: 1.7,
                                                child: Checkbox(
                                                    value: dailogueList4[index]
                                                        .stateValue,
                                                    side: BorderSide(
                                                      width: 1.4,
                                                      color: Constants
                                                          .ftaColorLight,
                                                    ),
                                                    activeColor:
                                                        Constants.ctaColorLight,
                                                    checkColor: Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        360)),
                                                    onChanged: (newValue) {
                                                      dailogueList4[index]
                                                              .stateValue =
                                                          newValue!;
                                                      setState(() {
                                                        for (int i = 0;
                                                            i <
                                                                dailogueList4
                                                                    .length;
                                                            i++) {
                                                          if (i != index) {
                                                            dailogueList4[i]
                                                                    .stateValue =
                                                                false;
                                                            //Constants.trueOrFalseStringValue = dailogueList[i].stringValue;
                                                          } else {
                                                            dailogueList4[i]
                                                                    .stateValue =
                                                                newValue!;
                                                            Constants
                                                                    .trueOrFalseStringValueL =
                                                                dailogueList4[i]
                                                                    .stringValue;
                                                            Constants
                                                                    .proceedProduct =
                                                                dailogueList4[i]
                                                                    .stringValue;
                                                          }
                                                        }
                                                        print(
                                                            "hhhhhhhh ${Constants.trueOrFalseStringValueL}");
                                                      });
                                                    }),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                dailogueList4[index]
                                                    .stringValue,
                                                style: TextStyle(
                                                    color: dailogueList3[index]
                                                                .stateValue ==
                                                            true
                                                        ? Constants
                                                            .ftaColorLight
                                                        : Colors.grey
                                                            .withOpacity(0.35),
                                                    fontSize: 18,
                                                    fontFamily: 'YuGothic',
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
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
            Constants.trueOrFalseStringValueJ == "No"
                ? Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            height: 100,
                            //width: 1000,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 50,
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(8)),
                                    color: Constants.ftaColorLight,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Note!',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'YuGothic',
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    //height: 180,
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                    ),
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
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(16)),
                                      //color: Colors.grey
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Closing Message Needed',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: 'YuGothic',
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400),
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
                      ],
                    ),
                  )
                : Container(),
            SizedBox(
              height: 32,
            ),
            Constants.trueOrFalseStringValueL == "Yes"
                ? Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: FadeInLeftBig(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.linearToEaseOut,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StyledText(
                            text: "Your total premium is R 0.00.",
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
                              fontSize: 18.0,
                              color: Colors.black,
                              //  fontFamily: 'YuGothic',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
            Constants.trueOrFalseStringValueL == "No"
                ? Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            height: 100,
                            //width: 1000,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 50,
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16)),
                                    color: Constants.ftaColorLight,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Note!',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'YuGothic',
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    //height: 180,
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                    ),
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
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(16)),
                                      //color: Colors.grey
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Closing Message Needed',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: 'YuGothic',
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400),
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
                      ],
                    ),
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

class ConfirmPrem {
  String productName;
  String sumAssured;
  String premium;
  bool isExpanded;

  ConfirmPrem(
      {required this.productName,
      required this.sumAssured,
      required this.premium,
      required this.isExpanded});
}

class ParentsFuneral {
  int id;
  double sumAssured;
  String dateOfBirth;
  int age;
  double premium;

  ParentsFuneral(
      this.id, this.sumAssured, this.dateOfBirth, this.age, this.premium);
}

class Raiders {
  int id;
  String riderType;
  String memberType;
  String cover;
  double premium;

  Raiders(this.id, this.riderType, this.memberType, this.cover, this.premium);
}
