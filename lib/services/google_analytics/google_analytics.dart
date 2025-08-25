/*
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mi_insights/constants/Constants.dart';
import 'package:mi_insights/services/longPrint.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleAnalytics {
  Future<void> _sendAnalyticsEvent(
      String event, int intValue, double doubleValue, bool boolValue) async {
    Map<String, Object> eventParams = <String, Object>{
      'event': event,
      'int': intValue,
      'double': doubleValue,
      'bool': boolValue.toString(),
      'timestamp': DateTime.now().toString(),
    };

    await Constants.analytics_instance!.logEvent(
      name: event,
      parameters: eventParams,
    );

    await storeToLocal(eventParams);
    setMessage('logEvent succeeded: ${jsonEncode(eventParams)}');
  }

  Future<void> logLoginEvent(bool isSuccess) async {
    String eventName = 'login_event';
    Map<String, Object> eventParams = <String, Object>{
      'event': eventName,
      'success': isSuccess.toString(),
      'timestamp': DateTime.now().toString(),
    };

    await Constants.analytics_instance!.logEvent(
      name: eventName,
      parameters: eventParams,
    );

    await storeToLocal(eventParams);
    setMessage('Login event logged successfully: ${jsonEncode(eventParams)}');
  }

  Future<void> storeToLocal(Map<String, Object> map) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> allLogs = prefs.getStringList('logs') ?? [];

    // Encode the current event map to a string and add to the list
    String currentLog = jsonEncode(map);
    allLogs.add(currentLog);

    // Store the updated list back to SharedPreferences
    await prefs.setStringList('logs', allLogs);
  }

  Future<List<String>> getLogs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('logs') ?? [];
  }

  Future<void> postLogsAsTextFile(String url, String logText) async {
    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..files.add(
          http.MultipartFile.fromString('file', logText, filename: 'logs.txt'));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Log file uploaded successfully.');
    } else {
      print('Failed to upload log file.');
    }
  }

  Future<void> deleteOldLogs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> allLogs = prefs.getStringList('logs') ?? [];
    DateTime now = DateTime.now();
    int days30 = 30 * 24 * 60 * 60 * 1000;

    List<String> updatedLogs = allLogs.where((log) {
      var decodedLog = jsonDecode(log);
      DateTime logDate = DateTime.parse(decodedLog['timestamp']);
      return now.difference(logDate).inMilliseconds < days30;
    }).toList();

    await prefs.setStringList('logs', updatedLogs);
  }

  Future<String> logsToText(List<String> logs) async {
    return logs.join('\n');
  }

  void uploadLogs() async {
    List<String> logs = await getLogs();
    String logText = await logsToText(logs);
    await postLogsAsTextFile('https://yourserver.com/upload', logText);
  }
}

void setMessage(String message) {
  logLongString(message);
}
*/
