import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constants/Constants.dart';
import '../models/PaymentHistoryItem.dart';
import '../models/reprintitem.dart';

List<ReprintItem> reprintList2C = [];
List<PaymentHistoryItem> paymentList = [];
bool showOptions = false;
bool isReprintListLoading = false;
List<Map<String, dynamic>> paymentHistoryList = [];
List<Map<String, dynamic>> policyDetailsList = [];
getReprintHistory() async {
  if (kDebugMode) {
    print(Constants.user_reference);
    print(Constants.cec_client_id);
  }
  String baseUrl = "https://miinsightsapps.net/files";
  String urlPath = "/get_requests_awaiting_action/";
  String apiUrl = baseUrl + urlPath;
  DateTime now = DateTime.now();

  // Construct the request body
  Map<String, dynamic> requestBody = {
    "policy_number": "ATH00170",
    "cec_client_id": Constants.cec_client_id,
    // "cec_client_id": Constants.cec_client_id,
  };
  reprintList2C = [];
  try {
    var response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode(requestBody),
      headers: {
        "Content-Type": "application/json",
      },
    );
    print(response.body);
    // Simulating transaction processing with a delay

    // Navigator.of(context).pop();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List<dynamic>;
      List<ReprintItem> reprintList2C = [];

      for (var element in data) {
        reprintList2C.add(ReprintItem.fromJson(element));
      }

      // Sorting the list by the timestamp (collection_date) in descending order
      reprintList2C.sort((a, b) =>
          DateTime.parse(b.timestamp).compareTo(DateTime.parse(a.timestamp)));

      isReprintListLoading = false;
      return reprintList2C;
    } else {
      isReprintListLoading = false;

      var errorData = jsonDecode(response.body);
      print(
          "Request failed with status: ${response.statusCode}, data: $errorData");

      return [];
    }

    // Perform your transaction logic here

    // Close the dialog
  } catch (error) {
    print("Error: $error");
  }
}
