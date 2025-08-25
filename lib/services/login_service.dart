import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:motion_toast/motion_toast.dart';
import '../HomePage.dart';
import '../Login.dart';
import '../constants/Constants.dart';
import '../models/BusinessInfo.dart';
import '../screens/Admin/NotificationManagement.dart';
import '../screens/HomeGoldenWheel.dart';
import '../screens/Testing/LeadInformationPage.dart' hide LeadInformationPage;
import '../screens/Test/TestWelcomePage.dart';
import '../screens/Valuetainment/Admin/admin.dart';
import '../services/log.dart';
import '../services/sharedpreferences.dart';

import '../utils/login_utils.dart';
import 'Sales Agent/sale_agent_home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../admin/ClientSearchPage.dart';

// Global controllers from Login.dart
TextEditingController? email_controller;
TextEditingController? password_controller;

/// Sets the global controllers for clearing them after login
void setLoginControllers(TextEditingController emailController,
    TextEditingController passwordController) {
  email_controller = emailController;
  password_controller = passwordController;
}

/// Clears the login form controllers
void clearLoginControllers() {
  email_controller?.clear();
  password_controller?.clear();
}

/// Makes the API request and returns the response for user authentication
Future<http.Response> authenticateUser(String email, String password) async {
  String baseUrl =
      Constants.InsightsReportsbaseUrl + "api/rights_and_roles/login_r/";
  if (kDebugMode) {
    print("dffgfggffg ${baseUrl}");
  }

  Map payload = {
    "device_id":
        "${Constants.device_id}###${Constants.device_model}###${Constants.device_os_version}",
    "password": password,
    "email": email,
    "latitude": 0,
    "longitude": 0,
  };

  http.Response response = await http.post(
    Uri.parse(baseUrl),
    body: jsonEncode(payload),
    headers: {'Content-Type': 'application/json'},
  );

  if (kDebugMode) {
    print("fdd $baseUrl");
    print("fdd ${jsonDecode(response.body)}");
  }

  return response;
}

/// Sets up user constants from response data
void setupUserConstants(Map responsedata, String email, BuildContext context) {
  Constants.screenWidth = MediaQuery.of(context).size.width;
  Constants.screenHeight = MediaQuery.of(context).size.height;
  Constants.myDisplayname = responsedata["user_name"];
  Constants.myEmail = email;
  Constants.myCell = responsedata["user_cell"] ?? "";
  Constants.cec_client_id = responsedata["cec_client_id"] ?? 0;
  Constants.organo_id = responsedata["organo_id"] ?? 0;
  Constants.user_role = (responsedata["user_role"]).toString();
  Constants.cec_employeeid = responsedata["user_id"];
  Constants.cec_empid = responsedata["user_id"];
  Constants.business_name = responsedata["business_name"] ?? "";
  Constants.current_quote = responsedata["quote"] ?? "";
  Constants.myUserModules = List<String>.from(responsedata["modules"] ?? "");

  String extractedRole = responsedata["user_role"] ?? "";
  Constants.myUserRoleLevel = (extractedRole.split(" - ")[0]).toLowerCase();
  Constants.myUserRole = (extractedRole.split(" - ")[1]).toLowerCase();
  Constants.myUserFunction = (extractedRole.split(" - ")[3]).toLowerCase();

  print("Extracted Role: ${Constants.myUserRole.toLowerCase()}*");
  print("Extracted Function: ${Constants.myUserFunction.toLowerCase()}*");
}

/// Saves user session data
Future<void> saveUserSession(
    Map responsedata, String email, String password) async {
  // Save user session data using BOTH methods to ensure consistency
  await Sharedprefs.saveUserLoggedInSharedPreference(true);
  await Sharedprefs.saveUserNameSharedPreference(responsedata["user_name"]);
  await Sharedprefs.saveUserEmailSharedPreference(email);
  await Sharedprefs.saveUserEmailSharedPreference2(email);
  await Sharedprefs.saveUserEmpIdSharedPreference(responsedata["user_id"]);
  await Sharedprefs.saveUserPasswordPreference(password);
  await Sharedprefs.saveUserCecClientIdSharedPreference(
      responsedata["cec_client_id"]);

  print("gfgfgf-1  ${Constants.cec_client_id}${password}");

  // ALSO save using standard SharedPreferences for fingerprint compatibility
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('fingerprint_enabled', true);
  await prefs.setBool('require_password', false);
  await prefs.setString('saved_email', email);
  await prefs.setString('saved_password', password);
  await prefs.setBool('user_logged_in', true);

  print(
      "Saved credentials - Email: ${email}, Password saved: ${password.isNotEmpty}");
}

/// Saves logo and banners
Future<void> saveLogoAndBanners(Map responsedata) async {
  // Save logo and banners
  if (responsedata["logo"] != null) {
    print("ghhhj ${responsedata["logo"]}");
    await Sharedprefs.saveLogoUrlSharedPreference(responsedata["logo"]);
  } else {
    await Sharedprefs.saveLogoUrlSharedPreference("");
  }

  if (responsedata["banners"] != null) {
    print("ghhhj ${responsedata["banners"]}");
    List<String> banners = List<String>.from(responsedata["banners"]);
    List<String> actual_banners = [];
    for (String banner in banners) {
      actual_banners.add(banner);
    }
    await Sharedprefs.savebannersSharedPreference(actual_banners);
  }

  if (kDebugMode) {
    print("dffgfg5  ${Constants.cec_client_id}${Constants.logoUrl}");
  }
}

/// Saves encrypted user data
Future<void> saveEncryptedUserData(Map responsedata) async {
  await EncryptedSharedPreferences.saveLastLoginDateTime(DateTime.now());
  await EncryptedSharedPreferences.saveEncryptedString(
      "employee_name", responsedata["user_name"]);
  await EncryptedSharedPreferences.saveEncryptedInt(
      "cec_client_id", responsedata["cec_client_id"]);
  await EncryptedSharedPreferences.saveEncryptedInt(
      "cec_employeeid", responsedata["user_id"]);
}

/// Makes the API request to get business details
Future<http.Response> makeBusinessDetailsRequest() async {
  String baseUrl = "${Constants.InsightsApiBusbaseUrl}";
  String urlPath = "/parlour/company_info/";
  String apiUrl = baseUrl + urlPath;

  // Construct the request body
  Map<String, dynamic> requestBody = {
    "token": "kjhjguytuyghjgjhg765764tyfu",
    "cec_client_id": Constants.cec_client_id,
  };

  return await http.post(
    Uri.parse(apiUrl),
    body: jsonEncode(requestBody),
    headers: {"Content-Type": "application/json"},
  );
}

/// Processes the business details response
void processBusinessDetailsResponse(http.Response response) {
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    print("dataxhjhjhk $data");

    Constants.currentBusinessInfo = BusinessInfo(
      address_1: data["address_1"] ?? "",
      address_2: data["address_2"] ?? "",
      city: data["city"] ?? "",
      province: data["province"] ?? "",
      country: data["country"] ?? "",
      area_code: data["area_code"] ?? "",
      postal_address_1: data["postal_address_1"] ?? "",
      postal_address_2: data["postal_address_2"] ?? "",
      postal_city: data["postal_city"] ?? "",
      postal_province: data["postal_province"] ?? "",
      postal_country: data["postal_country"] ?? "",
      postal_code: data["postal_code"] ?? "",
      tel_no: data["tel_no"] ?? "",
      cell_no: data["cell_no"] ?? "",
      comp_name: data["comp_name"] ?? "",
      vat_number: data["vat_number"] ?? "",
      client_fsp: data["client_fsp"] ?? "",
      logo: data["logo"] ?? "",
    );
  } else {
    var data = jsonDecode(response.body);
    print("datafghhg $data");
    print("Request failed with status: ${response.statusCode}");
  }
}

/// Main function to get business details
Future<void> getBusinessDetails() async {
  try {
    var response = await makeBusinessDetailsRequest();
    processBusinessDetailsResponse(response);
  } catch (error) {
    print("Error: $error");
  }
}

/// Makes the API request to check terms acceptance
Future<http.Response> makeTermsAcceptanceRequest() async {
  String url = "${Constants.insightsbaseUrl}files/check_terms_acceptance/";
  return await http.get(Uri.parse(url));
}

/// Processes the terms acceptance response
Future<void> processTermsAcceptanceResponse(http.Response response) async {
  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    bool accepted = data['accepted'];
    if (data['accepted'] == true) {
      Constants.accepted_terms = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('accepted_terms', true);
    } else if (data['accepted'] == false) {
      Constants.accepted_terms = false;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('accepted_terms', false);
    }
    // print("Terms accepted: $accepted");
  } else {
    // print("Error: Unable to check terms acceptance.");
  }
}

/// Main function to check terms acceptance
Future<void> checkTermsAccepted(int empId, int cecClientId) async {
  try {
    http.Response response = await makeTermsAcceptanceRequest();
    await processTermsAcceptanceResponse(response);
  } catch (e) {
    print("Exception caught: $e");
  }
}

/// Records terms acceptance
Future<void> acceptTerms(
    int empId, int cecClientId, int termsId, bool accepted) async {
  String acceptTermsUrl =
      "${Constants.insightsbaseUrl}files/accept_terms_and_conditions/";

  Map<String, dynamic> payload = {
    "emp_id": empId,
    "cec_client_id": cecClientId,
    "terms_id": termsId,
    "accepted": accepted,
  };

  try {
    http.Response response = await http.post(
      Uri.parse(acceptTermsUrl),
      body: json.encode(payload),
      headers: {'Content-Type': 'application/json'},
    );
    if (kDebugMode) {
      // print('Response status: ${response.statusCode}');
      //  print('Response body: ${response.body}');
    }

    if (response.statusCode == 200) {
      // print("Terms acceptance recorded successfully.");
    } else {
      // print("Error: Unable to record terms acceptance.");
    }
  } catch (e) {
    // print("Exception caught: $e");
  }
}

/// Handles non-200 status code responses
void handleNon200Response(BuildContext context, Map responsedata) {
  Navigator.of(context).pop();
  MotionToast.error(
      height: 45,
      width: 280,
      description: Text(
        "Authentication failed",
        style: TextStyle(color: Colors.white),
      )).show(context);
}

/// Authenticates with fingerprint
Future<bool> authenticateWithFingerprint(BuildContext context) async {
  try {
    final LocalAuthentication localAuth = LocalAuthentication();

    // Check if biometric authentication is available
    bool isAvailable = await localAuth.canCheckBiometrics;
    if (!isAvailable) {
      return false;
    }

    // Check if fingerprint is enrolled
    List<BiometricType> availableBiometrics =
        await localAuth.getAvailableBiometrics();
    if (availableBiometrics.isEmpty) {
      return false;
    }

    // Authenticate with fingerprint
    bool isAuthenticated = await localAuth.authenticate(
      localizedReason: 'Please authenticate to access your account',
      options: AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );

    return isAuthenticated;
  } catch (e) {
    print("Fingerprint authentication error: $e");
    return false;
  }
}

/// Signs in with fingerprint
Future<void> signInWithFingerprint(BuildContext context) async {
  try {
    // Check if fingerprint is enabled
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool fingerprintEnabled = prefs.getBool('fingerprint_enabled') ?? false;

    if (!fingerprintEnabled) {
      showErrorToast(context, "Fingerprint authentication is not enabled");
      return;
    }

    // Authenticate with fingerprint
    bool authenticated = await authenticateWithFingerprint(context);

    if (authenticated) {
      // Get saved credentials
      String? savedEmail = prefs.getString('saved_email');
      String? savedPassword = prefs.getString('saved_password');

      if (savedEmail != null && savedPassword != null) {
        // Proceed with normal login using saved credentials
        await signInUser(context, savedEmail, savedPassword);
      } else {
        showErrorToast(context, "No saved credentials found");
      }
    } else {
      showErrorToast(context, "Fingerprint authentication failed");
    }
  } catch (e) {
    print("Fingerprint login error: $e");
    showErrorToast(
        context, "An error occurred during fingerprint authentication");
  }
}

/// Main sign in function
Future<void> signInUser(
  BuildContext context,
  String email,
  String password,
) async {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => LoadingDialog(),
  );

  try {} catch (e) {
    Navigator.of(context).pop();
    Fluttertoast.showToast(
      msg: "Could not get current location.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  try {
    String baseUrl =
        Constants.InsightsReportsbaseUrl + "api/rights_and_roles/login_r/";
    Map payload = {
      "device_id":
          "${Constants.device_id}###${Constants.device_model}###${Constants.device_os_version}",
      "password": password,
      "email": email,
      "latitude": 0,
      "longitude": 0,
    };

    http.post(Uri.parse(baseUrl),
        body: jsonEncode(payload),
        headers: {'Content-Type': 'application/json'}).then((value) async {
      http.Response response = value;
      print("fdd ${baseUrl}");
      print("fdd ${jsonDecode(response.body)}");

      if (response.statusCode != 200) {
        Map responsedata = jsonDecode(response.body);
        Navigator.of(context).pop();
        String responsemsg =
            responsedata["ErrorMessage"] ?? "Authentication failed";
        if (responsemsg == "'int' object has no attribute 'role'" ||
            responsemsg == "User role not assigned") {
          // Navigate to RoleNotAssignedScreen if available
          // For now, show error toast since RoleNotAssignedScreen is not implemented
          MotionToast.error(
            height: 55,
            width: 280,
            description: Text(
              responsemsg,
              style: TextStyle(color: Colors.white),
            ),
          ).show(context);
        } else {
          MotionToast.error(
            height: 55,
            width: 280,
            description: Text(
              responsemsg,
              style: TextStyle(color: Colors.white),
            ),
          ).show(context);
        }
      } else {
        Map responsedata = jsonDecode(response.body);

        if (responsedata["success"] == true &&
            responsedata["authentication_successful"] == true) {
          Constants.screenWidth = MediaQuery.of(context).size.width;
          Constants.screenHeight = MediaQuery.of(context).size.height;
          clearLoginControllers();
          Constants.myDisplayname = responsedata["user_name"];
          Constants.myEmail = email;
          Constants.myCell = responsedata["user_cell"] ?? "";
          Constants.cec_client_id = responsedata["cec_client_id"] ?? 0;
          Constants.organo_id = responsedata["organo_id"] ?? 0;
          Constants.user_role = (responsedata["user_role"]).toString();
          Constants.cec_employeeid = responsedata["user_id"];
          Constants.cec_empid = responsedata["user_id"];
          Constants.business_name = responsedata["business_name"] ?? "";
          Constants.current_quote = responsedata["quote"] ?? "";
          Constants.myUserModules =
              List<String>.from(responsedata["modules"] ?? "");

          String extractedRole = responsedata["user_role"] ?? "";
          print("Extracted Role: $extractedRole");

          // Split the role string and extract parts
          List<String> roleParts = extractedRole.split(" - ");

          Constants.myUserRoleLevel =
              (roleParts[0]).toLowerCase(); // "underwriter"
          Constants.myUserRole = roleParts.length > 1
              ? (roleParts[1]).toLowerCase()
              : ""; // "insurer"
          Constants.myUserFunction = roleParts.length > 3
              ? (roleParts[3]).toLowerCase()
              : ""; // "finance management"

          if (kDebugMode) {
            print(
                "Extracted Role Level2: ${Constants.myUserRoleLevel.toLowerCase()}*");
          }
          print("Extracted Role: ${Constants.myUserRole.toLowerCase()}*");
          print(
              "Extracted Function: ${Constants.myUserFunction.toLowerCase()}*");

          List<String> roles = List<String>.from(responsedata["roles"]);
          Constants.myUserRoles = roles;
          List<String> permissions =
              List<String>.from(responsedata["permissions"]);
          List<String> modules = List<String>.from(responsedata["modules"]);

          Constants.permissions = permissions;

          if (kDebugMode) {
            print("Roles: $roles");
            print("Permissions: $permissions");
            print("Modules: $modules");
          }

          Sharedprefs.saveUserLoggedInSharedPreference(true);
          Sharedprefs.saveUserNameSharedPreference(responsedata["user_name"]);
          print("ghhhj -1 ${responsedata["logo"]}");
          if (responsedata["logo"] != null) {
            print("ghhhj ${responsedata["logo"]}");
            Sharedprefs.saveLogoUrlSharedPreference(responsedata["logo"]);
          } else {
            Sharedprefs.saveLogoUrlSharedPreference("");
          }
          if (responsedata["banners"] != null) {
            print("ghhhj ${responsedata["banners"]}");
            List<String> banners = List<String>.from(responsedata["banners"]);
            List<String> actual_banners = [];
            for (String banner in banners) {
              actual_banners.add(banner);
            }
            Sharedprefs.savebannersSharedPreference(actual_banners);
          }
          print("dffgfg5  ${Constants.cec_client_id}" + Constants.logoUrl);
          if (Constants.cec_client_id > 1) {
            NotificationApiService()
                .getLatestNotification(Constants.cec_client_id);
          }

          Sharedprefs.saveUserEmailSharedPreference(email);
          Sharedprefs.saveUserEmailSharedPreference2(email);
          Sharedprefs.saveUserEmpIdSharedPreference(responsedata["user_id"]);
          Sharedprefs.saveUserPasswordPreference(password);
          Sharedprefs.saveUserCecClientIdSharedPreference(
              responsedata["cec_client_id"]);

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('require_password', false);

          Future.delayed(Duration(seconds: 3), () async {
            Navigator.of(context).pop(); // Close the loading dialog
            print("sdffds-1 ${Constants.myUserRoleLevel.toLowerCase()}");
            print("sdffds0 ${roles}");

            if (hasTemporaryTesterRole(roles)) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LeadInformationPage()));
            } else if (Constants.myUserRoleLevel.toLowerCase() ==
                "super admin") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ClientSearchPage()));
            } else if (Constants.myUserRoleLevel.toLowerCase() ==
                "administrator") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyHomePage()));
            } else if (Constants.myUserRoleLevel.toLowerCase() ==
                "underwriter") {
              // Fixed: Check myUserRoleLevel instead of myUserRole
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyHomePage()));
            } else if (Constants.myUserRoleLevel.toLowerCase() ==
                    "specialist" ||
                Constants.myUserRoleLevel == "sales_agent") {
              // Also check role level for specialist
              Constants.account_type = "sales_agent";
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SalesAgentHomePage()));
            } else {
              // Default navigation for other roles
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyHomePage()));
            }

            // Log the action
            logAction(
              cecClientId: Constants.cec_client_id,
              employeeId: Constants.cec_empid,
              employeeName: '${Constants.myDisplayname}',
              action: 'Login',
              details: 'User logged in successfully',
              policyOrReference: '',
              deviceId:
                  "${Constants.device_id}###${Constants.device_model}###${Constants.device_os_version}",
              ipAddress: '',
              isPayment: false,
              payload: '',
              latitude: 0,
              longitude: 0,
              responseText: 'Success',
              statusCode: 200,
            );

            if (Constants.hasGoldenWheelAccess == true) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Goldenwheel()));
            } else if (Constants.account_type == "executive") {}

            checkTermsAccepted(
                responsedata["user_id"], responsedata["cec_client_id"]);
            acceptTerms(responsedata["user_id"], responsedata["cec_client_id"],
                1, true);

            MotionToast.success(
              height: 55,
              width: 280,
              onClose: () {},
              description: Text(
                "Welcome " + (responsedata["user_name"] ?? ""),
                style: TextStyle(color: Colors.white),
              ),
            ).show(context);

            EncryptedSharedPreferences.saveLastLoginDateTime(DateTime.now());
            EncryptedSharedPreferences.saveEncryptedString(
                "employee_name", responsedata["user_name"]);
            EncryptedSharedPreferences.saveEncryptedString(
                "employee_email", email);
            EncryptedSharedPreferences.saveEncryptedInt(
                "cec_client_id", responsedata["cec_client_id"]);
            EncryptedSharedPreferences.saveEncryptedInt(
                "cec_employeeid", responsedata["user_id"]);
          });
        } else if (responsedata["success"] == false) {
          Navigator.of(context).pop();
          MotionToast.error(
            description: Text(
              responsedata["ErrorMessage"] ?? "Authentication failed",
              style: TextStyle(color: Colors.white),
            ),
          ).show(context);
        } else {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: responsedata["error"] ?? "Authentication failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      }
    });
  } catch (error) {
    Navigator.of(context).pop(); // Make sure to close loading dialog on error
    if (error is SocketException) {
      handleNetworkError(context);
      if (kDebugMode) {
        print("Exception0 caught: $error");
      }
    } else {
      handleOtherErrors(context, error);
    }
    if (kDebugMode) {
      print("Exception caught1: $error");
    }
  }
}
