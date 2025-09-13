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
import 'package:mi_insights/screens/Sales%20Agent/universal_premium_calculator.dart';

import 'package:motion_toast/motion_toast.dart';
import 'package:path/path.dart' as pt;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../constants/Constants.dart';

import '../../customwidgets/custom_input.dart';
import '../../models/map_class.dart';
import '../../services/MyNoyifier.dart';
import '../../services/id_number_service.dart';
import '../../services/sales_service.dart';
import 'field_premium_calculator.dart';
import 'need_analysis.dart';

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
  int current_member_index;
  bool? is_self_or_payer;
  bool? is_sub_process;
  bool canAddMember;
  VoidCallback? onAfterEdit;
  bool? showIndexedDocuments;
  bool? showSourceOfIncome;

  @override
  State<NewMemberDialog> createState() => _NewMemberDialogState();

  NewMemberDialog({
    this.isEditMode = false,
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
    this.autoNumber,
    required this.current_member_index,
    this.is_self_or_payer,
    this.is_sub_process,
    this.onAfterEdit,
    required this.canAddMember,
    this.showIndexedDocuments,
    this.showSourceOfIncome,
  });
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
        "${Constants.insightsBackendBaseUrl}parlour/CheckMemberTotalCover";
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
    //${Constants.insightsBackendBaseUrl}indexed/client1/files/indexing/SaveFieldForm_943959_0.pdf
    //${Constants.insightsBackendBaseUrl}indexed/client1/files/indexing/SaveFieldForm_952078_0.pdf

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
    String baseUrl = "${Constants.insightsBackendBaseUrl}/fieldV6/saveMember/";
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
        needsAnalysisValueNotifier2.value++;

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
        "${Constants.insightsBackendBaseUrl}/fieldV6/updateMember/";
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

            needsAnalysisValueNotifier2.value++; // Notify UI to refresh
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

class NewMemberDialog2 extends StatefulWidget {
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
  int current_member_index;
  bool? is_self_or_payer;
  bool? is_sub_process;
  bool canAddMember;
  VoidCallback? onAfterEdit;
  bool? showIndexedDocuments;
  bool? showSourceOfIncome;

  @override
  State<NewMemberDialog2> createState() => _NewMemberDialog2State();

  NewMemberDialog2({
    this.isEditMode = false,
    this.relationship = "Self/Payer",
    this.title = "Mr",
    this.name = "",
    this.surname = "",
    this.dob = "",
    this.gender = "male",
    this.phone = "",
    this.idNumber = "",
    this.sourceOfIncome = "",
    this.sourceOfWealth = "",
    this.autoNumber,
    required this.current_member_index,
    this.is_self_or_payer,
    this.is_sub_process,
    this.onAfterEdit,
    required this.canAddMember,
    this.showIndexedDocuments,
    this.showSourceOfIncome,
  });
}

class _NewMemberDialog2State extends State<NewMemberDialog2> {
  String? _selectedRelationship;
  String? _selectedTitle;
  String? _selectedIncome;
  String? _selectedWealth;
  String? _selectedGender;
  String? selectedDateOfBirth;

  int colorIndex = 0;

  List<String> wealthList = ["Inheritance", "Savings", "Other", "Unknown"];
  List<String> incomeList = [
    "Salary",
    "Business Proceeds",
    "Sale Proceeds",
    "Sassa",
    "Other",
    "Unknown",
  ];

  List<String> coverList = [];

  List<String> commencementList = ["2024-07-01", "2024-05-23"];
  List<String> dateOfBirthList = ["1999-03-11"];
  int changeColorIndex = 0;
  int displayIndexedImage = 0;
  String displayIndexedImageFileType = "";
  List<String> genderList = ["male", "female"];
  List<String> tempRelationshipList = [];
  bool isAdjusting = false;

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
  int noOfDocuments = 0;
  bool isSAID = true;
  List<String> indexedFiles = [];
  String currentMemberCover = "";

  //String currentMemberCover = "This member currently has total cover of R0";

  Future<String> getMemberTotalCover(
    String memberIdNumber,
    int clientId,
  ) async {
    // Replace with your actual API endpoint URL
    final String apiUrl =
        "${Constants.insightsBackendBaseUrl}parlour/CheckMemberTotalCover";
    print("gghjghj $apiUrl ${clientId} $memberIdNumber");

    // Construct the request body
    final Map<String, dynamic> requestBody = {
      "memberIdNumber": memberIdNumber,
      "client_id": clientId,
    };

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
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.isEditMode == true
                            ? 'Edit Member To Cover'
                            : 'Add Member To Cover',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'YuGothic',
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: Divider(color: Colors.grey.withOpacity(0.55)),
                ),
                SizedBox(height: 24),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'Relationship',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'YuGothic',
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      hint: Row(
                                        children: [
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              'Select A Relationship',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Build a list of dropdown items.
                                      items: _buildRelationshipItems(),
                                      value: _selectedRelationship,
                                      onChanged: (String? value) {
                                        setState(() {
                                          _selectedRelationship = value;
                                        });
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        height: 50,
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(32),
                                          border:
                                              Border.all(color: Colors.black26),
                                          color: Colors.transparent,
                                        ),
                                        elevation: 0,
                                      ),
                                      iconStyleData: const IconStyleData(
                                        icon: Icon(
                                            Icons.arrow_forward_ios_outlined),
                                        iconSize: 14,
                                        iconEnabledColor: Colors.black,
                                        iconDisabledColor: Colors.transparent,
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        elevation: 2,
                                        maxHeight: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(32),
                                          color: Colors.white,
                                        ),
                                        offset: const Offset(0, 5),
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(40),
                                          thickness:
                                              WidgetStateProperty.all<double>(
                                            6,
                                          ),
                                          thumbVisibility:
                                              WidgetStateProperty.all<bool>(
                                                  true),
                                        ),
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        overlayColor: null,
                                        height: 40,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 14),
                                      ),
                                    ),
                                  ),
                                ],
                            ),
                            SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'Title',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'YuGothic',
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      hint: const Row(
                                        children: [
                                          /*Icon(
                                                    Icons.list,
                                                    size: 16,
                                                    color: Colors.grey,
                                                  ),*/
                                          SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              'Select A Title',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      items: Constants.titleList
                                          .map(
                                            (String item) =>
                                                DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                  color: Colors.black,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      value: _selectedTitle,
                                      onChanged: (String? value) {
                                        setState(() {
                                          _selectedTitle = value;
                                        });
                                        String? mismatchMessage =
                                            getGenderTitleMismatchMessage(
                                          _selectedGender,
                                          _selectedTitle,
                                        );

                                        if (mismatchMessage != null) {
                                          MotionToast.error(
                                            // You might need to adjust height/width for longer messages
                                            height: 45,
                                            width: 700,
                                            description: Text(
                                              mismatchMessage, // <-- Use the dynamic message here!
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ).show(context);
                                          return; // Stop further processing
                                        }
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.only(
                                          left: 14,
                                          right: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(32),
                                          border:
                                              Border.all(color: Colors.black26),
                                          color: Colors.transparent,
                                        ),
                                        elevation: 0,
                                      ),
                                      iconStyleData: const IconStyleData(
                                        icon: Icon(
                                            Icons.arrow_forward_ios_outlined),
                                        iconSize: 14,
                                        iconEnabledColor: Colors.black,
                                        iconDisabledColor: Colors.transparent,
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        elevation: 0,
                                        maxHeight: 200,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(32),
                                          color: Colors.white,
                                        ),
                                        offset: const Offset(-20, 0),
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(40),
                                          thickness:
                                              WidgetStateProperty.all<double>(
                                            6,
                                          ),
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
                                ],
                            ),
                            SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'Name',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'YuGothic',
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                CustomInputTransparent3(
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
                                ],
                            ),
                            SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'Surname',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'YuGothic',
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                CustomInputTransparent3(
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
                                ],
                            ),
                            SizedBox(height: 24),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment
                                            .start, //CADDateOfBirthController
                                        children: [
                                          Expanded(
                                            child: CustomInputTransparentID2(
                                              controller: CADIDController,
                                              hintText: "ID Number",
                                              onChanged: (value) {
                                                if (CADIDController
                                                        .text.length ==
                                                    13) {
                                                  extractDobFromIdNumber(
                                                    CADIDController.text,
                                                  );
                                                  _selectedGender =
                                                      getGenderFromSouthAfricanId(
                                                    CADIDController.text,
                                                  ).toString().toLowerCase();
                                                  setState(() {});
                                                  bool isMemberExists =
                                                      Constants
                                                          .currentleadAvailable!
                                                          .additionalMembers
                                                          .any(
                                                    (member) =>
                                                        member.id ==
                                                        CADIDController.text,
                                                  );

                                                  if (isMemberExists &&
                                                      widget.isEditMode ==
                                                          false) {
                                                    selectedDateOfBirth = "";
                                                    CADIDController.clear();

                                                    MotionToast.error(
                                                      //   title: Text("Error"),
                                                      description: Center(
                                                        child: Text(
                                                          "Member Already Exists!",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                'YuGothic',
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      layoutOrientation:
                                                          TextDirection.ltr,
                                                      animationType:
                                                          AnimationType.fromTop,
                                                      width: 350,
                                                      height: 55,
                                                      animationDuration:
                                                          const Duration(
                                                        milliseconds: 2500,
                                                      ),
                                                    ).show(context);
                                                  }
                                                }
                                              },
                                              onSubmitted: (value) {
                                                extractDobFromIdNumber(
                                                  CADIDController.text,
                                                );
                                                for (int i = 0;
                                                    i <
                                                        Constants
                                                                .additionalMember
                                                                .length -
                                                            1;
                                                    i++) {
                                                  if (Constants
                                                          .additionalMember[i]
                                                          .id !=
                                                      CADIDController.text) {
                                                    selectedDateOfBirth =
                                                        Constants.dateOfBirth;
                                                  } else {
                                                    selectedDateOfBirth = "";
                                                    CADIDController.clear();
                                                    MotionToast.error(
                                                      //    title: Text("Error"),
                                                      description: Center(
                                                        child: Text(
                                                          "Member with same ID already exist!",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                'YuGothic',
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      layoutOrientation:
                                                          TextDirection.ltr,
                                                      animationType:
                                                          AnimationType.fromTop,
                                                      width: 400,
                                                      height: 55,
                                                      animationDuration:
                                                          const Duration(
                                                        milliseconds: 2500,
                                                      ),
                                                    ).show(context);
                                                  }
                                                }
                                              },
                                              focusNode: idFocusNode,
                                              //suffix: Icon(CupertinoIcons.person_fill, size: 22, color: Color(0xFFEF601B).withOpacity(0.45),),
                                              textInputAction:
                                                  TextInputAction.next,
                                              isPasswordField: false,
                                              onIsSAIDChanged: (val) {
                                                isSAID = val;
                                              },
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
                            SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      "${currentMemberCover}",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'YuGothic',
                                        color: Constants.ftaColorLight,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      getMemberTotalCover(
                                        CADIDController.text,
                                        Constants.cec_client_id,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Constants.ftaColorLight,
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
                                        fontFamily: 'YuGothic',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 0.0,
                                      right: 8,
                                    ),
                                    child: InkWell(
                                      onTap: () async {
                                        final DateTime today = DateTime.now();
                                        final DateTime hundredYearsAgo =
                                            DateTime(
                                          today.year - 100,
                                          today.month,
                                          today.day,
                                        );

                                        print("Opening date picker...");
                                        DateTime? date = await showDatePicker(
                                          context: context,
                                          initialDate: today,
                                          firstDate: hundredYearsAgo,
                                          lastDate: today,
                                          initialDatePickerMode:
                                              DatePickerMode.year,
                                        );
                                        print("Date picker returned: $date");
                                        if (date != null && mounted) {
                                          setState(() {
                                            selectedDateOfBirth = Constants
                                                .formatter
                                                .format(date);
                                          });
                                        }

                                        if (date != null) {
                                          print(
                                              "xcdffgfg ${date.toIso8601String()}");
                                          selectedDateOfBirth =
                                              formatter.format(
                                            date,
                                          );
                                          setState(() {});
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(32),
                                          border: Border.all(
                                            color:
                                                Colors.grey.withOpacity(0.55),
                                          ),
                                        ),
                                        height: 50,
                                        width: 130,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 12.0,
                                              ),
                                              child: Text(
                                                selectedDateOfBirth == null ||
                                                        selectedDateOfBirth ==
                                                            ""
                                                    ? "Select A Date of Birth"
                                                    : selectedDateOfBirth!,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                  color: selectedDateOfBirth ==
                                                              null ||
                                                          selectedDateOfBirth ==
                                                              ""
                                                      ? Colors.grey
                                                      : Colors.black,
                                                ),
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
                            SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
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
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      hint: const Row(
                                        children: [
                                          /* Icon(
                                                    Icons.list,
                                                    size: 16,
                                                    color: Colors.grey,
                                                  ),*/
                                          SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              'Select A Gender',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      items: genderList
                                          .map(
                                            (String item) =>
                                                DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item[0].toUpperCase() +
                                                    item
                                                        .substring(1)
                                                        .toLowerCase(),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'YuGothic',
                                                  color: Colors.black,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      value: _selectedGender,
                                      onChanged: (String? value) {
                                        setState(() {
                                          _selectedGender = value;
                                        });
                                        String? mismatchMessage =
                                            getGenderTitleMismatchMessage(
                                          _selectedGender,
                                          _selectedTitle,
                                        );

                                        if (mismatchMessage != null) {
                                          MotionToast.error(
                                            // You might need to adjust height/width for longer messages
                                            height: 45,
                                            width: 700,
                                            description: Text(
                                              mismatchMessage, // <-- Use the dynamic message here!
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ).show(context);
                                          return; // Stop further processing
                                        }
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.only(
                                          left: 14,
                                          right: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(32),
                                          border:
                                              Border.all(color: Colors.black26),
                                          color: Colors.transparent,
                                        ),
                                        elevation: 0,
                                      ),
                                      iconStyleData: const IconStyleData(
                                        icon: Icon(
                                            Icons.arrow_forward_ios_outlined),
                                        iconSize: 14,
                                        iconEnabledColor: Colors.black,
                                        iconDisabledColor: Colors.transparent,
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        elevation: 0,
                                        maxHeight: 200,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(32),
                                          color: Colors.white,
                                        ),
                                        offset: const Offset(-20, 0),
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(40),
                                          thickness:
                                              WidgetStateProperty.all<double>(
                                            6,
                                          ),
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
                            if (_selectedRelationship == "Self/Payer")
                              SizedBox(height: 16),
                            if (_selectedRelationship == "Self/Payer")
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
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
                                                controller: CADPhoneController,
                                                hintText: "Contact Number",
                                                onChanged: (String) {},
                                                onSubmitted: (String) {},
                                                focusNode: phoneFocusNode,
                                                //suffix: Icon(CupertinoIcons.person_fill, size: 22, color: Color(0xFFEF601B).withOpacity(0.45),),
                                                textInputAction:
                                                    TextInputAction.next,
                                                isPasswordField: false,
                                                //maxInputs: 10,
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
                            SizedBox(height: 16),
                            if (_selectedRelationship == "Self/Payer" &&
                                (widget.showSourceOfIncome == true ||
                                    widget.showSourceOfIncome == null))
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
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
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
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
                                                child: DropdownButton2<String>(
                                                  isExpanded: true,
                                                  hint: const Row(
                                                    children: [
                                                      /* Icon(
                                                              Icons.list,
                                                              size: 16,
                                                              color: Colors.grey,
                                                            ),*/
                                                      SizedBox(width: 4),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: 8.0,
                                                          ),
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
                                                      .map(
                                                        (
                                                          String item,
                                                        ) =>
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
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      )
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
                                                    width: MediaQuery.of(
                                                      context,
                                                    ).size.width,
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 14,
                                                      right: 14,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              32),
                                                      border: Border.all(
                                                        color: Colors.black26,
                                                      ),
                                                      color: Colors.transparent,
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
                                                          BorderRadius.circular(
                                                              14),
                                                      color: Colors.white,
                                                    ),
                                                    offset:
                                                        const Offset(-20, 0),
                                                    scrollbarTheme:
                                                        ScrollbarThemeData(
                                                      radius:
                                                          const Radius.circular(
                                                        40,
                                                      ),
                                                      thickness:
                                                          WidgetStateProperty
                                                              .all<double>(6),
                                                      thumbVisibility:
                                                          WidgetStateProperty
                                                              .all<bool>(true),
                                                    ),
                                                  ),
                                                  menuItemStyleData:
                                                      const MenuItemStyleData(
                                                    overlayColor: null,
                                                    height: 40,
                                                    padding: EdgeInsets.only(
                                                      left: 14,
                                                      right: 14,
                                                    ),
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
                            if (_selectedRelationship == "Self/Payer" &&
                                (widget.showSourceOfIncome == true ||
                                    widget.showSourceOfIncome == null))
                              SizedBox(height: 16),
                            if (_selectedRelationship == "Self/Payer" &&
                                _selectedIncome == "Other" &&
                                (widget.showSourceOfIncome == true ||
                                    widget.showSourceOfIncome == null))
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 130,
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
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
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
                            if (_selectedRelationship == "Self/Payer" &&
                                _selectedIncome == "Other" &&
                                (widget.showSourceOfIncome == true ||
                                    widget.showSourceOfIncome == null))
                              SizedBox(height: 16),
                            if (_selectedRelationship == "Self/Payer" &&
                                (widget.showSourceOfIncome == true ||
                                    widget.showSourceOfIncome == null))
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
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
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        isExpanded: true,
                                        hint: const Row(
                                          children: [
                                            /* Icon(
                                                    Icons.list,
                                                    size: 16,
                                                    color: Colors.grey,
                                                  ),*/
                                            SizedBox(width: 4),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 8.0),
                                                child: Text(
                                                  'Select a source of wealth',
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
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
                                            .map(
                                              (
                                                String item,
                                              ) =>
                                                  DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'YuGothic',
                                                    color: Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        value: _selectedWealth,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _selectedWealth = value;
                                          });
                                        },
                                        buttonStyleData: ButtonStyleData(
                                          height: 50,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.only(
                                            left: 14,
                                            right: 14,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(32),
                                            border: Border.all(
                                                color: Colors.black26),
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
                                          iconDisabledColor: Colors.transparent,
                                        ),
                                        dropdownStyleData: DropdownStyleData(
                                          elevation: 0,
                                          maxHeight: 200,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(32),
                                            color: Colors.white,
                                          ),
                                          offset: const Offset(-20, 0),
                                          scrollbarTheme: ScrollbarThemeData(
                                            radius: const Radius.circular(40),
                                            thickness:
                                                WidgetStateProperty.all<double>(
                                                    6),
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
                                            left: 14,
                                            right: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            if (_selectedRelationship == "Self/Payer" &&
                                _selectedWealth == "Other" &&
                                (widget.showSourceOfIncome == true ||
                                    widget.showSourceOfIncome == null))
                              SizedBox(height: 16),
                            if (_selectedRelationship == "Self/Payer" &&
                                _selectedWealth == "Other" &&
                                (widget.showSourceOfIncome == true ||
                                    widget.showSourceOfIncome == null))
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 130,
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
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
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
                            SizedBox(height: 24),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    child: Container(
                                      height: 45,
                                      width: 160,
                                      padding:
                                          EdgeInsets.only(left: 16, right: 16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(36),
                                        color: Colors.grey.withOpacity(0.35),
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
                                              color: Colors.black,
                                            ),
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
                                SizedBox(width: 22),
                                Expanded(
                                  child: InkWell(
                                    child: Container(
                                      height: 45,
                                      width: 160,
                                      padding:
                                          EdgeInsets.only(left: 16, right: 16),
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
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      bool containSelfOrPayer = false;
                                      if (Constants.currentleadAvailable !=
                                          null) {
                                        if (Constants.currentleadAvailable!
                                            .additionalMembers
                                            .where((member) =>
                                                member.relationship == "self")
                                            .isNotEmpty) {
                                          containSelfOrPayer = true;
                                        }
                                      }
                                      print("dfjhdfdffd ${containSelfOrPayer}");

                                      if (containSelfOrPayer == true &&
                                          widget.isEditMode == false &&
                                          _selectedRelationship ==
                                              "Self/Payer") {
                                        MotionToast.error(
                                          // title: Text("Error"),
                                          description: Text(
                                            "Cannot have more than one payer",
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
                                            milliseconds: 2500,
                                          ),
                                        ).show(context);
                                        return null;
                                      } else
                                      // Check Date of Birth first
                                      if (selectedDateOfBirth == null ||
                                          selectedDateOfBirth!.isEmpty) {
                                        MotionToast.error(
                                          height: 45,
                                          description: Text(
                                            "Please select a Date of birth",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ).show(context);
                                        return;
                                      }
                                      if (_selectedGender == null ||
                                          _selectedGender!.isEmpty) {
                                        MotionToast.error(
                                          height: 45,
                                          description: Text(
                                            "Please select a gender",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ).show(context);
                                        return;
                                      }

                                      // Convert selectedDateOfBirth to DateTime and calculate user age
                                      final dobDateTime = DateTime.parse(
                                        selectedDateOfBirth!,
                                      );
                                      final userAge = calculateAge(dobDateTime);

                                      // Basic validations: relationship, title, name, surname, and DOB (again if needed)
                                      if (_selectedRelationship == null) {
                                        MotionToast.error(
                                          height: 45,
                                          description: Text(
                                            "Please select relationship",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ).show(context);
                                        return;
                                      }
                                      if (_selectedTitle == null) {
                                        MotionToast.error(
                                          height: 45,
                                          description: Text(
                                            "Please select the title",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ).show(context);
                                        return;
                                      }
                                      if (CADNameController.text.isEmpty) {
                                        MotionToast.error(
                                          height: 45,
                                          description: Text(
                                            "Please provide name",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ).show(context);
                                        return;
                                      }
                                      if (CADSurnameController.text.isEmpty) {
                                        MotionToast.error(
                                          height: 45,
                                          description: Text(
                                            "Please provide surname",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ).show(context);
                                        return;
                                      }

                                      // Relationship-based validations
                                      if (_selectedRelationship ==
                                          "Self/Payer") {
                                        if (userAge < 18) {
                                          MotionToast.error(
                                            height: 45,
                                            description: Text(
                                              "Self/Payer must be at least 18 years old",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ).show(context);
                                          return;
                                        }
                                        if (CADPhoneController.text.isEmpty) {
                                          MotionToast.error(
                                            height: 45,
                                            description: Text(
                                              "Please provide cell number",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ).show(context);
                                          return;
                                        }
                                        if (CADPhoneController.text.length !=
                                                10 &&
                                            CADPhoneController.text.length !=
                                                12) {
                                          MotionToast.error(
                                            height: 45,
                                            description: Text(
                                              "Phone number length must be 10 digits long",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ).show(context);
                                          return;
                                        }
                                        if (CADPhoneController.text[0] != "0" &&
                                            CADPhoneController.text[0] != "2") {
                                          MotionToast.error(
                                            height: 45,
                                            description: Text(
                                              "Phone number must start with a 0",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ).show(context);
                                          return;
                                        }
                                        if (CADIDController.text.isEmpty) {
                                          MotionToast.error(
                                            height: 45,
                                            description: Text(
                                              "Please provide ID number",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ).show(context);
                                          return;
                                        }
                                        if (!isIdMatchingDOB(
                                          CADIDController.text,
                                          dobDateTime,
                                        )) {
                                          MotionToast.error(
                                            height: 45,
                                            description: Text(
                                              "ID number does not match Date of Birth",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ).show(context);
                                          return;
                                        }
                                        if (_selectedIncome == null &&
                                            (widget.showSourceOfIncome ==
                                                    true ||
                                                widget.showSourceOfIncome ==
                                                    null)) {
                                          MotionToast.error(
                                            height: 45,
                                            description: Text(
                                              "Please select source of income",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ).show(context);
                                          return;
                                        }
                                        if (_selectedWealth == null &&
                                            (widget.showSourceOfIncome ==
                                                    true ||
                                                widget.showSourceOfIncome ==
                                                    null)) {
                                          MotionToast.error(
                                            height: 45,
                                            description: Text(
                                              "Please select source of wealth",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ).show(context);
                                          return;
                                        }
                                      } else if (_selectedRelationship ==
                                          "Partner") {
                                        if (userAge < 16) {
                                          MotionToast.error(
                                            height: 45,
                                            description: Text(
                                              "Partner must be at least 16 years old",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ).show(context);
                                          return;
                                        }
                                      } else if (_selectedRelationship ==
                                          "Child") {
                                        if (userAge < 0 || userAge > 24) {
                                          MotionToast.error(
                                            height: 45,
                                            description: Text(
                                              "Child’s age must be between 0 and 24 years",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ).show(context);
                                          return;
                                        }
                                      }
                                      if (_selectedRelationship ==
                                              "Self/Payer" &&
                                          _selectedWealth == "Other" &&
                                          CADWealthDescriptionController
                                              .text.isEmpty) {
                                        MotionToast.error(
                                          height: 45,
                                          description: Text(
                                            "Please provide wealth description",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ).show(context);
                                        return;
                                      }
                                      if (_selectedRelationship ==
                                              "Self/Payer" &&
                                          _selectedWealth == "Other" &&
                                          CADWealthDescriptionController
                                                  .text.length <
                                              4) {
                                        MotionToast.error(
                                          height: 45,
                                          width: 500,
                                          description: Text(
                                            "Wealth description must be at least 4 characters long",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ).show(context);
                                        return;
                                      }

                                      if (_selectedRelationship ==
                                              "Self/Payer" &&
                                          isSAID == true &&
                                          IDNumberService().validateSAId(
                                                CADIDController.text,
                                              ) ==
                                              false) {
                                        MotionToast.error(
                                          height: 45,
                                          description: Text(
                                            "Invalid South African ID",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ).show(context);
                                        return;
                                      }
                                      if (_selectedRelationship ==
                                              "Self/Payer" &&
                                          _selectedIncome == "Other" &&
                                          CADIncomeDescriptionController
                                              .text.isEmpty) {
                                        MotionToast.error(
                                          height: 45,
                                          description: Text(
                                            "Please provide income description",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ).show(context);
                                        return;
                                      }
                                      if (_selectedRelationship ==
                                              "Self/Payer" &&
                                          _selectedIncome == "Other" &&
                                          CADIncomeDescriptionController
                                                  .text.length <
                                              4) {
                                        MotionToast.error(
                                          height: 45,
                                          width: 500,
                                          description: Text(
                                            "Income description must be at least 4 characters long",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ).show(context);
                                        return;
                                      }
                                      if (validateGenderAndTitle(
                                        _selectedGender,
                                        _selectedTitle,
                                      )) {
                                        MotionToast.error(
                                          height: 45,
                                          width: 700,
                                          description: const Text(
                                            "Gender and Title mismatch (e.g., 'Mr' must be male, 'Ms' must be female).",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ).show(context);
                                        return; // Stop further processing
                                      }
                                      // New validation against the main member's date of birth
                                      if (current_member_index <
                                              policiesSelectedMainInsuredDOBs
                                                  .length &&
                                          policiesSelectedMainInsuredDOBs[
                                                  current_member_index] !=
                                              "") {
                                        print(
                                            "Main member DOB: ${policiesSelectedMainInsuredDOBs[current_member_index]}");
                                        final mainDob = DateTime.parse(
                                            policiesSelectedMainInsuredDOBs[
                                                current_member_index]);
                                        final mainMemberAge =
                                            calculateAge(mainDob);

                                        // For roles that require the new member to be older than the main member
                                        if ([
                                          "Parent",
                                          "GrandFather",
                                          "GrandMother"
                                        ].contains(_selectedRelationship)) {
                                          if (userAge <= mainMemberAge) {
                                            MotionToast.error(
                                              height: 65,
                                              width: 500,
                                              dismissable: true,
                                              description: Text(
                                                "The New member or $_selectedRelationship is $userAge years and can't be younger than the Main Member that is $mainMemberAge",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ).show(context);
                                            return;
                                          }
                                        }
                                        // For roles that require the new member to be younger than the main member
                                        else if (["Adult child"]
                                            .contains(_selectedRelationship)) {
                                          if (userAge >= mainMemberAge) {
                                            MotionToast.error(
                                              height: 65,
                                              width: 500,
                                              description: Text(
                                                "The New member or $_selectedRelationship is $userAge years and can't be older than the Main Member that is $mainMemberAge",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ).show(context);
                                            return;
                                          }
                                        }
                                        // Optionally, if you want to add any specific validation for "Cousin", you can do so here.
                                      }

                                      // If we reach here, all validations have passed.
                                      if (widget.isEditMode == false) {
                                        // New member
                                        saveMember(context, widget.canAddMember)
                                            .then((val) {
                                          // widget.onAfterEdit();
                                        });
                                      } else {
                                        // Update existing member
                                        updateMember(
                                                context, widget.autoNumber!)
                                            .then((val) {
                                          widget.onAfterEdit!();
                                        });
                                      }

                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 36),
                          ],
                        ),
                      ),
                      //SizedBox(width: 22),
                      // Modern Document Viewer Section
                      /*if (indexedFiles.isNotEmpty &&
                          (widget.showIndexedDocuments == true ||
                              widget.showIndexedDocuments == null))
                        Expanded(
                          flex: 3,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Document Grid Header
                                _buildDocumentGridHeader(),

                                const SizedBox(height: 8),
                                // Controls Panel
                                // if (isAdjusting == true) _buildControlsPanel(),
                                const SizedBox(height: 8),
                                _buildDocumentGrid(),
                                const SizedBox(height: 8),
                                Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Document Grid + Preview Area

                                      //Expanded(child: _buildDocumentPreview()),

                                      const SizedBox(width: 24),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),*/
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
  // Helper Methods for Modern UI Components

  Widget _buildDocumentGridHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.grid_view_rounded,
            size: 20,
            color: Constants.ftaColorLight,
          ),
          const SizedBox(width: 12),
          Text(
            'Indexed Documents',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          InkWell(
              onTap: () {
                isAdjusting = !isAdjusting;
                setState(() {});
              },
              child: Text(
                !isAdjusting ? "View Adjustments" : "Hide Adjustments",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Constants.ftaColorLight),
              )),
          SizedBox(
            width: 18,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            decoration: BoxDecoration(
              color: Constants.ftaColorLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$noOfDocuments ${noOfDocuments == 1 ? 'file' : 'files'}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentGrid() {
    return Container(
      height: 44,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Determine documents per row based on screen width
          int documentsPerRow;
          if (constraints.maxWidth > 1400) {
            documentsPerRow = 18;
          } else if (constraints.maxWidth > 900) {
            documentsPerRow = 12;
          } else {
            documentsPerRow = 8;
          }

          // Calculate how many rows we need
          int totalRows = (noOfDocuments / documentsPerRow).ceil();

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: totalRows,
            itemBuilder: (context, rowIndex) {
              // Calculate start and end indices for this row
              int startIndex = rowIndex * documentsPerRow;
              int endIndex =
                  (startIndex + documentsPerRow).clamp(0, noOfDocuments);

              return Container(
                width: constraints.maxWidth > 1400
                    ? 300 // Width for 18 items
                    : constraints.maxWidth > 900
                        ? 200 // Width for 9 items
                        : 100, // Width for 6 items
                margin: const EdgeInsets.only(right: 10),
                child: Row(
                  children: List.generate(endIndex - startIndex, (colIndex) {
                    int index = startIndex + colIndex;
                    final path = indexedFiles[index];
                    final filetype = path.split('.').last.toLowerCase();
                    final isSelected = displayIndexedImage == index;

                    if (kDebugMode) {
                      print("Filetype: $filetype ($path)");
                    }

                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            right:
                                colIndex < (endIndex - startIndex - 1) ? 4 : 0),
                        child: GestureDetector(
                          onTap: () => _onDocumentSelected(index, filetype),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.grey.withOpacity(0.55)
                                    : Colors.grey.withOpacity(0.3),
                                width: 1,
                              ),
                              color: isSelected
                                  ? Colors.grey.withOpacity(0.02)
                                  : Theme.of(context).colorScheme.surface,
                            ),
                            child: Stack(
                              children: [
                                // Main Content - Row Layout
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Document Index
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surfaceVariant,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              '${index + 1}',
                                              style: TextStyle(
                                                fontSize: 8,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 2),

                                      // File Type Badge
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getFileIconColor(filetype)
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            filetype.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 8,
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  _getFileIconColor(filetype),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Selection Indicator
                                if (isSelected)
                                  Positioned(
                                    top: 2,
                                    right: 2,
                                    child: Container(
                                      padding: const EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: Constants.ftaColorLight,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        size: 8,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDocumentPreview() {
    if (indexedFiles.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      padding: EdgeInsets.only(top: 12),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.1),
        ),
        child: Column(
          children: [
            // Preview Header
            Container(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceVariant
                    .withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.visibility_rounded,
                    size: 20,
                    color: Constants.ftaColorLight,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Document Preview',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Spacer(),
                  _buildPreviewActions(),
                ],
              ),
            ),

            // Preview Content
            Container(
              // height: 600,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: _buildPreviewContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Full Screen Button
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: IconButton(
            onPressed: () => _openFullScreenPreview(),
            icon: Icon(
              Icons.fullscreen,
              color: Constants.ftaColorLight,
              size: 22,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Constants.ftaColorLight.withOpacity(0.08),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            tooltip: 'Full Screen',
          ),
        ),

        const SizedBox(width: 8),

        /* // Download Button
        IconButton(
          onPressed: () => _downloadDocument(),
          icon: Icon(
            Icons.download_rounded,
            color: Constants.ftaColorLight,
          ),
          style: IconButton.styleFrom(
            backgroundColor: Constants.ftaColorLight.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          tooltip: 'Download',
        ),*/
      ],
    );
  }

  Widget _buildPreviewContent() {
    return Container(
      padding: const EdgeInsets.all(0),
      child: displayIndexedImageFileType == "pdf"
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      Theme.of(context).colorScheme.outline.withOpacity(0.15),
                ),
              ),
              child: PDFViewerWithControls(
                key: uq1_key1,
                pdfUrl: indexedFiles[displayIndexedImage],
              ),
            )
          : ColorFiltered(
              colorFilter: ColorFilter.matrix([
                _contrast,
                0,
                0,
                0,
                _brightness * 255,
                0,
                _contrast,
                0,
                0,
                _brightness * 255,
                0,
                0,
                _contrast,
                0,
                _brightness * 255,
                0,
                0,
                0,
                1,
                0,
              ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  indexedFiles[displayIndexedImage],
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildImageLoadingState(loadingProgress);
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return _buildImageErrorState();
                  },
                ),
              ),
            ),
    );
  }

  Widget _buildControlsPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.tune_rounded,
                size: 20,
                color: Constants.ftaColorLight,
              ),
              const SizedBox(width: 8),
              Text(
                'Image Adjustments',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _resetImageAdjustments,
                child: Text(
                  'Reset',
                  style: TextStyle(
                    fontSize: 12,
                    color: Constants.ftaColorLight,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (displayIndexedImageFileType != 'pdf') ...[
            // Brightness Control
            _buildSliderControl(
              'Brightness',
              _brightness,
              -1.0,
              1.0,
              Icons.brightness_6_rounded,
              (value) {
                setState(() {
                  _brightness = value;
                  myPdfValue1.value++;
                });
              },
            ),

            const SizedBox(height: 20),

            // Contrast Control
            _buildSliderControl(
              'Contrast',
              _contrast,
              0.0,
              2.0,
              Icons.contrast_rounded,
              (value) {
                setState(() {
                  _contrast = value;
                  myPdfValue1.value++;
                });
              },
            ),
          ] else
            _buildPdfNotice(),
        ],
      ),
    );
  }

  Widget _buildSliderControl(
    String label,
    double value,
    double min,
    double max,
    IconData icon,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: Constants.ftaColorLight,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            activeTrackColor: Constants.ftaColorLight,
            inactiveTrackColor: Constants.ftaColorLight.withOpacity(0.3),
            thumbColor: Constants.ftaColorLight,
            overlayColor: Constants.ftaColorLight.withOpacity(0.2),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  // Helper Methods

  Widget _buildFileIcon(String filetype) {
    switch (filetype) {
      case 'pdf':
        return SvgPicture.asset(
          'lib/assets/svgs/pdf_icon.svg',
          width: 32,
          height: 32,
        );
      default:
        return Icon(
          Icons.image_rounded,
          size: 32,
          color: _getFileIconColor(filetype),
        );
    }
  }

  Color _getFileIconColor(String filetype) {
    switch (filetype) {
      case 'pdf':
        return Colors.red;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Colors.blue;
      default:
        return Constants.ftaColorLight;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.description_outlined,
              size: 64,
              color: Constants.ftaColorLight,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Documents Available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload documents to view them here',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageLoadingState(ImageChunkEvent loadingProgress) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading image...',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load image',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Image adjustments are not available for PDF files',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Action Methods

  void _onDocumentSelected(int index, String filetype) {
    setState(() {
      displayIndexedImage = index;
      displayIndexedImageFileType = filetype;
      uq1_key1 = UniqueKey();
    });

    if (kDebugMode) {
      print("Selected document: $index, type: $filetype");
    }
  }

  void _resetImageAdjustments() {
    setState(() {
      _brightness = 0.0;
      _contrast = 1.0;
      myPdfValue1.value++;
    });
  }

  void _openFullScreenPreview() {
    // Navigate to full screen preview
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => displayIndexedImageFileType == 'pdf'
            ? PdfViewerPage(pdfUrl: indexedFiles[displayIndexedImage])
            : ImageViewerPage(imageUrl: indexedFiles[displayIndexedImage]),
      ),
    );
  }

  void _downloadDocument() {
    // Implement download functionality
    // This would typically use a package like dio or http to download the file
    print("Downloading: ${indexedFiles[displayIndexedImage]}");
  }

  @override
  void initState() {
    _selectedIncome = null;
    _selectedWealth = null;
    _selectedRelationship = null;

    print(
        "sddffdg ${Constants.currentleadAvailable!.additionalMembers.length}");

    if (widget.name.isNotEmpty) CADNameController.text = widget.name;
    if (widget.surname.isNotEmpty) CADSurnameController.text = widget.surname;
    if (widget.title.isNotEmpty) _selectedTitle = widget.title;
    if (widget.dob.isNotEmpty)
      selectedDateOfBirth = formatter.format(DateTime.parse(widget.dob));
    if (widget.dob.isNotEmpty) CADIDController.text = widget.idNumber;
    if (widget.phone.isNotEmpty) CADPhoneController.text = widget.phone;
    if (widget.gender.isNotEmpty) _selectedGender = widget.gender;
    if (widget.idNumber.isNotEmpty) CADIDController.text = widget.idNumber;

    if (kDebugMode) {
      print("dfgfdgff1 ${widget.sourceOfIncome}");
    }

    if (widget.sourceOfIncome.isNotEmpty)
      _selectedIncome = widget.sourceOfIncome;
    if (widget.sourceOfWealth.isNotEmpty)
      _selectedWealth = widget.sourceOfWealth;
    if (widget.title.isNotEmpty) _selectedTitle = widget.title;

    // Configure relationships FIRST before normalizing
    configureRelationships();
    // Handle is_self_or_payer flag
    if (widget.is_self_or_payer != null && widget.is_self_or_payer == true) {
      _selectedRelationship = "Self/Payer";
      if (!tempRelationshipList.contains("Self/Payer")) {
        tempRelationshipList.add("Self/Payer");
      }
    }
    // THEN normalize and set relationship AFTER configureRelationships()
    if (widget.relationship.isNotEmpty) {
      _selectedRelationship = _normalizeRelationship(widget.relationship);
      setState(() {});
    }
    print("dsfdgg $_selectedRelationship - ${widget.relationship}");

    if (Constants.currentleadAvailable!.additionalMembers.isEmpty) {
      CADNameController.text =
          Constants.currentleadAvailable!.leadObject.firstName;
      CADSurnameController.text =
          Constants.currentleadAvailable!.leadObject.lastName;
      CADPhoneController.text =
          Constants.currentleadAvailable!.leadObject.cellNumber;
      _selectedTitle = Constants.currentleadAvailable!.leadObject.title;
    }

    myNewMemberValue1.addListener(() {
      if (kDebugMode) {
        print("listening to myValue1");
      }
      setState(() {});
    });

    getIndexingDocuments();

    super.initState();
  }

  void configureRelationships() {
    tempRelationshipList = List<String>.from(Constants.relationshipList);
    print("Initial Relationship List: $tempRelationshipList");

    bool selfOrPayerExists = false;
    if (widget.current_member_index != null) {
      print("widget.current_member_index:");
    }
  }

/*
  void configureRelationships2() {
    tempRelationshipList = List<String>.from(Constants.relationshipList);
    print("Initial Relationship List: $tempRelationshipList");

    bool selfOrPayerExists = false;

    if (Constants.currentleadAvailable != null) {
      for (AdditionalMember member
          in Constants.currentleadAvailable!.additionalMembers) {
        String relationship = member.relationship.toLowerCase();

        // Check if "Self" or "Self/Payer" already exists
        if (relationship == "self/payer" || relationship == "self") {
          selfOrPayerExists = true;
        }

        // Remove specific relationships: "Self/Payer", "Self", "Partner", "Spouse"
        tempRelationshipList.removeWhere(
          (rel) =>
              rel.toLowerCase() == "self/payer" ||
              rel.toLowerCase() == "self" ||
              rel.toLowerCase() == "partner" ||
              rel.toLowerCase() == "spouse",
        );
      }
    }

    // If no "Self" or "Self/Payer" exists, only allow "Self/Payer"
    if (!selfOrPayerExists) {
      tempRelationshipList = ["Self/Payer"];
    }

    // Set default selection if the list isn't empty
    if (tempRelationshipList.isNotEmpty && _selectedRelationship == null) {
      _selectedRelationship = tempRelationshipList[0];
    }

    print("Filtered Relationship List: $tempRelationshipList");
    setState(() {}); // Call setState once at the end
  }
*/

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
        "${Constants.insightsBaseUrl}indexed/client${Constants.cec_client_id}/files/indexing/SaveFieldForm_${leadId}_$i$extension",
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

  Future<void> saveMember(BuildContext context, canAddMember) async {
    String baseUrl = "${Constants.InsightsAdminbaseUrl}fieldV6/saveMember/";
    int onoloadId = Constants.currentleadAvailable!.leadObject.onololeadid;
    print("Base URL: $baseUrl");
    print("onoloadId: $onoloadId");

    try {
      var headers = {'Content-Type': 'application/json'};

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
        "onololeadid": onoloadId.toString(),
        "source_of_income": _selectedIncome,
        "source_of_wealth": _selectedWealth,
        "other_unknown_income": CADIncomeDescriptionController.text,
        "other_unknown_wealth": CADWealthDescriptionController.text,
      };

      if (kDebugMode) {
        print("Payload: $payload");
      }

      var request = http.Request('POST', Uri.parse(baseUrl));
      request.body = json.encode(payload);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      if (kDebugMode) {
        print("Response bodyfghg: $responseBody");
      }

      if (response.statusCode == 200) {
        var responseData = jsonDecode(responseBody);
        if (kDebugMode) {
          print(responseData);
        }

        // Create AdditionalMember from response data.
        AdditionalMember newMember = AdditionalMember.fromJson(responseData);

        Constants.currentleadAvailable!.additionalMembers.add(newMember);

        if (canAddMember == true) {
          print("dfgffg ${_selectedRelationship!.toLowerCase()}");
          if (_selectedRelationship!.toLowerCase() == "self/payer") {
            AdditionalMember member = newMember;
            final policy =
                Constants.currentleadAvailable!.policies[current_member_index];
            final String? currentReference = policy.reference;
            final List<dynamic> membersList = policy.members ?? [];
            print("New main member autoNumber: ${member.autoNumber}");

            // Build a new partner Member object.
            final newPolicyMember = Member(
              null,
              null,
              null,
              currentReference,
              member.autoNumber,
              null,
              0,
              "main_member",
              0,
              null,
              "",
              null,
              "",
              null,
              null,
              null,
              "",
              Constants.cec_client_id,
              Constants.cec_employeeid,
            );

            // Check if a partner with the same autoNumber and reference exists.
            final existingIndex = membersList.indexWhere((m) {
              if (m is Map<String, dynamic>) {
                return (m['autoNumber'] == member.autoNumber) &&
                    ((m['type'] as String?)?.toLowerCase() == 'partner') &&
                    (m['reference'] == currentReference);
              } else if (m is Member) {
                return (m.autoNumber == member.autoNumber) &&
                    ((m.type ?? '').toLowerCase() == 'partner') &&
                    (m.reference == currentReference);
              }
              return false;
            });

            if (existingIndex != -1) {
              // Update the existing partner entry.
              membersList[existingIndex] = newPolicyMember.toJson();
            } else {
              // Otherwise, add the new partner entry.
              membersList.add(newPolicyMember.toJson());
            }
            policy.members = membersList;
          }
          // For Partner Members
          if (_selectedRelationship!.toLowerCase() == "partner") {
            AdditionalMember member = newMember;
            final policy =
                Constants.currentleadAvailable!.policies[current_member_index];
            final String? currentReference = policy.reference;
            final List<dynamic> membersList = policy.members ?? [];
            print("New partner autoNumber: ${member.autoNumber}");
            double cover = Constants
                    .currentleadAvailable!
                    .policies[current_member_index]
                    .quote
                    .sumAssuredFamilyCover ??
                0;

            // Build a new partner Member object.
            final newPolicyMember = Member(
              null,
              null,
              null,
              currentReference,
              member.autoNumber,
              null,
              cover,
              "partner",
              0,
              null,
              "",
              null,
              "",
              null,
              null,
              null,
              "",
              Constants.cec_client_id,
              Constants.cec_employeeid,
            );

            // Check if a partner with the same autoNumber and reference exists.
            final existingIndex = membersList.indexWhere((m) {
              if (m is Map<String, dynamic>) {
                return (m['autoNumber'] == member.autoNumber) &&
                    ((m['type'] as String?)?.toLowerCase() == 'partner') &&
                    (m['reference'] == currentReference);
              } else if (m is Member) {
                return (m.autoNumber == member.autoNumber) &&
                    ((m.type ?? '').toLowerCase() == 'partner') &&
                    (m.reference == currentReference);
              }
              return false;
            });

            if (existingIndex != -1) {
              // Update the existing partner entry.
              membersList[existingIndex] = newPolicyMember.toJson();
            } else {
              // Otherwise, add the new partner entry.
              membersList.add(newPolicyMember.toJson());
            }
            policy.members = membersList;
          }

          // For Child Members
          if (_selectedRelationship!.toLowerCase() == "child") {
            AdditionalMember member = newMember;
            final policy =
                Constants.currentleadAvailable!.policies[current_member_index];
            final String? currentReference = policy.reference;
            final List<dynamic> membersList = policy.members ?? [];
            double cover = Constants
                    .currentleadAvailable!
                    .policies[current_member_index]
                    .quote
                    .sumAssuredFamilyCover ??
                0;

            final newPolicyMember = Member(
              null,
              null,
              null,
              currentReference,
              member.autoNumber,
              null,
              cover,
              "child",
              0,
              null,
              "",
              null,
              "",
              null,
              null,
              null,
              "",
              Constants.cec_client_id,
              Constants.cec_employeeid,
            );

            final existingIndex = membersList.indexWhere((m) {
              if (m is Map<String, dynamic>) {
                return (m['autoNumber'] == member.autoNumber) &&
                    (((m['type'] as String?)?.toLowerCase()) ?? '') ==
                        'child' &&
                    (m['reference'] == currentReference);
              } else if (m is Member) {
                return (m.autoNumber == member.autoNumber) &&
                    ((m.type ?? '').toLowerCase()) == 'child' &&
                    (m.reference == currentReference);
              }
              return false;
            });

            if (existingIndex != -1) {
              membersList[existingIndex] = newPolicyMember.toJson();
            } else {
              membersList.add(newPolicyMember.toJson());
            }
            policy.members = membersList;
          }

          // For Extended Members (e.g., sister, brother, etc.)
          if ([
            "sister",
            "brother",
            "aunt",
            "niece",
            "nephew",
            "adult child",
            "grandfather",
            "grandmother",
            "cousin",
            "uncle",
          ].contains(_selectedRelationship!.toLowerCase())) {
            AdditionalMember member = newMember;
            final policy =
                Constants.currentleadAvailable!.policies[current_member_index];
            final String? currentReference = policy.reference;
            final List<dynamic> membersList = policy.members ?? [];
            double cover = Constants
                    .currentleadAvailable!
                    .policies[current_member_index]
                    .quote
                    .sumAssuredFamilyCover ??
                0;

            // Build a new extended member object.
            final newPolicyMember = Member(
              null,
              null,
              null,
              currentReference,
              member.autoNumber,
              null,
              cover,
              "extended",
              0,
              null,
              "",
              null,
              "",
              null,
              null,
              null,
              "",
              Constants.cec_client_id,
              Constants.cec_employeeid,
            );

            // Find if an extended member with the same autoNumber and reference already exists.
            final existingIndex = membersList.indexWhere((m) {
              if (m is Map<String, dynamic>) {
                return (m['autoNumber'] == member.autoNumber) &&
                    ((m['type'] as String?)?.toLowerCase() == 'extended') &&
                    (m['reference'] == currentReference);
              } else if (m is Member) {
                return (m.autoNumber == member.autoNumber) &&
                    ((m.type ?? '').toLowerCase() == 'extended') &&
                    (m.reference == currentReference);
              }
              return false;
            });

            if (existingIndex != -1) {
              // Replace the existing extended member entry.
              membersList[existingIndex] = newPolicyMember.toJson();
            } else {
              // Otherwise, add the new extended member.
              membersList.add(newPolicyMember.toJson());
            }
            policy.members = membersList;
          }
        }

        needsAnalysisValueNotifier2.value++;
        mySalesPremiumCalculatorValue.value++;

        advancedMemberCardKey2 = UniqueKey();
        setState(() {});

        print("Member saved successfully2gg: ${canAddMember} $responseData");
        appBarMemberCardNotifier.value++;
        SalesService salesService = SalesService();
        salesService.updatePolicy(Constants.currentleadAvailable!, context);
      } else {
        print("Failed to save member: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> saveMemberOld(BuildContext context, canAddMember) async {
    //String baseUrl = Constants.insightsBackendUrl + "fieldV6/saveMember";
    String baseUrl = "${Constants.InsightsAdminbaseUrl}fieldV6/saveMember/";
    int onoloadId = Constants.currentleadAvailable!.leadObject.onololeadid;
    print("Base URL: $baseUrl");
    print("onoloadId: $onoloadId");

    try {
      // Prepare the request
      var headers = {'Content-Type': 'application/json'};

      Map<String, dynamic> payload = {
        "title": _selectedTitle ?? '',
        "name": CADNameController.text,
        "surname": CADSurnameController.text,
        "gender": _selectedGender ?? '',
        "dob": selectedDateOfBirth, // Ensure 'YYYY-MM-DD' format
        "age": (DateTime.now().year - DateTime.parse(selectedDateOfBirth!).year)
            .toString(),
        "relationship": _selectedRelationship!.toLowerCase().replaceAll(
              "self/payer",
              "self",
            ),
        "id": CADIDController.text,
        "contact": CADPhoneController.text,
        "onololeadid":
            onoloadId.toString(), // Ensure correct data type for the backend
        "source_of_income": _selectedIncome,
        "source_of_wealth": _selectedWealth,
        "other_unknown_income": CADIncomeDescriptionController.text,
        "other_unknown_wealth": CADWealthDescriptionController.text,
      };

      if (kDebugMode) {
        print("Payload: $payload");
      }

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
        if (canAddMember == true) {
          if (_selectedRelationship!.toLowerCase().toLowerCase() == "partner") {
            AdditionalMember member = newMember;

            // 1) Add this partner to the policy
            final policy =
                Constants.currentleadAvailable!.policies[current_member_index];
            final String? currentReference = policy.reference;
            final List<dynamic> membersList = policy.members ?? [];
            print("gfgggh1ggyygr ${member.autoNumber}");

            // Build a new partner Member
            final newPolicyMember = Member(
              null,
              // id, if not needed
              null,
              // pId
              null,
              // polId
              currentReference,
              member.autoNumber,
              null,
              // additional_member_id (if not needed)
              0,
              // premium (default 0)
              "partner",
              // type
              0,
              // percentage (or null if not used here)
              null,
              // any additional percentage field
              "",
              // coverMembersCol (if that’s your marker)
              null,
              // ben_relationship (if handled separately)
              "",
              // terminationDate? (example value)
              null,
              // updatedBy
              null,
              // memberQueryType
              null,
              // memberQueryTypeOldNew
              "",
              // memberQueryTypeOldAutoNumber
              Constants.cec_client_id,
              // cecClientId or empId (adjust accordingly)
              Constants.cec_employeeid,
              // cecClientId or empId (adjust accordingly)
            );

            // 2) Add it to membersList if not already present
            final existingIndex = membersList.indexWhere((m) {
              if (m is Map<String, dynamic>) {
                return (m['autoNumber'] == member.autoNumber) &&
                    (m['type'] as String?)?.toLowerCase() == 'partner' &&
                    m['reference'] == currentReference;
              } else if (m is Member) {
                return (m.autoNumber == member.autoNumber) &&
                    (m.type ?? '').toLowerCase() == 'partner' &&
                    m.reference == currentReference;
              }
              return false;
            });

            if (existingIndex != -1) {
              // Replace existing partner
              membersList[existingIndex] = newPolicyMember.toJson();
              if (canAddMember == true) {}

              // Replace in policiesSelectedPartners
              // if an entry already exists at this index
            } else {
              // Add new partner
              membersList.add(newPolicyMember.toJson());
            }

            policy.members = membersList;
          }

          if (_selectedRelationship!.toLowerCase() == "child") {
            // Ensure that we have the additional member and policy context.
            AdditionalMember member = newMember;
            final policy =
                Constants.currentleadAvailable!.policies[current_member_index];
            final String? currentReference = policy.reference;
            final List<dynamic> membersList = policy.members ?? [];

            // 1) Create a new policy 'child' Member object.
            final newPolicyMember = Member(
              null,
              // id, if not needed
              null,
              // pId
              null,
              // polId
              currentReference,
              member.autoNumber,
              null,
              // additional_member_id (if not needed)
              0,
              // premium (default 0)
              "child",
              // type
              0,
              // percentage (or null if not used here)
              null,
              // any additional percentage field
              "",
              // coverMembersCol (if that’s your marker)
              null,
              // ben_relationship (if handled separately)
              "",
              // terminationDate? (example value)
              null,
              // updatedBy
              null,
              // memberQueryType
              null,
              // memberQueryTypeOldNew
              "",
              // memberQueryTypeOldAutoNumber
              Constants.cec_client_id,
              // cecClientId or empId (adjust accordingly)
              Constants.cec_employeeid,
              // cecClientId or empId (adjust accordingly)
            );

            // 2) Update policy.members to include (or replace) this child.
            final existingIndex = membersList.indexWhere((m) {
              if (m is Map<String, dynamic>) {
                return (m['autoNumber'] == member.autoNumber) &&
                    (((m['type'] as String?)?.toLowerCase()) ?? '') ==
                        'child' &&
                    m['reference'] == currentReference;
              } else if (m is Member) {
                return (m.autoNumber == member.autoNumber) &&
                    ((m.type ?? '').toLowerCase()) == 'child' &&
                    m.reference == currentReference;
              }
              return false;
            });

            if (existingIndex != -1) {
              // Replace the existing child.
              membersList[existingIndex] = newPolicyMember.toJson();
            } else {
              // Otherwise, add the new child.
              membersList.add(newPolicyMember.toJson());
            }

            // Update the policy's members list.
            policy.members = membersList;
          }

          print("sakjaks1 ");

          if ([
            "sister",
            "brother",
            "aunt",
            "niece",
            "nephew",
            "adult child",
            "grandfather",
            "grandmother",
            "cousin",
            "uncle",
          ].contains(_selectedRelationship!.toLowerCase())) {
            print("sakjaks2 ");

            AdditionalMember member = newMember;
            final policy =
                Constants.currentleadAvailable!.policies[current_member_index];
            final String? currentReference = policy.reference;
            final List<dynamic> membersList = policy.members ?? [];

            // 1) Create a new policy 'extended' Member object.
            final newPolicyMember = Member(
              null,
              // id, if not needed
              null,
              // pId
              null,
              // polId
              currentReference,
              member.autoNumber,
              null,
              // additional_member_id (if not needed)
              0,
              // premium (default 0)
              "extended",
              // type
              0,
              // percentage (or null if not used here)
              null,
              // any additional percentage field
              "",
              // coverMembersCol (if that’s your marker)
              null,
              // ben_relationship (if handled separately)
              "",
              // terminationDate? (example value)
              null,
              // updatedBy
              null,
              // memberQueryType
              null,
              // memberQueryTypeOldNew
              "",
              // memberQueryTypeOldAutoNumber
              Constants.cec_client_id,
              // cecClientId or empId (adjust accordingly)
              Constants.cec_employeeid,
              // cecClientId or empId (adjust accordingly)
            );

            // 2) Update policy.members to include (or replace) this extended member.
            final existingIndex = membersList.indexWhere((m) {
              if (m is Map<String, dynamic>) {
                return (m['autoNumber'] == member.autoNumber) &&
                    ((m['type'] as String?)?.toLowerCase() == 'extended') &&
                    m['reference'] == currentReference;
              } else if (m is Member) {
                return (m.autoNumber == member.autoNumber) &&
                    ((m.type ?? '').toLowerCase() == 'extended') &&
                    m.reference == currentReference;
              }
              return false;
            });

            if (existingIndex != -1) {
              // Replace existing extended member.
              membersList[existingIndex] = newPolicyMember.toJson();
            } else {
              // Otherwise, add new extended member.
              membersList.add(newPolicyMember.toJson());
            }

            // Update the policy's members list.
            policy.members = membersList;
          }
        }

        needsAnalysisValueNotifier2.value++;
        mySalesPremiumCalculatorValue.value++;
        appBarMemberCardNotifier.value++;
        advancedMemberCardKey2 = UniqueKey();
        setState(() {});

        print("Member saved successfully2gg: $responseData");
      } else {
        print("Failed to save member: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> updateMemberOld(BuildContext context, int autoNumber) async {
    String baseUrl = "${Constants.insightsBackendBaseUrl}fieldV6/updateMember/";
    int onoloadId = Constants.currentleadAvailable!.leadObject.onololeadid;

    print("Base URL: $baseUrl");
    print("onoloadId: $onoloadId");
    print("AutoNumber to update: $autoNumber");

    try {
      // Prepare headers
      var headers = {'Content-Type': 'application/json'};

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
        "relationship": _selectedRelationship!.toLowerCase().replaceAll(
              "self/payer",
              "self",
            ),
        "id": CADIDController.text,
        "contact": CADPhoneController.text,
        "onololeadid": onoloadId.toString(),
        "source_of_income": _selectedIncome,
        "source_of_wealth": _selectedWealth,
        "other_unknown_income": CADIncomeDescriptionController.text,
        "other_unknown_wealth": CADWealthDescriptionController.text,
      };

      print("Payload for update: $payload");

      var request = http.Request('POST', Uri.parse(baseUrl));
      request.body = json.encode(payload);
      request.headers.addAll(headers);

      // Send the update request
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      print("Response body8f: $responseBody");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(responseBody);
        print(
            "Decoded response data: $responseData (type: ${responseData.runtimeType})");

        // Check for success - handle both string "1" and integer 1
        if (responseData == 1 ||
            responseData == "1" ||
            responseData.toString() == "1") {
          print("API update successful for autoNumber: $autoNumber");

          // Find the member by autoNumber and update the details
          int index = Constants.currentleadAvailable!.additionalMembers
              .indexWhere((member) => member.autoNumber == autoNumber);

          if (index != -1) {
            print("Found member at index: $index, updating local data...");

            // Update the existing member's details
            AdditionalMember oldMember =
                Constants.currentleadAvailable!.additionalMembers[index];

            AdditionalMember updatedMember = AdditionalMember(
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
              relationship: _selectedRelationship!.toLowerCase().replaceAll(
                    "self/payer",
                    "self",
                  ),
              mipCover: oldMember.mipCover,
              mipStatus: oldMember.mipStatus,
              updatedBy: oldMember.updatedBy,
              memberQueryType: oldMember.memberQueryType,
              memberQueryTypeOldNew: oldMember.memberQueryTypeOldNew,
              memberQueryTypeOldAutoNumber:
                  oldMember.memberQueryTypeOldAutoNumber,
              membersAutoNumber: oldMember.membersAutoNumber,
              sourceOfIncome: _selectedIncome ?? '',
              sourceOfWealth: _selectedWealth ?? '',
              otherUnknownIncome: CADIncomeDescriptionController.text,
              otherUnknownWealth: CADWealthDescriptionController.text,
              timestamp: oldMember.timestamp,
              lastUpdate: DateTime.now().toIso8601String(),
            );

            // Update the member in the list
            Constants.currentleadAvailable!.additionalMembers[index] =
                updatedMember;

            // Handle policy member creation if needed
            if (Constants.currentleadAvailable!
                .policies[widget.current_member_index].members.isEmpty) {
              print("Creating new policy member...");

              SalesService salesService = SalesService();
              mainMembers[widget.current_member_index] = updatedMember;

              final policy = Constants
                  .currentleadAvailable!.policies[current_member_index];
              final String? currentReference = policy.reference;

              final newPolicyMember = Member(
                null, // id
                null, // policy_id
                null, // polId
                currentReference, // reference
                updatedMember.autoNumber, // auto_number
                null, // additional_member_id
                0, // premium
                "main_member", // type
                0, // percentage
                null, // additional percentage field
                "", // coverMembersCol
                null, // ben_relationship
                "", // terminationDate
                null, // updatedBy
                null, // memberQueryType
                null, // memberQueryTypeOldNew
                "", // memberQueryTypeOldAutoNumber
                Constants.cec_client_id, // cecClientId
                Constants.cec_employeeid, // empId
              );

              Constants
                  .currentleadAvailable!.policies[current_member_index].members
                  .add(newPolicyMember.toJson());

              // Update DOB list safely
              if (widget.current_member_index >=
                  policiesSelectedMainInsuredDOBs.length) {
                policiesSelectedMainInsuredDOBs.add(
                  Constants.formatter.format(DateTime.parse(updatedMember.dob)),
                );
              } else {
                policiesSelectedMainInsuredDOBs[widget.current_member_index] =
                    Constants.formatter
                        .format(DateTime.parse(updatedMember.dob));
              }

              // Create new policy
              await salesService.createNewPolicy(
                leadId: Constants.currentleadAvailable!.leadObject.onololeadid,
                additionalMemberId: updatedMember.autoNumber,
                productType:
                    policiesSelectedProducts[widget.current_member_index],
                reference: Constants.currentleadAvailable!
                    .policies[widget.current_member_index].reference,
                productFamily:
                    policiesSelectedProdTypes[widget.current_member_index!],
                clientId: Constants.cec_client_id,
              );
            }

            // Update main members list if this member is in it
            int mainMemberIndex = mainMembers.indexWhere(
              (member) => member.autoNumber == autoNumber,
            );

            print("Main member index: $mainMemberIndex");

            if (mainMemberIndex != -1) {
              print("Updating main member at index: $mainMemberIndex");
              mainMembers[mainMemberIndex] = updatedMember;
            }

            // Notify UI to refresh
            needsAnalysisValueNotifier2.value++;
            mySalesPremiumCalculatorValue.value++;

            print("Member updated successfully in local data");
          } else {
            print(
                "Warning: Member with autoNumber $autoNumber not found in local additionalMembers list");
            print(
                "Available autoNumbers: ${Constants.currentleadAvailable!.additionalMembers.map((m) => m.autoNumber).toList()}");

            // Optionally, you might want to reload the data from the server
            // or handle this case differently based on your app's requirements
          }
        } else {
          print("API returned unsuccessful response: $responseData");
        }
      } else {
        print(
            "Failed to update member: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error occurred while updating member: $e");
      // You might want to show a user-friendly error message here
    }
  }

  Future<void> updateMember(BuildContext context, int autoNumber) async {
    String baseUrl = "${Constants.insightsBackendBaseUrl}fieldV6/updateMember/";
    int onoloadId = Constants.currentleadAvailable!.leadObject.onololeadid;

    print("Base URL: $baseUrl");
    print("onoloadId: $onoloadId");
    print("AutoNumber to update: $autoNumber");

    try {
      // Prepare headers
      var headers = {'Content-Type': 'application/json'};

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
        "relationship": _selectedRelationship!.toLowerCase().replaceAll(
              "self/payer",
              "self",
            ),
        "id": CADIDController.text,
        "contact": CADPhoneController.text,
        "onololeadid": onoloadId.toString(),
        "source_of_income": _selectedIncome,
        "source_of_wealth": _selectedWealth,
        "other_unknown_income": CADIncomeDescriptionController.text,
        "other_unknown_wealth": CADWealthDescriptionController.text,
      };

      print("Payload for update: $payload");

      var request = http.Request('POST', Uri.parse(baseUrl));
      request.body = json.encode(payload);
      request.headers.addAll(headers);

      // Send the update request
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      print("Response body8f: $responseBody");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(responseBody);
        print(
            "Decoded response data: $responseData (type: ${responseData.runtimeType})");

        // Check for success - handle both string "1" and integer 1
        if (responseData == 1 ||
            responseData == "1" ||
            responseData.toString() == "1") {
          print("API update successful for autoNumber: $autoNumber");

          // Find the member by autoNumber and update the details
          int index = Constants.currentleadAvailable!.additionalMembers
              .indexWhere((member) => member.autoNumber == autoNumber);

          if (index != -1) {
            print("Found member at index: $index, updating local data...");

            // Update the existing member's details
            AdditionalMember oldMember =
                Constants.currentleadAvailable!.additionalMembers[index];

            AdditionalMember updatedMember = AdditionalMember(
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
              relationship: _selectedRelationship!.toLowerCase().replaceAll(
                    "self/payer",
                    "self",
                  ),
              mipCover: oldMember.mipCover,
              mipStatus: oldMember.mipStatus,
              updatedBy: oldMember.updatedBy,
              memberQueryType: oldMember.memberQueryType,
              memberQueryTypeOldNew: oldMember.memberQueryTypeOldNew,
              memberQueryTypeOldAutoNumber:
                  oldMember.memberQueryTypeOldAutoNumber,
              membersAutoNumber: oldMember.membersAutoNumber,
              sourceOfIncome: _selectedIncome ?? '',
              sourceOfWealth: _selectedWealth ?? '',
              otherUnknownIncome: CADIncomeDescriptionController.text,
              otherUnknownWealth: CADWealthDescriptionController.text,
              timestamp: oldMember.timestamp,
              lastUpdate: DateTime.now().toIso8601String(),
            );
            print("hhgghgh ${_selectedWealth} ${_selectedIncome}");

            // Update the member in the list
            Constants.currentleadAvailable!.additionalMembers[index] =
                updatedMember;

            // UPDATE POLICY MEMBERS - Find and update all policy members with matching additional_member_id
            print(
                "Updating policy members with additional_member_id: $autoNumber");

            for (int policyIndex = 0;
                policyIndex < Constants.currentleadAvailable!.policies.length;
                policyIndex++) {
              final policy =
                  Constants.currentleadAvailable!.policies[policyIndex];

              if (policy.members != null && policy.members!.isNotEmpty) {
                for (int memberIndex = 0;
                    memberIndex < policy.members!.length;
                    memberIndex++) {
                  var policyMember = policy.members![memberIndex];

                  // Check if this policy member matches the updated additional member
                  bool shouldUpdate = false;
                  if (policyMember is Map<String, dynamic>) {
                    int? additionalMemberId =
                        policyMember['additional_member_id'] as int?;
                    if (additionalMemberId == autoNumber) {
                      shouldUpdate = true;
                    }
                  } else if (policyMember is Member) {
                    if (policyMember.autoNumber == autoNumber) {
                      shouldUpdate = true;
                    }
                  }

                  if (shouldUpdate) {
                    print(
                        "Updating policy member in policy ${policy.reference} at index $memberIndex");

                    // Create updated policy member data
                    Map<String, dynamic> updatedPolicyMemberData;

                    if (policyMember is Map<String, dynamic>) {
                      // Update existing map data
                      updatedPolicyMemberData =
                          Map<String, dynamic>.from(policyMember);
                    } else if (policyMember is Member) {
                      // Convert Member to map first
                      updatedPolicyMemberData = policyMember.toJson();
                    } else {
                      // Create new map if unknown type
                      updatedPolicyMemberData = <String, dynamic>{};
                    }

                    // Update the policy member data with new information
                    // Note: Only update fields that are relevant to policy members
                    // You may need to adjust these fields based on your Member class structure
                    updatedPolicyMemberData['additional_member_id'] =
                        autoNumber;
                    updatedPolicyMemberData['last_update'] =
                        DateTime.now().toIso8601String();

                    // Update the policy member in the list
                    policy.members![memberIndex] = updatedPolicyMemberData;

                    print(
                        "Successfully updated policy member in policy ${policy.reference}");
                  }
                }
              }
            }

            // Handle policy member creation if needed
            if (Constants.currentleadAvailable!
                .policies[widget.current_member_index].members.isEmpty) {
              print("Creating new policy member...");

              SalesService salesService = SalesService();
              mainMembers[widget.current_member_index] = updatedMember;

              final policy = Constants
                  .currentleadAvailable!.policies[current_member_index];
              final String? currentReference = policy.reference;

              final newPolicyMember = Member(
                null, // id
                null, // policy_id
                null, // polId
                currentReference, // reference
                updatedMember.autoNumber, // auto_number
                null, // additional_member_id
                0, // premium
                "main_member", // type
                0, // percentage
                null, // additional percentage field
                "", // coverMembersCol
                null, // ben_relationship
                "", // terminationDate
                null, // updatedBy
                null, // memberQueryType
                null, // memberQueryTypeOldNew
                "", // memberQueryTypeOldAutoNumber
                Constants.cec_client_id, // cecClientId
                Constants.cec_employeeid, // empId
              );

              Constants
                  .currentleadAvailable!.policies[current_member_index].members
                  .add(newPolicyMember.toJson());

              // Update DOB list safely
              if (widget.current_member_index >=
                  policiesSelectedMainInsuredDOBs.length) {
                policiesSelectedMainInsuredDOBs.add(
                  Constants.formatter.format(DateTime.parse(updatedMember.dob)),
                );
              } else {
                policiesSelectedMainInsuredDOBs[widget.current_member_index] =
                    Constants.formatter
                        .format(DateTime.parse(updatedMember.dob));
              }

              // Create new policy
              await salesService.createNewPolicy(
                leadId: Constants.currentleadAvailable!.leadObject.onololeadid,
                additionalMemberId: updatedMember.autoNumber,
                productType:
                    policiesSelectedProducts[widget.current_member_index],
                reference: Constants.currentleadAvailable!
                    .policies[widget.current_member_index].reference,
                productFamily:
                    policiesSelectedProdTypes[widget.current_member_index!],
                clientId: Constants.cec_client_id,
              );
            }

            // Update main members list if this member is in it
            int mainMemberIndex = mainMembers.indexWhere(
              (member) => member.autoNumber == autoNumber,
            );

            print("Main member index: $mainMemberIndex");

            if (mainMemberIndex != -1) {
              print("Updating main member at index: $mainMemberIndex");
              mainMembers[mainMemberIndex] = updatedMember;
            }

            // Notify UI to refresh
            needsAnalysisValueNotifier2.value++;
            mySalesPremiumCalculatorValue.value++;

            print(
                "Member and related policy members updated successfully in local data");
          } else {
            print(
                "Warning: Member with autoNumber $autoNumber not found in local additionalMembers list");
            print(
                "Available autoNumbers: ${Constants.currentleadAvailable!.additionalMembers.map((m) => m.autoNumber).toList()}");

            // Optionally, you might want to reload the data from the server
            // or handle this case differently based on your app's requirements
          }
        } else {
          print("API returned unsuccessful response: $responseData");
        }
      } else {
        print(
            "Failed to update member: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error occurred while updating member: $e");
      // You might want to show a user-friendly error message here
    }
  }

  bool isValidDate(String? dob) {
    if (dob == null || dob.isEmpty) return false;
    try {
      DateTime parsedDate = DateTime.parse(dob);
      DateTime today = DateTime.now();
      int age = today.year - parsedDate.year;

      if (parsedDate.isAfter(today)) return false; // Future DOB not allowed
      if (age < 18 || age > 120) return false; // Age limits

      return true;
    } catch (e) {
      return false; // Invalid date format
    }
  }

  bool isValidMemberIndex(int index, List members) {
    return index >= 0 && index < members.length;
  }

  List<DropdownMenuItem<String>> _buildRelationshipItems() {
    // Start with a single "Self/Payer" item.
    List<DropdownMenuItem<String>> items = [
      const DropdownMenuItem<String>(
        value: "Self/Payer",
        child: Text(
          "Self/Payer",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'YuGothic',
            color: Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ];

    // Create a set to track already added values (case-insensitive)
    Set<String> addedValues = {"Self/Payer".toLowerCase()};

    // Then add the rest from tempRelationshipList, excluding duplicates and self variants
    for (String item in tempRelationshipList) {
      String lowerItem = item.toLowerCase();

      // Skip if it's a self variant or already added
      if (lowerItem == "self" ||
          lowerItem == "self/payer" ||
          addedValues.contains(lowerItem)) {
        continue;
      }

      // Add to our tracking set
      addedValues.add(lowerItem);

      // Add the dropdown item with original casing
      items.add(
        DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'YuGothic',
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    return items;
  }

  // Helper method to normalize relationship values
  String _normalizeRelationship(String relationship) {
    if (relationship.toLowerCase() == "self" ||
        relationship.toLowerCase() == "self/payer") {
      return "Self/Payer";
    }

    // Check if there's a case-insensitive match in tempRelationshipList
    for (String item in tempRelationshipList) {
      if (item.toLowerCase() == relationship.toLowerCase()) {
        return item; // Return the properly cased version from the list
      }
    }

    // If not found, add it to the list and return it
    if (!tempRelationshipList.contains(relationship)) {
      tempRelationshipList.add(relationship);
    }

    return relationship;
  }

  bool validateGenderAndTitle(String? selectedGender, String? selectedTitle) {
    if (selectedTitle == null || selectedTitle.isEmpty) {
      return false; // Not returning an error, but you could if you prefer
    }
    if (selectedGender == null || selectedGender.isEmpty) {
      return false; // Same note as above
    }

    final genderLower = selectedGender.toLowerCase();

    // Title "Mr" => must be "male"
    if (selectedTitle == 'Mr' && genderLower != 'male') {
      return true; // mismatch => validation fails
    }

    // Titles "Mrs", "Ms", "Miss" => must be "female"
    if ((selectedTitle == 'Mrs' ||
            selectedTitle == 'Ms' ||
            selectedTitle == 'Miss') &&
        genderLower != 'female') {
      return true; // mismatch => validation fails
    }

    // If we reach here, no mismatch found
    return false;
  }

  /// Validates if the selected title matches the selected gender and returns a specific
  /// error message if a mismatch is found.
  ///
  /// Args:
  ///   selectedGender (String?): The selected gender (e.g., "male", "female").
  ///   selectedTitle (String?): The selected title (e.g., "Mr", "Mrs", "Ms").
  ///
  /// Returns:
  ///   String?: A specific error message if a mismatch is found, otherwise null.
  String? getGenderTitleMismatchMessage(
      String? selectedGender, String? selectedTitle) {
    // If either gender or title is not selected, we don't consider it a mismatch yet.
    if (selectedGender == null || selectedTitle == null) {
      return null;
    }

    final genderLower = selectedGender.toLowerCase();

    // Title "Mr" => must be "male"
    if (selectedTitle == 'Mr' && genderLower != 'male') {
      // Return the specific message format you requested
      return 'Gender title mismatch, the title is "Mr" but the gender is not "male"';
    }

    // Titles "Mrs", "Ms", "Miss" => must be "female"
    if ((selectedTitle == 'Mrs' ||
            selectedTitle == 'Ms' ||
            selectedTitle == 'Miss') &&
        genderLower != 'female') {
      // Return a specific message for female titles
      return 'Gender title mismatch, the title is "$selectedTitle" but the gender is not "female"';
    }

    // If we reach here, no mismatch found
    return null;
  }
}

int calculateAge(DateTime birthDate) {
  final today = DateTime.now();
  int age = today.year - birthDate.year;
  // Subtract 1 if today is before the user's birthday in the current year
  if (today.month < birthDate.month ||
      (today.month == birthDate.month && today.day < birthDate.day)) {
    age--;
  }
  return age;
}

String getGenderFromSouthAfricanId(String id) {
  // Validate that the ID is exactly 13 digits long
  if (id.length != 13) {}

  // Extract the gender digits (7th to 10th digits, using 0-based indexing)
  final genderDigits = id.substring(6, 10);

  // Convert the extracted substring to an integer
  final genderValue = int.tryParse(genderDigits);
  if (genderValue == null) {
    throw ArgumentError("Invalid ID: Gender digits are not numeric.");
  }

  // Return "Female" if the number is less than 5000, otherwise "Male"
  return genderValue < 5000 ? "Female" : "Male";
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
        "${Constants.insightsBaseUrl}indexed/client1/files/indexing/SaveFieldForm_${leadId}_$i$extension"
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
