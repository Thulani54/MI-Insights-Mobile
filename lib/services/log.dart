import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mi_insights/constants/Constants.dart';

import '../models/ValutainmentModels.dart';

Future<void> logAction({
  required int cecClientId,
  required int employeeId,
  required String employeeName,
  required String action,
  required String details,
  required String policyOrReference,
  required String deviceId,
  required String ipAddress,
  required bool isPayment,
  required String payload,
  required String responseText,
  double? latitude,
  double? longitude,
  required int statusCode,
}) async {
  final url =
      Uri.parse('${Constants.InsightsReportsbaseUrl}/api/app_logs/log_action/');
  if (kDebugMode) {
    // print("fghghj ${url}");
  }

  final Map<String, dynamic> requestData = {
    'app_name': "MI Insights Mobile",
    'app_version': Constants.myAppVersion,
    'cec_client_id': cecClientId,
    'employee_id': employeeId,
    'employee_name': employeeName,
    'action': action,
    'details': details,
    'policy_or_reference': policyOrReference,
    'device_id': deviceId,
    'ip_address': ipAddress,
    'is_payment': isPayment,
    'payload': payload,
    'latitude': latitude ?? "",
    'longitude': longitude ?? "",
    'payload': payload,
    'response': responseText,
    'status_code': statusCode,
  };

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(requestData),
    );

    if (response.statusCode == 201) {
      print('Log saved successfully');
    } else {
      print('Failed to save log: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<ValuetainmentLogResponseModel> submitValuetainmentLog({
  required int cecClientId,
  required int cecEmployeeId,
  required int moduleId,
  required String action,
  required int questionId,
  required int choiceId,
  String description = '',
  int? attemptId,
}) async {
  String baseUrl = Constants.InsightsReportsbaseUrl +
      "/api/valuetainment/submit_valuetainment_log/";
  Map<String, dynamic> payload = {
    "cec_client_id": cecClientId,
    "cec_employeeid": cecEmployeeId,
    "module_id": moduleId,
    "action": action,
    "description": description,
    "question_id": questionId,
    "choice_id": choiceId,
  };

  if (attemptId != null) {
    payload["attempt_id"] = attemptId;
  }

  try {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    Map<String, dynamic> responseData = jsonDecode(response.body);
    print("fdfgfg ${responseData}");

    if (response.statusCode == 200) {
      print("Log submitted successfully with ID: ${responseData["log_id"]}");
      return ValuetainmentLogResponseModel.fromJson(responseData);
    } else if (response.statusCode == 200) {
      if (responseData["timed_out"] == true) {
        print(
            "Assessment timed out. Score: ${responseData["score"]}, Result: ${responseData["result"]}");
      } else if (responseData.containsKey("remaining_time")) {
        print("Remaining time: ${responseData["remaining_time"]} minutes");
      }
      return ValuetainmentLogResponseModel.fromJson(responseData);
    } else {
      String errorMessage = responseData["error"] ?? "Failed to submit log";
      print("Error: $errorMessage");
      return ValuetainmentLogResponseModel(logId: 0);
    }
  } catch (error) {
    print("Error: $error");
    return ValuetainmentLogResponseModel(logId: 0);
  }
}
