import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gif_view/gif_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:mi_insights/HomePage.dart';
import 'package:mi_insights/customwidgets/custom_input.dart';
import 'package:mi_insights/resetPassword.dart';
import 'package:mi_insights/screens/Admin/NotificationManagement.dart';
import 'package:mi_insights/screens/HomeGoldenWheel.dart';
import 'package:mi_insights/screens/Valuetainment/Admin/admin.dart';
import 'package:mi_insights/screens/mi_pay/pdfpreview.dart';
import 'package:mi_insights/screens/mi_pay/policyresults.dart';
import 'package:mi_insights/services/Sales%20Agent/sale_agent_home.dart';
import 'package:mi_insights/services/getAll.dart';
import 'package:mi_insights/services/log.dart';
import 'package:mi_insights/services/longPrint.dart';
import 'package:mi_insights/services/sharedpreferences.dart';
import 'package:mi_insights/services/syncAllData().dart';
import 'package:mi_insights/services/window_manager.dart';
import 'package:mi_insights/services/login_service.dart' as LoginService;
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import 'constants/Constants.dart';
import 'models/BusinessInfo.dart';

bool _isJailbroken = false;
bool _isDeveloperMode = false;
FocusNode email_focusNode = FocusNode();
FocusNode password_focusNode = FocusNode();
TextEditingController email_controller = TextEditingController();
TextEditingController password_controller = TextEditingController();
late VideoPlayerController _controller;
late GifController controller;
bool view_insights = true;
int battery_level = 100;
String networkInfo = "";
bool isConnectedWifi = false;
bool isConnectedMobileNetwork = false;
FocusNode employeeNode = FocusNode();
FocusNode policyNode = FocusNode();
String msgtx = "No Items found";
TextEditingController employeeidController = TextEditingController();
TextEditingController policynumberController = TextEditingController();

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  bool _acceptTerms = false;

  void _toggleAcceptTerms(bool? value) {
    setState(() {
      _acceptTerms = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        //  floatingActionButton: TripleTapFAB(),
        body: view_insights == true
            ? Stack(
                children: [
                  /* _controller.value.isInitialized
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: VideoPlayer(_controller),
                  )
                : Container(),*/
                  /* Container(
              width: MediaQuery.of(context).size.width * 5,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                "assets/backGround.jpg",
                fit: BoxFit.contain,
              ),
            ),*/
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 55,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 120,
                            width: MediaQuery.of(context).size.width,
                            child: Image.asset(
                              "assets/logos/MI AnalytiX 2 Tone.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        /* GifView.asset(
                    'assets/icons/mi_insights_logo_animated.gif',
                    height: 200,
                    width: 200,
                  ),*/
                        (Constants.logoUrl.isNotEmpty)
                            ? Container(
                                height: 130,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: CachedNetworkImage(
                                    imageUrl: Constants.logoUrl,
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => Container(
                                        height: 50,
                                        width: 50,
                                        child: Container()),
                                    // errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                ),
                              )
                            : Container(),
                        // Container(width: 200, height: 200, child: Placeholder()),
                        // if (Constants.currentBusinessInfo.logo.isEmpty)
                        //   Padding(
                        //     padding: const EdgeInsets.only(left: 32.0, right: 32),
                        //     child: Container(
                        //         height: 200,
                        //         width: MediaQuery.of(context).size.width,
                        //         child: Image.asset(
                        //             "assets/business_logos/black_logo_white_background.png")),
                        //   ),
                        SizedBox(
                          height: 16,
                        ),

                        if (Constants.logoUrl.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "WELCOME TO MI INSIGHTS",
                              style: GoogleFonts.lato(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                              ),
                            ),
                          ),
                        if (Constants.logoUrl.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              Constants.account_type == "sales_agent"
                                  ? "I AM DESTINED FOR SUCCESS"
                                  : "DRIVE BUSINESS GROWTH",
                              style: GoogleFonts.lato(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        SizedBox(
                          height: 16,
                        ),
                        if (Constants.logoUrl.isNotEmpty)
                          Text(
                            Constants.account_type == "sales_agent"
                                ? "Achieving Greatness In Every Sale"
                                : "Through Real-time Tracking of KPI's",
                            style: GoogleFonts.lato(
                              color: Constants.ctaColorLight,
                              fontWeight: FontWeight.w600,
                              fontSize: 13.5,
                            ),
                          ),
                        if (Constants.logoUrl.isEmpty)
                          Text(
                            "SIGN IN TO CONTINUE",
                            style: GoogleFonts.lato(
                              color: Constants.ctaColorLight,
                              fontWeight: FontWeight.w600,
                              fontSize: 13.5,
                            ),
                          ),
                        Container(
                          height: 28,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomInput(
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
                                child: CustomInput(
                                    controller: password_controller,
                                    hintText: "Password",
                                    onChanged: (val) {},
                                    onSubmitted: (val) {},
                                    focusNode: password_focusNode,
                                    textInputAction: TextInputAction.next,
                                    isPasswordField: true),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
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
                                    //sign_in(context, "Master@everestmpu.com", "123456");
                                    sign_in(
                                        context,
                                        email_controller.text.trim(),
                                        password_controller.text.trim());
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Constants.ctaColorLight,
                                        borderRadius:
                                            BorderRadius.circular(360),
                                        border: Border.all(
                                            color: Constants.ctaColorLight)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0,
                                          right: 8,
                                          top: 12,
                                          bottom: 12),
                                      child: Center(
                                        child: Text(
                                          "Sign In",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            letterSpacing: 1.05,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "TradeGothic",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ResetPassword(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 20.0, left: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(360),
                                        border: Border.all(
                                            color: Constants.ctaColorLight)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0,
                                          right: 8,
                                          top: 12,
                                          bottom: 12),
                                      child: Center(
                                        child: Text(
                                          "Forgot Password",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            letterSpacing: 1.05,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "TradeGothic",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        /*      Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              child: Center(
                                  child: Text.rich(
                                      textAlign: TextAlign.center,
                                      TextSpan(
                                          text:
                                              'By continuing, you agree to our ',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Terms of Service',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        MaterialApp(
                                                                          debugShowCheckedModeBanner:
                                                                              false,
                                                                          home:
                                                                              Scaffold(
                                                                            appBar:
                                                                                AppBar(
                                                                              leading: InkWell(
                                                                                onTap: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                child: Icon(
                                                                                  CupertinoIcons.back,
                                                                                  color: Colors.black,
                                                                                ),
                                                                              ),
                                                                              backgroundColor: Colors.white,
                                                                              title: Text(
                                                                                "Terms and conditions",
                                                                                style: TextStyle(color: Colors.black),
                                                                              ),
                                                                            ),
                                                                            body:
                                                                                ListView(
                                                                              shrinkWrap: true,
                                                                              physics: NeverScrollableScrollPhysics(),
                                                                              children: [
                                                                                SizedBox(height: 8),
                                                                                SizedBox(
                                                                                  height: 12,
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 8, right: 16),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      "MI FinTech Solutions (Pty) Ltd Mobile Application - MI Legends Club Terms of Use and Privacy Policy",
                                                                                      style: GoogleFonts.inter(
                                                                                        textStyle: TextStyle(
                                                                                          fontSize: 15,
                                                                                          letterSpacing: 0,
                                                                                          fontWeight: FontWeight.bold,
                                                                                          color: Colors.black,
                                                                                        ),
                                                                                      ),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  child: Stack(
                                                                                    children: [
                                                                                      Container(
                                                                                        height: 2,
                                                                                        width: double.infinity,
                                                                                        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(6)),
                                                                                        margin: EdgeInsets.only(left: 24, right: 24, top: 16),
                                                                                      ),
                                                                                      Center(
                                                                                        child: Container(
                                                                                          height: 2,
                                                                                          width: MediaQuery.of(context).size.width * 0.4,
                                                                                          decoration: BoxDecoration(color: Constants.ctaColorLight, borderRadius: BorderRadius.circular(6)),
                                                                                          margin: EdgeInsets.only(left: 32, right: 32, top: 16),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                //

                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    'Welcome to the MI FinTech Solutions (Pty) Ltd Mobile Application named "MI Insights" ("App"). By accessing or using MI Insights, you agree to comply with and be bound by the following Terms of Use and Privacy Policy. If you do not agree with these terms, please do not use MI Insights.',
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                //
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "Terms of Use",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 15.5,
                                                                                        decoration: TextDecoration.none,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "1. Acceptance of Terms",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13.5,
                                                                                        decoration: TextDecoration.underline,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    'These Terms of Use constitute a legally binding agreement between you and MI FinTech Solutions (Pty) Ltd ("MI FinTech," "we," "us," or "our"). You acknowledge that you have read, understood, and agreed to be bound by these terms.',
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                //
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "2. Use of MI Insights",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13.5,
                                                                                        decoration: TextDecoration.underline,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "2.1 Eligibility: You must be an authorized employee of the company legally contracted to use MI Insights. By using MI Insights, you represent and warrant that you have the authority to act on behalf of your employer.",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "2.2 Account Registration: Your employer may need to create an account for you to access certain rights and features of MI Insights. You agree to provide accurate, current, and complete information during the registration process and to keep your account information updated.",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "2.3 Security: You are responsible for maintaining the confidentiality of your account credentials and for any activity that occurs under your account. Notify us immediately if you suspect any unauthorized use of your account.",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "2.4 Prohibited Activities: You agree not to use MI Insights for any illegal, unauthorized, or prohibited purpose. This includes, but is not limited to, unauthorized access, data mining, or any action that could disrupt the functionality of MI Insights.",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                //
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "3. Privacy",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13.5,
                                                                                        decoration: TextDecoration.underline,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "We are committed to protecting your privacy and that of the client who is served using MI Insights. Our Privacy Policy outlines how we collect, use, and disclose information. By using MI Insights, you consent to the practices described in our Privacy Policy.",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                //
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "4. Intellectual Property",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13.5,
                                                                                        decoration: TextDecoration.underline,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    'All content and materials available on MI Insights, including but not limited to text, graphics, logos, images, and software, are the property of MI FinTech Solutions (Pty) Ltd or its licensors. You are granted a limited, non-exclusive, non-transferable, and revocable license to access and use MI Insights for its intended purpose.',
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                //

                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "By posting User Content on the Platform, you grant MI Insights a non-exclusive, worldwide, perpetual, irrevocable, royalty-free, sublicensable, transferable right and license to use, copy, modify, create derivative works based on, distribute, publicly display, publicly perform, and otherwise exploit in any manner such User Content in all formats and distribution channels now known or hereafter devised (including in connection with the Platform and MI Insights's business and on third-party sites and services), without further notice to or consent from you, and without the requirement of payment to you or any other person or entity.You represent and warrant that: (i) you either are the sole and exclusive owner of all User Content or you have all rights, licenses, consents, and releases that are necessary to grant to MI Insights the rights in such User Content, as contemplated under this Agreement; and (ii) neither the User Content, nor your submission, uploading, publishing, or otherwise making available of such User Content, nor MI Insights's use of the User Content as permitted herein will infringe, misappropriate or violate a third party's patent, copyright, trademark, trade secret, moral rights, or other proprietary or intellectual property rights, or rights of publicity or privacy, or result in the violation of any applicable law or regulation.",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "Intellectual Property. The Platform and its entire contents, features, and functionality (including but not limited to all information, software, text, displays, images, video, and audio, and the design, selection, and arrangement thereof), are owned by MI Insights, its licensors, or other providers of such material and are protected by South African and international copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights laws.",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 15,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "Third-Party Content and Services",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13.5,
                                                                                        decoration: TextDecoration.underline,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "The Platform may contain links to third-party websites or resources. MI Insights provides these links only as a convenience and is not responsible for the content, products, or services on or available from those websites or resources or links displayed",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "5. Disclaimer of Warranties",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13.5,
                                                                                        decoration: TextDecoration.underline,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    'Individual customers have the right to:',
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                //

                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    '5.1 Access, Update, or Delete Information: Individual customers may request access to their personal information, update inaccuracies, or request deletion by contacting us at +2710 786 1115 and or on namahadik@mi-group.co.za.',
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    '5.2 Opt-Out: Individual customers can opt-out of receiving promotional communications where applicable by following the unsubscribe instructions provided in communications from MI Insights.',
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "6. Children's Privacy",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13.5,
                                                                                        decoration: TextDecoration.underline,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    'MI Insights is not intended for use by individuals under the age of 16. We do not knowingly collect personal information from children under 16. If you believe a child has provided us with personal information, please contact us to have the information removed.',
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "7. Changes to Privacy Policy",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13.5,
                                                                                        decoration: TextDecoration.underline,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    'We reserve the right to update or modify this Privacy Policy at any time. Any changes will be effective upon posting. Continued use of MI Insights after such changes signifies acceptance of the modified policy.',
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "8. Contact Us",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13.5,
                                                                                        decoration: TextDecoration.underline,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    'If you have any questions or concerns about this Privacy Policy, please contact us at +2710 786 1115 and or on namahadik@mi-group.co.za.',
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    'By using the MI Insights mobile application, corporate clients and their individual customers acknowledge that they have read, understood, and agree to these Terms of Use and Privacy Policy.',
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                SizedBox(
                                                                                  height: 16,
                                                                                ),
                                                                                Container(height: 4, color: Colors.grey.withOpacity(0.35), width: MediaQuery.of(context).size.width),
                                                                                SizedBox(height: 12),
                                                                                Container(
                                                                                    alignment: Alignment.center,
                                                                                    padding: EdgeInsets.all(10),
                                                                                    child: Center(
                                                                                        child: Text.rich(TextSpan(text: 'By continuing, you agree to our ', style: TextStyle(fontSize: 14, color: Colors.black), children: <TextSpan>[
                                                                                      TextSpan(
                                                                                          text: 'Terms of Use',
                                                                                          style: TextStyle(
                                                                                            fontSize: 14,
                                                                                            color: Colors.black,
                                                                                            decoration: TextDecoration.none,
                                                                                          ),
                                                                                          recognizer: TapGestureRecognizer()
                                                                                            ..onTap = () {
                                                                                              // code to open / launch terms of service link here
                                                                                            }),
                                                                                      TextSpan(text: ' and ', style: TextStyle(fontSize: 14, color: Colors.black), children: <TextSpan>[
                                                                                        TextSpan(
                                                                                            text: 'Privacy Policy',
                                                                                            style: TextStyle(fontSize: 14, color: Colors.black, decoration: TextDecoration.none),
                                                                                            recognizer: TapGestureRecognizer()
                                                                                              ..onTap = () {
                                                                                                // code to open / launch privacy policy link here
                                                                                              })
                                                                                      ])
                                                                                    ])))),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )));
                                                      }),
                                            TextSpan(
                                                text: ' and ',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: 'Privacy Policy',
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {})
                                                ])
                                          ])))),
                        ),
                      ],
                    ),
                  ),*/

                        if (Constants.containsAppUpdate == true)
                          SizedBox(
                            height: 16,
                          ),

                        if (Constants.isLoggedIn == true)
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(32),
                              onTap: () async {
                                final LocalAuthentication auth =
                                    LocalAuthentication();
                                final bool canAuthenticateWithBiometrics =
                                    await auth.canCheckBiometrics;
                                final bool canAuthenticate =
                                    canAuthenticateWithBiometrics ||
                                        await auth.isDeviceSupported();
                                bool authenticated = false;
                                /* if (kDebugMode) {
                            print('InkWell tapped');
                                                    }
                                                    print(
                              'Can check biometrics: $canAuthenticateWithBiometrics');
                                                    print('Can authenticate: $canAuthenticate');*/

                                try {
                                  authenticated = await auth.authenticate(
                                    localizedReason:
                                        'Scan your fingerprint to authenticate',
                                  );
                                } catch (e) {
                                  print(e);
                                }
                                if (authenticated) {
                                  //print("fghhg");
                                  String email1 = "";
                                  String password1 = "";
                                  Sharedprefs.getUserEmailSharedPreference2()
                                      .then((value) {
                                    print("email1ghjhjk ${email1}");
                                    if (value != null)
                                      email1 = value.toString();
                                  });
                                  Sharedprefs.getUserPasswordPreference()
                                      .then((value) {
                                    if (value != null) password1 = value;
                                    print("password1jhkjk ${password1}");
                                  });

                                  Future.delayed(Duration(seconds: 1))
                                      .then((value) {
                                    if (email1.isEmpty || password1.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Please sign in with your email and password",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else {
                                      LoginService.signInUser(
                                          context, email1, password1);
                                    }
                                  });
                                }
                              },
                              child: SvgPicture.asset(
                                "assets/fingerprint.svg",
                                color: Constants.ctaColorLight,
                              ),
                            ),
                          ),

                        SizedBox(
                          height: 32,
                        ),
                        /*    Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(360),
                              color: Constants.ctaColorLight.withOpacity(0.10)),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "Click Here \n To \n Switch ",
                                  style: TextStyle(
                                      color: Constants.ctaColorLight,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),*/

                        SizedBox(
                          height: 16,
                        ),
                        /*            Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(360),
                                    side: BorderSide(
                                        color: Constants.ctaColorLight,
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
                                */ /*sign_in(context, "mncedisi@athandwe.co.za",
                                    "nosama@2023");*/ /*
                                //sign_in(context, email_controller.text, password_controller.text);
                              }
                            },
                            child: Container(
                              height: 35.0,
                              width: 100.0,
                              child: Center(
                                child: Text(
                                  'Sign Up',
                                  style: GoogleFonts.inter(
                                    color: Constants.ctaColorLight,
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
                  ),*/
                      ],
                    ),
                  ),
                ],
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 55,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 120,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            "assets/logos/MI AnalytiX 2 Tone.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      if (battery_level < 15)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12.0, right: 12, top: 12),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Constants.ctaColorLight,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  width: 1.2,
                                  color: Constants.ctaColorLight,
                                )),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "Your battery is low, the printer might have issues when printing, please plug the device on the charge. ",
                                style: TextStyle(),
                                textAlign: TextAlign.center,
                              ),
                            )),
                          ),
                        ),
                      if (isConnectedWifi == true)
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Please disconnect the app from Wifi connectivity as card payments will not work.",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                width: 1.2,
                                color: Constants.ctaColorLight,
                              )),
                          padding: EdgeInsets.only(left: 0, right: 0),
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CustomInput(
                                  hintText: 'Enter Your Unique Employee # ',
                                  controller: employeeidController,
                                  onChanged: (String) {},
                                  onSubmitted: (String) {},
                                  focusNode: employeeNode,
                                  textInputAction: TextInputAction.next,
                                  isPasswordField: true,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, bottom: 16, top: 8),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                width: 1.2,
                                color: Constants.ctaColorLight,
                              )),
                          padding: EdgeInsets.only(left: 0, right: 16),
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  obscureText: false,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    enabledBorder: null,
                                    contentPadding:
                                        EdgeInsets.only(left: 16, bottom: 8),
                                    border: InputBorder.none,
                                    hintText: 'Enter Client Policy / ID #',
                                    hintStyle: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize: 13.5,
                                          color: Colors.grey,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    focusedBorder: null,
                                    filled: false,
                                    fillColor: Colors.transparent,
                                  ),
                                  focusNode: policyNode,
                                  controller: policynumberController,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 8, left: 16),
                            child: Container(
                              child: Transform.scale(
                                scale: 1.9,
                                child: Checkbox(
                                  activeColor: Constants.ctaColorLight,
                                  checkColor: Colors.white,
                                  value: _acceptTerms,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(36.0),
                                    ),
                                  ),
                                  onChanged: _toggleAcceptTerms,
                                  // controlAffinity: ListTileControlAffinity.leading,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10),
                                child: Center(
                                    child: Text.rich(TextSpan(
                                        text:
                                            'By continuing, you agree to our ',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                        children: <TextSpan>[
                                      TextSpan(
                                          text: 'Terms of Service',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              MaterialApp(
                                                                debugShowCheckedModeBanner:
                                                                    false,
                                                                home: Scaffold(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  appBar:
                                                                      AppBar(
                                                                    leading:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        CupertinoIcons
                                                                            .back,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    title: Text(
                                                                      "Terms and conditions",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                  body:
                                                                      ListView(
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        NeverScrollableScrollPhysics(),
                                                                    children: [
                                                                      SizedBox(
                                                                          height:
                                                                              8),
                                                                      SizedBox(
                                                                        height:
                                                                            12,
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                8,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            "MI FinTech Solutions (Pty) Ltd Mobile Application - MI Pay Terms of Use and Privacy Policy",
                                                                            style:
                                                                                GoogleFonts.inter(
                                                                              textStyle: TextStyle(
                                                                                fontSize: 15,
                                                                                letterSpacing: 0,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            Container(
                                                                              height: 2,
                                                                              width: double.infinity,
                                                                              decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(6)),
                                                                              margin: EdgeInsets.only(left: 24, right: 24, top: 16),
                                                                            ),
                                                                            Center(
                                                                              child: Container(
                                                                                height: 2,
                                                                                width: MediaQuery.of(context).size.width * 0.4,
                                                                                decoration: BoxDecoration(color: Constants.ctaColorLight, borderRadius: BorderRadius.circular(6)),
                                                                                margin: EdgeInsets.only(left: 32, right: 32, top: 16),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      //

                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          'Welcome to the MI FinTech Solutions (Pty) Ltd Mobile Application named "MI Pay" ("App"). By accessing or using MI Pay, you agree to comply with and be bound by the following Terms of Use and Privacy Policy. If you do not agree with these terms, please do not use MI Pay.',
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      //
                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          "Terms of Use",
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 15.5,
                                                                              decoration: TextDecoration.none,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          "1. Acceptance of Terms",
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13.5,
                                                                              decoration: TextDecoration.underline,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          'These Terms of Use constitute a legally binding agreement between you and MI FinTech Solutions (Pty) Ltd ("MI FinTech," "we," "us," or "our"). You acknowledge that you have read, understood, and agreed to be bound by these terms.',
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      //
                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          "2. Use of MI Pay",
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13.5,
                                                                              decoration: TextDecoration.underline,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          "2.1 Eligibility: You must be an authorized employee of the company legally contracted to use MI Pay. By using MI Pay, you represent and warrant that you have the authority to act on behalf of your employer.",
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          "2.2 Account Registration: Your employer may need to create an account for you to access certain rights and features of MI Pay. You agree to provide accurate, current, and complete information during the registration process and to keep your account information updated.",
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          "2.3 Security: You are responsible for maintaining the confidentiality of your account credentials and for any activity that occurs under your account. Notify us immediately if you suspect any unauthorized use of your account.",
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          "2.4 Prohibited Activities: You agree not to use MI Pay for any illegal, unauthorized, or prohibited purpose. This includes, but is not limited to, unauthorized access, data mining, or any action that could disrupt the functionality of MI Pay.",
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      //
                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          "3. Privacy",
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13.5,
                                                                              decoration: TextDecoration.underline,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          "We are committed to protecting your privacy and that of the client who is served using MI Pay. Our Privacy Policy outlines how we collect, use, and disclose information. By using MI Pay, you consent to the practices described in our Privacy Policy.",
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      //
                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          "4. Intellectual Property",
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13.5,
                                                                              decoration: TextDecoration.underline,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          'All content and materials available on MI Pay, including but not limited to text, graphics, logos, images, and software, are the property of MI FinTech Solutions (Pty) Ltd or its licensors. You are granted a limited, non-exclusive, non-transferable, and revocable license to access and use MI Pay for its intended purpose.',
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      //

                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          "By posting User Content on the Platform, you grant MI PAY a non-exclusive, worldwide, perpetual, irrevocable, royalty-free, sublicensable, transferable right and license to use, copy, modify, create derivative works based on, distribute, publicly display, publicly perform, and otherwise exploit in any manner such User Content in all formats and distribution channels now known or hereafter devised (including in connection with the Platform and MI PAY's business and on third-party sites and services), without further notice to or consent from you, and without the requirement of payment to you or any other person or entity.You represent and warrant that: (i) you either are the sole and exclusive owner of all User Content or you have all rights, licenses, consents, and releases that are necessary to grant to MI PAY the rights in such User Content, as contemplated under this Agreement; and (ii) neither the User Content, nor your submission, uploading, publishing, or otherwise making available of such User Content, nor MI PAY's use of the User Content as permitted herein will infringe, misappropriate or violate a third party's patent, copyright, trademark, trade secret, moral rights, or other proprietary or intellectual property rights, or rights of publicity or privacy, or result in the violation of any applicable law or regulation.",
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          "Intellectual Property. The Platform and its entire contents, features, and functionality (including but not limited to all information, software, text, displays, images, video, and audio, and the design, selection, and arrangement thereof), are owned by MI PAY, its licensors, or other providers of such material and are protected by South African and international copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights laws.",
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 15,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          "Third-Party Content and Services",
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13.5,
                                                                              decoration: TextDecoration.underline,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          "The Platform may contain links to third-party websites or resources. MI PAY provides these links only as a convenience and is not responsible for the content, products, or services on or available from those websites or resources or links displayed",
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          "5. Disclaimer of Warranties",
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13.5,
                                                                              decoration: TextDecoration.underline,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          'Individual customers have the right to:',
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      //

                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          '5.1 Access, Update, or Delete Information: Individual customers may request access to their personal information, update inaccuracies, or request deletion by contacting us at +2710 786 1115 and or on namahadik@mi-group.co.za.',
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          '5.2 Opt-Out: Individual customers can opt-out of receiving promotional communications where applicable by following the unsubscribe instructions provided in communications from MI Pay.',
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          "6. Children's Privacy",
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13.5,
                                                                              decoration: TextDecoration.underline,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          'MI Pay is not intended for use by individuals under the age of 16. We do not knowingly collect personal information from children under 16. If you believe a child has provided us with personal information, please contact us to have the information removed.',
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          "7. Changes to Privacy Policy",
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13.5,
                                                                              decoration: TextDecoration.underline,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          'We reserve the right to update or modify this Privacy Policy at any time. Any changes will be effective upon posting. Continued use of MI Pay after such changes signifies acceptance of the modified policy.',
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          "8. Contact Us",
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13.5,
                                                                              decoration: TextDecoration.underline,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          'If you have any questions or concerns about this Privacy Policy, please contact us at +2710 786 1115 and or on namahadik@mi-group.co.za.',
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            Text(
                                                                          'By using the MI Pay mobile application, corporate clients and their individual customers acknowledge that they have read, understood, and agree to these Terms of Use and Privacy Policy.',
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 13,
                                                                              letterSpacing: 0,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      SizedBox(
                                                                        height:
                                                                            16,
                                                                      ),
                                                                      Container(
                                                                          height:
                                                                              4,
                                                                          color: Colors.grey.withOpacity(
                                                                              0.35),
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width),
                                                                      SizedBox(
                                                                          height:
                                                                              12),
                                                                      Container(
                                                                          alignment: Alignment
                                                                              .center,
                                                                          padding:
                                                                              EdgeInsets.all(10),
                                                                          child: Center(
                                                                              child: Text.rich(TextSpan(text: 'By continuing, you agree to our ', style: TextStyle(fontSize: 14, color: Colors.black), children: <TextSpan>[
                                                                            TextSpan(
                                                                                text: 'Terms of Service',
                                                                                style: TextStyle(
                                                                                  fontSize: 14,
                                                                                  color: Colors.black,
                                                                                  decoration: TextDecoration.none,
                                                                                ),
                                                                                recognizer: TapGestureRecognizer()
                                                                                  ..onTap = () {
                                                                                    // code to open / launch terms of service link here
                                                                                  }),
                                                                            TextSpan(text: ' and ', style: TextStyle(fontSize: 14, color: Colors.black), children: <TextSpan>[
                                                                              TextSpan(
                                                                                  text: 'Privacy Policy',
                                                                                  style: TextStyle(fontSize: 14, color: Colors.black, decoration: TextDecoration.none),
                                                                                  recognizer: TapGestureRecognizer()
                                                                                    ..onTap = () {
                                                                                      // code to open / launch privacy policy link here
                                                                                    })
                                                                            ])
                                                                          ])))),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )));
                                            }),
                                      TextSpan(
                                          text: ' and ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Privacy Policy',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    decoration: TextDecoration
                                                        .underline),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        MaterialApp(
                                                                          debugShowCheckedModeBanner:
                                                                              false,
                                                                          home:
                                                                              Scaffold(
                                                                            backgroundColor:
                                                                                Colors.white,
                                                                            appBar:
                                                                                AppBar(
                                                                              leading: InkWell(
                                                                                onTap: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                child: Icon(
                                                                                  CupertinoIcons.back,
                                                                                  color: Colors.black,
                                                                                ),
                                                                              ),
                                                                              backgroundColor: Colors.white,
                                                                              title: Text(
                                                                                "Terms and conditions",
                                                                                style: TextStyle(color: Colors.black),
                                                                              ),
                                                                            ),
                                                                            body:
                                                                                ListView(
                                                                              shrinkWrap: true,
                                                                              children: [
                                                                                SizedBox(height: 8),
                                                                                SizedBox(
                                                                                  height: 12,
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 8, right: 16),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      "MI FinTech Solutions (Pty) Ltd Mobile Application - MI Pay Terms of Use and Privacy Policy",
                                                                                      style: GoogleFonts.inter(
                                                                                        textStyle: TextStyle(
                                                                                          fontSize: 15,
                                                                                          letterSpacing: 0,
                                                                                          fontWeight: FontWeight.bold,
                                                                                          color: Colors.black,
                                                                                        ),
                                                                                      ),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  child: Stack(
                                                                                    children: [
                                                                                      Container(
                                                                                        height: 2,
                                                                                        width: double.infinity,
                                                                                        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(6)),
                                                                                        margin: EdgeInsets.only(left: 24, right: 24, top: 16),
                                                                                      ),
                                                                                      Center(
                                                                                        child: Container(
                                                                                          height: 2,
                                                                                          width: MediaQuery.of(context).size.width * 0.4,
                                                                                          decoration: BoxDecoration(color: Constants.ctaColorLight, borderRadius: BorderRadius.circular(6)),
                                                                                          margin: EdgeInsets.only(left: 32, right: 32, top: 16),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                //

                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    'Welcome to the MI FinTech Solutions (Pty) Ltd Mobile Application named "MI Pay" ("App"). By accessing or using MI Pay, you agree to comply with and be bound by the following Terms of Use and Privacy Policy. If you do not agree with these terms, please do not use MI Pay.',
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                //
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "Terms of Use",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 15.5,
                                                                                        decoration: TextDecoration.none,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "1. Acceptance of Terms",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13.5,
                                                                                        decoration: TextDecoration.underline,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    'These Terms of Use constitute a legally binding agreement between you and MI FinTech Solutions (Pty) Ltd ("MI FinTech," "we," "us," or "our"). You acknowledge that you have read, understood, and agreed to be bound by these terms.',
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                //
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "2. Use of MI Pay",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13.5,
                                                                                        decoration: TextDecoration.underline,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "2.1 Eligibility: You must be an authorized employee of the company legally contracted to use MI Pay. By using MI Pay, you represent and warrant that you have the authority to act on behalf of your employer.",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "2.2 Account Registration: Your employer may need to create an account for you to access certain rights and features of MI Pay. You agree to provide accurate, current, and complete information during the registration process and to keep your account information updated.",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "2.3 Security: You are responsible for maintaining the confidentiality of your account credentials and for any activity that occurs under your account. Notify us immediately if you suspect any unauthorized use of your account.",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "2.4 Prohibited Activities: You agree not to use MI Pay for any illegal, unauthorized, or prohibited purpose. This includes, but is not limited to, unauthorized access, data mining, or any action that could disrupt the functionality of MI Pay.",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                //
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "3. Privacy",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13.5,
                                                                                        decoration: TextDecoration.underline,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "We are committed to protecting your privacy and that of the client who is served using MI Pay. Our Privacy Policy outlines how we collect, use, and disclose information. By using MI Pay, you consent to the practices described in our Privacy Policy.",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                //
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "4. Intellectual Property",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13.5,
                                                                                        decoration: TextDecoration.underline,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    'All content and materials available on MI Pay, including but not limited to text, graphics, logos, images, and software, are the property of MI FinTech Solutions (Pty) Ltd or its licensors. You are granted a limited, non-exclusive, non-transferable, and revocable license to access and use MI Pay for its intended purpose.',
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                //

                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "By posting User Content on the Platform, you grant MI PAY a non-exclusive, worldwide, perpetual, irrevocable, royalty-free, sublicensable, transferable right and license to use, copy, modify, create derivative works based on, distribute, publicly display, publicly perform, and otherwise exploit in any manner such User Content in all formats and distribution channels now known or hereafter devised (including in connection with the Platform and MI PAY's business and on third-party sites and services), without further notice to or consent from you, and without the requirement of payment to you or any other person or entity.You represent and warrant that: (i) you either are the sole and exclusive owner of all User Content or you have all rights, licenses, consents, and releases that are necessary to grant to MI PAY the rights in such User Content, as contemplated under this Agreement; and (ii) neither the User Content, nor your submission, uploading, publishing, or otherwise making available of such User Content, nor MI PAY's use of the User Content as permitted herein will infringe, misappropriate or violate a third party's patent, copyright, trademark, trade secret, moral rights, or other proprietary or intellectual property rights, or rights of publicity or privacy, or result in the violation of any applicable law or regulation.",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "Intellectual Property. The Platform and its entire contents, features, and functionality (including but not limited to all information, software, text, displays, images, video, and audio, and the design, selection, and arrangement thereof), are owned by MI PAY, its licensors, or other providers of such material and are protected by South African and international copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights laws.",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 15,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "Third-Party Content and Services",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13.5,
                                                                                        decoration: TextDecoration.underline,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "The Platform may contain links to third-party websites or resources. MI PAY provides these links only as a convenience and is not responsible for the content, products, or services on or available from those websites or resources or links displayed",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "5. Disclaimer of Warranties",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13.5,
                                                                                        decoration: TextDecoration.underline,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    'Individual customers have the right to:',
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                //

                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    '5.1 Access, Update, or Delete Information: Individual customers may request access to their personal information, update inaccuracies, or request deletion by contacting us at +2710 786 1115 and or on namahadik@mi-group.co.za.',
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    '5.2 Opt-Out: Individual customers can opt-out of receiving promotional communications where applicable by following the unsubscribe instructions provided in communications from MI Pay.',
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "6. Children's Privacy",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13.5,
                                                                                        decoration: TextDecoration.underline,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    'MI Pay is not intended for use by individuals under the age of 16. We do not knowingly collect personal information from children under 16. If you believe a child has provided us with personal information, please contact us to have the information removed.',
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "7. Changes to Privacy Policy",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13.5,
                                                                                        decoration: TextDecoration.underline,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    'We reserve the right to update or modify this Privacy Policy at any time. Any changes will be effective upon posting. Continued use of MI Pay after such changes signifies acceptance of the modified policy.',
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    "8. Contact Us",
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13.5,
                                                                                        decoration: TextDecoration.underline,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    'If you have any questions or concerns about this Privacy Policy, please contact us at +2710 786 1115 and or on namahadik@mi-group.co.za.',
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                                                                  child: Text(
                                                                                    'By using the MI Pay mobile application, corporate clients and their individual customers acknowledge that they have read, understood, and agree to these Terms of Use and Privacy Policy.',
                                                                                    style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                SizedBox(
                                                                                  height: 16,
                                                                                ),
                                                                                Container(height: 4, color: Colors.grey.withOpacity(0.35), width: MediaQuery.of(context).size.width),
                                                                                SizedBox(height: 12),
                                                                                Container(
                                                                                    alignment: Alignment.center,
                                                                                    padding: EdgeInsets.all(10),
                                                                                    child: Center(
                                                                                        child: Text.rich(TextSpan(text: 'By continuing, you agree to our ', style: TextStyle(fontSize: 14, color: Colors.black), children: <TextSpan>[
                                                                                      TextSpan(
                                                                                          text: 'Terms of Service',
                                                                                          style: TextStyle(
                                                                                            fontSize: 14,
                                                                                            color: Colors.black,
                                                                                            decoration: TextDecoration.none,
                                                                                          ),
                                                                                          recognizer: TapGestureRecognizer()
                                                                                            ..onTap = () {
                                                                                              // code to open / launch terms of service link here
                                                                                            }),
                                                                                      TextSpan(text: ' and ', style: TextStyle(fontSize: 14, color: Colors.black), children: <TextSpan>[
                                                                                        TextSpan(
                                                                                            text: 'Privacy Policy',
                                                                                            style: TextStyle(fontSize: 14, color: Colors.black, decoration: TextDecoration.none),
                                                                                            recognizer: TapGestureRecognizer()
                                                                                              ..onTap = () {
                                                                                                // code to open / launch privacy policy link here
                                                                                              })
                                                                                      ])
                                                                                    ])))),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )));
                                                      })
                                          ])
                                    ])))),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: InkWell(
                          onTap: () async {
                            // _scan();

                            // openIntent(context);
                            //generateAndPrintPDF();
                            if (employeeidController.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please enter your employee id",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else if (employeeidController.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please enter the policy number",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else if (_acceptTerms == false) {
                              Fluttertoast.showToast(
                                  msg: "Please accept the terms of use",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              final DateTime now = DateTime.now();
                              /*await Constants.analytics_instance?.logEvent(
                                name: 'search_performed',
                                parameters: {
                                  'employee_uid':
                                      employeeidController.text.toUpperCase(),
                                  'policy_number':
                                      policynumberController.text.toUpperCase(),
                                  'serial_number': Constants.device_id,
                                  'timestamp': now.toIso8601String(),
                                },
                              );*/
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => policyresults(
                                            employeeuid: employeeidController
                                                .text
                                                .toUpperCase(),
                                            policynumber: policynumberController
                                                .text
                                                .toUpperCase(),
                                          )));
                            }
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Constants.ctaColorLight,
                                  borderRadius: BorderRadius.circular(32),
                                  border: Border.all(
                                    width: 1.2,
                                    color: Constants.ctaColorLight,
                                  )),
                              padding: EdgeInsets.only(left: 0, right: 16),
                              width: MediaQuery.of(context).size.width,
                              height: 45,
                              child: Center(
                                  child: Text(
                                "Proceed to Search",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ))),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PDFScreen(
                                      path:
                                          "lib/assets/MI_Pay_Training_0.02_Aug_2023.pdf")));
                            },
                            child: Text(
                              "User Guide",
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.bold,
                                  decorationColor: Constants.ctaColorLight,
                                  color: Constants.ctaColorLight,
                                ),
                              ),
                            ),
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

  Future<void> sign_in(
      BuildContext context, String email, String password) async {
    // Set the controllers so the service can clear them
    LoginService.setLoginControllers(email_controller, password_controller);

    // Use the login service
    await LoginService.signInUser(context, email, password);
  }

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
          Fluttertoast.showToast(
              msg: "Network error. Please check your connection and try again.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        // Last login date is not available, show network error toast.
        Fluttertoast.showToast(
            msg: "Network error. Please check your connection and try again.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }).catchError((error) {
      showNetworkErrorToast(context);
    });
  }

  void showNetworkErrorToast(BuildContext context) {
    Fluttertoast.showToast(
        msg:
            "Network error. Please check your internet connection and try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

// Function to handle other errors
  void handleOtherErrors(BuildContext context, dynamic error) {
    // Your existing error handling logic
    print(error.toString());
    Navigator.of(context).pop();
    Fluttertoast.showToast(
        msg: "Network Error! (E1)",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
    secureScreen();
    if (!kDebugMode) {
      // _checkDeviceSecurity();
    }
    Sharedprefs.getUserLoggedInSharedPreference().then((value) {
      if (value != null) Constants.isLoggedIn = value;
      // print("valuerdg0 $value");
    });
    Future.delayed(Duration(seconds: 2)).then((value) async {
      if (Constants.containsAppUpdate == true) {
        _showUpdateDialog(context);
      }
    });

    /* _controller = VideoPlayerController.asset('assets/vid_2.mp4')
      ..initialize().then((_) {
        _controller.play();
        setState(() {});
      });*/
    Future.delayed(Duration(seconds: 2)).then((value) async {
      setState(() {});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Constants.accepted_terms = prefs.getBool(
            'accepted_terms',
          ) ??
          false;
      // print("ggfghgh ${Constants.accepted_terms}");
      if (Constants.accepted_terms == false) {
        showPermisionsDialog();
      }
    });
  }

/*  Future<void> _checkDeviceSecurity() async {
    bool jailbroken = await FlutterJailbreakDetection.jailbroken;
    bool developerMode = await FlutterJailbreakDetection.developerMode;

    setState(() {
      _isJailbroken = jailbroken;
      _isDeveloperMode = developerMode;
    });

    if (jailbroken || developerMode) {
      // _showBlockingDialog();
    }
  }*/

  void _showBlockingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Security Warning'),
          content: Text(
              'This device is compromised and cannot be used with this app for security reasons.'),
          actions: [
            TextButton(
              onPressed: () {
                // Optionally exit the app or disable further actions
                Navigator.of(context).pop();
                // You can also call SystemNavigator.pop() to close the app
              },
              child: Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  requestPermissions() async {
    // Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Navigator.of(context).pop();
        Fluttertoast.showToast(
          msg: "Location permission is required to sign in.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }
    }
  }

  Future<void> acceptTerms(
      int empId, int cecClientId, int termsId, bool accepted) async {
    String acceptTermsUrl = "${Constants.insightsbaseUrl}files/accept_terms/";
    Map<String, dynamic> payload = {
      'emp_id': empId,
      'cec_client_id': cecClientId,
      'terms_id': termsId,
      'accepted': accepted,
    };

    try {
      http.Response response = await http.post(Uri.parse(acceptTermsUrl),
          body: json.encode(payload),
          headers: {'Content-Type': 'application/json'});
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

  Future<void> checkTermsAccepted(int empId, int cecClientId) async {
    String url = "${Constants.insightsbaseUrl}files/check_terms_acceptance/";
    try {
      http.Response response = await http.get(Uri.parse(url));
      if (kDebugMode) {
        // print('Response status: ${response.statusCode}');
        //print('Response body: ${response.body}');
      }

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
    } catch (e) {
      print("Exception caught: $e");
    }
  }

  Future<void> showPermisionsDialog() async {
    final prefs = await SharedPreferences.getInstance();
    int obtainedCount = prefs.getInt('usageCount') ?? 0;
    //print("obtainedCount ${obtainedCount}");
    if (obtainedCount < 5) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TermsAndConditions(
            onProceed: () {},
          ),
        ),
      );
    }
  }
}

class TermsAndConditions extends StatefulWidget {
  final VoidCallback onProceed;

  TermsAndConditions({required this.onProceed});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  bool isExpanded = false;
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(height: 65),
            Padding(
              padding: EdgeInsets.only(left: 16, top: 8, right: 16),
              child: Center(
                child: Text(
                  "MI FinTech Solutions (Pty) Ltd Mobile Application",
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, top: 8, right: 16),
              child: Center(
                child: Text(
                  "MI Insights Terms of Use and Privacy Policy",
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontSize: 22,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              child: Stack(
                children: [
                  Container(
                    height: 2,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(6)),
                    margin: EdgeInsets.only(left: 24, right: 24, top: 16),
                  ),
                  Center(
                    child: Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                          color: Constants.ctaColorLight,
                          borderRadius: BorderRadius.circular(6)),
                      margin: EdgeInsets.only(left: 32, right: 32, top: 16),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              'I agree to the Terms and Conditions',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: InkWell(
                      onTap: () async {
                        // if (_isChecked == true) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool('accepted_terms', true);
                        Navigator.of(context).pop();
                        widget.onProceed();
                        /*   } else {
                          MotionToast.error(
                            onClose: () {},
                            description:
                                Text("Please accept terms to continue"),
                          ).show(context);
                        }*/
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Constants.ctaColorLight,
                            borderRadius: BorderRadius.circular(360),
                            border: Border.all(color: Constants.ctaColorLight)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, top: 12, bottom: 12),
                          child: Center(
                            child: Text(
                              "I agree",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                letterSpacing: 1.05,
                                fontWeight: FontWeight.w600,
                                fontFamily: "TradeGothic",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            isExpanded == false
                ? Expanded(child: Container())
                : Expanded(
                    child: Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                'Welcome to the MI FinTech Solutions (Pty) Ltd Mobile Application named "MI Insights" ("App"). By accessing or using MI Insights, you agree to comply with and be bound by the following Terms of Use and Privacy Policy. If you do not agree with these terms, please do not use MI Insights.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: isExpanded == false ? 5 : 16,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "Terms of Use",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 15.5,
                                    decoration: TextDecoration.none,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "1.1 These Terms constitute a binding agreement between you and MI FinTech Solutions, governing your use of the Application and its associated Software.",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '1.2 MI FinTech Solutions grants you a license to use the Application, subject to these Terms and any Appstore Rules from where you downloaded it.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '1.3 The Application is not sold to you; MI FinTech Solutions retains ownership at all times.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '1.3 The Application is not sold to you; MI FinTech Solutions retains ownership at all times.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '1.4 Compatibility requires a smartphone or tablet with internet access and compatible operating systems like iOS or Android.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "1.5 If the Device isn't yours, you confirm permission from the owner for Application installation.",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            //
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "2 DEFINITIONS AND INTERPRETATION",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    decoration: TextDecoration.underline,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '2.1 "Application" refers to MI Insights, the MI FinTech Solutions Mobile App, including Applets, for communication and media exchange with compatible devices using the Software.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '2.2 "Applet/s" are unique modules and or services within the MI FinTech Solutions Mobile App, accessible through MI Insights, such as Underwriting Module, Sales Module, Claims Module and Retentions Module.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '2.3 "MI FinTech Solutions" or "we"; refers to MI FinTech Solutions Proprietary Limited, a licensed Financial Services Provider.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '2.4 "Software" is the software and media enabling Application use.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '2.5 "User" or "you"; refers to anyone installing the Software or using the Application.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '2.6 Singular references include the plural, and vice versa.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '2.7 Links to other documents are integral to these Terms under the ECT Act.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '2.8 Unspecified terms follow ECT Act definitions.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '2.9 The ECT Act can be viewed at https://www.gov.za/sites/default/files/gcis_document/201409/a25-02.pdf; ensure you have the latest version.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '2.10 Clause headings are for convenience and not for interpreting the terms and conditions.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            //
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "3 ACCEPTANCE OF TERMS",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    decoration: TextDecoration.underline,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "3.1 To register for the Application, you will be requested to accept the terms and conditions and your response in the affirmative confirms the user on MI FinTech Solutions' database.",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            //
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "4 INFORMATION PROVIDED ON THE APPLICATION",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    decoration: TextDecoration.underline,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '4.1 Unlike MI Insights, the core application, users have free access to the Mobile Application for reporting purposes. The application offers information on the users’ business and aims the assist executives and management to have a close management of their business by providing them with insights relating to their key performance indicators such as movement or growth in sales, collection of premium, claims submitted, etc.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            //

                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '4.2 Some information serves as a summary, and Users are advised to visit the core applications, MI Insights, for comprehensive details.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "Intellectual Property. The Platform and its entire contents, features, and functionality (including but not limited to all information, software, text, displays, images, video, and audio, and the design, selection, and arrangement thereof), are owned by MI Insights, its licensors, or other providers of such material and are protected by South African and international copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights laws.",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 15,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "5 GRANT OF LICENSE AND USE OF THE APPLICATION",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    decoration: TextDecoration.underline,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "5.1 MI FinTech Solutions grants users a non-transferable, non-exclusive license for personal use, subject to these Terms and Appstore Rules.",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "5.2 Users may not use the Application for commercial purposes without written consent.",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "6 INTELLECTUAL PROPERTY RIGHTS",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    decoration: TextDecoration.underline,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '6.1 All intellectual property rights for the Application and associated content belong to MI FinTech Solutions.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            //

                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '6.2 Users have no rights to access the Application in source code form.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "7 AMENDMENTS AND CHANGES TO PROFILE",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    decoration: TextDecoration.underline,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '7.1 MI FinTech Solutions may amend Terms, and users must accept them for continued use.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '7.2 MI FinTech Solutions reserves the right to change or discontinue aspects of the Application.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "8 PRIVACY POLICY AND DATA PROTECTION",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    decoration: TextDecoration.underline,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '8.1 MI FinTech Solutions commits to protecting user data in line with applicable data protection legislation.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '8.2 Users agree to the collection, processing, and storage of personal information for Application access and other specified purposes.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "9 DATA CONSUMPTION",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    decoration: TextDecoration.underline,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '9.1 The Application uses data for communication, and users are responsible for associated costs.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '9.2 Users must be aware of potential higher data pricing when roaming.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "10 DISCLAIMERS AND LIMITATION OF LIABILITY",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    decoration: TextDecoration.underline,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '10.1 Information provided by the Application comes without warranties, and users use it at their own risk.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '10.2 MI FinTech Solutions is not liable for any damages arising from various factors, including Application unavailability and third-party actions.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '10.3 MI FinTech Solutions strives for content accuracy but does not guarantee it. Users acknowledge the responsibility for their decisions based on the information.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "11 ELIMINATION OF ERRORS",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    decoration: TextDecoration.underline,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '11.1 Users are encouraged to report any harmful, untrue, illegal, infringing, defamatory or inaccurate content to MI FinTech Solutions for correction or removal.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "12 DISPUTE RESOLUTION",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    decoration: TextDecoration.underline,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '12.1 Disputes are to be resolved in good faith. Unresolved issues may be referred to arbitration with Arbitration Foundation of Southern Africa (&quot;AFSA&quot;).',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '12.2 Interim relief may be sought from a South African court pending arbitration.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "13 OTHER IMPORTANT TERMS",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    decoration: TextDecoration.underline,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '13.1 These Terms prevail over any User communications or postings and constitute the entire agreement between MI FinTech Solutions and the User.',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "13.2 MI FinTech Solutions' failure to enforce User obligations or rights does not waive those rights, except in writing. Delayed enforcement doesn't imply a waiver.",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "13.3 MI FinTech Solutions can transfer rights and obligations to another organization withoutaffecting User rights or MI FinTech Solutions' obligations.",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "13.4 If any Terms detailed herein are found unenforceable or invalid for any reason, such term(s) or condition(s) shall be severable from the remaining Terms. The remaining Terms shall remain enforceable and applicable.",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "13.5 No provision limits MI FinTech Solutions' liability beyond what the law allows. User's assumed risk or liability is limited as allowed by law. The Consumer Protection Act, 2008 (Consumer Protection Act&quot;) rights are not limited or excluded.",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "13.5 No provision limits MI FinTech Solutions' liability beyond what the law allows. User's assumed risk or liability is limited as allowed by law. The Consumer Protection Act, 2008 (Consumer Protection Act&quot;) rights are not limited or excluded.",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "13.5 No provision limits MI FinTech Solutions' liability beyond what the law allows. User's assumed risk or liability is limited as allowed by law. The Consumer Protection Act, 2008 (Consumer Protection Act&quot;) rights are not limited or excluded.",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "13.6 If subject to the Consumer Protection Act, all Terms are qualified to comply with the Act.",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                " 13.7 The Application, governed by South African law, is subject to South African courts, regardless of the User's country of residence.",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                '14 VARIATION OF CERTAIN DEEMING PROVISIONS IN THE ECT ACT',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "14.1 Users agree that these Terms create a binding contract with MI FinTech Solutions, even if wholly or partially in a data message. Users specifically agree:",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "14.1.1 These Terms are treated as concluded at MI FinTech Solutions' physical address upon the User's first access, registration, or use of the Application.",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "14.1.2 No electronic signature is required for User or MI FinTech Solutions to agree to these Terms.",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "14.1.3 User's use of the Application serves as sufficient evidence of agreement to these Terms.",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "14.1.4 Any data message is deemed sent from MI FinTech Solutions' physical address if the User's usual place of business or residence is not in South Africa.",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "14.1.5 Unless otherwise specified, communications sent by an automated information system on MI FinTech Solutions'' behalf are deemed data messages authorized by MI FinTech Solutions.",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                "14.1.6 User-sent data messages are acknowledged upon MI FinTech Solutions' acknowledgment or by a person authorized to act on its behalf.",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.5,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 16,
                            ),
                            Container(
                                height: 4,
                                color: Colors.grey.withOpacity(0.35),
                                width: MediaQuery.of(context).size.width),
                            SizedBox(height: 12),
                            Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10),
                                child: Center(
                                    child: Text.rich(TextSpan(
                                        text:
                                            'MI FinTech Solutions is a licensed Financial Services Provider (“FSP”), view our',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                        children: <TextSpan>[
                                      TextSpan(
                                          text: 'Disclaimer,',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            decoration: TextDecoration.none,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              // code to open / launch terms of service link here
                                            }),
                                      TextSpan(
                                          text: 'Privacy Policy,',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            decoration: TextDecoration.none,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              // code to open / launch terms of service link here
                                            }),
                                      TextSpan(
                                          text: ' and ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                    'Promotion of Access to Information.',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    decoration:
                                                        TextDecoration.none),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        // code to open / launch privacy policy link here
                                                      })
                                          ])
                                    ])))),
                          ],
                        ),
                      ),
                    ),
                  ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: TextButton(
                onPressed: () {
                  isExpanded = !isExpanded;
                  setState(() {});
                },
                child: Text(
                  isExpanded == true ? "Read Less" : 'Read More',
                  style: TextStyle(color: Constants.ctaColorLight),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            /*  if (isExpanded == false)
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8, bottom: 12),
                      child: InkWell(
                        onTap: () {
                          isExpanded = true;
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Constants.ctaColorLight.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(360),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8, top: 12, bottom: 12),
                            child: Center(
                              child: Text(
                                "Read more",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  letterSpacing: 1.05,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "TradeGothic",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),*/

            SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(36.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              strokeWidth: 2,
              valueColor:
                  new AlwaysStoppedAnimation<Color>(Constants.ctaColorLight),
            ),
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

getBusinessDetails() async {
  String baseUrl = "${Constants.baseUrl}";
  String urlPath = "/parlour/company_info/";
  String apiUrl = baseUrl + urlPath;
  DateTime now = DateTime.now();

  // Construct the request body
  Map<String, dynamic> requestBody = {
    "token": "kjhjguytuyghjgjhg765764tyfu",
    "cec_client_id": Constants.cec_client_id,
  };

  try {
    var response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode(requestBody),
      headers: {
        "Content-Type": "application/json",
      },
    );
    // Simulating transaction processing with a delay

    // Navigator.of(context).pop();
    print(
        "dfdfggf ${Constants.baseUrl} ${Constants.cec_client_id} ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("dataxhjhjhk $data");
      //print("datax ${c.runtimeType}");

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
      print("data $data");
      //setState(() {});

      print("Request failed with status: ${response.statusCode}");
    }

    // Perform your transaction logic here

    // Close the dialog
  } catch (error) {
    print("Error: $error");
  }
}

void _showUpdateDialog(context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          buttonPadding: EdgeInsets.only(top: 0.0, left: 0, right: 0),
          insetPadding: EdgeInsets.only(left: 16.0, right: 16),
          titlePadding: EdgeInsets.only(right: 0),
          surfaceTintColor: Colors.white,
          contentPadding: const EdgeInsets.only(left: 0.0),
          title: Padding(
            padding: const EdgeInsets.only(top: 14.0, left: 0, right: 0),
            child: Text(
              'UPDATE AVAILABLE!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0xff44556a)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      "A new version of the application is available for download. \nEnhance your experience with improved features and perfomance.",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Spacer(),
                  if (Constants.mandatoryUpdate != true)
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(
                            0.35,
                          ),
                          borderRadius: BorderRadius.circular(360)),
                      width: 150,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                            width: 125,
                            height: 38,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.35),
                                borderRadius: BorderRadius.circular(360)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 14.0, right: 14, top: 5, bottom: 5),
                              child: Center(
                                child: Text(
                                  'Not now',
                                  style: TextStyle(
                                      color: Constants.ctaColorLight,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            )),
                      ),
                    ),
                  if (Constants.mandatoryUpdate != true) SizedBox(width: 12),
                  Container(
                    child: InkWell(
                      onTap: () {
                        final Uri _url =
                            Uri.parse(Constants.appUpdatedownloadUrl);
                        _launchUrl(_url);
                      },
                      child: Container(
                          width: 150,
                          height: 38,
                          decoration: BoxDecoration(
                              color: Constants.ctaColorLight,
                              borderRadius: BorderRadius.circular(360)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 14.0, right: 14, top: 5, bottom: 5),
                            child: Center(
                              child: const Text(
                                'Click to download',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )),
                    ),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          actions: null,
        );
      });
    },
  );
}

Future<void> _launchUrl(Uri _url) async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
