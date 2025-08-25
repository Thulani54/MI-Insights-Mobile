import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mi_insights/constants/Constants.dart';
import 'package:mi_insights/customwidgets/CustomCard.dart';
import 'package:mi_insights/customwidgets/custom_input.dart';

import '../../models/notification.dart';
import '../Sales Agent/SalesAgentNewSale.dart';

class NotificationManagement extends StatefulWidget {
  @override
  _NotificationManagementState createState() => _NotificationManagementState();
}

class _NotificationManagementState extends State<NotificationManagement> {
  List<Notification2> notifications = [];
  bool isLoading = true;
  String? errorMessage;

  final NotificationApiService apiService = NotificationApiService();

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedNotifications = await apiService.fetchNotifications();
      setState(() {
        notifications = fetchedNotifications;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        shadowColor: Colors.grey.withOpacity(0.45),
        elevation: 6,
        backgroundColor: Colors.white,
        title: const Text(
          "Notifications",
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Failed to load notifications',
                          style: TextStyle(color: Colors.red)),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: fetchNotifications,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 8.0, left: 12, right: 12),
                      child: CustomCard(
                        elevation: 6,
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            notification.title,
                            style: TextStyle(fontSize: 14),
                          ),
                          subtitle: Text(
                            notification.content,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _showEditNotificationDialog(notification);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _deleteNotification(notification.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateNotificationDialog,
        backgroundColor: Constants.ctaColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(360),
        ),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showCreateNotificationDialog() {
    _showNotificationDialog(isEdit: false);
  }

  void _showEditNotificationDialog(Notification2 notification) {
    _showNotificationDialog(isEdit: true, notification: notification);
  }

  void _showNotificationDialog(
      {required bool isEdit, Notification2? notification}) {
    final _formKey = GlobalKey<FormState>();
    final titleController =
        TextEditingController(text: isEdit ? notification!.title : '');
    final messageController =
        TextEditingController(text: isEdit ? notification!.content : '');
    var notificationType =
        isEdit ? notification!.notificationType : 'Announcement';
    TextEditingController displayfromController =
        TextEditingController(text: isEdit ? notification!.displayFrom : '');
    TextEditingController displayUntilController =
        TextEditingController(text: isEdit ? notification!.displayUntil : '');
    TextEditingController eventDateController =
        TextEditingController(text: isEdit ? notification!.eventDate : '');
    final uploadedByController = TextEditingController(
        text: isEdit ? notification!.uploadedBy.toString() : '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            buttonPadding: EdgeInsets.only(top: 0.0, left: 0, right: 0),
            insetPadding: EdgeInsets.only(left: 16.0, right: 16),
            titlePadding: EdgeInsets.only(right: 0),
            surfaceTintColor: Colors.white,
            contentPadding:
                const EdgeInsets.only(left: 8.0, top: 16, right: 12),
            title: Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 16),
              child: Text(isEdit ? 'Edit Notification' : 'Create Notification'),
            ),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 4),
                        child: Text(
                          "Notification Title:",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomInputTransparent(
                        controller: titleController,
                        hintText: 'Title',
                        onChanged: (val) {},
                        onSubmitted: (val) {},
                        focusNode: FocusNode(),
                        textInputAction: TextInputAction.next,
                        isPasswordField: false,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, top: 8, bottom: 8),
                        child: Text(
                          "Notification Body:",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.75)),
                            borderRadius: BorderRadius.circular(8)),
                        child: MultiLineTextField(
                          maxLines: 5,
                          label: 'Notification body',
                          //   focusNode: _descriptionFocusNode,
                          controller: messageController,
                          bordercolor: Colors.transparent,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16, top: 12, bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            "Notification Type:",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 12.0,
                        left: 12,
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
                                value:
                                    notificationType, //Paragraph, heading, image, video
                                onChanged: (String? newValue) {
                                  setState(() {
                                    notificationType = newValue!;
                                    print(notificationType);
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
                                    "Event",
                                    "Announcement",
                                    "Reminder",
                                    "Alert"
                                  ].map<Widget>((item) {
                                    return DropdownMenuItem(
                                        child: Text("${item}",
                                            style:
                                                TextStyle(color: Colors.black)),
                                        value: item);
                                  }).toList();
                                },
                                items: [
                                  "Event",
                                  "Announcement",
                                  "Reminder",
                                  "Alert"
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
                    if (notificationType == "Event")
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 16, bottom: 8),
                        child: Row(
                          children: [
                            Text(
                              "Event Date:",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    if (notificationType == "Event")
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(32)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: TextFormField(
                                    controller: eventDateController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black54),
                                      hintText: "Event Date",
                                      suffixIcon: Icon(CupertinoIcons.calendar),
                                    ),
                                    readOnly: true,
                                    onTap: () {
                                      _selectDate(context, eventDateController)
                                          .then((val) {
                                        if (val != "") {
                                          //displayfromController.text= val;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16, top: 16, bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            "Display From:",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(32)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: TextFormField(
                                  controller: displayfromController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black54),
                                    hintText: "Display From",
                                    suffixIcon: Icon(CupertinoIcons.calendar),
                                  ),
                                  readOnly: true,
                                  onTap: () {
                                    _selectDate(context, displayfromController)
                                        .then((val) {
                                      if (val != "") {
                                        //displayfromController.text= val;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16, top: 16, bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            "Display Until:",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(32)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: TextFormField(
                                  controller: displayUntilController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black54),
                                    hintText: "Display Until",
                                    suffixIcon: Icon(CupertinoIcons.calendar),
                                  ),
                                  readOnly: true,
                                  onTap: () {
                                    _selectDate(context, displayUntilController)
                                        .then((val) {
                                      if (val != "") {
                                        //displayfromController.text= val;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
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
                    if (isEdit) {
                      final updatedNotification = Notification2(
                        id: notification!.id,
                        title: titleController.text,
                        content: messageController.text,
                        notificationType: notificationType.toLowerCase(),
                        cecClientId: Constants.cec_client_id,
                        uploadedBy: Constants.cec_employeeid,
                        displayFrom: displayfromController.text,
                        displayUntil: displayUntilController.text,
                        isActive: true,
                        eventDate: eventDateController.text,
                      );
                      _updateNotification(updatedNotification);
                    } else {
                      final newNotification = Notification2(
                        id: 0,
                        title: titleController.text,
                        content: messageController.text,
                        notificationType: notificationType,
                        cecClientId: Constants.cec_client_id,
                        uploadedBy: Constants.cec_employeeid,
                        displayFrom: displayfromController.text,
                        displayUntil: displayUntilController.text,
                        isActive: true,
                        eventDate: eventDateController.text,
                      );
                      _createNotification(newNotification);
                    }
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Save'),
              ),
            ],
          );
        });
      },
    );
  }

  Future<String> _selectDate(
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
      return DateFormat('yyyy-MM-dd').format(picked);
    }
    return "";
  }

  void _createNotification(Notification2 notification) async {
    try {
      final newNotification = await apiService.createNotification(notification);
      setState(() {
        fetchNotifications();
        //  notifications.add(newNotification);
      });
    } catch (error) {
      _showError(error.toString());
    }
  }

  void _updateNotification(Notification2 notification) async {
    try {
      final updatedNotification =
          await apiService.updateNotification(notification);
      setState(() {
        final index = notifications.indexWhere((n) => n.id == notification.id);
        if (index != -1) {
          notifications[index] = updatedNotification;
        }
      });
    } catch (error) {
      _showError(error.toString());
    }
  }

  void _deleteNotification(int id) async {
    try {
      await apiService.deleteNotification(id);
      setState(() {
        notifications.removeWhere((n) => n.id == id);
      });
    } catch (error) {
      _showError(error.toString());
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class NotificationApiService {
  static String baseUrl =
      '${Constants.InsightsReportsbaseUrl}/api/business_notifications/';

  Future<List<Notification2>> fetchNotifications() async {
    final response = await http.get(
        Uri.parse(baseUrl + "get/?cec_client_id=${Constants.cec_client_id}"));
    if (kDebugMode) {
      print("responsefggf ${response.body}");
    }
    if (response.statusCode == 200) {
      Map m1 = json.decode(response.body);
      final List<dynamic> data = m1["notifications"] ?? [];
      //print(data);
      return data.map((json) => Notification2.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  Future<Notification2> createNotification(Notification2 notification) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'create/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(notification.toJson()),
    );
    if (response.statusCode == 201) {
      return Notification2.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create notification');
    }
  }

  Future<void> getLatestNotification(int cec_client_id) async {
    String actual_url = baseUrl + 'get_latest_notification/';
    print("actual_url $actual_url");

    final response = await http.post(
      Uri.parse(actual_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "cec_client_id": (cec_client_id).toString(),
      }),
    );
    if (kDebugMode) {
      //print("fgfgffgf ${response.body}");
    }
    if (response.statusCode == 200) {
      Constants.latestNotification =
          Notification2.fromJson(json.decode(response.body)["notification"]);
      if (kDebugMode) {
        //  print("dfgfgf ${Constants.latestNotification.title}");
      }
    } else {
      if (kDebugMode) {
        //  print('Failed to get latest notification');
      }
    }
  }

  Future<Notification2> updateNotification(Notification2 notification) async {
    final response = await http.put(
      Uri.parse(baseUrl + '${notification.id}/update/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(notification.toJson()),
    );
    if (response.statusCode == 200) {
      return Notification2.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update notification');
    }
  }

  Future<void> deleteNotification(int id) async {
    final response = await http.delete(Uri.parse(baseUrl + '$id/delete/'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete notification');
    }
  }
}
