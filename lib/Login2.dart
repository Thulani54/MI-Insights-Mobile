/*
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mi_insights/HomePage.dart';
import 'package:mi_insights/customwidgets/custom_input.dart';
import 'package:mi_insights/services/sharedpreferences.dart';
import 'package:video_player/video_player.dart';

import 'constants/Constants.dart';

FocusNode email_focusNode = FocusNode();
FocusNode password_focusNode = FocusNode();
TextEditingController email_controller = TextEditingController();
TextEditingController password_controller = TextEditingController();
late VideoPlayerController _controller;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            */
/* _controller.value.isInitialized
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: VideoPlayer(_controller),
                  )
                : Container(),*/ /*

            Container(
              width: MediaQuery.of(context).size.width * 5,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                "lib/assets/backGround.jpg",
                fit: BoxFit.contain,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: SvgPicture.asset("lib/assets/logo_main.svg"),
                  ),
                  // Container(width: 200, height: 200, child: Placeholder()),
                  Text(
                    "FIND YOUR TRIBE",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Forge a new path",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF9BA17B)),
                  ),
                  Container(
                    height: 45,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomInputLine(
                              controller: email_controller,
                              hintText: "Email",
                              onChanged: (val) {},
                              onSubmitted: (val) {},
                              focusNode: email_focusNode,
                              textInputAction: TextInputAction.next,
                              isPasswordField: false),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomInputLine(
                              controller: password_controller,
                              hintText: "Password",
                              onChanged: (val) {},
                              onSubmitted: (val) {},
                              focusNode: password_focusNode,
                              textInputAction: TextInputAction.next,
                              isPasswordField: false),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 55,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.white,
                                        width: 1,
                                        style: BorderStyle.solid))),
                            onPressed: () {
                              if (email_controller.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Please enter your email",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else if (password_controller.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Please enter your password",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                sign_in(context, "mncedisi@athandwe.co.za",
                                    "nosama@2023");
                                //sign_in(context, email_controller.text, password_controller.text);
                              }
                            },
                            child: Container(
                              height: 35.0,
                              width: 100.0,
                              child: Center(
                                child: Text(
                                  'Sign In',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.white,
                                        width: 1,
                                        style: BorderStyle.none))),
                            onPressed: () {},
                            child: Container(
                              child: Center(
                                child: Text(
                                  'Forgot Password',
                                  style: GoogleFonts.inter(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.white,
                                        width: 1,
                                        style: BorderStyle.none))),
                            onPressed: () {
                              */
/*sign_in(context, "mncedisi@athandwe.co.za",
                                  "nosama@2023");*/ /*

                            },
                            child: Container(
                              child: Center(
                                child: Text(
                                  'Forgot password',
                                  style: GoogleFonts.inter(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sign_in(BuildContext context, String email, String password) {
    showDialog(
      context: context,
      barrierDismissible: true, // set to false if you want to force a rating
      builder: (context) => LoadingDialog(),
    );
    String baseUrl = Constants.insightsbaseUrl + "Admin/Login";
    Map payload = {
      "device_id":
          "dC7JwXFwwdI:APA91bF0gTbuXlfT6wIcGMLY57Xo7VxUMrMH-MuFYL5PnjUVI0G5X1d3d90FNRb8-XmcjI40L1XqDH-KAc1KWnPpxNg8Z8SK4Ty0xonbz4L3sbKz3Rlr4hyBqePWx9ZfEp53vWwkZ3tx",
      "password": password,
      "userEmail": email
    };
    try {
      http.post(Uri.parse(baseUrl), body: payload).then((value) {
        http.Response response = value;
        if (kDebugMode) {
          print(response);
          print(response.statusCode);
          print(response.body);
        }
        if (response.statusCode != 200) {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "Could not sign in",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Navigator.of(context).pop();
          Map responsedata = jsonDecode(response.body);

          List<dynamic>? usersList = responsedata["userExists"];
          if (usersList == null) {
            if (responsedata["ErrorMessagePassword"] != null) {
              Fluttertoast.showToast(
                  msg: responsedata["ErrorMessagePassword"],
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else if (responsedata["ErrorMessageNullCredentials"] != null) {
              Fluttertoast.showToast(
                  msg: responsedata["ErrorMessageNullCredentials"],
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          } else if (usersList!.isNotEmpty) {
            print(usersList![0]);
            Constants.myDisplayname = usersList[0]["employee_name"];
            Constants.myEmail = usersList[0]["employee_email"];
            Constants.myCell = usersList[0]["client_phone"];
            Constants.cec_client_id = usersList[0]["cec_client_id"];
            Constants.cec_employeeid = usersList[0]["cec_employeeid"];
            Sharedprefs.saveUserLoggedInSharedPreference(true);
            Sharedprefs.saveUserNameSharedPreference(
                usersList[0]["employee_name"]);
            Sharedprefs.saveUserEmailSharedPreference(
                usersList[0]["employee_email"]);
            Sharedprefs.saveUserEmpIdSharedPreference(
                usersList[0]["cec_employeeid"]);
            print("cec_employeeid ${Constants.cec_employeeid}");
            Sharedprefs.saveUserEmailSharedPreference(
                usersList[0]["client_phone"]);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyHomePage()));
            Fluttertoast.showToast(
                msg: "Welcome " + usersList[0]["employee_name"],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            Fluttertoast.showToast(
                msg: "Please verify your email and password",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
      });
    } catch (exception) {
      Navigator.of(context).pop();
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

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('lib/assets/vid_2.mp4')
      ..initialize().then((_) {
        _controller.play();
        setState(() {});
      });
  }
}

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16.0),
            Text(
              'Signing In...',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
*/
