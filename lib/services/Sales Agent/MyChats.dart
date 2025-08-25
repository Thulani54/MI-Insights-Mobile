import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../constants/Constants.dart';
import '../../models/NotificationModel.dart';
import '../../screens/Sales Agent/SalesAgentChatScreen.dart';
import '../inactivitylogoutmixin.dart';

class myChats extends StatefulWidget {
  const myChats({super.key});

  @override
  State<myChats> createState() => _myChatsState();
}

TextEditingController _searchContoller = TextEditingController();
TextEditingController _searchContoller_n = TextEditingController();

class _myChatsState extends State<myChats> with InactivityLogoutMixin {
  int _selectedIndex = 0;
  bool isLoadingChatData = false;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  bool _isLoading = false;
  List<chatUser> allusers = [];
  List<chatUser> filtered_users = [];
  List<NotificationModel> all_notifications = [];
  List<NotificationModel> filtered_notifications = [];
  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Container(
        color: Color(0xff2c3e50),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollStartNotification ||
                  scrollNotification is ScrollUpdateNotification) {
                restartInactivityTimer();
              }
              return true; // Return true to indicate the notification is handled
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 0.0, right: 16, bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 8, right: 8, top: 0, bottom: 4),
                            child: Container(
                              height: 45,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(360),
                                child: Material(
                                  elevation: 10,
                                  child: TextFormField(
                                    autofocus: false,
                                    decoration: InputDecoration(
                                      suffixIcon: InkWell(
                                        onTap: () {
                                          _isLoading = true;

                                          setState(() {});
                                          print("ghghghhjgjh");
                                          getUsers(
                                            _searchContoller.text,
                                          );
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 30,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0.0,
                                                bottom: 0.0,
                                                right: 0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      Constants.ctaColorLight,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          360)),
                                              child: Center(
                                                child: Icon(
                                                  Icons.search,
                                                  color: Colors.white,
                                                  size: 24,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      hintText: 'Search a user',
                                      hintStyle: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.withOpacity(0.09),
                                      contentPadding: EdgeInsets.only(left: 24),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.grey.withOpacity(0.0)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.grey.withOpacity(0.0)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    controller: _searchContoller,
                                    onChanged: (val) {
                                      getUsers(
                                        val,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: ListView.builder(
                      itemCount: filtered_users.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            print(
                                "dfghfg ${Constants.cec_employeeid.toString()} ${filtered_users[index].employeeId}");

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SalesAgentChatScreen(
                                          username: filtered_users[index]
                                              .username
                                              .toString(),
                                          useremail: '',
                                          cec_employee_id: int.parse(
                                              filtered_users[index].employeeId),
                                        ))).then((_) {
                              Constants.pageLevel = 3;
                            });
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  SizedBox(width: 16),
                                  Container(
                                      height: 60,
                                      width: 60,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(360),
                                        child: Image.asset(
                                            "assets/default-user.png"),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(360),
                                      )),
                                  SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${filtered_users[index].username}", // Use filtered_users here
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "${filtered_users[index].useremail}", // Use filtered_users here
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )),
      ),
      Container(
          color: Color(0xff2c3e50),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollStartNotification ||
                  scrollNotification is ScrollUpdateNotification) {
                restartInactivityTimer();
              }
              return true; // Return true to indicate the notification is handled
            },
            child: Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 0.0, right: 16, bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 8, right: 8, top: 0, bottom: 4),
                                child: Container(
                                  height: 45,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(360),
                                    child: Material(
                                      elevation: 10,
                                      child: TextFormField(
                                        autofocus: false,
                                        decoration: InputDecoration(
                                          suffixIcon: InkWell(
                                            onTap: () {
                                              _isLoading = true;

                                              setState(() {});
                                              print("ghghghhjgjh1");
                                              getUsersn(
                                                _searchContoller_n.text,
                                              );
                                            },
                                            child: Container(
                                              height: 35,
                                              width: 30,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0.0,
                                                    bottom: 0.0,
                                                    right: 0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Constants
                                                          .ctaColorLight,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              360)),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.search,
                                                      color: Colors.white,
                                                      size: 24,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          hintText: 'Search a user',
                                          hintStyle: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          filled: true,
                                          fillColor:
                                              Colors.grey.withOpacity(0.09),
                                          contentPadding:
                                              EdgeInsets.only(left: 24),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.0)),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.0)),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        controller: _searchContoller_n,
                                        onChanged: (val) {
                                          getUsersn(
                                            val,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: filtered_notifications
                              .length, // Use filtered_users here
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (getEmployeeById(
                                    filtered_notifications[index].senderId,
                                    filtered_notifications[index].receiverId) ==
                                "") {
                              return Container();
                            }
                            return InkWell(
                              onTap: () {
                                if (kDebugMode) {
                                  print(
                                      "fhghghfhh ${filtered_notifications[index].senderId}");
                                }
                                if (kDebugMode) {
                                  print(
                                      "fhghghfhh ${filtered_notifications[index].receiverId}");
                                }
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SalesAgentChatScreen(
                                              username: getEmployeeById(
                                                  filtered_notifications[index]
                                                      .senderId,
                                                  filtered_notifications[index]
                                                      .receiverId),
                                              useremail: '',
                                              cec_employee_id:
                                                  filtered_notifications[index]
                                                              .receiverId ==
                                                          Constants
                                                              .cec_employeeid
                                                      ? filtered_notifications[
                                                              index]
                                                          .senderId
                                                      : filtered_notifications[
                                                              index]
                                                          .receiverId,
                                            ))).then((_) {
                                  Constants.pageLevel = 3;
                                });
                              },
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 16),
                                      Container(
                                          height: 60,
                                          width: 60,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(360),
                                            child: Image.asset(
                                                "assets/default-user.png"),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(360),
                                          )),
                                      SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${getEmployeeById(filtered_notifications[index].senderId, filtered_notifications[index].receiverId)}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            "${filtered_notifications[index].notificationBody}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )),
              ],
            ),
          )),
    ];
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text("My Chats"),
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
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person_3_fill),
                label: 'All Contacts',
                backgroundColor: Colors.red,
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.chat_bubble_2_fill),
                label: 'Chats',
                backgroundColor: Colors.green,
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            backgroundColor: Color(0xff32465a),
            onTap: _onItemTapped,
          ),
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 1) {
        getUserChats();
      }
      ;
    });
    restartInactivityTimer();
  }

  @override
  void initState() {
    restartInactivityTimer();
    Constants.cec_employees.forEach((element) {
      Map m = element as Map;
      print("fgfhgf " + element.toString());
      if ((m["cec_employeeid"]).toString() !=
          Constants.cec_employeeid.toString())
        allusers.add(chatUser("${m["employee_name"]} ${m["employee_surname"]} ",
            m["employee_email"], m["cec_employeeid"]));
    });
    filtered_users = allusers;

    setState(() {});
    super.initState();
    getUserChats();
  }

  getUserChats() async {
    String baseUrl =
        "https://miinsightsapps.net/admin/getMyNotificationsReload?cec_employeid=${Constants.cec_employeeid}";
    int days_difference = 0;
    DateTime now = DateTime.now();
    try {
      //print(payload);
      isLoadingChatData = true;

      await http.post(
          Uri.parse(
            baseUrl,
          ),
          headers: {
            "Cookie":
                "userid=expiry=2021-04-25&client_modules=1001#1002#1003#1004#1005#1006#1007#1008#1009#1010#1011#1012#1013#1014#1015#1017#1018#1020#1021#1022#1024#1025#1026#1027#1028#1029#1030#1031#1032#1033#1034#1035&clientid=&empid=3&empfirstname=Mncedisi&emplastname=Khumalo&email=mncedisi@athandwe.co.za&username=mncedisi@athandwe.co.za&dob=8/28/1985 12:00:00 AM&fullname=Mncedisi Khumalo&userRole=5&userImage=mncedisi@athandwe.co.za.jpg&employedAt=branch&role=leader&branchid=6&branchname=Boulders&jobtitle=Administrative Assistant&dialing_strategy=Campaign Manager&clientname=Test 1 Funeral Parlour&foldername=maafrica&client_abbr=AS&pbx_account=pbx1051ef0a&soft_phone_ip=&agent_type=branch&mip_username=mnces@mip.co.za&agent_email=Mr Mncedisi Khumalo&ViciDial_phone_login=&ViciDial_phone_password=&ViciDial_agent_user=99&ViciDial_agent_password=&device_id=dC7JwXFwwdI:APA91bF0gTbuXlfT6wIcGMLY57Xo7VxUMrMH-MuFYL5PnjUVI0G5X1d3d90FNRb8-XmcjI40L1XqDH-KAc1KWnPpxNg8Z8SK4Ty0xonbz4L3sbKz3Rlr4hyBqePWx9ZfEp53vWwkZ3tx&servername=http://localhost:55661"
          }).then((value) {
        http.Response response = value;
        if (kDebugMode) {
          //print("hgtyrfggff $baseUrl");
          //print("payload_chat ${response.statusCode} ${response.body}");
        }
        if (response.statusCode != 200) {
        } else {
          List<dynamic> all_notifications = jsonDecode(response.body);
          print("Total notifications: ${all_notifications.length}");

          List<NotificationModel> notifications = [];

          // Populate the notifications list from JSON
          for (var element in all_notifications) {
            NotificationModel notification =
                NotificationModel.fromJson(element);
            notifications.add(notification); // Add to a separate list
          }

          // Sort notifications by timestamp in descending order
          notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));

          // Use a map to filter out and keep only the latest notification per conversation
          // Assuming each senderId and receiverId pair represents a unique conversation
          Map<String, NotificationModel> latestNotificationPerConversation = {};

          for (var notification in notifications) {
            String conversationKey =
                "${notification.senderId}_${notification.receiverId}";
            // If this conversation hasn't been added yet or the existing one is older, add/replace it
            if (!latestNotificationPerConversation
                    .containsKey(conversationKey) ||
                latestNotificationPerConversation[conversationKey]!
                    .timestamp
                    .isBefore(notification.timestamp)) {
              latestNotificationPerConversation[conversationKey] = notification;
            }
          }

          setState(() {
            // Update your state with the filtered list of notifications
            this.all_notifications =
                latestNotificationPerConversation.values.toList();

            // Assuming filtered_notifications is what you want to use for displaying
            filtered_notifications =
                latestNotificationPerConversation.values.toList();
          });
        }
      });
    } on Exception catch (_, exception) {
      //Exception exc = exception as Exception;
      // print(exception);
    }
  }

  void getUsersn(String query) {
    if (query.isEmpty) {
      filtered_notifications = List.from(all_notifications);
    } else {
      filtered_notifications = all_notifications.where((user) {
        return user.notificationTitle
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            user.notificationBody.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    setState(() {});
  }

  void getUsers(String query) {
    if (query.isEmpty) {
      filtered_users = List.from(allusers);
    } else {
      filtered_users = allusers.where((user) {
        return user.username.toLowerCase().contains(query.toLowerCase()) ||
            user.useremail.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    // Since we're changing the state of the list, we need to call setState to update the UI
    setState(() {});
  }
}

class chatUser {
  final String username;
  final String useremail;
  final String employeeId;
  chatUser(this.username, this.useremail, this.employeeId);
}

String getEmployeeById(
  int sender_employeeid,
  int reciever_cec_employeeid2,
) {
  String result = "";
  for (var employee in Constants.cec_employees) {
    if ((employee['cec_employeeid'].toString() ==
            sender_employeeid.toString()) &&
        (reciever_cec_employeeid2.toString() !=
            Constants.cec_client_id.toString())) {
      result = employee["employee_name"] + " " + employee["employee_surname"];
      print("fgfghg $result");
      return result;
    }
  }
  if (result.isEmpty) {
    print(
        "employee_id generate empty name $sender_employeeid $reciever_cec_employeeid2");
    for (var employee in Constants.cec_employees) {
      if (employee['cec_employeeid'].toString() ==
          reciever_cec_employeeid2.toString()) {
        result = employee["employee_name"] + " " + employee["employee_surname"];
        // print("fgfghg $result");
        return result;
      }
    }
    return "";
  } else
    return result;
}
