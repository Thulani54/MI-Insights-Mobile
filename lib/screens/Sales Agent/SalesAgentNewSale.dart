import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mi_insights/constants/Constants.dart';
import 'package:mi_insights/customwidgets/custom_input.dart';
import 'package:mi_insights/services/inactivitylogoutmixin.dart';
import 'package:mime/mime.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

import '../../../models/Product.dart';
import '../../../models/SalesAgentModel.dart';
import '../../../services/MyNoyifier.dart';
import '../../models/map_class.dart';
import '../../models/Lead.dart';
import 'FieldSalesAffinity.dart';
import 'manual_dial.dart';

final newsaleValue = ValueNotifier<int>(0);
MyNotifier? myNotifier;
List<PlatformFile> _files = [];

class SalesAgentNewSale extends StatefulWidget {
  const SalesAgentNewSale({super.key});

  @override
  State<SalesAgentNewSale> createState() => _SalesAgentNewSaleState();
}

class _SalesAgentNewSaleState extends State<SalesAgentNewSale>
    with InactivityLogoutMixin {
  // List<ParlourRatesExtras> all_parlour_rates = [
  //   ParlourRatesExtras("-1", "Select Product", "", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  //       0, "", "", true)
  // ];
  List<ParlourRatesExtras2a> displayed_parlour_rates = [
    ParlourRatesExtras2a(
      "Select Product",
      "",
    )
  ];
  SalesAgentModel? selected_agent;
  List<SalesAgentModel> all_sales_agents = [];
  List<SalesAgentModel> filteredSalesAgents = [];
  String title = "Mr";
  List<String> titles = ["Mr", "Ms", "Mrs", "Miss"];

  ParlourRatesExtras3 _selectedProduct = ParlourRatesExtras3(
      "-1", "Select", "Product", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "", "", true);
  ParlourRatesExtras2a? _selectedDisplayedProduct;
  TextEditingController phone_number_controller = TextEditingController();
  TextEditingController name_controller = TextEditingController();
  TextEditingController surname_controller = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController _salesAgentController = TextEditingController();
  String agent_sale_date = "Select Date";
  SalesAgentModel? selectedSalesAgent;
  FocusNode phone_number_focus_node = FocusNode();
  FocusNode name_focus_node = FocusNode();
  FocusNode surname_focus_node = FocusNode();
  FocusNode sales_agent_focus_node = FocusNode();
  bool isLoading = false;

  // Animated toggle variables for Field Sale / Paperless Sale
  double _sliderPosition = 0.0;
  int sale_type_index = 0;

  void _animateSaleTypeButton(int index) {
    setState(() {
      sale_type_index = index;
      _sliderPosition =
          index == 0 ? 0.0 : (MediaQuery.of(context).size.width / 2) - 16;
      Constants.fieldSaleType = index == 0 ? "Field Sale" : "Paperless Sale";
      salesFieldAffinityValue.value++;
    });
  }

  void _pickAndConvertFiles(bool allowMultiple) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'], // Allow images and PDF
    );

    if (result != null) {
      for (var platformFile in result.files) {
        // Check if the file is an image and not already a PNG
        if (_isImage(platformFile) && !_isPNG(platformFile)) {
          // Convert to PNG and create a new PlatformFile
          XFile? convertedFile = await _convertToPNG(platformFile);
          if (convertedFile != null) {
            final newPlatformFile = PlatformFile(
              name: convertedFile.path.split('/').last,
              path: convertedFile.path,
              size: await convertedFile.length(),
              // Add additional fields as necessary
            );
            setState(() {
              _files.add(newPlatformFile);
            });
          }
          print("file was converted ${_files.length}");
        } else {
          // If it's not an image that needs conversion or it's a PDF, add it directly
          setState(() {
            _files.add(platformFile);
          });
        }
      }
    }
  }

  _captureImageWithCamera() async {
    final ImagePicker _picker = ImagePicker();
    // Capture an image
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      // Create a PlatformFile from the captured image for consistency with your existing setup
      final capturedImageFile = PlatformFile(
        name: image.path.split('/').last,
        path: image.path,
        size: await image.length(),
        // Add additional fields as necessary
      );
      setState(() {
        _files.add(capturedImageFile); // Add the captured image to your list
      });
    }
  }

  Future<void> _attachCombinedImages2() async {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => CombinedImageSelector()))
        .then((_) {});
  }

  bool _isImage(PlatformFile file) {
    final mimeType = lookupMimeType(file.path!);
    return mimeType != null && mimeType.startsWith('image/');
  }

  bool _isPNG(PlatformFile file) {
    return path.extension(file.path!).toLowerCase() == '.png';
  }

  Future<XFile?> _convertToPNG(PlatformFile file) async {
    final directory = await getTemporaryDirectory();
    final targetPath = path.join(
        directory.path, '${path.basenameWithoutExtension(file.path!)}.png');
    File originalFile = File(file.path!);

    var result = await FlutterImageCompress.compressAndGetFile(
      originalFile.absolute.path,
      targetPath,
      format: CompressFormat.png,
    );

    return result;
  }

  void _removeFile(int index) {
    print("Removing file at index: $index");
    setState(() {
      _files.removeAt(index);
    });
    newsaleValue.value++;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("NEW LEAD"),
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black.withOpacity(0.6),
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
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 16, top: 24, bottom: 0),
                child: Row(
                  children: [
                    Text(
                      "Phone Number",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomInputTransparent4(
                          controller: phone_number_controller,
                          hintText: "Phone Number",
                          onChanged: (val) {
                            startInactivityTimer();
                          },
                          onSubmitted: (val) {},
                          focusNode: phone_number_focus_node,
                          textInputAction: TextInputAction.next,
                          integersOnly: true,
                          maxLines: 10,
                          isPasswordField: false),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 16, top: 20, bottom: 8),
                child: Row(
                  children: [
                    Text(
                      "Agent Sale Date",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  startInactivityTimer();
                  final ThemeData datePickerTheme = ThemeData(
                    colorScheme: ColorScheme.light(
                      background: Colors.white,
                      surfaceTint: Colors.white,
                      primary: Constants
                          .ctaColorLight, // Influences the selected date background but also affects the header
                      onPrimary: Colors
                          .black, // Ensures header text is visible against a lighter header background
                      onSurface: Colors.black,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: Constants.ctaColorLight,
                      ),
                    ),
                  );

                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: datePickerTheme,
                        child: child!,
                      );
                    },
                  );

                  if (pickedDate != null) {
                    startInactivityTimer();
                    agent_sale_date =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {});
                    print(pickedDate.toString());
                  } else {
                    startInactivityTimer();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.75)),
                      borderRadius: BorderRadius.circular(360)),
                  margin: const EdgeInsets.only(
                      left: 18.0, right: 16, top: 0, bottom: 12),
                  height: 48,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(agent_sale_date),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 16, top: 8, bottom: 8),
                child: Row(
                  children: [
                    Text(
                      "Product",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 0, right: 16),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.75)),
                      borderRadius: BorderRadius.circular(36)),
                  child: DropdownButton<ParlourRatesExtras2a?>(
                    isExpanded: true,
                    value: _selectedDisplayedProduct,
                    onChanged: (ParlourRatesExtras2a? newValue) {
                      startInactivityTimer();
                      setState(() {
                        _selectedDisplayedProduct = newValue!;
                      });
                    },
                    hint: Padding(
                      padding: const EdgeInsets.only(top: 0.0, left: 12),
                      child: Text(
                        "Select a Product",
                        style: TextStyle(
                          color: Colors.grey, // Hint text color
                        ),
                      ),
                    ),
                    selectedItemBuilder: (BuildContext context) {
                      return displayed_parlour_rates
                          .map<Widget>((ParlourRatesExtras2a item) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 16.0, left: 12),
                          child: Text(
                            "${item.product} - ${item.prod_type}".replaceAll(
                                "Select Product - ", "Select a Product"),
                            style: TextStyle(
                                color: Colors.black), // Adjust color as needed
                          ),
                        );
                      }).toList();
                    },

                    items: displayed_parlour_rates
                        .map<DropdownMenuItem<ParlourRatesExtras2a>>(
                            (ParlourRatesExtras2a product) {
                      return DropdownMenuItem<ParlourRatesExtras2a>(
                        value: product,
                        child: Text(
                          "${product.product} - ${product.prod_type}"
                              .replaceAll(
                                  "Select Product - ", "Select a product"),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.black, // Dropdown items text color
                          ),
                        ),
                      );
                    }).toList(),
                    underline: Container(), // Removes underline if not needed
                    dropdownColor: Colors.white, // Dropdown background color
                    style: TextStyle(
                      color: Colors
                          .white, // This sets the selected item text color
                    ),
                    iconEnabledColor:
                        Colors.white, // Changes the dropdown icon color
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 16, top: 24, bottom: 8),
                child: Row(
                  children: [
                    Text(
                      "Title",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 0, right: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 0.0, right: 0, top: 0, bottom: 0),
                            child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(36),
                                      topRight: Radius.circular(36),
                                      bottomLeft: Radius.circular(36),
                                      bottomRight: Radius.circular(36)),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(36),
                                        topRight: Radius.circular(36),
                                        bottomLeft: Radius.circular(36),
                                        bottomRight: Radius.circular(36)),
                                  ),

                                  // dropdown below..
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                        canvasColor: Colors.white,
                                        focusColor: Colors.white),
                                    child: DropdownButton<String>(
                                      borderRadius: BorderRadius.circular(3.0),
                                      value: title,
                                      isExpanded: true,
                                      focusNode: null,
                                      focusColor: Colors.transparent,

                                      hint: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Text(
                                          "Select a option",
                                          style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 13.5,
                                                color: Colors.black,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                      onChanged: (String? newValue) {
                                        setState(() => title = newValue!);
                                      },
                                      items: titles
                                          .map<DropdownMenuItem<String>>((String
                                                  value) =>
                                              DropdownMenuItem<String>(
                                                value: value,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(
                                                    value,
                                                    style: GoogleFonts.inter(
                                                      textStyle: TextStyle(
                                                          fontSize: 13.5,
                                                          color: Colors.black,
                                                          letterSpacing: 0,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ),
                                                ),
                                              ))
                                          .toList(),

                                      // add extra sugar..
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 42,
                                      underline: SizedBox(),
                                    ),
                                  ),
                                ))),
                      ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 16, top: 24, bottom: 4),
                child: Row(
                  children: [
                    Text(
                      "Name",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomInputTransparent4(
                          controller: name_controller,
                          hintText: "Name",
                          onChanged: (val) {
                            startInactivityTimer();
                          },
                          onSubmitted: (val) {},
                          focusNode: name_focus_node,
                          textInputAction: TextInputAction.next,
                          isPasswordField: false),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 16, top: 24, bottom: 4),
                child: Row(
                  children: [
                    Text(
                      "Surname",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomInputTransparent4(
                          controller: surname_controller,
                          hintText: "Surname",
                          onChanged: (val) {
                            startInactivityTimer();
                          },
                          onSubmitted: (val) {},
                          focusNode: surname_focus_node,
                          textInputAction: TextInputAction.next,
                          isPasswordField: false),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 16, top: 24, bottom: 4),
                child: Row(
                  children: [
                    Text(
                      "Select an Agent",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: CustomInputTransparent4(
                  controller: _salesAgentController,
                  hintText: 'Search an Agent',
                  onChanged: (val) {
                    startInactivityTimer();
                    String searchTerm = val.toLowerCase();

                    filteredSalesAgents = all_sales_agents.where((agent) {
                      return agent.employeeName
                          .toLowerCase()
                          .contains(searchTerm);
                    }).toList();

                    if (filteredSalesAgents.length > 5) {
                      filteredSalesAgents = filteredSalesAgents.sublist(0, 5);
                    }

                    // Update the UI
                    setState(() {});
                  },
                  onSubmitted: (val) {},
                  focusNode: sales_agent_focus_node,
                  textInputAction: TextInputAction.next,
                  isPasswordField: false,
                ),
              ),
              selectedSalesAgent != null &&
                      selectedSalesAgent!.employeeName.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 4.0, right: 4, top: 12, bottom: 12),
                      child: Text(
                        "Selected Agent: " +
                            selectedSalesAgent!.employeeName +
                            " " +
                            selectedSalesAgent!.employeeSurname,
                        style: TextStyle(
                            color: Constants.ctaColorLight,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : Container(),
              if (filteredSalesAgents.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16, top: 12),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: all_sales_agents.length > 0
                              ? Colors.grey.withOpacity(0.15)
                              : Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          itemCount: filteredSalesAgents.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                startInactivityTimer();
                                if (kDebugMode) {
                                  print(
                                      "Selected Agent: ${filteredSalesAgents[index].employeeName}");
                                }
                                selected_agent = filteredSalesAgents[index];
                                selectedSalesAgent = filteredSalesAgents[index];
                                _salesAgentController.text =
                                    "${selectedSalesAgent!.employeeName} ${selectedSalesAgent!.employeeSurname}";
                                filteredSalesAgents = [];
                                isLoading = false;
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Container(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          filteredSalesAgents[index]
                                                  .employeeName +
                                              " " +
                                              filteredSalesAgents[index]
                                                  .employeeSurname,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )),
                                    ),
                                    if (filteredSalesAgents.length != index + 1)
                                      Divider(
                                        color: Colors.grey.withOpacity(0.15),
                                      )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(12)),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _animateSaleTypeButton(0);
                                },
                                child: Container(
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          16,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(360)),
                                  height: 35,
                                  child: Center(
                                    child: Text(
                                      'Field Sale',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _animateSaleTypeButton(1);
                                },
                                child: Container(
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          16,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(360)),
                                  child: Center(
                                    child: Text(
                                      'Paperless Sale',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        left: _sliderPosition,
                        child: Container(
                            width: (MediaQuery.of(context).size.width / 2) - 16,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Constants.ctaColorLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: sale_type_index == 0
                                ? Center(
                                    child: Text(
                                      'Field Sale',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      'Paperless Sale',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (Constants.fieldSaleType != "Paperless Sale")
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 16, top: 16, bottom: 0),
                    child: Text(
                      "ATTACH DOCUMENTS",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              if (Constants.fieldSaleType != "Paperless Sale")
                Container(
                  height: 200, // Adjust the height if necessary
                  child: DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      body: Column(
                        children: [
                          PreferredSize(
                            preferredSize: Size.fromHeight(
                                kToolbarHeight), // Standard AppBar height
                            child: Material(
                              color: Colors.white, // AppBar background color
                              child: TabBar(
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicatorPadding:
                                    const EdgeInsets.only(left: 44, right: 44),
                                indicator: UnderlineTabIndicator(
                                    borderSide: BorderSide(
                                      width: 10.0,
                                      color: Constants.ctaColorLight,
                                    ),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16)),
                                    insets:
                                        EdgeInsets.symmetric(horizontal: 0.0)),
                                indicatorColor: Constants.ctaColorLight,
                                indicatorWeight: 8.0,
                                padding: EdgeInsets.zero,
                                labelPadding: EdgeInsets.zero,
                                tabs: const [
                                  Tab(
                                    iconMargin: EdgeInsets.only(bottom: 0.0),
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        "Single",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    iconMargin: EdgeInsets.only(top: 0.0),
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        "Combined",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                Column(
                                  children: [
                                    if (Constants.fieldSaleType !=
                                        "Paperless Sale") ...[
                                      SizedBox(height: 24),
                                      GestureDetector(
                                        onTap: () async {
                                          startInactivityTimer();
                                          _pickAndConvertFiles(false);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.75)),
                                              borderRadius:
                                                  BorderRadius.circular(36)),
                                          margin: const EdgeInsets.only(
                                              left: 18.0,
                                              right: 16,
                                              top: 0,
                                              bottom: 0),
                                          height: 44,
                                          child: Center(
                                            child: Text(
                                              "Attach a Document",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      Constants.ctaColorLight),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    if (Constants.fieldSaleType !=
                                        "Paperless Sale") ...[
                                      SizedBox(height: 16),
                                      GestureDetector(
                                        onTap: () async {
                                          startInactivityTimer();
                                          await _captureImageWithCamera();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.75)),
                                            borderRadius:
                                                BorderRadius.circular(36),
                                          ),
                                          margin: const EdgeInsets.only(
                                              left: 18.0,
                                              right: 16,
                                              top: 0,
                                              bottom: 0),
                                          height: 44,
                                          child: Center(
                                            child: Text(
                                              "Capture an Image",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      Constants.ctaColorLight),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                // Only show attach documents section for Field Sale
                                if (Constants.fieldSaleType != "Paperless Sale")
                                  Column(
                                    children: [
                                      SizedBox(height: 24),
                                      GestureDetector(
                                        onTap: () async {
                                          startInactivityTimer();
                                          _pickAndConvertFiles(true);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.75)),
                                              borderRadius:
                                                  BorderRadius.circular(36)),
                                          margin: const EdgeInsets.only(
                                              left: 18.0,
                                              right: 16,
                                              top: 0,
                                              bottom: 0),
                                          height: 44,
                                          child: Center(
                                            child: Text(
                                              "Attach Combined Documents",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      Constants.ctaColorLight),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      GestureDetector(
                                        onTap: () async {
                                          startInactivityTimer();
                                          await _attachCombinedImages2();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.75)),
                                            borderRadius:
                                                BorderRadius.circular(36),
                                          ),
                                          margin: const EdgeInsets.only(
                                              left: 18.0,
                                              right: 16,
                                              top: 0,
                                              bottom: 0),
                                          height: 44,
                                          child: Center(
                                            child: Text(
                                              "Capture Combined Images",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      Constants.ctaColorLight),
                                            ),
                                          ),
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
                  ),
                ),
              if (_files.length > 0 &&
                  Constants.fieldSaleType != "Paperless Sale")
                SizedBox(
                  height: 16,
                ),
              if (_files.length > 0 &&
                  Constants.fieldSaleType != "Paperless Sale")
                Row(
                  children: [
                    Spacer(),
                    Text(
                      _files.length == 1
                          ? "1 Document Added"
                          : "${_files.length} Documents Added",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Constants.ctaColorLight),
                    ),
                    SizedBox(
                      width: 32,
                    )
                  ],
                ),
              SizedBox(
                height: 12,
              ),
              if (_files.length > 0 &&
                  Constants.fieldSaleType != "Paperless Sale")
                Container(
                  // height: _files.length * 60,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 24, right: 16.0, top: 8),
                    child: ListView.builder(
                      itemCount: _files.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final file = _files[index];
                        Widget? thumbnail;

                        if (file.extension == 'jpg' ||
                            file.extension == 'png' ||
                            file.extension == 'jpeg') {
                          thumbnail = Image.file(
                            File(file.path!),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          );
                        } else if (file.extension == 'pdf') {
                          thumbnail = Icon(CupertinoIcons.doc);
                        } else {
                          // Placeholder for non-image files
                          thumbnail = Icon(Icons.file_present);
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.45)),
                              child: InkWell(
                                onTap: () {
                                  if (file.extension == 'jpg' ||
                                      file.extension == 'png' ||
                                      file.extension == 'jpeg') {
                                    // Navigate to the image preview page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ImagePreviewPage(
                                            imagePath: file.path!),
                                      ),
                                    );
                                  }
                                },
                                child: thumbnail,
                              ),
                            ),
                            title: Text(
                              file.name,
                              style: TextStyle(fontSize: 13.5),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _removeFile(index),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 18.0, right: 16, top: 0, bottom: 12),
                child: Row(
                  children: [
                    Text(
                      "Comments",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.75)),
                      borderRadius: BorderRadius.circular(8)),
                  child: MultiLineTextField(
                    maxLines: 5,
                    label: 'Add Comments',
                    //   focusNode: _descriptionFocusNode,
                    controller: notesController,
                    bordercolor: Colors.transparent,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (name_controller.text.isEmpty) {
                    MotionToast.error(
                      height: 45,
                      onClose: () {},
                      description: const Text(
                        "Please enter a name.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ).show(context);
                  } else if (surname_controller.text.isEmpty) {
                    MotionToast.error(
                      height: 45,
                      onClose: () {},
                      description: const Text(
                        "Please enter a surname.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ).show(context);
                  } else if (phone_number_controller.text.isEmpty) {
                    MotionToast.error(
                      height: 45,
                      onClose: () {},
                      description: const Text(
                        "Please enter a phone number.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ).show(context);
                  } else if (_selectedDisplayedProduct!.product ==
                      "Select Product") {
                    MotionToast.error(
                      height: 45,
                      onClose: () {},
                      description: const Text(
                        "Please select a product",
                        style: TextStyle(color: Colors.white),
                      ),
                    ).show(context);
                  } else if (selected_agent == null) {
                    MotionToast.error(
                      height: 45,
                      onClose: () {},
                      description: const Text(
                        "Please select an agent",
                        style: TextStyle(color: Colors.white),
                      ),
                    ).show(context);
                  } else if (_files.isEmpty &&
                      Constants.fieldSaleType == "Field Sale") {
                    MotionToast.error(
                      height: 45,
                      onClose: () {},
                      description: const Text(
                        "Please attach images",
                        style: TextStyle(color: Colors.white),
                      ),
                    ).show(context);
                  } else {
                    add_new_lead();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 18.0, right: 16, top: 16, bottom: 12),
                  height: 44,
                  decoration: BoxDecoration(
                      color: Constants.ctaColorLight,
                      border: Border.all(color: Colors.grey.withOpacity(0.75)),
                      borderRadius: BorderRadius.circular(360)),
                  child: Center(
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  if (name_controller.text.isEmpty) {
                    MotionToast.error(
                      height: 45,
                      onClose: () {},
                      description: const Text(
                        "Please enter a name.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ).show(context);
                  } else if (surname_controller.text.isEmpty) {
                    MotionToast.error(
                      height: 45,
                      onClose: () {},
                      description: const Text(
                        "Please enter a surname.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ).show(context);
                  } else if (phone_number_controller.text.isEmpty) {
                    MotionToast.error(
                      height: 45,
                      onClose: () {},
                      description: const Text(
                        "Please enter a phone number.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ).show(context);
                  } else if (_selectedDisplayedProduct!.product ==
                      "Select Product") {
                    MotionToast.error(
                      height: 45,
                      onClose: () {},
                      description: const Text(
                        "Please select a product",
                        style: TextStyle(color: Colors.white),
                      ),
                    ).show(context);
                  } else if (selected_agent == null) {
                    MotionToast.error(
                      height: 45,
                      onClose: () {},
                      description: const Text(
                        "Please select an agent",
                        style: TextStyle(color: Colors.white),
                      ),
                    ).show(context);
                  } else if (_files.isEmpty &&
                      Constants.fieldSaleType == "Field Sale") {
                    MotionToast.error(
                      height: 45,
                      onClose: () {},
                      description: const Text(
                        "Please attach images",
                        style: TextStyle(color: Colors.white),
                      ),
                    ).show(context);
                  } else {
                    // First add the new lead
                    await add_new_lead_and_continue();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 18.0, right: 16, top: 0, bottom: 12),
                  height: 44,
                  decoration: BoxDecoration(
                      color: Constants.ftaColorLight,
                      border: Border.all(color: Colors.grey.withOpacity(0.75)),
                      borderRadius: BorderRadius.circular(360)),
                  child: Center(
                    child: Text(
                      "SAVE AND CONTINUE",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    print("dgfgfhf ${Constants.cec_employeeid}");

    load_products2().then((value) {
      // _selectedProduct = all_parlour_rates[0];
      setState(() {});
    });
    load_all_sales_agents();
    startInactivityTimer();
    myNotifier = MyNotifier(newsaleValue, context);
    newsaleValue.addListener(() {
      if (mounted) setState(() {});
      Future.delayed(Duration(seconds: 2)).then((value) {
        if (mounted) setState(() {});
      });
    });
    super.initState();
  }

/*
  Future<void> load_products() async {
    var headers = {
      'Cookie':
          'userid=expiry=2021-04-25&client_modules=1001#1002#1003#1004#1005#1006#1007#1008#1009#1010#1011#1012#1013#1014#1015#1017#1018#1020#1021#1022#1024#1025#1026#1027#1028#1029#1030#1031#1032#1033#1034#1035&clientid=&empid=3&empfirstname=Mncedisi&emplastname=Khumalo&email=mncedisi@athandwe.co.za&username=mncedisi@athandwe.co.za&dob=8/28/1985 12:00:00 AM&fullname=Mncedisi Khumalo&userRole=5&userImage=mncedisi@athandwe.co.za.jpg&employedAt=branch&role=leader&branchid=6&branchname=Boulders&jobtitle=Administrative Assistant&dialing_strategy=Campaign Manager&clientname=Test 1 Funeral Parlour&foldername=maafrica&client_abbr=AS&pbx_account=pbx1051ef0a&soft_phone_ip=&agent_type=branch&mip_username=mnces@mip.co.za&agent_email=Mr Mncedisi Khumalo&ViciDial_phone_login=&ViciDial_phone_password=&ViciDial_agent_user=99&ViciDial_agent_password=&device_id=dC7JwXFwwdI:APA91bF0gTbuXlfT6wIcGMLY57Xo7VxUMrMH-MuFYL5PnjUVI0G5X1d3d90FNRb8-XmcjI40L1XqDH-KAc1KWnPpxNg8Z8SK4Ty0xonbz4L3sbKz3Rlr4hyBqePWx9ZfEp53vWwkZ3tx&servername=http://localhost:55661'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${Constants.insightsBackendBaseUrl}parlour/getParlourRatesExtras?client_id=${Constants.cec_client_id}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var decodedResponse = json.decode(responseBody);
      print("fgghggfh1" + decodedResponse.runtimeType.toString());

      List<dynamic> productList = decodedResponse["main_rates"];
      print("fgghggfh2" + productList.toString());

     */
/* all_parlour_rates = [
        ParlourRatesExtras("-1", "Select Product", "", 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, "", "", true)
      ];
*/ /*

      for (var product in productList) {
        //print(product);
        if (product['is_active']) {
          // Add only if the product is active
          all_parlour_rates.add(
            ParlourRatesExtras(
              product['id'].toString(),
              product['product'],
              product['prod_type'],
              product['amount'].toDouble(),
              product['premium'].toDouble(),
              product['min_age'],
              product['max_age'],
              product['spouse'],
              product['children'],
              product['parents'],
              product['extended'],
              product['parents_and_extended'],
              product['extra_members_allowed'],
              product['maximum_members'],
              product['timestamp'],
              product['last_update'],
              product['is_active'],
            ),
          );
        }
      }

      print('Selected ${_selectedDisplayedProduct}');
      print('Loaded ${all_parlour_rates.length} active products.');
    } else {
      print(response.reasonPhrase);
    }
  }
*/

  Future<void> load_products2() async {
    String url =
        '${Constants.parlourConfigBaseUrl}/parlour-config/get-parlour-rates-extras/?client_id=${Constants.cec_client_id}';
    print(url);
    var request = http.Request('GET', Uri.parse(url));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var decodedResponse = json.decode(responseBody);
      print("fgghggfh1" + decodedResponse.runtimeType.toString());

      Map<dynamic, dynamic> productList = decodedResponse["product_pitch"];
      print("fgghggfh3" + productList.toString());

      displayed_parlour_rates = [ParlourRatesExtras2a("Select Product", "")];
      productList.forEach((key, value) {
        Map product = value;
        product.forEach((planName, planDetails) {
          if (kDebugMode) {
            print('Selected ${key} ${planName}');
          }
          displayed_parlour_rates.add(ParlourRatesExtras2a(key, planName));
        });
      });

      //print('Selected ${_selectedDisplayedProduct}');
      //print('Loaded ${all_parlour_rates.length} active products.');
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> load_all_sales_agents() async {
    var request = http.Request(
      'GET',
      Uri.parse(
        '${Constants.insightsBackendUrl}/admin/getFieldEmployeesConsultants?organo_id=&cec_client_id=${Constants.cec_client_id}',
      ),
    );

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var decodedResponse = json.decode(responseBody);
      print("basaxsas0  - $responseBody");

      List<dynamic> salesAgentsList = decodedResponse;
      print("basaxsas  - ${salesAgentsList.length}");

      for (var agent in salesAgentsList) {
        print("basaxsas  -");

        print("sasaxsas  + ${(agent).toString()}");

        if (agent['employee_status'] == "active") {
          SalesAgentModel agentModel = SalesAgentModel.fromJson(agent);
          all_sales_agents.add(agentModel);

          // Automatically select the agent with matching cec_empid
          // Convert to string for comparison to handle different types
          if (agentModel.cecEmployeeId.toString() ==
              Constants.cec_empid.toString()) {
            selected_agent = agentModel;
            selectedSalesAgent = agentModel;
            _salesAgentController.text =
                "${agentModel.employeeName} ${agentModel.employeeSurname}";
            print(
                "Auto-selected agent: ${agentModel.employeeName} ${agentModel.employeeSurname}");
          }
        }
      }

      setState(() {});

      print('Loaded ${all_sales_agents.length} active sales agents.');
    } else {
      print("Failed to load sales agents: ${response.reasonPhrase}");
    }
  }

  Future<void> add_new_lead() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    //Constants.isViewingLead = true;
    var headers = {'Content-Type': 'application/json'};

    var body = jsonEncode({
      "LeadGuid": "Field_Lead",
      "cec_client_id": Constants.cec_client_id,
      "empId": selected_agent!.cecEmployeeId,
      "cellphone": phone_number_controller.text,
      "title": title,
      "name": name_controller.text,
      "surname": surname_controller.text,
      "product_type": _selectedDisplayedProduct!.prod_type,
      "branch_id": Constants.organo_id,
      "created_by": selected_agent!.cecEmployeeId,
      "user": selected_agent!.cecEmployeeId,
      "call_back_date": "",
      "call_back_time": "",
      "agent_sale_date": agent_sale_date,
      "hang_up_reason": "Transfered",
      "notes": notesController.text,
      "product": _selectedDisplayedProduct!.product,
      "abbr": _selectedDisplayedProduct!.product.substring(0, 2),
      "type": Constants.fieldSaleType
    });

    if (kDebugMode) {
      print("Request body: ${body}");
    }

    var request = http.Request('POST',
        Uri.parse('${Constants.insightsBackendBaseUrl}fieldV6/newLead'));
    request.headers.addAll(headers);
    request.body = body;

    try {
      http.StreamedResponse response = await request.send();
      print("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        print("Response body: $responseBody");
        var decodedResponse = json.decode(responseBody);

        // Assuming the response directly returns an integer
        int result = int.tryParse(decodedResponse.toString()) ?? 0;
        if (result > 0) {
          await uploadDocs(result);
        } else {
          Navigator.of(context).pop();
          showErrorDialog(context, "Invalid response from server");
        }
      } else {
        Navigator.of(context).pop();
        String errorBody = await response.stream.bytesToString();
        print("Error response: $errorBody");
        showErrorDialog(
            context, "Failed to create lead: ${response.reasonPhrase}");
      }
    } catch (e) {
      Navigator.of(context).pop();
      print("Network error: $e");
      showErrorDialog(context, "Network error: $e");
    }
  }
  //1414

  Future<void> uploadDocs(int result) async {
    print("Uploading documents for lead ID: ${result}");

    var queryParams = {
      'documents_indexed': 'Parked',
      'documents_indexed_by': Constants.cec_employeeid.toString(),
      'documents_indexed_policy_documents': 'yes',
      'documents_indexed_terms_and_conditions': 'yes',
      'documents_indexed_funeral_benefit': 'yes',
      'documents_indexed_additional_information': 'yes',
      'documents_indexed_vab_pamphlets': 'yes',
      'onololeadid': '${result}',
      'documents_indexed_field_form_uploaded': 'yes',
      'notes': notesController.text,
      'created_by': Constants.cec_employeeid.toString(),
    };

    var uri = Uri.parse('${Constants.insightsBackendBaseUrl}fieldV6/saveIndex');
    var uriWithParams = Uri(
      scheme: uri.scheme,
      host: uri.host,
      path: uri.path,
      query: Uri(queryParameters: queryParams).query,
    );

    var request = http.MultipartRequest('POST', uriWithParams);

    for (var file in _files) {
      print("Adding file: ${file.name}");
      if (file.path != null) {
        try {
          request.files.add(await http.MultipartFile.fromPath(
            'images[]',
            file.path!,
          ));
        } catch (e) {
          print("Error adding file ${file.name}: $e");
        }
      }
    }

    _files = [];

    try {
      var response = await request.send();
      print("Upload response status code: ${response.statusCode}");
      String responseBody = await response.stream.bytesToString();
      print("Upload response body: $responseBody");

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Files and data uploaded successfully");
        String trimmedResponseBody = responseBody.replaceAll('"', '');

        Navigator.of(context).pop(); // Close loading dialog

        if (trimmedResponseBody == "Success") {
          // Fetch lead details by ID before navigating
          await fetchLeadById2(result.toString());
        } else {
          showErrorDialog(
              context, "Upload completed but received: $responseBody");
        }
      } else {
        Navigator.of(context).pop(); // Close loading dialog
        showErrorDialog(context, "Upload failed: ${response.reasonPhrase}");
        print("Failed to upload files and data: ${response.reasonPhrase}");
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      print("Upload error: $e");
      showErrorDialog(context, "Upload error: $e");
    }
  }

  Future<void> uploadDocsContinue(int result) async {
    print("sdfgfg ${result}");
    var queryParams = {
      'documents_indexed': 'Parked',
      'documents_indexed_by': Constants.cec_employeeid.toString(),
      'documents_indexed_policy_documents': 'yes',
      'documents_indexed_terms_and_conditions': 'yes',
      'documents_indexed_funeral_benefit': 'yes',
      'documents_indexed_additional_information': 'yes',
      'documents_indexed_vab_pamphlets': 'yes',
      'onololeadid': '${result}',
      'documents_indexed_field_form_uploaded': 'yes',
      'notes': notesController.text,
      'created_by': "0",
    };

    var uri = Uri.parse('${Constants.insightsBackendBaseUrl}fieldV6/saveIndex');
    var uriWithParams = Uri(
      scheme: uri.scheme,
      host: uri.host,
      path: uri.path,
      query: Uri(queryParameters: queryParams).query,
    );

    var request = http.MultipartRequest('POST', uriWithParams);

    for (var file in _files) {
      print("files ${file.name}");
      if (file.path != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'images[]',
          file.path!,
        ));
      }
    }

    _files = [];

    var response = await request.send();
    print("Response status code: ${response.statusCode}");
    String responseBody = await response.stream.bytesToString();
    print("Response body: $responseBody");

    if (response.statusCode == 201) {
      print("Files and data uploaded successfully");
      // Handle success
      String trimmedResponseBody = responseBody.replaceAll('"', '');

      if (trimmedResponseBody == "Success") {
        // Fetch lead details by ID before navigating
        await fetchLeadById2(result.toString());
      } else {
        showErrorDialog(context, responseBody);
      }
    } else {
      showErrorDialog(context, response.reasonPhrase!);
      print("Failed to upload files and data: ${response.reasonPhrase}");
    }
  }

  Future<void> fetchLeadById2(String leadId) async {
    final String fetchUrl =
        "${Constants.insightsBackendBaseUrl}parlour/getLeadById?onololeadid=$leadId&cec_client_id=${Constants.cec_empid}";

    try {
      final response = await http.get(Uri.parse(fetchUrl));
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        Constants.currentleadAvailable = Lead.fromJson(responseData[0]);

        // Navigate to FieldSalesAffinity after successful lead fetch
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Fieldsalesaffinity(sale_type: Constants.fieldSaleType),
          ),
        );
      } else {
        print("Failed to fetch lead by ID: ${response.statusCode}");
        showErrorDialog(context, "Failed to fetch lead details");
      }
    } catch (error) {
      print("Error fetching lead by ID: $error");
      showErrorDialog(context, "Error fetching lead details: $error");
    }
  }

  Future<void> add_new_lead_and_continue() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    //Constants.isViewingLead = true;
    var headers = {'Content-Type': 'application/json'};

    var body = jsonEncode({
      "LeadGuid": "Field_Lead",
      "cec_client_id": Constants.cec_client_id,
      "empId": selected_agent!.cecEmployeeId,
      "cellphone": phone_number_controller.text,
      "title": title,
      "name": name_controller.text,
      "surname": surname_controller.text,
      "product_type": _selectedDisplayedProduct!.prod_type,
      "branch_id": Constants.organo_id,
      "created_by": selected_agent!.cecEmployeeId,
      "user": selected_agent!.cecEmployeeId,
      "call_back_date": "",
      "call_back_time": "",
      "agent_sale_date": agent_sale_date,
      "hang_up_reason": "Transfered",
      "notes": notesController.text,
      "product": _selectedDisplayedProduct!.product,
      "abbr": _selectedDisplayedProduct!.product.substring(0, 2),
      "type": Constants.fieldSaleType
    });

    if (kDebugMode) {
      print("Request body: ${body}");
    }

    var request = http.Request('POST',
        Uri.parse('${Constants.insightsBackendBaseUrl}fieldV6/newLead'));
    request.headers.addAll(headers);
    request.body = body;

    try {
      http.StreamedResponse response = await request.send();
      print("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        print("Response body: $responseBody");
        var decodedResponse = json.decode(responseBody);

        // Assuming the response directly returns an integer
        int result = int.tryParse(decodedResponse.toString()) ?? 0;
        if (result > 0) {
          await uploadDocsContinue(result);
        } else {
          Navigator.of(context).pop();
          showErrorDialog(context, "Invalid response from server");
        }
      } else {
        Navigator.of(context).pop();
        String errorBody = await response.stream.bytesToString();
        print("Error response: $errorBody");
        showErrorDialog(
            context, "Failed to save lead: ${response.reasonPhrase}");
      }
    } catch (e) {
      Navigator.of(context).pop();
      print("Network error: $e");
      showErrorDialog(context, "Network error: $e");
    }
  }

  /*Future<void> uploadDocumentsAndData(int result) async {
    var uri = Uri.parse(
        'https://insights.dedicated.co.za:805/api/user/PostUserImage');

    var request = http.MultipartRequest('POST', uri);

    request.fields['documents_indexed'] = 'Parked';
    request.fields['documents_indexed_by'] = '3';
    request.fields['documents_indexed_policy_documents'] = 'yes';
    request.fields['documents_indexed_terms_and_conditions'] = 'yes';
    request.fields['documents_indexed_funeral_benefit'] = 'yes';
    request.fields['documents_indexed_additional_information'] = 'yes';
    request.fields['documents_indexed_vab_pamphlets'] = 'yes';
    request.fields['onololeadid'] = '${result}';
    request.fields['documents_indexed_field_form_uploaded'] = 'yes';

    for (PlatformFile file in _files) {
      String fileName = basename(file.path!);
      request.files.add(await http.MultipartFile.fromPath(
        'file', // This should match the name expected by your server-side code
        file.path!,
        filename: fileName,
      ));
    }

    // Send the request
    var response = await request.send();

    // Handle the response
    if (response.statusCode == 200) {
      print("Upload successful");
      // You might want to read the response or decode JSON
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print("Response: $responseString");
    } else {
      print("Failed to upload. Status code: ${response.statusCode}");
      // Optionally, read the response body to get more details
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print("Response: $responseString");
    }
  }*/
  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button to close dialog
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ), // Make dialog rounded
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: contentBox(context),
        );
      },
    );
  }

  Widget contentBox(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              CircleAvatar(
                backgroundColor: Constants.ctaColorLight,
                radius: 45,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 90,
                ),
              ),
              Text(
                "Success",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 15),
              Text(
                "The lead was successfully uploaded.",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 22),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    phone_number_controller.text = "";
                    name_controller.text = "";
                    surname_controller.text = "";
                    notesController.text = "";
                    setState(() {});

                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "OK",
                    style:
                        TextStyle(fontSize: 18, color: Constants.ctaColorLight),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: errorContentBox(context, errorMessage),
        );
      },
    );
  }

  Widget errorContentBox(BuildContext context, String errorMessage) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 50, bottom: 16, left: 16, right: 16),
          margin: EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Error",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent),
              ),
              SizedBox(height: 15),
              Text(
                errorMessage,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 22),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -60,
          child: CircleAvatar(
            backgroundColor: Colors.redAccent,
            radius: 45,
            child: Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 90,
            ),
          ),
        ),
      ],
    );
  }
}

class MultiLineTextField extends StatelessWidget {
  const MultiLineTextField(
      {Key? key,
      this.controller,
      this.label,
      required this.bordercolor,
      this.validator,
      this.autofocus,
      this.onChanged,
      required this.maxLines})
      : super(key: key);

  final TextEditingController? controller;
  final String? label;
  final Color? bordercolor;
  final String? Function(String?)? validator;
  final bool? autofocus;
  final Function(String)? onChanged;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: bordercolor ?? Colors.blueAccent)),
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: TextFormField(
          maxLines: maxLines,
          scrollPadding: const EdgeInsets.all(0.0),
          onChanged: onChanged,
          autofocus: autofocus ?? false,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              vertical: -12,
            ),
            //contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            border: InputBorder.none,
            labelText: label ?? "label",
            labelStyle: GoogleFonts.inter(
              textStyle: TextStyle(
                  fontSize: 13.5,
                  color: Colors.grey,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w400),
            ),
            hintStyle: GoogleFonts.inter(
              textStyle: TextStyle(
                  fontSize: 13.5,
                  color: Colors.grey,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w400),
            ),
          ),
          controller: controller,
          validator: validator,
        ),
      ),
    );
  }
}

class ImagePreviewPage extends StatelessWidget {
  final String imagePath;

  const ImagePreviewPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.6),
        title: Text("Preview"),
        elevation: 6,
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          // Use PhotoView for the zoomable image
          child: PhotoView(
            imageProvider: FileImage(File(imagePath)),
            backgroundDecoration: BoxDecoration(
              color: Colors.black, // Ensure the background is black
            ),
            minScale:
                PhotoViewComputedScale.contained * 0.8, // Minimum scale level
            maxScale: PhotoViewComputedScale.covered * 2, // Maximum scale level
            // Enable the following to use a custom initial scale:
            // initialScale: PhotoViewComputedScale.contained,
          ),
        ),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final ImagePicker _picker = ImagePicker();
  List<File> _imageFiles = [];

  Future<void> captureImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      _editImage(File(image
          .path)); // Allow user to edit the image immediately after capturing
    }
  }

  Future<void> _editImage(File imageFile) async {
    CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      /*aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )*/
    );

    if (cropped != null) {
      setState(() {
        //  _imageFiles.add(cropped);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Capture and Edit Images"),
        actions: [
          IconButton(
            icon: Icon(Icons.upload_file),
            onPressed: _uploadImages,
          )
        ],
      ),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: _imageFiles.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onLongPress: () => _confirmDelete(index),
            child: Image.file(_imageFiles[index], fit: BoxFit.cover),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: captureImage,
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Do you really want to delete this image?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                setState(() {
                  _imageFiles.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadImages() async {
    // Implement your upload logic here
    // This could involve batching the files in _imageFiles and sending them to a server
  }
}

class MyWidget2 extends StatefulWidget {
  @override
  _MyWidget2State createState() => _MyWidget2State();
}

class _MyWidget2State extends State<MyWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  List<File> _selectedFiles = [];

  // Function to capture images
  Future<void> captureImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      _addFile(File(image.path));
    }
  }

  // Function to pick documents and images
  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
      allowMultiple: true,
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      files.forEach(_addFile);
    }
  }

  // Helper method to add a file to the list and update the state
  void _addFile(File file) {
    setState(() {
      _selectedFiles.add(file);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Files"),
        actions: [
          IconButton(
            icon: Icon(Icons.file_copy),
            onPressed: pickFiles,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: captureImage,
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: _selectedFiles.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onLongPress: () => _confirmDelete(index),
            child: _buildFileThumbnail(_selectedFiles[index]),
          );
        },
      ),
    );
  }

  Widget _buildFileThumbnail(File file) {
    if (['.jpg', '.jpeg', '.png'].any(file.path.endsWith)) {
      return Image.file(file, fit: BoxFit.cover); // For images
    } else {
      return Container(
        alignment: Alignment.center,
        child: Icon(Icons.insert_drive_file), // Placeholder for non-images
      );
    }
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Do you really want to delete this file?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                setState(() {
                  _selectedFiles.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class CombinedImageSelector extends StatefulWidget {
  const CombinedImageSelector({super.key});

  @override
  State<CombinedImageSelector> createState() => _CombinedImageSelectorState();
}

class _CombinedImageSelectorState extends State<CombinedImageSelector> {
  // List to store image files
  List<XFile> _images = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text("All images"),
            elevation: 6,
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
          ),
          body: _images.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                        child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Number of columns
                        crossAxisSpacing: 4.0, // Horizontal space between items
                        mainAxisSpacing: 4.0, // Vertical space between items
                      ),
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            InkWell(
                              onTap: () {
                                print("ffgfggf " +
                                    _images[index].mimeType.toString());

                                // Navigate to the image preview page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ImagePreviewPage(
                                        imagePath: _images[index].path!),
                                  ),
                                );
                              },
                              child: Image.file(
                                File(_images[index].path),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            Positioned(
                              right: 4, // Position from the right
                              bottom: 4, // Position from the bottom
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _images.removeAt(
                                        index); // Remove the image from the list
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    )),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 8),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          _attachFilesToMain();
                          newsaleValue.value++;
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Constants.ctaColorLight,
                              borderRadius: BorderRadius.circular(360),
                              border:
                                  Border.all(color: Constants.ctaColorLight)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8, top: 12, bottom: 12),
                            child: Center(
                              child: Text(
                                "Done",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  letterSpacing: 1.05,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "TradeGothic",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    )
                  ],
                )
              : Center(
                  child: Text(
                    'No images captured',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
          floatingActionButton: _images.isEmpty
              ? FloatingActionButton(
                  backgroundColor: Constants.ctaColorLight,
                  child: Icon(
                    Icons.image,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _attachCombinedImages();
                  })
              : null),
    );
  }

  @override
  void initState() {
    super.initState();
    _attachCombinedImages();
  }

  Future<void> _attachFilesToMain() async {
    // Assuming _files is a List<PlatformFile>
    for (XFile image in _images) {
      // Convert each XFile to a PlatformFile
      PlatformFile platformFile = PlatformFile(
        name: image.name, // name property from XFile
        path: image.path, // path of the file
        size: await image.length(), // size of the file in bytes
        bytes: await image.readAsBytes(), // Optional: include the file bytes
      );

      // Add the converted file to _files
      _files.add(platformFile);
    }
  }

  Future<void> _attachCombinedImages() async {
    bool isCapturing = true;

    while (isCapturing) {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        setState(() {
          _images.add(image);
        });
      }

      isCapturing = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                'Capture More Photos?',
                style: TextStyle(fontSize: 16),
              ),
              content: Text('Would you like to capture more images?'),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.transparent),
                  child: Text('No'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Constants.ctaColorLight),
                  child: Text('Yes'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          ) ??
          false;
    }
  }
}
