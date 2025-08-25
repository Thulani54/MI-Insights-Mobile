import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mi_insights/services/inactivitylogoutmixin.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../constants/Constants.dart';
import '../../../models/NotificationModel.dart';

bool isLoadingChatData = false;
int syncs = 0;
final AudioPlayer audioPlayer = AudioPlayer();

class SalesAgentChatScreen extends StatefulWidget {
  final String username;
  final String useremail;
  final int cec_employee_id;
  const SalesAgentChatScreen(
      {super.key,
      required this.username,
      required this.useremail,
      required this.cec_employee_id});

  @override
  State<SalesAgentChatScreen> createState() => _SalesAgentChatScreenState();
}

List<NotificationModel> messages = [];

class _SalesAgentChatScreenState extends State<SalesAgentChatScreen>
    with InactivityLogoutMixin {
  TextEditingController messageController = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  Timer? _syncTimer;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xff2c3e50),
        appBar: AppBar(
          title: Text(widget.username),
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
        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollStartNotification ||
                scrollNotification is ScrollUpdateNotification) {
              restartInactivityTimer();
            }
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 8),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Color(0xff2c3e50),
              child: Column(
                children: [
                  Expanded(
                    child: AnimatedList(
                      key: _listKey,
                      shrinkWrap: true,
                      reverse: false, // Ensure the list starts from the bottom
                      initialItemCount: messages.length,
                      itemBuilder: (context, index, animation) {
                        final message = messages[index];
                        bool isMe =
                            message.receiverId == Constants.cec_employeeid;
                        print(
                            "dfghghg1 ${message.senderId} ${message.receiverId} ${message.notificationTitle}");
                        print("dfghghg2 ${Constants.cec_employeeid}");

                        // Create a fade-in animation using the same `animation` controller
                        Animation<double> fadeAnimation = CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        );

                        return SwipeActionCell(
                          backgroundColor: Color(0xff2c3e50),
                          key: ValueKey(message
                              .id), // Assuming your Message model has an id
                          trailingActions: <SwipeAction>[
                            SwipeAction(
                              title: "Delete",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                              onTap: (CompletionHandler handler) async {
                                await handler(true);
                                deleteMessage(index, message.notificationId);
                              },
                              color: Colors.red,
                            ),
                          ],
                          child: FadeTransition(
                            opacity: fadeAnimation,
                            child: SlideTransition(
                              position: animation.drive(
                                Tween(begin: Offset(0, 1), end: Offset(0, 0))
                                    .chain(CurveTween(curve: Curves.easeInOut)),
                              ),
                              child: ChatBubble(
                                text: message.notificationBody,
                                isMe: isMe,
                                timestamp: formatTimestamp(message.timestamp),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
                                          setState(() {});
                                          if (kDebugMode) {
                                            print("ghghghhjgjh");
                                          }
                                          sendMessage();
                                        },
                                        child: Container(
                                          height: 45,
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
                                                  Icons.send,
                                                  color: Colors.white,
                                                  size: 24,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      hintText: 'Write your message..',
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
                                    controller: messageController,
                                    onChanged: (val) {
                                      restartInactivityTimer();
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();
    messages = [];
    setState(() {});
    getAllMessages();
    restartInactivityTimer();
    startPeriodicSync();
  }

  void startPeriodicSync() {
    _syncTimer =
        Timer.periodic(Duration(seconds: 2), (Timer t) => getAllMessages());
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    messages = [];
    super.dispose();
  }

  Future<void> deleteMessage(int index, int cecNotificationsId) async {
    messages.removeAt(index);
    _listKey.currentState
        ?.removeItem(index, (context, animation) => Container());
    final Uri url = Uri.parse(
        '${Constants.InsightsAdminbaseUrl}admin/deleteMessage?cec_notifications_id=$cecNotificationsId');

    try {
      // Send the GET request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Handle successful response
        print('Message deleted successfully');
        print("gfhfgh  " + response.body);
      } else {
        // Handle non-successful response
        print('Failed to delete message. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors that occur during the request
      print('Error deleting message: $e');
    }
  }

  getAllMessages() async {
    String baseUrl =
        "https://miinsightsapps.net/admin/getMyNotificationsReload?cec_employeid=${Constants.cec_employeeid}";

    try {
      isLoadingChatData = true;
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Cookie":
              "userid=expiry=2021-04-25&client_modules=1001#1002#1003#1004#1005#1006#1007#1008#1009#1010#1011#1012#1013#1014#1015#1017#1018#1020#1021#1022#1024#1025#1026#1027#1028#1029#1030#1031#1032#1033#1034#1035&clientid=&empid=3&empfirstname=Mncedisi&emplastname=Khumalo&email=mncedisi@athandwe.co.za&username=mncedisi@athandwe.co.za&dob=8/28/1985 12:00:00 AM&fullname=Mncedisi Khumalo&userRole=5&userImage=mncedisi@athandwe.co.za.jpg&employedAt=branch&role=leader&branchid=6&branchname=Boulders&jobtitle=Administrative Assistant&dialing_strategy=Campaign Manager&clientname=Test 1 Funeral Parlour&foldername=maafrica&client_abbr=AS&pbx_account=pbx1051ef0a&soft_phone_ip=&agent_type=branch&mip_username=mnces@mip.co.za&agent_email=Mr Mncedisi Khumalo&ViciDial_phone_login=&ViciDial_phone_password=&ViciDial_agent_user=99&ViciDial_agent_password=&device_id=dC7JwXFwwdI:APA91bF0gTbuXlfT6wIcGMLY57Xo7VxUMrMH-MuFYL5PnjUVI0G5X1d3d90FNRb8-XmcjI40L1XqDH-KAc1KWnPpxNg8Z8SK4Ty0xonbz4L3sbKz3Rlr4hyBqePWx9ZfEp53vWwkZ3tx&servername=http://localhost:55661"
        },
      );

      if (kDebugMode) {
        print("synced!!! ${syncs}");
      }

      if (response.statusCode == 200) {
        List<dynamic> all_notifications = jsonDecode(response.body);

        int specificSenderId = Constants.cec_employeeid;
        int specificReceiverId = widget.cec_employee_id;

        List<NotificationModel> filteredNotificationModels = all_notifications
            .where((notification) {
              List<String> tagParts =
                  (notification as Map<String, dynamic>)["tag"].split('###');
              int senderId1 = int.parse(tagParts[1]);
              int receiverId1 = int.parse(tagParts[5]);
              int senderId2 = int.parse(tagParts[5]);
              int receiverId2 = int.parse(tagParts[1]);
              bool match1 = senderId1 == specificSenderId &&
                  receiverId1 == specificReceiverId;
              bool match2 = senderId2 == specificSenderId &&
                  receiverId2 == specificReceiverId;
              return match1 || match2;
            })
            .map((notification) => NotificationModel.fromJson(
                notification as Map<String, dynamic>))
            .toList();

        DateTime? lastMessageTimestamp =
            messages.isNotEmpty ? messages.last.timestamp : null;
        List<NotificationModel> newMessages =
            filteredNotificationModels.where((notification) {
          return lastMessageTimestamp == null ||
              notification.timestamp.isAfter(lastMessageTimestamp);
        }).toList();

        if (newMessages.isNotEmpty) {
          for (var notificationModel in newMessages) {
            int index = messages.length;
            messages.add(notificationModel);
            playSendMessageSound();
            _listKey.currentState?.insertItem(index);
            restartInactivityTimer();
          }
        }
      }

      syncs++;
    } catch (_, exception) {
      print(exception);
    }
  }

  Future<void> sendMessage() async {
    String message = messageController.text.trim();
    if (message.isEmpty) {
      if (kDebugMode) {
        print("Message is empty");
      }
      return;
    }

    Map<String, dynamic> notification = {
      "sender_name": getEmployeeById(Constants.cec_employeeid),
      "sent_by": Constants.cec_employeeid.toString(),
      "date": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      "type": "update",
      "cec_client_id": Constants.cec_client_id,
      "cec_employeid": widget.cec_employee_id.toString(),
      "notification_body": message,
    };
    print("ghgghg  " + notification.toString());

    String baseUrl =
        "https://miinsightsapps.net/backend_api/api/admin/sendNotification/";

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Cookie":
              "userid=expiry=2021-04-25&client_modules=1001#1002#1003#1004#1005#1006#1007#1008#1009#1010#1011#1012#1013#1014#1015#1017#1018#1020#1021#1022#1024#1025#1026#1027#1028#1029#1030#1031#1032#1033#1034#1035&clientid=&empid=3&empfirstname=Mncedisi&emplastname=Khumalo&email=mncedisi@athandwe.co.za&username=mncedisi@athandwe.co.za&dob=8/28/1985 12:00:00 AM&fullname=Mncedisi Khumalo&userRole=5&userImage=mncedisi@athandwe.co.za.jpg&employedAt=branch&role=leader&branchid=6&branchname=Boulders&jobtitle=Administrative Assistant&dialing_strategy=Campaign Manager&clientname=Test 1 Funeral Parlour&foldername=maafrica&client_abbr=AS&pbx_account=pbx1051ef0a&soft_phone_ip=&agent_type=branch&mip_username=mnces@mip.co.za&agent_email=Mr Mncedisi Khumalo&ViciDial_phone_login=&ViciDial_phone_password=&ViciDial_agent_user=99&ViciDial_agent_password=&device_id=dC7JwXFwwdI:APA91bF0gTbuXlfT6wIcGMLY57Xo7VxUMrMH-MuFYL5PnjUVI0G5X1d3d90FNRb8-XmcjI40L1XqDH-KAc1KWnPpxNg8Z8SK4Ty0xonbz4L3sbKz3Rlr4hyBqePWx9ZfEp53vWwkZ3tx&servername=http://localhost:55661"
        },
        body: jsonEncode(notification),
      );

      if (response.statusCode == 200) {
        messageController.clear();
      } else {
        print("Failed to send message. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending message: $e");
    }
  }
}

/*

  function newMessage(ev) {
        message = $(".message-input input").val();
        if ($.trim(message) == '' || chatWithId == 0) {
            return false;
        }

        var notification = {
            sender_name : $('#lblName').text(),
            sent_by:$('#lblempid').text(),
            date: getTimeNow(),
            type : 'update',
            cec_client_id :$('#lblclient_id').text(),
            cec_employeid: chatWithId,
            notification_body: message,
        };

        //$.post(httppp + "admin/sendNotification", notification, function (data)
        $.post("/admin/sendNotification", notification, function (data) {
            data = check_json_data(data);
            $('.sentNow').remove();
            notification.cec_notifications_id = data;
            notification.sender_id = $('#lblempid').text();
            notifications.push(notification);
            notification.status = 'new';
            var empNotiIndex = empNotiId.indexOf(chatWithId);
            empNoti[empNotiIndex].push(notification);
            loadMessages(chatid);
        });


     */
/*
admin/readMessages*/

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String timestamp;

  ChatBubble({required this.text, required this.isMe, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[300],
          borderRadius: isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  topRight: Radius.circular(20))
              : BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  topRight: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(text,
                style: TextStyle(color: isMe ? Colors.white : Colors.black)),
            Text(timestamp,
                style: TextStyle(
                    fontSize: 11.5,
                    color: isMe ? Colors.white54 : Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}

String getEmployeeById(
  int cec_employeeid,
) {
  String result = "";
  for (var employee in Constants.cec_employees) {
    if (employee['cec_employeeid'].toString() == cec_employeeid.toString()) {
      result = employee["employee_name"] + " " + employee["employee_surname"];
      print("fgfghg $result");
      return result;
    }
  }
  if (result.isEmpty) {
    return "";
  } else
    return result;
}

void playSendMessageSound() async {
  audioPlayer.play(
    AssetSource("tones/mixkit-long-pop-2358.wav"),
  );
}

String formatTimestamp(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inDays < 31) {
    return timeago.format(timestamp);
  } else {
    return DateFormat('MM/dd/yyyy hh:mm a').format(timestamp);
  }
}
