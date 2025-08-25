import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';

import '../../constants/Constants.dart';
import '../../customwidgets/custom_input.dart';

class Fiels_Sales_Verify_Otp extends StatefulWidget {
  const Fiels_Sales_Verify_Otp();

  @override
  _Fiels_Sales_Verify_OtpState createState() => _Fiels_Sales_Verify_OtpState();
}

class _Fiels_Sales_Verify_OtpState extends State<Fiels_Sales_Verify_Otp> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _otpFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _verifyPasswordFocusNode = FocusNode();

  final TextEditingController _cellphoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _verifyPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _isOtpSent = false;
  bool _isOtpVerified = false;
  String otpNumber = "";
  Timer? _timer;
  int _remainingSeconds = 300; // 5 minutes

  @override
  void initState() {
    super.initState();
    _isOtpSent = false;
    _isOtpVerified = false;
    _cellphoneController.text = "0683289404";
    //Constants.InsightsReportsbaseUrl = "http://192.168.1.111:8000";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailFocusNode.dispose();
    _otpFocusNode.dispose();
    _passwordFocusNode.dispose();
    _verifyPasswordFocusNode.dispose();
    _cellphoneController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    _verifyPasswordController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _remainingSeconds = 300; // 5 minutes
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  String _formatRemainingTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _resendOtp() async {
    // Prevent resending if timer is active
    if (_remainingSeconds > 0) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // API endpoint for resending OTP
      var url =
          '${Constants.InsightsReportsbaseUrl}/api/resend_digital_sale_otp/';
      var headers = {'Content-Type': 'application/json'};
      var body = json.encode({
        "cec_client_id": Constants.cec_client_id,
        "cec_employee_id": Constants.cec_employeeid,
        "onololeadid": Constants.currentleadAvailable!.leadObject.onololeadid,
        "type": "SMS", // Use "EMAIL" for email-based OTPs
        "phone_number": _cellphoneController.text, // Phone number for SMS
        "email": "-", // Email is "-" for SMS type
      });

      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody["success"] == true) {
          otpNumber = responseBody['otp_number']; // OTP from the response

          setState(() {
            _isOtpSent = true;
            _isLoading = false;
            _startTimer(); // Restart the timer for the resend
          });

          // Show success toast
          MotionToast.success(
            description: Text("OTP resent!"),
          ).show(context);
        } else {
          throw Exception('Failed to resend OTP: ${responseBody["message"]}');
        }
      } else {
        throw Exception('Failed to resend OTP: ${response.reasonPhrase}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Show error toast
      MotionToast.error(
        description: Text(
          e.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ).show(context);
    }
  }

  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Set up the request headers
      var headers = {'Content-Type': 'application/json'};

      // Define the request payload
      var requestBody = json.encode({
        "cec_client_id": Constants.cec_client_id,
        "cec_employee_id": Constants.cec_employeeid,
        "onololeadid": Constants.currentleadAvailable!.leadObject.onololeadid,
        "type": "SMS",
        "email": "-",
        "phone_number": _cellphoneController.text,
      });
      print(
          "dffgf ${Constants.InsightsReportsbaseUrl}/api/create_digital_sale_otp/");

      // Create the request
      var request = http.Request(
        'POST',
        Uri.parse(
            '${Constants.InsightsReportsbaseUrl}/api/create_digital_sale_otp/'),
      );
      request.body = requestBody;
      request.headers.addAll(headers);

      // Send the request
      http.StreamedResponse streamedResponse = await request.send();

      // Handle the response
      if (streamedResponse.statusCode == 200 ||
          streamedResponse.statusCode == 201) {
        // Parse the response body
        String responseString = await streamedResponse.stream.bytesToString();
        Map<String, dynamic> responseBody = json.decode(responseString);

        // Check for success in the response
        if (responseBody["digital_otp_id"] != null) {
          setState(() {
            /*      otpNumber =
                responseBody['otp_number']; // OTP received from response*/
            _isOtpSent = true;
            _isLoading = false;
          });

          // Start OTP timer
          _startTimer();

          // Show success notification
          MotionToast.success(
            description: Text("OTP sent successfully!"),
          ).show(context);
        } else {
          throw Exception('Failed to send OTP: ${responseBody["message"]}');
        }
      } else {
        // Handle non-200 status codes
        throw Exception('Failed to send OTP: ${streamedResponse.reasonPhrase}');
      }
    } catch (e) {
      // Handle any errors
      setState(() {
        _isLoading = false;
      });

      // Show error notification
      MotionToast.error(
        description: Text(
          e.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ).show(context);
    }
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Set up request headers
      var headers = {'Content-Type': 'application/json'};

      // Define request body
      var requestBody = json.encode({
        "cec_client_id": Constants.cec_client_id,
        "cec_employee_id": Constants.cec_employeeid,
        "onololeadid": Constants.currentleadAvailable!.leadObject.onololeadid,
        "otp": _otpController.text, // OTP entered by the user
      });

      // Create and send the request
      var request = http.Request(
        'POST',
        Uri.parse(
            '${Constants.InsightsReportsbaseUrl}/api/verify_digital_sale_otp/'),
      );
      request.body = requestBody;
      request.headers.addAll(headers);

      http.StreamedResponse streamedResponse = await request.send();

      // Handle the response
      if (streamedResponse.statusCode == 200) {
        // Parse the response body
        String responseString = await streamedResponse.stream.bytesToString();
        Map<String, dynamic> responseBody = json.decode(responseString);
        print("xbnxzhj ${responseBody} ${responseString}");

        // Check if verification was successful
        if (responseBody["message"] == "OTP verified successfully") {
          setState(() {
            _isOtpVerified = true;
            _isLoading = false;
          });

          // Show success dialog
          /* showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Success'),
              content: Text('OTP verified successfully!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );*/

          MotionToast.success(
            description: Text("OTP verified!"),
          ).show(context);
        } else {
          throw Exception(
              'OTP verification failed: ${responseBody["message"]}');
        }
      } else {
        // Handle non-200 status codes
        throw Exception(
            'Failed to verify OTP: ${streamedResponse.reasonPhrase}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Show error notification
      MotionToast.error(
        description: Text(
          e.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ).show(context);
    }
  }

  Future<void> _submitNewPasswordForm() async {
    if (_passwordController.text != _verifyPasswordController.text) {
      MotionToast.error(
        description: Text(
          "Passwords do not match!",
          style: TextStyle(color: Colors.white),
        ),
      ).show(context);
      return;
    }

    if (!_validatePassword(_passwordController.text)) {
      MotionToast.error(
        description: Text(
          "Password does not meet criteria",
          style: TextStyle(color: Colors.white),
        ),
      ).show(context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
            '${Constants.InsightsReportsbaseUrl}/api/authentication/update_password/'),
        body: json.encode({
          'email': _cellphoneController.text,
          'new_password': _passwordController.text,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
        MotionToast.success(
          description: Text(
            "Password updated successfully",
            style: TextStyle(color: Colors.white),
          ),
        ).show(context);

        Navigator.of(context).pop();
      } else {
        throw Exception('Failed to update password');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      MotionToast.error(
        description: Text(
          e.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ).show(context);
    }
  }

  bool _validatePassword(String value) {
    return RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$')
        .hasMatch(value);
  }

  bool _validateOtp(String value) {
    return RegExp(r'^\d{6}$').hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      width: 450,
      constraints: BoxConstraints(
        maxWidth: 550,
      ),
      child: SingleChildScrollView(
        child: _isLoading
            ? Padding(
                padding: const EdgeInsets.only(top: 55.0, bottom: 24),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Constants.ctaColorLight),
                  ),
                ),
              )
            : !_isOtpSent
                ? Column(
                    children: [
                      SizedBox(height: 16),
                      Center(
                        child: Text(
                          "Verify One-Time-Pin",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 12.0, left: 24, right: 24),
                        height: 1,
                        color: Colors.grey.withOpacity(0.15),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Enter the client's cellphone number for verification below ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomInputTransparent4(
                          hintText: "Cellphone number",
                          controller: _cellphoneController,
                          onChanged: (value) {},
                          isEditable: false,
                          onSubmitted: (value) {
                            //_login.requestFocus();
                          },
                          textInputAction: TextInputAction.next,
                          focusNode: _emailFocusNode,
                          isPasswordField: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Constants.ctaColorLight,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Constants.ctaColorLight),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple.withOpacity(0.4),
                                spreadRadius: 0,
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: TextButton(
                            child: Container(
                              margin: EdgeInsets.only(left: 16, right: 16),
                              width: double.infinity,
                              height: MediaQuery.of(context).size.width < 500
                                  ? 32
                                  : MediaQuery.of(context).size.width < 1100 &&
                                          MediaQuery.of(context).size.width <
                                              1100
                                      ? 40
                                      : 45,
                              child: Center(
                                child: Text(
                                  "Send Otp",
                                  style: GoogleFonts.inter(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            onPressed: _submitForm,
                            style: TextButton.styleFrom(
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(360),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            "Additinoal charges apply.",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  )
                : !_isOtpVerified
                    ? Column(
                        children: [
                          SizedBox(height: 24),
                          Center(
                            child: Text(
                              "An OTP was sent to the number ending in ${getLastThreeDigits(_cellphoneController.text)}",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 12.0, left: 24, right: 24),
                            height: 1,
                            color: Colors.grey.withOpacity(0.15),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "Enter the OTP to Inforce the policies.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CustomInputTransparent4(
                              hintText: "Enter the six-digit OTP",
                              controller: _otpController,
                              onChanged: (value) {},
                              onSubmitted: (value) {
                                if (_validateOtp(value)) {
                                  _otpFocusNode.requestFocus();
                                }
                              },
                              textInputAction: TextInputAction.next,
                              focusNode: _otpFocusNode,
                              isPasswordField: false,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Constants.ctaColorLight,
                                borderRadius: BorderRadius.circular(30),
                                border:
                                    Border.all(color: Constants.ctaColorLight),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurple.withOpacity(0.4),
                                    spreadRadius: 0,
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                              child: TextButton(
                                child: Container(
                                  margin: EdgeInsets.only(left: 16, right: 16),
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.width < 500
                                          ? 32
                                          : MediaQuery.of(context).size.width <
                                                      1100 &&
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      1100
                                              ? 40
                                              : 45,
                                  child: Center(
                                    child: Text(
                                      "Verify OTP",
                                      style: GoogleFonts.inter(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed: _verifyOtp,
                                style: TextButton.styleFrom(
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(360),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Didn't receive the OTP?",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _remainingSeconds == 0
                                      ? _resendOtp
                                      : null,
                                  child: Text(
                                    "Resend OTP",
                                    style: TextStyle(
                                      color: _remainingSeconds == 0
                                          ? Constants.ctaColorLight
                                          : Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_remainingSeconds > 0)
                            Text(
                              "You can resend OTP in ${_formatRemainingTime(_remainingSeconds)}",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                "MI Fintech \u00a9 ${DateTime.now().year}.All rights reserved",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(height: 12),
                          SizedBox(height: 12),
                          Center(
                            child: Text(
                              "Otp Verification Successfull",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 12.0, left: 24, right: 24),
                            height: 1,
                            color: Colors.grey.withOpacity(0.15),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "Please verify if the client has received messages with terms and conditions, and payment details. ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                "MI Fintech \u00a9 ${DateTime.now().year}.All rights reserved",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
      ),
    );
  }
}

String getLastThreeDigits(String value) {
  if (value.length >= 3) {
    return value.substring(value.length - 3);
  } else {
    return value;
  }
}
