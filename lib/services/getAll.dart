import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/Constants.dart';

Future<void> getAllUsers(
  String empId,
  String client_id,
) async {
  https: //uat.miinsightsapps.net/fieldV6/getLeadss?empId=3&searchKey=6&status=all&cec_client_id=1&type=field&startDate=2023-08-01&endDate=2023-08-31
  String baseUrl =
      "https://miinsightsapps.net/chat/getAllUserDetails?empId=${empId}&client_id=${client_id}";
  ;
  try {
    if (kDebugMode) {
      //print("baseUrl $baseUrl");
    }

    await http.get(
        Uri.parse(
          baseUrl,
        ),
        headers: {
          "Cookie":
              "userid=expiry=2021-04-25&client_modules=1001#1002#1003#1004#1005#1006#1007#1008#1009#1010#1011#1012#1013#1014#1015#1017#1018#1020#1021#1022#1024#1025#1026#1027#1028#1029#1030#1031#1032#1033#1034#1035&clientid=&empid=3&empfirstname=Mncedisi&emplastname=Khumalo&email=mncedisi@athandwe.co.za&username=mncedisi@athandwe.co.za&dob=8/28/1985 12:00:00 AM&fullname=Mncedisi Khumalo&userRole=5&userImage=mncedisi@athandwe.co.za.jpg&employedAt=branch&role=leader&branchid=6&branchname=Boulders&jobtitle=Administrative Assistant&dialing_strategy=Campaign Manager&clientname=Test 1 Funeral Parlour&foldername=maafrica&client_abbr=AS&pbx_account=pbx1051ef0a&soft_phone_ip=&agent_type=branch&mip_username=mnces@mip.co.za&agent_email=Mr Mncedisi Khumalo&ViciDial_phone_login=&ViciDial_phone_password=&ViciDial_agent_user=99&ViciDial_agent_password=&device_id=dC7JwXFwwdI:APA91bF0gTbuXlfT6wIcGMLY57Xo7VxUMrMH-MuFYL5PnjUVI0G5X1d3d90FNRb8-XmcjI40L1XqDH-KAc1KWnPpxNg8Z8SK4Ty0xonbz4L3sbKz3Rlr4hyBqePWx9ZfEp53vWwkZ3tx&servername=http://localhost:55661"
        }).then((value) async {
      http.Response response = value;
      if (kDebugMode) {
        //print(response.bodyBytes);
        //print(response.statusCode);
        //  print("fghhgg " + response.body);
      }
      if (response.statusCode != 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? savedResponse =
            prefs.getString('getAllUserDetails_${client_id}_savedResponse');

        if (savedResponse != null) {
          String? savedResponse =
              prefs.getString('getAllUserDetails_${client_id}_savedResponse');

          var jsonResponse = jsonDecode(savedResponse!);
          Constants.all_branches =
              List<Map<String, dynamic>>.from(jsonResponse);
        } else {}
      } else {
        var jsonResponse = jsonDecode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('getAllUserDetails_${client_id}_savedResponse',
            jsonEncode(jsonResponse));

        //print("all users " + jsonResponse.toString());
        Constants.cec_employees = List<Map<String, dynamic>>.from(jsonResponse);
        //logLongString("all users1 " + Constants.cec_employees.toString());

        //Map responsedata = jsonDecode(response.body);
        //print(responsedata["byAgent"]);
      }
    });
  } catch (exception) {
    //Exception exc = exception as Exception;
    Fluttertoast.showToast(
        msg: exception.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

Future<void> getAllBranches(
  BuildContext context,
  String empId,
  String client_id,
) async {
  https: //uat.miinsightsapps.net/fieldV6/getLeadss?empId=3&searchKey=6&status=all&cec_client_id=1&type=field&startDate=2023-08-01&endDate=2023-08-31
  String baseUrl =
      "https://miinsightsapps.net/reports/getBranches?cec_client_id=${client_id}";

  try {
    if (kDebugMode) {
      //print("baseUrl $baseUrl");
    }

    await http.get(
        Uri.parse(
          baseUrl,
        ),
        headers: {
          "Cookie":
              "userid=expiry=2021-04-25&client_modules=1001#1002#1003#1004#1005#1006#1007#1008#1009#1010#1011#1012#1013#1014#1015#1017#1018#1020#1021#1022#1024#1025#1026#1027#1028#1029#1030#1031#1032#1033#1034#1035&clientid=&empid=3&empfirstname=Mncedisi&emplastname=Khumalo&email=mncedisi@athandwe.co.za&username=mncedisi@athandwe.co.za&dob=8/28/1985 12:00:00 AM&fullname=Mncedisi Khumalo&userRole=5&userImage=mncedisi@athandwe.co.za.jpg&employedAt=branch&role=leader&branchid=6&branchname=Boulders&jobtitle=Administrative Assistant&dialing_strategy=Campaign Manager&clientname=Test 1 Funeral Parlour&foldername=maafrica&client_abbr=AS&pbx_account=pbx1051ef0a&soft_phone_ip=&agent_type=branch&mip_username=mnces@mip.co.za&agent_email=Mr Mncedisi Khumalo&ViciDial_phone_login=&ViciDial_phone_password=&ViciDial_agent_user=99&ViciDial_agent_password=&device_id=dC7JwXFwwdI:APA91bF0gTbuXlfT6wIcGMLY57Xo7VxUMrMH-MuFYL5PnjUVI0G5X1d3d90FNRb8-XmcjI40L1XqDH-KAc1KWnPpxNg8Z8SK4Ty0xonbz4L3sbKz3Rlr4hyBqePWx9ZfEp53vWwkZ3tx&servername=http://localhost:55661"
        }).then((value) async {
      http.Response response = value;
      if (kDebugMode) {
        //print("hgjh " + response.bodyBytes.toString());
        //print(response.statusCode);
        //print(response.body);
      }
      if (response.statusCode != 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? savedResponse =
            prefs.getString('getBranches_${client_id}_savedResponse');

        if (savedResponse != null) {
          String? savedResponse =
              prefs.getString('getBranches_${client_id}_savedResponse');

          var jsonResponse = jsonDecode(savedResponse!);
          Constants.all_branches =
              List<Map<String, dynamic>>.from(jsonResponse);
        } else {}
      } else {
        var jsonResponse = jsonDecode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'getBranches_${client_id}_savedResponse', jsonEncode(jsonResponse));

        //print("all branches " + jsonResponse.toString());
        Constants.all_branches = List<Map<String, dynamic>>.from(jsonResponse);
        //print("all users1 " + Constants.cec_employees.toString());

        //Map responsedata = jsonDecode(response.body);
        //print(responsedata["byAgent"]);
      }
    });
  } catch (exception) {
    //Exception exc = exception as Exception;
    Fluttertoast.showToast(
        msg: exception.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
