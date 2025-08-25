import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../constants/Constants.dart';
import '../../customwidgets/custom_date_range_picker.dart';
import '../../services/inactivitylogoutmixin.dart';

double _sliderPosition = 0.0;
int _selectedButton = 1;
DateTime? startDate = DateTime.now();
DateTime? endDate = DateTime.now();

class ReportGenerators extends StatefulWidget {
  const ReportGenerators({super.key});

  @override
  State<ReportGenerators> createState() => _ReportGeneratorsState();
}

class _ReportGeneratorsState extends State<ReportGenerators>
    with InactivityLogoutMixin {
  Color _button1Color = Colors.grey.withOpacity(0.0);
  Color _button2Color = Colors.grey.withOpacity(0.0);
  Color _button3Color = Colors.grey.withOpacity(0.0);
  int currentLevel = 0;
  void _animateButton(int buttonNumber, BuildContext context) {
    restartInactivityTimer();

    setState(() {});

    _selectedButton = buttonNumber;
    if (buttonNumber == 1) {
      startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
      endDate = DateTime.now();
      _sliderPosition = 0.0;
    } else if (buttonNumber == 2) {
      _sliderPosition = (MediaQuery.of(context).size.width / 3) - 18;
      startDate = DateTime.now().subtract(Duration(days: 365));
      endDate = DateTime.now();
    } else if (buttonNumber == 3) {
      _sliderPosition = 2 * (MediaQuery.of(context).size.width / 3) - 32;
    }
    setState(() {});
    if (buttonNumber != 3) {
      setState(() {
        // Update colors
        _button1Color = buttonNumber == 1
            ? Constants.ctaColorLight
            : Colors.grey.withOpacity(0.0);
        _button2Color = buttonNumber == 2
            ? Constants.ctaColorLight
            : Colors.grey.withOpacity(0.0);
        _button3Color = buttonNumber == 3
            ? Constants.ctaColorLight
            : Colors.grey.withOpacity(0.0);

        // Update slider position based on the button tapped
      });
      DateTime now = DateTime.now();

      setState(() {});
    } else {
      showCustomDateRangePicker(
        context,
        dismissible: false,
        minimumDate: DateTime.utc(2023, 06, 01),
        maximumDate: DateTime.now(),
        /*    endDate: endDate,
        startDate: startDate,*/
        backgroundColor: Colors.white,
        primaryColor: Constants.ctaColorLight,
        onApplyClick: (start, end) {
          setState(() {
            endDate = end;
            startDate = start;
          });

          setState(() {});

          restartInactivityTimer();
        },
        onCancelClick: () {
          restartInactivityTimer();
          if (kDebugMode) {
            print("user cancelled.");
          }
          setState(() {
            _animateButton(1, context);
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            surfaceTintColor: Colors.white,
            shadowColor: Colors.grey.withOpacity(0.45),
            elevation: 6,
            backgroundColor: Colors.white,
            title: const Text(
              "Custom Report Generators",
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
          body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollStartNotification ||
                        scrollNotification is ScrollUpdateNotification) {
                      restartInactivityTimer();
                    }
                    return true;
                  },
                  child: Column(children: [
                    SizedBox(
                      height: 12,
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
                                            '1 Mth View',
                                            style:
                                                TextStyle(color: Colors.black),
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
                                            '12 Mths View',
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
                                            'Select Dates',
                                            style:
                                                TextStyle(color: Colors.black),
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
                                            '1 Mth View',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      : _selectedButton == 2
                                          ? Center(
                                              child: Text(
                                                '12 Mths View',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          : Center(
                                              child: Text(
                                                'Select Dates',
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
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20, top: 12),
                      child: Container(
                        height: 1,
                        color: Colors.grey.withOpacity(0.35),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16, top: 16, bottom: 4),
                      child: Row(
                        children: [
                          Text(
                            "Manco reports",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, top: 0, bottom: 4),
                      child: Container(
                        height: 1,
                        color: Colors.grey.withOpacity(0.35),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                String formattedStartDate =
                                    DateFormat('yyyy-MM-dd').format(startDate!);
                                String formattedEndDate =
                                    DateFormat('yyyy-MM-dd').format(endDate!);

                                downloadMancoPart1ExcelFile(
                                    Constants.cec_client_id,
                                    formattedStartDate,
                                    formattedEndDate,
                                    context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(36),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 8, bottom: 8, right: 8),
                                  child: Text(
                                    "Premium Collection",
                                    style: TextStyle(fontSize: 14.0),
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                String formattedStartDate =
                                    DateFormat('yyyy-MM-dd').format(startDate!);
                                String formattedEndDate =
                                    DateFormat('yyyy-MM-dd').format(endDate!);
                                downloadMancoPart2ExcelFile(
                                    Constants.cec_client_id,
                                    formattedStartDate,
                                    formattedEndDate,
                                    context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(36),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 8, bottom: 8, right: 8),
                                  child: Text(
                                    "Monthly Inforce Data",
                                    style: TextStyle(fontSize: 14.0),
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                String formattedStartDate =
                                    DateFormat('yyyy-MM-dd').format(startDate!);
                                String formattedEndDate =
                                    DateFormat('yyyy-MM-dd').format(endDate!);
                                downloadMancoPart3ExcelFile(
                                    Constants.cec_client_id,
                                    formattedStartDate,
                                    formattedEndDate,
                                    context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(36),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 8, bottom: 8, right: 8),
                                  child: Text(
                                    "Monthly Lapse NTU Cancellation_Data",
                                    style: TextStyle(fontSize: 14.0),
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                String formattedStartDate =
                                    DateFormat('yyyy-MM-dd').format(startDate!);
                                String formattedEndDate =
                                    DateFormat('yyyy-MM-dd').format(endDate!);
                                downloadMancoPart4ExcelFile(
                                    Constants.cec_client_id,
                                    formattedStartDate,
                                    formattedEndDate,
                                    context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(36),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 8, bottom: 8, right: 8),
                                  child: Text(
                                    "Premium Collection Date Data",
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16, top: 16, bottom: 12),
                      child: Row(
                        children: [
                          Text(
                            "Payover reports",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20, top: 12),
                      child: Container(
                        height: 1,
                        color: Colors.grey.withOpacity(0.35),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                String formattedStartDate =
                                    DateFormat('yyyy-MM-dd').format(startDate!);
                                String formattedEndDate =
                                    DateFormat('yyyy-MM-dd').format(endDate!);
                                downloadPayoverExcelFile(
                                    Constants.cec_client_id,
                                    formattedStartDate,
                                    formattedEndDate,
                                    context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(36),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 8, bottom: 8, right: 8),
                                  child: Text(
                                    "Payover Report Data",
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ])))),
    );
  }

  @override
  void initState() {
    startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    endDate = DateTime.now();

    super.initState();
  }
}

Future<void> downloadMancoPart1ExcelFile(int clientId, String startDate,
    String endDate, BuildContext context1) async {
  final url =
      '${Constants.InsightsReportsbaseUrl}/api/customs_reports/manco_part1/';

/*  showDialog(
    context: context,
    barrierDismissible:
    true, // Prevent dismissing by tapping outside
    builder: (BuildContext context) {
      return _loadingDialog(context);
    },
  );*/
  Fluttertoast.showToast(
    msg: "Starting download!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );

  try {
    // Create the request body
    final requestBody = {
      'client_id': clientId.toString(),
      'start_date': startDate,
      'end_date': endDate,
      'cec_employee_id': Constants.cec_employeeid.toString(),
    };

    // Send the POST request
    final response = await http.post(
      Uri.parse(url),
      body: requestBody,
    );

    if (response.statusCode == 200) {
      Directory? directory;
      String filePath;

      if (Platform.isAndroid) {
        // On Android, use external storage directory
        directory = await getExternalStorageDirectory();
      } else if (Platform.isIOS) {
        // On iOS, use the Documents directory
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory != null) {
        // Use the directory path
        String selectedDirectory = directory.path;

        // Combine the directory path with the file name
        filePath = path.join(selectedDirectory,
            'Premium Collection Data $startDate to $endDate.xlsx');

        // Save the file
        final file = File(filePath);
        if (file.existsSync()) {
          file.deleteSync();
        }
        await file.writeAsBytes(response.bodyBytes);

        // Dismiss the dialog
        //Navigator.of(context1).pop();
        MotionToast.success(
          onClose: () {},
          description: Text("File saved! Please check your files"),
        ).show(context1);

        print('File saved to $filePath');
      } else {
        // Dismiss the dialog
        // Navigator.of(context1).pop();
        print('Could not get directory to save the file.');
        MotionToast.error(
          onClose: () {},
          description: Text("Could not get directory to save the file."),
        ).show(context1);
      }
    } else {
      // Dismiss the dialog
      //Navigator.of(context1).pop();
      MotionToast.error(
        onClose: () {},
        description: Text("Failed to download file. Try again later."),
      ).show(context1);
      print('Failed to download file. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // Dismiss the dialog
    // Navigator.of(context1).pop();
    print('Error: $e');
    MotionToast.error(
      onClose: () {},
      description: Text("An error occurred. Please try again."),
    ).show(context1);
  }
}

Future<void> downloadMancoPart2ExcelFile(int clientId, String startDate,
    String endDate, BuildContext context1) async {
  final url =
      '${Constants.InsightsReportsbaseUrl}/api/customs_reports/manco_part2/';

  Fluttertoast.showToast(
    msg: "Processing request!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );

  try {
    final requestBody = {
      'client_id': clientId.toString(),
      'start_date': startDate,
      'end_date': endDate,
      'cec_employee_id': Constants.cec_employeeid.toString(),
    };

    final response = await http.post(
      Uri.parse(url),
      body: requestBody,
    );

    if (response.statusCode == 200) {
      MotionToast.success(
        onClose: () {},
        description: Text("Report generated and emailed successfully!"),
      ).show(context1);
    } else {
      MotionToast.error(
        onClose: () {},
        description: Text("Failed to generate report. Please try again later."),
      ).show(context1);
    }
  } catch (e) {
    MotionToast.error(
      onClose: () {},
      description: Text("An error occurred. Please try again."),
    ).show(context1);
  }
}

Future<void> downloadMancoPart3ExcelFile(int clientId, String startDate,
    String endDate, BuildContext context1) async {
  final url =
      '${Constants.InsightsReportsbaseUrl}/api/customs_reports/manco_part3/';

  Fluttertoast.showToast(
    msg: "Processing request!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );

  try {
    final requestBody = {
      'client_id': clientId.toString(),
      'start_date': startDate,
      'end_date': endDate,
      'cec_employee_id': Constants.cec_employeeid.toString(),
    };

    final response = await http.post(
      Uri.parse(url),
      body: requestBody,
    );

    if (response.statusCode == 200) {
      MotionToast.success(
        onClose: () {},
        description: Text("Report generated and emailed successfully!"),
      ).show(context1);
    } else {
      MotionToast.error(
        onClose: () {},
        description: Text("Failed to generate report. Please try again later."),
      ).show(context1);
      print('Failed to generate report. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    MotionToast.error(
      onClose: () {},
      description: Text("An error occurred. Please try again."),
    ).show(context1);
  }
}

Future<void> downloadMancoPart4ExcelFile(int clientId, String startDate,
    String endDate, BuildContext context1) async {
  final url =
      '${Constants.InsightsReportsbaseUrl}/api/customs_reports/manco_part4/';

  Fluttertoast.showToast(
    msg: "Processing request!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );

  try {
    final requestBody = {
      'client_id': clientId.toString(),
      'start_date': startDate,
      'end_date': endDate,
      'cec_employee_id': Constants.cec_employeeid.toString(),
    };

    final response = await http.post(
      Uri.parse(url),
      body: requestBody,
    );

    if (response.statusCode == 200) {
      MotionToast.success(
        onClose: () {},
        description: Text("Report generated and emailed successfully!"),
      ).show(context1);
    } else {
      MotionToast.error(
        onClose: () {},
        description: Text("Failed to generate report. Please try again later."),
      ).show(context1);
      print('Failed to generate report. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    MotionToast.error(
      onClose: () {},
      description: Text("An error occurred. Please try again."),
    ).show(context1);
  }
}

Future<void> downloadPayoverExcelFile(int clientId, String startDate,
    String endDate, BuildContext context1) async {
  final url =
      '${Constants.InsightsReportsbaseUrl}/api/customs_reports/generate_payover_data/';
  MotionToast.success(
    onClose: () {},
    description: Text("Sending Report to Email!"),
  ).show(context1);

  try {
    // Create the request body
    final requestBody = {
      'client_id': clientId.toString(),
      'start_date': startDate,
      'end_date': endDate,
      'cec_employee_id': Constants.cec_employeeid.toString(),
    };

    // Send the POST request
    final response = await http.post(
      Uri.parse(url),
      body: requestBody,
    );

    if (response.statusCode == 200) {
      MotionToast.success(
        onClose: () {},
        description: Text("Email Sent! Please check your files"),
      ).show(context1);
    } else {
      // Dismiss the dialog
      //Navigator.of(context1).pop();
      MotionToast.error(
        onClose: () {},
        description: Text("Failed to download file. Try again later."),
      ).show(context1);
      print('Failed to download file. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // Dismiss the dialog
    // Navigator.of(context1).pop();
    print('Error: $e');
    MotionToast.error(
      onClose: () {},
      description: Text("An error occurred. Please try again."),
    ).show(context1);
  }
}

Widget _loadingDialog(BuildContext context) {
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      title: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Downloading, please wait..."),
          ],
        ),
      ),
    );
  });
}
