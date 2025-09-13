import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:http/http.dart" as http;
import 'package:intl/intl.dart' as intl;
import 'package:motion_toast/motion_toast.dart';

import '../../../../constants/Constants.dart';

import '../../customwidgets/custom_input.dart';
import '../../models/map_class.dart';

class FieldSalesCommunicationPreference extends StatefulWidget {
  const FieldSalesCommunicationPreference({
    super.key,
  });

  @override
  State<FieldSalesCommunicationPreference> createState() =>
      _FieldSalesCommunicationPreferenceState();
}

class _FieldSalesCommunicationPreferenceState
    extends State<FieldSalesCommunicationPreference> {
  String? _selectedComm;
  String _selectedPref = "Cellphone";

  final intl.DateFormat formatter = intl.DateFormat('yyyy-MM-dd');

  List<String> commList = ["EmailPost", "Post", "Email"];

  List<String> preferenceList = [
    "Cellphone",
    "Telephone",
    "SMS",
    "Post",
    "Email"
  ];

  late TextEditingController CADPreferenceController = TextEditingController();

  final TextEditingController CADEmailController = TextEditingController();
  final TextEditingController CADCommuTelephoneController =
      TextEditingController();
  final TextEditingController CADPostController = TextEditingController();
  final TextEditingController CADTelephoneController = TextEditingController();
  final TextEditingController CADPhoneController = TextEditingController();
  final TextEditingController CADEasyPayController = TextEditingController();

  final FocusNode easyPayFocusNode = FocusNode();
  final FocusNode preferenceFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode telephoneFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 4, top: 16),
                child: const Text(
                  'Preference',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'YuGothic',
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 2, right: 2, top: 8, bottom: 8),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                                width: 1.0,
                                color: Colors.grey.withOpacity(0.55)),
                            borderRadius: BorderRadius.circular(360)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              borderRadius: BorderRadius.circular(8),
                              dropdownColor: Colors.white,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'YuGothic',
                                  color: Colors.black),
                              padding: const EdgeInsets.only(
                                  left: 24, right: 24, top: 5, bottom: 5),
                              hint: const Text(
                                'Select Communication Preference',
                                style: TextStyle(
                                    fontFamily: 'YuGothic',
                                    color: Colors.black),
                              ),
                              isExpanded: true,
                              value: _selectedPref,
                              items: preferenceList
                                  .map((String classType) =>
                                      DropdownMenuItem<String>(
                                        value: classType,
                                        child: Text(
                                          classType,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'YuGothic',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedPref = newValue!.toString();
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 4, top: 16),
                child: const Text(
                  'Cellphone Number',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'YuGothic',
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomInputTransparent4(
                      controller: CADPhoneController,
                      integersOnly: true,
                      hintText: "Cellphone Number",
                      onChanged: (value) {
                        Constants.currentleadAvailable!.leadObject
                            .altCellNumber = value;
                        print("dgffdfd $value");
                        print(
                            "hhgghh ${Constants.currentleadAvailable!.leadObject.altCellNumber}");
                      },
                      onSubmitted: (String) {
                        Constants.cellNumber = CADPhoneController.text;
                      },
                      focusNode: phoneFocusNode,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 4, top: 24),
                child: const Text(
                  '(Alt) Home Telephone',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'YuGothic',
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomInputTransparent4(
                      controller: CADTelephoneController,
                      hintText: "(Alt) Home Telephone",
                      onChanged: (String) {
                        Constants.altCellNumber = CADTelephoneController.text;
                      },
                      onSubmitted: (String) {
                        Constants.altCellNumber = CADTelephoneController.text;
                      },
                      focusNode: telephoneFocusNode,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 4, top: 16),
                child: const Text(
                  'Email',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'YuGothic',
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomInputTransparent4(
                      controller: CADEmailController,
                      hintText: "Email",
                      onChanged: (val) {
                        if (Constants.currentleadAvailable != null)
                          Constants.currentleadAvailable!.leadObject
                              .clientEmail = val;
                      },
                      onSubmitted: (String) {
                        Constants.clientEmail = CADEmailController.text;
                      },
                      focusNode: emailFocusNode,
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
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4, top: 24),
            child: const Text(
              'Preferred Policy Schedule Communication Method',
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'YuGothic',
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ),
          Container(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 2, right: 2, top: 8, bottom: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                        width: 1.0, color: Colors.grey.withOpacity(0.55)),
                    borderRadius: BorderRadius.circular(360)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                      borderRadius: BorderRadius.circular(8),
                      dropdownColor: Colors.white,
                      style: const TextStyle(
                          fontFamily: 'YuGothic', color: Colors.black),
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 5, bottom: 5),
                      hint: const Text(
                        'Select',
                        style: TextStyle(
                            fontFamily: 'YuGothic', color: Colors.black),
                      ),
                      isExpanded: true,
                      value: _selectedComm,
                      items: commList
                          .map((String classType) => DropdownMenuItem<String>(
                                value: classType,
                                child: Text(
                                  classType,
                                  style: TextStyle(
                                      fontFamily: 'YuGothic',
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ))
                          .toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedComm = newValue!.toString();
                        });
                      }),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                child: Container(
                  height: 40,
                  width: 120,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(360),
                      color: Constants.ftaColorLight),
                  child: Center(
                    child: Text(
                      "Submit",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 13,
                            fontFamily: 'YuGothic',
                            letterSpacing: 0,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  print("sjkkwj ${Constants.currentleadAvailable}");

                  //Constants.clientEmail = CADEmailController.text;
                  if (Constants.currentleadAvailable != null) {
                    if (CADPhoneController.text.isEmpty) {
                      MotionToast.error(
                        //   title: Text("Error"),
                        description: Center(
                          child: Text(
                            "Please enter a phone number.",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'YuGothic',
                              color: Colors.white,
                            ),
                          ),
                        ),
                        layoutOrientation: TextDirection.ltr,
                        animationType: AnimationType.fromTop,
                        width: 350,
                        height: 55,
                        animationDuration: const Duration(milliseconds: 2500),
                      ).show(context);
                    } else if (CADTelephoneController.text.isEmpty) {
                      MotionToast.error(
                        //   title: Text("Error"),
                        description: Center(
                          child: Text(
                            "Please enter an alternative phone number.",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'YuGothic',
                              color: Colors.white,
                            ),
                          ),
                        ),
                        layoutOrientation: TextDirection.ltr,
                        animationType: AnimationType.fromTop,
                        width: 350,
                        height: 55,
                        animationDuration: const Duration(milliseconds: 2500),
                      ).show(context);
                    } else if (CADEmailController.text.isEmpty) {
                      MotionToast.error(
                        //   title: Text("Error"),
                        description: Center(
                          child: Text(
                            "Please enter an email.",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'YuGothic',
                              color: Colors.white,
                            ),
                          ),
                        ),
                        layoutOrientation: TextDirection.ltr,
                        animationType: AnimationType.fromTop,
                        width: 350,
                        height: 55,
                        animationDuration: const Duration(milliseconds: 2500),
                      ).show(context);
                    } else {
                      Constants.currentleadAvailable!.leadObject
                          .communicationPreference = _selectedPref;
                      Constants.currentleadAvailable!.leadObject.cellNumber =
                          CADPhoneController.text;
                      Constants.currentleadAvailable!.leadObject.altCellNumber =
                          CADTelephoneController.text;
                      Constants.currentleadAvailable!.leadObject.clientEmail =
                          CADEmailController.text;
                      updateCommunicationPreferencesLeadObjectDetails(
                          Constants.currentleadAvailable!.leadObject);
                    }
                    updateCommunicationPreferencesLeadObjectDetails(
                        Constants.currentleadAvailable!.leadObject);
                    setState(() {});
                  }
                },
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    getCommunicationValuesFromLead();
    //getPrefComm();

    super.initState();
  }

  getCommunicationValuesFromLead() {
    if (Constants.currentleadAvailable != null) {
      CADPhoneController.text =
          Constants.currentleadAvailable!.leadObject.cellNumber;
      CADEmailController.text =
          Constants.currentleadAvailable!.leadObject.clientEmail;
      CADTelephoneController.text =
          Constants.currentleadAvailable!.leadObject.altCellNumber;
      if (Constants
          .currentleadAvailable!.leadObject.communicationPreference.isEmpty) {
        _selectedPref = "Cellphone";
      } else {
        _selectedPref =
            Constants.currentleadAvailable!.leadObject.communicationPreference;
      }
      setState(() {});
    }
  }

  void updateCommunicationPreferencesLeadObjectDetails(
      LeadObject leadObject) async {
    const String endpoint = "fieldV6/updateCommunicationDetails/";
    final String url = "${Constants.insightsBackendBaseUrl}" + endpoint;
    print("sjkkwj0 $url ${leadObject.toJson()}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(leadObject.toJson()),
      );

      // Check response status and content
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody.toString() == "No changes made.") {
          print("sjkkwj1 ${"No changes made."}");
          MotionToast.warning(
            dismissable: true,
            height: 55,
            width: 280,
            description: Text(
              responseBody.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ).show(context);
        } else if (responseBody.toString() == "Success.") {
          print("sjkkwj1b ${"Success."}");
          MotionToast.success(
            dismissable: true,
            height: 55,
            width: 280,
            description: Text(
              responseBody.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ).show(context);
        }
      } else {
        // Handle non-200 responses
      }
    } catch (e) {
      // Handle any exceptions
      print("Error updating lead details: $e");
      if (e.toString() == "No changes made.") {
        MotionToast.warning(
          dismissable: true,
          height: 55,
          width: 280,
          description: Text(
            "No changes made.",
            style: TextStyle(color: Colors.white),
          ),
        ).show(context);
      }
    }
  }

  getPrefComm() {
    CADPhoneController.text =
        Constants.currentleadAvailable!.leadObject.cellNumber;
    CADEmailController.text =
        Constants.currentleadAvailable!.leadObject.clientEmail;
    CADPreferenceController.text =
        Constants.currentleadAvailable!.leadObject.cellNumber;
    CADTelephoneController.text =
        Constants.currentleadAvailable!.leadObject.altCellNumber;

    if (_selectedPref == "Cellphone" && _selectedPref == "SMS") {
      CADPreferenceController.text =
          Constants.currentleadAvailable!.leadObject.cellNumber;
    } else if (_selectedPref == "Telephone") {
      CADPreferenceController.text =
          Constants.currentleadAvailable!.leadObject.altCellNumber;
    } else if (_selectedPref == "Email") {
      CADPreferenceController.text =
          Constants.currentleadAvailable!.leadObject.clientEmail;
    } else {
      if (Constants
          .currentleadAvailable!.leadObject.communicationPreference.isEmpty) {
        _selectedPref = "Cellphone";
      } else {
        _selectedPref =
            Constants.currentleadAvailable!.leadObject.communicationPreference;
        //CADPreferenceController.text  = Constants.currentleadAvailable!.clientEmail;
      }
    }
    setState(() {});
    print("dghdgdgrgyer ${CADPreferenceController.text}");
  }
}
