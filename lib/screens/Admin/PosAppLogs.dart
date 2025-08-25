import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mi_insights/services/inactivitylogoutmixin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/Constants.dart';
import '../../customwidgets/CustomCard.dart';
import '../../customwidgets/custom_date_range_picker.dart';
import '../../customwidgets/custom_input.dart';

double _sliderPosition = 0.0;
int _selectedButton = 1;
DateTime? startDate = DateTime.now();
DateTime? endDate = DateTime.now();

class Posapplogs extends StatefulWidget {
  const Posapplogs({super.key});

  @override
  State<Posapplogs> createState() => _PosapplogsState();
}

class _PosapplogsState extends State<Posapplogs> with InactivityLogoutMixin {
  Color _button1Color = Colors.grey.withOpacity(0.0);
  Color _button2Color = Colors.grey.withOpacity(0.0);
  Color _button3Color = Colors.grey.withOpacity(0.0);
  int currentLevel = 0;
  double _sliderPosition = 0.0;

  void _animateButton(int buttonNumber, BuildContext context) {
    restartInactivityTimer();

    setState(() {
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

      _button1Color = buttonNumber == 1
          ? Constants.ctaColorLight
          : Colors.grey.withOpacity(0.0);
      _button2Color = buttonNumber == 2
          ? Constants.ctaColorLight
          : Colors.grey.withOpacity(0.0);
      _button3Color = buttonNumber == 3
          ? Constants.ctaColorLight
          : Colors.grey.withOpacity(0.0);
    });

    if (buttonNumber == 3) {
      showCustomDateRangePicker(
        context,
        dismissible: false,
        minimumDate: DateTime.utc(2023, 06, 01),
        maximumDate: DateTime.now(),
        backgroundColor: Colors.white,
        primaryColor: Constants.ctaColorLight,
        onApplyClick: (start, end) {
          setState(() {
            endDate = end;
            startDate = start;
          });

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

  Future<void> getLogsBySessionId(
      BuildContext context1, String sessionId) async {
    // Show the loading dialog
    late BuildContext bx2;
    late BuildContext bx3;
    showDialog(
      context: context1,
      barrierDismissible: false,
      builder: (BuildContext context2) {
        bx2 = context2;
        return StatefulBuilder(
            builder: (BuildContext context3, StateSetter setState) {
          bx3 = context3;
          return AlertDialog(
            backgroundColor: Colors.transparent,
            title: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
      },
    );

    try {
      print("Starting fetch logs for session ID: $sessionId");
      final url = Uri.parse(
          '${Constants.posAppBaseUrl}/api/app_logs/get_logs_by_session_id/?session_id=$sessionId');
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      Navigator.of(bx2, rootNavigator: false)
          .pop(); // Dismiss the loading dialog

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Logs fetched: $data");

        if (data['success']) {
          if (data['logs'].isEmpty) {
            ScaffoldMessenger.of(bx3).showSnackBar(
              SnackBar(
                  content: Text('No logs found for the provided session ID.')),
            );
          } else {
            Navigator.of(bx3).push(
              MaterialPageRoute(
                builder: (context) => LogsDisplayScreen(logs: data['logs']),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(bx3).showSnackBar(
            SnackBar(content: Text('Error: ${data['ErrorMessage']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context1).showSnackBar(
          SnackBar(content: Text('Server Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print("Error fetching logs by session ID: $e");

      ScaffoldMessenger.of(context1).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  // Function to fetch logs by date range
  Future<void> getLogsByDateRange(
      String clientId, String startDate, String endDate) async {
    final url = Uri.parse(
        '${Constants.posAppBaseUrl}/api/app_logs/get_logs_by_date_range/');
    final response = await http.get(url.replace(queryParameters: {
      'start_date': startDate,
      'end_date': endDate,
    }));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => LogsDisplayScreen(logs: data['logs']),
            ),
          );
        }
      } else {
        if (mounted) {
          print('Error: ${data['ErrorMessage']}');
        }
      }
    } else {
      if (mounted) {
        print('Server Error: ${response.statusCode}');
      }
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
            "POS App Logs",
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
            child: Column(
              children: [
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _animateButton(1, context);
                                  },
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width /
                                            3) -
                                        12,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(360),
                                    ),
                                    height: 35,
                                    child: Center(
                                      child: Text(
                                        '1 Mth View',
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
                                    width: (MediaQuery.of(context).size.width /
                                            3) -
                                        12,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(360),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '12 Mths View',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _animateButton(3, context);
                                  },
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width /
                                            3) -
                                        12,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(360),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Select Dates',
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
                                        '1 Mth View',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : _selectedButton == 2
                                      ? Center(
                                          child: Text(
                                            '12 Mths View',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                            'Select Dates',
                                            style:
                                                TextStyle(color: Colors.white),
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
                        "Generate Logs by date range",
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
                            showPolicyDialog(context);
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
                                "Get logs by Policy",
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
                            getLogsByDateRange(
                              Constants.cec_client_id.toString(),
                              formattedStartDate,
                              formattedEndDate,
                            );
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
                                "Get logs by date range",
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
                            showLogsBySessionIdDialog(context);
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
                                "Get logs by Session Id",
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    endDate = DateTime.now();

    super.initState();
  }

  Future<void> showPolicyDialog(BuildContext context) async {
    final TextEditingController policyController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 16),
              child: Text('Enter Policy Number'),
            ),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomInputTransparent(
                        controller: policyController,
                        hintText: 'Policy Number',
                        onChanged: (val) {},
                        onSubmitted: (val) {},
                        focusNode: FocusNode(),
                        textInputAction: TextInputAction.next,
                        isPasswordField: false,
                      ),
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
                  if (_formKey.currentState!.validate()) {
                    final policyNumber = policyController.text.trim();
                    Navigator.of(context).pop();
                    getLogsByPolicy(context, policyNumber);
                  }
                },
                child: Text('Get Logs'),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> showLogsBySessionIdDialog(BuildContext context) async {
    final TextEditingController policySessionId = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 16),
              child: Text('Enter Session Id'),
            ),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomInputTransparent(
                        controller: policySessionId,
                        hintText: 'Session Id',
                        onChanged: (val) {},
                        onSubmitted: (val) {},
                        focusNode: FocusNode(),
                        textInputAction: TextInputAction.next,
                        isPasswordField: false,
                      ),
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
                  if (_formKey.currentState!.validate()) {
                    final sessionId = policySessionId.text.trim();
                    Navigator.of(context).pop();
                    getLogsBySessionId(context, sessionId);
                  }
                },
                child: Text('View Logs'),
              ),
            ],
          );
        });
      },
    );
  }
}

class LogsDisplayScreen extends StatelessWidget {
  final List<dynamic> logs;

  LogsDisplayScreen({required this.logs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Logs', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        shadowColor: Colors.grey,
        elevation: 6,
      ),
      body: logs.isEmpty
          ? Center(child: Text('No logs found'))
          : ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CustomCard(
                    elevation: 6,
                    surfaceTintColor: Colors.white,
                    color: Colors.white,
                    child: ListTile(
                      title: Text('Action: ${log['action']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Timestamp: ${log['timestamp']}'),
                          Text('Employee: ${log['employee_name']}'),
                          Text('Device: ${log['device_id']}'),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, bottom: 16, top: 16),
              child: InkWell(
                onTap: () {
                  _downloadLogsToExcel(context, logs);
                },
                child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    color: Constants.ctaColorLight,
                    borderRadius: BorderRadius.circular(360),
                  ),
                  child: Center(
                      child: Text(
                    "Download",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _downloadLogsToExcel(
      BuildContext context, List<dynamic> logs) async {
    // Create a new Excel file
    var excel = Excel.createExcel();

    // Select the default sheet
    Sheet sheetObject = excel['Logs'];

    // Add the headers
    sheetObject.appendRow([
      TextCellValue('Action'),
      TextCellValue('Timestamp'),
      TextCellValue('Employee Name'),
      TextCellValue('Device ID'),
    ]);

    // Add data rows
    for (var log in logs) {
      sheetObject.appendRow([
        TextCellValue(log['action']),
        TextCellValue(log['timestamp']),
        TextCellValue(log['employee_name']),
        TextCellValue(log['device_id']),
      ]);
    }

    // Determine the directory based on the platform
    Directory? directory;

    if (Platform.isAndroid) {
      // Request storage permission for Android
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Storage permission is required to save logs.')),
        );
        return;
      }

      directory = await getExternalStorageDirectory();
      // You can customize the path if needed
      String newPath = "";
      List<String> paths = directory!.path.split("/");
      for (int x = 1; x < paths.length; x++) {
        String folder = paths[x];
        if (folder != "Android") {
          newPath += "/" + folder;
        } else {
          break;
        }
      }
      newPath = newPath + "/Logs";
      directory = Directory(newPath);
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      throw UnsupportedError("Unsupported platform");
    }

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final path = '${directory.path}/logs.xlsx';
    print(path);
    final file = File(path);

    await file.writeAsBytes(excel.encode()!, flush: true);

    // Notify the user that the download is complete
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logs downloaded to $path')),
    );
  }
}

Future<void> getLogsByPolicy(
    BuildContext context1, String policyOrReference) async {
  // Show the loading dialog
  late BuildContext bx2;
  late BuildContext bx3;
  showDialog(
    context: context1,
    barrierDismissible: false,
    builder: (BuildContext context2) {
      bx2 = context2;
      return StatefulBuilder(
          builder: (BuildContext context3, StateSetter setState) {
        bx3 = context3;
        return AlertDialog(
          backgroundColor: Colors.transparent,
          title: Center(
            child: CircularProgressIndicator(),
          ),
        );
      });
    },
  );

  try {
    print("Starting fetch logs for policy: $policyOrReference");
    final url = Uri.parse(
        '${Constants.posAppBaseUrl}/api/app_logs/get_logs_by_policy/?policy_or_reference=$policyOrReference');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    Navigator.of(bx2, rootNavigator: false).pop(); // Dismiss the loading dialog

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Logs fetched: $data");

      if (data['success']) {
        if (data['logs'].isEmpty) {
          ScaffoldMessenger.of(bx3).showSnackBar(
            SnackBar(content: Text('No logs found for the provided policy.')),
          );
        } else {
          Navigator.of(bx3).push(
            MaterialPageRoute(
              builder: (context) => LogsDisplayScreen(logs: data['logs']),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(bx3).showSnackBar(
          SnackBar(content: Text('Error: ${data['ErrorMessage']}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context1).showSnackBar(
        SnackBar(content: Text('Server Error: ${response.statusCode}')),
      );
    }
  } catch (e) {
    print("gffgh");
    print(e);

    ScaffoldMessenger.of(context1).showSnackBar(
      SnackBar(content: Text('An error occurred: $e')),
    );
  }
}
