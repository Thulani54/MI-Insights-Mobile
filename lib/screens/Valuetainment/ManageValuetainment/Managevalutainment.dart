import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:excel/excel.dart' as excel1;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mi_insights/constants/Constants.dart';
import 'package:mi_insights/customwidgets/CustomCard.dart';
import 'package:mi_insights/customwidgets/custom_input.dart';
import 'package:mime/mime.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

import '../../../models/ValutainmentModels.dart';
import '../../../services/MyNoyifier.dart';
import '../../../services/inactivitylogoutmixin.dart';
import '../../Admin/Valuetainment/ViewValuetainment.dart';

final valuetainmentValue = ValueNotifier<int>(0);
MyNotifier? myNotifier;

class sectionmodel {
  String id;
  Map map;
  String image;
  sectionmodel(this.id, this.map, this.image);
}

class Managevalutainment extends StatefulWidget {
  const Managevalutainment({super.key});

  @override
  State<Managevalutainment> createState() => _ManagevalutainmentState();
}

List<Map<String, dynamic>> uploadContentMap = [];
List<Map<String, dynamic>> uploadContentMap2 = [];
List<ValuetainmentFAQ> faqs = [];
List<sectionmodel> sectionsList = [
  sectionmodel("Sales", {}, "assets/icons/sales_logo.svg"),
  sectionmodel("Collections", {}, "assets/icons/collections_logo.svg"),
  sectionmodel("Claims", {}, "assets/icons/claims_logo.svg"),
  sectionmodel("Cust. Profile", {}, "assets/icons/customers.svg"),
  sectionmodel("Fulfillment", {}, "assets/icons/communications_logo.svg"),
  sectionmodel("Commission", {}, "assets/icons/commission_logo.svg"),
  sectionmodel("Compliance", {}, "assets/icons/claims_logo.svg"),
  sectionmodel("Maintenance", {}, "assets/icons/maintanence_report.svg"),
  sectionmodel("Attendance", {}, "assets/icons/attendance.svg"),
  sectionmodel("Pol. Search", {}, "assets/icons/policy_search.svg"),
  sectionmodel("Reprints", {}, "assets/icons/reprint_logo.svg"),
  sectionmodel("Morale Index", {}, "assets/icons/people_matters.svg"),
  sectionmodel("QuoteX", {}, "assets/icons/micro_l.svg"),
];
List<Map<String, dynamic>> topic_data = [];
List<Map<String, dynamic>> faq_data = [];

class _ManagevalutainmentState extends State<Managevalutainment> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 6,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shadowColor: Colors.grey,
            title: const Text(
              "Valuetainment",
              style: TextStyle(color: Colors.black),
            ),
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                CupertinoIcons.back,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          // Constants.ctaColorLight,
                          //Constants.ctaColorLight.withOpacity(0.5),
                          Colors.grey.withOpacity(0.55),
                          Colors.white,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    height: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Stack(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                  "assets/business_logos/pop_and_spin2.png")),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: Padding(
                      padding:
                          const EdgeInsets.only(left: 0.0, bottom: 4, top: 8),
                      child: Text(
                        "PROGRAMMES",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16, bottom: 12),
                  child: Container(
                    height: 1,
                    decoration:
                        BoxDecoration(color: Colors.grey.withOpacity(0.15)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 8,
                        crossAxisCount: 4,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.4)),
                    itemCount: sectionsList.length,
                    padding: EdgeInsets.all(2.0),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                          onTap: () {},
                          child: Container(
                            height: 290,
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AdminViewValuetainment(
                                                  module_name:
                                                      sectionsList[index].id,
                                                ))).then((_) {});
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 0.0, right: 8),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            /*         decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.35)),
                                              borderRadius:
                                                  BorderRadius.circular(360)),*/
                                            child: Card(
                                              elevation: 6,
                                              surfaceTintColor: Colors.white,
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          360)),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.04),
                                                      spreadRadius: 2,
                                                      blurRadius: 4,
                                                      offset: Offset(0,
                                                          -2), // Offset to show the shadow at the top
                                                    ),
                                                  ],
                                                ),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 370,
                                                /*     decoration: BoxDecoration(
                                                    color:Colors.white,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        8),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors
                                                            .grey.withOpacity(0.2))),*/
                                                margin: EdgeInsets.only(
                                                    right: 0,
                                                    left: 0,
                                                    bottom: 4),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: SvgPicture.asset(
                                                    sectionsList[index].image,
                                                    // color: Colors.black,
                                                    color: Constants
                                                        .ctaColorLight
                                                        .withOpacity(0.90),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 55,
                                          child: Column(
                                            children: [
                                              Center(
                                                  child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Text(
                                                  sectionsList[index].id,
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                ),
                                              )),
                                              Spacer(),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class AdminViewValuetainment extends StatefulWidget {
  final String module_name;
  const AdminViewValuetainment({super.key, required this.module_name});

  @override
  State<AdminViewValuetainment> createState() => _AdminViewValuetainmentState();
}

class _AdminViewValuetainmentState extends State<AdminViewValuetainment>
    with InactivityLogoutMixin {
  bool isLoadingModules = true;
  @override
  void initState() {
    super.initState();
    getModules(widget.module_name);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.grey,
          leading: InkWell(
              onTap: () {
                restartInactivityTimer();
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          centerTitle: true,
          title: Text(
            "List of Courses",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            if (Constants.allowed_add_assessments)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(360),
                        color: Constants.ctaColorLight),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    )),
              ),
          ],
          elevation: 6,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                child: isLoadingModules == true
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Constants.ctaColorLight),
                        ),
                      )
                    : modules_list.length == 0
                        ? Center(
                            child: Text(
                              "No modules found",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: modules_list.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ViewValuetainment(
                                                  module_info:
                                                      modules_list[index])));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomCard(
                                    elevation: 2,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0,
                                          top: 8,
                                          bottom: 8,
                                          right: 8),
                                      child: Text(
                                        "${index + 1}) " +
                                            modules_list[index].title,
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (dialogContext) {
                              return StatefulBuilder(
                                builder: (BuildContext dailogcontext,
                                    StateSetter setState) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    backgroundColor: Colors.white,
                                    surfaceTintColor: Colors.white,
                                    title: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 24.0, right: 24),
                                      child: const Text('Add a Course'),
                                    )),
                                    content: Text(
                                      'Are you sure you would like to create Course Content?',
                                      style: TextStyle(),
                                      textAlign: TextAlign.center,
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.of(dailogcontext)
                                                    .pop();
                                                // Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Not Now',
                                                style: TextStyle(
                                                    color:
                                                        Constants.ctaColorLight,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: TextButton(
                                              onPressed: () {
                                                // _saveAttempt(80);
                                                Navigator.of(dailogcontext)
                                                    .pop();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdminNewModule(
                                                              module_name: widget
                                                                  .module_name,
                                                            )));
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Constants
                                                          .ctaColorLight,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              360)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20.0,
                                                            right: 20,
                                                            top: 5,
                                                            bottom: 5),
                                                    child: const Text(
                                                      'Continue',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Constants.ctaColorLight,
                                borderRadius: BorderRadius.circular(360)),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                "Add Course Content",
                                style: TextStyle(color: Colors.white),
                              )),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Module> modules_list = [];

  Future<void> getModules(String moduleType) async {
    setState(() {
      isLoadingModules = true;
    });

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'GET',
        Uri.parse(
            '${Constants.InsightsReportsbaseUrl}/api/valuetainment/valuetainment_modules/all?cec_client_id=${Constants.cec_client_id}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseString);
      print("uoiio0 $jsonResponse");

      setState(() {
        modules_list = (jsonResponse['modules'] as List)
            .map((item) => Module.fromJson(item))
            .where((module) =>
                module.module == moduleType) // Filter by module type
            .toList();
        isLoadingModules = false;
      });
    } else {
      print("uoiio1 ${response.reasonPhrase}");
      setState(() {
        isLoadingModules = false;
      });
    }
  }
}

MyNotifier? myNotifier2;
List<PlatformFile> _files = [];
final valuetainmentValue2 = ValueNotifier<int>(0);

class AdminNewModule extends StatefulWidget {
  final String module_name;
  const AdminNewModule({super.key, required this.module_name});

  @override
  State<AdminNewModule> createState() => _AdminNewModuleState();
}

class _AdminNewModuleState extends State<AdminNewModule>
    with InactivityLogoutMixin {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController maximumAttemptsController = TextEditingController();
  TextEditingController attemptsQuestionsController = TextEditingController();
  TextEditingController passPercentageController = TextEditingController();
  TextEditingController likesController = TextEditingController();
  TextEditingController viewsController = TextEditingController();
  TextEditingController moduleController = TextEditingController();
  TextEditingController timestampController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  FocusNode titleFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode durationFocusNode = FocusNode();
  FocusNode maximumAttemptsFocusNode = FocusNode();
  FocusNode attemptsQuestionsFocusNode = FocusNode();
  FocusNode passMarkFocusNode = FocusNode();
  FocusNode moduleFocusNode = FocusNode();
  FocusNode timestampFocusNode = FocusNode();
  FocusNode imageFocusNode = FocusNode();
  FocusNode dataFocusNode = FocusNode();
  FocusNode pageDataFocusNode = FocusNode();
  FocusNode subSectionsFocusNode = FocusNode();
  String moduleEndDate = "Select Date";
  String moduleStartDate = "Select Date";
  File moduleImage = File(
    "",
  );
  bool isLoading = false;
  MyNotifier? myNotifier;

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
    valuetainmentValue.value++;
  }

  File? _file;
  File? _file2;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      _file = File(result.files.single.path!);
      final data = await _readExcel(_file!);

      uploadContentMap = data;
      topic_data = _transformData(uploadContentMap);
      valuetainmentValue.value++;

      //print(uploadContentMap);
    }
  }

  void _pickFile2() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      _file2 = File(result.files.single.path!);
      final data = await _readExcel(_file2!);

      uploadContentMap2 = data;

      print(uploadContentMap2);
      valuetainmentValue.value++;
    }
  }

  Future<List<Map<String, dynamic>>> _readExcel(File file) async {
    final bytes = await file.readAsBytes();
    final excel = excel1.Excel.decodeBytes(bytes);

    final sheet = excel.tables[excel.tables.keys.first]!;
    final rows = sheet.rows;

    // Extract the headers
    final headers = rows.first.map((cell) => cell?.value.toString()).toList();

    // Extract the data rows
    final dataRows = rows.skip(1).map((row) {
      final rowData = <String, dynamic>{};
      for (var i = 0; i < headers.length; i++) {
        final cell = row[i];
        if (cell != null) {
          rowData[headers[i]!] =
              cell.value.toString(); // Convert all cell values to string
        } else {
          rowData[headers[i]!] = null; // Handle null values appropriately
        }
      }
      return rowData;
    }).toList();

    return dataRows;
  }

  List<Map<String, dynamic>> _transformData(List<Map<String, dynamic>> data) {
    Map<String, Map<String, dynamic>> topicsMap = {};

    for (var item in data) {
      String id = item['id'];
      if (!topicsMap.containsKey(id)) {
        topicsMap[id] = {
          "cec_client_id": Constants.cec_client_id,
          "title": item['title'],
          "description": item['description'],
          "duration": int.parse(item['duration']),
          "pages": int.parse(item['pages']),
          "likes": int.parse(item['likes']),
          "views": int.parse(item['views']),
          "timestamp": item['timestamp'],
          "is_visible": item['is_visible'] == 'true',
          "image": item['image'],
          "thumbnail": "",
          "page_data": [],
          "table_of_contents": [],
          "content_items": []
        };
      }

      topicsMap[id]?['table_of_contents'].add({
        "id": int.parse(item['toc_id']),
        "index": int.parse(item['toc_index']),
        "text": item['toc_text'],
        "page": int.parse(item['toc_page']),
        "type": item['toc_type']
      });

      topicsMap[id]!['content_items'].add({
        "id": int.parse(item['ci_id']),
        "text": item['ci_text'],
        "subtext": item['ci_subtext'],
        "page": int.parse(item['ci_page']),
        "type": item['ci_type'],
        "topic": item['ci_topic']
      });
    }

    return topicsMap.values.toList();
  }

  void _pickImageFile(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        topic_data[index]['image'] = File(result.files.single.path!);
      });
    }
  }

  void _pickVideoFile(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      setState(() {
        topic_data[index]['video_file'] = File(result.files.single.path!);
      });
    }
  }

  void _pickImageFile6(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        topic_data[index]['image'] = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadVideoFile(File videoFile, int topicId) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Constants.InsightsReportsbaseUrl}/api/upload_video/'),
    );

    request.fields['topic_id'] = topicId.toString();
    request.files.add(await http.MultipartFile.fromPath(
      'video',
      videoFile.path,
    ));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Video uploaded successfully');
    } else {
      print('Failed to upload video');
    }
  }

  List<Map<String, dynamic>> _transformQuestionsData(
      List<Map<String, dynamic>> data) {
    List<Map<String, dynamic>> questionsList = [];

    for (var item in data) {
      print("fdfggf $item");
      Map<String, dynamic> questionData = {
        "question_id": item['question_id'],
        "topic_id": item['topic_id'],
        "text": item['text'],
        "image": item['image'],
        "choices": [
          {
            "text": item['option_1'],
            "is_correct": item['correct_answer'] == "1"
          },
          {
            "text": item['option_2'],
            "is_correct": item['correct_answer'] == "2"
          },
          {
            "text": item['option_3'],
            "is_correct": item['correct_answer'] == "3"
          },
          {
            "text": item['option_4'],
            "is_correct": item['correct_answer'] == "4"
          },
        ],
        "timestamp": item['timestamp']
      };

      questionsList.add(questionData);
    }

    return questionsList;
  }

  void _add_module_content() async {
    try {
      var questions_data = _transformQuestionsData(uploadContentMap2);

      if (titleController.text.isEmpty) {
        MotionToast.error(
          onClose: () {},
          description: Text("Please enter a title"),
        ).show(context);
        return;
      }

      if (descriptionController.text.isEmpty) {
        MotionToast.error(
          onClose: () {},
          description: Text("Please enter a description"),
        ).show(context);
        return;
      }

      if (durationController.text.isEmpty ||
          int.tryParse(durationController.text) == null) {
        MotionToast.error(
          onClose: () {},
          description: Text("Please enter a assessment duration"),
        ).show(context);
        return;
      }

      int maximumAttempts;
      int attemptQuestions;
      int passPercentage;

      if (maximumAttemptsController.text.isEmpty) {
        MotionToast.error(
          onClose: () {},
          description: Text("Please enter maximum attempts"),
        ).show(context);
        return;
      }

      try {
        maximumAttempts = int.parse(maximumAttemptsController.text);
      } catch (e) {
        MotionToast.error(
          onClose: () {},
          description: Text("Maximum attempts must be a valid number"),
        ).show(context);
        return;
      }

      if (attemptsQuestionsController.text.isEmpty) {
        MotionToast.error(
          onClose: () {},
          description: Text("Please enter attempt questions"),
        ).show(context);
        return;
      }

      try {
        attemptQuestions = int.parse(attemptsQuestionsController.text);
      } catch (e) {
        MotionToast.error(
          onClose: () {},
          description: Text("Attempt questions must be a valid number"),
        ).show(context);
        return;
      }

      if (passPercentageController.text.isEmpty) {
        MotionToast.error(
          onClose: () {},
          description: Text("Please enter pass percentage"),
        ).show(context);
        return;
      }

      try {
        passPercentage = int.parse(passPercentageController.text);
      } catch (e) {
        MotionToast.error(
          onClose: () {},
          description: Text("Pass percentage must be a valid number"),
        ).show(context);
        return;
      }

      if (moduleStartDate.isEmpty) {
        MotionToast.error(
          onClose: () {},
          description: Text("Please enter start date"),
        ).show(context);
        return;
      }

      if (moduleEndDate.isEmpty) {
        MotionToast.error(
          onClose: () {},
          description: Text("Please enter end date"),
        ).show(context);
        return;
      }

      var jsonData1 = {
        "cec_client_id": Constants.cec_client_id,
        "uploaded_by": Constants.cec_employeeid,
        "title": titleController.text,
        "description": descriptionController.text,
        "duration": durationController.text,
        "maximum_attempts": maximumAttempts,
        "attempt_questions": attemptQuestions,
        "pass_percentage": passPercentage,
        "likes": 0,
        "views": 0,
        "module_type": widget.module_name,
        "is_visible": true,
        "start_date": moduleStartDate,
        "end_date": moduleEndDate,
        "topics": topic_data,
        "questions_data": questions_data,
      };

      var uri = Uri.parse(
          '${Constants.InsightsReportsbaseUrl}/api/valuetainment/upload_content_items/');
      var request = http.MultipartRequest('POST', uri);

      jsonData1.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (moduleImage.path != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', moduleImage.path!));
      }

      // Add other files similarly
      for (var topic in topic_data) {
        if (topic['image'] != null) {
          request.files.add(await http.MultipartFile.fromPath(
              'image_${topic['title']}', topic['image'].path));
        }
        if (topic['video_file'] != null) {
          request.files.add(await http.MultipartFile.fromPath(
              'video_${topic['title']}', topic['video_file'].path));
        }
        if (topic['thumbnail'] != null) {
          request.files.add(await http.MultipartFile.fromPath(
              'thumbnail_${topic['title']}', topic['thumbnail'].path));
        }
      }

      final response = await request.send();

      if (response.statusCode == 201) {
        Navigator.of(context).pop();
        MotionToast.success(
          description: Text("Module uploaded successfully"),
        ).show(context);
      } else {
        MotionToast.error(
          description: Text("Module upload failed"),
        ).show(context);
      }
    } catch (e) {
      MotionToast.error(
        description: Text("An unexpected error occurred: $e"),
      ).show(context);
    }
  }

  void _uploadModule() async {
    if (titleController.text.isEmpty) {
      MotionToast.error(
        onClose: () {},
        description: Text("Please enter a title"),
      ).show(context);
      return;
    }

    if (descriptionController.text.isEmpty) {
      MotionToast.error(
        onClose: () {},
        description: Text("Please enter a description"),
      ).show(context);
      return;
    }

    if (durationController.text.isEmpty ||
        int.tryParse(durationController.text) == null) {
      MotionToast.error(
        onClose: () {},
        description: Text("Please enter a assessment duration"),
      ).show(context);
      return;
    }

    int maximumAttempts;
    int attemptQuestions;
    int passPercentage;

    if (maximumAttemptsController.text.isEmpty) {
      MotionToast.error(
        onClose: () {},
        description: Text("Please enter maximum attempts"),
      ).show(context);
      return;
    }

    try {
      maximumAttempts = int.parse(maximumAttemptsController.text);
    } catch (e) {
      MotionToast.error(
        onClose: () {},
        description: Text("Maximum attempts must be a valid number"),
      ).show(context);
      return;
    }

    if (attemptsQuestionsController.text.isEmpty) {
      MotionToast.error(
        onClose: () {},
        description: Text("Please enter attempt questions"),
      ).show(context);
      return;
    }

    try {
      attemptQuestions = int.parse(attemptsQuestionsController.text);
    } catch (e) {
      MotionToast.error(
        onClose: () {},
        description: Text("Attempt questions must be a valid number"),
      ).show(context);
      return;
    }

    if (passPercentageController.text.isEmpty) {
      MotionToast.error(
        onClose: () {},
        description: Text("Please enter pass percentage"),
      ).show(context);
      return;
    }

    try {
      passPercentage = int.parse(passPercentageController.text);
    } catch (e) {
      MotionToast.error(
        onClose: () {},
        description: Text("Pass percentage must be a valid number"),
      ).show(context);
      return;
    }

    if (moduleStartDate.isEmpty) {
      MotionToast.error(
        onClose: () {},
        description: Text("Please enter start date"),
      ).show(context);
      return;
    }

    if (moduleEndDate.isEmpty) {
      MotionToast.error(
        onClose: () {},
        description: Text("Please enter end date"),
      ).show(context);
      return;
    }
    List<Map<String, dynamic>> questions_data =
        _transformQuestionsData(uploadContentMap2);
    if (questions_data.isEmpty) {
      MotionToast.error(
        onClose: () {},
        description: Text("Please upload questions"),
      ).show(context);
      return;
    }
    print("faq0 ${faq_data}");
    print("faq1 ${faqs}");
    print("questions_data ${questions_data}");
    var jsonData1 = {
      "cec_client_id": Constants.cec_client_id,
      "uploaded_by": Constants.cec_employeeid,
      "title": titleController.text,
      "description": descriptionController.text,
      "duration": durationController.text,
      "maximum_attempts": maximumAttempts,
      "attempt_questions": attemptQuestions,
      "pass_percentage": passPercentage,
      "likes": 0,
      "views": 0,
      "module_type": widget.module_name,
      "is_visible": true,
      "start_date": moduleStartDate,
      "end_date": moduleEndDate,
      "faq": faq_data,
      "questions_data": questions_data
    };

    var uri = Uri.parse(
        '${Constants.InsightsReportsbaseUrl}/api/valuetainment/create_module/');
    var response = await http.post(uri,
        body: jsonEncode(jsonData1),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 201) {
      var moduleResponse = jsonDecode(response.body);
      var moduleId = moduleResponse['module_id'];
      Navigator.of(context).pop();
      MotionToast.success(
        description: Text("Course uploaded successfully"),
      ).show(context);
      _uploadTopics(moduleId);

      if (moduleImage.path != null && moduleImage.path != "")
        _uploadModuleImage(moduleId, moduleImage);
    } else {
      // Handle error
    }
  }

  void _uploadTopics(int moduleId) async {
    for (var topic in topic_data) {
      var jsonData = {
        "module_id": moduleId,
        "cec_client_id": topic['cec_client_id'],
        "title": topic['title'],
        "description": topic['description'],
        "duration": topic['duration'],
        "pages": topic['pages'],
        "is_visible": topic['is_visible'],
        "table_of_contents": topic['table_of_contents'],
        "content_items": topic['content_items'],
      };

      var uri = Uri.parse(
          '${Constants.InsightsReportsbaseUrl}/api/valuetainment/create_topic/');
      var response = await http.post(uri,
          body: jsonEncode(jsonData),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode == 201) {
        var topicResponse = jsonDecode(response.body);
        var topicId = topicResponse['topic_id'];
        if (topic['image'] != null && topic['image'] != "") {
          print("Uploading image for topic $topicId ${topic['image']}");
          print("gffghg ${topic['image']}");
          _uploadMedia(topicId, topic['image'], topic['video_file']);
        }
      } else {
        // Handle error
      }
    }
  }

  void _uploadModuleImage(int topicId, File imageFile) async {
    var uri = Uri.parse(
        '${Constants.InsightsReportsbaseUrl}/api/valuetainment/upload_module_image/');
    var request = http.MultipartRequest('POST', uri);

    request.fields['module_id'] = topicId.toString();
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path!));

    var response = await request.send();

    if (response.statusCode == 201) {
      // Image uploaded successfully
    } else {
      // Handle error
    }
  }

  void _uploadMedia(int topicId, File? imageFile, File? videoFile) async {
    var uri = Uri.parse(
        '${Constants.InsightsReportsbaseUrl}/api/valuetainment/upload_topic_media/');
    var request = http.MultipartRequest('POST', uri);

    request.fields['topic_id'] = topicId.toString();

    if (imageFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));
    }

    if (videoFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('video_file', videoFile.path));
    }

    var response = await request.send();

    if (response.statusCode == 201) {
      // Media uploaded successfully
    } else {
      // Handle error
    }
  }

  void _addNewQuestion(Map<String, dynamic> newQuestion) {
    setState(() {
      uploadContentMap2.add(newQuestion);
    });
  }

  double _sliderPosition = 0.0;
  int _selectedButton = 1;
  void _animateButton(int buttonNumber, BuildContext context) {
    restartInactivityTimer();
    DateTime? startDate = DateTime.now();
    DateTime? endDate = DateTime.now();

    setState(() {});

    _selectedButton = buttonNumber;
    if (buttonNumber == 1) {
      _sliderPosition = 0.0;
    } else if (buttonNumber == 2) {
      _sliderPosition = (MediaQuery.of(context).size.width / 3) - 18;
    } else if (buttonNumber == 3) {
      _sliderPosition = 2 * (MediaQuery.of(context).size.width / 3) - 32;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("Add Course Content"),
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
              shadowColor: Colors.grey,
            ),
            /*  floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      AdminAddQuestion(onAddQuestion: _addNewQuestion),
                ));
              },
              child: Icon(Icons.add),
            ),*/
            bottomNavigationBar: InkWell(
              onTap: () {
                // _add_module_content();                       // print(topic_data);
                _uploadModule();
              },
              child: Container(
                margin: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 16, bottom: 12),
                height: 44,
                decoration: BoxDecoration(
                    color: Constants.ctaColorLight,
                    border: Border.all(color: Colors.grey.withOpacity(0.75)),
                    borderRadius: BorderRadius.circular(32)),
                child: Center(
                  child: Text(
                    "SUBMIT",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24,
                  ),
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
                                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _animateButton(1, context);
                                    },
                                    child: Container(
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  3) -
                                              12,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(360)),
                                      height: 35,
                                      child: Center(
                                        child: Text(
                                          'Content',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _animateButton(2, context);
                                    },
                                    child: Container(
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  3) -
                                              12,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(360)),
                                      child: Center(
                                        child: Text(
                                          'Assessments',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _animateButton(3, context);
                                    },
                                    child: Container(
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  3) -
                                              12,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(360)),
                                      child: Center(
                                        child: Text(
                                          "FAQ's",
                                          style: TextStyle(color: Colors.black),
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
                            child: InkWell(
                              onTap: () {
                                _animateButton(3, context);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 3,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Constants
                                      .ctaColorLight, // Color of the slider
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: _selectedButton == 1
                                    ? Center(
                                        child: Text(
                                          'Content',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : _selectedButton == 2
                                        ? Center(
                                            child: Text(
                                              'Assessments',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : Center(
                                            child: Text(
                                              "FAQ's",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_selectedButton == 1)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 8),
                          child: Container(
                            height: 1,
                            color: Colors.grey.withOpacity(0.35),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 16, bottom: 0),
                          child: Row(
                            children: [
                              Text(
                                "Course Title:",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: CustomInputTransparent(
                            controller: titleController,
                            hintText: "Enter course title",
                            focusNode: titleFocusNode,
                            textInputAction: TextInputAction.next,
                            onChanged: (String) {},
                            onSubmitted: (String) {},
                            isPasswordField: false,
                          ),
                        ),
                        // Description
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 24, bottom: 0),
                          child: Row(
                            children: [
                              Text(
                                "Course Description:",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 16, right: 16, top: 8, bottom: 0),
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
                            obscureText: false,
                            focusNode: descriptionFocusNode,
                            onChanged: (val) {},
                            onSubmitted: (val) {},
                            controller: descriptionController,
                            maxLines: 5,
                            minLines: 4,
                            textInputAction: TextInputAction.next,
/*        validator: (val) {
            return RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(val!)
                ? null
                : "Please Enter Correct Email";
          },*/

                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Course Description",
                              prefixIcon: null,
                              suffixIcon: null,
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.1),
                              hintStyle: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 13.5,
                                    color: Colors.grey,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w500),
                              ),
                              contentPadding:
                                  EdgeInsets.only(left: 16, top: 16),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.0)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffED7D32)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 22, bottom: 8),
                          child: Row(
                            children: [
                              Text(
                                "Course Cover Page:",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                startInactivityTimer();
                                await _pickModuleImageFile();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.75)),
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                height: 44,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 16),
                                    child: Text(
                                      "Click To Upload A Cover Page",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Constants.ctaColorLight,
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (moduleImage.path != null &&
                            moduleImage.path!.isNotEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  height: 200,
                                  child: Image.file(File(moduleImage.path!))),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 24, bottom: 0),
                          child: Row(
                            children: [
                              Text(
                                "Course Topic And Content:",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 0, bottom: 0),
                          child: Divider(
                            color: Colors.grey.withOpacity(0.35),
                          ),
                        ),
                        topic_data.length > 0
                            ? ListView.builder(
                                itemCount: topic_data.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final topic = topic_data[index];
                                  return Card(
                                    surfaceTintColor: Colors.white,
                                    color: Colors.white,
                                    child: ListTile(
                                      onTap: () {
                                        Map<String, List<Map<String, dynamic>>>
                                            pageData = {};

                                        for (var contentItem
                                            in topic['content_items']) {
                                          String page =
                                              contentItem["page"].toString();
                                          if (pageData.containsKey(page)) {
                                            pageData[page]?.add(contentItem);
                                          } else {
                                            pageData[page] = [contentItem];
                                          }
                                        }

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ViewModule(
                                              module: topic,
                                              //pageData: pageData,
                                              index: index,
                                            ),
                                          ),
                                        );
                                      },
                                      title: Text(
                                          "${index + 1}) " + topic['title']),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //  SizedBox(height: 6),
                                          /*  if (topic['description'] != null)
                                            Text(
                                              "Description: " +
                                                  topic['description'],
                                              style: TextStyle(fontSize: 12),
                                            ),*/
                                          SizedBox(height: 4),
                                          if (topic['table_of_contents'] !=
                                              null)
                                            ...topic['table_of_contents']
                                                .map<Widget>((toc) {
                                              return Text(
                                                "TOC: " + toc['text'],
                                                style: TextStyle(fontSize: 12),
                                              );
                                            }).toList(),
                                          SizedBox(height: 4),
                                          if (topic['content_items'] != null)
                                            ...topic['content_items']
                                                .map<Widget>((content) {
                                              return Text(
                                                "Content: " + content['text'],
                                                style: TextStyle(fontSize: 12),
                                              );
                                            }).toList(),
                                          if (topic['image'] != null &&
                                              topic['image'] is File)
                                            Image.file(
                                              topic['image'],
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          if (topic['video_file'] != null)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                "Video: ${topic['video_file'].path.split('/').last}",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 12),
                                              ),
                                            ),
                                        ],
                                      ),
                                      trailing: Container(
                                        width: 100,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Iconsax.image),
                                              onPressed: () =>
                                                  _pickImageFile6(index),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                  CupertinoIcons.video_camera),
                                              onPressed: () =>
                                                  _pickVideoFile(index),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0,
                                      right: 16,
                                      top: 8,
                                      bottom: 12),
                                  child: Text(
                                    "No course content added, to add click below. ",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                startInactivityTimer();
                                //  _pickFile();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddTopic()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.75)),
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                height: 44,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 16),
                                    child: Text(
                                      "Click To Add A Topic",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Constants.ctaColorLight,
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16),
                      ],
                    ),
                  if (_selectedButton == 2)
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 8),
                        child: Container(
                          height: 1,
                          color: Colors.grey.withOpacity(0.35),
                        ),
                      ),
                      // Duration
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 24, bottom: 12),
                        child: Row(
                          children: [
                            Text(
                              "Assessment Duration (in minutes)",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: CustomInputTransparent(
                          controller: durationController,
                          hintText: "Assessment Duration (in minutes)",
                          focusNode: durationFocusNode,
                          textInputAction: TextInputAction.next,
                          onChanged: (String) {},
                          onSubmitted: (String) {},
                          isPasswordField: false,
                          integersOnly: true,
                        ),
                      ),
                      // Maximum Attempts
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 24, bottom: 12),
                        child: Row(
                          children: [
                            Text(
                              "Number of Attempts on Assessment Allowed",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: CustomInputTransparent(
                          controller: maximumAttemptsController,
                          hintText: "Number of Attempts",
                          focusNode: maximumAttemptsFocusNode,
                          textInputAction: TextInputAction.next,
                          onChanged: (String) {},
                          onSubmitted: (String) {},
                          isPasswordField: false,
                          integersOnly: true,
                        ),
                      ),
                      // Attempt Questions
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 24, bottom: 12),
                        child: Row(
                          children: [
                            Text(
                              "No of Questions Displayed per Assessment",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: CustomInputTransparent(
                          controller: attemptsQuestionsController,
                          hintText: "No of Questions for Assessment",
                          focusNode: attemptsQuestionsFocusNode,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {},
                          onSubmitted: (value) {},
                          isPasswordField: false,
                          integersOnly: true,
                        ),
                      ),
                      // Maximum Attempts
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 24, bottom: 12),
                        child: Row(
                          children: [
                            Text(
                              "Pass Mark",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: CustomInputTransparent(
                          controller: passPercentageController,
                          hintText: "Number of questions for each attempt",
                          focusNode: passMarkFocusNode,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {},
                          onSubmitted: (value) {},
                          isPasswordField: false,
                          integersOnly: true,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 16, bottom: 12),
                        child: Row(
                          children: [
                            Text(
                              "Assesment Opened / Available From",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          startInactivityTimer();
                          final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                Duration(days: 365),
                              ));

                          if (pickedDate != null) {
                            moduleStartDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            moduleEndDate = DateFormat('yyyy-MM-dd')
                                .format(pickedDate.add(Duration(days: 365)));
                            setState(() {});
                          } else {
                            startInactivityTimer();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.75)),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          margin: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 0, bottom: 12),
                          height: 48,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(moduleStartDate),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 16, bottom: 12),
                        child: Row(
                          children: [
                            Text(
                              "Assesment Closed By",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          startInactivityTimer();
                          final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                Duration(days: 365),
                              ));

                          if (pickedDate != null) {
                            moduleEndDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(() {});
                          } else {
                            startInactivityTimer();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.75)),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          margin: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 0, bottom: 12),
                          height: 48,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(moduleEndDate),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 16, bottom: 0),
                        child: Row(
                          children: [
                            Text(
                              "Upload Assessment Questions",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 0, bottom: 0),
                        child: Divider(
                          color: Colors.grey.withOpacity(0.35),
                        ),
                      ),
                      uploadContentMap2.length > 0
                          ? Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: uploadContentMap2.length,
                                  itemBuilder: (context, index) {
                                    final question = uploadContentMap2[index];
                                    // print("Question: ${question}");

                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminEditQuestion(
                                                      question: question,
                                                      index: index,
                                                    )));
                                      },
                                      child: Card(
                                        surfaceTintColor: Colors.white,
                                        color: Colors.white,
                                        child: ListTile(
                                          title: Text("${index + 1}) " +
                                                  question['text'] ??
                                              'No question text available'),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 6,
                                              ),
                                              if (question['option_1'] != null)
                                                Text(
                                                  "1) " + question['option_1'],
                                                  style: TextStyle(
                                                      color: question[
                                                                  'correct_answer'] ==
                                                              '1'
                                                          ? Colors.green
                                                          : Colors.black,
                                                      fontSize: 12),
                                                ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              if (question['option_2'] != null)
                                                Text(
                                                  "2) " + question['option_2'],
                                                  style: TextStyle(
                                                      color: question[
                                                                  'correct_answer'] ==
                                                              '2'
                                                          ? Colors.green
                                                          : Colors.black,
                                                      fontSize: 12),
                                                ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              if (question['option_3'] != null)
                                                Text(
                                                  "3) " + question['option_3'],
                                                  style: TextStyle(
                                                      color: question[
                                                                  'correct_answer'] ==
                                                              '3'
                                                          ? Colors.green
                                                          : Colors.black,
                                                      fontSize: 12),
                                                ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              if (question['option_4'] != null)
                                                Text(
                                                  "4) " + question['option_4'],
                                                  style: TextStyle(
                                                      color: question[
                                                                  'correct_answer'] ==
                                                              '4'
                                                          ? Colors.green
                                                          : Colors.black,
                                                      fontSize: 12),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            )
                          : Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16, top: 8, bottom: 12),
                                child: Text(
                                  "No questions available",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                      GestureDetector(
                        onTap: () async {
                          startInactivityTimer();
                          _pickFile2();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.75)),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          margin: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 0, bottom: 0),
                          height: 40,
                          child: Center(
                            child: Text(
                              "Upload questions to course",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Constants.ctaColorLight,
                                  fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                      _file != null
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16, top: 16, bottom: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Selected file: ${_file!.path}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16, top: 16, bottom: 12),
                              child: Row(
                                children: [
                                  Text(
                                    "No file uploaded",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),

                      if (_files.length > 0)
                        Container(
                          // height: _files.length * 60,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 24, right: 16.0, top: 8),
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
                                                builder: (context) =>
                                                    ImagePreviewPage(
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
                            left: 16.0, right: 16, top: 16, bottom: 12),
                        child: Row(
                          children: [
                            Text(
                              "Comments",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.75)),
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
                    ]),
                  if (_selectedButton == 3)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 8, bottom: 12),
                          child: Container(
                            height: 1,
                            color: Colors.grey.withOpacity(0.35),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            startInactivityTimer();
                            _showAddFAQDialog2(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.75)),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            margin: const EdgeInsets.only(
                                left: 16.0, right: 16, top: 0, bottom: 0),
                            height: 40,
                            child: Center(
                              child: Text(
                                "Add a Frequently Asked Question",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Constants.ctaColorLight,
                                    fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 16, bottom: 4),
                          child: Text(
                            "All FAQs",
                            style: TextStyle(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 0, bottom: 12),
                          child: Container(
                            height: 1,
                            color: Colors.grey.withOpacity(0.35),
                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: faqs.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0,
                                          right: 16,
                                          top: 0,
                                          bottom: 12),
                                      child: CustomCard(
                                        elevation: 6,
                                        color: Colors.white,
                                        child: ListTile(
                                          title: Text("${index + 1}) " +
                                              faqs[index].question),
                                          subtitle: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Category:" +
                                                      faqs[index].category,
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                Text(faqs[index].answer),
                                              ]),
                                          trailing: IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              setState(() {
                                                faqs.removeAt(index);
                                                faq_data.removeAt(index);
                                              });
                                            },
                                          ),
                                        ),
                                      )));
                            })
                      ],
                    )
                ],
              ),
            )));
  }

  void _showAddFAQDialog2(BuildContext context) {
    String category = "Sales";
    List<ValuetainmentHowTo> howtos = [];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        TextEditingController questionController = TextEditingController();
        TextEditingController answerController = TextEditingController();
        bool isVisible = true;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              buttonPadding: EdgeInsets.only(top: 0.0, left: 0, right: 0),
              insetPadding: EdgeInsets.only(left: 16.0, right: 16),
              titlePadding: EdgeInsets.only(right: 0),
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              contentPadding: const EdgeInsets.only(left: 0.0),
              title: Padding(
                padding: const EdgeInsets.only(top: 24.0, left: 0, right: 0),
                child: Text(
                  'Add a Frequently Asked Question',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 16, bottom: 12),
                      child: Text(
                        "Category:",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    /*    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 16.0,
                              left: 16,
                            ),
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 0.0),
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      value: category,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          category = newValue!;
                                        });
                                      },
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          color: Colors.white,
                                        ),
                                      ),
                                      selectedItemBuilder: (BuildContext ctxt) {
                                        return [
                                          "Sales",
                                          "Collections",
                                          "Quotex",
                                          "Claims",
                                          "Commision",
                                          "Legal",
                                          "Payments",
                                        ].map<Widget>((item) {
                                          return DropdownMenuItem(
                                            child: Text(
                                              item,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            value: item,
                                          );
                                        }).toList();
                                      },
                                      items: [
                                        "General",
                                        "Popular",
                                        "New",
                                        "Technical",
                                        "Support",
                                        "Legal",
                                        "Payments",
                                      ].map<DropdownMenuItem<String>>(
                                          (String item) {
                                        return DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      underline: Container(),
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),*/
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 12),
                      child: Text(
                        "Question:",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: CustomInputTransparent(
                        controller: questionController,
                        hintText: 'Question',
                        onChanged: (val) {},
                        onSubmitted: (val) {},
                        focusNode: FocusNode(),
                        textInputAction: TextInputAction.next,
                        isPasswordField: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 12),
                      child: Text(
                        "Answer:",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8, top: 12, bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.75)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: MultiLineTextField(
                          maxLines: 5,
                          label: 'Answer',
                          controller: answerController,
                          bordercolor: Colors.transparent,
                        ),
                      ),
                    ),
                    for (ValuetainmentHowTo howto in howtos)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomCard(
                          elevation: 6,
                          color: Colors.white,
                          child: ListTile(
                            title: Text(
                              howto.stepNo + ") ${howto.text}",
                              style: TextStyle(fontSize: 14),
                            ),
                            trailing: IconButton(
                              icon: Icon(CupertinoIcons.delete),
                              onPressed: () {
                                setState(() {
                                  howtos.remove(howto);
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16.0, top: 12, bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            "Visible:",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Switch(
                            value: isVisible,
                            onChanged: (val) {
                              setState(() {
                                isVisible = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _showAddHowToDialog2(context).then((val) {
                          if (val != null) {
                            setState(() {
                              howtos.add(val);
                            });
                          }
                        });
                      },
                      child: Center(
                        child: Text(
                          "Add a how to",
                          style: TextStyle(
                            color: Constants.ctaColorLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    ValuetainmentFAQ newFaq = ValuetainmentFAQ(
                        faqId: 0,
                        category: category,
                        moduleId: 0,
                        question: questionController.text,
                        answer: answerController.text,
                        isVisible: isVisible,
                        imageId: null,
                        timestamp: DateTime.now(),
                        lastModified: DateTime.now(),
                        howToSteps: howtos,
                        isExpanded: false);
                    List<Map<String, dynamic>> howtos_map = [];
                    for (ValuetainmentHowTo howto in newFaq.howToSteps) {
                      howtos_map.add({
                        "step_no": howto.stepNo,
                        "text": howto.text,
                        "is_visible": howto.isVisible,
                      });
                    }

                    faq_data.add({
                      "category": widget.module_name,
                      "question": questionController.text,
                      "answer": answerController.text,
                      "is_visible": isVisible,
                      "how_to_steps": howtos_map,
                    });
                    faqs.add(newFaq);
                    Navigator.of(context).pop();
                    valuetainmentValue.value++;
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<ValuetainmentHowTo?> _showAddHowToDialog2(BuildContext context) async {
    List<String> steps = [
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "10",
      "11",
      "12",
      "13",
      "14",
      "15",
      "16",
      "17",
      "18",
      "19",
      "20"
    ];
    String step = "1";

    TextEditingController answerController = TextEditingController();
    bool isVisible = true;

    return showDialog<ValuetainmentHowTo>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              buttonPadding: EdgeInsets.only(top: 0.0, left: 0, right: 0),
              insetPadding: EdgeInsets.only(left: 16.0, right: 16),
              titlePadding: EdgeInsets.only(right: 0),
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              contentPadding: const EdgeInsets.only(left: 0.0),
              title: Padding(
                padding: const EdgeInsets.only(top: 24.0, left: 0, right: 0),
                child: Text(
                  'Add a How To',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 16, bottom: 12),
                      child: Text(
                        "Step number:",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 16.0,
                        left: 16,
                      ),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 24.0, top: 0),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: step,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    step = newValue!;
                                  });
                                },
                                items: steps.map<DropdownMenuItem<String>>(
                                    (String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                underline: Container(),
                                dropdownColor: Colors.white,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                iconEnabledColor: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 12),
                      child: Text(
                        "How To Text:",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8, top: 12, bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.75)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: MultiLineTextField(
                          maxLines: 5,
                          label: 'How to description',
                          controller: answerController,
                          bordercolor: Colors.transparent,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16.0, top: 12, bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            "Visible:",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Switch(
                            value: isVisible,
                            onChanged: (val) {
                              setState(() {
                                isVisible = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    ValuetainmentHowTo newHowTo = ValuetainmentHowTo(
                      howToId: 0, // Placeholder ID, should be generated
                      stepNo: step,
                      text: answerController.text,
                      isVisible: isVisible,
                      timestamp: DateTime.now(),
                      lastModified: DateTime.now(),
                    );
                    Navigator.of(context).pop(newHowTo);
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    startInactivityTimer();
    uploadContentMap = [];
    uploadContentMap2 = [];
    topic_data = [];
    moduleImage = File("");

    myNotifier = MyNotifier(valuetainmentValue, context);
    valuetainmentValue.addListener(() {
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
            'https://miinsightsapps.net/parlour/getParlourRatesExtras?client_id=${Constants.cec_client_id}'));

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
                    titleController.text = "";
                    descriptionController.text = "";
                    notesController.text = "";
                    setState(() {});

                    Navigator.of(context).pop();
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

/*
  _pickAndConvertFiles(String module_name, bool allowMultiple) async {
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
              print("ghgg0 ${topic_data.length} $module_name");
              print(topic_data);
              int index = topic_data
                  .indexWhere((element) => element["title"] == module_name);
              moduleImage = newPlatformFile;
              print("ghgg1 ${topic_data.length}");
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
*/

  _pickModuleImageFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        moduleImage = File(result.files.single.path!);
      });
    }
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
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.grey,
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

class AdminEditQuestion extends StatefulWidget {
  final Map<String, dynamic> question;
  final int index;
  const AdminEditQuestion(
      {super.key, required this.question, required this.index});

  @override
  State<AdminEditQuestion> createState() => _AdminEditQuestionState();
}

class _AdminEditQuestionState extends State<AdminEditQuestion> {
  TextEditingController questionController = TextEditingController();
  TextEditingController option1Controller = TextEditingController();
  TextEditingController option2Controller = TextEditingController();
  TextEditingController option3Controller = TextEditingController();
  TextEditingController option4Controller = TextEditingController();

  FocusNode questionFocusNode = FocusNode();
  FocusNode option1FocusNode = FocusNode();
  FocusNode option2FocusNode = FocusNode();
  FocusNode option3FocusNode = FocusNode();
  FocusNode option4FocusNode = FocusNode();
  String correct_answer = "";
  List<String> correct_answers = [
    "1",
    "2",
    "3",
    "4",
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 6,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.grey,
          title: const Text(
            "Edit Question",
            style: TextStyle(color: Colors.black),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              CupertinoIcons.back,
              color: Colors.black,
              size: 24,
            ),
          ),
        ),
        body: Column(
          children: [
            const Padding(
              padding:
                  EdgeInsets.only(left: 16.0, right: 16, top: 24, bottom: 12),
              child: Row(
                children: [
                  Text(
                    "Question",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: CustomInputSquare(
                controller: questionController,
                hintText: "Enter your question",
                focusNode: questionFocusNode,
                textInputAction: TextInputAction.next,
                onChanged: (val) {},
                onSubmitted: (val) {},
                isPasswordField: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, top: 24, bottom: 12),
              child: Row(
                children: [
                  Text(
                    "Option 1",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: CustomInputSquare(
                controller: option1Controller,
                hintText: "Option 1",
                focusNode: option1FocusNode,
                textInputAction: TextInputAction.next,
                onChanged: (val) {},
                onSubmitted: (val) {},
                isPasswordField: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, top: 24, bottom: 12),
              child: Row(
                children: [
                  Text(
                    "Option 2",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: CustomInputSquare(
                controller: option2Controller,
                hintText: "Option 2",
                focusNode: option2FocusNode,
                textInputAction: TextInputAction.next,
                onChanged: (val) {},
                onSubmitted: (val) {},
                isPasswordField: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, top: 24, bottom: 12),
              child: Row(
                children: [
                  Text(
                    "Option 3",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: CustomInputSquare(
                controller: option3Controller,
                hintText: "Option 3",
                focusNode: option3FocusNode,
                textInputAction: TextInputAction.next,
                onChanged: (val) {},
                onSubmitted: (val) {},
                isPasswordField: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, top: 24, bottom: 12),
              child: Row(
                children: [
                  Text(
                    "Option 4",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: CustomInputSquare(
                controller: option4Controller,
                hintText: "Option 4",
                focusNode: option4FocusNode,
                textInputAction: TextInputAction.next,
                onChanged: (val) {},
                onSubmitted: (val) {},
                isPasswordField: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, top: 24, bottom: 12),
              child: Row(
                children: [
                  Text(
                    "Correct answer",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 24.0, top: 0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: correct_answer,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          correct_answer = newValue!;
                                        });
                                      },

                                      selectedItemBuilder: (BuildContext ctxt) {
                                        return correct_answers
                                            .map<Widget>((item) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12.0),
                                            child: DropdownMenuItem(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Text("${item}",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                                value: item),
                                          );
                                        }).toList();
                                      },
                                      items: correct_answers
                                          .map<DropdownMenuItem<String>>(
                                              (String monthName) {
                                        return DropdownMenuItem<String>(
                                          value: monthName,
                                          child: Text(
                                            monthName,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                              color: Colors
                                                  .black, // Dropdown items text color
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      underline:
                                          Container(), // Removes underline if not needed
                                      // Dropdown background color
                                      style: TextStyle(
                                        color: Colors
                                            .white, // This sets the selected item text color
                                      ),
                                      // Changes the dropdown icon color
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                uploadContentMap2[widget.index] = {
                  "text": questionController.text,
                  "option_1": option1Controller.text,
                  "option_2": option2Controller.text,
                  "option_3": option3Controller.text,
                  "option_4": option4Controller.text,
                  "correct_answer": correct_answer
                };
                Navigator.of(context).pop();
                valuetainmentValue.value++;
              },
              child: Container(
                margin: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 16, bottom: 12),
                height: 44,
                decoration: BoxDecoration(
                    color: Constants.ctaColorLight,
                    border: Border.all(color: Colors.grey.withOpacity(0.75)),
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text(
                    "Update question",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    questionController.text = widget.question['text'] ?? "";
    option1Controller.text = widget.question["option_1"];
    option2Controller.text = widget.question["option_2"];
    option3Controller.text = widget.question["option_3"];
    option4Controller.text = widget.question["option_4"];
    correct_answer = widget.question["correct_answer"] ?? "1";
    setState(() {});
  }
}

class AdminAddQuestion extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddQuestion;

  const AdminAddQuestion({Key? key, required this.onAddQuestion})
      : super(key: key);

  @override
  State<AdminAddQuestion> createState() => _AdminAddQuestionState();
}

class _AdminAddQuestionState extends State<AdminAddQuestion> {
  TextEditingController questionController = TextEditingController();
  TextEditingController option1Controller = TextEditingController();
  TextEditingController option2Controller = TextEditingController();
  TextEditingController option3Controller = TextEditingController();
  TextEditingController option4Controller = TextEditingController();

  FocusNode questionFocusNode = FocusNode();
  FocusNode option1FocusNode = FocusNode();
  FocusNode option2FocusNode = FocusNode();
  FocusNode option3FocusNode = FocusNode();
  FocusNode option4FocusNode = FocusNode();
  String correct_answer = "1";
  List<String> correct_answers = ["1", "2", "3", "4"];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 6,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.grey,
          title: const Text(
            "Add Question",
            style: TextStyle(color: Colors.black),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              CupertinoIcons.back,
              color: Colors.black,
              size: 24,
            ),
          ),
        ),
        body: Column(
          children: [
            const Padding(
              padding:
                  EdgeInsets.only(left: 16.0, right: 16, top: 24, bottom: 12),
              child: Row(
                children: [
                  Text(
                    "Question",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: TextField(
                controller: questionController,
                focusNode: questionFocusNode,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "Enter your question",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, top: 24, bottom: 12),
              child: Row(
                children: [
                  Text(
                    "Option 1",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: TextField(
                controller: option1Controller,
                focusNode: option1FocusNode,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "Option 1",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, top: 24, bottom: 12),
              child: Row(
                children: [
                  Text(
                    "Option 2",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: TextField(
                controller: option2Controller,
                focusNode: option2FocusNode,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "Option 2",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, top: 24, bottom: 12),
              child: Row(
                children: [
                  Text(
                    "Option 3",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: TextField(
                controller: option3Controller,
                focusNode: option3FocusNode,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "Option 3",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, top: 24, bottom: 12),
              child: Row(
                children: [
                  Text(
                    "Option 4",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: TextField(
                controller: option4Controller,
                focusNode: option4FocusNode,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "Option 4",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, top: 24, bottom: 12),
              child: Row(
                children: [
                  Text(
                    "Correct answer",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 24.0, top: 0),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: correct_answer,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        correct_answer = newValue!;
                                      });
                                    },
                                    selectedItemBuilder: (BuildContext ctxt) {
                                      return correct_answers
                                          .map<Widget>((item) {
                                        return DropdownMenuItem(
                                            child: Text("${item}",
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            value: item);
                                      }).toList();
                                    },
                                    items: correct_answers
                                        .map<DropdownMenuItem<String>>(
                                            (String monthName) {
                                      return DropdownMenuItem<String>(
                                        value: monthName,
                                        child: Text(
                                          monthName,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                            color: Colors
                                                .black, // Dropdown items text color
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    underline:
                                        Container(), // Removes underline if not needed
                                    dropdownColor: Colors
                                        .white, // Dropdown background color
                                    style: TextStyle(
                                      color: Colors
                                          .white, // This sets the selected item text color
                                    ),
                                    iconEnabledColor: Colors
                                        .white, // Changes the dropdown icon color
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Map<String, dynamic> newQuestion = {
                  "question_id": DateTime.now().millisecondsSinceEpoch,
                  "text": questionController.text,
                  "option_1": option1Controller.text,
                  "option_2": option2Controller.text,
                  "option_3": option3Controller.text,
                  "option_4": option4Controller.text,
                  "correct_answer": correct_answer
                };
                widget.onAddQuestion(newQuestion);
                Navigator.of(context).pop();
              },
              child: Container(
                margin: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 16, bottom: 12),
                height: 44,
                decoration: BoxDecoration(
                    color: Constants.ctaColorLight,
                    border: Border.all(color: Colors.grey.withOpacity(0.75)),
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text(
                    "Save question",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewModule extends StatefulWidget {
  final int index;
  final Map<String, dynamic> module;

  const ViewModule({Key? key, required this.index, required this.module})
      : super(key: key);

  @override
  State<ViewModule> createState() => _ViewModuleState();
}

class _ViewModuleState extends State<ViewModule> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController durationController;
  late TextEditingController maximumAttemptsController;
  late TextEditingController attemptsQuestionsController;
  late TextEditingController passPercentageController;
  late TextEditingController moduleController;
  late TextEditingController timestampController;
  late TextEditingController imageController;
  late TextEditingController dataController;
  late TextEditingController notesController;
  List<TextEditingController> contenttitles = [];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.module['title']);
    descriptionController =
        TextEditingController(text: widget.module['description']);
    durationController =
        TextEditingController(text: widget.module['duration'].toString());
    maximumAttemptsController = TextEditingController(
        text: widget.module['maximum_attempts']?.toString() ?? '');
    attemptsQuestionsController = TextEditingController(
        text: widget.module['attempts_questions']?.toString() ?? '');
    passPercentageController = TextEditingController(
        text: widget.module['pass_percentage']?.toString() ?? '');
    moduleController =
        TextEditingController(text: widget.module['module'] ?? '');
    timestampController =
        TextEditingController(text: widget.module['timestamp']);
    // imageController = TextEditingController(text: widget.module['image'] ?? '');
    dataController = TextEditingController(text: widget.module['data'] ?? '');
    notesController = TextEditingController(text: widget.module['notes'] ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    durationController.dispose();
    maximumAttemptsController.dispose();
    attemptsQuestionsController.dispose();
    passPercentageController.dispose();
    moduleController.dispose();
    timestampController.dispose();
    imageController.dispose();
    dataController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void _saveModule() {
    setState(() {
      widget.module['title'] = titleController.text;
      widget.module['description'] = descriptionController.text;
      widget.module['duration'] = int.tryParse(durationController.text) ?? 0;
      widget.module['maximum_attempts'] =
          int.tryParse(maximumAttemptsController.text) ?? 0;
      widget.module['attempts_questions'] =
          int.tryParse(attemptsQuestionsController.text) ?? 0;
      widget.module['pass_percentage'] =
          int.tryParse(passPercentageController.text) ?? 0;
      widget.module['module'] = moduleController.text;
      widget.module['timestamp'] = timestampController.text;
      widget.module['image'] = imageController.text;
      widget.module['notes'] = notesController.text;
    });
    valuetainmentValue.value++;
    Navigator.of(context).pop();
  }

  void _addTopic() {
    contenttitles.add(TextEditingController());
    setState(() {
      widget.module['content_items'].add({
        "id": widget.module['content_items'].length,
        "text": "Page Item",
        "subtext": "",
        "page": 0,
        "type": "Heading",
        "topic": "",
      });
    });
  }

  void _addContentItem(Map<String, dynamic> topic) {
    setState(() {
      topic['content'].add({
        "text": "New Content Item",
        "subtext": null,
        "page": 0,
        "type": "Paragraph",
        "topic": null,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'View and Edit',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.grey,
        actions: [
          IconButton(
            icon: Icon(Iconsax.save_add),
            onPressed: _saveModule,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (widget.module['image'] != "")
              Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: Image.file(widget.module['image'])),
            Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 8),
                child: Text(
                  "Topic/Title:",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 8.0),
              child: CustomInputTransparent(
                controller: titleController,
                onChanged: (val) {
                  //    newTopic["title"] = titleController.text;
                },
                hintText: "Enter a Topic/Title",
                onSubmitted: (String) {},
                focusNode: FocusNode(),
                textInputAction: TextInputAction.next,
                isPasswordField: false,
                maxLines: 1,
              ),
            ),

            /*   _buildTextField(titleController, 'Title'),
            _buildTextField(descriptionController, 'Description', maxLines: 3),
            _buildTextField(durationController, 'Duration',
                inputType: TextInputType.number),
            _buildTextField(notesController, 'Notes', maxLines: 3),*/
            SizedBox(height: 16),
            Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 8),
                child: Text(
                  "Page Content:",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, top: 0, bottom: 0),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.module['content_items'].length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> contentItem =
                      widget.module['content_items'][index];

                  return ContentItem(contentItem: contentItem);
                }),
            SizedBox(height: 16),
            Center(
              child: InkWell(
                onTap: _addTopic,
                child: Text(
                  'Add a page item',
                  style: TextStyle(
                      color: Constants.ctaColorLight,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Constants.ctaColorLight),
                ),
              ),
            ),
            /* InkWell(
              onTap: () {
                _saveModule();
                print(widget.module['content_items']);
                MotionToast.success(
                  onClose: () {},
                  description: Text("Saved!"),
                ).show(context);
                //valuetainmentValue.value++;
              },
              child: Container(
                margin: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 16, bottom: 12),
                height: 44,
                decoration: BoxDecoration(
                    color: Constants.ctaColorLight,
                    border: Border.all(color: Colors.grey.withOpacity(0.75)),
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text(
                    "Save Changes",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}

Map<int, List<PageContentItem>> groupedContentItems = {};

class AddTopic extends StatefulWidget {
  const AddTopic({Key? key}) : super(key: key);

  @override
  State<AddTopic> createState() => _AddTopicState();
}

Map<String, dynamic> newTopic = {
  "cec_client_id": Constants.cec_client_id,
  "title": "",
  "description": "",
  "duration": 0,
  "maximum_attempts": 0,
  "attempts_questions": 0,
  "pass_percentage": 0,
  "notes": "",
  "table_of_contents": [],
  "content_items": []
};

class _AddTopicState extends State<AddTopic> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController maximumAttemptsController =
      TextEditingController();
  final TextEditingController attemptsQuestionsController =
      TextEditingController();
  final TextEditingController passPercentageController =
      TextEditingController();
  final TextEditingController moduleController = TextEditingController();
  final TextEditingController timestampController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    durationController.dispose();
    maximumAttemptsController.dispose();
    attemptsQuestionsController.dispose();
    passPercentageController.dispose();
    moduleController.dispose();
    timestampController.dispose();
    imageController.dispose();
    dataController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    groupedContentItems = {};
    newTopic = {
      "cec_client_id": Constants.cec_client_id,
      "title": "",
      "description": "",
      "duration": 0,
      "maximum_attempts": 0,
      "attempts_questions": 0,
      "pass_percentage": 0,
      "image": "",
      "notes": "",
      "table_of_contents": [],
      "content_items": []
    };
    myNotifier = MyNotifier(valuetainmentValue, context);
    valuetainmentValue.addListener(() {
      groupItems();
      setState(() {});
      Future.delayed(Duration(seconds: 3)).then((value) {
        setState(() {});
      });
    });
  }

  void groupItems() {
    groupedContentItems = {};
    for (var item in newTopic['content_items']) {
      print("item $item");
      if (!groupedContentItems.containsKey(item["page"])) {
        groupedContentItems[item["page"]] = [];
      }
      groupedContentItems[item["page"]]!.add(PageContentItem.fromJson(item));
    }

    var sortedGroupedContentItems = Map.fromEntries(
        groupedContentItems.entries.toList()
          ..sort((e1, e2) => e1.key.compareTo(e2.key)));
    groupedContentItems = sortedGroupedContentItems;

    setState(() {});
    print("groupedContentItems $groupedContentItems");
  }

  Key unq1 = UniqueKey();

  void _saveModule() {
    topic_data.add(newTopic);
    valuetainmentValue.value++;

    // Here you can add your save functionality to store the new module
    print(newTopic);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.grey,
        title: Text('Add Topic And Content'),
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 8),
                child: Text(
                  "Topic/Title:",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 8.0),
              child: CustomInputTransparent(
                controller: titleController,
                onChanged: (val) {
                  newTopic["title"] = titleController.text;
                },
                hintText: "Enter a Topic/Title",
                onSubmitted: (String) {},
                focusNode: FocusNode(),
                textInputAction: TextInputAction.next,
                isPasswordField: false,
                maxLines: 1,
              ),
            ),
            SizedBox(height: 16),
            Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 8),
                child: Text(
                  "Page Content:",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, top: 0, bottom: 0),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
              ),
            ),
            // Text(groupedContentItems.length.toString()),
            ListView.builder(
                shrinkWrap: true,
                key: unq1,
                physics: NeverScrollableScrollPhysics(),
                itemCount: groupedContentItems.length,
                itemBuilder: (context, index) {
                  List<PageContentItem>? contentItem1 =
                      groupedContentItems.values.toList()[index];
                  print(
                      "contentItem1 $index ${contentItem1} ${groupedContentItems[index]}");
                  if (contentItem1 == null) {
                    return Container();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, top: 8, bottom: 8),
                        child: Text(
                          "Page ${index + 1}",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                      Container(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: contentItem1.length,
                            itemBuilder: (context, index) {
                              PageContentItem contentItem = contentItem1[index];
                              if (contentItem == null) {
                                return Container();
                              }
                              return ContentItem2(
                                  index: index + 1, contentItem: contentItem);
                            }),
                      ),
                    ],
                  );
                }),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    //startInactivityTimer();
                    //  _pickFile();
                    if (titleController.text.isNotEmpty) {
                      _addTopic();
                      valuetainmentValue.value++;
                    } else {
                      MotionToast.error(
                        onClose: () {},
                        description: Text("Please enter a title"),
                      ).show(context);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.75)),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    height: 44,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: Text(
                          "Click To Add Page Content",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Constants.ctaColorLight,
                              fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, top: 24, bottom: 0),
              child: Row(
                children: [
                  Text(
                    "Course Table of Contents",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, top: 0, bottom: 0),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
              ),
            ),
            SizedBox(height: 16),
            ListView.builder(
                shrinkWrap: true,
                key: unq1,
                physics: NeverScrollableScrollPhysics(),
                itemCount: newTopic["table_of_contents"].length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, top: 8, bottom: 8),
                        child: Text(
                          "Page ${index + 1}",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    //  _pickFile();
                    if (titleController.text.isNotEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddTOCPage()));
                      valuetainmentValue.value++;
                    } else {
                      MotionToast.error(
                        onClose: () {},
                        description: Text("Please enter a title"),
                      ).show(context);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.75)),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    height: 44,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: Text(
                          "Click To Add Table of Contents Item",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Constants.ctaColorLight,
                              fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            /*      InkWell(
              onTap: () {
                _saveModule();
                print(newTopic['content_items']);
                MotionToast.success(
                  onClose: () {},
                  description: Text("Saved!"),
                ).show(context);
                //valuetainmentValue.value++;
              },
              child: Container(
                margin: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 16, bottom: 12),
                height: 44,
                decoration: BoxDecoration(
                    color: Constants.ctaColorLight,
                    border: Border.all(color: Colors.grey.withOpacity(0.75)),
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text(
                    "Save Changes",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),*/
          ],
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          if (titleController.text.isNotEmpty) {
            _saveModule();
            valuetainmentValue.value++;
          } else {
            MotionToast.error(
              onClose: () {},
              description: Text("Please enter a title"),
            ).show(context);
          }
        },
        child: Container(
          margin:
              const EdgeInsets.only(left: 16.0, right: 16, top: 16, bottom: 12),
          height: 44,
          decoration: BoxDecoration(
              color: Constants.ctaColorLight,
              border: Border.all(color: Colors.grey.withOpacity(0.75)),
              borderRadius: BorderRadius.circular(32)),
          child: Center(
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType inputType = TextInputType.text, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 8),
            child: Text(
              "${label}",
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
            )),
        Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 8.0),
          child: CustomInputTransparent(
            controller: controller,
            onChanged: (val) {},
            hintText: "Enter ${label.toLowerCase()}",
            onSubmitted: (String) {},
            focusNode: FocusNode(),
            textInputAction: TextInputAction.next,
            isPasswordField: false,
            maxLines: maxLines,
          ),
        ),
      ],
    );
  }

  void _addTopic() {
    //contenttitles.add(TextEditingController());
    int topic_id = 0;
    print("newTopic['content_items'] ${newTopic['content_items']}");
    if ((newTopic['content_items'] ?? []).length > 0) {
      topic_id = newTopic['content_items'].length;
    }
    setState(() {
      newTopic['content_items'].add({
        "id": topic_id,
        "text": "Add Paragraphs/Content",
        "subtext": "",
        "page": 1,
        "type": "Heading",
        "topic": "",
      });
    });
    valuetainmentValue.value++;
  }
}

class ContentItem extends StatefulWidget {
  final Map<String, dynamic> contentItem;
  const ContentItem({super.key, required this.contentItem});

  @override
  State<ContentItem> createState() => _ContentItemState();
}

class _ContentItemState extends State<ContentItem> {
  String type = "Paragraph";
  String label = "Paragraph";
  String page = "1";
  List<String> pages = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20"
  ];
  TextEditingController txt = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      surfaceTintColor: Colors.white,
      color: Colors.white,
      child: ExpansionTile(
        //  underline: Container(),
        title: Text(widget.contentItem['text'] ?? ""),
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16, top: 4, bottom: 8),
            child: Row(
              children: [
                Text(
                  "Confirm Page Number",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 16.0,
              left: 16,
            ),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24.0, top: 0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: page, //Paragraph, heading, image, video
                      onChanged: (String? newValue) {
                        setState(() {
                          widget.contentItem['page'] = int.parse(newValue!);
                          page = newValue!;
                        });
                      },
                      selectedItemBuilder: (BuildContext ctxt) {
                        return pages.map<Widget>((item) {
                          return DropdownMenuItem(
                              child: Text("${item}",
                                  style: TextStyle(color: Colors.black)),
                              value: item);
                        }).toList();
                      },
                      items: pages
                          .map<DropdownMenuItem<String>>((String monthName) {
                        return DropdownMenuItem<String>(
                          value: monthName,
                          child: Text(
                            monthName,
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
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16, top: 24, bottom: 6),
            child: Row(
              children: [
                Text(
                  "Choose Body Type (i.e Heading, Content etc)",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 16.0,
              left: 16,
            ),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 0),
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      value: type, //Paragraph, heading, image, video
                      onChanged: (String? newValue) {
                        setState(() {
                          type = newValue!;
                        });
                      },
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white,
                        ),
                      ),
                      selectedItemBuilder: (BuildContext ctxt) {
                        return [
                          "Heading",
                          "Bullet",
                          "Paragraph",
                          "Image",
                          "Video"
                        ].map<Widget>((item) {
                          return DropdownMenuItem(
                              child: Text("${item}",
                                  style: TextStyle(color: Colors.black)),
                              value: item);
                        }).toList();
                      },
                      items: [
                        "Heading",
                        "Bullet",
                        "Paragraph",
                        "Image",
                        "Video"
                      ].map<DropdownMenuItem<String>>((String monthName) {
                        return DropdownMenuItem<String>(
                          value: monthName,
                          child: Text(
                            monthName,
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
                      //dropdownColor: Colors.white, // Dropdown background color
                      style: TextStyle(
                        color: Colors
                            .white, // This sets the selected item text color
                      ),
                      // iconEnabledColor:
                      //     Colors.white, // Changes the dropdown icon color
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 24, bottom: 4),
                child: Row(
                  children: [
                    Text(
                      "Add Body/Content (i.e Heading, etc)",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 14, right: 16, top: 8, bottom: 0),
            width: MediaQuery.of(context).size.width,
            child: TextField(
              obscureText: false,
              focusNode: FocusNode(),
              onChanged: (val) {
                widget.contentItem['text'] = txt.text;
                setState(() {});
              },
              onSubmitted: (val) {},
              controller: txt,
              maxLines: 5,
              minLines: 4,
              textInputAction: TextInputAction.next,
/*        validator: (val) {
            return RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(val!)
                ? null
                : "Please Enter Correct Email";
          },*/

              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Course Description",
                prefixIcon: null,
                suffixIcon: null,
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                hintStyle: GoogleFonts.inter(
                  textStyle: TextStyle(
                      fontSize: 13.5,
                      color: Colors.grey,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w500),
                ),
                contentPadding: EdgeInsets.only(left: 16, top: 16),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.0)),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffED7D32)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.5),
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  @override
  void initState() {
    if (widget.contentItem['page'] == null ||
        widget.contentItem['page'] == 0 ||
        widget.contentItem['page'] == "") {
      widget.contentItem['page'] = 1;
    }

    super.initState();
  }
}

class ContentItem2 extends StatefulWidget {
  final PageContentItem contentItem;
  final int index;
  const ContentItem2(
      {super.key, required this.contentItem, required this.index});

  @override
  State<ContentItem2> createState() => _ContentItem2State();
}

class _ContentItem2State extends State<ContentItem2> {
  String type = "Paragraph";
  String label = "Paragraph";
  String page = "1";
  List<String> pages = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20"
  ];
  TextEditingController txt = new TextEditingController();
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        child: isEditing == false
            ? InkWell(
                onTap: () {
                  isEditing = true;
                  setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.withOpacity(0.15)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 4, bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, bottom: 4),
                                child: Text(
                                  "${widget.index}) ${newTopic['content_items'][widget.contentItem.id]['type']} - " +
                                      widget.contentItem.text,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : InkWell(
                onTap: () {
                  isEditing = false;
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomCard(
                    elevation: 6,
                    color: Colors.white,
                    child: Column(
                      //  underline: Container(),

                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 20, bottom: 8),
                          child: Row(
                            children: [
                              Text(
                                "Set Page Number",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 16.0,
                            left: 16,
                          ),
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 24.0, top: 0),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value:
                                        page, //Paragraph, heading, image, video
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        newTopic['content_items']
                                                [widget.contentItem.id]
                                            ['page'] = int.parse(newValue!);
                                        widget.contentItem.page =
                                            int.parse(newValue!);
                                        page = newValue!;
                                      });
                                    },
                                    selectedItemBuilder: (BuildContext ctxt) {
                                      return pages.map<Widget>((item) {
                                        return DropdownMenuItem(
                                            child: Text("${item}",
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            value: item);
                                      }).toList();
                                    },
                                    items: [
                                      for (int i = 0;
                                          i < groupedContentItems.length + 1;
                                          i++)
                                        (i + 1).toString()
                                    ].map<DropdownMenuItem<String>>(
                                        (String monthName) {
                                      return DropdownMenuItem<String>(
                                        value: monthName,
                                        child: Text(
                                          monthName,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                            color: Colors
                                                .black, // Dropdown items text color
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    underline:
                                        Container(), // Removes underline if not needed
                                    dropdownColor: Colors
                                        .white, // Dropdown background color
                                    style: TextStyle(
                                      color: Colors
                                          .white, // This sets the selected item text color
                                    ),
                                    iconEnabledColor: Colors
                                        .white, // Changes the dropdown icon color
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 24, bottom: 6),
                          child: Row(
                            children: [
                              Text(
                                "Choose Body Type (i.e Paragraph, etc)",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 16.0,
                                  left: 16,
                                ),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0.0, top: 0),
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          value:
                                              type, //Paragraph, heading, image, video
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              type = newValue!;
                                              newTopic['content_items']
                                                      [widget.contentItem.id]
                                                  ['type'] = newValue;
                                            });
                                          },
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: 200,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              color: Colors.white,
                                            ),
                                          ),
                                          selectedItemBuilder:
                                              (BuildContext ctxt) {
                                            return [
                                              "Heading",
                                              "Paragraph",
                                              "Bullet",
                                              "Image",
                                              "Video"
                                            ].map<Widget>((item) {
                                              return DropdownMenuItem(
                                                  child: Text("${item}",
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                  value: item);
                                            }).toList();
                                          },
                                          items: [
                                            "Heading",
                                            "Paragraph",
                                            "Image",
                                            "Bullet",
                                            "Video"
                                          ].map<DropdownMenuItem<String>>(
                                              (String monthName) {
                                            return DropdownMenuItem<String>(
                                              value: monthName,
                                              child: Text(
                                                monthName,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: false,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                  color: Colors
                                                      .black, // Dropdown items text color
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          underline:
                                              Container(), // Removes underline if not needed
                                          //dropdownColor: Colors.white, // Dropdown background color
                                          style: TextStyle(
                                            color: Colors
                                                .white, // This sets the selected item text color
                                          ),
                                          // iconEnabledColor:
                                          //     Colors.white, // Changes the dropdown icon color
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16, top: 24, bottom: 4),
                              child: Row(
                                children: [
                                  Text(
                                    "Add Body/Content (i.e Heading, etc)",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 14, right: 16, top: 8, bottom: 0),
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
                            obscureText: false,
                            focusNode: FocusNode(),
                            onChanged: (val) {
                              widget.contentItem.text = txt.text;
                              newTopic['content_items'][widget.contentItem.id]
                                  ['text'] = txt.text;
                              setState(() {});
                            },
                            onSubmitted: (val) {},
                            controller: txt,
                            maxLines: 10,
                            minLines: 4,
                            textInputAction: TextInputAction.next,
                            /*        validator: (val) {
                    return RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val!)
                        ? null
                        : "Please Enter Correct Email";
                                  },*/

                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Course Description",
                              prefixIcon: null,
                              suffixIcon: null,
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.1),
                              hintStyle: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 13.5,
                                    color: Colors.grey,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w500),
                              ),
                              contentPadding:
                                  EdgeInsets.only(left: 16, top: 16),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.0)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffED7D32)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5),
                          ),
                        ),
                        SizedBox(height: 12),
                        InkWell(
                          onTap: () {
                            isEditing = false;
                            valuetainmentValue.value++;
                            setState(() {});
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(
                                color: Constants.ctaColorLight,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  @override
  void initState() {
    if (widget.contentItem.page == null ||
        widget.contentItem.page == 0 ||
        widget.contentItem.page == "") {
      // widget.contentItem.page = 1;
    }

    super.initState();
  }
}

Widget _buildTextField(TextEditingController controller, String label,
    {TextInputType inputType = TextInputType.text, int maxLines = 1}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 8),
          child: Text(
            "${label}",
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.normal),
            ),
          )),
      Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 8.0),
        child: CustomInputTransparent(
          controller: controller,
          onChanged: (val) {},
          hintText: "Enter ${label.toLowerCase()}",
          onSubmitted: (String) {},
          focusNode: FocusNode(),
          textInputAction: TextInputAction.next,
          isPasswordField: false,
          maxLines: maxLines,
        ),
      ),
    ],
  );
}

class TOCItem {
  int id;
  int index;
  String text;
  int page;
  String type;

  TOCItem({
    required this.id,
    required this.index,
    required this.text,
    required this.page,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'index': index,
      'text': text,
      'page': page,
      'type': type,
    };
  }
}

class AddTOCPage extends StatefulWidget {
  const AddTOCPage({Key? key}) : super(key: key);

  @override
  State<AddTOCPage> createState() => _AddTOCPageState();
}

class _AddTOCPageState extends State<AddTOCPage> {
  List<TOCItem> tocItems = [];

  void _showTOCDialog({required bool isEdit, TOCItem? tocItem}) {
    final _formKey = GlobalKey<FormState>();
    final textController =
        TextEditingController(text: isEdit ? tocItem!.text : '');
    final pageController =
        TextEditingController(text: isEdit ? tocItem!.page.toString() : '');
    final typeController =
        TextEditingController(text: isEdit ? tocItem!.type : '');

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context1, setState1) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              title: Text(isEdit ? 'Edit TOC Item' : 'Add TOC Item'),
              content: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: textController,
                        decoration: InputDecoration(labelText: 'Text'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a text';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: pageController,
                        decoration: InputDecoration(labelText: 'Page'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a page number';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: typeController,
                        decoration: InputDecoration(labelText: 'Type'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a type';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (isEdit) {
                        tocItem!.text = textController.text;
                        tocItem.page = int.parse(pageController.text);
                        tocItem.type = typeController.text;
                      } else {
                        TOCItem newTOCItem = new TOCItem(
                          id: tocItems.length + 1,
                          index: tocItems.length + 1,
                          text: textController.text,
                          page: int.parse(pageController.text),
                          type: typeController.text,
                        );
                        tocItems.add(newTOCItem);
                        print("gfgf0 ${newTopic}");
                        print("gfgf1 ${newTOCItem.toJson()}");
                        newTopic["table_of_contents"].add(newTOCItem.toJson());
                        print("gfgf2 ${newTopic}");
                        valuetainmentValue.value++;

                        setState(() {});
                        setState1;
                      }
                    });

                    Navigator.of(context1).pop();
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteTOCItem(int index) {
    setState(() {
      tocItems.removeAt(index);
      // Update indices after removal
      for (int i = 0; i < tocItems.length; i++) {
        tocItems[i].index = i + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 6,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.grey,
        title: const Text(
          "Table of Contents",
          style: TextStyle(color: Colors.black),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            CupertinoIcons.back,
            color: Colors.black,
            size: 24,
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: tocItems.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final item = tocItems[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(item.index.toString()),
            ),
            title: Text(item.text),
            subtitle: Text('Page: ${item.page}, Type: ${item.type}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(CupertinoIcons.pencil),
                  onPressed: () {
                    _showTOCDialog(isEdit: true, tocItem: item);
                  },
                ),
                IconButton(
                  icon: Icon(CupertinoIcons.delete),
                  onPressed: () {
                    _deleteTOCItem(index);
                  },
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          if (tocItems.isNotEmpty) {
            valuetainmentValue.value++;
          } else {
            MotionToast.error(
              onClose: () {},
              description: Text("Please enter a title"),
            ).show(context);
          }
        },
        child: Container(
          margin:
              const EdgeInsets.only(left: 16.0, right: 16, top: 16, bottom: 12),
          height: 44,
          decoration: BoxDecoration(
              color: Constants.ctaColorLight,
              border: Border.all(color: Colors.grey.withOpacity(0.75)),
              borderRadius: BorderRadius.circular(32)),
          child: Center(
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.ctaColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(360),
        ),
        onPressed: () {
          if (newTopic["title"] == "") {
            MotionToast.error(
              onClose: () {},
              description: Text("Please enter a title first",
                  style: TextStyle(color: Colors.white)),
            ).show(context);
          } else {
            _showTOCDialog(isEdit: false);
          }
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void initState() {
    super.initState();

    // Check if "table_of_contents" exists and is not empty
    if (newTopic["table_of_contents"] != null &&
        newTopic["table_of_contents"].isNotEmpty) {
      for (var m in newTopic["table_of_contents"]) {
        tocItems.add(TOCItem(
          id: m['toc_id'],
          index: m['toc_index'],
          text: m['toc_text'],
          page: m['toc_page'],
          type: m['toc_type'],
        ));
      }
    }
  }
}
