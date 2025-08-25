import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';

import '../constants/constants.dart';
import 'customwidgets/custom_input.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword();

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
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
    if (Constants.currentleadAvailable != null) {
      _cellphoneController.text =
          Constants.currentleadAvailable!.leadObject.cellNumber;
      setState(() {});
    }
    // Constants.InsightsReportsbaseUrl = "http://192.168.1.111:8000";
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

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red[400],
                  size: 48,
                ),
                SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Constants.ctaColorLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _resendOtp() async {
    if (_remainingSeconds > 0) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
            '${Constants.InsightsReportsbaseUrl}/api/authentication/resend_otp/'),
        body: json.encode({'email': _cellphoneController.text}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody["success"] == true) {
          otpNumber = responseBody['otp_number'];
          setState(() {
            _isOtpSent = true;
            _isLoading = false;
            _startTimer();
          });
          MotionToast.success(
            description: Text("OTP resent!"),
          ).show(context);
        }
      } else if (response.statusCode == 404) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Account Not Found',
            'We could not find an account associated with this email address. Please check your email and try again.');
        return;
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Unable to Resend OTP',
            'We cannot process your request at the moment. Please try again in a few minutes.');
        return;
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Unable to Resend OTP',
          'We cannot process your request at the moment. Please try again in a few minutes.');
    }
  }

  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String baseUrl =
          '${Constants.InsightsReportsbaseUrl}/api/authentication/reset_password/';
      final response = await http.post(
        Uri.parse(baseUrl),
        body: json.encode({'email': _cellphoneController.text}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody["success"] == true) {
          otpNumber = responseBody['otp_number'];
          setState(() {
            _isOtpSent = true;
            _isLoading = false;
            _startTimer();
          });
          MotionToast.success(
            description: Text("OTP sent!"),
          ).show(context);
        }
      } else if (response.statusCode == 404) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Account Not Found',
            'We could not find an account associated with this email address. Please check your email and try again.');
        return;
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Unable to Reset Password',
            'We cannot reset your password at the moment. Please try again in a few minutes.');
        return;
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Unable to Reset Password',
          'We cannot reset your password at the moment. Please try again in a few minutes.');
    }
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.post(
        Uri.parse(
            '${Constants.InsightsReportsbaseUrl}/api/authentication/verify_otp/'),
        body: json.encode(
            {'email': _cellphoneController.text, 'otp': _otpController.text}),
        headers: {'Content-Type': 'application/json'},
      );
      print("sashjas12 ${response.statusCode}${response.body}");

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody["success"] == true) {
          setState(() {
            _isOtpVerified = true;
            _isLoading = false;
          });
          MotionToast.success(
            description: Text("OTP verified!"),
          ).show(context);
        }
      } else if (response.statusCode == 404) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Account Not Found',
            'We could not find an account associated with this email address. Please check your email and try again.');
        return;
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Unable to Verify OTP',
            'We cannot verify your OTP at the moment. Please try again in a few minutes.');
        return;
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Unable to Verify OTP',
          'We cannot verify your OTP at the moment. Please try again in a few minutes.');
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
      } else if (response.statusCode == 404) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Account Not Found',
            'We could not find an account associated with this email address. Please check your email and try again.');
        return;
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Unable to Update Password',
            'We cannot update your password at the moment. Please try again in a few minutes.');
        return;
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Unable to Update Password',
          'We cannot update your password at the moment. Please try again in a few minutes.');
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          elevation: 6,
          shadowColor: Colors.grey.withOpacity(0.15),
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Reset Password",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Container(
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
                    padding: const EdgeInsets.only(top: 55.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Constants.ctaColorLight),
                      ),
                    ),
                  )
                : !_isOtpSent
                    ? Column(
                        children: [
                          SizedBox(height: 12),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16),
                            child: Container(
                              height: 120,
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset(
                                "assets/logos/MI AnalytiX 2 Tone.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Center(
                            child: Text(
                              "Reset Password",
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
                              "Enter your registered email below to receive password instruction",
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
                            child: CustomInput(
                              hintText: "Account Email",
                              controller: _cellphoneController,
                              onChanged: (value) {},
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
                                      "Reset password",
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
                                "MI Fintech \u00a9 ${DateTime.now().year}.All rights reserved",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      )
                    : !_isOtpVerified
                        ? Column(
                            children: [
                              SizedBox(height: 12),
                              Container(
                                height: 120,
                                width: MediaQuery.of(context).size.width,
                                child: SvgPicture.asset(
                                  "assets/logo_main.svg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 24),
                              Center(
                                child: Text(
                                  "An OTP was sent to the number ending in ${getLastThreeDigits(otpNumber)}",
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
                                  "Enter the OTP and your new password below",
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
                                child: CustomInput(
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
                                    border: Border.all(
                                        color: Constants.ctaColorLight),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.deepPurple.withOpacity(0.4),
                                        spreadRadius: 0,
                                        blurRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: TextButton(
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(left: 16, right: 16),
                                      width: double.infinity,
                                      height: MediaQuery.of(context)
                                                  .size
                                                  .width <
                                              500
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
                                        borderRadius:
                                            BorderRadius.circular(360),
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
                              Container(
                                height: 120,
                                width: MediaQuery.of(context).size.width,
                                child: SvgPicture.asset(
                                  "assets/logo_main.svg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 12),
                              Center(
                                child: Text(
                                  "Set a new password",
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
                                  "Enter your new password below",
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
                                child: CustomInput(
                                  hintText: "New Password",
                                  controller: _passwordController,
                                  onChanged: (value) {},
                                  onSubmitted: (value) {
                                    if (_validatePassword(value)) {
                                      _verifyPasswordFocusNode.requestFocus();
                                    }
                                  },
                                  textInputAction: TextInputAction.next,
                                  focusNode: _passwordFocusNode,
                                  isPasswordField: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: CustomInput(
                                  hintText: "Verify New Password",
                                  controller: _verifyPasswordController,
                                  onChanged: (value) {},
                                  onSubmitted: (value) {
                                    if (_validatePassword(value)) {
                                      _verifyPasswordFocusNode.requestFocus();
                                    }
                                  },
                                  textInputAction: TextInputAction.next,
                                  focusNode: _verifyPasswordFocusNode,
                                  isPasswordField: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "The password must have at least 6 characters, 1 uppercase letter, 1 lowercase letter, 1 number and 1 special character",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Constants.ctaColorLight,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                        color: Constants.ctaColorLight),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.deepPurple.withOpacity(0.4),
                                        spreadRadius: 0,
                                        blurRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: TextButton(
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(left: 16, right: 16),
                                      width: double.infinity,
                                      height: MediaQuery.of(context)
                                                  .size
                                                  .width <
                                              500
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
                                          "Send new Password",
                                          style: GoogleFonts.inter(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: _submitNewPasswordForm,
                                    style: TextButton.styleFrom(
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(360),
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
                                    "MI Fintech \u00a9 ${DateTime.now().year}.All rights reserved",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
          ),
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
