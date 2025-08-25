import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mi_insights/constants/Constants.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionChecker {
  static String _baseUrl =
      '${Constants.InsightsReportsbaseUrl}/api/check_app_version/';

  Future<void> checkAppVersion(String platform) async {
    try {
      print("Checking app version...on $_baseUrl");

      // Get the current version of the app
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;
      print("Current version: $currentVersion");

      // Create the request payload
      Map<String, String> requestPayload = {
        'platform': platform,
        'current_version': currentVersion,
      };

      // Send the request to the server
      var response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestPayload),
      );

      // Parse the response
      if (response.statusCode == 200) {
        print("Response: ${response.body}");
        var responseData = jsonDecode(response.body);

        bool upToDate = responseData['up_to_date'];
        if (upToDate) {
          print('App is up to date');
          Constants.containsAppUpdate = false;
        } else {
          var latestVersion = responseData['latest_version'];
          String latestVersionNumber = latestVersion['version'];
          String releaseNotes = latestVersion['release_notes'];
          //String downloadUrl = latestVersion['download_url'];
          bool mandatoryUpdate = latestVersion['mandatory_update'];
          Constants.containsAppUpdate = true;
          Constants.appUpdatedownloadUrl = latestVersion['download_url'] ?? "";

          print('Update required to version $latestVersionNumber');
          print('Release notes: $releaseNotes');
          print('Download URL: ${Constants.appUpdatedownloadUrl}');
          if (mandatoryUpdate) {
            print('This update is mandatory.');
            Constants.mandatoryUpdate = true;
          }
        }
      } else {
        print('Failed to check version: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error checking app version: $e');
    }
  }
}
