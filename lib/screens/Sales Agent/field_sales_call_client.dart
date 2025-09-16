import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mi_insights/screens/Sales%20Agent/universal_premium_calculator.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../constants/Constants.dart';
import '../../../../models/map_class.dart';
import '../../customwidgets/CustomCard.dart';
import '../../customwidgets/custom_input.dart';
import '../../customwidgets/custom_script_text.dart';
import '../../models/ScriptConfig.dart';
import '../../models/WaitingPeriods.dart';
import '../../services/sales_service.dart';
import 'confirmpremium.dart';
import 'endcalldialog2.dart';
import 'newmemberdialog.dart';

class FuneralProduct {
  String productName;
  String productDescription;
  bool value;
  String stringValue;

  FuneralProduct(
      {required this.productName,
      required this.productDescription,
      this.stringValue = "No",
      this.value = false});
}

class Description {
  String description;
  bool value;
  String stringValue;

  Description(
      {required this.description, this.stringValue = "No", this.value = false});
}

class FieldSalesCallClientPage extends StatefulWidget {
  const FieldSalesCallClientPage({
    super.key,
  });

  @override
  State<FieldSalesCallClientPage> createState() =>
      _FieldSalesCallClientPageState();
}

class _FieldSalesCallClientPageState extends State<FieldSalesCallClientPage> {
  TextEditingController CADAddressController = TextEditingController();
  TextEditingController CADSuburbController = TextEditingController();
  TextEditingController CADCityController = TextEditingController();
  TextEditingController CADCodeController = TextEditingController();

  final FocusNode addressFocusNode = FocusNode();
  final FocusNode suburbFocusNode = FocusNode();
  final FocusNode cityFocusNode = FocusNode();
  final FocusNode codeFocusNode = FocusNode();

  TextEditingController CADAddressController1 = TextEditingController();
  TextEditingController CADSuburbController1 = TextEditingController();
  TextEditingController CADCityController1 = TextEditingController();
  TextEditingController CADCodeController1 = TextEditingController();

  final FocusNode addressFocusNode1 = FocusNode();
  final FocusNode suburbFocusNode1 = FocusNode();
  final FocusNode cityFocusNode1 = FocusNode();
  final FocusNode codeFocusNode1 = FocusNode();

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
  List<YesOrNoDialogue> dailogueList3 = [
    YesOrNoDialogue(stringValue: "Yes"),
    YesOrNoDialogue(stringValue: "No")
  ];

  String yesOrNoValue = "No"; //trueOrFalseIntValue

  String noValue = "";
  bool checkBoxValue2 = false;
  bool checkBoxValue1 = false;
  bool boolColor1 = false;
  bool boolColor2 = false;
  int isTickMarked = 0;
  int show_border_index1 = 1;
  int card_color_index1 = 0;
  bool isTickMarked1 = false;
  bool isTickMarked2 = false;
  bool isTickMarked3 = false;
  bool checkBoxValue3 = false;
  bool checkBoxValue4 = false;
  bool boolColor3 = false; //selectedProvince
  bool boolColor4 = false;
  String? selectedBank;
  String? selectedAccountType;
  int? selectedDebitDay;
  String? selectedCombinePremium;
  String? selectedID;
  String? selectedProvince;
  String? selectedProvince1;

  List<String> childrenList = [
    "Cover for children ceases on the 1st of the month following their 24th birthday.",
    "Cover for Extended Family younger than 18 at the benefit start date ceases on the 1st of the month following their 21st birthday.",
    "When this cover ceases you can call us to add the life insured again if they are eligible to be covered then.",
    "By law the total amount across all policies that can be paid on the death of a child under the age of 6 is limited to R 20 000. Children between the ages of 6 and below 14 is limited to R 50 000"
  ];
  List<String> viewList = [
    "View Policy Holder",
    "View Addresses",
    "View Member",
    "Confirm Premium"
  ];

  List<String> textList = [
    "Your banking details will be sent for verification overnight.",
    "Should there be any issues with your banking details you will be notified by sms.",
    "If everything is in order you will receive an sms with a link which you can use to check a summary of your policy details.",
    "If you miss a payment Athandwe can collect the missed payment from your bank account at any future date, or collect 2 (two) payments from your account in the following month to make sure your policy stays up to date. If you miss 2 (two) payments this policy will be stopped.",
    "To make sure you don’t get charged unnecessary bank costs on your bank account and to prevent your policy from stopping, you agree that Athandwe can match the date that we collect your monthly payment from your bank account to your salary pay date or any other appropriate date.",
    "If this date falls on a weekend or a public holiday your account will be debited on the 1st working day before or after the weekend or public holiday. Cover only starts once we have received the first premium."
  ];

  List<String> bankInstitutionList = ["FNB", "Capitec", "Absa"];
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
  List<String> accountTypeList = [
    "Chegue Account",
    "Savings Account",
  ];
  List<int> debitDayList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  List<String> combinePremiumList = ["Yes", "No"];

  String isYesOrNo = "";

  List<FuneralProduct> funeralProductList = [
    FuneralProduct(
      productName: "Natural",
      productDescription: "6 months and 6 premiums received.",
    ),
    FuneralProduct(
        productName: "Accidental Death",
        productDescription: "The 1st successful premium received."),
    FuneralProduct(
        productName: "Suicide",
        productDescription: "6 months and 6 premiums received."),
  ];

  List<Description> descriptionList = [
    Description(
        description:
            "Please note that at claims stage, ${Constants.business_name}  will require a certified copy of the death certificate as well as the BI1663 form."),
    Description(
        description:
            "Do you declare that you will suffer financial loss upon the death of the insured/insureds(customer must reply with a clear Yes or No)"),
    Description(
        description:
            "${Constants.business_name} reserves the right to contact any relevant person to validate the relationship you have with the life assured and should the relationship be found to be untruthful, ${Constants.business_name}  will not approve the claim"),
  ];
  AdditionalMember? mainMember;
  List<AdditionalMember> coveredMembers = [];

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> callClientQuestions = {
      "Good Morning": {
        "Question1":
            "Good Morning ${Constants.currentleadAvailable!.leadObject.title} ${Constants.currentleadAvailable!.leadObject.firstName} ${Constants.currentleadAvailable!.leadObject.lastName}, you are speaking to <bold>${Constants.myDisplayname}</bold>, calling you regarding your <green>${Constants.business_name}</green>. policy that you took out with <green>Siphiwe Mlambo ${getFormattedTimeAgo(Constants.currentleadAvailable?.leadObject.timestamp)} (${Constants.formatter.format(DateTime.parse(Constants.currentleadAvailable!.leadObject.timestamp!))})</green>, Is this a good time to talk?",
        "Yes1": {
          "Question2":
              "Thank you ${Constants.currentleadAvailable!.leadObject.title} ${Constants.currentleadAvailable!.leadObject.firstName} ${Constants.currentleadAvailable!.leadObject.lastName}, the reason for my call is to confirm that the information we have of you is accurate and complete. Am I speaking to <green>${Constants.currentleadAvailable!.leadObject.title} ${Constants.currentleadAvailable!.leadObject.firstName} ${Constants.currentleadAvailable!.leadObject.lastName}</green>?",
          "Yes2": {
            "View": {
              "Please confirm":
                  "Please confirm your ID, premium address and people covered in your policy for me:",
              "viewList": viewList,
            },
            "View Banking Details": {
              "Kindly confirm": "Kindly confirm your banking details:",
              "Button": "View Banking Details"
            },
            "Show Waiting Periods": {
              "Thank you":
                  "Thank you ${Constants.currentleadAvailable!.leadObject.title} ${Constants.currentleadAvailable!.leadObject.firstName} ${Constants.currentleadAvailable!.leadObject.lastName} , were you informed of your waiting periods or would you like me to take you through them?",
              "Button": "Show Waiting Periods",
              "Descriptions": descriptionList,
              "Waiting Periods": " WAITING PERIODS",
              "Funeral Product": {
                "Funeral Product": "Funeral Product",
                "Product List": funeralProductList,
              }
            },
            "Children": childrenList,
          },
          "No2": {},
        },
        "No1": {}
      }
    };

    final TextEditingController CADBranchCodeController =
        TextEditingController();
    final TextEditingController CADAccountNumberController =
        TextEditingController();
    final TextEditingController CADAccountHolderController =
        TextEditingController();
    final TextEditingController CADBranchNameController =
        TextEditingController();

    final FocusNode branchNameFocusNode = FocusNode();
    final FocusNode accountHolderFocusNode = FocusNode();
    final FocusNode accountNumberFocusNode = FocusNode();
    final FocusNode branchCodeFocusNode = FocusNode();

    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: 25,
            ),
            StyledText(
              text: callClientQuestions["Good Morning"]["Question1"],
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
            Container(
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
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 1.0,
                                color: dailogueList[index].stateValue == true
                                    ? Constants.ctaColorLight
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
                                          color: Constants.ctaColorLight),
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
                                              Constants.trueOrFalseStringValue =
                                                  dailogueList[i].stringValue;
                                              Constants.isGoodTimeToTalk =
                                                  Constants
                                                      .trueOrFalseStringValue;
                                              if (Constants
                                                      .trueOrFalseStringValue ==
                                                  "No") {
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    // set to false if you want to force a rating
                                                    builder: (context) =>
                                                        StatefulBuilder(
                                                          builder: (context,
                                                                  setState) =>
                                                              Dialog(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16),
                                                            ),
                                                            elevation: 0.0,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            child: Container(
                                                                constraints:
                                                                    BoxConstraints(
                                                                        minHeight:
                                                                            250.0),
                                                                child:
                                                                    EndCallDialog2()),
                                                          ),
                                                        ));
                                                setState(() {});
                                              }
                                            }
                                          }
                                          print(
                                              "hhhhhhhh ${Constants.trueOrFalseStringValue}");
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
                                              ? Constants.ctaColorLight
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
            SizedBox(
              height: 24,
            ),
            Constants.trueOrFalseStringValue == "Yes"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FadeInLeftBig(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.linearToEaseOut,
                        child: Column(
                          children: [
                            StyledText(
                              text: callClientQuestions["Good Morning"]["Yes1"]
                                  ["Question2"],
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
                            Container(
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
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                width: 1.0,
                                                color: dailogueList[index]
                                                            .stateValue ==
                                                        true
                                                    ? Constants.ctaColorLight
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
                                                      value:
                                                          dailogueList1[index]
                                                              .stateValue,
                                                      side: BorderSide(
                                                          width: 1.4,
                                                          color: Constants
                                                              .ctaColorLight),
                                                      activeColor: Constants
                                                          .ctaColorLight,
                                                      checkColor: Colors.white,
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
                                                                      .trueOrFalseStringValue1 =
                                                                  dailogueList1[
                                                                          i]
                                                                      .stringValue;
                                                            }
                                                          }
                                                          print(
                                                              "hjhggfddhhhh ${Constants.trueOrFalseStringValue1}");
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
                                                              .ctaColorLight
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
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Constants.trueOrFalseStringValue1 == "Yes"
                          ? FadeInLeftBig(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.linearToEaseOut,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  StyledText(
                                    text: callClientQuestions["Good Morning"]
                                            ["Yes1"]["Yes2"]["View"]
                                        ["Please confirm"],
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
                                  Container(
                                    child: ListView.builder(
                                      itemCount: viewList.length,
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.all(2.0),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 16),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                                minimumSize: Size(220, 40),
                                                backgroundColor: index ==
                                                        viewList.length - 1
                                                    ? Constants.ftaColorLight
                                                    : Constants.ctaColorLight),
                                            child: Text(
                                              viewList[index],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'YuGothic',
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                //ConfirmPremium
                                                if (index == 3) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ConfirmPremium(),
                                                    ),
                                                  );

                                                  setState(() {});
                                                }
                                                if (index == 1) {
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
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
                                                                        BorderRadius.circular(
                                                                            84),
                                                                  ),
                                                                  elevation:
                                                                      0.0,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  child:
                                                                      Container(
                                                                    // width: MediaQuery.of(context).size.width,

                                                                    //height: MediaQuery.of(context).size.height,
                                                                    constraints: BoxConstraints(
                                                                        maxWidth:
                                                                            880,
                                                                        minHeight:
                                                                            200),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16),
                                                                      boxShadow: const [
                                                                        BoxShadow(
                                                                          color:
                                                                              Colors.black26,
                                                                          blurRadius:
                                                                              10.0,
                                                                          offset: Offset(
                                                                              0.0,
                                                                              10.0),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.vertical,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(height: 24),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 16.0, right: 16),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                    'ADDRESSES',
                                                                                    style: TextStyle(
                                                                                      fontSize: 18,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontFamily: 'YuGothic',
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                  ),
                                                                                  InkWell(
                                                                                    onTap: () => Navigator.of(context).pop(),
                                                                                    child: Icon(
                                                                                      Icons.close,
                                                                                      size: 28,
                                                                                      color: Colors.black54,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 16.0, right: 16),
                                                                              child: Divider(color: Colors.grey.withOpacity(0.55)),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 24,
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(left: 24, right: 24),
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      children: [
                                                                                        Row(
                                                                                          children: [
                                                                                            const SizedBox(width: 8),
                                                                                            Expanded(
                                                                                              child: Text(
                                                                                                "Physical Address",
                                                                                                style: TextStyle(fontSize: 16, fontFamily: 'YuGothic', fontWeight: FontWeight.w600, color: Colors.black, decoration: TextDecoration.underline),
                                                                                              ),
                                                                                            ),
                                                                                            const SizedBox(width: 48),
                                                                                            Expanded(
                                                                                              child: Text(
                                                                                                "Postal Address",
                                                                                                style: TextStyle(fontSize: 16, fontFamily: 'YuGothic', fontWeight: FontWeight.w600, color: Colors.black, decoration: TextDecoration.underline),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 8,
                                                                                        ),
                                                                                        Row(
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          // Align items vertically centered
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            // Address Column
                                                                                            Expanded(
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  const Padding(
                                                                                                    padding: EdgeInsets.only(left: 8.0),
                                                                                                    child: Text(
                                                                                                      'Address',
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        fontFamily: 'YuGothic',
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                        color: Colors.black,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  CustomInputTransparent4(
                                                                                                    controller: CADAddressController,
                                                                                                    hintText: "Address",
                                                                                                    onChanged: (String) {},
                                                                                                    onSubmitted: (String) {},
                                                                                                    focusNode: addressFocusNode,
                                                                                                    textInputAction: TextInputAction.next,
                                                                                                    isPasswordField: false,
                                                                                                    suffix: InkWell(
                                                                                                      onTap: () {},
                                                                                                      child: Container(
                                                                                                        width: 55,
                                                                                                        height: 45,
                                                                                                        // Reduced height for better alignment
                                                                                                        decoration: BoxDecoration(
                                                                                                          color: Constants.ctaColorLight,
                                                                                                          borderRadius: BorderRadius.only(
                                                                                                            topRight: Radius.circular(360),
                                                                                                            bottomRight: Radius.circular(360),
                                                                                                          ),
                                                                                                        ),
                                                                                                        child: Row(
                                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                          children: [
                                                                                                            Icon(
                                                                                                              CupertinoIcons.location_solid,
                                                                                                              size: 14,
                                                                                                              color: Colors.white,
                                                                                                            ),
                                                                                                            const SizedBox(width: 4),
                                                                                                            Text(
                                                                                                              "Map",
                                                                                                              style: GoogleFonts.lato(
                                                                                                                textStyle: const TextStyle(
                                                                                                                  fontSize: 14,
                                                                                                                  fontFamily: 'YuGothic',
                                                                                                                  letterSpacing: 0,
                                                                                                                  fontWeight: FontWeight.w500,
                                                                                                                  color: Colors.white,
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),

                                                                                            const SizedBox(width: 48),
                                                                                            // Add consistent spacing between the columns

                                                                                            // PO Box or P/Bag Column
                                                                                            Expanded(
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(left: 8.0),
                                                                                                    child: const Text(
                                                                                                      'PO Box or P/Bag',
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        fontFamily: 'YuGothic',
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                        color: Colors.black,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  // Consistent spacing
                                                                                                  CustomInputTransparent4(
                                                                                                    controller: CADAddressController1,
                                                                                                    hintText: "PO Box or P/Bag",
                                                                                                    onChanged: (String) {},
                                                                                                    onSubmitted: (String) {},
                                                                                                    focusNode: addressFocusNode1,
                                                                                                    textInputAction: TextInputAction.next,
                                                                                                    isPasswordField: false,
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
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(left: 8.0),
                                                                                                    child: const Text(
                                                                                                      'Suburb',
                                                                                                      style: TextStyle(fontSize: 14, fontFamily: 'YuGothic', fontWeight: FontWeight.w500, color: Colors.black),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Row(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Expanded(
                                                                                                        child: CustomInputTransparent4(
                                                                                                          controller: CADSuburbController,
                                                                                                          hintText: "Suburb",
                                                                                                          onChanged: (String) {},
                                                                                                          onSubmitted: (String) {},
                                                                                                          focusNode: suburbFocusNode,
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
                                                                                            const SizedBox(width: 48),
                                                                                            Expanded(
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                children: [
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(left: 8.0),
                                                                                                    child: const Text(
                                                                                                      'Suburb',
                                                                                                      style: TextStyle(fontSize: 14, fontFamily: 'YuGothic', fontWeight: FontWeight.w500, color: Colors.black),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Row(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Expanded(
                                                                                                        child: CustomInputTransparent4(
                                                                                                          controller: CADSuburbController1,
                                                                                                          hintText: "Suburb",
                                                                                                          onChanged: (String) {},
                                                                                                          onSubmitted: (String) {},
                                                                                                          focusNode: suburbFocusNode1,
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
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                children: [
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(left: 8.0),
                                                                                                    child: const Text(
                                                                                                      'City',
                                                                                                      style: TextStyle(fontSize: 14, fontFamily: 'YuGothic', fontWeight: FontWeight.w500, color: Colors.black),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Row(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Expanded(
                                                                                                        child: CustomInputTransparent4(
                                                                                                          controller: CADCityController,
                                                                                                          hintText: "City",
                                                                                                          onChanged: (String) {},
                                                                                                          onSubmitted: (String) {},
                                                                                                          focusNode: cityFocusNode,
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
                                                                                            const SizedBox(width: 48),
                                                                                            Expanded(
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                children: [
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(left: 8.0),
                                                                                                    child: const Text(
                                                                                                      'City',
                                                                                                      style: TextStyle(fontSize: 14, fontFamily: 'YuGothic', fontWeight: FontWeight.w500, color: Colors.black),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Row(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Expanded(
                                                                                                        child: CustomInputTransparent4(
                                                                                                          controller: CADCityController1,
                                                                                                          hintText: "City",
                                                                                                          onChanged: (String) {},
                                                                                                          onSubmitted: (String) {},
                                                                                                          focusNode: cityFocusNode1,
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
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                children: [
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(left: 8.0),
                                                                                                    child: const Text(
                                                                                                      'Province',
                                                                                                      style: TextStyle(fontSize: 14, fontFamily: 'YuGothic', fontWeight: FontWeight.w500, color: Colors.black),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Row(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Expanded(
                                                                                                          child: Container(
                                                                                                        child: Padding(
                                                                                                          padding: const EdgeInsets.only(left: 2, right: 2, top: 8, bottom: 8),
                                                                                                          child: Container(
                                                                                                            height: 48,
                                                                                                            decoration: BoxDecoration(color: Colors.white, border: Border.all(width: 1.0, color: Colors.grey.withOpacity(0.55)), borderRadius: BorderRadius.circular(360)),
                                                                                                            child: DropdownButtonHideUnderline(
                                                                                                              child: DropdownButton(
                                                                                                                  borderRadius: BorderRadius.circular(8),
                                                                                                                  dropdownColor: Colors.white,
                                                                                                                  style: const TextStyle(
                                                                                                                    color: Colors.black,
                                                                                                                    fontFamily: 'YuGothic',
                                                                                                                    fontWeight: FontWeight.w500,
                                                                                                                    fontSize: 14,
                                                                                                                  ),
                                                                                                                  padding: const EdgeInsets.only(left: 24, right: 24, top: 5, bottom: 5),
                                                                                                                  hint: const Text(
                                                                                                                    'Select Province',
                                                                                                                    style: TextStyle(
                                                                                                                      color: Colors.black,
                                                                                                                      fontFamily: 'YuGothic',
                                                                                                                      fontWeight: FontWeight.w500,
                                                                                                                      fontSize: 14,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  isExpanded: true,
                                                                                                                  value: selectedProvince,
                                                                                                                  items: provinceList
                                                                                                                      .map((String classType) => DropdownMenuItem<String>(
                                                                                                                            value: classType,
                                                                                                                            child: Text(
                                                                                                                              classType,
                                                                                                                              style: TextStyle(fontSize: 14, fontFamily: 'YuGothic', fontWeight: FontWeight.w500, color: Colors.black),
                                                                                                                            ),
                                                                                                                          ))
                                                                                                                      .toList(),
                                                                                                                  onChanged: (newValue) {
                                                                                                                    setState(() {
                                                                                                                      selectedProvince = newValue;
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
                                                                                            const SizedBox(width: 48),
                                                                                            Expanded(
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                children: [
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(left: 8.0),
                                                                                                    child: const Text(
                                                                                                      'Province',
                                                                                                      style: TextStyle(fontSize: 14, fontFamily: 'YuGothic', fontWeight: FontWeight.w500, color: Colors.black),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Row(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Expanded(
                                                                                                          child: Container(
                                                                                                        child: Padding(
                                                                                                          padding: const EdgeInsets.only(left: 2, right: 2, top: 8, bottom: 8),
                                                                                                          child: Container(
                                                                                                            height: 48,
                                                                                                            decoration: BoxDecoration(color: Colors.white, border: Border.all(width: 1.0, color: Colors.grey.withOpacity(0.55)), borderRadius: BorderRadius.circular(360)),
                                                                                                            child: DropdownButtonHideUnderline(
                                                                                                              child: DropdownButton(
                                                                                                                  borderRadius: BorderRadius.circular(8),
                                                                                                                  dropdownColor: Colors.white,
                                                                                                                  style: const TextStyle(
                                                                                                                    color: Colors.black,
                                                                                                                    fontFamily: 'YuGothic',
                                                                                                                    fontWeight: FontWeight.w500,
                                                                                                                    fontSize: 14,
                                                                                                                  ),
                                                                                                                  padding: const EdgeInsets.only(left: 24, right: 24, top: 5, bottom: 5),
                                                                                                                  hint: const Text(
                                                                                                                    'Select Province',
                                                                                                                    style: TextStyle(
                                                                                                                      color: Colors.black,
                                                                                                                      fontFamily: 'YuGothic',
                                                                                                                      fontWeight: FontWeight.w500,
                                                                                                                      fontSize: 14,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  isExpanded: true,
                                                                                                                  value: selectedProvince1,
                                                                                                                  items: provinceList
                                                                                                                      .map((String classType) => DropdownMenuItem<String>(
                                                                                                                            value: classType,
                                                                                                                            child: Text(
                                                                                                                              classType,
                                                                                                                              style: TextStyle(fontSize: 14, fontFamily: 'YuGothic', fontWeight: FontWeight.w500, color: Colors.black),
                                                                                                                            ),
                                                                                                                          ))
                                                                                                                      .toList(),
                                                                                                                  onChanged: (newValue) {
                                                                                                                    setState(() {
                                                                                                                      selectedProvince1 = newValue;
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
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(left: 8.0),
                                                                                                    child: const Text(
                                                                                                      'Postal Code',
                                                                                                      style: TextStyle(fontSize: 14, fontFamily: 'YuGothic', fontWeight: FontWeight.w500, color: Colors.black),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Row(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Expanded(
                                                                                                        child: CustomInputTransparent4(
                                                                                                          controller: CADCodeController,
                                                                                                          hintText: "Code",
                                                                                                          onChanged: (String) {},
                                                                                                          onSubmitted: (String) {},
                                                                                                          focusNode: codeFocusNode,
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
                                                                                            const SizedBox(width: 48),
                                                                                            Expanded(
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                children: [
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(left: 8.0),
                                                                                                    child: const Text(
                                                                                                      'Postal Code',
                                                                                                      style: TextStyle(fontSize: 14, fontFamily: 'YuGothic', fontWeight: FontWeight.w500, color: Colors.black),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Row(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Expanded(
                                                                                                        child: CustomInputTransparent4(
                                                                                                          controller: CADCodeController1,
                                                                                                          hintText: "Code",
                                                                                                          onChanged: (String) {},
                                                                                                          onSubmitted: (String) {},
                                                                                                          focusNode: codeFocusNode1,
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
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 24,
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Expanded(flex: 1, child: Container()),
                                                                                Expanded(
                                                                                    child: TextButton.icon(
                                                                                        style: TextButton.styleFrom(backgroundColor: Colors.grey.withOpacity(0.1)),
                                                                                        onPressed: () {
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

                                                                                                        //height: MediaQuery.of(context).size.height,
                                                                                                        constraints: BoxConstraints(maxWidth: 800, minHeight: 200),
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
                                                                                                        child: SingleChildScrollView(
                                                                                                          scrollDirection: Axis.vertical,
                                                                                                          child: Center(
                                                                                                            child: Column(
                                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                                              children: [
                                                                                                                SizedBox(
                                                                                                                  height: 24,
                                                                                                                ),
                                                                                                                Padding(
                                                                                                                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                                                                                                                  child: Row(
                                                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                    children: [
                                                                                                                      Text(
                                                                                                                        'Confirm',
                                                                                                                        style: TextStyle(
                                                                                                                          fontSize: 18,
                                                                                                                          fontWeight: FontWeight.w500,
                                                                                                                          fontFamily: 'YuGothic',
                                                                                                                          color: Colors.black,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      InkWell(
                                                                                                                        onTap: () => Navigator.of(context).pop(),
                                                                                                                        child: Icon(
                                                                                                                          Icons.close,
                                                                                                                          size: 28,
                                                                                                                          color: Colors.black54,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ],
                                                                                                                  ),
                                                                                                                ),
                                                                                                                Padding(
                                                                                                                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                                                                                                                  child: Divider(color: Colors.grey.withOpacity(0.55)),
                                                                                                                ),
                                                                                                                SizedBox(
                                                                                                                  height: 16,
                                                                                                                ),
                                                                                                                Padding(
                                                                                                                  padding: EdgeInsets.only(left: 24, right: 16),
                                                                                                                  child: Text(
                                                                                                                    "Are you sure you would like to replace the Postal Address with Physical Address?",
                                                                                                                    style: TextStyle(fontSize: 16, fontFamily: 'YuGothic', fontWeight: FontWeight.w500, color: Colors.black),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                SizedBox(
                                                                                                                  height: 32,
                                                                                                                ),
                                                                                                                Padding(
                                                                                                                  padding: EdgeInsets.only(left: 16, right: 16),
                                                                                                                  child: Row(
                                                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                                                    children: [
                                                                                                                      InkWell(
                                                                                                                        child: Container(
                                                                                                                          height: 40,
                                                                                                                          width: 120,
                                                                                                                          padding: EdgeInsets.only(left: 16, right: 16),
                                                                                                                          decoration: BoxDecoration(
                                                                                                                            borderRadius: BorderRadius.circular(360),
                                                                                                                            color: Constants.ctaColorLight,
                                                                                                                          ),
                                                                                                                          child: Row(
                                                                                                                            children: [
                                                                                                                              Icon(
                                                                                                                                CupertinoIcons.xmark,
                                                                                                                                size: 16,
                                                                                                                                color: Colors.white,
                                                                                                                              ),
                                                                                                                              SizedBox(
                                                                                                                                width: 4,
                                                                                                                              ),
                                                                                                                              Text(
                                                                                                                                "No",
                                                                                                                                style: TextStyle(fontSize: 14, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.white),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        onTap: () {
                                                                                                                          Navigator.pop(context);
                                                                                                                          setState(() {});
                                                                                                                        },
                                                                                                                      ),
                                                                                                                      SizedBox(
                                                                                                                        width: 12,
                                                                                                                      ),
                                                                                                                      InkWell(
                                                                                                                        child: Container(
                                                                                                                          height: 40,
                                                                                                                          width: 120,
                                                                                                                          padding: EdgeInsets.only(left: 16, right: 16),
                                                                                                                          decoration: BoxDecoration(
                                                                                                                            borderRadius: BorderRadius.circular(360),
                                                                                                                            color: Constants.ctaColorLight,
                                                                                                                          ),
                                                                                                                          child: Row(
                                                                                                                            children: [
                                                                                                                              Icon(
                                                                                                                                CupertinoIcons.check_mark,
                                                                                                                                size: 16,
                                                                                                                                color: Colors.white,
                                                                                                                              ),
                                                                                                                              SizedBox(
                                                                                                                                width: 4,
                                                                                                                              ),
                                                                                                                              Text(
                                                                                                                                "Yes",
                                                                                                                                style: TextStyle(fontSize: 14, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.white),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        onTap: () {
                                                                                                                          asPhysicalAddress();
                                                                                                                          Navigator.pop(context);
                                                                                                                          /*setState(() {


                                                                                            });*/
                                                                                                                        },
                                                                                                                      ),
                                                                                                                    ],
                                                                                                                  ),
                                                                                                                ),
                                                                                                                SizedBox(
                                                                                                                  height: 24,
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ));
                                                                                          setState(() {});
                                                                                        },
                                                                                        icon: const Icon(
                                                                                          Icons.arrow_back_sharp,
                                                                                          size: 16,
                                                                                          color: Colors.black,
                                                                                        ),
                                                                                        label: Text(
                                                                                          "Same as postal address",
                                                                                          style: TextStyle(fontSize: 14, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.black),
                                                                                        ))),
                                                                                Expanded(flex: 1, child: Container()),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 12,
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Expanded(flex: 1, child: Container()),
                                                                                Expanded(
                                                                                    child: TextButton.icon(
                                                                                  style: TextButton.styleFrom(backgroundColor: Colors.grey.withOpacity(0.1)),
                                                                                  onPressed: () {
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

                                                                                                  //height: MediaQuery.of(context).size.height,
                                                                                                  constraints: BoxConstraints(maxWidth: 800, minHeight: 200),
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
                                                                                                  child: SingleChildScrollView(
                                                                                                    scrollDirection: Axis.vertical,
                                                                                                    child: Center(
                                                                                                      child: Center(
                                                                                                        child: Column(
                                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                                          children: [
                                                                                                            SizedBox(
                                                                                                              height: 24,
                                                                                                            ),
                                                                                                            Padding(
                                                                                                              padding: const EdgeInsets.only(left: 16.0, right: 16),
                                                                                                              child: Row(
                                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                children: [
                                                                                                                  Text(
                                                                                                                    'Confirm',
                                                                                                                    style: TextStyle(
                                                                                                                      fontSize: 18,
                                                                                                                      fontWeight: FontWeight.w500,
                                                                                                                      fontFamily: 'YuGothic',
                                                                                                                      color: Colors.black,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  InkWell(
                                                                                                                    onTap: () => Navigator.of(context).pop(),
                                                                                                                    child: Icon(
                                                                                                                      Icons.close,
                                                                                                                      size: 28,
                                                                                                                      color: Colors.black54,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ],
                                                                                                              ),
                                                                                                            ),
                                                                                                            Padding(
                                                                                                              padding: const EdgeInsets.only(left: 16.0, right: 16),
                                                                                                              child: Divider(color: Colors.grey.withOpacity(0.55)),
                                                                                                            ),
                                                                                                            SizedBox(
                                                                                                              height: 16,
                                                                                                            ),
                                                                                                            Padding(
                                                                                                              padding: EdgeInsets.only(left: 24, right: 16),
                                                                                                              child: Text(
                                                                                                                "Are you sure you would like to replace the Physical Address with Postal Address?",
                                                                                                                style: TextStyle(fontSize: 16, fontFamily: 'YuGothic', fontWeight: FontWeight.w500, color: Colors.black),
                                                                                                              ),
                                                                                                            ),
                                                                                                            SizedBox(
                                                                                                              height: 32,
                                                                                                            ),
                                                                                                            Padding(
                                                                                                              padding: EdgeInsets.only(left: 16, right: 16),
                                                                                                              child: Row(
                                                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                                                children: [
                                                                                                                  InkWell(
                                                                                                                    child: Container(
                                                                                                                      height: 40,
                                                                                                                      width: 120,
                                                                                                                      padding: EdgeInsets.only(left: 16, right: 16),
                                                                                                                      decoration: BoxDecoration(
                                                                                                                        borderRadius: BorderRadius.circular(360),
                                                                                                                        color: Constants.ctaColorLight,
                                                                                                                      ),
                                                                                                                      child: Row(
                                                                                                                        children: [
                                                                                                                          Icon(
                                                                                                                            CupertinoIcons.xmark,
                                                                                                                            size: 16,
                                                                                                                            color: Colors.white,
                                                                                                                          ),
                                                                                                                          SizedBox(
                                                                                                                            width: 4,
                                                                                                                          ),
                                                                                                                          Text(
                                                                                                                            "No",
                                                                                                                            style: TextStyle(fontSize: 14, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.white),
                                                                                                                          ),
                                                                                                                        ],
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    onTap: () {
                                                                                                                      Navigator.pop(context);
                                                                                                                      setState(() {});
                                                                                                                    },
                                                                                                                  ),
                                                                                                                  SizedBox(
                                                                                                                    width: 12,
                                                                                                                  ),
                                                                                                                  InkWell(
                                                                                                                    child: Container(
                                                                                                                      height: 40,
                                                                                                                      width: 120,
                                                                                                                      padding: EdgeInsets.only(left: 16, right: 16),
                                                                                                                      decoration: BoxDecoration(
                                                                                                                        borderRadius: BorderRadius.circular(360),
                                                                                                                        color: Constants.ctaColorLight,
                                                                                                                      ),
                                                                                                                      child: Row(
                                                                                                                        children: [
                                                                                                                          Icon(
                                                                                                                            CupertinoIcons.check_mark,
                                                                                                                            size: 16,
                                                                                                                            color: Colors.white,
                                                                                                                          ),
                                                                                                                          SizedBox(
                                                                                                                            width: 4,
                                                                                                                          ),
                                                                                                                          Text(
                                                                                                                            "Yes",
                                                                                                                            style: TextStyle(fontSize: 14, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.white),
                                                                                                                          ),
                                                                                                                        ],
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    onTap: () {
                                                                                                                      asPostalAddress();
                                                                                                                      Navigator.pop(context);
                                                                                                                      /*setState(() {


                                                                                                                                                                                                  });*/
                                                                                                                    },
                                                                                                                  ),
                                                                                                                ],
                                                                                                              ),
                                                                                                            ),
                                                                                                            SizedBox(
                                                                                                              height: 24,
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ));
                                                                                    setState(() {});
                                                                                  },
                                                                                  label: Text(
                                                                                    "Same as physical address",
                                                                                    style: TextStyle(fontSize: 14, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.black),
                                                                                  ),
                                                                                  icon: const Icon(
                                                                                    Icons.arrow_forward_sharp,
                                                                                    size: 16,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                )),
                                                                                Expanded(flex: 1, child: Container()),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 24,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 16.0, right: 16),
                                                                              child: Divider(color: Colors.grey.withOpacity(0.55)),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 24,
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(left: 24, right: 24),
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  InkWell(
                                                                                    child: Container(
                                                                                      height: 40,
                                                                                      width: 120,
                                                                                      padding: EdgeInsets.only(left: 16, right: 16),
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(360),
                                                                                        color: Constants.ctaColorLight,
                                                                                      ),
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          "Cancel",
                                                                                          style: TextStyle(fontSize: 14, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.white),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    onTap: () {
                                                                                      Navigator.pop(context);
                                                                                      setState(() {});
                                                                                    },
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 12,
                                                                                  ),
                                                                                  InkWell(
                                                                                    child: Container(
                                                                                      height: 40,
                                                                                      width: 120,
                                                                                      padding: EdgeInsets.only(left: 16, right: 16),
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(360),
                                                                                        color: Constants.ctaColorLight,
                                                                                      ),
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          "Done",
                                                                                          style: TextStyle(fontSize: 14, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.white),
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
                                                                            SizedBox(
                                                                              height: 24,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ));
                                                  setState(() {});
                                                }
                                                if (index == 2) {
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
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
                                                                        BorderRadius.circular(
                                                                            64),
                                                                  ),
                                                                  elevation:
                                                                      0.0,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  child:
                                                                      Container(
                                                                    // width: MediaQuery.of(context).size.width,

                                                                    //height: MediaQuery.of(context).size.height,
                                                                    constraints: BoxConstraints(
                                                                        maxWidth:
                                                                            880,
                                                                        minHeight:
                                                                            200),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16),
                                                                      boxShadow: const [
                                                                        BoxShadow(
                                                                          color:
                                                                              Colors.black26,
                                                                          blurRadius:
                                                                              10.0,
                                                                          offset: Offset(
                                                                              0.0,
                                                                              10.0),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.vertical,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(height: 24),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 16.0, right: 16),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                    'COVERED MEMBERS',
                                                                                    style: TextStyle(
                                                                                      fontSize: 18,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontFamily: 'YuGothic',
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                  ),
                                                                                  InkWell(
                                                                                    onTap: () => Navigator.of(context).pop(),
                                                                                    child: Icon(
                                                                                      Icons.close,
                                                                                      size: 28,
                                                                                      color: Colors.black54,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 16.0, right: 16),
                                                                              child: Divider(color: Colors.grey.withOpacity(0.55)),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 24,
                                                                            ),
                                                                            if (coveredMembers.isNotEmpty)
                                                                              GridView.builder(
                                                                                shrinkWrap: true,
                                                                                itemCount: coveredMembers.length,
                                                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                                    crossAxisCount: 2,
                                                                                    //childAspectRatio: 16/1
                                                                                    mainAxisExtent: 150,
                                                                                    crossAxisSpacing: 15,
                                                                                    mainAxisSpacing: 15),
                                                                                itemBuilder: (context, index) {
                                                                                  return AdvancedMemberCard(
                                                                                    member: coveredMembers[index],
                                                                                  );
                                                                                },
                                                                              ),
                                                                            SizedBox(
                                                                              height: 24,
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(left: 24, right: 24),
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  InkWell(
                                                                                    child: Container(
                                                                                      height: 40,
                                                                                      width: 120,
                                                                                      padding: EdgeInsets.only(left: 16, right: 16),
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(360),
                                                                                        color: Constants.ctaColorLight,
                                                                                      ),
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          "Cancel",
                                                                                          style: TextStyle(fontSize: 14, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.white),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    onTap: () {
                                                                                      Navigator.pop(context);
                                                                                      setState(() {});
                                                                                    },
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 22,
                                                                                  ),
                                                                                  InkWell(
                                                                                    child: Container(
                                                                                      height: 40,
                                                                                      width: 120,
                                                                                      padding: EdgeInsets.only(left: 16, right: 16),
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(360),
                                                                                        color: Constants.ctaColorLight,
                                                                                      ),
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          "Done",
                                                                                          style: TextStyle(fontSize: 14, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.white),
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
                                                                            SizedBox(
                                                                              height: 24,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ));
                                                  setState(() {});
                                                }
                                                if (index == 0) {
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
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
                                                                        BorderRadius.circular(
                                                                            64),
                                                                  ),
                                                                  elevation:
                                                                      0.0,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  child:
                                                                      Container(
                                                                    height: 350,
                                                                    // width: MediaQuery.of(context).size.width,

                                                                    //height: MediaQuery.of(context).size.height,
                                                                    constraints:
                                                                        BoxConstraints(
                                                                      maxWidth:
                                                                          880,
                                                                      minHeight:
                                                                          200,
                                                                      maxHeight:
                                                                          700,
                                                                    ),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16),
                                                                      boxShadow: const [
                                                                        BoxShadow(
                                                                          color:
                                                                              Colors.black26,
                                                                          blurRadius:
                                                                              10.0,
                                                                          offset: Offset(
                                                                              0.0,
                                                                              10.0),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.vertical,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          physics:
                                                                              NeverScrollableScrollPhysics(),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              SizedBox(height: 24),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 16.0, right: 16),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Text(
                                                                                      'POLICY HOLDER',
                                                                                      style: TextStyle(
                                                                                        fontSize: 18,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontFamily: 'YuGothic',
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                    InkWell(
                                                                                      onTap: () => Navigator.of(context).pop(),
                                                                                      child: Icon(
                                                                                        Icons.close,
                                                                                        size: 28,
                                                                                        color: Colors.black54,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 16.0, right: 16),
                                                                                child: Divider(color: Colors.grey.withOpacity(0.55)),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 24,
                                                                              ),
                                                                              if (mainMember != null)
                                                                                SizedBox(
                                                                                  height: 200,
                                                                                  width: 600,
                                                                                  child: AdvancedMemberCard(member: mainMember!),
                                                                                ),
                                                                              if (mainMember == null)
                                                                                Center(child: Text("No main member available")),
                                                                              SizedBox(
                                                                                height: 24,
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 16.0, right: 16),
                                                                                child: Divider(color: Colors.grey.withOpacity(0.55)),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 24,
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(left: 16, right: 16),
                                                                                child: Row(
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: 22,
                                                                                    ),
                                                                                    InkWell(
                                                                                      child: Container(
                                                                                        height: 40,
                                                                                        width: 120,
                                                                                        padding: EdgeInsets.only(left: 16, right: 16),
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(360),
                                                                                          color: Constants.ctaColorLight,
                                                                                        ),
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            "Done",
                                                                                            style: TextStyle(fontSize: 14, fontFamily: 'YuGothic', letterSpacing: 0, fontWeight: FontWeight.w400, color: Colors.white),
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
                                                                              ),
                                                                              SizedBox(
                                                                                height: 24,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ));
                                                  setState(() {});
                                                }
                                              });
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  StyledText(
                                    text: callClientQuestions["Good Morning"]
                                                ["Yes1"]["Yes2"]
                                            ["View Banking Details"]
                                        ["Kindly confirm"],
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
                                    text: callClientQuestions["Good Morning"]
                                            ["Yes1"]["Yes2"]
                                        ["View Banking Details"]["Button"],
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
                                  Text(
                                    callClientQuestions["Good Morning"]["Yes1"]
                                            ["Yes2"]["Show Waiting Periods"]
                                        ["Thank you"],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'YuGothic',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          minimumSize: Size(220, 50),
                                          backgroundColor:
                                              Constants.ctaColorLight),
                                      child: Text(
                                        callClientQuestions["Good Morning"]
                                                ["Yes1"]["Yes2"]
                                            ["Show Waiting Periods"]["Button"],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'YuGothic',
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BranchWaitingPeriodsScreen(),
                                            ),
                                          );
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                ],
                              ),
                            )
                          : Constants.trueOrFalseStringValue1 == "No"
                              ? Text(
                                  "!!!!!!!!",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'YuGothic',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                )
                              : Container(),
                      SizedBox(
                        height: 24,
                      ),
                    ],
                  )
                : Constants.trueOrFalseStringValue == "No"
                    ? Container()
                    : Container(),
          ],
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();
    obtainMainInsureed();
    ontainCoveredMembers();
    if (Constants.currentleadAvailable!.addresses != null) {
      CADCodeController.text =
          Constants.currentleadAvailable!.addresses!.physaddressCode;
      CADCityController.text =
          Constants.currentleadAvailable!.addresses!.physaddressLine3;
      CADSuburbController.text =
          Constants.currentleadAvailable!.addresses!.physaddressLine2;
      CADAddressController.text =
          Constants.currentleadAvailable!.addresses!.physaddressLine1;
      //selectedProvince = widget.addresses.postaddressProvince;

      CADCodeController1.text =
          Constants.currentleadAvailable!.addresses!.postaddressCode;
      CADCityController1.text =
          Constants.currentleadAvailable!.addresses!.postaddressLine3;
      CADSuburbController1.text =
          Constants.currentleadAvailable!.addresses!.postaddressLine2;
      CADAddressController1.text =
          Constants.currentleadAvailable!.addresses!.postaddressLine1;
    }
    //selectedProvince = widget.addresses.postaddressProvince;
  }

  void obtainMainInsureed() {
    if (Constants.currentleadAvailable != null) {
      mainMember = Constants.currentleadAvailable!.additionalMembers
          .firstWhere((element) => element.relationship == "self");
      if (mainMember != null) {
        setState(() {});
      }
    }
  }

  void ontainCoveredMembers() {
    coveredMembers = Constants.currentleadAvailable!.additionalMembers
        .where((element) => (element.relationship != "self"
            // ||int.parse(element.percentage.toString()) > 0)
            ))
        .toList();
  }

  asPhysicalAddress() {
    CADCodeController1 = CADCodeController;
    CADCityController1 = CADCityController;
    CADSuburbController1 = CADSuburbController;
    CADAddressController1 = CADAddressController;

    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {});
    });
  }

  asPostalAddress() {
    CADCodeController = CADCodeController1;
    CADCityController = CADCityController1;
    CADSuburbController = CADSuburbController1;
    CADAddressController = CADAddressController1;

    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {});
    });
  }

  /// Returns a human-readable time ago format or "N/A" if invalid.
  String getFormattedTimeAgo(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) {
      return "";
    }

    try {
      DateTime parsedTime = DateTime.parse(timestamp);
      return timeago.format(parsedTime);
    } catch (e) {
      print("Error parsing timestamp: $e");
      return "Invalid date";
    }
  }
}

class AdvancedMemberCard extends StatefulWidget {
  final AdditionalMember member;

  final VoidCallback? onDoubleTap;

  const AdvancedMemberCard({
    Key? key,
    required this.member,
    this.onDoubleTap,
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
        child: AnimatedScale(
          scale: isHovered ? 1.01 : 1.0, // Smooth scaling on hover
          duration: const Duration(milliseconds: 200),
          child: Container(
            margin:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border(
                top: BorderSide(
                    color: Constants.ctaColorLight,
                    width: 2.0), // Thick top border
                left: BorderSide(
                    color: Constants.ctaColorLight,
                    width: 1.0), // Thin left border
                right: BorderSide(
                    color: Constants.ctaColorLight,
                    width: 1.0), // Thin right border
                bottom: BorderSide(
                    color: Constants.ctaColorLight,
                    width: 1.0), // Thin bottom border
              ),
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
                  radius: 30,
                  backgroundColor: Constants.ctaColorLight,
                  child: Icon(
                    widget.member.gender.toLowerCase() == "female"
                        ? Icons.female
                        : Icons.male,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16.0),

                // Member Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date of Birth
                      Text(
                        'Date of Birth: ${intl.DateFormat('EEE, dd MMM yyyy').format(DateTime.parse(widget.member.dob))}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'YuGothic',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8.0),

                      // Member Name
                      Text(
                        widget.member!.title +
                            " " +
                            widget.member!.name +
                            " " +
                            widget.member!.surname,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'YuGothic',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8.0),

                      // Relationship
                      Row(
                        children: [
                          Icon(
                            Icons.people_alt,
                            color: Colors.black,
                            size: 16,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            'Relationship: ${widget.member.relationship}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'YuGothic',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Edit Button
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        barrierDismissible:
                            false, // set to false if you want to force a rating
                        builder: (context) => StatefulBuilder(
                              builder: (context, setState) => Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(64),
                                ),
                                elevation: 0.0,
                                backgroundColor: Colors.transparent,
                                child: Container(
                                  // width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  constraints: BoxConstraints(
                                    maxWidth: 1200,
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
                                  child: NewMemberDialog(
                                    isEditMode: true,
                                    relationship: widget.member.relationship,
                                    title: widget.member.title,
                                    name: widget.member.name,
                                    surname: widget.member.surname,
                                    dob: widget.member.dob,
                                    gender: widget.member.gender,
                                    phone: widget.member.contact,
                                    idNumber: widget.member.id,
                                    sourceOfIncome:
                                        widget.member.sourceOfIncome,
                                    sourceOfWealth:
                                        widget.member.sourceOfWealth,
                                    autoNumber: widget.member.autoNumber,
                                    current_member_index: current_member_index,
                                    canAddMember: false,
                                  ),
                                ),
                              ),
                            ));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Constants.ctaColorLight.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                          color: Constants.ctaColorLight, width: 1.5),
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Constants.ctaColorLight,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WaitingPeriodScreen extends StatefulWidget {
  const WaitingPeriodScreen({super.key});

  @override
  State<WaitingPeriodScreen> createState() => _WaitingPeriodScreenState();
}

class _WaitingPeriodScreenState extends State<WaitingPeriodScreen> {
  // Optional: store local state or rely on Constants.acceptedDeclarationsAndWaitingPeriods
  // For simplicity, we'll use Constants here.

  Future<void> _showDeclarationsDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return Dialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          // The ConstrainedBox ensures the dialog does not exceed 400 in width
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // shrink-wrap vertically
                children: [
                  const SizedBox(height: 16),
                  // Icon + Title
                  Center(
                    child: Column(
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: Colors.orange, size: 40),
                        const SizedBox(height: 10),
                        const Text(
                          'DECLARATION BY SALES AGENT',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'YuGothic',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Paragraph 1
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "I confirm that I have read and explained all the declarations and "
                      "exclusions to the client during our phone call. This includes verifying "
                      "the client’s understanding of coverage limitations, disclaimers, and "
                      "relevant policy details. I have not withheld any crucial information "
                      "or misrepresented any policy terms.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Paragraph 2
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "I have also thoroughly explained the waiting periods, ensuring the client "
                      "is aware of how they apply to the policy coverage. The client has "
                      "acknowledged their understanding of these waiting periods.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Confirmation text
                  const Text(
                    "Do you accept the declarations and waiting periods?",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),

                  // Actions Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, "I don't"),
                        child: Text(
                          "I don't",
                          style: TextStyle(color: Constants.ftaColorLight),
                        ),
                      ),
                      Container(
                        width: 160,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Constants.ftaColorLight,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            // Text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context, "I agree"),
                          child: Text(
                            "I agree",
                            style: TextStyle(color: Colors.white),
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
        );
      },
    );

    // If user chooses "I agree", set the box to checked; otherwise, uncheck it.
    if (result == "I agree") {
      setState(() {
        Constants.accepteddeclationsAndWaitiongPeriods = true;
      });
    } else {
      setState(() {
        Constants.accepteddeclationsAndWaitiongPeriods = false;
      });
    }
  }

  // Example: remove the IntrinsicHeight and just use a normal Row
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Row with two columns, each minHeight=400
          Row(
            crossAxisAlignment: CrossAxisAlignment.start, // or stretch
            children: [
              // Right Column (Waiting Periods)
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 400),
                  child: CustomCard(
                    elevation: 5,
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.15),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  topLeft: Radius.circular(12),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Center(
                                  child: Text(
                                    "Waiting Periods",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'YuGothic',
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: BranchWaitingPeriodsScreen(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Centered text
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: StyledText(
                      text:
                          "I confirm that I have read all the declarations and waiting periods to the client.",
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Checkbox option
          Center(
            child: Container(
              height: 60,
              width: 180,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  width: 1.0,
                  color: Constants.accepteddeclationsAndWaitiongPeriods
                      ? Constants.ftaColorLight
                      : Colors.grey.withOpacity(0.35),
                ),
                color: Colors.transparent,
              ),
              child: Row(
                children: [
                  Transform.scale(
                    scaleX: 1.3,
                    scaleY: 1.3,
                    child: Checkbox(
                      value: Constants.accepteddeclationsAndWaitiongPeriods,
                      side: BorderSide(
                        width: 1.4,
                        color: Constants.ftaColorLight,
                      ),
                      activeColor: Constants.ctaColorLight,
                      checkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(360),
                      ),
                      onChanged: (bool? newValue) async {
                        if (newValue == true) {
                          await _showDeclarationsDialog();
                        } else {
                          setState(() {
                            Constants.accepteddeclationsAndWaitiongPeriods =
                                false;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "I accept",
                    style: TextStyle(
                      color: Constants.accepteddeclationsAndWaitiongPeriods
                          ? Constants.ftaColorLight
                          : Colors.grey.withOpacity(0.35),
                      fontSize: 18,
                      fontFamily: 'YuGothic',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class BranchWaitingPeriodsScreen extends StatefulWidget {
  @override
  _BranchWaitingPeriodsScreenState createState() =>
      _BranchWaitingPeriodsScreenState();
}

class _BranchWaitingPeriodsScreenState
    extends State<BranchWaitingPeriodsScreen> {
  late Future<List<ProductWaitingPeriod>> futureProducts;

  @override
  void initState() {
    super.initState();
    SalesService salesService = SalesService();
    futureProducts = salesService.fetchGroupedProducts();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text("Waiting Periods"),
            surfaceTintColor: Colors.white,
            shadowColor: Colors.black.withOpacity(0.65),

            //Back Button
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          backgroundColor: Colors.white,
          body: FutureBuilder<List<ProductWaitingPeriod>>(
            future: futureProducts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No products found.'));
              }

              SalesService salesService = SalesService();
              salesService.fetchScriptConfig().then((val) {
                Constants.currentConfigAvailable = val;
                setState(() {});
              }).catchError((error) {
                print('Error loading script config: $error');
                // Continue without script config - don't block the user
              });

              final products = snapshot.data!;

              // Remove duplicates based on type field
              final seen = <String>{};
              final uniqueProducts =
                  products.where((product) => seen.add(product.type)).toList();

              List<Paragraph>? declarations = Constants
                  .currentConfigAvailable?.paragraphs["Waiting Periods"];
              if (declarations == null) {
                declarations = [];
              }

              return Column(
                children: [
                  // Only show the CustomScriptText if declarations is not empty
                  if (declarations.isNotEmpty)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 0.0, bottom: 0),
                            child: CustomScriptText(
                              text: declarations.first.paragraph,
                            ),
                          ),
                        ),
                      ],
                    ),

                  Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: uniqueProducts.length, // Use unique products
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final product =
                            uniqueProducts[index]; // Use unique products
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: CustomCard(
                            elevation: 4,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.productName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                      'Product Family: ${product.productFamily}'),
                                  SizedBox(height: 2),
                                  Text(
                                      'Waiting Period: ${product.waitingPeriod} months'),
                                  SizedBox(height: 2),
                                  Text('Member Type(s): ${product.type}'),
                                  SizedBox(height: 2),
                                  Text('Death Type: ${product.deathType}'),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }
}
