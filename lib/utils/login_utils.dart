import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mi_insights/HomePage.dart';
import 'package:mi_insights/services/Sales%20Agent/sale_agent_home.dart';
import 'package:motion_toast/motion_toast.dart';
import '../Login.dart';
import '../constants/Constants.dart';

import '../services/sharedpreferences.dart';

/// Shows a loading dialog
void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => LoadingDialog(),
  );
}

/// Shows an error toast
void showErrorToast(BuildContext context, String errorMessage) {
  MotionToast.error(
    height: 40,
    description: Text(
      errorMessage,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontFamily: 'YuGothic',
      ),
    ),
  ).show(context);
}

/// Shows a welcome toast
void showWelcomeToast(BuildContext context, String userName) {
  MotionToast.success(
    height: 55,
    width: 280,
    onClose: () {},
    description: Text(
      "Welcome " + (userName ?? ""),
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontFamily: 'YuGothic',
      ),
    ),
  ).show(context);
}

/// Shows a success toast
void showSuccessToast(BuildContext context, String message) {
  MotionToast.success(
    height: 55,
    width: 280,
    onClose: () {},
    description: Text(
      message,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontFamily: 'YuGothic',
      ),
    ),
  ).show(context);
}

/// Shows a warning toast
void showWarningToast(BuildContext context, String message) {
  MotionToast.warning(
    height: 55,
    width: 280,
    description: Text(
      message,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontFamily: 'YuGothic',
      ),
    ),
  ).show(context);
}

/// Handles network errors
void handleNetworkError(BuildContext context) {
  EncryptedSharedPreferences.getLastLoginDateTime().then((lastLoginDate) {
    if (lastLoginDate != null) {
      final now = DateTime.now();
      final difference = now.difference(lastLoginDate).inHours;

      if (difference < 24) {
        // Less than 24 hours since last login, proceed to the homepage.
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SalesAgentHomePage()),
          (Route<dynamic> route) => false,
        );
      } else {
        // More than 24 hours or exact 24 hours since last login, show toast.
        showNetworkErrorToast(context);
      }
    } else {
      // Last login date is not available, show network error toast.
      showNetworkErrorToast(context);
    }
  }).catchError((error) {
    showNetworkErrorToast(context);
  });
}

/// Shows a network error toast
void showNetworkErrorToast(BuildContext context) {
  Fluttertoast.showToast(
    msg: "Network error. Please check your internet connection and try again.",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

/// Handles other errors
void handleOtherErrors(BuildContext context, dynamic error) {
  print(error.toString());
  Navigator.of(context).pop();
  Fluttertoast.showToast(
    msg: "Network Error! (E1)",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

/// Formats the title text with the last letter of the second word in orange
RichText formatTitleText(List<String> words) {
  String secondWord = words[1];
  String beforeLastLetter = secondWord.substring(0, secondWord.length - 1);
  String lastLetter = secondWord.substring(secondWord.length - 1);

  return RichText(
    text: TextSpan(
      children: [
        // First word and part of the second word
        TextSpan(
          text: "${words[0]} $beforeLastLetter",
          style: TextStyle(
            color: Colors.blue[900], // Standard color
            fontSize: 17,
            fontWeight: FontWeight.w500,
            fontFamily: 'YuGothic',
          ),
        ),
        // The last letter of the second word in orange
        TextSpan(
          text: lastLetter,
          style: TextStyle(
            color: Constants.ctaColorLight, // Make this letter orange
            fontSize: 17,
            fontWeight: FontWeight.w500,
            fontFamily: 'YuGothic',
          ),
        ),
        // Handle any remaining words after the second word
        if (words.length > 2)
          TextSpan(
            text: " ${words.sublist(2).join(' ')}",
            style: TextStyle(
              color:
                  Colors.blue[900], // Standard color for the rest of the text
              fontSize: 17,
              fontWeight: FontWeight.w500,
              fontFamily: 'YuGothic',
            ),
          ),
      ],
    ),
  );
}

/// Creates the button style
ButtonStyle createButtonStyle() {
  return ElevatedButton.styleFrom(
    foregroundColor: Colors.black,
    backgroundColor: Colors.white,
    padding: EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 15,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );
}

/// Navigates to the appropriate screen based on user role
void navigateToAppropriateScreen(BuildContext context, List<String> roles) {
  print("sdffds0 ${roles} ${Constants.myUserRoleLevel.toLowerCase()}");
  if (Constants.myUserRoleLevel.toLowerCase() == "administrator") {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  } else if (Constants.myUserRole.toLowerCase() == "executive") {
    Constants.account_type = "executive";
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  } else if (Constants.myUserRole.toLowerCase() == "specialist") {
    Constants.account_type = "sales_agent";
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SalesAgentHomePage()),
    );
  }
}

bool hasTemporaryTesterRole(List<String> roles) {
  return roles.any((role) => role.toLowerCase().contains('temporary_tester'));
}
