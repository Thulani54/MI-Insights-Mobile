import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:http/http.dart" as http;
import 'package:iconsax/iconsax.dart';

import 'package:motion_toast/motion_toast.dart';
import 'package:path/path.dart' as pt;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../constants/Constants.dart';

import '../../customwidgets/custom_input.dart';
import '../../models/map_class.dart';
import '../../services/MyNoyifier.dart';

final myPdfValue1 = ValueNotifier<int>(0);
final myNewMemberValue1 = ValueNotifier<int>(0);
MyNotifier? pdfViewNotifier1;
double _brightness = 0.0; // 0 = no brightness change
double _contrast = 1.0;
UniqueKey uq1_key1 = UniqueKey();

class NewMemberDialog extends StatefulWidget {
  bool isEditMode;
  String relationship;
  String title;
  String name;
  String surname;
  String dob;
  String gender;
  String phone;
  String idNumber;
  String sourceOfIncome;
  String sourceOfWealth;
  int? autoNumber;

  @override
  State<NewMemberDialog> createState() => _NewMemberDialogState();

  NewMemberDialog(
      {this.isEditMode = false,
      this.relationship = "Self/Payer",
      this.title = "Mr",
      this.name = "",
      this.surname = "",
      this.dob = "",
      this.gender = "male",
      this.phone = "",
      this.idNumber = "",
      this.sourceOfIncome = "Salary",
      this.sourceOfWealth = "Savings",
      this.autoNumber});
}

class _NewMemberDialogState extends State<NewMemberDialog> {
  String? _selectedRelationship;
  String? _selectedTitle;
  String? _selectedIncome;
  String? _selectedWealth;
  String? _selectedGender;
  String? selectedDateOfBirth;

  int colorIndex = 0;

  List<String> wealthList = ["inheritance", "Savings", "Other", "Unknown"];
  List<String> incomeList = [
    "Salary",
    "Business Proceeds",
    "Sale Proceeds",
    "Sassa",
    "Other",
    "Unknown"
  ];

  List<String> coverList = [];
  List<String> productList = [
    "Product Athandwe1",
    "Product Athandwe2",
    "Product Athandwe3"
  ];
  List<String> commencementList = ["2024-07-01", "2024-05-23"];
  List<String> dateOfBirthList = ["1999-03-11"];
  int changeColorIndex = 0;

  List<String> genderList = ["male", "female", "other"];
  List<String> tempRelationshipList = [];

  final TextEditingController CADNameController = TextEditingController();
  final TextEditingController CADSurnameController = TextEditingController();

  final TextEditingController CADPhoneController = TextEditingController();
  final TextEditingController CADIDController = TextEditingController();
  final TextEditingController CADSourceOfIncomeController =
      TextEditingController();
  final TextEditingController CADSourceOfWealthController =
      TextEditingController();
  final TextEditingController CADIncomeDescriptionController =
      TextEditingController();
  final TextEditingController CADWealthDescriptionController =
      TextEditingController();

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode surnameFocusNode = FocusNode();
  final FocusNode dateOfBirthFocusNode = FocusNode();
  final FocusNode idFocusNode = FocusNode();
  final FocusNode sourceOfIncomeFocusNode =
      FocusNode(); //incomeDescriptionFocusNode
  final FocusNode sourceOfWealthFocusNode = FocusNode();
  final FocusNode incomeDescriptionFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode wealthDescriptionFocusNode = FocusNode();

  String currentMemberCover = "";

  //String currentMemberCover = "This member currently has total cover of R0";

  Future<String> getMemberTotalCover(
      String memberIdNumber, int clientId) async {
    // Replace with your actual API endpoint URL
    final String apiUrl =
        "https://miinsightsapps.net/backend_api/api/parlour/CheckMemberTotalCover";
    print("gghjghj $apiUrl");

    // Construct the request body
    final Map<String, dynamic> requestBody = {
      "memberIdNumber": memberIdNumber,
      "client_id": clientId,
    };
    if (memberIdNumber.isEmpty) return "";

    try {
      // Send POST request
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      // Handle the response
      if (response.statusCode == 200) {
        currentMemberCover = response.body.toString();
        setState(() {}); // Successful response
        print("gffghghg ${currentMemberCover}");
        return response.body; // Successful response
      } else {
        return "Error: ${response.statusCode} - ${response.reasonPhrase}";
      }
    } catch (e) {
      return "Error: $e"; // Handle connection or unexpected errors
    }
  }

  @override
  Widget build(BuildContext context) {
    //https://miinsightsapps.net/indexed/client1/files/indexing/SaveFieldForm_943959_0.pdf
    //https://miinsightsapps.net/indexed/client1/files/indexing/SaveFieldForm_952078_0.pdf

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 6,
            leading: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shadowColor: Colors.black.withOpacity(0.6),
            centerTitle: true,
            title: Text(
              widget.isEditMode == true
                  ? 'Edit Member To Cover'
                  : 'Add Member To Cover',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            constraints: BoxConstraints(maxWidth: 1200),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Container(
                                  height: 40,
                                  width: 130,
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Relationship',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'YuGothic',
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: const Row(
                                            children: [
                                              Icon(
                                                Icons.list,
                                                size: 16,
                                                color: Colors.black,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'Select A Relationship',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.grey,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          items: tempRelationshipList
                                              .map((String item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'YuGothic',
                                                        color: Colors.black,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ))
                                              .toList(),
                                          value: _selectedRelationship,
                                          onChanged: (String? value) {
                                            setState(() {
                                              _selectedRelationship = value;
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.only(
                                                left: 14, right: 14),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              border: Border.all(
                                                color: Colors.black26,
                                              ),
                                              color: Colors.transparent,
                                            ),
                                            elevation: 0,
                                          ),
                                          iconStyleData: const IconStyleData(
                                            icon: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                            ),
                                            iconSize: 14,
                                            iconEnabledColor: Colors.black,
                                            iconDisabledColor:
                                                Colors.transparent,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            elevation: 0,
                                            maxHeight: 200,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              color: Colors.white,
                                            ),
                                            offset: const Offset(-20, 0),
                                            scrollbarTheme: ScrollbarThemeData(
                                              radius: const Radius.circular(40),
                                              thickness: WidgetStateProperty
                                                  .all<double>(6),
                                              thumbVisibility:
                                                  WidgetStateProperty.all<bool>(
                                                      true),
                                            ),
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            overlayColor: null,
                                            height: 40,
                                            padding: EdgeInsets.only(
                                                left: 14, right: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Container(
                                  height: 40,
                                  width: 130,
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Title',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'YuGothic',
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: const Row(
                                            children: [
                                              Icon(
                                                Icons.list,
                                                size: 16,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'Select A Title',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.grey,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          items: Constants.titleList
                                              .map((String item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'YuGothic',
                                                        color: Colors.black,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ))
                                              .toList(),
                                          value: _selectedTitle,
                                          onChanged: (String? value) {
                                            setState(() {
                                              _selectedTitle = value;
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.only(
                                                left: 14, right: 14),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              border: Border.all(
                                                color: Colors.black26,
                                              ),
                                              color: Colors.transparent,
                                            ),
                                            elevation: 0,
                                          ),
                                          iconStyleData: const IconStyleData(
                                            icon: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                            ),
                                            iconSize: 14,
                                            iconEnabledColor: Colors.black,
                                            iconDisabledColor:
                                                Colors.transparent,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            elevation: 0,
                                            maxHeight: 200,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              color: Colors.white,
                                            ),
                                            offset: const Offset(-20, 0),
                                            scrollbarTheme: ScrollbarThemeData(
                                              radius: const Radius.circular(40),
                                              thickness: WidgetStateProperty
                                                  .all<double>(6),
                                              thumbVisibility:
                                                  WidgetStateProperty.all<bool>(
                                                      true),
                                            ),
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            overlayColor: null,
                                            height: 40,
                                            padding: EdgeInsets.only(
                                                left: 14, right: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Name',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'YuGothic',
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomInputTransparent3(
                                        controller: CADNameController,
                                        hintText: "Name",
                                        isName: true,
                                        onChanged: (String) {},
                                        onSubmitted: (String) {},
                                        focusNode: nameFocusNode,
                                        //suffix: Icon(CupertinoIcons.person_fill, size: 22, color: Color(0xFFEF601B).withOpacity(0.45),),
                                        textInputAction: TextInputAction.next,
                                        isPasswordField: false,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                const Text(
                                  'Surname',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'YuGothic',
                                      color: Colors.black),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomInputTransparent3(
                                        controller: CADSurnameController,
                                        hintText: "Surname",
                                        isName: true,
                                        onChanged: (String) {},
                                        onSubmitted: (String) {},
                                        focusNode: surnameFocusNode,
                                        //suffix: Icon(CupertinoIcons.person_fill, size: 22, color: Color(0xFFEF601B).withOpacity(0.45),),
                                        textInputAction: TextInputAction.next,
                                        isPasswordField: false,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  height: 16,
                                ),
                                Container(
                                  height: 45,
                                  width: 130,
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Date of Birth',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'YuGothic',
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0.0, right: 8),
                                        child: InkWell(
                                          onTap: () async {
                                            DateTime? date =
                                                await showYearFirstDatePicker(
                                                    context);
                                            if (date != null) {
                                              selectedDateOfBirth = Constants
                                                  .formatter
                                                  .format(date);
                                              setState(() {});
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.55),
                                              ),
                                            ),
                                            height: 50,
                                            width: 130,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12.0),
                                                  child: Text(
                                                    selectedDateOfBirth ==
                                                                null ||
                                                            selectedDateOfBirth ==
                                                                ""
                                                        ? "Select A Date of Birth"
                                                        : selectedDateOfBirth!,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'YuGothic',
                                                        color: selectedDateOfBirth ==
                                                                    null ||
                                                                selectedDateOfBirth ==
                                                                    ""
                                                            ? Colors.grey
                                                            : Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Container(
                                  height: 40,
                                  width: 130,
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Gender',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'YuGothic',
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: const Row(
                                            children: [
                                              Icon(
                                                Icons.list,
                                                size: 16,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'Select A Gender',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.grey,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          items: genderList
                                              .map((String item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item[0].toUpperCase() +
                                                          item
                                                              .substring(1)
                                                              .toLowerCase(),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'YuGothic',
                                                        color: Colors.black,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ))
                                              .toList(),
                                          value: _selectedGender,
                                          onChanged: (String? value) {
                                            setState(() {
                                              _selectedGender = value;
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.only(
                                                left: 14, right: 14),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              border: Border.all(
                                                color: Colors.black26,
                                              ),
                                              color: Colors.transparent,
                                            ),
                                            elevation: 0,
                                          ),
                                          iconStyleData: const IconStyleData(
                                            icon: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                            ),
                                            iconSize: 14,
                                            iconEnabledColor: Colors.black,
                                            iconDisabledColor:
                                                Colors.transparent,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            elevation: 0,
                                            maxHeight: 200,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              color: Colors.white,
                                            ),
                                            offset: const Offset(-20, 0),
                                            scrollbarTheme: ScrollbarThemeData(
                                              radius: const Radius.circular(40),
                                              thickness: WidgetStateProperty
                                                  .all<double>(6),
                                              thumbVisibility:
                                                  WidgetStateProperty.all<bool>(
                                                      true),
                                            ),
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            overlayColor: null,
                                            height: 40,
                                            padding: EdgeInsets.only(
                                                left: 14, right: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  height: 16,
                                ),
                                Container(
                                  height: 40,
                                  width: 130,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: const Text(
                                          'Contact Number',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'YuGothic',
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: CustomInputTransparent3(
                                                  controller:
                                                      CADPhoneController,
                                                  hintText: "Contact Number",
                                                  onChanged: (String) {},
                                                  onSubmitted: (String) {},
                                                  focusNode: phoneFocusNode,
                                                  //suffix: Icon(CupertinoIcons.person_fill, size: 22, color: Color(0xFFEF601B).withOpacity(0.45),),
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  isPasswordField: false,
                                                  integersOnly: true,
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
                                Container(
                                  height: 40,
                                  width: 130,
                                  child: Row(
                                    children: [
                                      const Text(
                                        'ID Number',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'YuGothic',
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment
                                                .start, //CADDateOfBirthController
                                            children: [
                                              Expanded(
                                                child:
                                                    CustomInputTransparentID2(
                                                  controller: CADIDController,
                                                  hintText: "ID Number",
                                                  onChanged: (value) {
                                                    if (CADIDController
                                                            .text.length ==
                                                        13) {
                                                      extractDobFromIdNumber(
                                                          CADIDController.text);
                                                      bool isMemberExists = Constants
                                                          .currentleadAvailable!
                                                          .additionalMembers
                                                          .any((member) =>
                                                              member.id ==
                                                              CADIDController
                                                                  .text);

                                                      if (isMemberExists) {
                                                        selectedDateOfBirth =
                                                            "";
                                                        CADIDController.clear();

                                                        MotionToast.error(
                                                          //   title: Text("Error"),
                                                          description: Center(
                                                            child: Text(
                                                              "Member Already Exists!",
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    'YuGothic',
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          layoutOrientation:
                                                              TextDirection.ltr,
                                                          animationType:
                                                              AnimationType
                                                                  .fromTop,
                                                          width: 350,
                                                          height: 55,
                                                          animationDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      2500),
                                                        ).show(context);
                                                      }
                                                    }
                                                  },
                                                  onSubmitted: (value) {
                                                    extractDobFromIdNumber(
                                                        CADIDController.text);
                                                    for (int i = 0;
                                                        i <
                                                            Constants
                                                                    .additionalMember
                                                                    .length -
                                                                1;
                                                        i++) {
                                                      if (Constants
                                                              .additionalMember[
                                                                  i]
                                                              .id !=
                                                          CADIDController
                                                              .text) {
                                                        selectedDateOfBirth =
                                                            Constants
                                                                .dateOfBirth;
                                                      } else {
                                                        selectedDateOfBirth =
                                                            "";
                                                        CADIDController.clear();
                                                        MotionToast.error(
                                                          //    title: Text("Error"),
                                                          description: Center(
                                                            child: Text(
                                                              "Member with same ID already exist!",
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    'YuGothic',
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          layoutOrientation:
                                                              TextDirection.ltr,
                                                          animationType:
                                                              AnimationType
                                                                  .fromTop,
                                                          width: 400,
                                                          height: 55,
                                                          animationDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      2500),
                                                        ).show(context);
                                                      }
                                                    }
                                                  },
                                                  focusNode: idFocusNode,
                                                  //suffix: Icon(CupertinoIcons.person_fill, size: 22, color: Color(0xFFEF601B).withOpacity(0.45),),
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  isPasswordField: false,
                                                  onIsSAIDChanged: (bool) {},
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Text("${currentMemberCover}",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'YuGothic',
                                                color:
                                                    Constants.ftaColorLight)),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          getMemberTotalCover(
                                              CADIDController.text, 1);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Constants.ftaColorLight,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              bottomLeft: Radius.circular(16),
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Check Cover',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'YuGothic'),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Container(
                                  height: 40,
                                  width: 130,
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Source of Income',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'YuGothic',
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
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
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child:
                                                      DropdownButton2<String>(
                                                    isExpanded: true,
                                                    hint: const Row(
                                                      children: [
                                                        Icon(
                                                          Icons.list,
                                                          size: 16,
                                                          color: Colors.grey,
                                                        ),
                                                        SizedBox(
                                                          width: 4,
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8.0),
                                                            child: Text(
                                                              'Select a source of income',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    'YuGothic',
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    items: incomeList
                                                        .map((String item) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                              value: item,
                                                              child: Text(
                                                                item,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      'YuGothic',
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ))
                                                        .toList(),
                                                    value: _selectedIncome,
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        _selectedIncome = value;
                                                      });
                                                    },
                                                    buttonStyleData:
                                                        ButtonStyleData(
                                                      height: 50,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 14,
                                                              right: 14),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                        border: Border.all(
                                                          color: Colors.black26,
                                                        ),
                                                        color:
                                                            Colors.transparent,
                                                      ),
                                                      elevation: 0,
                                                    ),
                                                    iconStyleData:
                                                        const IconStyleData(
                                                      icon: Icon(
                                                        Icons
                                                            .arrow_forward_ios_outlined,
                                                      ),
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
                                                                .circular(14),
                                                        color: Colors.white,
                                                      ),
                                                      offset:
                                                          const Offset(-20, 0),
                                                      scrollbarTheme:
                                                          ScrollbarThemeData(
                                                        radius: const Radius
                                                            .circular(40),
                                                        thickness:
                                                            WidgetStateProperty
                                                                .all<double>(6),
                                                        thumbVisibility:
                                                            WidgetStateProperty
                                                                .all<bool>(
                                                                    true),
                                                      ),
                                                    ),
                                                    menuItemStyleData:
                                                        const MenuItemStyleData(
                                                      overlayColor: null,
                                                      height: 40,
                                                      padding: EdgeInsets.only(
                                                          left: 14, right: 14),
                                                    ),
                                                  ),
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
                                Container(
                                  height: 40,
                                  width: 130,
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Source of Wealth',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'YuGothic',
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: const Row(
                                            children: [
                                              Icon(
                                                Icons.list,
                                                size: 16,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8.0),
                                                  child: Text(
                                                    'Select a source of wealth',
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'YuGothic',
                                                      color: Colors.grey,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          items: wealthList
                                              .map((String item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'YuGothic',
                                                        color: Colors.black,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ))
                                              .toList(),
                                          value: _selectedWealth,
                                          onChanged: (String? value) {
                                            setState(() {
                                              _selectedWealth = value;
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.only(
                                                left: 14, right: 14),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              border: Border.all(
                                                color: Colors.black26,
                                              ),
                                              color: Colors.transparent,
                                            ),
                                            elevation: 0,
                                          ),
                                          iconStyleData: const IconStyleData(
                                            icon: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                            ),
                                            iconSize: 14,
                                            iconEnabledColor: Colors.black,
                                            iconDisabledColor:
                                                Colors.transparent,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            elevation: 0,
                                            maxHeight: 200,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              color: Colors.white,
                                            ),
                                            offset: const Offset(-20, 0),
                                            scrollbarTheme: ScrollbarThemeData(
                                              radius: const Radius.circular(40),
                                              thickness: WidgetStateProperty
                                                  .all<double>(6),
                                              thumbVisibility:
                                                  WidgetStateProperty.all<bool>(
                                                      true),
                                            ),
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            overlayColor: null,
                                            height: 40,
                                            padding: EdgeInsets.only(
                                                left: 14, right: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Container(
                                  height: 40,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: const Text(
                                          'Income Description',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'YuGothic',
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
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
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: CustomInputTransparent3(
                                                  controller:
                                                      CADIncomeDescriptionController,
                                                  hintText:
                                                      "Type source of Income Description here",
                                                  onChanged: (String) {},
                                                  onSubmitted: (String) {},
                                                  focusNode:
                                                      incomeDescriptionFocusNode,
                                                  //suffix: Icon(CupertinoIcons.person_fill, size: 22, color: Color(0xFFEF601B).withOpacity(0.45),),
                                                  textInputAction:
                                                      TextInputAction.next,
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
                                Container(
                                  height: 40,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 12.0),
                                        child: const Text(
                                          'Wealth Description',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'YuGothic',
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
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
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: CustomInputTransparent3(
                                                  controller:
                                                      CADWealthDescriptionController,
                                                  hintText:
                                                      "Type source of Wealth Description here",
                                                  onChanged: (String) {},
                                                  onSubmitted: (String) {},
                                                  focusNode:
                                                      wealthDescriptionFocusNode,
                                                  //suffix: Icon(CupertinoIcons.person_fill, size: 22, color: Color(0xFFEF601B).withOpacity(0.45),),
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  isPasswordField: false,
                                                  //suffix:
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        child: Container(
                                          height: 45,
                                          width: 160,
                                          padding: EdgeInsets.only(
                                              left: 16, right: 16),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(36),
                                            color:
                                                Colors.grey.withOpacity(0.35),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Cancel",
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    fontSize: 14,
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'YuGothic',
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 22,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        child: Container(
                                          height: 45,
                                          width: 160,
                                          padding: EdgeInsets.only(
                                              left: 16, right: 16),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(360),
                                            color: Constants.ftaColorLight,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Save",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          if (_selectedRelationship == "" ||
                                              _selectedRelationship == null) {
                                            MotionToast.error(
                                              // title: Text("Error"),
                                              description: Text(
                                                "Please select relationship",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                  color: Colors.white,
                                                ),
                                              ),
                                              layoutOrientation:
                                                  TextDirection.ltr,
                                              animationType:
                                                  AnimationType.fromTop,
                                              width: 400,
                                              height: 55,
                                              animationDuration: const Duration(
                                                  milliseconds: 2500),
                                            ).show(context);
                                          } else if (_selectedTitle == "" ||
                                              _selectedTitle == null) {
                                            MotionToast.error(
                                              // title: Text("Error"),
                                              description: Text(
                                                "Please select Title",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                  color: Colors.white,
                                                ),
                                              ),
                                              layoutOrientation:
                                                  TextDirection.ltr,
                                              animationType:
                                                  AnimationType.fromTop,
                                              width: 400,
                                              height: 55,
                                              animationDuration: const Duration(
                                                  milliseconds: 2500),
                                            ).show(context);
                                          } else if (CADNameController
                                              .text.isEmpty) {
                                            MotionToast.error(
                                              title: Text("Error"),
                                              description:
                                                  Text("Please provide name"),
                                              layoutOrientation:
                                                  TextDirection.ltr,
                                              animationType:
                                                  AnimationType.fromTop,
                                              width: 400,
                                              height: 55,
                                              animationDuration: const Duration(
                                                  milliseconds: 2500),
                                            ).show(context);
                                          } else if (CADSurnameController
                                              .text.isEmpty) {
                                            MotionToast.error(
                                              // title: Text("Error"),
                                              description: Text(
                                                "Please provide surname",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                  color: Colors.white,
                                                ),
                                              ),

                                              layoutOrientation:
                                                  TextDirection.ltr,
                                              animationType:
                                                  AnimationType.fromTop,
                                              width: 400,
                                              height: 55,
                                              animationDuration: const Duration(
                                                  milliseconds: 2500),
                                            ).show(context);
                                          } else if (selectedDateOfBirth ==
                                                  "" ||
                                              selectedDateOfBirth == null) {
                                            MotionToast.error(
                                              // title: Text("Error"),
                                              height: 55,
                                              description: Text(
                                                "Please select a Date of birth",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                  color: Colors.white,
                                                ),
                                              ),
                                              layoutOrientation:
                                                  TextDirection.ltr,
                                              animationType:
                                                  AnimationType.fromTop,
                                              width: 400,

                                              animationDuration: const Duration(
                                                  milliseconds: 2500),
                                            ).show(context);
                                          } else if (CADPhoneController
                                              .text.isEmpty) {
                                            MotionToast.error(
                                              //title: Text("Error"),
                                              description: Text(
                                                "Please provide cell number",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                  color: Colors.white,
                                                ),
                                              ),
                                              layoutOrientation:
                                                  TextDirection.ltr,
                                              animationType:
                                                  AnimationType.fromTop,
                                              width: 400,
                                              height: 55,
                                              animationDuration: const Duration(
                                                  milliseconds: 2500),
                                            ).show(context);
                                          } else if (CADPhoneController
                                                      .text.length !=
                                                  10 &&
                                              CADPhoneController.text.length !=
                                                  12) {
                                            MotionToast.error(
                                              //title: Text("Error"),
                                              description: Text(
                                                "Phone number length must be 10 digits long",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                  color: Colors.white,
                                                ),
                                              ),
                                              layoutOrientation:
                                                  TextDirection.ltr,
                                              animationType:
                                                  AnimationType.fromTop,
                                              width: 400,
                                              height: 55,
                                              animationDuration: const Duration(
                                                  milliseconds: 2500),
                                            ).show(context);
                                          } else if (CADPhoneController
                                                      .text[0] !=
                                                  "0" &&
                                              CADPhoneController.text[0] !=
                                                  "2") {
                                            MotionToast.error(
                                              //title: Text("Error"),
                                              description: Text(
                                                "Phone number must start with a 0",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                  color: Colors.white,
                                                ),
                                              ),
                                              layoutOrientation:
                                                  TextDirection.ltr,
                                              animationType:
                                                  AnimationType.fromTop,
                                              width: 400,
                                              height: 55,
                                              animationDuration: const Duration(
                                                  milliseconds: 2500),
                                            ).show(context);
                                          } else if (CADIDController
                                              .text.isEmpty) {
                                            MotionToast.error(
                                              title: Text("Error"),
                                              description: Text(
                                                "Please provide ID number",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                  color: Colors.white,
                                                ),
                                              ),
                                              layoutOrientation:
                                                  TextDirection.ltr,
                                              animationType:
                                                  AnimationType.fromTop,
                                              width: 400,
                                              height: 55,
                                              animationDuration: const Duration(
                                                  milliseconds: 2500),
                                            ).show(context);
                                          } else if (isIdMatchingDOB(
                                                  CADIDController.text,
                                                  DateTime.parse(
                                                      selectedDateOfBirth!)) ==
                                              false) {
                                            MotionToast.error(
                                              // title: Text("Error"),
                                              description: Text(
                                                "Please provide ID number",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                  color: Colors.white,
                                                ),
                                              ),
                                              layoutOrientation:
                                                  TextDirection.ltr,
                                              animationType:
                                                  AnimationType.fromTop,
                                              width: 400,
                                              height: 55,
                                              animationDuration: const Duration(
                                                  milliseconds: 2500),
                                            ).show(context);
                                          } else if (_selectedIncome == "" ||
                                              _selectedIncome == null) {
                                            MotionToast.error(
                                              // title: Text("Error"),
                                              description: Text(
                                                "Please select source of income",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                  color: Colors.white,
                                                ),
                                              ),
                                              layoutOrientation:
                                                  TextDirection.ltr,
                                              animationType:
                                                  AnimationType.fromTop,
                                              width: 400,
                                              height: 55,
                                              animationDuration: const Duration(
                                                  milliseconds: 2500),
                                            ).show(context);
                                          } else if (_selectedWealth == "" ||
                                              _selectedWealth == null) {
                                            MotionToast.error(
                                              // title: Text("Error"),
                                              description: Text(
                                                "Please select source of wealth",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                  color: Colors.white,
                                                ),
                                              ),
                                              layoutOrientation:
                                                  TextDirection.ltr,
                                              animationType:
                                                  AnimationType.fromTop,
                                              width: 400,
                                              height: 55,
                                              animationDuration: const Duration(
                                                  milliseconds: 2500),
                                            ).show(context);
                                          } else if (_selectedWealth == "" ||
                                              _selectedWealth == null) {
                                            MotionToast.error(
                                              //  title: Text("Error"),
                                              description: Text(
                                                "Please select source of wealth",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                  color: Colors.white,
                                                ),
                                              ),
                                              layoutOrientation:
                                                  TextDirection.ltr,
                                              animationType:
                                                  AnimationType.fromTop,
                                              width: 400,
                                              height: 55,
                                              animationDuration: const Duration(
                                                  milliseconds: 2500),
                                            ).show(context);
                                          }
                                          /*else if (CADIncomeDescriptionController
                                              .text.isEmpty) {
                                            MotionToast.error(
                                              title: Text("Error"),
                                              description: Text(
                                                "Please provide Income description",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                  color: Colors.white,
                                                ),
                                              ),
                                              layoutOrientation: TextDirection.ltr,
                                              animationType: AnimationType.fromTop,
                                              width: 400,
                                              height: 55,
                                              animationDuration: const Duration(
                                                  milliseconds: 2500),
                                            ).show(context);
                                          }
                                          else if (CADWealthDescriptionController
                                              .text.isEmpty) {
                                            MotionToast.error(
                                              title: Text("Error"),
                                              description: Text(
                                                " Please provide wealth description",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                  color: Colors.white,
                                                ),
                                              ),
                                              layoutOrientation: TextDirection.ltr,
                                              animationType: AnimationType.fromTop,
                                              width: 400,
                                              height: 55,
                                              animationDuration: const Duration(
                                                  milliseconds: 2500),
                                            ).show(context);
                                          } */
                                          else {
                                            if (widget.isEditMode == false) {
                                              saveMember(context);
                                            } else {
                                              updateMember(
                                                  context, widget.autoNumber!);
                                            }
                                            Navigator.pop(context);
                                          }

                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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

  @override
  void initState() {
    if (widget.name.isNotEmpty) CADNameController.text = widget.name;
    if (widget.surname.isNotEmpty) CADSurnameController.text = widget.surname;
    if (widget.dob.isNotEmpty)
      selectedDateOfBirth =
          Constants.formatter.format(DateTime.parse(widget.dob));
    if (widget.phone.isNotEmpty) CADPhoneController.text = widget.phone;
    if (widget.gender.isNotEmpty) _selectedGender = widget.gender;
    if (widget.relationship.isNotEmpty)
      _selectedRelationship = widget.relationship;
    if (widget.idNumber.isNotEmpty) CADIDController.text = widget.idNumber;
    if (kDebugMode) {
      print("dfgfdgff ${widget.sourceOfIncome}");
    }
    if (widget.sourceOfIncome.isNotEmpty)
      _selectedIncome = widget.sourceOfIncome;
    if (widget.sourceOfWealth.isNotEmpty)
      _selectedWealth = widget.sourceOfWealth;
    if (widget.title.isNotEmpty) _selectedTitle = widget.title;
    configureRelationships();

    myNewMemberValue1.addListener(() {
      if (kDebugMode) {
        print("listening to myValue1");
      }
      setState(() {});
    });

    setState(() {
      //String baseUrl = "${Constants.insightsbaseUrl}fieldV6/saveMember";
    });
    //saveMember(context);

    super.initState();
  }

  void configureRelationships() {
    tempRelationshipList = List<String>.from(Constants.relationshipList);

    bool selfOrPayerExists = false;

    if (Constants.currentleadAvailable != null) {
      for (AdditionalMember member
          in Constants.currentleadAvailable!.additionalMembers) {
        String relationship = member.relationship.toLowerCase();

        // Check if "Self" or "Self/Payer" already exists
        if (relationship == "self/payer" || relationship == "self") {
          selfOrPayerExists = true;
        }

        // Remove used relationships from the list
        if (tempRelationshipList.contains(member.relationship)) {
          tempRelationshipList.remove(member.relationship);
        }
      }
    }

    // If no "Self" or "Self/Payer" exists, only allow "Self/Payer"
    if (!selfOrPayerExists) {
      tempRelationshipList = ["Self/Payer"];
    }

    // Set default selection if the list isn't empty
    if (tempRelationshipList.isNotEmpty) {
      _selectedRelationship = tempRelationshipList[0];
    }

    setState(() {}); // Call setState once at the end
  }

  void extractDobFromIdNumber(String idNumber) {
    if (idNumber.isEmpty || idNumber.length < 6) {
      // Handle invalid input
      print("Invalid ID Number");
      return;
    }

    try {
      // Extract YYMMDD from ID Number
      int yearPart = int.parse(idNumber.substring(0, 2));
      int monthPart = int.parse(idNumber.substring(2, 4));
      int dayPart = int.parse(idNumber.substring(4, 6));

      // Determine the correct year (1900s or 2000s)
      int currentYear =
          DateTime.now().year % 100; // Last two digits of the current year
      int fullYear =
          yearPart <= currentYear ? yearPart + 2000 : yearPart + 1900;

      // Validate the extracted date
      DateTime dob = DateTime(fullYear, monthPart, dayPart);

      // Format the date as YYYY-MM-DD
      selectedDateOfBirth = "${dob.year.toString().padLeft(4, '0')}-"
          "${dob.month.toString().padLeft(2, '0')}-"
          "${dob.day.toString().padLeft(2, '0')}";

      print("Extracted Date of Birth: $selectedDateOfBirth");

      setState(() {}); // Update UI if necessary
    } catch (e) {
      print("Error parsing ID Number: $e");
    }
  }

  Future<void> saveMember(BuildContext context) async {
    //String baseUrl = Constants.insightsBackendUrl + "fieldV6/saveMember";
    String baseUrl =
        "https://miinsightsapps.net/backend_api/api//fieldV6/saveMember/";
    int onoloadId = Constants.currentleadAvailable!.leadObject.onololeadid;
    print("Base URL: $baseUrl");
    print("onoloadId: $onoloadId");

    try {
      // Prepare the request
      var headers = {
        'Content-Type': 'application/json',
      };

      Map<String, dynamic> payload = {
        "title": _selectedTitle ?? '',
        "name": CADNameController.text,
        "surname": CADSurnameController.text,
        "gender": _selectedGender ?? '',
        "dob": selectedDateOfBirth, // Ensure 'YYYY-MM-DD' format
        "age": (DateTime.now().year - DateTime.parse(selectedDateOfBirth!).year)
            .toString(),
        "relationship": _selectedRelationship!
            .toLowerCase()
            .replaceAll("self/payer", "self"),
        "id": CADIDController.text,
        "contact": CADPhoneController.text,
        "onololeadid":
            onoloadId.toString(), // Ensure correct data type for the backend
        "source_of_income": CADSourceOfIncomeController.text,
        "source_of_wealth": CADSourceOfWealthController.text,
        "other_unknown_income": '',
        "other_unknown_wealth": ''
      };

      print("Payload: $payload"); // Debugging payload

      var request = http.Request('POST', Uri.parse(baseUrl));
      request.body = json.encode(payload);
      request.headers.addAll(headers);

      // Send the request
      http.StreamedResponse response = await request.send();

      // Log the response
      String responseBody = await response.stream.bytesToString();
      print("Response body: $responseBody");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(responseBody);
        AdditionalMember newMember = AdditionalMember.fromJson(responseData);
        Constants.currentleadAvailable!.additionalMembers.add(newMember);
        //needsAnalysisValueNotifier2.value++;

        print("Member saved successfully2: $responseData");
      } else {
        print("Failed to save member: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> updateMember(BuildContext context, int autoNumber) async {
    String baseUrl =
        "https://miinsightsapps.net/backend_api/api//fieldV6/updateMember/";
    int onoloadId = Constants.currentleadAvailable!.leadObject.onololeadid;

    print("Base URL: $baseUrl");
    print("onoloadId: $onoloadId");
    print("AutoNumber to update: $autoNumber");

    try {
      // Prepare headers
      var headers = {
        'Content-Type': 'application/json',
      };

      // Prepare the payload
      Map<String, dynamic> payload = {
        "auto_number": autoNumber, // Identify the member to update
        "title": _selectedTitle ?? '',
        "name": CADNameController.text,
        "surname": CADSurnameController.text,
        "gender": _selectedGender ?? '',
        "dob": selectedDateOfBirth, // Ensure 'YYYY-MM-DD' format
        "age": (DateTime.now().year - DateTime.parse(selectedDateOfBirth!).year)
            .toString(),
        "relationship": _selectedRelationship!
            .toLowerCase()
            .replaceAll("self/payer", "self"),
        "id": CADIDController.text,
        "contact": CADPhoneController.text,
        "onololeadid": onoloadId.toString(),
        "source_of_income": CADSourceOfIncomeController.text,
        "source_of_wealth": CADSourceOfWealthController.text,
        "other_unknown_income": '',
        "other_unknown_wealth": ''
      };

      print("Payload for update: $payload");

      var request = http.Request('POST', Uri.parse(baseUrl));
      request.body = json.encode(payload);
      request.headers.addAll(headers);

      // Send the update request
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      print("Response body: $responseBody");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(responseBody);
        if (responseData.toString() == "1") {
          // Find the member by autoNumber and update the details
          int index = Constants.currentleadAvailable!.additionalMembers
              .indexWhere((member) => member.autoNumber == autoNumber);

          if (index != -1) {
            // Update the existing member's details
            AdditionalMember oldMember =
                Constants.currentleadAvailable!.additionalMembers[index];
            Constants.currentleadAvailable!.additionalMembers[index] =
                AdditionalMember(
                    memberType: oldMember.memberType,
                    autoNumber: autoNumber,
                    id: CADIDController.text,
                    contact: CADPhoneController.text,
                    dob: selectedDateOfBirth!,
                    gender: _selectedGender ?? '',
                    name: CADNameController.text,
                    surname: CADSurnameController.text,
                    title: _selectedTitle!,
                    onololeadid: oldMember.onololeadid,
                    altContact: oldMember.altContact,
                    email: oldMember.email,
                    percentage: oldMember.percentage,
                    maritalStatus: oldMember.maritalStatus,
                    relationship: _selectedRelationship!
                        .toLowerCase()
                        .replaceAll("self/payer", "self"),
                    mipCover: oldMember.mipCover,
                    mipStatus: oldMember.mipStatus,
                    updatedBy: oldMember.updatedBy,
                    memberQueryType: oldMember.memberQueryType,
                    memberQueryTypeOldNew: oldMember.memberQueryTypeOldNew,
                    memberQueryTypeOldAutoNumber:
                        oldMember.memberQueryTypeOldAutoNumber,
                    membersAutoNumber: oldMember.membersAutoNumber,
                    sourceOfIncome: CADSourceOfIncomeController.text,
                    sourceOfWealth: CADSourceOfWealthController.text,
                    otherUnknownIncome: oldMember.otherUnknownIncome,
                    otherUnknownWealth: oldMember.otherUnknownWealth,
                    timestamp: oldMember.timestamp,
                    lastUpdate: oldMember.lastUpdate);

            //needsAnalysisValueNotifier2.value++; // Notify UI to refresh
            print("Member updated successfully: $responseData");
          }
        } else {
          print("Member with autoNumber $autoNumber not found.");
        }
      } else {
        print("Failed to update member: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error occurred while updating member: $e");
    }
  }
}

class PdfViewerPage extends StatelessWidget {
  final String pdfUrl;

  const PdfViewerPage({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // You could use e.g. Syncfusion PDF viewer, flutter_pdfview, etc.
    // Here’s a placeholder example:
    return Scaffold(
      appBar: AppBar(title: Text('PDF Viewer')),
      body: SfPdfViewer.network(pdfUrl),
    );
  }
}

// ----------------------------------------------------------------
// Example: Simple Image viewer page
// ----------------------------------------------------------------
class ImageViewerPage extends StatelessWidget {
  final String imageUrl;

  const ImageViewerPage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Viewer')),
      body: InteractiveViewer(
        panEnabled: true,
        minScale: 0.5,
        maxScale: 4,
        child: Center(
          child: Image.network(
            imageUrl,
            errorBuilder: (context, _, __) => Icon(Icons.broken_image),
          ),
        ),
      ),
    );
  }
}

class PDFViewerWithControls extends StatefulWidget {
  final String pdfUrl;

  // Add the Key? parameter here
  const PDFViewerWithControls({
    Key? key,
    required this.pdfUrl,
  }) : super(key: key); // Pass the key up to the parent

  @override
  _PDFViewerWithControlsState createState() => _PDFViewerWithControlsState();
}

class _PDFViewerWithControlsState extends State<PDFViewerWithControls> {
  late PdfViewerController _pdfViewerController;

  double _zoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();

    setState(() {});

    myPdfValue1.addListener(() {
      setState(() {});
      if (kDebugMode) {
        print("listening to myValue1");
      }
    });
  }

  // Helper to build the color matrix
  List<double> makeColorFilterMatrix(double brightness, double contrast) {
    final double t = brightness * 255;
    final double c = contrast;

    return <double>[
      c,
      0,
      0,
      0,
      t,
      0,
      c,
      0,
      0,
      t,
      0,
      0,
      c,
      0,
      t,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  // Example function for downloading the PDF
  Future<void> downloadPdfFile(String pdfUrl, String fileName) async {
    try {
      final response = await http.get(Uri.parse(pdfUrl));
      if (response.statusCode == 200) {
        String? outputPath = await FilePicker.platform.getDirectoryPath();
        if (outputPath == null) {
          print("No directory selected.");
          return;
        }

        final filePath = pt.join(outputPath, fileName);
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print('PDF file saved to $filePath');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("PDF file saved to $filePath")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Failed to download PDF: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error downloading PDF: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Constants.ftaColorLight,
        title: Text(
          "Pdf Preview",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'YuGothic',
            color: Colors.white,
          ),
        ),
        actions: [
          // Page Navigation
          IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: _pdfViewerController.pageNumber == 1
                  ? Colors.grey
                  : Colors.white,
            ),
            tooltip: 'Previous Page',
            onPressed: () {
              _pdfViewerController.previousPage();
              setState(() {});
            },
          ),
          Center(
            child: Text(
              "${_pdfViewerController.pageNumber} / ${_pdfViewerController.pageCount}",
              style: TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: _pdfViewerController.pageNumber ==
                      _pdfViewerController.pageCount
                  ? Colors.grey
                  : Colors.white,
            ),
            tooltip: 'Next Page',
            onPressed: () {
              _pdfViewerController.nextPage();
              setState(() {});
            },
          ),
          VerticalDivider(color: Colors.white54, thickness: 1),

          // Zoom Out
          IconButton(
            icon: Icon(Icons.zoom_out, color: Colors.white),
            tooltip: 'Zoom Out',
            onPressed: () {
              setState(() {
                if (_zoomLevel > 1.0) _zoomLevel -= 0.1;
                _pdfViewerController.zoomLevel = _zoomLevel;
              });
            },
          ),

          // Zoom Percentage Display
          Center(
            child: Text(
              "${(_zoomLevel * 100).toInt()}%",
              style: TextStyle(color: Colors.white),
            ),
          ),

          // Zoom In
          IconButton(
            icon: Icon(Icons.zoom_in, color: Colors.white),
            tooltip: 'Zoom In',
            onPressed: () {
              setState(() {
                if (_zoomLevel < 3.0) _zoomLevel += 0.1;
                _pdfViewerController.zoomLevel = _zoomLevel;
              });
            },
          ),
          VerticalDivider(color: Colors.white54, thickness: 1),

          // Rotate Button (not supported by Syncfusion, so show a notice)
          IconButton(
            icon: Icon(Icons.rotate_left, color: Colors.white),
            tooltip: 'Rotate Left',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Rotate is not supported.")),
              );
            },
          ),

          // Download Button (use your custom PDF download logic)
          IconButton(
            icon: Icon(Icons.download, color: Colors.white),
            tooltip: 'Download',
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Download started...")),
              );
              await downloadPdfFile(
                widget.pdfUrl,
                "SaveFieldForm.pdf",
              );
            },
          ),

          // Print Button (not supported by Syncfusion, so show a notice or implement custom printing)
          IconButton(
            icon: Icon(Icons.print, color: Colors.white),
            tooltip: 'Print',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Print is not supported.")),
              );
            },
          ),
          SizedBox(width: 8),
        ],
      ),
      body: ColorFiltered(
        colorFilter: ColorFilter.matrix(
          makeColorFilterMatrix(_brightness, _contrast),
        ),
        child: SfPdfViewer.network(
          widget.pdfUrl,
          controller: _pdfViewerController,
          onDocumentLoaded: (PdfDocumentLoadedDetails details) {
            // Once the document is loaded, trigger a rebuild so your
            // _pdfViewerController.pageNumber and pageCount are correct.
            setState(() {});
          },
        ),
      ),
      // Optionally add Sliders to adjust brightness & contrast
    );
  }
}

Future<DateTime?> showYearFirstDatePicker(BuildContext context) async {
  // Calculate the date range: 100 years ago to today
  final DateTime today = DateTime.now();
  final DateTime hundredYearsAgo =
      DateTime(today.year - 100, today.month, today.day);

  // Show the date picker dialog
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: today,
    // Default to today
    firstDate: hundredYearsAgo,
    // Minimum selectable date
    lastDate: today,
    // Maximum selectable date
    initialDatePickerMode: DatePickerMode.year,
    // Start with year selection

    // Custom themed appearance
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Constants.ftaColorLight, // Header background color
            onPrimary: Colors.white, // Header text color
            onSurface: Colors.black, // Body text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.deepOrange, // Button text color
            ),
          ),
        ),
        child: child!,
      );
    },
  );

  // Handle the selected date
  if (pickedDate != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Selected Date: ${pickedDate.toLocal()}")),
    );
  }
  return pickedDate;
}

bool isIdMatchingDOB(String idNumber, DateTime dateOfBirth) {
  // Validate ID Number length
  if (idNumber.length != 13 || !RegExp(r'^\d{13}$').hasMatch(idNumber)) {
    return false; // Invalid ID number format
  }

  // Extract YYMMDD from ID number
  String idDOBPart = idNumber.substring(0, 6);

  // Format dateOfBirth to YYMMDD
  String formattedDOB = dateOfBirth.year.toString().substring(2, 4) +
      dateOfBirth.month.toString().padLeft(2, '0') +
      dateOfBirth.day.toString().padLeft(2, '0');

  // Compare the two
  return idDOBPart == formattedDOB;
}

class ViewIndexedDocuments extends StatefulWidget {
  const ViewIndexedDocuments({super.key});

  @override
  State<ViewIndexedDocuments> createState() => _ViewIndexedDocumentsState();
}

int noOfDocuments = 0;
List<String> indexedFiles = [];
int displayIndexedImage = 0;
String displayIndexedImageFileType = "";

class _ViewIndexedDocumentsState extends State<ViewIndexedDocuments> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 22,
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // ------------------------------------------------------------
              // Top Row with GridView
              // ------------------------------------------------------------
              //Text(displayIndexedImage.toString()),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      width: 900,
                      child: GridView.builder(
                        itemCount: noOfDocuments,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 16 / 13,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                        itemBuilder: (context, index) {
                          final path = indexedFiles[index];
                          // Extract file extension
                          final filetype = path.split('.').last.toLowerCase();
                          if (kDebugMode) {
                            print("Filetype: $filetype ($path)");
                          }

                          return InkWell(
                            onTap: () {
                              displayIndexedImage = index;
                              //myNewMemberValue1.value++;
                              setState(() {});
                              if (kDebugMode) {
                                print("fgfgfg ${displayIndexedImage}");
                              }
                              displayIndexedImageFileType = filetype;
                              uq1_key1 = UniqueKey();

                              setState(() {});
                              // Decide how to open based on extension
                              /*if (filetype == 'pdf') {
                                                       // Navigate to PDF viewer
                                                       Navigator.push(
                                                         context,
                                                         MaterialPageRoute(
                                                           builder: (context) =>
                                                               PdfViewerPage(
                                                                   pdfUrl: path),
                                                         ),
                                                       );
                                                     }
                                                     else {
                                                       // Navigate to image viewer
                                                       Navigator.push(
                                                         context,
                                                         MaterialPageRoute(
                                                           builder: (context) =>
                                                               ImageViewerPage(
                                                                   imageUrl: path),
                                                         ),
                                                       );
                                                     }*/
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: displayIndexedImage == index
                                      ? Constants.ctaColorLight
                                      : Colors.blueGrey.shade200,
                                  width: 1,
                                ),
                                color: Colors.white,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: filetype == 'pdf'
                                    ? Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: SvgPicture.asset(
                                          'lib/assets/svgs/pdf_icon.svg',
                                          width: 32,
                                          height: 32,
                                        ),
                                      )
                                    : Icon(Iconsax.image),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // ------------------------------------------------------------
                  // Brightness / Contrast Column
                  // ------------------------------------------------------------
                  SizedBox(width: 22),
                  Container(
                    width: 250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // ---------------------------------
                        // Brightness Slider
                        // ---------------------------------
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                "Brightness:",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'YuGothic',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 3, // Thinner track
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 8), // Smaller knob
                                  overlayShape: RoundSliderOverlayShape(
                                      overlayRadius:
                                          12), // Smaller ripple effect
                                ),
                                child: Slider(
                                  value: _brightness,
                                  min: -1.0,
                                  max: 1.0,
                                  activeColor: Constants.ftaColorLight,
                                  inactiveColor:
                                      Constants.ftaColorLight.withOpacity(0.25),
                                  thumbColor: Constants.ftaColorLight,
                                  label: _brightness.round().toString(),
                                  onChanged: (double value) {
                                    setState(() {
                                      _brightness = value;
                                      myPdfValue1.value++;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),

                        // ---------------------------------
                        // Contrast Slider
                        // ---------------------------------
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                "Contrast:",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'YuGothic',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 3, // Thinner track
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 8), // Smaller knob
                                  overlayShape: RoundSliderOverlayShape(
                                      overlayRadius:
                                          12), // Smaller ripple effect
                                ),
                                child: Slider(
                                  min: 0.0,
                                  max: 2.0,
                                  value: _contrast,
                                  activeColor: Constants.ftaColorLight,
                                  inactiveColor:
                                      Constants.ftaColorLight.withOpacity(0.25),
                                  thumbColor: Constants.ftaColorLight,
                                  label: _contrast.round().toString(),
                                  onChanged: (double value) {
                                    setState(() {
                                      _contrast = value;
                                      myPdfValue1.value++;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 16),
              // ------------------------------------------------------------
              // Large "Preview" area (optional)
              // ------------------------------------------------------------
              if (indexedFiles.isNotEmpty)
                SelectableText(indexedFiles[displayIndexedImage]),
              if (indexedFiles.isNotEmpty)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.9,
                        padding: EdgeInsets.only(
                            left: 0, top: 24, right: 32, bottom: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          // Example: showing the first item in the list
                          child: displayIndexedImageFileType == "pdf"
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.15),
                                      width: 1,
                                    ),
                                  ),
                                  child: PDFViewerWithControls(
                                      key: uq1_key1,
                                      pdfUrl:
                                          indexedFiles[displayIndexedImage]),
                                )
                              : Image.network(
                                  indexedFiles[displayIndexedImage],
                                  fit: BoxFit.cover,
                                  colorBlendMode: BlendMode.modulate,
                                  // Example logic: adjust with brightness/contrast if desired
                                  // color: Colors.white.withOpacity(_currentSliderValue / 100),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        )
      ],
    );
  }

  void getIndexingDocuments() {
    List<String> list = [];
    noOfDocuments = Constants
            .currentleadAvailable?.leadObject.documentsIndexedFieldFormCount ??
        0;
    int leadId = Constants.currentleadAvailable?.leadObject.onololeadid ?? 0;
    String extension =
        Constants.currentleadAvailable?.leadObject.documentsIndexedExtention ??
            "";

    print("asahsghg ${extension}");

    indexedFiles = [
      for (int i = 0; i < noOfDocuments; i++)
        "https://miinsightsapps.net/indexed/client1/files/indexing/SaveFieldForm_${leadId}_$i$extension"
    ];
    if (noOfDocuments > 0) {
      displayIndexedImage = 0;
      final path = indexedFiles[0];
      // Extract file extension
      final filetype = path.split('.').last.toLowerCase();
      displayIndexedImageFileType = filetype;
      setState(() {});
    }
  }

  @override
  void initState() {
    getIndexingDocuments();
    super.initState();
  }
}
